
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
_LOG_OGGETTO = "ASSETS"
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

*** CONTROLLI DI LOGIN SUPERATI, PROCEDO CON LE CHIAMATE SPECIFICHE PER LA SINCRONIZZAZIONE DEGLI ASSETS


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

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DEGLI ASSETS PRESENTI SU SALESFORCE
CREATE CURSOR TMP_SF_ASSET ( ;
	Id C(254), ;
	ContactId C(254), ;
	AccountId C(254), ;
	ParentId C(254), ;
	RootAssetId C(254), ;
	Product2Id C(254), ;
	ProductCode C(254), ;
	IsCompetitorProduct C(254), ;
	CreatedDate C(254), ;
	CreatedById C(254), ;
	LastModifiedDate C(254), ;
	LastModifiedById C(254), ;
	SystemModstamp C(254), ;
	IsDeleted C(254), ;
	CurrencyIsoCode C(254), ;
	Name C(254), ;
	SerialNumber C(254), ;
	InstallDate C(254), ;
	PurchaseDate C(254), ;
	UsageEndDate C(254), ;
	Status C(254), ;
	Price C(254), ;
	Quantity C(254), ;
	Description C(254), ;
	OwnerId C(254), ;
	AssetProvidedById C(254), ;
	AssetServicedById C(254), ;
	IsInternal C(254), ;
	AssetLevel C(254), ;
	StockKeepingUnit C(254), ;
	LastViewedDate C(254), ;
	LastReferencedDate C(254), ;
	Configurazione_dispositivo__c C(254), ;
	Tipologia__c C(254), ;
	Data_di_collaudo__c C(254), ;
	Sistema_Operativo__c C(254), ;
	Durata_Garanzia_Standard__c C(254), ;
	Data_scadenza_full_risk__c C(254), ;
	Flag_Invio_Email_Asset__c C(254), ;
	Connettivit_di_rete__c C(254), ;
	Modello_Device__c C(254), ;
	Codice_Prodotto__c C(254), ;
	Riferimento_Prodotto__c C(254), ;
	Codice_Products__c C(254), ;
	Id_Asset__c C(254), ;
	Causale_DDT__c c(254), ;
	Data_DDT__c c(254), ;
	Numero_DDT__c c(254), ;
	DDT__c c(254), ;
	Riga_DDT__c c(254), ;
	Ordine__c C(254), ;
	External_ID_fattura__c C(254), ;
	Causale_fattura__c C(254), ;
	Numero_fattura__c C(254), ;
	Data_fattura__c C(254))

*SET STEP ON
*** ELABORAZIONE ASSETS AQUARIUS MODIFICATI O INSERITI RISPETTO ALL'ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE
WAIT WINDOWS "Lettura assets Aquarius modificati o inseriti rispetto all'ultima sincronizzazione..." NOWAIT

_ULT_TS_SYNC_ASS = ""
cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
IF !ExecCommand(cSql,"ULT_TS_SYNC_ASS")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_ASS
GO TOP
_ULT_TS_SYNC_ASS = LAST_DATE

*_ULT_TS_SYNC_ASS = '2023/12/0100:00:00'  && ###TEST### TUTTI I DDT DA UNA DATA PREIMPOSTATA ###TEST###

*!*	x_cond = "TT.ORD_DATORD >= '2019/12/01' AND CL.SF_ACCOUNT_ID <> '' AND DD.ORD_CODART <> '' AND (CASE TT.MOD_DATREG WHEN '' THEN (TT.REG_DATREG+CASE TT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE TT.REG_ORAREG END) " + ;
*!*	         "ELSE TT.MOD_DATREG+CASE TT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE TT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_ASS + "'"
x_cond = "CL.SF_ACCOUNT_ID <> '' AND DD.ORD_CODART <> '' AND (CASE TT.MOD_DATREG WHEN '' THEN (TT.REG_DATREG+CASE TT.REG_ORAREG WHEN '' THEN '23:59:59' ELSE TT.REG_ORAREG END) " + ;
         "ELSE TT.MOD_DATREG+CASE TT.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE TT.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_ASS + "'"
*x_cond = "CL.SF_ACCOUNT_ID <> '' AND SUBSTRING(TT.ORD_DATORD,1,4) = '2015'"  && ###TEST### TUTTI I DDT DI UN ANNO PREIMPOSTATO ###TEST###
*x_cond = "CL.SF_ACCOUNT_ID <> '' AND DD.ORD_CODART <> '' AND TT.ORD_DATORD >= '2021/07/20'"  && ###TEST### TUTTI I DDT DA UNA DATA PREIMPOSTATA ###TEST###
*x_cond = x_cond + " AND TT.TAGGANCIO >= '9000000002' "
*x_cond = "CL.SF_ACCOUNT_ID <> '' AND DD.ORD_CODART <> '' AND TT.TAGGANCIO = '7000002742' "
*x_cond = "CL.SF_ACCOUNT_ID <> '' AND DD.ORD_CODART <> '' AND TT.ORD_DATORD = '2024/05/31' "

