
***********************************************************************************************************************************************************************************
* LIBRERIA DEI METODI MESSI A DISPOSIZIONE DAL WEB SERVICE BLUENEXT PER INVIO E RICEZIONE FATTURE ELETTRONICHE VERSO E DA SISTEMA DI INTERSCAMBIO (SDI)
***********************************************************************************************************************************************************************************
*
* FATTURE ELETTRONICHE CLENTI: STEP DA SEGUIRE PER INVIO FATTURE ELETTRONICHE A PORTALE BLUENEXT:
*
*	1) Creazione file XML di Fattura elettronica da Ristampa Documenti
*	
*	2) Richiesta nuovo Nome File XML da assegnare (usare FUNCTION BLUENEXT_BOOKFILENAME) (VEDI PROGRAMMA DI TEST: prg\TEST_BLUENEXT_BOOKFILENAME.PRG)
*	
*	3) Richiesta nuovo Nome File ZIP da assegnare (usare FUNCTION BLUENEXT_BOOKFILENAME) (VEDI PROGRAMMA DI TEST: prg\TEST_BLUENEXT_BOOKFILENAME.PRG)
*	
*	4) Creazione File ZIP contenente il file XML, entrambi con i nomi richiesti da BlueNext (usare FUNCTION CREATE_ZIP_FILE) (VEDI PROGRAMMA DI TEST: prg\TEST_CREA_ZIP_FILE.PRG)
*	
*	5) Inviare il File ZIP e memorizzare l'ArchiveId restituito (usare FUNCTION BLUENEXT_SENDFILE) (VEDI PROGRAMMA DI TEST: prg\TEST_BLUENEXT_SENDFILE.PRG)
*	
*	6) Recuperare lo stato del File XML inviato (usare FUNCTION BLUENEXT_GETXMLFILESENDINGSTATE) (VEDI PROGRAMMA DI TEST: prg\TEST_BLUENEXT_GETXMLFILESENDINGSTATE.PRG)
*
*
* FATTURE ELETTRONICHE FORNITORI: STEP DA SEGUIRE PER RICEZIONE FATTURE ELETTRONICHE DAL PORTALE BLUENEXT:
*
*	1) Richiedere l’elenco dei documenti disponibili  (usare FUNCTION BLUENEXT_GETLIST) (VEDI PROGRAMMA DI TEST: prg\TEST_BLUENEXT_GETLIST.PRG)
*	
*	2) Richiedere, per ogni documento disponibile, il contenuto (usare FUNCTION BLUENEXT_GETFILE) (VEDI PROGRAMMA DI TEST: prg\TEST_BLUENEXT_GETFILE.PRG)
*	
*	3) Marcare come registrata la fattura importata nel proprio gestionale in modo da non riproporla al successivo scaricamento 
*      (usare FUNCTION BLUENEXT_MARKDOCUMENTASREGISTERD) (VEDI PROGRAMMA DI TEST: prg\TEST_BLUENEXT_MARKDOCUMENTASREGISTERD.PRG)
*	
*
***********************************************************************************************************************************************************************************

************************************************************************************************
FUNCTION BLUENEXT_LOGIN
************************************************************************************************
* RESTITUISCE IL TOKEN  E RELATIVA SCADENZA DA UTILIZZARE NELLE CHIAMATE VERSO PORTALE BLUENEXT
************************************************************************************************
* ES.:
* 	IF !BLUENEXT_LOGIN()
*		MESSAGEBOX("Errore")
*	ELSE
*		MESSAGEBOX("Token: " + PUB_BN_TOKEN)
*	ENDIF
************************************************************************************************
IF EMPTY(PUB_BNBASEURL) OR EMPTY(PUB_BNUSER) OR EMPTY(PUB_BNPASS) OR EMPTY(PUB_BNPIVA)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'Altro\Web\BlueNext'",16,"Attenzione")
	RETURN .F.
ENDIF

IF TYPE("PUB_BN_TOKEN_EXPIRE_DT") == "T"
	IF PUB_BN_TOKEN_EXPIRE_DT > DATETIME() AND !EMPTY(PUB_BN_TOKEN)
		*** TOKEN RICHIESTO IN PRECEDENZA NON ANCORA SCADUTO
		RETURN .T.
	ENDIF
ELSE
	RELEASE PUB_BN_TOKEN_EXPIRE_DT
	PUBLIC PUB_BN_TOKEN_EXPIRE_DT
	PUB_BN_TOKEN_EXPIRE_DT = DATETIME()
ENDIF

IF TYPE("PUB_BN_TOKEN") == "C"
ELSE
	RELEASE PUB_BN_TOKEN
	PUBLIC PUB_BN_TOKEN
ENDIF
PUB_BN_TOKEN = ""

