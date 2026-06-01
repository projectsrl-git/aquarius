_username = ALLTRIM(PUB_WPUSER)
_password = ALLTRIM(PUB_WPPASS)
_consumer_key = ALLTRIM(PUB_WPCKEY)
_consumer_secret = ALLTRIM(PUB_WPCSECRET)
_nomesito = ALLTRIM(PUB_WPSITO)

_HTTP_request = "/wp-json/wc/v2/products/288"

SET STEP ON

_cJson = WOOCOMMREST_PUT(_username,_password,_consumer_key,_consumer_secret,_nomesito,_HTTP_request,'{"regular_price": "24.54"}')
IF EMPTY(_cJson)
	WAIT CLEAR
	MESSAGEBOX("Nessuna risposta da '"+_nomesito+_HTTP_request+"': verificare la URL e che sia disponibile una connessione internet",16,"Attenzione")
	RETURN .F.
ENDIF

_ErrorMsg = STRTRAN(STRTRAN(SUBSTR(_cJson, AT('"message":"',_cJson), AT('"',SUBSTR(_cJson, AT('"message":"',_cJson)),4)),'"message":',''),'"','')
if !EMPTY(_ErrorMsg)
	WAIT CLEAR
	MESSAGEBOX(_ErrorMsg,16,"Attenzione")
	RETURN .F.
ENDIF