*!*	cSql=""     
*!*	cNomeCursorSql="TMP_ASSETS"
*!*	TEXT TO cSql NOSHOW
*!*		
*!*		SELECT
*!*			TT.TAGGANCIO AS TAGGANCIO,
*!*			DD.ORD_CODSYS AS CODSYS,
*!*			CL.SF_ACCOUNT_ID AS AccountId,
*!*			TT.ORD_VALUTA AS CurrencyIsoCode,
*!*			DD.ORD_DESART AS Name,
*!*			SN.SERIAL AS SerialNumber,
*!*			REPLACE(COALESCE((CASE WHEN OT.ORD_DATORC = '' THEN OT.ORD_DATORD ELSE OT.ORD_DATORC END),''),'/','-') AS PurchaseDate,
*!*			DD.ORD_PRZNET AS Price,
*!*			SN.QUANTI AS Quantity,
*!*			DD.ORD_DES2 AS Description,
*!*			1 AS AssetLevel,
*!*			CASE
*!*				WHEN DD.ORD_DESART LIKE '%PLATINUM+%' THEN 'PLATINUM+'
*!*				WHEN DD.ORD_DESART LIKE '%PLATINUM%' THEN 'PLATINUM'
*!*				WHEN DD.ORD_DESART LIKE '%SILVER%' THEN 'SILVER'
*!*				WHEN DD.ORD_DESART LIKE '%GOLD%' THEN 'GOLD'
*!*				ELSE ''
*!*			END AS Tipologia__c,
*!*			CASE
*!*				WHEN TT.ORD_DATCOL <> '' THEN REPLACE(TT.ORD_DATCOL,'/','-')
*!*				ELSE REPLACE(COALESCE((SELECT DBO.RIBALTA2(SUBSTRING(ORD_NOTE,27,10)) AS DATA_COLLAUDO FROM U_BOL_DD WHERE DAGGANCIO = DD.DAGGANCIO AND ORD_DESART = '*** COMMENTO ***' 
*!*					AND SUBSTRING(ORD_NOTE,1,26) = 'Data collaudo concordata: ' AND LEN(RTRIM(SUBSTRING(ORD_NOTE,27,10))) = 10 AND ASCII(SUBSTRING(ORD_NOTE,27+9,1)) <> 10),''),'/','-')
*!*			END AS Data_di_collaudo__c,
*!*			COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = SN.CODART AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0) AS Durata_Garanzia_Standard__c,
*!*			REPLACE(CONVERT(VARCHAR, DATEADD(MONTH, COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = SN.CODART AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0), 
*!*				CAST(TT.ORD_DATORD AS date)), 111),'/','-') AS Data_scadenza_full_risk__c,
*!*			SN.CODART AS Codice_Products__c,
*!*			COALESCE((SELECT ART_DESRID FROM U_ART_PR WHERE ART_CODPRI = SN.CODART),'') AS Riferimento_Prodotto__c,
*!*			SN.DAGGANCIO+SN.CODSYS AS Id_Asset__c,
*!*			AR.ART_CODTSN AS CODTSN,
*!*			RTRIM(TT.ORD_CAUS) + COALESCE(' - ' + P_TOP.DESCRI,'') AS Causale_DDT__c,
*!*			REPLACE(TT.ORD_DATORD,'/','-') AS Data_DDT__c,
*!*			RTRIM(TT.ORD_NUMORD) AS Numero_DDT__c
*!*		FROM U_BOL_SN AS SN
*!*		INNER JOIN U_BOL_DD AS DD ON DD.DAGGANCIO = SN.DAGGANCIO AND DD.ORD_CODSYS = SN.CODSYS AND DD.ORD_CODART = SN.CODART
*!*		INNER JOIN U_BOL_TT AS TT ON TT.TAGGANCIO = DD.DAGGANCIO
*!*		INNER JOIN U_CLI_AN AS AN ON AN.CLI_CODCLI = TT.ORD_CODCLI
*!*		INNER JOIN U_ANA_CL AS CL ON CL.CLI_CODCLI = TT.ORD_CODCLI
*!*		INNER JOIN U_ART_AN AS AR ON AR.ART_CODPRI = DD.ORD_CODART AND AR.ART_CODTSN IN ('SIS','PRD','ACQ')  -- ERASMO - 28/05/2021
*!*		--INNER JOIN U_ART_AN AS AR ON AR.ART_CODPRI = DD.ORD_CODART AND AR.ART_CODTSN IN ('SIS','PRD')
*!*		--INNER JOIN U_ART_AN AS AR ON AR.ART_CODPRI = DD.ORD_CODART AND AR.ART_CODTSN IN ('SIS')
*!*		LEFT OUTER JOIN U_ORD_TT AS OT ON OT.ORD_NUMORD = DD.ORS_NUMORC AND OT.ORD_DATORD = DD.ORS_DATORC
*!*		LEFT OUTER JOIN PARA AS P_TOP ON P_TOP.CODICE = 'TOP'+TT.ORD_CAUS
*!*		WHERE <<x_cond>>
*!*		ORDER BY TT.TAGGANCIO,DD.ORD_CODSYS
*!*		--and TT.taggancio in ('6006032324','6006029541','6006030563')
*!*	ENDTEXT

