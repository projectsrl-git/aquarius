
PROCEDURE SEND_OAUTH2MICROSOFTGRAPH

LPARAMETERS _par_from,_par_to,_par_cc,_par_subject,_par_body,_par_attach,_par_ccn,_par_MGTKNURI,_par_MGEMLURI,_par_MGTNTID,_par_MGCLNID,_par_MGCLNSEC,_par_conferma,_par_HTMLBody

IF PCOUNT() >= 14
ELSE
	WAIT WINDOWS "Parametri insufficienti per l'esecuzione della procedura SEND_OAUTH2MICROSOFTGRAPH" TIMEOUT 3
	RETURN .F.
ENDIF

_par_body = STRTRAN(_par_body,'"','&quot;')
_par_HTMLBody = STRTRAN(_par_HTMLBody,'"','&quot;')
_par_HTMLBody = STRTRAN(_par_HTMLBody,CHR(13),'')
_par_HTMLBody = STRTRAN(_par_HTMLBody,CHR(10),'')

_HTTP_request = ALLTRIM(STRTRAN(_par_MGTKNURI,"$tenantId",_par_MGTNTID))

*!*	TRY
*!*		loRequest = Createobject('MsXml2.XmlHttp')
*!*		loRequest.Open("POST",_HTTP_request,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
*!*		lcPostData = 'client_id=' + ALLTRIM(_par_MGCLNID)
*!*		lcPostData = lcPostData + '&scope=https://graph.microsoft.com/.default'
*!*		lcPostData = lcPostData + '&client_secret=' + ALLTRIM(_par_MGCLNSEC)
*!*		lcPostData = lcPostData + '&grant_type=client_credentials'
*!*		loRequest.Send(lcPostData)
*!*	CATCH TO oException
*!*		loRequest = Createobject('MsXml2.XmlHttp.6.0')
*!*		loRequest.Open("POST",_HTTP_request,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
*!*		lcPostData = 'client_id=' + ALLTRIM(_par_MGCLNID)
*!*		lcPostData = lcPostData + '&scope=https://graph.microsoft.com/.default'
*!*		lcPostData = lcPostData + '&client_secret=' + ALLTRIM(_par_MGCLNSEC)
*!*		lcPostData = lcPostData + '&grant_type=client_credentials'
*!*		loRequest.Send(lcPostData)
*!*	FINALLY
*!*		V_BODY = ""
*!*		IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*			IF TYPE("loRequest.ResponseBody") == 'Q'
*!*				V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*			ENDIF
*!*			IF TYPE("loRequest.ResponseBody") == 'C'
*!*				V_BODY = loRequest.ResponseBody
*!*			ENDIF
*!*		ENDIF
*!*	ENDTRY

**=> ERASMO - INIZIO 29/04/2025
TRY
	
	loRequest = Createobject('MsXml2.XmlHttp')
	loRequest.Open("POST",_HTTP_request,.F.)
	loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
	lcPostData = 'client_id=' + ALLTRIM(_par_MGCLNID)
	lcPostData = lcPostData + '&scope=https://graph.microsoft.com/.default'
	lcPostData = lcPostData + '&client_secret=' + ALLTRIM(_par_MGCLNSEC)
	lcPostData = lcPostData + '&grant_type=client_credentials'
	loRequest.Send(lcPostData)
	
CATCH TO oException

	TRY
		
		loRequest = Createobject('MsXml2.XmlHttp.6.0')
		loRequest.Open("POST",_HTTP_request,.F.)
		loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
		lcPostData = 'client_id=' + ALLTRIM(_par_MGCLNID)
		lcPostData = lcPostData + '&scope=https://graph.microsoft.com/.default'
		lcPostData = lcPostData + '&client_secret=' + ALLTRIM(_par_MGCLNSEC)
		lcPostData = lcPostData + '&grant_type=client_credentials'
		loRequest.Send(lcPostData)
		
	CATCH TO oException2
		
		oException2.UserValue = "Nested CATCH message: Unable to handle"
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[Nested Catch! (Unhandled: Throw oException2 Object Up) ]"
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[ Inner Exception Object: ]"
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  Error: ]" + STR(oException2.ErrorNo)
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  LineNo: ]" + STR(oException2.LineNo)
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  Message: ]" + oException2.Message
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  Procedure: ]" + oException2.Procedure
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  Details: ]" + oException2.Details
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  StackLevel: ]" + STR(oException2.StackLevel) 
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  LineContents: ]" + oException2.LineContents
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  UserValue: ]" + oException2.UserValue

		THROW oException2
      
	FINALLY
	
		V_BODY = ""
		IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
			IF TYPE("loRequest.ResponseBody") == 'Q'
				V_BODY = STRCONV(loRequest.ResponseBody,11)
			ENDIF
			IF TYPE("loRequest.ResponseBody") == 'C'
				V_BODY = loRequest.ResponseBody
			ENDIF
		ENDIF
		
	ENDTRY
	
