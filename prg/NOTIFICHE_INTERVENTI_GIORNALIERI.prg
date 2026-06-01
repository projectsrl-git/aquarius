**********************************
* NOTIFICHE_INTERVENTI_GIORNALIERI
**********************************

LPARAMETERS _NR_GIORNI,_CODOPE_MITTENTE

IF PCOUNT() >= 1
ELSE
	_NR_GIORNI = 0
ENDIF

IF PCOUNT() >= 2
ELSE
	_CODOPE_MITTENTE = ""
ENDIF

IF EMPTY(_CODOPE_MITTENTE)
	WAIT WINDOWS "PARAMETRI INSUFFICIENTI" TIMEOUT 3
	RETURN .F.
ENDIF

LOCAL _SAVE_SEL,_FILE_DA_ALLEGARE,_ALLEGATI,_TITOLO,_DATINT
_SAVE_SEL = SELECT()
_FILE_DA_ALLEGARE = ""
_ALLEGATI = ""
_DATINT = DTOC(DATE() + _NR_GIORNI)
_TITOLO = "NOTIFICHE INTERVENTI GIORNALIERI DEL " + _DATINT

WAIT WINDOWS "ESEGUE PROGRAMMA NOTIFICHE_INTERVENTI_GIORNALIERI" TIMEOUT 3
	
RELEASE PUB_CODOPE,PUB_NOMOPE,PUB_CAUCAS,PUB_NOIVASPINC,PUB_NOLOGO,PUB_PSSENDMAIL,PUB_MITTENTE,PUB_MAIL,PUB_SMTP,PUB_PORT,PUB_CRYPTO,PUB_AUTH_USER,PUB_AUTH_PASS,PUB_NOTIFICA,PUB_FIRMA_MAIL,PUB_NEEDCREDS,PUB_USESSL,PUB_NGGLOGEML, ;
	PUB_TWILIOURL,PUB_TWILIOSID,PUB_TWILIOAUTHTOKEN,PUB_TWILIOSMSPN,PUB_TWILIOWAPN
PUBLIC PUB_CODOPE,PUB_NOMOPE,PUB_CAUCAS,PUB_NOIVASPINC,PUB_NOLOGO,PUB_PSSENDMAIL,PUB_MITTENTE,PUB_MAIL,PUB_SMTP,PUB_PORT,PUB_CRYPTO,PUB_AUTH_USER,PUB_AUTH_PASS,PUB_NOTIFICA,PUB_FIRMA_MAIL,PUB_NEEDCREDS,PUB_USESSL,PUB_NGGLOGEML, ;
	PUB_TWILIOURL,PUB_TWILIOSID,PUB_TWILIOAUTHTOKEN,PUB_TWILIOSMSPN,PUB_TWILIOWAPN
PUB_CODOPE = _CODOPE_MITTENTE
PUB_NOMOPE = ""
PUB_CAUCAS = ""
PUB_NOIVASPINC = .F.
PUB_NOLOGO = .F.
PUB_PSSENDMAIL = .F.
PUB_MITTENTE = ""
PUB_MAIL = 0
PUB_SMTP = ""
PUB_PORT = ""
PUB_CRYPTO = ""
PUB_AUTH_USER = ""
PUB_AUTH_PASS = ""
PUB_NOTIFICA = ""
PUB_FIRMA_MAIL = ""
PUB_NEEDCREDS = .F.
PUB_USESSL = .F.
PUB_NGGLOGEML = 0
PUB_TWILIOURL = ""
PUB_TWILIOSID = ""
PUB_TWILIOAUTHTOKEN = ""
PUB_TWILIOSMSPN = ""
PUB_TWILIOWAPN = ""

Csql = "SELECT * FROM RES_OPER WHERE CODICE = '" + PUB_CODOPE + "'"
IF !ExecCommand(cSql,'CU_RES_OPER')
	return(.f.)
