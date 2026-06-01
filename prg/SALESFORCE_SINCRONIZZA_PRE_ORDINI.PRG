
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
_CONTA_LOC_INS_DA_SF = 0

_MSG_WARNINGS = ""

_LOG_CODSYS = IIF(EMPTY(_par_group_codsys),SYS(2015),_par_group_codsys)
_LOG_OGGETTO = "PRE_ORDINI"
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

*** CONTROLLI DI LOGIN SUPERATI, PROCEDO CON LE CHIAMATE SPECIFICHE PER LA SINCRONIZZAZIONE DEI PRE_ORDINI

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

IF USED("TMP_SF_PREORDINE__C")
	SELECT TMP_SF_PREORDINE__C
	USE
ENDIF
IF USED("TMP_SF_RIGA_PREORDINE__C")
	SELECT TMP_SF_RIGA_PREORDINE__C
	USE
ENDIF
IF USED("TMP_SF_DESTINAZIONE__C")
	SELECT TMP_SF_DESTINAZIONE__C
	USE
ENDIF

*** COMPONGO I CURSORI DI APPOGGIO CHE CONTERRANNO I DATI DEI PRE_ORDINI PRESENTI SU SALESFORCE
CREATE CURSOR TMP_SF_PREORDINE__C ( ;
	Id C(254), ;
	Name C(254), ;
	Data_ordine__c C(254), ;
	Account__c C(254), ;
	Causale_ordine__c C(254), ;
	Condizioni_di_pagamento__c C(254), ;
	CurrencyIsoCode C(254), ;
	Destinazione__c C(254), ;
	Opportunit__c C(254), ;
	Tipologia_Ordine__c C(254), ;
	Note_interne_per_spedizione__c C(254), ;
	Account__r_Codice_Cliente__c C(254), ;
	Opportunit__r_Owner_Centro_di_costo__c C(254), ;
	Causale_ordine__r_Codice__c C(254), ;
	Tipologia_Ordine__r_Codice__c C(254), ;
	Condizioni_di_pagamento__r_Codice__c C(254), ;
	Destinazione__r_Codice__c C(254), ;
	Destinazione__r_Ragione_sociale__c C(254), ;
	Destinazione__r_Indirizzo__Street__s C(254), ;
	Destinazione__r_Indirizzo__PostalCode__s C(254), ;
	Destinazione__r_Indirizzo__City__s C(254), ;
	Destinazione__r_Indirizzo__StateCode__s C(254), ;
	Destinazione__r_Indirizzo__CountryCode__s C(254), ;
	Destinazione__r_All_attenzione_di__c C(254), ;
	Destinazione__r_Note__c C(254), ;
	Destinazione__r_Email__c C(254), ;
	Destinazione__r_Id C(254), ;
	Destinazione__r_Name C(254), ;
	Porto__r_Codice__c C(254), ;
	Mezzo__r_Codice__c C(254), ;
	Numero_preordine_cliente__c C(254), ;
	NSO__c C(254), ;
	Banca__c C(254), ;
	Descrizione_causale__c C(254), ;
	Codice_CUP__c C(254), ;
	Codice_CIG__c C(254), ;
	Note_per_cliente__c C(254), ;
	Stato_sincronizzazione__c C(254), ;
	Errore_sync__c C(254), ;
	Spese_di_trasporto_da_imputare__c C(254), ;
	Numero_preventivo__c C(254))
	
CREATE CURSOR TMP_SF_RIGA_PREORDINE__C ( ;
	Id C(254), ;
	Name C(254), ;
	Codice_IVA__c C(254), ;
	CurrencyIsoCode C(254), ;
	Data_consegna__c C(254), ;
	Descrizione_articolo__c C(254), ;
	IsDeleted C(254), ;
	Preordine__c C(254), ;
	Prezzo_unitario__c C(254), ;
	Prodotto__c C(254), ;
	Quantit__c C(254), ;
	Sconto__c C(254), ;
	Prodotto__r_ProductCode C(254), ;
	Codice_IVA__r_Codice__c C(254), ;
	Note_interne__c C(254), ;
	Voce_preventivo__c C(254))
	
*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DELLE LOCALITA DI CONSEGNA PRESENTI SU SALESFORCE
CREATE CURSOR TMP_SF_DESTINAZIONE__C ( ;
	Id C(254), ;
	LastModifiedDate C(254), ;
	Name C(254), ;
	Cliente__c C(254), ;
	Ragione_sociale__c C(254), ;
	All_attenzione_di__c C(254), ;
	Indirizzo__City__s C(254), ;
	Indirizzo__Street__s C(254), ;
	Indirizzo__PostalCode__s C(254), ;
	Indirizzo__StateCode__s C(254), ;
	Indirizzo__CountryCode__s C(254), ;
	Email__c C(254), ;
	Note__c C(254), ;
	ExternalId__c C(254))
	
	
cSql="select * from U_ORD_TT where 1=0"
IF !ExecCommand(cSql,"CU_ORD_TT")
	return(.f.)
ENDIF

cSql="select * from U_ORD_T2 where 1=0"
IF !ExecCommand(cSql,"CU_ORD_T2")
	return(.f.)
ENDIF

cSql="select * from U_ORD_DD where 1=0"
IF !ExecCommand(cSql,"CU_ORD_DD")
	return(.f.)
ENDIF


*************************************************************************************************
*** ELABORAZIONE NUOVI PRE_ORDINI SALESFORCE CREATI
*************************************************************************************************

WAIT WINDOWS "Lettura nuovi Pre-ordini Salesforce creati..." NOWAIT

*!*	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Data_ordine__c,Account__c,Causale_ordine__c,Condizioni_di_pagamento__c,CurrencyIsoCode,Destinazione__c,Account__r.Codice_Cliente__c," + ;
*!*		"Opportunit__c,Tipologia_Ordine__c,Note_interne_per_spedizione__c,Opportunit__r.Owner.Centro_di_costo__c,Causale_ordine__r.Codice__c,Tipologia_Ordine__r.Codice__c,Condizioni_di_pagamento__r.Codice__c," + ;
*!*		"Destinazione__r.Codice__c,Destinazione__r.Ragione_sociale__c,Destinazione__r.Indirizzo__Street__s,Destinazione__r.Indirizzo__PostalCode__s,Destinazione__r.Indirizzo__City__s,Destinazione__r.Indirizzo__StateCode__s," + ;
*!*		"Destinazione__r.Indirizzo__CountryCode__s,Destinazione__r.All_attenzione_di__c,Destinazione__r.Note__c,Destinazione__r.Email__c,Destinazione__r.Id,Destinazione__r.Name+FROM+Preordine__c+" + ;
*!*		"WHERE+IsDeleted!=True+AND+Aq_uploaded__c!=True+ORDER+BY+Name+ASC+NULLS+FIRST"
*!*	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Data_ordine__c,Account__c,Causale_ordine__c,Condizioni_di_pagamento__c,CurrencyIsoCode,Destinazione__c,Account__r.Codice_Cliente__c," + ;
*!*		"Opportunit__c,Tipologia_Ordine__c,Note_interne_per_spedizione__c,Opportunit__r.Owner.Centro_di_costo__c,Causale_ordine__r.Codice__c,Tipologia_Ordine__r.Codice__c,Condizioni_di_pagamento__r.Codice__c," + ;
*!*		"Destinazione__r.Codice__c,Destinazione__r.Ragione_sociale__c,Destinazione__r.Indirizzo__Street__s,Destinazione__r.Indirizzo__PostalCode__s,Destinazione__r.Indirizzo__City__s,Destinazione__r.Indirizzo__StateCode__s," + ;
*!*		"Destinazione__r.Indirizzo__CountryCode__s,Destinazione__r.All_attenzione_di__c,Destinazione__r.Note__c,Destinazione__r.Email__c,Destinazione__r.Id,Destinazione__r.Name,Numero_preordine_cliente__c,NSO__c," + ;
*!*		"Porto__r.Codice__c,Mezzo__r.Codice__c,Banca__c,Descrizione_causale__c,Codice_CUP__c,Codice_CIG__c,Note_per_cliente__c,Stato_sincronizzazione__c,Errore_sync__c" + ;
*!*		"+FROM+Preordine__c+WHERE+IsDeleted!=True+AND+Stato_sincronizzazione__c!='Sincronizzato'+ORDER+BY+Name+ASC+NULLS+FIRST"
_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Data_ordine__c,Account__c,Causale_ordine__c,Condizioni_di_pagamento__c,CurrencyIsoCode,Destinazione__c,Account__r.Codice_Cliente__c," + ;
	"Opportunit__c,Tipologia_Ordine__c,Note_interne_per_spedizione__c,Opportunit__r.Owner.Centro_di_costo__c,Causale_ordine__r.Codice__c,Tipologia_Ordine__r.Codice__c,Condizioni_di_pagamento__r.Codice__c," + ;
	"Destinazione__r.Codice__c,Destinazione__r.Ragione_sociale__c,Destinazione__r.Indirizzo__Street__s,Destinazione__r.Indirizzo__PostalCode__s,Destinazione__r.Indirizzo__City__s,Destinazione__r.Indirizzo__StateCode__s," + ;
	"Destinazione__r.Indirizzo__CountryCode__s,Destinazione__r.All_attenzione_di__c,Destinazione__r.Note__c,Destinazione__r.Email__c,Destinazione__r.Id,Destinazione__r.Name,Numero_preordine_cliente__c,NSO__c," + ;
	"Porto__r.Codice__c,Mezzo__r.Codice__c,Banca__c,Descrizione_causale__c,Codice_CUP__c,Codice_CIG__c,Note_per_cliente__c,Stato_sincronizzazione__c,Errore_sync__c,Spese_di_trasporto_da_imputare__c,Numero_preventivo__c" + ;
	"+FROM+Preordine__c+WHERE+IsDeleted!=True+AND+Stato_sincronizzazione__c!='Sincronizzato'+AND+Cliente_Francia__c!=true+ORDER+BY+Name+ASC+NULLS+FIRST"

