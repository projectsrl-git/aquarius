PARAMETERS _X_ERRORE,_X_FILENAME

IF PCOUNT()=0
	_X_ERRORE = .F.
	_X_FILENAME=""
ENDIF

DO PRG\STARTSET

_DATA_FINE = DTOC(DATE())
_ORA_FINE = TIME()

_INVIA_MAIL_NOTIFICA 		= legge_config("build_config.cfg","INVIA_MAIL_NOTIFICA")

IF _INVIA_MAIL_NOTIFICA <>"SI"
	RETURN
ENDIF

_MITTENTE 		= legge_config("build_config.cfg","MITTENTE")
IF EMPTY(_MITTENTE)
	WAIT WINDOW "MITTENTE NON DEFINITO IN build_config.cfg" NOWAIT
	RETURN
ENDIF

_SMTP 			= legge_config("build_config.cfg","SMTP")
IF EMPTY(_SMTP )
	WAIT WINDOW "SMTP SERVER NON DEFINITO IN build_config.cfg" NOWAIT
	RETURN
ENDIF

_USERNAME		= legge_config("build_config.cfg","AUTH_USER")
IF EMPTY(_USERNAME)
	WAIT WINDOW "USERNAME NON DEFINITO IN build_config.cfg" NOWAIT
	RETURN
ENDIF

_PASSWORD		= legge_config("build_config.cfg","AUTH_PASS")
IF EMPTY(_PASSWORD)
	WAIT WINDOW "PASSWORD NON DEFINITA IN build_config.cfg" NOWAIT
	RETURN
ENDIF

_OGGETTO_SUCCESSO		= legge_config("build_config.cfg","OGGETTO_SUCCESSO")
IF EMPTY(_OGGETTO_SUCCESSO)
	WAIT WINDOW "OGGETTO SUCCSSO MAIL NON DEFINITO IN build_config.cfg" NOWAIT
	RETURN
ENDIF

_OGGETTO_ERRORE 		= legge_config("build_config.cfg","OGGETTO_ERRORE")
IF EMPTY(_OGGETTO_ERRORE )
	WAIT WINDOW "OGGETTO ERRORE MAIL NON DEFINITO IN build_config.cfg" NOWAIT
	RETURN
ENDIF

_CORPO 			= legge_config("build_config.cfg","CORPO")
IF EMPTY(_CORPO )
	WAIT WINDOW "CORPO MAIL NON DEFINITO IN build_config.cfg" NOWAIT
	RETURN
ENDIF

_MESSAGGIO		= legge_config("build_config.cfg","MESSAGGIO")
IF EMPTY(_MESSAGGIO)
	_MESSAGGIO = ""
ENDIF

_DESTINATARI	= legge_config("build_config.cfg","DESTINATARI")
IF EMPTY(_DESTINATARI)
	WAIT WINDOW "DESTINATARI MAIL NON DEFINITI IN build_config.cfg" NOWAIT
	RETURN
ENDIF

IF _X_ERRORE 
	_OGGETTO=_OGGETTO_ERRORE
ELSE
	_OGGETTO=_OGGETTO_SUCCESSO
ENDIF


WAIT WINDOWS "Elaborazione e-mail per " + ALLTRIM(_DESTINATARI) + " in corso..." TIMEOUT 2
_from    = ALLTRIM(_MITTENTE)
_to      = ALLTRIM(_DESTINATARI)
_subject = "Invio e-mail automatica: " + ALLTRIM(_OGGETTO)

IF EMPTY(ALLTRIM(_X_FILENAME))
	_body    = ALLTRIM(_CORPO) + CHR(10) + CHR(10) + ;
		"Esecuzione terminata il " + _DATA_FINE + " alle " + ALLTRIM(_ORA_FINE) + " -- "+_MESSAGGIO
ELSE
	_body    = ALLTRIM(_CORPO) + CHR(10) + CHR(10) + ;
		"Esecuzione terminata il " + _DATA_FINE + " alle " + ALLTRIM(_ORA_FINE)
ENDIF
		
	
_attach  = _X_FILENAME
_W_REPLYTO = ALLTRIM(_MITTENTE)
_W_SMTP = ALLTRIM(_SMTP)
_W_USERNAME = ALLTRIM(_USERNAME)
_W_PASSWORD = ALLTRIM(_PASSWORD)
IF EMPTY(_from) .OR. EMPTY(_to) .OR. EMPTY(_subject) .OR. EMPTY(_body) .OR. EMPTY(_W_SMTP)
   WAIT WINDOWS "Impossibile inviare e-mail a " + ALLTRIM(_DESTINATARI) + " -  Campi obbligatori: A, Oggetto e Messaggio" NOWAIT
