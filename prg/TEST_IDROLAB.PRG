
_USERNAME = STRTRAN("info@mascheronilegnano.it","@","%40")
_PASSWORD = "eureca2008"
_DOMINIO = "ws.eureca2008.net"

*!*	*** LISTA MARCHE
*!*	lcUrl = "http://"+_USERNAME+":"+_PASSWORD+"@"+_DOMINIO+"/listamarche.xml"
*!*	loRequest = Createobject('MsXml2.XmlHttp')
*!*	loRequest.Open("GET",lcUrl,.F.)
*!*	loRequest.Send()
*!*	V_BODY = STRCONV(loRequest.ResponseBody,11)
*!*	RELEASE loRequest

*!*	IF '<errore id="404">' $ V_BODY
*!*		WAIT CLEAR
*!*		MESSAGEBOX("Nessuna marca trovata su DataBase Idrolab",16,"Attenzione")
*!*		RETURN .F.
*!*	ENDIF

*!*	_RECCOUNT = XMLTOCURSOR(V_BODY,"LISTA_MARCHE",0)
*!*	IF _RECCOUNT <= 0
*!*		MESSAGEBOX("Nessuna marca trovata su DataBase Idrolab",16,"Attenzione")
*!*		RETURN .F.
*!*	ENDIF
*!*	SELECT LISTA_MARCHE
*!*	INDEX ON ALLTRIM(MAR_CODICE) TAG I_CODI

*!*	EXPORT TO "D:\Erasmo project\Varie\Documenti Mascheroni\Lista_marche_Idrolab_tmp.xls" TYPE XL5

*SET STEP ON
*** LISTINO FAR RUBINETTERIE
*!*	lcUrl = "http://"+_USERNAME+":"+_PASSWORD+"@"+_DOMINIO+"/listino/RFR.xml"
*!*	_CLIPTEXT=lcUrl 

*!*	_RECCOUNT = XMLTOCURSOR("C:\Users\Erasmo\Downloads\RFR.xml\RFR.xml","LISTINO",512)
*!*	IF _RECCOUNT <= 0
*!*		MESSAGEBOX("Nessun listino trovato su DataBase Idrolab",16,"Attenzione")
*!*		RETURN .F.
*!*	ENDIF
*!*	SELECT LISTINO
*!*	INDEX ON ALLTRIM(art_codiceproduttor) TAG I_CODI
*!*	SET ORDER TO I_CODI
*!*	GO TOP

*!*	EXPORT TO "D:\Erasmo project\Varie\Documenti Mascheroni\Listino_RFR_Idrolab.xls" TYPE XL5


*SET STEP ON
*** LISTINO BWT
*!*	lcUrl = "http://"+_USERNAME+":"+_PASSWORD+"@"+_DOMINIO+"/listino/BWT.xml"
*!*	_CLIPTEXT=lcUrl 

*!*	_RECCOUNT = XMLTOCURSOR("C:\Users\Erasmo\Downloads\BWT.xml\BWT.xml","LISTINO",512)
*!*	IF _RECCOUNT <= 0
*!*		MESSAGEBOX("Nessun listino trovato su DataBase Idrolab",16,"Attenzione")
*!*		RETURN .F.
*!*	ENDIF
*!*	SELECT LISTINO
*!*	INDEX ON ALLTRIM(art_codiceproduttor) TAG I_CODI
*!*	SET ORDER TO I_CODI
*!*	GO TOP

*!*	EXPORT TO "D:\Erasmo project\Varie\Documenti Mascheroni\Listino_BWT_Idrolab.xls" TYPE XL5



*SET STEP ON
*** LISTINO BWT
lcUrl = "http://"+_USERNAME+":"+_PASSWORD+"@"+_DOMINIO+"/listino/CIL.xml"
_CLIPTEXT=lcUrl 

*!*	_RECCOUNT = XMLTOCURSOR("C:\Users\Erasmo\Downloads\CIL.xml\CIL.xml","LISTINO",512)
*!*	IF _RECCOUNT <= 0
*!*		MESSAGEBOX("Nessun listino trovato su DataBase Idrolab",16,"Attenzione")
*!*		RETURN .F.
*!*	ENDIF
*!*	SELECT LISTINO
*!*	INDEX ON ALLTRIM(art_codiceproduttor) TAG I_CODI
*!*	SET ORDER TO I_CODI
*!*	GO TOP

*!*	EXPORT TO "D:\Erasmo project\Varie\Documenti Mascheroni\Listino_CIL_Idrolab.xls" TYPE XL5



*!*	SET STEP ON
*!*	*** URL PER RICERCA ARTICOLO
*!*	_NEW_CODART = '10135'
*!*	_marca = 'BWT'
*!*	lcUrl = "http://"+_USERNAME+":"+_PASSWORD+"@"+_DOMINIO+"/riccodartporz/"+_marca+"/"+_NEW_CODART+".xml"

MESSAGEBOX("FINE")
