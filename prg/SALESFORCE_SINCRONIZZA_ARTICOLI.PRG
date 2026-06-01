
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

_MSG_WARNINGS = ""

_LOG_CODSYS = IIF(EMPTY(_par_group_codsys),SYS(2015),_par_group_codsys)
_LOG_OGGETTO = "ARTICOLI"
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

*** CONTROLLI DI LOGIN SUPERATI, PROCEDO CON LE CHIAMATE SPECIFICHE PER LA SINCRONIZZAZIONE DEGLI ARTICOLI


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

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DEGLI ARTICOLI PRESENTI SU SALESFORCE
CREATE CURSOR TMP_SF_PRODUCT2 ( ;
	Id C(254), ;
	LastModifiedDate C(254), ;
	ProductCode C(254), ;
	Description C(254), ;
	Estensione_descrizione__c C(254), ;
	IsActive C(254), ;
	Unita_di_misura_acquisto__c C(254), ;
	Unita_di_misura_vendita__c C(254), ;
	Linea__c C(254), ;
	Prezzo_listino_italia__c C(254), ;
	Prezzo_listino_international__c C(254), ;
	Prezzo_listino_3__c C(254), ;
	Prezzo_listino_4__c C(254), ;
	Prezzo_listino_5__c C(254), ;
	Prezzo_costo_standard__c C(254), ;
	Scorta_minima__c C(254), ;
	Codice_magazzino_default__c C(254), ;
	Codice_classe_doganale__c C(254), ;
	Codice_servizi_intrastat__c C(254), ;
	Peso__c C(254), ;
	Codice_fornitore_1__c C(254), ;
	Codice_fornitore_2__c C(254), ;
	Codice_fornitore_3__c C(254), ;
	Codice_fornitore_4__c C(254), ;
	Codice_fornitore_5__c C(254), ;
	Descrizione_fornitore_1__c C(254), ;
	Descrizione_fornitore_2__c C(254), ;
	Descrizione_fornitore_3__c C(254), ;
	Descrizione_fornitore_4__c C(254), ;
	Descrizione_fornitore_5__c C(254), ;
	Prezzo_fornitore_1__c C(254), ;
	Prezzo_fornitore_2__c C(254), ;
	Prezzo_fornitore_3__c C(254), ;
	Prezzo_fornitore_4__c C(254), ;
	Prezzo_fornitore_5__c C(254), ;
	Valuta_fornitore_1__c C(254), ;
	Valuta_fornitore_2__c C(254), ;
	Valuta_fornitore_3__c C(254), ;
	Valuta_fornitore_4__c C(254), ;
	Valuta_fornitore_5__c C(254), ;
	Revisione__c C(254), ;
	Cod_tipologia_fatturazione_elettronica__c C(254), ;
	Cod_valore_fatturazione_elettronica__c C(254), ;
	Categoria_merceologica__c C(254), ;
	Tipologia_articolo__c C(254), ;
	Non_movimenta_magazzino__c C(254), ;
	Lotto_minimo_di_acquisto__c C(254), ;
	Tipo_produzione__c C(254), ;
	Codice_completo_gruppo_merc_industriale__c C(254), ;
	Gruppo__c C(254), ;
	Famiglia__c C(254), ;
	Sottofamiglia__c C(254), ;
	Lead_time_standard__c C(254), ;
	Lead_time_fornitore_1__c C(254), ;
	Lead_time_fornitore_2__c C(254), ;
	Lead_time_fornitore_3__c C(254), ;
	Lead_time_fornitore_4__c C(254), ;
	Lead_time_fornitore_5__c C(254), ;
	Cod_Tipo_Serial_Number__c C(254), ;
	Cod_Modello_Dichiarazione_di_Conformit__c C(254), ;
	Obsoleto__c C(254), ;
	Svincolato_da_listino__c C(254), ;
	Codice_IVA__c C(254), ;
	CND__c C(254), ;
	UDI_DI_base__c C(254), ;
	ExternalId__c C(254))
	
*** ELABORAZIONE ARTICOLI AQUARIUS MODIFICATI RISPETTO ALL'ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE
WAIT WINDOWS "Lettura articoli Aquarius modificati rispetto all'ultima sincronizzazione..." NOWAIT

_ULT_TS_SYNC_ART = ""
cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'ARTICOLI' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
IF !ExecCommand(cSql,"ULT_TS_SYNC_ART")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_ART
GO TOP
_ULT_TS_SYNC_ART = LAST_DATE

*_ULT_TS_SYNC_ART = '1950/01/0100:00:00'  && ###TEST### TUTTI GLI ARTICOLI ###TEST###

