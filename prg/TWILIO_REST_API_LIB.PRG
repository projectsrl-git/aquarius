
*!*	**************************************************************************
*!*	FUNCTION SendTwilioWhatsAppMessageTemplate
*!*	**************************************************************************
*!*	LPARAMETERS tcURL, tcSID, tcToken, tcFrom, tcTo, tcContentSid, tcJsonVariables

*!*	LOCAL loHttp, lcUrl, lcAuthString, lcAuthEncoded
*!*	LOCAL lcPostData, lcResponse, lcToEncoded, lcFromEncoded

*!*	lcResponse = ""

*!*	IF !IsInternetConnected()
*!*		lcResponse = "Errore: Connessione internet non disponibile"
*!*		MESSAGEBOX(lcResponse,48,"Attenzione",3000)
*!*		RETURN lcResponse 
*!*	ENDIF

*!*	* Gestione basilare URL Encoding per i numeri (sostituisce + con %2B)
*!*	lcToEncoded   = "whatsapp:" + STRTRAN(tcTo, "+", "%2B")
*!*	lcFromEncoded = "whatsapp:" + STRTRAN(tcFrom, "+", "%2B")

*!*	TRY
*!*	    *lcUrl = "https://api.twilio.com/2010-04-01/Accounts/" + tcSID + "/Messages.json"
*!*	    tcURL = ALLTRIM(tcURL)
*!*	    tcSID = ALLTRIM(tcSID)
*!*	    IF RIGHT(tcURL,1) <> "/"
*!*	    	tcURL = tcURL + "/"
*!*	    ENDIF
*!*	    lcUrl = tcURL + tcSID + "/Messages.json"
*!*	    loHttp = CREATEOBJECT("Msxml2.ServerXMLHTTP.6.0")

*!*	    * Basic Auth
*!*	    lcAuthString = tcSID + ":" + tcToken
*!*	    lcAuthEncoded = STRCONV(lcAuthString, 13)

*!*	    * Costruzione Body per Template:
*!*	    * ContentSid = l'ID univoco del template (inizia con HX...)
*!*	    * ContentVariables = stringa JSON con i valori per {{1}}, {{2}}, ecc.
*!*	    lcPostData = "To=" + lcToEncoded + ;
*!*	                 "&From=" + lcFromEncoded + ;
*!*	                 "&ContentSid=" + tcContentSid + ;
*!*	                 "&ContentVariables=" + URLEncode(tcJsonVariables) + ;
*!*	                 "&Language=it"  && Aggiungi questa parte qui
*!*	*!*	    lcPostData = "To=" + lcToEncoded + ;
*!*	*!*	                 "&From=" + lcFromEncoded + ;
*!*	*!*	                 "&ContentSid=" + tcContentSid + ;
*!*	*!*	                 "&ContentVariables=" + tcJsonVariables + ;
*!*	*!*	                 "&Language=it"  && Aggiungi questa parte qui
*!*	                 
*!*	                 
*!*		*lcPostDataUTF8 = STRCONV(lcPostData, 9)
*!*		
*!*	    loHttp.Open("POST", lcUrl, .F.)
*!*	    loHttp.setRequestHeader("Authorization", "Basic " + lcAuthEncoded)
*!*	    loHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
*!*	    *loHttp.setRequestHeader("Content-Type", "application/json") && CAMBIA QUI

*!*	    loHttp.Send(lcPostData)
*!*	    *loHttp.Send(lcPostDataUTF8)
*!*	    lcJson = loHttp.responseText
*!*	    
*!*		lcJsonClean = STRCONV(lcJson, 11)
*!*		obj_json = nfJsonRead(lcJsonClean)
*!*		IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)	
*!*			_cProperty = obj_json.error_message
*!*			IF !ISNULL(_cProperty)
*!*				lcResponse = "Errore: " + ALLTRIM(_cProperty)
*!*			ELSE
*!*				lcResponse = "Messaggio inviato correttamente"
*!*			ENDIF
*!*		ENDIF

*!*	CATCH TO loException
*!*	    lcResponse = "Errore: " + TRANSFORM(loException.ErrorNo) + " - " + loException.Message
*!*	ENDTRY

*!*	RETURN lcResponse

*!*	ENDFUNC


