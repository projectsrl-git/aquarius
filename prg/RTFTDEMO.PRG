CLOSE ALL
CLEAR ALL
tSafety = SET("safety") &&Store SET status of Safety to a variable
SET SAFETY OFF &&Check to see if the Dcolor table exists
IF FILE("dcolor.dbf")
 USE dcolor EXCLUSIVE
ELSE
 CREATE TABLE dcolor (dcolor c(20),gcolor g) &&Create and add records if DColor table doesn't exist
 INSERT INTO dcolor (dcolor) VALUES ("Red")
 INSERT INTO dcolor (dcolor) VALUES ("Green")
 INSERT INTO dcolor (dcolor) VALUES ("Blue")
 INSERT INTO dcolor (dcolor) VALUES ("Purple")
 INSERT INTO dcolor (dcolor) VALUES ("Orange")
 INSERT INTO dcolor (dcolor) VALUES ("Yellow")
ENDIF
_rtfFile = SYS(3)+".rtf" &&Create a legal file name with a .RTF extension
*NOTE: The file must have a .RTF extension to work properly
SCAN &&Create a Richtext OLE bound control in the general field of the dColor table
 SET TEXTMERGE TO &_rtfFile NOSHOW
 SET TEXTMERGE ON
 *!!IMPORTANT!! The following richtext formatting line(s) need to be         *included as one line in your program.
         \\{\rtf1\ansi\ansicpg1252\deff0\deflang1033{\fonttbl{\f0\fnil\fcharset0 Times New Roman;}}\viewkind4\uc1\pard\f0\fs20 The big \ul <<ALLT(dcolor.dcolor)>>\ulnone  dog\par}
 SET TEXTMERGE TO
 APPEND GENERAL gcolor FROM &_rtfFile LINK CLASS "RICHTEXT.RICHTEXTCTRL.1"
ENDSCAN
SET SAFETY &tSafety
ERASE &_rtfFile

REPORT FORM REPORT\rtfdemo PREVIEW NOCONSOLE
USE
CLOSE ALL