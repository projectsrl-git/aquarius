
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
	*MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'SalesForce REST API Authentication'",16,"Attenzione")
	WAIT WINDOWS "Configurare correttamente tutti i parametri di sistema nella sezione 'SalesForce REST API Authentication'" TIMEOUT 3
	RETURN .F.
ENDIF

_CONTA_INS_DA_AQ = 0
_CONTA_AGG_DA_AQ = 0
_CONTA_INS_DA_SF = 0
_CONTA_AGG_DA_SF = 0

_MSG_WARNINGS = ""

_LOG_CODSYS = IIF(EMPTY(_par_group_codsys),SYS(2015),_par_group_codsys)
_LOG_OGGETTO = "CLIENTI"
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

*** CONTROLLI DI LOGIN SUPERATI, PROCEDO CON LE CHIAMATE SPECIFICHE PER LA SINCRONIZZAZIONE DEI CLIENTI


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

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DEI CLIENTI PRESENTI SU SALESFORCE
CREATE CURSOR TMP_SF_ACCOUNT ( ;
	AccountSource C(254), ;
	Attrezzature_Competitor__c C(254), ;
	Attrezzature_Competitor_Pieno__c C(254), ;
	BillingCity C(254), ;
	BillingCountry C(254), ;
	BillingCountryCode C(254), ;
	BillingGeocodeAccuracy C(254), ;
	BillingLatitude C(254), ;
	BillingLongitude C(254), ;
	BillingPostalCode C(254), ;
	BillingState C(254), ;
	BillingStateCode C(254), ;
	BillingStreet C(254), ;
	Budget_potenziale_fatturato__c C(254), ;
	Canale_di_vendita__c C(254), ;
	Centro_di_costo__c C(254), ;
	Classe_Cliente__c C(254), ;
	Classe_Merceologica__c C(254), ;
	Cli_locali__c C(254), ;
	Cliente_Inadempiente__c C(254), ;
	Codice_Cliente__c C(254), ;
	Codice_Completo_Classe_di_vendita__c C(254), ;
	Codice_Fiscale__c C(254), ;
	Codice_Nazione__c C(254), ;
	Codice_Zona__c C(254), ;
	Condizioni_di_Pagamento__c C(254), ;
	Contratto__c C(254), ;
	CreatedById C(254), ;
	CreatedDate C(254), ;
	CurrencyIsoCode C(254), ;
	Data_Blocco_Fornitura__c C(254), ;
	Description C(254), ;
	Descrizione_Attrezzature__c C(254), ;
	Dettagli_partnership__c C(254), ;
	Dettagli_partnership_Pieno__c C(254), ;
	Distributore_di_riferimento__c C(254), ;
	Fax C(254), ;
	Fine_Partnership__c C(254), ;
	Gestore__c C(254), ;
	Gi_Cliente__c C(254), ;
	Id C(254), ;
	Industry C(254), ;
	Inizio_Partnership__c C(254), ;
	Interesse_dichiarato_Valutato__c C(254), ;
	IsDeleted C(254), ;
	IVA_CEE_EXTRA_CEE__c C(254), ;
	Jigsaw C(254), ;
	JigsawCompanyId C(254), ;
	LastActivityDate C(254), ;
	LastModifiedById C(254), ;
	LastModifiedDate C(254), ;
	LastReferencedDate C(254), ;
	LastViewedDate C(254), ;
	MacroClasseClienteFromLead__c C(254), ;
	MasterRecordId C(254), ;
	Name C(254), ;
	Nome_centro_servizi__c C(254), ;
	NumberOfEmployees C(254), ;
	OwnerId C(254), ;
	ParentId C(254), ;
	Partita_Iva__c C(254), ;
	Partnership__c C(254), ;
	Percentuale_di_completamento__c C(254), ;
	Phone C(254), ;
	PhotoUrl C(254), ;
	Possibili_Relazioni__c C(254), ;
	Possibili_Relazioni_Pieno__c C(254), ;
	Programma__c C(254), ;
	RecordTypeId C(254), ;
	Refertatore__c C(254), ;
	Scenario_Utilizzo_Attrezzature__c C(254), ;
	Scenario_Utilizzo_Attrezzature_Pieno__c C(254), ;
	Scontistica_Cliente__c C(254), ;
	ShippingCity C(254), ;
	ShippingCountry C(254), ;
	ShippingCountryCode C(254), ;
	ShippingGeocodeAccuracy C(254), ;
	ShippingLatitude C(254), ;
	ShippingLongitude C(254), ;
	ShippingPostalCode C(254), ;
	ShippingState C(254), ;
	ShippingStateCode C(254), ;
	ShippingStreet C(254), ;
	SicDesc C(254), ;
	SystemModstamp C(254), ;
	Tipo_di_fatturazione__c C(254), ;
	Tipologia_di_servizi_Post_vendita__c C(254), ;
	Type C(254), ;
	Username_gestore_Cardioline__c C(254), ;
	Votazione_Account__c C(254), ;
	Website C(254), ;
	Macro_Classe_Cliente__c C(254), ;
	Email__c C(254), ;
	Annullata__c c(254), ;
	Codice_SDI__c c(254), ;
	Pubblica_amministrazione__c c(254), ;
	Macrogruppo__c c(254), ;
	SYS_Centro_di_costo_Owner__c c(254), ;
	NSO__c c(254), ;
	Zona_Fatturazione__c C(254), ;
	Codice_Iva__c C(254), ;
	PEC__c C(254), ;
	Banca_del_fornitore__c C(254), ;
	Codice_IVA_lookup__c C(254), ;
	Condizioni_di_pagamento_pick__c C(254), ;
	Porto__c C(254), ;
	Mezzo__c C(254))
	
	
*** ELABORAZIONE CLIENTI AQUARIUS MODIFICATI RISPETTO ALL'ULTIMA SINCRONIZZAZIONE ANDATA A BUON FINE
WAIT WINDOWS "Lettura clienti Aquarius modificati rispetto all'ultima sincronizzazione..." NOWAIT

_ULT_TS_SYNC_CLI = ""
cSql   = "SELECT TOP 1 LAST_DATE FROM (SELECT DATA+ORA AS LAST_DATE FROM LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND ESITO = 'OK' UNION SELECT '1950/01/0100:00:00' AS LAST_DATE) AS T ORDER BY LAST_DATE DESC"
IF !ExecCommand(cSql,"ULT_TS_SYNC_CLI")
	return(.f.)
ENDIF
SELECT ULT_TS_SYNC_CLI
GO TOP
_ULT_TS_SYNC_CLI = LAST_DATE

*_ULT_TS_SYNC_CLI = '1950/01/0100:00:00'  && ###TEST### TUTTI I CLIENTI ###TEST###

x_cond = "AN.CLI_CODCLI NOT IN (SELECT FOR_CLICEE FROM U_FOR_AN WHERE FOR_CLICEE<>'') AND " + ;  && NON VISUALIZZA I CLIENTI DI COMPESAZIONE CEE
		 "(CASE CL.MOD_DATREG WHEN '' THEN (CL.REG_DATREG+CASE CL.REG_ORAREG WHEN '' THEN '23:59:59' ELSE CL.REG_ORAREG END) ELSE CL.MOD_DATREG+CASE CL.MOD_ORAREG WHEN '' THEN '23:59:59' ELSE CL.MOD_ORAREG END END) > '" + _ULT_TS_SYNC_CLI + "'"