*!*	*#### TEST ###########################################################################
*!*	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Data_ordine__c,Account__c,Causale_ordine__c,Condizioni_di_pagamento__c,CurrencyIsoCode,Destinazione__c,Account__r.Codice_Cliente__c," + ;
*!*		"Opportunit__c,Tipologia_Ordine__c,Note_interne_per_spedizione__c,Opportunit__r.Owner.Centro_di_costo__c,Causale_ordine__r.Codice__c,Tipologia_Ordine__r.Codice__c,Condizioni_di_pagamento__r.Codice__c," + ;
*!*		"Destinazione__r.Codice__c,Destinazione__r.Ragione_sociale__c,Destinazione__r.Indirizzo__Street__s,Destinazione__r.Indirizzo__PostalCode__s,Destinazione__r.Indirizzo__City__s,Destinazione__r.Indirizzo__StateCode__s," + ;
*!*		"Destinazione__r.Indirizzo__CountryCode__s,Destinazione__r.All_attenzione_di__c,Destinazione__r.Note__c,Destinazione__r.Email__c,Destinazione__r.Id,Destinazione__r.Name,Numero_preordine_cliente__c,NSO__c," + ;
*!*		"Porto__r.Codice__c,Mezzo__r.Codice__c,Banca__c,Descrizione_causale__c,Codice_CUP__c,Codice_CIG__c,Note_per_cliente__c,Stato_sincronizzazione__c,Errore_sync__c" + ;
*!*		"+FROM+Preordine__c+WHERE+Id='a1HMf00000548iTMAQ'"
*!*	*#### TEST ###########################################################################		

		
_cJson = ""
_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione nuovi Pre-ordini Salesforce creati in corso..." NOWAIT

obj_json = json_decode(_cJson)

*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
	_cProperty = "OBJ_JSON.Array(1)._message"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_message = ALLTRIM(&_cProperty)
		WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'PRE_ORDINI' AND CODSYS = '" + _LOG_CODSYS + "' ORDER BY DATA DESC, ORA DESC"
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

_nr_PreOrdini = OBJ_JSON._totalSize

SELECT TMP_SF_PREORDINE__C
ZAP

IF _nr_PreOrdini > 0

	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_PREORDINE__C
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
			
			*** CAMPI RAMIFICATI IN OGGETTI DI SECONDO LIVELLO
			IF TYPE(_cProperty) == 'O' AND !ISNULL(&_cProperty) AND SUBSTR(ALLTRIM(gaPropArray(I_col)),1,1) = "_"
				DO CASE
					CASE UPPER(RIGHT(_cProperty,LEN("_ACCOUNT__R"))) == "_ACCOUNT__R"
						IF !ISNULL(EVALUATE(_cProperty+"._codice_cliente__c"))
							M.Account__r_Codice_Cliente__c = EVALUATE(_cProperty+"._codice_cliente__c")
						ENDIF
				
					CASE UPPER(RIGHT(_cProperty,LEN("_OPPORTUNIT__R"))) == "_OPPORTUNIT__R"
						IF !ISNULL(EVALUATE(_cProperty+"._owner._centro_di_costo__c"))
							M.Opportunit__r_Owner_Centro_di_costo__c = EVALUATE(_cProperty+"._owner._centro_di_costo__c")
						ELSE
							*M.Opportunit__r_Owner_Centro_di_costo__c = "DIR"
							M.Opportunit__r_Owner_Centro_di_costo__c = ""
						ENDIF
						
					CASE UPPER(RIGHT(_cProperty,LEN("_CAUSALE_ORDINE__R"))) == "_CAUSALE_ORDINE__R"
						IF !ISNULL(EVALUATE(_cProperty+"._codice__c"))
							M.Causale_ordine__r_Codice__c = EVALUATE(_cProperty+"._codice__c")
						ENDIF
						
					CASE UPPER(RIGHT(_cProperty,LEN("_TIPOLOGIA_ORDINE__R"))) == "_TIPOLOGIA_ORDINE__R"
						IF !ISNULL(EVALUATE(_cProperty+"._codice__c"))
							M.Tipologia_Ordine__r_Codice__c = EVALUATE(_cProperty+"._codice__c")
						ENDIF
						
					CASE UPPER(RIGHT(_cProperty,LEN("_CONDIZIONI_DI_PAGAMENTO__R"))) == "_CONDIZIONI_DI_PAGAMENTO__R"
						IF !ISNULL(EVALUATE(_cProperty+"._codice__c"))
							M.Condizioni_di_pagamento__r_Codice__c = EVALUATE(_cProperty+"._codice__c")
						ENDIF
						
					CASE UPPER(RIGHT(_cProperty,LEN("_DESTINAZIONE__R"))) == "_DESTINAZIONE__R"
						IF !ISNULL(EVALUATE(_cProperty+"._codice__c"))
							M.Destinazione__r_Codice__c = EVALUATE(_cProperty+"._codice__c")
						ENDIF
						IF !ISNULL(EVALUATE(_cProperty+"._ragione_sociale__c"))
							M.Destinazione__r_Ragione_sociale__c = EVALUATE(_cProperty+"._ragione_sociale__c")
						ENDIF
						IF !ISNULL(EVALUATE(_cProperty+"._indirizzo__street__s"))
							M.Destinazione__r_Indirizzo__Street__s = EVALUATE(_cProperty+"._indirizzo__street__s")
						ENDIF
						IF !ISNULL(EVALUATE(_cProperty+"._indirizzo__postalcode__s"))
							M.Destinazione__r_Indirizzo__PostalCode__s = EVALUATE(_cProperty+"._indirizzo__postalcode__s")
						ENDIF
						IF !ISNULL(EVALUATE(_cProperty+"._indirizzo__city__s"))
							M.Destinazione__r_Indirizzo__City__s = EVALUATE(_cProperty+"._indirizzo__city__s")
						ENDIF
						IF !ISNULL(EVALUATE(_cProperty+"._indirizzo__statecode__s"))
							M.Destinazione__r_Indirizzo__StateCode__s = EVALUATE(_cProperty+"._indirizzo__statecode__s")
						ENDIF
						IF !ISNULL(EVALUATE(_cProperty+"._indirizzo__countrycode__s"))
							M.Destinazione__r_Indirizzo__CountryCode__s = EVALUATE(_cProperty+"._indirizzo__countrycode__s")
						ENDIF
						IF !ISNULL(EVALUATE(_cProperty+"._all_attenzione_di__c"))
							M.Destinazione__r_All_attenzione_di__c = EVALUATE(_cProperty+"._all_attenzione_di__c")
						ENDIF
						IF !ISNULL(EVALUATE(_cProperty+"._note__c"))
							M.Destinazione__r_Note__c = EVALUATE(_cProperty+"._note__c")
						ENDIF
						IF !ISNULL(EVALUATE(_cProperty+"._email__c"))
							M.Destinazione__r_Email__c = EVALUATE(_cProperty+"._email__c")
						ENDIF
						IF !ISNULL(EVALUATE(_cProperty+"._id"))
							M.Destinazione__r_Id = EVALUATE(_cProperty+"._id")
						ENDIF
						IF !ISNULL(EVALUATE(_cProperty+"._name"))
							M.Destinazione__r_Name = EVALUATE(_cProperty+"._name")
						ENDIF
						
					CASE UPPER(RIGHT(_cProperty,LEN("_PORTO__R"))) == "_PORTO__R"
						IF !ISNULL(EVALUATE(_cProperty+"._codice__c"))
							M.Porto__r_Codice__c = EVALUATE(_cProperty+"._codice__c")
						ENDIF
						
					CASE UPPER(RIGHT(_cProperty,LEN("_MEZZO__R"))) == "_MEZZO__R"
						IF !ISNULL(EVALUATE(_cProperty+"._codice__c"))
							M.Mezzo__r_Codice__c = EVALUATE(_cProperty+"._codice__c")
						ENDIF	
				ENDCASE
			ENDIF
		NEXT
		
		SELECT TMP_SF_PREORDINE__C
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_PREORDINE__C
	GO TOP
	DO WHILE !EOF()			
		_Id_Preordine__c = ALLTRIM(Id)
		
		WAIT WINDOWS "Lettura ed elaborazione dettagli Pre-ordine Salesforce "+ALLTRIM(M.Name)+"..." NOWAIT

		_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Name,Codice_IVA__c,CurrencyIsoCode,Data_consegna__c,Descrizione_articolo__c,IsDeleted,Preordine__c," + ;
			"Prezzo_unitario__c,Prodotto__c,Quantit__c,Sconto__c,Prodotto__r.ProductCode,Codice_IVA__r.Codice__c,Note_interne__c,Voce_preventivo__c+" + ;
			"FROM+Riga_preordine__c+WHERE+IsDeleted!=True+AND+Preordine__c='"+_Id_Preordine__c+"'+ORDER+BY+Name+ASC+NULLS+FIRST"

		_cJson = ""
		_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
		IF EMPTY(_cJson)
			WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
			RETURN .F.
		ENDIF
		
		_act_set_point = SET("POINT")
		SET POINT TO "."
		
		_OLD_DECIMALS = SET("DECIMALS")
		SET DECIMALS TO 10
		
		obj_json = json_decode(_cJson)
		
		SET POINT TO _act_set_point

		*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
		IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
			_cProperty = "OBJ_JSON.Array(1)._message"
			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
				_message = ALLTRIM(&_cProperty)
				WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'PRE_ORDINI' AND CODSYS = '" + _LOG_CODSYS + "' ORDER BY DATA DESC, ORA DESC"
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
		
		SELECT TMP_SF_RIGA_PREORDINE__C
		ZAP
		
		_nr_RighePreOrdini = OBJ_JSON._totalSize
		_YES_DETT = .F.
		
		IF _nr_RighePreOrdini > 0

			FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
				
				SELECT TMP_SF_RIGA_PREORDINE__C
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
					
					*** CAMPI RAMIFICATI IN OGGETTI DI SECONDO LIVELLO
					IF TYPE(_cProperty) == 'O' AND !ISNULL(&_cProperty) AND SUBSTR(ALLTRIM(gaPropArray(I_col)),1,1) = "_"
						DO CASE
							CASE UPPER(RIGHT(_cProperty,LEN("_PRODOTTO__R"))) == "_PRODOTTO__R"
								IF !ISNULL(EVALUATE(_cProperty+"._productcode"))
									M.Prodotto__r_ProductCode = EVALUATE(_cProperty+"._productcode")
								ENDIF
								
							CASE UPPER(RIGHT(_cProperty,LEN("_CODICE_IVA__R"))) == "_CODICE_IVA__R"
								IF !ISNULL(EVALUATE(_cProperty+"._codice__c"))
									M.Codice_IVA__r_Codice__c = EVALUATE(_cProperty+"._codice__c")
								ENDIF
						ENDCASE
					ENDIF
				NEXT
				
				SELECT TMP_SF_RIGA_PREORDINE__C
				APPEND BLANK
				GATHER MEMVAR MEMO
				
			NEXT

			RELEASE obj_json
			
			SELECT TMP_SF_RIGA_PREORDINE__C
			GO TOP
			IF !EOF()
				_YES_DETT = .T.
			ENDIF
		ENDIF
		
		IF !_YES_DETT
			SELECT TMP_SF_PREORDINE__C
			SKIP +1
			LOOP
		ENDIF
		
		WAIT WINDOWS "Elaborazione per inserimento Ordine cliente in corso..." NOWAIT

		SELECT CU_ORD_TT
		SET FILTER TO
		SET ORDER TO
		ZAP

		SELECT CU_ORD_T2
		SET FILTER TO
		SET ORDER TO
		ZAP

		SELECT CU_ORD_DD
		SET FILTER TO
		SET ORDER TO
		ZAP
		
		SELECT TMP_SF_PREORDINE__C
		SCATTER MEMVAR MEMO
			
		*** VERIFICO ESISTENZA ORDINE
		x_codi = "SF_PREORDINE__C_ID = '" + ALLTRIM(M.ID) + "'"
		x_cond = x_codi
		cSql = "select TAGGANCIO from U_ORD_T2 where " + x_cond
		IF !ExecCommand(cSql,"CHK_ORD_T2")
		   RETURN .F.
		ENDIF  
		SELECT CHK_ORD_T2
		GO TOP
		IF !EOF()
			x_codi = "TAGGANCIO = '" + TAGGANCIO + "'"
			x_cond = x_codi
			cSql = "select * from U_ORD_TT where " + x_cond
			IF !ExecCommand(cSql,"CHK_ORD_TT")
			   RETURN .F.
			ENDIF  
			SELECT CHK_ORD_TT
			GO TOP
			IF !EOF()
				SELECT TMP_SF_PREORDINE__C
				SKIP +1
				LOOP
			ENDIF
		ENDIF
				
		SELECT CU_ORD_TT
		SCATTER MEMVAR MEMO BLANK
		
		*M.SF_PREORDINE__C_ID = ALLTRIM(M.ID)
		M.SF_PREORDINE__C_ID = _Id_Preordine__c  && ERASMO - 23/06/2025
		M.TAGGANCIO = STR(NEWPROG('NUMORD'),10)
		X_TAGG = M.TAGGANCIO
		M.ORD_CODSOC = PUB_CODSOC		
		M.ORD_DATORD = STRTRAN(SUBSTR(M.Data_ordine__c,1,10),"-","/")
		
		_YES_PUBBLICA_AMMINISTRAZIONE = .F.
		_OK_CLIENTE_AQ = .F.
		
