
LPARAMETERS _par_scheduled,_par_group_codsys,_par_nr_gg_dal,_par_filtra_valute

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
	_par_nr_gg_dal = 10
ENDIF

IF PCOUNT() >= 4
ELSE
	_par_filtra_valute = ""
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
_LOG_OGGETTO = "CAMBI_VALUTE"
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

*** CONTROLLI DI LOGIN SUPERATI, PROCEDO CON LE CHIAMATE SPECIFICHE PER LA SINCRONIZZAZIONE DEGLI CAMBI_VALUTE


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

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DEI CAMBI_VALUTE PRESENTI SU SALESFORCE
CREATE CURSOR TMP_SF_DatedConversionRate ( ;
	Id C(254), ;
	IsoCode C(254), ;
	StartDate C(254), ;
	ConversionRate C(254))

*** ELABORAZIONE CAMBI_VALUTE AQUARIUS DEGLI ULTIMI N GIORNI
WAIT WINDOWS "Lettura CAMBI_VALUTE Aquarius modificati o inserite relativi agli ultimi " + ALLTRIM(STR(_par_nr_gg_dal,10,0)) + "giorni..." NOWAIT

*!*	_ULT_TS_SYNC_DOT = ""
*!*	cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'CAMBI_VALUTE' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
*!*	IF !ExecCommand(cSql,"ULT_TS_SYNC_DOT")
*!*		return(.f.)
*!*	ENDIF
*!*	SELECT ULT_TS_SYNC_DOT
*!*	GO TOP
*!*	_ULT_TS_SYNC_DOT = LAST_DATE
*!*	_ULT_TS_SYNC_DOT = '1950/01/0100:00:00'  && ###TEST### TUTTI GLI CAMBI_VALUTE ###TEST###

_DATADAL = RIBALTA2(DTOC(DATE() - _par_nr_gg_dal))
x_cond = "VVA_DATA >= '" + _DATADAL + "'"
IF !EMPTY(_par_filtra_valute)
	x_cond = x_cond + " AND VVA_CODVAL IN (" + _par_filtra_valute + ")"
ENDIF
cSql=""     
cNomeCursorSql="TMP_CAMBI_VALUTE"
TEXT TO cSql NOSHOW
	SELECT * 
	FROM U_VVA_CH 
	WHERE <<x_cond>>
	ORDER BY VVA_DATA,VVA_CODVAL
