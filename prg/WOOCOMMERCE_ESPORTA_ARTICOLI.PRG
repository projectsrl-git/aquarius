
IF EMPTY(PUB_WPUSER) OR EMPTY(PUB_WPPASS) OR EMPTY(PUB_WPCKEY) OR EMPTY(PUB_WPCSECRET) OR EMPTY(PUB_WPSITO)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'WordPress REST API Authentication'",16,"Attenzione")
	RETURN .F.
ENDIF

_risp = MESSAGEBOX("Esportare tutti i prodotti verso WooCommerce?",4+32+256,"Attenzione")
IF _risp = 6
ELSE
	MESSAGEBOX("Operazione abbandonata",48,"Informazione")
	RETURN .F.
ENDIF

_LOG_DATA = RIBALTA2(DTOC(DATE()))
_LOG_ORA = TIME()
_LOG_CODOPE = ALLTRIM(PUB_CODOPE)
_LOG_NOMOPE = ALLTRIM(PUB_NOMOPE)

_username = ALLTRIM(PUB_WPUSER)
_password = ALLTRIM(PUB_WPPASS)
_consumer_key = ALLTRIM(PUB_WPCKEY)
_consumer_secret = ALLTRIM(PUB_WPCSECRET)
_nomesito = ALLTRIM(PUB_WPSITO)

_HTTP_request = "/wp-json/wc/v2/products"

cSql="select * from WC_PRODUCTS where 1=0"
IF !ExecCommand(cSql,"TMP_PRODUCTS")
	return(.f.)
ENDIF

*** PRELEVO ELENCO PRODOTTI PER VERIFICA PREESISTENZA ARTICOLI
WAIT WINDOWS "Connessione a '"+_nomesito+_HTTP_request+"' in corso..." NOWAIT

_cJson = WOOCOMMREST_GET(_username,_password,_consumer_key,_consumer_secret,_nomesito,_HTTP_request)
IF EMPTY(_cJson)
	WAIT CLEAR
	MESSAGEBOX("Nessuna risposta da '"+_nomesito+_HTTP_request+"': verificare la URL e che sia disponibile una connessione internet",16,"Attenzione")
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione file Json articoli preesistenti in corso..." NOWAIT

_ErrorMsg = STRTRAN(STRTRAN(SUBSTR(_cJson, AT('"message":"',_cJson), AT('"',SUBSTR(_cJson, AT('"message":"',_cJson)),4)),'"message":',''),'"','')
if !EMPTY(_ErrorMsg)
	WAIT CLEAR
	MESSAGEBOX(_ErrorMsg,16,"Attenzione")
	RETURN .F.
ENDIF

obj_json = json_decode(_cJson)

CREATE CURSOR ACT_PRODUCTS (SKU C(16))
INDEX ON ALLTRIM(SKU) TAG I_SKU

FOR I_row = 1 TO ALEN(OBJ_JSON.Array,1)
	_cProperty = "OBJ_JSON.Array("+ALLTRIM(STR(I_row))+")._SKU"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_cCommand = "M.SKU = "+_cProperty
		&_cCommand
	ELSE
		M.SKU = ""
	ENDIF
	IF EMPTY(M.SKU)
		LOOP
	ENDIF
	SELECT ACT_PRODUCTS 
	APPEND BLANK
	REPLACE SKU WITH M.SKU
NEXT

RELEASE obj_json


*** ESPORTAZIONE ARTICOLI DA AQUARIUS
x_codi = "SUBSTRING(PR.ART_CODPRI,1,1) <> '.'"
x_nowb = "AN.ART_NONWEB = 0"
x_cond = x_codi + " and " + x_nowb
cSql   = "SELECT PR.ART_CODPRI,PR.ART_DESCR,AN.ART_DESCRWEB,PR.ART_PRZVEN,PR.ART_PRZVE2,AN.ART_SCHEDA,PR.ART_PESOUM FROM U_ART_PR AS PR LEFT OUTER JOIN U_ART_AN AS AN ON AN.ART_CODPRI = PR.ART_CODPRI WHERE " + x_cond + " ORDER BY PR.ART_CODPRI"
IF !ExecCommand(cSql,"TMP_ARTICOLI")
	return(.f.)
ENDIF
SELECT TMP_ARTICOLI
GO TOP
IF EOF()
	MESSAGEBOX("Nessun articolo da esportare verso WooCommerce",16,"Attenzione")
	RETURN .F.
ENDIF

_CONTA = 0

SCAN
	
	SCATTER MEMVAR MEMO
	
	WAIT WINDOWS "Verifica articolo '"+ALLTRIM(M.ART_CODPRI)+"' in corso..." NOWAIT
	
	*** VERIFICA PREESISTENZA ARTICOLO
	SELECT ACT_PRODUCTS
	SET ORDER TO I_SKU
	GO TOP
	SEEK ALLTRIM(M.ART_CODPRI)
	IF FOUND()
		SELECT TMP_ARTICOLI
		LOOP
	ENDIF
	
