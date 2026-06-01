
LPARAMETERS _par_scheduled,_par_group_codsys,_par_tipo_parametro

IF PCOUNT() >= 1
ELSE
	_par_scheduled = .F.
ENDIF

IF PCOUNT() >= 2
ELSE
	_par_group_codsys = ""
ENDIF

IF PCOUNT() >= 3
ELSE
	WAIT WINDOWS "Tipo parametro obbligatorio" TIMEOUT 3
	RETURN .F.
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
_LOG_OGGETTO = _par_tipo_parametro
_LOG_DATA = RIBALTA2(DTOC(DATE()))
_LOG_ORA = TIME()
_LOG_CODOPE = ALLTRIM(PUB_CODOPE)
_LOG_NOMOPE = ALLTRIM(PUB_NOMOPE)

RELEASE V_SF_OBJECT_NAME,V_PREFISSO_PARA_AQ,V_FASCIACOMPETENZA
PUBLIC V_SF_OBJECT_NAME,V_PREFISSO_PARA_AQ,V_FASCIACOMPETENZA
V_SF_OBJECT_NAME = ""
V_PREFISSO_PARA_AQ = ""
V_FASCIACOMPETENZA = ""
DO CASE
	CASE _LOG_OGGETTO == "CODICI_IVA"
		V_SF_OBJECT_NAME = "Codice_IVA__c"
		V_PREFISSO_PARA_AQ = "IVA"
	CASE _LOG_OGGETTO == "CAUSALI_ORDINI"
		V_SF_OBJECT_NAME = "Causale_ordine__c"
		V_PREFISSO_PARA_AQ = "TOP"
		V_FASCIACOMPETENZA = "O"
	CASE _LOG_OGGETTO == "TIPOLOGIE_ORDINI"
		V_SF_OBJECT_NAME = "Tipologia_Ordine__c"
		V_PREFISSO_PARA_AQ = "TPO"
	CASE _LOG_OGGETTO == "CONDIZIONI_PAGAMENTO"
		V_SF_OBJECT_NAME = "Condizioni_di_pagamento__c"
		V_PREFISSO_PARA_AQ = "CPA"
	CASE _LOG_OGGETTO == "PORTO"
		V_SF_OBJECT_NAME = "Porto__c"
		V_PREFISSO_PARA_AQ = "POR"
	CASE _LOG_OGGETTO == "MEZZO"
		V_SF_OBJECT_NAME = "Mezzo__c"
		V_PREFISSO_PARA_AQ = "MEZ"
	OTHERWISE
		WAIT WINDOWS "Tipo parametro " + _LOG_OGGETTO + " non previsto" TIMEOUT 3
		RETURN .F.		
ENDCASE

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

*** CONTROLLI DI LOGIN SUPERATI, PROCEDO CON LE CHIAMATE SPECIFICHE PER LA SINCRONIZZAZIONE DEI PARAMETRI


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

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DEI PARAMETRI PRESENTI SU SALESFORCE
CREATE CURSOR TMP_SF_PARAMETRO ( ;
	Id C(254), ;
	Codice__c C(254), ;
	Name C(254), ;
	Libera__c C(254), ;
	Attiva__c C(254), ;
	Attivo__c C(254), ;
	Societ__c C(254))

