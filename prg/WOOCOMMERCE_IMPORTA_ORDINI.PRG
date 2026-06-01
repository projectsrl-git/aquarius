
IF EMPTY(PUB_WPUSER) OR EMPTY(PUB_WPPASS) OR EMPTY(PUB_WPCKEY) OR EMPTY(PUB_WPCSECRET) OR EMPTY(PUB_WPSITO) OR EMPTY(PUB_WPIVCEE) OR EMPTY(PUB_WPIVEXT)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'WordPress REST API Authentication'",16,"Attenzione")
	RETURN .F.
ENDIF

_nAnno = VAL(SUBSTR(DTOC(DATE()),7,4))
_nMese = VAL(SUBSTR(DTOC(DATE()),4,2))
_nMese = _nMese - 1
IF _nMese = 0
	_nMese = 12
	_nAnno = _nAnno - 1
ENDIF
_Anno = TRC(4,ALLTRIM(STR(_nAnno,4,0)))
_Mese = TRC(2,ALLTRIM(STR(_nMese,2,0)))

_V_DATADA = "01/" + _Mese + "/" + _Anno  && DATA INIZIO MESE PRECEDENTE
_V_DATAAL = DTOC(DATE())

_CONTINUA = .F.
DO FORM FORM\WOOCOMMERCE_SELDATE LINKED
IF !_CONTINUA
	MESSAGEBOX("Operazione abbandonata",48,"Informazione")
	RETURN .F.
ENDIF

_LOG_DATA = RIBALTA2(DTOC(DATE()))
_LOG_ORA = TIME()
_LOG_CODOPE = ALLTRIM(PUB_CODOPE)
_LOG_NOMOPE = ALLTRIM(PUB_NOMOPE)

*!*	_username = "projectsrl"
*!*	_password = "U7#gRXdzyqCbUH7S!m3B*x*o"
*!*	_consumer_key = "ck_df2c7bce1458bc8fbdf95a7a36cf98e277ec52cc"
*!*	_consumer_secret = "cs_13974d397c64fc3a8d6fc6ec8389d78ea97441fa"
*!*	_nomesito = "https://www.kuberth.com"

_username = ALLTRIM(PUB_WPUSER)
_password = ALLTRIM(PUB_WPPASS)
_consumer_key = ALLTRIM(PUB_WPCKEY)
_consumer_secret = ALLTRIM(PUB_WPCSECRET)
_nomesito = ALLTRIM(PUB_WPSITO)

_HTTP_request = "/wp-json/wc/v2/orders"
_cJson = ""
_par_paragg_1 = "after="+STRTRAN(RIBALTA2(_V_DATADA),"/","-")+"T00%3A00%3A00"
_par_paragg_2 = "before="+STRTRAN(RIBALTA2(_V_DATAAL),"/","-")+"T24%3A00%3A00"

WAIT WINDOWS "Connessione a '"+_nomesito+_HTTP_request+"' in corso..." NOWAIT

_cJson = WOOCOMMREST_GET(_username,_password,_consumer_key,_consumer_secret,_nomesito,_HTTP_request,_par_paragg_1,_par_paragg_2)
IF EMPTY(_cJson)
	WAIT CLEAR
	MESSAGEBOX("Nessuna risposta da '"+_nomesito+_HTTP_request+"': verificare la URL e che sia disponibile una connessione internet",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione file Json in corso..." NOWAIT

_ErrorMsg = STRTRAN(STRTRAN(SUBSTR(_cJson, AT('"message":"',_cJson), AT('"',SUBSTR(_cJson, AT('"message":"',_cJson)),4)),'"message":',''),'"','')
if !EMPTY(_ErrorMsg)
	WAIT CLEAR
	MESSAGEBOX(_ErrorMsg,16,"Attenzione")
	RETURN .F.
ENDIF

obj_json = json_decode(_cJson)

cSql="select * from WC_ORDERS where 1=0"
IF !ExecCommand(cSql,"TMP_ORDERS")
	return(.f.)
ENDIF

cSql="select * from WC_ORDER_LINE_ITEMS where 1=0"
IF !ExecCommand(cSql,"TMP_ORDER_LINE_ITEMS")
	return(.f.)
ENDIF

*gnFieldcount = AFIELDS(gaMyArray)

FOR I_row = 1 TO ALEN(OBJ_JSON.Array,1)
	
	SELECT TMP_ORDERS
	SCATTER MEMVAR MEMO BLANK
	
	SELECT TMP_ORDER_LINE_ITEMS
	SCATTER MEMVAR MEMO BLANK
	
	*** ESCLUDO ORDINI SENZA CLIENTE
	_cProperty = "OBJ_JSON.Array("+ALLTRIM(STR(I_row))+")._CUSTOMER_ID"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		IF &_cProperty = 0
			LOOP
		ENDIF
	ENDIF
	
	_cProperty = "OBJ_JSON.Array("+ALLTRIM(STR(I_row))+")._ID"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_cCommand = "M.ID_ORDER = "+_cProperty
		&_cCommand
	ENDIF
	
	_cProperty = "OBJ_JSON.Array("+ALLTRIM(STR(I_row))+")._ORDER_KEY"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_cCommand = "M.ORDER_KEY = "+_cProperty
		&_cCommand
	ENDIF
		
	=AMEMBERS(gaPropArray, obj_json.ARRAY(I_row), 0)  && Array containing properties
	
	FOR I_col=1 TO ALEN(gaPropArray)
		*** DATI DI TESTATA
		_cProperty = "OBJ_JSON.Array("+ALLTRIM(STR(I_row))+")."+ALLTRIM(gaPropArray(I_col))
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			IF SUBSTR(ALLTRIM(gaPropArray(I_col)),1,1) = "_"
				_cCommand = "M."+SUBSTR(ALLTRIM(gaPropArray(I_col)),2)+" = "+_cProperty
				&_cCommand
			ENDIF
		ENDIF
		
		*** DATI BILLING E SHIPPING (TESTATA)
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) = 'O' AND !ISNULL(&_cProperty) AND UPPER(ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))) <> "LINE_ITEMS"
			=AMEMBERS(gaPropArrayDet, &_cProperty, 0)  && Array containing properties
			FOR I_col_det=1 TO ALEN(gaPropArrayDet)
				_cPropertyDet = _cProperty+"."+ALLTRIM(gaPropArrayDet(I_col_det))
				IF TYPE(_cPropertyDet) <> 'U' AND TYPE(_cPropertyDet) <> 'O' AND !ISNULL(&_cPropertyDet)
					IF SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),1,1) = "_"
						_cCommand = "M."+ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))+"_"+SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),2)+" = "+_cPropertyDet
						&_cCommand
					ENDIF
				ENDIF
			NEXT
		ENDIF
		
		*** DATI DI DETTAGLIO
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) = 'O' AND !ISNULL(&_cProperty) AND UPPER(ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))) = "LINE_ITEMS"
			_cProperty = _cProperty+".ARRAY"
			=AMEMBERS(gaPropArrayDet, &_cProperty, 0)  && Array containing properties
			
			FOR I_row_det = 1 TO ALEN(&_cProperty,1)
				FOR I_col_det=1 TO ALEN(gaPropArrayDet)
					_cPropertyDet = _cProperty+"("+ALLTRIM(STR(I_row_det))+")."+ALLTRIM(gaPropArrayDet(I_col_det))
					IF TYPE(_cPropertyDet) <> 'U' AND TYPE(_cPropertyDet) <> 'O' AND !ISNULL(&_cPropertyDet)
						IF SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),1,1) = "_"
							_cCommand = "M."+SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),2)+" = "+_cPropertyDet
							&_cCommand
						ENDIF
					ENDIF
				NEXT
				
				SELECT TMP_ORDER_LINE_ITEMS
				APPEND BLANK
				GATHER MEMVAR MEMO
				REPLACE LOG_DATA WITH _LOG_DATA 
				REPLACE LOG_ORA WITH _LOG_ORA 
				REPLACE LOG_CODOPE WITH _LOG_CODOPE 
				REPLACE LOG_NOMOPE WITH _LOG_NOMOPE 				
			NEXT
		ENDIF
	NEXT
	
	SELECT TMP_ORDERS
	APPEND BLANK
	GATHER MEMVAR MEMO
	REPLACE LOG_DATA WITH _LOG_DATA 
	REPLACE LOG_ORA WITH _LOG_ORA 
	REPLACE LOG_CODOPE WITH _LOG_CODOPE 
	REPLACE LOG_NOMOPE WITH _LOG_NOMOPE 
	