ELSE
   _n_mails_sent = 0
   _sent = .F.
   *** UTILIZZO UNA NUOVA PROCEDURA PERCHE' QUELLA PRECEDENTE NON SUPPORTAVA L'AUTENTICAZIONE DEL SERVER
   *SET PROCEDURE TO PRG\SEND_NEW
   *=sendemail(_from,_to,_subject,_body,_attach,_W_REPLYTO,_W_SMTP,_W_USERNAME,_W_PASSWORD)
   
   *** UTILIZZO PROCEDURA ALTERNATIVA PERCHE' QUELLA CHE UTILIZZAVA IL FILE WINDOWS\SYSTEM32\MSWINSCK.OCX
   *** NON SEMPRE ERA APPLICABILE: QUESTA UTILIZZA UNA LIBRERIA PROPRIETARIA PRG\vfpWinSock.prg
   *** SET PROCEDURE TO PRG\SEND_VIA_vfpWinSock ADDITIVE
   DO SEND_VFPWINSOCK WITH _from,_to,_subject,_body,_attach,_W_REPLYTO,_W_SMTP,_W_USERNAME,_W_PASSWORD
   WAIT WINDOWS "Tentativo di invio e-mail per " + ALLTRIM(_DESTINATARI) + " effettuato correttamente" TIMEOUT 2
ENDIF

WAIT CLEAR

RETURN




*********************************
PROCEDURE SEND_VFPWINSOCK
*********************************

PARAMETERS _X_FROM,_X_TO,_X_SUBJECT,_X_BODY,_X_ATTACH,_X_REPLYTO,_X_SMTP,_X_USERNAME,_X_PASSWORD

SET PROCEDURE TO PRG\vfpwinsock_NOTIFICA ADDITIVE

*_X_SMTP = o.Lire_Base_Registre("SMTP Server")
*_X_FROM = o.Lire_Base_Registre("SMTP Email Address")
*_X_NAME = o.Lire_Base_Registre("SMTP Display Name")
_X_NAME = ""
_X_TO_NAME = ""
_X_REPLYTO_NAME = ""
_X_CCI = ""
_X_DATA_MHTML = ""
_X_NOTIFICATION = .F.
_X_SILENCE = .F.
_X_PRIORITY = ""

*TEXT TO _X_BODY noshow
*Test
*Hello World
*ENDTEXT

*TEXT TO _X_BODY_HTML noshow
*<HTML>
*  <BODY>
*  Test<BR>
*  Hello <STRONG>World</STRONG>
*  </BODY>
*</HTML>
*ENDTEXT
_X_BODY_HTML = ""
_X_TRACEFILE = ADDBS(GETENV("temp")) + "VFPwinsock_TraceFile.txt"
_X_DEBUG = .F.
*_X_REGISTRY = 1  && Use Default Mail Account on this machine (OutlookExpress / Outlook)
_X_REGISTRY = 2  && Specify FROM, SMTP_HOST
_X_SOURCE = ""
DO MAKESOURCE

ExecScript(_X_SOURCE)

RETURN

*********************************
PROCEDURE MAKESOURCE
*********************************

#define _crlf CHR(13)+CHR(10)

