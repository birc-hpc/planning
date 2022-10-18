# Scripts and variables

A toolbox of commands, and familiarity with how to string them together in pipelines, is the bread and butter of day-to-day interaction with the UNIX system, but it has its limitations.

Sometimes, you have a series of commands you want to execute frequently. Imagine, for example, that you regularly have to collect current results and send them to collaborators.

Let's further imagine that you have a file, `important.txt`, containing the files you need to send each time. It could look something like this:

```txt
analysis1/results.txt
analysis2/experiments-1.txt
analysis2/experiments-2.txt
```

When you need to send the files, you want to zip them up so you can email them, you want to tag them with the date where you sent them (because your collaborators are forgetful and will mix them up otherwise), and you want to make a backup so no one can claim that you sent them the wrong files, or out of date files.

## Manually backing up important files

First, let's figure out how to get the current date. The command `date` sounds like something we can use, and indeed we can.

```bash
~> date
Tue Oct 18 12:14:19 CEST 2022
```

It is just not in a handy format if we want to add a date to a file name. But the command takes various arguments for formatting the date, and if we use `+%F` we get `YYYY-MM-DD` which is good for sorting files (it will sort lexicographically, matching how we would sort dates).

```bash
~> date
2022-10-18
```

We can use this to make a directory to collect the data in:

```bash
~> mkdir results-$( date +%F )
```

The syntax `$( ... )` tells bash to run a command, here `date +%F`, and paste the output of this command to replace the `$( ... )` bit. So, since `date +%F` outputs `2022-10-18`, the text `results-$( date +%F )` becomes `results-2022-10-18`, and this will be our results directory.

We want to copy the important files there, and for that we can use

```bash
~> cp $( cat important.txt ) results-$( date +%F )
```

We are using the `$( ... )` syntax again, first to get the file names from `important.txt` and secondly to get our target directory.

If you find this `$( ... )` stuff confusing, try using `echo` to see what it expands to:

```bash
~> echo cp $( cat important.txt ) results-$( date +%F )
cp analysis1/results.txt analysis2/experiments-1.txt analysis2/experiments-2.txt results-2022-10-18
```

Everything is as it should be.

Ok, so now we have the files in `results-2022-10-18` so we can zip them up. The UNIX way is to combine two commands, `tar` and `gzip`, so you get a `.tar.gz` file, but you can run both using just the `tar` tool:

```bash
~> tar -czf results-$( date +%F ).tar.gz results-$( date +%F )
```

The options are *c*reate, *z*ip, *f*ile (where the latter means you are giving the result a file name). The file name we give is `results-$( date +%F )` which will expand to `results-2022-10-18`.

If you want to unpack the files later (and you probably want to if it is worth packing them), then the command is `tar` again, but with options `-xf` for e*x*tract and *f*ile

```bash
~> tar -xf results-2022-10-18.tar.gz
```

Ok, now we have our files wrapped up and zipped (in what is affectionally called a *tarball*), and we can copy it to some backup place.

```bash
~> cp results-$( date +%F ).tar.gz backup
```

Then we can clean up after ourselves.

```bash
~> rm -r results-$( date +%F )
```

This just removes the directory we made, but it leaves the `results-2022-10-18.tar.gz` file alone so you can send it to the collaborators who are anxiously awaiting your latest results.

You can even mail it from the command line (but I won't show you how, as you might get in trouble with automated mailing, and in any case, you won't be able to do it from the cluster).

Summarising all of this, the commands looked like this:

```bash
~> mkdir results-$( date +%F )
~> cp $( cat important.txt ) results-$( date +%F )
~> tar -czf results-$( date +%F ).tar.gz results-$( date +%F )
~> rm -r results-$( date +%F )
~> cp results-$( date +%F ).tar.gz backup
```

It is nothing complicated, but it is not something you want to remember either, and if it is something you need to do every week, it is rather cumbersome and error-prone. It would probably take just as long the second, third, or maybe even tenth time as it did the first time.

But you don't have to. It is quite easy to turn this sequence of commands into a single one, and we can fix some potential error sources simultaneously.

## Writing your first shell script

Take the commands from above, and put them in a file. I will call it `backup.sh`. I call it `backup` because that is what the commands are doing, and `.sh` reminds me that these are shell commands. UNIX doesn't care what we name our files, but the convention is that a file that ends in `.sh` will contain shell commands of some sort, and your editor will use that to determine how it should display the file's content.

So, my `backup.sh` looks like this:

```bash
mkdir results-$( date +%F )
cp $( cat important.txt ) results-$( date +%F )
tar -czf results-$( date +%F ).tar.gz results-$( date +%F )
rm -r results-$( date +%F )/*
cp results-$( date +%F ).tar.gz backup
```

Nothing fancy here; I just put the commands in a file. From here, I could simply copy and paste every time I needed to run them, but there is an even easier way: I can *source* the file.

