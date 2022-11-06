# Cluster architecture

If this is your first trip into a UNIX cluster wonderland, and if you are reading this, it probably is, you should be aware of a few differences between working on your personal computer and working on a system like this. In this note, we will have a look at a few of the differences.

When you log into the cluster, two programs on two distinct computers are in play: the terminal you used to log in, running on your own computer, and the shell, running on the cluster's front-end computer.

Your terminal, and your computer, is not doing much in this interaction. When you type a command in the terminal, it merely sends that command to the shell at the other end, and when the shell reports back what happens, the terminal displays the results. Your computer, your programs, files and directories are not part of the interaction. You cannot access any of your local files from the cluster, and the cluster cannot write files to your computer's disks either. If you want to move data to or from the cluster, you have to explicitly do this, but we will return to this later.

All you have is a terminal that you can use to send commands and see the results, but otherwise your own computer is not part of the picture.

**FIXME: an illustration here**

When you are on the cluster, you have an entirely different file system at your disposal. Most of it you cannot see, though; users are protected from each other, and there are limits to which part of the file system that you can access. On the cluster, many projects operate on confidential and restricted data, so the system is set up such that all files are hidden from other users by default, and [you have to explicitly set up project directories accessible by multiple users](https://genome.au.dk/docs/projects-and-accounting) if you plan to collaborate.

**FIXME: will there be one for the class?**

**FIXME**

- Your machine, connected to the front-end.
- Communicating with the front-end:
  - A terminal (now a program) sending, receiving and displaying text.
  - A shell at the other end, handing your commands and returning replies.
  - `ssh` as the (secure shell) connection between your terminal and the shell at the cluster.
- Computing nodes behind the front-end.
- Your files and the (shared) file system on the cluster.

Somewhere here, set up ssh between frontend and nodes

  Now, set up public-key access to all compute nodes. On the frontend, run the same ssh-keygen command as before:

  [fe-open-01]$ ssh-keygen
  Again, just press Enter to use the default values (and do not type in a password). Then run:

  [fe-open-01]$ cat ~/.ssh/id_rsa.pub >> authorized_keys
  You will now be able to SSH between compute nodes without typing a password.
