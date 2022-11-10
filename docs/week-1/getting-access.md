# Getting access to GenomeDK’s cluster

To follow this class, you must have an account on the [GenomeDK](https://genome.au.dk). To get that, go to their [getting started page](https://genome.au.dk/docs/getting-started/#request-access) and fill out the request form on the first page (under *Get access to the cluster*). Do this as early as possible, as there can be some delay between requesting and getting access, and you will need access to do some of the exercises in the class.

Before you can log in to the cluster, you also need a terminal and the tool `ssh`.

If you are on Linux, then I will assume that you already know how to open a terminal (and if you don’t, I can’t help you much, as different distributions put them in different places).  But it will be there. So will `ssh`; it is included with all major distributions.

If you are using macOS, you also already have a terminal. The program is named **Terminal.app**, and it is found in your **Applications** folder. You may have more than one terminal program, but they will all work the same for our purposes. The `ssh` tool should also already be available.

If you are using Windows 10 or later, you can use **PowerShell** as your terminal. Although PowerShell itself is a kind of shell, different from what we will work with in this class, you only need it for `ssh`, and it will have that. After you are on the cluster, you will be using the same setup as everyone else.

If you are using a version of Windows older than 10, you can install [MobaXterm](https://mobaxterm.mobatek.net/) to get both a terminal and `ssh`.

## Your first login

After you have been granted access to the cluster, get on AU’s network (either via VPN or by being physically on campus), then open your terminal and type:

```bash
~> ssh USERNAME@login.genome.au.dk
```

on Linux or macOS or

```bash
~> ssh.exe USERNAME@login.genome.au.dk
```

on Windows, here `~>` is whatever prompt you have in your terminal (so do not type that in as part of the command), and where `USERNAME` is the user name you got on the cluster.

Hit enter, and it should ask you for a password

```bash
USERNAME@login.genome.au.dk's password:
```

Give it the password you received when you got the account, hit enter, and if everything went well, you are greeted by this friendly message:

```bash
  _____                                ______ _   __
 |  __ \                               |  _  \ | / /
 | |  \/ ___ _ __   ___  _ __ ___   ___| | | | |/ /
 | | __ / _ \ '_ \ / _ \| '_ ` _ \ / _ \ | | |    \
 | |_\ \  __/ | | | (_) | | | | | |  __/ |/ /| |\  \
  \____/\___|_| |_|\___/|_| |_| |_|\___|___/ \_| \_/

 Info     https://genome.au.dk/
 Help     https://genome.au.dk/docs
 Contact  support@genome.au.dk

[USERNAME@fe-open-01 ~]$
```

You are now logged into the front-end of the cluster. The string

```bash
[USERNAME@fe-open-01 ~]$
```

is your “prompt” (that tells you that you are `USERNAME` at the front end `fe-open-01`, and that you are sitting in your user directory `~`, but we get back to that later).

The first thing you should do is to change your password to something you can remember (and something that is not sitting in an email in your inbox). Use this command, and follow the instructions:

```bash
[USERNAME@fe-open-01 ~]$ change-password
```

I will soon grow tired of writing

```bash
[USERNAME@fe-open-01 ~]$
```

for the prompt, and in any case, the prompt is something you can change (see e.g. [oh-my-bash](https://github.com/ohmybash/oh-my-bash) for ways to go crazy with configuring your setup, but don’t go crazy quite yet, you will need your sanity a bit longer).

Henceforth, I will use `~>` to refer to your prompt, so although it looks like

```bash
[USERNAME@fe-open-01 ~]$
```

in your terminal, I will write it as

```bash
~> 
```

We don't have much to do at the cluster right now, so why not try logging out again? You can do that by typing `exit` or by pressing `Ctrl-d` (the control key together with `d`). The `exit` command will terminate the shell, which will disconnect you from the cluster's end while `Ctrl-d` tells the shell that you will not be sending any more data (the `Ctrl-d` sends a so-called "end of file" signal) which will do the same thing. In either case, the connection the the front end of the cluster is severed and you are now safely back on your own computer, just you and your terminal.

But don't worry. You can always log back in, if you feel bored or lonely.

If you are happy with logging into the cluster using a password, you can skip the next step, but if you prefer to set up the system so it trusts the computer you are currently using, you can create a crypto key for your computer, tell the cluster about it, and in the future the cluster will let you in as long as you are logging in from your current machine.

If you like the sound of that, create the key with the command

```bash
~> ssh-keygen
```

It will ask for a passphrase (that is a password for us mortals), and you can give it one if you want an extra level of protection. If you do, you need to type that in every time you log in, and then we don’t gain anything. If you leave the passphrase empty (I do), you don’t need to bother with passwords anymore. In either case, you need to give the passphrase twice (but that is a lot easier if you don’t provide one because then you just hit Enter twice).

Then it will write some gibberish like this:

```bash
Enter passphrase (empty for no passphrase):
Enter same passphrase again:
Your identification has been saved in /Users/das/.ssh/id_rsa.
Your public key has been saved in /Users/das/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:XxSd35yPd1bUoIJQDBCAvxDu+pB25ipYpcmp+VEh5JE das@jorn
The key's randomart image is:
+---[RSA 2048]----+
| .+oooo+.   ...o.|
|ooE.   ...   oo o|
|.oo .   . . o  +o|
|......     o   .=|
|.o *.   S   .  .o|
| oB.     . .  . =|
|==.o      .    o.|
|B.+.             |
|.++.             |
+----[SHA256]-----+
```

You can ignore it, except the part after `Your public key was saved in ...`. We need the file name after that, and that is what `THAT_FILE_I_SAID_WE_NEEDED` is in the next command:

```bash
~> ssh-copy-id -i THAT_FILE_I_SAID_WE_NEEDED USERNAME@login.genome.au.dk
```

Here, it will copy the super secret crypto info to the cluster, and to do that it needs your password one more time. Not the passphrase (that you left empty if you were as lazy as me), but the password you have for the cluster.

After all that, you can log into the cluster without providing a password.

```bash
~> ssh USERNAME@login.genome.au.dk

 _____                                ______ _   __
 |  __ \                               |  _  \ | / /
 | |  \/ ___ _ __   ___  _ __ ___   ___| | | | |/ /
 | | __ / _ \ '_ \ / _ \| '_ ` _ \ / _ \ | | |    \
 | |_\ \  __/ | | | (_) | | | | | |  __/ |/ /| |\  \
  \____/\___|_| |_|\___/|_| |_| |_|\___|___/ \_| \_/

 Info     https://genome.au.dk/
 Help     https://genome.au.dk/docs
 Contact  support@genome.au.dk

~> 
```

Now that you are here, you could

- [Try to run a few commands](basic-unix-commands.md) or
- [Learn about the file struct on a UNIX platform](navigating-file-system.md)

Knock yourself out!