x_cond = "PR.ART_CODPRI <> '' AND (CASE AN.MOD_DATREG WHEN '' THEN (AN.REG_DATREG+CASE AN.REG_ORAREG WHEN '' THEN '23:59:59' ELSE AN.REG_ORAREG END) ELSE AN.MOD_DATREG+CASE AN.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE AN.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_ART + "'"
cSql=""     
cNomeCursorSql="TMP_ARTICOLI"
TEXT TO cSql NOSHOW
	SELECT
		PR.ART_CODPRI,
		PR.ART_DESCR,
		PR.ART_DESEST,
		PR.ART_OBSOL,
		PR.ART_UNIMIS,
		PR.ART_UMMAGA,
		PR.ART_LINEA,
		PR.ART_PRZVEN,
		PR.ART_PRZVE2,
		PR.ART_PRZVE3,
		PR.ART_PRZVE4,
		PR.ART_PRZVE5,
		PR.ART_PRZCOS,
		PR.ART_SCORMI,
		PR.ART_MAGA,
		PR.ART_CLDOG,
		AN.ART_SERVINTRA,
		PR.ART_PESOUM,
		PR.ART_CODF1,
		PR.ART_CODF2,
		PR.ART_CODF3,
		PR.ART_CODF4,
		PR.ART_CODF5,
		COALESCE(FO1.FOR_RAGSOC,'') AS ART_DESF1,
		COALESCE(FO2.FOR_RAGSOC,'') AS ART_DESF2,
		COALESCE(FO3.FOR_RAGSOC,'') AS ART_DESF3,
		COALESCE(FO4.FOR_RAGSOC,'') AS ART_DESF4,
		COALESCE(FO5.FOR_RAGSOC,'') AS ART_DESF5,
		PR.ART_PRZCO1,
		PR.ART_PRZCO2,
		PR.ART_PRZCO3,
		PR.ART_PRZCO4,
		PR.ART_PRZCO5,
		COALESCE(FO1.FOR_VALUTA,'') AS ART_VALUTA1,
		COALESCE(FO2.FOR_VALUTA,'') AS ART_VALUTA2,
		COALESCE(FO3.FOR_VALUTA,'') AS ART_VALUTA3,
		COALESCE(FO4.FOR_VALUTA,'') AS ART_VALUTA4,
		COALESCE(FO5.FOR_VALUTA,'') AS ART_VALUTA5,
		ART_CODCTL,
		ART_SERIE,
		ART_CATBEN,
		ART_CATMER,
		ART_TIPART,
		ART_NONMOV,
		ART_LOTMIN,
		ART_TIPOPR,
		ART_CODGMI,
		COALESCE(GMI_1_3.DESCRI,'') AS ART_DESGMI_1,
		COALESCE(GMI_1_6.DESCRI,'') AS ART_DESGMI_2,
		COALESCE(GMI_1_9.DESCRI,'') AS ART_DESGMI_3,
		ART_LDTMST,
		ART_LDTM1,
		ART_LDTM2,
		ART_LDTM3,
		ART_LDTM4,
		ART_LDTM5,
		ART_CODTSN,
		ART_CODDCA,
		AN.ART_NOLISLCK,  -- ERASMO - 28/08/2024
		PR.ART_CODIVA,    -- ERASMO - 28/08/2024
		PR.ART_GRUPRD,    -- ERASMO - 11/09/2024
		PR.ART_CDISBN,    -- ERASMO - 11/09/2024
		PR.ART_BARCLI     -- ERASMO - 05/03/2025
	FROM U_ART_PR AS PR
	LEFT OUTER JOIN U_ART_AN AS AN ON AN.ART_CODPRI = PR.ART_CODPRI
	LEFT OUTER JOIN U_FOR_AN AS FO1 ON PR.ART_CODF1 = FO1.FOR_CODCLI
	LEFT OUTER JOIN U_FOR_AN AS FO2 ON PR.ART_CODF2 = FO2.FOR_CODCLI
	LEFT OUTER JOIN U_FOR_AN AS FO3 ON PR.ART_CODF3 = FO3.FOR_CODCLI
	LEFT OUTER JOIN U_FOR_AN AS FO4 ON PR.ART_CODF4 = FO4.FOR_CODCLI
	LEFT OUTER JOIN U_FOR_AN AS FO5 ON PR.ART_CODF5 = FO5.FOR_CODCLI
	LEFT OUTER JOIN PARA AS GMI_1_3 ON GMI_1_3.CODICE = 'GMI'+SUBSTRING(AN.ART_CODGMI,1,3)
	LEFT OUTER JOIN PARA AS GMI_1_6 ON GMI_1_6.CODICE = 'GMI'+SUBSTRING(AN.ART_CODGMI,1,6)
	LEFT OUTER JOIN PARA AS GMI_1_9 ON GMI_1_9.CODICE = 'GMI'+SUBSTRING(AN.ART_CODGMI,1,9)
	WHERE <<x_cond>>
	ORDER BY PR.ART_CODPRI
ENDTEXT
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT TMP_ARTICOLI
GO TOP
SCAN

*!*		IF RECNO() > 100
*!*			EXIT
*!*		ENDIF
	
	WAIT WINDOWS "Elaborazione articolo Aquarius " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	_ProductCode = ALLTRIM(ART_CODPRI)
	_ExternalId__c = ALLTRIM(ART_CODPRI)  && ERASMO - 27/01/2025
	*_Description = PARSE_STRING_XML(ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESCR,CHR(13),' '),CHR(10),''),'\','\\')))
	_Description = ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESCR,CHR(13),' '),CHR(10),''),'\','\\'))  && ERASMO - 03/01/2025
	*_Estensione_descrizione__c = PARSE_STRING_XML(ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESEST,CHR(13),' '),CHR(10),''),'\','\\')))
