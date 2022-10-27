# Programming in the shell

UNIX shells practically all have some programming support. It is not necessarily the kind of programming you are familiar with if you have experience with languages like Python or R or similar, but it is not completely dissimilar either. You will have support for looping and for taking different branches depending on conditions (`if`-statements and such), but the statements you write in a shell script are the kind of commands you know and love from the interactive shell, and the control flow constructions (that means the loops and such) reflect this.

We are going aiming to become expert shell programmers, and we are certainly not aiming at using shell programming as a replacement for more traditional languages (although some can be stretched that far). We will not see how you can emulate data structure or such complicated features. The purpose of this session is to see some of the things you can do in a shell to add control flow to shell scripts and, through that, create more flexible and powerful tools for yourself. For most users, that is all that they will ever need, but should you wish to delve further into shell programming at a later date, you will have a basis to build on, and there is plenty of online material that will help you continue down this dark path.

## Control and data flow

When we start making more complex commands, two main concerns should be on our mind: how is data processed, getting us from the input we have to the output we want, and which commands will be executed to get this done. The first we refer to as *data flow* and the second as *control flow*.

When you run shell commands, the data flow is typically handled through files and pipes. The pipelines we have already seen are a simple example of this. There, the output of one command flows into the input of the next, and along the way, each command transforms the data in some desired way. Data flow can be more complex than this, of course, with one program producing output that is used in multiple other commands, or one command might need the output of multiple previous commands. Simple pipelines cannot handle that, but we can store data in files and handle it that way. That is not the topic of this lesson, however, but something we will return to later.

The topic of this lesson is control flow, which describes which commands will run, in which order, and under which conditions. In the shell scripts we have seen so far, the commands mostly ran one after another. The script would run one command; when that command finished, it would move on to the next line in the file and execute the command there and then move on to the following command after that.

![Sequentially running commands](img/control-flow/sequential.png)

In the pipelines, all the commands run simultaneously while the data flows through them, but since we will not concern ourselves with the distinction between running something in parallel versus running commands sequentially, you can think of them as much the same as the shell script: one command running after another. With pipelines, it is just the data seeing this order of commands rather than the clock on the wall.

![Parallel pipeline](img/control-flow/pipeline.png)

One command after another is the simplest form of control flow, but we have also seen cases where one command would only be executed conditionally on the result of another. For example, in one of the versions of our backup script, we would only `source` a configuration script if the file existed:

```bash
[ -f conf.sh ] && source conf.sh
```

Or we would create a directory only if it didn’t exist already:

```bash
[ -d results-$date ] || mkdir results-$date
```

When we have such expressions, the commands are not executed in a simple linear fashion. Sure, they are executed one by one, but which commands depend on the state of your system. You can think of running the script as flowing through a graph of commands, where which path you take depends on the results of the tests you make. In the figure below, we have a bit of the backup script on the left, and on the right, we have the corresponding commands. There is an edge between two commands if one might be executed after the other, and after the directory test, we see that the next command depends on the result of the test. If the directory exists, we continue down to the `cp ...` command, but if it doesn't, we will execute the `mkdir ...` command first.

![Control flow for logical expression](img/control-flow/selection.png)

It is in this way we view the commands when we talk about control flow (where you can think of “control” as the commands we execute).

Logical operators are a simple way to get control flow (simple, if not exactly easy to read and decode). Others are both more powerful and easier to work with when things get complicated, and those are the topic for today.

First, however, we need to talk about tests. Whenever we need to choose which command to execute next, we need some form of test. In the backup script, we tested for the existence of files or directories using `[ -f … ]` or `[ -d … ]`, but there is a host of different ways of testing and we will do a whirlwind tour through them now.

## Testing stuff

Much of the control flow boils down to testing if something is true or false. "If this file exists, then do that...". "While there is more data, do this...". In a shell, however, you rarely see explicit true or false values, which is also the case for the bash shell. Instead, shells run commands and check the status of the commands to determine if something is "true" or "false". And there are multiple ways of doing that.

### Running a command

Generally, whenever you run a command, it will report back its status to the shell. You cannot do much with that status yet, but you can check what the result of the latest command was by printing the variable `$?`.

```bash
~> true ; echo $?
0
~> false ; echo $?
1
```

Here, `true` and `false` are not boolean values, but commands you can execute. They return true and false, respectively, but in the sense that the shell can understand, and as you can see, that is the exit status zero for true and one for false. Generally, the shell will consider any non-zero return status as "false" for programming purposes.

### Using `test`

The tests we have used so far, i.e. `[ -d … ]` and `[ -f … ]` are calling the command `test`. The square bracket syntax is just an alternative to calling this command, so 

```bash
~> [ -f conf.sh ] ; echo $?
0
```

and

```bash
~> test -f conf.sh ; echo $?
0
```

are doing the exact same thing.

The `test` command is the go-to command for testing file and directory properties. We have used it to test if a file exists, option `-f`, or whether a file exists and is a directory, option `-d`, and these are the most common file tests. However, if you need to test for other file properties, e.g. whether the file exists and is executable (`-x`) or whether you can write to it (`-w`), then check `man test`.

The `test` command also provides several string tests. You can, for example, test if two strings are the same:

```bash
~> [ "foo" = "bar" ]; echo $?
1
~> [ "foo" = "foo" ]; echo $?
0
```

This, alone, is, of course, useless. We can immediately see if the strings are the same. But combined with variables, it gives us a way to check if a variable has a specific value.

```bash
~> foo="foo"
~> [ $foo = "foo" ]; echo $?
0
~> foo="bar"
~> [ $foo = "foo" ]; echo $?
1
```

Read `man test` for the whole story.

### Using `let`



## Parentheses preposterousness

