
PROCEDURE SEND_VFPWINSOCK

PARAMETERS _X_FROM,_X_TO,_X_REPLYTO,_X_SUBJECT,_X_BODY,_X_ATTACH,_X_CCI,_X_SMTP,_X_USERNAME,_X_PASSWORD,_X_PORT,_X_CRYPTO,_X_NOTIFICATION,_X_BODY_HTML

**=> ERASMO - INIZIO 31/05/2011
IF PCOUNT() >= 13
ELSE
	_X_NOTIFICATION = .F.
ENDIF

_ok_files = CHECK_ATTACHMENTS(_X_ATTACH)
IF _ok_files
ELSE
	WAIT WINDOWS "Allegati troppo grandi o non validi" TIMEOUT 2
	RETURN .F.
ENDIF
**=> ERASMO - FINE 31/05/2011

**=> ERASMO - INIZIO 16/06/2011
IF PCOUNT() >= 14
ELSE
	_X_BODY_HTML = ""
ENDIF
**=> ERASMO - FINE 16/06/2011

**=> ERASMO - INIZIO 20/03/2017
IF PUB_PSSENDMAIL
	*** RICHIAMO NUOVA PROCEDURA DI INVIO MAIL TRAMITE POWERSHELL (DA WIN 7 IN SU)
	DO PRG\PS_SENDMAIL WITH _X_FROM,_X_TO,_X_REPLYTO,_X_SUBJECT,_X_BODY,_X_ATTACH,_X_CCI,_X_SMTP,_X_USERNAME,_X_PASSWORD,_X_PORT,_X_CRYPTO,_X_NOTIFICATION,_X_BODY_HTML
	RETURN
ENDIF
**=> ERASMO - FINE 20/03/2017

*_X_SMTP = o.Lire_Base_Registre("SMTP Server")
*_X_FROM = o.Lire_Base_Registre("SMTP Email Address")
*_X_NAME = o.Lire_Base_Registre("SMTP Display Name")
*!*	IF !EMPTY(_X_CRYPTO)
*!*		_X_PORT= _X_PORT + " && " + _X_CRYPTO   
*!*	ELSE
*!*		_X_PORT = _X_PORT
*!*	ENDIF

*_X_PORT = '25' && per specificare una porta: 'porta' oppure 'porta && sicurezza' => esempio: '25' '487 && SSL'
_X_NAME = ""
_X_REPLYTO_NAME = ""
_X_DATA_MHTML = ""
*_X_NOTIFICATION = .F.
*_X_SILENCE = .F.
_X_SILENCE = .T.  && ERASMO - 31/05/2011
_X_PRIORITY = ""
_X_TO_NAME = ""