```bash
~> source backup.sh
analysis1/results.txt -> results-2022-10-18/results.txt
analysis2/experiments-1.txt -> results-2022-10-18/experiments-1.txt
analysis2/experiments-2.txt -> results-2022-10-18/experiments-2.txt
results-2022-10-18.tar.gz -> backup/results-2022-10-18.tar.gz
```

The `source` command will run all the shell commands in your file, just as if you had pasted them in. You might also sometimes see

```bash
~> . backup.sh
analysis1/results.txt -> results-2022-10-18/results.txt
analysis2/experiments-1.txt -> results-2022-10-18/experiments-1.txt
analysis2/experiments-2.txt -> results-2022-10-18/experiments-2.txt
results-2022-10-18.tar.gz -> backup/results-2022-10-18.tar.gz
```

When you use dot `.` as a command, it means the same as `source`. Generally, people who use UNIX are lazy, so we pick short names when we can get away with it. The thought is, I think, that it is easier to think for an hour about what the command is called than it is to type a slightly longer but meaningful name. I don't know. Don't blame me, I didn't write UNIX.

Anyway, that is one easy way to run a sequence of commands: put them in a file and source them.

Sourcing commands isn't always ideal, though. When you do it, all the commands are run in your current shell, just as if you had typed them in yourself, but the commands might jump around the file system using `cd`, leaving you somewhere unexpected afterwards, or they might change your prompt or the colour of your shell's text, and generally all kinds of things you don't want to happen in the shell where you are currently working.

Instead, you can run the commands in a completely fresh shell. Just use the `bash` command to start a new `bash` and run the commands there.

```bash
~> bash backup.sh
```

With this approach, your commands are run in a fresh shell, so they won't be affected by the shenanigans you have been up to in the shell so far. Likewise, what happens in the new shell stays in the new shell.

There are pros and cons to both approaches. You *do* want to source if you need to affect your current shell, so sometimes that is what you want. Most of the time, though, you just want to execute your commands, and you don’t want your setup to have changed when you are done.

There is a third variation—that basically does the same as calling `bash` with your file of commands—is to turn the file into an executable itself. This has some extra benefits compared to just calling `bash`, predominantly that it will behave just as any other executable, and we won’t have to distinguish between a list of commands we have written ourselves and any other command we might run.

We need to do two things to achieve this:

- We need to inform UNIX about how it should execute our file, and
- we need to give UNIX permission to run the file.

First things first: how does UNIX figure out how to run a command? There are essentially two ways to execute a command. The command could be a file containing machine code, and if that is the case, UNIX will run it directly on the hardware. Alternatively, the file could contain commands for another program, like the shell, that tells that command what to do. We are in the second category. The shell program, `bash`, is machine code, and it can run directly on the computer, but what we have here is a list of commands that we need `bash` to interpret and execute.

When we are in the second category, we need to tell UNIX which program should interpret our instructions, and we do this by writing a special command at the first line of the instructions file. We will write

```bash
#!/bin/bash
```

The `#!` as the first two characters informs UNIX that we are giving it the path to a command we want to deal with the rest of the file, and the rest of the line is the command UNIX should run. When it sees this, it will run the command we give it, providing the file we are running as its standard input.

So, update `backup.sh` to this:

```bash
#!/bin/bash

mkdir results-$( date +%F )
cp $( cat important.txt ) results-$( date +%F )
tar -czf results-$( date +%F ).tar.gz results-$( date +%F )
rm -r results-$( date +%F )
cp results-$( date +%F ).tar.gz backup
```

Now, if we manage to execute the file (and we will shortly), UNIX will run the command `/bin/bash` and give it

```bash
#!/bin/bash

mkdir results-$( date +%F )
cp $( cat important.txt ) results-$( date +%F )
tar -czf results-$( date +%F ).tar.gz results-$( date +%F )
rm -r results-$( date +%F )
cp results-$( date +%F ).tar.gz backup
```

as input.

Notice that the tool also gets the `#!/bin/bash` line (also called the “hash-bang” line since `#` is pronounced “hash” in UNIX and `!` is pronounced “bang”). The shell won’t do anything about that line, though, since `bash` considers anything that follows a `#` a comment that it should ignore. Lucky us. Well, it isn’t *pure* luck, and you will learn that most UNIX tools consider `#` the start of a comment, and they do that because they want to ignore hash-bang lines. But I digress…

Getting back to our script, which is what such files of commands are called in the UNIX world. If you try to run it as a normal command, you will be disappointed.

```bash
~> backup.sh
bash: backup.sh: command not found
```

Why can’t bash find it? It is right *there*! `ls` will back me up on that!

The thing is, when the shell is looking for commands, it doesn’t just pick the first file with the right name that it can find. That could end up getting messy. Instead, it looks for commands in a selected number of places, and if you want to know where, check the variable `$PATH`.

