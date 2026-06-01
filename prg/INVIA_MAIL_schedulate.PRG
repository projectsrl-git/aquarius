

*!*	##############################################################################################################

					**********************************************************************************************
					***         PROJECT SRL - PROGRAMMA PER L'INVIO AUTOMATICO DELLE EMAIL SCHEDULATE          ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################




PARAMETERS _X_ERRORE,_X_FILENAME,_X_EMAIL,_X_CORPO2

IF PCOUNT()=0
    _X_FILENAME = ""
	_X_ERRORE   = .F.
	_X_EMAIL    = ""
ENDIF

**=> ERASMO - INIZIO 24/02/2020
IF PCOUNT() < 4
	_X_CORPO2 = ""
ENDIF
**=> ERASMO - FINE 24/02/2020

DO PRG\STARTSET


_DATA_FINE = DTOC(DATE())
_ORA_FINE = TIME()

_INVIA_MAIL_NOTIFICA 		= legge_config("aq_scheduler_config.cfg","INVIA_MAIL_NOTIFICA")
IF _INVIA_MAIL_NOTIFICA <>"SI"
	RETURN
ENDIF

_PATH_EMAIL	= legge_config("aq_scheduler_config.cfg","PATH_EMAIL")
IF EMPTY(_PATH_EMAIL)
	WAIT WINDOW "PATH EMAIL NON DEFINITO IN aq_scheduler_config.cfg" TIMEOUT 3
	RETURN
ENDIF

IF !EMPTY(ALLTRIM(_X_FILENAME))  && ERASMO - 09/01/2025
	DIMENSION _ARRAY_X_FILENAME [1] && any size.. will be redimensioned to fit
	lnRows = Split(@_ARRAY_X_FILENAME , ALLTRIM(_X_FILENAME), ';' )

	_X_FILENAME =""
	FOR i = 1 TO lnRows 
		IF i>1
			_X_FILENAME =_X_FILENAME +";"
		ENDIF
		
		_X_FILENAME =_X_FILENAME +ALLTRIM(_PATH_EMAIL) + "\" + ALLTRIM(_ARRAY_X_FILENAME [i])
	NEXT
ENDIF

*!*	_X_FILENAME =ALLTRIM(_PATH_EMAIL) + "\" + ALLTRIM(_ARRAY_X_FILENAME )
_MITTENTE 		= legge_config("aq_scheduler_config.cfg","MITTENTE")
_MITTENTE ="aquarius-scheduler@projectsrl.net"
IF EMPTY(_MITTENTE)
	WAIT WINDOW "MITTENTE NON DEFINITO IN aq_scheduler_config.cfg" NOWAIT
	RETURN
ENDIF

*!*	_SMTP ="smtp.projectsrl.net"
*!*	_USERNAME="noreply@projectsrl.net"
*!*	_PASSWORD="automatica"
*!*	_OGGETTO_SUCCESSO="ERP Aquatius - Schedulatore report"
*!*	_OGGETTO_ERRORE ="ERP Aquarius "
*!*	_CORPO ="Questa e-mail è generata automaticamente dallo Schedulatore di report di Aquarius"
*!*	_MESSAGGIO="NESSUN SCRIPT ELABORATO"

_SMTP 			= legge_config("aq_scheduler_config.cfg","SMTP")
IF EMPTY(_SMTP )
	WAIT WINDOW "SMTP SERVER NON DEFINITO IN aq_scheduler_config.cfg" NOWAIT
	RETURN
ENDIF

_USERNAME		= legge_config("aq_scheduler_config.cfg","AUTH_USER")
IF EMPTY(_USERNAME)
	WAIT WINDOW "USERNAME NON DEFINITO IN aq_scheduler_config.cfg" NOWAIT
	RETURN
ENDIF

_PASSWORD		= legge_config("aq_scheduler_config.cfg","AUTH_PASS")
IF EMPTY(_PASSWORD)
	WAIT WINDOW "PASSWORD NON DEFINITA IN aq_scheduler_config.cfg" NOWAIT
	RETURN
