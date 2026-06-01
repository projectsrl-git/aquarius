
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
_LOG_OGGETTO = "DDT"
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

*** CONTROLLI DI LOGIN SUPERATI, PROCEDO CON LE CHIAMATE SPECIFICHE PER LA SINCRONIZZAZIONE DEGLI ORDINI


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

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DEGLI ORDINI PRESENTI SU SALESFORCE
CREATE CURSOR TMP_SF_DDT__C ( ;
	ID C(254), ;
	LastModifiedDate C(254), ;
	Name C(254), ;
	Nr_riga__c C(254), ;
	ID_Esterno_AQ__c C(254), ;
	Prodotto__c C(254), ;
	Valore__c C(254), ;
	Quantit__c C(254), ;
	Riga_ordine_di_vendita__c C(254), ;
	Asset__c C(254), ;
	DDT__c C(254), ;
	Ordine__c C(254))

*** ELABORAZIONE DETTAGLI DDT AQUARIUS MODIFICATI O INSERITI RISPETTO ALL'ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE
WAIT WINDOWS "Lettura Dettagli DDT Aquarius modificati o inseriti rispetto all'ultima sincronizzazione..." NOWAIT

*!*	_ULT_TS_SYNC_DDT = ""
*!*	cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'DDT' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
*!*	IF !ExecCommand(cSql,"ULT_TS_SYNC_DDT")
*!*		return(.f.)
*!*	ENDIF
*!*	SELECT ULT_TS_SYNC_DDT
*!*	GO TOP
*!*	_ULT_TS_SYNC_DDT = LAST_DATE

*** PER LA DATA ULTIMA SINCRONIZZAZIONE CONSIDERO LA 2° DATA ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE (TESTATE DDT)
_ULT_TS_SYNC_DDT = ""
cSql   = "SELECT TOP 2 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
IF !ExecCommand(cSql,"ULT_TS_SYNC_DDT")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_DDT
GO BOTTOM
_ULT_TS_SYNC_DDT = LAST_DATE

**=> ERASMO - INIZIO 11/03/2025
_ULT_TS_SYNC_DDT_DD = ""
cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'DDT' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
IF !ExecCommand(cSql,"ULT_TS_SYNC_DDT_DD")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_DDT_DD
GO TOP
_ULT_TS_SYNC_DDT_DD = LAST_DATE
_ULT_TS_SYNC_DDT = MIN(_ULT_TS_SYNC_DDT,_ULT_TS_SYNC_DDT_DD)
**=> ERASMO - FINE 11/03/2025

*_ULT_TS_SYNC_DDT = '2023/12/0100:00:00'  && ###TEST### DDT DA UNA DATA SPECIFICA ###TEST###