*!*			x_cond = "U_ANA_CL.SF_ACCOUNT_ID = '" + ALLTRIM(M.Account__c) + "'"  && CERCO PER ID ACCOUNT SFDC MEMORIZZATO SU DB AQUARIUS
*!*			x_cond = x_cond + " AND U_CLI_AN.CLI_OBSOL <> 'S'"
*!*			cSql="select U_CLI_AN.CLI_CODCLI, U_CLI_AN.CLI_RAGSOC, U_ANA_CL.CLI_PA from u_cli_an left outer join u_ana_cl on u_cli_an.cli_codcli = u_ana_cl.cli_codcli where " + x_cond
*!*			IF !ExecCommand(cSql,"TMP_CLI_CL_AN")
*!*				return(.f.)
*!*			ENDIF
*!*			SELECT TMP_CLI_CL_AN
*!*			GO TOP
*!*			IF EOF()
*!*				x_cond = "U_CLI_AN.CLI_CODCLI = '" + ALLTRIM(M.Account__r_Codice_Cliente__c) + "'"  && IN ALTERNATIVA CERCO PER CODICE CLIENTE AQUARIUS
*!*				x_cond = x_cond + " AND U_CLI_AN.CLI_OBSOL <> 'S'"
*!*				cSql="select U_CLI_AN.CLI_CODCLI, U_CLI_AN.CLI_RAGSOC, U_ANA_CL.CLI_PA from u_cli_an left outer join u_ana_cl on u_cli_an.cli_codcli = u_ana_cl.cli_codcli where " + x_cond
*!*				IF !ExecCommand(cSql,"TMP_CLI_CL_AN")
*!*					return(.f.)
*!*				ENDIF
*!*				SELECT TMP_CLI_CL_AN
*!*				GO TOP
*!*			ENDIF
		
		IF EMPTY(M.Account__r_Codice_Cliente__c)
			M.Account__r_Codice_Cliente__c = LOOKUP_ACCOUNT_DA_ID(M.Account__c)
		ENDIF
		x_cond = "U_CLI_AN.CLI_CODCLI = '" + ALLTRIM(M.Account__r_Codice_Cliente__c) + "'"  && CERCO PER CODICE CLIENTE AQUARIUS
		*x_cond = x_cond + " AND U_CLI_AN.CLI_OBSOL <> 'S'"
		cSql="select U_CLI_AN.CLI_CODCLI, U_CLI_AN.CLI_RAGSOC, U_ANA_CL.CLI_PA from u_cli_an left outer join u_ana_cl on u_cli_an.cli_codcli = u_ana_cl.cli_codcli where " + x_cond
		IF !ExecCommand(cSql,"TMP_CLI_CL_AN")
			return(.f.)
		ENDIF
		SELECT TMP_CLI_CL_AN
		GO TOP

		IF !EOF()
			M.ORD_CODCLI = CLI_CODCLI
			_YES_PUBBLICA_AMMINISTRAZIONE = CLI_PA
			_includi_obsoleti = .T.
			M.ORD_CODCLI = seek_u_cli_an('',pub_codsoc+ALLTRIM(M.ORD_CODCLI),'cli_codcli','cli_codcli','','CUR_CLIENTE',_includi_obsoleti)
			IF EMPTY(M.ORD_CODCLI)
			ELSE
				_OK_CLIENTE_AQ = .T.
			ENDIF
		ENDIF
		
		IF !_OK_CLIENTE_AQ