ENDIF

_OGGETTO_SUCCESSO		= legge_config("aq_scheduler_config.cfg","OGGETTO_SUCCESSO")
IF EMPTY(_OGGETTO_SUCCESSO)
	WAIT WINDOW "OGGETTO SUCCSSO MAIL NON DEFINITO IN aq_scheduler_config.cfg" NOWAIT
	RETURN
ENDIF

_OGGETTO_ERRORE 		= legge_config("aq_scheduler_config.cfg","OGGETTO_ERRORE")
IF EMPTY(_OGGETTO_ERRORE )
	WAIT WINDOW "OGGETTO ERRORE MAIL NON DEFINITO IN aq_scheduler_config.cfg" NOWAIT
	RETURN
ENDIF

_CORPO 			= legge_config("aq_scheduler_config.cfg","CORPO")
IF EMPTY(_CORPO )
	WAIT WINDOW "CORPO MAIL NON DEFINITO IN aq_scheduler_config.cfg" NOWAIT
	RETURN
ENDIF

_MESSAGGIO		= legge_config("aq_scheduler_config.cfg","MESSAGGIO")
IF EMPTY(_MESSAGGIO)
	_MESSAGGIO = ""
ENDIF

**=> ERASMO - INIZIO 07/12/2018
_PORT = legge_config("aq_scheduler_config.cfg","PORT")
IF EMPTY(_PORT)
	WAIT WINDOW "PORTA NON DEFINITA IN aq_scheduler_config.cfg" NOWAIT
	RETURN
ENDIF

_CRYPTO = legge_config("aq_scheduler_config.cfg","CRYPTO")
IF EMPTY(_CRYPTO)
	_CRYPTO = ""
ENDIF

_NOTIFICATION = legge_config("aq_scheduler_config.cfg","NOTIFICATION")
IF EMPTY(_NOTIFICATION)
	_NOTIFICATION = ""
ENDIF

_BODY_HTML = ""

_NEEDCREDS = legge_config("aq_scheduler_config.cfg","NEEDCREDS")
IF EMPTY(_NEEDCREDS)
	_NEEDCREDS = ""
ENDIF

_USESSL = legge_config("aq_scheduler_config.cfg","USESSL")
IF EMPTY(_USESSL)
	_USESSL = ""
ENDIF
**=> ERASMO - FINE 07/12/2018

_DESTINATARI = ""
_CC = ""
_CCN = ""

IF "@" $ _X_EMAIL 

	_DESTINATARI = _X_EMAIL 
	_CCN 	= legge_config("aq_scheduler_config.cfg","DESTINATARI")

ELSE
	*!*	elaborazione email per identificare i destinatari
	x_cond  = "id_EMAIL = '" + _X_EMAIL + "'"							
	cSql   = "select * from email where " + x_cond  
	IF !ExecCommand(cSql,"CU_email_destinatari")
	   return(.f.)
	ENDIF

	SELECT CU_email_destinatari

	GO TOP

	DO WHILE !EOF()

	   	IF EMPTY(ALLTRIM(EMAIL))	
		   SELECT CU_email_destinatari
		   SKIP +1
		   LOOP
	    ENDIF
		
		IF PER = .T.
		   	IF EMPTY(ALLTRIM(_DESTINATARI))	
		   		_DESTINATARI = ALLTRIM(EMAIL) 
		   	ELSE
		   		*_DESTINATARI = _DESTINATARI + "," + ALLTRIM(EMAIL) 
		   		_DESTINATARI = _DESTINATARI + ";" + ALLTRIM(EMAIL)  && ERASMO - 15/02/2019
		   	ENDIF
	   	ENDIF
		
		IF CC = .T.
		   	IF EMPTY(ALLTRIM(_CC))	
		   		_CC = ALLTRIM(EMAIL) 
		   	ELSE
		   		*_CC = _CC + "," + ALLTRIM(EMAIL) 
		   		_CC = _CC + ";" + ALLTRIM(EMAIL)  && ERASMO - 15/02/2019
		   	ENDIF
	   	ENDIF

		IF CCN = .T.
		   	IF EMPTY(ALLTRIM(_CCN))	
		   		_CCN = ALLTRIM(EMAIL) 
		   	ELSE
		   		*_CCN = _CCN + "," + ALLTRIM(EMAIL) 
		   		_CCN = _CCN + ";" + ALLTRIM(EMAIL)  && ERASMO - 15/02/2019
		   	ENDIF
	   	ENDIF

	   	SELECT CU_email_destinatari
	   	SKIP +1
	      
	ENDDO 