*!*	PUB_BNBASEURL = "https://servizi-ms-frontend-demo.bluenext.it"
*!*	PUB_BNUSER = "72424.G.B2B"
*!*	PUB_BNPASS = ")72pxQTg"

*** CREDENZIALI
_username = ALLTRIM(PUB_BNUSER)
_password = ALLTRIM(PUB_BNPASS)

_cJson = ""
_HTTP_request = ALLTRIM(PUB_BNBASEURL) + "/b2bwebapi/login"
WAIT WINDOWS SUBSTR("Connessione per Login a '"+_HTTP_request+"' in corso...",1,254) NOWAIT

_cJson = BLUENEXTREST_POST_LOGIN(_HTTP_request,_username,_password,"service=B2B","")
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	RETURN .F.
ENDIF

WAIT WINDOWS "Login BlueNext in corso..." NOWAIT

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

*** TOKEN
_cProperty = "OBJ_JSON._access_token"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
	PUB_BN_TOKEN = &_cProperty
ENDIF
IF EMPTY(PUB_BN_TOKEN)
	WAIT WINDOWS "Parametro di ritorno 'access_token' non presente" TIMEOUT 3
	RETURN .F.
ENDIF

*** SCADENZA
_cProperty = "OBJ_JSON._expires_in"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
	PUB_BN_TOKEN_EXPIRE_DT = DATETIME() + VAL(&_cProperty)
ELSE
	WAIT WINDOWS "Parametro di ritorno 'expires_in' non presente" TIMEOUT 3
	RETURN .F.
ENDIF

RELEASE obj_json

RETURN .T.


************************************************************************************************
FUNCTION BLUENEXT_GETLIST
************************************************************************************************
* RESTITUISCE UN CURSORE CONTENENTE L'ELENCO DEI FILE INVIATI O RICEVUTI SU PORTALE BLUENEXT
************************************************************************************************
* ES.:
* 	IF !BLUENEXT_GETLIST("TMP_BN_INVOICES","2022/12/01","2022/12/31","Passive")
*		MESSAGEBOX("Errore")
*	ELSE
*		SELECT TMP_BN_INVOICES
*		GO TOP
*		BROWSE NORMAL
*	ENDIF
************************************************************************************************
LPARAMETERS _nome_cur,_data_amg_from,_data_amg_to,_category

IF PCOUNT() >= 4
ELSE
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF EMPTY(PUB_BNBASEURL) OR EMPTY(PUB_BNUSER) OR EMPTY(PUB_BNPASS) OR EMPTY(PUB_BNPIVA)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'Altro\Web\BlueNext'",16,"Attenzione")
	RETURN .F.
ENDIF

IF !BLUENEXT_LOGIN()
	MESSAGEBOX("Errore di autenticazione BlueNext")
	RETURN .F.
ENDIF

IF TYPE("PUB_BN_TOKEN") <> "C"
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non definita",16,"Attenzione")
	RETURN .F.
ENDIF

IF EMPTY(PUB_BN_TOKEN)
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non valorizzata",16,"Attenzione")
	RETURN .F.
ENDIF

_act_cur_sel = SELECT()

_token = PUB_BN_TOKEN

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' L'ELENCO DELLE FATTURE INIVATE PRESENTI SU BLUENEXT
CREATE CURSOR &_nome_cur ( ;
	ReceptionTime C(30), ;
	CreatedTime C(30), ;
	FileName C(50), ;
	ArchiveId C(36) , ;
    SdiId C(20))
    
    
*** COMPOSIZIONE JSON PER REQUEST
_json_content = '{'
_json_content = _json_content + '    "Recipient": {'
_json_content = _json_content + '        "CountryCode": "IT",'
_json_content = _json_content + '        "TaxId": "' + ALLTRIM(PUB_BNPIVA) + '"'
_json_content = _json_content + '    },'
_json_content = _json_content + '    "From": "' + STRTRAN(_data_amg_from,'/','-') + 'T00:00:00",'
_json_content = _json_content + '    "To": "' + STRTRAN(_data_amg_to,'/','-') + 'T23:59:59",'
_json_content = _json_content + '    "Registered": "false",'
_json_content = _json_content + '    "RegisteredType": "StoreDownloaded",'
_json_content = _json_content + '    "Category": "' + ALLTRIM(_category) + '"'
_json_content = _json_content + '}'

_cJsonResponse = ""
_HTTP_request = ALLTRIM(PUB_BNBASEURL) + "/b2bwebapi/api/v3/invoicedocument/getList"

WAIT WINDOWS "Interrogazione ed elaborazione elenco fatture elettroniche in corso..." NOWAIT

_cJsonResponse = BLUENEXTREST_POST_REQUEST(_HTTP_request,_token,_json_content)
IF EMPTY(_cJsonResponse)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_act_cur_sel)
	RETURN .F.
