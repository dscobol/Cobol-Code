A quick note about running GnuCOBOL and IBM DB2 for Linux, UNIX and Windows(LUW).

- On my PC, I have the original Windows user that was created when I first
  booted up the machine.
- I created a second "local" only user "dastagg" with Administrator rights that I log into 99% of the time.
- I used this local user to install all the software I use for this process.

There are two ways to install and use GnuCOBOL on Windows:
1. Cygwin
2. MingGW

I installed Cygwin64 and then compiled GnuCOBOL: *GnuCOBOL3.1-rc1* and all was working for normal batch programs.

However, when I tried to run DB2 programs, there were problems with LUW ver 11.5 and the Cygwin compiled version of GnuCOBOL.

What I needed to do to get them to work was uninstall LUW ver 11.5, install LUW 11.1 and then follow these
[instructions](https://sourceforge.net/p/gnucobol/discussion/contrib/thread/e6744ecf/?page=1&limit=25#88d9)

After adjusting the cmd files to my environment, I was then able to run COBOL/DB2 programs.

One more note.
It might be because the way I installed LUW(using a local account with Admin rights) but it automatically added my local userid and password to the DB as DBAdmin. So I am able to run the cmd files from a normal Windows Terminal.