ENDTEXT
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT TMP_CAMBI_VALUTE
GO TOP
SCAN
	
	WAIT WINDOWS "Elaborazione Cambio Valuta Aquarius " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	_IsoCode = UPPER(ALLTRIM(VVA_CODVAL))
	_StartDate = STRTRAN(VVA_DATA,"/","-")
	_CAMBIO = 1 / VVA_CHANGE
	_ConversionRate = STRTRAN(ALLTRIM(STR(_CAMBIO,12,6)),",",".")
	
	_cValutaInElaborazione = "Cambio Valuta " + _IsoCode + " del " + ribalta2(VVA_DATA)
	
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id+FROM+DatedConversionRate+WHERE+IsoCode='"+_IsoCode+"'+AND+StartDate="+_StartDate
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CAMBI_VALUTE' AND CODSYS = '" + _LOG_CODSYS + "'"
			IF !ExecRW(cSql,"LOG_SFSYNC","R")
			   return(.f.)
			ENDIF
			SELECT LOG_SFSYNC
			GO TOP
			IF !EOF()
				REPLACE ESITO WITH "KO"
				REPLACE MESSAGGIO WITH _cValutaInElaborazione + " - " + _message
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
	
	SELECT TMP_SF_DatedConversionRate
	ZAP
	
	IF OBJ_JSON._totalSize = 0
		
		*** INSERIMENTO NUOVA DOTAZIONE SU SALESFORCE
		
		_json_content = '{'
		_json_content = _json_content + '"IsoCode": "' + _IsoCode + '"'
		_json_content = _json_content + ', "StartDate": "' + _StartDate + '"'
		_json_content = _json_content + ', "ConversionRate": ' + _ConversionRate
		_json_content = _json_content + '}'
		
		_cJson = ""
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/DatedConversionRate/"

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
					
					WAIT WINDOWS SUBSTR("Errorcode: "+_errorcode+" - "+_cValutaInElaborazione+", pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
					_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
						"Warning: "+_errorcode+" - "+_cValutaInElaborazione+", pertanto non verrà considerato in questa elaborazione"
					SELECT TMP_CAMBI_VALUTE
					LOOP
			
				ENDIF
			ENDIF
			
			_cProperty = "OBJ_JSON.Array(1)._message"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_message = ALLTRIM(&_cProperty)
				
				WAIT WINDOWS SUBSTR("Risposta da '"+_HTTP_request+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CAMBI_VALUTE' AND CODSYS = '" + _LOG_CODSYS + "'"
				IF !ExecRW(cSql,"LOG_SFSYNC","R")
				   return(.f.)
				ENDIF
				SELECT LOG_SFSYNC
				GO TOP
				IF !EOF()
					REPLACE ESITO WITH "KO"
					REPLACE MESSAGGIO WITH _cValutaInElaborazione + " - " + _message
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
							
							cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CAMBI_VALUTE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
						
							_SF_DatedConversionRate_ID = _id
							*_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
							
*!*								cSql = "SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = '" + _CODICE_ARTICOLO_GRUPPO + "' AND DIS_CODART = '" + _CODICE_ARTICOLO_COMPONENTE + "'"	
*!*								IF !ExecRW(cSql,"U_DIS_DD","R")
*!*									return(.f.)
*!*								ENDIF
*!*								SELECT U_DIS_DD
*!*								GO TOP
*!*								IF !EOF()
*!*									REPLACE SF_DatedConversionRate_ID WITH _SF_DatedConversionRate_ID
*!*									*REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
*!*								ENDIF
*!*								IF !ExecRW(cSql,"U_DIS_DD","W")
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
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CAMBI_VALUTE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
		
		SELECT TMP_CAMBI_VALUTE
		LOOP
	ENDIF
		
	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_DatedConversionRate
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
		
		SELECT TMP_SF_DatedConversionRate
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_DatedConversionRate
	_SF_DatedConversionRate_ID = ID
	*_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
	
*!*		cSql = "SELECT * FROM U_DIS_DD WHERE DIS_GRUPPO = '" + _CODICE_ARTICOLO_GRUPPO + "' AND DIS_CODART = '" + _CODICE_ARTICOLO_COMPONENTE + "'"	
*!*		IF !ExecRW(cSql,"U_DIS_DD","R")
*!*			return(.f.)
*!*		ENDIF
*!*		SELECT U_DIS_DD
*!*		GO TOP
*!*		IF !EOF()
*!*			REPLACE SF_DatedConversionRate_ID WITH _SF_DatedConversionRate_ID
*!*			*REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
*!*		ENDIF
*!*		IF !ExecRW(cSql,"U_DIS_DD","W")
*!*			return(.f.)
*!*		ENDIF							

	SELECT TMP_SF_DatedConversionRate
	ZAP

	_json_content = '{'
	_json_content = _json_content + '"ConversionRate": ' + _ConversionRate
	_json_content = _json_content + '}'
		
	*** AGGIORNAMENTO CAMPI SU SALESFORCE
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/DatedConversionRate/"+_SF_DatedConversionRate_ID
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
						
						WAIT WINDOWS SUBSTR("Errorcode: "+_errorcode+" - "+_cValutaInElaborazione+", pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
						_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
							"Warning: "+_errorcode+" - "+_cValutaInElaborazione+", pertanto non verrà considerato in questa elaborazione"
						SELECT TMP_CAMBI_VALUTE
						LOOP
				
					ENDIF
				ENDIF
			
				_message = ALLTRIM(&_cProperty)
				WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CAMBI_VALUTE' AND CODSYS = '" + _LOG_CODSYS + "'"
				IF !ExecRW(cSql,"LOG_SFSYNC","R")
				   return(.f.)
				ENDIF
				SELECT LOG_SFSYNC
				GO TOP
				IF !EOF()
					REPLACE ESITO WITH "KO"
					REPLACE MESSAGGIO WITH _cValutaInElaborazione + " - " + _message
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CAMBI_VALUTE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale Cambi Valute inseriti da Aquarius: " + ALLTRIM(STR(_CONTA_INS_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun Cambio Valuta inserito da Aquarius"
ENDIF
IF _CONTA_AGG_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale Cambi Valute aggiornati da Aquarius: " + ALLTRIM(STR(_CONTA_AGG_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun Cambio Valuta aggiornato da Aquarius"
ENDIF
*!*	IF _CONTA_DEL_DA_SF > 0
*!*		_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale dotazioni cancellate su SalesForce: " + ALLTRIM(STR(_CONTA_DEL_DA_SF))
*!*	ELSE
*!*		_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessuna dotazione cancellata su SalesForce"
*!*	ENDIF

cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CAMBI_VALUTE' AND CODSYS = '" + _LOG_CODSYS + "'"
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

_OK_SYNC_CAMBI_VALUTE = .T.
			
RETURN .T.

