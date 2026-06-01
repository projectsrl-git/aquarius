
LPARAMETERS _par_scheduled_codsys

_LOG_CODSYS = SYS(2015)
IF PCOUNT() = 0
	_LOG_CODSYS = SYS(2015)
ELSE
	IF !ISNULL(_par_scheduled_codsys) AND !EMPTY(_par_scheduled_codsys)
		_LOG_CODSYS = _par_scheduled_codsys
	ENDIF
ENDIF 

IF EMPTY(PUB_ECURL) OR EMPTY(PUB_ECAUTK) OR EMPTY(PUB_ECMAGA)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'E-commerce REST API Authentication'",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() >= 1
ELSE
	_RISP = MESSAGEBOX("Importare gli ordini e-commerce non ancora scaricati?",4+32,"Attenzione")
	IF _RISP = 7
		RETURN .F.
	ENDIF
ENDIF

*!*	_nAnno = VAL(SUBSTR(DTOC(DATE()),7,4))
*!*	_nMese = VAL(SUBSTR(DTOC(DATE()),4,2))
*!*	_nMese = _nMese - 1
*!*	IF _nMese = 0
*!*		_nMese = 12
*!*		_nAnno = _nAnno - 1
*!*	ENDIF
*!*	_Anno = TRC(4,ALLTRIM(STR(_nAnno,4,0)))
*!*	_Mese = TRC(2,ALLTRIM(STR(_nMese,2,0)))

*!*	_V_DATADA = "01/" + _Mese + "/" + _Anno  && DATA INIZIO MESE PRECEDENTE
*!*	_V_DATAAL = DTOC(DATE())

*!*	_CONTINUA = .F.
*!*	DO FORM FORM\WOOCOMMERCE_SELDATE LINKED
*!*	IF !_CONTINUA
*!*		MESSAGEBOX("Operazione abbandonata",48,"Informazione")
*!*		RETURN .F.
*!*	ENDIF

_LOG_PROCEDURA = "IMPORT_ORDINI"
_MESSAGGIO = "1 - Inizio procedura"
DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO

_endpoint_url = ALLTRIM(PUB_ECURL)
_auth_key = ALLTRIM(PUB_ECAUTK)

_HTTP_request = _endpoint_url+"/orders"	
_cJson = ""

WAIT WINDOWS "Connessione a '"+_HTTP_request+"' in corso..." NOWAIT

_cJson = ECOMMREST_POST(_HTTP_request,_auth_key)
IF EMPTY(_cJson)
	_MESSAGGIO = "Nessuna risposta da '"+_nomesito+_HTTP_request+"': verificare la URL e che sia disponibile una connessione internet"
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"KO",_MESSAGGIO
	*WAIT WINDOWS _MESSAGGIO TIMEOUT 3
	WAIT WINDOWS SUBSTR(_MESSAGGIO,1,200) TIMEOUT 3  && ERASMO - 20/01/2023
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione file Json in corso..." NOWAIT

IF SUBSTR(_cJson,1,2) == "KO"
	_MESSAGGIO = "Errore " + ALLTRIM(SUBSTR(_cJson,5))
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"KO",_MESSAGGIO
	*WAIT WINDOWS _MESSAGGIO TIMEOUT 3
	WAIT WINDOWS SUBSTR(_MESSAGGIO,1,200) TIMEOUT 3  && ERASMO - 20/01/2023
	RETURN .F.
ENDIF

obj_json = json_decode(_cJson)

*** OGGETTO JSON VUOTO
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
ELSE
	_MESSAGGIO = "Oggetto Json restituito vuoto o non valido"
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"KO",_MESSAGGIO
	*WAIT WINDOWS _MESSAGGIO TIMEOUT 3
	WAIT WINDOWS SUBSTR(_MESSAGGIO,1,200) TIMEOUT 3  && ERASMO - 20/01/2023
	RETURN .F.
ENDIF

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DEGLI ORDINI PRESENTI SU E-COMMERCE
CREATE CURSOR TMP_ORDERS ( ;
	id C(50), ;
	code C(50), ;
	date C(50), ;
	notes M, ;
	subtotal C(50), ;
	tax C(50), ;
	shipment C(50), ;
	total C(50), ;
	created_at C(50), ;
	updated_at C(50), ;
	download_date C(50), ;	
    shipping_name C(200), ;
    shipping_first_name C(200), ;
    shipping_last_name C(200), ;
    shipping_email C(200), ;
    shipping_vat C(50), ;
    shipping_phone C(100), ;
    shipping_address C(200), ;
    shipping_zip_code C(50), ;
    shipping_city C(200), ;
    shipping_province C(50), ;
    shipping_country C(50), ;
    shipping_note M, ;
    payment_transaction C(100), ;
	qty C(50), ;
	original_price C(50), ;
	price C(50), ;
	vat C(50), ;
	product C(50), ;
    payment_conditions_id C(50), ;
    payment_conditions_code C(100), ;
    payment_conditions_name C(200), ;
	customer_id C(50), ;
	customer_code C(50), ;
	customer_name C(200), ;
	customer_first_name C(200), ;
	customer_last_name C(200), ;
	customer_created_at C(50), ;
	customer_updated_at C(50), ;
	customer_address C(200), ;
	customer_zip_code C(50), ;
	customer_city C(200), ;
	customer_province C(50), ;
	customer_country C(50), ;
	customer_phone C(100), ;
	customer_external_code C(50), ;
	customer_email C(200), ;
	customer_vat C(50), ;
	customer_pec C(200), ;
	customer_sdi C(50), ;
	customer_fiscal_code C(50), ;
	customer_note C(254), ;
	customer_privacy C(50), ;
	customer_marketing C(50), ;
	customer_class_code C(50), ;
	customer_group_code C(50))

*!*	cSql="select * from WC_ORDERS where 1=0"
*!*	IF !ExecCommand(cSql,"TMP_ORDERS")
*!*		return(.f.)
*!*	ENDIF

*!*	cSql="select * from WC_ORDER_LINE_ITEMS where 1=0"
*!*	IF !ExecCommand(cSql,"TMP_ORDER_LINE_ITEMS")
*!*		return(.f.)
*!*	ENDIF

*gnFieldcount = AFIELDS(gaMyArray)

FOR I_row = 1 TO ALEN(OBJ_JSON._ORDERS.Array,1)
	
	SELECT TMP_ORDERS
	SCATTER MEMVAR MEMO BLANK
	
	*** VERIFICO LA PRESENZA DI ALMENO 1 ORDINE
	_cObject = "obj_json._ORDERS.ARRAY(I_row)"
	*IF TYPE(_cObject) <> 'U' AND TYPE(_cObject,1) == 'A' AND !ISNULL(&_cObject)
	IF TYPE(_cObject) <> 'U' AND !ISNULL(&_cObject)
	ELSE
		LOOP
	ENDIF
	
	*** ESCLUDO ORDINI SENZA CLIENTE
	_cProperty = "OBJ_JSON._ORDERS.Array("+ALLTRIM(STR(I_row))+")._CUSTOMER_ID"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		IF &_cProperty = 0
			LOOP
		ENDIF
	ENDIF
	
	_cProperty = "OBJ_JSON._ORDERS.Array("+ALLTRIM(STR(I_row))+")._ID"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_cCommand = "M.EC_ORDER_ID = "+_cProperty
		&_cCommand
	ENDIF
	
	_cProperty = "OBJ_JSON._ORDERS.Array("+ALLTRIM(STR(I_row))+")._CODE"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_cCommand = "M.ORDER_CODE = "+_cProperty
		&_cCommand
	ENDIF
		
	=AMEMBERS(gaPropArray, obj_json._ORDERS.ARRAY(I_row), 0)  && Array containing properties
	
	_cPropertyRows = ""
	FOR I_col=1 TO ALEN(gaPropArray)
		*** DATI DI TESTATA
		_cProperty = "OBJ_JSON._ORDERS.Array("+ALLTRIM(STR(I_row))+")."+ALLTRIM(gaPropArray(I_col))
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			IF SUBSTR(ALLTRIM(gaPropArray(I_col)),1,1) = "_"
				_cCommand = "M."+SUBSTR(ALLTRIM(gaPropArray(I_col)),2)+" = "+_cProperty
				&_cCommand
			ENDIF
		ENDIF
		
		*** DATI CLIENTE (TESTATA)
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) = 'O' AND !ISNULL(&_cProperty) AND UPPER(ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))) = "CUSTOMER"
			=AMEMBERS(gaPropArrayDet, &_cProperty, 0)  && Array containing properties
			FOR I_col_det=1 TO ALEN(gaPropArrayDet)
				_cPropertyDet = _cProperty+"."+ALLTRIM(gaPropArrayDet(I_col_det))
				IF TYPE(_cPropertyDet) <> 'U' AND TYPE(_cPropertyDet) <> 'O' AND !ISNULL(&_cPropertyDet)
					IF SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),1,1) = "_"
						_cCommand = "M."+ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))+"_"+SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),2)+" = "+_cPropertyDet
						&_cCommand
					ENDIF
				ENDIF
				
				IF TYPE(_cPropertyDet) <> 'U' AND TYPE(_cPropertyDet) = 'O' AND !ISNULL(&_cPropertyDet) AND UPPER(ALLTRIM(SUBSTR(_cPropertyDet,RAT(".",_cPropertyDet,1)+2))) = "CUSTOMER_CLASS"
					=AMEMBERS(gaPropArrayDetCustomer, &_cPropertyDet, 0)  && Array containing properties
					FOR I_col_det_customer=1 TO ALEN(gaPropArrayDetCustomer)
						_cPropertyDetCustomer = _cPropertyDet+"."+ALLTRIM(gaPropArrayDetCustomer(I_col_det_customer))
						IF TYPE(_cPropertyDetCustomer) <> 'U' AND TYPE(_cPropertyDetCustomer) <> 'O' AND !ISNULL(&_cPropertyDetCustomer)
							IF SUBSTR(ALLTRIM(gaPropArrayDetCustomer(I_col_det_customer)),1,1) = "_"
								_cCommand = "M."+ALLTRIM(SUBSTR(_cPropertyDet,RAT(".",_cPropertyDet,1)+2))+"_"+SUBSTR(ALLTRIM(gaPropArrayDetCustomer(I_col_det_customer)),2)+" = "+_cPropertyDetCustomer
								&_cCommand
							ENDIF
						ENDIF
					NEXT
				ENDIF
				
				IF TYPE(_cPropertyDet) <> 'U' AND TYPE(_cPropertyDet) = 'O' AND !ISNULL(&_cPropertyDet) AND UPPER(ALLTRIM(SUBSTR(_cPropertyDet,RAT(".",_cPropertyDet,1)+2))) = "CUSTOMER_GROUP"
					=AMEMBERS(gaPropArrayDetCustomer, &_cPropertyDet, 0)  && Array containing properties
					FOR I_col_det_customer=1 TO ALEN(gaPropArrayDetCustomer)
						_cPropertyDetCustomer = _cPropertyDet+"."+ALLTRIM(gaPropArrayDetCustomer(I_col_det_customer))
						IF TYPE(_cPropertyDetCustomer) <> 'U' AND TYPE(_cPropertyDetCustomer) <> 'O' AND !ISNULL(&_cPropertyDetCustomer)
							IF SUBSTR(ALLTRIM(gaPropArrayDetCustomer(I_col_det_customer)),1,1) = "_"
								_cCommand = "M."+ALLTRIM(SUBSTR(_cPropertyDet,RAT(".",_cPropertyDet,1)+2))+"_"+SUBSTR(ALLTRIM(gaPropArrayDetCustomer(I_col_det_customer)),2)+" = "+_cPropertyDetCustomer
								&_cCommand
							ENDIF
						ENDIF
					NEXT
				ENDIF
			NEXT
		ENDIF
		
*!*			*** DATI SPEDIZIONE (TESTATA)
*!*			IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) = 'O' AND !ISNULL(&_cProperty) AND UPPER(ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))) = "ADDRESS"
*!*				=AMEMBERS(gaPropArrayDet, &_cProperty, 0)  && Array containing properties
*!*				FOR I_col_det=1 TO ALEN(gaPropArrayDet)
*!*					_cPropertyDet = _cProperty+"."+ALLTRIM(gaPropArrayDet(I_col_det))
*!*					IF TYPE(_cPropertyDet) <> 'U' AND TYPE(_cPropertyDet) <> 'O' AND !ISNULL(&_cPropertyDet)
*!*						IF SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),1,1) = "_"
*!*							_cCommand = "M."+ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))+"_"+SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),2)+" = "+_cPropertyDet
*!*							&_cCommand
*!*						ENDIF
*!*					ENDIF
*!*				NEXT
*!*			ENDIF

		*** DATI PAGAMENTO (TESTATA)
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) = 'O' AND !ISNULL(&_cProperty) AND UPPER(ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))) = "PAYMENT"
			=AMEMBERS(gaPropArrayDet, &_cProperty, 0)  && Array containing properties
			FOR I_col_det=1 TO ALEN(gaPropArrayDet)
				_cPropertyDet = _cProperty+"."+ALLTRIM(gaPropArrayDet(I_col_det))
				IF TYPE(_cPropertyDet) <> 'U' AND TYPE(_cPropertyDet) <> 'O' AND !ISNULL(&_cPropertyDet)
					IF SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),1,1) = "_"
						_cCommand = "M."+ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))+"_CONDITIONS_"+SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),2)+" = "+_cPropertyDet
						&_cCommand
					ENDIF
				ENDIF
			NEXT
		ENDIF
		
		*** ARRAY CHE CONTIENE I DATI DI DETTAGLIO
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) = 'O' AND !ISNULL(&_cProperty) AND UPPER(ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))) = "ROWS"
			_cPropertyRows = _cProperty+".ARRAY"
		ENDIF
		
	NEXT
	
	*** DATI DI DETTAGLIO
	IF !EMPTY(_cPropertyRows)
		=AMEMBERS(gaPropArrayDet, &_cPropertyRows, 0)  && Array containing properties
		
		FOR I_row_det = 1 TO ALEN(&_cPropertyRows,1)
			FOR I_col_det=1 TO ALEN(gaPropArrayDet)
				_cPropertyDet = _cPropertyRows+"("+ALLTRIM(STR(I_row_det))+")."+ALLTRIM(gaPropArrayDet(I_col_det))
				IF TYPE(_cPropertyDet) <> 'U' AND TYPE(_cPropertyDet) <> 'O' AND !ISNULL(&_cPropertyDet)
					IF SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),1,1) = "_"
						_cCommand = "M."+SUBSTR(ALLTRIM(gaPropArrayDet(I_col_det)),2)+" = "+_cPropertyDet
						&_cCommand
					ENDIF
				ENDIF
			NEXT
			
			SELECT TMP_ORDERS
			APPEND BLANK
			GATHER MEMVAR MEMO				
		NEXT
	ENDIF
	