*x_cond = "CVEN.CODICE <> '' AND " + x_cond  && ERASMO - 29/04/2020
*x_cond = x_cond + " AND AN.CLI_CODCLI = '500000657' "
cSql   = "SELECT AN.CLI_CODCLI, AN.CLI_RAGSOC, AN.CLI_CODIVA, AN.CLI_INDIR, AN.CLI_LOCALI, AN.CLI_CAP, AN.CLI_PROVIN, AN.CLI_NAZION, AN.CLI_TELEFO, AN.CLI_VALUTA, AN.CLI_PARIVA, AN.CLI_CODFIS, AN.CLI_IVACEE, " + ;
         "CL.CLI_INADEM, AN.CLI_DTCLOK, AN.CLI_TIPFAT, AN.CLI_CCOST1, AN.CLI_ZONA, AN.CLI_CANVEN, AN.CLI_CONPAG, AN.CLI_HOMPAG, COALESCE(STA.LIBERA,'') AS CLI_NAZION_ALPHA2, CASE CLI_INADEM WHEN 1 THEN 'true' ELSE 'false' END AS CLI_INADEM_C, " + ;
         "COALESCE(CVEN_1_3.DESCRI,'') AS CANALE_VENDITA, COALESCE(CVEN_1_6.DESCRI,'') AS MACROCLASSE_CLIENTE, COALESCE(CVEN.DESCRI,'') AS CLASSE_CLIENTE, COALESCE(CAST(REGIONI.CODICE AS VARCHAR(2)),'') AS REGIONE, AN.CLI_EMAIL, AN.CLI_OBSOL, " + ;
         "CL.CLI_IDSDI, CL.CLI_PA, AN.CLI_APPPRO, " + ;  && ERASMO - 02/12/2024
         "CL.CLI_IDNSO, " + ;  && ERASMO - 19/12/2024
         "AN.CLI_FAX, CL.CLI_EPEC, " + ;  && ERASMO - 03/02/2025
         "AN.CLI_BAEFOR, " + ;  && ERASMO - 10/02/2025
         "AN.CLI_PORTO, AN.CLI_MEZZO " + ;  && ERASMO - 26/05/2025
         "FROM U_CLI_AN AS AN " + ;
         "LEFT OUTER JOIN U_ANA_CL AS CL ON AN.CLI_CODCLI = CL.CLI_CODCLI " + ;
         "LEFT OUTER JOIN PARA AS STA ON 'STA'+AN.CLI_NAZION = STA.CODICE " + ;
         "LEFT OUTER JOIN PARA AS CVEN ON CVEN.CODICE = 'CVE'+AN.CLI_CANVEN AND LEN(RTRIM(CVEN.CODICE)) = 3+9 " + ;
         "LEFT OUTER JOIN PARA AS CVEN_1_3 ON CVEN_1_3.CODICE = 'CVE'+SUBSTRING(AN.CLI_CANVEN,1,3) AND LEN(RTRIM(CVEN_1_3.CODICE)) = 3+3 " + ;
         "LEFT OUTER JOIN PARA AS CVEN_1_6 ON CVEN_1_6.CODICE = 'CVE'+SUBSTRING(AN.CLI_CANVEN,1,6) AND LEN(RTRIM(CVEN_1_6.CODICE)) = 3+6 " + ;
         "LEFT OUTER JOIN PROVINCE ON PROVINCE.SIGLA = AN.CLI_PROVIN " + ;
         "LEFT OUTER JOIN REGIONI ON REGIONI.CODICE = PROVINCE.REGIONE " + ;
         "LEFT OUTER JOIN PARA AS APP ON 'APP'+AN.CLI_APPPRO = APP.CODICE " + ;  && ERASMO - 02/12/2024
         "WHERE " + x_cond + ;
         "ORDER BY AN.CLI_CODCLI"
IF !ExecCommand(cSql,"TMP_CLI_CL_AN")
	return(.f.)
ENDIF

SELECT TMP_CLI_CL_AN
GO TOP
SCAN

*!*		IF RECNO() > 100
*!*			EXIT
*!*		ENDIF
	
	WAIT WINDOWS "Elaborazione cliente Aquarius " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + " in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	_CLI_CODCLI = ALLTRIM(CLI_CODCLI)
	