*!*	**************************************************************************
*!*	FUNCTION SendTwilioWhatsAppMessageTemplate
*!*	**************************************************************************
*!*	LPARAMETERS tcURL, tcSID, tcToken, tcFrom, tcTo, tcContentSid, tcJsonVariables

*!*	LOCAL loHttp, lcUrl, lcAuthString, lcAuthEncoded, lcPostData, lcResponse
*!*	LOCAL lcMessageSid, lnTentativi, lcStatus, loJsonResult

*!*	lcResponse = ""

*!*	IF !IsInternetConnected()
*!*	    RETURN "Errore: Connessione internet non disponibile"
*!*	ENDIF

*!*	* Prepara l'autenticazione una volta sola
*!*	lcAuthString = ALLTRIM(tcSID) + ":" + ALLTRIM(tcToken)
*!*	lcAuthEncoded = STRCONV(lcAuthString, 13)
*!*	lcUrlBase = ALLTRIM(tcURL) + IIF(RIGHT(ALLTRIM(tcURL),1)="/","", "/") + tcSID + "/Messages"

*!*	TRY
*!*	    loHttp = CREATEOBJECT("Msxml2.ServerXMLHTTP.6.0")
*!*	    
*!*	    * 1. INVIO DEL MESSAGGIO (POST)
*!*	    lcPostData = "To=whatsapp:" + STRTRAN(tcTo, "+", "%2B") + ;
*!*	                 "&From=whatsapp:" + STRTRAN(tcFrom, "+", "%2B") + ;
*!*	                 "&ContentSid=" + tcContentSid + ;
*!*	                 "&ContentVariables=" + URLEncode(tcJsonVariables) + ;
*!*	                 "&Language=it"

*!*	    loHttp.Open("POST", lcUrlBase + ".json", .F.)
*!*	    loHttp.setRequestHeader("Authorization", "Basic " + lcAuthEncoded)
*!*	    loHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
*!*	    
*!*	    * Importante: invia in UTF-8 per evitare problemi con caratteri speciali
*!*	    loHttp.Send(STRCONV(lcPostData, 9))
*!*	    
*!*	    loJsonResult = nfJsonRead(STRCONV(loHttp.responseText, 11))
*!*	    
*!*	    IF TYPE("loJsonResult.sid") # "C"
*!*	        RETURN "Errore invio: " + NVL(loJsonResult.message, "Risposta sconosciuta")
*!*	    ENDIF
*!*	    
*!*	    lcMessageSid = loJsonResult.sid
*!*	    lcStatus = loJsonResult.status && Sarà probabilmente "queued" o "sent"

*!*	    * 2. POLLING DELLO STATO
*!*	    * WhatsApp impiega solitamente 1-3 secondi per rispondere a Twilio
*!*	    lnTentativi = 0
*!*	    lnTentativiMax = 10
*!*	    DO WHILE (lcStatus = "queued" OR lcStatus = "sent") AND lnTentativi < lnTentativiMax
*!*	        *WAIT "" TIMEOUT 2 && Attendi 2 secondi tra i controlli
*!*	        DO ATTENDI_N_SECONDI WITH 2
*!*	        lnTentativi = lnTentativi + 1
*!*	        
*!*	        loHttp.Open("GET", lcUrlBase + "/" + lcMessageSid + ".json", .F.)
*!*	        loHttp.setRequestHeader("Authorization", "Basic " + lcAuthEncoded)
*!*	        loHttp.Send()
*!*	        
*!*	        loJsonResult = nfJsonRead(STRCONV(loHttp.responseText, 11))
*!*	        lcStatus = loJsonResult.status
*!*	        
*!*	        IF lcStatus = "delivered" OR lcStatus = "read"
*!*	            EXIT
*!*	        ENDIF
*!*	    ENDDO

*!*	    * 3. ANALISI RISULTATO FINALE
*!*	    DO CASE
*!*	        CASE lcStatus = "delivered" OR lcStatus = "read"
*!*	            lcResponse = "Messaggio inviato e consegnato correttamente"
*!*	        CASE lcStatus = "undelivered" OR lcStatus = "failed"
*!*	            * Qui catturiamo l'errore che vedevi nel log!
*!*	            lcResponse = "Errore Consegna: " + TRANSFORM(loJsonResult.error_code) + " (Status: " + lcStatus + ")" + NVL(" - " + loJsonResult.error_message,"")
*!*	        OTHERWISE
*!*	            lcResponse = "Messaggio inviato (Stato finale non confermato: " + lcStatus + ")"
*!*	    ENDCASE