*!*				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'PRE_ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
*!*				IF !ExecRW(cSql,"LOG_SFSYNC","R")
*!*				   return(.f.)
*!*				ENDIF
*!*				SELECT LOG_SFSYNC
*!*				GO TOP
*!*				IF !EOF()
*!*					REPLACE ESITO WITH "KO"
*!*					REPLACE MESSAGGIO WITH "Pre-ordine " + ALLTRIM(M.Name) + " - Cliente con ID SalesForce " + ALLTRIM(M.Account__c) + " e codice Aquarius '" + ALLTRIM(M.Account__r_Codice_Cliente__c) + ;
*!*						"' non trovato in anagrafica Aquarius"
*!*					_SEC_FIN = SECONDS()
*!*					REPLACE TEMPO_IMPIEGATO WITH ROUND(_SEC_FIN - _SEC_INI, 0)
*!*				ENDIF
*!*				IF !ExecRW(cSql,"LOG_SFSYNC","W")
*!*				   return(.f.)
*!*				ENDIF
*!*				
*!*				RETURN .F.
			
			_MESSAGGIO = "Pre-ordine " + ALLTRIM(M.Name) + " - Cliente con ID SalesForce " + ALLTRIM(M.Account__c) + " e codice Aquarius '" + ALLTRIM(M.Account__r_Codice_Cliente__c) + "' non trovato in anagrafica Aquarius"
			_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)+CHR(10)) + _MESSAGGIO
			
			=CONTRASSEGNA_PRE_ORDINE_SFDC(_Id_Preordine__c,.F.,_MESSAGGIO)
			
			SELECT TMP_SF_PREORDINE__C
			SKIP +1
			LOOP
		ENDIF
		
	*!*		_blocco_forn = VERIFICA_BLOCCO_FORNITURA_CLIENTE(M.ORD_CODCLI)
	*!*		IF _blocco_forn
	*!*		  	_cMsg = "ATTENZIONE" + CHR(13) + CHR(13) + "Cliente " + M.ORD_CODCLI + " con blocco fornitura in anagrafica" + CHR(13) + "impossibile creare ordini" + CHR(13) + "Fare click su OK per continuare"
	*!*		  	DO MESSAGGIO_STILE_WIN8 WITH _cMsg   
	*!*			DELETE FROM TMP_ORDERS WHERE CUSTOMER_ID = M.CUSTOMER_ID
	*!*			DELETE FROM TMP_ORDER_LINE_ITEMS WHERE CUSTOMER_ID = M.CUSTOMER_ID
	*!*			SELECT TMP_ORDERS
	*!*			LOOP
	*!*		ENDIF
		
		M.ORD_VALUTA = UPPER(ALLTRIM(M.CurrencyIsoCode))
		M.ORD_CAMBIO = 1
		IF M.ORD_VALUTA <> PUB_VALRIF
		   *** PRELEVA IL CAMBIO DEL GIORNO
		   x_soci = "vva_codsoc = '" + PUB_CODSOC + "'"
		   x_codi = "vva_codval = '" + M.ORD_VALUTA + "'"
		   x_data = "vva_data   = '" + M.ORD_DATORD + "'"
		   x_cond = x_soci + " and " + x_codi + " and " + x_data
		   cSql = "select * from u_vva_ch where " + x_cond + " order by vva_codsoc,vva_codval,vva_data"
		   IF !ExecCommand(cSql,"CUR_CAMBIO")
		      RETURN .F.
		   ENDIF  
		   SELECT CUR_CAMBIO
		   GO TOP
		   IF EOF()
		   ELSE
		      M.ORD_CAMBIO = VVA_CHANGE
		   ENDIF 
		ENDIF
		
		IF !PUB_NORD 				&& SE VERO NON GESTISCE IL NUMERO ORDINE CLIENTE
	      SS=SELECT()
	      _PUB_ANNO_SAVE = PUB_ANNO
	      PUB_ANNO = SUBSTR(M.ORD_DATORD,1,4)
	      v_seek   = ACCESS_YEAR('NUMORD'+PUB_CODSOC)
	      PUB_ANNO = _PUB_ANNO_SAVE
	      v_chiave = "codice"
	      cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
	      IF !ExecRW(cSql,"PARA","R")
	         return(.f.)
	      ENDIF
	      SELECT PARA
	      IF RECCOUNT() <> 0
	         V2=VAL(SUBSTR(LIBERA,1,7)) + 1
		     REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
	         M.ORD_NUMORD = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
	      ELSE
	         RIT = MSGBOX('Parametro numero ordine non trovato','ATTENZIONE',31)
	         SELECT(SS)
	         RETURN .F.
	      ENDIF
	      IF !ExecRW(cSql,"PARA","W")
	         return(.f.)
	      ENDIF
	      SELECT(SS)
	    ELSE
	      M.ORD_NUMORD = PADL(ALLTRIM(M.NUMBER),6,'0')
		ENDIF
		PUB_LNO      = 6
		M.ORD_NUMORD = TRC(PUB_LNO,ALLTRIM(M.ORD_NUMORD))
		M.ORD_NUMORC = ALLTRIM(M.Numero_preordine_cliente__c)
		M.ORD_RIFERI = "Pre-ordine SalesForce N. " + ALLTRIM(M.Name)
		M.ORD_ANNO   = SUBSTR(M.ORD_DATORD,1,4)
		M.TNUMERO    = M.ORD_NUMORD

	*!*		IF PUB_CTRCLOR
	*!*			__DATI_ANAGRAFICI_OBBLIGATORI = .F.
	*!*			__CAMPI_NON_CODIFICATI = ""
	*!*			__CAMPI_NON_CODIFICATI=CONTROLLO_DATI_ANAGRAFICI_OBBLIGATORI('CUR_CLIENTE')
	*!*			IF __DATI_ANAGRAFICI_OBBLIGATORI 
	*!*			  	_cMsg = "ATTENZIONE" + CHR(13) + CHR(13) + "Dati anagrafici incompleti :" + CHR(13) + ALLTRIM(__CAMPI_NON_CODIFICATI) + CHR(13) + "provvedere alla codifica " + CHR(13) + "Fare click su OK per continuare"
	*!*			  	DO MESSAGGIO_STILE_WIN8 WITH _cMsg   
	*!*			  	THISFORM.REFRESH
	*!*			    RETURN(.F.)
	*!*			ENDIF
	*!*		ENDIF

		SELECT CUR_CLIENTE
		
		M.ORD_DTCONS = RIBALTA2(DTOC(CTOD(RIBALTA2(M.ORD_DATORD)) + PUB_GGCONS))
		M.ORD_CODBUN = PUB_CODBUN
		M.ORD_RAGSOC = CLI_RAGSOC
		M.ORD_INDIRI = CLI_INDIR
		M.ORD_CAP	 = CLI_CAP
		M.ORD_LOCALI = CLI_LOCALI
		M.ORD_PROVIN = CLI_PROVIN    
		M.ORD_PARIVA = DECODIFICA_PARTITA_IVA_CEE_INTRASTAT(CLI_PARIVA,CLI_IVACEE)		&& SE NON CODIFICATA LA PARTITA IVA VERIFICA SE E' UNA PARTITA IVA CEE 
		*** SE PARTITA IVA / PARTITA IVA CEE ENTRAMBE VUOTE, ED IL CODICE FISCALE NON E' VUOTO, INSERISCO IL CODICE FISCALE
		IF EMPTY(M.ORD_PARIVA) AND !EMPTY(CLI_CODFIS)
			M.ORD_PARIVA = CLI_CODFIS
		ENDIF
		M.ORD_FAX    = CLI_FAX
		M.ORD_CDIMBA = CLI_CODIMB
		__DTCLOK     = CLI_DTCLOK
		M.ORD_EVATOT = CLI_EVATOT	
		M.ORD_ORDDDT = CLI_ORDDDT	
		RELEASE _FIDO
		PUBLIC _FIDO
		_fido=CLI_IMPFID
		M.ORD_CODLOC = ""
		_YES_RIBA = .F.
		IF !ExecCommand("select LIBERA from para where codice = 'CPA" + ALLTRIM(M.ORD_CPA) + "'","TMP_PARA")
			return
		ENDIF
		SELECT TMP_PARA
		GO TOP
		IF !EOF()
			IF SUBSTR(LIBERA,10,1) = 'X'
				_YES_RIBA = .T.
			ENDIF
		ENDIF
		SELECT cur_cliente
		IF _YES_RIBA
			M.ORD_BANCA = CLI_BAE
		ELSE
			M.ORD_BANCA = CLI_BAEFOR
			IF !EMPTY(ALLTRIM(M.Banca__c))
				M.ORD_BANCA = ALLTRIM(M.Banca__c)
			ENDIF
		ENDIF
		
		M.ORD_CODNAZ = CLI_NAZION
		IF EMPTY(M.ORD_CODNAZ)
		   M.ORD_CODNAZ	= "ITA"
		ENDIF  
	*!*		M.ORD_CAUS = PUB_ORDIN
	*!*		IF PUB_CLIDIR
	*!*		   IF CLI_FLGDIR
	*!*		      M.ORD_CAUS = PUB_CAUDIR
	*!*		   ENDIF
	*!*		ENDIF
		M.ORD_FLGABP     = CLI_FLGABP
		M.ORD_AGE        = CLI_AGE
		IVA_ESE          = CLI_ALRID
		IVA_CLI          = CLI_CODIVA
		M.ORD_PRORIT     = CLI_PROVVI
		M.ORD_SC1T       = 0
		M.ORD_SC2T       = 0
		M.ORD_SC3T       = 0
		M.ORD_CLIFAT     = CLI_CODDIR
		M.ORD_RAGFAT     = CLI_RAGDIR
		M.ORD_SPBOLL	 = CLI_SPINCA   
		*M.ORD_SPTRAS	 = CLI_SPTRAS  
		DL_LINGUA        = CLI_LINGUA
		M.ORD_CCOSTO     = ALLTRIM(M.Opportunit__r_Owner_Centro_di_costo__c)
		IF EMPTY(ALLTRIM(M.ORD_CCOSTO))
			M.ORD_CCOSTO = CLI_CCOST1
		ENDIF
		M.ORD_CDIMBA     = CLI_CODIMB
		M.ORD_ACURA      = ALLTRIM(M.Mezzo__r_Codice__c)
		M.ORD_PORTO      = ALLTRIM(M.Porto__r_Codice__c)
		*M.ORD_VETTO1     = CLI_VETTO1
		*M.ORD_VETTO1     = ""
		M.ORD_VETTO1     = CLI_VETTO1  && ERASMO - 10/07/2025
		
		M.ORD_FECAUS     = ALLTRIM(M.Descrizione_causale__c)
		M.ORD_CUP        = ALLTRIM(M.Codice_CUP__c)
		M.ORD_CIG        = ALLTRIM(M.Codice_CIG__c)
		M.ORD_NOTEEVA	 = ALLTRIM(M.Note_interne_per_spedizione__c)
		M.ORD_NOTEEV2    = ALLTRIM(M.Note_per_cliente__c)
		
		M.ORD_CAUS		 = ALLTRIM(M.Causale_ordine__r_Codice__c)
		M.ORD_TIPOLOGIA	 = ALLTRIM(M.Tipologia_Ordine__r_Codice__c)
		*M.ORD_SPTIMP     = "SI"
		*M.ORD_SPTIMP     = "NO"
		M.ORD_SPTIMP     = ALLTRIM(M.Spese_di_trasporto_da_imputare__c)  && ERASMO - 20/06/2025
		M.ORD_CONPRZ     = "NO"
		M.ORD_CPA	     = UPPER(ALLTRIM(M.Condizioni_di_pagamento__r_Codice__c))
					  
		_SPBOLL_ = CALCOLA_SPESE_INCASSO(M.ORD_CPA)
		IF PUB_CALCOLA_SPESE_INCASSO_RIBA
			M.ORD_SPBOLL = _SPBOLL_
		ENDIF
		
		M.ORD_SPTRAS = 0
		
		x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "cli_codcli = '" + M.ORD_CODCLI + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "select * from u_ana_cl where " + x_cond + " order by cli_codsoc,cli_codcli"
		IF !ExecCommand(cSql,"CUR_U_ANA_CL")
		    RETURN .F.
		ENDIF
		SELECT CUR_U_ANA_CL
		GO TOP
		IF !EOF()
			__ORD_SERV_INTRA_CLIENTE = CLI_SERVINTRA
			PUB_NOINCA = CLI_NOINCA
			M.ORD_NOPOLIEC = CLI_NOPOLIEC
			M.ORD_SCASSA = CLI_SCASSA
			M.ORD_IDNSO = CLI_IDNSO
			M.ORD_IDSDI = CLI_IDSDI
		ELSE
			__ORD_SERV_INTRA_CLIENTE = ""
			PUB_NOINCA = .F.
		ENDIF
		
		IF !EMPTY(ALLTRIM(M.NSO__c))
			M.ORD_IDNSO = ALLTRIM(M.NSO__c)
		ENDIF
		   
		*thisformset.cerca_conti_centri_di_costo_testata()
		SELECT cur_cliente
		*PUB_PAESE = CERCA_TIPOLOGIA_PAESE_E_NAZIONE_INTRASTAT(CLI_NAZION)
		
		v_seek	= 'FPS-NO-EMAIL'
		v_chiave = "codice"
		IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
		   SELECT CUR_PARA
		   IF SUBSTR(LIBERA,1,5) = 'FORZA'
		   	 M.ORD_CODEMI = PUB_CLISOC
		     M.ORD_RAGEMI = PUB_RAGSOC
		     M.ORD_MAGS   = PUB_CODM
		     M.ORD_TIPORD = 'BO '
		     M.ORD_NUMTRX = '1     '
		     M.ORD_DATTRX = DTOC(DATE()-1)
		     M.ORD_ORATRX = '18:00'
		     M.ORD_DATRCX = DTOC(DATE())
		     M.ORD_ORARCX = '09:00'
		   ENDIF
		ENDIF
		
		M.ORD_MAGS = PUB_CODM
		
		*M.ORD_CODLOC = ALLTRIM(M.Destinazione__r_Codice__c)
		M.ORD_CODLOC = ALLTRIM(M.Destinazione__r_Name)  && ERASMO - 20/06/2025
		M.ORD_RAGC = ALLTRIM(M.Destinazione__r_Ragione_sociale__c)
		M.ORD_INDC = ALLTRIM(M.Destinazione__r_Indirizzo__Street__s)
		M.ORD_CAPC = ALLTRIM(M.Destinazione__r_Indirizzo__PostalCode__s)
		M.ORD_LOCC = ALLTRIM(M.Destinazione__r_Indirizzo__City__s)
		M.ORD_PROC = ALLTRIM(M.Destinazione__r_Indirizzo__StateCode__s)
		*M.ORD_NAZC = 
	    M.ORD_DSNAZC = UPPER(APITOSPA(ALLTRIM(M.Destinazione__r_Indirizzo__CountryCode__s)))
		IF M.ORD_DSNAZC == "ITALIA" OR M.ORD_DSNAZC == "IT"
			M.ORD_DSNAZC = "ITALIA"
		ELSE
			M.ORD_DSNAZC = ""
			IF !EMPTY(ALLTRIM(M.ORD_DSNAZC))
				x_cond = "codice LIKE 'STA%' AND UPPER(libera) = '" + M.ORD_DSNAZC + "'"
				cSql   = "select substring(codice,4,3) AS COD_NAZIONE_AQ, DESCRI from para where " + x_cond 
				IF !ExecCommand(cSql,"TMP_PARA")
				   return(.f.)
				ENDIF
				SELECT TMP_PARA
				GO TOP
				IF !EOF()
					M.ORD_DSNAZC = DESCRI
				ENDIF
			ENDIF
		ENDIF
		M.ORD_ATTENZIONE = ALLTRIM(M.Destinazione__r_All_attenzione_di__c)
		M.ORD_VARIE = ALLTRIM(M.Destinazione__r_Note__c)
	    IF !EMPTY(ALLTRIM(M.Destinazione__r_Email__c))
	    	M.ORD_ATTENZIONE = ALLTRIM(M.ORD_ATTENZIONE) + IIF(EMPTY(M.ORD_ATTENZIONE),""," - ") + APITOSPA("Email: " + ALLTRIM(M.Destinazione__r_Email__c))
	    ENDIF
	    *M.ORD_NOTEEV2 = ""
	    
	    *** EVENTUALE INSERIMENTO NUOVA LOCALITA' DI CONSEGNA
	    IF EMPTY(ALLTRIM(M.ORD_CODLOC)) AND !EMPTY(ALLTRIM(M.Destinazione__r_Id))
	    	M.ORD_CODLOC = INSERISCE_U_LOC_AN_SFDC()
	    ENDIF
		
	*!*		IF M.ORD_CODLOC = SPACE(03) .OR. EMPTY(M.ORD_CODLOC)
	*!*		ELSE
	*!*		   x_soci = "loc_codsoc = '" + PUB_CODSOC + "'"
	*!*		   x_tipo = "loc_cf = 'C'"
	*!*		   x_codi = "loc_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
	*!*		   x_loca = "loc_codloc = '" + ALLTRIM(M.ORD_CODLOC) + "'"
	*!*		   x_cond = x_soci + " and " + x_tipo + " and " + x_codi + " and " + x_loca
	*!*		   Csql   = "select * from u_loc_an where " + x_cond + " order by loc_codsoc,loc_cf,loc_codcli,loc_codloc"
	*!*		   IF !ExecCommand(cSql,"cur_localita")
	*!*		      return(.f.)
	*!*		   ENDIF
	*!*		   SELECT cur_localita
	*!*		   GO TOP
	*!*		   IF EOF()
	*!*		   ELSE
	*!*		      M.ORD_RAGC 		= LOC_RAGSOC
	*!*		      M.ORD_INDC 		= LOC_INDIRI
	*!*		      M.ORD_CAPC 		= LOC_CAP
	*!*		      M.ORD_LOCC 		= LOC_LOCALI
	*!*		      M.ORD_PROC 		= LOC_PROVIN
	*!*		      M.ORD_DSNAZC 		= LOC_DESNAZ  && ERASMO - 20/03/2015
	*!*		      M.ORD_ATTENZIONE 	= LOC_ATTENZIONE		
	*!*		      M.ORD_VARIE 		= LOC_VARIE				
	*!*		      _SAVE_ORD_CAPC 	= M.ORD_CAPC
	*!*		      _SAVE_ORD_PROC 	= M.ORD_PROC      
	*!*		   ENDIF 
	*!*		ENDIF
	
		**=> ERASMO - INIZIO 13/05/2025
		*** SE VUOTO IL CODICE LOCALITA' DI CONSEGNA, SETTO L'INDIRIZZO DI FATTURAZIONE
		IF EMPTY(ALLTRIM(M.ORD_CODLOC))		
			M.ORD_RAGC = ALLTRIM(M.ORD_RAGSOC)
			M.ORD_INDC = ALLTRIM(M.ORD_INDIRI)
			M.ORD_CAPC = ALLTRIM(M.ORD_CAP)
			M.ORD_LOCC = ALLTRIM(M.ORD_LOCALI)
			M.ORD_PROC = ALLTRIM(M.ORD_PROVIN)
			
			IF SUBSTR(ALLTRIM(M.ORD_CODNAZ),1,2) = 'IT'
				M.ORD_DSNAZC = "ITALIA"
			ELSE
				M.ORD_DSNAZC = ""
				x_cond = "codice = 'STA" + M.ORD_CODNAZ + "'"
				cSql   = "select DESCRI from para where " + x_cond 
				IF !ExecCommand(cSql,"TMP_PARA")
				   return(.f.)
				ENDIF
				SELECT TMP_PARA
				GO TOP
				IF !EOF()
					M.ORD_DSNAZC = ALLTRIM(DESCRI)
				ENDIF
			ENDIF
		ENDIF
		**=> ERASMO - FINE 13/05/2025
		
		M.ORD_NUMOFC = ALLTRIM(M.Numero_preventivo__c)  && ERASMO - 07/10/2025		
	    	    
		SELECT CU_ORD_TT
		APPEND BLANK
		GATHER MEMVAR MEMO
		
		SELECT CU_ORD_T2
		APPEND BLANK
		GATHER MEMVAR MEMO
		
