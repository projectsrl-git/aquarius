
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
_LOG_OGGETTO = "FATTURE"
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
CREATE CURSOR TMP_SF_FATTURA__C ( ;
	Id C(254), ;
	IsDeleted C(254), ;
	Name C(254), ;
	CurrencyIsoCode C(254), ;
	CreatedDate C(254), ;
	CreatedById C(254), ;
	LastModifiedDate C(254), ;
	LastModifiedById C(254), ;
	SystemModstamp C(254), ;
	LastActivityDate C(254), ;
	Anno__c C(254), ;
	Mese__c C(254), ;
	data_doc__c C(254), ;
	data_prev_evasione__c C(254), ;
	canale_vendita__c C(254), ;
	Ragione_Sociale__c C(254), ;
	Codice_Cliente__c C(254), ;
	Articolo__c C(254), ;
	desarticolo__c C(254), ;
	Gruppo__c C(254), ;
	Famiglia__c C(254), ;
	sottofamiglia__c C(254), ;
	centrcosto_descrizione__c C(254), ;
	euro_prnetto_quantita__c C(254), ;
	sconto_quantita__c C(254), ;
	quantita__c C(254), ;
	ult_prezzo_acquisto__c C(254), ;
	prezzo_ult_listino__c C(254), ;
	Ragione_Sociale_testo__c C(254), ;
	Id_Dettaglio__c C(20), ;
	Fattura__c C(254), ;
	Numero_Fattura__c C(254), ;
	OwnerId C(254), ;
	Product__c C(254), ;
	Riga_DDT__c C(254), ;
	Ordine__c C(254))

*** ELABORAZIONE FATTURE AQUARIUS MODIFICATE O INSERITE RISPETTO ALL'ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE (TESTATE FATTURE)
WAIT WINDOWS "Lettura Fatture Aquarius modificate o inserite rispetto all'ultima sincronizzazione..." NOWAIT

_ULT_TS_SYNC_FAT = ""
*cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
*** PER LA DATA ULTIMA SINCRONIZZAZIONE CONSIDERO LA 2° DATA ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE (TESTATE FATTURE)
cSql   = "SELECT TOP 2 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'FATTURE_TESTATE' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"  && ERASMO - 12/10/2021
IF !ExecCommand(cSql,"ULT_TS_SYNC_FAT")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_FAT
*GO TOP
GO BOTTOM  && ERASMO - 12/10/2021
_ULT_TS_SYNC_FAT = LAST_DATE

**=> ERASMO - INIZIO 11/03/2025
_ULT_TS_SYNC_FAT_DD = ""
cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
IF !ExecCommand(cSql,"ULT_TS_SYNC_FAT_DD")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_FAT_DD
GO TOP
_ULT_TS_SYNC_FAT_DD = LAST_DATE
_ULT_TS_SYNC_FAT = MIN(_ULT_TS_SYNC_FAT,_ULT_TS_SYNC_FAT_DD)
**=> ERASMO - FINE 11/03/2025

*_ULT_TS_SYNC_FAT = '2023/12/1400:00:00'  && ###TEST### TUTTE LE RIGHE FATTURA ###TEST###

x_cond = "ACL.SF_ACCOUNT_ID <> '' AND DD.ORD_CODART <> '' AND (CASE TT.MOD_DATREG WHEN '' THEN (TT.REG_DATREG+CASE TT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE TT.REG_ORAREG END) " + ;
         "ELSE TT.MOD_DATREG+CASE TT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE TT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_FAT + "'"