NEXT

RELEASE obj_json

SELECT TMP_ORDERS
GO TOP
IF EOF()
	_MESSAGGIO = "3 - Nessun nuovo ordine da scaricare"
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
	*WAIT WINDOWS _MESSAGGIO TIMEOUT 3
	WAIT WINDOWS SUBSTR(_MESSAGGIO,1,200) TIMEOUT 3  && ERASMO - 20/01/2023
ENDIF

*BROWSE NORMAL
*SET STEP ON
*RETURN

WAIT WINDOWS "Elaborazione per anagrafica Clienti in corso..." NOWAIT

*** ELABORAZIONE PER CONTROLLO ANAGRAFICA CLIENTI
_ATTIVA_INSERIMENTO_NUOVI_CLIENTI = .F.
_ATTIVA_AGGIORNAMENTO_CLIENTI = .F.
SELECT CUSTOMER_ID, CUSTOMER_EXTERNAL_CODE, CUSTOMER_FIRST_NAME, CUSTOMER_LAST_NAME, CUSTOMER_UPDATED_AT, SPACE(10) AS CLI_CODCLI, SPACE(200) AS CLI_RAGSOC, .F. AS CLI_DA_AGG FROM TMP_ORDERS ;
	GROUP BY CUSTOMER_ID, CUSTOMER_EXTERNAL_CODE, CUSTOMER_FIRST_NAME, CUSTOMER_LAST_NAME, CUSTOMER_UPDATED_AT ORDER BY CUSTOMER_ID DESC INTO CURSOR CU_CUSTOMERS READWRITE
SELECT CU_CUSTOMERS
GO TOP
SCAN
	_CLI_DA_AGG = .F.
	_CLI_CODCLI = ""
	_CLI_RAGSOC = ""
	_CUSTOMER_UPDATED_AT = ALLTRIM(CUSTOMER_UPDATED_AT)
	_EC_CUSTOMER_ID = VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0)))
	_EC_CUSTOMER_EXTERNAL_CODE = ALLTRIM(CUSTOMER_EXTERNAL_CODE)
	x_cond = "U_ANA_CL.EC_CUSTOMER_ID = " + ALLTRIM(STR(_EC_CUSTOMER_ID,50,0))
	cSql="select U_CLI_AN.CLI_CODCLI, U_CLI_AN.CLI_RAGSOC, U_ANA_CL.EC_CUSTOMER_UPDATED_AT from u_cli_an left outer join u_ana_cl on u_cli_an.cli_codcli = u_ana_cl.cli_codcli where " + x_cond
	IF !ExecCommand(cSql,"TMP_CLI_CL_AN")
		return(.f.)
	ENDIF
	SELECT TMP_CLI_CL_AN
	GO TOP
	IF EOF()
		x_cond = "U_CLI_AN.CLI_CODCLI = '" + _EC_CUSTOMER_EXTERNAL_CODE + "'"
		cSql="select U_CLI_AN.CLI_CODCLI, U_CLI_AN.CLI_RAGSOC, U_ANA_CL.EC_CUSTOMER_UPDATED_AT from u_cli_an left outer join u_ana_cl on u_cli_an.cli_codcli = u_ana_cl.cli_codcli where " + x_cond
		IF !ExecCommand(cSql,"TMP_CLI_CL_AN")
			return(.f.)
		ENDIF
		SELECT TMP_CLI_CL_AN
		GO TOP
		IF EOF()
			_CLI_CODCLI = "NUOVO!"
			_CLI_RAGSOC = ""
			_ATTIVA_INSERIMENTO_NUOVI_CLIENTI = .T.
		ELSE
			_CLI_CODCLI = CLI_CODCLI
			_CLI_RAGSOC = CLI_RAGSOC
			*IF !EMPTY(_CUSTOMER_UPDATED_AT) AND ALLTRIM(_CUSTOMER_UPDATED_AT) > ALLTRIM(EC_CUSTOMER_UPDATED_AT)
				_ATTIVA_AGGIORNAMENTO_CLIENTI = .T.
				_CLI_DA_AGG = .T.
			*ENDIF
		ENDIF
	ELSE
		_CLI_CODCLI = CLI_CODCLI
		_CLI_RAGSOC = CLI_RAGSOC
		IF !EMPTY(_CUSTOMER_UPDATED_AT) AND ALLTRIM(_CUSTOMER_UPDATED_AT) > ALLTRIM(EC_CUSTOMER_UPDATED_AT)
			_ATTIVA_AGGIORNAMENTO_CLIENTI = .T.
			_CLI_DA_AGG = .T.
		ENDIF
	ENDIF
	
	SELECT CU_CUSTOMERS
	REPLACE CLI_CODCLI WITH _CLI_CODCLI
	REPLACE CLI_RAGSOC WITH _CLI_RAGSOC
	REPLACE CLI_DA_AGG WITH _CLI_DA_AGG
ENDSCAN

_CONTA_CLI_INS = 0

IF _ATTIVA_INSERIMENTO_NUOVI_CLIENTI
	x_cond = "codice = 'NUMCLI" + PUB_CODSOC + "'"
	cSql   = "select * from para where " + x_cond 
	IF !ExecCommand(cSql,"TMP_PARA")
	   return(.f.)
	ENDIF
	SELECT TMP_PARA
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
	
	SELECT CU_CUSTOMERS
	GO TOP
	SCAN
		IF ALLTRIM(CLI_CODCLI) = "NUOVO!"
		ELSE
			LOOP
		ENDIF
		
		_EC_CUSTOMER_ID = VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0)))
		_EC_CUSTOMER_UPDATED_AT = ALLTRIM(CUSTOMER_UPDATED_AT)
		
		*** CREAZIONE NUOVA ANAGRAFICA CLIENTE
		SELECT TOP 1 * FROM TMP_ORDERS WHERE VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0))) = _EC_CUSTOMER_ID ORDER BY ID INTO CURSOR TMP_ORDERS_CUSTOMER
		SELECT TMP_ORDERS_CUSTOMER
		GO TOP
		IF EOF()
			DELETE FROM TMP_ORDERS WHERE VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0))) = _EC_CUSTOMER_ID
			SELECT CU_CUSTOMERS
			LOOP
		ENDIF
		
		*X_VALUTA  = UPPER(ALLTRIM(CURRENCY))
		*IF EMPTY(X_VALUTA)
			X_VALUTA = PUB_VALRIF
		*ENDIF
		X_AGE    = PUB_AGE
		X_CODIVA = PUB_IVA
		*X_CONPAG = "103"
		X_CONPAG = "989"  && ERASMO - 14/04/2022
		X_IVACEE = ""
		X_CODFIS = ""
		X_ZONA   = ""
		X_PARIVA = "."
		X_FAX    = ""
		X_RICERC = ""
		X_TELEX  = ""
		X_WEB    = ""
		X_CCOSTO = "ITADIR"
		
		IF !EMPTY(ALLTRIM(customer_name))
			X_RAGSOC = APITOSPA(ALLTRIM(customer_name))
			X_RAGDUE = APITOSPA(ALLTRIM(customer_first_name) + " " + ALLTRIM(customer_last_name))
		ELSE
			X_RAGSOC = APITOSPA(ALLTRIM(customer_first_name) + " " + ALLTRIM(customer_last_name))
			X_RAGDUE = ""
		ENDIF
		X_INDIR  = ALLTRIM(customer_address)
		X_NAZION = UPPER(ALLTRIM(customer_country))
		X_CAP    = ALLTRIM(customer_zip_code)
		X_LOCALI = ALLTRIM(customer_city)
		X_PROVIN = ALLTRIM(customer_province)
		X_TELEFO = ALLTRIM(customer_phone)
		X_EMAIL  = ALLTRIM(customer_email)
		
		**=> ERASMO - INIZIO 14/04/2022
		IF SUBSTR(X_NAZION,1,2) == "IT"
			_ok_controllo_cap = .T.
			IF LEN(X_CAP) = 5
				FOR I=1 TO LEN(X_CAP)
					_cCarattereNEsimo = SUBSTR(X_CAP,I,1)
					IF !ISDIGIT(_cCarattereNEsimo)
						_ok_controllo_cap = .F.
					ENDIF
				NEXT
			ELSE
				_ok_controllo_cap = .F.
			ENDIF
			IF !_ok_controllo_cap
				X_CAP = ""
			ENDIF
			
			x_cond = "COMUNE = '" + UPPER(STRTRAN(X_LOCALI,"'","`")) + "'"
			cSql   = "select * from COMUNI WHERE " + x_cond + " order by COMUNE"
			IF !ExecCommand(cSql,"TMP_COMUNI")
			   return(.f.)
			ENDIF
			SELECT TMP_COMUNI
			GO TOP
			IF !EOF()
				X_LOCALI = ALLTRIM(COMUNE)
				X_PROVIN = ALLTRIM(PROVINCIA)
				IF !_ok_controllo_cap
					X_CAP = ALLTRIM(CAP)
				ENDIF
			ENDIF
			SELECT TMP_ORDERS_CUSTOMER
		ENDIF
		**=> ERASMO - FINE 14/04/2022
		
		X_PEC    = ALLTRIM(customer_pec)
		X_SDI    = ALLTRIM(customer_sdi)
		X_PARIVA = ALLTRIM(customer_vat)
		X_CODFIS = ALLTRIM(customer_fiscal_code)
		X_PRVACY = ALLTRIM(STR(VAL(customer_privacy),1,0))
		X_NOTE   = ALLTRIM(customer_note)
		*X_CANVEN = "DIRB2C"+PADL(ALLTRIM(customer_class_code),3,'0')
		X_CANVEN = ALLTRIM(customer_class_code)  && ERASMO - 17/03/2022
		*X_GRUPPO = PADL(ALLTRIM(customer_group_code),3,'0')
		*X_GRUPPO = PADL(ALLTRIM(customer_group),3,'0')
		X_GRUPPO = PADL(ALLTRIM(customer_group_code),3,'0')  && ERASMO - 11/03/2022
		