*!*			_OLD_DECIMALS = SET("DECIMALS")
*!*			SET DECIMALS TO 10
		
		*** DETTAGLI ORDINE
		_NEW_SEQUEN = 0
		_LEGAME_BUNDLE_ART_PREC = ""
		_CODSYS_BUNDLE = ""
		SELECT TMP_SF_RIGA_PREORDINE__C
		GO TOP
		SCAN
		
			SELECT CU_ORD_DD
			SCATTER MEMVAR MEMO BLANK
			
			SELECT TMP_SF_RIGA_PREORDINE__C
			SCATTER MEMVAR MEMO
			
			IF ALLTRIM(M.Prodotto__r_ProductCode) = "Commento"
				_LEGAME_BUNDLE_ART_PREC = ALLTRIM(M.Voce_preventivo__c)
				_CODSYS_BUNDLE = SYS(2015)
				
				M.DAGGANCIO  = X_TAGG	
				M.ORD_CODART = ""
				M.ORD_DESART = "*** COMMENTO ***"
				M.ORD_CODSYS = _CODSYS_BUNDLE
				M.ORD_QTAORD = 0
				M.ORD_UM	 = ""
				*M.ORD_NOTE	 = ALLTRIM(M.Note_interne__c)
				M.ORD_NOTE	 = ALLTRIM(M.Descrizione_articolo__c)
				IF !EMPTY(ALLTRIM(M.Note_interne__c))
					M.ORD_NOTE = ALLTRIM(M.ORD_NOTE) + CHR(13)+CHR(10) + ALLTRIM(M.Note_interne__c)
				ENDIF
				M.ORD_NOTEBO = ""
				_NEW_SEQUEN  = _NEW_SEQUEN + 10
				M.ORD_SEQUEN = _NEW_SEQUEN
				
				M.ORS_NUMORD = M.ORD_NUMORD
				M.ORS_DATORD = M.ORD_DATORD
				M.ORS_MAGS   = M.ORD_MAGS
				M.ORS_MAGD   = M.ORD_MAGD
				M.ORS_CODCLI = M.ORD_CODCLI
				M.ORS_RAGSOC = M.ORD_RAGSOC
				M.ORS_CODEMI = M.ORD_CODEMI
				M.ORS_RAGEMI = M.ORD_RAGEMI
				M.ORS_TIPORD = M.ORD_TIPORD
				M.ORS_FLGABP = M.ORD_FLGABP

				SELECT CU_ORD_DD
				APPEND BLANK
				GATHER MEMVAR MEMO
				
				SELECT TMP_SF_RIGA_PREORDINE__C
				LOOP
			
			ENDIF
			
			M.ORD_CODART = APITOSPA(ALLTRIM(M.Prodotto__r_ProductCode))
			*M.ORD_QTAORD = VAL(STRTRAN(M.Quantit__c,'.',','))
			M.ORD_QTAORD = VAL(STRTRAN(ALLTRIM(M.Quantit__c),'.',','))  && ERASMO - 21/07/2025
			M.DAGGANCIO = X_TAGG
			
			IF !ExecCommand("select ART_CODMAT, ART_DESCR, ART_UMMAGA from U_ART_PR where ART_CODPRI = '" + ALLTRIM(M.ORD_CODART) + "'","TMP_ART_PR")
			   RETURN .F.
			ENDIF
			SELECT TMP_ART_PR
			GO TOP
			IF EOF()
				SELECT TMP_SF_RIGA_PREORDINE__C
				LOOP
			ENDIF
			
			DO PRE_ORDINE_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD
			
		ENDSCAN
		
		SET DECIMALS TO _OLD_DECIMALS
		
		U_CANCELLA = .T.
		PUB_DAGGANCIO = M.TAGGANCIO
		=CREA_NOTE_CLIENTE("ORD",M.ORD_CODCLI,"CU_ORD_DD",PUB_DAGGANCIO,M.ORD_PESNET)
		PUB_DAGGANCIO = ""
		DO GESTIONE_ARTICOLI_AUTOMATICI WITH "ORD",M.ORD_CODCLI,"CU_ORD_DD"
		DO GESTIONE_ARTICOLO_SCONTO_CASSA WITH "ORD",M.ORD_CODCLI,"CU_ORD_DD",.F.,"M.ORD_SCASSA"
		
*!*			*** INSERISCO RIFERIMENTO E-MAIL PER SPEDIZIONIERE COME COMMENTO NEI DETTAGLI ORDINE
*!*		    SELECT CU_ORD_DD
*!*		    GO TOP
*!*		    SCATTER MEMVAR MEMO BLANK
*!*		    APPEND BLANK
*!*		    M.DAGGANCIO  = X_TAGG
*!*			_NEW_SEQUEN  = _NEW_SEQUEN + 10
*!*			M.ORD_SEQUEN = _NEW_SEQUEN
*!*			M.ORD_DESART = "*** COMMENTO ***"
*!*			M.ORD_NOTE   = "QUANTUM VIEW: " + ALLTRIM(M.shipping_email)
*!*			M.ORD_CODSYS = SYS(2015)
*!*		    GATHER MEMVAR MEMO
*!*			
		* RICALCOLA IL VALORE DEL DOCUMENTO
		SELECT CU_ORD_DD
		SET FILTER TO DAGGANCIO = X_TAGG AND ORD_FLGMOD <> 'A'	 
		DO CALCORD
		SET FILTER TO
		
		SELECT CU_ORD_TT
		REPLACE ORD_VALORE WITH M.ORD_VALORE
		REPLACE ORD_IMPONIB WITH M.ORD_IMPONIB 
		REPLACE ORD_IMPOSTA WITH M.ORD_IMPOSTA 
		
		IF !EMPTY(M.ORD_DATCON)
			REPLACE ORD_DTCONS WITH M.ORD_DATCON
		ENDIF
		