ENDIF
SELECT CU_RES_OPER
GO TOP
IF !EOF()
	PUB_NOMOPE = DESCRI
	PUB_MITTENTE = ALLTRIM(MITTENTE)
	PUB_MAIL = MAIL
	PUB_SMTP = ALLTRIM(SMTP)
	PUB_PORT = ALLTRIM(PORT)
	PUB_CRYPTO = ALLTRIM(CRYPTO)
	PUB_AUTH_USER = ALLTRIM(AUTH_USER)
	PUB_AUTH_PASS = ALLTRIM(AUTH_PASS)
	PUB_NOTIFICA = ALLTRIM(NOTIFICA)
	PUB_FIRMA_MAIL = ALLTRIM(FIRMA_MAIL)
	PUB_NEEDCREDS = NEEDCREDS
	PUB_USESSL = USESSL
ENDIF

Csql = "SELECT AZI_CAUCAS FROM U_AZI_AN"
IF !ExecCommand(cSql,'CU_AZI_AN')
	return(.f.)
ENDIF
SELECT CU_AZI_AN
GO TOP
IF !EOF()
	PUB_CAUCAS = AZI_CAUCAS
ENDIF

Csql = "SELECT AZI_NOIVASPINC,AZI_NOLOGO,AZI_PSSENDMAIL FROM U_AZI_PB"
IF !ExecCommand(cSql,'CU_AZI_PB')
	return(.f.)
ENDIF
SELECT CU_AZI_PB
GO TOP
IF !EOF()
	PUB_NOIVASPINC = AZI_NOIVASPINC
	PUB_NOLOGO = AZI_NOLOGO
	PUB_PSSENDMAIL = AZI_PSSENDMAIL
ENDIF

Csql = "SELECT AZI_TWILIOURL,AZI_TWILIOSID,AZI_TWILIOAUTHTOKEN,AZI_TWILIOSMSPN,AZI_TWILIOWAPN FROM U_AZI_PC"
IF !ExecCommand(cSql,'CU_AZI_PC')
	return(.f.)
ENDIF
SELECT CU_AZI_PC
GO TOP
IF !EOF()
	PUB_TWILIOURL = AZI_TWILIOURL 
	PUB_TWILIOSID = AZI_TWILIOSID 
	PUB_TWILIOAUTHTOKEN = AZI_TWILIOAUTHTOKEN 
	PUB_TWILIOSMSPN = AZI_TWILIOSMSPN 
	PUB_TWILIOWAPN = AZI_TWILIOWAPN 
ENDIF


SET PROCEDURE TO PRG\SEND_VIA_vfpWinSock ADDITIVE
SET PROCEDURE TO PRG\APPLILIB ADDITIVE
SET PROCEDURE TO PRG\XLSLIB ADDITIVE
SET PROCEDURE TO PRG\TWILIO_REST_API_LIB ADDITIVE
SET PROCEDURE TO PRG\NFJSONREAD ADDITIVE


*SET STEP ON
x_soci = "TT.ORD_CODSOC = '" + PUB_CODSOC + "'"
x_clos = "TT.ORD_INTCLOSE = 0"
x_conf = "TT.ORD_CONFERMATO = 1"
x_data = "TT.ORD_DTPROGR = '" + RIBALTA2(_DATINT) + "'"
x_cond = x_soci + " and " + x_clos + " and " + x_conf + " and " + x_data