*!*			*** SE CLIENTE CONVENZIONATO (CODICE GRUPPO VALORIZZATO E DIVERSO DA '000') PRELEVO LA CONDIZIONE DI PAGAMENTO DA QUELLA CODIFICATA NEL PARAMETRO GRUPPO CLIENTE
*!*			IF !EMPTY(X_GRUPPO) AND ALLTRIM(X_GRUPPO) <> "000"
*!*				X_CONPAG = ""
*!*				x_cond = "codice = 'APP" + ALLTRIM(X_GRUPPO) + "'"
*!*				cSql   = "select * from para where " + x_cond 
*!*				IF !ExecCommand(cSql,"TMP_PARA_GRUPPO")
*!*				   return(.f.)
*!*				ENDIF
*!*				SELECT TMP_PARA_GRUPPO
*!*				GO TOP
*!*				IF !EOF()
*!*					X_CONPAG = ALLTRIM(LIBERA)
*!*				ENDIF
*!*			ENDIF
*!*			SELECT TMP_ORDERS_CUSTOMER
		
		**=> ERASMO - INIZIO 29/03/2022
		*** SE CLIENTE CONVENZIONATO, PRELEVO CODICE CONDIZIONE DI PAGAMENTO DA APPOSITO CAMPO
		IF !EMPTY(X_GRUPPO) AND ALLTRIM(X_GRUPPO) <> "000"
			IF !EMPTY(PADL(ALLTRIM(payment_conditions_code),3,'0')) AND ALLTRIM(PADL(ALLTRIM(payment_conditions_code),3,'0')) <> "000"
				X_CONPAG = PADL(ALLTRIM(payment_conditions_code),3,'0')
			ELSE
				X_CONPAG = ""
			ENDIF
		ENDIF
		
		X_PA = .F.
		IF !EMPTY(X_CANVEN) AND ALLTRIM(X_CANVEN) <> "000000000"
			C_PA = ""
			x_cond = "codice = 'CVE" + ALLTRIM(X_CANVEN) + "'"
			cSql   = "select * from para where " + x_cond 
			IF !ExecCommand(cSql,"TMP_PARA_CANVEN")
			   return(.f.)
			ENDIF
			SELECT TMP_PARA_CANVEN
			GO TOP
			IF !EOF()
				C_PA = UPPER(ALLTRIM(TOKENIZER(ITALIANO,"PUBBLICA_AMMINISTRAZIONE")))
				IF ALLTRIM(C_PA) == "SI"
					X_PA = .T.
				ENDIF
			ENDIF
		ENDIF
		
		SELECT TMP_ORDERS_CUSTOMER
		**=> ERASMO - FINE 29/03/2022
				
		*** RILEVO CODICE NAZIONE AQUARIUS (IN E-COMMERCE E' ESPRESSA IN FORMATO ISO 3166-1 alpha-2)
		*x_cond = "codice LIKE 'STA%' AND UPPER(libera) = '" + X_NAZION + "'"
		IF X_NAZION == "ITALIA" OR X_NAZION == "IT"
			X_NAZION = "ITA"
		ELSE
			*x_cond = "codice LIKE 'STA%' AND UPPER(DESCRI) = '" + X_NAZION + "'"
			x_cond = "codice LIKE 'STA%' AND UPPER(libera) = '" + X_NAZION + "'"
			cSql   = "select substring(codice,4,3) AS COD_NAZIONE_AQ from para where " + x_cond 
			IF !ExecCommand(cSql,"TMP_PARA")
			   return(.f.)
			ENDIF
			SELECT TMP_PARA
			GO TOP
			IF !EOF()
				X_NAZION = COD_NAZIONE_AQ
			ENDIF
		ENDIF
		
		IF !EMPTY(X_NAZION)
			V_SEEK   = 'STA'+X_NAZION
			V_CHIAVE = 'codice'
			IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
			   SELECT CUR_PARA
				*** CODICE ZONA POPOLATO DA CAMPO PARA.CODPGO DELLA NAZIONE
				IF PUB_PRDISP
					X_ZONA = ALLTRIM(CODPGO)
				ENDIF
			ENDIF
		ENDIF
		
		IF SUBSTR(X_NAZION,1,2) = 'IT'
			X_CODIVA  = PUB_IVA
		ELSE
			X_CODIVA = ""
			cSql=""     
			cNomeCursorSql="_TEMP"
			TEXT TO cSql NOSHOW
				SELECT SUBSTRING(CODICE,4,2) AS GRUPPO_NAZIONE
				FROM PARA 
				WHERE CODICE LIKE 'GEN%' 
					AND NOTE LIKE '%.<<X_NAZION>>.%' 
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
		ENDIF
		
		SELECT TMP_ORDERS_CUSTOMER
		
*!*			IF EMPTY(X_RAGSOC)
*!*				X_RAGSOC = UPPER(ALLTRIM(BILLING_COMPANY))
*!*				IF EMPTY(X_RAGSOC)
*!*					X_RAGSOC = UPPER(ALLTRIM(BILLING_FIRST_NAME)) + " " + UPPER(ALLTRIM(BILLING_LAST_NAME))
*!*					X_RAGDUE = ""
*!*				ELSE
*!*					X_RAGDUE = UPPER(ALLTRIM(BILLING_FIRST_NAME)) + " " + UPPER(ALLTRIM(BILLING_LAST_NAME))
*!*				ENDIF
*!*			ENDIF
				
*!*			F_INDIR   = UPPER(ALLTRIM(BILLING_ADDRESS_1)) + " " + UPPER(ALLTRIM(BILLING_ADDRESS_2))
*!*			F_NAZION  = UPPER(ALLTRIM(BILLING_COUNTRY))
*!*			F_CAP     = UPPER(ALLTRIM(BILLING_POSTCODE))
*!*			F_LOCALI  = UPPER(ALLTRIM(BILLING_CITY))
*!*			F_PROVIN  = UPPER(ALLTRIM(BILLING_STATE))
*!*			F_VALUTA  = UPPER(ALLTRIM(CURRENCY))
*!*			F_TELEFO  = UPPER(ALLTRIM(BILLING_PHONE))
*!*			F_EMAIL   = ALLTRIM(BILLING_EMAIL)
*!*			
*!*			*** RILEVO CODICE NAZIONE AQUARIUS (IN WOOCOMMERCE E' ESPRESSA IN FORMATO ISO 3166-1 alpha-2)
*!*			x_cond = "codice LIKE 'STA%' AND libera = '" + F_NAZION + "'"
*!*			cSql   = "select substring(codice,4,3) AS COD_NAZIONE_AQ from para where " + x_cond 
*!*			IF !ExecCommand(cSql,"TMP_PARA")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT TMP_PARA
*!*			GO TOP
*!*			IF !EOF()
*!*				F_NAZION = COD_NAZIONE_AQ
*!*			ENDIF
*!*			
*!*			IF EMPTY(X_INDIR)
*!*				X_INDIR = F_INDIR
*!*			ENDIF
*!*			IF EMPTY(X_NAZION)
*!*				X_NAZION = F_NAZION
*!*			ENDIF
*!*			IF EMPTY(X_CAP)
*!*				X_CAP = F_CAP
*!*			ENDIF
*!*			IF EMPTY(X_LOCALI)
*!*				X_LOCALI = F_LOCALI
*!*			ENDIF
*!*			IF EMPTY(X_PROVIN)
*!*				X_PROVIN = F_PROVIN
*!*			ENDIF
*!*			IF EMPTY(X_TELEFO)
*!*				X_TELEFO = F_TELEFO
*!*			ENDIF
*!*			IF EMPTY(X_EMAIL)
*!*				X_EMAIL = F_EMAIL
*!*			ENDIF
		
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
			DELETE FROM TMP_ORDERS WHERE VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0))) = _EC_CUSTOMER_ID
			SELECT CU_CUSTOMERS
			LOOP
		ELSE
		   S_NUM = SUBSTR(LIBERA,1,10)
		   *IF S_NUM  <> "9999999999"                    && SOLO SE <> 9999999999
		      N_NUM     = VAL(S_NUM)
		      INC_NUM   = N_NUM + 1
		      S_INC_NUM = STR(INC_NUM,10,0)
		      X_CODICE  = ALLTRIM(S_INC_NUM)
		      IF SUBSTR(X_CODICE,1,1)  <  "A"
		 	     X_CODICE= TRC(PUB_LCL,ALLTRIM(X_CODICE))
			  ENDIF
		      REPLACE LIBERA WITH S_INC_NUM 
		   *ENDIF
		ENDIF
		IF !ExecRW(cSql,"para","W")
		   return(.f.)
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
		*REPLACE CLI_CODIVA WITH X_CODIVA
		REPLACE CLI_CODIVA WITH IIF(X_PA,"SP",X_CODIVA)	&& ERASMO - 29/03/2022
		REPLACE CLI_SOSIMP WITH IIF(X_PA,"FVS","")  	&& ERASMO - 29/03/2022
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
		REPLACE CLI_NAZION WITH X_NAZION
		REPLACE CLI_ZONA   WITH X_ZONA
		REPLACE CLI_AGE	   WITH X_AGE
		REPLACE CLI_PARIVA WITH X_PARIVA
		REPLACE CLI_TELEX  WITH X_TELEX
		REPLACE CLI_HOMPAG WITH X_WEB
		REPLACE CLI_CCOST1 WITH X_CCOSTO
		REPLACE CLI_CONPAG WITH X_CONPAG
		REPLACE CLI_NOTE   WITH X_NOTE
		REPLACE CLI_CANVEN WITH X_CANVEN
		REPLACE CLI_APPPRO WITH X_GRUPPO
		
		*** VALORI FISSI
		REPLACE CLI_TIPFAT WITH "FDV"
		REPLACE CLI_CCOST1 WITH "ITADIR"
		REPLACE CLI_LISTIN WITH IIF(SUBSTR(CLI_NAZION,1,2) = 'IT',"1","2")  && ERASMO - 11/03/2022
		*REPLACE CLI_LOCDOC WITH "001"  && ERASMO - 14/04/2022
		
		**=> ERASMO - INIZIO 14/04/2022
		X_RAGSOC = CLI_RAGSOC
		X_RAGDUE = CLI_RAGDUE
		X_INDIR  = CLI_INDIR
		X_LOCALI = CLI_LOCALI
		X_PROVIN = CLI_PROVIN
		X_NAZION = CLI_NAZION
		X_CAP    = CLI_CAP
		X_CODFIS = CLI_CODFIS
		X_PARIVA = CLI_PARIVA
		X_IVACEE = CLI_IVACEE
		
		X_RECCAT = 1
					
		X_RAGLEG  = ""
		X_RGLEG2  = ""
		X_INDLEG  = ""
		X_LOCLEG  = ""
		X_PROLEG  = ""
		X_NAZLEG  = ""
		X_CAPLEG  = ""
		X_CFISLG  = ""
		X_PIVALG  = ""
		X_IVCELG  = ""

		X_RECCOG  = ""
		X_RECNOM  = ""
		X_PRONAS  = ""
		X_RECCDF  = ""

		X_ESTNAZ  = ""
		X_ESTDOM  = ""
		
		DO ECOMMERCE_CARD_DATI_PERSONA_FISICA_GIURIDICA
		
		REPLACE CLI_RECCAT WITH X_RECCAT 
		
		REPLACE CLI_RAGLEG WITH X_RAGLEG 
		REPLACE CLI_RGLEG2 WITH X_RGLEG2 
		REPLACE CLI_INDLEG WITH X_INDLEG 
		REPLACE CLI_LOCLEG WITH X_LOCLEG 
		REPLACE CLI_PROLEG WITH X_PROLEG 
		REPLACE CLI_NAZLEG WITH X_NAZLEG 
		REPLACE CLI_CAPLEG WITH X_CAPLEG 
		REPLACE CLI_CFISLG WITH X_CFISLG 
		REPLACE CLI_PIVALG WITH X_PIVALG 
		REPLACE CLI_IVCELG WITH X_IVCELG 
		
		REPLACE CLI_RECCOG WITH X_RECCOG 
		REPLACE CLI_RECNOM WITH X_RECNOM 
		REPLACE CLI_PRONAS WITH X_PRONAS 
		REPLACE CLI_RECCDF WITH X_RECCDF 

		REPLACE CLI_ESTNAZ WITH X_ESTNAZ 
		REPLACE CLI_ESTDOM WITH X_ESTDOM 
		**=> ERASMO - FINE 14/04/2022

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
		REPLACE CLI_FLGDPR WITH IIF(ALLTRIM(X_PRVACY) == '1', .T.,.F.)
		REPLACE CLI_DTGDPR WITH IIF(ALLTRIM(X_PRVACY) == '1', RIBALTA2(DTOC(DATE())),"")
		REPLACE CLI_FATELETT WITH .T.
		REPLACE CLI_IDSDI WITH X_SDI
		REPLACE CLI_EPEC WITH X_PEC
		REPLACE CLI_PA WITH X_PA  && ERASMO - 29/03/2022
		REPLACE EC_CUSTOMER_ID WITH _EC_CUSTOMER_ID
		REPLACE EC_CUSTOMER_UPDATED_AT WITH _EC_CUSTOMER_UPDATED_AT
		REPLACE REG_CODOPE WITH PUB_CODOPE
		REPLACE REG_NOMOPE WITH PUB_NOMOPE
		REPLACE REG_DATREG WITH RIBALTA2(DTOC(DATE()))
		REPLACE REG_ORAREG WITH TIME()
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
		
		_CONTA_CLI_INS = _CONTA_CLI_INS + 1
		
		_MESSAGGIO = "2 - Inserito nuovo Cliente " + ALLTRIM(X_CODICE) + " - " + ALLTRIM(M.CLI_RAGSOC) + " (ID: " + ALLTRIM(STR(_EC_CUSTOMER_ID,10,0)) + ")"
		DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
		
	ENDSCAN

ELSE
	_MESSAGGIO = "2 - Nessun nuovo Cliente da inserire"
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
ENDIF


_CONTA_CLI_AGG = 0