*** ELABORAZIONE PARAMETRI AQUARIUS ELIMINATI (LO ESEGUO IMMEDIATAMENTE PERCHE' POTREBBE ESSERE STATA REINSERITO SUCCESSIVAMENTE)
WAIT WINDOWS "Elaborazione PARAMETRI Aquarius eliminati.." NOWAIT

cSql="SELECT * FROM LOG_DELETED WHERE TABLE_NAME = 'PARA' AND LIBERA NOT LIKE '%DELETED FROM SFDC%' ORDER BY CHIAVE"
cNomeCursorSql="TMP_LOG_DELETED_PARA"
IF !ExecCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF
SELECT TMP_LOG_DELETED_PARA
GO TOP
SCAN
	_Codice__c = ENCODE_URI_SF(ALLTRIM(AGGANCIO))
		
	*** ELIMINAZIONE PARAMETRO IN LINEA SU SFDC NON PIU' PRESENTE SU AQUARIUS		
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id+FROM+"+V_SF_OBJECT_NAME+"+WHERE+Codice__c='"+_Codice__c+"'"
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = '" + _LOG_OGGETTO + "' AND CODSYS = '" + _LOG_CODSYS + "'"
			IF !ExecRW(cSql,"LOG_SFSYNC","R")
			   return(.f.)
			ENDIF
			SELECT LOG_SFSYNC
			GO TOP
			IF !EOF()
				REPLACE ESITO WITH "KO"
				REPLACE MESSAGGIO WITH  "Parametro " + _Codice__c + " - " + _message
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
			
			*** CANCELLAZIONE RECORD SU SFDC
			_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/"+V_SF_OBJECT_NAME+"/"+&_cProperty
			_cJson = ""
			_cJson = SALESFORCEREST_DELETE(_HTTP_request,_access_token)
			IF EMPTY(_cJson)
				WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
				_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
					"Warning: Oggetto JSON restituito VUOTO durante il tentativo di cancellazione Parametro Id=" + &_cProperty + " (" + _Codice__c + ")"
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
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = '" + _LOG_OGGETTO + "' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
	SELECT TMP_LOG_DELETED_PARA
	cSql="SELECT * FROM LOG_DELETED WHERE TABLE_NAME = 'PARA' AND LIBERA NOT LIKE '%DELETED FROM SFDC%' AND AGGANCIO = '" + ALLTRIM(AGGANCIO) + "' AND CHIAVE = '" + ALLTRIM(CHIAVE) + "' ORDER BY CHIAVE"
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
	SELECT TMP_LOG_DELETED_PARA
	
ENDSCAN



*** ELABORAZIONE PARAMETRI AQUARIUS MODIFICATI RISPETTO ALL'ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE
WAIT WINDOWS "Lettura " + _LOG_OGGETTO + " Aquarius modificati o inseriti rispetto all'ultima sincronizzazione..." NOWAIT

_ULT_TS_SYNC_PARA = ""
cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = '" + _LOG_OGGETTO + "' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
IF !ExecCommand(cSql,"ULT_TS_SYNC_LOC_CONS")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_LOC_CONS
GO TOP
_ULT_TS_SYNC_PARA = LAST_DATE

*_ULT_TS_SYNC_PARA = '1950/01/0100:00:00'  && ###TEST### TUTTI I CODICI IVA ###TEST###

x_cond = "(CASE PA.MOD_DATREG WHEN '' THEN (PA.REG_DATREG+CASE PA.REG_ORAREG WHEN '' THEN '23:59:59' ELSE PA.REG_ORAREG END) ELSE PA.MOD_DATREG+CASE PA.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE PA.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_PARA + "'"
IF _LOG_OGGETTO == "CAUSALI_ORDINI" AND !EMPTY(V_FASCIACOMPETENZA)
	x_cond = x_cond + " AND SUBSTRING(LIBERA,42,1) = '" + V_FASCIACOMPETENZA + "'"
ENDIF
cSql=""     
cNomeCursorSql="TMP_PARA"
TEXT TO cSql NOSHOW
	
	SELECT
		SUBSTRING(PA.CODICE,<<ALLTRIM(STR(LEN(V_PREFISSO_PARA_AQ)+1,30,0))>>,30) AS Codice__c,
		PA.DESCRI AS Name,
		PA.LIBERA AS Libera__c,
		PA.DISATTIVO
	FROM PARA AS PA
	WHERE CODICE LIKE '<<V_PREFISSO_PARA_AQ>>%' AND <<x_cond>>
	ORDER BY CODICE
	
ENDTEXT
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT TMP_PARA
GO TOP
SCAN

*!*		IF RECNO() > 10
*!*			EXIT
*!*		ENDIF
	
*!*		IF ALLTRIM(Codice__c) == 'OM'
*!*			SET STEP ON
*!*		ENDIF
	
	WAIT WINDOWS "Elaborazione Parametro Aquarius " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	SCATTER MEMVAR MEMO
	
	_Name = ENCODE_URI_SF(ALLTRIM(M.Name))
	_Codice__c = ENCODE_URI_SF(ALLTRIM(M.Codice__c))
	_Libera__c = ENCODE_URI_SF(ALLTRIM(M.Libera__c))
	_Attivo__c = IIF(M.DISATTIVO,"false","true")
	_Attiva__c = IIF(M.DISATTIVO,"false","true")
	
	*** PULIZIA CARATTERE CR E LF
	_Name = STRTRAN(STRTRAN(_Name,CHR(13),' '),CHR(10),'')
	
	*** ESCAPING CARATTERE \
	_Name = STRTRAN(_Name,'\','\\')
	_Codice__c = STRTRAN(_Codice__c,'\','\\')
	_Libera__c = STRTRAN(_Libera__c,'\','\\')
	
	*** ESCAPING CARATTERE "
	_Name = STRTRAN(_Name,'"','\"')
	_Codice__c = STRTRAN(_Codice__c,'"','\"')
	_Libera__c = STRTRAN(_Libera__c,'"','\"')
	
	*** ESCAPING CARATTERE /
	_Name = STRTRAN(_Name,'/','\/')
	_Codice__c = STRTRAN(_Codice__c,'/','\/')
	_Libera__c = STRTRAN(_Libera__c,'/','\/')
	
	_cParametro = _LOG_OGGETTO + " " + ALLTRIM(_Codice__c) + " (" + ALLTRIM(_Name) + ")"
		
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id+FROM+"+V_SF_OBJECT_NAME+"+WHERE+Codice__c='"+_Codice__c+"'"
	_cJson = ""
	_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
	IF EMPTY(_cJson)
		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
		RETURN .F.
	ENDIF
	
	obj_json = json_decode(_cJson)

	*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)		
		_cProperty = "OBJ_JSON.Array(1)._message"
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			_message = ALLTRIM(&_cProperty)
			
			WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = '" + _LOG_OGGETTO + "' AND CODSYS = '" + _LOG_CODSYS + "'"
			IF !ExecRW(cSql,"LOG_SFSYNC","R")
			   return(.f.)
			ENDIF
			SELECT LOG_SFSYNC
			GO TOP
			IF !EOF()
				REPLACE ESITO WITH "KO"
				REPLACE MESSAGGIO WITH _cParametro + " - " + _message
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
	
	SELECT TMP_SF_PARAMETRO
	ZAP
	
	IF OBJ_JSON._totalSize = 0
		
		*** INSERIMENTO NUOVA LOCALITA DI CONSEGNA SU SALESFORCE
		
		_json_content = '{'
		_json_content = _json_content + '"Name": "' + _Name + '"'
		_json_content = _json_content + ', "Codice__c": "' + _Codice__c + '"'
		DO CASE
			CASE _LOG_OGGETTO == "CODICI_IVA"
				_json_content = _json_content + ', "Libera__c": "' + _Libera__c + '"'
				_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
			CASE _LOG_OGGETTO == "CAUSALI_ORDINI"
				_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
			CASE _LOG_OGGETTO == "TIPOLOGIE_ORDINI"
				_json_content = _json_content + ', "Codici_causali_legati__c": "' + _Libera__c + '"'
				_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
			CASE _LOG_OGGETTO == "CONDIZIONI_PAGAMENTO"
				_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
			CASE _LOG_OGGETTO == "PORTO"
				_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
			CASE _LOG_OGGETTO == "MEZZO"
				_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
		ENDCASE
		_json_content = _json_content + '}'
		
		_cJson = ""
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/"+V_SF_OBJECT_NAME+"/"

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
					
					WAIT WINDOWS SUBSTR("Errorcode: "+_errorcode+" - "+_cParametro+", pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
					_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
						"Warning: "+_errorcode+" - "+_cParametro+", pertanto non verrà considerato in questa elaborazione"
					SELECT TMP_PARA
					LOOP
			
				ENDIF
			ENDIF
			
			_cProperty = "OBJ_JSON.Array(1)._message"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_message = ALLTRIM(&_cProperty)
				
				WAIT WINDOWS SUBSTR("Risposta da '"+_HTTP_request+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = '" + _LOG_OGGETTO + "' AND CODSYS = '" + _LOG_CODSYS + "'"
				IF !ExecRW(cSql,"LOG_SFSYNC","R")
				   return(.f.)
				ENDIF
				SELECT LOG_SFSYNC
				GO TOP
				IF !EOF()
					REPLACE ESITO WITH "KO"
					REPLACE MESSAGGIO WITH _cParametro + " - " + _message
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
							
							cSql = "select * from LOG_SFSYNC WHERE OGGETTO = '" + _LOG_OGGETTO + "' AND CODSYS = '" + _LOG_CODSYS + "'"
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
						
*!*								_SF_DESTINAZIONE__C_ID = _id
*!*								_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
*!*								
*!*								cSql = "SELECT * FROM U_LOC_AN WHERE LOC_CODCLI = '" + ALLTRIM(M.Codice_Cliente__c) + "' AND LOC_CODLOC = '" + ALLTRIM(M.Name) + "'"	
*!*								IF !ExecRW(cSql,"U_LOC_AN","R")
*!*									return(.f.)
*!*								ENDIF
*!*								SELECT U_LOC_AN 
*!*								GO TOP
*!*								IF !EOF()
*!*									REPLACE SF_LOC_ID WITH _SF_DESTINAZIONE__C_ID
*!*									REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
*!*								ENDIF
*!*								IF !ExecRW(cSql,"U_LOC_AN","W")
*!*									return(.f.)
*!*								ENDIF
							
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
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = '" + _LOG_OGGETTO + "' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
		SELECT TMP_PARA
		LOOP
	ENDIF

	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_PARAMETRO
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
		
		SELECT TMP_SF_PARAMETRO
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_PARAMETRO
	_SF_PARAMETRO_ID = ID
*!*		_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE			
*!*		
*!*		cSql = "SELECT * FROM U_LOC_AN WHERE LOC_CODCLI = '" + ALLTRIM(M.Codice_Cliente__c) + "' AND LOC_CODLOC = '" + ALLTRIM(M.Name) + "'"	
*!*		IF !ExecRW(cSql,"U_LOC_AN","R")
*!*			return(.f.)
*!*		ENDIF
*!*		SELECT U_LOC_AN 
*!*		GO TOP
*!*		IF !EOF()
*!*			REPLACE SF_LOC_ID WITH _SF_DESTINAZIONE__C_ID
*!*			REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
*!*		ENDIF
*!*		IF !ExecRW(cSql,"U_LOC_AN","W")
*!*			return(.f.)
*!*		ENDIF

	SELECT TMP_SF_PARAMETRO
	ZAP

	_json_content = '{'
	_json_content = _json_content + '"Name": "' + _Name + '"'
	DO CASE
		CASE _LOG_OGGETTO == "CODICI_IVA"
			_json_content = _json_content + ', "Libera__c": "' + _Libera__c + '"'
			_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
		CASE _LOG_OGGETTO == "CAUSALI_ORDINI"
			_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
		CASE _LOG_OGGETTO == "TIPOLOGIE_ORDINI"
			_json_content = _json_content + ', "Codici_causali_legati__c": "' + _Libera__c + '"'
			_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
		CASE _LOG_OGGETTO == "CONDIZIONI_PAGAMENTO"
			_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
		CASE _LOG_OGGETTO == "PORTO"
			_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
		CASE _LOG_OGGETTO == "MEZZO"
			_json_content = _json_content + ', "Attiva__c": ' + _Attiva__c
	ENDCASE
	_json_content = _json_content + '}'
		
	*** AGGIORNAMENTO CAMPI SU SALESFORCE
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/"+V_SF_OBJECT_NAME+"/"+_SF_PARAMETRO_ID
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
						
						WAIT WINDOWS SUBSTR("Errorcode: "+_errorcode+" - "+_cParametro+", pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
						_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
							"Warning: "+_errorcode+" - "+_cParametro+", pertanto non verrà considerato in questa elaborazione"
						SELECT TMP_PARA
						LOOP
				
					ENDIF
				ENDIF
			
				_message = ALLTRIM(&_cProperty)
				WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = '" + _LOG_OGGETTO + "' AND CODSYS = '" + _LOG_CODSYS + "'"
				IF !ExecRW(cSql,"LOG_SFSYNC","R")
				   return(.f.)
				ENDIF
				SELECT LOG_SFSYNC
				GO TOP
				IF !EOF()
					REPLACE ESITO WITH "KO"
					REPLACE MESSAGGIO WITH _cParametro + " - " + _message
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = '" + _LOG_OGGETTO + "' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale Parametri inseriti da Aquarius: " + ALLTRIM(STR(_CONTA_INS_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun Parametro inserito da Aquarius"
ENDIF
IF _CONTA_AGG_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale Parametri aggiornati da Aquarius: " + ALLTRIM(STR(_CONTA_AGG_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun Parametro aggiornato da Aquarius"
ENDIF
IF _CONTA_DEL_DA_SF > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale Parametri cancellati su SalesForce: " + ALLTRIM(STR(_CONTA_DEL_DA_SF))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun Parametro cancellato su SalesForce"
ENDIF

cSql = "select * from LOG_SFSYNC WHERE OGGETTO = '" + _LOG_OGGETTO + "' AND CODSYS = '" + _LOG_CODSYS + "'"
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

_OK_SYNC_PARAMETRI = .T.
			
RETURN .T.


**********************************************************************
FUNCTION ENCODE_URI_SF
**********************************************************************
LPARAMETERS _par_string

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_RIT = ALLTRIM(_par_string)
_RIT = STRTRAN(_RIT,'&','%26')
_RIT = STRTRAN(_RIT,'"','%22')

RETURN _RIT

ENDFUNC



*!*	**********************************************************************
*!*	FUNCTION LOOKUP_ACCOUNT
*!*	**********************************************************************
*!*	LPARAMETERS _par_cliente

*!*	IF PCOUNT() >= 1
*!*	ELSE
*!*		RETURN ""
*!*	ENDIF

*!*	_RIT = ""

*!*	_Codice_Cliente__c = ALLTRIM(_par_cliente)

*!*	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Codice_Cliente__c+FROM+Account+WHERE+Codice_Cliente__c='"+_Codice_Cliente__c+"'"

*!*	_cJson = ""
*!*	_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
*!*	IF EMPTY(_cJson)
*!*		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
*!*		RETURN ""
*!*	ENDIF

*!*	obj_json = json_decode(_cJson)

*!*	*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
*!*	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)		
*!*		_cProperty = "OBJ_JSON.Array(1)._message"
*!*		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
*!*			_message = ALLTRIM(&_cProperty)
*!*			
*!*			WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
*!*			
*!*			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = '" + _LOG_OGGETTO + "' AND CODSYS = '" + _LOG_CODSYS + "'"
*!*			IF !ExecRW(cSql,"LOG_SFSYNC","R")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT LOG_SFSYNC
*!*			GO TOP
*!*			IF !EOF()
*!*				REPLACE ESITO WITH "KO"
*!*				REPLACE MESSAGGIO WITH "Cliente " + _Codice_Cliente__c + " non trovato in tabella SFDC Account"
*!*				_SEC_FIN = SECONDS()
*!*				REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
*!*			ENDIF
*!*			IF !ExecRW(cSql,"LOG_SFSYNC","W")
*!*			   return(.f.)
*!*			ENDIF
*!*			
*!*			RELEASE obj_json
*!*			RETURN ""
*!*		ENDIF
*!*	ENDIF

*!*	IF OBJ_JSON._totalSize > 0
*!*	ELSE	
*!*		RELEASE obj_json			
*!*		RETURN ""
*!*	ENDIF

*!*	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
*!*			
*!*		_cProperty = "OBJ_JSON._records.Array("+ALLTRIM(STR(I_row))+")._Id"
*!*		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
*!*			IF &_cProperty = ""
*!*				LOOP
*!*			ENDIF
*!*		ENDIF
*!*		
*!*		=AMEMBERS(gaPropArray, obj_json._RECORDS.Array(I_row), 0)  && Array containing properties
*!*		
*!*		FOR I_col=1 TO ALEN(gaPropArray)
*!*			_cProperty = "OBJ_JSON._records.Array("+ALLTRIM(STR(I_row))+")."+ALLTRIM(gaPropArray(I_col))
*!*			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
*!*				IF SUBSTR(ALLTRIM(gaPropArray(I_col)),1,1) = "_"
*!*					_cCommand = "M."+SUBSTR(ALLTRIM(gaPropArray(I_col)),2)+" = "+_cProperty
*!*					&_cCommand
*!*				ENDIF
*!*			ENDIF
*!*		NEXT
*!*		
*!*		IF TYPE("M.ID") == 'C'
*!*			_RIT = M.ID
*!*		ENDIF
*!*		
*!*	NEXT

*!*	RELEASE obj_json

*!*	RETURN _RIT

*!*	ENDFUNC

