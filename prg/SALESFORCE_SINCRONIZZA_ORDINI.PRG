
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
_CONTA_DEL_DA_SF = 0  && ERASMO - 04/04/2025

_MSG_WARNINGS = ""

_LOG_CODSYS = IIF(EMPTY(_par_group_codsys),SYS(2015),_par_group_codsys)
_LOG_OGGETTO = "ORDINI"
_LOG_DATA = RIBALTA2(DTOC(DATE()))
_LOG_ORA = TIME()
_LOG_CODOPE = ALLTRIM(PUB_CODOPE)
_LOG_NOMOPE = ALLTRIM(PUB_NOMOPE)

*!*	*** LOGIN
*!*	_username = ALLTRIM(PUB_SFUSER)
*!*	_password = ALLTRIM(PUB_SFPASS)
*!*	_consumer_key = ALLTRIM(PUB_SFCKEY)
*!*	_consumer_secret = ALLTRIM(PUB_SFCSECRET)
*!*	_access_token = ""
*!*	_instance_url = ""

*!*	_SEC_INI = SECONDS()

*!*	_cJson = ""
*!*	_HTTP_request = ALLTRIM(PUB_SFLOGIN)
*!*	WAIT WINDOWS SUBSTR("Connessione per Login a '"+_HTTP_request+"' in corso...",1,254) NOWAIT

*!*	_cJson = SALESFORCEREST_POST(_HTTP_request,"","",_username,_password,_consumer_key,_consumer_secret)
*!*	IF EMPTY(_cJson)
*!*		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
*!*		RETURN .F.
*!*	ENDIF

*!*	WAIT WINDOWS "Elaborazione file Json in corso..." NOWAIT

*!*	obj_json = json_decode(_cJson)