*!*			REPLACE ORD_NOTEEVA WITH "QUANTUM VIEW: " + ALLTRIM(M.shipping_email)

		IF !ExecRW('','U_ORD_TT','I','','CU_ORD_TT')
		   return(.f.)
		ENDIF

		IF !ExecRW('','U_ORD_T2','I','','CU_ORD_T2')
		   return(.f.)
		ENDIF

		IF !ExecRW('','U_ORD_DD','I','','CU_ORD_DD')
		   return(.f.)
		ENDIF
		
		=CONTRASSEGNA_PRE_ORDINE_SFDC(_Id_Preordine__c,.T.,"")
		
		_CONTA_INS_DA_SF = _CONTA_INS_DA_SF + 1
		
		*RELEASE obj_json
		SELECT TMP_SF_PREORDINE__C
		SKIP +1
		LOOP
	ENDDO
ENDIF



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
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'PRE_ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
IF _CONTA_INS_DA_SF > 0
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale Pre-ordini inseriti da Salesforce: " + ALLTRIM(STR(_CONTA_INS_DA_SF))
ELSE
	_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun Pre-ordine inserito da Salesforce"
ENDIF
*!*	IF _CONTA_AGG_DA_SF > 0
*!*		_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Totale PRE_ORDINI aggiornati da Salesforce: " + ALLTRIM(STR(_CONTA_AGG_DA_SF))
*!*	ELSE
*!*		_MESSAGGIO = _MESSAGGIO + IIF(EMPTY(_MESSAGGIO),"",CHR(13)+CHR(10)) + "Nessun cliente aggiornato da Salesforce"
*!*	ENDIF

cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'PRE_ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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

_OK_SYNC_PRE_ORDINI = .T.
			
RETURN .T.


*!*	**********************************************************************
*!*	FUNCTION LOOKUP_USER
*!*	**********************************************************************
*!*	LPARAMETERS _par_ccosto

*!*	IF PCOUNT() >= 1
*!*	ELSE
*!*		RETURN ""
*!*	ENDIF

*!*	_RIT = ""

*!*	_Centro_di_costo__c = ALLTRIM(_par_ccosto)

*!*	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Address,Centro_di_costo__c,Email,FirstName,LastName+FROM+User+WHERE+Centro_di_costo__c='"+_Centro_di_costo__c +"'"

*!*	*!*	IF "&" $ _Centro_di_costo__c
*!*	*!*		_Descr_Centro_di_costo__c = ""
*!*	*!*		cSql = "select TOP 1 * from CCOSTO WHERE CON_CONTO = '"+_Centro_di_costo__c+"' ORDER BY CON_ANNO DESC"
*!*	*!*		IF !ExecCommand(cSql,"TMP_CCOSTO")
*!*	*!*		   return(.f.)
*!*	*!*		ENDIF
*!*	*!*		SELECT TMP_CCOSTO
*!*	*!*		GO TOP
*!*	*!*		IF !EOF()
*!*	*!*			_Descr_Centro_di_costo__c = ALLTRIM(CON_DESCR)
*!*	*!*			_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Address,Centro_di_costo__c,Email,FirstName,LastName+FROM+User+WHERE+Name='"+_Descr_Centro_di_costo__c+"'"
*!*	*!*		ENDIF
*!*	*!*	ENDIF

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
*!*			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'PRE_ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
*!*			IF !ExecRW(cSql,"LOG_SFSYNC","R")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT LOG_SFSYNC
*!*			GO TOP
*!*			IF !EOF()
*!*				REPLACE ESITO WITH "KO"
*!*				REPLACE MESSAGGIO WITH "Cliente Aquarius " + _CLI_RAGSOC + " - " + _message
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


**********************************************************************
FUNCTION LOOKUP_ACCOUNT_DA_ID
**********************************************************************
LPARAMETERS _par_id_account

IF PCOUNT() >= 1
ELSE
	RETURN ""
ENDIF

_L_SELECT = SELECT()  && ERASMO - 17/03/2025

_RIT = ""

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,Codice_Cliente__c+FROM+Account+WHERE+Id='"+ALLTRIM(_par_id_account)+"'"

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
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'PRE_ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
		IF !ExecRW(cSql,"LOG_SFSYNC","R")
		   return(.f.)
		ENDIF
		SELECT LOG_SFSYNC
		GO TOP
		IF !EOF()
			REPLACE ESITO WITH "KO"
			REPLACE MESSAGGIO WITH "Cliente con Id " + ALLTRIM(_par_id_account)+ " non trovato in tabella SFDC Account"
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
		IF TYPE(_cProperty) == 'C'
			_RIT = ALLTRIM(&_cProperty)
		ENDIF
	ENDIF
NEXT

RELEASE obj_json

SELECT(_L_SELECT)  && ERASMO - 17/03/2025

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
FUNCTION INSERISCE_U_LOC_AN_SFDC
**********************************************************************
_L_SELECT = SELECT()  && ERASMO - 17/03/2025
_RIT = ""

_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/query/?q=SELECT+Id,LastModifiedDate,Name,Cliente__c,Ragione_sociale__c,All_attenzione_di__c,Indirizzo__City__s,Indirizzo__Street__s,Indirizzo__PostalCode__s," + ;
	"Indirizzo__StateCode__s,Indirizzo__CountryCode__s,Email__c,Note__c,ExternalId__c+FROM+Destinazione__c+WHERE+Id='" + ALLTRIM(M.Destinazione__r_Id) + "'"

_cJson = ""
_cJson = SALESFORCEREST_GET(_HTTP_request,_access_token,"","")
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_L_SELECT)  && ERASMO - 17/03/2025
	RETURN ""
ENDIF

WAIT WINDOWS "Elaborazione nuova Località di consegna inserita su SalesForce in corso..." NOWAIT

obj_json = json_decode(_cJson)

*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
	_cProperty = "OBJ_JSON.Array(1)._message"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_message = ALLTRIM(&_cProperty)
		WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		
		cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'PRE_ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
		SELECT(_L_SELECT)  && ERASMO - 17/03/2025
		RETURN .F.
	ENDIF
ENDIF

SELECT TMP_SF_DESTINAZIONE__C
ZAP

IF OBJ_JSON._totalSize > 0

	FOR I_row = 1 TO ALEN(OBJ_JSON._RECORDS.Array,1)
		
		SELECT TMP_SF_DESTINAZIONE__C
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
		
		SELECT TMP_SF_DESTINAZIONE__C
		APPEND BLANK
		GATHER MEMVAR MEMO
		
	NEXT

	RELEASE obj_json
	
	SELECT TMP_SF_DESTINAZIONE__C
	GO TOP
		
	SCATTER MEMVAR MEMO
	
	cSql = "SELECT * FROM U_LOC_AN WHERE 1=0"
	IF !ExecCommand(cSql,"TMP_LOC_AN")
		return(.f.)
	ENDIF
	SELECT TMP_LOC_AN
	SCATTER MEMVAR MEMO BLANK
	
	M.SF_LOC_ID = M.ID
	M.SF_LASTMODIFIEDDATE = M.LASTMODIFIEDDATE
	M.LOC_CODCLI = ""
	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_sfid = "sf_account_id = '" + ALLTRIM(M.Cliente__c) + "'"
	x_cond = x_soci + " and " + x_sfid 
	cSql = "select CLI_CODCLI from U_ANA_CL where " + x_cond
	IF !ExecCommand(cSql,"CX_ANA_CL")
	   RETURN .F.
	ENDIF
	SELECT CX_ANA_CL
	GO TOP
	IF !EOF()
		M.LOC_CODCLI = ALLTRIM(CLI_CODCLI)
	ELSE
		WAIT WINDOWS SUBSTR("Warning: Cliente SalesForce con ID "+ALLTRIM(M.Cliente__c)+" non trovato in anagrafica Aquarius, pertanto non verrà considerato in questa elaborazione",1,254) TIMEOUT 2
		_MSG_WARNINGS = ALLTRIM(_MSG_WARNINGS) + IIF(EMPTY(_MSG_WARNINGS),"",CHR(13)) + ;
			"Warning: Cliente SalesForce con ID "+ALLTRIM(M.Cliente__c)+" non trovato in anagrafica Aquarius, pertanto non verrà considerato in questa elaborazione"
		SELECT(_L_SELECT)
		RETURN ""
	ENDIF
	M.LOC_CODLOC = ""
	_NEW_CODLOC = "001"
	x_soci = "loc_codsoc = '" + PUB_CODSOC + "'"
	x_ccff = "loc_cf = 'C'"
	x_clie = "loc_codcli = '" + M.LOC_CODCLI + "'"
	x_cond = x_soci + " and " + x_ccff + " and " + x_clie
	cSql = "select loc_codloc from u_loc_an where " + x_cond + " order by loc_codloc desc"
	IF !ExecCommand(cSql,"CX_LOC_AN")
	   RETURN .F. 
	ENDIF
	SELECT CX_LOC_AN
	GO TOP
	IF EOF()
		_NEW_CODLOC = "001"
	ELSE
		SELECT MAX(VAL(loc_codloc)) AS N_CODLOC FROM CX_LOC_AN INTO CURSOR CN_LOC_AN
		SELECT CN_LOC_AN
		GO TOP
		IF !ISNULL(N_CODLOC)
			_nUltCodLoc = N_CODLOC
			IF _nUltCodLoc > 0
				_NEW_CODLOC = TRC(3,ALLTRIM(STR(_nUltCodLoc + 1,3,0)))
			ELSE
				_NEW_CODLOC = ""
			ENDIF
		ELSE
			_NEW_CODLOC = ""
		ENDIF
	ENDIF
	M.LOC_CF = "C"
	M.LOC_CODLOC = _NEW_CODLOC
	M.LOC_RAGSOC = APITOSPA(ALLTRIM(M.Ragione_sociale__c))
	M.LOC_ATTENZIONE = APITOSPA(ALLTRIM(M.All_attenzione_di__c))
	M.LOC_LOCALI = APITOSPA(ALLTRIM(M.Indirizzo__City__s))
	M.LOC_INDIRI = APITOSPA(ALLTRIM(M.Indirizzo__Street__s))
	M.LOC_CAP = APITOSPA(ALLTRIM(M.Indirizzo__PostalCode__s))
	M.LOC_PROVIN = APITOSPA(ALLTRIM(M.Indirizzo__StateCode__s))
	M.LOC_CODNAZ = ""
	IF !EMPTY(UPPER(ALLTRIM(M.Indirizzo__CountryCode__s)))
		x_cond = "codice LIKE 'STA%' AND libera = '" + UPPER(ALLTRIM(M.Indirizzo__CountryCode__s)) + "'"
		cSql   = "select substring(codice,4,3) AS COD_NAZIONE_AQ from para where " + x_cond 
		IF !ExecCommand(cSql,"TMP_PARA")
		   return(.f.)
		ENDIF
		SELECT TMP_PARA
		GO TOP
		IF !EOF()
			M.LOC_CODNAZ = COD_NAZIONE_AQ
		ENDIF
	ENDIF
	M.LOC_EMAIL = ALLTRIM(M.Email__c)
	M.LOC_VARIE = ALLTRIM(M.Note__c)
	
	M.LOC_CODSOC = PUB_CODSOC
	M.SF_LOC_ID = M.ID
	M.SF_LASTMODIFIEDDATE = M.LASTMODIFIEDDATE
	
	cSql = "SELECT * FROM U_LOC_AN WHERE 1=0"
	IF !ExecRW(cSql,"U_LOC_AN","R")
		return(.f.)
	ENDIF
	SELECT U_LOC_AN
	APPEND BLANK
	DO U_LOC_AN
	IF !ExecRW(cSql,"U_LOC_AN","W")
		return(.f.)
	ENDIF
	
	*** AGGIORNAMENTO CODICE LOCALITA' E EXTERNAL_ID SU SALESFORCE
	
	_json_content = '{'
	_json_content = _json_content + '"Name": "' + ALLTRIM(M.LOC_CODLOC) + '"'
	_json_content = _json_content + ', "ExternalId__c": "' + ALLTRIM(M.LOC_CODCLI)+ALLTRIM(M.LOC_CODLOC) + '"'
	_json_content = _json_content + '}'
			
	*** AGGIORNAMENTO CAMPI SU SALESFORCE
	_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Destinazione__c/"+ALLTRIM(M.SF_LOC_ID)
	_cJson = ""

	_cJson = SALESFORCEREST_PATCH(_HTTP_request,_access_token,_json_content)
	IF EMPTY(_cJson)
		WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
		SELECT(_L_SELECT)  && ERASMO - 17/03/2025
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
				
				cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'PRE_ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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
				SELECT(_L_SELECT)  && ERASMO - 17/03/2025
				RETURN .F.
			ENDIF
		ENDIF
	
	ENDIF
	
	_RIT = M.LOC_CODLOC
	
	_CONTA_LOC_INS_DA_SF = _CONTA_LOC_INS_DA_SF + 1
	
	RELEASE obj_json
		