NEXT

RELEASE obj_json

SELECT TMP_ORDERS
GO TOP

SELECT TMP_ORDER_LINE_ITEMS
GO TOP

WAIT WINDOWS "Elaborazione per anagrafica Clienti in corso..." NOWAIT

*** ELABORAZIONE PER CONTROLLO ANAGRAFICA CLIENTI
_RICHIEDI_VERIFICA_UTENTE = .F.
SELECT CUSTOMER_ID, BILLING_FIRST_NAME, BILLING_LAST_NAME, BILLING_COMPANY, SPACE(10) AS CLI_CODCLI, SPACE(200) AS CLI_RAGSOC FROM TMP_ORDERS ;
	GROUP BY CUSTOMER_ID, BILLING_FIRST_NAME, BILLING_LAST_NAME, BILLING_COMPANY ORDER BY CUSTOMER_ID DESC INTO CURSOR CU_CUSTOMERS READWRITE
SELECT CU_CUSTOMERS
GO TOP
SCAN
	_WC_CUSTOMER_ID = CUSTOMER_ID
	x_cond = "U_ANA_CL.WC_CUSTOMER_ID = " + ALLTRIM(STR(_WC_CUSTOMER_ID))
	cSql="select U_CLI_AN.CLI_CODCLI, U_CLI_AN.CLI_RAGSOC from u_cli_an left outer join u_ana_cl on u_cli_an.cli_codcli = u_ana_cl.cli_codcli where " + x_cond
	IF !ExecCommand(cSql,"TMP_CLI_CL_AN")
		return(.f.)
	ENDIF
	SELECT TMP_CLI_CL_AN
	GO TOP
	IF !EOF()
		_CLI_CODCLI = CLI_CODCLI
		_CLI_RAGSOC = CLI_RAGSOC
	ELSE
		_CLI_CODCLI = "NUOVO!"
		_CLI_RAGSOC = ""
		_RICHIEDI_VERIFICA_UTENTE = .T.
	ENDIF
	
	SELECT CU_CUSTOMERS
	REPLACE CLI_CODCLI WITH _CLI_CODCLI
	REPLACE CLI_RAGSOC WITH _CLI_RAGSOC
ENDSCAN

_CONTA_CLI = 0

IF _RICHIEDI_VERIFICA_UTENTE
	x_cond = "codice = 'NUMCLI" + PUB_CODSOC + "'"
	cSql   = "select * from para where " + x_cond 
	IF !ExecRW(cSql,"para","R")
	   return(.f.)
	ENDIF
	SELECT PARA
	GO TOP
	IF EOF()
		MESSAGEBOX('Parametro codice cliente non trovato',16,"*** ATTENZIONE ***")
		MESSAGEBOX("Operazione abbandonata",48,"Attenzione")
		RETURN .F.
	ELSE
		S_NUM = SUBSTR(LIBERA,1,10)
		IF S_NUM  <> "9999999999"                    && SOLO SE <> 9999999999
		ELSE
			MESSAGEBOX('Parametro codice cliente impostato a 9999999999: verificare la configurazione del parametro',16,"*** ATTENZIONE ***")
			MESSAGEBOX("Operazione abbandonata",48,"Attenzione")
			RETURN .F.
		ENDIF
	ENDIF
