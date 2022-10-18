# Cluster architecture

- Your machine, connected to the front-end.
- Communicating with the front-end:
  - A terminal (now a program) sending, receiving and displaying text.
  - A shell at the other end, handing your commands and returning replies.
  - `ssh` as the (secure shell) connection between your terminal and the shell at the cluster.
- Computing nodes behind the front-end.
- Your files and the (shared) file system on the cluster.