_X_SOURCE=""
IF NOT EMPTY(_X_TO)
  _X_SOURCE=_X_SOURCE + [local loSendMail]+ _crlf
  _X_SOURCE=_X_SOURCE + [loSendMail=CREATEOBJECT("VFP_Winsock_Send_Mail")]+ _crlf

  IF _X_DEBUG
    IF NOT EMPTY(_X_TRACEFILE)
      _X_SOURCE=_X_SOURCE + [erase "] + ALLTRIM(_X_TRACEFILE) + ["] +_crlf
      _X_SOURCE=_X_SOURCE + [loSendMail.TraceFile = "]+ ALLTRIM(_X_TRACEFILE) +["]+ _crlf
    endif
  endif

  IF _X_REGISTRY=1
  ELSE
    IF NOT empty(_X_SMTP)
      _X_SOURCE=_X_SOURCE + [loSendMail.SMTP_Host = "]+ALLTRIM(_X_SMTP)+["]+ _crlf
    ENDIF
    IF NOT empty(_X_FROM)
      _X_SOURCE=_X_SOURCE + [loSendMail.FROM = "]+ALLTRIM(_X_FROM)+["]+ _crlf
    ENDIF
    IF NOT empty(_X_NAME)
      _X_SOURCE=_X_SOURCE + [loSendMail.FROM_NAME = "]+ALLTRIM(_X_NAME)+["]+ _crlf
    ENDIF
  ENDIF
  
  IF NOT empty(_X_USERNAME) AND NOT empty(_X_PASSWORD) 
    _X_SOURCE=_X_SOURCE + [loSendMail.AUTH_LOGIN = "]+ALLTRIM(_X_USERNAME)+["]+ _crlf
    _X_SOURCE=_X_SOURCE + [loSendMail.AUTH_PASSWORD = "]+ALLTRIM(_X_PASSWORD)+["]+ _crlf
  ENDIF
  _X_SOURCE=_X_SOURCE + [loSendMail.TO = "]+ALLTRIM(_X_TO)+["]+ _crlf
  IF NOT empty(_X_TO_NAME)
    _X_SOURCE=_X_SOURCE + [loSendMail.TO_NAME = "]+ALLTRIM(_X_TO_NAME)+["]+ _crlf
  ENDIF
  IF NOT empty(_X_REPLYTO)
    _X_SOURCE=_X_SOURCE + [loSendMail.CC = "]+ALLTRIM(_X_REPLYTO)+["]+ _crlf
  ENDIF
  IF NOT empty(_X_REPLYTO_NAME)
    _X_SOURCE=_X_SOURCE + [loSendMail.CC_NAME = "]+ALLTRIM(_X_REPLYTO_NAME)+["]+ _crlf
  ENDIF
  IF NOT empty(_X_CCI)
    _X_SOURCE=_X_SOURCE + [loSendMail.CCI = "]+ALLTRIM(_X_CCI)+["]+ _crlf
  ENDIF
  IF NOT empty(_X_SUBJECT)
    _X_SOURCE=_X_SOURCE + [loSendMail.Subject = "]+ALLTRIM(_X_SUBJECT)+["]+ _crlf
  ENDIF
  
  IF NOT empty(_X_DATA_MHTML)
    _X_SOURCE=_X_SOURCE + [loSendMail.DATA_MHTML = "]+ALLTRIM(_X_DATA_MHTML)+["]+ _crlf
  else    
    IF NOT empty(_X_BODY)
      _X_SOURCE=_X_SOURCE + [TEXT to loSendMail.MESSAGE noshow]+ _crlf
      _X_SOURCE=_X_SOURCE + _X_BODY + _crlf
      _X_SOURCE=_X_SOURCE + [ENDTEXT] + _crlf
    ENDIF
    IF NOT empty(_X_BODY_HTML)
      _X_SOURCE=_X_SOURCE + [TEXT to loSendMail.MessageHTML noshow]+ _crlf
      _X_SOURCE=_X_SOURCE + _X_BODY_HTML + _crlf
      _X_SOURCE=_X_SOURCE + [ENDTEXT] + _crlf
    ENDIF
  endif

  IF NOT empty(_X_ATTACH)
    _X_SOURCE=_X_SOURCE + [loSendMail.ATTACHMENT = "]+ALLTRIM(_X_ATTACH)+["]+ _crlf
  ENDIF

  IF _X_NOTIFICATION
    _X_SOURCE=_X_SOURCE + [loSendMail.Notification = .T. ]+ _crlf
  ENDIF
  IF _X_SILENCE
    _X_SOURCE=_X_SOURCE + [loSendMail.Silence = .T. ]+ _crlf
  ENDIF

  IF NOT EMPTY(_X_PRIORITY)
    _X_SOURCE=_X_SOURCE + [loSendMail.Priority = "] + _X_PRIORITY + ["]+ _crlf
  ENDIF

  _X_SOURCE=_X_SOURCE + [if not loSendMail.send() ]+ _crlf
  *_X_SOURCE=_X_SOURCE + [  =MESSAGEBOX(loSendMail.erreur,16,"Error") ]+ _crlf
  _X_SOURCE=_X_SOURCE + [  =WAIT WINDOWS loSendMail.erreur TIMEOUT 2 ]+ _crlf
  _X_SOURCE=_X_SOURCE + [endif]+ _crlf

  IF _X_DEBUG
    IF NOT EMPTY(_X_TRACEFILE)
      _X_SOURCE=_X_SOURCE + [if file("]+_X_TRACEFILE+[") ] + _crlf
      _X_SOURCE=_X_SOURCE + [  modify file "]+ ALLTRIM(_X_TRACEFILE) +["]+_crlf
      _X_SOURCE=_X_SOURCE + [endif]+ _crlf
    ENDIF
    _X_SOURCE=_X_SOURCE + [  modify file loSendMail.dump() ]+_crlf
  endif

  _X_SOURCE=_X_SOURCE + [loSendMail=.null.]+ _crlf
ENDIF

RETURN