ENDIF

SELECT(_L_SELECT)  && ERASMO - 17/03/2025

RETURN _RIT

ENDFUNC


*************************************************************
PROCEDURE PRE_ORDINE_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD
*************************************************************
*!*		Id C(254), ;
*!*		Name C(254), ;
*!*		Codice_IVA__c C(254), ;
*!*		CurrencyIsoCode C(254), ;
*!*		Data_consegna__c C(254), ;
*!*		Descrizione_articolo__c C(254), ;
*!*		IsDeleted C(254), ;
*!*		Preordine__c C(254), ;
*!*		Prezzo_unitario__c C(254), ;
*!*		Prodotto__c C(254), ;
*!*		Quantit__c C(254), ;
*!*		Sconto__c C(254))
*!*		Prodotto__r_ProductCode C(254), ;
*!*		Codice_IVA__r_Codice__c C(254))

M.ORD_PARENT = 0
*M.ORD_PREZZO = VAL(STRTRAN(M.Prezzo_unitario__c,'.',','))
*M.ORD_SC1 = VAL(STRTRAN(M.Sconto__c,'.',','))
M.ORD_PREZZO = VAL(STRTRAN(ALLTRIM(M.Prezzo_unitario__c),'.',','))  && ERASMO - 21/07/2025
M.ORD_SC1 = VAL(STRTRAN(ALLTRIM(M.Sconto__c),'.',','))  			&& ERASMO - 21/07/2025

*!*	*######################################################### TEST ##########################
*!*	lsFile = SYS(5)+SYS(2003)+"\Log_Pre_ordini.txt"
*!*	=STRTOFILE("Pre-ordine SF "+M.SF_PREORDINE__C_ID+" ("+M.TAGGANCIO+")"+CHR(13)+CHR(10) + ;
*!*		"   M.ORD_CODART = " + ALLTRIM(M.ORD_CODART) + CHR(13)+CHR(10) + ;
*!*		"   M.Sconto__c = " + ALLTRIM(M.Sconto__c) + CHR(13)+CHR(10) + ;
*!*		"   M.ORD_SC1 = " + ALLTRIM(STR(M.ORD_SC1,20,10)) + ;
*!*		CHR(13)+CHR(10),lsFile,.T.)     
*!*	*######################################################### TEST ##########################
			
IF EMPTY(M.ORD_CODART)
	M.ORD_CODART = '.'
ENDIF

M.ART_CODGMI = ""
M.ORD_SERV_INTRA = ""  && ERASMO - 19/05/2025
IF !ExecCommand("select * from U_ART_AN where ART_CODPRI = '" + ALLTRIM(M.ORD_CODART) + "'","CX_ART_AN")
   RETURN .F.
ENDIF
SELECT CX_ART_AN
GO TOP
IF !EOF()
	M.ART_CODGMI = ART_CODGMI
	M.ORD_SERV_INTRA = ART_SERVINTRA  && ERASMO - 19/05/2025
ENDIF

IF !ExecCommand("select * from U_ART_PR where ART_CODPRI = '" + ALLTRIM(M.ORD_CODART) + "'","CX_ART_PR")
   RETURN .F.
ENDIF
SELECT CX_ART_PR
GO TOP
IF EOF()
	**** DA GESTIRE
	RETURN .F.
ENDIF

M.ORD_CODART  = ART_CODPRI
M.ORD_MAGA	  = ART_MAGA
M.ORD_DESART  = ALLTRIM(M.Descrizione_articolo__c)
M.ORD_DES2	  = ""
M.ORD_CLDOG   = ART_CLDOG
* -------------------------------------------------------------------------- descrizioni in lingua ---------- ARTICOLO ---------- *
DL_TIPODES 		= 'ARTICOLO'
DL_CODICE  		= M.ORD_CODART
_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
IF !EMPTY(_DESCR_LINGUA)
	M.ORD_DESART = _DESCR_LINGUA
	M.ORD_DES2	 = ""
ENDIF
* -------------------------------------------------------------------------- descrizioni in lingua ---------- ARTICOLO ---------- *

IF ALLTRIM(M.ORD_CODART) = '.'
	M.ORD_DESART = "COD. SALESFORCE " + ALLTRIM(M.Prodotto__r_ProductCode) + " (NON PRESENTE IN ANAGRAFICA)"
ENDIF

SELECT CX_ART_PR
M.ORD_UM	  = ART_UMMAGA  
M.ORD_UMFIN	  = ART_UMMAGA  
M.ORD_UMBAR	  = ART_UMMAGA  
M.ORD_UMSEZ	  = ART_UMMAGA  
M.ORD_IVA	  = ALLTRIM(M.Codice_IVA__r_Codice__c)
XLINEA        = ART_LINEA
M.ORD_COORD   = ART_COORD 
M.ORD_QTXCON  = ART_QTACON 
M.ORD_SCORMI  = ART_SCORMI
M.ORD_CODTAG  = ART_CODTAG 
M.ORD_DESTAG  = ART_DESTAG 
M.ORD_CODCOL  = ART_CODCOL 
M.ORD_DESCOL  = ART_DESCOL 
M.ORD_PUBBLI  = ART_PUBBLI
M.ORD_PESOUM  = ART_PESOUM
M.ORD_DATCON  = STRTRAN(M.Data_consegna__c,'-','/')
IF EMPTY(M.ORD_DATCON)
   M.ORD_DATCON = "2999/12/31"
ENDIF
M.ORD_CODMAT = ART_CODMAT
M.ORD_DESMAT = ART_DESMAT
M.ORD_CODCOL = ART_CODCOL
M.ORD_DESCOL = ART_DESCOL
M.ORD_SPESSO = ART_SPESSO
M.ORD_ALTEZZ = ART_ALTEZZ
M.ORD_LUNGHE = ART_LUNGHE
M.ORD_CODIMB = ART_CODIMB
M.ORD_DESIMB = ART_DESIMB
M.ORD_LOTMIN = ART_LOTMIN
IF EMPTY(M.ORD_CDAPRD) OR !ESISTE_ARTICOLO(M.ORD_CDAPRD)  
   M.ORD_CDAPRD = M.ORD_CODART
   M.ORD_DSAPRD = M.ORD_DESART
ENDIF
V_DIBA = ART_CDDIBA
**------------------------------------------- RICERCA IVA INTRASTAT -----------------------------------------**
RELEASE _COD_IVA_INTRASTAT,_COD_IVA_INTRASTAT_ESE
PUBLIC _COD_IVA_INTRASTAT ,_COD_IVA_INTRASTAT_ESE
_COD_IVA_INTRASTAT 		= ""
_COD_IVA_INTRASTAT_ESE 	= ""
_TIPO_CLI_FOR			= "C"
_CODICE_CLI_FOR			= M.ORD_CODCLI
_TIPOLOGIA_DOCUMENTO	= ALLTRIM(M.ORD_TIPOLOGIA)
=INTRA_DETERMINA_IVA(_TIPO_CLI_FOR,_CODICE_CLI_FOR,_TIPOLOGIA_DOCUMENTO)
IF !EMPTY(_COD_IVA_INTRASTAT)			&& IVA INTRASTAT
	IVA_CLI = _COD_IVA_INTRASTAT		&& IVA INTRASTAT
ENDIF 									&& IVA INTRASTAT
IF !EMPTY(_COD_IVA_INTRASTAT_ESE)		&& IVA INTRASTAT ESENTE
	IVA_ESE = _COD_IVA_INTRASTAT_ESE 	&& IVA INTRASTAT ESENTE
