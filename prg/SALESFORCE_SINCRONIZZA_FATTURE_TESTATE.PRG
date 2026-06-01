
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

_MSG_WARNINGS = ""

_LOG_CODSYS = IIF(EMPTY(_par_group_codsys),SYS(2015),_par_group_codsys)
_LOG_OGGETTO = "FATTURE_TESTATE"
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

*** CONTROLLI DI LOGIN SUPERATI, PROCEDO CON LE CHIAMATE SPECIFICHE PER LA SINCRONIZZAZIONE DELLE FATTURE


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

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DELLE FATTURE PRESENTI SU SALESFORCE
CREATE CURSOR TMP_SF_FATTURA_TESTATA__C ( ;
	External_id__c C(254), ;
	Data_fattura__c C(254), ;
	Tipologia_ordine__c C(254), ;
	Numero_fattura__c C(254), ;
	Account__c C(254), ;
	Numero_ordine_cliente__c C(254), ;
	Data_ordine_cliente__c C(254), ;
	Causale__c C(254), ;
	Condizioni_pagamento__c C(254), ;
	Numero_preventivo__c C(254), ;
	Data_preventivo__c C(254), ;
	Centro_di_costo__c C(254), ;
	Valore_fattura__c C(254), ;
	Cup__c C(254), ;
	Cig__c C(254), ;
	Descrizione_causale__c C(254), ;
	Riferimenti_amministrativi__c C(254), ;
	Endpoint_cliente__c C(254), ;
	Codice_destinatario__c C(254), ;
	Email_pec__c C(254), ;
	Note_varie__c C(254), ;
	Name C(254), ;
	OwnerId C(254), ;
	LastModifiedDate C(254))

*** ELABORAZIONE TESTATE FATTURE AQUARIUS MODIFICATE O INSERITE RISPETTO ALL'ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE
WAIT WINDOWS "Lettura Testate Fatture Aquarius modificate o inserite rispetto all'ultima sincronizzazione..." NOWAIT

_ULT_TS_SYNC_FAT = ""
cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
IF !ExecCommand(cSql,"ULT_TS_SYNC_FAT")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_FAT
GO TOP
_ULT_TS_SYNC_FAT = LAST_DATE

*_ULT_TS_SYNC_FAT = '2023/12/1000:00:00'  && ###TEST### TUTTE LE RIGHE FATTURA ###TEST###

x_cond = "ACL.SF_ACCOUNT_ID <> '' AND (CASE TT.MOD_DATREG WHEN '' THEN (TT.REG_DATREG+CASE TT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE TT.REG_ORAREG END) " + ;
         "ELSE TT.MOD_DATREG+CASE TT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE TT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_FAT + "'"