*!*	CATCH TO loException
*!*	    lcResponse = "Errore Procedura: " + TRANSFORM(loException.ErrorNo) + " - " + loException.Message
*!*	ENDTRY

*!*	RETURN lcResponse

*!*	ENDFUNC


**************************************************************************
FUNCTION SendTwilioWhatsAppMessageTemplate
**************************************************************************
LPARAMETERS tcURL, tcSID, tcToken, tcFrom, tcTo, tcContentSid, tcJsonVariables

LOCAL loHttp, lcUrlBase, lcAuthString, lcAuthEncoded, lcPostData, lcResponse
LOCAL lcMessageSid, lnTentativi, lnTentativiMax, lcStatus, loJsonResult

lcResponse = ""

IF !IsInternetConnected()
    lcResponse = "Errore: Connessione internet non disponibile"
    RETURN lcResponse 
ENDIF

* Prepara i dati di base fuori dal TRY
lcAuthString = ALLTRIM(tcSID) + ":" + ALLTRIM(tcToken)
lcAuthEncoded = STRCONV(lcAuthString, 13)
lcUrlBase = ALLTRIM(tcURL) + IIF(RIGHT(ALLTRIM(tcURL),1)=="/","", "/") + ALLTRIM(tcSID) + "/Messages"

TRY
    loHttp = CREATEOBJECT("Msxml2.ServerXMLHTTP.6.0")
    
    * 1. INVIO DEL MESSAGGIO (POST)
    lcPostData = "To=whatsapp:" + STRTRAN(tcTo, "+", "%2B") + ;
                 "&From=whatsapp:" + STRTRAN(tcFrom, "+", "%2B") + ;
                 "&ContentSid=" + tcContentSid + ;
                 "&ContentVariables=" + URLEncode(tcJsonVariables) + ;
                 "&Language=it"

    loHttp.Open("POST", lcUrlBase + ".json", .F.)
    loHttp.setRequestHeader("Authorization", "Basic " + lcAuthEncoded)
    loHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    
    * Invio in UTF-8
    loHttp.Send(STRCONV(lcPostData, 9))
    
    loJsonResult = nfJsonRead(STRCONV(loHttp.responseText, 11))
    
    * --- MODIFICA: Controllo SID senza RETURN interno ---
    IF TYPE("loJsonResult.sid") # "C"
        lcResponse = "Errore invio: " + NVL(loJsonResult.message, "Risposta sconosciuta")
    ELSE
        lcMessageSid = loJsonResult.sid
        lcStatus = loJsonResult.status 

        * 2. POLLING DELLO STATO
        lnTentativi = 0
        lnTentativiMax = 10
        
        DO WHILE (lcStatus == "queued" OR lcStatus == "sent") AND lnTentativi < lnTentativiMax
            * Uso della tua procedura esterna per l'attesa
            DO ATTENDI_N_SECONDI WITH 2
            lnTentativi = lnTentativi + 1
            
            loHttp.Open("GET", lcUrlBase + "/" + lcMessageSid + ".json", .F.)
            loHttp.setRequestHeader("Authorization", "Basic " + lcAuthEncoded)
            loHttp.Send()
            
            loJsonResult = nfJsonRead(STRCONV(loHttp.responseText, 11))
            lcStatus = loJsonResult.status
            
            IF lcStatus == "delivered" OR lcStatus == "read"
                EXIT
            ENDIF
        ENDDO

        * 3. ANALISI RISULTATO FINALE
        DO CASE
            CASE lcStatus == "delivered" OR lcStatus == "read"
                lcResponse = "Messaggio inviato e consegnato correttamente"
            
            CASE lcStatus == "undelivered" OR lcStatus == "failed"
                lcResponse = "Errore Consegna: " + TRANSFORM(NVL(loJsonResult.error_code, 0)) + ;
                             " (Status: " + lcStatus + ")" + ;
                             NVL(" - " + loJsonResult.error_message, "")
            
            OTHERWISE
                lcResponse = "Messaggio inviato (Stato finale non confermato: " + lcStatus + ")"
        ENDCASE
    ENDIF

CATCH TO loException
    lcResponse = "Errore Procedura: " + TRANSFORM(loException.ErrorNo) + " - " + loException.Message
ENDTRY

