*!*	Utmost blessings!
*!*	Philip

*P.S. The test code (for now):
LOCAL cDesktopPath, cSpecialFolder
nRec = RECNO('Visit')
cSpecialFolder = "Desktop"
WSHShell = CreateObject("WScript.Shell")
cDesktopPath = WSHShell.SpecialFolders(cSpecialFolder)
cDir = EVALUATE([cDesktopPath])
cEvents = ""
SELECT visit
nRec = RECNO('Visit')
LOCATE FOR visit.dos = DATE()
IF FOUND()
SCAN FOR !INLIST(Record," ") AND BETWEEN(visit.dos,DATE(),DATE()+7) && visit.dos = DATE()
cSubject = STRTRAN(ALLTRIM(last_name)+IIF(!EMPTY(First_name),"-"+ALLTRIM(First_name),""),",") && no commas allowed
cDate = Alltrim(Str(Month(visit.Dos))) +"-"+Alltrim(Str(Day(visit.Dos)))+"-"+Right(Str(Year(visit.Dos)),2)
cEvents = cEvents+CHR(13)+CHR(10)+cSubject+","+cDate+","+ALLTRIM(time)
ENDSCAN
ENDIF
GO nRec
STRTOFILE("Subject,Start date,Start time"+cEvents,cDir+"\To "+cDate+" DPW.csv")
ShellExecute(0,"Open","https://calendar.google.com","","",1)