ENDIF

*!*	IF SUBSTR(_cJsonResponse,1,15) == '{"Success":true'
*!*	ELSE
*!*		_MESSAGGIO = "Errore nella request"
*!*		MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
*!*		SELECT(_act_cur_sel)
*!*		RETURN .F.
*!*	ENDIF
**=> ERASMO - INIZIO 04/11/2024
IF SUBSTR(_cJsonResponse,1,15) == '{"Success":true'
ELSE
	_MESSAGGIO = "Errore nella request"
	MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	
	OBJ_JSON = json_decode(_cJsonResponse)

	*** OGGETTO JSON VUOTO
	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
	ELSE
		_MESSAGGIO = "Oggetto Json restituito vuoto o non valido"
		MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
		SELECT(_act_cur_sel)
		RETURN .F.
	ENDIF

	_error_description = ""
	_cProperty = "OBJ_JSON._ERROR._ERROR_DESCRIPTION"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) == 'C' AND !ISNULL(&_cProperty)
		_error_description = OBJ_JSON._ERROR._ERROR_DESCRIPTION
		MESSAGEBOX(_error_description,48,"Attenzione")
	ENDIF

	RELEASE obj_json

	SELECT(_act_cur_sel)
	RETURN .F.
ENDIF
**=> ERASMO - FINE 04/11/2024

OBJ_JSON = json_decode(_cJsonResponse)

*** OGGETTO JSON VUOTO
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
ELSE
	_MESSAGGIO = "Oggetto Json restituito vuoto o non valido"
	MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	SELECT(_act_cur_sel)
	RETURN .F.
ENDIF

FOR I_row = 1 TO ALEN(OBJ_JSON._DATA._FILE.Array,1)
	
	SELECT &_nome_cur
	SCATTER MEMVAR MEMO BLANK
	
	*** VERIFICO LA PRESENZA DI ALMENO 1 FILE
	_cObject = "obj_json._DATA._FILE.ARRAY(I_row)"
	IF TYPE(_cObject) == 'O' AND !ISNULL(&_cObject)
	ELSE
		LOOP
	ENDIF
		
	=AMEMBERS(gaPropArray, obj_json._DATA._FILE.ARRAY(I_row), 0)  && Array containing properties
	
	_cPropertyRows = ""
	FOR I_col=1 TO ALEN(gaPropArray)
		*** DATI FILE I-ESIMO
		_cProperty = "OBJ_JSON._DATA._FILE.Array("+ALLTRIM(STR(I_row))+")."+ALLTRIM(gaPropArray(I_col))
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			IF SUBSTR(ALLTRIM(gaPropArray(I_col)),1,1) = "_"
				_cCommand = "M."+SUBSTR(ALLTRIM(gaPropArray(I_col)),2)+" = "+_cProperty
				&_cCommand
			ENDIF
		ENDIF		
	NEXT
	
	SELECT &_nome_cur
	APPEND BLANK
	GATHER MEMVAR MEMO
	
NEXT

RELEASE obj_json

SELECT &_nome_cur
GO TOP
*!*	IF EOF()
*!*		_MESSAGGIO = "Nessuna fattura nella lista"
*!*		MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
*!*		RETURN .F.
*!*	ENDIF
*!*	BROWSE NORMAL

SELECT(_act_cur_sel)

RETURN .T.


************************************************************************************************
FUNCTION BLUENEXT_BOOKFILENAME
************************************************************************************************
* RESTITUISCE IL NOME FILE PRENOTATO SU PORTALE BLUENEXT DA ASSEGNARE AL FILE XML O ZIP
************************************************************************************************
* ES.:
*	_V_NOME_FILE_DA_BLUENEXT = BLUENEXT_BOOKFILENAME()
* 	IF EMPTY(_V_NOME_FILE_DA_BLUENEXT)
*		MESSAGEBOX("Errore")
*	ENDIF
************************************************************************************************

IF EMPTY(PUB_BNBASEURL) OR EMPTY(PUB_BNUSER) OR EMPTY(PUB_BNPASS) OR EMPTY(PUB_BNPIVA)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'Altro\Web\BlueNext'",16,"Attenzione")
	RETURN ""
ENDIF

IF !BLUENEXT_LOGIN()
	MESSAGEBOX("Errore di autenticazione BlueNext")
	RETURN ""
ENDIF

IF TYPE("PUB_BN_TOKEN") <> "C"
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non definita",16,"Attenzione")
	RETURN ""
ENDIF

IF EMPTY(PUB_BN_TOKEN)
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non valorizzata",16,"Attenzione")
	RETURN ""
ENDIF

_act_cur_sel = SELECT()

_token = PUB_BN_TOKEN