```bash
~> echo $PATH
~/go/bin:/Library/Frameworks/Python.framework/Versions/3.10/bin:/usr/local/bin:/usr/bin:/bin:/usr/sbin:/sbin:/Library/Apple/usr/bin:/usr/local/go/bin:/Library/TeX/texbin:/Users/mailund/go/bin/
```

(these are the results I get on my iMac, and yours will differ depending on how your shell is set up).

It is a list of `:`-separated directories, and unless the executable is in one of those, UNIX doesn’t find it. If you want to run your script as a command, you either need it to be in one of the `PATH` directories or you have to provide a path to it.

The first option means you either copy the file to the desired directory, or you have to add a directory to `PATH`. The current directory is `.`, so you could add `.` to `PATH`.

```bash
~> PATH=.:$PATH
```

This updates `PATH` to `.` followed by the old list (in `$PATH`). If you do this, then UNIX will always prefer to run files in your current directory over files in the other `PATH` directories. I suggest you do not do this. You don’t want to run random files you just happen to have where you currently are. But there is nothing wrong with making a new directory, say `~/bin`, where you put scripts you use often, and then adding `~/bin` to `PATH`. If you do, though, you want to update `PATH` every time you log in. You can do that by editing **FIXME: where is `.bashrc` or its equivalence on the cluster?

For a script that is supposed to be run in this particular project’s directory and nowhere else—we are backing up specific files that are only found here, after all—we don’t want to make it a command we can run from anywhere. Instead of getting the script into `PATH` we can use a path to it when we want to run it.

```bash
~> ./backup.sh
bash: ./backup.sh: Permission denied
```

When we specify which path the file is in, `./` is the current directory, UNIX finds it. It just refuses to execute it.

There is a simple file permission system on UNIX that specifies who is allowed to read, write, and execute files. You can see how those permissions are set with `ls -l`:

```bash
~> ls -l
total 88
...
-rw-r--r--  1 mailund  staff    216 Oct 18 13:20 backup.sh
...
```

It is the string `-rw-r--r--` you are interested in now. The first character will be `d` if you are looking at a directory, and `-` otherwise. It is not interesting right now. The remaining nine characters show the status of three groups of permissions.

The world, according to UNIX, is separated into three layers of people. The owner of a file, also known as the user (here it is `mailund`), the group the file (and usually owner) belongs to, here `staff`, and then everybody else. For each layer, there are three “permission bits”: read, write, and execute. The string `-rw-r--r--` says that the owner (the first three bits after the directory indicator) can read, (`r`), can write (`w`), but cannot execute, (`-`). Members of the group can read but not write or execute (`r--`), and the same for everybody else (`r--`).

The command `chmod` (change mode) can change the bits (if you have permission to change them, which you have if you own the file, i.e., it considers you the user).

To set the execute bit for myself, I can write:

```bash
~> chmod u+x backup.sh
~> ls -l
...
-rwxr--r--  1 mailund  staff    216 Oct 18 13:20 backup.sh
...
```

Notice that the user bits went from `rw-` to `rwx`. The group and “other” permission didn’t change and is still `r--`.

The `u` in the argument to `chmod` specifies that we are changing permission for the user and the `+x` specifies that we are turning execution permission on. If you try the command with `u-x` instead, you will turn the execution bit off.

To change permission for the group, you use `g` instead of `u`, and if you want to change it for others, you use `o`. If you want to change a bit for all three layers, you can use `a`.

```bash
~> chmod a+x backup.sh
~> ls -l
...
-rwxr-xr-x  1 mailund  staff    216 Oct 18 13:20 backup.sh
...
```

Generally, you shouldn’t increase permissions for everyone worldwide, but the `a` option is safe if you want to reduce permissions.

This `backup.sh` script is probably not one you intend for anyone but yourself to use, so just use `chmod u+x backup.sh` and leave it at that.

If you have done that, UNIX has permission to execute the file, and since we have a hash-bang line (`#!/bin/bash`), it knows how to.

```bash
~> ./backup.sh
```



----

**FIXME:**

----

- make `backup` dir if it isn't there
- use a variable for the date

----

- More on comments

- Adding arguments to the script (variables `$@ $1 $2` and such)
- General variables (just an example where we use a better name)
- Variables and environment variables--what's the difference (inheriting variables from the parent process)

----

**FIXME:** just copied some stuff here that I might need later

It actually gets a little more. Every process you run has an "environment" where various variables are specified. You can see which variables your shell knows about using the command `env`. Some variables are passed along to the program, to its environment. The process for how that works is not important for us at this point, except that one of the variables is the working directory (`PWD`), so when you run a program, it knows in which directory it is running, so if any of the arguments are relative paths to files, it knows what they are relative to.

![Process with arguments and environment.](img/process-with-env.png)

While this environment is sometimes important, I don't expect that it will be important in this class, so I will quietly ignore it from here on.

- **FIXME** Explain that the environment variable `$PWD` is the reason `bash backup.sh` didn't run in the root.
