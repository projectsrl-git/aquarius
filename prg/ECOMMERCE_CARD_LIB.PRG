
FUNCTION ECOMMREST_POST

LPARAMETERS _par_HTTP_request,_par_auth_key,_par_json_content

LOCAL _rit
_rit = ""

IF !IsInternetConnected()
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	RETURN _rit
ENDIF

IF PCOUNT() >= 3
ELSE
	_par_json_content = ""
ENDIF

lcUrl = _par_HTTP_request
V_BODY = ""
*loRequest = Createobject('MsXml2.XmlHttp')
loRequest = Createobject('MsXml2.XmlHttp.6.0')  && ERASMO - 09/07/2024
loRequest.Open("POST",lcUrl,.F.)
loRequest.SetRequestHeader('Authkey',_par_auth_key)
IF !EMPTY(_par_json_content)
	loRequest.SetRequestHeader('Content-Type','application/json')
	loRequest.Send(_par_json_content)
ELSE
	loRequest.Send()
ENDIF
*!*	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
*!*		IF TYPE("loRequest.ResponseBody") == 'Q'
*!*			V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*		ENDIF
*!*		IF TYPE("loRequest.ResponseBody") == 'C'
*!*			V_BODY = loRequest.ResponseBody
*!*		ENDIF
*!*	ENDIF
IF TYPE("loRequest.ResponseText") <> 'U' AND TYPE("loRequest.ResponseText") <> 'O'
	IF TYPE("loRequest.ResponseText") == 'Q'
		V_BODY = STRCONV(loRequest.ResponseText,11)
	ENDIF
	IF TYPE("loRequest.ResponseText") == 'C'
		V_BODY = loRequest.ResponseText
	ENDIF
ENDIF
IF EMPTY(V_BODY)
	IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
		IF TYPE("loRequest.ResponseBody") == 'Q'
			V_BODY = STRCONV(loRequest.ResponseBody,11)
		ENDIF
		IF TYPE("loRequest.ResponseBody") == 'C'
			V_BODY = loRequest.ResponseBody
		ENDIF
	ENDIF
ENDIF

IF !EMPTY(V_BODY) AND ALLTRIM(STR(loRequest.status,10,0)) == "200"
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
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00b0','°')  && ERASMO - 19/07/2022
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u2019','’')  && ERASMO - 28/05/2024
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u2013','–')  && ERASMO - 28/06/2024
	_cJsonFixUnicode = StrTran(_cJsonFixUnicode,'\u00a0','–')  && ERASMO - 17/12/2024
	_rit = _cJsonFixUnicode
ELSE
	_rit = "KO: " + ALLTRIM(STR(loRequest.status,10,0)) + " " + ALLTRIM(loRequest.statustext)
ENDIF

RELEASE loRequest

RETURN _rit

ENDFUNC


***************************************************************************
PROCEDURE EC_WRITE_LOG
***************************************************************************
LPARAMETERS _par_codsys,_par_procedura,_par_esito,_par_messaggio

IF PCOUNT() >= 4
ELSE
	RETURN
ENDIF

LOCAL sws_ec

sws_ec=SELECT()

*** SCRITTURA RECORD TABELLA LOG_ECOMMERCE
cSql = "select * from LOG_ECOMMERCE where 1=0"
IF !ExecRW(cSql,"LOG_ECOMMERCE","R")
   return(.f.)
ENDIF
SELECT LOG_ECOMMERCE
APPEND BLANK
REPLACE CODSYS WITH _par_codsys
REPLACE PROCEDURA WITH _par_procedura
REPLACE DATA WITH RIBALTA2(DTOC(DATE()))
REPLACE ORA WITH TIME()
REPLACE CODOPE WITH ALLTRIM(PUB_CODOPE)
REPLACE NOMOPE WITH ALLTRIM(PUB_NOMOPE)
REPLACE ESITO WITH _par_esito
REPLACE MESSAGGIO WITH _par_messaggio
IF !ExecRW(cSql,"LOG_ECOMMERCE","W")
   return(.f.)
ENDIF

SELECT(sws_ec)

RETURN
