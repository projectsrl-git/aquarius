
*!*	*******************************
*!*	*!* Example of using SendViaShell
*!*	*******************************
*!*	LOCAL lcTo, lcSubject, lcBody, lcCC, lcBCC, lcErrReturn
*!*	lcTo = "lestofante.m@libero.it"
*!*	lcSubject = "Hey Have You Tried VFP Email?"
*!*	lcBody = "Just wanted to let you know that VFP is pretty versatile" + CHR(13) + "and has a lot of ways to send email."
*!*	*lcCC = "someoneelse@anotherhost.com"
*!*	*lcBCC = "myboss@bosshost.com"

*!*	SendViaShell(@lcErrReturn, lcTo, lcSubject, lcBody, lcCC, lcBCC)

*!*	IF EMPTY(lcErrReturn)
*!*	  MESSAGEBOX("'" + lcSubject + "' opened successfullly.", 64, "Send email via Shell")
*!*	ELSE
*!*	  MESSAGEBOX("'" + lcSubject + "' failed to be sent.  Reason:" + CHR(13) + lcErrReturn, 64, "Send email via Shell")
*!*	ENDIF

*!*	*******************************************
*!*	PROCEDURE SendViaShell(tcReturn, tcTo, tcSubject, tcBody, tcCC, tcBCC)
*!*	*******************************************
*!*	  DECLARE INTEGER ShellExecute IN shell32.DLL ;
*!*	    INTEGER hwndWin, STRING cOperation, STRING cFile, ;
*!*	    STRING cParameters, STRING cDirectory, INTEGER nShowWin

*!*	  LOCAL lcCommand, lcCRLF

*!*	  TRY
*!*	    lcCRLF = "%0D%0A"
*!*	    *lcCommand = "mailto:" + tcTo + "?Subject=" + tcSubject + "&Body=" + STRTRAN(tcBody, CHR(13), lcCRLF)
*!*	    lcCommand = 'mailto:' + tcTo + '?Subject=' + tcSubject + '&Body=' + STRTRAN(tcBody, CHR(13), lcCRLF) + '&Attach=C:\PROVA.TXT'
*!*	*!*	    IF TYPE("tcCC") = "C"
*!*	*!*	      lcCommand = lcCommand + "&CC=" + tcCC
*!*	*!*	    ENDIF
*!*	*!*	    IF TYPE("tcBCC") = "C"
*!*	*!*	      lcCommand = lcCommand + "&BCC=" + tcBCC
*!*	*!*	    ENDIF
*!*	    IF LEN(lcCommand) > 2020 && should be 2048, but not on my system
*!*	      THROW "Mailto command is limited to 2048 bytes"
*!*	    ENDIF
*!*	    ShellExecute(0, "open", lcCommand, "", "", 1)
*!*	  CATCH TO loError
*!*	    tcReturn = [Error: ] + STR(loError.ERRORNO) + CHR(13) + ;
*!*	      [LineNo: ] + STR(loError.LINENO) + CHR(13) + ;
*!*	      [Message: ] + loError.MESSAGE + CHR(13) + ;
*!*	      [Procedure: ] + loError.PROCEDURE + CHR(13) + ;
*!*	      [Details: ] + loError.DETAILS + CHR(13) + ;
*!*	      [StackLevel: ] + STR(loError.STACKLEVEL) + CHR(13) + ;
*!*	      [LineContents: ] + loError.LINECONTENTS
*!*	  FINALLY
*!*	    CLEAR DLLS "ShellExecute"
*!*	  ENDTRY
*!*	ENDPROC


_act_dir = sys(5)+sys(2003)

MS = CREATEOBJECT( "MSMAPI.MAPISession" )
MS.NewSession = .t. 
MS.DownLoadMail = .f. 
MS.Signon()
IF (MS.SessionID > 0)
	MM= CREATEOBJECT( "MSMAPI.MAPIMessages" )
	MM.SessionID = MS.SessionID
	MM.Compose
	MM.RecipIndex = 0
	MM.RecipAddress ="lestofante.m@libero.it" 
	MM.MsgSubject ="pincopallino" 
	MM.MsgNoteText = "TestoMessaggio"
	MM.Send(0)
ENDIF

MS.SignOff

SET DEFAULT TO &_act_dir 

RETURN