*x_cond = x_cond + " AND TT.ORD_NUMORD >= '001330' "
*x_cond = x_cond + " AND TT.ORD_CCOSTO = 'ITAGM' "
*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND SUBSTRING(TT.ORD_DATORD,1,4) = '2015' "
*x_cond = x_cond + " AND TT.TAGGANCIO >= '6000022319' "
cSql=""     
cNomeCursorSql="TMP_FATTURATO"
TEXT TO cSql NOSHOW
	
	SELECT
		TT.TAGGANCIO,
		TT.ORD_DATORD,
		TT.ORD_TIPOLOGIA,
		COALESCE(TIPORD.DESCRI,'') AS DESCR_TIPORD,
		TT.ORD_NUMORD,
		ACL.SF_ACCOUNT_ID,
		TT.ORD_NUMORC,
		TT.ORD_DATORC,
		TT.ORD_CAUS,
		COALESCE(CAUSAL.DESCRI,'') AS DESCR_CAUSAL,
		TT.ORD_CPA,
		TT.ORD_NUMOFC,
		TT.ORD_DATOFC,
		TT.ORD_CCOSTO,
		--TT.ORD_IMPONIB,
		TT.ORD_IMPONIB * CASE WHEN SUBSTRING(COALESCE(CAUSAL.LIBERA,''),11,1) = 'S' THEN -1 ELSE 1 END AS ORD_IMPONIB,  -- ERASMO - 17/11/2021
		TT.ORD_CAMBIO,
		TT.ORD_CUP,
		TT.ORD_CIG,
		TT.ORD_FECAUS,
		TT.ORD_RIFAMMFE,
		COALESCE(O2.ORD_IDNSO,'') AS ORD_IDNSO,
		TT.ORD_IDSDI,
		TT.ORD_EPEC,
		TT.ORD_VARIE
	FROM U_FAT_TT AS TT
	LEFT OUTER JOIN PARA AS TIPORD ON TIPORD.CODICE = 'TPO'+TT.ORD_TIPOLOGIA
	LEFT OUTER JOIN U_CLI_AN AS CLI ON TT.ORD_CODCLI = CLI.CLI_CODCLI 
	LEFT OUTER JOIN U_ANA_CL AS ACL ON TT.ORD_CODCLI = ACL.CLI_CODCLI 	
	LEFT OUTER JOIN PARA AS CAUSAL ON CAUSAL.CODICE = 'TOP'+TT.ORD_CAUS
	LEFT OUTER JOIN U_ORD_TT AS OT ON OT.ORD_CODCLI = TT.ORD_CODCLI AND OT.ORD_NUMORD = TT.ORD_NUMORC AND OT.ORD_DATORD = TT.ORD_DATORC
	LEFT OUTER JOIN U_ORD_T2 AS O2 ON OT.TAGGANCIO = O2.TAGGANCIO
	WHERE <<x_cond>>
	ORDER BY TT.ORD_DATORD,TT.ORD_NUMORD

ENDTEXT

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT TMP_FATTURATO
GO TOP
SCAN

*!*		IF RECNO() > 100
*!*			EXIT
*!*		ENDIF
	
	WAIT WINDOWS "Elaborazione testata fattura Aquarius " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	_External_id__c = ALLTRIM(TAGGANCIO)
	
	_Data_fattura__c = FORMATTA_DATA(ORD_DATORD)
	_Tipologia_ordine__c = PARSE_STRING(ORD_TIPOLOGIA)
	_Numero_fattura__c = ALLTRIM(ORD_NUMORD)
	_Account__c =  ALLTRIM(SF_ACCOUNT_ID)
	_Numero_ordine_cliente__c = PARSE_STRING(ORD_NUMORC)
	_Data_ordine_cliente__c = FORMATTA_DATA(ORD_DATORC)
	_Causale__c = ALLTRIM(ORD_CAUS)
	_Condizioni_pagamento__c = ALLTRIM(ORD_CPA)
	_Numero_preventivo__c = PARSE_STRING(ORD_NUMOFC)
	_Data_preventivo__c = FORMATTA_DATA(ORD_DATOFC)
	_Centro_di_costo__c = PARSE_STRING(ORD_CCOSTO)
	_Valore_fattura__c = STRTRAN(ALLTRIM(STR(ROUND(ORD_IMPONIB*ORD_CAMBIO,2),16,2)),',','.')
	_Cup__c = PARSE_STRING(ORD_CUP)
	_Cig__c = PARSE_STRING(ORD_CIG)
	_Descrizione_causale__c = PARSE_STRING(ORD_FECAUS)
	_Riferimenti_amministrativi__c = PARSE_STRING(ORD_RIFAMMFE)
	_Endpoint_cliente__c = PARSE_STRING(ORD_IDNSO)
	_Codice_destinatario__c = PARSE_STRING(ORD_IDSDI)
	_Email_pec__c = PARSE_STRING(ORD_EPEC)
	_Note_varie__c = PARSE_STRING(ORD_VARIE)
	*_Name = ALLTRIM(TAGGANCIO)
	_Name = ALLTRIM(ORD_NUMORD)  && ERASMO - 08/11/2021
	*_OwnerId = LOOKUP_USER(ORD_CCOSTO)
	_OwnerId = LOOKUP_USER(ENCODE_URI_SF(ORD_CCOSTO))
	IF EMPTY(_OwnerId)
