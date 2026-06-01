
LPARAMETERS _par_scheduled_codsys

_LOG_CODSYS = SYS(2015)
IF PCOUNT() = 0
	_LOG_CODSYS = SYS(2015)
ELSE
	IF !ISNULL(_par_scheduled_codsys) AND !EMPTY(_par_scheduled_codsys)
		_LOG_CODSYS = _par_scheduled_codsys
	ENDIF
ENDIF 

IF EMPTY(PUB_ECURL) OR EMPTY(PUB_ECAUTK) &&OR EMPTY(PUB_ECMAGA)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'E-commerce REST API Authentication'",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() >= 1
ELSE
	_RISP = MESSAGEBOX("Importare le anagrafiche clienti da e-commerce?",4+32,"Attenzione")
	IF _RISP = 7
		RETURN .F.
	ENDIF
ENDIF

_LOG_PROCEDURA = "IMPORT_CLIENTI"
_MESSAGGIO = "1 - Inizio procedura"
DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO

_endpoint_url = ALLTRIM(PUB_ECURL)
_auth_key = ALLTRIM(PUB_ECAUTK)

_HTTP_request = _endpoint_url+"/customers"	
_cJson = ""

WAIT WINDOWS "Connessione a '"+_HTTP_request+"' in corso..." NOWAIT

_cJson = ECOMMREST_POST(_HTTP_request,_auth_key)
IF EMPTY(_cJson)
	_MESSAGGIO = "Nessuna risposta da '"+_nomesito+_HTTP_request+"': verificare la URL e che sia disponibile una connessione internet"
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"KO",_MESSAGGIO
	WAIT WINDOWS _MESSAGGIO TIMEOUT 3
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione file Json in corso..." NOWAIT

IF SUBSTR(_cJson,1,2) == "KO"
	_MESSAGGIO = "Errore " + ALLTRIM(SUBSTR(_cJson,5))
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"KO",_MESSAGGIO
	WAIT WINDOWS _MESSAGGIO TIMEOUT 3
	RETURN .F.
ENDIF
*SET STEP ON
*obj_json = json_decode(_cJson)
_cErrorMessage = ""								&& ERASMO - 01/02/2023
obj_json = json_decode(_cJson,@_cErrorMessage)	&& ERASMO - 01/02/2023

*** OGGETTO JSON VUOTO
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
ELSE
	*_MESSAGGIO = "Oggetto Json restituito vuoto o non valido"
	_MESSAGGIO = "Oggetto Json restituito vuoto o non valido" + IIF(!EMPTY(ALLTRIM(_cErrorMessage)),CHR(13)+CHR(10)+ALLTRIM(_cErrorMessage),"")  && ERASMO - 01/02/2023
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"KO",_MESSAGGIO
	WAIT WINDOWS _MESSAGGIO TIMEOUT 3
	RETURN .F.
ENDIF

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' I DATI DEGLI ORDINI PRESENTI SU E-COMMERCE
CREATE CURSOR TMP_CUSTOMERS ( ;
	customer_id C(50), ;
	customer_user_id C(50), ;
	customer_code C(50), ;
	customer_name C(200), ;
	customer_first_name C(200), ;
	customer_last_name C(200), ;
	customer_enabled C(50), ;
	customer_created_at C(50), ;
	customer_updated_at C(50), ;
	customer_shipment_id C(50), ;
	customer_address C(200), ;
	customer_zip_code C(50), ;
	customer_city C(50), ;
	customer_province C(50), ;
	customer_country C(50), ;
	customer_phone C(200), ;
	customer_external_code C(50), ;
	customer_email C(200), ;
	customer_vat C(50), ;
	customer_pec C(50), ;
	customer_sdi C(50), ;
	customer_fiscal_code C(50), ;
	customer_note C(254), ;
	customer_privacy C(50), ;
	customer_marketing C(50), ;
	customer_class_code C(50), ;
	customer_group_code C(50), ;
	payment_conditions_code C(100))


FOR I_row = 1 TO ALEN(OBJ_JSON._CUSTOMERS.Array,1)
			
	=AMEMBERS(gaPropArray, obj_json._CUSTOMERS.ARRAY(I_row), 0)  && Array containing properties
	
	SELECT TMP_CUSTOMERS
	SCATTER MEMVAR MEMO BLANK
	
	_cPropertyRows = ""
	FOR I_col=1 TO ALEN(gaPropArray)
		*** DATI CLIENTE
		_cProperty = "OBJ_JSON._CUSTOMERS.Array("+ALLTRIM(STR(I_row))+")."+ALLTRIM(gaPropArray(I_col))
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			IF SUBSTR(ALLTRIM(gaPropArray(I_col)),1,1) = "_"
				_cCommand = "M.customer_"+SUBSTR(ALLTRIM(gaPropArray(I_col)),2)+" = "+_cProperty
				&_cCommand
			ENDIF
		ENDIF
		
		*** DATI CLIENTE (CANALE DI VENDITA)
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) = 'O' AND !ISNULL(&_cProperty) AND UPPER(ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))) = "CUSTOMER_CLASS"
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
		
		*** DATI CLIENTE (GRUPPO)
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) = 'O' AND !ISNULL(&_cProperty) AND UPPER(ALLTRIM(SUBSTR(_cProperty,RAT(".",_cProperty,1)+2))) = "CUSTOMER_GROUP"
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
		
		*** DATI CLIENTE (PAGAMENTO)
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
	NEXT
	
	IF M.CUSTOMER_ENABLED = 1  && ERASMO - 15/04/2022 (SOLO CLIENTI ABILITATI)
		SELECT TMP_CUSTOMERS
		APPEND BLANK
		GATHER MEMVAR MEMO
	ENDIF	