* Unico punto di uscita della funzione
RETURN lcResponse

ENDFUNC


*!*	**************************************************************************
*!*	FUNCTION SendTwilioSMSMessage
*!*	**************************************************************************
*!*	LPARAMETERS tcURL, tcSID, tcToken, tcFrom, tcTo, tcMessage

*!*	LOCAL loHttp, lcUrl, lcAuthString, lcAuthEncoded
*!*	LOCAL lcPostData, lcResponse, lcToEncoded, lcFromEncoded

*!*	lcResponse = ""

*!*	IF !IsInternetConnected()
*!*		lcResponse = "Errore: Connessione internet non disponibile"
*!*		MESSAGEBOX(lcResponse,48,"Attenzione",3000)
*!*		RETURN lcResponse 
*!*	ENDIF

*!*	* Gestione basilare URL Encoding per i numeri (sostituisce + con %2B)
*!*	lcToEncoded   = STRTRAN(tcTo, "+", "%2B")
*!*	lcFromEncoded = STRTRAN(tcFrom, "+", "%2B")

*!*	TRY
*!*	    *lcUrl = "https://api.twilio.com/2010-04-01/Accounts/" + tcSID + "/Messages.json"
*!*	    tcURL = ALLTRIM(tcURL)
*!*	    tcSID = ALLTRIM(tcSID)
*!*	    IF RIGHT(tcURL,1) <> "/"
*!*	    	tcURL = tcURL + "/"
*!*	    ENDIF
*!*	    lcUrl = tcURL + tcSID + "/Messages.json"
*!*	    loHttp = CREATEOBJECT("Msxml2.ServerXMLHTTP.6.0")

*!*	    * Basic Auth
*!*	    lcAuthString = tcSID + ":" + tcToken
*!*	    lcAuthEncoded = STRCONV(lcAuthString, 13)

*!*	    * Costruzione Body (Assicurati che tcMessage sia già codificato o pulito)
*!*	    lcPostData = "To=" + lcToEncoded + ;
*!*	    			 "&From=" + lcFromEncoded + ;
*!*	    			 "&Body=" + URLEncode(tcMessage)

*!*	    loHttp.Open("POST", lcUrl, .F.)
*!*	    loHttp.setRequestHeader("Authorization", "Basic " + lcAuthEncoded)
*!*	    loHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")

*!*	    loHttp.Send(lcPostData)
*!*	    lcJson = loHttp.responseText
*!*	    
*!*		lcJsonClean = STRCONV(lcJson, 11)
*!*		obj_json = nfJsonRead(lcJsonClean)
*!*		IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)	
*!*			_cProperty = obj_json.error_message
*!*			IF !ISNULL(_cProperty)
*!*				lcResponse = "Errore: " + ALLTRIM(_cProperty)
*!*			ELSE
*!*				lcResponse = "Messaggio inviato correttamente"
*!*			ENDIF
*!*		ENDIF

*!*	CATCH TO loException
*!*	    lcResponse = "Errore: " + TRANSFORM(loException.ErrorNo) + " - " + loException.Message
*!*	ENDTRY

*!*	RETURN lcResponse



**************************************************************************
FUNCTION SendTwilioSMSMessage
**************************************************************************
LPARAMETERS tcURL, tcSID, tcToken, tcFrom, tcTo, tcMessage

LOCAL loHttp, lcUrlBase, lcAuthString, lcAuthEncoded, lcPostData, lcResponse
LOCAL lcMessageSid, lnTentativi, lcStatus, loJsonResult, lcJson

lcResponse = ""

IF !IsInternetConnected()
    lcResponse = "Errore: Connessione internet non disponibile"
    MESSAGEBOX(lcResponse, 48, "Attenzione", 3000)
    RETURN lcResponse 
ENDIF