cSql=""
cNomeCursorSql="CX_INTERVENTI"
TEXT TO cSql NOSHOW
	SELECT
		CAST((CASE NOTIFY_TYPE WHEN 2 THEN 'WhatsApp' WHEN 3 THEN 'SMS' WHEN 4 THEN 'E-mail' ELSE '' END) AS VARCHAR(10)) AS TIPO_INVIO
		,CAST((CASE NOTIFY_TYPE WHEN 2 THEN NOTIFY_WA WHEN 3 THEN NOTIFY_SMS WHEN 4 THEN NOTIFY_EMAIL ELSE '' END) AS VARCHAR(254)) AS DESTINATARIO_INVIO
		,SPACE(10) AS ESITO_INVIO
		,SPACE(200) AS MSG_ERRORE
		,TAGGANCIO AS ID_INTERVENTO
		,ORD_NUMORD AS NR_INTERVENTO
		,ORD_DATORD AS DATA_REGISTRAZ
		,ORD_DTPROGR AS DATA_ESECUZIONE
		,ORD_CCODSCHE AS COD_IMPIANTO
		,ORD_CODCLI AS COD_CLIENTE
		,ORD_RAGSOC AS RAG_SOCIALE
		,SUBSTRING(COALESCE(MIN(ORD_ORAINIPRO),''),1,5) AS ORA_INIZIO
		,CAST(coalesce(stuff((select  DISTINCT ', ' + RTRIM(ORD_NOME_TECN) from VENDITE_DT WHERE DAGGANCIO = MAIN.TAGGANCIO for xml path('')),1,1,''),'') AS nvarchar(254)) AS TECNICI
	FROM (
		SELECT
			 TT.*
			,DT.ORD_ORAINIPRO
			,IT.NOTIFY_TYPE
			,IT.NOTIFY_WA
			,IT.NOTIFY_SMS
			,IT.NOTIFY_EMAIL
		FROM VENDITE_TT AS TT
		LEFT OUTER JOIN VENDITE_DT AS DT ON DT.DAGGANCIO = TT.TAGGANCIO
		LEFT OUTER JOIN IMPIANTI_TT AS IT ON IT.CCODSCHE = TT.ORD_CCODSCHE
		WHERE <<X_COND>>
	) AS MAIN
	GROUP BY
		 NOTIFY_TYPE
		,NOTIFY_WA
		,NOTIFY_SMS
		,NOTIFY_EMAIL
		,TAGGANCIO
		,ORD_NUMORD
		,ORD_DATORD
		,ORD_DTPROGR
		,ORD_CCODSCHE
		,ORD_CODCLI
		,ORD_RAGSOC
	ORDER BY ORD_DTPROGR,ORA_INIZIO
