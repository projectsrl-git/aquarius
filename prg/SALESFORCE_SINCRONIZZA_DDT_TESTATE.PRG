
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
_CONTA_DEL_DA_SF = 0  && ERASMO - 02/08/2023

_MSG_WARNINGS = ""

_LOG_CODSYS = IIF(EMPTY(_par_group_codsys),SYS(2015),_par_group_codsys)
_LOG_OGGETTO = "DDT_TESTATE"
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

*** CONTROLLI DI LOGIN SUPERATI, PROCEDO CON LE CHIAMATE SPECIFICHE PER LA SINCRONIZZAZIONE DEI DDT


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

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DEI DDT PRESENTI SU SALESFORCE
CREATE CURSOR TMP_SF_DDT__C ( ;	
	ID C(254), ;
	LastModifiedDate C(254), ;
	Name C(254), ;
	Data_documento__c C(254), ;
	Ragione_sociale__c C(254), ;
	Destinazione__Street__s C(254), ;
	Destinazione__City__s C(254), ;
	Destinazione__StateCode__s C(254), ;
	Destinazione__PostalCode__s C(254), ;
	Destinazione__CountryCode__s C(254), ;
	Nome_Destinazione__c C(254), ;
	Causale__c C(254), ;
	Condizioni_pagamento__c C(254), ;
	Tipologia_documento__c C(254), ;
	All_attenzione_di__c C(254), ;
	Note_varie__c C(254), ;
	Fattura__c C(254), ;
	OwnerID C(254), ;
	ID_esterno_AQ__c C(254))

*!*	NUMERO BOLLA
*!*	DATA BOLLA
*!*	ID Account SF
*!*	INDIRIZZO
*!*	INDIRIZZO
*!*	LOCALITA
*!*	LOCALITA'
*!*	PROVINCIA
*!*	PROVINCIA
*!*	CAP
*!*	CAP
*!*	NAZIONE
*!*	NAZIONE
*!*	DES NAZ
*!*	RAGIONE SOCIALE
*!*	DESCRIZIONE CAUSALE
*!*	CONDIZIONI PAGAMENTO
*!*	TIPOLOGIA DOCUMENTO
*!*	ALL'ATTENZIONE DI
*!*	NOTE VARIE
*!*	ID alla fattura SF
*!*	ID Owner SF
*!*	ID_DDT_AQUARIUS
	

*** ELABORAZIONE TESTATE DDT AQUARIUS MODIFICATI O INSERITI RISPETTO ALL'ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE
WAIT WINDOWS "Lettura Testate DDT Aquarius modificati o inseriti rispetto all'ultima sincronizzazione..." NOWAIT

_ULT_TS_SYNC_DDT = ""
cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
IF !ExecCommand(cSql,"ULT_TS_SYNC_DDT")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_DDT
GO TOP
_ULT_TS_SYNC_DDT = LAST_DATE

*_ULT_TS_SYNC_DDT = '2023/12/0100:00:00'  && ###TEST### DDT DA UNA DATA SPECIFICA ###TEST###

