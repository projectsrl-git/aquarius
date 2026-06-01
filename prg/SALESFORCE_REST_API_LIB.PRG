
FUNCTION SALESFORCEREST_GET

LPARAMETERS _par_HTTP_request,_par_access_token,_par_paragg_1,_par_paragg_2

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	*MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione",5)  && ERASMO - 27/03/2025
	RETURN _rit
ENDIF

IF PCOUNT() >= 2
ELSE
	RETURN _rit
ENDIF

IF PCOUNT() >= 3
ELSE
	_par_paragg_1 = ""
ENDIF

IF PCOUNT() >= 4
ELSE
	_par_paragg_2 = ""
ENDIF

lcUrl = ""

IF !EMPTY(_par_paragg_1)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_1
ENDIF
IF !EMPTY(_par_paragg_2)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_2
ENDIF

lcUrl = _par_HTTP_request + IIF(!EMPTY(lcUrl),"?"+lcUrl,"")

V_BODY = ""
*!*	*loRequest = Createobject('MsXml2.XmlHttp')
*!*	loRequest = Createobject('MsXml2.XmlHttp.6.0')  && ERASMO - 09/07/2024
*!*	*loRequest = Createobject('MSXML2.ServerXMLHTTP')
*!*	loRequest.Open("GET",lcUrl,.F.)
*!*	loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*	loRequest.Send()
*!*	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*		IF TYPE("loRequest.ResponseBody") == 'Q'
*!*			V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*		ENDIF
*!*		IF TYPE("loRequest.ResponseBody") == 'C'
*!*			V_BODY = loRequest.ResponseBody
*!*		ENDIF
*!*	ENDIF