*!*			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
*!*			IF !ExecRW(cSql,"LOG_SFSYNC","R")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT LOG_SFSYNC
*!*			GO TOP
*!*			IF !EOF()
*!*				REPLACE ESITO WITH "KO"
*!*				REPLACE MESSAGGIO WITH "Testata Fattura " + _Numero_Fattura__c + " del " + Data_fattura__c + " - User SFDC non trovato per Centro di costo '" + _Centro_di_costo__c + "'"
*!*				_SEC_FIN = SECONDS()
*!*				REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
*!*			ENDIF
*!*			IF !ExecRW(cSql,"LOG_SFSYNC","W")
*!*			   return(.f.)
*!*			ENDIF
*!*			RETURN .F.
		WAIT WINDOWS SUBSTR("Testata Fattura " + _Numero_Fattura__c + " del " + _Data_fattura__c + " - User SFDC non trovato per Centro di costo '" + _Centro_di_costo__c + "'",1,254) TIMEOUT 2
		_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
			"Warning: Testata Fattura " + _Numero_Fattura__c + " del " + _Data_fattura__c + " - User SFDC non trovato per Centro di costo '" + _Centro_di_costo__c + "'"
*!*			SELECT TMP_FATTURATO
*!*			LOOP
	ENDIF	
	
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Account__c+FROM+Fattura_testata__c+WHERE+External_id__c='"+_External_id__c+"'"

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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
	SELECT TMP_SF_FATTURA_TESTATA__C
	ZAP
	
	IF OBJ_JSON._totalSize = 0
		
		*** INSERIMENTO NUOVA FATTURA SU SALESFORCE
		
		_json_content = '{'
		
		_json_content = _json_content + '"External_id__c": "' + _External_id__c + '"'
		_json_content = _json_content + ', "Data_fattura__c": ' + IIF(!EMPTY(_Data_fattura__c),'"'+ _Data_fattura__c + '"','null')
		_json_content = _json_content + ', "Tipologia_ordine__c": ' + IIF(!EMPTY(_Tipologia_ordine__c),'"'+ _Tipologia_ordine__c + '"','null')
		_json_content = _json_content + ', "Numero_fattura__c": ' + IIF(!EMPTY(_Numero_fattura__c),'"'+ _Numero_fattura__c + '"','null')
		_json_content = _json_content + ', "Account__c": "' + _Account__c + '"'
		_json_content = _json_content + ', "Numero_ordine_cliente__c": ' + IIF(!EMPTY(_Numero_ordine_cliente__c),'"'+ _Numero_ordine_cliente__c + '"','null')
		_json_content = _json_content + ', "Data_ordine_cliente__c": ' + IIF(!EMPTY(_Data_ordine_cliente__c),'"'+ _Data_ordine_cliente__c + '"','null')
		_json_content = _json_content + ', "Causale__c": ' + IIF(!EMPTY(_Causale__c),'"'+ _Causale__c + '"','null')
		_json_content = _json_content + ', "Condizioni_pagamento__c": ' + IIF(!EMPTY(_Condizioni_pagamento__c),'"'+ _Condizioni_pagamento__c + '"','null')
		_json_content = _json_content + ', "Numero_preventivo__c": ' + IIF(!EMPTY(_Numero_preventivo__c),'"'+ _Numero_preventivo__c + '"','null')
		_json_content = _json_content + ', "Data_preventivo__c": ' + IIF(!EMPTY(_Data_preventivo__c),'"'+ _Data_preventivo__c + '"','null')
		_json_content = _json_content + ', "Centro_di_costo__c": ' + IIF(!EMPTY(_Centro_di_costo__c),'"'+ _Centro_di_costo__c + '"','null')
		_json_content = _json_content + ', "Valore_fattura__c": ' + _Valore_fattura__c 
		_json_content = _json_content + ', "Cup__c": ' + IIF(!EMPTY(_Cup__c),'"'+ _Cup__c + '"','null')
		_json_content = _json_content + ', "Cig__c": ' + IIF(!EMPTY(_Cig__c),'"'+ _Cig__c + '"','null')
		_json_content = _json_content + ', "Descrizione_causale__c": ' + IIF(!EMPTY(_Descrizione_causale__c),'"'+ _Descrizione_causale__c + '"','null')
		_json_content = _json_content + ', "Riferimenti_amministrativi__c": ' + IIF(!EMPTY(_Riferimenti_amministrativi__c),'"'+ _Riferimenti_amministrativi__c + '"','null')
		_json_content = _json_content + ', "Endpoint_cliente__c": ' + IIF(!EMPTY(_Endpoint_cliente__c),'"'+ _Endpoint_cliente__c + '"','null')
		_json_content = _json_content + ', "Codice_destinatario__c": ' + IIF(!EMPTY(_Codice_destinatario__c),'"'+ _Codice_destinatario__c + '"','null')
		_json_content = _json_content + ', "Email_pec__c": ' + IIF(!EMPTY(_Email_pec__c),'"'+ _Email_pec__c + '"','null')
		_json_content = _json_content + ', "Note_varie__c": ' + IIF(!EMPTY(_Note_varie__c),'"'+ _Note_varie__c + '"','null')
		_json_content = _json_content + ', "Name": "' + _Name + '"'
		_json_content = _json_content + IIF(!EMPTY(_OwnerId),', "OwnerId": "'+ _OwnerId + '"','')
		*_json_content = _json_content + ', "OwnerId": ' + IIF(!EMPTY(_OwnerId),'"'+ _OwnerId + '"','null')
		_json_content = _json_content + '}'
		
		_cJson = ""
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Fattura_testata__c/"

		_cJson = SALESFORCEREST_POST_INSERT(_HTTP_request,_access_token,_json_content)
		IF EMPTY(_cJson)
			WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
			RETURN .F.
		ENDIF
		
		obj_json = json_decode(_cJson)
				
		*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
		IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
			_cProperty = "OBJ_JSON.Array(1)._message"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_message = ALLTRIM(&_cProperty)
				
				WAIT WINDOWS SUBSTR("Risposta da '"+_HTTP_request+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
			
			_cProperty = "OBJ_JSON._success"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_success = &_cProperty
				IF _success = .T.
				
					_cProperty = "OBJ_JSON._id"
					IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
						_id = &_cProperty
						IF EMPTY(_id)
							WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"'",1,254) TIMEOUT 3
							
							cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
						
							_SF_FATTURA_TESTATA__C_ID = _id
							_SF_LASTMODIFIEDDATE = ""
							_cProperty = "OBJ_JSON._lastmodifieddate"
							IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
								_SF_LASTMODIFIEDDATE = &_cProperty
							ENDIF
							
							cSql = "SELECT * FROM U_FAT_TT WHERE TAGGANCIO = '" + _External_id__c + "'"
							IF !ExecRW(cSql,"U_FAT_TT","R")
								return(.f.)
							ENDIF
							SELECT U_FAT_TT
							GO TOP
							IF !EOF()
								REPLACE SF_FATTURA_TESTATA__C_ID WITH _SF_FATTURA_TESTATA__C_ID
								REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
							ENDIF
							IF !ExecRW(cSql,"U_FAT_TT","W")
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
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
		SELECT TMP_FATTURATO
		LOOP
	ENDIF

	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_FATTURA_TESTATA__C
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
		
		SELECT TMP_SF_FATTURA_TESTATA__C
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_FATTURA_TESTATA__C
	_SF_FATTURA_TESTATA__C_ID = ID
	_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
	
	cSql = "SELECT * FROM U_FAT_TT WHERE TAGGANCIO = '" + _External_id__c + "'"
	IF !ExecRW(cSql,"U_FAT_TT","R")
		return(.f.)
	ENDIF
	SELECT U_FAT_TT
	GO TOP
	IF !EOF()
		REPLACE SF_FATTURA_TESTATA__C_ID WITH _SF_FATTURA_TESTATA__C_ID 
		REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
	ENDIF
	IF !ExecRW(cSql,"U_FAT_TT","W")
		return(.f.)
	ENDIF

	SELECT TMP_SF_FATTURA_TESTATA__C
	ZAP
	
	_json_content = '{'
	_json_content = _json_content + '"Data_fattura__c": ' + IIF(!EMPTY(_Data_fattura__c),'"'+ _Data_fattura__c + '"','null')
	_json_content = _json_content + ', "Tipologia_ordine__c": ' + IIF(!EMPTY(_Tipologia_ordine__c),'"'+ _Tipologia_ordine__c + '"','null')
	_json_content = _json_content + ', "Numero_fattura__c": ' + IIF(!EMPTY(_Numero_fattura__c),'"'+ _Numero_fattura__c + '"','null')
	_json_content = _json_content + ', "Account__c": "' + _Account__c + '"'
	_json_content = _json_content + ', "Numero_ordine_cliente__c": ' + IIF(!EMPTY(_Numero_ordine_cliente__c),'"'+ _Numero_ordine_cliente__c + '"','null')
	_json_content = _json_content + ', "Data_ordine_cliente__c": ' + IIF(!EMPTY(_Data_ordine_cliente__c),'"'+ _Data_ordine_cliente__c + '"','null')
	_json_content = _json_content + ', "Causale__c": ' + IIF(!EMPTY(_Causale__c),'"'+ _Causale__c + '"','null')
	_json_content = _json_content + ', "Condizioni_pagamento__c": ' + IIF(!EMPTY(_Condizioni_pagamento__c),'"'+ _Condizioni_pagamento__c + '"','null')
	_json_content = _json_content + ', "Numero_preventivo__c": ' + IIF(!EMPTY(_Numero_preventivo__c),'"'+ _Numero_preventivo__c + '"','null')
	_json_content = _json_content + ', "Data_preventivo__c": ' + IIF(!EMPTY(_Data_preventivo__c),'"'+ _Data_preventivo__c + '"','null')
	_json_content = _json_content + ', "Centro_di_costo__c": ' + IIF(!EMPTY(_Centro_di_costo__c),'"'+ _Centro_di_costo__c + '"','null')
	_json_content = _json_content + ', "Valore_fattura__c": ' + _Valore_fattura__c 
	_json_content = _json_content + ', "Cup__c": ' + IIF(!EMPTY(_Cup__c),'"'+ _Cup__c + '"','null')
	_json_content = _json_content + ', "Cig__c": ' + IIF(!EMPTY(_Cig__c),'"'+ _Cig__c + '"','null')
	_json_content = _json_content + ', "Descrizione_causale__c": ' + IIF(!EMPTY(_Descrizione_causale__c),'"'+ _Descrizione_causale__c + '"','null')
	_json_content = _json_content + ', "Riferimenti_amministrativi__c": ' + IIF(!EMPTY(_Riferimenti_amministrativi__c),'"'+ _Riferimenti_amministrativi__c + '"','null')
	_json_content = _json_content + ', "Endpoint_cliente__c": ' + IIF(!EMPTY(_Endpoint_cliente__c),'"'+ __Endpoint_cliente__c + '"','null')
	_json_content = _json_content + ', "Codice_destinatario__c": ' + IIF(!EMPTY(_Codice_destinatario__c),'"'+ _Codice_destinatario__c + '"','null')
	_json_content = _json_content + ', "Email_pec__c": ' + IIF(!EMPTY(_Email_pec__c),'"'+ _Email_pec__c + '"','null')
	_json_content = _json_content + ', "Note_varie__c": ' + IIF(!EMPTY(_Note_varie__c),'"'+ _Note_varie__c + '"','null')
	_json_content = _json_content + ', "Name": "' + _Name + '"'
	_json_content = _json_content + IIF(!EMPTY(_OwnerId),', "OwnerId": "'+ _OwnerId + '"','')
	*_json_content = _json_content + ', "OwnerId": ' + IIF(!EMPTY(_OwnerId),'"'+ _OwnerId + '"','null')
	_json_content = _json_content + '}'
		
	*** AGGIORNAMENTO CAMPI SU SALESFORCE
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Fattura_testata__c/"+_SF_FATTURA_TESTATA__C_ID 
	_cJson = ""

	*WAIT WINDOWS "Connessione a '"+_instance_url+"' in corso..." NOWAIT

	_cJson = SALESFORCEREST_PATCH(_HTTP_request,_access_token,_json_content)
	IF EMPTY(_cJson)
		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
		RETURN .F.
	ENDIF
	
	*WAIT WINDOWS "Elaborazione file Json per aggiornamento testata fattura " + _CLI_RAGSOC + " in corso..." NOWAIT
	
	IF _cJson = "204"
		_CONTA_AGG_DA_AQ = _CONTA_AGG_DA_AQ + 1
	ELSE
		
		obj_json = json_decode(_cJson)

		*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
		IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
			_cProperty = "OBJ_JSON.Array(1)._message"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_message = ALLTRIM(&_cProperty)
				WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
	ENDIF
	