*!*		_Estensione_descrizione__c = ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESEST,CHR(13),' '),CHR(10),''),'\','\\'))  && ERASMO - 03/01/2025
	*_IsActive = IIF(UPPER(ALLTRIM(ART_OBSOL))=='S',"false","true")
	**=> ERASMO - INIZIO 30/01/2025
	*** DETERMINO IL VALORE DEL FLAG DI ATTIVAZIONE SULLA BASE DELLE SPECIFICHE DI VENDIBILITA', CHE ANDRA' A DISATTIVARE IL PRODOTTO SOLO IN CASO DI AGGIORNAMENTO (IN INSERT E' FALSE DI DEFAULT)
	_IsActive = ""
	_soddisfa_requisiti_vendibilita = .T.
	IF UPPER(ALLTRIM(ART_OBSOL)) == "S"
		_soddisfa_requisiti_vendibilita = .F.
	ENDIF
	IF ART_PRZVEN > 0 OR ART_NOLISLCK
	ELSE
		_soddisfa_requisiti_vendibilita = .F.
	ENDIF
	IF UPPER(ALLTRIM(ART_MAGA)) == "SEDE"
		_soddisfa_requisiti_vendibilita = .F.
	ENDIF
	IF !_soddisfa_requisiti_vendibilita
		_IsActive = "false"
	ENDIF
	**=> ERASMO - FINE 30/01/2025
	_Unita_di_misura_acquisto__c = ALLTRIM(ART_UNIMIS)
	_Unita_di_misura_vendita__c = ALLTRIM(ART_UMMAGA)
	_Linea__c = ALLTRIM(ART_LINEA)
	_Prezzo_listino_italia__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZVEN,2),16,2)),',','.')
	_Prezzo_listino_international__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZVE2,2),16,2)),',','.')
	_Prezzo_listino_3__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZVE3,2),16,2)),',','.')
	_Prezzo_listino_4__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZVE4,2),16,2)),',','.')
	_Prezzo_listino_5__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZVE5,2),16,2)),',','.')
	*_Prezzo_costo_standard__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCOS,2),16,2)),',','.')
	_Prezzo_costo_standard__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCOS,6),12,6)),',','.')  && ERASMO - 06/08/2024
	_Scorta_minima__c = STRTRAN(ALLTRIM(STR(ROUND(ART_SCORMI,2),16,2)),',','.')
	_Codice_magazzino_default__c = ALLTRIM(ART_MAGA)
	_Codice_classe_doganale__c = ALLTRIM(ART_CLDOG)
	_Codice_servizi_intrastat__c = ALLTRIM(ART_SERVINTRA)
	_Peso__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PESOUM,3),15,3)),',','.')
	_Codice_fornitore_1__c = ALLTRIM(ART_CODF1)
	_Codice_fornitore_2__c = ALLTRIM(ART_CODF2)
	_Codice_fornitore_3__c = ALLTRIM(ART_CODF3)
	_Codice_fornitore_4__c = ALLTRIM(ART_CODF4)
	_Codice_fornitore_5__c = ALLTRIM(ART_CODF5)
	*_Descrizione_fornitore_1__c = PARSE_STRING_XML(ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESF1,CHR(13),' '),CHR(10),''),'\','\\')))
	*_Descrizione_fornitore_2__c = PARSE_STRING_XML(ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESF2,CHR(13),' '),CHR(10),''),'\','\\')))
	*_Descrizione_fornitore_3__c = PARSE_STRING_XML(ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESF3,CHR(13),' '),CHR(10),''),'\','\\')))
	*_Descrizione_fornitore_4__c = PARSE_STRING_XML(ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESF4,CHR(13),' '),CHR(10),''),'\','\\')))
	*_Descrizione_fornitore_5__c = PARSE_STRING_XML(ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESF5,CHR(13),' '),CHR(10),''),'\','\\')))
	**=> ERASMO - INIZIO 03/01/2025
	_Descrizione_fornitore_1__c = ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESF1,CHR(13),' '),CHR(10),''),'\','\\'))
	_Descrizione_fornitore_2__c = ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESF2,CHR(13),' '),CHR(10),''),'\','\\'))
	_Descrizione_fornitore_3__c = ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESF3,CHR(13),' '),CHR(10),''),'\','\\'))
	_Descrizione_fornitore_4__c = ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESF4,CHR(13),' '),CHR(10),''),'\','\\'))
	_Descrizione_fornitore_5__c = ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESF5,CHR(13),' '),CHR(10),''),'\','\\'))
	**=> ERASMO - FINE 03/01/2025
	*_Prezzo_fornitore_1__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCO1,2),16,2)),',','.')
	*_Prezzo_fornitore_2__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCO2,2),16,2)),',','.')
	*_Prezzo_fornitore_3__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCO3,2),16,2)),',','.')
	*_Prezzo_fornitore_4__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCO4,2),16,2)),',','.')
	*_Prezzo_fornitore_5__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCO5,2),16,2)),',','.')
	_Prezzo_fornitore_1__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCO1,6),12,6)),',','.')  && ERASMO - 28/08/2024
	_Prezzo_fornitore_2__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCO2,6),12,6)),',','.')  && ERASMO - 28/08/2024
	_Prezzo_fornitore_3__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCO3,6),12,6)),',','.')  && ERASMO - 28/08/2024
	_Prezzo_fornitore_4__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCO4,6),12,6)),',','.')  && ERASMO - 28/08/2024
	_Prezzo_fornitore_5__c = STRTRAN(ALLTRIM(STR(ROUND(ART_PRZCO5,6),12,6)),',','.')  && ERASMO - 28/08/2024
	_Valuta_fornitore_1__c = ALLTRIM(ART_VALUTA1)
	_Valuta_fornitore_2__c = ALLTRIM(ART_VALUTA2)
	_Valuta_fornitore_3__c = ALLTRIM(ART_VALUTA3)
	_Valuta_fornitore_4__c = ALLTRIM(ART_VALUTA4)
	_Valuta_fornitore_5__c = ALLTRIM(ART_VALUTA5)
	_Revisione__c = ALLTRIM(ART_CODCTL)
	_Cod_tipologia_fatturazione_elettronica__c = ALLTRIM(ART_SERIE)
	_Cod_valore_fatturazione_elettronica__c = ALLTRIM(ART_CATBEN)
	_Categoria_merceologica__c = ALLTRIM(ART_CATMER)
	_Tipologia_articolo__c = ALLTRIM(ART_TIPART)
	_Non_movimenta_magazzino__c = IIF(ART_NONMOV,"true","false")
	_Lotto_minimo_di_acquisto__c = STRTRAN(ALLTRIM(STR(ROUND(ART_LOTMIN,0),18,0)),',','.')
	_Tipo_produzione__c = ALLTRIM(ART_TIPOPR)
	_Codice_completo_gruppo_merc_industriale__c = ALLTRIM(ART_CODGMI)
	*_Gruppo__c = PARSE_STRING_XML(ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESGMI_1,CHR(13),' '),CHR(10),''),'\','\\')))
	*_Famiglia__c = PARSE_STRING_XML(ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESGMI_2,CHR(13),' '),CHR(10),''),'\','\\')))
	*_Sottofamiglia__c = PARSE_STRING_XML(ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESGMI_3,CHR(13),' '),CHR(10),''),'\','\\')))
	**=> ERASMO - INIZIO 03/01/2025
	_Gruppo__c = ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESGMI_1,CHR(13),' '),CHR(10),''),'\','\\'))
	_Famiglia__c = ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESGMI_2,CHR(13),' '),CHR(10),''),'\','\\'))
	_Sottofamiglia__c = ALLTRIM(STRTRAN(STRTRAN(STRTRAN(ART_DESGMI_3,CHR(13),' '),CHR(10),''),'\','\\'))
	**=> ERASMO - FINE 03/01/2025
	_Lead_time_standard__c = STRTRAN(ALLTRIM(STR(ROUND(ART_LDTMST,0),3,0)),',','.')
	_Lead_time_fornitore_1__c = STRTRAN(ALLTRIM(STR(ROUND(ART_LDTM1,0),3,0)),',','.')
	_Lead_time_fornitore_2__c = STRTRAN(ALLTRIM(STR(ROUND(ART_LDTM2,0),3,0)),',','.')
	_Lead_time_fornitore_3__c = STRTRAN(ALLTRIM(STR(ROUND(ART_LDTM3,0),3,0)),',','.')
	_Lead_time_fornitore_4__c = STRTRAN(ALLTRIM(STR(ROUND(ART_LDTM4,0),3,0)),',','.')
	_Lead_time_fornitore_5__c = STRTRAN(ALLTRIM(STR(ROUND(ART_LDTM5,0),3,0)),',','.')
	_Cod_Tipo_Serial_Number__c = ALLTRIM(ART_CODTSN)
	_Cod_Modello_Dichiarazione_di_Conformit__c = ALLTRIM(ART_CODDCA)
	**=> ERASMO - INIZIO 28/08/2024
	_Obsoleto__c = IIF(UPPER(ALLTRIM(ART_OBSOL))=='S',"false","true")
	_Svincolato_da_listino__c = IIF(ART_NOLISLCK,"true","false")
	_Codice_IVA__c = LOOKUP_IVA(ALLTRIM(ART_CODIVA))
	IF EMPTY(_Codice_IVA__c)
		RETURN .F.
	ENDIF
	**=> ERASMO - FINE 28/08/2024
*!*		**=> ERASMO - INIZIO 11/09/2024
*!*		_CND__c	= ALLTRIM(ART_GRUPRD)
*!*		_UDI_DI_base__c	= ALLTRIM(ART_CDISBN)
*!*		**=> ERASMO - FINE 11/09/2024

	_UDI_DI_base__c	= ALLTRIM(ART_BARCLI)  && ERASMO - 05/03/2025

	**=> ERASMO - INIZIO 08/01/2024
	*** PULIZIA CARATTERE CR E LF
	_Description = STRTRAN(STRTRAN(_Description,CHR(13),' '),CHR(10),'')
	
	*** ESCAPING CARATTERE \
	_Description = STRTRAN(_Description,'\','\\')
	_ProductCode = STRTRAN(_ProductCode,'\','\\')  && ERASMO - 30/01/2025
		
	*** ESCAPING CARATTERE "
	_Description = STRTRAN(_Description,'"','\"')
	_ProductCode = STRTRAN(_ProductCode,'"','\"')  && ERASMO - 30/01/2025
	
	*** ESCAPING CARATTERE /
	_Description = STRTRAN(_Description,'/','\/')
	*_ProductCode = STRTRAN(_ProductCode,'/','\/')  && ERASMO - 30/01/2025 - ASTERISCATO DA ERASMO - 18/02/2025 PER ERRORE RESTITUITO IN WHERE CONDITION
	**=> ERASMO - FINE 08/01/2024
	
	_ProductCode_where_cond = STRTRAN(_ProductCode,'+','%2B')  && ERASMO - 30/01/2025 - FIX SU PROBLEMA CARATTERE '+'
	
	*_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Description+FROM+Product2+WHERE+ProductCode='"+_ProductCode+"'"
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Description+FROM+Product2+WHERE+ProductCode='"+_ProductCode_where_cond+"'+ORDER+BY+CreatedDate"  && ERASMO - 30/01/2025

	_cJson = ""

	*WAIT WINDOWS "Connessione a '"+_instance_url+"' in corso..." NOWAIT

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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ARTICOLI' AND CODSYS = '" + _LOG_CODSYS + "'"
			IF !ExecRW(cSql,"LOG_SFSYNC","R")
			   return(.f.)
			ENDIF
			SELECT LOG_SFSYNC
			GO TOP
			IF !EOF()
				REPLACE ESITO WITH "KO"
				REPLACE MESSAGGIO WITH "Articolo " + _ProductCode + " (" + _Description + ") - " + _message
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
	
	SELECT TMP_SF_PRODUCT2
	ZAP
	
	IF OBJ_JSON._totalSize = 0
		
		*** INSERIMENTO NUOVO ARTICOLO SU SALESFORCE
		
		_json_content = '{'
		_json_content = _json_content + '"Name": "' + _ProductCode + '"'
		_json_content = _json_content + ', "ProductCode": "' + _ProductCode + '"'
		_json_content = _json_content + ', "Description": "' + _Description + '"'
*!*			_json_content = _json_content + ', "Estensione_descrizione__c": "' + _Estensione_descrizione__c + '"'
		*_json_content = _json_content + ', "IsActive": ' + _IsActive
		_json_content = _json_content + ', "IsActive": false'  && ERASMO - 28/08/2024
		_json_content = _json_content + ', "Unita_di_misura_acquisto__c": "' + _Unita_di_misura_acquisto__c + '"'
		_json_content = _json_content + ', "Unita_di_misura_vendita__c": "' + _Unita_di_misura_vendita__c + '"'
		_json_content = _json_content + ', "Linea__c": "' + _Linea__c + '"'
		_json_content = _json_content + ', "Prezzo_listino_italia__c": ' + _Prezzo_listino_italia__c
		_json_content = _json_content + ', "Prezzo_listino_international__c": ' + _Prezzo_listino_international__c
		*_json_content = _json_content + ', "Prezzo_listino_3__c": ' + _Prezzo_listino_3__c
		*_json_content = _json_content + ', "Prezzo_listino_4__c": ' + _Prezzo_listino_4__c
		*_json_content = _json_content + ', "Prezzo_listino_5__c": ' + _Prezzo_listino_5__c
		_json_content = _json_content + ', "Prezzo_costo_standard__c": ' + _Prezzo_costo_standard__c
		_json_content = _json_content + ', "Scorta_minima__c": ' + _Scorta_minima__c
		_json_content = _json_content + ', "Codice_magazzino_default__c": "' + _Codice_magazzino_default__c + '"'
		_json_content = _json_content + ', "Codice_classe_doganale__c": "' + _Codice_classe_doganale__c + '"'
		_json_content = _json_content + ', "Codice_servizi_intrastat__c": "' + _Codice_servizi_intrastat__c + '"'
		_json_content = _json_content + ', "Peso__c": ' + _Peso__c
		_json_content = _json_content + ', "Codice_fornitore_1__c": "' + _Codice_fornitore_1__c + '"'
		_json_content = _json_content + ', "Codice_fornitore_2__c": "' + _Codice_fornitore_2__c + '"'
		_json_content = _json_content + ', "Codice_fornitore_3__c": "' + _Codice_fornitore_3__c + '"'
		_json_content = _json_content + ', "Codice_fornitore_4__c": "' + _Codice_fornitore_4__c + '"'
		_json_content = _json_content + ', "Codice_fornitore_5__c": "' + _Codice_fornitore_5__c + '"'
		_json_content = _json_content + ', "Descrizione_fornitore_1__c": "' + _Descrizione_fornitore_1__c + '"'
		_json_content = _json_content + ', "Descrizione_fornitore_2__c": "' + _Descrizione_fornitore_2__c + '"'
		_json_content = _json_content + ', "Descrizione_fornitore_3__c": "' + _Descrizione_fornitore_3__c + '"'
		_json_content = _json_content + ', "Descrizione_fornitore_4__c": "' + _Descrizione_fornitore_4__c + '"'
		_json_content = _json_content + ', "Descrizione_fornitore_5__c": "' + _Descrizione_fornitore_5__c + '"'
		_json_content = _json_content + ', "Prezzo_fornitore_1__c": ' + _Prezzo_fornitore_1__c
		_json_content = _json_content + ', "Prezzo_fornitore_2__c": ' + _Prezzo_fornitore_2__c
		_json_content = _json_content + ', "Prezzo_fornitore_3__c": ' + _Prezzo_fornitore_3__c
		_json_content = _json_content + ', "Prezzo_fornitore_4__c": ' + _Prezzo_fornitore_4__c
		_json_content = _json_content + ', "Prezzo_fornitore_5__c": ' + _Prezzo_fornitore_5__c
		_json_content = _json_content + ', "Valuta_fornitore_1__c": "' + _Valuta_fornitore_1__c + '"'
		_json_content = _json_content + ', "Valuta_fornitore_2__c": "' + _Valuta_fornitore_2__c + '"'
		_json_content = _json_content + ', "Valuta_fornitore_3__c": "' + _Valuta_fornitore_3__c + '"'
		_json_content = _json_content + ', "Valuta_fornitore_4__c": "' + _Valuta_fornitore_4__c + '"'
		_json_content = _json_content + ', "Valuta_fornitore_5__c": "' + _Valuta_fornitore_5__c + '"'
		_json_content = _json_content + ', "Revisione__c": "' + _Revisione__c + '"'
		_json_content = _json_content + ', "Cod_tipologia_fatturazione_elettronica__c": "' + _Cod_tipologia_fatturazione_elettronica__c + '"'
		_json_content = _json_content + ', "Cod_valore_fatturazione_elettronica__c": "' + _Cod_valore_fatturazione_elettronica__c + '"'
		_json_content = _json_content + ', "Categoria_merceologica__c": "' + _Categoria_merceologica__c + '"'
		_json_content = _json_content + ', "Tipologia_articolo__c": "' + _Tipologia_articolo__c + '"'
		_json_content = _json_content + ', "Non_movimenta_magazzino__c": ' + _Non_movimenta_magazzino__c
		_json_content = _json_content + ', "Lotto_minimo_di_acquisto__c": ' + _Lotto_minimo_di_acquisto__c
		_json_content = _json_content + ', "Tipo_produzione__c": "' + _Tipo_produzione__c + '"'
		_json_content = _json_content + ', "Codice_completo_gruppo_merc_industriale__c": "' + _Codice_completo_gruppo_merc_industriale__c + '"'
		_json_content = _json_content + ', "Gruppo__c": "' + _Gruppo__c + '"'
		_json_content = _json_content + ', "Famiglia__c": "' + _Famiglia__c + '"'
		_json_content = _json_content + ', "Sottofamiglia__c": "' + _Sottofamiglia__c + '"'
		_json_content = _json_content + ', "Lead_time_standard__c": "' + _Lead_time_standard__c + '"'
		_json_content = _json_content + ', "Lead_time_fornitore_1__c": "' + _Lead_time_fornitore_1__c + '"'
		_json_content = _json_content + ', "Lead_time_fornitore_2__c": "' + _Lead_time_fornitore_2__c + '"'
		_json_content = _json_content + ', "Lead_time_fornitore_3__c": "' + _Lead_time_fornitore_3__c + '"'
		_json_content = _json_content + ', "Lead_time_fornitore_4__c": "' + _Lead_time_fornitore_4__c + '"'
		_json_content = _json_content + ', "Lead_time_fornitore_5__c": "' + _Lead_time_fornitore_5__c + '"'
		_json_content = _json_content + ', "Cod_Tipo_Serial_Number__c": "' + _Cod_Tipo_Serial_Number__c + '"'
		_json_content = _json_content + ', "Cod_Modello_Dichiarazione_di_Conformit__c": "' + _Cod_Modello_Dichiarazione_di_Conformit__c + '"'
		_json_content = _json_content + ', "Obsoleto__c": "' + _Obsoleto__c + '"'  && ERASMO - 28/08/2024
		_json_content = _json_content + ', "Svincolato_da_listino__c": ' + _Svincolato_da_listino__c  && ERASMO - 28/08/2024
		_json_content = _json_content + ', "Codice_IVA__c": "' + _Codice_IVA__c + '"'  && ERASMO - 28/08/2024	
		_json_content = _json_content + ', "Svincolato_da_listino__c": "' + _Svincolato_da_listino__c + '"'  && ERASMO - 28/08/2024
		_json_content = _json_content + ', "Codice_IVA__c": "' + _Codice_IVA__c + '"'  && ERASMO - 28/08/2024	
		_json_content = _json_content + ', "Svincolato_da_listino__c": ' + _Svincolato_da_listino__c  && ERASMO - 28/08/2024
		_json_content = _json_content + ', "Codice_IVA__c": "' + _Codice_IVA__c + '"'  && ERASMO - 28/08/2024		
*!*			_json_content = _json_content + ', "CND__c": "' + _CND__c + '"'  && ERASMO - 11/09/2024
*!*			_json_content = _json_content + ', "UDI_DI_base__c": "' + _UDI_DI_base__c + '"'  && ERASMO - 11/09/2024
		_json_content = _json_content + ', "UDI_DI_base__c": "' + _UDI_DI_base__c + '"'  && ERASMO - 05/03/2025
		_json_content = _json_content + ', "ExternalId__c": "' + _ExternalId__c + '"'  && ERASMO - 27/01/2025
		_json_content = _json_content + '}'
		
		_cJson = ""
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Product2/"

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
				
					WAIT WINDOWS SUBSTR("Errorcode: "+_errorcode+" - Articolo Aquarius " + _ProductCode + " (" + _Description + "), pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
					_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
						"Warning: "+_errorcode+" - Articolo Aquarius " + _ProductCode + " (" + _Description + "), pertanto non verrà considerato in questa elaborazione"
					SELECT TMP_ARTICOLI
					LOOP
			
				ENDIF
			ENDIF
			
			_cProperty = "OBJ_JSON.Array(1)._message"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_message = ALLTRIM(&_cProperty)
				
				WAIT WINDOWS SUBSTR("Risposta da '"+_HTTP_request+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ARTICOLI' AND CODSYS = '" + _LOG_CODSYS + "'"
				IF !ExecRW(cSql,"LOG_SFSYNC","R")
				   return(.f.)
				ENDIF
				SELECT LOG_SFSYNC
				GO TOP
				IF !EOF()
					REPLACE ESITO WITH "KO"
					REPLACE MESSAGGIO WITH "Articolo " + _ProductCode + " (" + _Description + ") - " + _message
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
							
							cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ARTICOLI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
						
							_SF_PRODUCT2_ID = _id
							*_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
							
							cSql = "SELECT * FROM U_ART_AN WHERE ART_CODPRI = '" + _ProductCode + "'"
							IF !ExecRW(cSql,"U_ART_AN","R")
								return(.f.)
							ENDIF
							SELECT U_ART_AN
							GO TOP
							IF !EOF()
								REPLACE SF_PRODUCT2_ID WITH _SF_PRODUCT2_ID
								*REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
							ENDIF
							IF !ExecRW(cSql,"U_ART_AN","W")
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
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ARTICOLI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
		SELECT TMP_ARTICOLI
		LOOP
	ENDIF

	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_PRODUCT2
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
		
		SELECT TMP_SF_PRODUCT2
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_PRODUCT2
	GO TOP  && ERASMO - 30/01/2025
	_SF_PRODUCT2_ID = ID
	_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
	
	cSql = "SELECT * FROM U_ART_AN WHERE ART_CODPRI = '" + _ProductCode + "'"
	IF !ExecRW(cSql,"U_ART_AN","R")
		return(.f.)
	ENDIF
	SELECT U_ART_AN
	GO TOP
	IF !EOF()
		REPLACE SF_PRODUCT2_ID WITH _SF_PRODUCT2_ID
		REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
	ENDIF
	IF !ExecRW(cSql,"U_ART_AN","W")
		return(.f.)
	ENDIF

	SELECT TMP_SF_PRODUCT2
	ZAP

	_json_content = '{'
	_json_content = _json_content + '"ProductCode": "' + _ProductCode + '"'
	_json_content = _json_content + ', "Description": "' + _Description + '"'
*!*		_json_content = _json_content + ', "Estensione_descrizione__c": "' + _Estensione_descrizione__c + '"'
	*_json_content = _json_content + ', "IsActive": ' + _IsActive
	_json_content = _json_content + IIF(_IsActive = "false", ', "IsActive": ' + _IsActive, "")  && ERASMO - 28/08/2024 (passato solo se FALSE)
	_json_content = _json_content + ', "Unita_di_misura_acquisto__c": "' + _Unita_di_misura_acquisto__c + '"'
	_json_content = _json_content + ', "Unita_di_misura_vendita__c": "' + _Unita_di_misura_vendita__c + '"'
	_json_content = _json_content + ', "Linea__c": "' + _Linea__c + '"'
	_json_content = _json_content + ', "Prezzo_listino_italia__c": ' + _Prezzo_listino_italia__c
	_json_content = _json_content + ', "Prezzo_listino_international__c": ' + _Prezzo_listino_international__c
	*_json_content = _json_content + ', "Prezzo_listino_3__c": ' + _Prezzo_listino_3__c
	*_json_content = _json_content + ', "Prezzo_listino_4__c": ' + _Prezzo_listino_4__c
	*_json_content = _json_content + ', "Prezzo_listino_5__c": ' + _Prezzo_listino_5__c
	_json_content = _json_content + ', "Prezzo_costo_standard__c": ' + _Prezzo_costo_standard__c
	_json_content = _json_content + ', "Scorta_minima__c": ' + _Scorta_minima__c
	_json_content = _json_content + ', "Codice_magazzino_default__c": "' + _Codice_magazzino_default__c + '"'
	_json_content = _json_content + ', "Codice_classe_doganale__c": "' + _Codice_classe_doganale__c + '"'
	_json_content = _json_content + ', "Codice_servizi_intrastat__c": "' + _Codice_servizi_intrastat__c + '"'
	_json_content = _json_content + ', "Peso__c": ' + _Peso__c
	_json_content = _json_content + ', "Codice_fornitore_1__c": "' + _Codice_fornitore_1__c + '"'
	_json_content = _json_content + ', "Codice_fornitore_2__c": "' + _Codice_fornitore_2__c + '"'
	_json_content = _json_content + ', "Codice_fornitore_3__c": "' + _Codice_fornitore_3__c + '"'
	_json_content = _json_content + ', "Codice_fornitore_4__c": "' + _Codice_fornitore_4__c + '"'
	_json_content = _json_content + ', "Codice_fornitore_5__c": "' + _Codice_fornitore_5__c + '"'
	_json_content = _json_content + ', "Descrizione_fornitore_1__c": "' + _Descrizione_fornitore_1__c + '"'
	_json_content = _json_content + ', "Descrizione_fornitore_2__c": "' + _Descrizione_fornitore_2__c + '"'
	_json_content = _json_content + ', "Descrizione_fornitore_3__c": "' + _Descrizione_fornitore_3__c + '"'
	_json_content = _json_content + ', "Descrizione_fornitore_4__c": "' + _Descrizione_fornitore_4__c + '"'
	_json_content = _json_content + ', "Descrizione_fornitore_5__c": "' + _Descrizione_fornitore_5__c + '"'
	_json_content = _json_content + ', "Prezzo_fornitore_1__c": ' + _Prezzo_fornitore_1__c
	_json_content = _json_content + ', "Prezzo_fornitore_2__c": ' + _Prezzo_fornitore_2__c
	_json_content = _json_content + ', "Prezzo_fornitore_3__c": ' + _Prezzo_fornitore_3__c
	_json_content = _json_content + ', "Prezzo_fornitore_4__c": ' + _Prezzo_fornitore_4__c
	_json_content = _json_content + ', "Prezzo_fornitore_5__c": ' + _Prezzo_fornitore_5__c
	_json_content = _json_content + ', "Valuta_fornitore_1__c": "' + _Valuta_fornitore_1__c + '"'
	_json_content = _json_content + ', "Valuta_fornitore_2__c": "' + _Valuta_fornitore_2__c + '"'
	_json_content = _json_content + ', "Valuta_fornitore_3__c": "' + _Valuta_fornitore_3__c + '"'
	_json_content = _json_content + ', "Valuta_fornitore_4__c": "' + _Valuta_fornitore_4__c + '"'
	_json_content = _json_content + ', "Valuta_fornitore_5__c": "' + _Valuta_fornitore_5__c + '"'
	_json_content = _json_content + ', "Revisione__c": "' + _Revisione__c + '"'
	_json_content = _json_content + ', "Cod_tipologia_fatturazione_elettronica__c": "' + _Cod_tipologia_fatturazione_elettronica__c + '"'
	_json_content = _json_content + ', "Cod_valore_fatturazione_elettronica__c": "' + _Cod_valore_fatturazione_elettronica__c + '"'
	_json_content = _json_content + ', "Categoria_merceologica__c": "' + _Categoria_merceologica__c + '"'
	_json_content = _json_content + ', "Tipologia_articolo__c": "' + _Tipologia_articolo__c + '"'
	_json_content = _json_content + ', "Non_movimenta_magazzino__c": ' + _Non_movimenta_magazzino__c
	_json_content = _json_content + ', "Lotto_minimo_di_acquisto__c": ' + _Lotto_minimo_di_acquisto__c
	_json_content = _json_content + ', "Tipo_produzione__c": "' + _Tipo_produzione__c + '"'
	_json_content = _json_content + ', "Codice_completo_gruppo_merc_industriale__c": "' + _Codice_completo_gruppo_merc_industriale__c + '"'
	_json_content = _json_content + ', "Gruppo__c": "' + _Gruppo__c + '"'
	_json_content = _json_content + ', "Famiglia__c": "' + _Famiglia__c + '"'
	_json_content = _json_content + ', "Sottofamiglia__c": "' + _Sottofamiglia__c + '"'
	_json_content = _json_content + ', "Lead_time_standard__c": "' + _Lead_time_standard__c + '"'
	_json_content = _json_content + ', "Lead_time_fornitore_1__c": "' + _Lead_time_fornitore_1__c + '"'
	_json_content = _json_content + ', "Lead_time_fornitore_2__c": "' + _Lead_time_fornitore_2__c + '"'
	_json_content = _json_content + ', "Lead_time_fornitore_3__c": "' + _Lead_time_fornitore_3__c + '"'
	_json_content = _json_content + ', "Lead_time_fornitore_4__c": "' + _Lead_time_fornitore_4__c + '"'
	_json_content = _json_content + ', "Lead_time_fornitore_5__c": "' + _Lead_time_fornitore_5__c + '"'
	_json_content = _json_content + ', "Cod_Tipo_Serial_Number__c": "' + _Cod_Tipo_Serial_Number__c + '"'
	_json_content = _json_content + ', "Cod_Modello_Dichiarazione_di_Conformit__c": "' + _Cod_Modello_Dichiarazione_di_Conformit__c + '"'
	_json_content = _json_content + ', "Obsoleto__c": "' + _Obsoleto__c + '"'  && ERASMO - 28/08/2024
	_json_content = _json_content + ', "Svincolato_da_listino__c": ' + _Svincolato_da_listino__c  && ERASMO - 28/08/2024
	_json_content = _json_content + ', "Codice_IVA__c": "' + _Codice_IVA__c + '"'  && ERASMO - 28/08/2024	
*!*		_json_content = _json_content + ', "CND__c": "' + _CND__c + '"'  && ERASMO - 11/09/2024
*!*		_json_content = _json_content + ', "UDI_DI_base__c": "' + _UDI_DI_base__c + '"'   && ERASMO - 11/09/2024
	_json_content = _json_content + ', "UDI_DI_base__c": "' + _UDI_DI_base__c + '"'  && ERASMO - 05/03/2025
	_json_content = _json_content + ', "ExternalId__c": "' + _ExternalId__c + '"'  && ERASMO - 27/01/2025
	_json_content = _json_content + '}'
	
	*** AGGIORNAMENTO CAMPI SU SALESFORCE
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Product2/"+_SF_PRODUCT2_ID
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
					
						WAIT WINDOWS SUBSTR("Errorcode: "+_errorcode+" - Articolo Aquarius " + _ProductCode + " (" + _Description + "), pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
						_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
							"Warning: "+_errorcode+" - Articolo Aquarius " + _ProductCode + " (" + _Description + "), pertanto non verrà considerato in questa elaborazione"
						SELECT TMP_ARTICOLI
						LOOP
				
					ENDIF
				ENDIF
			
				_message = ALLTRIM(&_cProperty)
				WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ARTICOLI' AND CODSYS = '" + _LOG_CODSYS + "'"
				IF !ExecRW(cSql,"LOG_SFSYNC","R")
				   return(.f.)
				ENDIF
				SELECT LOG_SFSYNC
				GO TOP
				IF !EOF()
					REPLACE ESITO WITH "KO"
					REPLACE MESSAGGIO WITH "Articolo " + _ProductCode + " (" + _Description + ") - " + _message
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ARTICOLI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale articoli inseriti da Aquarius: " + ALLTRIM(STR(_CONTA_INS_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun articolo inserito da Aquarius"
ENDIF
IF _CONTA_AGG_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale articoli aggiornati da Aquarius: " + ALLTRIM(STR(_CONTA_AGG_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun articolo aggiornato da Aquarius"
ENDIF

cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ARTICOLI' AND CODSYS = '" + _LOG_CODSYS + "'"
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

_OK_SYNC_ARTICOLI = .T.
			
RETURN .T.


**********************************************************************
FUNCTION LOOKUP_IVA
**********************************************************************
LPARAMETERS _par_codiva

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 06/02/2025

_RIT = ""

_CodiceIva = ALLTRIM(_par_codiva)
_CodiceIva = STRTRAN(_CodiceIva,"+","%2B")

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Codice__c,Name+FROM+Codice_IVA__c+WHERE+Codice__c='"+_CodiceIva+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'ARTICOLI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Articolo " + _ProductCode + " (" + _Description + ") - " + _message
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