**=> ERASMO - INIZIO 02/08/2023 - INCLUSIONE DI ASSETS DA DETTAGLI DDT SENZA SERIAL NUMBER E ASSETS DA DETTAGLI FATTURE SENZA DDT LEGATE
cSql=""     
cNomeCursorSql="TMP_ASSETS"
TEXT TO cSql NOSHOW
	SELECT * FROM (
		SELECT
			'1-DDT' AS TIPO_DOC,
			TT.TAGGANCIO AS TAGGANCIO,
			DD.ORD_CODSYS AS CODSYS,
			CL.SF_ACCOUNT_ID AS AccountId,
			TT.ORD_VALUTA AS CurrencyIsoCode,
			DD.ORD_DESART AS Name,
			--SN.SERIAL AS SerialNumber,
			COALESCE(SN.SERIAL,'') AS SerialNumber,
			REPLACE(COALESCE((CASE WHEN OT.ORD_DATORC = '' THEN OT.ORD_DATORD ELSE OT.ORD_DATORC END),''),'/','-') AS PurchaseDate,
			DD.ORD_PRZNET AS Price,
			--SN.QUANTI AS Quantity,
			COALESCE(SN.QUANTI,DD.ORD_QTAORD) AS Quantity,
			DD.ORD_DES2 AS Description,
			1 AS AssetLevel,
			CASE
				WHEN DD.ORD_DESART LIKE '%PLATINUM+%' THEN 'PLATINUM+'
				WHEN DD.ORD_DESART LIKE '%PLATINUM%' THEN 'PLATINUM'
				WHEN DD.ORD_DESART LIKE '%SILVER%' THEN 'SILVER'
				WHEN DD.ORD_DESART LIKE '%GOLD%' THEN 'GOLD'
				ELSE ''
			END AS Tipologia__c,
			CASE
				WHEN TT.ORD_DATCOL <> '' THEN REPLACE(TT.ORD_DATCOL,'/','-')
				ELSE REPLACE(COALESCE((SELECT DBO.RIBALTA2(SUBSTRING(ORD_NOTE,27,10)) AS DATA_COLLAUDO FROM U_BOL_DD WHERE DAGGANCIO = DD.DAGGANCIO AND ORD_DESART = '*** COMMENTO ***' 
					AND SUBSTRING(ORD_NOTE,1,26) = 'Data collaudo concordata: ' AND LEN(RTRIM(SUBSTRING(ORD_NOTE,27,10))) = 10 AND ASCII(SUBSTRING(ORD_NOTE,27+9,1)) <> 10),''),'/','-')
			END AS Data_di_collaudo__c,
			--COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = SN.CODART AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0) AS Durata_Garanzia_Standard__c,
			COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = AR.ART_CODPRI AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0) AS Durata_Garanzia_Standard__c,
			--REPLACE(CONVERT(VARCHAR, DATEADD(MONTH, COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = SN.CODART AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0), 
			--	CAST(TT.ORD_DATORD AS date)), 111),'/','-') AS Data_scadenza_full_risk__c,
			REPLACE(CONVERT(VARCHAR, DATEADD(MONTH, COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = AR.ART_CODPRI AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0), 
				CAST(TT.ORD_DATORD AS date)), 111),'/','-') AS Data_scadenza_full_risk__c,
			--SN.CODART AS Codice_Products__c,
			AR.ART_CODPRI AS Codice_Products__c,
			--COALESCE((SELECT ART_DESRID FROM U_ART_PR WHERE ART_CODPRI = SN.CODART),'') AS Riferimento_Prodotto__c,
			COALESCE((SELECT ART_DESRID FROM U_ART_PR WHERE ART_CODPRI = AR.ART_CODPRI),'') AS Riferimento_Prodotto__c,
			--SN.DAGGANCIO+SN.CODSYS AS Id_Asset__c,
			DD.DAGGANCIO+DD.ORD_CODSYS AS Id_Asset__c,
			AR.ART_CODTSN AS CODTSN,
			RTRIM(TT.ORD_CAUS) + RTRIM(COALESCE(' - ' + P_TOP.DESCRI,'')) AS Causale_DDT__c,
			REPLACE(TT.ORD_DATORD,'/','-') AS Data_DDT__c,
			RTRIM(TT.ORD_NUMORD) AS Numero_DDT__c,
			TT.TAGGANCIO+DD.ORD_CODSYS AS EXTERNAL_ID_RIGA_DDT,
			TT.TAGGANCIO AS EXTERNAL_ID_TESTATA_DDT,
			COALESCE(OT.TAGGANCIO,'') AS EXTERNAL_ID_TESTATA_ORDINE,
			'' AS EXTERNAL_ID_FATTURA__C,  -- ERASMO - 01/06/2024
			'' AS CAUSALE_FATTURA__C,  -- ERASMO - 10/06/2024
			'' AS NUMERO_FATTURA__C,   -- ERASMO - 10/06/2024
			'' AS DATA_FATTURA__C      -- ERASMO - 10/06/2024
		--FROM U_BOL_SN AS SN
		--INNER JOIN U_BOL_DD AS DD ON DD.DAGGANCIO = SN.DAGGANCIO AND DD.ORD_CODSYS = SN.CODSYS AND DD.ORD_CODART = SN.CODART
		FROM U_BOL_DD AS DD
		LEFT OUTER JOIN U_BOL_SN AS SN ON DD.DAGGANCIO = SN.DAGGANCIO AND DD.ORD_CODSYS = SN.CODSYS AND DD.ORD_CODART = SN.CODART
		--INNER JOIN U_BOL_TT AS TT ON TT.TAGGANCIO = DD.DAGGANCIO 
		INNER JOIN U_BOL_TT AS TT ON TT.TAGGANCIO = DD.DAGGANCIO AND TT.ORD_CAUS IN ('VEN','VEG')  -- ERASMO - 03/06/2024
		INNER JOIN U_CLI_AN AS AN ON AN.CLI_CODCLI = TT.ORD_CODCLI
		INNER JOIN U_ANA_CL AS CL ON CL.CLI_CODCLI = TT.ORD_CODCLI
		--INNER JOIN U_ART_AN AS AR ON AR.ART_CODPRI = DD.ORD_CODART AND AR.ART_CODTSN IN ('SIS','PRD','ACQ')
		INNER JOIN U_ART_AN AS AR ON AR.ART_CODPRI = DD.ORD_CODART
		INNER JOIN U_ART_PR AS PR ON PR.ART_CODPRI = AR.ART_CODPRI AND PR.ART_NONMOV = 0
		LEFT OUTER JOIN U_ORD_TT AS OT ON OT.ORD_NUMORD = DD.ORS_NUMORC AND OT.ORD_DATORD = DD.ORS_DATORC
		LEFT OUTER JOIN PARA AS P_TOP ON P_TOP.CODICE = 'TOP'+TT.ORD_CAUS
		WHERE <<x_cond>>
		
		UNION
		
		SELECT
			'2-FAT' AS TIPO_DOC,
			TT.TAGGANCIO AS TAGGANCIO,
			DD.ORD_CODSYS AS CODSYS,
			CL.SF_ACCOUNT_ID AS AccountId,
			TT.ORD_VALUTA AS CurrencyIsoCode,
			DD.ORD_DESART AS Name,
			'' AS SerialNumber,
			REPLACE(COALESCE((CASE WHEN OT.ORD_DATORC = '' THEN OT.ORD_DATORD ELSE OT.ORD_DATORC END),''),'/','-') AS PurchaseDate,
			DD.ORD_PRZNET AS Price,
			--SN.QUANTI AS Quantity,
			DD.ORD_QTAORD AS Quantity,
			DD.ORD_DES2 AS Description,
			1 AS AssetLevel,
			CASE
				WHEN DD.ORD_DESART LIKE '%PLATINUM+%' THEN 'PLATINUM+'
				WHEN DD.ORD_DESART LIKE '%PLATINUM%' THEN 'PLATINUM'
				WHEN DD.ORD_DESART LIKE '%SILVER%' THEN 'SILVER'
				WHEN DD.ORD_DESART LIKE '%GOLD%' THEN 'GOLD'
				ELSE ''
			END AS Tipologia__c,
			CASE
				WHEN TT.ORD_DATCOL <> '' THEN REPLACE(TT.ORD_DATCOL,'/','-')
				ELSE REPLACE(COALESCE((SELECT DBO.RIBALTA2(SUBSTRING(ORD_NOTE,27,10)) AS DATA_COLLAUDO FROM U_FAT_DD WHERE DAGGANCIO = DD.DAGGANCIO AND ORD_DESART = '*** COMMENTO ***' 
					AND SUBSTRING(ORD_NOTE,1,26) = 'Data collaudo concordata: ' AND LEN(RTRIM(SUBSTRING(ORD_NOTE,27,10))) = 10 AND ASCII(SUBSTRING(ORD_NOTE,27+9,1)) <> 10),''),'/','-')
			END AS Data_di_collaudo__c,
			--COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = SN.CODART AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0) AS Durata_Garanzia_Standard__c,
			COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = AR.ART_CODPRI AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0) AS Durata_Garanzia_Standard__c,
			--REPLACE(CONVERT(VARCHAR, DATEADD(MONTH, COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = SN.CODART AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0), 
			--	CAST(TT.ORD_DATORD AS date)), 111),'/','-') AS Data_scadenza_full_risk__c,
			REPLACE(CONVERT(VARCHAR, DATEADD(MONTH, COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = AR.ART_CODPRI AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0), 
				CAST(TT.ORD_DATORD AS date)), 111),'/','-') AS Data_scadenza_full_risk__c,
			--SN.CODART AS Codice_Products__c,
			AR.ART_CODPRI AS Codice_Products__c,
			--COALESCE((SELECT ART_DESRID FROM U_ART_PR WHERE ART_CODPRI = SN.CODART),'') AS Riferimento_Prodotto__c,
			COALESCE((SELECT ART_DESRID FROM U_ART_PR WHERE ART_CODPRI = AR.ART_CODPRI),'') AS Riferimento_Prodotto__c,
			--SN.DAGGANCIO+SN.CODSYS AS Id_Asset__c,
			DD.DAGGANCIO+DD.ORD_CODSYS AS Id_Asset__c,
			AR.ART_CODTSN AS CODTSN,
			RTRIM(TT.ORD_CAUS) + RTRIM(COALESCE(' - ' + P_TOP.DESCRI,'')) AS Causale_DDT__c,
			--REPLACE(TT.ORD_DATORD,'/','-') AS Data_DDT__c,
			'' AS Data_DDT__c,  -- ERASMO - 10/06/2024
			--'F'+RTRIM(TT.ORD_NUMORD) AS Numero_DDT__c,
			'' AS Numero_DDT__c,  -- ERASMO - 01/06/2024
			'' AS EXTERNAL_ID_RIGA_DDT,
			'' AS EXTERNAL_ID_TESTATA_DDT,
			COALESCE(OT.TAGGANCIO,'') AS EXTERNAL_ID_TESTATA_ORDINE,
			RTRIM(TT.TAGGANCIO) AS EXTERNAL_ID_FATTURA__C,  -- ERASMO - 01/06/2024
			TT.ORD_CAUS AS CAUSALE_FATTURA__C,					-- ERASMO - 10/06/2024
			TT.ORD_NUMORD AS NUMERO_FATTURA__C,					-- ERASMO - 10/06/2024
			REPLACE(TT.ORD_DATORD,'/','-') AS DATA_FATTURA__C	-- ERASMO - 10/06/2024
		FROM U_FAT_TT AS TT
		INNER JOIN U_FAT_DD AS DD ON TT.TAGGANCIO = DD.DAGGANCIO AND DD.ORS_NUMDDT = '' AND DD.ORS_DATDDT = ''
		INNER JOIN U_CLI_AN AS AN ON AN.CLI_CODCLI = TT.ORD_CODCLI
		INNER JOIN U_ANA_CL AS CL ON CL.CLI_CODCLI = TT.ORD_CODCLI
		--INNER JOIN U_ART_AN AS AR ON AR.ART_CODPRI = DD.ORD_CODART AND AR.ART_CODTSN IN ('SIS','PRD','ACQ')
		INNER JOIN U_ART_AN AS AR ON AR.ART_CODPRI = DD.ORD_CODART
		--INNER JOIN U_ART_PR AS PR ON PR.ART_CODPRI = AR.ART_CODPRI AND PR.ART_NONMOV = 0
		INNER JOIN U_ART_PR AS PR ON PR.ART_CODPRI = AR.ART_CODPRI AND PR.ART_CODPRI NOT LIKE '.%'
		LEFT OUTER JOIN U_ORD_TT AS OT ON OT.ORD_NUMORD = DD.ORS_NUMORC AND OT.ORD_DATORD = DD.ORS_DATORC
		LEFT OUTER JOIN PARA AS P_TOP ON P_TOP.CODICE = 'TOP'+TT.ORD_CAUS
		WHERE <<x_cond>>
	) AS MAIN
	ORDER BY TIPO_DOC,TAGGANCIO,CODSYS