x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.ORD_CAUS IN ('VEN','VEG') AND DD.ORD_CODART <> '' AND TT.SF_DDT__C_ID <> '' AND (" + CHR(13) + ;
         "(CASE TT.MOD_DATREG WHEN '' THEN (TT.REG_DATREG+CASE TT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE TT.REG_ORAREG END) ELSE TT.MOD_DATREG+CASE TT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE TT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_DDT + "')"
*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.ORD_CAUS <> 'OI' AND DD.ORD_CODART <> '' AND substring(TT.ORD_DATORD,1,4) = '2021'"
*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.ORD_CAUS <> 'OI' AND DD.ORD_CODART <> '' AND DD.DAGGANCIO > '6000044365' "
*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.ORD_CAUS <> 'OI' AND DD.ORD_CODART <> '' AND TT.ORD_DATORD >= '2021/08/01'"
*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND DD.ORD_CODART <> '' AND DD.DAGGANCIO in ('6000013581','6000043600')"

cSql=""     
cNomeCursorSql="TMP_DETTAGLI_DDT"
TEXT TO cSql NOSHOW
	
	SELECT
		DD.DAGGANCIO, 
		DD.DAGGANCIO+DD.ORD_CODSYS AS EXTERNAL_ID_RIGA_DDT,
		DD.ORD_SEQUEN, 
		DD.ORD_CODSYS, 
		TT.ORD_NUMORD, 
		TT.ORD_DATORD, 
		DD.ORD_CODART, 
		DD.ORD_CCODET, 
		DD.ORD_PRZNET, 
		DD.ORD_QTAORD, 
		TT.ORD_CAMBIO, 
		COALESCE(OD.DAGGANCIO+OD.ORD_CODSYS,'') AS EXTERNAL_ID_RIGA_ORDINE,
		COALESCE(OD.DAGGANCIO+RIGHT('0000000000'+CAST(OD.ORD_SEQUEN AS VARCHAR(10)),10),'') AS EXTERNAL_ID_RIGA_ORDINE_OLD,
		COALESCE(OD.DAGGANCIO,'') AS EXTERNAL_ID_TESTATA_ORDINE
	FROM U_BOL_DD AS DD
	LEFT OUTER JOIN U_BOL_TT AS TT ON TT.TAGGANCIO = DD.DAGGANCIO
	LEFT OUTER JOIN U_ANA_CL AS ACL ON TT.ORD_CODCLI = ACL.CLI_CODCLI
	LEFT OUTER JOIN U_ORD_DD AS OD ON OD.ORD_CODART = DD.ORD_CODART AND OD.ORD_LEGSYS = DD.ORD_LEGSYS
	WHERE <<x_cond>>
	ORDER BY TT.ORD_DATORD,TT.ORD_NUMORD,DD.ORD_SEQUEN

ENDTEXT
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT TMP_DETTAGLI_DDT
GO TOP
SCAN

*!*		IF RECNO() > 100
*!*			EXIT
*!*		ENDIF
	
	WAIT WINDOWS "Elaborazione dettaglio DDT Aquarius " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	SCATTER MEMVAR MEMO
	
	_Numero_DDT = ALLTRIM(M.ORD_NUMORD)
	_Data_DDT = RIBALTA2(M.ORD_DATORD)
	_Cod_Articolo = ALLTRIM(M.ORD_CODART)
	
	_Name = ALLTRIM(M.ORD_CODART)
	_Nr_riga__c = PADL(STR(M.ORD_SEQUEN,10,0),10,'0')
	_ID_Esterno_AQ__c = ALLTRIM(M.EXTERNAL_ID_RIGA_DDT)
	_Prodotto__c = LOOKUP_PRODOTTO(ALLTRIM(M.ORD_CODART))
	IF EMPTY(_Prodotto__c)
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Dettaglio DDT " + _Numero_DDT + " del " + _Data_DDT + " - Articolo " + _Cod_Articolo + " non trovato in tabella SFDC Product2"
			_SEC_FIN = SECONDS()
			REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
		ENDIF
		IF !ExecRW(cSql,"LOG_SFSYNC","W")
		   return(.f.)
		ENDIF
		RETURN .F.
	ENDIF
	_Valore__c = STRTRAN(ALLTRIM(STR(ROUND(M.ORD_QTAORD*M.ORD_PRZNET*M.ORD_CAMBIO,2),16,2)),',','.')
	_Quantit__c = STRTRAN(ALLTRIM(STR(ROUND(M.ORD_QTAORD,4),14,4)),',','.')
	_Aggancio_Testata_DDT = ALLTRIM(M.DAGGANCIO)
	_DDT__c = LOOKUP_DDT__C(_Aggancio_Testata_DDT)
	IF EMPTY(_DDT__c)
		WAIT WINDOWS SUBSTR("Dettaglio DDT " + _Numero_DDT + " del " + _Data_DDT + "  Art. " + _Cod_Articolo + " - Testata DDT non trovata per External ID '" + _Aggancio_Testata_DDT + "'",1,254) TIMEOUT 2
		_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
			"Warning: Dettaglio DDT " + _Numero_DDT + " del " + _Data_DDT + "  Art. " + _Cod_Articolo + " - Testata DDT non trovata per External ID '" + _Aggancio_Testata_DDT + "'"
	ENDIF
	_Riga_ordine_di_vendita__c = LOOKUP_RIGA_ORDINE_DI_VENDITA__C(M.EXTERNAL_ID_RIGA_ORDINE)
	IF EMPTY(_Riga_ordine_di_vendita__c)
		_Riga_ordine_di_vendita__c = LOOKUP_RIGA_ORDINE_DI_VENDITA__C(M.EXTERNAL_ID_RIGA_ORDINE_OLD)
	ENDIF
	_Asset__c = ""
	*_Asset__c = LOOKUP_ASSET__C(EXTERNAL_ID_RIGA_ORDINE)
	_Ordine__c = LOOKUP_ORDINE_DI_VENDITA__C(M.EXTERNAL_ID_TESTATA_ORDINE)  && ERASMO - 04/03/2024
	

	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Prodotto__c+FROM+Riga_DDT__c+WHERE+ID_Esterno_AQ__c='"+_ID_Esterno_AQ__c+"'"
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
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
		
	SELECT TMP_SF_DDT__C
	ZAP
	
	IF OBJ_JSON._totalSize = 0
		
		*** INSERIMENTO NUOVA RIGA DDT DDT SU SALESFORCE
		
		_json_content = '{'
		_json_content = _json_content + '"ID_Esterno_AQ__c": "' + _ID_Esterno_AQ__c + '"'
		_json_content = _json_content + ', "Name": "' + _Name + '"'
		_json_content = _json_content + ', "Nr_riga__c": ' + IIF(!EMPTY(_Nr_riga__c),_Nr_riga__c,'null')
		_json_content = _json_content + ', "Prodotto__c": ' + IIF(!EMPTY(_Prodotto__c),'"'+ _Prodotto__c + '"','null')	
		_json_content = _json_content + ', "Valore__c": ' + IIF(!EMPTY(_Valore__c),_Valore__c,'null')
		_json_content = _json_content + ', "Quantit__c": ' + IIF(!EMPTY(_Quantit__c),_Quantit__c,'null')
		_json_content = _json_content + ', "Riga_ordine_di_vendita__c": ' + IIF(!EMPTY(_Riga_ordine_di_vendita__c),'"'+ _Riga_ordine_di_vendita__c + '"','null')
		_json_content = _json_content + ', "DDT__c": ' + IIF(!EMPTY(_DDT__c),'"'+ _DDT__c + '"','null')
		_json_content = _json_content + ', "Ordine__c": ' + IIF(!EMPTY(_Ordine__c),'"'+ _Ordine__c + '"','null')  && ERASMO - 04/03/2024
		_json_content = _json_content + '}'
		
		_cJson = ""
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Riga_DDT__c/"

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
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
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
							
							cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
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
						
							_SF_RIGA_DDT__C_ID = _id
							_SF_LASTMODIFIEDDATE = ""
							_cProperty = "OBJ_JSON._lastmodifieddate"
							IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
								_SF_LASTMODIFIEDDATE = &_cProperty
							ENDIF
							
*!*								cSql = "SELECT * FROM U_ORD_T2 WHERE DAGGANCIO = '" + _External_id__c + "'"
*!*								IF !ExecRW(cSql,"U_ORD_T2","R")
*!*									return(.f.)
*!*								ENDIF
*!*								SELECT U_ORD_T2
*!*								GO TOP
*!*								IF !EOF()
*!*									REPLACE SF_ORDINE_DI_VENDITA__C_ID WITH _SF_ORDINE_DI_VENDITA__C_ID
*!*									REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
*!*								ENDIF
*!*								IF !ExecRW(cSql,"U_ORD_T2","W")
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
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
		SELECT TMP_DETTAGLI_DDT
		LOOP
	ENDIF

	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_DDT__C
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
		
		SELECT TMP_SF_DDT__C
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_DDT__C
	_SF_RIGA_DDT__C_ID = ID
	_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
	
*!*		cSql = "SELECT * FROM U_ORD_T2 WHERE DAGGANCIO = '" + _External_id__c + "'"
*!*		IF !ExecRW(cSql,"U_ORD_T2","R")
*!*			return(.f.)
*!*		ENDIF
*!*		SELECT U_ORD_T2
*!*		GO TOP
*!*		IF !EOF()
*!*			REPLACE SF_ORDINE_DI_VENDITA__C_ID WITH _SF_ORDINE_DI_VENDITA__C_ID 
*!*			REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
*!*		ENDIF
*!*		IF !ExecRW(cSql,"U_ORD_T2","W")
*!*			return(.f.)
*!*		ENDIF

	SELECT TMP_SF_DDT__C
	ZAP

	_json_content = '{'
	_json_content = _json_content + '"Name": "' + _Name + '"'
	_json_content = _json_content + ', "Nr_riga__c": ' + IIF(!EMPTY(_Nr_riga__c),_Nr_riga__c,'null')
	_json_content = _json_content + ', "Prodotto__c": ' + IIF(!EMPTY(_Prodotto__c),'"'+ _Prodotto__c + '"','null')	
	_json_content = _json_content + ', "Valore__c": ' + IIF(!EMPTY(_Valore__c),_Valore__c,'null')
	_json_content = _json_content + ', "Quantit__c": ' + IIF(!EMPTY(_Quantit__c),_Quantit__c,'null')
	_json_content = _json_content + ', "Riga_ordine_di_vendita__c": ' + IIF(!EMPTY(_Riga_ordine_di_vendita__c),'"'+ _Riga_ordine_di_vendita__c + '"','null')
	_json_content = _json_content + ', "DDT__c": ' + IIF(!EMPTY(_DDT__c),'"'+ _DDT__c + '"','null')
	_json_content = _json_content + ', "Ordine__c": ' + IIF(!EMPTY(_Ordine__c),'"'+ _Ordine__c + '"','null')  && ERASMO - 04/03/2024
	_json_content = _json_content + '}'
		
	*** AGGIORNAMENTO CAMPI SU SALESFORCE
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Riga_DDT__c/"+_SF_RIGA_DDT__C_ID 
	_cJson = ""
	
	*WAIT WINDOWS "Connessione a '"+_instance_url+"' in corso..." NOWAIT

	_cJson = SALESFORCEREST_PATCH(_HTTP_request,_access_token,_json_content)
	IF EMPTY(_cJson)
		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
		RETURN .F.
	ENDIF
	
	*WAIT WINDOWS "Elaborazione file Json per aggiornamento testata ordine " + _CLI_RAGSOC + " in corso..." NOWAIT
	
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
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale dettagli DDT inseriti da Aquarius: " + ALLTRIM(STR(_CONTA_INS_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun dettaglio DDT inserito da Aquarius"
ENDIF
IF _CONTA_AGG_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale dettagli DDT aggiornati da Aquarius: " + ALLTRIM(STR(_CONTA_AGG_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun dettaglio DDT aggiornato da Aquarius"
ENDIF

cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
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

_OK_SYNC_DDT = .T.
			
RETURN .T.


**********************************************************************
FUNCTION LOOKUP_PRODOTTO
**********************************************************************
LPARAMETERS _par_articolo

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 06/02/2025

_RIT = ""

_ProductCode = ALLTRIM(_par_articolo)
_ProductCode = STRTRAN(_ProductCode,"+","%2B")

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Description+FROM+Product2+WHERE+ProductCode='"+_ProductCode+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Dettaglio Ordine " + _Numero_ordine__c + " del " + _Data_ordine_cliente__c + " - Articolo " + _CodiceProdottoAquarius + " non trovato in tabella SFDC Product2"
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
FUNCTION LOOKUP_DDT__C
**********************************************************************
LPARAMETERS _C_External_id_DDT__c

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 06/02/2025

_RIT = ""

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Ragione_sociale__c+FROM+DDT__c+WHERE+ID_esterno_AQ__c='"+_C_External_id_DDT__c+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Lookup Testata DDT ID_esterno_AQ__c " + _C_External_id_DDT__c + " - " + _message
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
FUNCTION LOOKUP_RIGA_ORDINE_DI_VENDITA__C
**********************************************************************
LPARAMETERS _C_External_id_Riga_Ordine

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 06/02/2025

_RIT = ""

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name+FROM+Riga_ordine_di_vendita__c+WHERE+External_Id__c='"+_C_External_id_Riga_Ordine+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Lookup Riga Ordine External_Id__c " + _C_External_id_Riga_Ordine + " - " + _message
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


**=> ERASMO - INIZIO 04/03/2024
**********************************************************************
FUNCTION LOOKUP_ORDINE_DI_VENDITA__C
**********************************************************************
LPARAMETERS _C_External_id_Testata_Ordine

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 06/02/2025

_RIT = ""

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name+FROM+Ordine_di_vendita__c+WHERE+External_id__c='"+_C_External_id_Testata_Ordine+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Lookup Testata Ordine External_Id__c " + _C_External_id_Testata_Ordine + " - " + _message
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
**=> ERASMO - FINE 04/03/2024


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