IF _ATTIVA_AGGIORNAMENTO_CLIENTI	
	SELECT CU_CUSTOMERS
	GO TOP
	SCAN
		IF !CLI_DA_AGG
			LOOP
		ENDIF
		
		X_CODCLI = ALLTRIM(CLI_CODCLI)
		
		_EC_CUSTOMER_ID = VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0)))
		_EC_CUSTOMER_UPDATED_AT = ALLTRIM(CUSTOMER_UPDATED_AT)
		
		*** AGGIORNAMENTO ANAGRAFICA CLIENTE
		SELECT TOP 1 * FROM TMP_ORDERS WHERE VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0))) = _EC_CUSTOMER_ID ORDER BY ID INTO CURSOR TMP_ORDERS_CUSTOMER
		SELECT TMP_ORDERS_CUSTOMER
		GO TOP
		IF EOF()
			DELETE FROM TMP_ORDERS WHERE VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0))) = _EC_CUSTOMER_ID
			SELECT CU_CUSTOMERS
			LOOP
		ENDIF
		
		IF !EMPTY(ALLTRIM(customer_name))
			X_RAGSOC = APITOSPA(ALLTRIM(customer_name))
			X_RAGDUE = APITOSPA(ALLTRIM(customer_first_name) + " " + ALLTRIM(customer_last_name))
		ELSE
			X_RAGSOC = APITOSPA(ALLTRIM(customer_first_name) + " " + ALLTRIM(customer_last_name))
			X_RAGDUE = ""
		ENDIF
		X_INDIR  = ALLTRIM(customer_address)
		X_CAP    = ALLTRIM(customer_zip_code)
		X_LOCALI = ALLTRIM(customer_city)
		X_PROVIN = ALLTRIM(customer_province)
		X_TELEFO = ALLTRIM(customer_phone)
		X_EMAIL  = ALLTRIM(customer_email)
		X_PEC    = ALLTRIM(customer_pec)
		X_SDI    = ALLTRIM(customer_sdi)
		X_PRVACY = ALLTRIM(STR(VAL(customer_privacy),1,0))
		X_NOTE   = ALLTRIM(customer_note)
		*X_CANVEN = "DIRB2C"+PADL(ALLTRIM(customer_class_code),3,'0')
		*X_GRUPPO = PADL(ALLTRIM(customer_group_code),3,'0')
				
		**=> ERASMO - INIZIO 14/04/2022
		X_NAZION = UPPER(ALLTRIM(customer_country))
		IF SUBSTR(X_NAZION,1,2) == "IT"
			_ok_controllo_cap = .T.
			IF LEN(X_CAP) = 5
				FOR I=1 TO LEN(X_CAP)
					_cCarattereNEsimo = SUBSTR(X_CAP,I,1)
					IF !ISDIGIT(_cCarattereNEsimo)
						_ok_controllo_cap = .F.
					ENDIF
				NEXT
			ELSE
				_ok_controllo_cap = .F.
			ENDIF
			IF !_ok_controllo_cap
				X_CAP = ""
			ENDIF
			
			x_cond = "COMUNE = '" + UPPER(STRTRAN(X_LOCALI,"'","`")) + "'"
			cSql   = "select * from COMUNI WHERE " + x_cond + " order by COMUNE"
			IF !ExecCommand(cSql,"TMP_COMUNI")
			   return(.f.)
			ENDIF
			SELECT TMP_COMUNI
			GO TOP
			IF !EOF()
				X_LOCALI = ALLTRIM(COMUNE)
				X_PROVIN = ALLTRIM(PROVINCIA)
				IF !_ok_controllo_cap
					X_CAP = ALLTRIM(CAP)
				ENDIF
			ENDIF
			SELECT TMP_ORDERS_CUSTOMER
		ENDIF
		**=> ERASMO - FINE 14/04/2022
		
		**=> ERASMO - INIZIO 29/03/2022
		*** SE CLIENTE CONVENZIONATO, PRELEVO CODICE CONDIZIONE DI PAGAMENTO DA APPOSITO CAMPO
		X_GRUPPO = PADL(ALLTRIM(customer_group_code),3,'0')
		*X_CONPAG = "103"
		X_CONPAG = "989"  && ERASMO - 14/04/2022
		IF !EMPTY(X_GRUPPO) AND ALLTRIM(X_GRUPPO) <> "000"
			IF !EMPTY(PADL(ALLTRIM(payment_conditions_code),3,'0')) AND ALLTRIM(PADL(ALLTRIM(payment_conditions_code),3,'0')) <> "000"
				X_CONPAG = PADL(ALLTRIM(payment_conditions_code),3,'0')
			ELSE
				X_CONPAG = ""
			ENDIF
		ENDIF
		SELECT TMP_ORDERS_CUSTOMER
		**=> ERASMO - FINE 29/03/2022
		
		SELECT TMP_ORDERS_CUSTOMER
		
		IF !ExecRW("select * from u_cli_an where cli_codcli = '" + X_CODCLI + "'","u_cli_an","R")
		   return(.f.)
		ENDIF
		SELECT U_CLI_AN
		GO TOP
		IF !EOF()
			REPLACE CLI_RAGSOC WITH X_RAGSOC
			REPLACE CLI_RAGDUE WITH X_RAGDUE
			REPLACE CLI_INDIR  WITH X_INDIR
			REPLACE CLI_LOCALI WITH X_LOCALI
			REPLACE CLI_PROVIN WITH X_PROVIN
			REPLACE CLI_TELEFO WITH X_TELEFO
			REPLACE CLI_EMAIL  WITH X_EMAIL	
			REPLACE CLI_DATINS WITH RIBALTA2(DTOC(DATE()))
			REPLACE CLI_CAP    WITH X_CAP
			REPLACE CLI_NOTE   WITH X_NOTE
			REPLACE CLI_CONPAG WITH X_CONPAG  && ERASMO - 29/03/2022
			*REPLACE CLI_APPPRO WITH X_GRUPPO  && ERASMO - 29/03/2022
			
			**=> ERASMO - INIZIO 14/04/2022
			X_RAGSOC = CLI_RAGSOC
			X_RAGDUE = CLI_RAGDUE
			X_INDIR  = CLI_INDIR
			X_LOCALI = CLI_LOCALI
			X_PROVIN = CLI_PROVIN
			X_NAZION = CLI_NAZION
			X_CAP    = CLI_CAP
			X_CODFIS = CLI_CODFIS
			X_PARIVA = CLI_PARIVA
			X_IVACEE = CLI_IVACEE

			X_RECCAT = 1
						
			X_RAGLEG  = ""
			X_RGLEG2  = ""
			X_INDLEG  = ""
			X_LOCLEG  = ""
			X_PROLEG  = ""
			X_NAZLEG  = ""
			X_CAPLEG  = ""
			X_CFISLG  = ""
			X_PIVALG  = ""
			X_IVCELG  = ""

			X_RECCOG  = ""
			X_RECNOM  = ""
			X_PRONAS  = ""
			X_RECCDF  = ""

			X_ESTNAZ  = ""
			X_ESTDOM  = ""
			
			DO ECOMMERCE_CARD_DATI_PERSONA_FISICA_GIURIDICA
			
			REPLACE CLI_RECCAT WITH X_RECCAT 
			
			REPLACE CLI_RAGLEG WITH X_RAGLEG 
			REPLACE CLI_RGLEG2 WITH X_RGLEG2 
			REPLACE CLI_INDLEG WITH X_INDLEG 
			REPLACE CLI_LOCLEG WITH X_LOCLEG 
			REPLACE CLI_PROLEG WITH X_PROLEG 
			REPLACE CLI_NAZLEG WITH X_NAZLEG 
			REPLACE CLI_CAPLEG WITH X_CAPLEG 
			REPLACE CLI_CFISLG WITH X_CFISLG 
			REPLACE CLI_PIVALG WITH X_PIVALG 
			REPLACE CLI_IVCELG WITH X_IVCELG 
			
			REPLACE CLI_RECCOG WITH X_RECCOG 
			REPLACE CLI_RECNOM WITH X_RECNOM 
			REPLACE CLI_PRONAS WITH X_PRONAS 
			REPLACE CLI_RECCDF WITH X_RECCDF 

			REPLACE CLI_ESTNAZ WITH X_ESTNAZ 
			REPLACE CLI_ESTDOM WITH X_ESTDOM 
			**=> ERASMO - FINE 14/04/2022
		ENDIF
		
		SCATTER MEMVAR MEMO
		
		IF !ExecRW("","u_cli_an","W")
		   return(.f.)
		ENDIF
					
		x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "cli_codcli = '" + X_CODCLI + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "select * from u_ana_cl where " + x_cond + " order by cli_codsoc,cli_codcli"
		IF !ExecRW(cSql,"u_ana_cl","R")
		   return(.f.)
		ENDIF
		SELECT U_ANA_CL
		GO TOP 
		IF !EOF()
			REPLACE CLI_FLGDPR WITH IIF(ALLTRIM(X_PRVACY) == '1', .T.,.F.)
			IF (EMPTY(CLI_DTGDPR) OR ALLTRIM(CLI_DTGDPR) = "/  /") AND ALLTRIM(X_PRVACY) == '1'
				REPLACE CLI_DTGDPR WITH RIBALTA2(DTOC(DATE()))
			ENDIF
			REPLACE CLI_IDSDI WITH X_SDI
			REPLACE CLI_EPEC WITH X_PEC
			REPLACE EC_CUSTOMER_ID WITH _EC_CUSTOMER_ID
			REPLACE EC_CUSTOMER_UPDATED_AT WITH _EC_CUSTOMER_UPDATED_AT
			REPLACE MOD_CODOPE WITH PUB_CODOPE
			REPLACE MOD_NOMOPE WITH PUB_NOMOPE
			REPLACE MOD_DATREG WITH RIBALTA2(DTOC(DATE()))
			REPLACE MOD_ORAREG WITH TIME()
		ENDIF
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
		
		_CONTA_CLI_AGG = _CONTA_CLI_AGG + 1
		
		_MESSAGGIO = "2 - Aggiornato Cliente " + ALLTRIM(M.CLI_CODCLI) + " - " + ALLTRIM(M.CLI_RAGSOC) + " (ID: " + ALLTRIM(STR(_EC_CUSTOMER_ID,10,0)) + ")"
		DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
		
	ENDSCAN

ELSE
	_MESSAGGIO = "2 - Nessun Cliente da aggiornare"
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
ENDIF

WAIT WINDOWS "Elaborazione per inserimento Ordini clienti in corso..." NOWAIT

*** INSERIMENTO ORDINI CLIENTI
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
*SET STEP ON
SELECT ID,CODE,CUSTOMER_ID FROM TMP_ORDERS GROUP BY ID,CODE,CUSTOMER_ID ORDER BY ID INTO CURSOR TMP_ORDERS_TESTATE
SELECT TMP_ORDERS_TESTATE
GO TOP
SCAN
	SCATTER MEMVAR MEMO
	
*!*		*** FILTRO GLI ORDINI CON I SOLI STATUS DA IMPORTARE
*!*		IF ALLTRIM(UPPER(M.STATUS)) = "PENDING" OR ALLTRIM(UPPER(M.STATUS)) = "PROCESSING" OR ALLTRIM(UPPER(M.STATUS)) = "COMPLETED" OR ALLTRIM(UPPER(M.STATUS)) = "ON-HOLD"
*!*		ELSE
*!*			LOOP
*!*		ENDIF
	
	*** VERIFICO ESISTENZA ORDINE
	x_codi = "EC_ORDER_ID = " + ALLTRIM(STR(VAL(M.ID),50,0))
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
			SELECT TMP_ORDERS_TESTATE
			LOOP
		ENDIF
	ENDIF
			
	SELECT CU_ORD_TT
	SCATTER MEMVAR MEMO BLANK
	
	M.EC_ORDER_ID = VAL(ALLTRIM(STR(VAL(M.ID),50,0)))
	M.EC_ORDER_CODE = ALLTRIM(M.CODE)
	M.TAGGANCIO = STR(NEWPROG('NUMORD'),10)
	X_TAGG = M.TAGGANCIO
	M.ORD_CODSOC = PUB_CODSOC
	
	SELECT TMP_ORDERS
	SET FILTER TO ID = M.ID
	GO TOP
	SCATTER MEMVAR MEMO
	
	M.ORD_DATORD = STRTRAN(SUBSTR(M.date,1,10),"-","/")
	
	_YES_PUBBLICA_AMMINISTRAZIONE = .F.  && ERASMO - 29/03/2022
	x_cond = "U_ANA_CL.EC_CUSTOMER_ID = " + ALLTRIM(STR(VAL(M.CUSTOMER_ID),50,0))
	*cSql="select U_CLI_AN.CLI_CODCLI, U_CLI_AN.CLI_RAGSOC from u_cli_an left outer join u_ana_cl on u_cli_an.cli_codcli = u_ana_cl.cli_codcli where " + x_cond
	cSql="select U_CLI_AN.CLI_CODCLI, U_CLI_AN.CLI_RAGSOC, U_ANA_CL.CLI_PA from u_cli_an left outer join u_ana_cl on u_cli_an.cli_codcli = u_ana_cl.cli_codcli where " + x_cond  && ERASMO - 29/03/2022
	IF !ExecCommand(cSql,"TMP_CLI_CL_AN")
		return(.f.)
	ENDIF
	SELECT TMP_CLI_CL_AN
	GO TOP
	IF !EOF()
		M.ORD_CODCLI = CLI_CODCLI
		_YES_PUBBLICA_AMMINISTRAZIONE = CLI_PA  && ERASMO - 29/03/2022
	ELSE
		SELECT TMP_ORDERS_TESTATE
		LOOP
	ENDIF
	
	M.ORD_CODCLI = seek_u_cli_an('',pub_codsoc+ALLTRIM(M.ORD_CODCLI),'cli_codcli','cli_codcli','','CUR_CLIENTE')
	IF EMPTY(M.ORD_CODCLI)
	   	*MESSAGEBOX("Nessun cliente selezionato",64,"*** INFORMAZIONE ***")
	   	MESSAGEBOX("Nessun cliente selezionato",64,"*** INFORMAZIONE ***",3)  && ERASMO - INIZIO 10/01/2023
		SELECT TMP_ORDERS_TESTATE
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

	SELECT CUR_CLIENTE
	M.ORD_VALUTA = CLI_VALUTA
	
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
	M.ORD_RIFERI = "Ord. E-Commerce Cod. " + ALLTRIM(M.CODE)
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
	M.ORD_CODLOC = CLI_LOCDOC
	M.ORD_BANCA	= CLI_BAE
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
	*M.ORD_CCOSTO     = CLI_CCOST1
	M.ORD_CCOSTO     = "ITADIR"  && ERASMO - 14/04/2022
	M.ORD_CDIMBA     = CLI_CODIMB
	M.ORD_ACURA      = CLI_MEZZO
	M.ORD_PORTO      = CLI_PORTO
	M.ORD_VETTO1     = CLI_VETTO1
	
	M.ORD_CAUS		 = "OC"
	M.ORD_TIPOLOGIA	 = IIF(ALLTRIM(CLI_APPPRO) = "000" OR EMPTY(CLI_APPPRO),"ECN","ECC")
	*M.ORD_SPTIMP     = "SI"
	M.ORD_SPTIMP     = "NO"  && ERASMO - 11/03/2022
	M.ORD_CONPRZ     = "NO"
	
	IF ALLTRIM(CLI_APPPRO) = "000" OR EMPTY(CLI_APPPRO)  && CLIENTE NON CONVENZIONATO
		M.ORD_TIPOLOGIA	= "ECN"
		*M.ORD_CPA		= "114"
		M.ORD_CPA		= "989"  && ERASMO - 08/04/2022
	ELSE
		M.ORD_TIPOLOGIA	= "ECC"
		M.ORD_CPA		= CLI_CONPAG
	ENDIF
	
*!*		
*!*			
*!*		IF !EMPTY(M.PAYMENT_METHOD)
*!*			IF !ExecCommand("select * from para where codice = 'CPA" + SUBSTR(UPPER(ALLTRIM(M.PAYMENT_METHOD)),1,3) + "'","cx_para")
*!*				return
*!*			ENDIF
*!*			SELECT CX_PARA
*!*			GO TOP
*!*			IF !EOF()
*!*				M.ORD_CPA = SUBSTR(CODICE,4,3)
*!*			ELSE
*!*				cSql = "select * from para WHERE 1=0"
*!*				IF !ExecRW(cSql,"PARA","R")
*!*					return
*!*				ENDIF
*!*				SELECT PARA
*!*				APPEND BLANK
*!*				REPLACE CODICE WITH "CPA"+SUBSTR(UPPER(ALLTRIM(M.PAYMENT_METHOD)),1,3)
*!*				REPLACE DESCRI WITH UPPER(ALLTRIM(M.PAYMENT_METHOD_TITLE))
*!*				REPLACE LIBERA WITH "DF BON    0 "
*!*				M.ORD_CPA = SUBSTR(CODICE,4,3)
*!*				IF !ExecRW(cSql,"PARA","W")
*!*					return
*!*				ENDIF
*!*			ENDIF
*!*		ELSE
*!*			IF !EMPTY(M.PAYMENT_METHOD_TITLE)
*!*				IF !ExecCommand("select * from para where codice like 'CPA%' AND DESCRI = '" + ALLTRIM(M.PAYMENT_METHOD_TITLE) + "'","cx_para")
*!*					return
*!*				ENDIF
*!*				SELECT CX_PARA
*!*				GO TOP
*!*				IF !EOF()
*!*					M.ORD_CPA = SUBSTR(CODICE,4,3)
*!*				ENDIF
*!*			ENDIF
*!*		ENDIF
	
