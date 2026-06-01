LOCAL loRequest, lcUrl, lcFilename,V_GIORNO,V_MESE,V_ANNO,V_MESSAGGIO_ERRORE_NO_CAMBIO,V_LEN_NO_CAMBIO

V_MESSAGGIO_ERRORE_NO_CAMBIO = "ATTENZIONE! Non ci sono valori di cambio per i dati inseriti"
V_LEN_NO_CAMBIO = 61

V_GIORNO="27"
V_MESE ="12" 
V_ANNO ="2013"
V_DATA_AAAAMMGG=V_ANNO+V_MESE+V_GIORNO

lcUrl = "http://cambi.bancaditalia.it/cambi/QueryOneDateAllCur?lang=ita&rate=0&initDay="+V_GIORNO+"&initMonth="+V_MESE+"&initYear="+V_ANNO+"&refCur=euro&R1=csv"
lcFilename = "d:\CAMBI_"+V_DATA_AAAAMMGG+".TXT"

loRequest = Createobject('MsXml2.XmlHttp')
loRequest.Open("GET",lcUrl,.F.)
loRequest.Send()


IF LEN(loRequest.ResponseBody)<=V_LEN_NO_CAMBIO 
	WAIT WINDOW (V_MESSAGGIO_ERRORE_NO_CAMBIO )
	RETURN
ENDIF



STRTOFILE(loRequest.ResponseBody,lcFilename)