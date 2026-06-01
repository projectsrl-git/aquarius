*******************************
*!* Example of using SendViaWinExec
*******************************
LOCAL lcTo, lcSubject, lcBody, lcCC, lcBCC, lcErrReturn
lcTo = "lestofante.m@libero.it"
lcSubject = "Hey Have You Tried VFP Email?"
lcBody = "Just wanted to let you know that VFP is pretty versatile" + CHR(13) + "and has a lot of ways to send email."
lcCC = "lestofante.m@libero.it"
lcBCC = "lestofante.m@libero.it"

SendViaWinExec(@lcErrReturn, lcTo, lcSubject, lcBody, lcCC, lcBCC)

IF EMPTY(lcErrReturn)
  MESSAGEBOX("'" + lcSubject + "' opened successfullly.", 64, "Send email via WinExec")
ELSE
  MESSAGEBOX("'" + lcSubject + "' failed to be sent.  Reason:" + CHR(13) + lcErrReturn, 64, "Send email via WinExec")
ENDIF

*******************************************
PROCEDURE SendViaWinExec(tcReturn, tcTo, tcSubject, tcBody, tcCC, tcBCC)
*******************************************

DECLARE INTEGER WinExec IN kernel32 ;
    STRING lpCmdLine ,;
    INTEGER uCmdShow

  LOCAL lcCommand, lcCRLF
 
  TRY
    lcCRLF = "%0D%0A"
    lcCommand = ["C:\Program Files\Outlook Express\msimn.exe" /mailurl:mailto:] + tcTo + "?Subject=" + tcSubject + "&Body=" + STRTRAN(tcBody, CHR(13), lcCRLF)
    IF TYPE("tcCC") = "C"
      lcCommand = lcCommand + "&CC=" + tcCC
    ENDIF
    IF TYPE("tcBCC") = "C"
      lcCommand = lcCommand + "&BCC=" + tcBCC
    ENDIF
    IF LEN(lcCommand) > 32766 && should be 32768, but not on my system
      THROW "Mailto command is limited to 32768 bytes"
    ENDIF

 WinExec(lcCommand, 1)

  CATCH TO loError
    tcReturn = [Error: ] + STR(loError.ERRORNO) + CHR(13) + ;
      [LineNo: ] + STR(loError.LINENO) + CHR(13) + ;
      [Message: ] + loError.MESSAGE + CHR(13) + ;
      [Procedure: ] + loError.PROCEDURE + CHR(13) + ;
      [Details: ] + loError.DETAILS + CHR(13) + ;
      [StackLevel: ] + STR(loError.STACKLEVEL) + CHR(13) + ;
      [LineContents: ] + loError.LINECONTENTS
  FINALLY
    CLEAR DLLS "WinExec"
  ENDTRY
ENDPROC