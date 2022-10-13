# Navigating the file system

**FIXME: THE STUFF BELOW SHOULD BE REWRITTEN, SINCE WE CANNOT ASSUME THAT THEY HAVE THE FOGGIEST ABOUT WHAT THE FILE SYSTEM LOOKS LIKE THESE DAYS. IT IS ALSO IMPORTANT TO DISTINGUISH BETWEEN WHERE FILES AND DIRECTORIES ARE, AND WHERE _THEY_ ARE IN THE SHELL (CWD).**

I won’t say much about the file system. You already know how the file system consist of a hierarchy of directories and files. The only thing to add to this, when it comes to shells, is that we have something called the _current (working) directory_, and all commands are relative to that place.

The command `pwd` will show you where the shell’s current working directory is. You get a string of `/`-separated names. The slash is used to separate directories on UNIX (you might be used to backslash on Windows). Whenever you provide a file-name to a command, it will be interpreted in one of two ways.

An _absolute_ path to the file—any file-name that starts with a `/` is absolute, and the path—the string of `/`-separated names is interpreted as starting in the root of your file system. What that is, depends on your platform.

A _relative_ path is one that doesn’t start with a `/`. Those will be interpreted as a path that starts in the current working directory and relative to that.

So, when we wrote `cat qux` we used a relative path. We gave `cat` the `qux` file in the current directory. Earlier, when we did `touch foo/bar` we also used a relative path. We specified the directory `foo` in the current directory, and then the file `bar` inside that `foo` directory.

In addition to this, there are two special names, `.` and `..`. A single dot, `.`, always refers to the current directory. So if we wrote `cat ./qux` we would explicitly say that we wanted the `qux` in the current directory. There are some situations where it is necessary to specify `./qux` instead of `qux`, but we won’t go into that here.

The two dots, `..`, refers to the parent of a directory. If we wrote `cat ../foo` we would be looking for the `foo` file not in this directory but in the directory one up.

Try running these commands and see what you get:

```bash
~> ls .
~> ls ..
```

The two dots can be used inside a path, so if we wrote

```bash
~> mkdir foo
~> ls foo/..
```

we would ask `ls` to list the parent directory of `foo` (which would be the same as the current directory.

To change directories you use the command `cd`. It takes a path as an argument, so you can change the current directory to the sub-directory `foo` using

```bash
~> cd foo
```

and then go back to the original directory with

```bash
~> cd ..
```

If you use `cd` with arguments, you will be send to your home directory, whatever that is. It depends on your platform, and it isn’t an important concept on a personal computer, but it is if you get an account on a shared system like our GenomeDK cluster. The home directory is the root of all your own files, kept separated from other users’ files.

Try using `cd` to move around the directory hierarchy, and every time you end up somewhere new, use `pwd` to see where the shell thinks that you are.