ENDTEXT
**=> ERASMO - FINE 02/08/2023

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT TMP_ASSETS
GO TOP
SCAN

*!*		IF RECNO() > 100
*!*			EXIT
*!*		ENDIF

	WAIT WINDOWS "Elaborazione asset (dettaglio DDT) Aquarius " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	_CODTSN = ALLTRIM(CODTSN)
	_TAGGANCIO = TAGGANCIO
	_CODSYS = CODSYS
	
	_SF_ASSET_ID = ""
	_SF_ASSET_PARENT_ID = ""
	
	_Id_Asset__c = ALLTRIM(Id_Asset__c)
	_AccountId = ALLTRIM(AccountId)
	_ParentId = ""
	_CurrencyIsoCode = ALLTRIM(CurrencyIsoCode)
	_Name = ALLTRIM(Name)
	_SerialNumber = ALLTRIM(SerialNumber)
	_PurchaseDate = ALLTRIM(PurchaseDate)
	_Price = Price
	_Quantity = Quantity
	_Description = ALLTRIM(Description)
	_AssetLevel = AssetLevel
	_Tipologia__c = ALLTRIM(Tipologia__c)
	_Data_di_collaudo__c = STRTRAN(ALLTRIM(Data_di_collaudo__c),' ','')
	IF !EMPTY(_Data_di_collaudo__c)
		IF LEN(_Data_di_collaudo__c) = 10 AND SUBSTR(_Data_di_collaudo__c,5,1) = '-' AND SUBSTR(_Data_di_collaudo__c,8,1) = '-'
			Local llError, xx
			Try
			   xx = DATE(VAL(SUBSTR(_Data_di_collaudo__c,1,4)),VAL(SUBSTR(_Data_di_collaudo__c,6,2)),VAL(SUBSTR(_Data_di_collaudo__c,9,2)))
			Catch
			   llError = .T.
			EndTry
			IF llError
				_Data_di_collaudo__c = ""
			ELSE
				_Data_di_collaudo__c = RIBALTA2(STRTRAN(DTOC(xx),'/','-'))
			ENDIF
		ELSE
			_Data_di_collaudo__c = ""
		ENDIF
	ENDIF
	_Durata_Garanzia_Standard__c = Durata_Garanzia_Standard__c
	_Data_scadenza_full_risk__c = ALLTRIM(Data_scadenza_full_risk__c)
	_Codice_Products__c = ALLTRIM(Codice_Products__c)
	**=> ERASMO - INIZIO 09/06/2021
	_Product2Id = LOOKUP_PRODOTTO(_Codice_Products__c)
	IF EMPTY(_Product2Id)
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Asset con Id_Asset__c " + _Id_Asset__c + " - Articolo " + _Codice_Products__c + " non trovato in tabella SFDC Product2"
			_SEC_FIN = SECONDS()
			REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
		ENDIF
		IF !ExecRW(cSql,"LOG_SFSYNC","W")
		   return(.f.)
		ENDIF
		RETURN .F.
	ENDIF
	**=> ERASMO - FINE 09/06/2021
	_Riferimento_Prodotto__c = ALLTRIM(Riferimento_Prodotto__c)
	*_Causale_DDT__c = Causale_DDT__c	&& ERASMO - 22/05/2020
	_Causale_DDT__c = ALLTRIM(Causale_DDT__c)	&& ERASMO - 04/09/2023
	_Data_DDT__c = Data_DDT__c			&& ERASMO - 22/05/2020
	_Numero_DDT__c = Numero_DDT__c		&& ERASMO - 22/05/2020
	_External_ID_fattura__c = ALLTRIM(EXTERNAL_ID_FATTURA__C)  && ERASMO - 01/06/2024
	**=> ERASMO - INIZIO 10/06/2024			
	_Causale_fattura__c = ALLTRIM(CAUSALE_FATTURA__C)
	_Numero_fattura__c = ALLTRIM(NUMERO_FATTURA__C)
	_Data_fattura__c = ALLTRIM(DATA_FATTURA__C)
	**=> ERASMO - FINE 10/06/2024
	
	
	*** PULIZIA CARATTERE CR E LF
	_Name = STRTRAN(STRTRAN(_Name,CHR(13),' '),CHR(10),'')
	_SerialNumber = STRTRAN(STRTRAN(_SerialNumber,CHR(13),' '),CHR(10),'')
	_Description = STRTRAN(STRTRAN(_Description,CHR(13),' '),CHR(10),'')
	_Tipologia__c = STRTRAN(STRTRAN(_Tipologia__c,CHR(13),' '),CHR(10),'')
	_Codice_Products__c = STRTRAN(STRTRAN(_Codice_Products__c,CHR(13),' '),CHR(10),'')
	_Riferimento_Prodotto__c = STRTRAN(STRTRAN(_Riferimento_Prodotto__c,CHR(13),' '),CHR(10),'')
	
	*** ESCAPING CARATTERE \	
	_Name = STRTRAN(_Name,'\','\\')
	_SerialNumber = STRTRAN(_SerialNumber,'\','\\')
	_Description = STRTRAN(_Description,'\','\\')
	_Tipologia__c = STRTRAN(_Tipologia__c,'\','\\')
	_Codice_Products__c = STRTRAN(_Codice_Products__c,'\','\\')
	_Riferimento_Prodotto__c = STRTRAN(_Riferimento_Prodotto__c,'\','\\')	
	
	*** ESCAPING CARATTERE "
	_Name = STRTRAN(_Name,'"','\"')
	_SerialNumber = STRTRAN(_SerialNumber,'"','\"')
	_Description = STRTRAN(_Description,'"','\"')
	_Tipologia__c = STRTRAN(_Tipologia__c,'"','\"')
	_Codice_Products__c = STRTRAN(_Codice_Products__c,'"','\"')
	_Riferimento_Prodotto__c = STRTRAN(_Riferimento_Prodotto__c,'"','\"')
	
*!*		**=> ERASMO - INIZIO 23/10/2023
*!*		IF EMPTY(_SerialNumber)
*!*			_RecordTypeId = "012MU0000004LPoYAM"
*!*		ELSE
*!*			_RecordTypeId = "012MU0000004LQhYAM"
*!*		ENDIF
*!*		**=> ERASMO - FINE 23/10/2023
	
	**=> ERASMO - INIZIO 12/12/2023
	IF EMPTY(_SerialNumber)
		_RecordTypeId = "01269000000xNVmAAM"
	ELSE
		_RecordTypeId = "01269000000xNVrAAM"
	ENDIF
	**=> ERASMO - FINE 12/12/2023
	
	**=> ERASMO - INIZIO 13/12/2023
	_EXTERNAL_ID_TESTATA_DDT = EXTERNAL_ID_TESTATA_DDT
	_EXTERNAL_ID_RIGA_DDT = EXTERNAL_ID_RIGA_DDT
	_DDT__c = LOOKUP_DDT__C(_EXTERNAL_ID_TESTATA_DDT)
	_Riga_DDT__c = LOOKUP_RIGA_DDT__C(_EXTERNAL_ID_RIGA_DDT)
	**=> ERASMO - FINE 13/12/2023
	
	_Ordine__c = LOOKUP_ORDINE_DI_VENDITA__C(EXTERNAL_ID_TESTATA_ORDINE)  && ERASMO - 04/03/2024
	
*!*		*###################
*!*		_LIV1_GIA_PRESENTE = .F.
*!*		*###################
	_json_content = ""
	_OK_INS_AGG = AGGIORNA_INSERISCE_ASSET("TMP_ASSETS")
	
	IF !_OK_INS_AGG
		*_CLIPTEXT = _json_content
		*SET STEP ON
		RETURN .F.
	ENDIF
	
*!*		*###################
*!*		IF _LIV1_GIA_PRESENTE
*!*			SELECT TMP_ASSETS
*!*			LOOP
*!*		ENDIF
*!*		*###################
	
	_SF_ASSET_PARENT_ID = _SF_ASSET_ID
	
*!*		IF _CODTSN = "SIS"
*!*		ELSE
*!*			LOOP
*!*		ENDIF
	
	**=> ERASMO - INIZIO 04/12/2020
	*** SE IL PRODOTTO E' UN SISTEMA OPPURE HA UN SERIAL NUMBER PRODOTTO RANDOM DA AQUARIUS IN QUANTO CONTIENE UNO O PIU' PRODOTTI DI PRODUZIONE INTERNA
	IF _CODTSN = "SIS" OR LEN(ALLTRIM(_SerialNumber)) = 13
	ELSE
		LOOP
	ENDIF
	**=> ERASMO - FINE 04/12/2020
	
	x_cond = "SN.DAGGANCIO = '" + _TAGGANCIO + "' AND SN.CODSYS = '" + _CODSYS + "' AND SN.SERIAL = '" + _SerialNumber + "' AND TRE.MOV_SERIAL <> '" + _SerialNumber + "'"
	cSql=""     
	cNomeCursorSql="TMP_ASSETS_LIV2"
	TEXT TO cSql NOSHOW
		
		SELECT 
			AT.ART_DESCR AS Name,
			TRE.MOV_SERIAL AS SerialNumber,
			AT.ART_ULPCAR AS Price,
			SN.QUANTI AS Quantity,
			'' AS Description,
			2 AS AssetLevel,
			CASE
				WHEN AT.ART_DESCR LIKE '%PLATINUM+%' THEN 'PLATINUM+'
				WHEN AT.ART_DESCR LIKE '%PLATINUM%' THEN 'PLATINUM'
				WHEN AT.ART_DESCR LIKE '%SILVER%' THEN 'SILVER'
				WHEN AT.ART_DESCR LIKE '%GOLD%' THEN 'GOLD'
				ELSE ''
			END AS Tipologia__c,
			COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = TRE.MOV_ANAART AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0) AS Durata_Garanzia_Standard__c,
			CONVERT(VARCHAR, DATEADD(MONTH, COALESCE((SELECT TOP 1 NMESI FROM U_ART_GA WHERE CODART = TRE.MOV_ANAART AND DTVAL >= CONVERT(VARCHAR, GETDATE(), 111) ORDER BY DTVAL),0), 
				CAST(TT.ORD_DATORD AS date)), 111) AS Data_scadenza_full_risk__c,
			TRE.MOV_ANAART AS Codice_Products__c,
			COALESCE((SELECT ART_DESRID FROM U_ART_PR WHERE ART_CODPRI = TRE.MOV_ANAART),'') AS Riferimento_Prodotto__c
		FROM U_BOL_SN AS SN
		INNER JOIN U_BOL_DD AS DD ON DD.DAGGANCIO = SN.DAGGANCIO AND DD.ORD_CODSYS = SN.CODSYS AND DD.ORD_CODART = SN.CODART
		INNER JOIN U_BOL_TT AS TT ON TT.TAGGANCIO = DD.DAGGANCIO
		INNER JOIN U_CLI_AN AS AN ON AN.CLI_CODCLI = TT.ORD_CODCLI
		INNER JOIN U_ANA_CL AS CL ON CL.CLI_CODCLI = TT.ORD_CODCLI --AND CL.SF_ACCOUNT_ID <> ''
		--INNER JOIN U_ART_AN AS AR ON AR.ART_CODPRI = DD.ORD_CODART AND AR.ART_CODTSN IN ('SIS')
		INNER JOIN U_ART_AN AS AR ON AR.ART_CODPRI = DD.ORD_CODART -- ERASMO - 04/12/2020
		LEFT OUTER JOIN U_ORD_TT AS OT ON OT.ORD_NUMORD = DD.ORS_NUMORC AND OT.ORD_DATORD = DD.ORS_DATORC
		OUTER APPLY (SELECT TOP 1 MOV_LEGAME FROM U_MAG_MO WHERE MOV_SEGNO = '-' AND MOV_TOP = TT.ORD_CAUS AND MOV_LEGSYS = DD.ORD_SYSMAG AND MOV_SERIAL = SN.SERIAL) AS MO
		OUTER APPLY (SELECT TOP 1 SUBSTRING(MOV_TRCKNG,1,8000) AS MOV_TRCKNG FROM U_MAG_MO WHERE SUBSTRING(MOV_TRCKNG,1,8000) <> '' AND MOV_SEGNO = '+' AND MOV_LEGAME = MO.MOV_LEGAME ORDER BY MOV_DTREGI, MOV_ORAMOV) AS TR
		OUTER APPLY(
			SELECT MOV_ANAART, MOV_SERIAL, MOV_LEGAME, COALESCE(TRM.MOV_TRCKNG,'') AS MOV_TRCKNG FROM U_MAG_MO AS MO 
			OUTER APPLY (SELECT TOP 1 SUBSTRING(MOV_TRCKNG,1,8000) AS MOV_TRCKNG FROM U_MAG_MO WHERE SUBSTRING(MOV_TRCKNG,1,8000) <> '' AND MOV_SEGNO = '+' AND MOV_LEGAME = MO.MOV_LEGAME ORDER BY MOV_DTREGI, MOV_ORAMOV) AS TRM 
			WHERE 
				--MOV_ANAART IN (SELECT ART_CODPRI FROM U_ART_AN WHERE ART_CODTSN IN ('ACQ','PRD')) AND 
				MOV_ANAART IN (SELECT ART_CODPRI FROM U_ART_AN WHERE ART_CODTSN IN ('ACQ','PRD','SN6')) AND -- ERASMO - 04/12/2020
				MOV_DOCMOD = 0 AND 
				MOV_SEGNO = '-' AND 
				MOV_LEGAME <> '' AND 
				TR.MOV_TRCKNG LIKE '%'+RTRIM(MOV_LEGAME)+'%'
			GROUP BY MOV_ANAART, MOV_SERIAL, MOV_LEGAME, COALESCE(TRM.MOV_TRCKNG,'')
			) AS TRE
		INNER JOIN U_ART_PR AS AT ON AT.ART_CODPRI = TRE.MOV_ANAART
		WHERE <<x_cond>>

	ENDTEXT
	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF
	
	SELECT TMP_ASSETS_LIV2
	GO TOP
	SCAN
	
		_ParentId = _SF_ASSET_PARENT_ID 
		_Name = ALLTRIM(Name)
		_SerialNumber = ALLTRIM(SerialNumber)
		_Price = Price
		_Quantity = Quantity
		_Description = ALLTRIM(Description)
		_AssetLevel = AssetLevel
		_Tipologia__c = ALLTRIM(Tipologia__c)
		_Durata_Garanzia_Standard__c = Durata_Garanzia_Standard__c
		_Data_scadenza_full_risk__c = ALLTRIM(Data_scadenza_full_risk__c)
		_Codice_Products__c = ALLTRIM(Codice_Products__c)
		**=> ERASMO - INIZIO 09/06/2021
		_Product2Id = LOOKUP_PRODOTTO(_Codice_Products__c)
		IF EMPTY(_Product2Id)
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
			IF !ExecRW(cSql,"LOG_SFSYNC","R")
			   return(.f.)
			ENDIF
			SELECT LOG_SFSYNC
			GO TOP
			IF !EOF()
				REPLACE ESITO WITH "KO"
				REPLACE MESSAGGIO WITH "Asset con Id_Asset__c " + _Id_Asset__c + " - Articolo " + _Codice_Products__c + " non trovato in tabella SFDC Product2"
				_SEC_FIN = SECONDS()
				REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
			ENDIF
			IF !ExecRW(cSql,"LOG_SFSYNC","W")
			   return(.f.)
			ENDIF
			RETURN .F.
		ENDIF
		**=> ERASMO - FINE 09/06/2021
		_Riferimento_Prodotto__c = ALLTRIM(Riferimento_Prodotto__c)
		
		*** ESCAPING CARATTERE "
		_Name = STRTRAN(_Name,'"','\"')
		_SerialNumber = STRTRAN(_SerialNumber,'"','\"')
		_Description = STRTRAN(_Description,'"','\"')
		_Tipologia__c = STRTRAN(_Tipologia__c,'"','\"')
		_Codice_Products__c = STRTRAN(_Codice_Products__c,'"','\"')
		_Riferimento_Prodotto__c = STRTRAN(_Riferimento_Prodotto__c,'"','\"')
		
*!*			**=> ERASMO - INIZIO 23/10/2023
*!*			IF EMPTY(_SerialNumber)
*!*				_RecordTypeId = "012MU0000004LPoYAM"
*!*			ELSE
*!*				_RecordTypeId = "012MU0000004LQhYAM"
*!*			ENDIF
*!*			**=> ERASMO - FINE 23/10/2023
		
		**=> ERASMO - INIZIO 12/12/2023
		IF EMPTY(_SerialNumber)
			_RecordTypeId = "01269000000xNVmAAM"
		ELSE
			_RecordTypeId = "01269000000xNVrAAM"
		ENDIF
		**=> ERASMO - FINE 12/12/2023
		
		_json_content = ""
		_OK_INS_AGG = AGGIORNA_INSERISCE_ASSET("TMP_ASSETS_LIV2")
		
		IF !_OK_INS_AGG
			*_CLIPTEXT = _json_content
			*SET STEP ON
			RETURN .F.
		ENDIF
	
	ENDSCAN
	
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale assets inseriti da Aquarius: " + ALLTRIM(STR(_CONTA_INS_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun asset inserito da Aquarius"
ENDIF
IF _CONTA_AGG_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale assets aggiornati da Aquarius: " + ALLTRIM(STR(_CONTA_AGG_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun asset aggiornato da Aquarius"
ENDIF

cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
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

_OK_SYNC_ASSETS = .T.
			
RETURN .T.


*****************************************************************************
FUNCTION AGGIORNA_INSERISCE_ASSET
*****************************************************************************
LPARAMETERS _PAR_NOMECUR


_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Codice_Products__c+FROM+Asset+WHERE+Id_Asset__c='"+_Id_Asset__c+"'+AND+SerialNumber='"+_SerialNumber+"'"

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
		_message = ALLTRIM(&_cProperty) + "(Id_Asset__c: " + _Id_Asset__c
		WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
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

SELECT TMP_SF_ASSET
ZAP

IF OBJ_JSON._totalSize = 0
	
	*** INSERIMENTO NUOVO ASSET SU SALESFORCE
	
	_json_content = '{'
	_json_content = _json_content + '"Id_Asset__c": "' + _Id_Asset__c + '"'
	_json_content = _json_content + ', "AccountId": "' + _AccountId + '"'
	_json_content = _json_content + ', "ParentId": ' + IIF(!EMPTY(_ParentId),'"'+ _ParentId + '"','null')
	_json_content = _json_content + ', "CurrencyIsoCode": "' + _CurrencyIsoCode + '"'
	_json_content = _json_content + ', "Name": "' + _Name + '"'
	_json_content = _json_content + ', "SerialNumber": "' + _SerialNumber + '"'
	_json_content = _json_content + ', "PurchaseDate": ' + IIF(!EMPTY(_PurchaseDate),'"'+ _PurchaseDate + '"','null')
	_json_content = _json_content + ', "Price": ' + STRTRAN(ALLTRIM(STR(_Price,19,PUB_DECPRZ)),',','.')	
	_json_content = _json_content + ', "Quantity": ' + STRTRAN(ALLTRIM(STR(_Quantity,19,PUB_DECQTA)),',','.')
	_json_content = _json_content + ', "Description": "' + _Description + '"'
	*_json_content = _json_content + ', "AssetLevel": ' + ALLTRIM(STR(_AssetLevel,10,0))
	_json_content = _json_content + ', "Tipologia__c": "' + _Tipologia__c + '"'
	_json_content = _json_content + ', "Data_di_collaudo__c": ' + IIF(!EMPTY(_Data_di_collaudo__c),'"'+ _Data_di_collaudo__c + '"','null')
	_json_content = _json_content + ', "Durata_Garanzia_Standard__c": ' + IIF(_Durata_Garanzia_Standard__c > 0,'"' + ALLTRIM(STR(_Durata_Garanzia_Standard__c,10,0)) + ' mesi"','null')
	*_json_content = _json_content + ', "Data_scadenza_full_risk__c": ' + IIF(!EMPTY(_Data_scadenza_full_risk__c),'"'+ _Data_scadenza_full_risk__c + '"','null')
	_json_content = _json_content + ', "Codice_Products__c": "' + _Codice_Products__c + '"'
	_json_content = _json_content + ', "Product2Id": ' + IIF(!EMPTY(_Product2Id),'"'+ _Product2Id + '"','null')	&& ERASMO - 09/06/2021
	_json_content = _json_content + ', "Riferimento_Prodotto__c": "' + _Riferimento_Prodotto__c + '"'
	_json_content = _json_content + ', "Causale_DDT__c": "' + _Causale_DDT__c + '"'	&& ERASMO - 22/05/2020
	*_json_content = _json_content + ', "Data_DDT__c": "' + _Data_DDT__c + '"'	&& ERASMO - 22/05/2020
	_json_content = _json_content + ', "Data_DDT__c": ' + IIF(!EMPTY(_Data_DDT__c),'"'+ _Data_DDT__c + '"','null')	&& ERASMO - 30/06/2024
	_json_content = _json_content + ', "Numero_DDT__c": "' + _Numero_DDT__c + '"'	&& ERASMO - 22/05/2020
	_json_content = _json_content + ', "RecordTypeId": "' + _RecordTypeId + '"'	&& ERASMO - 23/10/2023
	_json_content = _json_content + ', "DDT__c": ' + IIF(!EMPTY(_DDT__c),'"'+ _DDT__c + '"','null')  && ERASMO - 13/12/2023
	_json_content = _json_content + ', "Riga_DDT__c": ' + IIF(!EMPTY(_Riga_DDT__c),'"'+ _Riga_DDT__c + '"','null')  && ERASMO - 13/12/2023
	_json_content = _json_content + ', "Ordine__c": ' + IIF(!EMPTY(_Ordine__c),'"'+ _Ordine__c + '"','null')  && ERASMO - 04/03/2024
	*_json_content = _json_content + ', "External_ID_fattura__c": ' + IIF(!EMPTY(_External_ID_fattura__c),'"'+ _External_ID_fattura__c + '"','null')  && ERASMO - 01/06/2024
	**=> ERASMO - INIZIO 10/06/2024
	*** CAMPI CHE DEVONO ESSERE VALORIZZATI SOLO SE PIENI, IN QUANTO POTREBBERO ESSERE GESTITI DIRETTAMENTE CON DEI TRIGGER DIRETTAMENTE SU SFDC
	IF !EMPTY(_External_ID_fattura__c)
		_json_content = _json_content + ', "External_ID_fattura__c": ' + '"'+ _External_ID_fattura__c + '"'
	ENDIF
	IF !EMPTY(_Causale_fattura__c)
		_json_content = _json_content + ', "Causale_fattura__c": ' + '"'+ _Causale_fattura__c + '"'
	ENDIF
	IF !EMPTY(_Numero_fattura__c)
		_json_content = _json_content + ', "Numero_fattura__c": ' + '"'+ _Numero_fattura__c + '"'
	ENDIF
	IF !EMPTY(_Data_fattura__c)
		_json_content = _json_content + ', "Data_fattura__c": ' + '"'+ _Data_fattura__c + '"'
	ENDIF
	**=> ERASMO - FINE 10/06/2024
	_json_content = _json_content + '}'
	
	_cJson = ""
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Asset/"

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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
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
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
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
					
						_SF_ASSET_ID = _id
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
					
					cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
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

	SELECT &_PAR_NOMECUR
	RETURN .T.
ENDIF

*!*	*###################
*!*	_CONTA_AGG_DA_AQ = _CONTA_AGG_DA_AQ + 1
*!*	_LIV1_GIA_PRESENTE = .T.
*!*	SELECT &_PAR_NOMECUR
*!*	RETURN .T.
*!*	*###################

FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
	
	SELECT TMP_SF_ASSET
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
	
	SELECT TMP_SF_ASSET
	APPEND BLANK
	GATHER MEMVAR MEMO
	
NEXT

RELEASE obj_json

SELECT TMP_SF_ASSET
_SF_ASSET_ID = ID
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

SELECT TMP_SF_ASSET
ZAP
	
_json_content = '{'
_json_content = _json_content + '"AccountId": "' + _AccountId + '"'
_json_content = _json_content + ', "ParentId": ' + IIF(!EMPTY(_ParentId),'"'+ _ParentId + '"','null')
_json_content = _json_content + ', "CurrencyIsoCode": "' + _CurrencyIsoCode + '"'
_json_content = _json_content + ', "Name": "' + _Name + '"'
_json_content = _json_content + ', "SerialNumber": "' + _SerialNumber + '"'
_json_content = _json_content + ', "PurchaseDate": ' + IIF(!EMPTY(_PurchaseDate),'"'+ _PurchaseDate + '"','null')
_json_content = _json_content + ', "Price": ' + STRTRAN(ALLTRIM(STR(_Price,19,PUB_DECPRZ)),',','.')	
_json_content = _json_content + ', "Quantity": ' + STRTRAN(ALLTRIM(STR(_Quantity,19,PUB_DECQTA)),',','.')
_json_content = _json_content + ', "Description": "' + _Description + '"'
*_json_content = _json_content + ', "AssetLevel": ' + ALLTRIM(STR(_AssetLevel,10,0))
_json_content = _json_content + ', "Tipologia__c": "' + _Tipologia__c + '"'
_json_content = _json_content + ', "Data_di_collaudo__c": ' + IIF(!EMPTY(_Data_di_collaudo__c),'"'+ _Data_di_collaudo__c + '"','null')
_json_content = _json_content + ', "Durata_Garanzia_Standard__c": ' + IIF(_Durata_Garanzia_Standard__c > 0,'"' + ALLTRIM(STR(_Durata_Garanzia_Standard__c,10,0)) + ' mesi"','null')
*_json_content = _json_content + ', "Data_scadenza_full_risk__c": ' + IIF(!EMPTY(_Data_scadenza_full_risk__c),'"'+ _Data_scadenza_full_risk__c + '"','null')
_json_content = _json_content + ', "Codice_Products__c": "' + _Codice_Products__c + '"'
_json_content = _json_content + ', "Product2Id": ' + IIF(!EMPTY(_Product2Id),'"'+ _Product2Id + '"','null')	&& ERASMO - 09/06/2021
_json_content = _json_content + ', "Riferimento_Prodotto__c": "' + _Riferimento_Prodotto__c + '"'
_json_content = _json_content + ', "Causale_DDT__c": "' + _Causale_DDT__c + '"'	&& ERASMO - 22/05/2020
*_json_content = _json_content + ', "Data_DDT__c": "' + _Data_DDT__c + '"'	&& ERASMO - 22/05/2020
_json_content = _json_content + ', "Data_DDT__c": ' + IIF(!EMPTY(_Data_DDT__c),'"'+ _Data_DDT__c + '"','null')	&& ERASMO - 30/06/2024
_json_content = _json_content + ', "Numero_DDT__c": "' + _Numero_DDT__c + '"'	&& ERASMO - 22/05/2020
_json_content = _json_content + ', "RecordTypeId": "' + _RecordTypeId + '"'	&& ERASMO - 23/10/2023
_json_content = _json_content + ', "DDT__c": ' + IIF(!EMPTY(_DDT__c),'"'+ _DDT__c + '"','null')  && ERASMO - 13/12/2023
_json_content = _json_content + ', "Riga_DDT__c": ' + IIF(!EMPTY(_Riga_DDT__c),'"'+ _Riga_DDT__c + '"','null')  && ERASMO - 13/12/2023
_json_content = _json_content + ', "Ordine__c": ' + IIF(!EMPTY(_Ordine__c),'"'+ _Ordine__c + '"','null')  && ERASMO - 04/03/2024
*_json_content = _json_content + ', "External_ID_fattura__c": ' + IIF(!EMPTY(_External_ID_fattura__c),'"'+ _External_ID_fattura__c + '"','null')  && ERASMO - 01/06/2024
**=> ERASMO - INIZIO 10/06/2024
*** CAMPI CHE DEVONO ESSERE VALORIZZATI SOLO SE PIENI, IN QUANTO POTREBBERO ESSERE GESTITI DIRETTAMENTE CON DEI TRIGGER DIRETTAMENTE SU SFDC
IF !EMPTY(_External_ID_fattura__c)
	_json_content = _json_content + ', "External_ID_fattura__c": ' + '"'+ _External_ID_fattura__c + '"'
ENDIF
IF !EMPTY(_Causale_fattura__c)
	_json_content = _json_content + ', "Causale_fattura__c": ' + '"'+ _Causale_fattura__c + '"'
ENDIF
IF !EMPTY(_Numero_fattura__c)
	_json_content = _json_content + ', "Numero_fattura__c": ' + '"'+ _Numero_fattura__c + '"'
ENDIF
IF !EMPTY(_Data_fattura__c)
	_json_content = _json_content + ', "Data_fattura__c": ' + '"'+ _Data_fattura__c + '"'
ENDIF
**=> ERASMO - FINE 10/06/2024
_json_content = _json_content + '}'
	
*** AGGIORNAMENTO CAMPI SU SALESFORCE
_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Asset/"+_SF_ASSET_ID
_cJson = ""

_cJson = SALESFORCEREST_PATCH(_HTTP_request,_access_token,_json_content)
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	RETURN .F.
ENDIF

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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Asset con Id_Asset__c " + _Id_Asset__c + " - Articolo " + _ProductCode + " non trovato in tabella SFDC Product2"
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


**=> ERASMO - INIZIO 13/12/2023
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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ASSETS' AND CODSYS = '" + _LOG_CODSYS + "'"
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
**=> ERASMO - FINE 13/12/2023


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