FINALLY
	
	V_BODY = ""
	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
		IF TYPE("loRequest.ResponseBody") == 'Q'
			V_BODY = STRCONV(loRequest.ResponseBody,11)
		ENDIF
		IF TYPE("loRequest.ResponseBody") == 'C'
			V_BODY = loRequest.ResponseBody
		ENDIF
	ENDIF
	
ENDTRY
**=> ERASMO - FINE 29/04/2025

LOCAL _rit
_rit = ""
IF !EMPTY(V_BODY)
	_cJsonFixUnicode = V_BODY
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00e0','à')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00e1','á')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00e8','è')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00e9','é')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00ec','ì')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00ed','í')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00f2','ò')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00f3','ó')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00f9','ù')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00fa','ú')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00c0','À')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00c1','Á')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00c8','È')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00c9','É')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00cc','Ì')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00cd','Í')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00d2','Ò')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00d3','Ó')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00d9','Ù')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00da','Ú')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00f1','ñ')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00d1','Ñ')
	_rit = _cJsonFixUnicode
ELSE
	_rit = ALLTRIM(STR(loRequest.status,10,0))	
ENDIF

RELEASE loRequest

_cJson = _rit
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	RETURN .F.
ENDIF

*WAIT WINDOWS "Elaborazione file Json in corso..." NOWAIT

RELEASE obj_json
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

_json_content = '{"message": {'
_json_content = _json_content + '"subject": "' + _par_subject + '"'
_json_content = _json_content + ', "body": {'
_json_content = _json_content + 	'"contentType": "' + IIF(EMPTY(_par_HTMLBody),'Text','HTML') + '"'
_json_content = _json_content + 	',"content": "' + IIF(EMPTY(_par_HTMLBody),_par_body,_par_HTMLBody) + CHR(13)+CHR(10) + '"}'
_json_content = _json_content + ', "toRecipients": ['
_nr_indirizzi = OCCURS(";",_par_to) + 1
FOR I = 1 TO _nr_indirizzi 
	_indirizzo_iesimo = ALLTRIM(STR_EXTRACT(_par_to,";",I))
	IF !EMPTY(_indirizzo_iesimo)
		_json_content = _json_content + IIF(I=1,'',',') + '{"emailAddress": {"address": "' + _indirizzo_iesimo + '"}}'
	ENDIF
ENDFOR
_json_content = _json_content + ']'
IF !EMPTY(_par_cc)
	_json_content = _json_content + ', "ccRecipients": ['
	_nr_indirizzi = OCCURS(";",_par_cc) + 1
	FOR I = 1 TO _nr_indirizzi 
		_indirizzo_iesimo = ALLTRIM(STR_EXTRACT(_par_cc,";",I))
		IF !EMPTY(_indirizzo_iesimo)
			_json_content = _json_content + IIF(I=1,'',',') + '{"emailAddress": {"address": "' + _indirizzo_iesimo + '"}}'
		ENDIF
	ENDFOR
	_json_content = _json_content + ']'
ENDIF
IF !EMPTY(_par_ccn)
	_json_content = _json_content + ', "bccRecipients": ['
	_nr_indirizzi = OCCURS(";",_par_ccn) + 1
	FOR I = 1 TO _nr_indirizzi 
		_indirizzo_iesimo = ALLTRIM(STR_EXTRACT(_par_ccn,";",I))
		IF !EMPTY(_indirizzo_iesimo)
			_json_content = _json_content + IIF(I=1,'',',') + '{"emailAddress": {"address": "' + _indirizzo_iesimo + '"}}'
		ENDIF
	ENDFOR
	_json_content = _json_content + ']'
ENDIF
_json_content = _json_content + ', "from": {"emailAddress": {"address": "' + ALLTRIM(_par_from) + '"}}'

IF !EMPTY(_par_attach)
	_json_content = _json_content + ', "attachments": ['
	_nr_allegati = OCCURS(";",_par_attach) + 1
	FOR I = 1 TO _nr_allegati
		_allegato_iesimo = ALLTRIM(STR_EXTRACT(_par_attach,";",I))
		IF !EMPTY(_allegato_iesimo) AND FILE(_allegato_iesimo,1)
			_json_content = _json_content + IIF(I=1,'',',') + '{'
			_json_content = _json_content + '"@odata.type": "#microsoft.graph.fileAttachment"'
			_json_content = _json_content + ',"name": "' + JUSTFNAME(_allegato_iesimo) + '"'
			*_json_content = _json_content + ',"contentType": "application/pdf"'
			_json_content = _json_content + ',"contentType": "' + ALLTRIM(CERCA_CAMPO_PARA("MIME"+JUSTEXT(_allegato_iesimo),"LIBERA")) + '"'
			_json_content = _json_content + ',"contentBytes": "' + STRCONV(FILETOSTR(_allegato_iesimo),13) + '"'
			_json_content = _json_content + '}'
		ENDIF
	ENDFOR
	_json_content = _json_content + ']'
ENDIF
_json_content = _json_content + '}}'


_HTTP_request = ALLTRIM(STRTRAN(_par_MGEMLURI,"$fromEmail",_par_from))