*!*	**=> ERASMO - INIZIO 24/07/2024
*!*	TRY
*!*		loRequest = Createobject('MsXml2.XmlHttp')
*!*		loRequest.Open("GET",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*		loRequest.Send()
*!*	CATCH TO oException
*!*		loRequest = Createobject('MsXml2.XmlHttp.6.0')
*!*		loRequest.Open("GET",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*		loRequest.Send()
*!*	FINALLY
*!*		IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*			IF TYPE("loRequest.ResponseBody") == 'Q'
*!*				V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*			ENDIF
*!*			IF TYPE("loRequest.ResponseBody") == 'C'
*!*				V_BODY = loRequest.ResponseBody
*!*			ENDIF
*!*		ENDIF
*!*	ENDTRY
*!*	**=> ERASMO - FINE 24/07/2024

**=> ERASMO - INIZIO 24/04/2025
TRY
	
	loRequest = Createobject('MsXml2.XmlHttp')
	loRequest.Open("GET",lcUrl,.F.)
	loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
	loRequest.Send()
	
CATCH TO oException

	TRY
		
		loRequest = Createobject('MsXml2.XmlHttp.6.0')
		loRequest.Open("GET",lcUrl,.F.)
		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
		loRequest.Send()
		
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
	
	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
		IF TYPE("loRequest.ResponseBody") == 'Q'
			V_BODY = STRCONV(loRequest.ResponseBody,11)
		ENDIF
		IF TYPE("loRequest.ResponseBody") == 'C'
			V_BODY = loRequest.ResponseBody
		ENDIF
	ENDIF
	
ENDTRY
**=> ERASMO - FINE 24/04/2025

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
	*_rit = ALLTRIM(STR(loRequest.status,10,0))	
	**=> ERASMO - INIZIO 24/04/2025
	IF TYPE("STR(loRequest.status,10,0)") == "C"
		IF !EMPTY(STR(loRequest.status,10,0))
			_rit = ALLTRIM(STR(loRequest.status,10,0))
		ENDIF
	ENDIF
	**=> ERASMO - FINE 24/04/2025
ENDIF

RELEASE loRequest

RETURN _rit

ENDFUNC



FUNCTION SALESFORCEREST_POST

LPARAMETERS _par_HTTP_request,_par_paragg_1,_par_paragg_2,_par_username,_par_password,_par_consumer_key,_par_consumer_secret

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	*MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione",5)  && ERASMO - 27/03/2025
	RETURN _rit
ENDIF

IF PCOUNT() >= 1
ELSE
	RETURN _rit
ENDIF

IF PCOUNT() >= 2
ELSE
	_par_paragg_1 = ""
ENDIF

IF PCOUNT() >= 3
ELSE
	_par_paragg_2 = ""
ENDIF

IF PCOUNT() >= 4
ELSE
	_par_username = ""
ENDIF

IF PCOUNT() >= 5
ELSE
	_par_password = ""
ENDIF

IF PCOUNT() >= 6
ELSE
	_par_consumer_key = ""
ENDIF

IF PCOUNT() >= 7
ELSE
	_par_consumer_secret = ""
ENDIF

lcUrl = ""

IF !EMPTY(_par_paragg_1)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_1
ENDIF
IF !EMPTY(_par_paragg_2)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_2
ENDIF
IF !EMPTY(_par_consumer_key) AND !EMPTY(_par_consumer_secret) AND !EMPTY(_par_username) AND !EMPTY(_par_password)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + "grant_type=password"+"&client_id="+_par_consumer_key+"&client_secret="+_par_consumer_secret+"&username="+_par_username+"&password="+_par_password
ENDIF

lcUrl = _par_HTTP_request + IIF(!EMPTY(lcUrl),"?"+lcUrl,"")

V_BODY = ""
*!*	*loRequest = Createobject('MsXml2.XmlHttp')
*!*	loRequest = Createobject('MsXml2.XmlHttp.6.0')  && ERASMO - 09/07/2024
*!*	*loRequest = Createobject('MSXML2.ServerXMLHTTP')
*!*	loRequest.Open("POST",lcUrl,.F.)
*!*	loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
*!*	loRequest.Send()
*!*	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*		IF TYPE("loRequest.ResponseBody") == 'Q'
*!*			V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*		ENDIF
*!*		IF TYPE("loRequest.ResponseBody") == 'C'
*!*			V_BODY = loRequest.ResponseBody
*!*		ENDIF
*!*	ENDIF

*!*	**=> ERASMO - INIZIO 24/07/2024
*!*	TRY
*!*		loRequest = Createobject('MsXml2.XmlHttp')
*!*		loRequest.Open("POST",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
*!*		loRequest.Send()
*!*	CATCH TO oException
*!*		loRequest = Createobject('MsXml2.XmlHttp.6.0')
*!*		loRequest.Open("POST",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
*!*		loRequest.Send()
*!*	FINALLY
*!*		IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*			IF TYPE("loRequest.ResponseBody") == 'Q'
*!*				V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*			ENDIF
*!*			IF TYPE("loRequest.ResponseBody") == 'C'
*!*				V_BODY = loRequest.ResponseBody
*!*			ENDIF
*!*		ENDIF
*!*	ENDTRY
*!*	**=> ERASMO - FINE 24/07/2024

**=> ERASMO - INIZIO 24/04/2025
TRY
	
	loRequest = Createobject('MSXML2.ServerXMLHTTP')
	loRequest.Open("POST",lcUrl,.F.)
	loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
	loRequest.Send()
	
CATCH TO oException

	TRY
		
		loRequest = Createobject('MSXML2.ServerXMLHTTP.6.0')
		loRequest.Open("POST",lcUrl,.F.)
		loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
		loRequest.Send()
		
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
	
	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
		IF TYPE("loRequest.ResponseBody") == 'Q'
			V_BODY = STRCONV(loRequest.ResponseBody,11)
		ENDIF
		IF TYPE("loRequest.ResponseBody") == 'C'
			V_BODY = loRequest.ResponseBody
		ENDIF
	ENDIF
	
ENDTRY
**=> ERASMO - FINE 24/04/2025

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
	*_rit = ALLTRIM(STR(loRequest.status,10,0))	
	**=> ERASMO - INIZIO 24/04/2025
	IF TYPE("STR(loRequest.status,10,0)") == "C"
		IF !EMPTY(STR(loRequest.status,10,0))
			_rit = ALLTRIM(STR(loRequest.status,10,0))
		ENDIF
	ENDIF
	**=> ERASMO - FINE 24/04/2025
ENDIF

RELEASE loRequest

RETURN _rit

ENDFUNC



FUNCTION SALESFORCEREST_PATCH

LPARAMETERS _par_HTTP_request,_par_access_token,_par_json_content,_par_paragg_1,_par_paragg_2

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	*MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione",5)  && ERASMO - 27/03/2025
	RETURN _rit
ENDIF

IF PCOUNT() >= 3
ELSE
	RETURN _rit
ENDIF

IF PCOUNT() >= 4
ELSE
	_par_paragg_1 = ""
ENDIF

IF PCOUNT() >= 5
ELSE
	_par_paragg_2 = ""
ENDIF

lcUrl = ""

IF !EMPTY(_par_paragg_1)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_1
ENDIF
IF !EMPTY(_par_paragg_2)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_2
ENDIF

lcUrl = _par_HTTP_request + IIF(!EMPTY(lcUrl),"?"+lcUrl,"")

V_BODY = ""
*!*	*loRequest = Createobject('MsXml2.XmlHttp')
*!*	loRequest = Createobject('MsXml2.XmlHttp.6.0')  && ERASMO - 09/07/2024
*!*	loRequest.Open("PATCH",lcUrl,.F.)
*!*	loRequest.SetRequestHeader('Content-Type','application/json')
*!*	loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*	loRequest.Send(_par_json_content)
*!*	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*		IF TYPE("loRequest.ResponseBody") == 'Q'
*!*			V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*		ENDIF
*!*		IF TYPE("loRequest.ResponseBody") == 'C'
*!*			V_BODY = loRequest.ResponseBody
*!*		ENDIF
*!*	ENDIF

*!*	**=> ERASMO - INIZIO 24/07/2024
*!*	TRY
*!*		loRequest = Createobject('MsXml2.XmlHttp')
*!*		loRequest.Open("PATCH",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/json')
*!*		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*		loRequest.Send(_par_json_content)
*!*	CATCH TO oException
*!*		loRequest = Createobject('MsXml2.XmlHttp.6.0')
*!*		loRequest.Open("PATCH",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/json')
*!*		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*		loRequest.Send(_par_json_content)
*!*	FINALLY
*!*		IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*			IF TYPE("loRequest.ResponseBody") == 'Q'
*!*				V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*			ENDIF
*!*			IF TYPE("loRequest.ResponseBody") == 'C'
*!*				V_BODY = loRequest.ResponseBody
*!*			ENDIF
*!*		ENDIF
*!*	ENDTRY
*!*	**=> ERASMO - FINE 24/07/2024

**=> ERASMO - INIZIO 24/04/2025
TRY
	
	loRequest = Createobject('MsXml2.XmlHttp')
	loRequest.Open("PATCH",lcUrl,.F.)
	loRequest.SetRequestHeader('Content-Type','application/json')
	loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
	loRequest.Send(_par_json_content)
	
CATCH TO oException

	TRY
		
		loRequest = Createobject('MsXml2.XmlHttp.6.0')
		loRequest.Open("PATCH",lcUrl,.F.)
		loRequest.SetRequestHeader('Content-Type','application/json')
		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
		loRequest.Send(_par_json_content)
		
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
	
	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
		IF TYPE("loRequest.ResponseBody") == 'Q'
			V_BODY = STRCONV(loRequest.ResponseBody,11)
		ENDIF
		IF TYPE("loRequest.ResponseBody") == 'C'
			V_BODY = loRequest.ResponseBody
		ENDIF
	ENDIF
	
ENDTRY
**=> ERASMO - FINE 24/04/2025

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
	*_rit = ALLTRIM(STR(loRequest.status,10,0))
	**=> ERASMO - INIZIO 24/04/2025
	IF TYPE("STR(loRequest.status,10,0)") == "C"
		IF !EMPTY(STR(loRequest.status,10,0))
			_rit = ALLTRIM(STR(loRequest.status,10,0))
		ENDIF
	ENDIF
	**=> ERASMO - FINE 24/04/2025
ENDIF

RELEASE loRequest

RETURN _rit

ENDFUNC


FUNCTION SALESFORCEREST_POST_INSERT

LPARAMETERS _par_HTTP_request,_par_access_token,_par_json_content,_par_paragg_1,_par_paragg_2

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	*MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione",5)  && ERASMO - 27/03/2025
	RETURN _rit
ENDIF

IF PCOUNT() >= 3
ELSE
	RETURN _rit
ENDIF

IF PCOUNT() >= 4
ELSE
	_par_paragg_1 = ""
ENDIF

IF PCOUNT() >= 5
ELSE
	_par_paragg_2 = ""
ENDIF

lcUrl = ""

IF !EMPTY(_par_paragg_1)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_1
ENDIF
IF !EMPTY(_par_paragg_2)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_2
ENDIF

lcUrl = _par_HTTP_request + IIF(!EMPTY(lcUrl),"?"+lcUrl,"")

V_BODY = ""
*!*	*loRequest = Createobject('MsXml2.XmlHttp')
*!*	loRequest = Createobject('MsXml2.XmlHttp.6.0')  && ERASMO - 09/07/2024
*!*	loRequest.Open("POST",lcUrl,.F.)
*!*	loRequest.SetRequestHeader('Content-Type','application/json')
*!*	loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*	loRequest.Send(_par_json_content)
*!*	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*		IF TYPE("loRequest.ResponseBody") == 'Q'
*!*			V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*		ENDIF
*!*		IF TYPE("loRequest.ResponseBody") == 'C'
*!*			V_BODY = loRequest.ResponseBody
*!*		ENDIF
*!*	ENDIF

*!*	**=> ERASMO - INIZIO 24/07/2024
*!*	TRY
*!*		loRequest = Createobject('MsXml2.XmlHttp')
*!*		loRequest.Open("POST",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/json')
*!*		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*		loRequest.Send(_par_json_content)
*!*	CATCH TO oException
*!*		loRequest = Createobject('MsXml2.XmlHttp.6.0')
*!*		loRequest.Open("POST",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/json')
*!*		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*		loRequest.Send(_par_json_content)
*!*	FINALLY
*!*		IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*			IF TYPE("loRequest.ResponseBody") == 'Q'
*!*				V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*			ENDIF
*!*			IF TYPE("loRequest.ResponseBody") == 'C'
*!*				V_BODY = loRequest.ResponseBody
*!*			ENDIF
*!*		ENDIF
*!*	ENDTRY
*!*	**=> ERASMO - FINE 24/07/2024

**=> ERASMO - INIZIO 24/04/2025
TRY
	
	loRequest = Createobject('MsXml2.XmlHttp')
	loRequest.Open("POST",lcUrl,.F.)
	loRequest.SetRequestHeader('Content-Type','application/json')
	loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
	loRequest.Send(_par_json_content)
	
CATCH TO oException

	TRY
		
		loRequest = Createobject('MsXml2.XmlHttp.6.0')
		loRequest.Open("POST",lcUrl,.F.)
		loRequest.SetRequestHeader('Content-Type','application/json')
		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
		loRequest.Send(_par_json_content)
		
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
	
	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
		IF TYPE("loRequest.ResponseBody") == 'Q'
			V_BODY = STRCONV(loRequest.ResponseBody,11)
		ENDIF
		IF TYPE("loRequest.ResponseBody") == 'C'
			V_BODY = loRequest.ResponseBody
		ENDIF
	ENDIF
	
ENDTRY
**=> ERASMO - FINE 24/04/2025

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
	*_rit = ALLTRIM(STR(loRequest.status,10,0))
	**=> ERASMO - INIZIO 24/04/2025
	IF TYPE("STR(loRequest.status,10,0)") == "C"
		IF !EMPTY(STR(loRequest.status,10,0))
			_rit = ALLTRIM(STR(loRequest.status,10,0))
		ENDIF
	ENDIF
	**=> ERASMO - FINE 24/04/2025
ENDIF

RELEASE loRequest

RETURN _rit

ENDFUNC



FUNCTION SALESFORCEREST_DELETE

LPARAMETERS _par_HTTP_request,_par_access_token,_par_paragg_1,_par_paragg_2

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	*MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione",5)  && ERASMO - 27/03/2025
	RETURN _rit
ENDIF

IF PCOUNT() >= 3
ELSE
	_par_paragg_1 = ""
ENDIF

IF PCOUNT() >= 4
ELSE
	_par_paragg_2 = ""
ENDIF

lcUrl = ""

IF !EMPTY(_par_paragg_1)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_1
ENDIF
IF !EMPTY(_par_paragg_2)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_2
ENDIF

lcUrl = _par_HTTP_request + IIF(!EMPTY(lcUrl),"?"+lcUrl,"")

V_BODY = ""
*!*	*loRequest = Createobject('MsXml2.XmlHttp')
*!*	loRequest = Createobject('MsXml2.XmlHttp.6.0')  && ERASMO - 09/07/2024
*!*	loRequest.Open("DELETE",lcUrl,.F.)
*!*	loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*	loRequest.Send()
*!*	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*		IF TYPE("loRequest.ResponseBody") == 'Q'
*!*			V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*		ENDIF
*!*		IF TYPE("loRequest.ResponseBody") == 'C'
*!*			V_BODY = loRequest.ResponseBody
*!*		ENDIF
*!*	ENDIF

*!*	**=> ERASMO - INIZIO 24/07/2024
*!*	TRY
*!*		loRequest = Createobject('MsXml2.XmlHttp')
*!*		loRequest.Open("DELETE",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*		loRequest.Send()
*!*	CATCH TO oException
*!*		loRequest = Createobject('MsXml2.XmlHttp.6.0')
*!*		loRequest.Open("DELETE",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
*!*		loRequest.Send()

*!*	FINALLY
*!*		IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*			IF TYPE("loRequest.ResponseBody") == 'Q'
*!*				V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*			ENDIF
*!*			IF TYPE("loRequest.ResponseBody") == 'C'
*!*				V_BODY = loRequest.ResponseBody
*!*			ENDIF
*!*		ENDIF
*!*	ENDTRY
*!*	**=> ERASMO - FINE 24/07/2024

**=> ERASMO - INIZIO 24/04/2025
TRY
	
	loRequest = Createobject('MsXml2.XmlHttp')
	loRequest.Open("DELETE",lcUrl,.F.)
	loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
	loRequest.Send()
	
CATCH TO oException

	TRY
		
		loRequest = Createobject('MsXml2.XmlHttp.6.0')
		loRequest.Open("DELETE",lcUrl,.F.)
		loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
		loRequest.Send()
		
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
	
	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
		IF TYPE("loRequest.ResponseBody") == 'Q'
			V_BODY = STRCONV(loRequest.ResponseBody,11)
		ENDIF
		IF TYPE("loRequest.ResponseBody") == 'C'
			V_BODY = loRequest.ResponseBody
		ENDIF
	ENDIF
	
ENDTRY
**=> ERASMO - FINE 24/04/2025

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
	*_rit = ALLTRIM(STR(loRequest.status,10,0))
	**=> ERASMO - INIZIO 24/04/2025
	IF TYPE("STR(loRequest.status,10,0)") == "C"
		IF !EMPTY(STR(loRequest.status,10,0))
			_rit = ALLTRIM(STR(loRequest.status,10,0))
		ENDIF
	ENDIF
	**=> ERASMO - FINE 24/04/2025
ENDIF

RELEASE loRequest

RETURN _rit

ENDFUNC


FUNCTION SALESFORCEREST_POST_LOGOUT

LPARAMETERS _par_HTTP_request,_par_paragg_1,_par_paragg_2,_par_username,_par_password,_par_consumer_key,_par_consumer_secret

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	*MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione",5)  && ERASMO - 27/03/2025
	RETURN _rit
ENDIF

IF PCOUNT() >= 1
ELSE
	RETURN _rit
ENDIF

IF PCOUNT() >= 2
ELSE
	_par_paragg_1 = ""
ENDIF

IF PCOUNT() >= 3
ELSE
	_par_paragg_2 = ""
ENDIF

IF PCOUNT() >= 4
ELSE
	_par_username = ""
ENDIF

IF PCOUNT() >= 5
ELSE
	_par_password = ""
ENDIF

IF PCOUNT() >= 6
ELSE
	_par_consumer_key = ""
ENDIF

IF PCOUNT() >= 7
ELSE
	_par_consumer_secret = ""
ENDIF

lcUrl = ""

IF !EMPTY(_par_paragg_1)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_1
ENDIF
IF !EMPTY(_par_paragg_2)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_2
ENDIF
IF !EMPTY(_par_consumer_key) AND !EMPTY(_par_consumer_secret) AND !EMPTY(_par_username) AND !EMPTY(_par_password)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + "grant_type=password"+"&client_id="+_par_consumer_key+"&client_secret="+_par_consumer_secret+"&username="+_par_username+"&password="+_par_password
ENDIF

lcUrl = _par_HTTP_request + IIF(!EMPTY(lcUrl),"?"+lcUrl,"")

V_BODY = ""
*!*	*loRequest = Createobject('MSXML2.ServerXMLHTTP')
*!*	loRequest = Createobject('MSXML2.ServerXMLHTTP.6.0')  && ERASMO - 09/07/2024
*!*	loRequest.Open("POST",lcUrl,.F.)
*!*	loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
*!*	loRequest.Send()
*!*	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*		IF TYPE("loRequest.ResponseBody") == 'Q'
*!*			V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*		ENDIF
*!*		IF TYPE("loRequest.ResponseBody") == 'C'
*!*			V_BODY = loRequest.ResponseBody
*!*		ENDIF
*!*	ENDIF

*!*	**=> ERASMO - INIZIO 24/07/2024
*!*	TRY
*!*		loRequest = Createobject('MSXML2.ServerXMLHTTP')
*!*		loRequest.Open("POST",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
*!*		loRequest.Send()
*!*	CATCH TO oException
*!*		loRequest = Createobject('MSXML2.ServerXMLHTTP.6.0')
*!*		loRequest.Open("POST",lcUrl,.F.)
*!*		loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
*!*		loRequest.Send()
*!*	FINALLY
*!*		IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*			IF TYPE("loRequest.ResponseBody") == 'Q'
*!*				V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*			ENDIF
*!*			IF TYPE("loRequest.ResponseBody") == 'C'
*!*				V_BODY = loRequest.ResponseBody
*!*			ENDIF
*!*		ENDIF
*!*	ENDTRY
*!*	**=> ERASMO - FINE 24/07/2024

**=> ERASMO - INIZIO 24/04/2025
TRY
	
	loRequest = Createobject('MSXML2.ServerXMLHTTP')
	loRequest.Open("POST",lcUrl,.F.)
	loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
	loRequest.Send()
	
CATCH TO oException

	TRY
		
		loRequest = Createobject('MSXML2.ServerXMLHTTP.6.0')
		loRequest.Open("POST",lcUrl,.F.)
		loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
		loRequest.Send()
		
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
	
	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
		IF TYPE("loRequest.ResponseBody") == 'Q'
			V_BODY = STRCONV(loRequest.ResponseBody,11)
		ENDIF
		IF TYPE("loRequest.ResponseBody") == 'C'
			V_BODY = loRequest.ResponseBody
		ENDIF
	ENDIF
	
ENDTRY
**=> ERASMO - FINE 24/04/2025

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
	*_rit = ALLTRIM(STR(loRequest.status,10,0))
	**=> ERASMO - INIZIO 24/04/2025
	IF TYPE("STR(loRequest.status,10,0)") == "C"
		IF !EMPTY(STR(loRequest.status,10,0))
			_rit = ALLTRIM(STR(loRequest.status,10,0))
		ENDIF
	ENDIF
	**=> ERASMO - FINE 24/04/2025
ENDIF

RELEASE loRequest

RETURN _rit

ENDFUNC


**=> ERASMO - INIZIO 12/03/2025
FUNCTION SALESFORCE_LOGIN

LPARAMETERS _par_HTTP_request,_par_username,_par_password,_par_consumer_key,_par_consumer_secret,_ref_access_token,_ref_instance_url

_cJson_login = ""
WAIT WINDOWS SUBSTR("Connessione per Login a '"+_par_HTTP_request+"' in corso...",1,254) NOWAIT

_cJson_login = SALESFORCEREST_POST(_par_HTTP_request,"","",_par_username,_par_password,_par_consumer_key,_par_consumer_secret)
IF EMPTY(_cJson_login)
	WAIT WINDOWS SUBSTR("Nessuna risposta da '"+_par_HTTP_request+"': verificare tutti i parametri e che sia disponibile una connessione internet",1,254) TIMEOUT 3
	RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione file Json in corso..." NOWAIT

obj_json = json_decode(_cJson_login)

*** MESSAGGIO DI ERRORE DEFINITO NEL JSON
IF TYPE("obj_json") <> 'U' AND TYPE("obj_json") = 'O' AND !ISNULL(obj_json)
	_cProperty = "OBJ_JSON._error_description"
	IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
		_message = ALLTRIM(&_cProperty)
		WAIT WINDOWS SUBSTR("Risposta da '"+_par_HTTP_request+"'" + REPLICATE(CHR(13),2) + _message,1,254) TIMEOUT 3
		RETURN .F.
	ENDIF
ENDIF

*** TOKEN E/O INSTANCE_URL NON RESTITUITI
_cProperty = "OBJ_JSON._access_token"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
	_ref_access_token = &_cProperty
ENDIF
IF EMPTY(_ref_access_token)
	WAIT WINDOWS "Parametro di ritorno 'access_token' non presente" TIMEOUT 3
	RETURN .F.
ENDIF
_cProperty = "OBJ_JSON._instance_url"
IF TYPE(_cProperty) <> 'U' AND TYPE(_cProperty) <> 'O' AND !ISNULL(&_cProperty)
	_ref_instance_url = &_cProperty
ENDIF
IF EMPTY(_ref_instance_url)
	WAIT WINDOWS "Parametro di ritorno 'instance_url' non presente" TIMEOUT 3
	RETURN .F.
ENDIF

RELEASE obj_json

RETURN .T.

ENDFUNC
**=> ERASMO - FINE 12/03/2025