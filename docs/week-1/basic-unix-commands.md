# A quick introduction to the UNIX command line

The basic interaction with all shells involves typing something into a *prompt*, the text highlighted in the figure below.

**FIXME:** Make a picture of a shell as they will see it on the cluster.

The prompt is what the shell writes to you, to indicate that it is ready to take the next command. To the right of it is your cursor, and there you can type in your commands. When you interact with your shell, you will write a command at the prompt and then hit ENTER. (This should be familiar to most of you). Then the shell will interpret what you wrote, execute the command you gave it, and print the result.

Prompts can be configured, so they look differently depending on which machine you are on, which jobs you are currently running, and a host of other factors, so I will not attempt to guess what the prompt will look like for you. The default on GenomeDK will be the host name in square brackets followed by a `$`, so for example

```bash
[fe-open-01]$
```

but this is only a default, and it will only look like this if you are on the machine `fe-open-01`.

Below I will use `~>` as the example prompt, but keep in mind that it can look different on your computer.

## A few useful commands

This will not be a tutorial of most useful commands you will want to know, you will pick those up with time if you explore the UNIX environment as you work on exercises and projects, but I will show you a few to get you started.

### man

The most useful command to know is `man`, short for *manual*. This is where you get information about the tools you have. If you write

```bash
~> man man
```

you get the manual for the `man` command.

Back in the good old days, all tools would have a manual page that described them, and all the old tools still do. Unfortunately, this isn’t true for many modern bioinformatics tools, where you have to run the tool with a flag such as `-h` or `--help` to get the same information, but that is a worry for another day. For the commands I will show you in this exercise, `man` will give you a description. Use this command to learn more about the various tools and commands.

### ls

The `ls` command you saw in the examples above lists the files in a directory. Try the command

```bash
~> man ls
```

You will find that the command takes an unreasonable number of options. The exact options depend a bit on which platform you are on, but there will be more than you care to study right now on all platforms. On my machine, the options are

```bash
ls [-ABCFGHLOPRSTUW@abcdefghiklmnopqrstuwx1%] [file ...]
```

where the long line `[-ABCFGHLOPRSTUW@abcdefghiklmnopqrstuwx1%]` are all the options. Ignore them. The important part is `ls [file ...]`. This bit tells you that `ls` takes zero or more files as arguments. Zero or more because `file ...` is in `[…]` which means that they can be left out and “more” because of the ellipsis after `file`.

We used it without arguments above

```bash
~> ls
```

and if we do this, it will list the current directory. (More on that shortly).

If you give it options, which will typically be directories, it will list those. So

```bash
~> ls foo
```

will list the file or directory `foo`. If `foo` is a file, it will just list `foo`, and if `foo` is a directory it will list all the files in it.

### mkdir, touch and rm

Try running these commands:

```bash
~> mkdir foo
~> touch foo/bar
~> touch foo/baz
~> ls foo
```

What do you see?

Use `man mkdir` to find out what `mkdir` does.

(It creates a new directory).

Use `man touch` to see what `touch` does.

(It “touches” a file, which isn’t something we need here, but touching a file that doesn’t exist has the side-effect of creating it).

Why do you get the result you get when you run these commands?

If you want to remove a file, the command `rm` is what you need. However,

```bash
~> rm foo
```

won’t work for us here. Since `foo` is a directory, we cannot simply remove it the same way as we can a file. However,

```bash
~> rm -r foo
```

will do the trick. The option `-r` tells `rm` to remove files recursively, and then it will happily take a directory and remove it together with all files and directories inside it.

A command such as `rm -r foo` gives us a common pattern for instructions to a shell. The `rm` bit is a program that we want to run. The `foo` argument is an option to it, and the `-r` bit is a flag that modifies how the program is run. There are some conventions for how programs use flags and options and such, but unfortunately there is more than one convention, so you never really know how any given program handles arguments. That is up to the programmer who wrote the tool, and you have to check the documentation.

We will see how to write tools that take arguments, and how to parse the arguments as flags and options, in some of the later exercises and projects.

### echo