ENDTEXT
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT CX_INTERVENTI
GO TOP
SCAN
	_X_NOTIFY_TYPE = ALLTRIM(TIPO_INVIO)
	_X_NOTIFY_TO = ALLTRIM(DESTINATARIO_INVIO)
	
	IF _X_NOTIFY_TYPE <> "" AND !EMPTY(_X_NOTIFY_TO)
	ELSE
		LOOP
	ENDIF
	
	SCATTER MEMVAR MEMO

	DO CASE
		CASE _X_NOTIFY_TYPE = 'WhatsApp'
				
			IF EMPTY(PUB_TWILIOURL) OR EMPTY(PUB_TWILIOSID) OR EMPTY(PUB_TWILIOAUTHTOKEN) OR EMPTY(PUB_TWILIOSMSPN) OR EMPTY(PUB_TWILIOWAPN)
				SELECT CX_INTERVENTI
				REPLACE MSG_ERRORE WITH "Configurare correttamente i parametri per l'invio messaggistica tramite Twilio"
				LOOP
			ENDIF
			IF EMPTY(ALLTRIM(_X_NOTIFY_TO))
				SELECT CX_INTERVENTI
				REPLACE MSG_ERRORE WITH "Numero di telefono WhatsApp destinatario notifiche interventi non configurato in gestione impianto"
				LOOP
			ENDIF
			lcSidTmp = ""
			v_seek   = 'NTIWHA'
			v_chiave = 'codice'
			cSql="SELECT * FROM para WHERE "+V_CHIAVE+ " = ?V_SEEK"
			IF !ExecCommand(cSql,"tmp_para")
			   return(.f.)
			ENDIF
			SELECT tmp_para
			GO TOP
			IF !EOF()
				lcSidTmp = ALLTRIM(ITALIANO)
			ENDIF
			IF EMPTY(ALLTRIM(lcSidTmp))
				SELECT CX_INTERVENTI
				REPLACE MSG_ERRORE WITH "Template WhatsApp non configurato in parametro Testi notifiche interventi"
				LOOP
			ENDIF
						
			_sent = .F.
			_response = ""
			
			_DATA = RIBALTA2(M.DATA_ESECUZIONE)
			_ORA = ""
			IF !EMPTY(M.ORA_INIZIO)
				IF ALLTRIM(M.ORA_INIZIO) < "13:00"
					_ORA = "mattina"
				ELSE
					_ORA = "pomeriggio"
				ENDIF
			ENDIF
			
			lcTo = "+39"+ALLTRIM(_X_NOTIFY_TO)
			lcVars = '{"date":"'+_DATA+'","time":"'+_ORA+'"}'
			lcResult = SendTwilioWhatsAppMessageTemplate(ALLTRIM(PUB_TWILIOURL), ALLTRIM(PUB_TWILIOSID), ALLTRIM(PUB_TWILIOAUTHTOKEN), ALLTRIM(PUB_TWILIOWAPN), ALLTRIM(lcTo), ALLTRIM(lcSidTmp), ALLTRIM(lcVars))
			IF SUBSTR(lcResult,1,6) = "Errore"
				SELECT CX_INTERVENTI
				REPLACE ESITO_INVIO WITH "NEGATIVO"
				REPLACE MSG_ERRORE WITH lcResult
				_sent = .F.
				_response = lcResult
			ELSE
				SELECT CX_INTERVENTI
				REPLACE ESITO_INVIO WITH "POSITIVO"
				_sent = .T.
				_response = ""
			ENDIF
			
			_message_from = ALLTRIM(PUB_TWILIOWAPN)
			_to = lcTo
			_cc = ""
			_ccn = ""
			_subject = "WhatsApp - Template: " + ALLTRIM(lcSidTmp) + " - Vars: " + ALLTRIM(lcVars)
			_allegato = ""
			_body = ""
			_body2 = ""
			DO INSERT_LOG_EMAIL WITH _sent,_response
			
			
		CASE _X_NOTIFY_TYPE = 'SMS'
		
			IF EMPTY(PUB_TWILIOURL) OR EMPTY(PUB_TWILIOSID) OR EMPTY(PUB_TWILIOAUTHTOKEN) OR EMPTY(PUB_TWILIOSMSPN) OR EMPTY(PUB_TWILIOWAPN)
				SELECT CX_INTERVENTI
				REPLACE MSG_ERRORE WITH "Configurare correttamente i parametri per l'invio messaggistica tramite Twilio"
				LOOP
			ENDIF
			IF EMPTY(ALLTRIM(_X_NOTIFY_TO))
				SELECT CX_INTERVENTI
				REPLACE MSG_ERRORE WITH "Numero di telefono SMS destinatario notifiche interventi non configurato in gestione impianto"
				LOOP
			ENDIF
			lcMsg = ""
			v_seek   = 'NTISMS'
			v_chiave = 'codice'
			cSql="SELECT * FROM para WHERE "+V_CHIAVE+ " = ?V_SEEK"
			IF !ExecCommand(cSql,"tmp_para")
			   return(.f.)
			ENDIF
			SELECT tmp_para
			GO TOP
			IF !EOF()
				lcMsg = ALLTRIM(ITALIANO)
			ENDIF
			IF EMPTY(ALLTRIM(lcMsg))
				SELECT CX_INTERVENTI
				REPLACE MSG_ERRORE WITH "Messaggio SMS non configurato in parametro Testi notifiche interventi"
				LOOP
			ENDIF
			
			_DATA = RIBALTA2(M.DATA_ESECUZIONE)
			_ORA = ""
			IF !EMPTY(M.ORA_INIZIO)
				IF ALLTRIM(M.ORA_INIZIO) < "13:00"
					_ORA = "mattina"
				ELSE
					_ORA = "pomeriggio"
				ENDIF
			ENDIF
			
			_sent = .F.
			_response = ""
			
			lcTo = "+39"+ALLTRIM(_X_NOTIFY_TO)
			lcMsg = STRTRAN(lcMsg,"{{date}}",_DATA)
			lcMsg = STRTRAN(lcMsg,"{{time}}",_ORA)
			lcResult = SendTwilioSMSMessage(ALLTRIM(PUB_TWILIOURL), ALLTRIM(PUB_TWILIOSID), ALLTRIM(PUB_TWILIOAUTHTOKEN), ALLTRIM(PUB_TWILIOSMSPN), ALLTRIM(lcTo), lcMsg)
			IF SUBSTR(lcResult,1,6) = "Errore"
				SELECT CX_INTERVENTI
				REPLACE ESITO_INVIO WITH "NEGATIVO"
				REPLACE MSG_ERRORE WITH lcResult
				_sent = .F.
				_response = lcResult
			ELSE
				SELECT CX_INTERVENTI
				REPLACE ESITO_INVIO WITH "POSITIVO"
				_sent = .T.
				_response = ""
			ENDIF
			
			_message_from = ALLTRIM(PUB_TWILIOSMSPN)
			_to = ALLTRIM(lcTo)
			_cc = ""
			_ccn = ""
			_subject = "SMS"
			_allegato = ""
			_body = ALLTRIM(lcMsg)
			_body2 = ""
			DO INSERT_LOG_EMAIL WITH _sent,_response
			
			
		CASE _X_NOTIFY_TYPE = 'E-mail'
		
			IF EMPTY(ALLTRIM(_X_NOTIFY_TO))
				SELECT CX_INTERVENTI
				REPLACE MSG_ERRORE WITH "Indirizzo e-mail per destinatario notifiche interventi non configurato in gestione impianto"
				LOOP
			ENDIF
			lcSubj = ""
			lcMsg = ""
			lcBcc = ""
			v_seek   = 'NTIEML'
			v_chiave = 'codice'
			cSql="SELECT * FROM para WHERE "+V_CHIAVE+ " = ?V_SEEK"
			IF !ExecCommand(cSql,"tmp_para")
			   return(.f.)
			ENDIF
			SELECT tmp_para
			GO TOP
			IF !EOF()
				lcSubj = ALLTRIM(LIBERA)
				lcMsg = ALLTRIM(ITALIANO)
				lcBcc = ALLTRIM(DESIVA)
			ENDIF
			IF EMPTY(ALLTRIM(lcSubj))
				SELECT CX_INTERVENTI
				REPLACE MSG_ERRORE WITH "Oggetto e-mail non configurato in parametro Testi notifiche interventi"
				LOOP
			ENDIF
			IF EMPTY(ALLTRIM(lcMsg))
				SELECT CX_INTERVENTI
				REPLACE MSG_ERRORE WITH "Messaggio e-mail non configurato in parametro Testi notifiche interventi"
				LOOP
			ENDIF
			
			_DATA = RIBALTA2(M.DATA_ESECUZIONE)
			_ORA = ""
			IF !EMPTY(M.ORA_INIZIO)
				IF ALLTRIM(M.ORA_INIZIO) < "13:00"
					_ORA = "mattina"
				ELSE
					_ORA = "pomeriggio"
				ENDIF
			ENDIF
			
			lcTo = ALLTRIM(_X_NOTIFY_TO)
			lcSubj = STRTRAN(lcSubj,"{{date}}",_DATA)
			lcSubj = STRTRAN(lcSubj,"{{time}}",_ORA)
			lcSubj = STRTRAN(lcSubj,"{{codsche}}",ALLTRIM(M.COD_IMPIANTO))  && ERASMO - 14/04/2026
			lcMsg = STRTRAN(lcMsg,"{{date}}",_DATA)
			lcMsg = STRTRAN(lcMsg,"{{time}}",_ORA)
			lcImmediate = .T.
			lcNoNotify = .T.  && ERASMO - 14/04/2026
			
			_sent = .F.
			_response = ""
			*LPARAMETERS txtExport,_doc,_tipo,_codice,_indemail,_oggetto,_corpo,_blocca_campi,_testo_nascosto,_nessuna_notifica,_nessuna_conferma_lettura,_forza_html,_indemail_cc,_indemail_ccn,_invio_immediato
			*DO FORM FORM\EMAIL WITH "","","","",lcTo,lcSubj,lcMsg,.F.,"",.F.,.F.,.F.,"",lcBcc,lcImmediate
			DO FORM FORM\EMAIL WITH "","","","",lcTo,lcSubj,lcMsg,.F.,"",lcNoNotify,.F.,.F.,"",lcBcc,lcImmediate  && ERASMO - 14/04/2026
			IF !_sent
				SELECT CX_INTERVENTI
				REPLACE ESITO_INVIO WITH "NEGATIVO"
				REPLACE MSG_ERRORE WITH lcResult
			ELSE
				SELECT CX_INTERVENTI
				REPLACE ESITO_INVIO WITH "POSITIVO"
			ENDIF
			_message_from = PUB_MITTENTE
			DO INSERT_LOG_EMAIL WITH _sent,_response
			
		OTHERWISE
		
			SELECT CX_INTERVENTI
			REPLACE MSG_ERRORE WITH "Verificare configurazione Notifiche"
			LOOP
			
	ENDCASE

