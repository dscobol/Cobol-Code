Because I am working through multiple Tutorials, I will describe the naming conventions I am using here.

As it is my intension to move each program from PC to ZOS, this will keep the tracking of the source code easier and since I am starting on the PC, it's better to just do this at the beginning.

['Beginning COBOL for Programmers' by Michael Coughlan](http://www.apress.com/9781430262534) :

My Source: BDS0X0Y

Where 0X is the chapter number and 0Y is the exercise number.

For example: Listing8-1.cbl becomes:

BDS0801.cbl

This code will be found at **gnuCobol:Tutorials:ABCFP**

[The Open Mainframe Project](https://www.openmainframeproject.org/projects/coboltrainingcourse) :

My Source : ODSXXXX

Where XXXX is as close as I can match with the original name.

For example: CBL0001.cobol becomes:

ODS0001.cbl

This code is located at both *gnuCobol and Mainframe*:**Tutorials:OMP**

[Enterprise COBOL For Business Application Programming](https://community.ibm.com/community/user/ibmz-and-linuxone/viewdocument/enterprise-cobol-for-business-appli?CommunityKey=b0dae4a8-74eb-44ac-86c7-90f3cd32909a&tab=librarydocuments)

This tutorial is more encompassing than the other tutorials so it makes for a more difficult renaming strategy.

It seems the cleanest way is to create a new member for each workshop.

My Source: WSXXX

Where XXX is the Workshop number, so Workshop 5.2 becomes WS52.cbl.

This code is located at both *gnuCobol and Mainframe*:**Tutorials:ECBAP**

A lot of the Workshops are modifying existing programs so the new member will just be that but in SCM to be able to restore the code if need be.

The FAV series of programs are created using my prefered structure, naming conventions etc. This includes FAVRPT and FAVRFP.

But, in any case, they will always be identified by the Workshop number.

The assignments and their status will be listed in README4.