*!*		_CONFERMA = .F.
*!*		DO FORM FORM\WC_LEGA_CLIENTI LINKED
*!*		IF !_CONFERMA
*!*			MESSAGEBOX("Operazione abbandonata",48,"Attenzione")
*!*			RETURN .F.
*!*		ENDIF
	SELECT CU_CUSTOMERS
	GO TOP
	SCAN
		IF ALLTRIM(CLI_CODCLI) = "NUOVO!"
		ELSE
			LOOP
		ENDIF
		
		_WC_CUSTOMER_ID = CUSTOMER_ID
		
		*** CREAZIONE NUOVA ANAGRAFICA CLIENTE
		SELECT TOP 1 * FROM TMP_ORDERS WHERE CUSTOMER_ID = _WC_CUSTOMER_ID ORDER BY DATE_MODIFIED DESC INTO CURSOR TMP_ORDERS_CUSTOMER
		SELECT TMP_ORDERS_CUSTOMER
		GO TOP
		IF EOF()
			DELETE FROM TMP_ORDERS WHERE CUSTOMER_ID = _WC_CUSTOMER_ID
			DELETE FROM TMP_ORDER_LINE_ITEMS WHERE CUSTOMER_ID = _WC_CUSTOMER_ID
			SELECT CU_CUSTOMERS
			LOOP
		ENDIF
		
		X_VALUTA  = UPPER(ALLTRIM(CURRENCY))
		IF EMPTY(X_VALUTA)
			X_VALUTA = PUB_VALRIF
		ENDIF
		X_AGE     = PUB_AGE
		X_CODIVA  = PUB_IVA
		X_CONPAG  = PUB_CPA
		X_IVACEE  = ""
		X_CODFIS  = ""
		X_ZONA    = ""
		X_PARIVA  = "."
		X_FAX     = ""
		X_RICERC  = ""
		X_TELEX   = ""
		X_WEB     = ""
		X_CCOSTO  = ""
		
		*** SE DISPONIBILI, PRELEVO TUTTE LE INFORMAZIONI ANAGRAFICHE TRAMITE APPOSITO ACCESSO REST-API WOOCOMMERCE
		_HTTP_request = "/wp-json/wc/v2/customers/" + ALLTRIM(STR(_WC_CUSTOMER_ID,10,0))
		_cJsonCli = ""
		_cJsonCli = WOOCOMMREST_GET(_username,_password,_consumer_key,_consumer_secret,_nomesito,_HTTP_request)
		IF !EMPTY(_cJsonCli)
			_ErrorMsg = STRTRAN(STRTRAN(SUBSTR(_cJsonCli, AT('"message":"',_cJsonCli), AT('"',SUBSTR(_cJsonCli, AT('"message":"',_cJsonCli)),4)),'"message":',''),'"','')
			IF EMPTY(_ErrorMsg)
				obj_json_cli = json_decode(_cJsonCli)
				X_RAGSOC = UPPER(ALLTRIM(obj_json_cli._BILLING._COMPANY))
				X_RAGDUE = UPPER(ALLTRIM(obj_json_cli._BILLING._FIRST_NAME)) + " " + UPPER(ALLTRIM(obj_json_cli._BILLING._LAST_NAME))
				IF EMPTY(X_RAGDUE)
					X_RAGDUE = UPPER(ALLTRIM(obj_json_cli._FIRST_NAME)) + " " + UPPER(ALLTRIM(obj_json_cli._LAST_NAME))
				ENDIF
				IF EMPTY(X_RAGSOC)
					X_RAGSOC = UPPER(ALLTRIM(obj_json_cli._BILLING._FIRST_NAME)) + " " + UPPER(ALLTRIM(obj_json_cli._BILLING._LAST_NAME))
					X_RAGDUE = ""
				ENDIF
				IF EMPTY(X_RAGSOC)
					X_RAGSOC = UPPER(ALLTRIM(obj_json_cli._FIRST_NAME)) + " " + UPPER(ALLTRIM(obj_json_cli._LAST_NAME))
					X_RAGDUE = ""
				ENDIF
				X_INDIR   = UPPER(ALLTRIM(obj_json_cli._BILLING._ADDRESS_1)) + " " + UPPER(ALLTRIM(obj_json_cli._BILLING._ADDRESS_2))
				X_NAZIONE = UPPER(ALLTRIM(obj_json_cli._BILLING._COUNTRY))
				X_CAP     = UPPER(ALLTRIM(obj_json_cli._BILLING._POSTCODE))
				X_LOCALI  = UPPER(ALLTRIM(obj_json_cli._BILLING._CITY))
				X_PROVIN  = UPPER(ALLTRIM(obj_json_cli._BILLING._STATE))
				X_TELEFO  = UPPER(ALLTRIM(obj_json_cli._BILLING._PHONE))
				X_EMAIL   = ALLTRIM(obj_json_cli._BILLING._EMAIL)
				
				*** RILEVO CODICE NAZIONE AQUARIUS (IN WOOCOMMERCE E' ESPRESSA IN FORMATO ISO 3166-1 alpha-2)
				x_cond = "codice LIKE 'STA%' AND libera = '" + X_NAZIONE + "'"
				cSql   = "select substring(codice,4,3) AS COD_NAZIONE_AQ from para where " + x_cond 
				IF !ExecCommand(cSql,"TMP_PARA")
				   return(.f.)
				ENDIF
				SELECT TMP_PARA
				GO TOP
				IF !EOF()
					X_NAZIONE = COD_NAZIONE_AQ
				ENDIF
				
				_billing_cf = ""
				FOR __I=1 TO ALEN(obj_json_cli._META_DATA.ARRAY,1)
					IF TYPE("ALLTRIM(obj_json_cli._META_DATA.ARRAY("+ALLTRIM(STR(__I,10,0))+")._VALUE)") == 'C'
						IF ALLTRIM(obj_json_cli._META_DATA.ARRAY(__I)._KEY) = "billing_cf"
							_billing_cf = ALLTRIM(obj_json_cli._META_DATA.ARRAY(__I)._VALUE)
							EXIT
						ENDIF
					ENDIF
				ENDFOR
				
				IF SUBSTR(X_NAZIONE,1,2) = 'IT'
					X_CODIVA  = PUB_IVA
					X_IVACEE  = ""
					IF EMPTY(_billing_cf)
						X_PARIVA = ""
						X_CODFIS = ""
					ELSE
						IF ISDIGIT(_billing_cf)
							X_CODFIS = ""
							X_PARIVA = _billing_cf
						ELSE
							X_CODFIS = _billing_cf
							X_PARIVA = ""
						ENDIF
					ENDIF
				ELSE
					X_CODIVA = ""
					cSql=""     
					cNomeCursorSql="_TEMP"
					TEXT TO cSql NOSHOW
						SELECT SUBSTRING(CODICE,4,2) AS GRUPPO_NAZIONE
						FROM PARA 
						WHERE CODICE LIKE 'GEN%' 
							AND NOTE LIKE '%.<<X_NAZIONE>>.%' 
							AND CODICE IN ('GENCE','GENEX')
					ENDTEXT
					IF !ExecPreparedCommand(cSql,cNomeCursorSql)
						return(.F.)
					ENDIF
					SELECT _TEMP
					GO TOP
					IF GRUPPO_NAZIONE = 'CE'
						X_CODIVA = PUB_WPIVCEE
					ENDIF
					IF GRUPPO_NAZIONE = 'EX'
						X_CODIVA = PUB_WPIVEXT
					ENDIF					
					
					X_CODFIS = ""
					X_PARIVA = ""
					X_IVACEE = _billing_cf
				ENDIF
				
			ENDIF
		ENDIF
		RELEASE _cJsonCli
		
		SELECT TMP_ORDERS_CUSTOMER
		
		IF EMPTY(X_RAGSOC)
			X_RAGSOC = UPPER(ALLTRIM(BILLING_COMPANY))
			IF EMPTY(X_RAGSOC)
				X_RAGSOC = UPPER(ALLTRIM(BILLING_FIRST_NAME)) + " " + UPPER(ALLTRIM(BILLING_LAST_NAME))
				X_RAGDUE = ""
			ELSE
				X_RAGDUE = UPPER(ALLTRIM(BILLING_FIRST_NAME)) + " " + UPPER(ALLTRIM(BILLING_LAST_NAME))
			ENDIF
		ENDIF
				
		F_INDIR   = UPPER(ALLTRIM(BILLING_ADDRESS_1)) + " " + UPPER(ALLTRIM(BILLING_ADDRESS_2))
		F_NAZIONE = UPPER(ALLTRIM(BILLING_COUNTRY))
		F_CAP     = UPPER(ALLTRIM(BILLING_POSTCODE))
		F_LOCALI  = UPPER(ALLTRIM(BILLING_CITY))
		F_PROVIN  = UPPER(ALLTRIM(BILLING_STATE))
		F_VALUTA  = UPPER(ALLTRIM(CURRENCY))
		F_TELEFO  = UPPER(ALLTRIM(BILLING_PHONE))
		F_EMAIL   = ALLTRIM(BILLING_EMAIL)
		
		*** RILEVO CODICE NAZIONE AQUARIUS (IN WOOCOMMERCE E' ESPRESSA IN FORMATO ISO 3166-1 alpha-2)
		x_cond = "codice LIKE 'STA%' AND libera = '" + F_NAZIONE + "'"
		cSql   = "select substring(codice,4,3) AS COD_NAZIONE_AQ from para where " + x_cond 
		IF !ExecCommand(cSql,"TMP_PARA")
		   return(.f.)
		ENDIF
		SELECT TMP_PARA
		GO TOP
		IF !EOF()
			F_NAZIONE = COD_NAZIONE_AQ
		ENDIF
		
		IF EMPTY(X_INDIR)
			X_INDIR = F_INDIR
		ENDIF
		IF EMPTY(X_NAZIONE)
			X_NAZIONE = F_NAZIONE
		ENDIF
		IF EMPTY(X_CAP)
			X_CAP = F_CAP
		ENDIF
		IF EMPTY(X_LOCALI)
			X_LOCALI = F_LOCALI
		ENDIF
		IF EMPTY(X_PROVIN)
			X_PROVIN = F_PROVIN
		ENDIF
		IF EMPTY(X_TELEFO)
			X_TELEFO = F_TELEFO
		ENDIF
		IF EMPTY(X_EMAIL)
			X_EMAIL = F_EMAIL
		ENDIF
		
		X_CODICE  = ""
		x_cond = "codice = 'NUMCLI" + PUB_CODSOC + "'"
		cSql   = "select * from para where " + x_cond 
		IF !ExecRW(cSql,"para","R")
		   return(.f.)
		ENDIF
		SELECT PARA
		GO TOP
		IF EOF()
			MESSAGEBOX('Parametro codice cliente non trovato',16,"*** ATTENZIONE ***")
			IF !ExecRW(cSql,"para","W")
			   return(.f.)
			ENDIF
			DELETE FROM TMP_ORDERS WHERE CUSTOMER_ID = _WC_CUSTOMER_ID
			DELETE FROM TMP_ORDER_LINE_ITEMS WHERE CUSTOMER_ID = _WC_CUSTOMER_ID
			SELECT CU_CUSTOMERS
			LOOP
		ELSE
		   S_NUM = SUBSTR(LIBERA,1,10)
		   IF S_NUM  <> "9999999999"                    && SOLO SE <> 9999999999
		      N_NUM     = VAL(S_NUM)
		      INC_NUM   = N_NUM + 10
		      S_INC_NUM = STR(INC_NUM,10,0)
		      X_CODICE  = ALLTRIM(S_INC_NUM)
		      IF SUBSTR(X_CODICE,1,1)  <  "A"
		 	     X_CODICE= TRC(PUB_LCL,ALLTRIM(X_CODICE))
			  ENDIF
		      REPLACE LIBERA WITH S_INC_NUM 
		   ENDIF   
		   
		   INC_NUM   = N_NUM + 10
		   S_INC_NUM = STR(INC_NUM,10,0)
		   X_CODICE  = ALLTRIM(S_INC_NUM)
		   IF SUBSTR(X_CODICE,1,1)  <  "A"
		      X_CODICE= TRC(PUB_LCL,ALLTRIM(X_CODICE))
		   ENDIF

		ENDIF
		IF !ExecRW(cSql,"para","W")
		   return(.f.)
		ENDIF
		
		*** RILEVO CODICE NAZIONE AQUARIUS (IN WOOCOMMERCE E' ESPRESSA IN FORMATO ISO 3166-1 alpha-2)
		x_codi = "codice LIKE 'STA%'"
		x_libe = "libera = '" + ALLTRIM(X_NAZIONE) + "'"
		x_cond = x_codi + " AND " + x_libe
		cSql   = "select * from para where " + x_cond 
		IF !ExecCommand(cSql,"TMP_PARA")
		   return(.f.)
		ENDIF
		SELECT TMP_PARA
		GO TOP
		IF !EOF()
			X_NAZIONE = SUBSTR(CODICE,4,3)
		ENDIF
		
		IF !ExecRW("select * from u_cli_an where 0=1","u_cli_an","R")
		   return(.f.)
		ENDIF
		SELECT U_CLI_AN
		append blank
		SELECT U_CLI_AN
		REPLACE CLI_CODSOC WITH PUB_CODSOC
		REPLACE CLI_CODCLI WITH X_CODICE
		REPLACE CLI_RAGSOC WITH X_RAGSOC
		REPLACE CLI_RAGDUE WITH X_RAGDUE
		REPLACE CLI_CODIVA WITH X_CODIVA
		REPLACE CLI_CODFIS WITH X_CODFIS
		REPLACE CLI_INDIR  WITH X_INDIR
		REPLACE CLI_IVACEE WITH X_IVACEE
		REPLACE CLI_LOCALI WITH X_LOCALI
		REPLACE CLI_PROVIN WITH X_PROVIN
		REPLACE CLI_VALUTA WITH X_VALUTA
		REPLACE CLI_TELEFO WITH X_TELEFO
		REPLACE CLI_FAX    WITH X_FAX
		REPLACE CLI_EMAIL  WITH X_EMAIL
		REPLACE CLI_RICERC WITH X_RICERC	
		REPLACE CLI_DATINS WITH RIBALTA2(DTOC(DATE()))
		REPLACE CLI_DATNEW WITH RIBALTA2(DTOC(DATE()))
		REPLACE CLI_CAP    WITH X_CAP
		REPLACE CLI_NAZION WITH X_NAZIONE
		REPLACE CLI_ZONA   WITH X_ZONA
		REPLACE CLI_AGE	   WITH X_AGE
		REPLACE CLI_PARIVA WITH X_PARIVA
		REPLACE CLI_TELEX  WITH X_TELEX
		REPLACE CLI_HOMPAG WITH X_WEB
		REPLACE CLI_CCOST1 WITH X_CCOSTO
		REPLACE CLI_CONPAG WITH X_CONPAG

		SCATTER MEMVAR MEMO

		IF !ExecRW("","u_cli_an","W")
		   return(.f.)
		ENDIF
							
		x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "cli_codcli = '" + M.CLI_CODCLI + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "select * from u_ana_cl where " + x_cond + " order by cli_codsoc,cli_codcli"
		IF !ExecRW(cSql,"u_ana_cl","R")
		   return(.f.)
		ENDIF
		SELECT U_ANA_CL
		GO TOP 
		IF EOF()
			APPEND BLANK
		ENDIF
		REPLACE CLI_CODSOC WITH PUB_CODSOC
		REPLACE CLI_CODCLI WITH X_CODICE
		REPLACE WC_CUSTOMER_ID WITH _WC_CUSTOMER_ID
		IF !ExecRW(cSql,"u_ana_cl","W")
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
		
		_CONTA_CLI = _CONTA_CLI + 1
		
	ENDSCAN
ENDIF

WAIT WINDOWS "Elaborazione per inserimento/aggiornamento Ordini clienti in corso..." NOWAIT

*** INSERIMENTO ORDINI CLIENTI
cSql="select * from U_ORD_TT where 1=0"
IF !ExecCommand(cSql,"CU_ORD_TT")
	return(.f.)
ENDIF

cSql="select * from U_ORD_DD where 1=0"
IF !ExecCommand(cSql,"CU_ORD_DD")
	return(.f.)
ENDIF

SELECT TMP_ORDERS
GO TOP
SCAN
	SCATTER MEMVAR MEMO
	
	*** FILTRO GLI ORDINI CON I SOLI STATUS DA IMPORTARE
	IF ALLTRIM(UPPER(M.STATUS)) = "PENDING" OR ALLTRIM(UPPER(M.STATUS)) = "PROCESSING" OR ALLTRIM(UPPER(M.STATUS)) = "COMPLETED" OR ALLTRIM(UPPER(M.STATUS)) = "ON-HOLD"
	ELSE
		LOOP
	ENDIF
	
	*** VERIFICO ESISTENZA ORDINE
	x_codi = "WC_ORDER_KEY = '" + M.ORDER_KEY + "'"
	x_cond = x_codi
	cSql = "select * from U_ORD_TT where " + x_cond
	IF !ExecCommand(cSql,"CHK_ORD_TT")
	   RETURN .F.
	ENDIF  
	SELECT CHK_ORD_TT
	GO TOP
	IF !EOF() AND WC_DATE_MODIFIED = M.DATE_MODIFIED  && ORDINE GIA' IMPORTATO IN PRECEDENZA E NON MODIFICATO SUL WEB, NON ESEGUO NESSUN AGGIORNAMENTO
		DELETE FROM TMP_ORDER_LINE_ITEMS WHERE ORDER_KEY = M.ORDER_KEY
		SELECT TMP_ORDERS
		DELETE
		LOOP
	ENDIF
	
	IF !EOF() AND WC_DATE_MODIFIED <> M.DATE_MODIFIED  && ORDINE GIA' IMPORTATO IN PRECEDENZA E MODIFICATO SUL WEB, ESEGUO AGGIORNAMENTO DI ALCUNI CAMPI
		IF !ExecRW(cSql,"U_ORD_TT","R")
		   RETURN .F.
		ENDIF  
		SCATTER MEMVAR MEMO
		M.WC_DATE_MODIFIED = M.DATE_MODIFIED
		
		M.ORD_CODCLI = seek_u_cli_an('',pub_codsoc+ALLTRIM(M.ORD_CODCLI),'cli_codcli','cli_codcli','','CUR_CLIENTE')
		IF EMPTY(M.ORD_CODCLI)
		   	MESSAGEBOX("Cliente " + ALLTRIM(M.ORD_CODCLI) + " non trovato",64,"*** INFORMAZIONE ***")
			DELETE FROM TMP_ORDERS WHERE CUSTOMER_ID = M.CUSTOMER_ID
			DELETE FROM TMP_ORDER_LINE_ITEMS WHERE CUSTOMER_ID = M.CUSTOMER_ID
			SELECT TMP_ORDERS
			LOOP
		ENDIF

		SELECT CUR_CLIENTE
		__DTCLOK = CLI_DTCLOK
		RELEASE _FIDO
		PUBLIC _FIDO
		_fido = CLI_IMPFID
		IVA_ESE = CLI_ALRID
		IVA_CLI = CLI_CODIVA
		
		M.ORD_VALUTA = M.CURRENCY
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
		
		IF !EMPTY(M.PAYMENT_METHOD)
			IF !ExecCommand("select * from para where codice = 'CPA" + SUBSTR(UPPER(ALLTRIM(M.PAYMENT_METHOD)),1,10) + "'","cx_para")
				return
			ENDIF
			SELECT CX_PARA
			GO TOP
			IF !EOF()
				M.ORD_CPA = SUBSTR(CODICE,4,10)
			ELSE
				cSql = "select * from para WHERE 1=0"
				IF !ExecRW(cSql,"PARA","R")
					return
				ENDIF
				SELECT PARA
				APPEND BLANK
				REPLACE CODICE WITH "CPA"+SUBSTR(UPPER(ALLTRIM(M.PAYMENT_METHOD)),1,10)
				REPLACE DESCRI WITH UPPER(ALLTRIM(M.PAYMENT_METHOD_TITLE))
				REPLACE LIBERA WITH "DF BON    0 "
				M.ORD_CPA = SUBSTR(CODICE,4,10)
				IF !ExecRW(cSql,"PARA","W")
					return
				ENDIF
			ENDIF
		ELSE
			IF !EMPTY(M.PAYMENT_METHOD_TITLE)
				IF !ExecCommand("select * from para where codice like 'CPA%' AND DESCRI = '" + ALLTRIM(M.PAYMENT_METHOD_TITLE) + "'","cx_para")
					return
				ENDIF
				SELECT CX_PARA
				GO TOP
				IF !EOF()
					M.ORD_CPA = SUBSTR(CODICE,4,10)
				ENDIF
			ENDIF
		ENDIF
		
		IF EMPTY(M.ORD_CPA)
			SELECT CUR_CLIENTE
			M.ORD_CPA = CLI_CONPAG
			IF EMPTY(M.ORD_CPA)
				SELECT CUR_CLIENTE
				M.ORD_CPA = PUB_CPA
			ENDIF
		ENDIF
		
*!*			*** SCORPORO L'IVA DALLE SPESE DI TRASPORTO
*!*			PERC_ALIQ = 0
*!*			IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(IVA_CLI) + "'","cx_para")
*!*			   return
*!*			ENDIF
*!*			SELECT cx_para
*!*			GO TOP
*!*			IF !EOF()
*!*			   cALIQ = SUBSTR(LIBERA,1,3)
*!*			   PERC_ALIQ = VAL(cALIQ)
*!*			ENDIF
*!*			_SPTRAS_CON_IVA = VAL(STRTRAN(M.SHIPPING_TOTAL,'.',','))
*!*			_SPTRAS_SENZA_IVA = _SPTRAS_CON_IVA / (1 + (PERC_ALIQ/100))
*!*			M.ORD_SPTRAS = _SPTRAS_SENZA_IVA 
		
		M.ORD_SPTRAS = VAL(STRTRAN(M.SHIPPING_TOTAL,'.',','))
		
		SELECT U_ORD_TT
		DO U_ORD_TT
		IF !ExecRW(cSql,"U_ORD_TT","W")
		   RETURN .F.
		ENDIF
		
		X_TAGG = M.TAGGANCIO
		
		*** CANCELLO GLI ATTUALI DETTAGLI ORDINE PER REIMPORTARLI
		x_agga = "DAGGANCIO = '" + X_TAGG + "'"
		x_codi = "WC_ORDER_KEY = '" + M.ORDER_KEY + "'"
		x_cond = x_agga + " and " + x_codi 
		cSql = "DELETE from U_ORD_DD where " + x_cond
		IF !ExecCommand(cSql,"DEL_ORD_DD")
		   RETURN .F.
		ENDIF
		
	ELSE
		
		SELECT CU_ORD_TT
		SCATTER MEMVAR MEMO BLANK
		
		M.WC_ORDER_KEY = M.ORDER_KEY
		M.WC_DATE_MODIFIED = M.DATE_MODIFIED
		M.TAGGANCIO = STR(NEWPROG('NUMORD'),10)
		X_TAGG = M.TAGGANCIO
		M.ORD_CODSOC = PUB_CODSOC
		M.ORD_VALUTA = M.CURRENCY
		M.ORD_DATORD = STRTRAN(SUBSTR(M.DATE_CREATED,1,10),"-","/")
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
	      v_seek   = ACCESS_YEAR('NUMORD'+PUB_CODSOC)
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
	         RETURN
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
		M.ORD_RIFERI = "Ord. WooCommerce Nr." + ALLTRIM(M.NUMBER)
		M.ORD_ANNO   = SUBSTR(M.ORD_DATORD,1,4)
		M.TNUMERO    = M.ORD_NUMORD
		
		x_cond = "U_ANA_CL.WC_CUSTOMER_ID = " + ALLTRIM(STR(M.CUSTOMER_ID))
		cSql="select U_CLI_AN.CLI_CODCLI, U_CLI_AN.CLI_RAGSOC from u_cli_an left outer join u_ana_cl on u_cli_an.cli_codcli = u_ana_cl.cli_codcli where " + x_cond
		IF !ExecCommand(cSql,"TMP_CLI_CL_AN")
			return(.f.)
		ENDIF
		SELECT TMP_CLI_CL_AN
		GO TOP
		IF !EOF()
			M.ORD_CODCLI = CLI_CODCLI
		ELSE
			DELETE FROM TMP_ORDERS WHERE CUSTOMER_ID = M.CUSTOMER_ID
			DELETE FROM TMP_ORDER_LINE_ITEMS WHERE CUSTOMER_ID = M.CUSTOMER_ID
			SELECT TMP_ORDERS
			LOOP
		ENDIF
		
		M.ORD_CODCLI = seek_u_cli_an('',pub_codsoc+ALLTRIM(M.ORD_CODCLI),'cli_codcli','cli_codcli','','CUR_CLIENTE')
		IF EMPTY(M.ORD_CODCLI)
		   	MESSAGEBOX("Nessun cliente selezionato",64,"*** INFORMAZIONE ***")
			DELETE FROM TMP_ORDERS WHERE CUSTOMER_ID = M.CUSTOMER_ID
			DELETE FROM TMP_ORDER_LINE_ITEMS WHERE CUSTOMER_ID = M.CUSTOMER_ID
			SELECT TMP_ORDERS
			LOOP
		ENDIF


		_blocco_forn = VERIFICA_BLOCCO_FORNITURA_CLIENTE(M.ORD_CODCLI)
		IF _blocco_forn
		  	_cMsg = "ATTENZIONE" + CHR(13) + CHR(13) + "Cliente " + M.ORD_CODCLI + " con blocco fornitura in anagrafica" + CHR(13) + "impossibile creare ordini" + CHR(13) + "Fare click su OK per continuare"
		  	DO MESSAGGIO_STILE_WIN8 WITH _cMsg   
			DELETE FROM TMP_ORDERS WHERE CUSTOMER_ID = M.CUSTOMER_ID
			DELETE FROM TMP_ORDER_LINE_ITEMS WHERE CUSTOMER_ID = M.CUSTOMER_ID
			SELECT TMP_ORDERS
			LOOP
		ENDIF

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
		M.ORD_CODLOC = CLI_LOCDOC
		M.ORD_CPA	= CLI_CONPAG
		M.ORD_BANCA	= CLI_BAE
		M.ORD_CODNAZ = CLI_NAZION
		IF EMPTY(M.ORD_CODNAZ)
		   M.ORD_CODNAZ	= "ITA"
		ENDIF  
		M.ORD_CAUS = PUB_ORDIN
		IF PUB_CLIDIR
		   IF CLI_FLGDIR
		      M.ORD_CAUS = PUB_CAUDIR
		   ENDIF
		ENDIF
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
		M.ORD_CCOSTO     = CLI_CCOST1
		M.ORD_CDIMBA     = CLI_CODIMB
		M.ORD_ACURA      = CLI_MEZZO
		M.ORD_PORTO      = CLI_PORTO
		M.ORD_VETTO1     = CLI_VETTO1
			
		IF !EMPTY(M.PAYMENT_METHOD)
			IF !ExecCommand("select * from para where codice = 'CPA" + SUBSTR(UPPER(ALLTRIM(M.PAYMENT_METHOD)),1,10) + "'","cx_para")
				return
			ENDIF
			SELECT CX_PARA
			GO TOP
			IF !EOF()
				M.ORD_CPA = SUBSTR(CODICE,4,10)
			ELSE
				cSql = "select * from para WHERE 1=0"
				IF !ExecRW(cSql,"PARA","R")
					return
				ENDIF
				SELECT PARA
				APPEND BLANK
				REPLACE CODICE WITH "CPA"+SUBSTR(UPPER(ALLTRIM(M.PAYMENT_METHOD)),1,10)
				REPLACE DESCRI WITH UPPER(ALLTRIM(M.PAYMENT_METHOD_TITLE))
				REPLACE LIBERA WITH "DF BON    0 "
				M.ORD_CPA = SUBSTR(CODICE,4,10)
				IF !ExecRW(cSql,"PARA","W")
					return
				ENDIF
			ENDIF
		ELSE
			IF !EMPTY(M.PAYMENT_METHOD_TITLE)
				IF !ExecCommand("select * from para where codice like 'CPA%' AND DESCRI = '" + ALLTRIM(M.PAYMENT_METHOD_TITLE) + "'","cx_para")
					return
				ENDIF
				SELECT CX_PARA
				GO TOP
				IF !EOF()
					M.ORD_CPA = SUBSTR(CODICE,4,10)
				ENDIF
			ENDIF
		ENDIF
		
		IF EMPTY(M.ORD_CPA)
			SELECT CUR_CLIENTE
			M.ORD_CPA = CLI_CONPAG
			IF EMPTY(M.ORD_CPA)
				SELECT CUR_CLIENTE
				M.ORD_CPA = PUB_CPA
			ENDIF
		ENDIF
			  
		_SPBOLL_ = CALCOLA_SPESE_INCASSO(M.ORD_CPA)
		IF PUB_CALCOLA_SPESE_INCASSO_RIBA
			M.ORD_SPBOLL = _SPBOLL_
		ENDIF
		
*!*			*** SCORPORO L'IVA DALLE SPESE DI TRASPORTO
*!*			PERC_ALIQ = 0
*!*			IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(IVA_CLI) + "'","cx_para")
*!*			   return
*!*			ENDIF
*!*			SELECT cx_para
*!*			GO TOP
*!*			IF !EOF()
*!*			   cALIQ = SUBSTR(LIBERA,1,3)
*!*			   PERC_ALIQ = VAL(cALIQ)
*!*			ENDIF
*!*			_SPTRAS_CON_IVA = VAL(STRTRAN(M.SHIPPING_TOTAL,'.',','))
*!*			_SPTRAS_SENZA_IVA = _SPTRAS_CON_IVA / (1 + (PERC_ALIQ/100))
*!*			M.ORD_SPTRAS = _SPTRAS_SENZA_IVA 
		
		M.ORD_SPTRAS = VAL(STRTRAN(M.SHIPPING_TOTAL,'.',','))
		
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
		ELSE
			__ORD_SERV_INTRA_CLIENTE = ""
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
		
		SELECT CU_ORD_TT
		APPEND BLANK
		GATHER MEMVAR MEMO
	
	ENDIF
	
	*** DETAGLI ORDINE
	SELECT * FROM TMP_ORDER_LINE_ITEMS WHERE ORDER_KEY = M.ORDER_KEY ORDER BY ID INTO CURSOR C_TMP_ORDER_LINE_ITEMS
	SELECT C_TMP_ORDER_LINE_ITEMS
	GO TOP
	SCAN
	
		SELECT CU_ORD_DD
		SCATTER MEMVAR MEMO BLANK
		
		SELECT C_TMP_ORDER_LINE_ITEMS
		SCATTER MEMVAR MEMO
		
		M.WC_ORDER_KEY = M.ORDER_KEY
		M.WC_ORDER_LINE_ITEMS_ID = M.ID
		
		M.ORD_CODART = APITOSPA(ALLTRIM(M.SKU))
		M.ORD_DESART = APITOSPA(ALLTRIM(M.NAME))
		M.ORD_QTAORD = M.QUANTITY
		M.DAGGANCIO = X_TAGG
		
		IF EMPTY(M.ORD_CODART)
			M.ORD_CODART = '.'
		ENDIF
		
		IF !ExecCommand("select * from U_ART_PR where ART_CODPRI = '" + ALLTRIM(M.ORD_CODART) + "'","CX_ART_PR")
		   return
		ENDIF
		SELECT CX_ART_PR
		GO TOP
*!*			IF EOF()
*!*				SELECT CX_ART_PR
*!*				USE
*!*				M.ORD_CODART = '.'
*!*				IF !ExecCommand("select * from U_ART_PR where ART_CODPRI = '" + ALLTRIM(M.ORD_CODART) + "'","CX_ART_PR")
*!*				   return
*!*				ENDIF
*!*				SELECT CX_ART_PR
*!*				GO TOP
*!*				IF !EOF()
*!*					__descrizione = M.NAME
*!*				ELSE
*!*					__descrizione = M.NAME
*!*				ENDIF
*!*			ELSE
*!*				__descrizione = ART_DESCR
*!*			ENDIF
		IF EOF()
			*** SE ARTICOLO NON PRESENTE IN ANAGRAFICA AQUARIUS, LO IMPORTO AL MOMENTO DA WOOCOMMERCE
			SELECT CX_ART_PR
			USE
			
			_HTTP_request = "/wp-json/wc/v2/products"
			_par_sku = "sku="+M.ORD_CODART
			_cJsonArt = ""
			_cJsonArt = WOOCOMMREST_GET(_username,_password,_consumer_key,_consumer_secret,_nomesito,_HTTP_request,_par_sku)
			IF !EMPTY(_cJsonArt)
				_ErrorMsg = STRTRAN(STRTRAN(SUBSTR(_cJsonArt, AT('"message":"',_cJsonArt), AT('"',SUBSTR(_cJsonArt, AT('"message":"',_cJsonArt)),4)),'"message":',''),'"','')
				IF EMPTY(_ErrorMsg)
					obj_json_art = json_decode(_cJsonArt)
					IF TYPE("obj_json_art.array(1)") <> "L"
						
						_cProperty = "obj_json_art.Array(1)._NAME"
						IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
							_cCommand = "M.NAME = "+_cProperty
							&_cCommand
						ELSE
							M.NAME = ""
						ENDIF
						
						_cProperty = "obj_json_art.Array(1)._SHORT_DESCRIPTION"
						IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
							_cCommand = "M.SHORT_DESCRIPTION = "+_cProperty
							&_cCommand
						ELSE
							M.SHORT_DESCRIPTION = ""
						ENDIF
						
						_cProperty = "obj_json_art.Array(1)._DESCRIPTION"
						IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
							_cCommand = "M.DESCRIPTION = "+_cProperty
							&_cCommand
						ELSE
							M.DESCRIPTION = ""
						ENDIF						
						
						_cProperty = "obj_json_art.Array(1)._REGULAR_PRICE"
						IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
							_cCommand = "M.REGULAR_PRICE = VAL(STRTRAN(ALLTRIM("+_cProperty+"),'.',','))"
							&_cCommand
						ELSE
							M.REGULAR_PRICE = 0
						ENDIF
						
						_cProperty = "obj_json_art.Array(1)._PRICE_ITA"
						IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
							_cCommand = "M.PRICE_ITA = VAL(STRTRAN(ALLTRIM("+_cProperty+"),'.',','))"
							&_cCommand
						ELSE
							M.PRICE_ITA = 0
						ENDIF
						
						_cProperty = "obj_json_art.Array(1)._PRICE_EXT"
						IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
							_cCommand = "M.PRICE_EXT = VAL(STRTRAN(ALLTRIM("+_cProperty+"),'.',','))"
							&_cCommand
						ELSE
							M.PRICE_EXT = 0
						ENDIF
						
						_cProperty = "obj_json_art.Array(1)._WEIGHT"
						IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
							_cCommand = "M.WEIGHT = VAL(STRTRAN(ALLTRIM("+_cProperty+"),'.',','))"
							&_cCommand
						ELSE
							M.WEIGHT = 0
						ENDIF
						
												
						Csql = "select * from u_art_pr where 1=0"
						IF !ExecRW(cSql,"U_ART_PR","R")
						   return(.f.)
						ENDIF
						SELECT U_ART_PR
						IF EOF()
						   APPEND BLANK
						   REPLACE ART_CODSOC	WITH PUB_CODSOC
						   REPLACE ART_CODPRI 	WITH M.ORD_CODART
						   REPLACE ART_DESCR  	WITH APITOSPA(M.NAME)
						   REPLACE ART_DESRID	WITH APITOSPA(M.SHORT_DESCRIPTION)
						   REPLACE ART_PRZVEN	WITH M.PRICE_ITA
						   REPLACE ART_PRZVE2	WITH M.PRICE_EXT
						   REPLACE ART_PESOUM	WITH M.WEIGHT
						   REPLACE ART_DATINS	WITH RIBALTA2(DTOC(DATE()))
						   REPLACE ART_DATVAR	WITH RIBALTA2(DTOC(DATE()))
						   REPLACE ART_LINEA	WITH PUB_LINEA
						   REPLACE ART_UNIMIS	WITH PUB_UM
						   REPLACE ART_UMMAGA	WITH PUB_UM
						   REPLACE ART_CODIVA	WITH PUB_IVA
						   REPLACE ART_MAGA		WITH PUB_CODM
						   REPLACE ART_CODMAT	WITH "001"
						ENDIF
						IF !ExecRW(cSql,"U_ART_PR","W")
						   return(.f.)
						ENDIF
						
						Csql   = "select * from u_art_an where 1=0"
						IF !ExecRW(cSql,"U_ART_AN","R")
						   return(.f.)
						ENDIF
						SELECT U_ART_AN
						IF EOF()
						   APPEND BLANK
						   REPLACE ART_CODSOC		WITH PUB_CODSOC
						   REPLACE ART_CODPRI		WITH M.ORD_CODART
						   REPLACE ART_DESCRWEB		WITH APITOSPA(M.NAME)
						   REPLACE ART_PRZVENWEB	WITH M.REGULAR_PRICE
						   REPLACE ART_SCHEDA		WITH APITOSPA(M.DESCRIPTION)
						ENDIF
						IF !ExecRW(cSql,"u_art_an","W")
						   return(.f.)
						ENDIF
						
					ENDIF
				ENDIF
			ENDIF
			RELEASE _cJsonArt
			
			IF !ExecCommand("select * from U_ART_PR where ART_CODPRI = '" + ALLTRIM(M.ORD_CODART) + "'","CX_ART_PR")
			   return
			ENDIF
			SELECT CX_ART_PR
			GO TOP
			IF EOF()
				SELECT CX_ART_PR
				USE
				M.ORD_CODART = '.'
				IF !ExecCommand("select * from U_ART_PR where ART_CODPRI = '" + ALLTRIM(M.ORD_CODART) + "'","CX_ART_PR")
				   return
				ENDIF
			ENDIF
		ENDIF
		
		M.ORD_CODART  = ART_CODPRI
		M.ORD_MAGA	  = ART_MAGA 
		*M.ORD_DESART  = __descrizione
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

		SELECT CX_ART_PR
		M.ORD_UM	  = ART_UMMAGA  
		M.ORD_UMFIN	  = ART_UMMAGA  
		M.ORD_UMBAR	  = ART_UMMAGA  
		M.ORD_UMSEZ	  = ART_UMMAGA  
		M.ORD_IVA	  = ART_CODIVA
		*M.ORD_PREZZO  = VAL(STRTRAN(M.TOTAL,'.',',')) / M.QUANTITY
		*IF M.ORD_PREZZO = 0				&& SERGIO 2015/01/28 SE SELEZIONO UN LISTINO CON L'APPOSITO TASTO PERDE IL PREZZO DEL LISTINO
		*	M.ORD_PREZZO  = ART_PRZVEN
		*ENDIF
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
		IF !EMPTY(m.ord_dtcons)
		   m.ord_DATCON  = m.ord_dtcons
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
		
		*** SE CLIENTE IN ESENZIONE IVA VERIFICA SE IVA ARTICOLO IN ESENZIONE E NEL CASO MANTIENE QUESTA ALIQUOTA 
		*** ALTRIMENTI GESTISCE L'ALIQUOTA IN ESENZIONE A LIVELLO DI CLIENTE
		IF !EMPTY(IVA_ESE)					
		  PERC_ALIQ = 0
		  IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(M.ORD_IVA) + "'","cx_para")
		     return
		  ENDIF
		  SELECT cx_para
		  GO TOP
		  IF !EOF()
		     cALIQ = SUBSTR(LIBERA,1,3)
		     PERC_ALIQ = VAL(cALIQ)
		  ENDIF
		  IF PERC_ALIQ > 0
		     M.ORD_IVA = IVA_ESE			&& ALIQUOTA NON IN ESENZIONE FORZO L'IVA DI ESENZIONE A LIVELLO DI CLIENTE
		  ENDIF
		ELSE
			IF PUB_IVANAG 					&& GESTIONE IVA PRELEVATA DALL'ANAGRAFICA CLENTI

			    IF !EMPTY(IVA_CLI)
					M.ORD_IVA = IVA_CLI
				ELSE
				    PUB_ERRORE=MESSAGEBOX('In anagrafica clienti non hai codificato il codice iva !!!!'+CHR(13)+'provvedi perfavore,per ora gestisco il codice iva articolo',64,'*** ATTENZIONE ***') 
				ENDIF
				
			ENDIF 
		ENDIF 