NEXT

RELEASE obj_json

SELECT TMP_CUSTOMERS 
GO TOP
IF EOF()
	_MESSAGGIO = "2 - Nessun cliente da inserire/aggiornare"
	DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
	WAIT WINDOWS _MESSAGGIO TIMEOUT 3
ENDIF


WAIT WINDOWS "Elaborazione per anagrafica Clienti in corso..." NOWAIT

*** ELABORAZIONE PER CONTROLLO ANAGRAFICA CLIENTI
_ATTIVA_INSERIMENTO_NUOVI_CLIENTI = .F.
_ATTIVA_AGGIORNAMENTO_CLIENTI = .F.
SELECT CUSTOMER_ID, CUSTOMER_EXTERNAL_CODE, CUSTOMER_FIRST_NAME, CUSTOMER_LAST_NAME, CUSTOMER_UPDATED_AT, SPACE(10) AS CLI_CODCLI, SPACE(200) AS CLI_RAGSOC, .F. AS CLI_DA_AGG FROM TMP_CUSTOMERS ;
	ORDER BY CUSTOMER_ID DESC INTO CURSOR CU_CUSTOMERS READWRITE
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
			IF !EMPTY(_CUSTOMER_UPDATED_AT) AND ALLTRIM(_CUSTOMER_UPDATED_AT) > ALLTRIM(EC_CUSTOMER_UPDATED_AT)
				_ATTIVA_AGGIORNAMENTO_CLIENTI = .T.
				_CLI_DA_AGG = .T.
			ENDIF
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
		SELECT TOP 1 * FROM TMP_CUSTOMERS WHERE VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0))) = _EC_CUSTOMER_ID ORDER BY CUSTOMER_ID INTO CURSOR TMP_CUSTOMERS_INS 
		SELECT TMP_CUSTOMERS_INS 
		GO TOP
		IF EOF()
			DELETE FROM TMP_CUSTOMERS WHERE VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0))) = _EC_CUSTOMER_ID
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
		X_RAGDUE = ""
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
			SELECT TMP_CUSTOMERS_INS
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
		X_GRUPPO = PADL(ALLTRIM(customer_group_code),3,'0')

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
*!*			SELECT TMP_CUSTOMERS_INS
		
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
		
		SELECT TMP_CUSTOMERS_INS
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
		
		SELECT TMP_CUSTOMERS_INS 
		
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
		SELECT TOP 1 * FROM TMP_CUSTOMERS WHERE VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0))) = _EC_CUSTOMER_ID ORDER BY CUSTOMER_ID INTO CURSOR TMP_CUSTOMERS_AGG
		SELECT TMP_CUSTOMERS_AGG
		GO TOP
		IF EOF()
			DELETE FROM TMP_CUSTOMERS WHERE VAL(ALLTRIM(STR(VAL(CUSTOMER_ID),50,0))) = _EC_CUSTOMER_ID
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
			SELECT TMP_CUSTOMERS_AGG
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
		SELECT TMP_CUSTOMERS_AGG
		**=> ERASMO - FINE 29/03/2022
		
		SELECT TMP_CUSTOMERS_AGG
		
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

_MESSAGGIO = "3 - Procedura terminata"
DO EC_WRITE_LOG WITH _LOG_CODSYS,_LOG_PROCEDURA,"OK",_MESSAGGIO
WAIT WINDOWS _MESSAGGIO TIMEOUT 3

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

**=> ERASMO - INIZIO 28/06/2024
****************************
PROCEDURE Tokenizer
*****************************
LPARAMETERS pStringa,pProprieta

LOCAL 	_valore,;
		_posizione,;
		_stringa,;
		_posizioneFinale

_valore=""
_stringa=pStringa
_posizione=AT(pProprieta+":",_stringa)
_posizioneFinale=0

IF _posizione>0
	_stringa=SUBSTR(_stringa,_posizione+LEN(pProprieta)+1)
	_posizioneFinale=AT(";",_stringa)-1
	IF SUBSTR(_stringa,1,1) = ";"  && CASO IN CUI IL VALORE DEVE ESSERE VOLUTAMENTE VUOTO
		_valore=""
	ELSE
		IF _posizioneFinale > 0
			_valore=ALLTRIM(SUBSTR(_stringa,1,_posizioneFinale))
		ELSE
			_valore=ALLTRIM(SUBSTR(_stringa,1))
		ENDIF
	ENDIF
ENDIF


RETURN _valore
ENDPROC 
**=> ERASMO - FINE 28/06/2024