*!*	*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
*!*	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
*!*		_cProperty = "OBJ_JSON._error_description"
*!*		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
*!*			_message = ALLTRIM(&_cProperty)
*!*			WAIT WINDOWS SUBSTR("Risposta da '"+_HTTP_request+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
*!*			RETURN .F.
*!*		ENDIF
*!*	ENDIF

*!*	*** TOKEN E/O INSTANCE_URL NON RESTITUITI
*!*	_cProperty = "OBJ_JSON._access_token"
*!*	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
*!*		_access_token = &_cProperty
*!*	ENDIF
*!*	IF EMPTY(_access_token)
*!*		WAIT WINDOWS "Parametro di ritorno 'access_token' non presente" TIMEOUT 3
*!*		RETURN .F.
*!*	ENDIF
*!*	_cProperty = "OBJ_JSON._instance_url"
*!*	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
*!*		_instance_url = &_cProperty
*!*	ENDIF
*!*	IF EMPTY(_instance_url)
*!*		WAIT WINDOWS "Parametro di ritorno 'instance_url' non presente" TIMEOUT 3
*!*		RETURN .F.
*!*	ENDIF

*!*	RELEASE obj_json

*!*	*** CONTROLLI DI LOGIN SUPERATI, PROCEDO CON LE CHIAMATE SPECIFICHE PER LA SINCRONIZZAZIONE DEGLI ORDINI

**=> ERASMO - INIZIO 12/03/2025
_SEC_INI = SECONDS()
_access_token = ""
_instance_url = ""
IF !SALESFORCE_LOGIN(ALLTRIM(PUB_SFLOGIN),ALLTRIM(PUB_SFUSER),ALLTRIM(PUB_SFPASS),ALLTRIM(PUB_SFCKEY),ALLTRIM(PUB_SFCSECRET),@_access_token,@_instance_url)
	RETURN .F.
ENDIF
**=> ERASMO - FINE 12/03/2025

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
CREATE CURSOR TMP_SF_RIGA_ORDINE_DI_VENDITA__C ( ;
	ID C(254), ;
	LastModifiedDate C(254), ;
	External_Id__c C(254), ;
	Data_consegna__c C(254), ;
	Regione__c C(254), ;
	Provincia__c C(254), ;
	Product__c C(254), ;
	Centro_di_costo__c C(254), ;
	Valore_evaso__c C(254), ;
	Valore_ordinato__c C(254), ;
	Valore_da_evadere__c C(254), ;
	Sconto_quantita__c C(254), ;
	Quantita_ordinata__c C(254), ;
	Quantita_evasa__c C(254), ;
	Quantita_da_evadere__c C(254), ;
	Id_fattura__c C(254), ;
	Id_riga_fattura__c C(254), ;
	Numero_fattura__c C(254), ;
	Data_fattura__c C(254), ;
	Name C(254), ;
	Ordine_di_vendita__c C(254))

*** ELABORAZIONE DETTAGLI ORDINI AQUARIUS MODIFICATI O INSERITI RISPETTO ALL'ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE
WAIT WINDOWS "Lettura Dettagli Ordini Aquarius modificati o inseriti rispetto all'ultima sincronizzazione..." NOWAIT

*!*	_ULT_TS_SYNC_ORD = ""
*!*	cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
*!*	IF !ExecCommand(cSql,"ULT_TS_SYNC_ORD")
*!*		return(.f.)
*!*	ENDIF
*!*	SELECT ULT_TS_SYNC_ORD
*!*	GO TOP
*!*	_ULT_TS_SYNC_ORD = LAST_DATE

*** PER LA DATA ULTIMA SINCRONIZZAZIONE CONSIDERO LA 2° DATA ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE (TESTATE ORDINI)
_ULT_TS_SYNC_ORD = ""
*cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'ORDINI_TESTATE' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
cSql   = "SELECT TOP 2 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'ORDINI_TESTATE' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"  && ERASMO - 12/10/2021
IF !ExecCommand(cSql,"ULT_TS_SYNC_ORD")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_ORD
GO BOTTOM
_ULT_TS_SYNC_ORD = LAST_DATE

**=> ERASMO - INIZIO 11/03/2025
_ULT_TS_SYNC_ORD_DD = ""
cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
IF !ExecCommand(cSql,"ULT_TS_SYNC_ORD_DD")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_ORD_DD
GO TOP
_ULT_TS_SYNC_ORD_DD = LAST_DATE
_ULT_TS_SYNC_ORD = MIN(_ULT_TS_SYNC_ORD,_ULT_TS_SYNC_ORD_DD)
**=> ERASMO - FINE 11/03/2025

*_ULT_TS_SYNC_ORD = '2021/01/0100:00:00'  && ###TEST### TUTTE LE RIGHE ORDINI ###TEST###

*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.ORD_CAUS <> 'OI' AND DD.ORD_CODART <> '' AND T2.SF_ORDINE_DI_VENDITA__C_ID <> '' AND (" + CHR(13) + ;
         "(CASE TT.MOD_DATREG WHEN '' THEN (TT.REG_DATREG+CASE TT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE TT.REG_ORAREG END) ELSE TT.MOD_DATREG+CASE TT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE TT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_ORD + "' OR " + ;
         "(CASE BT.MOD_DATREG WHEN '' THEN (BT.REG_DATREG+CASE BT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE BT.REG_ORAREG END) ELSE BT.MOD_DATREG+CASE BT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE BT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_ORD + "' OR " + ;
         "(CASE FT.MOD_DATREG WHEN '' THEN (FT.REG_DATREG+CASE FT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE FT.REG_ORAREG END) ELSE FT.MOD_DATREG+CASE FT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE FT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_ORD + "')"        
x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.ORD_CAUS NOT IN ('OI','OR') AND DD.ORD_CODART <> '' AND T2.SF_ORDINE_DI_VENDITA__C_ID <> '' AND (" + CHR(13) + ;
         "(CASE TT.MOD_DATREG WHEN '' THEN (TT.REG_DATREG+CASE TT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE TT.REG_ORAREG END) ELSE TT.MOD_DATREG+CASE TT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE TT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_ORD + "' OR " + ;
         "(CASE BT.MOD_DATREG WHEN '' THEN (BT.REG_DATREG+CASE BT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE BT.REG_ORAREG END) ELSE BT.MOD_DATREG+CASE BT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE BT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_ORD + "' OR " + ;
         "(CASE FT.MOD_DATREG WHEN '' THEN (FT.REG_DATREG+CASE FT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE FT.REG_ORAREG END) ELSE FT.MOD_DATREG+CASE FT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE FT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_ORD + "')"  && ERASMO - 20/03/2026  
*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.ORD_CAUS <> 'OI' AND DD.ORD_CODART <> '' AND substring(TT.ORD_DATORD,1,4) = '2021'"
*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.ORD_CAUS <> 'OI' AND DD.ORD_CODART <> '' AND DD.DAGGANCIO > '6000044365' "
*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND TT.ORD_CAUS <> 'OI' AND DD.ORD_CODART <> '' AND TT.ORD_DATORD >= '2021/08/01'"
*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND DD.ORD_CODART <> '' AND DD.DAGGANCIO in ('6000013581','6000043600')"

*!*	cSql=""     
*!*	cNomeCursorSql="TMP_ORDINATO"
*!*	TEXT TO cSql NOSHOW
*!*		
*!*		SELECT
*!*			DD.DAGGANCIO,
*!*			DD.ORD_SEQUEN,
*!*			DD.ORD_CODSYS,  -- ERASMO - 29/08/2023
*!*			TT.ORD_NUMORD,
*!*			TT.ORD_DATORD,
*!*			DD.ORD_DATCON,
*!*			COALESCE(REGIONI.REGIONE,'') AS REGIONE,
*!*			TT.ORD_PROVIN,
*!*			DD.ORD_CODART,
*!*			DD.ORD_CCODET,
*!*			DD.ORD_PRZNET,
*!*			DD.ORD_QTAORD,
*!*			DD.ORD_QTAEV,
*!*			TT.ORD_CAMBIO,
*!*			DD.ORD_SC1,
*!*			COALESCE(FD.DAGGANCIO,'') AS DAGGANCIO_FAT,
*!*			COALESCE(FD.ORD_SEQUEN,0) AS SEQUEN_FAT,
*!*			COALESCE(FD.ORS_NUMORD,'') AS NUMORD_FAT,
*!*			COALESCE(FD.ORS_DATORD,'') AS DATORD_FAT,
*!*			(CASE TT.MOD_DATREG WHEN '' THEN (TT.REG_DATREG+CASE TT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE TT.REG_ORAREG END) ELSE TT.MOD_DATREG+CASE TT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE TT.MOD_ORAREG END END) AS DATA_ORA_ORDINE,
*!*	        (CASE BT.MOD_DATREG WHEN '' THEN (BT.REG_DATREG+CASE BT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE BT.REG_ORAREG END) ELSE BT.MOD_DATREG+CASE BT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE BT.MOD_ORAREG END END) AS DATA_ORA_BOLLA,
*!*	        (CASE FT.MOD_DATREG WHEN '' THEN (FT.REG_DATREG+CASE FT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE FT.REG_ORAREG END) ELSE FT.MOD_DATREG+CASE FT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE FT.MOD_ORAREG END END) AS DATA_ORA_FATTURA
*!*		FROM U_ORD_DD AS DD
*!*		LEFT OUTER JOIN U_ORD_TT AS TT ON TT.TAGGANCIO = DD.DAGGANCIO
*!*		LEFT OUTER JOIN U_ORD_T2 AS T2 ON T2.TAGGANCIO = DD.DAGGANCIO
*!*		LEFT OUTER JOIN U_ANA_CL AS ACL ON TT.ORD_CODCLI = ACL.CLI_CODCLI
*!*		LEFT OUTER JOIN PROVINCE ON PROVINCE.SIGLA = TT.ORD_PROVIN
*!*		LEFT OUTER JOIN REGIONI ON REGIONI.CODICE = PROVINCE.REGIONE
*!*		LEFT OUTER JOIN U_FAT_DD AS FD ON FD.ORD_CODART = DD.ORD_CODART AND ((FD.ORS_NUMORC = TT.ORD_NUMORD AND FD.ORS_DATORC = TT.ORD_DATORD) 
*!*			OR (FD.ORS_NUMDDT+FD.ORS_DATDDT IN (SELECT ORS_NUMORD+ORS_DATORD FROM U_BOL_DD WHERE ORD_CODART = DD.ORD_CODART AND ORS_NUMORC = TT.ORD_NUMORD AND ORS_DATORC = TT.ORD_DATORD)))
*!*		LEFT OUTER JOIN U_FAT_TT AS FT ON FT.TAGGANCIO = FD.DAGGANCIO
*!*		--LEFT OUTER JOIN U_BOL_DD AS BD ON BD.ORD_CODART = DD.ORD_CODART AND BD.ORS_NUMORC = TT.ORD_NUMORD AND BD.ORS_DATORC = TT.ORD_DATORD
*!*		LEFT OUTER JOIN U_BOL_DD AS BD ON BD.ORD_CODART = DD.ORD_CODART AND BD.ORD_LEGSYS = DD.ORD_LEGSYS AND BD.ORS_NUMORC = TT.ORD_NUMORD AND BD.ORS_DATORC = TT.ORD_DATORD  -- ERASMO - 28/10/2021
*!*		LEFT OUTER JOIN U_BOL_TT AS BT ON BT.TAGGANCIO = BD.DAGGANCIO
*!*		WHERE <<x_cond>>
*!*		ORDER BY TT.ORD_DATORD,TT.ORD_NUMORD,DD.ORD_SEQUEN

*!*	ENDTEXT
*!*	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
*!*		return(.F.)
*!*	ENDIF

**=> ERASMO - INIZIO 02/04/2025
*** CAMBIATO PUNTAMENTO A U_FAT_DD USANDO U_FAT_DD.ORD_LEGSYS = U_ORD_DD.ORD_LEGSYS
cSql=""     
cNomeCursorSql="TMP_ORDINATO"
TEXT TO cSql NOSHOW
		
	SELECT
		DD.DAGGANCIO,
		DD.ORD_SEQUEN,
		DD.ORD_CODSYS,
		TT.ORD_NUMORD,
		TT.ORD_DATORD,
		DD.ORD_DATCON,
		COALESCE(REGIONI.REGIONE,'') AS REGIONE,
		TT.ORD_PROVIN,
		DD.ORD_CODART,
		DD.ORD_CCODET,
		DD.ORD_PRZNET,
		DD.ORD_QTAORD,
		DD.ORD_QTAEV,
		TT.ORD_CAMBIO,
		DD.ORD_SC1,
		COALESCE(FD.DAGGANCIO,'') AS DAGGANCIO_FAT,
		COALESCE(FD.ORD_SEQUEN,0) AS SEQUEN_FAT,
		COALESCE(FD.ORS_NUMORD,'') AS NUMORD_FAT,
		COALESCE(FD.ORS_DATORD,'') AS DATORD_FAT,
		(CASE TT.MOD_DATREG WHEN '' THEN (TT.REG_DATREG+CASE TT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE TT.REG_ORAREG END) ELSE TT.MOD_DATREG+CASE TT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE TT.MOD_ORAREG END END) AS DATA_ORA_ORDINE,
        (CASE BT.MOD_DATREG WHEN '' THEN (BT.REG_DATREG+CASE BT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE BT.REG_ORAREG END) ELSE BT.MOD_DATREG+CASE BT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE BT.MOD_ORAREG END END) AS DATA_ORA_BOLLA,
        (CASE FT.MOD_DATREG WHEN '' THEN (FT.REG_DATREG+CASE FT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE FT.REG_ORAREG END) ELSE FT.MOD_DATREG+CASE FT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE FT.MOD_ORAREG END END) AS DATA_ORA_FATTURA
	FROM U_ORD_DD AS DD
	LEFT OUTER JOIN U_ORD_TT AS TT ON TT.TAGGANCIO = DD.DAGGANCIO
	LEFT OUTER JOIN U_ORD_T2 AS T2 ON T2.TAGGANCIO = DD.DAGGANCIO
	LEFT OUTER JOIN U_ANA_CL AS ACL ON TT.ORD_CODCLI = ACL.CLI_CODCLI
	LEFT OUTER JOIN PROVINCE ON PROVINCE.SIGLA = TT.ORD_PROVIN
	LEFT OUTER JOIN REGIONI ON REGIONI.CODICE = PROVINCE.REGIONE
	--OUTER APPLY (SELECT TOP 1 * FROM U_FAT_DD WHERE ORD_LEGSYS = DD.ORD_LEGSYS ORDER BY ORS_DATORD, ORS_NUMORD) AS FD
	OUTER APPLY (SELECT TOP 1 * FROM U_FAT_DD WHERE ORD_LEGSYS = DD.ORD_LEGSYS ORDER BY ORS_DATORD DESC, ORS_NUMORD DESC) AS FD  -- ERASMO - 04/08/2025
	LEFT OUTER JOIN U_FAT_TT AS FT ON FT.TAGGANCIO = FD.DAGGANCIO
	--OUTER APPLY (SELECT TOP 1 * FROM U_BOL_DD WHERE ORD_CODART = DD.ORD_CODART AND ORD_LEGSYS = DD.ORD_LEGSYS AND ORS_NUMORC = TT.ORD_NUMORD AND ORS_DATORC = TT.ORD_DATORD ORDER BY ORS_DATORD, ORS_NUMORD) AS BD
	OUTER APPLY (SELECT TOP 1 * FROM U_BOL_DD WHERE ORD_CODART = DD.ORD_CODART AND ORD_LEGSYS = DD.ORD_LEGSYS AND ORS_NUMORC = TT.ORD_NUMORD AND ORS_DATORC = TT.ORD_DATORD ORDER BY ORS_DATORD DESC, ORS_NUMORD DESC) AS BD  -- ERASMO - 04/08/2025
	LEFT OUTER JOIN U_BOL_TT AS BT ON BT.TAGGANCIO = BD.DAGGANCIO
	WHERE <<x_cond>>
	ORDER BY TT.ORD_DATORD,TT.ORD_NUMORD,DD.ORD_SEQUEN

ENDTEXT
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF
**=> ERASMO - FINE 02/04/2025

**=> ERASMO - INIZIO 12/03/2025
*** EFFETTUO NUOVAMENTE IL LOGIN PER PRELEVARE UN NUOVO TOKEN, IN QUANTO IL VECCHIO POTREBBE ESSERE SCADUTO
IF !SALESFORCE_LOGIN(ALLTRIM(PUB_SFLOGIN),ALLTRIM(PUB_SFUSER),ALLTRIM(PUB_SFPASS),ALLTRIM(PUB_SFCKEY),ALLTRIM(PUB_SFCSECRET),@_access_token,@_instance_url)
	RETURN .F.
ENDIF
**=> ERASMO - FINE 12/03/2025

SELECT TMP_ORDINATO
GO TOP
SCAN

*!*		IF RECNO() > 100
*!*			EXIT
*!*		ENDIF
	
	WAIT WINDOWS "Elaborazione dettaglio ordine Aquarius " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT

	_Numero_ordine__c = ALLTRIM(ORD_NUMORD)
	_Data_ordine_cliente__c = RIBALTA2(ORD_DATORD)
	
	*_External_id__c = ALLTRIM(DAGGANCIO)+PADL(ALLTRIM(STR(ORD_SEQUEN,10,0)),10,'0')
	**=> ERASMO - INIZIO 29/08/2023
	*** MODIFICA PER IDENTIFICARE UNIVOCAMENTE LA RIGA ORDINE AQUARIUS, MANTENENDO UNA CERTA RETROCOMPATIBILITA' CON LE RIGHE PRECEDENTEMENTE IMPORTATE
	_External_id__c = ALLTRIM(DAGGANCIO)+ALLTRIM(ORD_CODSYS)
	_External_id__c_old = ALLTRIM(DAGGANCIO)+PADL(ALLTRIM(STR(ORD_SEQUEN,10,0)),10,'0')
	**=> ERASMO - FINE 29/08/2023
			
	_Data_consegna__c = FORMATTA_DATA(ORD_DATCON)
	_Regione__c = PARSE_STRING(REGIONE)
	_Provincia__c = PARSE_STRING(ORD_PROVIN)	
	_CodiceProdottoAquarius = ALLTRIM(ORD_CODART)
	_Product__c = LOOKUP_PRODOTTO(_CodiceProdottoAquarius)
	IF EMPTY(_Product__c)
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			IF EMPTY(ALLTRIM(MESSAGGIO)) OR ALLTRIM(MESSAGGIO) = "ELABORAZIONE"  && ERASMO - 12/03/2025
				REPLACE MESSAGGIO WITH "Dettaglio Ordine " + _Numero_ordine__c + " del " + _Data_ordine_cliente__c + " - Articolo " + _CodiceProdottoAquarius + " non trovato in tabella SFDC Product2"
			ENDIF
			_SEC_FIN = SECONDS()
			REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
		ENDIF
		IF !ExecRW(cSql,"LOG_SFSYNC","W")
		   return(.f.)
		ENDIF
		RETURN .F.
	ENDIF
	
	_Centro_di_costo__c = PARSE_STRING(ORD_CCODET)
	_Valore_evaso__c = STRTRAN(ALLTRIM(STR(ROUND(ORD_QTAEV*ORD_PRZNET*ORD_CAMBIO,2),16,2)),',','.')
	_Valore_ordinato__c = STRTRAN(ALLTRIM(STR(ROUND(ORD_QTAORD*ORD_PRZNET*ORD_CAMBIO,2),16,2)),',','.')
	_Valore_da_evadere__c = STRTRAN(ALLTRIM(STR(ROUND((ORD_QTAORD-ORD_QTAEV)*ORD_PRZNET*ORD_CAMBIO,2),16,2)),',','.')
	_Sconto_quantita__c = STRTRAN(ALLTRIM(STR(ROUND(ORD_SC1,8),19,8)),',','.')
	_Quantita_ordinata__c = STRTRAN(ALLTRIM(STR(ROUND(ORD_QTAORD,4),14,4)),',','.')
	_Quantita_evasa__c = STRTRAN(ALLTRIM(STR(ROUND(ORD_QTAEV,4),14,4)),',','.')
	_Quantita_da_evadere__c = STRTRAN(ALLTRIM(STR(ROUND(ORD_QTAORD-ORD_QTAEV,4),14,4)),',','.')
	_Id_fattura__c = ALLTRIM(DAGGANCIO_FAT)
	*_Id_riga_fattura__c = ALLTRIM(DAGGANCIO_FAT)+PADL(ALLTRIM(STR(SEQUEN_FAT,10,0)),10,'0')
	_Numero_fattura__c = PARSE_STRING(NUMORD_FAT)
	_Data_fattura__c = FORMATTA_DATA(DATORD_FAT)
	*_Name = ALLTRIM(DAGGANCIO)+PADL(ALLTRIM(STR(ORD_SEQUEN,10,0)),10,'0')
	_Name = ALLTRIM(ORD_CODART)  && ERASMO - 08/11/2021
		
	_External_id_Ordine_di_vendita__c = ALLTRIM(DAGGANCIO)
	_Ordine_di_vendita__c = LOOKUP_ORDINE_DI_VENDITA__C(_External_id_Ordine_di_vendita__c)
	IF EMPTY(_Ordine_di_vendita__c)
		WAIT WINDOWS SUBSTR("Dettaglio Ordine " + _Numero_ordine__c + " del " + _Data_ordine_cliente__c + "  Art. " + _Product__c + " - Testata Ordine non trovata per External ID '" + _External_id_Ordine_di_vendita__c + "'",1,254) TIMEOUT 2
		_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
			"Warning: Dettaglio Ordine " + _Numero_ordine__c + " del " + _Data_ordine_cliente__c + "  Art. " + _Product__c + " - Testata Ordine non trovata per External ID '" + _External_id_Ordine_di_vendita__c + "'"
*!*			SELECT TMP_ORDINATO
*!*			LOOP
	ENDIF
	
	**=> ERASMO - INIZIO 29/08/2023
	*** MODIFICA PER IDENTIFICARE UNIVOCAMENTE LA RIGA ORDINE AQUARIUS, MANTENENDO UNA CERTA RETROCOMPATIBILITA' CON LE RIGHE PRECEDENTEMENTE IMPORTATE
	
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Product__c+FROM+Riga_ordine_di_vendita__c+WHERE+External_Id__c='"+_External_id__c+"'"
	
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
	IF OBJ_JSON._totalSize = 0  && SECONDA RICERCA PER RETROCOMPATIBILITA'
	**=> ERASMO - FINE 29/08/2023
	
		*_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Product__c+FROM+Riga_ordine_di_vendita__c+WHERE+Name='"+_Name+"'"
		*_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Product__c+FROM+Riga_ordine_di_vendita__c+WHERE+External_Id__c='"+_External_id__c+"'"  && ERASMO - 10/11/2021
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Product__c+FROM+Riga_ordine_di_vendita__c+WHERE+External_Id__c='"+_External_id__c_old+"'"  && ERASMO - 29/08/2023

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
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
		
	ENDIF  && ERASMO - 29/08/2023
		
	SELECT TMP_SF_RIGA_ORDINE_DI_VENDITA__C
	ZAP
	
	IF OBJ_JSON._totalSize = 0
		
		*** INSERIMENTO NUOVO ORDINE SU SALESFORCE
		
		_json_content = '{'
		*_json_content = _json_content + '"External_id__c": "' + _External_id__c + '"'
		_json_content = _json_content + '"External_id__c": "' + _External_id__c + '"'  && ERASMO - 10/11/2021
		_json_content = _json_content + ', "Name": "' + _Name + '"'
		_json_content = _json_content + ', "Data_consegna__c": ' + IIF(!EMPTY(_Data_consegna__c),'"'+ _Data_consegna__c + '"','null')
		_json_content = _json_content + ', "Regione__c": ' + IIF(!EMPTY(_Regione__c),'"'+ _Regione__c + '"','null')
		_json_content = _json_content + ', "Provincia__c": ' + IIF(!EMPTY(_Provincia__c),'"'+ _Provincia__c + '"','null')
		_json_content = _json_content + ', "Product__c": ' + IIF(!EMPTY(_Product__c),'"'+ _Product__c + '"','null')
		_json_content = _json_content + ', "Centro_di_costo__c": ' + IIF(!EMPTY(_Centro_di_costo__c),'"'+ _Centro_di_costo__c+ '"','null')
		_json_content = _json_content + ', "Valore_evaso__c": ' + _Valore_evaso__c
		_json_content = _json_content + ', "Valore_ordinato__c": ' + _Valore_ordinato__c
		_json_content = _json_content + ', "Valore_da_evadere__c": ' + _Valore_da_evadere__c
		_json_content = _json_content + ', "Sconto_quantita__c": ' + _Sconto_quantita__c
		_json_content = _json_content + ', "Quantita_ordinata__c": ' + _Quantita_ordinata__c
		_json_content = _json_content + ', "Quantita_evasa__c": ' + _Quantita_evasa__c
		_json_content = _json_content + ', "Quantita_da_evadere__c": ' + _Quantita_da_evadere__c
		_json_content = _json_content + ', "Id_fattura__c": ' + IIF(!EMPTY(_Id_fattura__c),'"'+ _Id_fattura__c+ '"','null')
		*_json_content = _json_content + ', "Id_riga_fattura__c": ' + IIF(!EMPTY(_Id_riga_fattura__c),'"'+ _Id_riga_fattura__c+ '"','null')
		_json_content = _json_content + ', "Numero_fattura__c": ' + IIF(!EMPTY(_Numero_fattura__c),'"'+ _Numero_fattura__c+ '"','null')
		_json_content = _json_content + ', "Data_fattura__c": ' + IIF(!EMPTY(_Data_fattura__c),'"'+ _Data_fattura__c+ '"','null')
		_json_content = _json_content + ', "Ordine_di_vendita__c": ' + IIF(!EMPTY(_Ordine_di_vendita__c),'"'+ _Ordine_di_vendita__c+ '"','null')
		_json_content = _json_content + '}'
		
		_cJson = ""
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Riga_ordine_di_vendita__c/"

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
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
							
							cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
						
							_SF_RIGA_ORDINE_DI_VENDITA__C_ID = _id
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
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
		SELECT TMP_ORDINATO
		LOOP
	ENDIF

	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_RIGA_ORDINE_DI_VENDITA__C
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
		
		SELECT TMP_SF_RIGA_ORDINE_DI_VENDITA__C
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_RIGA_ORDINE_DI_VENDITA__C
	_SF_RIGA_ORDINE_DI_VENDITA__C_ID = ID
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

	SELECT TMP_SF_RIGA_ORDINE_DI_VENDITA__C
	ZAP
	
	_json_content = '{'
	_json_content = _json_content + '"Name": "' + _Name + '"'  && ERASMO - 29/12/2021
	_json_content = _json_content + ', "Data_consegna__c": ' + IIF(!EMPTY(_Data_consegna__c),'"'+ _Data_consegna__c + '"','null')
	_json_content = _json_content + ', "Regione__c": ' + IIF(!EMPTY(_Regione__c),'"'+ _Regione__c + '"','null')
	_json_content = _json_content + ', "Provincia__c": ' + IIF(!EMPTY(_Provincia__c),'"'+ _Provincia__c + '"','null')
	_json_content = _json_content + ', "Product__c": ' + IIF(!EMPTY(_Product__c),'"'+ _Product__c + '"','null')
	_json_content = _json_content + ', "Centro_di_costo__c": ' + IIF(!EMPTY(_Centro_di_costo__c),'"'+ _Centro_di_costo__c+ '"','null')
	_json_content = _json_content + ', "Valore_evaso__c": ' + _Valore_evaso__c
	_json_content = _json_content + ', "Valore_ordinato__c": ' + _Valore_ordinato__c
	_json_content = _json_content + ', "Valore_da_evadere__c": ' + _Valore_da_evadere__c
	_json_content = _json_content + ', "Sconto_quantita__c": ' + _Sconto_quantita__c
	_json_content = _json_content + ', "Quantita_ordinata__c": ' + _Quantita_ordinata__c
	_json_content = _json_content + ', "Quantita_evasa__c": ' + _Quantita_evasa__c
	_json_content = _json_content + ', "Quantita_da_evadere__c": ' + _Quantita_da_evadere__c
	_json_content = _json_content + ', "Id_fattura__c": ' + IIF(!EMPTY(_Id_fattura__c),'"'+ _Id_fattura__c+ '"','null')
	*_json_content = _json_content + ', "Id_riga_fattura__c": ' + IIF(!EMPTY(_Id_riga_fattura__c),'"'+ _Id_riga_fattura__c+ '"','null')
	_json_content = _json_content + ', "Numero_fattura__c": ' + IIF(!EMPTY(_Numero_fattura__c),'"'+ _Numero_fattura__c+ '"','null')
	_json_content = _json_content + ', "Data_fattura__c": ' + IIF(!EMPTY(_Data_fattura__c),'"'+ _Data_fattura__c+ '"','null')
	*_json_content = _json_content + ', "Ordine_di_vendita__c": ' + IIF(!EMPTY(_Ordine_di_vendita__c),'"'+ _Ordine_di_vendita__c+ '"','null')
	_json_content = _json_content + '}'
		
	*** AGGIORNAMENTO CAMPI SU SALESFORCE
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Riga_ordine_di_vendita__c/"+_SF_RIGA_ORDINE_DI_VENDITA__C_ID 
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
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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

**=> ERASMO - INIZIO 04/04/2025
*** CANCELLAZIONE, TRA GLI ORDINI TRATTATI, DELLE EVENTUALI RIGHE ORDINE PRESENTI SU SFDC MA NON PIU' SU AQUARIUS
WAIT WINDOWS "Elaborazione dettagli ordini Aquarius cancellati in corso..." NOWAIT

SELECT DISTINCT DAGGANCIO AS TAGGANCIO FROM TMP_ORDINATO GROUP BY DAGGANCIO ORDER BY DAGGANCIO INTO CURSOR TMP_ORDINATO_TT
SELECT TMP_ORDINATO_TT
GO TOP
SCAN
	
	WAIT WINDOWS "Elaborazione raggruppamento dettagli ordini Aquarius cancellati " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	_ACT_AGGANCIO = TAGGANCIO
	
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
			_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,External_Id__c+FROM+Riga_ordine_di_vendita__c+WHERE+External_Id__c+LIKE+'"+_ACT_AGGANCIO+"%25'"
		ELSE
			_HTTP_request = ALLTRIM(_instance_url) + _cNextRecordsUrl
		ENDIF
			
		_cJson = ""
		_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
		IF EMPTY(_cJson)
			WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
			RETURN .F.
		ENDIF

		obj_json_dd = json_decode(_cJson)

		*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
		IF TYPE("obj_json_dd") <> 'U' AND TYPE("obj_json_dd") = 'O' AND !ISNULL(obj_json_dd)
			_cProperty = "obj_json_dd.Array(1)._message"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_message = ALLTRIM(&_cProperty)
				WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
				
				RELEASE obj_json_dd			
				RETURN .F.
			ENDIF
		ENDIF

		_cNextRecordsUrl = ""
		_cProperty = "obj_json_dd._nextRecordsUrl"
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			_cNextRecordsUrl = &_cProperty
		ENDIF

		IF obj_json_dd._totalSize > 0

			FOR I_row = 1 TO ALEN(obj_json_dd._RECORDS.Array,1)
				
				_cProperty = "obj_json_dd._records.Array("+ALLTRIM(STR(I_row))+")._External_Id__c"
				IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
					IF &_cProperty = ""
						LOOP
					ENDIF
				ELSE
					LOOP  && ERASMO - 10/06/2025
				ENDIF
				
				*** VERIFICA SE CAMPO "External_Id__c" E' CONFORME AL NUOVO PUNTAMENTO DAGGANCIO+ORD_CODSYS DI 20 CARATTERI E NON FORMATTATO COMO VECCHIO PUNTAMENTO DAGGANCIO+ORD_SEQUEN (ES. DA ESCLUDERE 60000399310000000010)
				IF LEN(ALLTRIM(&_cProperty)) = 20 AND SUBSTR(ALLTRIM(&_cProperty),11,2) <> "00"
				ELSE
					LOOP
				ENDIF
				
				*** VERIFICA ESISTENZA RECORD SU AQUARIUS IN CORRISPONDENZA DEL CAMPO "External_Id__c" (SONO ESCLUSE LE RIGHE DI COMMENTO)
				x_agga = "DAGGANCIO = '" + SUBSTR(&_cProperty,1,10) + "'"
				x_csys = "ORD_CODSYS = '" + SUBSTR(&_cProperty,11,10) + "'"
				x_comm = "ORD_DESART <> '*** COMMENTO ***'"
				x_cond = x_agga + " and " + x_csys + " and " + x_comm
				cSql = "select DAGGANCIO,ORD_CODART,ORD_CODSYS from U_ORD_DD WHERE " + x_cond
				IF !ExecCommand(cSql,"CHK_ORD_DD")
				   return(.f.)
				ENDIF
				SELECT CHK_ORD_DD
				GO TOP
				IF EOF()
				
					_cProperty = "obj_json_dd._records.Array("+ALLTRIM(STR(I_row))+")._Id"
					IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
						IF &_cProperty = ""
							LOOP
						ENDIF
					ENDIF
					
					*** CANCELLAZIONE DETTAGLIO ORDINE SU SFDC
					_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Riga_ordine_di_vendita__c/"+&_cProperty
					_cJson = ""
					_cJson = SALESFORCEREST_DELETE(_HTTP_request,_access_token)
					IF EMPTY(_cJson)
						WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"' in fase di cancellazione riga ordine: verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
						
						_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
							"Warning: Oggetto JSON restituito VUOTO durante il tentativo di cancellazione riga ordine Id=" + &_cProperty + " (" + x_cond + ")"
						LOOP
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
								
								cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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

			RELEASE obj_json_dd
		ENDIF

	ENDDO

ENDSCAN

WAIT CLEAR
**=> ERASMO - FINE 04/04/2025

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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale dettagli ordini inseriti da Aquarius: " + ALLTRIM(STR(_CONTA_INS_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun dettaglio ordine inserito da Aquarius"
ENDIF
IF _CONTA_AGG_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale dettagli ordini aggiornati da Aquarius: " + ALLTRIM(STR(_CONTA_AGG_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun dettaglio ordine aggiornato da Aquarius"
ENDIF
**=> ERASMO - INIZIO 04/04/2025
IF _CONTA_DEL_DA_SF > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale dettagli ordini cancellati su SalesForce: " + ALLTRIM(STR(_CONTA_DEL_DA_SF))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun dettaglio ordine cancellato su SalesForce"
ENDIF
**=> ERASMO - FINE 04/04/2025

cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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

_OK_SYNC_ORDINI = .T.
			
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
_ProductCode = STRTRAN(_ProductCode,"+","%2B")  && ERASMO - 27/11/2023

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Dettaglio Ordine " + _Numero_ordine__c + " del " + _Data_ordine_cliente__c + " - Articolo " + _CodiceProdottoAquarius + " non trovato in tabella SFDC Product2"
			REPLACE MESSAGGIO WITH ALLTRIM(MESSAGGIO) + " - " + _message  && ERASMO - 12/03/2025
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
FUNCTION LOOKUP_ORDINE_DI_VENDITA__C
**********************************************************************
LPARAMETERS _par_External_id_Ordine_di_vendita__c

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 06/02/2025

_RIT = ""

_C_External_id_Ordine_di_vendita__c = ALLTRIM(_par_External_id_Ordine_di_vendita__c)

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Account__c+FROM+Ordine_di_vendita__c+WHERE+External_id__c='"+_C_External_id_Ordine_di_vendita__c+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Lookup Testata Ordine External_id__c " + _C_External_id_Ordine_di_vendita__c + " - " + _message
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