
LPARAMETERS _par_scheduled,_par_group_codsys

IF PCOUNT() >= 1
ELSE
	_par_scheduled = .F.
ENDIF

IF PCOUNT() >= 2
ELSE
	_par_group_codsys = ""
ENDIF

IF EMPTY(PUB_SFLOGIN) OR EMPTY(PUB_SFLOGOUT) OR EMPTY(PUB_SFUSER) OR EMPTY(PUB_SFPASS) OR EMPTY(PUB_SFCKEY) OR EMPTY(PUB_SFCSECRET)
	WAIT WINDOWS "Configurare correttamente tutti i parametri di sistema nella sezione 'SalesForce REST API Authentication'" TIMEOUT 3
	RETURN .F.
ENDIF

_CONTA_INS_DA_AQ = 0
_CONTA_AGG_DA_AQ = 0
_CONTA_INS_DA_SF = 0
_CONTA_AGG_DA_SF = 0
_CONTA_DEL_DA_SF = 0

_MSG_WARNINGS = ""

_LOG_CODSYS = IIF(EMPTY(_par_group_codsys),SYS(2015),_par_group_codsys)
_LOG_OGGETTO = "LOCALITA_CONSEGNA"
_LOG_DATA = RIBALTA2(DTOC(DATE()))
_LOG_ORA = TIME()
_LOG_CODOPE = ALLTRIM(PUB_CODOPE)
_LOG_NOMOPE = ALLTRIM(PUB_NOMOPE)

*** LOGIN
_username = ALLTRIM(PUB_SFUSER)
_password = ALLTRIM(PUB_SFPASS)
_consumer_key = ALLTRIM(PUB_SFCKEY)
_consumer_secret = ALLTRIM(PUB_SFCSECRET)
_access_token = ""
_instance_url = ""

_SEC_INI = SECONDS()

_cJson = ""
_HTTP_request = ALLTRIM(PUB_SFLOGIN)
WAIT WINDOWS SUBSTR("Connessione per Login a '"+_HTTP_request+"' in corso...",1,254) NOWAIT

_cJson = SALESFORCEREST_POST(_HTTP_request,"","",_username,_password,_consumer_key,_consumer_secret)
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione file Json in corso..." NOWAIT

obj_json = json_decode(_cJson)