*!*		IF EMPTY(M.ORD_CPA)
*!*			SELECT CUR_CLIENTE
*!*			M.ORD_CPA = "103"
*!*		ENDIF
		  
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
	
	M.ORD_SPTRAS = VAL(STRTRAN(M.SHIPMENT,'.',','))
	
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
		PUB_NOINCA 		 = .F.
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
	
	M.ORD_MAGS = PUB_ECMAGA
	
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

    M.ORD_RAGC 			= APITOSPA(ALLTRIM(ALLTRIM(M.shipping_name)))
    **=> ERASMO - INIZIO 24/03/2022
	IF EMPTY(ALLTRIM(M.ORD_RAGC))
		M.ORD_RAGC = APITOSPA(ALLTRIM(M.shipping_first_name) + " " + ALLTRIM(M.shipping_last_name))
	ENDIF
    **=> ERASMO - FINE 24/03/2022
    M.ORD_INDC 			= APITOSPA(ALLTRIM(ALLTRIM(M.shipping_address)))
    M.ORD_CAPC 			= APITOSPA(ALLTRIM(ALLTRIM(M.shipping_zip_code)))
    M.ORD_LOCC 			= APITOSPA(ALLTRIM(ALLTRIM(M.shipping_city)))
    M.ORD_PROC 			= APITOSPA(ALLTRIM(ALLTRIM(M.shipping_province)))
    M.ORD_DSNAZC 		= UPPER(APITOSPA(ALLTRIM(ALLTRIM(M.shipping_country))))
	IF M.ORD_DSNAZC == "ITALIA" OR M.ORD_DSNAZC == "IT"
		M.ORD_DSNAZC = "ITALIA"
	ELSE
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
	
	**=> ERASMO - INIZIO 14/04/2022
	IF M.ORD_DSNAZC = "ITALIA"
		_ok_controllo_cap = .T.
		IF LEN(M.ORD_CAPC) = 5
			FOR I=1 TO LEN(M.ORD_CAPC)
				_cCarattereNEsimo = SUBSTR(M.ORD_CAPC,I,1)
				IF !ISDIGIT(_cCarattereNEsimo)
					_ok_controllo_cap = .F.
				ENDIF
			NEXT
		ELSE
			_ok_controllo_cap = .F.
		ENDIF
		IF !_ok_controllo_cap
			M.ORD_CAPC = ""
		ENDIF
		
		x_cond = "COMUNE = '" + UPPER(STRTRAN(M.ORD_LOCC,"'","`")) + "'"
		cSql   = "select * from COMUNI WHERE " + x_cond + " order by COMUNE"
		IF !ExecCommand(cSql,"TMP_COMUNI")
		   return(.f.)
		ENDIF
		SELECT TMP_COMUNI
		GO TOP
		IF !EOF()
			M.ORD_LOCC = ALLTRIM(COMUNE)
			M.ORD_PROC = ALLTRIM(PROVINCIA)
			IF !_ok_controllo_cap
				M.ORD_CAPC = ALLTRIM(CAP)
			ENDIF
		ENDIF
		SELECT CUR_U_ANA_CL
	ENDIF
	**=> ERASMO - FINE 14/04/2022
    
    M.ORD_ATTENZIONE	= APITOSPA(ALLTRIM(M.shipping_first_name) + " " + ALLTRIM(M.shipping_last_name))
    **=> ERASMO - INIZIO 24/03/2022
	IF EMPTY(ALLTRIM(M.ORD_ATTENZIONE)) == EMPTY(ALLTRIM(M.ORD_RAGC))
		M.ORD_ATTENZIONE = ""
	ENDIF
    **=> ERASMO - FINE 24/03/2022
    IF !EMPTY(ALLTRIM(M.shipping_email))
    	M.ORD_ATTENZIONE = ALLTRIM(M.ORD_ATTENZIONE) + IIF(EMPTY(M.ORD_ATTENZIONE),""," - ") + APITOSPA("Email: " + ALLTRIM(ALLTRIM(M.shipping_email)))
    ENDIF
    IF !EMPTY(ALLTRIM(M.shipping_phone))
    	M.ORD_ATTENZIONE = ALLTRIM(M.ORD_ATTENZIONE) + IIF(EMPTY(M.ORD_ATTENZIONE),""," - ") + APITOSPA("Tel.: " + ALLTRIM(ALLTRIM(M.shipping_phone)))
    ENDIF
    M.ORD_VARIE = ""
*!*	    IF !EMPTY(ALLTRIM(M.payment_code))
*!*	    	M.ORD_VARIE = ALLTRIM(M.ORD_VARIE) + IIF(EMPTY(M.ORD_VARIE),""," - ") + "Payment Code: " + ALLTRIM(ALLTRIM(M.payment_code))
*!*	    ENDIF
    IF !EMPTY(ALLTRIM(M.payment_transaction))
    	M.ORD_VARIE = ALLTRIM(M.ORD_VARIE) + IIF(EMPTY(M.ORD_VARIE),""," - ") + "Payment Transaction: " + ALLTRIM(ALLTRIM(M.payment_transaction))
    ENDIF
    
    M.ORD_NOTEEV2 = IIF(!ISNULL(M.notes),M.notes,"")  && ERASMO - 11/03/2022
    
    **=> ERASMO - INIZIO 28/03/2022
    IF !ISNULL(M.shipping_note)
    	IF !EMPTY(M.shipping_note)
    		M.ORD_NOTEEV2 = M.shipping_note
    	ENDIF
    ENDIF
    **=> ERASMO - FINE 28/03/2022
    
	SELECT CU_ORD_TT
	APPEND BLANK
	GATHER MEMVAR MEMO
	
	SELECT CU_ORD_T2
	APPEND BLANK
	GATHER MEMVAR MEMO
	
*!*		**=> ERASMO - INIZIO 14/04/2022
*!*		IF !EMPTY(ALLTRIM(M.CLI_CODCLI))
*!*			x_soci = "loc_codsoc = '" + PUB_CODSOC + "'"
*!*			x_ccff = "loc_cf = 'C'"
*!*			x_clie = "loc_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
*!*			x_cloc = "loc_codloc = '001'"
*!*			x_cond = x_soci + " and " + x_ccff + " and " + x_clie + " and " + x_cloc
*!*			cSql = "select * from u_loc_an where " + x_cond
*!*			IF !ExecRW(cSql,"U_LOC_AN","R")
*!*			   RETURN .F.
*!*			ENDIF
*!*			SELECT U_LOC_AN
*!*			GO TOP
*!*			IF EOF()
*!*			   APPEND BLANK
*!*			   REPLACE LOC_CODSOC WITH PUB_CODSOC
*!*			   REPLACE LOC_CODLOC WITH "001"
*!*			   REPLACE LOC_CODCLI WITH M.ORD_CODCLI
*!*			   REPLACE LOC_RAGSOC WITH M.ORD_RAGC
*!*			   REPLACE LOC_INDIRI WITH M.ORD_INDC
*!*			   REPLACE LOC_CAP    WITH M.ORD_CAPC
*!*			   REPLACE LOC_LOCALI WITH M.ORD_LOCC
*!*			   REPLACE LOC_PROVIN WITH M.ORD_PROC
*!*			   REPLACE LOC_CODNAZ WITH M.ORD_CODNAZ
*!*			   REPLACE LOC_DESNAZ WITH M.ORD_DSNAZC
*!*			   REPLACE LOC_ATTENZIONE WITH M.ORD_ATTENZIONE
*!*			ENDIF
*!*			IF !ExecRW(cSql,"U_LOC_AN","W")
*!*			   RETURN .F.
*!*			ENDIF
*!*		ENDIF
*!*		**=> ERASMO - FINE 14/04/2022

	*** DETAGLI ORDINE
	_NEW_SEQUEN = 0
	SELECT TMP_ORDERS
	GO TOP
	SCAN
	
		SELECT CU_ORD_DD
		SCATTER MEMVAR MEMO BLANK
		
		SELECT TMP_ORDERS
		SCATTER MEMVAR MEMO
		
*!*			M.WC_ORDER_KEY = M.ORDER_KEY
*!*			M.WC_ORDER_LINE_ITEMS_ID = M.ID
		
		M.ORD_CODART = APITOSPA(ALLTRIM(M.product))
		M.ORD_QTAORD = VAL(STRTRAN(M.qty,'.',','))
		M.DAGGANCIO = X_TAGG
		_CODSYS_BUNDLE = ""  && ERASMO - 05/01/2023
		
		IF !ExecCommand("select ART_CODMAT, ART_DESCR, ART_UMMAGA from U_ART_PR where ART_CODPRI = '" + ALLTRIM(M.ORD_CODART) + "'","TMP_ART_PR")
		   RETURN .F.
		ENDIF
		SELECT TMP_ART_PR
		GO TOP
		IF EOF()
			M.ORD_CODART = "."
			_ORD_PRZNET = VAL(STRTRAN(M.price,'.',','))
			_ORD_PREZZO = VAL(STRTRAN(M.original_price,'.',','))
			DO ECOMMERCE_CARD_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD WITH _ORD_PREZZO,_ORD_PRZNET
			SELECT TMP_ORDERS
			LOOP
		ENDIF
		
		_ALIQUOTA_IVA = VAL(ALLTRIM(STR(VAL(STRTRAN(M.vat,'.',',')),50,10)))  && ERASMO - 07/11/2022
		
		IF UPPER(ALLTRIM(ART_CODMAT)) == "BUN" && ARTICOLO BUNDLE
		
			_CODART_BUNDLE = ALLTRIM(M.ORD_CODART)
			_QTAORD_BUNDLE = M.ORD_QTAORD
			_UMMAGA_BUNDLE = ALLTRIM(ART_UMMAGA)
			_DESCR_BUNDLE  = ALLTRIM(ART_DESCR)
			
			*** VERIFICA ESISTENZA COMPOSIZIONE DI.BA.
			x_grup = "DIS.DIS_GRUPPO = '" + _CODART_BUNDLE + "'"
			x_disq = "DIS.DIS_QTA > 0"
			x_cond = x_grup + " and " + x_disq
			cSql   = "SELECT DIS.DIS_CODART, ANA.ART_DESCR, DIS.DIS_QTA FROM U_DIS_DD AS DIS " + CHR(13) + ;
			         "RIGHT OUTER JOIN U_ART_PR AS ANA ON ANA.ART_CODPRI = DIS.DIS_CODART " + CHR(13) + ;
			         "RIGHT OUTER JOIN U_DIS_TT AS DIT ON DIT.TAGGANCIO = DIS.DAGGANCIO " + CHR(13) + ;
			         "WHERE " + x_cond + " ORDER BY DIS.DIS_SEQUEN"
			IF !ExecCommand(cSql,"BUN_DIS_DD")
			  return(.f.)
			ENDIF
			SELECT BUN_DIS_DD
			GO TOP
			IF !EOF()
				*** L'ARTICOLO E' UN CODICE BUNDLE: INSERISCO UNA RIGA DI COMMENTO COL SUO RIFERIMENTO E LE SUE COMPONENTI COME RIGHE ARTICOLO, 
				*** PROPORZIONATE NELLE QUANTITA' RICHIESTE IN BASE AL COEFFICIENTE DI IMPIEGO DEFINITO IN DI.BA.
				*** L'UNICO ARTICOLO VALORIZZATO SARA' IL PRIMO DELLA COMPOSIZIONE DI.BA., CON PREZZO PRESO DAL PREZZO DEL BUNDLE COME DA E-COMMERCE
				
				*** INSERIMENTO RIGA DI COMMENTO
				M.DAGGANCIO 	= X_TAGG
				M.ORD_CODART	= ""
				M.ORD_DESART 	= "*** COMMENTO ***"
				M.ORD_CODSYS 	= SYS(2015)
				_CODSYS_BUNDLE	= M.ORD_CODSYS  && ERASMO - 05/01/2023
				*M.ORD_QTAORD 	= _QTAORD_BUNDLE 
				*M.ORD_UM	 	= _UMMAGA_BUNDLE
				M.ORD_QTAORD 	= 0		&& ERASMO - 14/04/2022
				M.ORD_UM	 	= ""	&& ERASMO - 14/04/2022
				*M.ORD_NOTE	 	= _DESCR_BUNDLE
				M.ORD_NOTE	 	= ALLTRIM(_CODART_BUNDLE) + " - " + _DESCR_BUNDLE  && ERASMO - 14/04/2022
				M.ORD_NOTEBO 	= ALLTRIM(_CODART_BUNDLE)  && ERASMO - 05/01/2023
				DL_TIPODES 		= 'ARTICOLO'
				DL_CODICE  		= _CODART_BUNDLE
				_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
				IF !EMPTY(_DESCR_LINGUA)
					*M.ORD_NOTE = _DESCR_LINGUA
					M.ORD_NOTE = ALLTRIM(_CODART_BUNDLE) + " - " + _DESCR_LINGUA  && ERASMO - 14/04/2022
				ENDIF
				_NEW_SEQUEN 	= _NEW_SEQUEN + 10
				M.ORD_SEQUEN 	= _NEW_SEQUEN
				
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
				
				_PRIMO_ARTICOLO_COMPONENTE = .T.
				_SEQUEN_ACCORPAMENTO = 0  && ERASMO - 14/04/2022
				_VALORE_CON_IVA_ARTICOLI_DISACCORPATI = 0  && ERASMO - 07/11/2022
				SELECT BUN_DIS_DD
				GO TOP
				SCAN
					SCATTER MEMVAR MEMO
					
					SELECT CU_ORD_DD
					SCATTER MEMVAR MEMO BLANK
					M.ORD_CODART = ALLTRIM(M.DIS_CODART)
					*M.ORD_QTAORD = _QTAORD_BUNDLE * M.DIS_QTA
					*M.ORD_QTAORD = _QTAORD_BUNDLE  && ERASMO - 14/04/2022
					M.ORD_QTAORD = _QTAORD_BUNDLE * M.DIS_QTA  && ERASMO - 20/01/2023
					M.DAGGANCIO = X_TAGG
					
					IF _PRIMO_ARTICOLO_COMPONENTE
						*_ORD_PRZNET = VAL(STRTRAN(M.price,'.',','))
						*_ORD_PREZZO = VAL(STRTRAN(M.original_price,'.',','))
						**=> ERASMO - INIZIO 20/01/2023
						_ORD_PRZNET = VAL(STRTRAN(M.price,'.',',')) / M.DIS_QTA
						_ORD_PREZZO = VAL(STRTRAN(M.original_price,'.',',')) / M.DIS_QTA
						**=> ERASMO - FINE 20/01/2023
					ELSE
						_ORD_PREZZO = 0
						_ORD_PRZNET = 0
					ENDIF
					
					*DO ECOMMERCE_CARD_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD WITH _ORD_PREZZO,_ORD_PRZNET
					**=> ERASMO - INIZIO 14/04/2022
					*** PER LE COMPONENTI SUCCESSIVE AL PRIMO ARTICOLO GESTIRE L'ACCORPAMENTO AD ESSO
					IF _PRIMO_ARTICOLO_COMPONENTE
						*DO ECOMMERCE_CARD_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD WITH _ORD_PREZZO,_ORD_PRZNET
						DO ECOMMERCE_CARD_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD WITH _ORD_PREZZO,_ORD_PRZNET,0,.T.,.T.  && ERASMO - 07/11/2022
						_SEQUEN_ACCORPAMENTO = M.ORD_SEQUEN
					ELSE