*!*	x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.ORD_CAUS IN ('VEN','VEG') AND (CASE TT.MOD_DATREG WHEN '' THEN (TT.REG_DATREG+CASE TT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE TT.REG_ORAREG END) " + ;
*!*	         "ELSE TT.MOD_DATREG+CASE TT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE TT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_DDT + "'"
*!*	*x_cond = x_cond + " AND TT.ORD_NUMORD >= '001330' "
*!*	*x_cond = x_cond + " AND TT.ORD_CCOSTO = 'ITAGM' "
*!*	*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND SUBSTRING(TT.ORD_DATORD,1,4) = '2015' "
*!*	*x_cond = x_cond + " AND TT.TAGGANCIO >= '6000042354' "
*!*	*x_cond = x_cond + " AND TT.ORD_CCOSTO IN ('MKT','INTLLA','INTLGU','INTLGM','INTLP','INTLPS','INTLDX','INTLPI','R&D','INTLPR')"
*!*	*x_cond = x_cond + " AND TT.ORD_CCOSTO IN ('R&D')"
*!*	*x_cond = x_cond + " AND TT.ORD_CCOSTO IN ('SERV')"
*!*	*x_cond = x_cond + " AND TT.ORD_CCOSTO IN ('MKT')"
*!*	*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.TAGGANCIO = '9999999999' "

**=> ERASMO - INIZIO 08/04/2025
x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.ORD_CAUS IN ('VEN','VEG') AND (" + CHR(13) + ;
         "(CASE TT.MOD_DATREG WHEN '' THEN (TT.REG_DATREG+CASE TT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE TT.REG_ORAREG END) ELSE TT.MOD_DATREG+CASE TT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE TT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_DDT + "' OR " + ;
         "(CASE FT.MOD_DATREG WHEN '' THEN (FT.REG_DATREG+CASE FT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE FT.REG_ORAREG END) ELSE FT.MOD_DATREG+CASE FT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE FT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_DDT + "')"
**=> ERASMO - FINE 08/04/2025
cSql=""
cNomeCursorSql="TMP_DDT"
TEXT TO cSql NOSHOW
	
	SELECT
		TT.TAGGANCIO, 
		TT.ORD_DATORD, 
		TT.ORD_NUMORD, 
		TT.ORD_CODCLI, 
		COALESCE(ACL.SF_ACCOUNT_ID,'') AS SF_ACCOUNT_ID, 
		TT.ORD_CLIFAT, 
		COALESCE(ACL_FATT.SF_ACCOUNT_ID,'') AS SF_ACCOUNT_ID_FATT,
		TT.ORD_RAGSOC, 
		TT.ORD_INDIRI, 
		TT.ORD_LOCALI, 
		TT.ORD_PROVIN, 
		TT.ORD_CAP, 
		TT.ORD_CODNAZ,
		COALESCE(STA.LIBERA,'') AS ORD_CODNAZ_ALPHA2, 
		TT.ORD_INDC, 
		TT.ORD_LOCC, 
		TT.ORD_PROC, 
		TT.ORD_CAPC, 
		TT.ORD_DSNAZC, 
		COALESCE(STAC.LIBERA,COALESCE(STA.LIBERA,'')) AS ORD_DSNAZC_ALPHA2, 
		TT.ORD_RAGC, 
		TT.ORD_CAUS, 
		COALESCE(CAUSAL.DESCRI,'') AS DESCR_CAUSAL, 
		TT.ORD_CPA, 
		TT.ORD_TIPOLOGIA, 
		TT.ORD_ATTENZIONE, 
		TT.ORD_VARIE, 
		--COALESCE((SELECT TOP 1 DAGGANCIO FROM U_FAT_DD AS DF INNER JOIN (SELECT TAGGANCIO FROM U_FAT_TT) AS TF ON DF.DAGGANCIO = TF.TAGGANCIO WHERE ORD_DESART <> '*** COMMENTO ***' 
		--	AND ORS_NUMDDT = TT.ORD_NUMORD AND ORS_DATDDT = TT.ORD_DATORD),'') AS TAGGANCIO_FAT, 
		COALESCE(FT.TAGGANCIO,'') AS TAGGANCIO_FAT, -- ERASMO - 08/04/2025
		TT.ORD_CCOSTO 
	FROM U_BOL_TT AS TT
	LEFT OUTER JOIN U_CLI_AN AS CLI ON TT.ORD_CODCLI = CLI.CLI_CODCLI
	LEFT OUTER JOIN U_ANA_CL AS ACL ON TT.ORD_CODCLI = ACL.CLI_CODCLI	
	LEFT OUTER JOIN U_ANA_CL AS ACL_FATT ON TT.ORD_CLIFAT = ACL_FATT.CLI_CODCLI
	LEFT OUTER JOIN PARA AS STA ON 'STA'+TT.ORD_CODNAZ = STA.CODICE 
	LEFT OUTER JOIN PARA AS STAC ON SUBSTRING(STAC.CODICE,1,3) = 'STA' AND TT.ORD_DSNAZC = STAC.DESCRI 
	LEFT OUTER JOIN PARA AS CAUSAL ON CAUSAL.CODICE = 'TOP'+TT.ORD_CAUS	
	OUTER APPLY (SELECT TOP 1 TAGGANCIO,REG_DATREG,REG_ORAREG,MOD_DATREG,MOD_ORAREG FROM U_FAT_TT AS TF WHERE TAGGANCIO IN (SELECT DAGGANCIO FROM U_FAT_DD AS DF WHERE ORD_DESART <> '*** COMMENTO ***' 
			AND ORS_NUMDDT = TT.ORD_NUMORD AND ORS_DATDDT = TT.ORD_DATORD) ORDER BY TF.TAGGANCIO) AS FT
	WHERE <<x_cond>>
	ORDER BY TT.ORD_DATORD,TT.ORD_NUMORD

ENDTEXT

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT TMP_DDT
GO TOP
SCAN

*!*		IF RECNO() > 100
*!*			EXIT
*!*		ENDIF
	
	WAIT WINDOWS "Elaborazione testata DDT Aquarius " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	_ID_esterno_AQ__c = ALLTRIM(TAGGANCIO)
	_Name = ALLTRIM(ORD_NUMORD)
	_Data_documento__c = FORMATTA_DATA(ORD_DATORD)
	IF !EMPTY(SF_ACCOUNT_ID_FATT)
		_Ragione_sociale__c = ALLTRIM(SF_ACCOUNT_ID_FATT)
	ELSE
		_Ragione_sociale__c = ALLTRIM(SF_ACCOUNT_ID)
	ENDIF
	IF !EMPTY(ALLTRIM(ORD_RAGC))
		_Destinazione__Street__s = PARSE_STRING(ALLTRIM(ORD_INDC))
		_Destinazione__City__s = PARSE_STRING(ALLTRIM(ORD_LOCC))
		_Destinazione__StateCode__s = ALLTRIM(ORD_PROC)
		_Destinazione__PostalCode__s = ALLTRIM(ORD_CAPC)
		_Destinazione__CountryCode__s = ALLTRIM(ORD_DSNAZC_ALPHA2)
		_Nome_Destinazione__c = PARSE_STRING(ALLTRIM(ORD_RAGC))
	ELSE
		_Destinazione__Street__s = PARSE_STRING(ALLTRIM(ORD_INDIRI))
		_Destinazione__City__s = PARSE_STRING(ALLTRIM(ORD_LOCALI))
		_Destinazione__StateCode__s = ALLTRIM(ORD_PROVIN)
		_Destinazione__PostalCode__s = ALLTRIM(ORD_CAP)
		_Destinazione__CountryCode__s = ALLTRIM(ORD_CODNAZ_ALPHA2)
		_Nome_Destinazione__c = PARSE_STRING(ALLTRIM(ORD_RAGSOC))
	ENDIF
	IF UPPER(_Destinazione__CountryCode__s) == "EL"  && FORZATURA PER GRECIA
		_Destinazione__CountryCode__s = "GR"
	ENDIF
	IF UPPER(_Destinazione__CountryCode__s) == "IT"  && SE STATO NON ITALIA, SBIANCO LA PROVINCIA, CONCATENANDOLA ALLA LOCALITA'
	ELSE
		IF !EMPTY(_Destinazione__StateCode__s)
			_Destinazione__City__s = ALLTRIM(_Destinazione__City__s ) + " - " + ALLTRIM(_Destinazione__StateCode__s) 
			_Destinazione__StateCode__s = ""
		ENDIF
	ENDIF
	_Destinazione__City__s = ALLTRIM(SUBSTR(_Destinazione__City__s,1,40))
	_Causale__c = PARSE_STRING(ALLTRIM(DESCR_CAUSAL))
	_Condizioni_pagamento__c = ALLTRIM(ORD_CPA)
	_Tipologia_documento__c = ALLTRIM(ORD_TIPOLOGIA)
	_All_attenzione_di__c = PARSE_STRING(ALLTRIM(ORD_ATTENZIONE))
	_Note_varie__c = PARSE_STRING(ALLTRIM(ORD_VARIE))
	_External_id_Fattura_testata__c = ALLTRIM(TAGGANCIO_FAT)
	_Fattura__c = LOOKUP_FATTURA_TESTATA__C(_External_id_Fattura_testata__c)
	_Centro_di_costo = ALLTRIM(PARSE_STRING(ORD_CCOSTO))
	_OwnerID = LOOKUP_USER(ENCODE_URI_SF(_Centro_di_costo))
	IF EMPTY(_OwnerId)
		WAIT WINDOWS SUBSTR("Testata DDT " + _Name + " del " + _Data_documento__c + " - User SFDC non trovato per Centro di costo '" + _Centro_di_costo + "'",1,254) TIMEOUT 2
		_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
			"Warning: Testata DDT " + _Name + " del " + _Data_documento__c + " - User SFDC non trovato per Centro di costo '" + _Centro_di_costo + "'"
	ENDIF
	
	
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Ragione_sociale__c+FROM+DDT__c+WHERE+ID_esterno_AQ__c='"+_ID_esterno_AQ__c+"'"

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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
		
		*** INSERIMENTO NUOVO DDT SU SALESFORCE
		
		_json_content = '{'
		_json_content = _json_content + '"ID_esterno_AQ__c": "' + _ID_esterno_AQ__c + '"'
		_json_content = _json_content + ', "Name": ' + IIF(!EMPTY(_Name),'"'+ _Name + '"','null')
		_json_content = _json_content + ', "Data_documento__c": ' + IIF(!EMPTY(_Data_documento__c),'"'+ _Data_documento__c + '"','null')
		_json_content = _json_content + ', "Ragione_sociale__c": "' + _Ragione_sociale__c + '"'
		_json_content = _json_content + ', "Destinazione__Street__s": ' + IIF(!EMPTY(_Destinazione__Street__s),'"'+ _Destinazione__Street__s + '"','null')
		_json_content = _json_content + ', "Destinazione__City__s": ' + IIF(!EMPTY(_Destinazione__City__s),'"'+ _Destinazione__City__s + '"','null')
		_json_content = _json_content + ', "Destinazione__StateCode__s": ' + IIF(!EMPTY(_Destinazione__StateCode__s),'"'+ _Destinazione__StateCode__s + '"','null')
		_json_content = _json_content + ', "Destinazione__PostalCode__s": ' + IIF(!EMPTY(_Destinazione__PostalCode__s),'"'+ _Destinazione__PostalCode__s + '"','null')
		_json_content = _json_content + ', "Destinazione__CountryCode__s": ' + IIF(!EMPTY(_Destinazione__CountryCode__s),'"'+ _Destinazione__CountryCode__s + '"','null')
		_json_content = _json_content + ', "Nome_Destinazione__c": ' + IIF(!EMPTY(_Nome_Destinazione__c),'"'+ _Nome_Destinazione__c + '"','null')
		_json_content = _json_content + ', "Causale__c": ' + IIF(!EMPTY(_Causale__c),'"'+ _Causale__c + '"','null')
		_json_content = _json_content + ', "Condizioni_pagamento__c": ' + IIF(!EMPTY(_Condizioni_pagamento__c),'"'+ _Condizioni_pagamento__c + '"','null')
		_json_content = _json_content + ', "Tipologia_documento__c": ' + IIF(!EMPTY(_Tipologia_documento__c),'"'+ _Tipologia_documento__c + '"','null')
		_json_content = _json_content + ', "All_attenzione_di__c": ' + IIF(!EMPTY(_All_attenzione_di__c),'"'+ _All_attenzione_di__c + '"','null')
		_json_content = _json_content + ', "Note_varie__c": ' + IIF(!EMPTY(_Note_varie__c),'"'+ _Note_varie__c + '"','null')
		_json_content = _json_content + ', "Fattura__c": ' + IIF(!EMPTY(_Fattura__c),'"'+ _Fattura__c + '"','null')
		_json_content = _json_content + IIF(!EMPTY(_OwnerId),', "OwnerId": "'+ _OwnerId + '"','')
		_json_content = _json_content + '}'
		
		_cJson = ""
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/DDT__c/"

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
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
							
							cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
						
							_SF_DDT__C_ID = _id
							_SF_LASTMODIFIEDDATE = ""
							_cProperty = "OBJ_JSON._lastmodifieddate"
							IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
								_SF_LASTMODIFIEDDATE = &_cProperty
							ENDIF
							
							cSql = "SELECT * FROM U_BOL_TT WHERE TAGGANCIO = '" + _ID_esterno_AQ__c + "'"
							IF !ExecRW(cSql,"U_BOL_TT","R")
								return(.f.)
							ENDIF
							SELECT U_BOL_TT
							GO TOP
							IF !EOF()
								REPLACE SF_DDT__C_ID WITH _SF_DDT__C_ID 
								REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
							ENDIF
							IF !ExecRW(cSql,"U_BOL_TT","W")
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
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
		SELECT TMP_DDT
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
	_SF_DDT__C_ID = ID
	_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
	
	cSql = "SELECT * FROM U_BOL_TT WHERE TAGGANCIO = '" + _ID_esterno_AQ__c + "'"
	IF !ExecRW(cSql,"U_BOL_TT","R")
		return(.f.)
	ENDIF
	SELECT U_BOL_TT
	GO TOP
	IF !EOF()
		REPLACE SF_DDT__C_ID WITH _SF_DDT__C_ID 
		REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
	ENDIF
	IF !ExecRW(cSql,"U_BOL_TT","W")
		return(.f.)
	ENDIF

	SELECT TMP_SF_DDT__C
	ZAP
		
	_json_content = '{'
	_json_content = _json_content + '"Name": ' + IIF(!EMPTY(_Name),'"'+ _Name + '"','null')
	_json_content = _json_content + ', "Data_documento__c": ' + IIF(!EMPTY(_Data_documento__c),'"'+ _Data_documento__c + '"','null')
	_json_content = _json_content + ', "Ragione_sociale__c": "' + _Ragione_sociale__c + '"'
	_json_content = _json_content + ', "Destinazione__Street__s": ' + IIF(!EMPTY(_Destinazione__Street__s),'"'+ _Destinazione__Street__s + '"','null')
	_json_content = _json_content + ', "Destinazione__City__s": ' + IIF(!EMPTY(_Destinazione__City__s),'"'+ _Destinazione__City__s + '"','null')
	_json_content = _json_content + ', "Destinazione__StateCode__s": ' + IIF(!EMPTY(_Destinazione__StateCode__s),'"'+ _Destinazione__StateCode__s + '"','null')
	_json_content = _json_content + ', "Destinazione__PostalCode__s": ' + IIF(!EMPTY(_Destinazione__PostalCode__s),'"'+ _Destinazione__PostalCode__s + '"','null')
	_json_content = _json_content + ', "Destinazione__CountryCode__s": ' + IIF(!EMPTY(_Destinazione__CountryCode__s),'"'+ _Destinazione__CountryCode__s + '"','null')
	_json_content = _json_content + ', "Nome_Destinazione__c": ' + IIF(!EMPTY(_Nome_Destinazione__c),'"'+ _Nome_Destinazione__c + '"','null')
	_json_content = _json_content + ', "Causale__c": ' + IIF(!EMPTY(_Causale__c),'"'+ _Causale__c + '"','null')
	_json_content = _json_content + ', "Condizioni_pagamento__c": ' + IIF(!EMPTY(_Condizioni_pagamento__c),'"'+ _Condizioni_pagamento__c + '"','null')
	_json_content = _json_content + ', "Tipologia_documento__c": ' + IIF(!EMPTY(_Tipologia_documento__c),'"'+ _Tipologia_documento__c + '"','null')
	_json_content = _json_content + ', "All_attenzione_di__c": ' + IIF(!EMPTY(_All_attenzione_di__c),'"'+ _All_attenzione_di__c + '"','null')
	_json_content = _json_content + ', "Note_varie__c": ' + IIF(!EMPTY(_Note_varie__c),'"'+ _Note_varie__c + '"','null')
	_json_content = _json_content + ', "Fattura__c": ' + IIF(!EMPTY(_Fattura__c),'"'+ _Fattura__c + '"','null')
	_json_content = _json_content + IIF(!EMPTY(_OwnerId),', "OwnerId": "'+ _OwnerId + '"','')
	_json_content = _json_content + '}'
		
	*** AGGIORNAMENTO CAMPI SU SALESFORCE
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/DDT__c/"+_SF_DDT__C_ID
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
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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


*** GESTIONE CANCELLAZIONE TESTATE DDT (TRA LE TESTATE DDT DEGLI ULTIMI 12 MESI DALLA DATA OGGI) PRESENTI SU SFDC MA NON SU AQUARIUS
WAIT WINDOWS "Elaborazione testate DDT Aquarius cancellate in corso..." NOWAIT

_cNextRecordsUrl = ""
_1stQuery = .T.

DO WHILE .T.
	IF _1stQuery
	ELSE
		IF EMPTY(_cNextRecordsUrl)
			EXIT
		ENDIF
	ENDIF
	_1stQuery = .F.
	
	IF EMPTY(_cNextRecordsUrl)
		_data_dal = STRTRAN(PADL(ALLTRIM(STR(VAL(SUBSTR(RIBALTA2(DTOC(DATE())),1,4)) - 1)),4,'0') + SUBSTR(RIBALTA2(DTOC(DATE())),5,6),"/","-")
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Data_documento__c,ID_esterno_AQ__c+FROM+DDT__c+WHERE+Data_documento__c+>="+_data_dal
	ELSE
		_HTTP_request = ALLTRIM(_instance_url) + _cNextRecordsUrl
	ENDIF
		
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
			
			RELEASE obj_json_tt			
			RETURN .F.
		ENDIF
	ENDIF

	_cNextRecordsUrl = ""
	_cProperty = "obj_json_tt._nextRecordsUrl"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_cNextRecordsUrl = &_cProperty
	ENDIF

	IF obj_json_tt._totalSize > 0

		FOR I_row = 1 TO ALEN(obj_json_tt._RECORDS.Array,1)
			
			_cProperty = "obj_json_tt._records.Array("+ALLTRIM(STR(I_row))+")._ID_esterno_AQ__c"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				IF &_cProperty = ""
					LOOP
				ENDIF
			ELSE
				LOOP  && ERASMO - 10/06/2025
			ENDIF
			
			*** VERIFICA ESISTENZA RECORD SU AQUARIUS IN CORRISPONDENZA DEL CAMPO "ID_esterno_AQ__c"
			x_agga = "TAGGANCIO = '" + SUBSTR(&_cProperty,1,10) + "'"
			x_cond = x_agga
			cSql = "select TAGGANCIO,ORD_NUMORD,ORD_DATORD from U_BOL_TT WHERE " + x_cond
			IF !ExecCommand(cSql,"CHK_BOL_TT")
			   return(.f.)
			ENDIF
			SELECT CHK_BOL_TT
			GO TOP
			IF EOF()
			
				_cProperty = "obj_json_tt._records.Array("+ALLTRIM(STR(I_row))+")._Id"
				IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
					IF &_cProperty = ""
						LOOP
					ENDIF
				ENDIF
				
				*** CANCELLAZIONE TESTATA DDT SU SFDC
				_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/DDT__c/"+&_cProperty
				_cJson = ""
				_cJson = SALESFORCEREST_DELETE(_HTTP_request,_access_token)
				IF EMPTY(_cJson)
					WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
					
*!*						**=> ERASMO - INIZIO 13/01/2023
*!*						_message = "Oggetto JSON restituito VUOTO durante il tentativo di cancellazione ordine Id=" + &_cProperty + " (" + x_agga + ")"					
*!*						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
*!*						IF !ExecRW(cSql,"LOG_SFSYNC","R")
*!*						   return(.f.)
*!*						ENDIF
*!*						SELECT LOG_SFSYNC
*!*						GO TOP
*!*						IF !EOF()
*!*							REPLACE ESITO WITH "KO"
*!*							REPLACE MESSAGGIO WITH _message
*!*							_SEC_FIN = SECONDS()
*!*							REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
*!*						ENDIF
*!*						IF !ExecRW(cSql,"LOG_SFSYNC","W")
*!*						   return(.f.)
*!*						ENDIF
*!*						**=> ERASMO - FINE 13/01/2023
										
					*RETURN .F.
					
					**=> ERASMO - INIZIO 17/01/2023
					_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
						"Warning: Oggetto JSON restituito VUOTO durante il tentativo di cancellazione DDT Id=" + &_cProperty + " (" + x_agga + ")"
					LOOP
					**=> ERASMO - FINE 17/01/2023
				ENDIF
				
				IF _cJson = "204"
					_CONTA_DEL_DA_SF = _CONTA_DEL_DA_SF + 1
				ELSE
					obj_json = json_decode(_cJson)

					*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
					IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
						_cProperty = "OBJ_JSON.Array(1)._message"
						IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
							_message = ALLTRIM(&_cProperty)
							WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
							
							cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
				
			ENDIF
		NEXT

		RELEASE obj_json_tt
	ENDIF

ENDDO

WAIT CLEAR


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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale testate DDT inserite da Aquarius: " + ALLTRIM(STR(_CONTA_INS_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessuna testata DDT inserita da Aquarius"
ENDIF
IF _CONTA_AGG_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale testate DDT aggiornate da Aquarius: " + ALLTRIM(STR(_CONTA_AGG_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessuna testata DDT aggiornata da Aquarius"
ENDIF
IF _CONTA_DEL_DA_SF > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale testate DDT cancellate su SalesForce: " + ALLTRIM(STR(_CONTA_DEL_DA_SF))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessuna testata DDT cancellata su SalesForce"
ENDIF

cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
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

_OK_SYNC_DDT_TESTATE = .T.
			
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

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Address,Centro_di_costo__c,Email,FirstName,LastName+FROM+User+WHERE+Centro_di_costo__c='"+_Centro_di_costo__c+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Testata ddt " + _Name + " del " + _Data_documento__c + " - " + _message
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


**********************************************************************
FUNCTION LOOKUP_FATTURA_TESTATA__C
**********************************************************************
LPARAMETERS _par_External_id_Fattura_testata__c

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 06/02/2025

_RIT = ""

_C_External_id_Fattura_testata__c = ALLTRIM(_par_External_id_Fattura_testata__c)
_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Account__c+FROM+Fattura_testata__c+WHERE+External_id__c='"+_C_External_id_Fattura_testata__c+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'DDT_TESTATE' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Lookup Testata Fattura External_id__c " + _C_External_id_Fattura_testata__c + " - " + _message
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