ENDIF


IF _X_ERRORE 
	_OGGETTO=_OGGETTO_ERRORE
ELSE
	_OGGETTO=_OGGETTO_SUCCESSO
ENDIF


*WAIT WINDOWS "Elaborazione e-mail per " + ALLTRIM(_DESTINATARI) + " in corso..." TIMEOUT 3
WAIT WINDOWS "Elaborazione e-mail per " + SUBSTR(ALLTRIM(_DESTINATARI),1,150) + " ..." TIMEOUT 3  && ERASMO - 10/02/2016
_from    = ALLTRIM(_MITTENTE)
_to      = ALLTRIM(_DESTINATARI)
_subject = "Invio e-mail automatica: " + ALLTRIM(_OGGETTO)

*!*	IF EMPTY(ALLTRIM(_X_FILENAME))
*!*		_body    = ALLTRIM(_CORPO) + CHR(10) + CHR(10) + ;
*!*			"Esecuzione terminata il " + _DATA_FINE + " alle " + ALLTRIM(_ORA_FINE) + " -- "+_MESSAGGIO
*!*	ELSE
*!*		_body    = ALLTRIM(_CORPO) + CHR(10) + CHR(10) + ;
*!*			"Esecuzione terminata il " + _DATA_FINE + " alle " + ALLTRIM(_ORA_FINE)
*!*	ENDIF
_body = ALLTRIM(_CORPO) + CHR(10) + CHR(10) + "Esecuzione terminata il " + _DATA_FINE + " alle " + ALLTRIM(_ORA_FINE)  && ERASMO - 09/01/2025

**=> ERASMO - INIZIO 24/02/2020
IF !EMPTY(_X_CORPO2)
	_body = ALLTRIM(_body) + CHR(10) + CHR(10) + ALLTRIM(_X_CORPO2)
ENDIF
**=> ERASMO - FINE 24/02/2020

_attach  	= _X_FILENAME
_W_REPLYTO 	= ALLTRIM(_CC)
_W_CCN 		= ALLTRIM(_CCN)
_W_SMTP 	= ALLTRIM(_SMTP)
_W_USERNAME = ALLTRIM(_USERNAME)
_W_PASSWORD = ALLTRIM(_PASSWORD)

**=> ERASMO - INIZIO 07/12/2018
_W_PORT 		= ALLTRIM(_PORT)
_W_CRYPTO 		= ALLTRIM(_CRYPTO)
_W_NOTIFICATION = ALLTRIM(_NOTIFICATION)
_W_BODY_HTML	= ALLTRIM(_BODY_HTML)
_W_NEEDCREDS	= IIF('SI' $ ALLTRIM(_NEEDCREDS),.T.,.F.)
_W_USESSL 		= IIF('SI' $ ALLTRIM(_USESSL),.T.,.F.)
**=> ERASMO - FINE 07/12/2018

IF EMPTY(_from) .OR. EMPTY(_to) .OR. EMPTY(_subject) .OR. EMPTY(_body) .OR. EMPTY(_W_SMTP)
   *WAIT WINDOWS "Impossibile inviare e-mail a " + ALLTRIM(_DESTINATARI) + " -  Campi obbligatori: A, Oggetto e Messaggio" NOWAIT
   WAIT WINDOWS "Impossibile inviare e-mail a " + SUBSTR(ALLTRIM(_DESTINATARI),1,150) + " -  Campi obbligatori: A, Oggetto e Messaggio" NOWAIT  && ERASMO - 10/02/2016