*!*							_NR_RIGHE_STESSA_QTA_PRIMO_ARTICOLO = ROUND(M.DIS_QTA,0)
*!*							FOR _r = 1 TO _NR_RIGHE_STESSA_QTA_PRIMO_ARTICOLO
*!*								_ORD_PARENT = _SEQUEN_ACCORPAMENTO
*!*								*DO ECOMMERCE_CARD_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD WITH _ORD_PREZZO,_ORD_PRZNET,_ORD_PARENT
*!*								**=> ERASMO - INIZIO 07/11/2022
*!*								M.ORD_QTAORD = _QTAORD_BUNDLE
*!*								DO ECOMMERCE_CARD_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD WITH _ORD_PREZZO,_ORD_PRZNET,_ORD_PARENT,.T.,.F.,M.DIS_QTA
*!*								_ORD_PARENT_USCITA = M.ORD_PARENT
*!*								IF _ORD_PARENT_USCITA = 0
*!*									EXIT
*!*								ENDIF
*!*								**=> ERASMO - FINE 07/11/2022
*!*							NEXT
						**=> ERASMO - INIZIO 20/01/2023
						*** ELIMINATO ACCORPAMENTO RIGHE ORDINE, TUTTE LE RIGHE DI.BA. POSSONO AVERE UNA QUANTITA' MOLTIPLICATIVA IN DI.BA., MA SOLO LA PRIMA VIENE VALORIZZATA
						M.ORD_QTAORD = _QTAORD_BUNDLE * M.DIS_QTA
						DO ECOMMERCE_CARD_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD WITH _ORD_PREZZO,_ORD_PRZNET,0,.T.,.F.,M.DIS_QTA
						**=> ERASMO - FINE 20/01/2023
					ENDIF
					**=> ERASMO - FINE 14/04/2022
					
					_PRIMO_ARTICOLO_COMPONENTE = .F.
				ENDSCAN
				
				**=> ERASMO - INIZIO 07/11/2022
				*** AGGIORNO PREZZO IN CODICE BUNDLE PRINCIPALE
				IF _VALORE_CON_IVA_ARTICOLI_DISACCORPATI > 0	
					SELECT CU_ORD_DD
					GO TOP
					SCAN
						IF ORD_SEQUEN = _SEQUEN_ACCORPAMENTO
							_NEW_PREZZO = (ROUND((ORD_PREZZO * (1 + (_ALIQUOTA_IVA/100))),2)) - (_VALORE_CON_IVA_ARTICOLI_DISACCORPATI)
							_NEW_PREZZO = ROUND(_NEW_PREZZO,6)
							REPLACE ORD_PREZZO WITH _NEW_PREZZO 
							REPLACE ORD_PRZNET WITH _NEW_PREZZO 
							REPLACE ORD_SC1 WITH 0
							REPLACE ORD_SC2 WITH 0
							REPLACE ORD_SC3 WITH 0
							REPLACE ORD_VALORE WITH CALCOLA_VALORE_RIGA_DOCUMENTO(ORD_PRZNET,ORD_QTAORD)
							EXIT
						ENDIF
					ENDSCAN
				ENDIF
				**=> ERASMO - FINE 07/11/2022
				
			ELSE
				_ORD_PRZNET = VAL(STRTRAN(M.price,'.',','))
				_ORD_PREZZO = VAL(STRTRAN(M.original_price,'.',','))
				DO ECOMMERCE_CARD_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD WITH _ORD_PREZZO,_ORD_PRZNET
			ENDIF
		ELSE
			_ORD_PRZNET = VAL(STRTRAN(M.price,'.',','))
			_ORD_PREZZO = VAL(STRTRAN(M.original_price,'.',','))
			DO ECOMMERCE_CARD_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD WITH _ORD_PREZZO,_ORD_PRZNET
		ENDIF
		
		
*!*			IF EMPTY(M.ORD_CODART)
*!*				M.ORD_CODART = '.'
*!*			ENDIF
*!*			
*!*			IF !ExecCommand("select * from U_ART_PR where ART_CODPRI = '" + ALLTRIM(M.ORD_CODART) + "'","CX_ART_PR")
*!*			   RETURN .F.
*!*			ENDIF
*!*			SELECT CX_ART_PR
*!*			GO TOP
*!*			IF EOF()
*!*				**** DA GESTIRE
*!*			ENDIF
*!*			
*!*			M.ORD_CODART  = ART_CODPRI
*!*			*M.ORD_MAGA	  = ART_MAGA
*!*			M.ORD_MAGA    = PUB_ECMAGA
*!*			M.ORD_DESART  = ART_DESCR
*!*			M.ORD_DES2	  = ""
*!*			M.ORD_CLDOG   = ART_CLDOG
*!*			* -------------------------------------------------------------------------- descrizioni in lingua ---------- ARTICOLO ---------- *
*!*			DL_TIPODES 		= 'ARTICOLO'
*!*			DL_CODICE  		= M.ORD_CODART
*!*			_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
*!*			IF !EMPTY(_DESCR_LINGUA)
*!*				M.ORD_DESART = _DESCR_LINGUA
*!*				M.ORD_DES2	 = ""
*!*			ENDIF
*!*			* -------------------------------------------------------------------------- descrizioni in lingua ---------- ARTICOLO ---------- *

*!*			SELECT CX_ART_PR
*!*			M.ORD_UM	  = ART_UMMAGA  
*!*			M.ORD_UMFIN	  = ART_UMMAGA  
*!*			M.ORD_UMBAR	  = ART_UMMAGA  
*!*			M.ORD_UMSEZ	  = ART_UMMAGA  
*!*			M.ORD_IVA	  = ART_CODIVA
*!*			*M.ORD_PREZZO  = VAL(STRTRAN(M.TOTAL,'.',',')) / M.QUANTITY
*!*			*IF M.ORD_PREZZO = 0				&& SERGIO 2015/01/28 SE SELEZIONO UN LISTINO CON L'APPOSITO TASTO PERDE IL PREZZO DEL LISTINO
*!*			*	M.ORD_PREZZO  = ART_PRZVEN
*!*			*ENDIF
*!*			XLINEA        = ART_LINEA
*!*			M.ORD_COORD   = ART_COORD 
*!*			M.ORD_QTXCON  = ART_QTACON 
*!*			M.ORD_SCORMI  = ART_SCORMI
*!*			M.ORD_CODTAG  = ART_CODTAG 
*!*			M.ORD_DESTAG  = ART_DESTAG 
*!*			M.ORD_CODCOL  = ART_CODCOL 
*!*			M.ORD_DESCOL  = ART_DESCOL 
*!*			M.ORD_PUBBLI  = ART_PUBBLI
*!*			M.ORD_PESOUM  = ART_PESOUM
*!*			IF !EMPTY(m.ord_dtcons)
*!*			   m.ord_DATCON  = m.ord_dtcons
*!*			ENDIF
*!*			M.ORD_CODMAT = ART_CODMAT
*!*			M.ORD_DESMAT = ART_DESMAT
*!*			M.ORD_CODCOL = ART_CODCOL
*!*			M.ORD_DESCOL = ART_DESCOL
*!*			M.ORD_SPESSO = ART_SPESSO
*!*			M.ORD_ALTEZZ = ART_ALTEZZ
*!*			M.ORD_LUNGHE = ART_LUNGHE
*!*			M.ORD_CODIMB = ART_CODIMB
*!*			M.ORD_DESIMB = ART_DESIMB
*!*			M.ORD_LOTMIN = ART_LOTMIN
*!*			IF EMPTY(M.ORD_CDAPRD) OR !ESISTE_ARTICOLO(M.ORD_CDAPRD)  
*!*			   M.ORD_CDAPRD = M.ORD_CODART
*!*			   M.ORD_DSAPRD = M.ORD_DESART
*!*			ENDIF
*!*			V_DIBA = ART_CDDIBA
*!*			**------------------------------------------- RICERCA IVA INTRASTAT -----------------------------------------**
*!*			RELEASE _COD_IVA_INTRASTAT,_COD_IVA_INTRASTAT_ESE
*!*			PUBLIC _COD_IVA_INTRASTAT ,_COD_IVA_INTRASTAT_ESE
*!*			_COD_IVA_INTRASTAT 		= ""
*!*			_COD_IVA_INTRASTAT_ESE 	= ""
*!*			_TIPO_CLI_FOR			= "C"
*!*			_CODICE_CLI_FOR			= M.ORD_CODCLI
*!*			_TIPOLOGIA_DOCUMENTO	= ALLTRIM(M.ORD_TIPOLOGIA)
*!*			=INTRA_DETERMINA_IVA(_TIPO_CLI_FOR,_CODICE_CLI_FOR,_TIPOLOGIA_DOCUMENTO)
*!*			IF !EMPTY(_COD_IVA_INTRASTAT)			&& IVA INTRASTAT
*!*				IVA_CLI = _COD_IVA_INTRASTAT		&& IVA INTRASTAT
*!*			ENDIF 									&& IVA INTRASTAT
*!*			IF !EMPTY(_COD_IVA_INTRASTAT_ESE)		&& IVA INTRASTAT ESENTE
*!*				IVA_ESE = _COD_IVA_INTRASTAT_ESE 	&& IVA INTRASTAT ESENTE
*!*			ENDIF 									&& IVA INTRASTAT ESENTE
*!*			**------------------------------------------- RICERCA IVA INTRASTAT -----------------------------------------**
*!*			**-------------------------------- RICERCA IVA INTRASTAT DA ANAGRAFICA ARTICOLI -----------------------------**
*!*			PUB_SERVINTRA       				= ""
*!*			__CODICE_NAZIONE__					= M.ORD_CODNAZ
*!*			_CODICE_IVAESENTE__ATTRIBUITO__		= IVA_ESE 
*!*			_CODICE_ARTICOLO__  				= M.ORD_CODART
*!*			_IVA_ARTICOLO_=PRELEVA_CODICE_IVA_INTRASTAT_DA_ANAGRAFICA_ARTICOLI(__CODICE_NAZIONE__,_CODICE_IVAESENTE__ATTRIBUITO__,_CODICE_ARTICOLO__)
*!*			IF !EMPTY(_IVA_ARTICOLO_)
*!*				IVA_CLI = _IVA_ARTICOLO_
*!*			ENDIF
*!*			
*!*			M.ORD_CCODET = M.ORD_CCOSTO
*!*			
*!*			*** SE CLIENTE IN ESENZIONE IVA VERIFICA SE IVA ARTICOLO IN ESENZIONE E NEL CASO MANTIENE QUESTA ALIQUOTA 
*!*			*** ALTRIMENTI GESTISCE L'ALIQUOTA IN ESENZIONE A LIVELLO DI CLIENTE
*!*			IF !EMPTY(IVA_ESE)					
*!*			  PERC_ALIQ = 0
*!*			  IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(M.ORD_IVA) + "'","cx_para")
*!*			     RETURN .F.
*!*			  ENDIF
*!*			  SELECT cx_para
*!*			  GO TOP
*!*			  IF !EOF()
*!*			     cALIQ = SUBSTR(LIBERA,1,3)
*!*			     PERC_ALIQ = VAL(cALIQ)
*!*			  ENDIF
*!*			  IF PERC_ALIQ > 0
*!*			     M.ORD_IVA = IVA_ESE			&& ALIQUOTA NON IN ESENZIONE FORZO L'IVA DI ESENZIONE A LIVELLO DI CLIENTE
*!*			  ENDIF
*!*			ELSE
*!*	*!*				IF PUB_IVANAG 					&& GESTIONE IVA PRELEVATA DALL'ANAGRAFICA CLENTI

*!*	*!*				    IF !EMPTY(IVA_CLI)
*!*	*!*						M.ORD_IVA = IVA_CLI
*!*	*!*					ELSE
*!*	*!*					    PUB_ERRORE=MESSAGEBOX('In anagrafica clienti non hai codificato il codice iva !!!!'+CHR(13)+'provvedi per favore, per ora gestisco il codice iva articolo',64,'*** ATTENZIONE ***') 
*!*	*!*					ENDIF
*!*	*!*					
*!*	*!*				ENDIF 
*!*			ENDIF 