*!*	**=> ERASMO - INIZIO 20/06/2011
*!*	*** GESTISCO EVENTUALI IMMAGINI PRESENTI ALL'INTERNO DELLA FIRMA COME ALLEGATI
*!*	IF "<IMG " $ UPPER(_X_BODY_HTML)
*!*		CREATE CURSOR ATTCH_SIGN_FILES (NAME C(240), FULLNAME C(240), ID_FILE C(10))
*!*		INDEX ON FULLNAME TAG I_FULLNAME
*!*		_ESCI = .F.
*!*		_NFILE = 1
*!*		DO WHILE !_ESCI
*!*			_NEW_ID_FILE = SYS(2015)
*!*			_rgth_str = SUBSTR(_X_BODY_HTML,AT('src="',_X_BODY_HTML,_NFILE))
*!*			_sign_file_strn = SUBSTR(_rgth_str,1,AT('"',_rgth_str,2))
*!*			_signature_file = STRTRAN(STRTRAN(SUBSTR(_rgth_str,6,AT('"',_rgth_str,2)-6),'/','\'),'file:\\\','')
*!*			IF FILE(_signature_file)
*!*				_X_BODY_HTML = STRTRAN(_X_BODY_HTML,_sign_file_strn,'src="cid:'+_NEW_ID_FILE+'"',1,1)
*!*				SELECT ATTCH_SIGN_FILES
*!*				APPEND BLANK
*!*				REPLACE NAME WITH JUSTFNAME(_signature_file)
*!*				REPLACE FULLNAME WITH _signature_file
*!*				REPLACE ID_FILE WITH _NEW_ID_FILE
*!*				_X_ATTACH = IIF(EMPTY(_X_ATTACH),_signature_file,_X_ATTACH + " ; " + _signature_file)
*!*			ENDIF
*!*			IF OCCURS('src="',_rgth_str) > 1
*!*				_NFILE = _NFILE + 1
*!*			ELSE
*!*				_ESCI = .T.
*!*			ENDIF
*!*		ENDDO
*!*	ENDIF
*!*	**=> ERASMO - FINE 20/06/2011

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
*_X_BODY_HTML = ""
_X_TRACEFILE = ADDBS(GETENV("temp")) + "VFPwinsock_TraceFile.txt"
_X_DEBUG = .F.
*_X_REGISTRY = 1  && Use Default Mail Account on this machine (OutlookExpress / Outlook)
_X_REGISTRY = 2  && Specify FROM, SMTP_HOST
_X_SOURCE = ""
DO MAKESOURCE

ExecScript(_X_SOURCE)

**=> ERASMO - INIZIO 20/06/2011
IF USED("ATTCH_SIGN_FILES")
	SELECT ATTCH_SIGN_FILES
	USE
ENDIF
**=> ERASMO - FINE 20/06/2011

RETURN


PROCEDURE MAKESOURCE

#define _crlf CHR(13)+CHR(10)
_X_SOURCE=""
IF NOT EMPTY(_X_TO)
  _X_SOURCE=[set proc to PRG\vfpWinsock additive] + _crlf
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
    IF NOT empty(_X_SMTP)
	  IF NOT EMPTY(_X_CRYPTO)
	 	   _X_SOURCE=_X_SOURCE + [loSendMail.SMTP_Port = ]+_X_PORT + _X_CRYPTO + _crlf
	  ELSE
		   _X_SOURCE=_X_SOURCE + [loSendMail.SMTP_Port = ]+_X_PORT+ _crlf
	  ENDIF 
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
*  _X_REPLYTO = copia conoscenza
  IF NOT empty(_X_REPLYTO)
    _X_SOURCE=_X_SOURCE + [loSendMail.CC = "]+ALLTRIM(_X_REPLYTO)+["]+ _crlf
  ENDIF
  IF NOT empty(_X_REPLYTO_NAME)
    _X_SOURCE=_X_SOURCE + [loSendMail.CC_NAME = "]+ALLTRIM(_X_REPLYTO_NAME)+["]+ _crlf
  ENDIF
*  _X_CCI = copia conoscenza nascosta
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

*!*	  IF NOT empty(_X_ATTACH)
*!*	    _X_SOURCE=_X_SOURCE + [loSendMail.ATTACHMENT = "]+ALLTRIM(_X_ATTACH)+["]+ _crlf
*!*	  ENDIF
  
  **=> ERASMO - INIZIO 31/05/2011
  IF NOT empty(_X_ATTACH)
    _X_SOURCE=_X_SOURCE + [TEXT to loSendMail.ATTACHMENT noshow]+ _crlf
    _X_SOURCE=_X_SOURCE + _X_ATTACH + _crlf
    _X_SOURCE=_X_SOURCE + [ENDTEXT] + _crlf
  ENDIF
  **=> ERASMO - FINE 31/05/2011

  IF _X_NOTIFICATION
    _X_SOURCE=_X_SOURCE + [loSendMail.Notification = .T. ]+ _crlf
  ENDIF
  IF _X_SILENCE
    _X_SOURCE=_X_SOURCE + [loSendMail.Silence = .T. ]+ _crlf
  ENDIF

  IF NOT EMPTY(_X_PRIORITY)
    _X_SOURCE=_X_SOURCE + [loSendMail.Priority = "] + _X_PRIORITY + ["]+ _crlf
  ENDIF

  *_X_SOURCE=_X_SOURCE + [if not loSendMail.send() ]+ _crlf
  _X_SOURCE=_X_SOURCE + [if not loSendMail.sendF() ]+ _crlf  && ERASMO/FABIANO 31/05/2011
  *_X_SOURCE=_X_SOURCE + [  =MESSAGEBOX(loSendMail.erreur,16,"Error") ]+ _crlf
  _X_SOURCE=_X_SOURCE + [  WAIT WINDOWS loSendMail.erreur TIMEOUT 4 ]+ _crlf
  _X_SOURCE=_X_SOURCE + [else ]+ _crlf				&& ERASMO 31/05/2011
  _X_SOURCE=_X_SOURCE + [  _sent = .T. ]+ _crlf		&& ERASMO 31/05/2011
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


FUNCTION CHECK_ATTACHMENTS

LPARAMETERS _P_ALLEGATO

PUB_ATCMAX = 10000000

_v_ok_attach = .F.
_v_all_attach_size = 0

IF EMPTY(_P_ALLEGATO)
	_v_ok_attach = .T.
	RETURN _v_ok_attach
ELSE
	_nr_allegati = OCCURS(";",_P_ALLEGATO) + 1
	FOR I = 1 TO _nr_allegati
		_allegato_iesimo = STR_EXTRACT(_P_ALLEGATO,";",I)
		IF FILE(ALLTRIM(_allegato_iesimo))
			pnHandle = FOPEN(ALLTRIM(_allegato_iesimo))	&& Open file
			pnSize = FSEEK(pnHandle,0,2)				&& Determine file size, assign to pnSize
			=FCLOSE(pnHandle)							&& Close file
			_v_all_attach_size = _v_all_attach_size + pnSize 
		ELSE
			_v_ok_attach = .F.
			RETURN _v_ok_attach
		ENDIF
	ENDFOR
ENDIF

IF _v_all_attach_size > PUB_ATCMAX .AND. PUB_ATCMAX > 0
	_v_ok_attach = .F.
ELSE
	_v_ok_attach = .T.
ENDIF

RETURN _v_ok_attach