*** COMPOSIZIONE JSON PER REQUEST
_json_content = '{'
_json_content = _json_content + '    "CountryCode": "IT",'
_json_content = _json_content + '    "TaxId": "' + ALLTRIM(PUB_BNPIVA) + '"'
_json_content = _json_content + '}'

_cJsonResponse = ""
_HTTP_request = ALLTRIM(PUB_BNBASEURL) + "/b2bwebapi/api/v1/invoicetransmission/bookFilename"

WAIT WINDOWS "Richiesta nome file fattura elettronica in corso..." NOWAIT

_cJsonResponse = BLUENEXTREST_POST_REQUEST(_HTTP_request,_token,_json_content)
IF EMPTY(_cJsonResponse)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_act_cur_sel)
	RETURN ""
ENDIF

IF SUBSTR(_cJsonResponse,1,15) == '{"Success":true'
ELSE
	_MESSAGGIO = "Errore nella request"
	MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	SELECT(_act_cur_sel)
	RETURN ""
ENDIF

OBJ_JSON = json_decode(_cJsonResponse)

*** OGGETTO JSON VUOTO
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
ELSE
	_MESSAGGIO = "Oggetto Json restituito vuoto o non valido"
	MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	SELECT(_act_cur_sel)
	RETURN ""
ENDIF

_ritorno = ""

_cProperty = "OBJ_JSON._DATA"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) == 'C' AND !ISNULL(&_cProperty)
	_ritorno = OBJ_JSON._DATA
ENDIF

RELEASE obj_json

SELECT(_act_cur_sel)

RETURN _ritorno


************************************************************************************************
FUNCTION BLUENEXT_SENDFILE
************************************************************************************************
* INVIA UNA FATTURA ELETTRONICA VERSO PORTALE BLUENEXT
************************************************************************************************
* ES.:
* 	_V_NOME_COMPLETO_FILE_ZIP = "C:\Users\Erasmo\Desktop\TEST BLUENEXT\X BLUENEXT\TEST_ERRORE\IT02406660064_061222102603716.zip"
* 	_V_ERROR_MESSAGE = ""
* 	_V_ARCHIVEID = BLUENEXT_SENDFILE(_V_NOME_COMPLETO_FILE_ZIP,@_V_ERROR_MESSAGE)
* 	IF EMPTY(_V_ARCHIVEID)
* 		_V_ERROR_MESSAGE = STRTRAN(_V_ERROR_MESSAGE,"<br />",CHR(13)+CHR(10))
* 		_V_ERROR_MESSAGE = STRTRAN(_V_ERROR_MESSAGE,"<br>",CHR(13)+CHR(10))
* 		MESSAGEBOX("Errore: " + _V_ERROR_MESSAGE)
* 	ELSE
* 		MESSAGEBOX("Fattura inviata" + CHR(13) + ;
* 			"ArchiveId: " + _V_ARCHIVEID)
* 	ENDIF
************************************************************************************************
LPARAMETERS _nome_completo_file_zip,_error_description

IF PCOUNT() >= 1
ELSE
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN ""
ENDIF

IF PCOUNT() >= 2
ELSE
	_error_description = ""
ENDIF

IF EMPTY(PUB_BNBASEURL) OR EMPTY(PUB_BNUSER) OR EMPTY(PUB_BNPASS) OR EMPTY(PUB_BNPIVA)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'Altro\Web\BlueNext'",16,"Attenzione")
	RETURN ""
ENDIF

IF !BLUENEXT_LOGIN()
	MESSAGEBOX("Errore di autenticazione BlueNext")
	RETURN ""
ENDIF

IF TYPE("PUB_BN_TOKEN") <> "C"
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non definita",16,"Attenzione")
	RETURN ""
ENDIF

IF EMPTY(PUB_BN_TOKEN)
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non valorizzata",16,"Attenzione")
	RETURN ""
ENDIF

IF !FILE(_nome_completo_file_zip)
	MESSAGEBOX("File non trovato",16,"Attenzione")
	RETURN ""
ENDIF

_act_cur_sel = SELECT()

_token = PUB_BN_TOKEN
_filename = JUSTFNAME(_nome_completo_file_zip)
_filecontent_encode_64 = STRCONV(FILETOSTR(ALLTRIM(_nome_completo_file_zip)),13)

*** COMPOSIZIONE JSON PER REQUEST
_json_content = '{'
_json_content = _json_content + '    "SendMode": 0,'
_json_content = _json_content + '    "AdditionalInfo": null,'
_json_content = _json_content + '    "Filename": "' + ALLTRIM(_filename) + '",'
_json_content = _json_content + '    "File": "' + ALLTRIM(_filecontent_encode_64) + '"'
_json_content = _json_content + '}'