The command `echo` prints the arguments you give it:

```bash
~> echo foo bar baz
foo
bar
baz
```

Think of it as a simple “print” statement in a shell. When you are working interactively, it doesn’t seem like a terribly useful command, but it does have its usage.

If you write

```bash
~> echo foo bar baz > qux
```

you will have created a new file, `qux`, that contains the lines:

```bash
foo
bar
baz
```

The magic happens with the symbol `>`, and it isn’t actually `echo` doing the magic but the shell. When we write this, we redirect the output of the command to the left of `>` into the file on the right. We return to this in a little bit.

### cat, more and less

The `cat` command con*cat*tenates files.

If you call `cat` with a number of files, it will print their content one after another. A number could be one, so you can write

```bash
~> cat qux
foo
bar
baz
```

to get the content of the file `qux` we created above. The same file can appear more than once, so you could also get:

```bash
~> cat qux qux
foo
bar
baz
foo
bar
baz
```

It is a useful command if you want to see the content of a small file, but if a file is large, you probably don’t want to get all of it printed. Instead you can get a view of it with the commands `more` or `less`. (The `less` command is an improved `more` and “`more` is `less`” is programmer humour).

Try running `more qux` and `less qux`.

If you read `man cat` you will see `[file ...]` in the command description, telling you that you can also call `cat` with zero files. If you do this, it will look like nothing is happening.

```bash
~> cat

```

but try writing something and hitting ENTER. It will echo what you just wrote. Write some more and hit ENTER again, and the same thing happen. When you grow tired of this you can hit `CTRL-d` to finish.

What happens is that `cat` reads from “standard input”. It takes over from the shell so all you write goes to `cat`, and everything you write will be echoed because that is what `cat` does—it prints each input line.

Just as you can send the output of a command to a file with `>` you can also tell a program that its “standard input” should be taken from a file. The symbol is then `<`. So

```bash
~> cat < qux
foo
bar
baz
```

in a UNIX shell will do the same as

```bash
~> cat qux
```

This, however, doesn’t work with PowerShell. We can get a similar effect in a different way, but we get to that later.

For `cat`, this isn’t useful in itself; we get exactly the same effect by calling `cat qux` as `cat < qux`, but it has its uses as we shall also see shortly.

### cmp and diff

If you want to see if two files are identical—you can probably imagine that this can be useful—two tools are particularly useful. The `cmp` command will tell you if two files are the same. It will print that they are different if they are

```bash
~> echo foo baz bar > qax
~> cmp qux qax
qux qax differ: char 7, line 2
```

or print nothing if they are the same:

```bash
~> cmp qux qux
```

Just because it doesn’t print anything doesn’t mean that the tool doesn’t return a value, it just isn’t printed. You can get the status of a command using `echo $?`

```bash
~> cmp qux qux
~> echo $?
0
~> cmp qux qax
qux qax differ: char 7, line 2
~> echo $?
1
```

This is mostly useful for shell programming, which we return to later in the class.

If you are familiar with programming, you might be surprised that zero means success and non-zero means failure; it is typically the other way around. It is indeed, but the convention in UNIX is that all programs report their status with an integer, and zero is their way of reporting that nothing untowards happend. It shouldn't be interpreted as `true` or `false` in the traditional programming sense, it is just a return status, and zero means that the program terminated sucessfully. For `cmp`, the program considers two identical files a success, so it reports zero. If the files differ, it considers that an unexpected event, and it terminates with a non-zero status.

But enough about program status and variables; we return to that later, when we learn how to write small programs, also called "scripts", in this shell language.

The string `$?` we use to get the return status printed is a "variable". Variables are mappings from some name `name` to a value, and if you want the value associated with the variable `name` you write `$name`. Thus, when we write `$?` we are asking for the value in the variable `?`, which in bash always holds the status of the last command we ran. There are many variables in play in a typical UNIX shell, and we will see more of them next week.

If you want to see the differences between two files, `diff` is your tool.

```bash
~> diff qux qux
~> diff qux qax
2d1
< bar
3a3
> bar
```