*!*			*** PER IL CALCOLO DEL LISTINO MI DEVO RIFERIRE ALL'ARTICOLO CLIENTE, 
*!*			*** SE GESTITO E SE DIVERSO DALL'ARTICOLO MAGAZZINO
*!*			LOCAL _OLD_ORD_CODART
*!*			IF PUB_CDAPRD AND !EMPTY(M.ORD_CDAPRD) AND ESISTE_ARTICOLO(M.ORD_CDAPRD)
*!*				_OLD_ORD_CODART = M.ORD_CODART
*!*				M.ORD_CODART = M.ORD_CDAPRD
*!*			ENDIF


*!*			V_TIPO = CERCATIPO(M.ORD_CODART)


*!*			DO OK_LIST     && GESTISCE I LISTINI
		
		PERC_ALIQ = 0
		IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(M.ORD_IVA) + "'","cx_para")
		   return
		ENDIF
		SELECT cx_para
		GO TOP
		IF !EOF()
		   cALIQ = SUBSTR(LIBERA,1,3)
		   PERC_ALIQ = VAL(cALIQ)
		ENDIF
		*_PREZZO_CON_IVA = VAL(STRTRAN(M.TOTAL,'.',',')) / M.QUANTITY
		*_PREZZO_SENZA_IVA = _PREZZO_CON_IVA / (1 + (PERC_ALIQ/100))
		*M.ORD_PREZZO = _PREZZO_SENZA_IVA 
		*M.ORD_PREZZO = VAL(STRTRAN(M.PRICE,'.',','))
		M.ORD_PREZZO = VAL(STRTRAN(M.TOTAL,'.',',')) / M.ORD_QTAORD

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
		
		IF PUB_CTRTAG .OR. PUB_CTRCOL
		   IF M.ORD_CODTAG <> SPACE(03) .OR. M.ORD_CODCOL <> SPACE(03)
		   ELSE
		      DO FORM FORM\TAGCOL00 WITH "M.ORD_CODART",M.ORD_CODART,"M.ORD_DESART",M.ORD_DESART, ;
		                            "M.ORD_CODCOL",M.ORD_CODCOL,"M.ORD_DESCOL",M.ORD_DESCOL, ;
		                            "M.ORD_CODTAG",M.ORD_CODTAG,"M.ORD_DESTAG",M.ORD_DESTAG, ;
		                            .T.
		   ENDIF
		ENDIF