_cJsonResponse = ""
_HTTP_request = ALLTRIM(PUB_BNBASEURL) + "/b2bwebapi/api/v1/invoicetransmission/sendFile"

WAIT WINDOWS "Invio ed elaborazione file fattura elettronica in corso..." NOWAIT

_cJsonResponse = BLUENEXTREST_POST_REQUEST(_HTTP_request,_token,_json_content)
IF EMPTY(_cJsonResponse)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_act_cur_sel)
	RETURN ""
ENDIF

IF SUBSTR(_cJsonResponse,1,15) == '{"Success":true'
ELSE
	_MESSAGGIO = "Errore nella request"
	MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	
	OBJ_JSON = json_decode(_cJsonResponse)

	*** OGGETTO JSON VUOTO
	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
	ELSE
		_MESSAGGIO = "Oggetto Json restituito vuoto o non valido"
		MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
		SELECT(_act_cur_sel)
		RETURN ""
	ENDIF

	_error_description = ""

	_cProperty = "OBJ_JSON._ERROR._ERROR_DESCRIPTION"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) == 'C' AND !ISNULL(&_cProperty)
		_error_description = OBJ_JSON._ERROR._ERROR_DESCRIPTION
	ENDIF

	RELEASE obj_json

	SELECT(_act_cur_sel)
	RETURN ""
ENDIF

OBJ_JSON = json_decode(_cJsonResponse)

*** OGGETTO JSON VUOTO
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
ELSE
	_MESSAGGIO = "Oggetto Json restituito vuoto o non valido"
	MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	SELECT(_act_cur_sel)
	RETURN ""
ENDIF

_archiveid_ritorno = ""

_cProperty = "OBJ_JSON._DATA._ARCHIVEID"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) == 'C' AND !ISNULL(&_cProperty)
	_archiveid_ritorno = OBJ_JSON._DATA._ARCHIVEID
ENDIF

RELEASE obj_json

SELECT(_act_cur_sel)

RETURN _archiveid_ritorno



************************************************************************************************
FUNCTION BLUENEXT_GETXMLFILESENDINGSTATE
************************************************************************************************
* RESTITUISCE LO STATO DEL FILE XML PRECEDENTEMENTE ESPORTATO VERSO PORTALE BLUENEXT
************************************************************************************************
* ES.:
*	_V_ERROR_DESCRIPTION = ""
*	_V_STATO_FILE_XML = BLUENEXT_GETXMLFILESENDINGSTATE(_V_NOME_FILE_XML,_V_ARCHIVEID,@_V_ERROR_DESCRIPTION)
* 	IF EMPTY(_V_STATO_FILE_XML)
*		MESSAGEBOX("Errore")
*	ELSE
*		MESSAGEBOX("Stato file: " + ALLTRIM(STR(_V_STATO_FILE_XML,10,0)))
*		IF !EMPTY(_V_ERROR_DESCRIPTION)
*			MESSAGEBOX("Descrizione errore: " + ALLTRIM(_V_ERROR_DESCRIPTION))
*		ENDIF
*	ENDIF
************************************************************************************************
LPARAMETERS _nome_file_xml,_archiveid,_error_description

IF PCOUNT() >= 2
ELSE
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() >= 3
ELSE
	_error_description = ""
ENDIF

IF EMPTY(PUB_BNBASEURL) OR EMPTY(PUB_BNUSER) OR EMPTY(PUB_BNPASS) OR EMPTY(PUB_BNPIVA)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'Altro\Web\BlueNext'",16,"Attenzione")
	RETURN .F.
ENDIF

IF !BLUENEXT_LOGIN()
	MESSAGEBOX("Errore di autenticazione BlueNext")
	RETURN .F.
ENDIF

IF TYPE("PUB_BN_TOKEN") <> "C"
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non definita",16,"Attenzione")
	RETURN .F.
ENDIF

IF EMPTY(PUB_BN_TOKEN)
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non valorizzata",16,"Attenzione")
	RETURN .F.
ENDIF

_act_cur_sel = SELECT()

_token = PUB_BN_TOKEN

*** COMPOSIZIONE JSON PER REQUEST
_json_content = '{'
_json_content = _json_content + '    "ArchiveId": "' + ALLTRIM(_archiveid) + '",'
_json_content = _json_content + '    "FileName": "' + ALLTRIM(_nome_file_xml) + '"'
_json_content = _json_content + '}'

_cJsonResponse = ""
_HTTP_request = ALLTRIM(PUB_BNBASEURL) + "/b2bwebapi/api/v2/invoicedocument/getXmlFileSendingState"

WAIT WINDOWS "Interrogazione ed elaborazione stato file fattura elettronica in corso..." NOWAIT

_cJsonResponse = BLUENEXTREST_POST_REQUEST(_HTTP_request,_token,_json_content)
IF EMPTY(_cJsonResponse)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_act_cur_sel)
	RETURN .F.