*!*	*!*			*** PER IL CALCOLO DEL LISTINO MI DEVO RIFERIRE ALL'ARTICOLO CLIENTE, 
*!*	*!*			*** SE GESTITO E SE DIVERSO DALL'ARTICOLO MAGAZZINO
*!*	*!*			LOCAL _OLD_ORD_CODART
*!*	*!*			IF PUB_CDAPRD AND !EMPTY(M.ORD_CDAPRD) AND ESISTE_ARTICOLO(M.ORD_CDAPRD)
*!*	*!*				_OLD_ORD_CODART = M.ORD_CODART
*!*	*!*				M.ORD_CODART = M.ORD_CDAPRD
*!*	*!*			ENDIF


*!*	*!*			V_TIPO = CERCATIPO(M.ORD_CODART)


*!*	*!*			DO OK_LIST     && GESTISCE I LISTINI
*!*			
*!*			PERC_ALIQ = 0
*!*			IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(M.ORD_IVA) + "'","cx_para")
*!*			   RETURN .F.
*!*			ENDIF
*!*			SELECT cx_para
*!*			GO TOP
*!*			IF !EOF()
*!*			   cALIQ = SUBSTR(LIBERA,1,3)
*!*			   PERC_ALIQ = VAL(cALIQ)
*!*			ENDIF
*!*			*_PREZZO_CON_IVA = VAL(STRTRAN(M.TOTAL,'.',',')) / M.QUANTITY
*!*			*_PREZZO_SENZA_IVA = _PREZZO_CON_IVA / (1 + (PERC_ALIQ/100))
*!*			*M.ORD_PREZZO = _PREZZO_SENZA_IVA 
*!*			*M.ORD_PREZZO = VAL(STRTRAN(M.PRICE,'.',','))
*!*			M.ORD_PREZZO = VAL(STRTRAN(M.price,'.',','))
*!*			M.ORD_PRZNET = VAL(STRTRAN(M.original_price,'.',','))
*!*			M.ORD_SC1 = (1 - (M.ORD_PRZNET / M.ORD_PREZZO)) * 100

*!*			_PRORIG = M.ORD_PRORIG
*!*			_SC1    = M.ORD_SC1
*!*			_SC2    = M.ORD_SC2
*!*			_SC3    = M.ORD_SC3
*!*			_PREZZO = M.ORD_PREZZO
*!*			
*!*			OK_COMM= .F.   && INIBISCE I COMMENTI

*!*			IF M.ORD_VALUTA = PUB_VALRIF        && SE VALUTA DIGITATA = VALUTA DI RIFERIMENTO
*!*			   M.ORD_CAMBIO = 1
*!*			ENDIF	  
*!*			IF M.ORD_PRORIG = 0
*!*			   M.ORD_PRORIG = M.ORD_PRORIT
*!*			ENDIF
*!*			IF M.ORD_SC1 = 0
*!*			   M.ORD_SC1 = M.ORD_SC1T
*!*			ENDIF
*!*			IF M.ORD_SC2 = 0
*!*			   M.ORD_SC2 = M.ORD_SC2T
*!*			ENDIF
*!*			IF M.ORD_SC3 = 0
*!*			   M.ORD_SC3 = M.ORD_SC3T
*!*			ENDIF
*!*					
*!*			VPRE         = M.ORD_PREZZO
*!*			VPRE         = VPRE-ROUND((VPRE*M.ORD_SC1/100),6)
*!*			VPRE         = VPRE-ROUND((VPRE*M.ORD_SC2/100),6)
*!*			VPRE         = VPRE-ROUND((VPRE*M.ORD_SC3/100),6)
*!*			VPRE         = VPRE-ROUND((VPRE*M.ORD_SC4/100),6)  
*!*			VPRE         = VPRE-ROUND((VPRE*M.ORD_SC5/100),6)  
*!*			M.ORD_PRZNET = VPRE
*!*			M.ORD_PRZNET = ROUND(M.ORD_PRZNET,6)
*!*			M.ORD_VALORE = CALCOLA_VALORE_RIGA_DOCUMENTO(M.ORD_PRZNET,M.ORD_QTAORD)  

*!*			DO OK_PROV     && GESTISCE LE PROVVIGIONI 
*!*			
*!*	*!*			IF PUB_CTRTAG .OR. PUB_CTRCOL
*!*	*!*			   IF M.ORD_CODTAG <> SPACE(03) .OR. M.ORD_CODCOL <> SPACE(03)
*!*	*!*			   ELSE
*!*	*!*			      DO FORM FORM\TAGCOL00 WITH "M.ORD_CODART",M.ORD_CODART,"M.ORD_DESART",M.ORD_DESART, ;
*!*	*!*			                            "M.ORD_CODCOL",M.ORD_CODCOL,"M.ORD_DESCOL",M.ORD_DESCOL, ;
*!*	*!*			                            "M.ORD_CODTAG",M.ORD_CODTAG,"M.ORD_DESTAG",M.ORD_DESTAG, ;
*!*	*!*			                            .T.
*!*	*!*			   ENDIF
*!*	*!*			ENDIF

*!*	*!*			IF PUB_CDAPRD AND !EMPTY(M.ORD_CDAPRD) AND ESISTE_ARTICOLO(M.ORD_CDAPRD)
*!*	*!*				M.ORD_CODART = _OLD_ORD_CODART
*!*	*!*			ENDIF

*!*			M.ORD_UMCLI  = ""
*!*			M.ORD_PRECLI = 0
*!*			M.ORD_QTACLI = 0
*!*			
*!*			_NEW_SEQUEN = _NEW_SEQUEN + 10
*!*			M.ORD_SEQUEN = _NEW_SEQUEN
*!*			
*!*	        M.ORS_NUMORD = M.ORD_NUMORD
*!*	        M.ORS_DATORD = M.ORD_DATORD
*!*	        M.ORS_MAGS   = M.ORD_MAGS
*!*	        M.ORS_MAGD   = M.ORD_MAGD
*!*	        M.ORS_CODCLI = M.ORD_CODCLI
*!*	        M.ORS_RAGSOC = M.ORD_RAGSOC
*!*	        M.ORS_CODEMI = M.ORD_CODEMI
*!*	        M.ORS_RAGEMI = M.ORD_RAGEMI
*!*	        M.ORS_TIPORD = M.ORD_TIPORD
*!*	        *M.ORS_DESTIN = M.ORD_DESTIN
*!*	        M.ORS_FLGABP = M.ORD_FLGABP
*!*	        
*!*	        SELECT CU_ORD_DD
*!*	        APPEND BLANK
*!*	        GATHER MEMVAR MEMO
	ENDSCAN
	
	U_CANCELLA = .T.
*!*		PUB_DAGGANCIO = M.TAGGANCIO	&& SERGIO : SERVE PER CANCELLARE IN AUTOMATICO I COMMENTI VECCHI PRIMA DEL NUOVO INSERIMENTO DELLO STESSO COMMENTO , ALTRIMENTI HO DEI COMMENTI DOPPI
*!*		=CREA_NOTE("ORD","CU_ORD_DD")
*!*		PUB_DAGGANCIO = ""			&& SERGIO : SERVE PER CANCELLARE IN AUTOMATICO I COMMENTI VECCHI PRIMA DEL NUOVO INSERIMENTO DELLO STESSO COMMENTO , ALTRIMENTI HO DEI COMMENTI DOPPI

	PUB_DAGGANCIO = M.TAGGANCIO
	=CREA_NOTE_CLIENTE("ORD",M.ORD_CODCLI,"CU_ORD_DD",PUB_DAGGANCIO,M.ORD_PESNET)
	PUB_DAGGANCIO = ""
	DO GESTIONE_ARTICOLI_AUTOMATICI WITH "ORD",M.ORD_CODCLI,"CU_ORD_DD"
	DO GESTIONE_ARTICOLO_SCONTO_CASSA WITH "ORD",M.ORD_CODCLI,"CU_ORD_DD",.F.,"M.ORD_SCASSA"
	
	*** INSERISCO RIFERIMENTO E-MAIL PER SPEDIZIONIERE COME COMMENTO NEI DETTAGLI ORDINE
    SELECT CU_ORD_DD
    GO TOP
    SCATTER MEMVAR MEMO BLANK
    APPEND BLANK
    M.DAGGANCIO  = X_TAGG
	_NEW_SEQUEN  = _NEW_SEQUEN + 10
	M.ORD_SEQUEN = _NEW_SEQUEN
	M.ORD_DESART = "*** COMMENTO ***"
	M.ORD_NOTE   = "QUANTUM VIEW: " + ALLTRIM(M.shipping_email)
	M.ORD_CODSYS = SYS(2015)
    GATHER MEMVAR MEMO
	
	* RICALCOLA IL VALORE DEL DOCUMENTO
	SELECT CU_ORD_DD
	SET FILTER TO DAGGANCIO = X_TAGG AND ORD_FLGMOD <> 'A'	 
	DO CALCORD
	SET FILTER TO
	
	SELECT CU_ORD_TT
	REPLACE ORD_VALORE WITH M.ORD_VALORE
	REPLACE ORD_IMPONIB WITH M.ORD_IMPONIB 
	REPLACE ORD_IMPOSTA WITH M.ORD_IMPOSTA 
	REPLACE ORD_NOTEEVA WITH "QUANTUM VIEW: " + ALLTRIM(M.shipping_email)
	
	_MESSAGGIO = "3 - Caricamento Ordine n° " + M.ORD_NUMORD + " del " + RIBALTA2(M.ORD_DATORD) + " Rif.: " + M.ORD_RIFERI
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO

ENDSCAN

_CONTA = 0
SELECT CU_ORD_TT
GO TOP
SCAN
	_CONTA = _CONTA + 1
ENDSCAN
GO TOP

IF !ExecRW('','U_ORD_TT','I','','CU_ORD_TT')
   return(.f.)
ENDIF

IF !ExecRW('','U_ORD_T2','I','','CU_ORD_T2')
   return(.f.)
ENDIF

IF !ExecRW('','U_ORD_DD','I','','CU_ORD_DD')
   return(.f.)
ENDIF

*!*	IF !ExecRW('','WC_ORDERS','I','','TMP_ORDERS')
*!*	   return(.f.)
*!*	ENDIF

*!*	IF !ExecRW('','WC_ORDER_LINE_ITEMS','I','','TMP_ORDER_LINE_ITEMS')
*!*	   return(.f.)
*!*	ENDIF

WAIT CLEAR

_MESSAGGIO = ""
IF _CONTA > 0
	_MESSAGGIO = "4 - Totale ordini inseriti: " + ALLTRIM(STR(_CONTA))
ELSE
	_MESSAGGIO = "4 - Nessun ordine inserito"
ENDIF
IF _CONTA_CLI_INS > 0
	_MESSAGGIO = _MESSAGGIO + REPLICATE(CHR(13),2) + "Totale nuovi clienti inseriti: " + ALLTRIM(STR(_CONTA_CLI_INS))
ENDIF
IF _CONTA_CLI_AGG > 0
	_MESSAGGIO = _MESSAGGIO + REPLICATE(CHR(13),2) + "Totale clienti aggiornati: " + ALLTRIM(STR(_CONTA_CLI_AGG))
ENDIF
**=> ERASMO - INIZIO 20/01/2023
IF TYPE("_cJson") == "C" AND !ISNULL(_cJson)
	_MESSAGGIO = _MESSAGGIO + REPLICATE(CHR(13),2) + "Oggetto JSON: " + ALLTRIM(_cJson)
ENDIF
**=> ERASMO - FINE 20/01/2023

DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
*WAIT WINDOWS _MESSAGGIO TIMEOUT 3
WAIT WINDOWS SUBSTR(_MESSAGGIO,1,200) TIMEOUT 3  && ERASMO - 20/01/2023

*** FASE FINALE DI AGGIORNAMENTO ORDINE E-COMMERCE PER CONTRASSEGNARLO COME "SCARICATO"
SELECT CU_ORD_T2
GO TOP
SCAN
	_HTTP_request = _endpoint_url+"/update_order"	
	_cJson = ""
	_EC_ORDER_CODE = ALLTRIM(EC_ORDER_CODE)

	WAIT WINDOWS "Connessione a '"+_HTTP_request+"' per contrassegnare ordine " + _EC_ORDER_CODE + " come scaricato..." NOWAIT
	
	_json_content = '{"orders":['
	_json_content = _json_content + '{"code":"' + _EC_ORDER_CODE + '"}'
	_json_content = _json_content + ']}'

	_cJson = ECOMMREST_POST(_HTTP_request,_auth_key,_json_content)
	IF EMPTY(_cJson)
		_MESSAGGIO = "Nessuna risposta da '"+_nomesito+_HTTP_request+"': verificare la URL e che sia disponibile una connessione internet"
		DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"KO",_MESSAGGIO
		*WAIT WINDOWS _MESSAGGIO TIMEOUT 3
		WAIT WINDOWS SUBSTR(_MESSAGGIO,1,200) TIMEOUT 3  && ERASMO - 20/01/2023
		RETURN .F.
	ENDIF

	IF SUBSTR(_cJson,1,2) == "KO"
		_MESSAGGIO = "Errore " + ALLTRIM(SUBSTR(_cJson,5))
		DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"KO",_MESSAGGIO
		*WAIT WINDOWS _MESSAGGIO TIMEOUT 3
		WAIT WINDOWS SUBSTR(_MESSAGGIO,1,200) TIMEOUT 3  && ERASMO - 20/01/2023
		RETURN .F.
	ENDIF

*!*		obj_json = json_decode(_cJson)