*!*		_par_sku = "sku="+ALLTRIM(M.ART_CODPRI)
*!*		_cJsonArt = ""
*!*		_cJsonArt = WOOCOMMREST_GET(_username,_password,_consumer_key,_consumer_secret,_nomesito,_HTTP_request,_par_sku)
*!*		IF !EMPTY(_cJsonArt)
*!*			_ErrorMsg = STRTRAN(STRTRAN(SUBSTR(_cJsonArt, AT('"message":"',_cJsonArt), AT('"',SUBSTR(_cJsonArt, AT('"message":"',_cJsonArt)),4)),'"message":',''),'"','')
*!*			IF EMPTY(_ErrorMsg)
*!*				obj_json_art = json_decode(_cJsonArt)
*!*				IF TYPE("obj_json_art.array(1)") <> "L"
*!*					SELECT TMP_ARTICOLI
*!*					LOOP
*!*				ENDIF
*!*			ENDIF
*!*		ENDIF
*!*		RELEASE _cJsonArt
	
	WAIT WINDOWS "Esportazione articolo '"+ALLTRIM(M.ART_CODPRI)+"' in corso..." NOWAIT
	
	_par_json_content = '"sku":' + '"' + ALLTRIM(M.ART_CODPRI) + '"'
	
	IF !EMPTY(M.ART_DESCRWEB)
		_par_json_content = _par_json_content + ' ,"name":' + '"' + ALLTRIM(M.ART_DESCRWEB) + '"'
	ELSE
		_par_json_content = _par_json_content + ' ,"name":' + '"' + ALLTRIM(M.ART_DESCR) + '"'
	ENDIF
	
	_par_json_content = _par_json_content + ' ,"short_description":' + '"' + ALLTRIM(M.ART_DESCR) + '"'
	
	IF !EMPTY(M.ART_SCHEDA)
		_par_json_content = _par_json_content + ' ,"description":' + '"' + ALLTRIM(M.ART_SCHEDA) + '"'
	ENDIF
	
	IF M.ART_PRZVEN > 0
		_par_json_content = _par_json_content + ' ,"regular_price":' + '"' + STRTRAN(ALLTRIM(STR(ROUND(M.ART_PRZVEN,2),10,2	)),',','.') + '"'
		_par_json_content = _par_json_content + ' ,"price_ita":' + '"' + STRTRAN(ALLTRIM(STR(ROUND(M.ART_PRZVEN,2),10,2	)),',','.') + '"'
	ENDIF
	
	IF M.ART_PRZVE2 > 0
		_par_json_content = _par_json_content + ' ,"price_ext":' + '"' + STRTRAN(ALLTRIM(STR(ROUND(M.ART_PRZVE2,2),10,2	)),',','.') + '"'
	ENDIF
	
	IF M.ART_PESOUM > 0
		_par_json_content = _par_json_content + ' ,"weight":' + '"' + STRTRAN(ALLTRIM(STR(ROUND(M.ART_PESOUM,2),10,2)),',','.') + '"'
	ENDIF
	
	_par_json_content = '{' + _par_json_content + '}'
	
	_cJson = ""
	_cJson = WOOCOMMREST_POST(_username,_password,_consumer_key,_consumer_secret,_nomesito,_HTTP_request,_par_json_content)
	IF EMPTY(_cJson)
		MESSAGEBOX("Nessuna risposta da '"+_nomesito+_HTTP_request+"': verificare la URL e che sia disponibile una connessione internet",16,"Attenzione")
		SELECT TMP_ARTICOLI
		LOOP
	ENDIF

	_ErrorMsg = STRTRAN(STRTRAN(SUBSTR(_cJson, AT('"message":"',_cJson), AT('"',SUBSTR(_cJson, AT('"message":"',_cJson)),4)),'"message":',''),'"','')
	if !EMPTY(_ErrorMsg)
		MESSAGEBOX(_ErrorMsg,16,"Attenzione")
		SELECT TMP_ARTICOLI
		LOOP
	ENDIF
	
	SELECT TMP_PRODUCTS
	APPEND BLANK
	GATHER MEMVAR MEMO
	REPLACE LOG_DATA WITH _LOG_DATA 
	REPLACE LOG_ORA WITH _LOG_ORA 
	REPLACE LOG_CODOPE WITH _LOG_CODOPE 
	REPLACE LOG_NOMOPE WITH _LOG_NOMOPE 
	
	_CONTA = _CONTA + 1

ENDSCAN

WAIT WINDOWS "Salvataggio log in corso..." NOWAIT

IF !ExecRW('','WC_PRODUCTS','I','','TMP_PRODUCTS')
   return(.f.)
ENDIF

WAIT CLEAR

_MESSAGGIO = ""
IF _CONTA > 0
	_MESSAGGIO = "Totale articoli inseriti: " + ALLTRIM(STR(_CONTA))
ELSE
	_MESSAGGIO = "Nessun articolo inserito"
ENDIF

MESSAGEBOX(_MESSAGGIO,64,"Informazione")

RETURN