ENDIF

IF SUBSTR(_cJsonResponse,1,15) == '{"Success":true'
ELSE
	_MESSAGGIO = "Errore nella request"
	MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	SELECT(_act_cur_sel)
	RETURN .F.
ENDIF

OBJ_JSON = json_decode(_cJsonResponse)

*** OGGETTO JSON VUOTO
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
ELSE
	_MESSAGGIO = "Oggetto Json restituito vuoto o non valido"
	MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	SELECT(_act_cur_sel)
	RETURN .F.
ENDIF

_ritorno = 0

_cProperty = "OBJ_JSON._DATA._STATE"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) == 'N' AND !ISNULL(&_cProperty)
	_ritorno = OBJ_JSON._DATA._STATE
ENDIF

_cProperty = "OBJ_JSON._DATA._ERRORDESCRIPTION"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) == 'C' AND !ISNULL(&_cProperty)
	_error_description = OBJ_JSON._DATA._ERRORDESCRIPTION
ENDIF

RELEASE obj_json

SELECT(_act_cur_sel)

RETURN _ritorno


************************************************************************************************
FUNCTION BLUENEXT_GETRECEIPT
************************************************************************************************
* RESTITUISCE UN CURSORE CONTENENTE UN RECORD CON I CAMPI DELLA RICEVUTA DEL SDI RELATIVAMENTE
* ALLA FATTURA ESPORTATA VERSO PORTALE BLUENEXT
************************************************************************************************
* ES.:
* 	IF !BLUENEXT_GETRECEIPT("TMP_BN_RECEIPT",_V_NOME_FILE_XML,_V_ARCHIVEID)
*		MESSAGEBOX("Errore")
*	ELSE
*		SELECT TMP_BN_RECEIPT
*		GO TOP
*		BROWSE NORMAL
*	ENDIF
************************************************************************************************
LPARAMETERS _nome_cur,_nome_file_xml,_archiveid

IF PCOUNT() >= 3
ELSE
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF EMPTY(PUB_BNBASEURL) OR EMPTY(PUB_BNUSER) OR EMPTY(PUB_BNPASS) OR EMPTY(PUB_BNPIVA)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'Altro\Web\BlueNext'",16,"Attenzione")
	RETURN .F.
ENDIF

IF !BLUENEXT_LOGIN()
	MESSAGEBOX("Errore di autenticazione BlueNext")
	RETURN .F.
ENDIF

IF TYPE("PUB_BN_TOKEN") <> "C"
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non definita",16,"Attenzione")
	RETURN .F.
ENDIF

IF EMPTY(PUB_BN_TOKEN)
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non valorizzata",16,"Attenzione")
	RETURN .F.
ENDIF

_act_cur_sel = SELECT()

_token = PUB_BN_TOKEN

*** COMPONGO IL CURSORE DI APPOGGIO CHE CONTERRA' UN RECORD CON I CAMPI DELLA RICEVUTA DEL SDI RELATIVAMENTE ALLA FATTURA ESPORTATA VERSO PORTALE BLUENEXT
CREATE CURSOR &_nome_cur ( ;
	IdentificativoSdI C(20), ;
	NomeFile C(50), ;
	Hash C(100), ;
	DataOraRicezione C(30), ;
	DataOraConsegna C(30), ;
	DataMessaADisposizione C(10), ;
	Destinatario_Codice C(10), ;
	Destinatario_Pec C(254), ;
	MessageId C(20), ;
	Descrizione M)

*** COMPOSIZIONE JSON PER REQUEST
_json_content = '{'
_json_content = _json_content + '    "ArchiveId": "' + ALLTRIM(_archiveid) + '",'
_json_content = _json_content + '    "FileName": "' + ALLTRIM(_nome_file_xml) + '"'
_json_content = _json_content + '}'

_cJsonResponse = ""
_HTTP_request = ALLTRIM(PUB_BNBASEURL) + "/b2bwebapi/api/v2/invoicedocument/getReceipt"

WAIT WINDOWS "Interrogazione ed elaborazione ricevuta file fattura elettronica in corso..." NOWAIT

_cJsonResponse = BLUENEXTREST_POST_REQUEST(_HTTP_request,_token,_json_content)
IF EMPTY(_cJsonResponse)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_act_cur_sel)
	RETURN .F.
ENDIF

IF SUBSTR(_cJsonResponse,1,15) == '{"Success":true'
ELSE
	*_MESSAGGIO = "Errore nella request"
	*MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	SELECT(_act_cur_sel)
	RETURN .F.
ENDIF

OBJ_JSON = json_decode(_cJsonResponse)