This section will be a bit messy. I apologise for that. Well, I do not apologise because I didn't do any of the damage, but I am sorry that it is this way. The bash shell uses different kinds of parentheses for different purposes, and you always need to pick the right one for the job when you program in bash. There isn't much system to it, so you have to memorise which kinds of parentheses are needed for which kind of jobs.

Single parentheses run commands in a sub-shell. That is the same as running the commands in a shell script, in the sense that any changes you make to the shell's status and environment only affect the new shell and not the current one. For example, if you set variables, the variables affect the new shell and not the old one:

```bash
~> x=foo
~> ( x=bar ; echo $x )
bar
~> echo $x
foo
```

If you change directory, the rule is the same: you change the status of the new shell but not the current one.

```bash
~> pwd
/home/mailund
~> ( cd / ; pwd )  # changing dir in the sub-shell
/
~> pwd # We didn't change dir in this shell
/home/mailund
```

Adding `$` to the sub-shell command, you get the output back in a form you can use to substitute text:

```bash
~> echo $( x=bar ; echo $x )
bar
```

Single parentheses can be used as test conditions because they are commands like any other command.

```bash
~> (echo "foo" ; true) ; echo $?
foo
0
~> (echo "foo" ; false) ; echo $?
foo
1
```

Other than that, they are not directly related to testing, unlike the other parentheses variants, we will examine below.

### Using `let` as `(( ... ))`

### Using `test` as `[ ... ]` or `[[ ... ]]`

Expressions in single square brackets, `[ expr ]`, are just alternative syntax for `test expr`. The two ways of writing a test work exactly the same, and in my experience, it is about fifty-fifty what people use in the wild. I personally find the `[ ... ]` syntax more readable, but that is probably a matter of what I am experienced with rather than any qualitative difference between the two ways of testing.

Bash being bash, it couldn’t possibly stick to only two ways of doing such tests (or four or five for that matter). Since we have syntax with single parentheses, `( ... )`, for running commands in a sub-shell, and double parentheses, `(( ... ))` for testing using `let`, we couldn’t possibly just have one version with single square brackets. Oh no. We also have syntax for double square brackets: `[[ ... ]]`.

It is not too bad, though. Unlike `( ... )` and `(( ... ))` that do utterly different things, `[[ expr ]]` does the same as `[ expr ]` except that the former is part of the shell language and not simply running a command (`test`), so the syntax inside `[[ ... ]]` is less restricted.[^1]

[^1]: Coming to think about it, maybe it isn’t better to have a similar syntax that does *almost* the same compared to similar syntax that at least doesn’t behave the same. I don’t know. I find it all a big mess, but I live by the stoic philosophy that tells me next to nothing is under my control, so I might as well just get on with it.

The `[[ ... ]]` construction can work out that when you use a variable, you probably refer to a single token. So, for example, if you have a file name with a space in it:

```bash
~> touch 'foo bar'
~> ls 'foo bar'
foo bar
```

You might imagine that you could do something like this to test if it is present:

```bash
~> x='foo bar'
~> [ -f $x ]; echo $?
```

Try it; I dare you.

It will fail because the variable `$x` expands to `foo bar`, and you will run the command `test -f foo bar`. Now, `test` doesn’t like this because it expects a single file name after `-f`, so it will complain.

If you instead use

```bash
~> [[ -f $x ]]; echo $?
0
```

it works just fine. Since bash interprets what you write in `[[ ... ]]`, it is smarter than `test`, which will get the arguments *after* the variable `$x` is expanded. It can’t possibly know that the arguments `foo` and `bar` were previously part of the same variable.

It is not that you cannot do it with `test`, but you have to quote variables by putting them in `" ... "`

```bash
~> [ -f "$x" ]; echo $?
0
```

With `[ ... ]`, you tend to have to quote *a lot* of variables. The alternative `[[ ... ]]` construction is better at dealing with expanded variables.

Because `[[ ... ]]` can interpret the input better than a command can (because it sees it before we do all the shell expansions and transformations that normally happens when we execute a command), we can also use more familiar notation than we can with a command, when the notation clashes with other shell notation.

Comparison operations are examples of this. In a shell command `<` and `>` are used to redirect `stdin` and `stdout`, so we can’t write `test a < b` and get away with it. Since the `[ ... ]` notation means the same as calling `test`, we cannot do it there either. We can, however, do it with `[[ ... ]]`:

```bash
~> [[ a < b ]]; echo $?
0
```

Again, it is not that it is impossible to use shell operators as operators for a command; you would just have to quote or escape the operators somehow, making expressions less readable. This will work fine, it is just ugly:

```bash
~> [ a \< b ]; echo $?
0
```

When you compare numbers with either `[[ ... ]]` or `[ ... ]`, you have to be careful, though. Comparisons are textual, not arithmetical. `[[ 10 > 9 ]]` is false because the *string* “10” is sorted before the *string* 9.

```bash
~> [[ 10 > 9 ]]; echo $?
1
```

With the `let` command, `(( 10 > 9 ))`, the comparison is arithmetical, and the *number* 10 is greater than the *number* 9.

The two test commands can compare numbers, but you need different operators. The *numerical* greater than is `-gt`, so you would write

```bash
~> [[ 10 -gt 9 ]]; echo $?
0
```

Or, of course, you could use the `let` or `(( ... ))` syntax.

```bash
~> (( 10 > 9 )); echo $?
0
```

**FIXME: regex matching**

If you are in doubt, use the `[[ ... ]]` construction. It will almost always behave the same as `[ ... ]` (with the caveats on expansion), but it can do more.

## If-statements

## Cases

## While loops

## For loops

```bash
for (( i=0; i < 10; i++ )); do
 echo $i
done
```

## Functions

- local and global variables
- parameters