ELSE
   _n_mails_sent = 0
   _sent = .F.
   _response = ""  && ERASMO - 02/08/2024
   *** UTILIZZO UNA NUOVA PROCEDURA PERCHE' QUELLA PRECEDENTE NON SUPPORTAVA L'AUTENTICAZIONE DEL SERVER
   *SET PROCEDURE TO PRG\SEND_NEW
   *=sendemail(_from,_to,_subject,_body,_attach,_W_REPLYTO,_W_SMTP,_W_USERNAME,_W_PASSWORD)
   
*!*	   *** UTILIZZO PROCEDURA ALTERNATIVA PERCHE' QUELLA CHE UTILIZZAVA IL FILE WINDOWS\SYSTEM32\MSWINSCK.OCX
*!*	   *** NON SEMPRE ERA APPLICABILE: QUESTA UTILIZZA UNA LIBRERIA PROPRIETARIA PRG\vfpWinSock.prg
*!*	   *** SET PROCEDURE TO PRG\SEND_VIA_vfpWinSock ADDITIVE
*!*	   DO SEND_VFPWINSOCK WITH _from,_to,_subject,_body,_attach,_W_REPLYTO,_W_SMTP,_W_USERNAME,_W_PASSWORD,_W_CCN
*!*	   *WAIT WINDOWS "Tentativo di invio e-mail per " + ALLTRIM(_DESTINATARI) + " effettuato correttamente" TIMEOUT 2
   
   *** RICHIAMO NUOVA PROCEDURA DI INVIO MAIL TRAMITE POWERSHELL (DA WIN 7 IN SU)
   *DO PRG\PS_SENDMAIL WITH _from,_to,_W_REPLYTO,_subject,_body,_attach,_W_CCN,_W_SMTP,_W_USERNAME,_W_PASSWORD,_W_PORT,_W_CRYPTO,_W_NOTIFICATION,_W_BODY_HTML,_W_NEEDCREDS,_W_USESSL  && ERASMO - 07/12/2018
   
*!*	   **=> ERASMO - INIZIO 17/07/2024
*!*	   DO INSERT_LOG_EMAIL WITH _sent
*!*	   **=> ERASMO - FINE 17/07/2024  
   *DO INSERT_LOG_EMAIL WITH _sent,_response  && ERASMO - 02/08/2024
   
   **=> ERASMO - INIZIO 05/08/2024
   *** ELABORO n TENTATIVI MAX DI INVIO FIN QUANDO NON OTTENGO ESITO POSITIVO
   _n_max_attempts = 3
   FOR _attempt = 1 TO _n_max_attempts
      _sent = .F.
      _response = ""
      DO PRG\PS_SENDMAIL WITH _from,_to,_W_REPLYTO,_subject,_body,_attach,_W_CCN,_W_SMTP,_W_USERNAME,_W_PASSWORD,_W_PORT,_W_CRYPTO,_W_NOTIFICATION,_W_BODY_HTML,_W_NEEDCREDS,_W_USESSL
      IF !_sent
         IF _attempt < _n_max_attempts
            LOOP
         ENDIF
      ENDIF
      IF _attempt > 1
         _response = ALLTRIM(_response) + IIF(EMPTY(ALLTRIM(_response)),"",CHR(13)+CHR(10)) + "(TENTATIVO N. " + ALLTRIM(STR(_attempt,10,0)) + ")"
      ENDIF
      DO INSERT_LOG_EMAIL WITH _sent,_response
      EXIT
   NEXT
   **=> ERASMO - FINE 05/08/2024
   
   WAIT WINDOWS "Tentativo di invio e-mail per " + SUBSTR(ALLTRIM(_DESTINATARI),1,150) + " effettuato correttamente" TIMEOUT 2  && ERASMO - 10/02/2016