*** OGGETTO JSON VUOTO
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
ELSE
	_MESSAGGIO = "Oggetto Json restituito vuoto o non valido"
	MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	SELECT(_act_cur_sel)
	RETURN .F.
ENDIF

_receiptXml = ""

_cProperty = "OBJ_JSON._SUCCESS"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) == 'L' AND !ISNULL(&_cProperty)
	IF !OBJ_JSON._SUCCESS
		_MESSAGGIO = "Oggetto Json restituito vuoto"
		MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
		SELECT(_act_cur_sel)
		RETURN .F.
	ENDIF
ENDIF

_cProperty = "OBJ_JSON._DATA"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) == 'C' AND !ISNULL(&_cProperty)
	IF EMPTY(OBJ_JSON._DATA)
		_MESSAGGIO = "Oggetto Json restituito vuoto"
		MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
		SELECT(_act_cur_sel)
		RETURN .F.
	ELSE
		_receiptXml = STRCONV(OBJ_JSON._DATA,14)
		_receiptXml = STRCONV(_receiptXml,11)
	ENDIF
ENDIF

RELEASE obj_json

_IdentificativoSdI = STREXTRACT(_receiptXml,'<IdentificativoSdI>','</IdentificativoSdI>',1)
_NomeFile = STREXTRACT(_receiptXml,'<NomeFile>','</NomeFile>',1)
_Hash = STREXTRACT(_receiptXml,'<Hash>','</Hash>',1)
_DataOraRicezione = STREXTRACT(_receiptXml,'<DataOraRicezione>','</DataOraRicezione>',1)
_DataOraConsegna = STREXTRACT(_receiptXml,'<DataOraConsegna>','</DataOraConsegna>',1)
_DataMessaADisposizione = STREXTRACT(_receiptXml,'<DataMessaADisposizione>','</DataMessaADisposizione>',1)
_Destinatario_Codice = STREXTRACT(_receiptXml,'<Codice>','</Codice>',1)
_Destinatario_Pec = STREXTRACT(_receiptXml,'<PEC>','</PEC>',1)
_MessageId = STREXTRACT(_receiptXml,'<MessageId>','</MessageId>',1)
_Descrizione = STREXTRACT(_receiptXml,'<Descrizione>','</Descrizione>',1)

SELECT &_nome_cur
APPEND BLANK
REPLACE IdentificativoSdI WITH _IdentificativoSdI 
REPLACE NomeFile WITH _NomeFile 
REPLACE Hash WITH _Hash 
REPLACE DataOraRicezione WITH _DataOraRicezione 
REPLACE DataOraConsegna WITH _DataOraConsegna 
REPLACE DataMessaADisposizione WITH _DataMessaADisposizione 
REPLACE Destinatario_Codice WITH _Destinatario_Codice 
REPLACE Destinatario_Pec WITH _Destinatario_Pec 
REPLACE MessageId WITH _MessageId 
REPLACE Descrizione WITH _Descrizione 

SELECT(_act_cur_sel)

RETURN .T.


************************************************************************************************
FUNCTION BLUENEXT_GETFILE
************************************************************************************************
* EFFETTUA IL DOWNLOAD DEL FILE XML RICHIESTO, PRESENTE SUL PORTALE BLUENEXT
************************************************************************************************
* ES.:
*	_V_OK_DOWNLOADED = BLUENEXT_GETFILE(_V_NOME_FILE_XML,_V_ARCHIVEID,_V_DIRECTORY)
* 	IF !_V_OK_DOWNLOADED
*		MESSAGEBOX("Errore")
*	ELSE
*		MESSAGEBOX("File scaricato correttamente nella directory " + ALLTRIM(_V_DIRECTORY))
*	ENDIF
************************************************************************************************
LPARAMETERS _nome_file_xml,_archiveid,_directory

IF PCOUNT() >= 3
ELSE
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF EMPTY(PUB_BNBASEURL) OR EMPTY(PUB_BNUSER) OR EMPTY(PUB_BNPASS) OR EMPTY(PUB_BNPIVA)
	MESSAGEBOX("Configurare correttamente tutti i parametri di sistema nella sezione 'Altro\Web\BlueNext'",16,"Attenzione")
	RETURN .F.
ENDIF

IF !BLUENEXT_LOGIN()
	MESSAGEBOX("Errore di autenticazione BlueNext")
	RETURN .F.
ENDIF

IF TYPE("PUB_BN_TOKEN") <> "C"
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non definita",16,"Attenzione")
	RETURN .F.
ENDIF

IF EMPTY(PUB_BN_TOKEN)
	MESSAGEBOX("Variabile pubblica PUB_BN_TOKEN non valorizzata",16,"Attenzione")
	RETURN .F.
ENDIF

_act_cur_sel = SELECT()

_token = PUB_BN_TOKEN

