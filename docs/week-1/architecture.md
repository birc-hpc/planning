# Cluster architecture

If this is your first trip into a UNIX cluster wonderland, and if you are reading this, it probably is, you should be aware of a few differences between working on your personal computer and working on a system like this. In this note, we will have a look at a few of the differences.

When you log into the cluster, two programs on two distinct computers are in play: the terminal you used to log in, running on your own computer, and the shell, running on the cluster's front-end computer.

Your terminal, and your computer, are not doing much in this interaction. When you type a command in the terminal, it merely sends that command to the shell at the other end, and when the shell reports back what happens, the terminal displays the results. Your computer, your programs, files and directories are not part of the interaction. You cannot access any of your local files from the cluster, and the cluster cannot write files to your computer's disks either. If you want to move data to or from the cluster, you have to do this explicitly, but we will return to this later.

All you have is a terminal that you can use to send commands and see the results, but otherwise, your own computer is not part of the picture.

**FIXME: an illustration here**

When you are on the cluster, you have an entirely different file system at your disposal. Most of it you cannot see, though; users are protected from each other, and there are limits to which part of the file system you can access. On the cluster, many projects operate on confidential and restricted data, so the system is set up such that all files are hidden from other users by default, and [you have to set up project directories accessible by multiple users explicitly](https://genome.au.dk/docs/projects-and-accounting) if you plan to collaborate.

**FIXME: will there be one for the class?**

Anyway, you are sitting at your computer, typing in commands in the terminal; these commands are then sent via `ssh` to the bash shell on the cluster's front end; the shell executes them and then sends the result back. Your computer and terminal are only there to show you what is going on at the other end, and everything that happens when you run programs happens at the cluster's end.

At that end, however, there are more computers than just the front end. A lot more. Which is why clusters are interesting. The front end is a powerful computer, likely much more powerful than your laptop, but alone it couldn't service all the jobs we want to run on the cluster. It doesn't have to, though, and if you treat it right, it shouldn't have to either.

The front end's only job is to work as an intermediate between you and the cluster proper, and the latter consists of a large array of powerful computers. If you run the command `gnodes` you will get a quick view of what is currently available to you.

```bash
~> gnodes

+- gpu - 36 cores & 384GB & 2 GPUs & max time 7-00:00:00 +
| s10n01  384G  .................................... ** |
| s10n02  256G  ..................................._ *G |
+-------------------------------------------------------+

+- normal - 36 cores & 384GB & max time 7-00:00:00 --+
| s05n01  384G                  DOWN                 |
| s05n02  384G                  DOWN                 |
| s05n03  384G                  DOWN                 |
| s05n04  352G  ....................________________ |
| s05n05  320G  ....________________________________ |
| s05n06  320G  ....________________________________ |
| s05n07  301G  ....__________________OOOOOOOOOOOOOO |
| s05n08  310G  ......_______________OOOOOOOOOOOOOOO |
| s05n09  128G  ..................................!! |
| s05n10  320G  ...........__________________OOOOOOO |
| s05n11  352G  ....................________________ |
| s05n12  320G  ....________________________________ |
| s05n13  370G  .............................OOOOOOO |
| s05n14  304G  ...________________________________O |
| s05n15  244G  ..................................!! |
| s05n16  312G  ...________________________________O |
| s05n17  202G  ...................!!!!!!!!!!!!!!!!! |
| s05n18    0G  _________OOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s05n19  320G  ....________________________________ |
| s05n20  384G                  DOWN                 |
+----------------------------------------------------+

+- normal - 64 cores & 503GB & max time 7-00:00:00 ------------------------------+
| s22n11  463G  .................................................OOOOOOOOOOOOOOO |
| s22n12  439G  ................................________________________________ |
| s22n13  458G  ..............................................________________OO |
| s22n14    0G  ________________________________________________________________ |
| s22n21  311G  ................_______________________________________OOOOOOOOO |
| s22n22  407G  ................_______________________________________________O |
| s22n23  439G  ................................________________________________ |
| s22n24  471G  ................................................________________ |
| s22n31  503G  ................................................................ |
| s22n32  503G  ................................................................ |
| s22n33  407G  ................________________________________________________ |
| s22n34    0G  ________________________________________________________________ |
| s22n41  407G  ................________________________________________________ |
| s22n42    0G  ________________________________________________OOOOOOOOOOOOOOOO |
| s22n43  503G                                DOWN                               |
| s22n44  471G  ................................................________________ |
| s22n51  439G  ................................________________________________ |
| s22n52  439G  ................................________________________________ |
| s22n53  503G  ................................................................ |
+--------------------------------------------------------------------------------+

+- short - 36 cores & 384GB & max time 12:00:00 -----+
| s05n16  312G  ...________________________________O |
| s05n17  202G  ...................!!!!!!!!!!!!!!!!! |
| s05n18    0G  _________OOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s05n19  320G  ....________________________________ |
| s05n20  384G                  DOWN                 |
| s05n21  384G                  DOWN                 |
| s05n22    0G  ___________________________OOOOOOOOO |
| s05n23    0G  ______________________OOOOOOOOOOOOOO |
| s05n24  384G                  DOWN                 |
| s05n25    0G  _______________OOOOOOOOOOOOOOOOOOOOO |
| s05n26    0G  _____________________OOOOOOOOOOOOOOO |
+----------------------------------------------------+

+- short - 64 cores & 503GB & max time 12:00:00 ---------------------------------+
| s21n11    0G  _____________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n12    0G  ______________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n13  503G                                DOWN                               |
| s21n14    0G  __________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n21  503G                                DOWN                               |
| s21n22  375G                                                              OOOO |
| s21n23    0G  _________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n24  479G  ..............................................................OO |
| s21n31    3G  ..............___OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n32    0G  _______________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n33    0G  _____________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n34    0G  ___________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n41    0G  _________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n42    0G  _______________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n43    0G  _____________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n44    0G  _____________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n51  353G  ..............................................................._ |
| s21n52  500G  ...............................................................O |
| s21n53  503G  ................................................................ |
| s21n54  439G  ............................................................____ |
| s21n61    5G  .....................OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n62  500G  ...............................................................O |
| s21n63  496G  ..............................................................OO |
| s21n64    0G  ___________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n71    0G  _________________________________________OOOOOOOOOOOOOOOOOOOOOOO |
| s21n72    0G  ________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n73    0G  _____________________________________OOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n74  503G                                DOWN                               |
| s21n81  503G  ................................................................ |
| s21n82  114G  ..________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n83    0G  ___________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n84    4G  ............______________________________OOOOOOOOOOOOOOOOOOOOOO |
| s21n91    3G  .............________________________OOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n92  479G  ..............................................................OO |
| s21n93    0G  ________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
| s21n94    0G  ___________________________OOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOOO |
+--------------------------------------------------------------------------------+
```


**FIXME**

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