ENDSCAN

LOCAL _DIRECTORY_PDF,_NOME_REPORT

_DIRECTORY_PDF=LEGGE_CONFIG("AQ_SCHEDULER_CONFIG.CFG","PATH_EMAIL")  && RICERCA PERCORSO
IF !DIRECTORY(_DIRECTORY_PDF)
	*MESSAGEBOX("Directory '" + JUSTDRIVE(_DIRECTORY_PDF) + "' inesistente" + CHR(13) + CHR(13) + ;
		"Non sarà possibile creare correttamente i files PDF",48,"Attenzione")
	RETURN .F.
ENDIF

RELEASE PUB_INTXLS
PUBLIC PUB_INTXLS
PUB_INTXLS = ""
IF !ExecCommand("select * from u_azi_pb","u_azi_pb")
   return
ENDIF
SELECT u_azi_pb
GO TOP
IF !EOF()
	PUB_INTXLS = AZI_INTXLS
ENDIF

_NOME_REPORT = _DIRECTORY_PDF + "\" + "NOTIFICHE_INTERVENTI_GIORNALIERI" + SYS(2015) + ".XLSX"

WAIT WINDOW "ATTENDERE PREGO: creazione report excel in corso..." NOWAIT

_TITOLO_EXCEL1 = _TITOLO
_TITOLO_EXCEL2 = ""
_TITOLO_EXCEL3 = ""
_TOTALI_GENERALI = .F.
DO ESTRXLS WITH "CX_INTERVENTI",_TITOLO_EXCEL1,_TITOLO_EXCEL2,_TITOLO_EXCEL3,_TOTALI_GENERALI,.F.,.F.,_NOME_REPORT