*!*			IF PUB_CDAPRD AND !EMPTY(M.ORD_CDAPRD) AND ESISTE_ARTICOLO(M.ORD_CDAPRD)
*!*				M.ORD_CODART = _OLD_ORD_CODART
*!*			ENDIF

		M.ORD_UMCLI  = ""
		M.ORD_PRECLI = 0
		M.ORD_QTACLI = 0
		
		M.ORD_SEQUEN = M.ID * 10
		
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
        
        SELECT CU_ORD_DD
        APPEND BLANK
        GATHER MEMVAR MEMO         
	ENDSCAN
	
	M.WC_ORDER_KEY = M.ORDER_KEY
	M.WC_ORDER_LINE_ITEMS_ID = 0
	
	U_CANCELLA = .T.
	PUB_DAGGANCIO = M.TAGGANCIO	&& SERGIO : SERVE PER CANCELLARE IN AUTOMATICO I COMMENTI VECCHI PRIMA DEL NUOVO INSERIMENTO DELLO STESSO COMMENTO , ALTRIMENTI HO DEI COMMENTI DOPPI
	=CREA_NOTE("ORD","CU_ORD_DD")
	PUB_DAGGANCIO = ""			&& SERGIO : SERVE PER CANCELLARE IN AUTOMATICO I COMMENTI VECCHI PRIMA DEL NUOVO INSERIMENTO DELLO STESSO COMMENTO , ALTRIMENTI HO DEI COMMENTI DOPPI

	PUB_DAGGANCIO = M.TAGGANCIO
	=CREA_NOTE_CLIENTE("ORD",M.ORD_CODCLI,"CU_ORD_DD",PUB_DAGGANCIO,M.ORD_PESNET)
	PUB_DAGGANCIO = ""
	DO GESTIONE_ARTICOLI_AUTOMATICI WITH "ORD",M.ORD_CODCLI,"CU_ORD_DD"
	DO GESTIONE_ARTICOLO_SCONTO_CASSA WITH "ORD",M.ORD_CODCLI,"CU_ORD_DD",.F.,"M.ORD_SCASSA"
	
	* RICALCOLA IL VALORE DEL DOCUMENTO
	SELECT CU_ORD_DD
	SET FILTER TO DAGGANCIO = X_TAGG AND ORD_FLGMOD <> 'A'	 
	DO CALCORD
	SET FILTER TO
	
	SELECT CU_ORD_TT
	REPLACE ORD_VALORE WITH M.ORD_VALORE
	REPLACE ORD_IMPONIB WITH M.ORD_IMPONIB 
	REPLACE ORD_IMPOSTA WITH M.ORD_IMPOSTA 