It will also print nothing if the files are identical—then there are no differences—and otherwise it will print the differences it see. You need to remove `bar` in the second line of `qux` and then add a `bar` at the third line to get `qax`. The way `diff` displays the differences can be changed with a plethora of options that you can learn about using `man diff`.

The `-y` option is particularly useful. It displays the two files next to each other with `<` when a line is present in the first file and not the second, and with `>` when something is present in the second file but not the first.

```bash
~> diff -y qux qax
foo     foo
bar   <
baz     baz
      > bar
```

### grep

The `grep` command lets you search in files. The name has a weird mnemonic, `grep` stands for “global, regular expression, print”, a name that made perfect sense in the Elder Days where it was a command you could give the `ed` editor, but today it is pure nonsense. Instead, `grep` has become a verb in its own right, and you will hear programmers talk about “grepping” for stuff.

The simplest usage is `grep word file` that will search for `word` in the file `file` and print all the lines where `word` is found.

A boring example is this:

```bash
~> grep foo qux
foo
```

It prints a single `foo` as there is one line in `qux` that contains `foo`.

If you search in more than one file, `grep` will also tell you which file it found `word` in.

```bash
~> grep foo qux qax
qux:foo
qax:foo
```

The countless options you can give `grep` can change how it outputs it findings, whether it prints the lines where it finds `word` or just which files it found `word` in, ,whether it should output the files it *didn’t* find `word` in instead, and so on. It is one of the most useful search commands you have at your disposal on the command line, once you learn how to use it.

## The anatomy of a typical UNIX command

I know that it all looks confusing and overwhelming at this point. You’ve seen a tiny fraction of the commands you have available in a shell, and all of them take an obscene number of options, and there is no way that you can remember the commands or the options. Luckily, with `man` you don’t have to remember the options, but if you don’t know the name of a command, `man` is of no use.

It *is* overwhelming; it *is* confusing. It is not just you. There *are* too many commands to remember, and every time someone writes a new tool, yourself included, there is one more command to add to the toolbox.

Have no fear, though. It is just like learning a new language. A new language contains tens or hundreds of thousands of words and you need to learn a lot of them before you can speak the language, and at least you have fewer words on the command line than in English, Swahili or Dutch.

The more you use the language, the more words you will learn, and soon you will speak a passable command line, if not yet completely fluent. The only thing you need to do to keep learning is to, whenever you want to do something, X, ask the question: “how do I do X in my shell?”. You can ask me, you can ask a friend, and Google is your friend if you have no others. Slowly but surely you will increase your vocabulary.

Luckily, the grammar is much simpler for a shell than a natural language. It is more complicated than I will show you here—and each shell is a separate language with its own grammar when it comes to the more complicated stuff—but it is simpler than the natural languages you already speak.

I will show you the basic grammar, though, and illustrate how a simple grammar gives you a powerful language.

We start with the grammar for a single command. You’ve seen several examples above. A command looks like this:

```bash
~> some-command arg1 arg2 arg3 …
```

There is a command at the beginning, `some-command`, and then zero or more arguments, `arg1 arg2 arg3 …`

When you write a command like that, the shell will find a program called `some-command` and execute it, giving it the arguments. Some strings you can’t use as arguments, we will see most of them below, because the shell will interpret them as commands to itself rather than the program, but generally it just gives the program the arguments.

What the program does with the arguments is entirely up to the program. The shell doesn’t know, nor does it care. That is the program’s responsibility. The way to find out what they mean is using `man some-command`.

When you write your own programs, you have access to the arguments that a user provides on the command line. Where you have them depends on the programming language you use, and I will show you how to get at them in Python, the language we use for this class, next week.

Anyway, when you execute a command, you will be running a program, and that program gets the arguments you provided.

![Process with arguments.](img/process-with-args.png)

With this alone, we would have a useful interface to running commands. We can call any program by putting it first in a command, and we can give the program any arguments it needs using the following values. If a command needs to read or write files, we can specify file names as arguments, and it will be able to find the files, either relative to the working directory or using an absolute path.