ENDIF

WAIT CLEAR

RETURN




*********************************
PROCEDURE SEND_VFPWINSOCK
*********************************

PARAMETERS _X_FROM,_X_TO,_X_SUBJECT,_X_BODY,_X_ATTACH,_X_REPLYTO,_X_SMTP,_X_USERNAME,_X_PASSWORD,_X_CCN

SET PROCEDURE TO PRG\vfpwinsock_NOTIFICA_scheduler ADDITIVE

*_X_SMTP = o.Lire_Base_Registre("SMTP Server")
*_X_FROM = o.Lire_Base_Registre("SMTP Email Address")
*_X_NAME = o.Lire_Base_Registre("SMTP Display Name")
_X_NAME = ""
_X_TO_NAME = ""
_X_REPLYTO_NAME = ""
_X_CCI = _X_CCN
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
  *_X_SOURCE=_X_SOURCE + [loSendMail.TO = "]+ALLTRIM(_X_TO)+["]+ _crlf
  **=> ERASMO - INIZIO 20/06/2017
  _X_TO = ALLTRIM(_X_TO)
  IF LEN(_X_TO) <= 230
	  _X_SOURCE=_X_SOURCE + [loSendMail.TO = "]+ALLTRIM(_X_TO)+["]+ _crlf
  ELSE
    _X_SOURCE=_X_SOURCE + [loSendMail.TO = "]+SUBSTR(_X_TO,1,230)+["]
    FOR I_ = 1 TO INT(LEN(_X_TO)/230)
    	_X_SOURCE=_X_SOURCE + [+;] + _crlf + [  "] + SUBSTR(_X_TO,(230*I_)+1,230)+["]
    ENDFOR
    _X_SOURCE=_X_SOURCE+_crlf 
  ENDIF
  **=> ERASMO - FINE 20/06/2017
    
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
  _X_SOURCE=_X_SOURCE + [  WAIT WINDOWS loSendMail.erreur TIMEOUT 2 ]+ _crlf
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

**=> ERASMO - INIZIO 17/07/2024
*********************************
PROCEDURE INSERT_LOG_EMAIL
*********************************
*PARAMETERS _PAR_SENT
**=> ERASMO - INIZIO 02/08/2024
PARAMETERS _PAR_SENT,_PAR_RESPONSE

IF PCOUNT() >= 1
ELSE
	_PAR_SENT = .F.
ENDIF

IF PCOUNT() >= 2
ELSE
	_PAR_RESPONSE = ""
ENDIF
**=> ERASMO - FINE 02/08/2024

_l_tipdoc = "SCH"
_l_numdoc = ""
_l_datdoc = ""
_l_codcli = ""
_l_ragsoc = ""
_l_ind_mittente = _from
_l_ind_email = _to
_l_ind_emailcc = _W_REPLYTO
_l_ind_emailcn = _W_CCN
_l_oggetto = _subject
_l_messaggio = _body
_l_allegato = ""
_l_sent = _PAR_SENT

IF !EMPTY(ALLTRIM(_attach))
	_nr_allegati = OCCURS(";",_attach) + 1
	FOR I = 1 TO _nr_allegati
		_allegato_iesimo = STR_EXTRACT(_attach,";",I)
		_JF_NAME = JUSTFNAME(_allegato_iesimo)
		IF !EMPTY(_JF_NAME)
			_l_allegato = _allegato_iesimo
			*=LOG_EMAIL(_l_tipdoc,_l_numdoc,_l_datdoc,_l_codcli,_l_ragsoc,_l_ind_mittente,_l_ind_email,_l_ind_emailcc,_l_ind_emailcn,_l_oggetto,_l_messaggio,_l_allegato,_l_sent)
			=LOG_EMAIL(_l_tipdoc,_l_numdoc,_l_datdoc,_l_codcli,_l_ragsoc,_l_ind_mittente,_l_ind_email,_l_ind_emailcc,_l_ind_emailcn,_l_oggetto,_l_messaggio,_l_allegato,_l_sent,_PAR_RESPONSE)  && ERASMO - 02/08/2024
		ENDIF
	ENDFOR
