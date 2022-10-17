# Scripts and variables

- How to make a simple script (putting commands in a file, the `#!`-line).
- Adding arguments to the script (variables `$@ $1 $2` and such)
- General variables (just an example where we use a better name)
- Variables and environment variables--what's the difference (inheriting variables from the parent process)

**FIXME:** just copied some stuff here that I might need later

It actually gets a little more. Every process you run has an "environment" where various variables are specified. You can see which variables your shell knows about using the command `env`. Some variables are passed along to the program, to its environment. The process for how that works is not important for us at this point, except that one of the variables is the working directory (`PWD`), so when you run a program, it knows in which directory it is running, so if any of the arguments are relative paths to files, it knows what they are relative to.

![Process with arguments and environment.](img/process-with-env.png)

While this environment is sometimes important, I don't expect that it will be important in this class, so I will quietly ignore it from here on.
