
*********************************************************************************************
FUNCTION BLUENEXTREST_POST_LOGIN
*********************************************************************************************
LPARAMETERS _par_HTTP_request,_par_username,_par_password,_par_paragg_1,_par_paragg_2

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	RETURN _rit
ENDIF

IF PCOUNT() >= 1
ELSE
	RETURN _rit
ENDIF

IF PCOUNT() >= 2
ELSE
	_par_username = ""
ENDIF

IF PCOUNT() >= 3
ELSE
	_par_password = ""
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

IF !EMPTY(_par_username) AND !EMPTY(_par_password)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + "grant_type=password"+"&username="+_par_username+"&password="+_par_password
ENDIF
IF !EMPTY(_par_paragg_1)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_1
ENDIF
IF !EMPTY(_par_paragg_2)
	lcUrl = lcUrl + IIF(EMPTY(lcUrl),"","&") + _par_paragg_2
ENDIF

lcUrl = _par_HTTP_request + IIF(!EMPTY(lcUrl),"?"+lcUrl,"")

V_BODY = ""
loRequest = Createobject('MsXml2.XmlHttp')
*loRequest = Createobject('MSXML2.ServerXMLHTTP')
loRequest.Open("POST",lcUrl,.F.)
*loRequest.SetRequestHeader('Content-Type','application/x-www-form-urlencoded')
loRequest.Send()
IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
	IF TYPE("loRequest.ResponseBody") == 'Q'
		V_BODY = STRCONV(loRequest.ResponseBody,11)
	ENDIF
	IF TYPE("loRequest.ResponseBody") == 'C'
		V_BODY = loRequest.ResponseBody
	ENDIF
ENDIF

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

RETURN _rit

ENDFUNC


*********************************************************************************************
FUNCTION BLUENEXTREST_POST_REQUEST
*********************************************************************************************
LPARAMETERS _par_HTTP_request,_par_access_token,_par_json_content,_par_paragg_1,_par_paragg_2

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
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
loRequest = Createobject('MsXml2.XmlHttp')
loRequest.Open("POST",lcUrl,.F.)
loRequest.SetRequestHeader('Content-Type','application/json')
loRequest.SetRequestHeader('Authorization','Bearer ' + _par_access_token)
loRequest.Send(_par_json_content)
IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
	IF TYPE("loRequest.ResponseBody") == 'Q'
		V_BODY = STRCONV(loRequest.ResponseBody,11)
	ENDIF
	IF TYPE("loRequest.ResponseBody") == 'C'
		V_BODY = loRequest.ResponseBody
	ENDIF
ENDIF

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

RETURN _rit

ENDFUNC