ENDSCAN


_HTTP_request = ALLTRIM(PUB_SFLOGOUT)
_cJson = ""
WAIT WINDOWS SUBSTR("Connessione per Logout a '"+_HTTP_request+"' in corso...",1,254) NOWAIT

*_cJson = SALESFORCEREST_POST(_HTTP_request,"token="+_access_token,"")
_cJson = SALESFORCEREST_POST_LOGOUT(_HTTP_request,"token="+_access_token,"")  && ERASMO - 01/07/2024
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale testate fatture inserite da Aquarius: " + ALLTRIM(STR(_CONTA_INS_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessuna testata fattura inserita da Aquarius"
ENDIF
IF _CONTA_AGG_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale testate fatture aggiornate da Aquarius: " + ALLTRIM(STR(_CONTA_AGG_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessuna testata fattura aggiornata da Aquarius"
ENDIF

cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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

_OK_SYNC_FATTURE_TESTATE = .T.
			
RETURN .T.


**********************************************************************
FUNCTION LOOKUP_USER
**********************************************************************
LPARAMETERS _par_ccosto

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 06/02/2025

_RIT = ""

_Centro_di_costo__c = ALLTRIM(_par_ccosto)

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Address,Centro_di_costo__c,Email,FirstName,LastName+FROM+User+WHERE+Centro_di_costo__c='"+_Centro_di_costo__c +"'"