*!*		**=> ERASMO - INIZIO 05/05/2021
*!*		IF PUB_CTRCLOR
*!*			x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
*!*			x_codi = "cli_codcli = '" + ALLTRIM(_CLI_CODCLI) + "'"
*!*			x_cond = x_soci + " and " + x_codi
*!*			cSql = "select * from u_cli_an where " + x_cond
*!*			IF !ExecCommand(cSql,"CUR_CLIENTE")
*!*			   RETURN .F.
*!*			ENDIF
*!*			__DATI_ANAGRAFICI_OBBLIGATORI = .F.
*!*			__CAMPI_NON_CODIFICATI = ""
*!*			__CAMPI_NON_CODIFICATI=CONTROLLO_DATI_ANAGRAFICI_OBBLIGATORI('CUR_CLIENTE')
*!*			IF __DATI_ANAGRAFICI_OBBLIGATORI 
*!*			  	SELECT TMP_CLI_CL_AN
*!*			  	LOOP
*!*			ENDIF
*!*		ENDIF
*!*		SELECT TMP_CLI_CL_AN
*!*		**=> ERASMO - FINE 05/05/2021
	
	_CLI_RAGSOC = ALLTRIM(CLI_RAGSOC)
	_CLI_CODIVA = ALLTRIM(CLI_CODIVA)
	_CLI_INDIR = ALLTRIM(CLI_INDIR)
	_CLI_LOCALI = SUBSTR(ALLTRIM(CLI_LOCALI),1,40)
	_CLI_CAP = ALLTRIM(CLI_CAP)
	_CLI_PROVIN = IIF(CLI_NAZION='ITA',UPPER(ALLTRIM(CLI_PROVIN)),'')
	_CLI_NAZION = UPPER(ALLTRIM(CLI_NAZION))
	_CLI_NAZION_ALPHA2 = UPPER(ALLTRIM(CLI_NAZION_ALPHA2))
	IF _CLI_NAZION_ALPHA2 = 'EL'
		_CLI_NAZION_ALPHA2 = 'GR'
	ENDIF
	_CLI_TELEFO = ALLTRIM(CLI_TELEFO)
	_CLI_VALUTA = UPPER(ALLTRIM(CLI_VALUTA))
	_CLI_PARIVA = ALLTRIM(CLI_PARIVA)
	_CLI_CODFIS = ALLTRIM(CLI_CODFIS)
	_CLI_IVACEE = ALLTRIM(CLI_IVACEE)
	_CLI_INADEM_C = ALLTRIM(CLI_INADEM_C)
	*_CLI_DTCLOK_SF = IIF(EMPTY(CLI_DTCLOK),STRTRAN(RIBALTA2(CLI_DTCLOK),"/","-"),"")
	_CLI_DTCLOK_SF = IIF(!EMPTY(CLI_DTCLOK),STRTRAN(RIBALTA2(CLI_DTCLOK),"/","-"),"")  && ERASMO - 22/09/2025
	_CLI_TIPFAT = ALLTRIM(CLI_TIPFAT)
	_CLI_CCOST1 = ALLTRIM(CLI_CCOST1)
	_CLI_ZONA = UPPER(ALLTRIM(CLI_ZONA))
	_CLI_CANVEN = ALLTRIM(CLI_CANVEN)
	_CLI_CONPAG = ALLTRIM(CLI_CONPAG)
	_CLI_HOMPAG = ALLTRIM(CLI_HOMPAG)
	_CANALE_VENDITA = ALLTRIM(CANALE_VENDITA)
	_MACROCLASSE_CLIENTE = ALLTRIM(MACROCLASSE_CLIENTE)
	_CLASSE_CLIENTE = ALLTRIM(CLASSE_CLIENTE)
	_REGIONE = ALLTRIM(REGIONE)
	_CLI_EMAIL = ALLTRIM(CLI_EMAIL)  && ERASMO - 09/11/2020
	_CLI_OBSOL = ALLTRIM(CLI_OBSOL)  && ERASMO - 11/06/2021
	**=> ERASMO - INIZIO 26/05/2025
	_CLI_PORTO = ALLTRIM(CLI_PORTO)
	_CLI_MEZZO = ALLTRIM(CLI_MEZZO)
	**=> ERASMO - FINE 26/05/2025
	
	**=> ERASMO - INIZIO 23/06/2021
	*_OwnerId = LOOKUP_USER(CLI_CCOST1)
	_OwnerId = LOOKUP_USER(ENCODE_URI_SF(CLI_CCOST1))
	IF EMPTY(_OwnerId)
		WAIT WINDOWS SUBSTR("Cliente Aquarius " + _CLI_RAGSOC + " - User SFDC non trovato per Centro di costo '" + CLI_CCOST1 + "'",1,254) TIMEOUT 2
		_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
			"Warning: Cliente Aquarius " + _CLI_RAGSOC + " - User SFDC non trovato per Centro di costo '" + CLI_CCOST1 + "'"
	ENDIF	
	**=> ERASMO - FINE 23/06/2021
	**=> ERASMO - INIZIO 02/12/2024
	_CLI_IDSDI = ALLTRIM(CLI_IDSDI)
	_CLI_PA = CLI_PA
	_Macrogruppo__c = IIF(!EMPTY(ALLTRIM(CLI_APPPRO)) AND ALLTRIM(CLI_APPPRO) <> "000", LOOKUP_MACROGRUPPO(ALLTRIM(CLI_APPPRO)), "")
	**=> ERASMO - FINE 02/12/2024
	
	**=> ERASMO - INIZIO 03/02/2025
	_CLI_FAX = ALLTRIM(CLI_FAX)
	_CLI_IDNSO = ALLTRIM(CLI_IDNSO)
	_CLI_EPEC = ALLTRIM(CLI_EPEC)
	**=> ERASMO - FINE 03/02/2025
	
	_CLI_BAEFOR = ALLTRIM(CLI_BAEFOR)  && ERASMO - 10/02/2025
	
	**=> ERASMO - INIZIO 29/04/2025
	_Codice_IVA_lookup__c = IIF(!EMPTY(_CLI_CODIVA), LOOKUP_IVA(_CLI_CODIVA), "")
	**=> ERASMO - FINE 29/04/2025
	
	**=> ERASMO - INIZIO 16/05/2025
	_Condizioni_di_pagamento_pick__c = IIF(!EMPTY(_CLI_CONPAG), LOOKUP_CPA(_CLI_CONPAG), "")
	**=> ERASMO - FINE 16/05/2025

	**=> ERASMO - INIZIO 26/05/2025
	_Porto__c = IIF(!EMPTY(_CLI_PORTO), LOOKUP_PORTO(_CLI_PORTO), "")
	_Mezzo__c = IIF(!EMPTY(_CLI_MEZZO), LOOKUP_MEZZO(_CLI_MEZZO), "")
	**=> ERASMO - FINE 26/05/2025
				
	*** PULIZIA CARATTERE CR E LF
	_CLI_RAGSOC = STRTRAN(STRTRAN(_CLI_RAGSOC,CHR(13),' '),CHR(10),'')
	_CLI_INDIR = STRTRAN(STRTRAN(_CLI_INDIR,CHR(13),' '),CHR(10),'')
	_CLI_LOCALI = STRTRAN(STRTRAN(_CLI_LOCALI,CHR(13),' '),CHR(10),'')
	_CLI_TELEFO = STRTRAN(STRTRAN(_CLI_TELEFO,CHR(13),' '),CHR(10),'')
	_CANALE_VENDITA = STRTRAN(STRTRAN(_CANALE_VENDITA,CHR(13),' '),CHR(10),'')
	_MACROCLASSE_CLIENTE = STRTRAN(STRTRAN(_MACROCLASSE_CLIENTE,CHR(13),' '),CHR(10),'')
	_CLASSE_CLIENTE = STRTRAN(STRTRAN(_CLASSE_CLIENTE,CHR(13),' '),CHR(10),'')
	_REGIONE = STRTRAN(STRTRAN(_REGIONE,CHR(13),' '),CHR(10),'')
	_CLI_EMAIL = STRTRAN(STRTRAN(_CLI_EMAIL,CHR(13),' '),CHR(10),'')  && ERASMO - 09/11/2020
	_CLI_IDSDI = STRTRAN(STRTRAN(_CLI_IDSDI,CHR(13),' '),CHR(10),'')	&& ERASMO - 10/02/2025
	_CLI_FAX = STRTRAN(STRTRAN(_CLI_FAX,CHR(13),' '),CHR(10),'')		&& ERASMO - 10/02/2025
	_CLI_IDNSO = STRTRAN(STRTRAN(_CLI_IDNSO,CHR(13),' '),CHR(10),'')	&& ERASMO - 10/02/2025
	_CLI_EPEC = STRTRAN(STRTRAN(_CLI_EPEC,CHR(13),' '),CHR(10),'')		&& ERASMO - 10/02/2025
	
	*** ESCAPING CARATTERE \
	_CLI_RAGSOC = STRTRAN(_CLI_RAGSOC,'\','\\')
	_CLI_INDIR = STRTRAN(_CLI_INDIR,'\','\\')
	_CLI_LOCALI = STRTRAN(_CLI_LOCALI,'\','\\')
	_CLI_TELEFO = STRTRAN(_CLI_TELEFO,'\','\\')
	_CANALE_VENDITA = STRTRAN(_CANALE_VENDITA,'\','\\')
	_MACROCLASSE_CLIENTE = STRTRAN(_MACROCLASSE_CLIENTE,'\','\\')
	_CLASSE_CLIENTE = STRTRAN(_CLASSE_CLIENTE,'\','\\')
	_REGIONE = STRTRAN(_REGIONE,'\','\\')
	_CLI_EMAIL = STRTRAN(_CLI_EMAIL,'\','\\')  && ERASMO - 09/11/2020
	_CLI_IDSDI = STRTRAN(_CLI_IDSDI,'\','\\')	&& ERASMO - 10/02/2025
	_CLI_FAX = STRTRAN(_CLI_FAX,'\','\\')		&& ERASMO - 10/02/2025
	_CLI_IDNSO = STRTRAN(_CLI_IDNSO,'\','\\')	&& ERASMO - 10/02/2025
	_CLI_EPEC = STRTRAN(_CLI_EPEC,'\','\\')		&& ERASMO - 10/02/2025
	
	*** ESCAPING CARATTERE "
	_CLI_RAGSOC = STRTRAN(_CLI_RAGSOC,'"','\"')
	_CLI_INDIR = STRTRAN(_CLI_INDIR,'"','\"')
	_CLI_LOCALI = STRTRAN(_CLI_LOCALI,'"','\"')
	_CLI_TELEFO = STRTRAN(_CLI_TELEFO,'"','\"')
	_CANALE_VENDITA = STRTRAN(_CANALE_VENDITA,'"','\"')
	_MACROCLASSE_CLIENTE = STRTRAN(_MACROCLASSE_CLIENTE,'"','\"')
	_CLASSE_CLIENTE = STRTRAN(_CLASSE_CLIENTE,'"','\"')
	_REGIONE = STRTRAN(_REGIONE,'"','\"')
	_CLI_EMAIL = STRTRAN(_CLI_EMAIL,'"','\"')  && ERASMO - 09/11/2020
	_CLI_IDSDI = STRTRAN(_CLI_IDSDI,'"','\"')	&& ERASMO - 10/02/2025
	_CLI_FAX = STRTRAN(_CLI_FAX,'"','\"')		&& ERASMO - 10/02/2025
	_CLI_IDNSO = STRTRAN(_CLI_IDNSO,'"','\"')	&& ERASMO - 10/02/2025
	_CLI_EPEC = STRTRAN(_CLI_EPEC,'"','\"')		&& ERASMO - 10/02/2025
	
	
	IF EMPTY(_CLI_PARIVA) AND EMPTY(_CLI_CODFIS) AND EMPTY(_CLI_IVACEE)
		WAIT WINDOWS SUBSTR("Cliente Aquarius " + _CLI_RAGSOC + " incompleto, pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
		_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
			"Warning: Cliente Aquarius " + _CLI_RAGSOC + "(" + _CLI_CODCLI + ") incompleto, non considerato in elaborazione clienti Aquarius modificati rispetto all'ultima sincronizzazione"
		SELECT TMP_CLI_CL_AN
		LOOP
	ENDIF
	
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,LastModifiedDate,Codice_Iva__c+FROM+Account+WHERE+Codice_Cliente__c='"+_CLI_CODCLI+"'"

	_cJson = ""

	*WAIT WINDOWS "Connessione a '"+_instance_url+"' in corso..." NOWAIT

	_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
	IF EMPTY(_cJson)
		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
		RETURN .F.
	ENDIF
	
	*WAIT WINDOWS "Elaborazione file Json per ricerca cliente " + _CLI_RAGSOC + " in corso..." NOWAIT

	obj_json = json_decode(_cJson)

	*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)		
		_cProperty = "OBJ_JSON.Array(1)._message"
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			_message = ALLTRIM(&_cProperty)
			
			WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
			IF !ExecRW(cSql,"LOG_SFSYNC","R")
			   return(.f.)
			ENDIF
			SELECT LOG_SFSYNC
			GO TOP
			IF !EOF()
				REPLACE ESITO WITH "KO"
				REPLACE MESSAGGIO WITH "Cliente " + _CLI_RAGSOC + " (" + _CLI_CODCLI + ") - " + _message
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
	
	SELECT TMP_SF_ACCOUNT
	ZAP
	
	IF OBJ_JSON._totalSize = 0
		
		*** INSERIMENTO NUOVO CLIENTE SU SALESFORCE
		
		_json_content = '{'
		_json_content = _json_content + '"Codice_Cliente__c": "' + _CLI_CODCLI + '"'
		_json_content = _json_content + ', "Name": "' + _CLI_RAGSOC + '"'
		**=> ERASMO - INIZIO 28/04/2020
		IF SUBSTR(_CLI_CANVEN,1,3) = "DIR"
			_json_content = _json_content + ', "RecordTypeId": "0121r0000007ixLAAQ"'
		ELSE
			_json_content = _json_content + ', "RecordTypeId": "0121r0000007ixNAAQ"'
		ENDIF
		**=> ERASMO - FINE 28/04/2020
		_json_content = _json_content + ', "BillingStreet": "' + _CLI_INDIR + '"'
		_json_content = _json_content + ', "BillingCity": "' + _CLI_LOCALI + '"'
		_json_content = _json_content + ', "BillingPostalCode": "' + _CLI_CAP + '"'
		_json_content = _json_content + ', "BillingStateCode": "' + _CLI_PROVIN + '"'
		_json_content = _json_content + ', "BillingCountryCode": "' + _CLI_NAZION_ALPHA2 + '"'
		_json_content = _json_content + ', "ShippingStreet": "' + _CLI_INDIR + '"'
		_json_content = _json_content + ', "ShippingCity": "' + _CLI_LOCALI + '"'
		_json_content = _json_content + ', "ShippingPostalCode": "' + _CLI_CAP + '"'
		_json_content = _json_content + ', "ShippingStateCode": "' + _CLI_PROVIN + '"'
		_json_content = _json_content + ', "ShippingCountryCode": "' + _CLI_NAZION_ALPHA2 + '"'
		_json_content = _json_content + ', "Phone": "' + _CLI_TELEFO + '"'
		_json_content = _json_content + ', "Website": "' + _CLI_HOMPAG + '"'
		_json_content = _json_content + ', "CurrencyIsoCode": "' + _CLI_VALUTA + '"'
		_json_content = _json_content + ', "Partita_Iva__c": "' + _CLI_PARIVA + '"'
		_json_content = _json_content + ', "Tipo_di_fatturazione__c": "' + _CLI_TIPFAT + '"'
		_json_content = _json_content + ', "Cli_locali__c": "' + _CLI_LOCALI + '"'
		_json_content = _json_content + ', "Codice_Fiscale__c": "' + _CLI_CODFIS + '"'
		_json_content = _json_content + ', "IVA_CEE_EXTRA_CEE__c": "' + _CLI_IVACEE + '"'
		_json_content = _json_content + ', "Cliente_Inadempiente__c": "' + _CLI_INADEM_C + '"'
		_json_content = _json_content + ', "Data_Blocco_Fornitura__c": ' + IIF(!EMPTY(_CLI_DTCLOK_SF),'"'+ _CLI_DTCLOK_SF + '"','null')
		_json_content = _json_content + ', "Codice_Iva__c": "' + _CLI_CODIVA + '"'
		_json_content = _json_content + ', "Codice_Nazione__c": "' + _CLI_NAZION + '"'
		_json_content = _json_content + ', "Centro_di_costo__c": "' + _CLI_CCOST1 + '"'
		_json_content = _json_content + ', "Regione_Fatturazione__c": "' + _REGIONE + '"'
		_json_content = _json_content + ', "Codice_Completo_Classe_di_vendita__c": "' + _CLI_CANVEN + '"'
		_json_content = _json_content + ', "Condizioni_di_Pagamento__c": "' + _CLI_CONPAG + '"'
		_json_content = _json_content + ', "Canale_di_vendita__c": "' + SUBSTR(_CLI_CANVEN,1,3) + '"'
		_json_content = _json_content + ', "Macro_Classe_Cliente__c": "' + SUBSTR(_CLI_CANVEN,1,6) + '"'
		_json_content = _json_content + ', "Classe_Cliente__c": "' + SUBSTR(_CLI_CANVEN,1,9) + '"'
		_json_content = _json_content + ', "Regione_Spedizione__c": "' + _REGIONE + '"'
		_json_content = _json_content + ', "Zona_Fatturazione__c": "' + _CLI_ZONA + '"'
		_json_content = _json_content + ', "Zona_Spedizione__c": "' + _CLI_ZONA + '"'
		_json_content = _json_content + ', "UpdatedInSF__c": false'
		_json_content = _json_content + ', "FromAcquarius__c": true'
		_json_content = _json_content + ', "cli_locali__c": "' + _CLI_LOCALI + '"'
		_json_content = _json_content + ', "Email__c": "' + _CLI_EMAIL + '"'
		_json_content = _json_content + ', "Annullata__c": ' + IIF(UPPER(ALLTRIM(_CLI_OBSOL)) = 'S','true','false')  && ERASMO - 11/06/2021
		_json_content = _json_content + IIF(!EMPTY(_OwnerId),', "OwnerId": "'+ _OwnerId + '"','')  && ERASMO - 23/06/2021
		_json_content = _json_content + ', "Codice_SDI__c": "' + _CLI_IDSDI + '"'  && ERASMO - 02/12/2024
		_json_content = _json_content + ', "Pubblica_amministrazione__c": ' + IIF(_CLI_PA,'true','false')  && ERASMO - 02/12/2024
		_json_content = _json_content + ', "Macrogruppo__c": ' + IIF(EMPTY(_Macrogruppo__c),'null','"' + _Macrogruppo__c + '"')   && ERASMO - 02/12/2024
		_json_content = _json_content + ', "Fax": "' + _CLI_FAX + '"'		&& ERASMO - 03/02/2025
		_json_content = _json_content + ', "NSO__c": "' + _CLI_IDNSO + '"'	&& ERASMO - 03/02/2025
		_json_content = _json_content + ', "PEC__c": "' + _CLI_EPEC + '"'	&& ERASMO - 03/02/2025
		_json_content = _json_content + ', "Banca_del_fornitore__c": "' + _CLI_BAEFOR + '"'  && ERASMO - 10/02/2025
		_json_content = _json_content + ', "Codice_IVA_lookup__c": "' + _Codice_IVA_lookup__c + '"'  && ERASMO - 29/04/2025
		_json_content = _json_content + ', "Condizioni_di_pagamento_pick__c": "' + _Condizioni_di_pagamento_pick__c + '"'  && ERASMO - 16/05/2025
		_json_content = _json_content + ', "Porto__c": ' + IIF(EMPTY(_Porto__c),'null','"' + _Porto__c + '"')   && ERASMO - 26/05/2025
		_json_content = _json_content + ', "Mezzo__c": ' + IIF(EMPTY(_Mezzo__c),'null','"' + _Mezzo__c + '"')   && ERASMO - 26/05/2025
		_json_content = _json_content + '}'
		_cJson = ""
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Account/"

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
				
					WAIT WINDOWS SUBSTR("Errorcode: "+_errorcode+" - Cliente Aquarius " + _CLI_RAGSOC + " (" + _CLI_CODCLI + "), pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
					_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
						"Warning: "+_errorcode+" - Cliente Aquarius " + _CLI_RAGSOC + " (" + _CLI_CODCLI + "), pertanto non verrà considerato in questa elaborazione"
					SELECT TMP_CLI_CL_AN
					LOOP
			
				ENDIF
			ENDIF
			
			_cProperty = "OBJ_JSON.Array(1)._message"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_message = ALLTRIM(&_cProperty)
				
				WAIT WINDOWS SUBSTR("Risposta da '"+_HTTP_request+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
				IF !ExecRW(cSql,"LOG_SFSYNC","R")
				   return(.f.)
				ENDIF
				SELECT LOG_SFSYNC
				GO TOP
				IF !EOF()
					REPLACE ESITO WITH "KO"
					REPLACE MESSAGGIO WITH "Cliente " + _CLI_RAGSOC + " (" + _CLI_CODCLI + ") - " + _message
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
							
							cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
						
							_SF_ACCOUNT_ID = _id
							*_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
							
							cSql = "SELECT * FROM U_ANA_CL WHERE CLI_CODCLI = '" + _CLI_CODCLI + "'"
							IF !ExecRW(cSql,"U_ANA_CL","R")
								return(.f.)
							ENDIF
							SELECT U_ANA_CL
							GO TOP
							IF !EOF()
								REPLACE SF_ACCOUNT_ID WITH _SF_ACCOUNT_ID
								*REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
							ENDIF
							IF !ExecRW(cSql,"U_ANA_CL","W")
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
						
						cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	
		SELECT TMP_CLI_CL_AN
		LOOP
	ENDIF

	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_ACCOUNT
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
		
		SELECT TMP_SF_ACCOUNT
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_ACCOUNT
	_SF_ACCOUNT_ID = ID
	_SF_LASTMODIFIEDDATE = LASTMODIFIEDDATE
	
	cSql = "SELECT * FROM U_ANA_CL WHERE CLI_CODCLI = '" + _CLI_CODCLI + "'"
	IF !ExecRW(cSql,"U_ANA_CL","R")
		return(.f.)
	ENDIF
	SELECT U_ANA_CL
	GO TOP
	IF !EOF()
		REPLACE SF_ACCOUNT_ID WITH _SF_ACCOUNT_ID
		REPLACE SF_LASTMODIFIEDDATE WITH _SF_LASTMODIFIEDDATE 
	ENDIF
	IF !ExecRW(cSql,"U_ANA_CL","W")
		return(.f.)
	ENDIF

	SELECT TMP_SF_ACCOUNT
	ZAP
	
	_json_content = '{'
	_json_content = _json_content + '"Name": "' + _CLI_RAGSOC + '"'
	**=> ERASMO - INIZIO 09/07/2020
	IF SUBSTR(_CLI_CANVEN,1,3) = "DIR"
		_json_content = _json_content + ', "RecordTypeId": "0121r0000007ixLAAQ"'
	ELSE
		_json_content = _json_content + ', "RecordTypeId": "0121r0000007ixNAAQ"'
	ENDIF
	**=> ERASMO - FINE 09/07/2020
	_json_content = _json_content + ', "BillingStreet": "' + _CLI_INDIR + '"'
	_json_content = _json_content + ', "BillingCity": "' + _CLI_LOCALI + '"'
	_json_content = _json_content + ', "BillingPostalCode": "' + _CLI_CAP + '"'
	_json_content = _json_content + ', "BillingStateCode": "' + _CLI_PROVIN + '"'
	_json_content = _json_content + ', "BillingCountryCode": "' + _CLI_NAZION_ALPHA2 + '"'
	_json_content = _json_content + ', "ShippingStreet": "' + _CLI_INDIR + '"'
	_json_content = _json_content + ', "ShippingCity": "' + _CLI_LOCALI + '"'
	_json_content = _json_content + ', "ShippingPostalCode": "' + _CLI_CAP + '"'
	_json_content = _json_content + ', "ShippingStateCode": "' + _CLI_PROVIN + '"'
	_json_content = _json_content + ', "ShippingCountryCode": "' + _CLI_NAZION_ALPHA2 + '"'
	_json_content = _json_content + ', "Phone": "' + _CLI_TELEFO + '"'
	_json_content = _json_content + ', "Website": "' + _CLI_HOMPAG + '"'
	_json_content = _json_content + ', "CurrencyIsoCode": "' + _CLI_VALUTA + '"'
	_json_content = _json_content + ', "Partita_Iva__c": "' + _CLI_PARIVA + '"'
	_json_content = _json_content + ', "Tipo_di_fatturazione__c": "' + _CLI_TIPFAT + '"'
	_json_content = _json_content + ', "Cli_locali__c": "' + _CLI_LOCALI + '"'
	_json_content = _json_content + ', "Codice_Fiscale__c": "' + _CLI_CODFIS + '"'
	_json_content = _json_content + ', "IVA_CEE_EXTRA_CEE__c": "' + _CLI_IVACEE + '"'
	_json_content = _json_content + ', "Cliente_Inadempiente__c": "' + _CLI_INADEM_C + '"'
	_json_content = _json_content + ', "Data_Blocco_Fornitura__c": ' + IIF(!EMPTY(_CLI_DTCLOK_SF),'"'+ _CLI_DTCLOK_SF + '"','null')
	_json_content = _json_content + ', "Codice_Iva__c": "' + _CLI_CODIVA + '"'
	_json_content = _json_content + ', "Codice_Nazione__c": "' + _CLI_NAZION + '"'
	_json_content = _json_content + ', "Centro_di_costo__c": "' + _CLI_CCOST1 + '"'
	_json_content = _json_content + ', "Regione_Fatturazione__c": "' + _REGIONE + '"'
	_json_content = _json_content + ', "Codice_Completo_Classe_di_vendita__c": "' + _CLI_CANVEN + '"'
	_json_content = _json_content + ', "Condizioni_di_Pagamento__c": "' + _CLI_CONPAG + '"'
	_json_content = _json_content + ', "Canale_di_vendita__c": "' + SUBSTR(_CLI_CANVEN,1,3) + '"'
	_json_content = _json_content + ', "Macro_Classe_Cliente__c": "' + SUBSTR(_CLI_CANVEN,1,6) + '"'
	_json_content = _json_content + ', "Classe_Cliente__c": "' + SUBSTR(_CLI_CANVEN,1,9) + '"'
	_json_content = _json_content + ', "Regione_Spedizione__c": "' + _REGIONE + '"'
	_json_content = _json_content + ', "Zona_Fatturazione__c": "' + _CLI_ZONA + '"'
	_json_content = _json_content + ', "Zona_Spedizione__c": "' + _CLI_ZONA + '"'
	_json_content = _json_content + ', "UpdatedInSF__c": true'
	*_json_content = _json_content + ', "FromAcquarius__c": true'
	_json_content = _json_content + ', "cli_locali__c": "' + _CLI_LOCALI + '"'
	_json_content = _json_content + ', "Email__c": "' + _CLI_EMAIL + '"'
	_json_content = _json_content + ', "Annullata__c": ' + IIF(UPPER(ALLTRIM(_CLI_OBSOL)) = 'S','true','false')  && ERASMO - 11/06/2021
	_json_content = _json_content + IIF(!EMPTY(_OwnerId),', "OwnerId": "'+ _OwnerId + '"','')  && ERASMO - 23/06/2021
	_json_content = _json_content + ', "Codice_SDI__c": "' + _CLI_IDSDI + '"'  && ERASMO - 02/12/2024
	_json_content = _json_content + ', "Pubblica_amministrazione__c": ' + IIF(_CLI_PA,'true','false')  && ERASMO - 02/12/2024
	_json_content = _json_content + ', "Macrogruppo__c": ' + IIF(EMPTY(_Macrogruppo__c),'null','"' + _Macrogruppo__c + '"')   && ERASMO - 02/12/2024
	_json_content = _json_content + ', "Fax": "' + _CLI_FAX + '"'		&& ERASMO - 03/02/2025
	_json_content = _json_content + ', "NSO__c": "' + _CLI_IDNSO + '"'	&& ERASMO - 03/02/2025
	_json_content = _json_content + ', "PEC__c": "' + _CLI_EPEC + '"'	&& ERASMO - 03/02/2025
	_json_content = _json_content + ', "Banca_del_fornitore__c": "' + _CLI_BAEFOR + '"'  && ERASMO - 10/02/2025
	_json_content = _json_content + ', "Codice_IVA_lookup__c": "' + _Codice_IVA_lookup__c + '"'  && ERASMO - 29/04/2025
	_json_content = _json_content + ', "Condizioni_di_pagamento_pick__c": "' + _Condizioni_di_pagamento_pick__c + '"'  && ERASMO - 16/05/2025
	_json_content = _json_content + ', "Porto__c": ' + IIF(EMPTY(_Porto__c),'null','"' + _Porto__c + '"')   && ERASMO - 26/05/2025
	_json_content = _json_content + ', "Mezzo__c": ' + IIF(EMPTY(_Mezzo__c),'null','"' + _Mezzo__c + '"')   && ERASMO - 26/05/2025
	_json_content = _json_content + '}'
		
	*** AGGIORNAMENTO CAMPI SU SALESFORCE
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Account/"+_SF_ACCOUNT_ID
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
			
				_cProperty_errorcode = "OBJ_JSON.Array(1)._errorcode"
				IF TYPE(_cProperty_errorcode) <> 'U' AND TYPE(_cProperty_errorcode) <> 'O' AND !ISNULL(&_cProperty_errorcode)
					_errorcode = ALLTRIM(&_cProperty_errorcode)
					IF _errorcode = "DUPLICATES_DETECTED"
					
						WAIT WINDOWS SUBSTR("Errorcode: "+_errorcode+" - Cliente Aquarius " + _CLI_RAGSOC + " (" + _CLI_CODCLI + "), pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
						_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
							"Warning: "+_errorcode+" - Cliente Aquarius " + _CLI_RAGSOC + " (" + _CLI_CODCLI + "), pertanto non verrà considerato in questa elaborazione"
						SELECT TMP_CLI_CL_AN
						LOOP
				
					ENDIF
					
					**=> ERASMO - INIZIO 10/02/2025
					IF _errorcode = "CANNOT_INSERT_UPDATE_ACTIVATE_ENTITY"
					
						WAIT WINDOWS SUBSTR("Errorcode: "+_errorcode+" - Cliente Aquarius " + _CLI_RAGSOC + " (" + _CLI_CODCLI + "), pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
						_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
							"Warning: "+_errorcode+" - Cliente Aquarius " + _CLI_RAGSOC + " (" + _CLI_CODCLI + "), pertanto non verrà considerato in questa elaborazione"
						SELECT TMP_CLI_CL_AN
						LOOP
				
					ENDIF
					**=> ERASMO - FINE 10/02/2025
				ENDIF
			
				_message = ALLTRIM(&_cProperty)
				WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
				IF !ExecRW(cSql,"LOG_SFSYNC","R")
				   return(.f.)
				ENDIF
				SELECT LOG_SFSYNC
				GO TOP
				IF !EOF()
					REPLACE ESITO WITH "KO"
					REPLACE MESSAGGIO WITH "Cliente " + _CLI_RAGSOC + " (" + _CLI_CODCLI + ") - " + _message
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


*** ELABORAZIONE NUOVI CLIENTI SALESFORCE CREATI (SENZA RIFERIMENTO CODICE CLIENTE AQUARIUS)
*** SE RECORD INSERITO SU SALESFORCE, RIPORTARE SOLO GLI ACCOUNT APPARTENENTI AI SEGUENTI TYPEID:
*** 	-	0128E0000000wXsQAI cliente finale
*** 	-	0128E0000000wXnQAI distributore/rivenditore/partner
**=> ERASMO - INIZIO 28/04/2020
*** CODICI CAMBIATI IN AMBIENTE DI PRODUZIONE SALESFORCE:
*** 	-	0121r0000007ixLAAQ cliente finale
*** 	-	0121r0000007ixNAAQ distributore/rivenditore/partner
**=> ERASMO - FINE 28/04/2020
*************************************************************************************************

WAIT WINDOWS "Lettura nuovi clienti Salesforce creati (senza riferimento codice cliente Aquarius)..." NOWAIT

*!*	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,LastModifiedDate,Name,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode,BillingCountryCode,Phone,CurrencyIsoCode,Partita_Iva__c," + ;
*!*		"Codice_Fiscale__c,IVA_CEE_EXTRA_CEE__c,Cliente_Inadempiente__c,Data_Blocco_Fornitura__c,Tipo_di_fatturazione__c,Codice_Nazione__c,Centro_di_costo__c,Classe_Cliente__c,Condizioni_di_Pagamento__c,Website" + ;
*!*		"+FROM+Account+WHERE+Codice_Cliente__c=null+AND+RecordTypeId+IN+('0128E0000000wXsQAI','0128E0000000wXnQAI')"
*!*	**=> ERASMO - INIZIO 28/04/2020
*!*	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,LastModifiedDate,Name,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode,BillingCountryCode,Phone,CurrencyIsoCode,Partita_Iva__c," + ;
*!*		"Codice_Fiscale__c,IVA_CEE_EXTRA_CEE__c,Cliente_Inadempiente__c,Data_Blocco_Fornitura__c,Tipo_di_fatturazione__c,Codice_Nazione__c,Centro_di_costo__c,Classe_Cliente__c,Condizioni_di_Pagamento__c,Website" + ;
*!*		"+FROM+Account+WHERE+(Codice_Cliente__c=null+OR+Codice_Cliente__c='')+AND+RecordTypeId+IN+('0121r0000007ixLAAQ','0121r0000007ixNAAQ')"
*!*	**=> ERASMO - FINE 28/04/2020
**=> ERASMO - INIZIO 19/12/2024
_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,LastModifiedDate,Name,BillingStreet,BillingCity,BillingPostalCode,BillingStateCode,BillingCountryCode,Phone,CurrencyIsoCode,Partita_Iva__c," + ;
	"Codice_Fiscale__c,IVA_CEE_EXTRA_CEE__c,Cliente_Inadempiente__c,Data_Blocco_Fornitura__c,Tipo_di_fatturazione__c,Codice_Nazione__c,Centro_di_costo__c,Classe_Cliente__c,Condizioni_di_Pagamento__c,Email__c,Website,Codice_SDI__c," + ;
	"Pubblica_amministrazione__c,Macrogruppo__c,SYS_Centro_di_costo_Owner__c,Fax,NSO__c,Zona_Fatturazione__c,Codice_Iva__c,PEC__c,Banca_del_fornitore__c+FROM+Account+" + ;
	"WHERE+(Codice_Cliente__c=null+OR+Codice_Cliente__c='')+AND+RecordTypeId+IN+('0121r0000007ixLAAQ','0121r0000007ixNAAQ')" + ;
	"+AND+Id!=null+AND+Id!=''+AND+Name!=null+AND+Name!=''"  && ERASMO - 07/01/2025
**=> ERASMO - FINE 19/12/2024

_cJson = ""
_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione nuovi clienti Salesforce creati in corso..." NOWAIT

obj_json = json_decode(_cJson)

*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
	_cProperty = "OBJ_JSON.Array(1)._message"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_message = ALLTRIM(&_cProperty)
		WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
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

SELECT TMP_SF_ACCOUNT
ZAP

IF OBJ_JSON._totalSize > 0

	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_ACCOUNT
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
		
		SELECT TMP_SF_ACCOUNT
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_ACCOUNT
	GO TOP
	SCAN
	
		*IF RECNO() > 1
		*	EXIT
		*ENDIF
		
		SCATTER MEMVAR MEMO
		
		cSql = "SELECT * FROM U_CLI_AN WHERE 1=0"
		IF !ExecCommand(cSql,"TMP_CLI_AN")
			return(.f.)
		ENDIF
		SELECT TMP_CLI_AN
		SCATTER MEMVAR MEMO BLANK
		cSql = "SELECT * FROM U_ANA_CL WHERE 1=0"
		IF !ExecCommand(cSql,"TMP_ANA_CL")
			return(.f.)
		ENDIF
		SELECT TMP_ANA_CL
		SCATTER MEMVAR MEMO BLANK
		
		M.SF_ACCOUNT_ID = M.ID
		M.SF_LASTMODIFIEDDATE = M.LASTMODIFIEDDATE
		
		M.CLI_RAGSOC = APITOSPA(UPPER(ALLTRIM(M.Name)))
		M.CLI_INDIR = APITOSPA(UPPER(ALLTRIM(M.BillingStreet)))
		M.CLI_LOCALI = APITOSPA(UPPER(ALLTRIM(M.BillingCity)))
		M.CLI_CAP = ALLTRIM(M.BillingPostalCode)
		M.CLI_PROVIN = UPPER(ALLTRIM(M.BillingStateCode))
		
		M.CLI_NAZION = PUB_NAZI
		IF !EMPTY(UPPER(ALLTRIM(M.BillingCountryCode)))
			x_cond = "codice LIKE 'STA%' AND libera = '" + UPPER(ALLTRIM(M.BillingCountryCode)) + "'"
			cSql   = "select substring(codice,4,3) AS COD_NAZIONE_AQ from para where " + x_cond 
			IF !ExecCommand(cSql,"TMP_PARA")
			   return(.f.)
			ENDIF
			SELECT TMP_PARA
			GO TOP
			IF !EOF()
				M.CLI_NAZION = COD_NAZIONE_AQ
			ENDIF
		ENDIF
		
		M.CLI_TELEFO = UPPER(ALLTRIM(M.Phone))
		
		M.CLI_VALUTA = UPPER(ALLTRIM(M.CurrencyIsoCode))
		IF EMPTY(M.CLI_VALUTA)
			M.CLI_VALUTA = PUB_VALRIF
		ENDIF
		
		M.CLI_PARIVA = UPPER(ALLTRIM(M.Partita_Iva__c))
		M.CLI_CODFIS = UPPER(ALLTRIM(M.Codice_Fiscale__c))
		M.CLI_IVACEE = UPPER(ALLTRIM(M.IVA_CEE_EXTRA_CEE__c))
		M.CLI_INADEM = IIF(UPPER(SUBSTR(M.Cliente_Inadempiente__c,1,1)) == 'F',.F.,.T.)
		M.CLI_DTCLOK = RIBALTA2(STRTRAN(ALLTRIM(M.Data_Blocco_Fornitura__c),"-","/"))
		M.CLI_TIPFAT = ALLTRIM(M.Tipo_di_fatturazione__c)
		IF !EMPTY(ALLTRIM(M.Codice_Nazione__c))
			M.CLI_NAZION = ALLTRIM(M.Codice_Nazione__c)
		ENDIF
		*M.CLI_CCOST1 = UPPER(ALLTRIM(M.Centro_di_costo__c))
		M.CLI_CCOST1 = UPPER(ALLTRIM(M.SYS_Centro_di_costo_Owner__c))  && ERASMO - 19/12/2024
		*M.CLI_ZONA = UPPER(ALLTRIM(M.Codice_Zona__c))
		M.CLI_CANVEN = UPPER(ALLTRIM(M.Classe_Cliente__c))
		M.CLI_CONPAG = UPPER(ALLTRIM(M.Condizioni_di_Pagamento__c))
		*IF EMPTY(M.CLI_CONPAG)
		*	M.CLI_CONPAG = PUB_CPA
		*ENDIF
		M.CLI_HOMPAG = ALLTRIM(M.Website)
		M.CLI_EMAIL = ALLTRIM(M.Email__c)  && ERASMO - 09/11/2020
		
		*M.CLI_CODIVA = PUB_IVA
		M.CLI_CODIVA = ALLTRIM(M.Codice_Iva__c)  && ERASMO - 19/12/2024
		M.CLI_LISTIN = "1"
		M.CLI_AGE = PUB_AGE
		
		**=> ERASMO - INIZIO 19/12/2024
		M.CLI_FAX = ALLTRIM(M.Fax)
		M.CLI_ZONA = ALLTRIM(M.Zona_Fatturazione__c)
		M.CLI_IDSDI = ALLTRIM(M.Codice_SDI__c)
		M.CLI_EPEC = ALLTRIM(M.PEC__c)  && ERASMO - 03/02/2025
		M.CLI_IDNSO = ALLTRIM(M.NSO__c)
		M.CLI_PA = IIF(SUBSTR(UPPER(ALLTRIM(M.Pubblica_amministrazione__c)),1,1) == "T",.T.,.F.)
		M.CLI_APPPRO = ""
		IF !EMPTY(ALLTRIM(M.Macrogruppo__c))
			M.CLI_APPPRO = LOOKUP_GRUPPO_AQ_DA_MACROGRUPPO(ALLTRIM(M.Macrogruppo__c))
		ENDIF
		IF EMPTY(ALLTRIM(M.CLI_APPPRO))
			M.CLI_APPPRO = "000"
		ENDIF
		M.CLI_FATELETT = .T.
		**=> ERASMO - FINE 19/12/2024
		
		M.CLI_BAEFOR = ALLTRIM(M.Banca_del_fornitore__c)  && ERASMO - 10/02/2025
		
		X_CODICE = ""
		x_cond = "codice = 'NUMCLI" + PUB_CODSOC + "'"
		cSql   = "select * from para where " + x_cond 
		IF !ExecRW(cSql,"para","R")
		   return(.f.)
		ENDIF
		SELECT PARA
		GO TOP
		IF EOF()
			*MESSAGEBOX('Parametro codice cliente non trovato',16,"*** ATTENZIONE ***")
			WAIT WINDOWS "Parametro codice cliente non trovato'" TIMEOUT 3
			IF !ExecRW(cSql,"para","W")
			   return(.f.)
			ENDIF
			RETURN .F.
		ELSE
		   S_NUM = SUBSTR(LIBERA,1,10)
		   IF S_NUM  <> "9999999999"                    && SOLO SE <> 9999999999
		      N_NUM     = VAL(S_NUM)
		      INC_NUM   = N_NUM + 1
		      S_INC_NUM = STR(INC_NUM,10,0)
		      X_CODICE  = ALLTRIM(S_INC_NUM)
		      IF SUBSTR(X_CODICE,1,1)  <  "A"
		 	     X_CODICE= TRC(PUB_LCL,ALLTRIM(X_CODICE))
			  ENDIF
		      REPLACE LIBERA WITH S_INC_NUM 
		   ENDIF   
		   
		   INC_NUM   = N_NUM + 1
		   S_INC_NUM = STR(INC_NUM,10,0)
		   X_CODICE  = ALLTRIM(S_INC_NUM)
		   IF SUBSTR(X_CODICE,1,1)  <  "A"
		      X_CODICE = TRC(PUB_LCL,ALLTRIM(X_CODICE))
		   ENDIF
		ENDIF
		IF !ExecRW(cSql,"para","W")
		   return(.f.)
		ENDIF
		
		M.CLI_CODSOC = PUB_CODSOC
		M.CLI_CODCLI = X_CODICE
		M.CLI_DATNEW = RIBALTA2(DTOC(DATE()))  && ERASMO - 29/04/2020
		cSql = "SELECT * FROM U_CLI_AN WHERE 1=0"
		IF !ExecRW(cSql,"U_CLI_AN","R")
			return(.f.)
		ENDIF
		SELECT U_CLI_AN
		APPEND BLANK
		DO U_CLI_AN
		IF !ExecRW(cSql,"U_CLI_AN","W")
			return(.f.)
		ENDIF
		
		cSql = "SELECT * FROM U_ANA_CL WHERE 1=0"
		IF !ExecRW(cSql,"U_ANA_CL","R")
			return(.f.)
		ENDIF
		SELECT U_ANA_CL
		APPEND BLANK
		DO U_ANA_CL
		
		REPLACE REG_DATREG WITH _LOG_DATA
		REPLACE REG_ORAREG WITH _LOG_ORA

		IF !ExecRW(cSql,"U_ANA_CL","W")
			return(.f.)
		ENDIF
		
		IF !EMPTY(ALLTRIM(M.CLI_CODCLI)) 			&& TEST DI SICUREZZA PER NON AGGIORNARE I MASTRI NEL CASO DI ERRORE SW
			
			V_ER = SOTTOGEN(M.cli_nazion)
			IF !V_ER
			   CC = PUB_CC
			ENDIF 
			* -->> Ricarico cursore
			* --------------------------
			V_CONTO = CC + ALLTRIM(M.CLI_CODCLI)
			x_soci  = "con_soc = '" + PUB_CODSOC + "'"
			x_anno  = "con_anno = '" + PUB_ANNO + "'"
			x_cont  = "con_conto = '" + V_CONTO + "'"
			x_cond  = x_soci + " and " + x_anno + " and " + x_cont
			cSql    = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
			IF !ExecRW(cSql,"conti","R")
			   return(.f.)
			ENDIF
			  
			IF RECCOUNT() = 0
			   APPEND BLANK
			   REPLACE CON_SOC     WITH PUB_CODSOC
			   REPLACE CON_ANNO    WITH PUB_ANNO
			   REPLACE CON_CONTO   WITH V_CONTO
			   REPLACE CON_DESCR   WITH M.CLI_RAGSOC   
			   REPLACE CON_TIPOCO  WITH 'C'
			   REPLACE CON_PARIVA  WITH M.CLI_PARIVA 
			   REPLACE CON_POSBIL  WITH 'P'
			   REPLACE CON_IVASN   WITH .F.
			   REPLACE CON_CCO     WITH SPACE(13)
			ELSE
			   REPLACE CON_DESCR   WITH M.CLI_RAGSOC   
			   REPLACE CON_TIPOCO  WITH 'C'
			   REPLACE CON_PARIVA  WITH M.CLI_PARIVA 
			   REPLACE CON_POSBIL  WITH 'P'
			   REPLACE CON_IVASN   WITH .F.
			ENDIF 
			IF !ExecRW(cSql,"conti","W")
			   return(.f.)
			ENDIF

		ENDIF		
		
		_json_content = '{'
		_json_content = _json_content + '"Codice_Cliente__c": "' + ALLTRIM(M.CLI_CODCLI) + '"'
		*_json_content = _json_content + ', "Name": "' + _CLI_RAGSOC + '"'
		_json_content = _json_content + ', "Name": "' + ALLTRIM(M.CLI_RAGSOC) + '"'  && ERASMO - 10/06/2021
		_json_content = _json_content + ', "UpdatedInSF__c": true'
		_json_content = _json_content + '}'
		
		*** AGGIORNAMENTO CAMPI SU SALESFORCE
		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Account/"+ALLTRIM(M.SF_ACCOUNT_ID)
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
					
					cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale clienti inseriti da Aquarius: " + ALLTRIM(STR(_CONTA_INS_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun cliente inserito da Aquarius"
ENDIF
IF _CONTA_AGG_DA_AQ > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale clienti aggiornati da Aquarius: " + ALLTRIM(STR(_CONTA_AGG_DA_AQ))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun cliente aggiornato da Aquarius"
ENDIF
IF _CONTA_INS_DA_SF > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale clienti inseriti da Salesforce: " + ALLTRIM(STR(_CONTA_INS_DA_SF))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun cliente inserito da Salesforce"
ENDIF
*!*	IF _CONTA_AGG_DA_SF > 0
*!*		_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale clienti aggiornati da Salesforce: " + ALLTRIM(STR(_CONTA_AGG_DA_SF))
*!*	ELSE
*!*		_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun cliente aggiornato da Salesforce"
*!*	ENDIF

cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
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

_OK_SYNC_CLIENTI = .T.
			
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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Cliente Aquarius " + _CLI_RAGSOC + " - " + _message
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
FUNCTION LOOKUP_MACROGRUPPO
**********************************************************************
LPARAMETERS _par_gruppo

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 06/02/2025

_RIT = ""

_par_gruppo = ALLTRIM(_par_gruppo)

*** ###################################################################################################################################################################################################
*** @Erasmo Masiello rispetto a quanto condiviso ieri, segnalo che nel campo Macrogruppo__c - che sarà il campo oggetto d'integrazione con il campo GRUPPO di Aq - potrai trovare clienti di RecordType
***  - Macrogruppo: 01269000000iljHAAQ
***  - Gruppo: 012690000015beGAAQ
*** Per quanto riguarda le logiche condivise ieri, ricordo che su Salesforce non gestiremo il valore NESSUN GRUPPO.
*** ###################################################################################################################################################################################################

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name+FROM+Account+WHERE+RecordTypeId+IN+('01269000000iljHAAQ','012690000015beGAAQ')+AND+Codice_Cliente__c='"+_par_gruppo+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Gruppo/Macrogruppo Aquarius " + _par_gruppo + " non trovato in tabella SFDC Account per Cliente Aquarius " + _CLI_RAGSOC			
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
FUNCTION LOOKUP_GRUPPO_AQ_DA_MACROGRUPPO
**********************************************************************
LPARAMETERS _par_id_macrogruppo

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 06/02/2025

_RIT = ""

_par_id_macrogruppo = ALLTRIM(_par_id_macrogruppo)

*_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name+FROM+Account+WHERE+RecordTypeId+IN+('01269000000iljHAAQ','012690000015beGAAQ')+AND+Codice_Cliente__c='"+_par_gruppo+"'"
_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Codice_Cliente__c+FROM+Account+WHERE+RecordTypeId+IN+('01269000000iljHAAQ','012690000015beGAAQ')+AND+Id='"+_par_id_macrogruppo+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Id Gruppo/Macrogruppo SFDC " + _par_id_macrogruppo + " non trovato in tabella SFDC Account per Nuovo Cliente Aquarius " + _CLI_RAGSOC			
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
		
	_cProperty = "OBJ_JSON._records.Array("+ALLTRIM(STR(I_row))+")._Codice_Cliente__c"
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
	
	IF TYPE("M.Codice_Cliente__c") == 'C'
		_RIT = M.Codice_Cliente__c
	ENDIF
	
NEXT

RELEASE obj_json

SELECT(_L_SELECT)  && ERASMO - 06/02/2025

RETURN _RIT

ENDFUNC

**=> ERASMO - INIZIO 29/04/2025
**********************************************************************
FUNCTION LOOKUP_IVA
**********************************************************************
LPARAMETERS _par_codiva

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()

_RIT = ""

_CodiceIva = ALLTRIM(_par_codiva)
_CodiceIva = STRTRAN(_CodiceIva,"+","%2B")

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Codice__c,Name+FROM+Codice_IVA__c+WHERE+Codice__c='"+_CodiceIva+"'"

_cJson = ""
_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_L_SELECT)
	RETURN ""
ENDIF

obj_json = json_decode(_cJson)

*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)		
	_cProperty = "OBJ_JSON.Array(1)._message"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_message = ALLTRIM(&_cProperty)
		
		WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Cliente " + _CLI_RAGSOC + " (" + _CLI_CODCLI + ") - " + _message
			_SEC_FIN = SECONDS()
			REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
		ENDIF
		IF !ExecRW(cSql,"LOG_SFSYNC","W")
		   return(.f.)
		ENDIF
		
		RELEASE obj_json
		SELECT(_L_SELECT)
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

SELECT(_L_SELECT)

RETURN _RIT

ENDFUNC
**=> ERASMO - FINE 29/04/2025


**=> ERASMO - INIZIO 16/05/2025
**********************************************************************
FUNCTION LOOKUP_CPA
**********************************************************************
LPARAMETERS _par_conpag

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()

_RIT = ""

_CodiceCpa = ALLTRIM(_par_conpag)
_CodiceCpa = STRTRAN(_CodiceCpa,"+","%2B")

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Codice__c,Name+FROM+Condizioni_di_pagamento__c+WHERE+Codice__c='"+_CodiceCpa+"'"

_cJson = ""
_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_L_SELECT)
	RETURN ""
ENDIF

obj_json = json_decode(_cJson)

*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)		
	_cProperty = "OBJ_JSON.Array(1)._message"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_message = ALLTRIM(&_cProperty)
		
		WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Cliente " + _CLI_RAGSOC + " (" + _CLI_CODCLI + ") - " + _message
			_SEC_FIN = SECONDS()
			REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
		ENDIF
		IF !ExecRW(cSql,"LOG_SFSYNC","W")
		   return(.f.)
		ENDIF
		
		RELEASE obj_json
		SELECT(_L_SELECT)
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

SELECT(_L_SELECT)

RETURN _RIT

ENDFUNC
**=> ERASMO - FINE 16/05/2025


**=> ERASMO - INIZIO 26/05/2025
**********************************************************************
FUNCTION LOOKUP_PORTO
**********************************************************************
LPARAMETERS _par_porto

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()

_RIT = ""

_CodicePorto = ALLTRIM(_par_porto)
_CodicePorto = STRTRAN(_CodicePorto,"+","%2B")

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Codice__c,Name+FROM+Porto__c+WHERE+Codice__c='"+_CodicePorto+"'"

_cJson = ""
_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_L_SELECT)
	RETURN ""
ENDIF

obj_json = json_decode(_cJson)

*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)		
	_cProperty = "OBJ_JSON.Array(1)._message"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_message = ALLTRIM(&_cProperty)
		
		WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Cliente " + _CLI_RAGSOC + " (" + _CLI_CODCLI + ") - " + _message
			_SEC_FIN = SECONDS()
			REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
		ENDIF
		IF !ExecRW(cSql,"LOG_SFSYNC","W")
		   return(.f.)
		ENDIF
		
		RELEASE obj_json
		SELECT(_L_SELECT)
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

SELECT(_L_SELECT)

RETURN _RIT

ENDFUNC


**********************************************************************
FUNCTION LOOKUP_MEZZO
**********************************************************************
LPARAMETERS _par_mezzo

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()

_RIT = ""

_CodiceMezzo = ALLTRIM(_par_mezzo)
_CodiceMezzo = STRTRAN(_CodiceMezzo,"+","%2B")

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Codice__c,Name+FROM+Mezzo__c+WHERE+Codice__c='"+_CodiceMezzo+"'"

_cJson = ""
_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_L_SELECT)
	RETURN ""
ENDIF

obj_json = json_decode(_cJson)

*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)		
	_cProperty = "OBJ_JSON.Array(1)._message"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_message = ALLTRIM(&_cProperty)
		
		WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'CLIENTI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Cliente " + _CLI_RAGSOC + " (" + _CLI_CODCLI + ") - " + _message
			_SEC_FIN = SECONDS()
			REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
		ENDIF
		IF !ExecRW(cSql,"LOG_SFSYNC","W")
		   return(.f.)
		ENDIF
		
		RELEASE obj_json
		SELECT(_L_SELECT)
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

SELECT(_L_SELECT)

RETURN _RIT

ENDFUNC
**=> ERASMO - FINE 26/05/2025