*x_cond = x_cond + " AND TT.ORD_NUMORD >= '001330' "
*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND DD.ORD_CODART <> '' AND substring(TT.ORD_DATORD,1,4) = '2021'"
*x_cond = "ACL.SF_ACCOUNT_ID <> '' AND DD.ORD_CODART <> '' AND TT.ORD_DATORD >= '2021/11/01'"
*x_cond = x_cond + " AND DD.DAGGANCIO >= '6000034220' "
cSql=""     
cNomeCursorSql="TMP_FATTURATO"
TEXT TO cSql NOSHOW
	
	SELECT
		DD.DAGGANCIO,
		DD.ORD_SEQUEN,
		--TT.ORD_VALUTA AS VALUTA,
		'EUR' AS VALUTA,  -- ERASMO - 28/09/2023
		SUBSTRING(TT.ORD_DATORD,1,4) AS ANNO,
		SUBSTRING(TT.ORD_DATORD,6,2) AS MESE,
		REPLACE(TT.ORD_DATORD,'/','-') AS DATA_DOC_RIBALTATA,
		TT.ORD_NUMORD AS NUM_FATTURA,
		REPLACE(DD.ORD_DATCON,'/','-') AS DTE_PREV_EVASIONE_RIBALTATA,
		COALESCE(CVEN_1_3.DESCRI,'') AS CANALE_VENDITA,
		RTRIM(TT.ORD_RAGSOC) AS RAG_SOCIALE,
		COALESCE(ACL.SF_ACCOUNT_ID,'') AS SF_ACCOUNT_ID,
		RTRIM(TT.ORD_CODCLI) AS CODICE_CLIENTE,
		RTRIM(DD.ORD_CODART) AS ARTICOLO,
		RTRIM(DD.ORD_DESART) AS DESARTICOLO,
		SUBSTRING(ARTAN.ART_CODGMI,1,3) + ' - ' + RTRIM(COALESCE(CCODGRU.DESCRI,'')) AS GRUPPO,
		SUBSTRING(ARTAN.ART_CODGMI,1,6) + ' - ' + RTRIM(COALESCE(CCODFAM.DESCRI,'')) AS FAMIGLIA,
		ARTAN.ART_CODGMI + ' - ' + RTRIM(COALESCE(CCODMERC.DESCRI,'')) AS SOTTOFAMIGLIA,
		RTRIM(COALESCE(CC.CON_DESCR,'')) AS CENTRCOSTO_DESCRIZIONE,
		CASE DD.ORD_PUBBLI
			WHEN 'O' THEN 0
			ELSE (CASE SUBSTRING(CAUSAL.LIBERA,11,1) WHEN 'S' THEN -1 ELSE 1 END) * DD.ORD_PRZNET*DD.ORD_QTAORD*TT.ORD_CAMBIO
		END AS EURO_PRNETTO_QUANTITA,
		CASE DD.ORD_PUBBLI
			WHEN 'O' THEN (CASE SUBSTRING(CAUSAL.LIBERA,11,1) WHEN 'S' THEN -1 ELSE 1 END) * DD.ORD_PRZNET*DD.ORD_QTAORD*TT.ORD_CAMBIO
			ELSE (CASE SUBSTRING(CAUSAL.LIBERA,11,1) WHEN 'S' THEN -1 ELSE 1 END) * (DD.ORD_PREZZO - DD.ORD_PRZNET)*DD.ORD_QTAORD*TT.ORD_CAMBIO
		END AS SCONTO_QUANTITA,
		DD.ORD_QTAORD AS QUANTITA,
		PR.ART_ULPCAR AS ULT_PREZZO_ACQUISTO,
		COALESCE((
			CASE CLI.CLI_LISTIN
				WHEN '1' THEN PR.ART_PRZVEN
				WHEN '2' THEN PR.ART_PRZVE2
				WHEN '3' THEN PR.ART_PRZVE3
				WHEN '4' THEN PR.ART_PRZVE4
				WHEN '5' THEN PR.ART_PRZVE5
				ELSE PR.ART_PRZVEN
			END),0) AS PREZZO_ULT_LISTINO,
		COALESCE(BD.DAGGANCIO+BD.ORD_CODSYS,'') AS EXTERNAL_ID_RIGA_DDT,  -- ERASMO - 14/12/2023
		COALESCE((SELECT TOP 1 TAGGANCIO FROM U_ORD_TT WHERE ORD_NUMORD = DD.ORS_NUMORC AND ORD_DATORD = DD.ORS_DATORC ORDER BY TAGGANCIO),'') AS EXTERNAL_ID_TESTATA_ORDINE  -- ERASMO - 04/03/2024
	FROM U_FAT_DD AS DD
	LEFT OUTER JOIN U_FAT_TT AS TT ON TT.TAGGANCIO = DD.DAGGANCIO
	LEFT OUTER JOIN U_ART_PR AS PR ON DD.ORD_CODART = PR.ART_CODPRI
	LEFT OUTER JOIN U_ART_AN AS ARTAN ON DD.ORD_CODART = ARTAN.ART_CODPRI
	LEFT OUTER JOIN CCOSTO AS CC ON DD.ORD_CCODET = CC.CON_CONTO AND CC.CON_ANNO = TT.ORD_ANNO
	LEFT OUTER JOIN U_CLI_AN AS CLI ON TT.ORD_CODCLI = CLI.CLI_CODCLI 
	LEFT OUTER JOIN U_ANA_CL AS ACL ON TT.ORD_CODCLI = ACL.CLI_CODCLI 
	LEFT OUTER JOIN PARA AS CVEN ON CVEN.CODICE = 'CVE'+CLI.CLI_CANVEN AND LEN(RTRIM(CVEN.CODICE)) = 3+9
	LEFT OUTER JOIN PARA AS CVEN_1_3 ON CVEN_1_3.CODICE = 'CVE'+SUBSTRING(CLI.CLI_CANVEN,1,3) AND LEN(RTRIM(CVEN_1_3.CODICE)) = 3+3
	LEFT OUTER JOIN PARA AS CVEN_1_6 ON CVEN_1_6.CODICE = 'CVE'+SUBSTRING(CLI.CLI_CANVEN,1,6) AND LEN(RTRIM(CVEN_1_6.CODICE)) = 3+6
	LEFT OUTER JOIN PARA AS CZONA ON CZONA.CODICE = 'ZON'+CLI.CLI_ZONA 
	LEFT OUTER JOIN PARA AS CCODMERC ON CCODMERC.CODICE = 'GMI'+ARTAN.ART_CODGMI 
	LEFT OUTER JOIN PARA AS CCODGRU ON CCODGRU.CODICE = 'GMI'+SUBSTRING(ARTAN.ART_CODGMI,1,3)
	LEFT OUTER JOIN PARA AS CCODFAM ON CCODFAM.CODICE = 'GMI'+SUBSTRING(ARTAN.ART_CODGMI,1,6)
	LEFT OUTER JOIN PARA AS TIPORD ON TIPORD.CODICE = 'TPO'+TT.ORD_TIPOLOGIA
	LEFT OUTER JOIN PARA AS CAUSAL ON CAUSAL.CODICE = 'TOP'+TT.ORD_CAUS
	LEFT OUTER JOIN PROVINCE ON PROVINCE.SIGLA = TT.ORD_PROVIN
	LEFT OUTER JOIN REGIONI ON REGIONI.CODICE = PROVINCE.REGIONE
	LEFT OUTER JOIN PARA AS NAZIONI ON NAZIONI.CODICE = 'STA'+CLI.CLI_NAZION
	LEFT OUTER JOIN U_BOL_DD AS BD ON BD.ORS_SYSFAT <> '' AND BD.ORS_SYSFAT = DD.ORS_SYSDDT
	WHERE <<x_cond>>
	ORDER BY TT.ORD_DATORD,TT.ORD_NUMORD