ENDIF 									&& IVA INTRASTAT ESENTE
**------------------------------------------- RICERCA IVA INTRASTAT -----------------------------------------**
**-------------------------------- RICERCA IVA INTRASTAT DA ANAGRAFICA ARTICOLI -----------------------------**
PUB_SERVINTRA       				= ""
__CODICE_NAZIONE__					= M.ORD_CODNAZ
_CODICE_IVAESENTE__ATTRIBUITO__		= IVA_ESE 
_CODICE_ARTICOLO__  				= M.ORD_CODART
_IVA_ARTICOLO_=PRELEVA_CODICE_IVA_INTRASTAT_DA_ANAGRAFICA_ARTICOLI(__CODICE_NAZIONE__,_CODICE_IVAESENTE__ATTRIBUITO__,_CODICE_ARTICOLO__)
IF !EMPTY(_IVA_ARTICOLO_)
	IVA_CLI = _IVA_ARTICOLO_
ENDIF

**=> ERASMO - INIZIO 19/05/2025
*** SE CLIENTE NON HA IVA CEE CODIFICATA, ALLORA NON VERRA' PROPOSTO IL CODICE IVA INTRASTAT (MODIFICA SU ESPLICITA RICHIESTA DEL CLIENTE)
x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select CLI_CODIVA,CLI_IVACEE from u_cli_an where " + x_cond
IF !ExecCommand(cSql,"TMP_CLIENTE")
   return(.f.)
ENDIF
SELECT TMP_CLIENTE
GO TOP
IF !EOF()
	IF EMPTY(CLI_IVACEE) OR ALLTRIM(CLI_IVACEE) = '.'
		IVA_CLI = CLI_CODIVA
	ENDIF
ENDIF

IF EMPTY(M.ORD_SERV_INTRA)
	M.ORD_SERV_INTRA = PUB_SERVINTRA
ENDIF
**-------------------------------- RICERCA IVA INTRASTAT DA ANAGRAFICA ARTICOLI -----------------------------**
**=> ERASMO - FINE 19/05/2025

M.ORD_CCODET = M.ORD_CCOSTO

PERC_ALIQ = 0
IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(M.ORD_IVA) + "'","cx_para")
   RETURN .F.
ENDIF
SELECT cx_para
GO TOP
IF !EOF()
   cALIQ = SUBSTR(LIBERA,1,3)
   PERC_ALIQ = VAL(cALIQ)
ENDIF

M.ORD_PRZNET = 0
IF M.ORD_PREZZO <> 0
ELSE
	M.ORD_SC1 = 0
ENDIF

_PRORIG = M.ORD_PRORIG
_SC1    = M.ORD_SC1
_SC2    = M.ORD_SC2
_SC3    = M.ORD_SC3
_PREZZO = M.ORD_PREZZO

OK_COMM= .F.   && INIBISCE I COMMENTI

IF M.ORD_VALUTA = PUB_VALRIF        && SE VALUTA DIGITATA = VALUTA DI RIFERIMENTO
   M.ORD_CAMBIO = 1
ENDIF	  
IF M.ORD_PRORIG = 0
   M.ORD_PRORIG = M.ORD_PRORIT
ENDIF
IF M.ORD_SC1 = 0
   M.ORD_SC1 = M.ORD_SC1T
ENDIF
IF M.ORD_SC2 = 0
   M.ORD_SC2 = M.ORD_SC2T
ENDIF
IF M.ORD_SC3 = 0
   M.ORD_SC3 = M.ORD_SC3T
ENDIF
		
VPRE         = M.ORD_PREZZO
VPRE         = VPRE-ROUND((VPRE*M.ORD_SC1/100),6)
VPRE         = VPRE-ROUND((VPRE*M.ORD_SC2/100),6)
VPRE         = VPRE-ROUND((VPRE*M.ORD_SC3/100),6)
VPRE         = VPRE-ROUND((VPRE*M.ORD_SC4/100),6)  
VPRE         = VPRE-ROUND((VPRE*M.ORD_SC5/100),6)  
M.ORD_PRZNET = VPRE
M.ORD_PRZNET = ROUND(M.ORD_PRZNET,6)
M.ORD_VALORE = CALCOLA_VALORE_RIGA_DOCUMENTO(M.ORD_PRZNET,M.ORD_QTAORD)  

DO OK_PROV     && GESTISCE LE PROVVIGIONI 

M.ORD_UMCLI  = ""
M.ORD_PRECLI = 0
M.ORD_QTACLI = 0

_NEW_SEQUEN = _NEW_SEQUEN + 10
M.ORD_SEQUEN = _NEW_SEQUEN

M.ORS_NUMORD = M.ORD_NUMORD
M.ORS_DATORD = M.ORD_DATORD
M.ORS_MAGS   = M.ORD_MAGS
M.ORS_MAGD   = M.ORD_MAGD
M.ORS_CODCLI = M.ORD_CODCLI
M.ORS_RAGSOC = M.ORD_RAGSOC
M.ORS_CODEMI = M.ORD_CODEMI
M.ORS_RAGEMI = M.ORD_RAGEMI
M.ORS_TIPORD = M.ORD_TIPORD
*M.ORS_DESTIN = M.ORD_DESTIN
M.ORS_FLGABP = M.ORD_FLGABP

M.ORD_CONDET = ""
IF PUB_TPAEGRU	&& GESTIONE CONTO CONTABILE DA TABELLA PAESE/GRUPPO MERCEOLOGICO INDUSTRIALE
	*__PAESE	= PUB_PAESE
	__PAESE	= CERCA_TIPOLOGIA_PAESE_E_NAZIONE_INTRASTAT(M.ORD_CODNAZ)  
	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "art_codpri = '" + M.ORD_CODART + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select ART_CODGMI from U_ART_AN where " + x_cond + " order by art_codsoc,art_codpri"
	IF !ExecCommand(cSql,"CA_ART_AN_cu")
	   RETURN .F.
	ENDIF
	SELECT CA_ART_AN_cu
	GO TOP 
	IF !EOF()
		__GRUPPO_MERCEOLOGICO_INDUSTRIALE	= ART_CODGMI
	ELSE 
		__GRUPPO_MERCEOLOGICO_INDUSTRIALE	= ""			 
	ENDIF
	__GRUPPO_MERCEOLOGICO_INDUSTRIALE = IIF(!EMPTY(CERCA_GMI_CANVEN_CLI(M.ORD_CODCLI)),CERCA_GMI_CANVEN_CLI(M.ORD_CODCLI),__GRUPPO_MERCEOLOGICO_INDUSTRIALE)
	_cConDet = CERCA_CONTO_CONTABILE_VENDITE_IN_TABELLA_PAESE_GRUPPO_MERCEOLOGICO_INDUSTRIALE(__PAESE,__GRUPPO_MERCEOLOGICO_INDUSTRIALE,M.ORD_TIPOLOGIA)
	IF !EMPTY(_cConDet)
		M.ORD_CONDET = _cConDet
	ENDIF
ENDIF

M.ORD_CODSYS = SYS(2015)
M.ORD_LEGSYS = SYS(2015)
M.KEY_AGG = ""

IF _LEGAME_BUNDLE_ART_PREC <> "" AND ALLTRIM(M.Voce_preventivo__c) == ALLTRIM(_LEGAME_BUNDLE_ART_PREC)
	M.KEY_AGG = _CODSYS_BUNDLE
ENDIF

SELECT CU_ORD_DD
APPEND BLANK
GATHER MEMVAR MEMO

*** RIGA DI COMMENTO (IN SFDC ASSOCIATA ALLA RIGA ARTICOLO, PER CUI LA INSERISCO APPENA DOPO)
IF !EMPTY(ALLTRIM(M.Note_interne__c))
	SELECT CU_ORD_DD
	SCATTER MEMVAR MEMO BLANK
	
	M.DAGGANCIO  = X_TAGG	
	M.ORD_CODART = ""
	M.ORD_DESART = "*** COMMENTO ***"
	M.ORD_CODSYS = SYS(2015)
	M.ORD_QTAORD = 0
	M.ORD_UM	 = ""
	M.ORD_NOTE	 = ALLTRIM(M.Note_interne__c)
	M.ORD_NOTEBO = ""
	_NEW_SEQUEN  = _NEW_SEQUEN + 10
	M.ORD_SEQUEN = _NEW_SEQUEN
	
	M.ORS_NUMORD = M.ORD_NUMORD
	M.ORS_DATORD = M.ORD_DATORD
	M.ORS_MAGS   = M.ORD_MAGS
	M.ORS_MAGD   = M.ORD_MAGD
	M.ORS_CODCLI = M.ORD_CODCLI
	M.ORS_RAGSOC = M.ORD_RAGSOC
	M.ORS_CODEMI = M.ORD_CODEMI
	M.ORS_RAGEMI = M.ORD_RAGEMI
	M.ORS_TIPORD = M.ORD_TIPORD
	M.ORS_FLGABP = M.ORD_FLGABP

	SELECT CU_ORD_DD
	APPEND BLANK
	GATHER MEMVAR MEMO
ENDIF

RETURN .T.


**********************************************************************
FUNCTION CONTRASSEGNA_PRE_ORDINE_SFDC
**********************************************************************
LPARAMETERS _par_Id_Preordine__c,_par_ok_uploaded,_par_messaggio_warning

_RIT = .F.

*** AGGIORNAMENTO FLAG DI ORDINE ACQUISITO SU TABELLA PRE-ORDINI SALESFORCE
_json_content = '{'
*_json_content = _json_content + '"Aq_uploaded__c": ' + IIF(_par_ok_uploaded,"true","false")
_json_content = _json_content + '"Stato_sincronizzazione__c": "' + IIF(_par_ok_uploaded,'Sincronizzato','In errore') + '"'
IF !EMPTY(ALLTRIM(_par_messaggio_warning))
	_json_content = _json_content + ', "Errore_sync__c": "' + ALLTRIM(_par_messaggio_warning) + '"'
ENDIF
_json_content = _json_content + '}'
		
*** AGGIORNAMENTO CAMPI SU SALESFORCE
_HTTP_request = ALLTRIM(_instance_url) + "/services/data/v42.0/sobjects/Preordine__c/"+_par_Id_Preordine__c
_cJson = ""

_cJson = SALESFORCEREST_PATCH(_HTTP_request,_access_token,_json_content)
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_instance_url+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	RETURN _RIT
ENDIF

IF _cJson = "204"
	_RIT = .T.
ELSE
	
	obj_json = json_decode(_cJson)

	*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
		_cProperty = "OBJ_JSON.Array(1)._message"
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			_message = ALLTRIM(&_cProperty)
			WAIT WINDOWS SUBSTR("Risposta da '"+_instance_url+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
			
			cSql = "select * from LOG_SFSYNC WHERE OGGETTO = 'PRE_ORDINI' AND CODSYS = '" + _LOG_CODSYS + "'"
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

RETURN _RIT

ENDFUNC