*!*		*** OGGETTO JSON VUOTO
*!*		IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
*!*		ELSE
*!*			_MESSAGGIO = "Oggetto Json restituito vuoto"
*!*			DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"KO",_MESSAGGIO
*!*			WAIT WINDOWS _MESSAGGIO TIMEOUT 3
*!*			RETURN .F.
*!*		ENDIF
	
	_MESSAGGIO = "5 - Contrassegnato ordine " + _EC_ORDER_CODE + " come scaricato"
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
	
ENDSCAN

_MESSAGGIO = "6 - Procedura terminata"
DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
*WAIT WINDOWS _MESSAGGIO TIMEOUT 3
WAIT WINDOWS SUBSTR(_MESSAGGIO,1,200) TIMEOUT 3  && ERASMO - 20/01/2023


*** AGGIORNAMENTO DISPONIBILITA' PRODOTTI SU E-COMMERCE
LOCAL _ACT_SEL
_ACT_SEL = SELECT()
DO PRG\ECOMMERCE_ESPORTA_DISPONIBILITA_PRODOTTI_CARD WITH SYS(2015)
SELECT(_ACT_SEL)


RETURN .T.


*************************************************************
PROCEDURE ECOMMERCE_CARD_INSERISCE_RIGA_ARTICOLO_IN_CU_ORD_DD
*************************************************************
*LPARAMETERS _par_prezzo,_par_prznet
*!*	**=> ERASMO - INIZIO 14/04/2022
*!*	LPARAMETERS _par_prezzo,_par_prznet,_par_parent

*!*	IF PCOUNT() >= 3
*!*	ELSE
*!*		_par_parent = 0
*!*	ENDIF

*!*	M.ORD_PARENT = _par_parent
*!*	**=> ERASMO - FINE 14/04/2022

**=> ERASMO - INIZIO 07/11/2022
LPARAMETERS _par_prezzo,_par_prznet,_par_parent,_par_bundle,_par_main_bundle,_par_disqta

IF PCOUNT() >= 3
ELSE
	_par_parent = 0
ENDIF

IF PCOUNT() >= 4
ELSE
	_par_bundle = .F.
ENDIF

IF PCOUNT() >= 5
ELSE
	_par_main_bundle = .F.
ENDIF

IF PCOUNT() >= 6
ELSE
	_par_disqta = 0
ENDIF

M.ORD_PARENT = _par_parent
**=> ERASMO - FINE 07/11/2022

IF EMPTY(M.ORD_CODART)
	M.ORD_CODART = '.'
ENDIF

**=> ERASMO - INIZIO 07/11/2022
M.ART_CODGMI = ""
IF !ExecCommand("select * from U_ART_AN where ART_CODPRI = '" + ALLTRIM(M.ORD_CODART) + "'","CX_ART_AN")
   RETURN .F.
ENDIF
SELECT CX_ART_AN
GO TOP
IF !EOF()
	M.ART_CODGMI = ART_CODGMI
ENDIF
**=> ERASMO - FINE 07/11/2022

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
*M.ORD_MAGA	  = ART_MAGA
M.ORD_MAGA    = PUB_ECMAGA
M.ORD_DESART  = ART_DESCR
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
	M.ORD_DESART = "COD. E-COMMERCE " + APITOSPA(ALLTRIM(M.product)) + " (NON PRESENTE IN ANAGRAFICA)"
ENDIF

SELECT CX_ART_PR
M.ORD_UM	  = ART_UMMAGA  
M.ORD_UMFIN	  = ART_UMMAGA  
M.ORD_UMBAR	  = ART_UMMAGA  
M.ORD_UMSEZ	  = ART_UMMAGA  
M.ORD_IVA	  = ART_CODIVA
**=> ERASMO - INIZIO 29/03/2022
*_ALIQUOTA_IVA = VAL(ALLTRIM(STR(VAL(M.vat),50,0)))
DO CASE
	CASE _ALIQUOTA_IVA = 22
		IF _YES_PUBBLICA_AMMINISTRAZIONE
			M.ORD_IVA = "SP"
		ELSE
			M.ORD_IVA = "22"
		ENDIF
	CASE _ALIQUOTA_IVA = 5
		IF _YES_PUBBLICA_AMMINISTRAZIONE
			M.ORD_IVA = "5S"
		ELSE
			M.ORD_IVA = "05"
		ENDIF
	CASE _ALIQUOTA_IVA = 0
		M.ORD_IVA = "E10"
	
	**=> ERASMO - INIZIO 07/11/2022
	OTHERWISE
		IF !_par_bundle
			M.ORD_IVA = "E10"
		ELSE
			IF _par_main_bundle
				M.ORD_IVA = "E10"
				*_par_prznet = _par_prznet / (1 + _ALIQUOTA_IVA)
				_par_prezzo = _par_prznet
			ELSE
				M.ORD_IVA = "E10"
				IF SUBSTR(M.ART_CODGMI,1,6) = '001011'  && DISACCORPAMENTO CONSUMABILI CON IVA 22%
					M.ORD_PARENT = 0
					M.ORD_QTAORD = M.ORD_QTAORD * _par_disqta
					IF _YES_PUBBLICA_AMMINISTRAZIONE
						M.ORD_IVA = "SP"
					ELSE
						M.ORD_IVA = "22"
					ENDIF
					SELECT CX_ART_PR
					_par_prznet = ART_PRZVE5  && PREZZO IN BUNDLE
					_par_prezzo = _par_prznet
					
					_VALORE_CON_IVA_ARTICOLI_DISACCORPATI = _VALORE_CON_IVA_ARTICOLI_DISACCORPATI + (_par_disqta * _par_prznet * (1 + 0.22))
					
*!*						*** AGGIORNO PREZZO IN CODICE BUNDLE PRINCIPALE
*!*						SELECT CU_ORD_DD
*!*						GO TOP
*!*						SCAN
*!*							IF ORD_SEQUEN = _par_parent
*!*								_NEW_PREZZO = (ROUND((ORD_PREZZO * (1 + (_ALIQUOTA_IVA/100))),2)) - (_par_disqta * _par_prznet * (1 + 0.22))
*!*								_NEW_PREZZO = ROUND(_NEW_PREZZO,6)
*!*								REPLACE ORD_PREZZO WITH _NEW_PREZZO 
*!*								REPLACE ORD_PRZNET WITH _NEW_PREZZO 
*!*								REPLACE ORD_SC1 WITH 0
*!*								REPLACE ORD_SC2 WITH 0
*!*								REPLACE ORD_SC3 WITH 0
*!*								REPLACE ORD_VALORE WITH CALCOLA_VALORE_RIGA_DOCUMENTO(ORD_PRZNET,ORD_QTAORD)
*!*								EXIT
*!*							ENDIF
*!*						ENDSCAN
					
				ENDIF
			ENDIF
		ENDIF
	**=> ERASMO - FINE 07/11/2022
ENDCASE
**=> ERASMO - FINE 29/03/2022
*M.ORD_PREZZO  = VAL(STRTRAN(M.TOTAL,'.',',')) / M.QUANTITY
*IF M.ORD_PREZZO = 0				&& SERGIO 2015/01/28 SE SELEZIONO UN LISTINO CON L'APPOSITO TASTO PERDE IL PREZZO DEL LISTINO
*	M.ORD_PREZZO  = ART_PRZVEN
*ENDIF
SELECT CX_ART_PR  && ERASMO - 07/11/2022
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

M.ORD_CCODET = M.ORD_CCOSTO

*!*	*** SE CLIENTE IN ESENZIONE IVA VERIFICA SE IVA ARTICOLO IN ESENZIONE E NEL CASO MANTIENE QUESTA ALIQUOTA 
*!*	*** ALTRIMENTI GESTISCE L'ALIQUOTA IN ESENZIONE A LIVELLO DI CLIENTE
*!*	IF !EMPTY(IVA_ESE)					
*!*	  PERC_ALIQ = 0
*!*	  IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(M.ORD_IVA) + "'","cx_para")
*!*	     RETURN .F.
*!*	  ENDIF
*!*	  SELECT cx_para
*!*	  GO TOP
*!*	  IF !EOF()
*!*	     cALIQ = SUBSTR(LIBERA,1,3)
*!*	     PERC_ALIQ = VAL(cALIQ)
*!*	  ENDIF
*!*	  IF PERC_ALIQ > 0
*!*	     M.ORD_IVA = IVA_ESE			&& ALIQUOTA NON IN ESENZIONE FORZO L'IVA DI ESENZIONE A LIVELLO DI CLIENTE
*!*	  ENDIF
*!*	ELSE
*!*	*!*				IF PUB_IVANAG 					&& GESTIONE IVA PRELEVATA DALL'ANAGRAFICA CLENTI

*!*	*!*				    IF !EMPTY(IVA_CLI)
*!*	*!*						M.ORD_IVA = IVA_CLI
*!*	*!*					ELSE
*!*	*!*					    PUB_ERRORE=MESSAGEBOX('In anagrafica clienti non hai codificato il codice iva !!!!'+CHR(13)+'provvedi per favore, per ora gestisco il codice iva articolo',64,'*** ATTENZIONE ***') 
*!*	*!*					ENDIF
*!*	*!*					
*!*	*!*				ENDIF 
*!*	ENDIF 

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
   RETURN .F.
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
*!*	M.ORD_PREZZO = VAL(STRTRAN(M.price,'.',','))
*!*	M.ORD_PRZNET = VAL(STRTRAN(M.original_price,'.',','))
M.ORD_PREZZO = _par_prezzo
M.ORD_PRZNET = _par_prznet
IF M.ORD_PREZZO <> 0
	M.ORD_SC1 = (1 - (M.ORD_PRZNET / M.ORD_PREZZO)) * 100
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

*!*			IF PUB_CTRTAG .OR. PUB_CTRCOL
*!*			   IF M.ORD_CODTAG <> SPACE(03) .OR. M.ORD_CODCOL <> SPACE(03)
*!*			   ELSE
*!*			      DO FORM FORM\TAGCOL00 WITH "M.ORD_CODART",M.ORD_CODART,"M.ORD_DESART",M.ORD_DESART, ;
*!*			                            "M.ORD_CODCOL",M.ORD_CODCOL,"M.ORD_DESCOL",M.ORD_DESCOL, ;
*!*			                            "M.ORD_CODTAG",M.ORD_CODTAG,"M.ORD_DESTAG",M.ORD_DESTAG, ;
*!*			                            .T.
*!*			   ENDIF
*!*			ENDIF

*!*			IF PUB_CDAPRD AND !EMPTY(M.ORD_CDAPRD) AND ESISTE_ARTICOLO(M.ORD_CDAPRD)
*!*				M.ORD_CODART = _OLD_ORD_CODART
*!*			ENDIF

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

**=> ERASMO - INIZIO 11/03/2022
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
**=> ERASMO - FINE 11/03/2022

**=> ERASMO - INIZIO 08/04/2022
M.ORD_CODSYS = SYS(2015)
M.ORD_LEGSYS = SYS(2015)
**=> ERASMO - FINE 08/04/2022

**=> ERASMO - INIZIO 05/01/2023
IF _par_bundle
	M.KEY_AGG = _CODSYS_BUNDLE
ELSE
	M.KEY_AGG = ""
ENDIF
**=> ERASMO - FINE 05/01/2023

SELECT CU_ORD_DD
APPEND BLANK
GATHER MEMVAR MEMO
 
RETURN .T.


**=> ERASMO - INIZIO 14/04/2022
******************************************************
PROCEDURE ECOMMERCE_CARD_DATI_PERSONA_FISICA_GIURIDICA
******************************************************
__OLD_SEL = SELECT()

X_RAGLEG  = ""
X_RGLEG2  = ""
X_INDLEG  = ""
X_LOCLEG  = ""
X_PROLEG  = ""
X_NAZLEG  = ""
X_CAPLEG  = ""
X_CFISLG  = ""
X_PIVALG  = ""
X_IVCELG  = ""

X_RECCOG  = ""
X_RECNOM  = ""
X_PRONAS  = ""
X_RECCDF  = ""

X_RECCAT = 1
IF EMPTY(X_PARIVA) AND LEN(X_CODFIS) == 16
	X_RECCAT = 2
ENDIF
IF X_RECCAT = 1				&& DATI PERSONA GIURIDICA
	X_RAGLEG  = X_RAGSOC
	X_RGLEG2  = X_RAGDUE
	X_INDLEG  = X_INDIR
	X_LOCLEG  = X_LOCALI
	X_PROLEG  = X_PROVIN
	X_NAZLEG  = X_NAZION
	X_CAPLEG  = X_CAP
	X_CFISLG  = X_CODFIS
	X_PIVALG  = X_PARIVA
	X_IVCELG  = X_IVACEE
ELSE						&& DATI PERSONA FISICA
	X_RECCOG  = X_RAGSOC
	X_RECNOM  = X_RAGDUE
	X_PRONAS  = X_PROVIN
	X_RECCDF  = X_CODFIS
ENDIF

X_ESTNAZ  = ""
X_ESTDOM  = ""
IF X_RECCAT = 1										&& PERSONA GIURIDICA
	x_cond = "PA.CODICE = 'STA" + X_NAZLEG + "'"
ELSE													&& PERSONA FISICA
	x_cond = "PA.CODICE = 'STA" + X_NAZION + "'"
ENDIF
cSql = "SELECT PA.DTIPOMOV AS CODNAZ_UNI, COALESCE(NU.DESCRI,'') AS DESNAZ_UNI FROM PARA AS PA " + ;
	"LEFT OUTER JOIN NAZIONI_UNICO AS NU ON NU.CODICE = PA.DTIPOMOV WHERE " + x_cond
IF !ExecCommand(cSql,"CX_PARA_NAZ")
	RETURN .F.
ENDIF
SELECT CX_PARA_NAZ
GO TOP
IF !EOF()
	IF X_reccat = 1								&& PERSONA GIURIDICA
		X_ESTNAZ = ALLTRIM(CODNAZ_UNI)
	ELSE										&& PERSONA FISICA
		X_ESTDOM = ALLTRIM(CODNAZ_UNI)
	ENDIF
ENDIF

SELECT(__OLD_SEL)

RETURN .T.
**=> ERASMO - FINE 14/04/2022