*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
	_cProperty = "OBJ_JSON._error_description"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_message = ALLTRIM(&_cProperty)
		WAIT WINDOWS SUBSTR("Risposta da '"+_HTTP_request+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		RETURN .F.
	ENDIF
ENDIF

*** TOKEN E/O INSTANCE_URL NON RESTITUITI
_cProperty = "OBJ_JSON._access_token"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
	_access_token = &_cProperty
ENDIF
IF EMPTY(_access_token)
	WAIT WINDOWS "Parametro di ritorno 'access_token' non presente" TIMEOUT 3
	RETURN .F.
ENDIF
_cProperty = "OBJ_JSON._instance_url"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
	_instance_url = &_cProperty
ENDIF
IF EMPTY(_instance_url)
	WAIT WINDOWS "Parametro di ritorno 'instance_url' non presente" TIMEOUT 3
	RETURN .F.
ENDIF

RELEASE obj_json

*** CONTROLLI DI LOGIN SUPERATI, PROCEDO CON LE CHIAMATE SPECIFICHE PER LA SINCRONIZZAZIONE DELLE LOCALITA_CONSEGNA


*** SCRITTURA RECORD TABELLA LOG_SFSYNC
cSql = "select * from LOG_SFSYNC where 1=0"
IF !ExecRW(cSql,"LOG_SFSYNC","R")
   return(.f.)
ENDIF
SELECT LOG_SFSYNC
APPEND BLANK
REPLACE CODSYS WITH _LOG_CODSYS
REPLACE OGGETTO WITH _LOG_OGGETTO
REPLACE DATA WITH _LOG_DATA
REPLACE ORA WITH _LOG_ORA
REPLACE CODOPE WITH _LOG_CODOPE
REPLACE NOMOPE WITH _LOG_NOMOPE
REPLACE ESITO WITH ""
REPLACE MESSAGGIO WITH "ELABORAZIONE"
REPLACE NRECINS_FROM_AQ WITH 0
REPLACE NRECAGG_FROM_AQ WITH 0
REPLACE NRECINS_FROM_SF WITH 0
REPLACE NRECAGG_FROM_SF WITH 0
REPLACE TEMPO_IMPIEGATO WITH 0
IF !ExecRW(cSql,"LOG_SFSYNC","W")
   return(.f.)
ENDIF

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DELLE LOCALITA DI CONSEGNA PRESENTI SU SALESFORCE
CREATE CURSOR TMP_SF_DESTINAZIONE__C ( ;
	Id C(254), ;
	LastModifiedDate C(254), ;
	Name C(254), ;
	Cliente__c C(254), ;
	Ragione_sociale__c C(254), ;
	All_attenzione_di__c C(254), ;
	Indirizzo__City__s C(254), ;
	Indirizzo__Street__s C(254), ;
	Indirizzo__PostalCode__s C(254), ;
	Indirizzo__StateCode__s C(254), ;
	Indirizzo__CountryCode__s C(254), ;
	Email__c C(254), ;
	Note__c C(254), ;
	ExternalId__c C(254))

*** ELABORAZIONE LOCALITA DI CONSEGNA AQUARIUS ELIMINATE (LO ESEGUO IMMEDIATAMENTE PERCHE' POTREBBE ESSERE STATA REINSERITA SUCCESSIVAMENTE)
WAIT WINDOWS "Elaborazione LOCALITA DI CONSEGNA Aquarius eliminate..." NOWAIT

cSql="SELECT * FROM LOG_DELETED WHERE TABLE_NAME = 'U_LOC_AN' AND LIBERA NOT LIKE '%DELETED FROM SFDC%' ORDER BY CHIAVE"
cNomeCursorSql="TMP_LOG_DELETED_LOC_AN"
IF !ExecCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF
SELECT TMP_LOG_DELETED_LOC_AN
GO TOP
SCAN
	_ExternalId__c = ALLTRIM(CHIAVE)
		
	*** ELIMINAZIONE LOCALITA DI CONSEGNA IN LINEA SU SFDC NON PIU' PRESENTI SU AQUARIUS		
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id+FROM+Destinazione__c+WHERE+ExternalId__c='"+_ExternalId__c+"'"
	_cJson = ""
	_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
	IF EMPTY(_cJson)
		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
		RETURN .F.
	ENDIF
	
	obj_json_tt = json_decode(_cJson)

	*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
	IF TYPE("obj_json_tt") <> 'U' AND TYPE("obj_json_tt") = 'O' AND !ISNULL(obj_json_tt)
		_cProperty = "obj_json_tt.Array(1)._message"
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			_message = ALLTRIM(&_cProperty)
			WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
			IF !ExecRW(cSql,"LOG_SFSYNC","R")
			   return(.f.)
			ENDIF
			SELECT LOG_SFSYNC
			GO TOP
			IF !EOF()
				REPLACE ESITO WITH "KO"
				REPLACE MESSAGGIO WITH  _cGruppo_Comp + " - " + _message
				_SEC_FIN = SECONDS()
				REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
			ENDIF
			IF !ExecRW(cSql,"LOG_SFSYNC","W")
			   return(.f.)
			ENDIF
			
			RELEASE obj_json_tt			
			RETURN .F.
		ENDIF
	ENDIF
	
	_OK_DELETED_ON_SF = .F.

	IF obj_json_tt._totalSize > 0

		FOR I_row = 1 TO ALEN(obj_json_tt._RECORDS.Array,1)
					
			_cProperty = "obj_json_tt._records.Array("+ALLTRIM(STR(I_row))+")._Id"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				IF &_cProperty = ""
					LOOP
				ENDIF
			ENDIF
			
			*** CANCELLAZIONE RECORD LOCALITA_CONSEGNA SU SFDC
			_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Destinazione__c/"+&_cProperty
			_cJson = ""
			_cJson = SALESFORCEREST_DELETE(_HTTP_request,_access_token)
			IF EMPTY(_cJson)
				WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
				_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
					"Warning: Oggetto JSON restituito VUOTO durante il tentativo di cancellazione Località di consegna Id=" + &_cProperty + " (" + _CODICE_CLIENTE + _CODICE_LOCALITA + ")"
				LOOP
			ENDIF
			
			IF _cJson = "204"
				_CONTA_DEL_DA_SF = _CONTA_DEL_DA_SF + 1
				_OK_DELETED_ON_SF = .T.
			ELSE
				obj_json = json_decode(_cJson)

				*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
				IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
					_cProperty = "OBJ_JSON.Array(1)._message"
					IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
						_message = ALLTRIM(&_cProperty)
						WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
						IF !ExecRW(cSql,"LOG_SFSYNC","R")
						   return(.f.)
						ENDIF
						SELECT LOG_SFSYNC
						GO TOP
						IF !EOF()
							REPLACE ESITO WITH "KO"
							REPLACE MESSAGGIO WITH _message + REPLICATE(CHR(13),2) + _json_content
							_SEC_FIN = SECONDS()
							REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
						ENDIF
						IF !ExecRW(cSql,"LOG_SFSYNC","W")
						   return(.f.)
						ENDIF
						
						RELEASE obj_json
						RETURN .F.
					ENDIF
				ENDIF
				
				RELEASE obj_json
			
			ENDIF
				
		NEXT

		RELEASE obj_json_tt
	ENDIF
	
	SELECT TMP_LOG_DELETED_LOC_AN
	cSql="SELECT * FROM LOG_DELETED WHERE TABLE_NAME = 'U_LOC_AN' AND LIBERA NOT LIKE '%DELETED FROM SFDC%' AND AGGANCIO = '" + ALLTRIM(AGGANCIO) + "' AND CHIAVE = '" + ALLTRIM(CHIAVE) + "' ORDER BY CHIAVE"
	IF !ExecRW(cSql,"LOG_DELETED","R")
		return(.F.)
	ENDIF
	SELECT LOG_DELETED
	GO TOP
	IF !EOF()
		IF _OK_DELETED_ON_SF
			REPLACE LIBERA WITH ALLTRIM(LIBERA) + IIF(EMPTY(ALLTRIM(LIBERA)),"","; ") + "DELETED FROM SFDC"
		ELSE
			REPLACE LIBERA WITH ALLTRIM(LIBERA) + IIF(EMPTY(ALLTRIM(LIBERA)),"","; ") + "NOT DELETED FROM SFDC"
		ENDIF
	ENDIF
	IF !ExecRW(cSql,"LOG_DELETED","W")
		return(.F.)
	ENDIF
	SELECT TMP_LOG_DELETED_LOC_AN
	
ENDSCAN



*** ELABORAZIONE LOCALITA DI CONSEGNA AQUARIUS MODIFICATI RISPETTO ALL'ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE
WAIT WINDOWS "Lettura LOCALITA DI CONSEGNA Aquarius modificate o inserite rispetto all'ultima sincronizzazione..." NOWAIT

_ULT_TS_SYNC_LOC_CONS = ""
cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
IF !ExecCommand(cSql,"ULT_TS_SYNC_LOC_CONS")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_LOC_CONS
GO TOP
_ULT_TS_SYNC_LOC_CONS = LAST_DATE

*_ULT_TS_SYNC_LOC_CONS = '1950/01/0100:00:00'  && ###TEST### TUTTI GLI LOCALITA_CONSEGNA ###TEST###

x_cond = "LOC_CF = 'C' AND ACL.SF_ACCOUNT_ID <> '' AND (CASE AN.MOD_DATREG WHEN '' THEN (AN.REG_DATREG+CASE AN.REG_ORAREG WHEN '' THEN '23:59:59' ELSE AN.REG_ORAREG END) ELSE AN.MOD_DATREG+CASE AN.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE AN.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_LOC_CONS + "'"
*x_cond = x_cond + " AND SF_LOC_ID = ''"  && SOLO PER POPOLAMENTO MASSIVO INIZIALE
cSql=""
cNomeCursorSql="TMP_LOCALITA_CONSEGNA"
TEXT TO cSql NOSHOW
	
	SELECT
		AN.LOC_CODLOC AS Name,
		AN.LOC_CODCLI AS Codice_Cliente__c,
		AN.LOC_RAGSOC AS Ragione_sociale__c,
		AN.LOC_ATTENZIONE AS All_attenzione_di__c,
		AN.LOC_LOCALI AS Indirizzo__City__s,
		AN.LOC_INDIRI AS Indirizzo__Street__s,
		AN.LOC_CAP AS Indirizzo__PostalCode__s,
		AN.LOC_PROVIN AS Indirizzo__StateCode__s,
		COALESCE(P_STA.LIBERA,'') AS Indirizzo__CountryCode__s,
		AN.LOC_EMAIL AS Email__c,
		AN.LOC_VARIE AS Note__c,
		RTRIM(AN.LOC_CODCLI)+RTRIM(AN.LOC_CODLOC) AS ExternalId__c
	FROM U_LOC_AN AS AN
	LEFT OUTER JOIN PARA AS P_STA ON P_STA.CODICE = 'STA'+AN.LOC_CODNAZ
	RIGHT OUTER JOIN U_CLI_AN AS CL ON AN.LOC_CODCLI = CL.CLI_CODCLI
	LEFT OUTER JOIN U_ANA_CL AS ACL ON CL.CLI_CODCLI = ACL.CLI_CODCLI
	WHERE <<x_cond>>
	ORDER BY LOC_CODCLI,LOC_CODLOC
	
ENDTEXT
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT TMP_LOCALITA_CONSEGNA
GO TOP
SCAN

*!*		IF RECNO() > 10
*!*			EXIT
*!*		ENDIF
	
	WAIT WINDOWS "Elaborazione Località di consegna Aquarius " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	SCATTER MEMVAR MEMO
	
	_Name = ALLTRIM(M.Name)
	_Cliente__c = LOOKUP_ACCOUNT(ALLTRIM(M.Codice_Cliente__c))
	IF EMPTY(_Cliente__c)	
		WAIT WINDOWS SUBSTR("Codice cliente: "+ALLTRIM(M.Codice_Cliente__c)+" - Account SFDC non trovato, pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
		_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
			"Warning: Codice cliente: "+ALLTRIM(M.Codice_Cliente__c)+" - Account SFDC non trovato, pertanto non verrà considerato in questa elaborazione"
		SELECT TMP_LOCALITA_CONSEGNA
		LOOP
	ENDIF
	_Ragione_sociale__c = ALLTRIM(M.Ragione_sociale__c)
	_All_attenzione_di__c = ALLTRIM(M.All_attenzione_di__c)
	_Indirizzo__City__s = SUBSTR(ALLTRIM(M.Indirizzo__City__s),1,40)
	_Indirizzo__Street__s = ALLTRIM(M.Indirizzo__Street__s)
	_Indirizzo__PostalCode__s = ALLTRIM(M.Indirizzo__PostalCode__s)
	_Indirizzo__StateCode__s = ALLTRIM(M.Indirizzo__StateCode__s)
	_Indirizzo__CountryCode__s = ALLTRIM(M.Indirizzo__CountryCode__s)
	**=> ERASMO - INIZIO 19/12/2024
	*** PER NAZIONI ESTERE NON CONSIDERO IL CAMPO PROVINCIA
	IF _Indirizzo__CountryCode__s == "IT"
	ELSE
		_Indirizzo__StateCode__s = ""
	ENDIF
	**=> ERASMO - FINE 19/12/2024	
	_Email__c = ALLTRIM(M.Email__c)
	_Note__c = ALLTRIM(M.Note__c)
	_ExternalId__c = ALLTRIM(M.ExternalId__c)
	
	*** PULIZIA CARATTERE CR E LF
	_Ragione_sociale__c = STRTRAN(STRTRAN(_Ragione_sociale__c,CHR(13),' '),CHR(10),'')
	_All_attenzione_di__c = STRTRAN(STRTRAN(_All_attenzione_di__c,CHR(13),' '),CHR(10),'')
	_Indirizzo__City__s = STRTRAN(STRTRAN(_Indirizzo__City__s,CHR(13),' '),CHR(10),'')
	_Indirizzo__Street__s = STRTRAN(STRTRAN(_Indirizzo__Street__s,CHR(13),' '),CHR(10),'')
	_Note__c = STRTRAN(STRTRAN(_Note__c,CHR(13),' '),CHR(10),'')
	
	*** ESCAPING CARATTERE \
	_Ragione_sociale__c = STRTRAN(_Ragione_sociale__c,'\','\\')
	_All_attenzione_di__c = STRTRAN(_All_attenzione_di__c,'\','\\')
	_Indirizzo__City__s = STRTRAN(_Indirizzo__City__s,'\','\\')
	_Indirizzo__Street__s = STRTRAN(_Indirizzo__Street__s,'\','\\')
	_Note__c = STRTRAN(_Note__c,'\','\\')
		
	*** ESCAPING CARATTERE "
	_Ragione_sociale__c = STRTRAN(_Ragione_sociale__c,'"','\"')
	_All_attenzione_di__c = STRTRAN(_All_attenzione_di__c,'"','\"')
	_Indirizzo__City__s = STRTRAN(_Indirizzo__City__s,'"','\"')
	_Indirizzo__Street__s = STRTRAN(_Indirizzo__Street__s,'"','\"')
	_Note__c = STRTRAN(_Note__c,'"','\"')
	
	*** ESCAPING CARATTERE /
	_Ragione_sociale__c = STRTRAN(_Ragione_sociale__c,'/','\/')
	_All_attenzione_di__c = STRTRAN(_All_attenzione_di__c,'/','\/')
	_Indirizzo__City__s = STRTRAN(_Indirizzo__City__s,'/','\/')
	_Indirizzo__Street__s = STRTRAN(_Indirizzo__Street__s,'/','\/')
	_Note__c = STRTRAN(_Note__c,'/','\/')
		
	IF EMPTY(_Indirizzo__CountryCode__s) AND !EMPTY(_Indirizzo__StateCode__s)
		*** FORZO IL PAESE A 'IT' SE VUOTO E CONFORME ALLA LUNGHEZZA DELLA PROVINCIA E DEL CAP, ALTRIMENTI MI DAREBBE ERRORE
		IF LEN(_Indirizzo__StateCode__s) = 2 AND LEN(_Indirizzo__PostalCode__s) = 5
			_Indirizzo__CountryCode__s = "IT"
		ELSE
			_Indirizzo__StateCode__s = ""
		ENDIF
	ENDIF
	
	_cLocalita_Consegna = "Località di consegna " + ALLTRIM(M.Name) + " del cliente " + ALLTRIM(M.Codice_Cliente__c)
		
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,ExternalId__c+FROM+Destinazione__c+WHERE+ExternalId__c='"+_ExternalId__c+"'"
	_cJson = ""
	_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
	IF EMPTY(_cJson)
		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
		RETURN .F.
	ENDIF
	
	*WAIT WINDOWS "Elaborazione file Json per ricerca articolo " + _ProductCode + " in corso..." NOWAIT

	obj_json = json_decode(_cJson)

	*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)		
		_cProperty = "OBJ_JSON.Array(1)._message"
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			_message = ALLTRIM(&_cProperty)
			
			WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
			IF !ExecRW(cSql,"LOG_SFSYNC","R")
			   return(.f.)
			ENDIF
			SELECT LOG_SFSYNC
			GO TOP
			IF !EOF()
				REPLACE ESITO WITH "KO"
				REPLACE MESSAGGIO WITH _cLocalita_Consegna + " - " + _message
				_SEC_FIN = SECONDS()
				REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
			ENDIF
			IF !ExecRW(cSql,"LOG_SFSYNC","W")
			   return(.f.)
			ENDIF
			
			RELEASE obj_json			
			RETURN .F.
		ENDIF
	ENDIF
	
	SELECT TMP_SF_DESTINAZIONE__C
	ZAP
	
	IF OBJ_JSON._totalSize = 0
		
		*** INSERIMENTO NUOVA LOCALITA DI CONSEGNA SU SALESFORCE
		
		_json_content = '{'
		_json_content = _json_content + '"Name": "' + _Name + '"'
		_json_content = _json_content + ', "Cliente__c": "' + _Cliente__c + '"'
		_json_content = _json_content + ', "Ragione_sociale__c": "' + _Ragione_sociale__c + '"'
		_json_content = _json_content + ', "All_attenzione_di__c": "' + _All_attenzione_di__c + '"'
		_json_content = _json_content + ', "Indirizzo__City__s": "' + _Indirizzo__City__s + '"'
		_json_content = _json_content + ', "Indirizzo__Street__s": "' + _Indirizzo__Street__s + '"'
		_json_content = _json_content + ', "Indirizzo__PostalCode__s": "' + _Indirizzo__PostalCode__s + '"'
		_json_content = _json_content + ', "Indirizzo__StateCode__s": "' + _Indirizzo__StateCode__s + '"'
		_json_content = _json_content + ', "Indirizzo__CountryCode__s": "' + _Indirizzo__CountryCode__s + '"'
		_json_content = _json_content + ', "Email__c": "' + _Email__c + '"'
		_json_content = _json_content + ', "Note__c": "' + _Note__c + '"'
		_json_content = _json_content + ', "ExternalId__c": "' + _ExternalId__c + '"'
		_json_content = _json_content + '}'
		
		_cJson = ""
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Destinazione__c/"

		_cJson = SALESFORCEREST_POST_INSERT(_HTTP_request,_access_token,_json_content)
		IF EMPTY(_cJson)
			WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
			RETURN .F.
		ENDIF
		
		obj_json = json_decode(_cJson)
				
		*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
		IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
		
			_cProperty = "OBJ_JSON.Array(1)._errorcode"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_errorcode = ALLTRIM(&_cProperty)
				IF _errorcode = "DUPLICATES_DETECTED"
					
					WAIT WINDOWS SUBSTR("Errorcode: "+_errorcode+" - "+_cLocalita_Consegna+", pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
					_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
						"Warning: "+_errorcode+" - "+_cLocalita_Consegna+", pertanto non verrà considerato in questa elaborazione"
					SELECT TMP_LOCALITA_CONSEGNA
					LOOP
			
				ENDIF
			ENDIF
			
			_cProperty = "OBJ_JSON.Array(1)._message"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_message = ALLTRIM(&_cProperty)
				
				WAIT WINDOWS SUBSTR("Risposta da '"+_HTTP_request+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
				IF !ExecRW(cSql,"LOG_SFSYNC","R")
				   return(.f.)
				ENDIF
				SELECT LOG_SFSYNC
				GO TOP
				IF !EOF()
					REPLACE ESITO WITH "KO"
					REPLACE MESSAGGIO WITH _cLocalita_Consegna + " - " + _message
					_SEC_FIN = SECONDS()
					REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
				ENDIF
				IF !ExecRW(cSql,"LOG_SFSYNC","W")
				   return(.f.)
				ENDIF
				
				RELEASE obj_json
				RETURN .F.
			ENDIF
			
			_cProperty = "OBJ_JSON._success"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_success = &_cProperty
				IF _success = .T.
				
					_cProperty = "OBJ_JSON._id"
					IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
						_id = &_cProperty
						IF EMPTY(_id)
							WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"'",1,254) TIMEOUT 3
							
							cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
							IF !ExecRW(cSql,"LOG_SFSYNC","R")
							   return(.f.)
							ENDIF
							SELECT LOG_SFSYNC
							GO TOP
							IF !EOF()
								REPLACE ESITO WITH "KO"
								REPLACE MESSAGGIO WITH "Nessuna risposta da '"+_HTTP_request+"'"
								_SEC_FIN = SECONDS()
								REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
							ENDIF
							IF !ExecRW(cSql,"LOG_SFSYNC","W")
							   return(.f.)
							ENDIF
							
							RETURN .F.
						ELSE
						
							_SF_DESTINAZIONE__C_ID = _id
							*_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
							
							cSql = "SELECT * FROM U_LOC_AN WHERE LOC_CODCLI = '" + ALLTRIM(M.Codice_Cliente__c) + "' AND LOC_CODLOC = '" + ALLTRIM(M.Name) + "'"	
							IF !ExecRW(cSql,"U_LOC_AN","R")
								return(.f.)
							ENDIF
							SELECT U_LOC_AN 
							GO TOP
							IF !EOF()
								REPLACE SF_LOC_ID WITH _SF_DESTINAZIONE__C_ID
								*REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
							ENDIF
							IF !ExecRW(cSql,"U_LOC_AN","W")
								return(.f.)
							ENDIF
							
							_CONTA_INS_DA_AQ = _CONTA_INS_DA_AQ + 1
						
						ENDIF
					ENDIF
					
				ELSE
					
					_errors = ""
					_cProperty = "OBJ_JSON._errors.Array"
					IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) = 'O'
						FOR I_err = 1 TO ALEN(OBJ_JSON._errors.Array,1)
							_errors = _errors + IIF(EMPTY(_errors),"",CHR(13)) + OBJ_JSON._errors.Array(I_err)._message
						ENDFOR
						
						WAIT WINDOWS SUBSTR("Risposta da '"+_HTTP_request+"'" + REPLICATE(CHR(13),2) + _errors,1,254) TIMEOUT 3
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
						IF !ExecRW(cSql,"LOG_SFSYNC","R")
						   return(.f.)
						ENDIF
						SELECT LOG_SFSYNC
						GO TOP
						IF !EOF()
							REPLACE ESITO WITH "KO"
							REPLACE MESSAGGIO WITH _errors
							_SEC_FIN = SECONDS()
							REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
						ENDIF
						IF !ExecRW(cSql,"LOG_SFSYNC","W")
						   return(.f.)
						ENDIF
						
						RETURN .F.

					ENDIF
					
				ENDIF
			ENDIF
		ENDIF
	
		SELECT TMP_LOCALITA_CONSEGNA
		LOOP
	ENDIF

	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_DESTINAZIONE__C
		SCATTER MEMVAR MEMO BLANK
		
		_cProperty = "OBJ_JSON._records.Array("+ALLTRIM(STR(I_row))+")._Id"
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			IF &_cProperty = ""
				LOOP
			ENDIF
		ENDIF
		
		=AMEMBERS(gaPropArray, obj_json._RECORDS.Array(I_row), 0)  && Array containing properties
		
		FOR I_col=1 TO ALEN(gaPropArray)
			_cProperty = "OBJ_JSON._records.Array("+ALLTRIM(STR(I_row))+")."+ALLTRIM(gaPropArray(I_col))
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				IF SUBSTR(ALLTRIM(gaPropArray(I_col)),1,1) = "_"
					_cCommand = "M."+SUBSTR(ALLTRIM(gaPropArray(I_col)),2)+" = "+_cProperty
					&_cCommand
				ENDIF
			ENDIF
		NEXT
		
		SELECT TMP_SF_DESTINAZIONE__C
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_DESTINAZIONE__C
	_SF_DESTINAZIONE__C_ID = ID
	*_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE			
	
	cSql = "SELECT * FROM U_LOC_AN WHERE RTRIM(LOC_CODCLI)+RTRIM(LOC_CODLOC) = '" + ALLTRIM(M.ExternalId__c) + "'"	
	IF !ExecRW(cSql,"U_LOC_AN","R")
		return(.f.)
	ENDIF
	SELECT U_LOC_AN 
	GO TOP
	IF !EOF()
		REPLACE SF_LOC_ID WITH _SF_DESTINAZIONE__C_ID
		*REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
	ENDIF
	IF !ExecRW(cSql,"U_LOC_AN","W")
		return(.f.)
	ENDIF

	SELECT TMP_SF_DESTINAZIONE__C
	ZAP

	_json_content = '{'
	_json_content = _json_content + '"Name": "' + _Name + '"'
	_json_content = _json_content + ', "Cliente__c": "' + _Cliente__c + '"'
	_json_content = _json_content + ', "Ragione_sociale__c": "' + _Ragione_sociale__c + '"'
	_json_content = _json_content + ', "All_attenzione_di__c": "' + _All_attenzione_di__c + '"'
	_json_content = _json_content + ', "Indirizzo__City__s": "' + _Indirizzo__City__s + '"'
	_json_content = _json_content + ', "Indirizzo__Street__s": "' + _Indirizzo__Street__s + '"'
	_json_content = _json_content + ', "Indirizzo__PostalCode__s": "' + _Indirizzo__PostalCode__s + '"'
	_json_content = _json_content + ', "Indirizzo__StateCode__s": "' + _Indirizzo__StateCode__s + '"'
	_json_content = _json_content + ', "Indirizzo__CountryCode__s": "' + _Indirizzo__CountryCode__s + '"'
	_json_content = _json_content + ', "Email__c": "' + _Email__c + '"'
	_json_content = _json_content + ', "Note__c": "' + _Note__c + '"'
	_json_content = _json_content + '}'
		
	*** AGGIORNAMENTO CAMPI SU SALESFORCE
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Destinazione__c/"+_SF_DESTINAZIONE__C_ID
	_cJson = ""

	*WAIT WINDOWS "Connessione a '"+_instance_url+"' in corso..." NOWAIT

	_cJson = SALESFORCEREST_PATCH(_HTTP_request,_access_token,_json_content)
	IF EMPTY(_cJson)
		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
		RETURN .F.
	ENDIF
	
	*WAIT WINDOWS "Elaborazione file Json per aggiornamento articolo " + _ProductCode + " in corso..." NOWAIT
	
	IF _cJson = "204"
		_CONTA_AGG_DA_AQ = _CONTA_AGG_DA_AQ + 1
	ELSE
		
		obj_json = json_decode(_cJson)

		*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
		IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
			_cProperty = "OBJ_JSON.Array(1)._message"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			
				_cProperty_errorcode = "OBJ_JSON.Array(1)._errorcode"
				IF TYPE(_cProperty_errorcode) <> 'U' AND TYPE(_cProperty_errorcode) <> 'O' AND !ISNULL(&_cProperty_errorcode)
					_errorcode = ALLTRIM(&_cProperty_errorcode)
					IF _errorcode = "DUPLICATES_DETECTED"
						
						WAIT WINDOWS SUBSTR("Errorcode: "+_errorcode+" - "+_cLocalita_Consegna+", pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
						_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
							"Warning: "+_errorcode+" - "+_cLocalita_Consegna+", pertanto non verrà considerato in questa elaborazione"
						SELECT TMP_LOCALITA_CONSEGNA
						LOOP
				
					ENDIF
				ENDIF
			
				_message = ALLTRIM(&_cProperty)
				WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
				IF !ExecRW(cSql,"LOG_SFSYNC","R")
				   return(.f.)
				ENDIF
				SELECT LOG_SFSYNC
				GO TOP
				IF !EOF()
					REPLACE ESITO WITH "KO"
					REPLACE MESSAGGIO WITH _cLocalita_Consegna + " - " + _message
					_SEC_FIN = SECONDS()
					REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
				ENDIF
				IF !ExecRW(cSql,"LOG_SFSYNC","W")
				   return(.f.)
				ENDIF
				
				RELEASE obj_json
				RETURN .F.
			ENDIF
		ENDIF
	
	ENDIF
		
ENDSCAN


**********************************************************************************************************************************************
*** ELABORAZIONE NUOVE LOCALITA DI CONSEGNA CREATE SU SFDC, DA INSERIRE ANCHE SU AQUARIUS, CHE DEVE RESTITUIRE IL CODICE LOCALITA' DI CONSEGNA
**********************************************************************************************************************************************

WAIT WINDOWS "Lettura nuove Località di consegna inserite su SalesForce..." NOWAIT

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,LastModifiedDate,Name,Cliente__c,Ragione_sociale__c,All_attenzione_di__c,Indirizzo__City__s,Indirizzo__Street__s,Indirizzo__PostalCode__s," + ;
	"Indirizzo__StateCode__s,Indirizzo__CountryCode__s,Email__c,Note__c,ExternalId__c+FROM+Destinazione__c+WHERE+ExternalId__c=null+OR+ExternalId__c=''"

_cJson = ""
_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione nuove Località di consegna inserite su SalesForce in corso..." NOWAIT

obj_json = json_decode(_cJson)

*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
	_cProperty = "OBJ_JSON.Array(1)._message"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_message = ALLTRIM(&_cProperty)
		WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH _message
			_SEC_FIN = SECONDS()
			REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
		ENDIF
		IF !ExecRW(cSql,"LOG_SFSYNC","W")
		   return(.f.)
		ENDIF
		
		RELEASE obj_json			
		RETURN .F.
	ENDIF
ENDIF

SELECT TMP_SF_DESTINAZIONE__C
ZAP

IF OBJ_JSON._totalSize > 0

	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_DESTINAZIONE__C
		SCATTER MEMVAR MEMO BLANK
		
		_cProperty = "OBJ_JSON._records.Array("+ALLTRIM(STR(I_row))+")._Id"
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			IF &_cProperty = ""
				LOOP
			ENDIF
		ENDIF
		
		=AMEMBERS(gaPropArray, obj_json._RECORDS.Array(I_row), 0)  && Array containing properties
		
		FOR I_col=1 TO ALEN(gaPropArray)
			_cProperty = "OBJ_JSON._records.Array("+ALLTRIM(STR(I_row))+")."+ALLTRIM(gaPropArray(I_col))
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				IF SUBSTR(ALLTRIM(gaPropArray(I_col)),1,1) = "_"
					_cCommand = "M."+SUBSTR(ALLTRIM(gaPropArray(I_col)),2)+" = "+_cProperty
					&_cCommand
				ENDIF
			ENDIF
		NEXT
		
		SELECT TMP_SF_DESTINAZIONE__C
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_DESTINAZIONE__C
	GO TOP
	SCAN
	
		*IF RECNO() > 1
		*	EXIT
		*ENDIF
		
		SCATTER MEMVAR MEMO
		
		cSql = "SELECT * FROM U_LOC_AN WHERE 1=0"
		IF !ExecCommand(cSql,"TMP_LOC_AN")
			return(.f.)
		ENDIF
		SELECT TMP_LOC_AN
		SCATTER MEMVAR MEMO BLANK
		
		M.SF_LOC_ID = M.ID
		M.SF_LASTMODIFIEDDATE = M.LASTMODIFIEDDATE
		M.LOC_CODCLI = ""
		x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
		x_sfid = "sf_account_id = '" + ALLTRIM(M.Cliente__c) + "'"
		x_cond = x_soci + " and " + x_sfid 
		cSql = "select CLI_CODCLI from U_ANA_CL where " + x_cond
		IF !ExecCommand(cSql,"CX_ANA_CL")
		   RETURN .F.
		ENDIF
		SELECT CX_ANA_CL
		GO TOP
		IF !EOF()
			M.LOC_CODCLI = ALLTRIM(CLI_CODCLI)
		ELSE
			WAIT WINDOWS SUBSTR("Warning: Cliente SalesForce con ID "+ALLTRIM(M.Cliente__c)+" non trovato in anagrafica Aquarius, pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
			_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
				"Warning: Cliente SalesForce con ID "+ALLTRIM(M.Cliente__c)+" non trovato in anagrafica Aquarius, pertanto non verrà considerato in questa elaborazione"
			SELECT TMP_SF_DESTINAZIONE__C
			LOOP
		ENDIF
		M.LOC_CODLOC = ""
		_NEW_CODLOC = "001"
		x_soci = "loc_codsoc = '" + PUB_CODSOC + "'"
		x_ccff = "loc_cf = 'C'"
		x_clie = "loc_codcli = '" + M.LOC_CODCLI + "'"
		x_cond = x_soci + " and " + x_ccff + " and " + x_clie
		cSql = "select loc_codloc from u_loc_an where " + x_cond + " order by loc_codloc desc"
		IF !ExecCommand(cSql,"CX_LOC_AN")
		   RETURN .F. 
		ENDIF
		SELECT CX_LOC_AN
		GO TOP
		IF EOF()
			_NEW_CODLOC = "001"
		ELSE
			SELECT MAX(VAL(loc_codloc)) AS N_CODLOC FROM CX_LOC_AN INTO CURSOR CN_LOC_AN
			SELECT CN_LOC_AN
			GO TOP
			IF !ISNULL(N_CODLOC)
				_nUltCodLoc = N_CODLOC
				IF _nUltCodLoc > 0
					_NEW_CODLOC = TRC(3,ALLTRIM(STR(_nUltCodLoc + 1,3,0)))
				ELSE
					_NEW_CODLOC = ""
				ENDIF
			ELSE
				_NEW_CODLOC = ""
			ENDIF
		ENDIF
		M.LOC_CF = "C"
		M.LOC_CODLOC = _NEW_CODLOC
		M.LOC_RAGSOC = APITOSPA(ALLTRIM(M.Ragione_sociale__c))
		M.LOC_ATTENZIONE = APITOSPA(ALLTRIM(M.All_attenzione_di__c))
		M.LOC_LOCALI = APITOSPA(ALLTRIM(M.Indirizzo__City__s))
		M.LOC_INDIRI = APITOSPA(ALLTRIM(M.Indirizzo__Street__s))
		M.LOC_CAP = APITOSPA(ALLTRIM(M.Indirizzo__PostalCode__s))
		M.LOC_PROVIN = APITOSPA(ALLTRIM(M.Indirizzo__StateCode__s))
		M.LOC_CODNAZ = ""
		IF !EMPTY(UPPER(ALLTRIM(M.Indirizzo__CountryCode__s)))
			x_cond = "codice LIKE 'STA%' AND libera = '" + UPPER(ALLTRIM(M.Indirizzo__CountryCode__s)) + "'"
			cSql   = "select substring(codice,4,3) AS COD_NAZIONE_AQ from para where " + x_cond 
			IF !ExecCommand(cSql,"TMP_PARA")
			   return(.f.)
			ENDIF
			SELECT TMP_PARA
			GO TOP
			IF !EOF()
				M.LOC_CODNAZ = COD_NAZIONE_AQ
			ENDIF
		ENDIF
		M.LOC_EMAIL = ALLTRIM(M.Email__c)
		M.LOC_VARIE = ALLTRIM(M.Note__c)
		
		M.LOC_CODSOC = PUB_CODSOC
		M.SF_LOC_ID = M.ID
		M.SF_LASTMODIFIEDDATE = M.LASTMODIFIEDDATE
		
		cSql = "SELECT * FROM U_LOC_AN WHERE 1=0"
		IF !ExecRW(cSql,"U_LOC_AN","R")
			return(.f.)
		ENDIF
		SELECT U_LOC_AN
		APPEND BLANK
		DO U_LOC_AN
		IF !ExecRW(cSql,"U_LOC_AN","W")
			return(.f.)
		ENDIF
		
		*** AGGIORNAMENTO CODICE LOCALITA' E EXTERNAL_ID SU SALESFORCE
		
		_json_content = '{'
		_json_content = _json_content + '"Name": "' + ALLTRIM(M.LOC_CODLOC) + '"'
		_json_content = _json_content + ', "ExternalId__c": "' + ALLTRIM(M.LOC_CODCLI)+ALLTRIM(M.LOC_CODLOC) + '"'
		_json_content = _json_content + '}'
				
		*** AGGIORNAMENTO CAMPI SU SALESFORCE
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Destinazione__c/"+ALLTRIM(M.SF_LOC_ID)
		_cJson = ""

		_cJson = SALESFORCEREST_PATCH(_HTTP_request,_access_token,_json_content)
		IF EMPTY(_cJson)
			WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
			RETURN .F.
		ENDIF
		
		IF _cJson = "204"
		ELSE
			
			obj_json = json_decode(_cJson)

			*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
			IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
				_cProperty = "OBJ_JSON.Array(1)._message"
				IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
					_message = ALLTRIM(&_cProperty)
					WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
					
					cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
					IF !ExecRW(cSql,"LOG_SFSYNC","R")
					   return(.f.)
					ENDIF
					SELECT LOG_SFSYNC
					GO TOP
					IF !EOF()
						REPLACE ESITO WITH "KO"
						REPLACE MESSAGGIO WITH _message
						_SEC_FIN = SECONDS()
						REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
					ENDIF
					IF !ExecRW(cSql,"LOG_SFSYNC","W")
					   return(.f.)
					ENDIF
					
					RELEASE obj_json
					RETURN .F.
				ENDIF
			ENDIF
		
		ENDIF
		
		_CONTA_INS_DA_SF = _CONTA_INS_DA_SF + 1
		
		RELEASE obj_json
		
	ENDSCAN
ENDIF




_HTTP_request = ALLTRIM(PUB_SFLOGOUT)
_cJson = ""
WAIT WINDOWS SUBSTR("Connessione per Logout a '"+_HTTP_request+"' in corso...",1,254) NOWAIT

_cJson = SALESFORCEREST_POST_LOGOUT(_HTTP_request,"token="+_access_token,"")
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione file Json per Logout in corso..." NOWAIT

IF _cJson = "200"
ELSE
	
	obj_json = json_decode(_cJson)

	*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
		_cProperty = "OBJ_JSON.Array(1)._message"
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			_message = ALLTRIM(&_cProperty)
			WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
			IF !ExecRW(cSql,"LOG_SFSYNC","R")
			   return(.f.)
			ENDIF
			SELECT LOG_SFSYNC
			GO TOP
			IF !EOF()
				REPLACE ESITO WITH "KO"
				REPLACE MESSAGGIO WITH _message
				_SEC_FIN = SECONDS()
				REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
			ENDIF
			IF !ExecRW(cSql,"LOG_SFSYNC","W")
			   return(.f.)
			ENDIF
			
			RELEASE obj_json
			RETURN .F.
		ENDIF
	ENDIF

ENDIF

RELEASE obj_json


_MESSAGGIO = ""
IF _CONTA_INS_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale Località di consegna inserite da Aquarius: " + ALLTRIM(STR(_CONTA_INS_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessuna Località di consegna inserita da Aquarius"
ENDIF
IF _CONTA_AGG_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale Località di consegna aggiornate da Aquarius: " + ALLTRIM(STR(_CONTA_AGG_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessuna Località di consegna aggiornata da Aquarius"
ENDIF
IF _CONTA_DEL_DA_SF > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale Località di consegna cancellate su SalesForce: " + ALLTRIM(STR(_CONTA_DEL_DA_SF))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessuna Località di consegna cancellata su SalesForce"
ENDIF
IF _CONTA_INS_DA_SF > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale Località di consegna inserite da SalesForce: " + ALLTRIM(STR(_CONTA_INS_DA_SF))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessuna Località di consegna inserita da SalesForce"
ENDIF


cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
IF !ExecRW(cSql,"LOG_SFSYNC","R")
   return(.f.)
ENDIF
SELECT LOG_SFSYNC
GO TOP
IF !EOF()
	REPLACE ESITO WITH "OK"
	REPLACE MESSAGGIO WITH ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)+CHR(10)) + _MESSAGGIO
	REPLACE NRECINS_FROM_AQ WITH _CONTA_INS_DA_AQ
	REPLACE NRECAGG_FROM_AQ WITH _CONTA_AGG_DA_AQ
	REPLACE NRECINS_FROM_SF WITH _CONTA_INS_DA_SF
	REPLACE NRECAGG_FROM_SF WITH _CONTA_AGG_DA_SF
	_SEC_FIN = SECONDS()
	REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
ENDIF
IF !ExecRW(cSql,"LOG_SFSYNC","W")
   return(.f.)
ENDIF

WAIT CLEAR

IF !_par_scheduled
	MESSAGEBOX(_MESSAGGIO,64,"Informazione",5000)
ENDIF

_OK_SYNC_LOCALITA_CONSEGNA = .T.
			
RETURN .T.


**********************************************************************
FUNCTION LOOKUP_ACCOUNT
**********************************************************************
LPARAMETERS _par_cliente

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 17/03/2025

_RIT = ""

_Codice_Cliente__c = ALLTRIM(_par_cliente)

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Codice_Cliente__c+FROM+Account+WHERE+Codice_Cliente__c='"+_Codice_Cliente__c+"'"

_cJson = ""
_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_L_SELECT)  && ERASMO - 17/03/2025
	RETURN ""
ENDIF

obj_json = json_decode(_cJson)

*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)		
	_cProperty = "OBJ_JSON.Array(1)._message"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_message = ALLTRIM(&_cProperty)
		
		WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'LOCALITA_CONSEGNA' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Cliente " + _Codice_Cliente__c + " non trovato in tabella SFDC Account"
			_SEC_FIN = SECONDS()
			REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
		ENDIF
		IF !ExecRW(cSql,"LOG_SFSYNC","W")
		   return(.f.)
		ENDIF
		
		RELEASE obj_json
		SELECT(_L_SELECT)  && ERASMO - 17/03/2025
		RETURN ""
	ENDIF
ENDIF

IF TYPE("obj_json") = 'O' AND OBJ_JSON._totalSize > 0
ELSE	
	RELEASE obj_json
	SELECT(_L_SELECT)  && ERASMO - 17/03/2025
	RETURN ""
ENDIF

FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
	_cProperty = "OBJ_JSON._records.Array("+ALLTRIM(STR(I_row))+")._Id"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		IF &_cProperty = ""
			LOOP
		ENDIF
	ENDIF
	
	=AMEMBERS(gaPropArray, obj_json._RECORDS.Array(I_row), 0)  && Array containing properties
	
	FOR I_col=1 TO ALEN(gaPropArray)
		_cProperty = "OBJ_JSON._records.Array("+ALLTRIM(STR(I_row))+")."+ALLTRIM(gaPropArray(I_col))
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			IF SUBSTR(ALLTRIM(gaPropArray(I_col)),1,1) = "_"
				_cCommand = "M."+SUBSTR(ALLTRIM(gaPropArray(I_col)),2)+" = "+_cProperty
				&_cCommand
			ENDIF
		ENDIF
	NEXT
	
	IF TYPE("M.ID") == 'C'
		_RIT = M.ID
	ENDIF
	
NEXT

RELEASE obj_json

SELECT(_L_SELECT)  && ERASMO - 17/03/2025

RETURN _RIT

ENDFUNC