TRY
    * Pulizia e costruzione URL Base
    tcURL = ALLTRIM(tcURL)
    tcSID = ALLTRIM(tcSID)
    lcUrlBase = tcURL + IIF(RIGHT(tcURL,1) == "/", "", "/") + tcSID + "/Messages"
    
    loHttp = CREATEOBJECT("Msxml2.ServerXMLHTTP.6.0")
    lcAuthString = tcSID + ":" + tcToken
    lcAuthEncoded = STRCONV(lcAuthString, 13)

    lcPostData = "To=" + STRTRAN(tcTo, "+", "%2B") + ;
                 "&From=" + STRTRAN(tcFrom, "+", "%2B") + ;
                 "&Body=" + URLEncode(tcMessage)

    * 1. INVIO
    loHttp.Open("POST", lcUrlBase + ".json", .F.)
    loHttp.setRequestHeader("Authorization", "Basic " + lcAuthEncoded)
    loHttp.setRequestHeader("Content-Type", "application/x-www-form-urlencoded")
    loHttp.Send(STRCONV(lcPostData, 9))
    
    lcJson = STRCONV(loHttp.responseText, 11)
    loJsonResult = nfJsonRead(lcJson)

    * --- MODIFICA QUI: Niente RETURN dentro il TRY ---
    IF TYPE("loJsonResult.sid") # "C"
        lcResponse = "Errore API: " + NVL(loJsonResult.message, "Risposta non valida")
    ELSE
        lcMessageSid = loJsonResult.sid
        lcStatus = loJsonResult.status

        * 2. POLLING
        lnTentativi = 0
        lnTentativiMax = 0
        DO WHILE (lcStatus == "queued" OR lcStatus == "accepted") AND lnTentativi < lnTentativiMax
            DO ATTENDI_N_SECONDI WITH 2
            lnTentativi = lnTentativi + 1
            
            loHttp.Open("GET", lcUrlBase + "/" + lcMessageSid + ".json", .F.)
            loHttp.setRequestHeader("Authorization", "Basic " + lcAuthEncoded)
            loHttp.Send()
            
            loJsonResult = nfJsonRead(STRCONV(loHttp.responseText, 11))
            lcStatus = loJsonResult.status
        ENDDO

        * 3. RISULTATO FINALE
        DO CASE
            CASE INLIST(lcStatus, "sent", "delivered")
                lcResponse = "SMS inviato correttamente"
            CASE INLIST(lcStatus, "failed", "undelivered")
                lcResponse = "Errore SMS: " + TRANSFORM(NVL(loJsonResult.error_code, 0)) + ;
                             " - " + NVL(loJsonResult.error_message, "Rifiutato")
            OTHERWISE
                lcResponse = "SMS inoltrato (Stato: " + lcStatus + ")"
        ENDCASE
    ENDIF

CATCH TO loException
    lcResponse = "Errore: " + TRANSFORM(loException.ErrorNo) + " - " + loException.Message
ENDTRY

* Il RETURN deve stare SEMPRE fuori dal TRY/CATCH
RETURN lcResponse

ENDFUNC



**************************************************************************
FUNCTION URLEncode
**************************************************************************
LPARAMETERS tcString

LOCAL lcResult, lnI, lcChar, lnAsc
lcResult = ""

FOR lnI = 1 TO LEN(tcString)
    lcChar = SUBSTR(tcString, lnI, 1)
    lnAsc  = ASC(lcChar)
    
    * Caratteri "Unreserved" secondo RFC 3986: A-Z, a-z, 0-9, -, ., _, ~
    IF (lnAsc >= 65 AND lnAsc <= 90) OR ; && A-Z
       (lnAsc >= 97 AND lnAsc <= 122) OR ; && a-z
       (lnAsc >= 48 AND lnAsc <= 57) OR ; && 0-9
       INLIST(lcChar, "-", ".", "_", "~")
        
        lcResult = lcResult + lcChar
    ELSE
        * Converte in esadecimale con prefisso %
        lcResult = lcResult + "%" + RIGHT(TRANSFORM(lnAsc, "@0"), 2)
    ENDIF
ENDFOR

RETURN lcResult

ENDFUNC


***************************
PROCEDURE ATTENDI_N_SECONDI
***************************

LPARAMETERS _par_seconds

*_BEFORE_SECONDS = SECONDS()
_BEFORE_SECONDS = INT(SECONDS())   
IF _BEFORE_SECONDS >= 86399
	_BEFORE_SECONDS = 0
	DO WHILE !(SECONDS() > 0  .AND. SECONDS() < 1)  && A CAVALLO TRA 2 GIORNI, ATTENDO LA MEZZANOTTE
		LOOP
	ENDDO
ENDIF
_AFTER_SECONDS = CEILING(_BEFORE_SECONDS + _par_seconds)

DO WHILE !(SECONDS() >= _AFTER_SECONDS)
	LOOP
ENDDO

ENDPROC