ENDSCAN

_CONTA = 0
SELECT TMP_ORDERS
GO TOP
SCAN
	_CONTA = _CONTA + 1
ENDSCAN

IF !ExecRW('','U_ORD_TT','I','','CU_ORD_TT')
   return(.f.)
ENDIF

IF !ExecRW('','U_ORD_DD','I','','CU_ORD_DD')
   return(.f.)
ENDIF

IF !ExecRW('','WC_ORDERS','I','','TMP_ORDERS')
   return(.f.)
ENDIF

IF !ExecRW('','WC_ORDER_LINE_ITEMS','I','','TMP_ORDER_LINE_ITEMS')
   return(.f.)
ENDIF

WAIT CLEAR

_MESSAGGIO = ""
IF _CONTA > 0
	_MESSAGGIO = "Totale ordini inseriti/aggiornati: " + ALLTRIM(STR(_CONTA))
ELSE
	_MESSAGGIO = "Nessun ordine inserito/aggiornato"
ENDIF
IF _CONTA_CLI > 0
	_MESSAGGIO = _MESSAGGIO + REPLICATE(CHR(13),2) + "Totale nuovi clienti inseriti: " + ALLTRIM(STR(_CONTA_CLI))
ENDIF

MESSAGEBOX(_MESSAGGIO,64,"Informazione")

RETURN