*!*	IF "&" $ _Centro_di_costo__c
*!*		_Descr_Centro_di_costo__c = ""
*!*		cSql = "select TOP 1 * from CCOSTO WHERE CON_CONTO = '"+_Centro_di_costo__c+"' ORDER BY CON_ANNO DESC"
*!*		IF !ExecCommand(cSql,"TMP_CCOSTO")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT TMP_CCOSTO
*!*		GO TOP
*!*		IF !EOF()
*!*			_Descr_Centro_di_costo__c = ALLTRIM(CON_DESCR)
*!*			_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Address,Centro_di_costo__c,Email,FirstName,LastName+FROM+User+WHERE+Name='"+_Descr_Centro_di_costo__c+"'"
*!*		ENDIF
*!*	ENDIF

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Testata Fattura " + _Numero_Fattura__c + " del " + _Data_fattura__c + " - " + _message
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

IF OBJ_JSON._totalSize > 0
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

SELECT(_L_SELECT)  && ERASMO - 06/02/2025

RETURN _RIT

ENDFUNC


**********************************************************************
FUNCTION PARSE_STRING
**********************************************************************
LPARAMETERS _par_string

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_RIT = ALLTRIM(_par_string)
*_RIT = PARSE_STRING_XML(_RIT)
_RIT = STRTRAN(_RIT,CHR(13),' ')
_RIT = STRTRAN(_RIT,CHR(10),' ')
_RIT = STRTRAN(_RIT,CHR(9),' ')
_RIT = STRTRAN(_RIT,'\','\\')
_RIT = STRTRAN(_RIT,'"','\"')  && ERASMO - 04/02/2025
_RIT = STRTRAN(_RIT,CHR(1),'')  && ERASMO - 06/02/2025

_RIT = ALLTRIM(_RIT)

RETURN _RIT

ENDFUNC


**********************************************************************
FUNCTION FORMATTA_DATA
**********************************************************************
LPARAMETERS _par_date

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_RIT = ALLTRIM(_par_date)

IF _RIT = "/  /"
	_RIT = ""
	RETURN _RIT
ENDIF

IF SUBSTR(_RIT,3,1) = "/"
	_RIT = RIBALTA2(_RIT)
ENDIF
_RIT = STRTRAN(_RIT,'/','-')

RETURN _RIT

ENDFUNC


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

RETURN _RIT

ENDFUNC