*!*	TRY
*!*		loRequest = Createobject('MsXml2.XmlHttp')
*!*		loRequest.Open("POST",_HTTP_request,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/json')
*!*		loRequest.SetRequestHeader('Authorization','Bearer ' + _access_token)
*!*		loRequest.Send(_json_content)
*!*	CATCH TO oException
*!*		loRequest = Createobject('MsXml2.XmlHttp.6.0')
*!*		loRequest.Open("POST",_HTTP_request,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/json')
*!*		loRequest.SetRequestHeader('Authorization','Bearer ' + _access_token)
*!*		loRequest.Send(_json_content)
*!*	FINALLY
*!*		V_BODY = ""
*!*		IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*			IF TYPE("loRequest.ResponseBody") == 'Q'
*!*				V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*			ENDIF
*!*			IF TYPE("loRequest.ResponseBody") == 'C'
*!*				V_BODY = loRequest.ResponseBody
*!*			ENDIF
*!*		ENDIF
*!*	ENDTRY

**=> ERASMO - INIZIO 29/04/2025
TRY
	
	loRequest = Createobject('MsXml2.XmlHttp')
	loRequest.Open("POST",_HTTP_request,.F.)
	loRequest.SetRequestHeader('Content-Type','application/json')
	loRequest.SetRequestHeader('Authorization','Bearer ' + _access_token)
	loRequest.Send(_json_content)
	
CATCH TO oException

	TRY
		
		loRequest = Createobject('MsXml2.XmlHttp.6.0')
		loRequest.Open("POST",_HTTP_request,.F.)
		loRequest.SetRequestHeader('Content-Type','application/json')
		loRequest.SetRequestHeader('Authorization','Bearer ' + _access_token)
		loRequest.Send(_json_content)
		
	CATCH TO oException2
		
		oException2.UserValue = "Nested CATCH message: Unable to handle"
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[Nested Catch! (Unhandled: Throw oException2 Object Up) ]"
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[ Inner Exception Object: ]"
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  Error: ]" + STR(oException2.ErrorNo)
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  LineNo: ]" + STR(oException2.LineNo)
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  Message: ]" + oException2.Message
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  Procedure: ]" + oException2.Procedure
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  Details: ]" + oException2.Details
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  StackLevel: ]" + STR(oException2.StackLevel) 
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  LineContents: ]" + oException2.LineContents
		_rit = IIF(!EMPTY(_rit),CHR(13),"") + "[  UserValue: ]" + oException2.UserValue

		THROW oException2
      
	FINALLY
	
		V_BODY = ""
		IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
			IF TYPE("loRequest.ResponseBody") == 'Q'
				V_BODY = STRCONV(loRequest.ResponseBody,11)
			ENDIF
			IF TYPE("loRequest.ResponseBody") == 'C'
				V_BODY = loRequest.ResponseBody
			ENDIF
		ENDIF
		
	ENDTRY
	
FINALLY
	
	V_BODY = ""
	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
		IF TYPE("loRequest.ResponseBody") == 'Q'
			V_BODY = STRCONV(loRequest.ResponseBody,11)
		ENDIF
		IF TYPE("loRequest.ResponseBody") == 'C'
			V_BODY = loRequest.ResponseBody
		ENDIF
	ENDIF
	
ENDTRY
**=> ERASMO - FINE 29/04/2025

_rit = ""
IF !EMPTY(V_BODY)
	_cJsonFixUnicode = V_BODY
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00e0','à')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00e1','á')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00e8','è')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00e9','é')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00ec','ì')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00ed','í')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00f2','ò')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00f3','ó')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00f9','ù')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00fa','ú')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00c0','À')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00c1','Á')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00c8','È')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00c9','É')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00cc','Ì')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00cd','Í')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00d2','Ò')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00d3','Ó')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00d9','Ù')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00da','Ú')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00f1','ñ')
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00d1','Ñ')
	_rit = _cJsonFixUnicode
ELSE
	_rit = ALLTRIM(STR(loRequest.status,10,0))
ENDIF

cloRequestStatusText = ALLTRIM(loRequest.statustext)

RELEASE loRequest

_cJson = _rit
IF EMPTY(_cJson)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione file Json in corso..." NOWAIT

IF ALLTRIM(_cJson) == "202"
	WAIT WINDOWS SUBSTR("Email inviata con successo",1,254) TIMEOUT 3
	_sent = .T.
	_response = ""
ELSE
	RELEASE obj_json
	obj_json = json_decode(_cJson)

	*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
	IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
		_cProperty = "OBJ_JSON._error._message"
		IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
			_response = ALLTRIM(&_cProperty)
		ELSE
			_response = ALLTRIM(cloRequestStatusText)
		ENDIF
		WAIT WINDOWS SUBSTR("Risposta da '"+_HTTP_request+"'" + REPLICATE(CHR(13),2) + _response,1,254) TIMEOUT 3
		RELEASE obj_json
		_sent = .F.
		RETURN .F.
	ENDIF
ENDIF


RETURN .T.


