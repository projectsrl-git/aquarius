
FUNCTION WOOCOMMREST_GET

LPARAMETERS _par_username,_par_password,_par_consumer_key,_par_consumer_secret,_par_nomesito,_par_HTTP_request,_par_paragg_1,_par_paragg_2

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	RETURN _rit
ENDIF

IF PCOUNT() >= 6
ELSE
	RETURN _rit
ENDIF

IF PCOUNT() >= 7
ELSE
	_par_paragg_1 = ""
ENDIF

IF PCOUNT() >= 8
ELSE
	_par_paragg_2 = ""
ENDIF

lcUrl = _par_nomesito+_par_HTTP_request+"?consumer_key="+_par_consumer_key+"&consumer_secret="+_par_consumer_secret
IF !EMPTY(_par_paragg_1)
	lcUrl = lcUrl + "&" + _par_paragg_1
ENDIF
IF !EMPTY(_par_paragg_2)
	lcUrl = lcUrl + "&" + _par_paragg_2
ENDIF

loRequest = Createobject('MsXml2.XmlHttp')
loRequest.Open("GET",lcUrl,.F.)
loRequest.Send()
V_BODY = STRCONV(loRequest.ResponseBody,11)
RELEASE loRequest

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
ENDIF

RETURN _rit

ENDFUNC



FUNCTION WOOCOMMREST_POST

LPARAMETERS _par_username,_par_password,_par_consumer_key,_par_consumer_secret,_par_nomesito,_par_HTTP_request,_par_json_content

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	RETURN _rit
ENDIF

IF PCOUNT() >= 6
ELSE
	RETURN _rit
ENDIF

IF PCOUNT() >= 7
ELSE
	_par_json_content = ""
ENDIF

lcUrl = _par_nomesito+_par_HTTP_request+"?consumer_key="+_par_consumer_key+"&consumer_secret="+_par_consumer_secret

loRequest = Createobject('MsXml2.XmlHttp')
loRequest.Open("POST",lcUrl,.F.)
loRequest.SetRequestHeader('Content-Type','application/json')
loRequest.Send(_par_json_content)
V_BODY = STRCONV(loRequest.ResponseBody,11)
RELEASE loRequest

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
ENDIF

RETURN _rit

ENDFUNC


FUNCTION WOOCOMMREST_PUT

LPARAMETERS _par_username,_par_password,_par_consumer_key,_par_consumer_secret,_par_nomesito,_par_HTTP_request,_par_json_content

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	RETURN _rit
ENDIF

IF PCOUNT() >= 6
ELSE
	RETURN _rit
ENDIF

IF PCOUNT() >= 7
ELSE
	_par_json_content = ""
ENDIF
SET STEP ON
lcUrl = _par_nomesito+_par_HTTP_request+"?consumer_key="+_par_consumer_key+"&consumer_secret="+_par_consumer_secret

loRequest = Createobject('MsXml2.XmlHttp')
loRequest.Open("PUT",lcUrl,.F.)
loRequest.SetRequestHeader('Content-Type','application/json')
loRequest.Send(_par_json_content)
V_BODY = STRCONV(loRequest.ResponseBody,11)
RELEASE loRequest

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
ENDIF

RETURN _rit

ENDFUNC


