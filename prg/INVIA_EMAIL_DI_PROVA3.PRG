*******************************
*!* Example of using SendViaMAPI
*******************************
DIMENSION aryAttach(2)
aryAttach(1) = "C:\PROVA.txt" && change to an actual file that exists on your computer
*aryAttach(2) = "C:\attachment2.zip" && change to an actual file that exists on your computer

LOCAL lcTo, lcSubject, lcBody, lnCount, lcCC, lcBCC, lcUserName, lcPassword, llOpenEmail, lcErrReturn
lcTo = "lestofante.m@libero.it"
lcSubject = "Hey Have You Tried VFP Email?"
lcBody = "Just wanted to let you know that VFP is pretty versatile and has a lot of ways to send email."
lcCC = "lestofante.m@libero.it"
lcBCC = "lestofante.m@libero.it"
lcUserName = "emasiello@project-online.local" && my SMTP username
lcPassword = "Erm9791" && my SMTP password

*!* to automatically send email set llOpenEmail to .F.
llOpenEmail = .T. && Whether email is opened in MAPI-aware email client or not

SendViaMAPI(@lcErrReturn, lcTo, lcSubject, lcBody, @aryAttach, lcCC, lcBCC, lcUserName, lcPassword, llOpenEmail)

IF EMPTY(lcErrReturn)
 MESSAGEBOX("'" + lcSubject + "' sent successfullly.", 64, "Send email via MAPI")
ELSE
 MESSAGEBOX("'" + lcSubject + "' failed to be sent.  Reason:" + CHR(13) + lcErrReturn, 64, "Send email via MAPI")
ENDIF

*******************************************
PROCEDURE SendViaMAPI(tcReturn, tcTo, tcSubject, tcBody, taFiles, tcCC, tcBCC, tcUserName, tcPassword, tlOpenEmail)
*******************************************
 #DEFINE PRIMARY 1
 #DEFINE CARBON_COPY 2
 #DEFINE BLIND_CARBON_COPY 3

 LOCAL loSession, loMessages, lnAttachments, loError AS EXCEPTION, loErrorSend AS EXCEPTION

 tcReturn = ""

 TRY
  loSession = CREATEOBJECT( "MSMAPI.MAPISession" )
  IF TYPE("tcUserName") = "C"
   loSession.UserName = tcUserName
  ENDIF
  IF TYPE("tcPassword") = "C"
   loSession.PASSWORD = tcPassword
  ENDIF
  loSession.Signon()
  IF (loSession.SessionID > 0)
   loMessages = CREATEOBJECT( "MSMAPI.MAPIMessages" )
   loMessages.SessionID = loSession.SessionID
  ENDIF
  WITH loMessages
   .Compose()
   .RecipDisplayName = tcTo
   .RecipType = PRIMARY
   .ResolveName()
   IF TYPE("tcCC") = "C"
    .RecipIndex = .RecipCount
    .RecipDisplayName = tcCC
    .RecipType = CARBON_COPY
    .ResolveName()
   ENDIF
   IF TYPE("tcBCC") = "C"
    .RecipIndex = .RecipCount
    .RecipDisplayName = tcBCC
    .RecipType = BLIND_CARBON_COPY
    .ResolveName()
   ENDIF
   .MsgSubject = tcSubject
   .MsgNoteText = tcBody
   IF TYPE("taFiles", 1) = "A"
    lnAttachments = ALEN(taFiles)
    IF LEN(tcBody) < lnAttachments && Make sure body is large enough for attachments
     tcBody = PADR(tcBody, lnAttachments, " ")
    ENDIF
    FOR lnCountAttachments = 1 TO lnAttachments
     .AttachmentIndex = .AttachmentCount
     .AttachmentPosition = .AttachmentIndex
     .AttachmentName = JUSTFNAME(taFiles(lnCountAttachments))
     .AttachmentPathName = taFiles(lnCountAttachments)
    ENDFOR
   ENDIF
   TRY
    .SEND(tlOpenEmail)
   CATCH TO loErrorSend
    IF tlOpenEmail && Did user cancel the operation from their email client?
     tcReturn = "User cancelled sending of email."
    ELSE
     THROW loErrorSend
    ENDIF
   ENDTRY
  ENDWITH
  loSession.Signoff()
 CATCH TO loError
  tcReturn = [Error: ] + STR(loError.ERRORNO) + CHR(13) + ;
   [LineNo: ] + STR(loError.LINENO) + CHR(13) + ;
   [Message: ] + loError.MESSAGE + CHR(13) + ;
   [Procedure: ] + loError.PROCEDURE + CHR(13) + ;
   [Details: ] + loError.DETAILS + CHR(13) + ;
   [StackLevel: ] + STR(loError.STACKLEVEL) + CHR(13) + ;
   [LineContents: ] + loError.LINECONTENTS
 FINALLY
  STORE .NULL. TO loSession, loMessages
  RELEASE loSession, loMessages
 ENDTRY
ENDPROC