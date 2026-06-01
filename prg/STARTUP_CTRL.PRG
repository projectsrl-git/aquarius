
LPARAMETERS _TIPO_ELABORAZIONE

*** PARAMETRO PASSATO 
*** _TIPO_ELABORAZIONE = "M" ...............Elaborazione con selezione date manuale (è possibile anche modificare i parametri di esecuzione)
*** _TIPO_ELABORAZIONE = "A" ...............Elaborazione con selezione date automatica (data del giorno attuale)

*ON SHUTDOWN QUIT
_OLD_SCREEN_Visible = _SCREEN.Visible
_SCREEN.Visible = .F. && (SI PUO' UTILIZZARE IL PARAMETRO "SCREEN=OFF" NEL FILE config.fpw, MA SOLO SE SI USA UN PROGETTO A PARTE, AL DI FUORI DA AQUARIUS)

IF PARAMETERS() = 0
	_TIPO_ELABORAZIONE = "M"
ENDIF

IF _TIPO_ELABORAZIONE != "M" .AND. _TIPO_ELABORAZIONE != "A"
	_TIPO_ELABORAZIONE = "M"
ENDIF

SET PROCEDURE TO PRG\SQLLIB_CTRL ADDITIVE
SET PROCEDURE TO PRG\WINLIB ADDITIVE
SET PROCEDURE TO PRG\CTRLLIB ADDITIVE
SET PROCEDURE TO PRG\AQMLIB ADDITIVE
SET PROCEDURE TO PRG\SEND_VIA_vfpWinSock ADDITIVE

SET PROCEDURE TO PRG\DISTINTA_BASE_LIB	ADDITIVE  && ERASMO - 19/10/2012
SET PROCEDURE TO PRG\LOCAZIONILIB		ADDITIVE  && ERASMO - 13/12/2012

*ON ERROR DO MSG_EXIT_PROCEDURE

DO PRG\STARTSET

PUBLIC PUB_DATLOG
PUBLIC PUB_ORALOG
PUB_DATLOG = RIBALTA2(DTOC(DATE()))
PUB_ORALOG = TIME()

PUBLIC pub_sqlhd
pub_sqlhd = 0

*WAIT WINDOWS "Connessione al DB di Origine dati in corso..." NOWAIT
IF !ExecConnect()
	WAIT WINDOWS "Si sono verificati dei problemi di connessione al DB di Origine dati" TIMEOUT 2
	return(.f.)
ENDIF

PUBLIC PUB_CODSOC
PUB_CODSOC = "01"
*PUBLIC PUB_TOT_TT,PUB_TOT_DD,PUB_TOTLOG,PUB_MOVLOG,PUB_IMPLOG,PUB_MOGLOG,PUB_WRTLOG
PUBLIC PUB_TOT_TT,PUB_TOT_DD,PUB_TOTLOG,PUB_MOVLOG,PUB_IMPLOG,PUB_PRZLOG,PUB_MOGLOG,PUB_WRTLOG  && ERASMO - 29/04/2011
PUB_TOT_TT = 0
PUB_TOT_DD = 0
PUB_TOTLOG = 0
PUB_MOVLOG = 0
PUB_IMPLOG = 0
PUB_PRZLOG = 0  && ERASMO - 29/04/2011
PUB_MOGLOG = 0
PUB_WRTLOG = 0

_LCTRLMOV = .F.
_NCTRLMOV = 1	&& ERASMO - 13/05/2011
_LCTRLIMP = .F.
_NCTRLIMP = 1
_LCTRLPRZ = .F.	&& ERASMO - 29/04/2011
_NCTRLPRZ = 1	&& ERASMO - 29/04/2011
_LCTRLMOG = .F.
_LCTRLWRT = .F.
_LCTRLEMAIL = .F.
IF !USED("PARAMETRI_ESECUZIONE_CONTROLLO_GIACENZE")
   USE PARAMETRI_ESECUZIONE_CONTROLLO_GIACENZE IN 0 AGAIN
ENDIF
SELECT PARAMETRI_ESECUZIONE_CONTROLLO_GIACENZE
SET FILTER TO
SET FILTER TO !DELETED()
GO TOP
IF EOF()
	APPEND BLANK
ELSE
	_LCTRLMOV = LCTRLMOV
	_NCTRLMOV = NCTRLMOV  && ERASMO - 13/05/2011
	_LCTRLIMP = LCTRLIMP
	_NCTRLIMP = NCTRLIMP
	_LCTRLPRZ = LCTRLPRZ  && ERASMO - 29/04/2011
	_NCTRLPRZ = NCTRLPRZ  && ERASMO - 29/04/2011
	_LCTRLMOG = LCTRLMOG
	_LCTRLWRT = LCTRLWRT
	_LCTRLEMAIL = LCTRLEMAIL
ENDIF

**=> ERASMO - INIZIO 29/04/2011
IF _NCTRLIMP <= 0
	_NCTRLIMP = 1
ENDIF
IF _NCTRLPRZ <= 0
	_NCTRLPRZ = 1
ENDIF
**=> ERASMO - FINE 29/04/2011

_MITTENTE 	= ""
_SMTP 		= ""
_AUTH_USER	= ""
_AUTH_PASS	= ""
_OGGETTO 	= ""
_CORPO 		= ""
_LOG_INDIRI	= ""
IF !USED("PARAMETRI_EMAIL_CONTROLLO_GIACENZE")
   USE PARAMETRI_EMAIL_CONTROLLO_GIACENZE IN 0 AGAIN
ENDIF
SELECT PARAMETRI_EMAIL_CONTROLLO_GIACENZE
SET FILTER TO
SET FILTER TO !DELETED()
GO TOP
IF EOF()
	APPEND BLANK
ELSE
	_MITTENTE 	= MITTENTE
	_SMTP 		= SMTP
	_AUTH_USER	= AUTH_USER
	_AUTH_PASS	= AUTH_PASS
	_OGGETTO 	= OGGETTO
	_CORPO 		= CORPO
	_LOG_INDIRI	= LOG_INDIRI
ENDIF

_CODCLI = ""
_DATADA = RIBALTA2(DTOC(DATE()))
_DATAA  = RIBALTA2(DTOC(DATE()))
IF _TIPO_ELABORAZIONE = "M"
	_V_DATADA = RIBALTA2(_DATADA)
	_V_DATAAL = RIBALTA2(_DATAA)
	_CRETURN1 = _V_DATADA
	_CRETURN2 = _V_DATAAL
	_CONTINUA=PJ_INPUTDATE_CTRL("Data ddt DAL","Data ddt AL",;
		"Controllo giacenze e movimenti - selezione date DDT",_CRETURN1,_CRETURN2)
	
	SELECT PARAMETRI_ESECUZIONE_CONTROLLO_GIACENZE
	REPLACE LCTRLMOV WITH _LCTRLMOV
	REPLACE NCTRLMOV WITH _NCTRLMOV  && ERASMO - 13/05/2011
	REPLACE LCTRLIMP WITH _LCTRLIMP
	REPLACE NCTRLIMP WITH _NCTRLIMP
	REPLACE LCTRLPRZ WITH _LCTRLPRZ  && ERASMO - 29/04/2011
	REPLACE NCTRLPRZ WITH _NCTRLPRZ  && ERASMO - 29/04/2011
	REPLACE LCTRLMOG WITH _LCTRLMOG
	REPLACE LCTRLWRT WITH _LCTRLWRT
	REPLACE LCTRLEMAIL WITH _LCTRLEMAIL
	USE
	
	SELECT PARAMETRI_EMAIL_CONTROLLO_GIACENZE
	REPLACE MITTENTE WITH _MITTENTE 
	REPLACE SMTP WITH _SMTP 
	REPLACE AUTH_USER WITH _AUTH_USER
	REPLACE AUTH_PASS WITH _AUTH_PASS
	REPLACE OGGETTO WITH _OGGETTO 
	REPLACE CORPO WITH _CORPO 
	REPLACE LOG_INDIRI WITH _LOG_INDIRI
	USE
	
	IF _CONTINUA
	ELSE
		RETURN
	ENDIF
	_V_DATADA = _CRETURN1
	_V_DATAAL = _CRETURN2

	IF EMPTY(ALLTRIM(_V_DATADA))
		MESSAGEBOX("Operazione annullata",48,"Informazione")
		RETURN
	ENDIF
	IF EMPTY(ALLTRIM(_V_DATADA)) .OR. _V_DATADA = '  /  /    '
		MESSAGEBOX("Data elaborazione DAL obbligatoria",16,"Attenzione")
		RETURN
	ENDIF
	IF VALID_DATA(_V_DATADA)
	ELSE
		MESSAGEBOX("Data elaborazione DAL non valida",16,"Attenzione")
		RETURN
	ENDIF
	_V_DATADA = OK_DATA(_V_DATADA)
	
	IF EMPTY(ALLTRIM(_V_DATAAL))
		MESSAGEBOX("Operazione annullata",48,"Informazione")
		RETURN
	ENDIF
	IF EMPTY(ALLTRIM(_V_DATAAL)) .OR. _V_DATAAL = '  /  /    '
		MESSAGEBOX("Data elaborazione AL obbligatoria",16,"Attenzione")
		RETURN
	ENDIF
	IF VALID_DATA(_V_DATAAL)
	ELSE
		MESSAGEBOX("Data elaborazione AL non valida",16,"Attenzione")
		RETURN
	ENDIF
	_V_DATAAL = OK_DATA(_V_DATAAL)
	
	_DATADA = RIBALTA2(_V_DATADA)
	_DATAA  = RIBALTA2(_V_DATAAL)
ENDIF

IF _LCTRLMOV
	WAIT WINDOWS "Controllo esistenza e corrispondenza quantità Movimenti in funzione dei dettagli DDT in corso..." NOWAIT
	*=VERIFICA_SPEDITO_CON_MAGAZZINO(_CODCLI,_DATADA,_DATAA)
	=VERIFICA_SPEDITO_CON_MAGAZZINO(_CODCLI,_DATADA,_DATAA,_NCTRLMOV)  && ERASMO - 13/05/2011
ENDIF

IF _LCTRLIMP
	WAIT WINDOWS "Controllo quantità impegnata in giacenze per gli articoli in dettagli DDT in corso..." NOWAIT
	=VERIFICA_SPEDITO_CON_IMPEGNATO(_CODCLI,_DATADA,_DATAA,_NCTRLIMP)
ENDIF

**=> ERASMO - INIZIO 29/04/2011
IF _LCTRLPRZ
	WAIT WINDOWS "Controllo prezzo di costo in movimenti per gli articoli in dettagli DDT in corso..." NOWAIT
	=VERIFICA_SPEDITO_CON_PREZZO_DI_COSTO(_CODCLI,_DATADA,_DATAA,_NCTRLPRZ)
ENDIF
**=> ERASMO - FINE 29/04/2011

IF _LCTRLMOG
	WAIT WINDOWS "Controllo quadratura saldo movimenti con giacenze per gli articoli in dettagli DDT in corso..." NOWAIT
	=VERIFICA_SPEDITO_CON_MOVIMENTI_GIACENZE(_CODCLI,_DATADA,_DATAA)
ENDIF

_DATA_FINE = DTOC(DATE())
_ORA_FINE = TIME()

IF !USED("PARAMETRI_EMAIL_CONTROLLO_GIACENZE")
   USE PARAMETRI_EMAIL_CONTROLLO_GIACENZE IN 0 AGAIN
ENDIF
SELECT PARAMETRI_EMAIL_CONTROLLO_GIACENZE
SET FILTER TO
SET FILTER TO !DELETED()
GO TOP
IF EOF()
ELSE
	IF _LCTRLEMAIL
		_MITTENTE 	= MITTENTE
		_SMTP 		= SMTP
		_USERNAME	= AUTH_USER
		_PASSWORD	= AUTH_PASS
		_OGGETTO 	= OGGETTO
		_CORPO 		= CORPO
		_LOG_INDIRI	= LOG_INDIRI

		WAIT WINDOWS "Elaborazione e-mail per " + ALLTRIM(_LOG_INDIRI) + " in corso..." NOWAIT
		_from    = ALLTRIM(_MITTENTE)
		_to      = ALLTRIM(_LOG_INDIRI)
		_cc      = ""
		_subject = "Invio e-mail automatica: " + ALLTRIM(_OGGETTO)
		_body    = ALLTRIM(_CORPO) + CHR(10) + CHR(10) + ;
			"Elaborazione effettuata il " + RIBALTA2(PUB_DATLOG) + " alle " + ALLTRIM(PUB_ORALOG) + ;
			" e terminata il " + _DATA_FINE + " alle " + ALLTRIM(_ORA_FINE) + CHR(10) + CHR(10) + ;
			"Date elaborazione DDT dal " + RIBALTA2(_DATADA) + " al " + RIBALTA2(_DATAA) + CHR(10) + CHR(10) + ;
			"Totale testate DDT elaborate: " + ALLTRIM(STR(PUB_TOT_TT,10,0)) + " - Totale dettagli DDT elaborati: " + ALLTRIM(STR(PUB_TOT_DD,10,0)) + CHR(10) + CHR(10) + ;
			"Tipi di elaborazione effettuati:"
		*IF _LCTRLMOV .OR. _LCTRLIMP .OR. _LCTRLMOG .OR. _LCTRLWRT
		IF _LCTRLMOV .OR. _LCTRLIMP .OR. _LCTRLPRZ .OR. _LCTRLMOG .OR. _LCTRLWRT  && ERASMO - 29/04/2011
			*IF _LCTRLMOV
			*	_body = _body + CHR(10) + "   - Controllo esistenza e corrispondenza quantità Movimenti in funzione dei dettagli DDT"
			*	_body = _body + CHR(10) + "     Anomalie rilevate: " + ALLTRIM(STR(PUB_MOVLOG,10,0))
			*ENDIF
			**=> ERASMO - INIZIO 13/05/2011
			IF _LCTRLMOV
				_body = _body + CHR(10) + "   - Controllo esistenza e corrispondenza quantità Movimenti in funzione dei dettagli DDT"
				IF _NCTRLMOV = 2
					_body = _body + " con aggiornamento quantità in movimenti rispetto ai dettagli DDT (solo dettagli DDT con corrispondenza 1 a 1)"
				ENDIF
				_body = _body + CHR(10) + "     Anomalie rilevate: " + ALLTRIM(STR(PUB_MOVLOG,10,0))
			ENDIF
			**=> ERASMO - FINE 13/05/2011
			IF _LCTRLIMP
				_body = _body + CHR(10) + "   - Controllo quantità impegnata in giacenze per gli articoli in dettagli DDT"
				IF _NCTRLIMP = 2
					_body = _body + " con ricalcolo qtà impegnata in giacenze rispetto alle packing list"
				ENDIF
				_body = _body + CHR(10) + "     Anomalie rilevate: " + ALLTRIM(STR(PUB_IMPLOG,10,0))
			ENDIF
			**=> ERASMO - INIZIO 29/04/2011
			IF _LCTRLPRZ
				_body = _body + CHR(10) + "   - Controllo prezzo di costo in movimenti per gli articoli in dettagli DDT"
				IF _NCTRLPRZ = 2
					_body = _body + " con aggiornamento prezzo di costo in movimenti rispetto a giacenze di origine"
				ENDIF
				_body = _body + CHR(10) + "     Anomalie rilevate: " + ALLTRIM(STR(PUB_PRZLOG,10,0))
			ENDIF
			**=> ERASMO - FINE 29/04/2011			
			IF _LCTRLMOG
				_body = _body + CHR(10) + "   - Controllo quadratura saldo movimenti con giacenze per gli articoli in dettagli DDT"
				_body = _body + CHR(10) + "     Anomalie rilevate: " + ALLTRIM(STR(PUB_MOGLOG,10,0))
			ENDIF
			IF _LCTRLWRT
				_body = _body + CHR(10) + "   - Esecuzione dell'allineamento movimenti-giacenze"
				_body = _body + CHR(10) + "     Anomalie rilevate: " + ALLTRIM(STR(PUB_WRTLOG,10,0))
			ENDIF
		ELSE
			_body = _body + CHR(10) + "   - Nessun tipo di controllo selezionato"
		ENDIF
		_body = _body + CHR(10) + CHR(10) + "Totale log di errore scritti: " + ALLTRIM(STR(PUB_TOTLOG,10,0))
		*_attach  = _X_FILENAME
		_attach  = ""
		_W_REPLYTO = ALLTRIM(_MITTENTE)
		_W_SMTP = ALLTRIM(_SMTP)
		_W_USERNAME = ALLTRIM(_USERNAME)
		_W_PASSWORD = ALLTRIM(_PASSWORD)
		_PORT = "25"
		_CRYPTO = ""
		_V_CONFERMA = .F.
		IF EMPTY(_from) .OR. EMPTY(_to) .OR. EMPTY(_subject) .OR. EMPTY(_body) .OR. EMPTY(_W_SMTP)
		   WAIT WINDOWS "Impossibile inviare e-mail a " + ALLTRIM(_LOG_INDIRI) + " -  Campi obbligatori: A, Oggetto e Messaggio" NOWAIT
		ELSE
		   _n_mails_sent = 0
		   _sent = .F.
		   *** UTILIZZO UNA NUOVA PROCEDURA PERCHE' QUELLA PRECEDENTE NON SUPPORTAVA L'AUTENTICAZIONE DEL SERVER 
		   *** PRECLUDE L'ESISTENZA DEL FILE DI SISTEMA WINDOWS\SYSTEM32\MSWINSCK.OCX
		   *=sendemail(_from,_to,_subject,_body,_attach,_W_REPLYTO,_W_SMTP,_W_USERNAME,_W_PASSWORD)
		   
		   *** UTILIZZO PROCEDURA ALTERNATIVA PERCHE' QUELLA CHE UTILIZZAVA IL FILE WINDOWS\SYSTEM32\MSWINSCK.OCX
		   *** NON SEMPRE ERA APPLICABILE: QUESTA UTILIZZA UNA LIBRERIA PROPRIETARIA PRG\vfpWinSock.prg
		   *DO SEND_VFPWINSOCK WITH _from,_to,_subject,_body,_attach,_W_REPLYTO,_W_SMTP,_W_USERNAME,_W_PASSWORD
		   *WAIT WINDOWS "Tentativo di invio e-mail per " + ALLTRIM(_LOG_INDIRI) + " effettuato correttamente" TIMEOUT 2
		   _SONO_QUI=SYS(5)+SYS(2003)
		   **=> ERASMO - INIZIO 15/06/2011
		   *DO SEND_VFPWINSOCK WITH _from,_to,"",_subject,_body,_attach,_W_REPLYTO,_W_SMTP,_W_USERNAME,_W_PASSWORD,"25","",.F.
		   DO SEND_VFPWINSOCK WITH _from,_to,_cc,_subject,_body,_attach,_W_REPLYTO,_W_SMTP,_W_USERNAME,_W_PASSWORD,_PORT,_CRYPTO,_V_CONFERMA,""
	       SET DEFA TO &_SONO_QUI
		   IF _sent
		      WAIT WINDOWS "Tentativo di invio e-mail per " + ALLTRIM(_LOG_INDIRI) + " effettuato correttamente" TIMEOUT 2
		   ELSE
		      WAIT WINDOWS "Tentativo di invio e-mail per " + ALLTRIM(_LOG_INDIRI) + " fallito" TIMEOUT 2
		   ENDIF
		   **=> ERASMO - FINE 15/06/2011
		ENDIF
	ENDIF
ENDIF

IF USED("PARAMETRI_EMAIL_CONTROLLO_GIACENZE")
	SELECT PARAMETRI_EMAIL_CONTROLLO_GIACENZE
	USE
ENDIF

IF USED("PARAMETRI_ESECUZIONE_CONTROLLO_GIACENZE")
	SELECT PARAMETRI_ESECUZIONE_CONTROLLO_GIACENZE
	USE
ENDIF

WAIT CLEAR

_SCREEN.Visible = _OLD_SCREEN_Visible

RETURN