ENDTEXT

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT TMP_FATTURATO
GO TOP
SCAN

*!*		IF RECNO() > 1
*!*			EXIT
*!*		ENDIF
	
	WAIT WINDOWS "Elaborazione dettaglio fattura Aquarius " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	_Id_Dettaglio__c = PADL(ALLTRIM(DAGGANCIO),10,'0')+PADL(ALLTRIM(STR(ORD_SEQUEN,10,0)),10,'0')
	
	*_Name = ALLTRIM(NUM_FATTURA)
	*_Name = PADL(ALLTRIM(DAGGANCIO),10,'0')+PADL(ALLTRIM(STR(ORD_SEQUEN,10,0)),10,'0')  && ERASMO - 21/06/2021
	_Name = ALLTRIM(ARTICOLO)  && ERASMO - 08/11/2021
	_CurrencyIsoCode = VALUTA
	_Anno__c = ANNO
	_Mese__c = MESE
	_data_doc__c = DATA_DOC_RIBALTATA
	_data_prev_evasione__c = IIF(EMPTY(ALLTRIM(DTE_PREV_EVASIONE_RIBALTATA)),"2999-12-31",DTE_PREV_EVASIONE_RIBALTATA)
	_canale_vendita__c = ALLTRIM(CANALE_VENDITA)
	_Ragione_Sociale__c = ALLTRIM(SF_ACCOUNT_ID)
	_Codice_Cliente__c = ALLTRIM(CODICE_CLIENTE)
	_Articolo__c = ALLTRIM(ARTICOLO)
	_desarticolo__c = ALLTRIM(DESARTICOLO)
	_Gruppo__c = ALLTRIM(GRUPPO)
	_Famiglia__c = ALLTRIM(FAMIGLIA)
	_sottofamiglia__c = ALLTRIM(SOTTOFAMIGLIA)
	_centrcosto_descrizione__c = ALLTRIM(CENTRCOSTO_DESCRIZIONE)
	_euro_prnetto_quantita__c = EURO_PRNETTO_QUANTITA
	_sconto_quantita__c = SCONTO_QUANTITA
	_quantita__c = QUANTITA
	_ult_prezzo_acquisto__c = ULT_PREZZO_ACQUISTO
	_prezzo_ult_listino__c = PREZZO_ULT_LISTINO
	_Ragione_Sociale_testo__c = ALLTRIM(RAG_SOCIALE)
	
	_Fattura__c = ""	
	_Numero_Fattura__c = ALLTRIM(NUM_FATTURA)
	
	_CodiceProdottoAquarius = ALLTRIM(ARTICOLO)
	_Product__c = LOOKUP_PRODOTTO(_CodiceProdottoAquarius)
	IF EMPTY(_Product__c)
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Fattura " + _Numero_Fattura__c + "/" + _Anno__c + " - Articolo " + _CodiceProdottoAquarius + " non trovato in tabella SFDC Product2"
			_SEC_FIN = SECONDS()
			REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
		ENDIF
		IF !ExecRW(cSql,"LOG_SFSYNC","W")
		   return(.f.)
		ENDIF
		RETURN .F.
	ENDIF
	
	**=> ERASMO - INIZIO 10/06/2021
	_External_id_Fattura_testata__c = ALLTRIM(DAGGANCIO)
	_Fattura__c = LOOKUP_FATTURA_TESTATA__C(_External_id_Fattura_testata__c)
	IF EMPTY(_Fattura__c)
		WAIT WINDOWS SUBSTR("Fattura " + _Numero_Fattura__c + "/" + _Anno__c + " - Articolo " + _CodiceProdottoAquarius + " - Testata Fattura non trovata per External ID '" + _External_id_Fattura_testata__c + "'",1,254) TIMEOUT 2
		_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
			"Warning: Fattura " + _Numero_Fattura__c + "/" + _Anno__c + " - Articolo " + _CodiceProdottoAquarius + " - Testata Fattura non trovata per External ID '" + _External_id_Fattura_testata__c + "'"
	ENDIF	
	**=> ERASMO - FINE 10/06/2021
	
	*** PULIZIA CARATTERE CR E LF
	_Ragione_Sociale_testo__c = STRTRAN(STRTRAN(_Ragione_Sociale_testo__c,CHR(13),' '),CHR(10),'')
	_canale_vendita__c = STRTRAN(STRTRAN(_canale_vendita__c,CHR(13),' '),CHR(10),'')
	_Articolo__c = STRTRAN(STRTRAN(_Articolo__c,CHR(13),' '),CHR(10),'')
	_desarticolo__c = STRTRAN(STRTRAN(_desarticolo__c,CHR(13),' '),CHR(10),'')
	_Gruppo__c = STRTRAN(STRTRAN(_Gruppo__c,CHR(13),' '),CHR(10),'')
	_Famiglia__c = STRTRAN(STRTRAN(_Famiglia__c,CHR(13),' '),CHR(10),'')
	_sottofamiglia__c = STRTRAN(STRTRAN(_sottofamiglia__c,CHR(13),' '),CHR(10),'')
	_centrcosto_descrizione__c = STRTRAN(STRTRAN(_centrcosto_descrizione__c,CHR(13),' '),CHR(10),'')
	
	*** ESCAPING CARATTERE \	
	_Ragione_Sociale_testo__c = STRTRAN(_Ragione_Sociale_testo__c,'\','\\')
	_canale_vendita__c = STRTRAN(_canale_vendita__c,'\','\\')
	_Articolo__c = STRTRAN(_Articolo__c,'\','\\')
	_desarticolo__c = STRTRAN(_desarticolo__c,'\','\\')
	_Gruppo__c = STRTRAN(_Gruppo__c,'\','\\')
	_Famiglia__c = STRTRAN(_Famiglia__c,'\','\\')
	_sottofamiglia__c = STRTRAN(_sottofamiglia__c,'\','\\')
	_centrcosto_descrizione__c = STRTRAN(_centrcosto_descrizione__c,'\','\\')
	
	*** ESCAPING CARATTERE "
	_Ragione_Sociale_testo__c = STRTRAN(_Ragione_Sociale_testo__c,'"','\"')
	_canale_vendita__c = STRTRAN(_canale_vendita__c,'"','\"')
	_Articolo__c = STRTRAN(_Articolo__c,'"','\"')
	_desarticolo__c = STRTRAN(_desarticolo__c,'"','\"')
	_Gruppo__c = STRTRAN(_Gruppo__c,'"','\"')
	_Famiglia__c = STRTRAN(_Famiglia__c,'"','\"')
	_sottofamiglia__c = STRTRAN(_sottofamiglia__c,'"','\"')
	_centrcosto_descrizione__c = STRTRAN(_centrcosto_descrizione__c,'"','\"')
	
	**=> ERASMO - INIZIO 14/12/2023
	SELECT TMP_FATTURATO  && ERASMO - 06/02/2025
	_EXTERNAL_ID_RIGA_DDT = EXTERNAL_ID_RIGA_DDT
	_Riga_DDT__c = LOOKUP_RIGA_DDT__C(_EXTERNAL_ID_RIGA_DDT)	
	**=> ERASMO - FINE 14/12/2023
	
	_Ordine__c = LOOKUP_ORDINE_DI_VENDITA__C(EXTERNAL_ID_TESTATA_ORDINE)  && ERASMO - 04/03/2024
		
*!*		IF EMPTY(_CLI_PARIVA) AND EMPTY(_CLI_CODFIS) AND EMPTY(_CLI_IVACEE)
*!*			WAIT WINDOWS SUBSTR("Cliente Aquarius " + _CLI_RAGSOC + " incompleto, pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
*!*			_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
*!*				"Warning: Cliente Aquarius " + _CLI_RAGSOC + "(" + _CLI_CODCLI + ") incompleto, non considerato in elaborazione clienti Aquarius modificati rispetto all'ultima sincronizzazione"
*!*			SELECT TMP_FATTURATO
*!*			LOOP
*!*		ENDIF
	
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,data_doc__c,Articolo__c+FROM+Fattura__c+WHERE+Id_Dettaglio__c='"+_Id_Dettaglio__c+"'"

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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
	SELECT TMP_SF_FATTURA__C
	ZAP
	
	IF OBJ_JSON._totalSize = 0
		
		*** INSERIMENTO NUOVA FATTURA SU SALESFORCE
		
		_json_content = '{'
		_json_content = _json_content + '"Id_Dettaglio__c": "' + _Id_Dettaglio__c + '"'

		_json_content = _json_content + ', "Name": "' + _Name + '"'
		_json_content = _json_content + ', "CurrencyIsoCode": "' + _CurrencyIsoCode + '"'
		_json_content = _json_content + ', "Anno__c": "' + _Anno__c + '"'
		_json_content = _json_content + ', "Mese__c": "' + _Mese__c + '"'
		_json_content = _json_content + ', "data_doc__c": "' + _data_doc__c + '"'
		_json_content = _json_content + ', "data_prev_evasione__c": "' + _data_prev_evasione__c + '"'
		*_json_content = _json_content + ', "canale_vendita__c": "' + _canale_vendita__c + '"'
		_json_content = _json_content + ', "Ragione_Sociale__c": "' + _Ragione_Sociale__c + '"'
		_json_content = _json_content + ', "Articolo__c": "' + _Articolo__c + '"'
		_json_content = _json_content + ', "desarticolo__c": "' + _desarticolo__c + '"'
		_json_content = _json_content + ', "Gruppo__c": "' + _Gruppo__c + '"'
		_json_content = _json_content + ', "Famiglia__c": "' + _Famiglia__c + '"'
		_json_content = _json_content + ', "sottofamiglia__c": "' + _sottofamiglia__c + '"'
		_json_content = _json_content + ', "centrcosto_descrizione__c": "' + _centrcosto_descrizione__c + '"'
		_json_content = _json_content + ', "euro_prnetto_quantita__c": ' + STRTRAN(ALLTRIM(STR(_euro_prnetto_quantita__c,19,PUB_DECPRZ)),',','.')		
		_json_content = _json_content + ', "sconto_quantita__c": ' + STRTRAN(ALLTRIM(STR(_sconto_quantita__c,19,PUB_DECPRZ)),',','.')
		_json_content = _json_content + ', "quantita__c": ' + STRTRAN(ALLTRIM(STR(_quantita__c,19,PUB_DECQTA)),',','.')
		_json_content = _json_content + ', "ult_prezzo_acquisto__c": ' + STRTRAN(ALLTRIM(STR(_ult_prezzo_acquisto__c,19,PUB_DECPRZ)),',','.')
		_json_content = _json_content + ', "prezzo_ult_listino__c": ' + STRTRAN(ALLTRIM(STR(_prezzo_ult_listino__c,19,PUB_DECPRZ)),',','.')
		_json_content = _json_content + ', "Numero_Fattura__c": "' + _Numero_Fattura__c + '"'
		_json_content = _json_content + ', "Fattura__c": ' + IIF(!EMPTY(_Fattura__c),'"'+ _Fattura__c + '"','null')  && ERASMO - 10/06/2021
		_json_content = _json_content + ', "Product__c": "' + _Product__c + '"'
		_json_content = _json_content + ', "Riga_DDT__c": ' + IIF(!EMPTY(_Riga_DDT__c),'"'+ _Riga_DDT__c + '"','null')  && ERASMO - 14/12/2023
		_json_content = _json_content + ', "Ordine__c": ' + IIF(!EMPTY(_Ordine__c),'"'+ _Ordine__c + '"','null')  && ERASMO - 04/03/2024
		_json_content = _json_content + '}'
		
		_cJson = ""
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Fattura__c/"

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
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
							
							cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
						
							_SF_FATTURA__C_ID = _id
							*_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
							
*!*								cSql = "SELECT * FROM U_ANA_CL WHERE CLI_CODCLI = '" + _CLI_CODCLI + "'"
*!*								IF !ExecRW(cSql,"U_ANA_CL","R")
*!*									return(.f.)
*!*								ENDIF
*!*								SELECT U_ANA_CL
*!*								GO TOP
*!*								IF !EOF()
*!*									REPLACE SF_ACCOUNT_ID WITH _SF_ACCOUNT_ID
*!*									*REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
*!*								ENDIF
*!*								IF !ExecRW(cSql,"U_ANA_CL","W")
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
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
		
		SELECT TMP_SF_FATTURA__C
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
		
		SELECT TMP_SF_FATTURA__C
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_FATTURA__C
	_SF_FATTURA__C_ID = ID
	*_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
	
*!*		cSql = "SELECT * FROM U_ANA_CL WHERE CLI_CODCLI = '" + _CLI_CODCLI + "'"
*!*		IF !ExecRW(cSql,"U_ANA_CL","R")
*!*			return(.f.)
*!*		ENDIF
*!*		SELECT U_ANA_CL
*!*		GO TOP
*!*		IF !EOF()
*!*			REPLACE SF_ACCOUNT_ID WITH _SF_ACCOUNT_ID
*!*			REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
*!*		ENDIF
*!*		IF !ExecRW(cSql,"U_ANA_CL","W")
*!*			return(.f.)
*!*		ENDIF

	SELECT TMP_SF_FATTURA__C
	ZAP
	
	_json_content = '{'
	_json_content = _json_content + '"Name": "' + _Name + '"'
	_json_content = _json_content + ', "CurrencyIsoCode": "' + _CurrencyIsoCode + '"'
	_json_content = _json_content + ', "Anno__c": "' + _Anno__c + '"'
	_json_content = _json_content + ', "Mese__c": "' + _Mese__c + '"'
	_json_content = _json_content + ', "data_doc__c": "' + _data_doc__c + '"'
	_json_content = _json_content + ', "data_prev_evasione__c": "' + _data_prev_evasione__c + '"'
	*_json_content = _json_content + ', "canale_vendita__c": "' + _canale_vendita__c + '"'
	*_json_content = _json_content + ', "Ragione_Sociale__c": "' + _Ragione_Sociale__c + '"'
	_json_content = _json_content + ', "Articolo__c": "' + _Articolo__c + '"'
	_json_content = _json_content + ', "desarticolo__c": "' + _desarticolo__c + '"'
	_json_content = _json_content + ', "Gruppo__c": "' + _Gruppo__c + '"'
	_json_content = _json_content + ', "Famiglia__c": "' + _Famiglia__c + '"'
	_json_content = _json_content + ', "sottofamiglia__c": "' + _sottofamiglia__c + '"'
	_json_content = _json_content + ', "centrcosto_descrizione__c": "' + _centrcosto_descrizione__c + '"'
	_json_content = _json_content + ', "euro_prnetto_quantita__c": ' + STRTRAN(ALLTRIM(STR(_euro_prnetto_quantita__c,19,PUB_DECPRZ)),',','.')		
	_json_content = _json_content + ', "sconto_quantita__c": ' + STRTRAN(ALLTRIM(STR(_sconto_quantita__c,19,PUB_DECPRZ)),',','.')
	_json_content = _json_content + ', "quantita__c": ' + STRTRAN(ALLTRIM(STR(_quantita__c,19,PUB_DECQTA)),',','.')
	_json_content = _json_content + ', "ult_prezzo_acquisto__c": ' + STRTRAN(ALLTRIM(STR(_ult_prezzo_acquisto__c,19,PUB_DECPRZ)),',','.')
	_json_content = _json_content + ', "prezzo_ult_listino__c": ' + STRTRAN(ALLTRIM(STR(_prezzo_ult_listino__c,19,PUB_DECPRZ)),',','.')
	_json_content = _json_content + ', "Numero_Fattura__c": "' + _Numero_Fattura__c + '"'
	*_json_content = _json_content + ', "Fattura__c": ' + IIF(!EMPTY(_Fattura__c),'"'+ _Fattura__c + '"','null')  && ERASMO - 10/06/2021 - ### ERASMO - 08/11/2021 - RIGA ASTERISCATA CAUSA ERRORE PER RE-PARENTIG NON POSSIBILE
	_json_content = _json_content + ', "Product__c": "' + _Product__c + '"'
	_json_content = _json_content + ', "Riga_DDT__c": ' + IIF(!EMPTY(_Riga_DDT__c),'"'+ _Riga_DDT__c + '"','null')  && ERASMO - 14/12/2023
	_json_content = _json_content + ', "Ordine__c": ' + IIF(!EMPTY(_Ordine__c),'"'+ _Ordine__c + '"','null')  && ERASMO - 04/03/2024
	_json_content = _json_content + '}'
		
	*** AGGIORNAMENTO CAMPI SU SALESFORCE
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Fattura__c/"+_SF_FATTURA__C_ID
	_cJson = ""

	*WAIT WINDOWS "Connessione a '"+_instance_url+"' in corso..." NOWAIT

	_cJson = SALESFORCEREST_PATCH(_HTTP_request,_access_token,_json_content)
	IF EMPTY(_cJson)
		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
		RETURN .F.
	ENDIF
	
	*WAIT WINDOWS "Elaborazione file Json per aggiornamento cliente " + _CLI_RAGSOC + " in corso..." NOWAIT
	
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
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
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


*!*	*** ELABORAZIONE NUOVI CLIENTI SALESFORCE CREATI (SENZA RIFERIMENTO CODICE CLIENTE AQUARIUS)
*!*	WAIT WINDOWS "Lettura nuovi clienti Salesforce creati (senza riferimento codice cliente Aquarius)..." NOWAIT

*!*	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,LastModifiedDate,Name,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode,BillingCountryCode,Phone,CurrencyIsoCode,Partita_Iva__c," + ;
*!*		"Codice_Fiscale__c,IVA_CEE_EXTRA_CEE__c,Cliente_Inadempiente__c,Data_Blocco_Fornitura__c,Tipo_di_fatturazione__c,Codice_Nazione__c,Centro_di_costo__c,Codice_Completo_Classe_di_vendita__c,Condizioni_di_Pagamento__c,Website" + ;
*!*		"+FROM+Account+WHERE+Codice_Cliente__c=null"

*!*	_cJson = ""
*!*	_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
*!*	IF EMPTY(_cJson)
*!*		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
*!*		RETURN .F.
*!*	ENDIF

*!*	WAIT WINDOWS "Elaborazione nuovi clienti Salesforce creati in corso..." NOWAIT

*!*	obj_json = json_decode(_cJson)

*!*	*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
*!*	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
*!*		_cProperty = "OBJ_JSON.Array(1)._message"
*!*		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
*!*			_message = ALLTRIM(&_cProperty)
*!*			WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
*!*			
*!*			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
*!*			IF !ExecRW(cSql,"LOG_SFSYNC","R")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT LOG_SFSYNC
*!*			GO TOP
*!*			IF !EOF()
*!*				REPLACE ESITO WITH "KO"
*!*				REPLACE MESSAGGIO WITH _message
*!*				_SEC_FIN = SECONDS()
*!*				REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
*!*			ENDIF
*!*			IF !ExecRW(cSql,"LOG_SFSYNC","W")
*!*			   return(.f.)
*!*			ENDIF
*!*			
*!*			RELEASE obj_json			
*!*			RETURN .F.
*!*		ENDIF
*!*	ENDIF

*!*	SELECT TMP_SF_FATTURA__C
*!*	ZAP

*!*	IF OBJ_JSON._totalSize > 0

*!*		FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
*!*			
*!*			SELECT TMP_SF_FATTURA__C
*!*			SCATTER MEMVAR MEMO BLANK
*!*			
*!*			_cProperty = "OBJ_JSON._records.Array("+ALLTRIM(STR(I_row))+")._Id"
*!*			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
*!*				IF &_cProperty = ""
*!*					LOOP
*!*				ENDIF
*!*			ENDIF
*!*			
*!*			=AMEMBERS(gaPropArray, obj_json._RECORDS.Array(I_row), 0)  && Array containing properties
*!*			
*!*			FOR I_col=1 TO ALEN(gaPropArray)
*!*				_cProperty = "OBJ_JSON._records.Array("+ALLTRIM(STR(I_row))+")."+ALLTRIM(gaPropArray(I_col))
*!*				IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
*!*					IF SUBSTR(ALLTRIM(gaPropArray(I_col)),1,1) = "_"
*!*						_cCommand = "M."+SUBSTR(ALLTRIM(gaPropArray(I_col)),2)+" = "+_cProperty
*!*						&_cCommand
*!*					ENDIF
*!*				ENDIF
*!*			NEXT
*!*			
*!*			SELECT TMP_SF_FATTURA__C
*!*			APPEND BLANK
*!*			GATHER MEMVAR MEMO
*!*			
*!*		NEXT

*!*		RELEASE obj_json
*!*		
*!*		SELECT TMP_SF_FATTURA__C
*!*		GO TOP
*!*		SCAN
*!*		
*!*			IF RECNO() > 1
*!*				EXIT
*!*			ENDIF
*!*			
*!*			SCATTER MEMVAR MEMO
*!*			
*!*			cSql = "SELECT * FROM U_CLI_AN WHERE 1=0"
*!*			IF !ExecCommand(cSql,"TMP_CLI_AN")
*!*				return(.f.)
*!*			ENDIF
*!*			SELECT TMP_CLI_AN
*!*			SCATTER MEMVAR MEMO BLANK
*!*			cSql = "SELECT * FROM U_ANA_CL WHERE 1=0"
*!*			IF !ExecCommand(cSql,"TMP_ANA_CL")
*!*				return(.f.)
*!*			ENDIF
*!*			SELECT TMP_ANA_CL
*!*			SCATTER MEMVAR MEMO BLANK
*!*			
*!*			M.SF_ACCOUNT_ID = M.ID
*!*			M.SF_LASTMODIFIEDDATE = M.LASTMODIFIEDDATE
*!*			
*!*			M.CLI_RAGSOC = APITOSPA(UPPER(ALLTRIM(M.Name)))
*!*			M.CLI_INDIR = APITOSPA(UPPER(ALLTRIM(M.BillingStreet)))
*!*			M.CLI_LOCALI = APITOSPA(UPPER(ALLTRIM(M.BillingCity)))
*!*			M.CLI_CAP = ALLTRIM(M.BillingPostalCode)
*!*			M.CLI_PROVIN = UPPER(ALLTRIM(M.BillingStateCode))
*!*			
*!*			M.CLI_NAZION = PUB_NAZI
*!*			IF !EMPTY(UPPER(ALLTRIM(M.BillingCountryCode)))
*!*				x_cond = "codice LIKE 'STA%' AND libera = '" + UPPER(ALLTRIM(M.BillingCountryCode)) + "'"
*!*				cSql   = "select substring(codice,4,3) AS COD_NAZIONE_AQ from para where " + x_cond 
*!*				IF !ExecCommand(cSql,"TMP_PARA")
*!*				   return(.f.)
*!*				ENDIF
*!*				SELECT TMP_PARA
*!*				GO TOP
*!*				IF !EOF()
*!*					M.CLI_NAZION = COD_NAZIONE_AQ
*!*				ENDIF
*!*			ENDIF
*!*			
*!*			M.CLI_TELEFO = UPPER(ALLTRIM(M.Phone))
*!*			
*!*			M.CLI_VALUTA = UPPER(ALLTRIM(M.CurrencyIsoCode))
*!*			IF EMPTY(M.CLI_VALUTA)
*!*				M.CLI_VALUTA = PUB_VALRIF
*!*			ENDIF
*!*			
*!*			M.CLI_PARIVA = UPPER(ALLTRIM(M.Partita_Iva__c))
*!*			M.CLI_CODFIS = UPPER(ALLTRIM(M.Codice_Fiscale__c))
*!*			M.CLI_IVACEE = UPPER(ALLTRIM(M.IVA_CEE_EXTRA_CEE__c))
*!*			M.CLI_INADEM = IIF(UPPER(SUBSTR(M.Cliente_Inadempiente__c,1,1)) == 'F',.F.,.T.)
*!*			M.CLI_DTCLOK = RIBALTA2(STRTRAN(ALLTRIM(M.Data_Blocco_Fornitura__c),"-","/"))
*!*			M.CLI_TIPFAT = ALLTRIM(M.Tipo_di_fatturazione__c)
*!*			IF !EMPTY(ALLTRIM(M.Codice_Nazione__c))
*!*				M.CLI_NAZION = ALLTRIM(M.Codice_Nazione__c)
*!*			ENDIF
*!*			M.CLI_CCOST1 = UPPER(ALLTRIM(M.Centro_di_costo__c))
*!*			*M.CLI_ZONA = UPPER(ALLTRIM(M.Codice_Zona__c))
*!*			M.CLI_CANVEN = UPPER(ALLTRIM(M.Codice_Completo_Classe_di_vendita__c))
*!*			M.CLI_CONPAG = UPPER(ALLTRIM(M.Condizioni_di_Pagamento__c))
*!*			IF EMPTY(M.CLI_CONPAG)
*!*				M.CLI_CONPAG = PUB_CPA
*!*			ENDIF		
*!*			M.CLI_HOMPAG = ALLTRIM(M.Website)
*!*			
*!*			M.CLI_CODIVA = PUB_IVA
*!*			M.CLI_LISTIN = "1"
*!*			M.CLI_AGE = PUB_AGE
*!*			
*!*			X_CODICE = ""
*!*			x_cond = "codice = 'NUMCLI" + PUB_CODSOC + "'"
*!*			cSql   = "select * from para where " + x_cond 
*!*			IF !ExecRW(cSql,"para","R")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT PARA
*!*			GO TOP
*!*			IF EOF()
*!*				MESSAGEBOX('Parametro codice cliente non trovato',16,"*** ATTENZIONE ***")
*!*				IF !ExecRW(cSql,"para","W")
*!*				   return(.f.)
*!*				ENDIF
*!*				RETURN .F.
*!*			ELSE
*!*			   S_NUM = SUBSTR(LIBERA,1,10)
*!*			   IF S_NUM  <> "9999999999"                    && SOLO SE <> 9999999999
*!*			      N_NUM     = VAL(S_NUM)
*!*			      INC_NUM   = N_NUM + 10
*!*			      S_INC_NUM = STR(INC_NUM,10,0)
*!*			      X_CODICE  = ALLTRIM(S_INC_NUM)
*!*			      IF SUBSTR(X_CODICE,1,1)  <  "A"
*!*			 	     X_CODICE= TRC(PUB_LCL,ALLTRIM(X_CODICE))
*!*				  ENDIF
*!*			      REPLACE LIBERA WITH S_INC_NUM 
*!*			   ENDIF   
*!*			   
*!*			   INC_NUM   = N_NUM + 10
*!*			   S_INC_NUM = STR(INC_NUM,10,0)
*!*			   X_CODICE  = ALLTRIM(S_INC_NUM)
*!*			   IF SUBSTR(X_CODICE,1,1)  <  "A"
*!*			      X_CODICE = TRC(PUB_LCL,ALLTRIM(X_CODICE))
*!*			   ENDIF
*!*			ENDIF
*!*			IF !ExecRW(cSql,"para","W")
*!*			   return(.f.)
*!*			ENDIF
*!*			
*!*			M.CLI_CODSOC = PUB_CODSOC
*!*			M.CLI_CODCLI = X_CODICE
*!*			cSql = "SELECT * FROM U_CLI_AN WHERE 1=0"
*!*			IF !ExecRW(cSql,"U_CLI_AN","R")
*!*				return(.f.)
*!*			ENDIF
*!*			SELECT U_CLI_AN
*!*			APPEND BLANK
*!*			DO U_CLI_AN
*!*			IF !ExecRW(cSql,"U_CLI_AN","W")
*!*				return(.f.)
*!*			ENDIF
*!*			
*!*			cSql = "SELECT * FROM U_ANA_CL WHERE 1=0"
*!*			IF !ExecRW(cSql,"U_ANA_CL","R")
*!*				return(.f.)
*!*			ENDIF
*!*			SELECT U_ANA_CL
*!*			APPEND BLANK
*!*			DO U_ANA_CL
*!*			IF !ExecRW(cSql,"U_ANA_CL","W")
*!*				return(.f.)
*!*			ENDIF
*!*			
*!*			IF !EMPTY(ALLTRIM(M.CLI_CODCLI)) 			&& TEST DI SICUREZZA PER NON AGGIORNARE I MASTRI NEL CASO DI ERRORE SW
*!*				
*!*				V_ER = SOTTOGEN(M.cli_nazion)
*!*				IF !V_ER
*!*				   CC = PUB_CC
*!*				ENDIF 
*!*				* -->> Ricarico cursore
*!*				* --------------------------
*!*				V_CONTO = CC + ALLTRIM(M.CLI_CODCLI)
*!*				x_soci  = "con_soc = '" + PUB_CODSOC + "'"
*!*				x_anno  = "con_anno = '" + PUB_ANNO + "'"
*!*				x_cont  = "con_conto = '" + V_CONTO + "'"
*!*				x_cond  = x_soci + " and " + x_anno + " and " + x_cont
*!*				cSql    = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
*!*				IF !ExecRW(cSql,"conti","R")
*!*				   return(.f.)
*!*				ENDIF
*!*				  
*!*				IF RECCOUNT() = 0
*!*				   APPEND BLANK
*!*				   REPLACE CON_SOC     WITH PUB_CODSOC
*!*				   REPLACE CON_ANNO    WITH PUB_ANNO
*!*				   REPLACE CON_CONTO   WITH V_CONTO
*!*				   REPLACE CON_DESCR   WITH M.CLI_RAGSOC   
*!*				   REPLACE CON_TIPOCO  WITH 'C'
*!*				   REPLACE CON_PARIVA  WITH M.CLI_PARIVA 
*!*				   REPLACE CON_POSBIL  WITH 'P'
*!*				   REPLACE CON_IVASN   WITH .F.
*!*				   REPLACE CON_CCO     WITH SPACE(13)
*!*				ELSE
*!*				   REPLACE CON_DESCR   WITH M.CLI_RAGSOC   
*!*				   REPLACE CON_TIPOCO  WITH 'C'
*!*				   REPLACE CON_PARIVA  WITH M.CLI_PARIVA 
*!*				   REPLACE CON_POSBIL  WITH 'P'
*!*				   REPLACE CON_IVASN   WITH .F.
*!*				ENDIF 
*!*				IF !ExecRW(cSql,"conti","W")
*!*				   return(.f.)
*!*				ENDIF

*!*			ENDIF
*!*			
*!*			_json_content = '{'
*!*			_json_content = _json_content + '"Codice_Cliente__c": "' + ALLTRIM(M.CLI_CODCLI) + '"'
*!*			_json_content = _json_content + '}'
*!*			
*!*			*** AGGIORNAMENTO CAMPI SU SALESFORCE
*!*			_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Account/"+ALLTRIM(M.SF_ACCOUNT_ID)
*!*			_cJson = ""

*!*			_cJson = SALESFORCEREST_PATCH(_HTTP_request,_access_token,_json_content)
*!*			IF EMPTY(_cJson)
*!*				WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
*!*				RETURN .F.
*!*			ENDIF
*!*			
*!*			IF _cJson = "204"
*!*			ELSE
*!*				
*!*				obj_json = json_decode(_cJson)

*!*				*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
*!*				IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
*!*					_cProperty = "OBJ_JSON.Array(1)._message"
*!*					IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
*!*						_message = ALLTRIM(&_cProperty)
*!*						WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
*!*						
*!*						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
*!*						
*!*						RELEASE obj_json
*!*						RETURN .F.
*!*					ENDIF
*!*				ENDIF
*!*			
*!*			ENDIF
*!*			
*!*			_CONTA_INS_DA_SF = _CONTA_INS_DA_SF + 1
*!*			
*!*			RELEASE obj_json
*!*			
*!*		ENDSCAN
*!*	ENDIF



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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale dettagli fatture inseriti da Aquarius: " + ALLTRIM(STR(_CONTA_INS_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun dettaglio fattura inserito da Aquarius"
ENDIF
IF _CONTA_AGG_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale dettagli fatture aggiornati da Aquarius: " + ALLTRIM(STR(_CONTA_AGG_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun dettaglio fattura aggiornato da Aquarius"
ENDIF
*!*	IF _CONTA_INS_DA_SF > 0
*!*		_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale clienti inseriti da Salesforce: " + ALLTRIM(STR(_CONTA_INS_DA_SF))
*!*	ELSE
*!*		_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun cliente inserito da Salesforce"
*!*	ENDIF
*!*	IF _CONTA_AGG_DA_SF > 0
*!*		_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale clienti aggiornati da Salesforce: " + ALLTRIM(STR(_CONTA_AGG_DA_SF))
*!*	ELSE
*!*		_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun cliente aggiornato da Salesforce"
*!*	ENDIF

cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
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

_OK_SYNC_FATTURE = .T.
			
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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Fattura " + _Numero_Fattura__c + "/" + _Anno__c + " - Articolo " + _ProductCode + " - " + _message
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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
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


**=> ERASMO - INIZIO 14/12/2023
**********************************************************************
FUNCTION LOOKUP_RIGA_DDT__C
**********************************************************************
LPARAMETERS _C_External_id_Riga_DDT__c

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 06/02/2025

_RIT = ""

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name+FROM+Riga_DDT__c+WHERE+ID_esterno_AQ__c='"+_C_External_id_Riga_DDT__c+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'FATTURE' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Lookup Riga DDT ID_esterno_AQ__c " + _C_External_id_Riga_DDT__c + " - " + _message
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
**=> ERASMO - FINE 14/12/2023


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