*** CONTROLLO ESISTENZA DIRECTORY
IF DIRECTORY(_directory,1)
ELSE
	MESSAGEBOX("Directory passata '" + _directory + "' inesistente",16,"Attenzione")
	RETURN .F.
ENDIF

*** COMPOSIZIONE JSON PER REQUEST
_json_content = '{'
_json_content = _json_content + '    "ArchiveId": "' + ALLTRIM(_archiveid) + '",'
_json_content = _json_content + '    "FileName": "' + ALLTRIM(_nome_file_xml) + '",'
_json_content = _json_content + '    "FileFormat": "Xml"'
_json_content = _json_content + '}'

_cJsonResponse = ""
_HTTP_request = ALLTRIM(PUB_BNBASEURL) + "/b2bwebapi/api/v3/invoicedocument/getFile"

WAIT WINDOWS "Download ed elaborazione file fattura elettronica in corso..." NOWAIT

_cJsonResponse = BLUENEXTREST_POST_REQUEST(_HTTP_request,_token,_json_content)
IF EMPTY(_cJsonResponse)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	SELECT(_act_cur_sel)
	RETURN .F.
ENDIF

IF SUBSTR(_cJsonResponse,1,15) == '{"Success":true'
ELSE
	_MESSAGGIO = "Errore nella request"
	MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	SELECT(_act_cur_sel)
	RETURN .F.
ENDIF

*!*	OBJ_JSON = json_decode(_cJsonResponse)

*!*	*** OGGETTO JSON VUOTO
*!*	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
*!*	ELSE
*!*		_MESSAGGIO = "Oggetto Json restituito vuoto o non valido"
*!*		MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
*!*		SELECT(_act_cur_sel)
*!*		RETURN .F.
*!*	ENDIF

*!*	_fileXml = ""

*!*	_cProperty = "OBJ_JSON._SUCCESS"
*!*	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) == 'L' AND !ISNULL(&_cProperty)
*!*		IF !OBJ_JSON._SUCCESS
*!*			_MESSAGGIO = "Oggetto Json restituito vuoto"
*!*			MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
*!*			SELECT(_act_cur_sel)
*!*			RETURN .F.
*!*		ENDIF
*!*	ENDIF

*!*	_cProperty = "OBJ_JSON._DATA._CONTENT"
*!*	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) == 'C' AND !ISNULL(&_cProperty)
*!*		IF EMPTY(OBJ_JSON._DATA._CONTENT)
*!*			_MESSAGGIO = "Oggetto Json restituito vuoto"
*!*			MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
*!*			SELECT(_act_cur_sel)
*!*			RETURN .F.
*!*		ELSE
*!*			_fileXml = STRCONV(OBJ_JSON._DATA._CONTENT,14)
*!*		ENDIF
*!*	ENDIF

**=> ERASMO - INIZIO 27/03/2024
_fileXml = ""
*_startContentPosition = 25
*_cContent = SUBSTR(_cJsonResponse,_startContentPosition,LEN(_cJsonResponse)-_startContentPosition-2)
**=> ERASMO - INIZIO 22/11/2024
_cStartPosition = '"Data":"'
_startContentPosition = AT(_cStartPosition,_cJsonResponse,1) + LEN(_cStartPosition)
_cContent = SUBSTR(_cJsonResponse,_startContentPosition)
_cEndPosition = '"}'
_endContentPosition = AT(_cEndPosition,_cContent,1)
_cContent = SUBSTR(_cContent,1,_endContentPosition)
**=> ERASMO - FINE 22/11/2024
IF EMPTY(_cContent)
	_MESSAGGIO = "Oggetto Json restituito vuoto"
	MESSAGEBOX(_MESSAGGIO,16,"Attenzione")
	SELECT(_act_cur_sel)
	RETURN .F.
ELSE
	_fileXml = STRCONV(_cContent,14)
ENDIF
**=> ERASMO - FINE 27/03/2024

_new_filename = ALLTRIM(_directory) + IIF(RIGHT(ALLTRIM(_directory),1) = "\", "", "\") + ALLTRIM(_nome_file_xml) + IIF(UPPER(RIGHT(ALLTRIM(_nome_file_xml),4)) = ".XML", "", ".xml")
STRTOFILE(_fileXml,_new_filename,0)

IF !FILE(_new_filename,1)
	MESSAGEBOX("File generato '" + _new_filename + "' non trovato",16,"Attenzione")
	RETURN .F.
ENDIF

*!*	_cProperty = "OBJ_JSON._DATA._ERRORDESCRIPTION"
*!*	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) == 'C' AND !ISNULL(&_cProperty)
*!*		_error_description = OBJ_JSON._DATA._ERRORDESCRIPTION
*!*	ENDIF

RELEASE obj_json

SELECT(_act_cur_sel)

RETURN .T.
