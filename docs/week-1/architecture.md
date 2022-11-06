# Cluster architecture

If this is your first trip into a UNIX cluster wonderland, and if you are reading this, it probably is, you should be aware of a few differences between working on your personal computer and working on a system like this. In this note, we will have a look at a few of the differences.

When you log into the cluster, two programs on two distinct computers are in play: the terminal you used to log in, running on your own computer, and the shell, running on the cluster's front-end computer.

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
