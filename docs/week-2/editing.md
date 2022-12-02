# Editing files on the cluster

## Editors on the cluster

 (nano, emacs, vi), mount (see files on your own laptop), VSCode (I don't know what it is it can do, but it can apparently work directly on the cluster).

## Mounting the cluser's file system on your own computer

If you, like I quickly do, get tired of editing files through a shells limited capabilities, you can also *mount* the cluster's file system on your own computer.

Mounting file systems is part of the UNIX architecture. In UNIX, unlike e.g. Windows, you do not operate with different drives, and instead you have one big hunking file system that may span multiple physical disks. It is how the large number of user and project directories are distributed on multiple disks on a large system such as GenomeDK, and we can use it to our advantage as well.

The idea with mounting is that you take some directory and then you tell it that the content of this directory is actually this "whole file system over there". If you get away with that, and we will, then the computer will see the other file system as if they were any other directories and files inside the designated directory.

If we pick a directory on our local machine and *mount* our home directory on the cluster there, then our computer should see the cluster files as part of its own directory structure!

It won't be quite as fast as if the files were local, partly because we have to access the files over the secure `ssh` connection, so I do not recommend that you try to compile software or analyse data on your local machine. Everything you touch in the mounted files will have to be copied back and forth between your laptop and the cluster. Do the data intensive work on the cluster. But you can easily open files and edit them on your own computer without worrying about the data transmission bottlneck. A file system over `ssh` is slow, yes, but biounits such as ourselves are much slower.

### Installing `sshfs`

The system we will use to mount the cluster filesystem is called `sshfs` (`ssh` + file system), and you need to install it on your own computer to use it. It is on your computer that we mount the cluster, and the cluster cannot do it for you.

How you install it depends on your operating system:

- Linux: On an `apt-get` system (e.g. Ubuntu) use `apt-get install sshfs`; on a `yum` system (e.g. Fedora or CentOS) use `yum install sshfs`
- MacOS: [Install MacFUSE and `sshfs`](https://osxfuse.github.io) (separate packages on the right of the page; you need to install both).
- Windows: I am not aware of a native `sshfs` for windows, but you should be able to use the Linux version if you are using something like [Windows Subsystem for Linux](https://learn.microsoft.com/en-us/windows/wsl/install). (You probably want something like that installed anyway, since then you get the full power of UNIX on your own laptop, and not the Mickey Mouse computer interface that you are stuck with otherwise).

### Mounting the cluster

Ok, if you have `sshfs` installed, we can proceed with mounting the cluster. For this, you need a directory designated as the entry point to the glorious cluster. I call mine `~/GenomeDK`, i.e. I put it in my home directory with a name that I can easily remember refers to the cluster. Make the directory of your choice:

```bash
~> mkdir ~/GenomeDK
```

You can call it something else, and put it somewhere else, you just want a directory. I recommend that you keep it empty, though, because you cannot get to its content while the cluster's file system is mounted.

For mounting the cluster, you need this command:

```bash
~> sshfs USERNAME@login.genome.au.dk:/home/USERNAME  \
     ~/GenomeDK                                      \
     -o idmap=none -o uid=$(id -u),gid=$(id -g)      \
     -o allow_other -o umask=077 -o follow_symlinks
```

As earlier, `USERNAME` should be the user name you have on the cluster. Don't forget the `\` in the command. The command line is long, but here it is broken into four lines. We can do that by escaping the new line at the end, but if you forget `\` you will type in one command as four, and nothing good will come of it.

The first line specifies where we want the directory to point. It is at the cluser, so `login.genome.au.dk` (that's the machine we can log into; the files could be anywhere on the cluster), and where on the cluster's file system we want to point (here our home directory, `/home/USERNAME`). The second line specifies which directory we want to point there; I went with the name I gave mine, but you have to change it if you didn't follow my excellent example. The rest is just stuff to make it work; you don't have to worry about it if you just copy the two lines.

Assuming this goes well--and why shouldn't it?--your cluster files are now at the other end of `~/GenomeDK`. Check it out!

```bash
~> ls ~/GenomeDK
...the glorious cluster file system...
```

On MacOS, if you open Finder in your home directory, the directory will have a weird name, like `MacFUSE Volume 0`. Just ignore that; it is MacFUSE being silly. Stick to the terminal; the shell is always right.

If you want to close the connection to the cluster again, you need to unmount it. UNIX being UNIX, the command isn't called `unmount` but `umount`, and you write

```bash
~> umount ~/GenomeDK
```

After that, you get your empty `~/GenomeDK` directory back (but your files on the cluster are safe and sound, I promise). You might have trouble unmounting if you have a tool looking at files on the cluster. Generally, operating systems are not happy with unmounting files you are currently working on. If you have problems with this command, close the tools you have used to access files there.

If you are like me, you won't remember all the arguments to the mounting `sshfs` command, but the good news is that we do not have to. We can make our own commands as e.g. aliases or functions in a configuration file such as `~/.bashrc`. Mine looks like this:

```bash
genome_dk_user=mailund
genome_dk_mount_dir=~/GenomeDK
function mount_gdk() {
    local local_dir=$genome_dk_mount_dir
    local remote_dir=${genome_dk_user}@login.genome.au.dk:/home/${genome_dk_user}

    if ! ( [[ -d $local_dir ]] || mkdir $local_dir ); then
        echo "Couldn't create mount dir $local_dir"
        return 2
    fi

    sshfs $remote_dir $local_dir                        \
        -o idmap=none -o uid=$(id -u),gid=$(id -g)      \
        -o allow_other -o umask=077 -o follow_symlinks
}
function unmount_gdk() {
    umount $genome_dk_mount_dir
    rmdir $genome_dk_mount_dir
}
```

Since my shell reads these when it starts, I have at my fingertips the commands `mount_gdk` and `unmount_gdk` (I didn't forget the `n`). If you want to use them, change the `genome_dk_user` and `genome_dk_mount_dir` to fit your user name and mount directory.

The mounting command, `mount_gdk`, tries to create the mount directory if it doesn't exist (and give up if it can't), and `unmount_gdk` removes the directory when I'm done. You don't have to do this, you can keep the directory if you want to. I just prefer to run a tight ship.

Anyway, while the cluster is mounted this way, you can access all the files you have on the cluster as if they were on your own file system. Not quite as fast, I will admit that, but a hell of a lot easier than if you had to edit files using terminal editors.

## Working with a remote VS Code