_ALLEGATI = ""
_FILE_DA_ALLEGARE = JUSTFNAME(_NOME_REPORT)
_ALLEGATI = _ALLEGATI + IIF(EMPTY(_ALLEGATI),"",";")+_FILE_DA_ALLEGARE 


_ERRORE =.F.
DO PRG\INVIA_MAIL_SCHEDULATE WITH _ERRORE,_ALLEGATI ,_ID_EMAIL_DA_INVIARE

**=> ERASMO - INIZIO 08/05/2026
PUB_CODOPE = "SER"
PUB_NOMOPE = ""
Csql = "SELECT * FROM RES_OPER WHERE CODICE = '" + PUB_CODOPE + "'"
IF !ExecCommand(cSql,'CU_RES_OPER')
	return(.f.)
ENDIF
SELECT CU_RES_OPER
GO TOP
IF !EOF()
	PUB_NOMOPE = DESCRI
ENDIF
**=> ERASMO - FINE 08/05/2026

SELECT(_SAVE_SEL )
	
RETURN .T.


*******************************************************************************
PROCEDURE INSERT_LOG_EMAIL
*******************************************************************************
LPARAMETERS _par_sent,_par_response

IF PCOUNT() >= 2
ELSE
	_par_response = ""
ENDIF

_l_tipdoc = "INR"
_l_numdoc = M.NR_INTERVENTO
_l_datdoc = M.DATA_REGISTRAZ
_l_codcli = M.COD_CLIENTE
_l_ragsoc = M.RAG_SOCIALE
_l_ind_mittente = _message_from
_l_ind_email = _to
_l_ind_emailcc = _cc
_l_ind_emailcn = _ccn
_l_oggetto = _subject
_l_messaggio = _body
_l_allegato = ""
_l_sent = _par_sent
=LOG_EMAIL(_l_tipdoc,_l_numdoc,_l_datdoc,_l_codcli,_l_ragsoc,_l_ind_mittente,_l_ind_email,_l_ind_emailcc,_l_ind_emailcn,_l_oggetto,_l_messaggio,_l_allegato,_l_sent,_par_response)

ENDPROC