ELSE
	*=LOG_EMAIL(_l_tipdoc,_l_numdoc,_l_datdoc,_l_codcli,_l_ragsoc,_l_ind_mittente,_l_ind_email,_l_ind_emailcc,_l_ind_emailcn,_l_oggetto,_l_messaggio,_l_allegato,_l_sent)
	=LOG_EMAIL(_l_tipdoc,_l_numdoc,_l_datdoc,_l_codcli,_l_ragsoc,_l_ind_mittente,_l_ind_email,_l_ind_emailcc,_l_ind_emailcn,_l_oggetto,_l_messaggio,_l_allegato,_l_sent,_PAR_RESPONSE)  && ERASMO - 02/08/2024
ENDIF

ENDPROC


**********************************************************************************************************************************************************************************************
FUNCTION LOG_EMAIL
**********************************************************************************************************************************************************************************************
*** REGISTRA UN LOG DEGLI INVII E-MAIL
**********************************************************************************************************************************************************************************************
*LPARAMETERS _par_tipdoc,_par_numdoc,_par_datdoc,_par_codcli,_par_ragsoc,_par_ind_mittente,_par_ind_email,_par_ind_emailcc,_par_ind_emailcn,_par_oggetto,_par_messaggio,_par_allegato,_par_sent
LPARAMETERS _par_tipdoc,_par_numdoc,_par_datdoc,_par_codcli,_par_ragsoc,_par_ind_mittente,_par_ind_email,_par_ind_emailcc,_par_ind_emailcn,_par_oggetto,_par_messaggio,_par_allegato,_par_sent,_par_response  && ERASMO - 02/08/2024

IF PCOUNT() < 12
	RETURN .F.
ENDIF

**=> ERASMO - INIZIO 02/08/2024
IF PCOUNT() >= 13
ELSE
	_par_sent = .F.
ENDIF

IF PCOUNT() >= 14
ELSE
	_par_response = ""
ENDIF
**=> ERASMO - FINE 02/08/2024

LOCAL _OLD_SELECT,l_Sql

_OLD_SELECT = SELECT()

l_Sql = "SELECT * FROM LOG_EMAIL WHERE 1=0"
IF !ExecRW(l_Sql,"LOG_EMAIL","R")
   RETURN .F.
ENDIF
SELECT LOG_EMAIL
APPEND BLANK

REPLACE TIPDOC WITH _par_tipdoc
REPLACE NUMDOC WITH _par_numdoc
REPLACE DATDOC WITH _par_datdoc
REPLACE CODCLI WITH _par_codcli
REPLACE RAGSOC WITH _par_ragsoc
REPLACE IND_MITTENTE WITH _par_ind_mittente
REPLACE IND_EMAIL WITH _par_ind_email
REPLACE IND_EMAILCC WITH _par_ind_emailcc
REPLACE IND_EMAILCN WITH _par_ind_emailcn
REPLACE OGGETTO WITH _par_oggetto
REPLACE MESSAGGIO WITH _par_messaggio
REPLACE ALLEGATO WITH _par_allegato
REPLACE SENT WITH _par_sent
REPLACE DATLOG WITH RIBALTA2(DTOC(DATE()))
REPLACE ORALOG WITH TIME()
REPLACE CODOPE WITH PUB_CODOPE
REPLACE NOMOPE WITH PUB_NOMOPE
REPLACE RESPONSE WITH _par_response  && ERASMO - 02/08/2024

IF !ExecRW(l_Sql,"LOG_EMAIL","W")
   return
ENDIF

SELECT(_OLD_SELECT)

RETURN .T.
**=> ERASMO - FINE 17/07/2024
