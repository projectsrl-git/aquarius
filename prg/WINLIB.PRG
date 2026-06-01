*!*	##############################################################################################################

					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA DELLE FUNZIONI DI BASE                                  ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################

**************************************************************************
* Funzione - MSGBOX     Data: 28.10.94    Autore: PROJECT S.R.L.
**************************************************************************
FUNCTION MSGBOX
***************
PARAMETERS _STRG,_TITOLO,_TIPO
=messagebox(_STRG,16,_TITOLO)
RETURN(1)


**********************************************************************
* Funzione - VALID_DATA   Data: 27.08.94   Autore: Project
**********************************************************************
* Questa funzione permette di verificare l'esattezza di una data in
* formato stringa. Accetta un solo parametro di tipo carattere lungo
* 8, nel formato GG.MM.AA ritorna un valore logico .T. se data Ok .F.
* se data non corretta.
**********************************************************************
FUNCTION VALID_DATA
*******************
PARAMETERS X_DATA
*RETURN(CTOD(X_DATA)!= {  /  /  })
**=> ERASMO - INIZIO 10/02/2025
*** PER EVITARE FREQUENTI ERRORI DI BATTITURA TIPO "10/02/0025"
_RIT = CTOD(X_DATA)!= {  /  /  }
*IF _RIT = .T. AND CTOD(X_DATA) >= CTOD("01/01/1950")
IF _RIT = .T. AND CTOD(X_DATA) >= CTOD("01/01/1950") AND CTOD(X_DATA) <= CTOD("31/12/2999")  && ERASMO - 29/05/2025
ELSE
	_RIT = .F.
ENDIF

RETURN _RIT
**=> ERASMO - FINE 10/02/2025



**********************************************************************
* Funzione - OK_DATA   Data: 14.04.96   Autore: Project S.r.L.
**********************************************************************
*
* TRASFORMA DATA FORMATO GG.MM.AA IN FORMATO GG.MM.AAAA
* SE LA DATA E' ERRATA RITORNA AUTOMATICAMENTE LA DATA DI SISTEMA
*
* SINTASSI: DATA=OK_DATA(DATA)
* DATA= VARIABILE DA PASSARE CONTENENTE LA DATA DA CONTROLLARE
*
**********************************************************************
FUNCTION OK_DATA
*******************
PARA XDATA

FLAG_DATA = .T.
XGG       = VAL(SUBSTR(XDATA,1,2))
XMM       = VAL(SUBSTR(XDATA,4,2))
XAA1      = VAL(SUBSTR(XDATA,7,2))
XAA2      = VAL(SUBSTR(XDATA,9,2))
_LENAA    = LEN(ALLTRIM(SUBSTR(XDATA,7,4)))

IF _LENAA <> 4
   IF XAA2=0
*!*		  IF XAA1 > 80
*!*		     XAA2=XAA1
*!*	         XAA1=19
*!*		  ELSE
*!*	         XAA2=XAA1
*!*		     XAA1=20
*!*	      ENDIF
      **=> ERASMO - INIZIO 31/01/2024
      IF XAA1 > 0
         XAA2=XAA1
         XAA1=VAL(SUBSTR(DTOC(DATE()),7,2))
      ELSE
         IF TYPE("PUB_ANNO") = "C"
            IF LEN(ALLTRIM(PUB_ANNO)) = 4
               XAA1 = VAL(SUBSTR(PUB_ANNO,1,2))
               XAA2 = VAL(SUBSTR(PUB_ANNO,3,2))
            ELSE
               XAA1 = VAL(SUBSTR(DTOC(DATE()),7,2))
               XAA2 = VAL(SUBSTR(DTOC(DATE()),9,2))
            ENDIF
         ELSE
            XAA1 = VAL(SUBSTR(DTOC(DATE()),7,2))
            XAA2 = VAL(SUBSTR(DTOC(DATE()),9,2))
         ENDIF
      ENDIF
      **=> ERASMO - FINE 31/01/2024
   ENDIF
ENDIF 

BIS=((XAA2/4)=INT(XAA2/4))

IF XGG= 0  .OR. XMM = 0 .OR. XMM > 12
   FLAG_DATA = .F.
ENDIF

DO CASE
   CASE XMM = 2 .AND. BIS
        IF XGG > 29
           FLAG_DATA = .F.
        ENDIF
   CASE XMM = 2
        IF XGG > 28
           FLAG_DATA = .F.
        ENDIF
   CASE XMM = 11 .OR. XMM = 4 .OR. XMM = 6 .OR. XMM = 9
        IF XGG > 30
           FLAG_DATA = .F.
        ENDIF
   CASE XMM = 1 .OR. XMM = 3 .OR. XMM = 5 .OR. XMM = 7 .OR. XMM = 8 .OR. XMM = 10 .OR. XMM = 12
        IF XGG > 31
           FLAG_DATA = .F.
        ENDIF
ENDCASE

IF !FLAG_DATA
   XDATA = DTOC(DATE())
   XGG   = VAL(SUBSTR(XDATA,1,2))
   XMM   = VAL(SUBSTR(XDATA,4,2))
   XAA1  = VAL(SUBSTR(XDATA,7,2))
   XAA2  = VAL(SUBSTR(XDATA,9,2))
   IF XAA2=0
      IF XAA1 > 80
         XAA2=XAA1
         XAA1=19
      ELSE
         XAA2=XAA1
         XAA1=20
      ENDIF
   ENDIF
ENDIF

XSEPA = SUBSTR(XDATA,3,1)
XGG   = STRTRAN(STR(XGG,2)," ","0")
XMM   = STRTRAN(STR(XMM,2)," ","0")
XAA1  = STRTRAN(STR(XAA1,2)," ","0")
XAA2  = STRTRAN(STR(XAA2,2)," ","0")

RETURN(XGG+XSEPA+XMM+XSEPA+XAA1+XAA2)


**********************************************************************
* Funzione - CODFIS   Data: 15.08.96   Autore: Project S.r.L.
**********************************************************************
* FUNZIONE PER IL CALCOLO DEL CODICE FISCALE
* NECESSITA ANCHE DELLE FUNZIONI VERFIS() OPENDB()
* OCCORRE AVERE IL DFB PJCOMUNI E RELATIVI INDICI
*
* PARAMETRI:
*            _COG  --->  COGNOME
*            _NOM  --->  NOME
*            _DAT  --->  DATA DI NASCITA FORMATO GG-MM-AAAA
*            _SES  --->  SESSO
*            _COM  --->  COMUNE DI NASCITA
*            _PRO  --->  PROVINCIA DI NASCITA
*
*
* SINTASSI: COD_FIS=CODFIS(Espr1,Espr2,Espr3,Espr4,Espr5,Espr6)
*
*
**********************************************************************
FUNCTION CODFIS
****************

PARAMETER _COG,_NOM,_DAT,_SES,_COM,_PRO

W_NP = PARAMETERS()
IF W_NP < 6
   =MESSAGEBOX("Errore Function CODFIS parametri insufficienti !",16,"Attenzione")
   RETURN ""
ENDIF

**=> ERASMO - INIZIO 12/06/2009
* ----> VERIFICA PARAMETRI
IF EMPTY(ALLTRIM(_COG)) .OR. ;
   EMPTY(ALLTRIM(_NOM)) .OR. ;
   EMPTY(ALLTRIM(_DAT)) .OR. ALLTRIM(_DAT) = "/  /" .OR. ;
   EMPTY(ALLTRIM(_SES)) .OR. ;
   EMPTY(ALLTRIM(_COM))
   =MESSAGEBOX("Parametri errati o isufficienti",64,"Attenzione")
   RETURN ""
ENDIF
**=> ERASMO - FINE 12/06/2009

**=> ERASMO - INIZIO 05/06/2024
*** FUNZIONE INTERAMENTE SOSTITUITA CON INTERROGAZIONE WEBSERVICE DOTNETHELL
_rit = ""
IF !IsInternetConnected()
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	RETURN _rit
ENDIF

_par_HTTP_request = "http://webservices.dotnethell.it/codicefiscale.asmx/CalcolaCodiceFiscale"
lcUrl = _par_HTTP_request + "?Nome="+ALLTRIM(_NOM) + CHR(38) + "Cognome="+ALLTRIM(_COG) + CHR(38) + "ComuneNascita="+ALLTRIM(_COM) + CHR(38) + "DataNascita="+STRTRAN(ALLTRIM(_DAT),"/","%2F") + CHR(38) + "Sesso="+ALLTRIM(_SES)

V_BODY = ""
loRequest = Createobject('MsXml2.XmlHttp')
*loRequest = Createobject('MSXML2.ServerXMLHTTP')
loRequest.Open("GET",lcUrl,.F.)
loRequest.Send()
IF TYPE("loRequest.ResponseBody") <> 'U' AND TYPE("loRequest.ResponseBody") <> 'O'
	IF TYPE("loRequest.ResponseBody") == 'Q'
		V_BODY = STRCONV(loRequest.ResponseBody,11)
	ENDIF
	IF TYPE("loRequest.ResponseBody") == 'C'
		V_BODY = loRequest.ResponseBody
	ENDIF
ENDIF 

_cSTRINIRESP = '<string xmlns="http://webservices.dotnethell.it/CodiceFiscale">'
_cSTRFINRESP = '</string>'
_rit = SUBSTR(V_BODY, AT(_cSTRINIRESP,V_BODY,1)+LEN(_cSTRINIRESP), AT(_cSTRFINRESP,V_BODY,1)-(AT(_cSTRINIRESP,V_BODY,1)+LEN(_cSTRINIRESP)))
RELEASE loRequest

IF LEN(ALLTRIM(_rit)) = 16 AND !(' ' $ _rit)
ELSE
	MESSAGEBOX(IIF(!EMPTY(_rit),_rit,"Verificare i parametri"),16,"Attenzione")
	_rit = ""
ENDIF

RETURN _rit
**=> ERASMO - FINE 05/06/2024

*!*	DECLARE TAB_MESI[12]
*!*	    TAB_MESI[01] =  "01A"
*!*	    TAB_MESI[02] =  "02B"
*!*	    TAB_MESI[03] =  "03C"
*!*	    TAB_MESI[04] =  "04D"
*!*	    TAB_MESI[05] =  "05E"
*!*	    TAB_MESI[06] =  "06H"
*!*	    TAB_MESI[07] =  "07L"
*!*	    TAB_MESI[08] =  "08M"
*!*	    TAB_MESI[09] =  "09P"
*!*	    TAB_MESI[10] =  "10R"
*!*	    TAB_MESI[11] =  "11S"
*!*	    TAB_MESI[12] =  "12T"

*!*	_COD1 = SPACE(3) && PRIMI TRE CARATTERI DEL COGNOME
*!*	_COD2 = SPACE(3) && PRIMI TRE CARATTERI DEL NOME
*!*	_COD3 = SPACE(5) && DATA DI NASCITA
*!*	_COD4 = SPACE(4) && CODICE COMUNE DI NASCITA
*!*	_COD5 = SPACE(1) && ULTIMO CARATTERE TROVATO CON VERFIS()
*!*	_TABE = 0
*!*	POSI  = 0        && CONTATORE POSIZIONE

*!*	*******************  SEZIONE PER IL COGNOME  **********************

*!*	* ---> MEMORIZZANO I SINGOLI CARATTERI
*!*	_C1 = " "
*!*	_C2 = " "
*!*	_C3 = " "
*!*	_C4 = " "
*!*	_C5 = " "
*!*	HH  = 0

*!*	* ----> ESTRAGGO CARATTERI DAL COGNOME

*!*	POSI=0
*!*	DO WHILE .T.
*!*	   POSI=POSI+1
*!*	   IF SUBSTR(_COG,(POSI),1) = " "
*!*	      IF SUBSTR(_COG,(POSI),2) = "  "
*!*	         EXIT
*!*	      ENDIF
*!*	      LOOP
*!*	   ENDIF
*!*	   IF SUBSTR(_COG,(POSI),1) = "A" .OR. SUBSTR(_COG,(POSI),1) = "E" .OR. ;
*!*	      SUBSTR(_COG,(POSI),1) = "I" .OR. SUBSTR(_COG,(POSI),1) = "O" .OR. ;
*!*	      SUBSTR(_COG,(POSI),1) = "U"
*!*	      LOOP
*!*	   ELSE
*!*	      IF _C1 = " "
*!*	         _C1 = SUBSTR(_COG,(POSI),1)
*!*	         HH=HH+1
*!*	         LOOP
*!*	      ENDIF
*!*	      IF _C2 = " "
*!*	         _C2 = SUBSTR(_COG,(POSI),1)
*!*	         HH=HH+1
*!*	         LOOP
*!*	      ENDIF
*!*	      IF _C3 = " "
*!*	         _C3 = SUBSTR(_COG,(POSI),1)
*!*	         HH=HH+1
*!*	         EXIT
*!*	      ENDIF
*!*	   ENDIF
*!*	   LOOP
*!*	ENDDO

*!*	* ----> NEL CASO IN CUI NEL COGNOME NON VI SONO CONSONANTI
*!*	IF HH=0
*!*	   =MESSAGEBOX("Errore nella digitazione dei dati !","COGNOME !")
*!*	   RETURN(SPACE(16))
*!*	ENDIF

*!*	* ----> NEL CASO IN CUI NEL COGNOME NON VI SONO TRE CONSONANTI
*!*	IF HH < 3
*!*	   POSI=0
*!*	   DO WHILE .T.
*!*	      POSI=POSI+1
*!*	      IF SUBSTR(_COG,(POSI),1) = " "
*!*	         IF SUBSTR(_COG,(POSI),2) = "  "
*!*	            EXIT
*!*	         ENDIF
*!*	         LOOP
*!*	      ENDIF
*!*	      IF SUBSTR(_COG,(POSI),1) = "A" .OR. SUBSTR(_COG,(POSI),1) = "E" .OR. ;
*!*	         SUBSTR(_COG,(POSI),1) = "I" .OR. SUBSTR(_COG,(POSI),1) = "O" .OR. ;
*!*	         SUBSTR(_COG,(POSI),1) = "U"
*!*	         IF _C1 = " "
*!*	            _C1 = SUBSTR(_COG,(POSI),1)
*!*	            HH=HH+1
*!*	            LOOP
*!*	         ENDIF
*!*	         IF _C2 = " "
*!*	            _C2 = SUBSTR(_COG,(POSI),1)
*!*	            HH=HH+1
*!*	            LOOP
*!*	         ENDIF
*!*	         IF _C3 = " "
*!*	            _C3 = SUBSTR(_COG,(POSI),1)
*!*	            HH=HH+1
*!*	            EXIT
*!*	         ENDIF
*!*	      ENDIF
*!*	      LOOP
*!*	   ENDDO
*!*	ENDIF

*!*	_COD1 = _C1+_C2+_C3

*!*	*******************  SEZIONE PER IL NOME  **********************

*!*	* ---> MEMORIZZANO I SINGOLI CARATTERI
*!*	_C1 = " "
*!*	_C2 = " "
*!*	_C3 = " "
*!*	_C4 = " "
*!*	_C5 = " "
*!*	HH  = 0

*!*	* ----> ESTRAGGO CARATTERI DAL NOME

*!*	POSI = 0
*!*	DO WHILE .T.
*!*	   POSI=POSI+1
*!*	   IF SUBSTR(_NOM,(POSI),1) = " "
*!*	      IF SUBSTR(_NOM,(POSI),2) = "  "
*!*	         EXIT
*!*	      ENDIF
*!*	      LOOP
*!*	   ENDIF
*!*	   IF SUBSTR(_NOM,(POSI),1) = "A" .OR. SUBSTR(_NOM,(POSI),1) = "E" .OR. ;
*!*	      SUBSTR(_NOM,(POSI),1) = "I" .OR. SUBSTR(_NOM,(POSI),1) = "O" .OR. ;
*!*	      SUBSTR(_NOM,(POSI),1) = "U"
*!*	      LOOP
*!*	   ELSE
*!*	      IF _C1 = " "
*!*	         _C1 = SUBSTR(_NOM,(POSI),1)
*!*	         HH=HH+1
*!*	         LOOP
*!*	      ENDIF
*!*	      IF _C2 = " "
*!*	         _C2 = SUBSTR(_NOM,(POSI),1)
*!*	         HH=HH+1
*!*	         LOOP
*!*	      ENDIF
*!*	      IF _C3 = " "
*!*	         _C3 = SUBSTR(_NOM,(POSI),1)
*!*	         HH=HH+1
*!*	         EXIT
*!*	      ENDIF
*!*	   ENDIF
*!*	   LOOP
*!*	ENDDO

*!*	* ----> NEL CASO IN CUI NEL COGNOME NON VI SONO CONSONANTI

*!*	IF HH=0
*!*	   =MESSAGEBOX("Errore nella digitazione dei dati !","NOME !")
*!*	   RETURN(SPACE(16))
*!*	ENDIF

*!*	* ----> NEL CASO IN CUI NEL NOME NON VI SONO TRE CONSONANTI
*!*	IF HH < 3
*!*	   POSI=0
*!*	   DO WHILE .T.
*!*	      POSI=POSI+1
*!*	      IF SUBSTR(_NOM,(POSI),1) = " "
*!*	         IF SUBSTR(_NOM,(POSI),2) = "  "
*!*	            EXIT
*!*	         ENDIF
*!*	         LOOP
*!*	      ENDIF
*!*	      IF SUBSTR(_NOM,(POSI),1) = "A" .OR. SUBSTR(_NOM,(POSI),1) = "E" .OR. ;
*!*	         SUBSTR(_NOM,(POSI),1) = "I" .OR. SUBSTR(_NOM,(POSI),1) = "O" .OR. ;
*!*	         SUBSTR(_NOM,(POSI),1) = "U"
*!*	         IF _C1 = " "
*!*	            _C1 = SUBSTR(_NOM,(POSI),1)
*!*	            HH=HH+1
*!*	            LOOP
*!*	         ENDIF
*!*	         IF _C2 = " "
*!*	            _C2 = SUBSTR(_NOM,(POSI),1)
*!*	            HH=HH+1
*!*	            LOOP
*!*	         ENDIF
*!*	         IF _C3 = " "
*!*	            _C3 = SUBSTR(_NOM,(POSI),1)
*!*	            HH=HH+1
*!*	            EXIT
*!*	         ENDIF
*!*	      ENDIF
*!*	      LOOP
*!*	   ENDDO
*!*	ENDIF

*!*	_COD2 = _C1+_C2+_C3

*!*	*******************  SEZIONE PER LA DATA DI NASCITA  **********************

*!*	* ---> MEMORIZZANO I SINGOLI CARATTERI
*!*	_C1 = " "
*!*	_C2 = " "
*!*	_C3 = " "
*!*	_C4 = " "
*!*	_C5 = " "
*!*	HH  = 0

*!*	* ----> COMPONGO LA DATA
*!*	_C1 = SUBSTR(_DAT,9,1)
*!*	_C2 = SUBSTR(_DAT,10,1)
*!*	_C3 = SUBSTR(TAB_MESI[VAL(SUBSTR(_DAT,4,2))],3,1)
*!*	_C4 = SUBSTR(_DAT,1,1)

*!*	IF _SES = "F"
*!*	   _C4=STR(VAL(SUBSTR(_DAT,1,1))+4,1)
*!*	ENDIF

*!*	_C5   = SUBSTR(_DAT,2,1)
*!*	_COD3 = _C1+_C2+_C3+_C4+_C5

*!*	*******************  SEZIONE PER CODICE COMUNE  **********************
*!*	* ----> CERCO IL COMUNE

*!*	*!*	IF !ExecCommand("select * from pjcomuni where codice=?_COM","pjcomuni")
*!*	*!*	   return
*!*	*!*	ENDIF
*!*	*!*	SELECT PJCOMUNI
*!*	*!*	IF reccount() <> 0
*!*	*!*	   _COD4= SUBSTR(CO_CODPROV,1,4)
*!*	*!*	ELSE
*!*	*!*	   _COD4="XXXX"
*!*	*!*	ENDIF

*!*	**=> ERASMO - INIZIO 12/06/2009
*!*	IF !ExecCommand("select COD_FIS AS CODICE_COMUNE from comuni where comune=?_COM","pjcomuni")
*!*	   return
*!*	ENDIF
*!*	SELECT PJCOMUNI
*!*	IF reccount() <> 0
*!*	   _COD4 = CODICE_COMUNE
*!*	ELSE
*!*	   _COD4 = "XXXX"
*!*	ENDIF
*!*	**=> ERASMO - FINE 12/06/2009

*!*	*******************  SEZIONE PER ULTIMA LETTERA  **********************

*!*	COD_FIS = _COD1+_COD2+_COD3+_COD4
*!*	_COD5   = VERFIS(COD_FIS,.F.)

*!*	*RETURN(_COD1+" "+_COD2+" "+_COD3+" "+_COD4+_COD5)
*!*	RETURN(_COD1+_COD2+_COD3+_COD4+_COD5)  && ERASMO - 12/06/2009


**********************************************************************
* Funzione - VERFIS   Data: 15.08.96   Autore: Project S.r.L.
**********************************************************************
* FUNZIONE PER LA VERIFICA DEL CODICE FISCALE
*
* SE VIENE PASSATO UN PARAMETRO .T. LA FUNZIONE SI LIMITA A VERIFICARE
* L'ESATTEZZA DEL CODICE FISCALE
* IN QUESTO CASO RITORNA IL VALORE .T. SE IL COD.FIS. RISULTA ESATTO E
* IL VALORE .F. SE RISULTA ERRATO.

* SE VIENE PASSATO UN PARAMETRO .F. LA FUNZIONE TROVA L'ULTIMA LETTERA
* DEL CODICE FISCALE
* IN QUESTO CASO RITORNA LA LETTERA DA PORRE ALLA FINE DEL CODICE FISCALE
*
* SINTASSI: V_RIT=VERFIS(V_CODFIF,.T.)  PER CONTROLLARE SE ESATTO
* SINTASSI: V_RIT=VERFIS(V_CODFIF,.F.)  PER CALCOLARE L'ULTIMA LETTERA
*
**********************************************************************
FUNCTION VERFIS
*****************

PARAMETER _CODFIS,_CONTR

W_NP = PARAMETERS()

IF W_NP < 2
   =MESSAGEBOX("Errore - VERFIS Parametri insufficienti !",XX,"Errore !")
   CANCEL
ENDIF

_TOTALE = 0
_RESTO1 = 0
_RESTO2 = 0
POS     = 0
_TAB    = 0

DECLARE TAB_PARI[26]
    TAB_PARI[01] =  "A000"
    TAB_PARI[02] =  "B101"
    TAB_PARI[03] =  "C202"
    TAB_PARI[04] =  "D303"
    TAB_PARI[05] =  "E404"
    TAB_PARI[06] =  "F505"
    TAB_PARI[07] =  "G606"
    TAB_PARI[08] =  "H707"
    TAB_PARI[09] =  "I808"
    TAB_PARI[10] =  "J909"
    TAB_PARI[11] =  "K 10"
    TAB_PARI[12] =  "L 11"
    TAB_PARI[13] =  "M 12"
    TAB_PARI[14] =  "N 13"
    TAB_PARI[15] =  "O 14"
    TAB_PARI[16] =  "P 15"
    TAB_PARI[17] =  "Q 16"
    TAB_PARI[18] =  "R 17"
    TAB_PARI[19] =  "S 18"
    TAB_PARI[20] =  "T 19"
    TAB_PARI[21] =  "U 20"
    TAB_PARI[22] =  "V 21"
    TAB_PARI[23] =  "W 22"
    TAB_PARI[24] =  "X 23"
    TAB_PARI[25] =  "Y 24"
    TAB_PARI[26] =  "Z 25"

DECLARE TAB_DISPARI[26]
    TAB_DISPARI[01] =  "A001"
    TAB_DISPARI[02] =  "B100"
    TAB_DISPARI[03] =  "C205"
    TAB_DISPARI[04] =  "D307"
    TAB_DISPARI[05] =  "E409"
    TAB_DISPARI[06] =  "F513"
    TAB_DISPARI[07] =  "G615"
    TAB_DISPARI[08] =  "H717"
    TAB_DISPARI[09] =  "I819"
    TAB_DISPARI[10] =  "J921"
    TAB_DISPARI[11] =  "K 02"
    TAB_DISPARI[12] =  "L 04"
    TAB_DISPARI[13] =  "M 18"
    TAB_DISPARI[14] =  "N 20"
    TAB_DISPARI[15] =  "O 11"
    TAB_DISPARI[16] =  "P 03"
    TAB_DISPARI[17] =  "Q 06"
    TAB_DISPARI[18] =  "R 08"
    TAB_DISPARI[19] =  "S 12"
    TAB_DISPARI[20] =  "T 14"
    TAB_DISPARI[21] =  "U 16"
    TAB_DISPARI[22] =  "V 10"
    TAB_DISPARI[23] =  "W 22"
    TAB_DISPARI[24] =  "X 25"
    TAB_DISPARI[25] =  "Y 24"
    TAB_DISPARI[26] =  "Z 23"

DECLARE TAB_RESTO[26]
    TAB_RESTO[01] =  "00A"
    TAB_RESTO[02] =  "01B"
    TAB_RESTO[03] =  "02C"
    TAB_RESTO[04] =  "03D"
    TAB_RESTO[05] =  "04E"
    TAB_RESTO[06] =  "05F"
    TAB_RESTO[07] =  "06G"
    TAB_RESTO[08] =  "07H"
    TAB_RESTO[09] =  "08I"
    TAB_RESTO[10] =  "09J"
    TAB_RESTO[11] =  "10K"
    TAB_RESTO[12] =  "11L"
    TAB_RESTO[13] =  "12M"
    TAB_RESTO[14] =  "13N"
    TAB_RESTO[15] =  "14O"
    TAB_RESTO[16] =  "15P"
    TAB_RESTO[17] =  "16Q"
    TAB_RESTO[18] =  "17R"
    TAB_RESTO[19] =  "18S"
    TAB_RESTO[20] =  "19T"
    TAB_RESTO[21] =  "20U"
    TAB_RESTO[22] =  "21V"
    TAB_RESTO[23] =  "22W"
    TAB_RESTO[24] =  "23X"
    TAB_RESTO[25] =  "24Y"
    TAB_RESTO[26] =  "25Z"

POS=0

DO WHILE .T.

   * ----> ELABORO LE POSIZIONI DISPARI ( 1,3,5,7,ecc.)

   POS=POS+1
   
   IF POS >15
      EXIT
   ENDIF
   
   _LETTER = SUBSTR(_CODFIS,(POS),1)
   _TAB    = 0

   DO WHILE  .T.
      _TAB = _TAB+1
      IF _TAB > 26
         EXIT
      ENDIF
      IF _LETTER = SUBSTR(TAB_DISPARI[VAL(STR(_TAB,2))],1,1) .OR. _LETTER = SUBSTR(TAB_DISPARI[VAL(STR(_TAB,2))],2,1)
         _TOTALE=_TOTALE+VAL(SUBSTR(TAB_DISPARI[VAL(STR(_TAB,2))],3,2))
         EXIT
      ELSE
         LOOP
      ENDIF
   ENDDO

   * ----> ELABORO LE POSIZIONI PARI ( 2,4,6,8,ecc.)

   POS=POS+1

   IF POS >15
      EXIT
   ENDIF

   _LETTER = SUBSTR(_CODFIS,(POS),1)
   _TAB    = 0
   
   DO WHILE  .T.
      _TAB=_TAB+1
      IF _TAB > 26
         EXIT
      ENDIF
      IF _LETTER = SUBSTR(TAB_PARI[VAL(STR(_TAB,2))],1,1) .OR. _LETTER = SUBSTR(TAB_PARI[VAL(STR(_TAB,2))],2,1)
         _TOTALE=_TOTALE+VAL(SUBSTR(TAB_PARI[VAL(STR(_TAB,2))],3,2))
         EXIT
      ELSE
         LOOP
      ENDIF
   ENDDO
   
   LOOP

ENDDO

* ----> TROVO L'ULTIMA LETTERA

_RESTO1 = (_TOTALE /26)
_RESTO2 = (_TOTALE - (INT(_RESTO1) * 26))

IF _RESTO2 < 10
   _LETTER ="0"+STR(_RESTO2,1)
ELSE
   _LETTER =STR(_RESTO2,2)
ENDIF

_RIT = "?"
_TAB = 0

DO WHILE  .T.
   _TAB=_TAB+1
   IF _TAB > 26
      EXIT
   ENDIF
   IF _LETTER = SUBSTR(TAB_RESTO[VAL(STR(_TAB,2))],1,2)
      _RIT = SUBSTR(TAB_RESTO[VAL(STR(_TAB,2))],3,1)
      EXIT
   ELSE
      LOOP
   ENDIF
ENDDO

IF _CONTR   && SE ESEGUITA PER CONTROLLO
   IF _RIT = SUBSTR(_CODFIS,16,1)
      RETURN(.T.)
   ELSE
      RETURN(.F.)
   ENDIF
ELSE
   RETURN(_RIT)
ENDIF


**********************************************************************
* Funzione - PARAHELP   Data: 11.05.94   Autore: Project
**********************************************************************
* Mostra una pick list con i dati di un archivio.
* Uso:
* 1) Aprire il database con rispettivo indice (se necessario)
* 2) Chiamare la funzione con la seguente sintassi:
* Variabile = PARAHELP(Select,Titolo,CampoV,CampoR[,Chiave[,Condizione]])
* Select: E' la select in cui c'è il database da mostrare
* Chiave: E' l'eventuale chiave di SEEK che punta al primo elemento
* Titolo: E' l'intestazione della finestra di help
* CampoV: E'il campo visualizzato nell'inquiry
* CampoR: E'il campo ritornato dalla funzione dopo la conferma
* Condizione: E' la condizione che si deve verificare per ogni record
*             che viene visualizzato
* 3)La funzione restituisce "???" se si termina con ESC o il contenuto di
* CampoR se si termina con ENTER.
* ATTENZIONE ! La funzione, nel caso di un'uscita con ESC restituisce
* comunque "???" anche se CampoR è numerico. E' quindi necessario gestire
* la variabile d'uscita con TYPE() onde evitare errori indesiderati.
*
**********************************************************************
FUNCTION PARAHELP
******************
PARAMETER _SELECT,_TITOLO,_CAMPOV,_CAMPOR,_SEEK,_CONDIZIONE

_MAXLAR=0
_MAXALT=0

IF TYPE("_SEEK")=="L"
   _SEEK=""
ENDIF
_SAVESEL = SELECT()
SELECT(_SELECT)
_NP = PARAMETERS()
IF _NP < 4
   =MESSAGEBOX("Errore - PARAHELP Parametri insufficienti !",16,"Errore !")
   CANCEL
ENDIF
IF _NP < 6
   _CONDIZIONE = ".T."
ENDIF
IF _NP < 5 .OR. _SEEK==""
   GO TOP
ELSE
   IF ORDER()==""
      =MESSAGEBOX("Errore - PARAHELP nessun indice in uso ! SEEK ???",16,"Errore !")
      CANCEL
   ENDIF
   _SEEK = ALLTRIM(_SEEK)
   SEEK _SEEK
ENDIF
_FONT   = "Courier New"
_SIZE   = 8
_MAXLAR = LEN(&_CAMPOV)+8
_BCAMPO = "DUMMY = "+_CAMPOV+" :H='"+_TITOLO+"':"+STR(LEN(&_CAMPOV))
_MAXALT = _MAXLAR*.33

DEFINE WINDOW PARAHELP;
   AT  0,0;
   SIZE _MAXALT,_MAXLAR;
   FONT _FONT,_SIZE;
   FLOAT SYSTEM CLOSE HALFHEIGHT;
   TITLE "Seleziona !"
MOVE WINDOW PARAHELP CENTER

BROWSE WINDOW PARAHELP ;
   FIELDS &_BCAMPO;
   FOR &_CONDIZIONE;
   NOAPPEND NODELETE;
   NOEDIT NOMENU REST;
   COLOR ,,,,,,N/R*

ON KEY LABEL ENTER
ON KEY LABEL RIGHTMOUSE
RELEASE WINDOW PARAHELP
IF LASTKEY()=23
   _RETVAL = &_CAMPOR
ELSE
  _RETVAL  = "???"
ENDIF
SELECT(_SAVESEL)
RETURN(_RETVAL)


*************************************************************************
* Funzione - STR_EXTRACT      Data: 26.07.94     Autore: Project
*************************************************************************
* Questa funzione permette di estrarre da una stringa determinate
* sottostringhe contenute tra il delimitatore specificato.
* Esempio:
*     AA="Pippo,Pluto,Paperino"
*     ? STR_EXTRACT(AA,",",2)      && Ritornerà  "Pluto"
* Sintassi:
*     STR_EXTRACT(<ExpC1>,<ExpC2>,<ExpN1>)
*     ExpC1 - Stringa di origine
*     ExpC2 - Carattere delimitatore di lista
*     ExpN1 - Numero di occorrenze nella lista
*
*************************************************************************
FUNCTION STR_EXTRACT
********************

PARA SRIG,DEL,OCC

SRIG=SRIG+DEL

FOR K=1 TO OCC-1
   STAR=AT(DEL,SRIG)+1
   IF STAR >LEN(SRIG)
      SRIG=""
      EXIT
   ENDIF
   SRIG=SUBSTR(SRIG,STAR)
NEXT

FINE=AT(DEL,SRIG)

IF SRIG==""
   RETURN("")
ELSE
   RETURN(SUBSTR(SRIG,1,FINE-1))
ENDIF


***********************************************************************
* Funzione - RIBALTA
***********************************************************************
*
*  Consente di convertire il formato data
*  AA.MM.GG in GG.MM.AA e viceversa
*  Sintassi: RIBALTA(Stringa da convertire)
*  Parametro: Carattere
*  Ritorna:   Carattere
*  Se il contenuto di GG,MM,AA è nullo ritorna SPACE(8)
*
***********************************************************************
FUNCTION RIBALTA
****************

PARAMETER _VALCAMPO

_GIORNO=SUBSTR(_VALCAMPO,7,2)
_MESE  =SUBSTR(_VALCAMPO,4,2)
_ANNO  =SUBSTR(_VALCAMPO,1,2)
_SEPARA=SUBSTR(_VALCAMPO,3,1)
_TUTTO =_GIORNO+_SEPARA+_MESE+_SEPARA+_ANNO

RETURN(_TUTTO)


*!*	**********************************************************************
*!*	* Funzione - VALID_DATA   Data: 27.08.94   Autore: Project
*!*	**********************************************************************
*!*	* Questa funzione permette di verificare l'esattezza di una data in
*!*	* formato stringa. Accetta un solo parametro di tipo carattere lungo
*!*	* 8, nel formato GG.MM.AA ritorna un valore logico .T. se data Ok .F.
*!*	* se data non corretta.
*!*	**********************************************************************
*!*	FUNCTION VALID_DATA
*!*	********************

*!*	PARAMETERS X_DATA
*!*	RETURN(CTOD(X_DATA)!= {  /  /  })


**********************************************************************
* Funzione - WSHOWDBF   Data: 01.10.94   Autore: Project
**********************************************************************
* Questa funzione permette di fare una query SQL su di unn database e
* mostrare il risultato in una finestra browse. Equivale alla vecchia
* SHOWDBF delle nostre applicazioni CLIPPER, la sintassi è la seguente:
*
*  WSHOWDBF(<Exp>,<ExpC1>,<ExpC2>[,<ExpC3>[,<ExpC4>]])
*  Exp   = Può essere Numerico o carattere ed è la SELECT in cui è aperto
*          il database Origine.
*  ExpC1 = E' un'espressione carattere contenente il titolo da porre
*          sulla finestra di OutPut
*  ExpC2 = E' un'espressione carettre contenente l'elenco dei campi
*          da visualizzare nella browse, la stringa ha il seguente formato.
*          "Descrizione campo1:NomeCampo1:Lunghezza1;Descrizione Campo2 ..."
*  ExpC3 = E' un'espressione carattere facoltativa contenente la condizione
*          da validare su ogni record della query.
*          (E' la clausola WHERE di SELECT SQL)
*  ExpC4 = E' un'espressione carattere facolativa contenente l'ordinamento
*          dei dati nella query. Ha il seguente formato.
*          "Nomecampo1 [ASC|DESC] ,Nomecampo2 [ASC|DESC]"
*          - Specificare ASC o nullo per un ordine crescente
*          - Specificare DESC per un ordine decrescente
*          (E' la clausola ORDER BY di Select SQL)
*  Nella finestra di Browse è possibile selezionare un record con il
*  tasto sinistro del mouse e confermare con il tasto destro, è anche
*  possibile annullare chiudendo la finestra (vedi sotto).
*  Con i tasti e possibile muoversi all'interno della finestra, ENTER
*  conferma un record ESC annulla la selezione.
*
*  A seguito di una conferma verrà ritornato il N° di record selezionato.
*  A seguito di un annullo verrà ritornato il valore 0.
*
*  Esempio Query sul database parametri.
*
*  TITOLO="TITOLI DI STUDIO"
*  CAMPI ="Codice Titolo:SUBSTR(CODICE,4):15;Descrizione:DESCRI:25"
*  FILTRO="SUBSTR(CODICE,1,3)=='TIT'"
*  ORDINE="CODICE,DESCRI DESC"
*  ? WSHOWDBF("PARA",TITOLO,CAMPI,FILTRO,ORDINE)
*
**********************************************************************
FUNCTION WSHOWDBF
******************

PARA _SELECT,_TITOLO,_CAMPI,_CONDIZIONI,_ORDINE

IF PARAMETERS() < 3
   =MESSAGEBOX("WSHOWDBF: Parametri Insufficienti, ne occorrono almeno 3 !",16,"ERRORE !")
   RETURN
ENDIF

_CONDIZIONI = IIF(PARAMETERS()<4 OR LEN(_CONDIZIONI)=0,".T.",_CONDIZIONI)
_ORDINE     = IIF(PARAMETERS()<5,"",_ORDINE)
_OLDSELECT  = SELECT()

SELECT(_SELECT)
PRIVATE _PUNCAM,_NUMFLD,_TEMP,_QCAMPI,_RETVAL,_MAXALT,_MAXLAR,_ERR

_NUMFLD=OCCURS(";",_CAMPI)+1

DECLARE _ACAMPO[_NUMFLD],_ALUNGO[_NUMFLD],_ADESCR[_NUMFLD]

FOR _PUNCAM=1 TO _NUMFLD
    _TEMP=STR_EXTRACT(_CAMPI,";",_PUNCAM)
    _ADESCR[_PUNCAM]=STR_EXTRACT(_TEMP,":",1)
    IF EMPTY(_ADESCR[_PUNCAM])
       _ERR="O manca una descrizione nell'elenco campi,"+CHR(13)+;
       "oppure hai messo un punto e virgola in "+CHR(13)+"più alla fine "+;
       "della stringa campi ! Posizione: "+ALLTRIM(STR(_PUNCAM))
       =MESSAGEBOX(_ERR,16,"ERRORE - WSHOWDBF")
       RETURN
    ENDIF
    _ACAMPO[_PUNCAM]=STR_EXTRACT(_TEMP,":",2)
    IF EMPTY(_ACAMPO[_PUNCAM])
       _ERR="Manca un campo nell'elenco alla posizione: "+ALLTRIM(STR(_PUNCAM))
       =MESSAGEBOX(_ERR,16,"ERRORE - WSHOWDBF")
       RETURN
    ENDIF
    _ALUNGO[_PUNCAM]=STR_EXTRACT(_TEMP,":",3)
    IF EMPTY(_ALUNGO[_PUNCAM])
       _ERR="Manca una lunghezza nell'elenco alla posizione: "+ALLTRIM(STR(_PUNCAM))
       =MESSAGEBOX(_ERR,16,"ERRORE - WSHOWDBF")
       RETURN
    ENDIF
NEXT

_QCAMPI=""
FOR _PUNCAM=1 TO _NUMFLD
    _QCAMPI=_QCAMPI+_ACAMPO[_PUNCAM]+","
NEXT

_QCAMPI=SUBSTR(_QCAMPI,1,LEN(_QCAMPI)-1)
_CONDIZIONI=" WHERE "+_CONDIZIONI

IF LEN(_ORDINE)>0
   _CONDIZIONI=_CONDIZIONI+" ORDER BY "+_ORDINE
ENDIF

RELEASE N_REC   
PUBLIC  N_REC   

SET TALK WINDOW
SET TALK ON

SELECT *, RECNO() AS N_REC;
  FROM ALIAS(_SELECT) &_CONDIZIONI;
  INTO CURSOR WSHOWDBF

SET TALK OFF
_MAXALT = 0
_MAXLAR = 0
_QCAMPI = ""

FOR _PUNCAM=1 TO _NUMFLD
    _MAXLAR=_MAXLAR+VAL(_ALUNGO[_PUNCAM])
    _QNTMP=ALLTRIM(STR(_PUNCAM))
    _QCAMPI=_QCAMPI+"M"+_QNTMP+"="+_ACAMPO[_PUNCAM]+":";
            +_ALUNGO[_PUNCAM]+":H=["+_ADESCR[_PUNCAM]+"],"
NEXT

_QCAMPI = SUBSTR(_QCAMPI,1,LEN(_QCAMPI)-1)
_MAXLAR = _MAXLAR+3+_NUMFLD
_MAXALT = _MAXLAR*.33

IF _MAXLAR > 220  &&130
   _MAXLAR = 220  &&130
ENDIF

IF _MAXALT > 47 &&35
   _MAXALT = 47 &&35
ENDIF

*!*	cTitleText = "   ======>>>>>>> FARE CLIC SULLA RIGA + TASTO DESTRO PER ANALIZZARE ULTERIORI INFORMAZIONI   <<<<<<<======" 
cTitleText = "" 

DEFINE WINDOW WSHOWDBF;
   AT  0,0;
   SIZE _MAXALT,_MAXLAR;
   FONT "Courier New",8 HALFHEIGHT;
   FLOAT GROW zoom SYSTEM CLOSE TITLE ALLTRIM(_TITOLO)+ cTitleText 

MOVE WINDOW WSHOWDBF CENTER
ON KEY LABEL ENTER KEYBOARD CHR(23)
*!*	ON KEY LABEL RIGHTMOUSE KEYBOARD "{ENTER}"
ON KEY LABEL RIGHTMOUSE DO WSHOWDBF_CLICK_DESTRO


BROWSE WINDOW WSHOWDBF;
   FIELDS &_QCAMPI;
   NOAPPEND NODELETE;
   NOEDIT NOMENU REST;
   COLOR ,,,,,,N/R*;
   NORGRID NOLGRID

RELEASE WINDOW WSHOWDBF
ON KEY LABEL ENTER
ON KEY LABEL RIGHTMOUSE

IF LASTKEY()=23
  _RETVAL = N_REC
ELSE
  _RETVAL = 0
ENDIF

SELECT(_OLDSELECT)
RETURN(_RETVAL)


**********************************************************************
* Funzione - MEMOREAD   Data: 01.11.94   Autore: Project
**********************************************************************
* Questa funzione è l'equivalente lella medesima funzione CLIPPER,
* permette di leggere un file di testo (dimensione < 64K) e di
* assegnarlo ad una variabile di tipo carattere.
* Sintassi:     VARMEM=MEMOREAD(<ExpC>)
* ExpC = espressione carattere contenente il nome del file da
*        leggere completo di path ed estensione.
*
**********************************************************************
FUNCTION MEMOREAD
*****************

PARA _NOMEFILE

IF !FILE(_NOMEFILE)
   RETURN("")
ENDIF

_HANDLE = FOPEN(_NOMEFILE)
_SIZE   = FSEEK(_HANDLE,0,2)
=FSEEK(_HANDLE,0)
_MEMO   = FREAD(_HANDLE,_SIZE)
=FCLOSE(_HANDLE)
RETURN(_MEMO)


**********************************************************************
* Funzione - MEMOWRITE   Data: 01.11.94   Autore: Project
**********************************************************************
* Questa funzione è l'equivalente lella medesima funzione CLIPPER,
* permette di creare un file di testo (dimensione < 64K) partendo
* da una variabile di memoria tipo carattere.
* Sintassi:     =MEMOREAD(<ExpC1>,<ExpC2>)
* ExpC1 = espressione carattere contenente il nome del file da
*         leggere completo di path ed estensione.
* ExpC2 = espressione carattere che deve essere scritta nel file.
* La funzione restiruisce un valore logico corrispondente all'esito
* dell'operazione effettuata.
*
**********************************************************************
FUNCTION MEMOWRITE
******************
PARA _NOMEFILE,_MEMO

_HANDLE=FCREATE(_NOMEFILE)

IF _HANDLE < 0
   RETURN(.F.)
ENDIF

_SIZE=FWRITE(_HANDLE,_MEMO)
=FCLOSE(_HANDLE)

IF _SIZE <> LEN(_MEMO)
   RETURN(.F.)
ELSE
   RETURN(.T.)
ENDIF


***********************************************************************
* Funzione - RIBALTA2     Data: 15.11.95   Autore: Project
***********************************************************************
*
*  Consente di convertire il formato data
*  AAAA.MM.GG in GG.MM.AAAA e viceversa
*  Sintassi: RIBALTA(Stringa da convertire)
*  Parametro: Carattere
*  Ritorna:   Carattere
*  Se il contenuto di GG,MM,AA è nullo ritorna SPACE(10)
*
***********************************************************************
FUNCTION RIBALTA2
*****************

PARAMETER _VALCAMPO

_SEPARA="/.-"

DO CASE
   CASE SUBSTR(_VALCAMPO,3,1) $ _SEPARA   && GG.MM.AAAA
        _SEPARA=SUBSTR(_VALCAMPO,3,1)
        _GIORNO=SUBSTR(_VALCAMPO,1,2)
        _MESE  =SUBSTR(_VALCAMPO,4,2)
        _ANNO  =SUBSTR(_VALCAMPO,7,4)
        _TUTTO =_ANNO+_SEPARA+_MESE+_SEPARA+_GIORNO
   CASE SUBSTR(_VALCAMPO,5,1) $ _SEPARA   && AAAA.MM.GG
        _SEPARA=SUBSTR(_VALCAMPO,5,1)
        _GIORNO=SUBSTR(_VALCAMPO,9,2)
        _MESE  =SUBSTR(_VALCAMPO,6,2)
        _ANNO  =SUBSTR(_VALCAMPO,1,4)
        _TUTTO =_GIORNO+_SEPARA+_MESE+_SEPARA+_ANNO
   OTHERWISE                              && NON VALIDO !
        _TUTTO=SPACE(10)
ENDCASE

RETURN(_TUTTO)


***********************************************************************
* Procedura - PLAYWAV    Data: 10.12.95   Autore: Project
***********************************************************************
* Suona un file in formato .Wav
* ATTENZIONE! : L'utilizzo di questa procedura modifica l'impostazione
* di SET BEL TO è quindi necessario reimpostarne il valore dopo l'esecuzione.
* Tale limitazione è dovuta all'impossibilità di FoxPro di ritornare
* l'impostazione corrente di SET BEL TO !!!
***********************************************************************
PROCEDURE PLAYWAV
*****************

PARA _NOMEFILE

*!*	SET BELL TO (_NOMEFILE), 0
*!*	?? CHR(7)

**=> ERASMO - INIZIO 26/10/2009
*** FUNZIONE ALTERNATIVA PER EVITARE IL PROBLEMA DELLA 
*** VISUALIZZAZIONE ANOMALA IMMAGINI NEI COMMANDBUTTON
IF FILE(_NOMEFILE)
   #DEFINE SND_SYNC 0
   #DEFINE SND_ASYNC 1
   #DEFINE SND_NODEFAULT 2
   #DEFINE SND_MEMORY 4
   #DEFINE SND_LOOP 8
   #DEFINE SND_NOSTOP 16
   DECLARE INTEGER sndPlaySound IN winmm STRING lpszSound, INTEGER fuSound
   = sndPlaySound(_NOMEFILE,SND_ASYNC + SND_NODEFAULT)
ENDIF
**=> ERASMO - FINE 26/10/2009

RETURN


***************************************************************************
* Procedura - STOPALL               Data: 10.01.96   Autore: Project
***************************************************************************
* QUESTA PROCEDURA E' CHIAMATA DALLA PRESSIONE DI CTRL+Q , BLOCCA
* QUALSIASI ATTIVITA' E RITORNA ALLA FINESTRA COMANDI
*
***************************************************************************
PROCEDURE STOPALL
*****************

CLEAR

ON KEY LABEL "CTRL+Q"
ON KEY LABEL "ESC"
ON KEY LABEL "CTRL+D"
ON READERROR
SET SYSMENU TO DEFAULT
SET STATUS BAR ON
SET TALK ON
DEACTIVATE WINDOW DEBUG
MODIFY WINDOW SCREEN
CLEAR WINDOW ALL

TEXT TO cSql NOSHOW
	UPDATE RES_OPER
	SET IN_USO=0
	where codice = PUB_CODOPE
ENDTEXT

IF !ExecCommand(cSql,"RES_OPER")
  return(.f.)
ENDIF

USE
CANCEL
RETURN


**************************************************************************
* Procedura - OPENDB                    Data: 10.11.95   Autore: Project
**************************************************************************
* Procedura da utilizzare per aprire un DB
*
**************************************************************************
PROCEDURE OPENDB
*****************

PARA V1

IF !USED(V1)
   USE &V1 IN 0 AGAIN
ENDIF

SELECT &V1
SET FILTER TO
SET ORDER TO
GO TOP
RETURN


****************************************************************************
* Funzione - POPLIST                 Data: 04.02.96   Autore: Project
****************************************************************************
* Questa funzione permette di mostrare una lista di selezione, proveniente
* da un database nella quale l'utente può selezionare un valore.
* L'archivio si assume già filtrato, ordinato e selezionato.
* I parametri da passare alla funzione e la sintassi sono i seguenti:
*
*                   <ExpL>=POPLIST(<ExpC1>,<ExpC2>[,<ExpC3>])
*
* ExpC1 = E' il nome della variabile di GET nella quale verrà caricato
*         il valore selezionato nella lista. La variabile deve esistere
*         ed essere di tipo carattere.
*         Se la variabile è inizializzata con un valore, questo
*         verrà ricercato nell'elenco e se trovato diventerà il valore di
*         default selezionato. Le coordinate della variabile GET verranno
*         anche usate per posizionare le finestra di selezione.
*         Se la variabile non fa parte di un guppo di GET, posizionare
*         il cursore con un @ rig,col SAY "" prima di chiamare la funzione.
*
* ExpC2 = E' un'espressione di tipo carattere rappresentante il valore
*         che verrà visualizzato nell'elnco. Può semplicemente essere il
*         nome di un campo del database attivo o un'espressione più complessa.
*
* ExpC3 = E' un'espressione facoltativa che rappresenta il valore che verrà
*         caricato nella variabile <ExpC1> al momento della conferma. Se non
*         viene specificata si assume che nella variabile specificata da ExpC1
*         venga caricato il valore espresso da ExpC2.
*
* La funzione ritorna un valore logico .T. se la variabile ExpC1 è stata
* ridefinita, .F. in caso contrario.
*
* Nota: La funzione imposta in modo automatico due variabili seguenti:
*       PUB_ERRORE = ""    && Usata da toolbar
*       V_POPLIST  = .F.   && Flag di attivazione Poplist (BEG01MNU)
*                             da usare con i pulsanti e CONTROL()
*
* ESEMPIO:
*
* SELECT PARA
* V_RETURN=POPLIST(VARIABILE,"DESCRI")
* PIPPO=SPACE(10)
* V_RETURN=POPLIST("PIPPO","CODICE+'|'+DESCRI","CODICE")
* ? PIPPO
*
*
****************************************************************************
FUNCTION POPLIST
****************

PARAMETERS V_GET,V_CAMPI,V_FILL

IF PARAMETERS() < 2
   =MESSAGEBOX("Parametri insufficienti !",16,"ERRORE POPLIST()")
   RETURN(.F.)
ENDIF

PUB_ERRORE=""
V_POPLIST=.F.
V_MAXRI=8
V_WIND=.T.
V_FILL=IIF(PARAMETERS()>2,V_FILL,V_CAMPI)

IF TYPE("&V_CAMPI")<>"C"
   =MESSAGEBOX("CAMPI NON TROVATI !",16,"ERRORE POPLIST()")
   RETURN(.F.)
ENDIF

IF TYPE("&V_GET")<>"C"
   =MESSAGEBOX("LA VARIABILE &V_GET NON ESISTE !",16,"ERRORE POPLIST()")
   RETURN(.F.)
ENDIF

IF OBJNUM(&V_GET)>0
   SHOW GET &V_GET
ENDIF

&V_GET=SUBSTR(&V_GET,1,LEN(&V_FILL))

IF PARAMETERS()=3
   GO TOP
   LOCATE FOR &V_FILL==&V_GET
   IF !FOUND()
     GO TOP
   ENDIF
   V_DEFAULT=&V_CAMPI
ELSE
   V_DEFAULT=&V_GET
ENDIF

V_LEN=LEN(&V_CAMPI)+2.1
V_ROW=ROW()+3.4
V_COL=COL()-2.6
V_ALTA=V_MAXRI*1.135

IF V_ROW+V_ALTA+.06 > SROWS()
   V_ROW=V_ROW-(V_ROW+V_ALTA+.06-SROWS())
ENDIF

IF V_COL+V_LEN+1 > SCOLS()
   V_COL=V_COL-(V_COL+V_LEN+1-SCOLS())
ENDIF

IF V_WIND
   W_TYPE="PANEL"
ELSE
   W_TYPE="NONE"
ENDIF

DEFINE POPUP V_POPLIST PROMPT FIELD &V_CAMPI SCROLL
DEFINE WINDOW W_COMBO AT V_ROW,V_COL SIZE V_ALTA+.06,V_LEN+1;
	FONT "Courier New", 9 ;
	STYLE "";
    &W_TYPE

ACTIVATE WINDOW W_COMBO
V_NOSAVE=.F.

ON KEY LABEL RIGHTMOUSE KEYBOARD "{ENTER}"
@ ROW(),COL() GET V_LIST ;
    DEFAULT V_DEFAULT;
 	PICTURE "@&T" ;
	POPUP V_POPLIST ;
	SIZE V_ALTA,LEN(&V_CAMPI)+3;
	FONT "Courier New", 9 ;
	STYLE ""

READ CYCLE DEACTIVATE EXITPOP()

ON KEY LABEL RIGHTMOUSE
RELEASE POPUPS V_POPLIST
RELEASE WINDOW W_COMBO

IF LASTKEY()=27 OR V_NOSAVE
   RETURN(.F.)
ELSE
   &V_GET=&V_FILL
   RETURN(.T.)
ENDIF

FUNCTION EXITPOP
V_NOSAVE=.T.
RETURN .T.


************************************************************************
* Procedura - ZERRORE
************************************************************************
* Procedura tappo per gestione evento VALID
PROCEDURE ZERRORE
RETURN


*********************************************************
PROCEDURE CONTATORE
*********************************************************

PARAMETERS _TESTO,_NUMERO,_PASSO,_POS_Y,_POS_X,_NOME_WIN

_NUM_PARA=PARAMETERS()

DO CASE
   CASE _NUM_PARA=1
        =MSGBOX("Manca in parametro","ERRORE IN CONTATORE",31)
   CASE _NUM_PARA=2
        _PASSO=1
        _POS_X=10
        _POS_Y=5
        _NOME_WIN="DISPLAY"
   CASE _NUM_PARA=3
        _POS_X=10
        _POS_Y=5
        _NOME_WIN="DISPLAY"
   CASE _NUM_PARA=5
        _NOME_WIN="DISPLAY"
ENDCASE

IF _PASSO=0 .AND. WEXIST(_NOME_WIN)
   RELEASE WINDOW &_NOME_WIN
   RETURN
ENDIF

IF _NUMERO/_PASSO!=INT(_NUMERO/_PASSO)
   RETURN
ENDIF

IF NOT WEXIST(_NOME_WIN) ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".PJX" ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".SCX" ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".MNX" ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".PRG" ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".FRX" ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".QPR"
	DEFINE WINDOW &_NOME_WIN ;
		AT _POS_Y,_POS_X ;
		SIZE 4.769,22.800 ;
		FONT "MS Sans Serif", 8 ;
		NOFLOAT ;
		NOCLOSE ;
		NOMINIMIZE ;
		PANEL ;
		COLOR RGB(,,,192,192,192)

   ACTIVATE WINDOW &_NOME_WIN

   @ 0.462,1.200 SAY "conta_BN.bmp" BITMAP ;
	SIZE 2.462,20.400 ;
	STYLE "T"
   @ 3.308,1.800 SAY _TESTO ;
	SIZE 1.000,19.400 ;
	FONT "MS Sans Serif", 8

ENDIF

SS_NUMERO=STR(_NUMERO,6,0)

ACTIVATE WINDOW &_NOME_WIN

@ 0.923,3.000 SAY "n_"+ALLTRIM(SUBSTR(SS_NUMERO,1,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"
@ 0.923,5.800 SAY "N_"+ALLTRIM(SUBSTR(SS_NUMERO,2,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"
@ 0.923,8.600 SAY "N_"+ALLTRIM(SUBSTR(SS_NUMERO,3,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"
@ 0.923,11.400 SAY "N_"+ALLTRIM(SUBSTR(SS_NUMERO,4,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"
@ 0.923,14.200 SAY "N_"+ALLTRIM(SUBSTR(SS_NUMERO,5,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"
@ 0.923,17.000 SAY "N_"+ALLTRIM(SUBSTR(SS_NUMERO,6,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"

RETURN


*******************************************************************
FUNCTION PUNTINI
*******************************************************************
* CREA UNA STRINGA ALLINEATA A DX DI 14 CHR CON NUMERO E PUNTINI
****************
PARAMETER VALORE
****************

_XDEC  = ""

IF ATC(',',VALORE) <> 0                           && VERIFICO SE ESITONO DECIMALI
	_XDEC  = SUBSTR(VALORE,ATC(',',VALORE))       && OTTENGO I DECIMALI COMPRESO VIRGOLA
	STRI   = SUBSTR(VALORE,1,ATC(',',VALORE)-1)   && OTTENGO L'INTERO
    STRI   = REPLICATE(" ",11-LEN(ALLTRIM(STRI)))+ALLTRIM(STRI) && AGGIUNGO SPAZI SINO AD ARRIVARE A 11
ELSE
	STRI   = SUBSTR(VALORE,1,11)
ENDIF

_LUN   =LEN(STRI)
ST2    = ""

FOR I= 11 TO 1 STEP -1
  IF SUBSTR(STRI,I,1)<>" "
    IF (I=3 .OR. I=6 .OR. I=9)
      IF SUBSTR(STRI,I-1,1)<>" " .AND. SUBSTR(STRI,I-1,1)<>"-"
        ST2="."+SUBSTR(STRI,I,1)+ST2
      ELSE
        ST2=SUBSTR(STRI,I,1)+ST2
      ENDIF
    ELSE
      ST2=SUBSTR(STRI,I,1)+ST2
    ENDIF
  ELSE
    EXIT
  ENDIF
NEXT

IF !EMPTY(_XDEC)
	ST2= ST2+_XDEC    && AGGIUNGE VIRGOLA E DECIMALE
ENDIF

LUN=LEN(ALLTRIM(ST2))
IF LUN < 15
	ST2=SPACE(14-LUN)+ST2   && AGGIUNGE SPAZI SINO A 14
ENDIF	

RETURN(ST2)


************************************************************************
* Procedura - CANCELLA FILE
************************************************************************

PROCEDURE CANCFILE()

NUMFILE = ADIR(MATFILE,'A:\*.ZIP')

FOR FF = 1 TO NUMFILE
  GG_FILE = MATFILE[FF,1]
  PATC = 'A:\'+GG_FILE
  ERASE  &PATC
ENDFOR

**********************************************************************
* Funzione - NUMWORDS  : VERSIONE IN LIRE
**********************************************************************
* Data     : 10.06.85
* Note     : Conversione di importi da cifre a parole
*            agisce su numeri da 0 a 999999999999
*
FUNCTION NUMWORDS
PARAMETERS NUMERO
UNITA     = "UNO    DUE    TRE    QUATTROCINQUE SEI    SETTE  OTTO   NOVE   "
DECINA1   = "DIECI      UNDICI     DODICI     TREDICI    QUATTORDICI"+;
        "QUINDICI   SEDICI     DICIASSETTEDICIOTTO   DICIANNOVE "
DECINE    = "DIECI    VENTI    TRENTA   QUARANTA CINQUANTASESSANTA "+;
        "SETTANTA OTTANTA  NOVANTA  "
ATTRIBUTI = " MILIARDI MILIONI MILA     "
DO CASE
   CASE NUMERO=0
        PAROLE = "ZERO"
   CASE ABS(NUMERO)=1
        PAROLE = "UNA"
   OTHERWISE
       CIFRE = STR(ABS(NUMERO),12,0)
       PAROLE = ""
       GRUPPO = 4
       DO WHILE GRUPPO#0
          TRE_CIFRE = SUBSTR(CIFRE,(GRUPPO-1)*3+1,3)
          STRINGA = ""
          DO CASE
             CASE TRE_CIFRE=SPACE(3)
                EXIT
             CASE VAL(TRE_CIFRE)=1
                DO CASE
                   CASE GRUPPO=4
                      STRINGA = "UNO"
                   CASE GRUPPO=3
                      STRINGA = "MILLE"
                   CASE GRUPPO=2
                      STRINGA = "UN MILIONE"
                   CASE GRUPPO=1
                      STRINGA = "UN MILIARDO"
                ENDCASE
             CASE VAL(TRE_CIFRE)>1
               CIFRA = VAL(SUBSTR(TRE_CIFRE,1,1))
               IF CIFRA#0
                  IF CIFRA>1
                      STRINGA = TRIM(SUBSTR(UNITA,(CIFRA-1)*7+1,7))
                  ENDIF
                  STRINGA = STRINGA+"CENTO"
                  IF SUBSTR(TRE_CIFRE,2,1)="8"
                      STRINGA = LEFT(STRINGA,LEN(STRINGA)-1)
                  ENDIF
               ENDIF
               CIFRA = VAL(SUBSTR(TRE_CIFRE,2,1))
               IF CIFRA=1
                  CIFRA = VAL(SUBSTR(TRE_CIFRE,3,1))
                  STRINGA = STRINGA+TRIM(SUBSTR(DECINA1,CIFRA*11+1,11))
               ELSE
                  IF CIFRA>1
                     STRINGA = STRINGA+;
                     TRIM(SUBSTR(DECINE,(CIFRA-1)*9+1,9))
                     IF SUBSTR(TRE_CIFRE,3,1)$"18"
                        STRINGA = LEFT(STRINGA,LEN(STRINGA)-1)
                     ENDIF
                  ENDIF
                  CIFRA = VAL(SUBSTR(TRE_CIFRE,3,1))
                  IF CIFRA>0
                     STRINGA = STRINGA+TRIM(SUBSTR(UNITA,(CIFRA-1)*7+1,7))
                  ENDIF
               ENDIF
              IF GRUPPO#4
                 STRINGA = STRINGA+;
                 TRIM(SUBSTR(ATTRIBUTI,(GRUPPO-1)*9+1,9))
              ENDIF
       ENDCASE
       IF LEN(STRINGA)#0
          IF LEN(PAROLE)#0
             STRINGA = STRINGA+" "
          ENDIF
          PAROLE = STRINGA+PAROLE
       ENDIF
       GRUPPO = GRUPPO-1
    ENDDO
ENDCASE
RETURN(PAROLE)



****************************
PROCEDURE CREA_SPOOL
****************************
**--> CREA UN FILE DI SPOOL E AGGIORNA I DATI SULLO STORICO

PARA _ALIAS,_TITOLO

RELEASE _NUMF
PUBLIC _NUMF
_NUMF = ""


_SAVE_SEL=STR(SELECT())

**--> RECUPERO SUL PARA IL NUMERO PROGRESSIVO DA ASSEGNARE AL FILE

IF !ExecCommand("select * from para where codice='NUMSPOOL'+?pub_codsoc","para")
   return
ENDIF
SELECT PARA
IF reccount() <> 0
   _NUMF=SUBSTR(LIBERA,1,7)
ELSE
   _NUMF="0000000"
ENDIF

_NUMF="S"+_NUMF+"."+SUBSTR(PUB_CODOPE,1,3)

**--> CREO IL FILE CON LA COPY DAL dB

SELECT &_ALIAS
GO TOP

COPY TO &_NUMF SDF

**--> SCRIVO SUL JOURNAL IL RISULTATO

**=> SERGIO 26/10/2017 INIZIO: NON PIU' USATO LO SPOOLER
*!*	IF !ExecRW("select * from pj_spool where 1=0","pj_spool","R")
*!*	   return
*!*	ENDIF
*!*	SELECT PJ_SPOOL
*!*	IF reccount() = 0
*!*	   APPEND BLANK
*!*	   REPLACE PJ_CODSOC WITH PUB_CODSOC
*!*	   REPLACE PJ_CODOPE WITH PUB_CODOPE
*!*	   REPLACE PJ_NOME   WITH _NUMF
*!*	   REPLACE PJ_LPT    WITH "LPT1"
*!*	   REPLACE PJ_TITOLO WITH _TITOLO
*!*	   REPLACE PJ_DATA   WITH RIBALTA2(DTOC(DATE()))
*!*	   REPLACE PJ_ORA    WITH SUBSTR(TIME(),1,5)
*!*	   REPLACE PJ_COPIE  WITH 0
*!*	ENDIF
*!*	IF !ExecRW("","pj_spool","W")
*!*	   return
*!*	ENDIF
**=> SERGIO 26/10/2017 FINE: NON PIU' USATO LO SPOOLER


**--> SALVO SUL PARA IL NUMERO USATO PIU' UNO
IF !ExecRW("select * from para where codice='NUMSPOOL'+?PUB_CODSOC","para","R")
   return
ENDIF
SELECT PARA
IF reccount() <> 0
   VAL_NUMF=VAL(LIBERA)+1
   REPLACE LIBERA WITH SETTE_ZERI(VAL_NUMF)
ELSE
   VAL_NUMF=1
   APPEND BLANK
   REPLACE CODICE WITH "NUMSPOOL"+PUB_CODSOC
   REPLACE DESCRI WITH "NUMERO PROGRESSIVO PER CREAZIONE FILE SPOOL"
   REPLACE LIBERA WITH SETTE_ZERI(VAL_NUMF)
ENDIF
IF !ExecRW("","para","W")
   return
ENDIF

SELECT &_SAVE_SEL
RETURN
   
***********************************************************************
* Funzione - SETTE_ZERI   Autore: Project S.r.L.
***********************************************************************
  
FUNCTION SETTE_ZERI
PARA VVVAAL

IF VVVAAL<10000000
  OUT=STR(VVVAAL,7,0)
ENDIF

IF VVVAAL<1000000
  OUT="0"+STR(VVVAAL,6,0)
ENDIF

IF VVVAAL<100000
  OUT="00"+STR(VVVAAL,5,0)
ENDIF

IF VVVAAL<10000
  OUT="000"+STR(VVVAAL,4,0)
ENDIF

IF VVVAAL<1000
  OUT="0000"+STR(VVVAAL,3,0)
ENDIF

IF VVVAAL<100
  OUT="00000"+STR(VVVAAL,2,0)
ENDIF

IF VVVAAL<10
  OUT="000000"+STR(VVVAAL,1,0)
ENDIF

RETURN(OUT)


***********************************************************************
* Funzione - TRC     Data: 18.03.97   Autore: Project S.r.L.
***********************************************************************
*
*  AGGIUNGE ZERI INIZIALI AD UN NUMERO IN FORMATO CARATTERE
*  PARAMETRI DA PASSARE
*  _LUN  = LUNGEZZA DEL CAMPO
*  _COD = VARIABILE CONTENENTE VALORE
*
*  sintassi:
*  V_COD=TRC(10,V_COD)
**************************
FUNCTION TRC
**************************
PARA _LUN,_COD

_COD=ALLTRIM(_COD)
IF LEN(_COD) > _LUN
 RETURN(_COD)
ENDIF

_LUN1=_LUN - LEN(_COD)
_OUT=REPLICATE('0',_LUN1)+_COD

RETURN(_OUT)

**************************************************************************
* Funzione - TRCSP     Data: 31.03.2000   Autore: Sergio Piaggi by Project
**************************************************************************
*
*  AGGIUNGE SPAZI FINALI AD UN NUMERO IN FORMATO CARATTERE
*  PARAMETRI DA PASSARE
*  _LUN  = LUNGEZZA DEL CAMPO
*  _COD = VARIABILE CONTENENTE VALORE
*
*  sintassi:
*  V_COD=TRC(10,V_COD)
**************************
FUNCTION TRCSP
**************************
PARA _LUN,_COD

_COD=ALLTRIM(_COD)
IF LEN(_COD) > _LUN
 RETURN(_COD)
ENDIF

_LUN1=_LUN - LEN(_COD)
_OUT=_COD+REPLICATE(' ',_LUN1)

RETURN(_OUT)


***********************************************************************
* Funzione - DX13     Data: 28.08.97   Autore: Sergio Piaggi by Project
***********************************************************************
*
*  AGGIUNGE "_" INIZIALI AD UN NUMERO IN FORMATO CARATTERE DOPO AVERLO
*  TRASFORMATO CON I PUNTINI SEPARATORI
*  PARAMETRI DA PASSARE
*  _LUN  = LUNGEZZA DEL CAMPO
*  _COD = VARIABILE CONTENENTE VALORE
*
*  sintassi:
*  V_COD=TRC(10,V_COD)
**************************
FUNCTION DX13
**************************
PARA _LUN,_COD

_COD=ALLTRIM(TRAN(_COD,"9,999,999,999.999"))
IF LEN(_COD) > _LUN
 RETURN(_COD)
ENDIF

IF LEN(_COD) = 1
 _LUN = 15                && FORZA 15 PER ALLINEARE A DESTRA SU MESSAGE
ENDIF

_LUN1=_LUN - LEN(_COD)

_OUT=REPLICATE("_",_LUN1)+_COD

RETURN(_OUT)

********************
FUNCTION CERCAFORM      && RICERCA IL FORM PERSONALIZZATO
********************
* -->> SINTASSI: AA=CERCAFORM(_PROC,_FORM_EXE)
* -->> DOVE    : 
* -->>            _PROC  		= KEY ACCESS PER IDENTIFICARE IL FORM DA ESEGUIRE ALTERNATIVO AL FORM STANDARD

LPARAMETERS  _PROC   

LOCAL _NOMEFORM,_FORM_EXE_UTE  

_SAVE_SEL=STR(SELECT())
SET EXACT ON

_FORM_EXE_UTE  	= CERCAFORM_UTENTE(PUB_CODOPE,_PROC) 	&& CERCA IL FORM PERSONALIZZATO SULLA TABELLA UTENTE 
IF !EMPTY(_FORM_EXE_UTE)
	
	_NOMEFORM = _FORM_EXE_UTE  

ELSE 

	x_cond = "nomeproc = '" + ALLTRIM(_PROC) + "'"
	cSql = "select * from FORM_EXE where " + x_cond + " order by nomeproc"

	IF !ExecCommand(cSql,"FORM_EXE")
	   return("NNN")
	ENDIF

	SELECT FORM_EXE
	IF reccount() > 0
		_NOMEFORM=ALLTRIM(NOMEFORMEXE)
	ELSE
		_NOMEFORM=ALLTRIM(_PROC)
	ENDIF

ENDIF


IF !EMPTY(_NOMEFORM)
	_CERCA_FORM = "FORM\"+_NOMEFORM+".SCT"

	IF !FILE(_CERCA_FORM)
	   =MESSAGEB("Manca il form: "+ALLTRIM(_NOMEFORM),16,"*** ATTENZIONE ***")
	   SELECT &_SAVE_SEL
	   RETURN("NNN")
	ENDIF
ENDIF

SELECT &_SAVE_SEL
RETURN(_NOMEFORM)


******************************************************************************
FUNCTION CERCAFORM_UTENTE && RICERCA IL FORM PERSONALIZZATO PER SINGOLO UTENTE
******************************************************************************
* -->> SINTASSI: AA=CERCAFORM(_UTE,_PROC)
* -->> DOVE    : 
* -->>            _UTE  		= CODICE OPERATORE
* -->>            _PROC  		= KEY ACCESS PER IDENTIFICARE IL FORM DA ESEGUIRE ALTERNATIVO AL FORM STANDARCODICE UTENTED

LPARAMETERS  _UTE,_PROC   

LOCAL _NOMEFORM

_SAVE_SEL=STR(SELECT())
SET EXACT ON

x_uten = "utente = '" + ALLTRIM(_UTE) + "'"
x_proc = "nomeproc = '" + ALLTRIM(_PROC) + "'"
x_cond = x_uten + " and " + x_proc  
cSql = "select * from FORM_EXE_UTENTE where " + x_cond + " order by nomeproc"


IF !ExecCommand(cSql,"FORM_EXE_UTENTE")
   return("NNN")
ENDIF

SELECT FORM_EXE_UTENTE
IF reccount() > 0
	IF !EMPTY(NOMEFORMEXE)
		_NOMEFORM=ALLTRIM(NOMEFORMEXE)
	ELSE
		_NOMEFORM=""	&& ALLTRIM(_PROC) : FORZO BLANK IN MODO DA FAR GESTIRE ALLA CERCAFORM LA RICERCA DEL FORM
	ENDIF
ELSE
	_NOMEFORM=""		&& ALLTRIM(_PROC) : FORZO BLANK IN MODO DA FAR GESTIRE ALLA CERCAFORM LA RICERCA DEL FORM
ENDIF


SELECT &_SAVE_SEL
RETURN(_NOMEFORM)
***********************************
FUNCTION ESEGUE_FORM
***********************************
LPARAMETERS _FORM_STD,_FORM_EXE,_PARAMETRI_FORM


DO CASE

	CASE EMPTY(_FORM_EXE)
	
		IF EMPTY(_PARAMETRI_FORM)
			DO FORM FORM\&_FORM_STD  linked  
		ELSE
			DO FORM FORM\&_FORM_STD WITH _PARAMETRI_FORM linked  
		ENDIF       
	
	OTHERWISE


		IF EMPTY(_PARAMETRI_FORM)
			DO FORM FORM\&_FORM_EXE linked  
		ELSE
			DO FORM FORM\&_FORM_EXE WITH _PARAMETRI_FORM linked  
		ENDIF     
	 
ENDCASE



RETURN


***********************************
FUNCTION ESEGUE_FORM_PARAMETRI
***********************************
LPARAMETERS _codice_operatore,_ulteriore_descrizione_form  

IF PCOUNT() = 0
  _codice_operatore = pub_codope
ENDIF

*IF PCOUNT() = 1
IF PCOUNT() <= 1  && ERASMO - 05/09/2016
  _ulteriore_descrizione_form  = ""
ENDIF


_GESTIONE_PARAMETRI_ALBERO__ = .F.

SUTEX=STR(SELECT())

__CODOPE= ALLTRIM(_codice_operatore)
IF !ExecCommand("SELECT * FROM res_oper WHERE CODICE=?__CODOPE","Res_Oper_Temp")
  return(.f.)
ENDIF

SELECT Res_Oper_Temp
GO TOP
IF !EOF()	
	IF RES_PARATREE
		_GESTIONE_PARAMETRI_ALBERO__ = .T.
	ELSE
		_GESTIONE_PARAMETRI_ALBERO__ = .F.
	ENDIF
ENDIF 


IF !PUB_PARATREE	&& NON è ATTIVA LA GESTIONE DEI PARAMETRI AD ALBERO

	do form form\menu_paraall linked 
	
ELSE

	IF _GESTIONE_PARAMETRI_ALBERO__ 	&& PUB_PARATREE
		do form form\menu_parametri WITH _codice_operatore,_ulteriore_descrizione_form linked 
	ELSE
		do form form\menu_paraall linked 
	ENDIF

ENDIF


SELECT &SUTEX


RETURN

********************
FUNCTION CERCAREPO      && RICERCA IL REPORT DI STAMPA PERSONALIZZATO
********************
* -->> SINTASSI: AA=CERCAREPO(_COMPA,_PROC,_REPO)
* -->> DOVE    :  _COMPA = CODICE DELLA COMPAGNIA SE ESISTONO REPORT DIVERSI
* -->>                     A SECONDA DELLE COMPAGNIE. PER UN REPORT UNICO PER
* -->>                     TUTTE LE COMPAGNIE DEVE ESSERE << XXX >>.
* -->>            _PROC  = NOME DELLA PROCEDURA IN CUI E' RICHIAMATO E CON CUI
* -->>                     VIENE IDENTIFICATO IN PJTIPREP.DBF.
* -->>            _REPO  = NOME DEL REPORT STANDARD USATO DAL SISTEMA.

PARA _COMPA,_PROC,_REPO

* -->> RICERCO SE ESISTONO REPORT DI STAMPA PERSONALIZZATI
* -->> RICHIESTI DAI VARI CLIENTI
IF PARAMETER() < 3
  _NOMEREP="NNN"
ELSE
  _NOMEREP="REPORT\"+_REPO
ENDIF
**** DO DAV

_SAVE_SEL=STR(SELECT())
SET EXACT ON

x_comp = "compa = '" + ALLTRIM(_COMPA) + "'"
x_nome = "nomeproc = '" + ALLTRIM(_PROC) + "'"
x_cond = x_comp + " and " + x_nome   
cSql = "select * from pjtiprep where " + x_cond + " order by compa,nomeproc"

*** TEXT TO cSql NOSHOW
***	   SELECT *
***	   FROM pjtiprep
***	   where compa+nomeproc = ?_COMPA+?_PROC
*** ENDTEXT

IF !ExecCommand(cSql,"pjtiprep")
   return("NNN")
ENDIF

SELECT pjtiprep
IF reccount() > 0
   _NOMEREP="REPORT\"+NOMEREP
ELSE
   x_nome = "nomeproc = '" + ALLTRIM(_PROC) + "'"
   x_cond = x_nome   
   cSql = "select * from pjtiprep where " + x_cond + " order by nomeproc"
   *** TEXT TO cSql NOSHOW
   ***	  SELECT *
   ***	  FROM pjtiprep
   ***	  where nomeproc = ?_PROC
   *** ENDTEXT
   IF !ExecCommand(cSql,"pjtiprep")
	  return("NNN")
   ENDIF
   SELECT pjtiprep
   IF reccount() > 0
 	  _NOMEREP="REPORT\"+NOMEREP
   ENDIF
ENDIF

*SET EXACT OFF
&& ASTERISCATO DA ERASMO IL 29/01/2013

IF !FILE(_NOMEREP)
   =MESSAGEB("Manca il report: "+ALLTRIM(_NOMEREP),16,"*** ATTENZIONE ***")
   SELECT &_SAVE_SEL
   RETURN("NNN")
ENDIF

SELECT &_SAVE_SEL
RETURN(_NOMEREP)


********************
FUNCTION ELENCOPRN
********************
* -->> QUESTA FUNZIONE PERMETTE DI STAMPARE IL CONTENUTO DI UN ARCHIVIO (CURSORE O DBF)
* -->> CON IL REPORT STANDARD CREATO PER LA PROCEDURA IN CUI E' RICHIAMATO O OLTRI REPORT
* -->> FATTI COME PERSONALIZZAZIONE PER IL CLIENTE
*
* -->> SINTASSI: =ELENCOPRN(_SELECT,_COMPA,_PROC,_REPO)
* -->> DOVE    :  _SELECT= ALIAS DEL CURSORE/DBF
* -->>            _COMPA = CODICE DELLA COMPAGNIA SE ESISTONO REPORT DIVERSI
* -->>                     A SECONDA DELLE COMPAGNIE. PER UN REPORT UNICO PER
* -->>                     TUTTE LE COMPAGNIE DEVE ESSERE << XXX >>.
* -->>            _PROC  = NOME DELLA PROCEDURA IN CUI E' RICHIAMATO E CON CUI
* -->>                     VIENE IDENTIFICATO IN PJTIPREP.DBF.
* -->>            _REPO  = NOME DEL REPORT STANDARD USATO DAL SISTEMA.

PARA _SELECT,_COMPA,_PROC,_REPO

* -->> RICERCO SE ESISTONO REPORT DI STAMPA PERSONALIZZATI
* -->> RICHIESTI DAI VARI CLIENTI
IF PARAMETER() < 3
   =MESSAGEB("MANCANO PARAMETRI PER LA FUNZIONE ELENCOPRN <WINLIB>",16,"*** ATTENZIONE ***")
   RETURN(.T.)
ENDIF

IF PARAMETER() < 4
   _NOMEREP="NNN"
ELSE
   _NOMEREP=_REPO
ENDIF

x_comp = "compa = '" + ALLTRIM(_COMPA) + "'"
x_nome = "nomeproc = '" + ALLTRIM(_PROC) + "'"
x_cond = x_comp + " and " + x_nome   
cSql = "select * from pjtiprep where " + x_cond + " order by compa,nomeproc"

*** TEXT TO cSql NOSHOW
***	   SELECT *
***	   FROM pjtiprep
***	   where compa+nomeproc = ?_COMPA+?_PROC
*** ENDTEXT

IF !ExecCommand(cSql,"pjtiprep")
  return(.f.)
ENDIF

SELECT pjtiprep
IF reccount() > 0
   _NOMEREP="REPORT\"+NOMEREP
ELSE
   x_nome = "nomeproc = '" + ALLTRIM(_PROC) + "'"
   x_cond = x_nome   
   cSql = "select * from pjtiprep where " + x_cond + " order by nomeproc"
   *** TEXT TO cSql NOSHOW
   ***	  SELECT *
   ***	  FROM pjtiprep
   ***	  where nomeproc = ?_PROC
   *** ENDTEXT
   IF !ExecCommand(cSql,"pjtiprep")
	  return(.f.)
   ENDIF
   SELECT pjtiprep
   IF reccount() > 0
 	  _NOMEREP="REPORT\"+NOMEREP
   ENDIF
ENDIF

IF !FILE(_NOMEREP)
   =MESSAGEB("Manca il report "+ALLTRIM(_NOMEREP),16,"*** ATTENZIONE ***")
   RETURN(.T.)
ENDIF

* -->> VERIFICO SE SI TRATTA DI REPORT O ETICHETTA
ESTE=SUBSTR(_NOMEREP,LEN(ALLTRIM(_NOMEREP))-2,3)

IF ESTE="FRX"
   SELECT &_SELECT
   GO TOP
   IF MESSAGEB("Desideri anche il preview ?",292,"*** DOMANDA ***")=6
      REPORT FORM &_NOMEREP PREVIEW
      REPORT FORM &_NOMEREP TO PRINTER PROMPT NOCONSOLE
   ELSE
     REPORT FORM &_NOMEREP TO PRINTER PROMPT NOCONSOLE
   ENDIF
ELSE
   SELECT &_SELECT
   GO TOP
   IF MESSAGEB("Desideri anche il preview ?",292,"*** DOMANDA ***")=6
      LABEL FORM &_NOMEREP PREVIEW
      LABEL FORM &_NOMEREP NOCONSOLE TO PRINTER PROMPT
   ELSE
      LABEL FORM &_NOMEREP TO PRINTER PROMPT NOCONSOLE NOEJECT
   ENDIF
ENDIF

RETURN(.T.)


***********************************************************************
* Funzione - SOTTOGEN     Data: 31.03.98   Autore: Carlo by Project
***********************************************************************
*  RITORNA IN PUB_CC E PUB_FF IL SOTTOCONTO CLIENTI E FORNITORI
*  V_ER =.T. SE NON TROVO NESSUN SOTTOCONTO, ALTRIMENTI V_ER=.F.
*
*  PUB_STATO_CEE = .T.			SE SI TRATTA DI UN PAESE CEE
*  PUB_STATO_EXTRA_CEE = .T.	SE SI TRATTA DI UN PAESE EXTRA CEE
*
*  ACCEDE AL PARAMETRO STA+CODICE NAZIONE
*	SE NON ESISTE : TRATTA IL PARAMETRO GEN+PUB_CODSOC
*
*  sintassi:
*  V_ER=SOTTOGEN(V_CODNAZ)
**************************
FUNCTION SOTTOGEN
**************************
PARA _CNAZ

PUB_ER				= .F.
PUB_CC				= ''
PUB_FF				= ''
PUB_STATO_CEE 		= .F.			
PUB_STATO_EXTRA_CEE = .F.	

_SAVESEL = SELECT()

_CNAZ = ALLTRIM(SUBSTR(_CNAZ,1,3))


* == >>> ACCESSO AL PARAMETRO GENERALE
TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GEN'+?pub_codsoc
ENDTEXT
IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF
SELECT PARA
IF reccount() > 0

   ** SERGIO 05/10/2021 INIZIO
   IF PUB_CONTOSIMILCEE 
	   PUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_GRUPPOCF))
	   PUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_GRUPPOCF))
   ELSE
	   PUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_SOTTOG-1))
	   PUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_SOTTOG-1))
   ENDIF
   ** SERGIO 05/10/2021 FINE
ELSE
   =MESSAGEBOX("Parametro << GEN01 >> non trovato",16,"*** ATTENZIONE ***")
   SELECT(_SAVESEL)
   PUB_ER=.T.
   RETURN(PUB_ER)
ENDIF


* == >>> ACCESSO AL PARAMETRO NAZIONE

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'STA'+?_cnaz
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() = 0
    PUB_ER=.F.
    SELECT(_SAVESEL)
    RETURN(PUB_ER)
ENDIF

* == >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONE ITALIA

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENIT'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() > 0
    IF _CNAZ $ NOTE

      ** SERGIO 05/10/2021 INIZIO
	  IF PUB_CONTOSIMILCEE 
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_GRUPPOCF))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_GRUPPOCF))
	  ELSE
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_SOTTOG-1))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_SOTTOG-1))
	  ENDIF
      ** SERGIO 05/10/2021 FINE


      IF EMPTY(XUB_CC).OR.EMPTY(XUB_FF)
	    =MESSAGEBOX("Mancano valori nel parametro << GENIT >>",16,"*** ATTENZIONE ***")
        PUB_ER=.T.
        SELECT(_SAVESEL)
        RETURN(PUB_ER)
      ELSE
      
        PUB_CC=XUB_CC
        PUB_FF=XUB_FF
        PUB_ER=.F.

        SELECT(_SAVESEL)
        RETURN(PUB_ER)
      ENDIF
    ELSE
      PUB_ER=.T.
    ENDIF
ENDIF

* == >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONI CEE

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENCE'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() > 0
   IF _CNAZ $ NOTE

      ** SERGIO 05/10/2021 INIZIO
	  IF PUB_CONTOSIMILCEE 
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_GRUPPOCF))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_GRUPPOCF))
	  ELSE
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_SOTTOG-1))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_SOTTOG-1))
	  ENDIF
      ** SERGIO 05/10/2021 FINE


      IF EMPTY(XUB_CC).OR.EMPTY(XUB_FF)
	    =MESSAGEBOX("Mancano valori nel parametro << GENCE >>",16,"*** ATTENZIONE ***")
        PUB_ER=.T.
        RETURN(PUB_ER)
      ELSE

        PUB_CC			= XUB_CC
        PUB_FF			= XUB_FF
        PUB_STATO_CEE 	= .T.
        PUB_ER			= .F.
        
        SELECT(_SAVESEL)
        RETURN(PUB_ER)
      ENDIF
    ELSE
      PUB_ER=.T.
    ENDIF
ENDIF



* === >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONI EXTRA CEE

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENEX'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() > 0
   IF _CNAZ $ NOTE


      ** SERGIO 05/10/2021 INIZIO   
	  IF PUB_CONTOSIMILCEE 
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_GRUPPOCF))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_GRUPPOCF))
	  ELSE
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_SOTTOG-1))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_SOTTOG-1))
	  ENDIF
      ** SERGIO 05/10/2021 FINE   
   
      IF EMPTY(XUB_CC).OR.EMPTY(XUB_FF)
	    =MESSAGEBOX("Mancano valori nel parametro << GENEX >>",16,"*** ATTENZIONE ***")
        PUB_ER=.T.
        RETURN(PUB_ER)
      ELSE
      
        PUB_CC				= XUB_CC
        PUB_FF				= XUB_FF
		PUB_STATO_EXTRA_CEE = .T.	
        PUB_ER				= .F.

        SELECT(_SAVESEL)
        RETURN(PUB_ER)
      ENDIF
    ELSE
      PUB_ER=.T.
    ENDIF
ENDIF

**=> ERASMO - INIZIO 02/09/2019
* === >>> ACCESSO AL PARAMETRO GENERALE 'GENES' PER GESTIONE ALTERNATIVA
TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENES'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() > 0
   IF _CNAZ $ NOTE
   
      ** SERGIO 05/10/2021 INIZIO   
	  IF PUB_CONTOSIMILCEE 
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_GRUPPOCF))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_GRUPPOCF))
	  ELSE
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_SOTTOG-1))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_SOTTOG-1))	      
	  ENDIF
      ** SERGIO 05/10/2021 FINE    
   
      IF EMPTY(XUB_CC).OR.EMPTY(XUB_FF)
	    =MESSAGEBOX("Mancano valori nel parametro << GENES >>",16,"*** ATTENZIONE ***")
        PUB_ER=.T.
        RETURN(PUB_ER)
      ELSE
      
        PUB_CC				= XUB_CC
        PUB_FF				= XUB_FF
		PUB_STATO_EXTRA_CEE = .T.	
        PUB_ER				= .F.

        SELECT(_SAVESEL)
        RETURN(PUB_ER)
      ENDIF
    ELSE
      PUB_ER=.T.
    ENDIF
ENDIF
**=> ERASMO - FINE 02/09/2019

IF PUB_ER=.T.
    *=MESSAGEBOX("PARAMETRO 'GEN' NON TROVATO",16,"ATTENZIONE")
    *RETURN(PUB_ER)
ENDIF

**=> ERASMO - INIZIO 31/01/2014
SELECT(_SAVESEL)

ENDFUNC
**=> ERASMO - FINE 31/01/2014

***********************************************************************
* Funzione - VERYCF          Data: 09/06/99   Autore: Sergio by Project
***********************************************************************
*
*   RICONOSCE SE CLIENTE / FORNITORE ATTRAVERSO I PARAMETRI :
*	- GEN01		:	GENERALE
*   - GENIT		:	SE GRUPPO NAZIONE ITALIA
*	- GENCE		:	SE GRUPPO CEE
*	- GENEX		:	SE GRUPPO EXTRA CEE
*
*	- PARAMETRI : _MASTRO = SOTTOGRUPPO DA VERIFICARE
*				: _CLFO	  = "CF"  SE DEVE CONTROLLARE SIA IL MASTRO CLI CHE FOR	
*				: _CLFO	  = "CL"  SE DEVE CONTROLLARE SOLO IL MASTRO CLIENTE
*				: _CLFO	  = "FO"  SE DEVE CONTROLLARE SOLO IL MASTRO FORNITORE
*

FUNCTION VERYCF
PARA _MASTRO,_CLFO

_SAVESEL = SELECT()

PUB_CC  =''
PUB_FF  =''
PUB_CCIT=''
PUB_FFIT=''
PUB_CCCE=''
PUB_FFCE=''
PUB_CCEX=''
PUB_FFEX=''

_DAELAB = .F.


TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GEN'+?pub_codsoc
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

* == >>> ACCESSO AL PARAMETRO GENERALE
SELECT PARA

** SERGIO 18/12/2021 INIZIO   
IF PUB_CONTOSIMILCEE 

	IF reccount() > 0
	   PUB_CC=SUBSTR(LIBERA,1,PUB_GRUPPOCF)
	   PUB_FF=SUBSTR(LIBERA,18,PUB_GRUPPOCF)
	ELSE
	   =MESSAGEBOX("PARAMETRO 'GEN01' NON TROVATO",16,"ATTENZIONE")
	   PUB_ER=.T.
	   SELECT(_SAVESEL)
	   RETURN(PUB_ER)
	ENDIF  
  
ELSE


	IF reccount() > 0
	   PUB_CC=SUBSTR(LIBERA,1,pub_sottog-1)
	   PUB_FF=SUBSTR(LIBERA,18,pub_sottog-1)
	ELSE
	   =MESSAGEBOX("PARAMETRO 'GEN01' NON TROVATO",16,"ATTENZIONE")
	   PUB_ER=.T.
	   SELECT(_SAVESEL)
	   RETURN(PUB_ER)
	ENDIF
	      
ENDIF
** SERGIO 18/12/2021 FINE    






* == >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONE ITALIA

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENIT'
ENDTEXT

IF !ExecCommand(cSql,"para")
   return(.f.)
ENDIF

SELECT PARA


** SERGIO 18/12/2021 INIZIO   
IF PUB_CONTOSIMILCEE 

	IF reccount() > 0
	      PUB_CCIT=SUBSTR(LIBERA,1,PUB_GRUPPOCF)
	      PUB_FFIT=SUBSTR(LIBERA,18,PUB_GRUPPOCF)
	ENDIF
  
ELSE

	IF reccount() > 0
	      PUB_CCIT=SUBSTR(LIBERA,1,pub_sottog-1)
	      PUB_FFIT=SUBSTR(LIBERA,18,pub_sottog-1)
	ENDIF
	      
ENDIF
** SERGIO 18/12/2021 FINE



* == >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONI CEE

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENCE'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA


** SERGIO 18/12/2021 INIZIO   
IF PUB_CONTOSIMILCEE 

	IF reccount() > 0
	      PUB_CCCE=SUBSTR(LIBERA,1,PUB_GRUPPOCF)
	      PUB_FFCE=SUBSTR(LIBERA,18,PUB_GRUPPOCF)
	ENDIF
  
ELSE

	IF reccount() > 0
	      PUB_CCCE=SUBSTR(LIBERA,1,pub_sottog-1)
	      PUB_FFCE=SUBSTR(LIBERA,18,pub_sottog-1)
	ENDIF
	      
ENDIF
** SERGIO 18/12/2021 FINE

* === >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONI EXTRA CEE

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENEX'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA

** SERGIO 18/12/2021 INIZIO   
IF PUB_CONTOSIMILCEE 

	IF reccount() > 0
	      PUB_CCEX=SUBSTR(LIBERA,1,PUB_GRUPPOCF)
	      PUB_FFEX=SUBSTR(LIBERA,18,PUB_GRUPPOCF)
	ENDIF
  
ELSE

	IF reccount() > 0
	      PUB_CCEX=SUBSTR(LIBERA,1,pub_sottog-1)
	      PUB_FFEX=SUBSTR(LIBERA,18,pub_sottog-1)
	ENDIF

	      
ENDIF
** SERGIO 18/12/2021 FINE

* === >>> VERIFICA

_DAELAB = .F.


DO CASE
	CASE _CLFO = "CF"

			IF _MASTRO = PUB_CC
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_FF
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_CCIT
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_FFIT
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_CCCE
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_FFCE
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_CCEX
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_FFEX
			   _DAELAB = .T.
			ENDIF


	CASE _CLFO = "CL"


			IF _MASTRO = PUB_CC
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_CCIT
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_CCCE
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_CCEX
			   _DAELAB = .T.
			ENDIF


	CASE _CLFO = "FO"	


			IF _MASTRO = PUB_FF
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_FFIT
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_FFCE
			   _DAELAB = .T.
			ENDIF

			IF _MASTRO = PUB_FFEX
			   _DAELAB = .T.
			ENDIF



ENDCASE

SELECT(_SAVESEL)

RETURN(_DAELAB)



***********************************************************************
* Funzione - VERYCF_SIMILCEE Data: 18/12/2021 Autore: Sergio by Project
***********************************************************************
*
*   GESTIONE GRUPPI CLIENTI/FORNITORI SOLO PER CONTI CONTABILI DEL 
*   PIANO DEI CONTI A 5 LIVELLI SIMILCEE
*
*   RICONOSCE SE CLIENTE / FORNITORE ATTRAVERSO I PARAMETRI :
*	- GEN01		:	GENERALE
*   - GENIT		:	SE GRUPPO NAZIONE ITALIA
*	- GENCE		:	SE GRUPPO CEE
*	- GENEX		:	SE GRUPPO EXTRA CEE
*
*	- PARAMETRI : _MASTRO = SOTTOGRUPPO DA VERIFICARE
*				: _CLFO	  = "CF"  SE DEVE CONTROLLARE SIA IL MASTRO CLI CHE FOR	
*				: _CLFO	  = "CL"  SE DEVE CONTROLLARE SOLO IL MASTRO CLIENTE
*				: _CLFO	  = "FO"  SE DEVE CONTROLLARE SOLO IL MASTRO FORNITORE
*

FUNCTION VERYCF_SIMILCEE
PARA _MASTRO,_CLFO

_SAVESELXX = SELECT()

PUB_CC  =''
PUB_FF  =''
PUB_CCIT=''
PUB_FFIT=''
PUB_CCCE=''
PUB_FFCE=''
PUB_CCEX=''
PUB_FFEX=''

_DAELAB = .F.

* == >>> ACCESSO AL PARAMETRO GENERALE
*1.2.1.      CLI  3.1.1.      FOR     
TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GEN'+?pub_codsoc
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() > 0
   PUB_CC=ALLTRIM(SUBSTR(LIBERA,1,10))
   PUB_FF=ALLTRIM(SUBSTR(LIBERA,18,10))
ELSE
   =MESSAGEBOX("PARAMETRO 'GEN01' NON TROVATO",16,"ATTENZIONE")
   PUB_ER=.T.
   SELECT(_SAVESELXX)
   RETURN(PUB_ER)
ENDIF

* == >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONE ITALIA
TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENIT'
ENDTEXT

IF !ExecCommand(cSql,"para")
   return(.f.)
ENDIF

SELECT PARA
IF reccount() > 0
      PUB_CCIT=ALLTRIM(SUBSTR(LIBERA,1,10))
      PUB_FFIT=ALLTRIM(SUBSTR(LIBERA,18,10))
ENDIF

* == >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONI CEE
TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENCE'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() > 0
      PUB_CCCE=ALLTRIM(SUBSTR(LIBERA,1,10))
      PUB_FFCE=ALLTRIM(SUBSTR(LIBERA,18,10))
ENDIF

* === >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONI EXTRA CEE
TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENEX'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() > 0
      PUB_CCEX=ALLTRIM(SUBSTR(LIBERA,1,10))
      PUB_FFEX=ALLTRIM(SUBSTR(LIBERA,18,10))
ENDIF


* === >>> VERIFICA
_DAELAB = .F.

LEN_PUB_CC 		= LEN(ALLTRIM(PUB_CC))
LEN_PUB_FF 		= LEN(ALLTRIM(PUB_FF))
LEN_PUB_CCIT 	= LEN(ALLTRIM(PUB_CCIT))
LEN_PUB_FFIT	= LEN(ALLTRIM(PUB_FFIT))
LEN_PUB_CCCE	= LEN(ALLTRIM(PUB_CCCE))
LEN_PUB_FFCE	= LEN(ALLTRIM(PUB_FFCE))
LEN_PUB_CCEX	= LEN(ALLTRIM(PUB_CCEX))
LEN_PUB_FFEX	= LEN(ALLTRIM(PUB_FFEX))


DO CASE
	CASE _CLFO = "CF"

			IF SUBSTR(_MASTRO,1,LEN_PUB_CC) = PUB_CC
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_FF) = PUB_FF
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_CCIT) = PUB_CCIT
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_FFIT) = PUB_FFIT
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_CCCE) = PUB_CCCE
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_FFCE) = PUB_FFCE
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_CCEX) = PUB_CCEX
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_FFEX) = PUB_FFEX
			   _DAELAB = .T.
			ENDIF


	CASE _CLFO = "CL"


			IF SUBSTR(_MASTRO,1,LEN_PUB_CC) = PUB_CC
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_CCIT) = PUB_CCIT
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_CCCE) = PUB_CCCE
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_CCEX) = PUB_CCEX
			   _DAELAB = .T.
			ENDIF




	CASE _CLFO = "FO"	



			IF SUBSTR(_MASTRO,1,LEN_PUB_FF) = PUB_FF
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_FFIT) = PUB_FFIT
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_FFCE) = PUB_FFCE
			   _DAELAB = .T.
			ENDIF

			IF SUBSTR(_MASTRO,1,LEN_PUB_FFEX) = PUB_FFEX
			   _DAELAB = .T.
			ENDIF






ENDCASE

SELECT(_SAVESELXX)

RETURN(_DAELAB)



************************************************************************************
* Funzione - Parametri_generali_mastri Data: 02/12/2012   Autore: Fabiano by Project
************************************************************************************
*
*   ACCEDO A PARA PER OTTENERE PUB_CC, PUB_FF, PUB_CCIT, PUB_FFIT, PUB_CCCE, PUB_FFCE, PUB_CCEX, PUB_FFEX

FUNCTION PARAMETRI_GENERALI_MASTRI


_SAVESEL = SELECT()

PUB_CC  =''
PUB_FF  =''
PUB_CCIT=''
PUB_FFIT=''
PUB_CCCE=''
PUB_FFCE=''
PUB_CCEX=''
PUB_FFEX=''

_DAELAB = .F.


TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GEN'+?pub_codsoc
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

* == >>> ACCESSO AL PARAMETRO GENERALE
SELECT PARA

** SERGIO 18/12/2021 INIZIO   
IF PUB_CONTOSIMILCEE 

	IF reccount() > 0
	   PUB_CC=SUBSTR(LIBERA,1,PUB_GRUPPOCF)
	   PUB_FF=SUBSTR(LIBERA,18,PUB_GRUPPOCF)
	ELSE
	   =MESSAGEBOX("PARAMETRO 'GEN01' NON TROVATO",16,"ATTENZIONE")
	   PUB_ER=.T.
	   SELECT(_SAVESEL)
	   RETURN(PUB_ER)
	ENDIF
  
ELSE

	IF reccount() > 0
	   PUB_CC=SUBSTR(LIBERA,1,pub_sottog-1)
	   PUB_FF=SUBSTR(LIBERA,18,pub_sottog-1)
	ELSE
	   =MESSAGEBOX("PARAMETRO 'GEN01' NON TROVATO",16,"ATTENZIONE")
	   PUB_ER=.T.
	   SELECT(_SAVESEL)
	   RETURN(PUB_ER)
	ENDIF

	      
ENDIF
** SERGIO 18/12/2021 FINE


* == >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONE ITALIA

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENIT'
ENDTEXT

IF !ExecCommand(cSql,"para")
   return(.f.)
ENDIF

SELECT PARA

** SERGIO 18/12/2021 INIZIO   
IF PUB_CONTOSIMILCEE 

	IF reccount() > 0
	      PUB_CCIT=SUBSTR(LIBERA,1,PUB_GRUPPOCF)
	      PUB_FFIT=SUBSTR(LIBERA,18,PUB_GRUPPOCF)
	ENDIF
  
ELSE

	IF reccount() > 0
	      PUB_CCIT=SUBSTR(LIBERA,1,pub_sottog-1)
	      PUB_FFIT=SUBSTR(LIBERA,18,pub_sottog-1)
	ENDIF

	      
ENDIF
** SERGIO 18/12/2021 FINE

* == >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONI CEE

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENCE'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA


** SERGIO 18/12/2021 INIZIO   
IF PUB_CONTOSIMILCEE 

	IF reccount() > 0
	      PUB_CCCE=SUBSTR(LIBERA,1,PUB_GRUPPOCF)
	      PUB_FFCE=SUBSTR(LIBERA,18,PUB_GRUPPOCF)
	ENDIF
  
ELSE

	IF reccount() > 0
	      PUB_CCCE=SUBSTR(LIBERA,1,pub_sottog-1)
	      PUB_FFCE=SUBSTR(LIBERA,18,pub_sottog-1)
	ENDIF

	      
ENDIF
** SERGIO 18/12/2021 FINE

* === >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONI EXTRA CEE

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENEX'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA

** SERGIO 18/12/2021 INIZIO   
IF PUB_CONTOSIMILCEE 

	IF reccount() > 0
	      PUB_CCEX=SUBSTR(LIBERA,1,PUB_GRUPPOCF)
	      PUB_FFEX=SUBSTR(LIBERA,18,PUB_GRUPPOCF)
	ENDIF
  
ELSE

	IF reccount() > 0
	      PUB_CCEX=SUBSTR(LIBERA,1,pub_sottog-1)
	      PUB_FFEX=SUBSTR(LIBERA,18,pub_sottog-1)
	ENDIF

	      
ENDIF
** SERGIO 18/12/2021 FINE

SELECT(_SAVESEL)


RETURN

***********************************************************************
* Funzione - TRASGG     Data: 12.03.97   Autore: Project S.r.L.
***********************************************************************
*
*  Consente di convertire una data in giorni
*  parametri da passare:
*  "AMG"  se la data è in formato AAAA/MM/GG
*  "GMA"  se la data è in formato GG/MM/AAAA
*  _DATA1  variavile contenente la data
*
*  sintassi:
*  TRASGG("AMG",_DATA1)
**************************
FUNCTION TRASGG
**************************
PARAMETER _TIPO,_DATA1
_GIORNI=0
*!*	IF _TIPO="AMG"
*!*	  IF SUBSTR(_DATA1,3,1)="/"
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,2)) * 360)
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,4,2)) * 30)
*!*	    IF VAL(SUBSTR(_DATA1,7,2)) > 30
*!*	      _GIORNI=_GIORNI+30
*!*	    ELSE
*!*	      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,7,2)))
*!*	    ENDIF
*!*	  ELSE
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,4)) * 360)
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,6,2)) * 30)
*!*	    IF VAL(SUBSTR(_DATA1,9,2)) > 30
*!*	      _GIORNI=_GIORNI+30
*!*	    ELSE
*!*	      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,9,2)))
*!*	    ENDIF
*!*	  ENDIF
*!*	ELSE
*!*	  IF SUBSTR(_DATA1,7,3)=" "
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,7,2)) * 360)
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,4,2)) * 30)
*!*	    IF VAL(SUBSTR(_DATA1,1,2)) > 30
*!*	      _GIORNI=_GIORNI+30
*!*	    ELSE
*!*	      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,2)))
*!*	    ENDIF
*!*	  ELSE
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,7,4)) * 360)
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,4,2)) * 30)
*!*	    IF VAL(SUBSTR(_DATA1,1,2)) > 30
*!*	      _GIORNI=_GIORNI+30
*!*	    ELSE
*!*	      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,2)))
*!*	    ENDIF
*!*	  ENDIF
*!*	ENDIF

IF _TIPO="AMG"
  IF SUBSTR(_DATA1,3,1)="/"
    _GIORNI=CTOD(_DATA1)-CTOD("01/01/1900")
  ELSE
    _GIORNI=CTOD(RIBALTA2(_DATA1))-CTOD("01/01/1900")
  ENDIF
ELSE
  IF SUBSTR(_DATA1,5,1)="/"
  	_GIORNI=CTOD(RIBALTA2(_DATA1))-CTOD("01/01/1900")
  ELSE
  	_GIORNI=CTOD(_DATA1)-CTOD("01/01/1900")
  ENDIF
ENDIF


RETURN(_GIORNI)

****************************************
FUNCTION CALCOLA_GIORNI_MESI_ESPOSIZIONE
****************************************
* CALCOLA SIA I GIORNI CHE I MESI DI ESPOSIZIONE
* SE TIPO_AGG = GG : AGGIORNA IL CAMPO DEL CURSORE RIPORTANDO I GIORNI
* SE TIPO_AGG = MM : AGGIORNA IL CAMPO DEL CURSORE RIPORTANDO I MESI
LPARAMETERS _CURSORE,_DATAA,_CAMPO_AGG,_TIPO_AGG

LOCAL __GGOGGI,__GGIERI,__GGESPO,__NUMERO_ANNI,__NUMERO_MESI 

__GGOGGI = TRASGG("GMA",_DATAA)

SELECT &_CURSORE
SCAN

	_DATADAL = RIBALTA2(ORD_DATORD)
	__GGIERI = TRASGG("GMA",_DATADAL)
	__GGESPO = __GGOGGI - __GGIERI   	

	__NUMERO_ANNI = __GGESPO / 365		&& NUMERO ANNI
	__NUMERO_MESI = __NUMERO_ANNI * 12	&& NUMERO MESI
	
	DO CASE
		CASE _TIPO_AGG = "GG"			&& RIPORTA I GIORNI
			REPLACE &_CAMPO_AGG	WITH __GGESPO 
		CASE _TIPO_AGG = "MM"			&& RIPORTA I MESI 
			REPLACE &_CAMPO_AGG	WITH __NUMERO_MESI 
	ENDCASE
	

ENDSCAN

RETURN



***************************************************************************
FUNCTION DEFPUB
***************************************************************************
* CREA VARIABILI PUBBLICHE DA UN DBF
* PASSARE LA SELECT IN CUI E' APERTO IL DBF

PARA _SELECT

Select(_SELECT)
_TotFields=afields(_NameFields)
for _x=1 to _TotFields
   _temp="M."+_NameFields[_x,1]
   release &_temp
   public &_temp
next


***************************************************************************
FUNCTION RELPUB
***************************************************************************
* RILASCIA VARIABILI PUBBLICHE CREATE DA UN DBF
* PASSARE LA SELECT IN CUI E' APERTO IL DBF

PARA _SELECT

Select(_SELECT)
_TotFields=afields(_NameFields)
for _x=1 to _TotFields
   _temp="M."+_NameFields[_x,1]
   release &_temp
next



************************************************************************
* Funzione - GETINTER                Data: 28.11.98   Autore: Project
************************************************************************
* La seguente funzione permette di editare in una finestra il contenuto
* di una variabile già definita ed inizializzata.
* La sintassi ed i parametri sono i seguenti:
*
* <ExpL> =GETINTER(<ExpC1>,<ExpC2>,<ExpC3>[,<ExpN1>,<ExpN2>])
*
* <ExpC1> E' una descrizione che compare davanti al campo da editare.
* <ExpC2> E' il nome di una variabile di tipo C N D L già definita ed
*         inizializzata (periodo da).
* <ExpC3> E' il nome di una variabile di tipo C N D L già definita ed
*         inizializzata (periodo a).
*
* <ExpN1> Richiesto solo se la variabile è di tipo numerico; rappresenta
*         la lunghezza totale del campo.
* <ExpN2> Richiesto solo se la variabile è di tipo numerico; rappresenta
*         il numero dei decimali.
*
* <ExpL>  La funzione ritorna il valore .T. se il contenuto della
*         variabile e' stato modificato, .F. in caso contrario.
*
* Esempio programma:
*   -->> se data
*   -------------
*	PUBLIC X_DAL,X_AL	
*	X_DAL=CTOD("")
*	V_AL =CTOD("")
*	IF !GETINTER("Fatture del periodo","X_DAL","X_AL")
*	   RETURN
*	ENDIF
*	X_DAL=DTOC(X_DAL)
*	X_AL =DTOC(X_AL)
*	
*   -->> se carattere
*   -------------
*	PUBLIC X_DAL,X_AL	
*	X_DAL=SPACE(10)
*	V_AL =SPACE(10)
*	IF !GETINTER("Ricerca per codice","X_DAL","X_AL")
*	   RETURN
*	ENDIF
*	
*	
*   -->> se numerico
*   -------------
*	PUBLIC X_DAL,X_AL	
*	X_DAL=0
*	V_AL =0
*	IF !GETINTER("Ricerca per codice","X_DAL","X_AL",15,3)
*	   RETURN
*	ENDIF
*	
************************************************************************
FUNCTION GETINTER
PARAMETERS V_DESC,V_VAR1,V_VAR2,V_LUNG,V_DECI
V_TIP1=TYPE("&V_VAR1")
V_TIP2=TYPE("&V_VAR2")
IF V_TIP1="U"
   =MESSAGEBOX("VARIABILE &V_VAR1 NON DEFINITA",16,"ERRORE: INPUTBOX !")
   RETURN(.F.)
ENDIF
IF V_TIP1="M"
   =MESSAGEBOX("VARIABILE MEMO NON SUPPORTATA !",16,"ERRORE: INPUTBOX !")
   RETURN(.F.)
ENDIF
IF PARAMETERS() < 4 AND V_TIP1="N"
   =MESSAGEBOX("PARAMETRI INSUFFICIENTI;PER VARIABILE NUMERICA !",16,"ERRORE: INPUTBOX !")
   RETURN(.F.)
ENDIF

IF V_TIP2="U"
   =MESSAGEBOX("VARIABILE &V_VAR2 NON DEFINITA",16,"ERRORE: INPUTBOX !")
   RETURN(.F.)
ENDIF
IF V_TIP2="M"
   =MESSAGEBOX("VARIABILE MEMO NON SUPPORTATA !",16,"ERRORE: INPUTBOX !")
   RETURN(.F.)
ENDIF

V_GET1=&V_VAR1
V_GET2=&V_VAR2

SET DATE TO GERMAN
DO CASE
   CASE V_TIP1="C"
     V_LUNG=LEN(&V_VAR1)
     V_DECI=0
     W_PICT=REPLICATE("X",V_LUNG)
   CASE V_TIP1="N"
     IF V_DECI > 0
        W_PICT=REPLICATE("9",V_LUNG-V_DECI-1)+'.'+REPLICATE("9",V_DECI)
     ELSE
        W_PICT=REPLICATE("9",V_LUNG)
     ENDIF
   CASE V_TIP1="D"
     W_PICT="@D"
     V_LUNG=10
     V_DECI=0
   CASE V_TIP1="L"
     W_PICT="Y"
     V_LUNG=1
     V_DECI=0
ENDCASE
V_DAL="  Dal"
V_AL ="  Al "
W_LARG=LEN(V_DESC+V_DAL)+V_LUNG+6
IF W_LARG<20
   W_LARG=20
ENDIF
DEFINE WINDOW _r7p0zbngr ;
	AT  0.000, 0.000  ;
	SIZE 7.0,W_LARG ;
	FONT "Courier New", 10 ;
	FLOAT ;
	NOCLOSE ;
	NOMINIMIZE ;
	SYSTEM ;
	HALFHEIGHT ;
	COLOR RGB(,,,192,192,192) ;
	ICON FILE "c:\aquarius\ico\2_aquarius.ico" 
MOVE WINDOW _r7p0zbngr CENTER
ACTIVATE WINDOW _r7p0zbngr SAME

* -->> SCRITTA DESCRITTIVA 1
@ 0.913,2.800 SAY V_DESC+V_DAL ;
	FONT "Courier New", 10 ;
	STYLE "B" ;
	COLOR RGB(255,0,0,192,192,192)
	
* -->> CAMPO DI GET 1
@ 0.913,2.800+LEN(V_DESC+V_DAL)+1 GET V_GET1 ;
	SIZE 1.000,V_LUNG ;
	DEFAULT " " ;
	FONT "Courier New", 10 ;
	STYLE "B" ;
	PICTURE W_PICT ;
	COLOR ,RGB(255,255,255,0,0,125)


* -->> SCRITTA DESCRITTIVA 2
@ 2.413,2.800+LEN(V_DESC) SAY V_AL ;
	FONT "Courier New", 10 ;
	STYLE "B" ;
	COLOR RGB(255,0,0,192,192,192)

	* -->> CAMPO DI GET 2
@ 2.413,2.800+LEN(V_DESC+V_AL)+1 GET V_GET2 ;
	SIZE 1.000,V_LUNG ;
	DEFAULT " " ;
	FONT "Courier New", 10 ;
	STYLE "B" ;
	PICTURE W_PICT ;
	COLOR ,RGB(255,255,255,0,0,125)

* -->> TASTI
@ 4.692,(W_LARG-17.5)/2 GET BT ;
	PICTURE "@*HT Ok;Annulla" ;
	SIZE 1.769,11.667,0.667 ;
	DEFAULT 1 ;
	FONT "MS Sans Serif", 8 ;
	STYLE "B"
	
READ CYCLE MODAL
RELEASE WINDOW _r7p0zbngr
IF LASTKEY()=27 OR BT=2
   RETURN(.F.)
ENDIF
&V_VAR1=V_GET1
&V_VAR2=V_GET2
RETURN(.T.)
*EOF Function: GETINTER


************************************************************************
* Funzione - GETDATA                  Data: 25/08/2015   Autore: Project
************************************************************************
* La seguente funzione permette di editare in una finestra il contenuto
* di una variabile già definita ed inizializzata.
* La sintassi ed i parametri sono i seguenti:
*
* <ExpL> =GETDATA(<ExpC1>,[,<ExpN1>,<ExpN2>])
*
* <ExpC1> E' una descrizione che compare davanti al campo da editare.
*
* <ExpN1> Richiesto solo se la variabile è di tipo numerico; rappresenta
*         la lunghezza totale del campo.
* <ExpN2> Richiesto solo se la variabile è di tipo numerico; rappresenta
*         il numero dei decimali.
*
* <ExpL>  La funzione ritorna il valore .T. se il contenuto della
*         variabile e' stato modificato, .F. in caso contrario.
*
* Esempio programma:
*   -->> se data
*   -------------
*	PUBLIC X_DAL,X_AL	
*	X_DAL=CTOD("")
*	IF !GETDATA("Data collaudo","X_DAL")
*	   RETURN
*	ENDIF
*	X_DAL=DTOC(X_DAL)
*	
*   -->> se carattere
*   -------------
*	PUBLIC X_DAL	
*	X_DAL=SPACE(10)
*	IF !GETDATA("Ricerca per codice","X_DAL")
*	   RETURN
*	ENDIF
*	
*	
*   -->> se numerico
*   -------------
*	PUBLIC X_DAL
*	X_DAL=0
*	IF !GETDATA("Ricerca per codice","X_DAL",15,3)
*	   RETURN
*	ENDIF
*	
************************************************************************
FUNCTION GETDATA
PARAMETERS V_DESC,V_VAR1,V_LUNG,V_DECI
V_TIP1=TYPE("&V_VAR1")
IF V_TIP1="U"
   =MESSAGEBOX("VARIABILE &V_VAR1 NON DEFINITA",16,"ERRORE: GETDATA !")
   RETURN(.F.)
ENDIF
IF V_TIP1="M"
   =MESSAGEBOX("VARIABILE MEMO NON SUPPORTATA !",16,"ERRORE: GETDATA !")
   RETURN(.F.)
ENDIF
IF PARAMETERS() < 2 AND V_TIP1="N"
   =MESSAGEBOX("PARAMETRI INSUFFICIENTI;PER VARIABILE NUMERICA !",16,"ERRORE: GETDATA !")
   RETURN(.F.)
ENDIF

 	

V_GET1=&V_VAR1

SET DATE TO GERMAN
DO CASE
   CASE V_TIP1="C"
     V_LUNG=LEN(&V_VAR1)
     V_DECI=0
     W_PICT=REPLICATE("X",V_LUNG)
   CASE V_TIP1="N"
     IF V_DECI > 0
        W_PICT=REPLICATE("9",V_LUNG-V_DECI-1)+'.'+REPLICATE("9",V_DECI)
     ELSE
        W_PICT=REPLICATE("9",V_LUNG)
     ENDIF
   CASE V_TIP1="D"
     W_PICT="@D"
     V_LUNG=10
     V_DECI=0
   CASE V_TIP1="L"
     W_PICT="Y"
     V_LUNG=1
     V_DECI=0
ENDCASE
V_DAL="     "
W_LARG=LEN(V_DESC+V_DAL)+V_LUNG+6
IF W_LARG<20
   W_LARG=20
ENDIF
DEFINE WINDOW _r7p0zbngr ;
	AT  0.000, 0.000  ;
	SIZE 7.0,W_LARG ;
	FONT "Courier New", 10 ;
	FLOAT ;
	NOCLOSE ;
	NOMINIMIZE ;
	SYSTEM ;
	HALFHEIGHT ;
	COLOR RGB(,,,192,192,192) ;
	ICON FILE "c:\aquarius\ico\2_aquarius.ico" 
MOVE WINDOW _r7p0zbngr CENTER
ACTIVATE WINDOW _r7p0zbngr SAME

* -->> SCRITTA DESCRITTIVA 1
@ 0.913,2.800 SAY V_DESC+V_DAL ;
	FONT "Courier New", 10 ;
	STYLE "B" ;
	COLOR RGB(255,0,0,192,192,192)
	
* -->> CAMPO DI GET 1
@ 0.913,2.800+LEN(V_DESC+V_DAL)+1 GET V_GET1 ;
	SIZE 1.000,V_LUNG ;
	DEFAULT " " ;
	FONT "Courier New", 10 ;
	STYLE "B" ;
	PICTURE W_PICT ;
	COLOR ,RGB(255,255,255,0,0,125)

* -->> TASTI
@ 4.692,(W_LARG-17.5)/2 GET BT ;
	PICTURE "@*HT Ok;Termina" ;
	SIZE 1.769,11.667,0.667 ;
	DEFAULT 1 ;
	FONT "MS Sans Serif", 8 ;
	STYLE "B"
	
READ CYCLE MODAL
RELEASE WINDOW _r7p0zbngr
IF LASTKEY()=27 OR BT=2
   RETURN(.F.)
ENDIF
&V_VAR1=V_GET1
RETURN(.T.)
*EOF Function: GETDATA

************************************************************************
* Funzione - INPUTBOX                Data: 06.02.96   Autore: Project
************************************************************************
* La seguente funzione permette di editare in una finestra il contenuto
* di una variabile già definita ed inizializzata.
* La sintassi ed i parametri sono i seguenti:
*
* <ExpL> =INPUTBOX(<ExpC1>,<ExpC2>[,<ExpN1>,<ExpN2>])
*
* <ExpC1> E' una descrizione che compare davanti al campo da editare.
* <ExpC2> E' il nome di una variabile di tipo C N D L già definita ed
*         inizializzata.
*
* <ExpN1> Richiesto solo se la variabile è di tipo numerico; rappresenta
*         la lunghezza totale del campo.
* <ExpN2> Richiesto solo se la variabile è di tipo numerico; rappresenta
*         il numero dei decimali.
*
* <ExpL>  La funzione ritorna il valore .T. se il contenuto della
*         variabile e' stato modificato, .F. in caso contrario.
*
FUNCTION INPUTBOX
PARAMETERS V_DESC,V_VARI,V_LUNG,V_DECI
V_TIPO=TYPE("&V_VARI")
IF V_TIPO="U"
   =MESSAGEBOX("VARIABILE &V_VARI NON DEFINITA",16,"ERRORE: INPUTBOX !")
   RETURN(.F.)
ENDIF
IF V_TIPO="M"
   =MESSAGEBOX("VARIABILE MEMO NON SUPPORTATA !",16,"ERRORE: INPUTBOX !")
   RETURN(.F.)
ENDIF
IF PARAMETERS() < 4 AND V_TIPO="N"
   =MESSAGEBOX("PARAMETRI INSUFFICIENTI;PER VARIABILE NUMERICA !",16,"ERRORE: INPUTBOX !")
   RETURN(.F.)
ENDIF
V_GET=&V_VARI
SET DATE TO GERMAN
DO CASE
   CASE V_TIPO="C"
     V_LUNG=LEN(&V_VARI)
     V_DECI=0
     W_PICT=REPLICATE("X",V_LUNG)
   CASE V_TIPO="N"
     IF V_DECI > 0
        W_PICT=REPLICATE("9",V_LUNG-V_DECI-1)+'.'+REPLICATE("9",V_DECI)
     ELSE
        W_PICT=REPLICATE("9",V_LUNG)
     ENDIF
   CASE V_TIPO="D"
     W_PICT="@D"
     V_LUNG=10
     V_DECI=0
   CASE V_TIPO="L"
     W_PICT="Y"
     V_LUNG=1
     V_DECI=0
ENDCASE
W_LARG=LEN(V_DESC)+V_LUNG+6
IF W_LARG<20
   W_LARG=20
ENDIF
DEFINE WINDOW _r7p0zbngr ;
	AT  0.000, 0.000  ;
	SIZE 4.5,W_LARG ;
	FONT "Courier New", 10 ;
	FLOAT ;
	NOCLOSE ;
	NOMINIMIZE ;
	SYSTEM ;
	HALFHEIGHT ;
	COLOR RGB(,,,192,192,192)
MOVE WINDOW _r7p0zbngr CENTER
ACTIVATE WINDOW _r7p0zbngr SAME
* -->> SCRITTA DESCRITTIVA
@ 0.846,2.800 SAY V_DESC ;
	FONT "Courier New", 10 ;
	STYLE "B" ;
	COLOR RGB(255,0,0,192,192,192)
	
* -->> CAMPO DI GET
@ 0.923,2.800+LEN(V_DESC)+1 GET V_GET ;
	SIZE 1.000,V_LUNG ;
	DEFAULT " " ;
	FONT "Courier New", 10 ;
	STYLE "B" ;
	PICTURE W_PICT ;
	COLOR ,RGB(255,255,255,0,0,125)
	
* -->> TASTI
@ 2.692,(W_LARG-17.5)/2 GET BT ;
	PICTURE "@*HT Ok;Annulla" ;
	SIZE 1.769,11.667,0.667 ;
	DEFAULT 1 ;
	FONT "MS Sans Serif", 8 ;
	STYLE "B"
	
READ CYCLE MODAL
RELEASE WINDOW _r7p0zbngr
IF LASTKEY()=27 OR BT=2
   RETURN(.F.)
ENDIF
&V_VARI=V_GET
RETURN(.T.)
*EOF Function: INPUTBOX


**************************************************************************
* Funzione - TEMPO     Data: 04.12.98    Autore: Project S.r.l.
**************************************************************************
* Consente di determinare il tempo in ore,minuti e secondi intercorsi tra
* due date e due ore.
* Parametri da passare :
* _TEMPAS variabile contenente il tempo precedente da sommare al nuovo tempo
* _DATA1  variabile contenente la data di inizio  nel formato GG/MM/AAAA
* _ORA1   variabile contenente l'orario di inizio nel formato HH:MM:SS
* _DATA2  variabile contenente la data di fine    nel formato GG/MM/AAAA
* _ORA2   variabile contenente l'orario di fine   nel formato HH:MM:SS
*
* sintassi :
* TEMPO(_TEMPAS,_DATA1,_ORA1,_DATA2,_ORA2)
*
**********************
FUNCTION TEMPO
**********************

PARAMETERS _TEMPAS,_DATA1,_ORA1,_DATA2,_ORA2

_TEMPO = "00000:00:00"



IF _TEMPAS = SPACE(09) .OR. _TEMPAS = '   :  :  '
   _TEMPAS = '00000:00:00'
ENDIF
_HHPAS = VAL(SUBSTR(_TEMPAS,1,3))
_MMPAS = VAL(SUBSTR(_TEMPAS,5,2))
_SSPAS = VAL(SUBSTR(_TEMPAS,8,2))

_N_SECPAS = (_HHPAS * 3600) + (_MMPAS * 60) + _SSPAS

_DT_INI = CTOT(_DATA1 + " " + _ORA1)
_DT_FIN = CTOT(_DATA2 + " " + _ORA2)

_N_SECTOT = (_DT_FIN - _DT_INI) + _N_SECPAS

_HHCAL    = INT(_N_SECTOT/3600)
_N_SECTOT = _N_SECTOT - (_HHCAL * 3600)
_MMCAL    = INT(_N_SECTOT/60)
_N_SECTOT = _N_SECTOT - (_MMCAL * 60)
_SSCAL    = _N_SECTOT

_TEMPO = TRC(3,STR(_HHCAL,3,0)) + ":" + TRC(2,STR(_MMCAL,2,0)) + ":" + TRC(2,STR(_SSCAL,2,0))

**=> ERASMO - FINE 20/04/2006

RETURN(_TEMPO)


**************************************************************************
* Funzione - CALCOLAORA Data: 21.06.2004    Autore: Project S.r.l.
**************************************************************************
* Consente di determinare il nuovo orario con un orario iniziale (hh:mm:ss)
* ed un numero di ore,minuti hh:mm
* Parametri da passare :
* _ORAINI variabile contenente l'orario iniziale
* _ORELAV variabile contenente il numero di ore lavorate
*
* sintassi :
* CALCOLAORA(_ORAINI,_ORELAV)
*
**********************
FUNCTION CALCOLAORA
**********************

PARAMETERS _ORAINI,_ORELAV

_ORAFIN = _ORAINI

_HHINI = VAL(SUBSTR(_ORAINI,1,2))
_MMINI = VAL(SUBSTR(_ORAINI,4,2))
_SSINI = VAL(SUBSTR(_ORAINI,7,2))

_HHLAV = INT(_ORELAV)
_MMLAV = ROUND((_ORELAV - _HHLAV),2) * 100
_MMLAV = INT((30 * _MMLAV) / 50)

_HHFIN = _HHINI + _HHLAV
_MMFIN = _MMINI + _MMLAV
IF _MMFIN > 60
   _MMFIN = _MMFIN - 60
   _HHFIN = _HHFIN + 1
ENDIF
IF _HHFIN > 24
   _HHFIN = 24 - _HHFIN
ENDIF  

_HHFINX = ALLTRIM(STR(_HHFIN,2,0))
IF _HHFIN > 9
ELSE
   _HHFINX = '0' + _HHFINX
ENDIF
_MMFINX = ALLTRIM(STR(_MMFIN,2,0))
IF _MMFIN > 9
ELSE
   _MMFINX = '0' + _MMFINX
ENDIF
_SSFINX = '00'

_ORAFIN = _HHFINX + ":" + _MMFINX + ":" + _SSFINX 

RETURN(_ORAFIN)

**************************************************************************
* Funzione - GETTESTO     Data: 28.04.99    Autore: PROJECT S.R.L.
**************************************************************************
FUNCTION GETTESTO
PARAMETERS _TIPODOC,_INTPIE

_SAVESEL = SELECT()

x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
Csql   = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
IF !ExecCommand(cSql,"u_azi_an")
   return(.f.)
ENDIF
SELECT u_azi_an
GO TOP

DO CASE

  CASE _TIPODOC="OFF" .AND. _INTPIE="INT"
    _TESTO=AZI_INTOFF
  CASE _TIPODOC="OFF" .AND. _INTPIE="PIE"
    _TESTO=AZI_PIEOFF

  CASE _TIPODOC="ORD" .AND. _INTPIE="INT"
    _TESTO=AZI_INTORD
  CASE _TIPODOC="ORD" .AND. _INTPIE="PIE"
    _TESTO=AZI_PIEORD

  CASE _TIPODOC="ORF" .AND. _INTPIE="INT"
    _TESTO=AZI_INTORF
  CASE _TIPODOC="ORF" .AND. _INTPIE="PIE"
    _TESTO=AZI_PIEORF

  CASE _TIPODOC="BOL" .AND. _INTPIE="INT"
    _TESTO=AZI_INTBOL
  CASE _TIPODOC="BOL" .AND. _INTPIE="PIE"
    _TESTO=AZI_PIEBOL

  CASE _TIPODOC="FAP" .AND. _INTPIE="INT"
    _TESTO=AZI_INTFAP
  CASE _TIPODOC="FAP" .AND. _INTPIE="PIE"
    _TESTO=AZI_PIEFAP

  CASE _TIPODOC="FAT" .AND. _INTPIE="INT"
    _TESTO=AZI_INTFAT
  CASE _TIPODOC="FAT" .AND. _INTPIE="PIE"
    _TESTO=AZI_PIEFAT

  OTHERWISE
    _TESTO="FUNZIONE GETTESTO: PARAMETRI NON CORRETTI"

ENDCASE

SELECT(_SAVESEL)

RETURN(_TESTO)


**************************************************************************
* Funzione - PJPREPARA  Data: 17.04.99   Autore: Project S.r.l.
**************************************************************************
*
*  INSERISCE IL VALORE DI UN CAMPO IN UNA DETERMINATA POSIZIONE DEL RECORD
*  DA STAMPARE TRAMITE LO SPOOL (STAMPA IN FORMATO TESTO)
*  PARAMETRI DA PASSARE
*  _PAGINA  = NUMERO DELLA PAGINA
*  _RIGA    = NUMERO DELLA RIGA
*  _COLONNA = NUMERO DELLA COLONNA
*  _CAMPO   = IL CONTENUTO DEL CAMPO DA STAMPARE
*  _LENCAMPO= LA LUNGHEZZA DEL CAMPO DA STAMPARE
*
*  sintassi:
*  DO PJPREPARA WITH V_PAGINA,V_RIGA,V_COLONNA,V_CAMPO,V_LENCAMPO
**************************
FUNCTION PJPREPARA
**************************
PARA _PAGINA,_RIGA,_COLONNA,_CAMPO,_LENCAMPO

_ZZXX = SELECT()

SELECT FILE_STA
SET ORDER TO FILE_IND
GO TOP

_PAG = STR(_PAGINA,4,0)
_RIG = STR(_RIGA,3,0)

SEEK _PAG + _RIG

IF FOUND()
ELSE
   APPEND BLANK
   REPLACE STA_PAGINA WITH _PAGINA
   REPLACE STA_RIGA   WITH _RIGA
   REPLACE STA_RECORD WITH SPACE(160)
ENDIF

V_INIZIO = _COLONNA - 1
V_MEZZO  = _COLONNA +_LENCAMPO
V_FINE   = 200 - V_MEZZO + 1

IF V_INIZIO = 0
   V_RECORD = _CAMPO + SUBSTR(STA_RECORD,V_MEZZO,V_FINE)
ELSE
   V_RECORD = SUBSTR(STA_RECORD,1,V_INIZIO) + _CAMPO + SUBSTR(STA_RECORD,V_MEZZO,V_FINE)
ENDIF

REPLACE STA_RECORD WITH V_RECORD

SELECT(_ZZXX)

RETURN


***************************************************************************
* Funzione - PJCOMPLETA  Data: 17.04.99   Autore: Project S.r.l.
***************************************************************************
*
*  INSERISCE TANTE RIGHE BIANCHE, QUANTE SONO QUELLE CHE NECESSITANO PER
*  COMPLETARE UNA PAGINA DI STAMPA, INOLTRE CONTROLLA ED EVENTUAMENTE
*  INSERISCE RIGHE BIANCHE ALL'INTERNO DEL TESTO DOVE NECESSITA.
*  PARAMETRI DA PASSARE
*  _TOTRIG  = NUMERO TOTALE DI RIGHE PRESENTI SU UNA PAGINA
*
*  sintassi:
*  DO PJCOMPLETA WITH V_TOTRIG
**************************
FUNCTION PJCOMPLETA
**************************
PARA _TOTRIG

V_PAGINA = 1
V_RIGA   = 0

SELECT FILE_STA
SET ORDER TO FILE_IND
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF STA_PAGINA = V_PAGINA
      IF STA_RIGA = V_RIGA
         SKIP +1
         LOOP
      ENDIF
   ENDIF

   IF STA_PAGINA = V_PAGINA
      V_DIFRIGA = STA_RIGA - V_RIGA
      IF V_DIFRIGA = 1
         V_RIGA = STA_RIGA
         SKIP +1
         LOOP
      ENDIF
   ENDIF

   IF STA_PAGINA = V_PAGINA
      SAVE_RIGA = STA_RIGA
      DO WHILE .T.
         IF V_DIFRIGA = 1
            EXIT
         ENDIF
         V_RIGA = V_RIGA + 1
         APPEND BLANK
         REPLACE STA_PAGINA WITH V_PAGINA
         REPLACE STA_RIGA   WITH V_RIGA
         REPLACE STA_RECORD WITH SPACE(200)
         V_DIFRIGA = V_DIFRIGA - 1
      ENDDO
      SELECT FILE_STA
      SET ORDER TO FILE_IND
      GO TOP
      _PAG = STR(V_PAGINA,4,0)
      _RIG = STR(SAVE_RIGA,3,0)
      SEEK _PAG + _RIG
      V_RIGA = STA_RIGA
      SKIP +1
      LOOP
   ENDIF

   V_DIFPAGINA = STA_PAGINA - V_PAGINA
   V_DIFRIGA   = _TOTRIG - V_RIGA

   IF V_DIFRIGA = 0
      IF V_DIFPAGINA = 1
         V_PAGINA = STA_PAGINA
         V_RIGA   = 0
         LOOP
      ENDIF
   ENDIF


   SAVE_PAGINA = STA_PAGINA
   SAVE_RIGA   = STA_RIGA

   DO WHILE .T.

      IF V_DIFRIGA = 0	
        EXIT
      ENDIF

      V_RIGA    = V_RIGA + 1
      APPEND BLANK
      REPLACE STA_PAGINA WITH V_PAGINA
      REPLACE STA_RIGA   WITH V_RIGA
      REPLACE STA_RECORD WITH SPACE(200)
      V_DIFRIGA = V_DIFRIGA - 1

   ENDDO

   IF V_DIFPAGINA = 1
      SELECT FILE_STA
      SET ORDER TO FILE_IND
      GO TOP
      _PAG = STR(SAVE_PAGINA,4,0)
      _RIG = STR(SAVE_RIGA,3,0)
      SEEK _PAG + _RIG
      V_PAGINA = STA_PAGINA
      V_RIGA   = 0
      LOOP
   ENDIF

   V_PAGINA = V_PAGINA + 1
   V_RIGA   = 1

   DO WHILE .T.

      IF V_DIFPAGINA = 1
         EXIT
      ENDIF
         APPEND BLANK
         REPLACE STA_PAGINA WITH V_PAGINA
         REPLACE STA_RIGA   WITH V_RIGA
         REPLACE STA_RECORD WITH SPACE(200)
         IF V_RIGA = _TOTRIG
            V_DIFPAGINA = V_DIFPAGINA - 1
            V_PAGINA = V_PAGINA +1
            V_RIGA   = 0
         ENDIF
         V_RIGA    = V_RIGA + 1
      ******** ENDIF   SERGIO

   ENDDO

   SELECT FILE_STA
   SET ORDER TO FILE_IND
   GO TOP
   _PAG = STR(SAVE_PAGINA,4,0)
   _RIG = STR(SAVE_RIGA,3,0)
   SEEK _PAG + _RIG
   V_PAGINA = STA_PAGINA
   V_RIGA   = 0

ENDDO

V_DIFRIGA   = _TOTRIG - V_RIGA


DO WHILE .T.

   IF V_DIFRIGA = 0
      EXIT
   ENDIF

   V_RIGA = V_RIGA + 1

   APPEND BLANK
   REPLACE STA_PAGINA WITH V_PAGINA
   REPLACE STA_RIGA   WITH V_RIGA
   REPLACE STA_RECORD WITH SPACE(200)

***** INIZIO TEST PARACADUTE INSERITO DA SERGIO
   IF V_DIFRIGA > 0
	   V_DIFRIGA = V_DIFRIGA - 1
   ELSE
	   V_DIFRIGA = V_DIFRIGA + 1
   ENDIF
***** FINE TEST PARACADUTE INSERITO DA SERGIO

ENDDO

RETURN



***********************************************************************
* Funzione - MODTBL     Data: 15.08.00   Autore: Project S.r.L.  
***********************************************************************
*
*  MODIFICA UNA TABELLA AGGIORNANDO / AGGIUNGENDO DEI CAMPI
*  CONTROLLA SE IL CAMPO:
*  		 ESISTE  	-  MODIFICA EVENTUALE LUNGHEZZA E TIPOLOGIA
*  		 NON ESISTE -  AGGIUNGE IL CAMPO
*
*  ******************************************************************************
*  PRIMA DI RICHIAMARE LA FUNZIONE LA TABELLA DBF DEVE ESSERE APERTA IN EXCLUSIVA
*  ******************************************************************************
*
*  PARAMETRI DA PASSARE: ALIAS DELLA TABELLA
*                        NOME DEL CAMPO
*                        TIPOLOGIA E LUNGHEZZA CAMPO
*                        FLAG DI CANCELLAZIONE CAMPO (OPZIONALE)
*
*  Sintassi:
*  =MODTBL(ALIAS(SELECT()),"NOME_CAMPO","C(10)",.F.,.T.)
*
**************************
FUNCTION MODTBL
**************************
PARA _TBL,_CAMPO,_TIPO,_DROP,_CURS

IF PARAMETER() < 4
  _DROP=.F.
ENDIF

IF EMPTY(_CURS)
	_CURS=.F.
ENDIF

_TBL   = UPPER(_TBL)
_CAMPO = UPPER(_CAMPO)
_TIPO  = UPPER(_TIPO)

ESISTE=.F.
IF _CURS
	Select &_TBL
	_TotFields=afields(_NameFields)
	for _x=1 to _TotFields
	   IF ALLTRIM(_NameFields[_x,1]) == ALLTRIM(_CAMPO)
	     ESISTE=.T.
		 _NameFields[_x,2]=SUBSTR(_TIPO,1,1)
 		 _DIMENSIONE=STRTRAN(STR_EXTRACT(_TIPO,"(",2),")","")
		 _NameFields[_x,3]=INT(VAL(STR_EXTRACT(_DIMENSIONE,",",1)))
		 _NameFields[_x,4]=INT(VAL(STR_EXTRACT(_DIMENSIONE,",",2)))
	     EXIT
	   ENDIF
	next
	IF !ESISTE
		_Nfields=_TotFields+1
		_nArrayColumns = ALEN(_NameFields,2)			
		DIMENSION _NameFields[_Nfields,_nArrayColumns]	
		_NameFields[_Nfields,1]=_CAMPO
		_NameFields[_Nfields,2]=SUBSTR(_TIPO,1,1)
		_DIMENSIONE=STRTRAN(STR_EXTRACT(_TIPO,"(",2),")","")
		_NameFields[_Nfields,3]=INT(VAL(STR_EXTRACT(_DIMENSIONE,",",1)))
		_NameFields[_Nfields,4]=INT(VAL(STR_EXTRACT(_DIMENSIONE,",",2)))
		_NameFields[_Nfields,5]=.T.
		_NameFields[_Nfields,6]=.F.
		FOR JJ1=7 TO 16
			_NameFields[_Nfields,JJ1]=""
		NEXT
	ENDIF
	CREATE CURSOR &_TBL FROM ARRAY _NameFields
	RETURN(.T.)
ENDIF


ESISTE=.F.
* -->> RICERCO NELLA TABELLA SE IL CAMPO GIA' ESISTE
Select &_TBL
_TotFields=afields(_NameFields)
for _x=1 to _TotFields
   IF ALLTRIM(_NameFields[_x,1]) == ALLTRIM(_CAMPO)
     ESISTE=.T.
     EXIT
   ENDIF
next

* -->> CANCELLAZIONE DI UN CAMPO DALLA TABELLA
* ----------------------------------------------
IF _DROP
  ALTER TABLE &_TBL DROP COLUMN &_CAMPO
  RETURN(.T.)
ENDIF


* -->> AGGIUNTA / VARIAZIONE DI UN CAMPO NELLA TABELLA
* ----------------------------------------------
IF ESISTE
  ALTER TABLE &_TBL ALTER COLUMN &_CAMPO  &_TIPO    && MODIFICA
ELSE
  ALTER TABLE &_TBL ADD   COLUMN &_CAMPO  &_TIPO    && AGGIUNTA
ENDIF

RETURN(.T.)



*************************************************************************
* Funzione - VERTBL     Data: 01.03.01   Autore: Project S.r.l.
*************************************************************************
*
*  CONTROLLA SE IL CAMPO ESISTE
*
*  PARAMETRI DA PASSARE: ALIAS DELLA TABELLA
*                        NOME DEL CAMPO
*
*  Sintassi:
*  =MODTBL(ALIAS(SELECT()),"NOME_CAMPO")
*
**************************
FUNCTION VERTBL
**************************
PARA _TBL,_CAMPO

_TBL   = UPPER(_TBL)
_CAMPO = UPPER(_CAMPO)

ESISTE=.F.
* -->> RICERCO NELLA TABELLA SE IL CAMPO GIA' ESISTE
Select &_TBL
_TotFields=afields(_NameFields)
for _x=1 to _TotFields
   IF ALLTRIM(_NameFields[_x,1]) == ALLTRIM(_CAMPO)
     ESISTE=.T.
     EXIT
   ENDIF
next

RETURN(ESISTE)


************************************************************************
FUNCTION GET_DES
************************************************************************
* RESTITUISCE LA DESCRIZIONE DEL PARAMERTO (PRESENTE IN PARA.DBF)
* IMPOSTATO IN INGRESSO
*
* SINTASSI:
*
* DESCRIZIONE=GET_DES("TOP","VEN")
*
* ? DESCRIZIONE ----->  CONTIENE "FATTURA DI VENDITA"
*
* FABIANO... 12/10/1999
************************************************************************
PARAMETERS _GD_TIPO,_GD_CODICE

_GD_SEL=SELECT()

_GD_DESCRI=""

IF EMPTY(_GD_TIPO)
  WAIT WINDOW "!!! ATTENZIONE !!! FUNZIONE - GET_DES"+CHR(13)+"DESCRIZIONE NON VALORIZZATA: MANCA IL TIPO DI PARAMETRO"
  SELECT(_GD_SEL)
  RETURN(_GD_DESCRI)
ENDIF

IF EMPTY(_GD_CODICE)
  SELECT(_GD_SEL)
  RETURN(_GD_DESCRI)
ENDIF

IF !ExecCommand("select * from para where codice = ?_GD_TIPO+?_GD_CODICE","para")
   return
ENDIF
SELECT PARA
IF reccount() = 0
  _GD_DESCRI="Parametro inesistente"
ELSE
  _GD_DESCRI=ALLTRIM(DESCRI)
ENDIF

SELECT(_GD_SEL)

RETURN(_GD_DESCRI)


************************************************************************
FUNCTION CONDENSA
************************************************************************
*
* RESTITUISCE LA DESCRIZIONE IN INGRESSO IN FORMATO COMPRESSO PER STAMPA DOS
*
* FABIANO... 12/10/1999
************************************************************************
PARAMETERS _C_DESCRI

_GD_SEL=SELECT()

_C_DESCRI=CHR(15)+_C_DESCRI+CHR(18)

SELECT(_GD_SEL)

RETURN(_C_DESCRI)



***********************************************************************
* Funzione - WR_EXCEL     Data: 26.10.99   Autore: Project S.r.L.
***********************************************************************
*
*  GESTIONE SCRITTURA FILE EXCEL
*
*  Sintassi:
*  =WR_EXCEL(_TABELLA,_FILEIN,_FILEOU,_PGM)
*  Dove:
*  _TABELLA  = DBF O CURSORE IN CUI VI SONO I DATI DA SCRIVERE IN EXCEL (APERTA)
*  _FILEIN   = NOME DEL FILE EXCEL ORIGINALE (VUOTO) FORMATTATO (COMPLETO DI PATH)
*  _FILEOU   = NOME DEL NUOVO FILE IN CUI SCRIVERE I DATI (COMPLETO DI PATH)
*  _PGM      = NOME DEL PROGRAMMA (.FXP) DA LANCIARE IN CUI VIENE
*              GESTITA LA SCRITTURA DEL FOGLIO EXCEL (PERSONALIZZATA PER OGNI FILE EXCEL)
*
**************************
FUNCTION WR_EXCEL
**************************
PARA _TABELLA,_FILEIN,_FILEOU,_PGM

_WPARA=PARAMETERS()

IF _WPARA < 4
   =MESSAGEB("Parametri insufficenti per la funzione WR_EXCEL (-4)",16,"*** ATTENZIONE ***")
   RETURN(.F.)
ENDIF

X_PRG = "PRG\"+_PGM

IF !FILE(X_PRG+".PRG")
   =MESSAGEB("Manca la procedura di scrittura foglio excel ("+_PGM+".PRG)",16,"*** ATTENZIONE ***")
   RETURN(.F.)
ENDIF

IF !USED(_TABELLA)
   =MESSAGEB("L'origine dati non è disponibile ("+_TABELLA+")",16,"*** ATTENZIONE ***")
   RETURN(.F.)
ENDIF

IF !FILE(_FILEIN)
   =MESSAGEB("Manca il file excel con la formattazione ("+_FILEIN+")",16,"*** ATTENZIONE ***")
   RETURN(.F.)
ENDIF

_excel="C:\Programmi\Microsoft Office\Office\EXCEL.EXE"

IF !ExecCommand("select * from para where codice = 'EDTEXCEL' order by codice","para")
   return
ENDIF
SELECT PARA
DO WHILE !EOF()
   IF ALLTRIM(CODICE)<>"EDTEXCEL"
      EXIT
   ENDIF
   IF ALLTRIM(DESIVA)==STR_EXTRACT(SYS(0),"#",1)
      _excel=ALLTRIM(LIBERA)
      EXIT
   ENDIF
   SKIP+1
ENDDO

IF !FILE(_EXCEL)
   =MESSAGEB("Manca il programma excel nella posizione specificata ("+_FILEIN+")",16,"*** ATTENZIONE ***")
   RETURN(.F.)
ENDIF

IF FILE(_FILEOU)
   IF MESSAGEB("Il file di destinazione già esiste!!! ("+_FILEOU+")"+chr(13)+;
               "Desideri sovvrascriverlo ???",36,"*** ATTENZIONE ***")=7
      RETURN(.F.)
   ENDIF
ENDIF

ERASE &_FILEOU

_COMM="COPY FILE "+_FILEIN+" TO "+_FILEOU
&_COMM

DO PRG\&_PGM WITH _TABELLA,_FILEOU,_EXCEL

IF ALLTRIM(_FILEOU)="ERRORE"
   =MESSAGEB("Errore durante l'apertura del canale di"+chr(13)+"comunicazione col programma EXCEL",16,"*** ATTENZIONE ***")
   RETURN(.F.)
ENDIF

IF MESSAGEB("Creato file excel: "+_FILEOU+CHR(13)+"Desideri visualizzarlo?",292,"*** INFORMAZIONE ***")=6
   run /n1 &_excel &_FILEOU
ENDIF

RETURN(.T.)


****************************
FUNCTION REG_WORKSTATION
****************************
*Registra la workstation sul dbf PARA
*
_WORKSTATION=SYS(0)

IF ALLTRIM(_WORKSTATION)="1"
  RETURN(.T.)
ENDIF

IF ALLTRIM(STR_EXTRACT(_WORKSTATION,"#",1))=""
  RETURN(.T.)
ENDIF

IF !ExecCommand("select * from para where codice = 'EDTEXCEL'","para")
   return
ENDIF
SELECT PARA
IF reccount() = 0
   APPEND BLANK
   REPLACE CODICE WITH "EDTEXCEL"
   REPLACE DESCRI WITH "Posizione del programma EXCEL"
   REPLACE DESIVA WITH UPPER(STR_EXTRACT(_WORKSTATION,"#",1))
ENDIF

IF !ExecCommand("select * from para where codice = 'EDTWORD'","para")
   return
ENDIF
SELECT PARA
IF reccount() = 0
   APPEND BLANK
   REPLACE CODICE WITH "EDTWORD"
   REPLACE DESCRI WITH "Posizione del programma WORD"
   REPLACE DESIVA WITH UPPER(STR_EXTRACT(_WORKSTATION,"#",1))
ENDIF

RETURN(.T.)


****************************
FUNCTION DESOP
****************************
PARA _CODICE
  PRIVATE OUT

  SEL =SELECT()

  IF !ExecCommand("select * from res_oper where codice = ?_codice","res_oper")
     return
  ENDIF
  SELECT RES_OPER
  IF reccount() = 0
     OUT = DESCRI
  ELSE
     OUT = ""
  ENDIF

SELECT(SEL)
RETURN(OUT)




**********************************************************************
FUNCTION Cur2RdWr
**********************************************************************
LPARAMETER m.SourceName,m.TargetName,m.LeaveSourceOpen

IF EMPTY(m.TargetName)
	m.TargetName=rdwrsupp
ENDIF

if used(m.TargetName)
  select (m.TargetName)
  use
endif

USE DBF(m.SourceName) IN 0 AGAIN ALIAS (m.TargetName)

IF !m.LeaveSourceOpen
 USE IN (m.SourceName)
ENDIF

SELECT (m.TargetName)

RETURN m.TargetName


***********************************************************************
* Funzione - RIBALTASET     Data: 19.05.2004   Autore: Project  
***********************************************************************
*
*  Consente di convertire il formato settimana
*  AAAA.NN in NN.AAAA e viceversa
*  Sintassi: RIBALTASET(Stringa da convertire)
*  Parametro: Carattere
*  Ritorna:   Carattere
*  Se il contenuto di NN,AAAA è nullo ritorna SPACE(07)
*
***********************************************************************
FUNCTION RIBALTASET
*******************

PARAMETER _VALCAMPO

_SEPARA="/.-"

DO CASE
   CASE SUBSTR(_VALCAMPO,3,1) $ _SEPARA   && NN.AAAA
        _SEPARA=SUBSTR(_VALCAMPO,3,1)
        _NUMERO=SUBSTR(_VALCAMPO,1,2)
        _ANNO  =SUBSTR(_VALCAMPO,4,4)
        _TUTTO =_ANNO+_SEPARA+_NUMERO
   CASE SUBSTR(_VALCAMPO,5,1) $ _SEPARA   && AAAA.NN
        _SEPARA=SUBSTR(_VALCAMPO,5,1)
        _NUMERO=SUBSTR(_VALCAMPO,6,2)
        _ANNO  =SUBSTR(_VALCAMPO,1,4)
        _TUTTO =_NUMERO+_SEPARA+_ANNO
   OTHERWISE                              && NON VALIDO !
        _TUTTO=SPACE(07)
ENDCASE

RETURN(_TUTTO)


* SERGIO INIZIO 07/08/2004
**********************************************************************
* -->> FUNZIONE CHE IDENTIFICA SE LA DATA IN OGGETTO E' RIBALTATA
* -->> IN QUESTO CASO LA RIPORTA IN FORMATO GG/MM/AAAA
**********************************************************************
FUNCTION GDATA  
**********************************************************************
PARA _DATA

OUT=_DATA

IF SUBSTR(_DATA,5,1)="/"
  OUT=RIBALTA2(_DATA)
ENDIF  

RETURN(OUT)

* SERGIO FINE 07/08/2004

***************************************************************************
* Funzione - DAYLASTMOD     Data: 17.09.2004   Autore: Project - Cougar
***************************************************************************
*
*  Consente di ottenere i giorni che intercorrono tra la data dell'ultima 
*  modifica di un file e la data odierna.
*  
*  Sintassi: DAYLASTMOD( PercorsoFile )
*  Parametro: Carattere
*  Ritorna:   Numerico
*  Se il contenuto di PercorsoFile non è valido il programma restituirà -50
*
***************************************************************************
FUNCTION DAYLASTMOD
*******************
PARAMETERS PercorsoFile

IF FILE( PercorsoFile ) = .F.
	RETURN -50
ENDIF

ggg = ribalta2(DTOC(FDATE( PercorsoFile )))
lll = ribalta2(DTOC(DATE()))

fff = VAL(SUBSTR(ggg,1,4)+SUBSTR(ggg,6,2)+SUBSTR(ggg,9,2))
yyy = VAL(SUBSTR(lll,1,4)+SUBSTR(lll,6,2)+SUBSTR(lll,9,2))

RETURN (yyy - fff)

*** EOFuNcTiOn - DAYLASTMOD - By Cougar

***************************************************************************
* Funzione - CERCAMENUUTENTE   Data: 17.09.2004   Autore: Project - Cougar
***************************************************************************
*
*  Cerca nella stringa estratta da UTENTI nella tabella TBL_MENU 
*  se è presente l'utente corrente.
*  
*  Sintassi: CERCAMENUUTENTE( campoUtenti, utenteCorrente )
*  Parametro: Carattere, Carattere
*  Ritorna:   Boolean
*
*  Se trova l'utente la funzione restituisce .T.
*  Se non la trova restituisce .F.
*
*  (LOGICO No?, ndr)
*
*  Esempio:
*  SELECT TBL_MENU
*  XXX = CERCAMENUUTENTE( UTENTI, PUB_CODOPE )
*
***************************************************************************
FUNCTION CERCAMENUUTENTE
***************************************************************************
PARAMETERS campoUtenti, utenteCorrente

myFlag = .F.
inFlag = .F.
myCont = 0

DO WHILE !inFlag
	XXX = STR_EXTRACT( campoUtenti, ".", 3 + myCont )
	IF XXX = utenteCorrente
		myFlag = .T.
		inFlag = .T.
	ELSE
		IF XXX = ""
			inFlag = .T.
		ELSE
			myCont = myCont + 1
		ENDIF
	ENDIF
ENDDO

RETURN myFlag

*** EOFuNcTiOn - CERCAMENUUTENTE - By Cougar

*** SERGIO 10/02/2005 INIZIO
*************************************************************************** 
FUNCTION verifica_chiusura_aquarius
***************************************************************************
 

IF !ExecCommand("SELECT * FROM PARA WHERE CODICE = 'FRZFORZATA'","CLOSE_AQ")
  return(.f.)
ENDIF
 	
SELECT CLOSE_AQ
GO top
IF !EOF()

  
  IF ALLTRIM(LIBERA) = "SI"

     IF PUB_CODOPE <> ALLTRIM(DESIVA)


			    DO PLAYWAV WITH "BLIP.WAV" 

	 		    XDESCRI="CHIUSURA FORZATA AQUARIUS"
			    SET CLASSLIB TO "proj_lib.vcx" additive
			    oForm=CreateObject("MsgErr") 
			    oform.edit1.Value=""+XDESCRI+CHR(13)+;
						  ""+CHR(13)+;			  
						  "Terminare le operazioni e uscire per favore da AQUARIUS "
			    oform.Show
 			    RELEASE oForm 



     ENDIF

  ENDIF

ENDIF


RETURN 


*** SERGIO 10/02/2005 FINE


*** SERGIO 04/04/2005 INIZIO


***************************************************************************
* Funzione - REPLACEALLCHR   Data: 23.03.2005   Autore: Project - Cougar
***************************************************************************
*
*  Cerca nella stringa tutti i caratteri uguali a X e li sostituisce con Y
*  
*  Sintassi: REPLACEALLCHR( mystring, chr1, chr2 )
*  Parametro: Carattere, Carattere, Carattere
*  Ritorna:   Stringa
*
*  La funzione restituisce la stringa modificata
*
*  Esempio:
*  XXX = REPLACEALLCHR( MOV_VAL, "." , "," )
*
***************************************************************************
FUNCTION REPLACEALLCHR
***************************************************************************
PARAMETERS stringa, chrOld, chrNew

lenght = LEN(stringa)

FOR I = 1 TO lenght
	carattere = SUBSTR(stringa,I,LEN(chrOld))
	IF carattere = chrOld
		stringa = SUBSTR(stringa, LEN(chrOld), i-1) + chrNew + SUBSTR(stringa,i+LEN(chrOld),lenght)
	ENDIF
NEXT

RETURN stringa


***************************************************************************
* Funzione - REPLACECHR   Data: 23.03.2005   Autore: Project - Cougar
***************************************************************************
*
*  Cerca nella stringa il primo carattere uguali a X e lo sostituisce con Y
*  
*  Sintassi: REPLACEALLCHR( mystring, chr1, chr2 )
*  Parametro: Carattere, Carattere, Carattere
*  Ritorna:   Stringa
*
*  La funzione restituisce la stringa modificata
*
*  Esempio:
*  XXX = REPLACECHR( MOV_VAL, "." , "," )
*
***************************************************************************
FUNCTION REPLACECHR
***************************************************************************
PARAMETERS stringa, chrOld, chrNew

lenght = LEN(stringa)

FOR I = 1 TO lenght
	carattere = SUBSTR(stringa,I,LEN(chrOld))
	IF carattere = chrOld
		stringa = SUBSTR(stringa, LEN(chrOld), i-1) + chrNew + SUBSTR(stringa,i+LEN(chrOld),lenght)
		EXIT
	ENDIF
NEXT

RETURN stringa



****************************************
PROCEDURE STAMPA_A4
****************************************

PARAMETERS _NOME,X_COMPRESSO,X_ORI

OK_FILE=PUB_DIR+'\'+_NOME

_area_ambiente = SYS(5)+SYS(2003)

*!*	DO FORM FORM\PJ_SP11 LINKED

COMPRESSO = X_COMPRESSO 
BALL_FORM = 1

*** BALL_ORI  = 2
IF EMPTY(X_ORI)
	BALL_ORI  = 2
ELSE
	BALL_ORI  = X_ORI
ENDIF	

BALL_PAG  = 1

  IF COMPRESSO=1
	  do case
 	 	case ball_form=1 and ball_ori=1	&& a4 verticale
 	 		_report = "spool11c.frx"
 	 	case ball_form=2 and ball_ori=1	&& a3 verticale
 	 		_report = "spool21c.frx"
	  	case ball_form=1 and ball_ori=2	&& a4 orizzontale
 	 		_report = "spool12c.frx"
 	 	case ball_form=2 and ball_ori=2	&& a3 orizzontale
 	 		_report = "spool22c.frx"
 	 	otherwise
 	 		_report = "spool11c.frx"
	  endcase
  ELSE
	  do case
 	 	case ball_form=1 and ball_ori=1	&& a4 verticale
 	 		_report = "spool11.frx"
 	 	case ball_form=2 and ball_ori=1	&& a3 verticale
 	 		_report = "spool21.frx"
	  	case ball_form=1 and ball_ori=2	&& a4 orizzontale
 	 		_report = "spool12.frx"
 	 	case ball_form=2 and ball_ori=2	&& a3 orizzontale
 	 		_report = "spool22.frx"
 	 	otherwise
 	 		_report = "spool11.frx"
	  endcase
  ENDIF

    	
  IF BALL_PAG=1
      create cursor _spooler(riga1 c(250),riga2 c(250), riga3 c(250),pagina n(5))
	  COMM="APPEND FROM "+_NOME+" SDF"      
      &COMM
      select _spooler
      go top
      m.pagina=1
      scan
      	if asc(alltrim(riga1))=12
      		m.pagina=m.pagina+1
   		    replace pagina with m.pagina  
      		replace riga1 with strtran(riga1,chr(12),"")       
      	else
   		    replace pagina with m.pagina  
      	endif
      endscan
      go top   
      
      *report form &_report preview
      *report form &_report to printer prompt noconsole
  ELSE     
      THISFORM.PARZ_PRINT
      create cursor _spooler(riga1 c(250),riga2 c(250), riga3 c(250),pagina n(5))
      COMM="APPEND FROM PJ_TEMP."+PUB_EXT+" SDF "
      &COMM
      select _spooler
      go top
      m.pagina=1
      scan
      	if asc(alltrim(riga1))=12
      		m.pagina=m.pagina+1
   		    replace pagina with m.pagina  
      		replace riga1 with strtran(riga1,chr(12),"")       
      	else
   		    replace pagina with m.pagina  
      	endif
      endscan
      go top   
      *report form &_report preview
      *report form &_report to printer prompt noconsole
  ENDIF
  
  DO PRG\MENUSTA WITH "_spooler",.T.,.T.,"NO_CERCAREPO",_report,_report,.F.  && ERASMO - 18/03/2021

ERASE  &_NOME && SERGIO 26/10/2017: ELIMINA IL FILE DI STAMPA IN QUANTO LO SPOOLER NON E' PIU UTILIZZATO

set defa to &_area_ambiente

return




**********************************************************************
* Funzione - WSHOWDBF_CLICK_DESTRO
**********************************************************************
FUNCTION WSHOWDBF_CLICK_DESTRO

*!*	DO CASE 
*!*		
*!*			CASE _SELECT = "WEXPLODE"
*!*			
*!*					SELECT WEXPLODE

*!*					WAIT WINDOWS "ARTICOLO :" +WCOD  

*!*					DO FORM FORM\MENU_DISVIEW LINKED

*!*			OTHERWISE
*!*			
*!*	ENDCASE


RETURN


*!*	***********************************************************************
*!*	* Funzione - checkEmailAddress     Data: 28/09/2007   Autore: Project
*!*	***********************************************************************
*!*	*
*!*	*  Consente di verificare che il contenuto di una stringa passata come 
*!*	*  parametro sia formalmente corretto per essere utilizzato come 
*!*	*  indirizzo di posta elettronica valido - Valori di ritorno: .T./.F.
*!*	*
*!*	***********************************************************************
*!*	FUNCTION checkEmailAddress     
*!*	***********************************************************************

*!*	PARAMETER _strEmail

*!*	_x_strEmail = ALLTRIM(_strEmail)
*!*	_x_return   = .F.

*!*	IF EMPTY(_x_strEmail)
*!*	ELSE
*!*	   _XX_AT  = ATC("@",_x_strEmail)
*!*	   _XX_DOT = RAT(".",_x_strEmail)
*!*	   IF _XX_AT > 0 .AND. _XX_DOT > 0 .AND. _XX_DOT > _XX_AT .AND.  ;
*!*	      !EMPTY(SUBSTR(_x_strEmail,_XX_AT - 1,1)) .AND. !EMPTY(SUBSTR(_x_strEmail,_XX_AT + 1,1)) .AND. SUBSTR(_x_strEmail,_XX_AT + 1,1) <> "." .AND.  ;
*!*	      !EMPTY(SUBSTR(_x_strEmail,_XX_DOT - 1,1)) .AND. !EMPTY(SUBSTR(_x_strEmail,_XX_DOT + 1,1)) .AND. SUBSTR(_x_strEmail,_XX_DOT - 1,1) <> "@"
*!*	      _x_return = .T.
*!*	   ELSE
*!*	   ENDIF
*!*	ENDIF

*!*	RETURN(_x_return)



***************************************************************************
* Funzione - checkFlgEti                 Data: 12/05/2008   Autore: Project
***************************************************************************
*
*  Consente di verificare se il cliente desidera le etichette e Paking List
*  neutre senza il logo aziendale. Il parametro da passare è il codice cliente
*  
*  La funzione restituisce .T./.F. a seconda che per il cliente sia 
*  rispettivamente ATTIVO oppure DISATTIVO tale flag
*
***********************************************************************
FUNCTION checkFlgEti
***********************************************************************

PARAMETER _codice_cliente

__NPARA = PARAMETERS()
IF __NPARA < 1
   RETURN .F.
ENDIF

_x_return = .F.

_SAVESEL = SELECT()

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_clie = "cli_codcli = '" + ALLTRIM(_codice_cliente) + "'"
x_cond = x_soci + " and " + x_clie 
cSql = "select cli_flgeti from u_cli_an where " + x_cond
IF !ExecCommand(cSql,"chk_cli_an")
   return(.f.)
ENDIF
SELECT chk_cli_an
GO TOP
IF EOF()
   SELECT(_SAVESEL)
   RETURN(_x_return)
ENDIF
IF cli_flgeti
   _x_return = .T.
ENDIF

SELECT(_SAVESEL)
RETURN(_x_return)


***************************************************************************
* Funzione - checkFlgPes                 Data: 12/05/2008   Autore: Project
***************************************************************************
*
*  Consente di verificare se il cliente desidera che venga stampato il peso nelle etichette GRANDI
*  da applicare al bancale in uscita da packing list
*  
*  La funzione restituisce .T./.F. a seconda che per il cliente sia 
*  rispettivamente ATTIVO oppure DISATTIVO tale flag
*
***********************************************************************
FUNCTION checkFlgPes
***********************************************************************

PARAMETER _codice_cliente

__NPARA = PARAMETERS()
IF __NPARA < 1
   RETURN .F.
ENDIF

_x_return = .F.

_SAVESEL = SELECT()

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_clie = "cli_codcli = '" + ALLTRIM(_codice_cliente) + "'"
x_cond = x_soci + " and " + x_clie 
cSql = "select cli_flgpes from u_cli_an where " + x_cond
IF !ExecCommand(cSql,"chk_cli_an")
   return(.f.)
ENDIF
SELECT chk_cli_an
GO TOP
IF EOF()
   SELECT(_SAVESEL)
   RETURN(_x_return)
ENDIF
IF cli_flgpes 
   _x_return = .T.
ENDIF

SELECT(_SAVESEL)
RETURN(_x_return)




**************************************************************************************
* Procedura - Open_with_default_windows_program		Data: 18/09/2008   Autore: Project
**************************************************************************************
*
*  Consente di aprire ogni tipo di file conosciuto dal sistema in windows 
*  tramite il programma predefinito
*
**************************************************************************************
PROCEDURE Open_with_default_windows_program
**************************************************************************************
PARAMETER _full_path,_message,_parameters,_show_win

*!*	IF PARAMETERS() = 0
*!*	   RETURN .F.
*!*	ENDIF

**=> ERASMO - INIZIO 20/05/2019
IF PCOUNT() = 0
   RETURN .F.
ENDIF

IF PCOUNT() >= 2
ELSE
	_message = ""
ENDIF

IF PCOUNT() >= 3
ELSE
	_parameters = ""
ENDIF

IF PCOUNT() >= 4
ELSE
	_show_win = 1
ENDIF
**=> ERASMO - FINE 20/05/2019

lcFile = _full_path
*IF FILE(lcFile)
IF FILE(lcFile,1)  && ERASMO - 12/10/2022
ELSE
   MESSAGEBOX("Nome file o percorso non corretto",16,"Attenzione")
   RETURN .F.
ENDIF

IF EMPTY(lcFile)
   MESSAGEBOX("Parametro Nome file vuoto",16,"Attenzione")
   RETURN .F.
ENDIF

DECLARE INTEGER ShellExecute IN shell32.dll ; 
  INTEGER hndWin, ; 
  STRING cAction, ; 
  STRING cFileName, ; 
  STRING cParams, ;  
  STRING cDir, ; 
  INTEGER nShowWin

*!*	cAction = "open"
*!*	WAIT WINDOWS "Apertura in corso..." nowait
*!*	TRY
*!*		ShellExecute(0,cAction,lcFile,0,0,1)
*!*	CATCH
*!*		WAIT WINDOWS "Apertura impossibile" nowait
*!*	ENDTRY

**=> ERASMO - INIZIO 20/05/2019
hndWin = 0
cAction = "open"
cFileName = lcFile
cParams = _parameters
cDir = ""
nShowWin = _show_win

IF EMPTY(_message)
	WAIT WINDOWS "Apertura in corso..." nowait
ELSE
	IF _message <> "NO_MESSAGE"
		WAIT WINDOWS _message NOWAIT
	ENDIF
ENDIF

TRY
	*ShellExecute(0,cAction,lcFile,0,0,1)
	ShellExecute(hndWin,cAction,cFileName,cParams,cDir,nShowWin)  && ERASMO - 20/05/2019
CATCH
	WAIT WINDOWS "Apertura impossibile" nowait
ENDTRY
**=> ERASMO - FINE 20/05/2019


RETURN




***************************************************************************
* Funzione - checkDesCliTag                 Data: 03/10/2008   Autore: Project
***************************************************************************
*
*  Consente di verificare se il cliente desidera una stringa particolare
*  che deve essere sostituita al codice cliente
*  
*  Tale stringa è possibile impostarla in anagrafica solamente dopo aver impostato
*  la spunta etichette neutre a .T.
*
*  La funzione restituisce : 
*     - la stringa da sostituire al codice cliente se esiste e se checkFlgEti ritorna .T.
*   altrimenti
*     - il codice cliente
*
***********************************************************************
FUNCTION checkDesCliTag
***********************************************************************

PARAMETER _codice_cliente

__NPARA = PARAMETERS()
IF __NPARA < 1
   RETURN .F.
ENDIF

_x_return = _codice_cliente

_SAVSELX = SELECT()


IF checkFlgEti(_codice_cliente)	&& solo se il flag è ATTIVO

	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_clie = "cli_codcli = '" + ALLTRIM(_codice_cliente) + "'"
	x_cond = x_soci + " and " + x_clie 
	cSql = "select cli_desrot from u_cli_an where " + x_cond
	IF !ExecCommand(cSql,"dsrot_cli_an")
	   return(.f.)
	ENDIF
	SELECT dsrot_cli_an
	GO TOP
	IF EOF()
	   SELECT(_SAVSELX)
	   RETURN(_x_return)
	ENDIF
	
	IF !EMPTY(ALLTRIM(cli_desrot))
	    _x_return = ALLTRIM(cli_desrot)
	ELSE    
	    _x_return = _codice_cliente
	ENDIF

ENDIF


SELECT(_SAVSELX)
RETURN(_x_return)





***************************************************************************
* Funzione - checkPrintImgRibo 			Data: 15/06/2009   Autore: Project
***************************************************************************
FUNCTION checkPrintImgRibo 
***********************************************************************

PARAMETER _codice_nonconformita

__NPARA = PARAMETERS()
IF __NPARA < 1
   RETURN .F.
ENDIF

_x_return = .F.

_SAVSELX = SELECT()

cSql = "select desiva from para where codice = '" + _codice_nonconformita + "' "
IF !ExecCommand(cSql,"par_1")
   return(.f.)
ENDIF
SELECT par_1
GO TOP

IF EOF()
	___desiva = ""
ELSE
   	___desiva = par_1.DESIVA
ENDIF
	
IF !EMPTY(ALLTRIM(___desiva))
    _x_return = .T.
ENDIF


SELECT(_SAVSELX)
RETURN(_x_return)






***************************************************************************
* Funzione - desArtTag                 Data: 03/10/2008   Autore: Project
***************************************************************************
*
*  Consente di verificare se il cliente desidera una stringa particolare
*  che deve essere sostituita al codice del prodotto sull'etichetta
*  
*  Tale stringa è possibile impostarla in anagrafica articoli nella cartella
*  apposita "Etichetta prodotto finito"
*
*  La funzione restituisce : 
*
*     # la descrizione articolo impostata nella linguetta
*			- Se il 'codice cliente' impostato nella linguetta è valorizzato
*			- Se la 'descrizione articolo' impostato nella linguetta e corrispondente al codice cliente è valorizzato
*
*	  altrimenti
*
*     # la descrizione articolo impostata in anagrafica articoli
*
***********************************************************************
FUNCTION desArtTag                 
***********************************************************************

PARAMETER _codice_articolo, _codice_cliente

__NPARA = PARAMETERS()
IF __NPARA < 2
   RETURN .F.
ENDIF

_x_return = _codice_articolo

_SAVSELX = SELECT()


x_art = "ART_CODPRI = '" + ALLTRIM(_codice_articolo) + "'"
x_cli = "( ART_CLITAG1 = '"    + ALLTRIM(_codice_cliente) + ; 
		"' OR ART_CLITAG2 = '" + ALLTRIM(_codice_cliente) + ;
		"' OR ART_CLITAG3 = '" + ALLTRIM(_codice_cliente) + ;
		"' OR ART_CLITAG4 = '" + ALLTRIM(_codice_cliente) + ;
		"' OR ART_CLITAG5 = '" + ALLTRIM(_codice_cliente) + "')"
x_cond = x_art + " and " + x_cli 
cSql = "select art_codpri,art_descr,ART_CODITG1,ART_DESCTG1,ART_CLITAG1,ART_DSCLIT1 from u_art_pr where " + x_cond
IF !ExecCommand(cSql,"ds_art")
   return(.f.)
ENDIF

SELECT ds_art
GO TOP
IF EOF()
   SELECT(_SAVSELX)
   RETURN(_x_return)
ENDIF


IF !EMPTY(ALLTRIM(ART_CODITG1))
    _x_return = ALLTRIM(ART_CODITG1)
ELSE    
    _x_return = _codice_articolo
ENDIF


SELECT(_SAVSELX)
RETURN(_x_return)


**=> ERASMO - INIZIO 28/12/2017
**********************************************************************
FUNCTION TROVA_ARTICOLO_CLIENTE
***********************************************************************

LPARAMETERS _codice_articolo, _codice_cliente, _codice_descrizione

IF PCOUNT() < 2
   RETURN ""
ENDIF

IF PCOUNT() < 3
   _codice_descrizione = "COD"
ENDIF

_x_return = ""

_SAVSELX = SELECT()


x_art = "ART_CODPRI = '" + ALLTRIM(_codice_articolo) + "'"
x_cli = "(ART_CLITAG1 = '"    + ALLTRIM(_codice_cliente) + ; 
		"' OR ART_CLITAG2 = '" + ALLTRIM(_codice_cliente) + ;
		"' OR ART_CLITAG3 = '" + ALLTRIM(_codice_cliente) + ;
		"' OR ART_CLITAG4 = '" + ALLTRIM(_codice_cliente) + ;
		"' OR ART_CLITAG5 = '" + ALLTRIM(_codice_cliente) + "')"
x_cond = x_art + " and " + x_cli 
cSql = "select art_codpri,art_descr, " + CHR(13) + ;
       "ART_CODITG1,ART_DESCTG1,ART_CLITAG1,ART_DSCLIT1, " + CHR(13) + ;
       "ART_CODITG2,ART_DESCTG2,ART_CLITAG2,ART_DSCLIT2, " + CHR(13) + ;
       "ART_CODITG3,ART_DESCTG3,ART_CLITAG3,ART_DSCLIT3, " + CHR(13) + ;
       "ART_CODITG4,ART_DESCTG4,ART_CLITAG4,ART_DSCLIT4, " + CHR(13) + ;
       "ART_CODITG5,ART_DESCTG5,ART_CLITAG5,ART_DSCLIT5 " + CHR(13) + ;
       "from u_art_pr where " + x_cond
IF !ExecCommand(cSql,"TMP_ART_PR")
   return(.f.)
ENDIF

SELECT TMP_ART_PR
GO TOP
IF EOF()
   SELECT(_SAVSELX)
   RETURN(_x_return)
ENDIF

DO CASE
	CASE ART_CLITAG1 = ALLTRIM(_codice_cliente)
		IF _codice_descrizione = "COD"
			_x_return = ALLTRIM(ART_CODITG1)
		ELSE
			_x_return = ALLTRIM(ART_DESCTG1)
		ENDIF
		
	CASE ART_CLITAG2 = ALLTRIM(_codice_cliente)
		IF _codice_descrizione = "COD"
			_x_return = ALLTRIM(ART_CODITG2)
		ELSE
			_x_return = ALLTRIM(ART_DESCTG2)
		ENDIF

	CASE ART_CLITAG3 = ALLTRIM(_codice_cliente)
		IF _codice_descrizione = "COD"
			_x_return = ALLTRIM(ART_CODITG3)
		ELSE
			_x_return = ALLTRIM(ART_DESCTG3)
		ENDIF
		
	CASE ART_CLITAG4 = ALLTRIM(_codice_cliente)
		IF _codice_descrizione = "COD"
			_x_return = ALLTRIM(ART_CODITG4)
		ELSE
			_x_return = ALLTRIM(ART_DESCTG4)
		ENDIF

	CASE ART_CLITAG5 = ALLTRIM(_codice_cliente)
		IF _codice_descrizione = "COD"
			_x_return = ALLTRIM(ART_CODITG5)
		ELSE
			_x_return = ALLTRIM(ART_DESCTG5)
		ENDIF
		
	OTHERWISE
		_x_return = ""
ENDCASE

SELECT(_SAVSELX)
RETURN(_x_return)
**=> ERASMO - FINE 28/12/2017


******************************************************************************************
* Funzione - Num2Let									Data: 30/01/2009   Autore: Project
******************************************************************************************
*  Parametri:
*    1) Valore Numerico che si vuole convertire in lettere (OBBLIGATORIA)
*    2) Valore Logico .T. oppure .F. rispettivamente se si vuole oppure no l'indicazione 
*       di 2 decimali (FACOLTATIVA). Se non viene indicato verrà messo a .T. per default
*  
*
*  Restituisce una stringa contenente la descrizione in lettere del numero
*  passato nei parametri
*  
*  La funzione è valida solo per numeri da -999.999.999.999,99 a 999.999.999.999,99
*
******************************************************************************************
FUNCTION Num2Let
******************************************************************************************

PARAMETERS _numero,_decimali

_x_return = ""
_negativo = .F.

__NPARA = PARAMETERS()
IF __NPARA < 1
   RETURN(_x_return)
ENDIF

IF __NPARA < 2
   _decimali = .T.
ENDIF

If _numero = 0 .OR. _numero > 999999999999.99  .OR. _numero < -999999999999.99
   RETURN(_x_return)
ENDIF

IF _numero > 0
ELSE
   _negativo = .T.
   _numero = ABS(_numero)
ENDIF

_decimals = ""
IF _decimali
  _decimals = TRC(2,ALLTRIM(STR((_numero - Int(_numero)) * 100)))
  _decimals = "/" + _decimals
ENDIF

LOCAL Frazione1,Frazione2,Frazione3,Esp AS Integer
Frazione1 = 0
Frazione2 = 0
Frazione3 = 0
Esp       = 0

LOCAL InLettere AS String
InLettere = ""

LOCAL Temp AS Double
Temp = 0

LOCAL ARRAY Cifra(28) As String
Cifra(1) = ""
Cifra(2) = "uno"
Cifra(3) = "due"
Cifra(4) = "tre"
Cifra(5) = "quattro"
Cifra(6) = "cinque"
Cifra(7) = "sei"
Cifra(8) = "sette"
Cifra(9) = "otto"
Cifra(10) = "nove"
Cifra(11) = "dieci"
Cifra(12) = "undici"
Cifra(13) = "dodici"
Cifra(14) = "tredici"
Cifra(15) = "quattordici"
Cifra(16) = "quindici"
Cifra(17) = "sedici"
Cifra(18) = "diciassette"
Cifra(19) = "diciotto"
Cifra(20) = "diciannove"
Cifra(21) = "venti"
Cifra(22) = "trenta"
Cifra(23) = "quaranta"
Cifra(24) = "cinquanta"
Cifra(25) = "sessanta"
Cifra(26) = "settanta"
Cifra(27) = "ottanta"
Cifra(28) = "novanta"

For Esp = 3 To 0 Step -1
    Temp = _numero / 1000 ^ Esp
    Frazione1 = Int(Temp)
    If Frazione1 > 0
        Frazione2 = Frazione1
        If Frazione2 > 99
            Temp = Frazione2 / 100
            Frazione3 = Int(Temp)
            Frazione2 = Frazione2 - Frazione3 * 100
            If Frazione3 = 1
                InLettere = InLettere + "cento"
            Else
                InLettere = InLettere + Cifra(Frazione3 + 1) + "cento"
            EndIf
        EndIf
        If Frazione2 <= 20
            InLettere = InLettere + Cifra(Frazione2 + 1)
        Else
            Temp = Frazione2 / 10
            Frazione3 = Int(Temp)
            InLettere = InLettere + Cifra(Frazione3 + 19)
            Frazione2 = Frazione2 - Frazione3 * 10
            If Frazione2 = 1 Or Frazione2 = 8
                InLettere = Left(InLettere, Len(InLettere) - 1)
            EndIf
            InLettere = InLettere + Cifra(Frazione2 + 1)
        EndIf
        DO Case 
            Case Esp = 1
                If Frazione1 = 1
                    InLettere = Left(InLettere, Len(InLettere) - 3) + "mille"
                Else
                    InLettere = InLettere + "mila"
                EndIf
            Case Esp = 2
                If Frazione1 = 1
                    InLettere = Left(InLettere, Len(InLettere) - 3) + "unmilione"
                Else
                    InLettere = InLettere + "milioni"
                EndIf
            Case Esp = 3
                If Frazione1 = 1
                    InLettere = "unmiliardo"
                Else
                    InLettere = InLettere + "miliardi"
                EndIf
        EndCase
        _numero = _numero - Frazione1 * 1000 ^ Esp
    EndIf
Next

_x_return = InLettere

IF _decimali
  _x_return = _x_return + _decimals 
ENDIF

IF _negativo
   _x_return = "meno " + _x_return
ENDIF

RETURN(_x_return)



***************************************************************************
* Funzione - pj_inputbox                 Data: 15/05/2009   Autore: Project
***************************************************************************
*
*  Consente di digitare un valore testuale similmente alla funzione Fox INPUTBOX()
*  
*  Es.:
*
*  _NEW_EMAIL = PJ_INPUTBOX("Digitare il valore:","Titolo","testo di default")
*
*
*  La funzione restituisce la stringa inserita
*
***********************************************************************
FUNCTION pj_inputbox
***********************************************************************
*PARAMETERS _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE,_TOPLEVEL,_PASSWORDCHAR
LPARAMETERS _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE,_TOPLEVEL,_PASSWORDCHAR,_FORMAT,_INPUTMASK  && ERASMO - 18/06/2024

IF PCOUNT() < 1 .OR. TYPE("_CINPUTPROMPT") <> 'C'
   _CINPUTPROMPT = "Digitare il valore"
ENDIF

IF PCOUNT() < 2 .OR. TYPE("_CDIALOGCAPTION") <> 'C'
   _CDIALOGCAPTION = "Aquarius"
ENDIF

IF PCOUNT() < 3 .OR. TYPE("_CDEFAULTVALUE") <> 'C'
   _CDEFAULTVALUE = ""
ELSE
   _CDEFAULTVALUE = RTRIM(_CDEFAULTVALUE)
ENDIF

**=> ERASMO - INIZIO 16/02/2018
IF PCOUNT() < 4
   _TOPLEVEL = .F.
ENDIF
**=> ERASMO - FINE 16/02/2018

**=> ERASMO - INIZIO 19/04/2022
IF PCOUNT() < 5 .OR. TYPE("_PASSWORDCHAR") <> 'C'
   _PASSWORDCHAR = ""
ELSE
   _PASSWORDCHAR = SUBSTR(ALLTRIM(_PASSWORDCHAR),1,1)
ENDIF
**=> ERASMO - FINE 19/04/2022

**=> ERASMO - INIZIO 18/06/2024
IF PCOUNT() < 6
   _FORMAT = ""
ENDIF
IF PCOUNT() < 7
   _INPUTMASK = ""
ENDIF
**=> ERASMO - FINE 18/06/2024

_CRETURN = _CDEFAULTVALUE 

*DO FORM FORM\PJ_INPUTBOX WITH _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE

*!*	**=> ERASMO - INIZIO 16/02/2018
*!*	IF _TOPLEVEL
*!*		DO FORM FORM\PJ_INPUTBOX_TOP_LEVEL WITH _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE
*!*	ELSE
*!*		DO FORM FORM\PJ_INPUTBOX WITH _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE
*!*	ENDIF
*!*	**=> ERASMO - INIZIO 16/02/2018
*!*	**=> ERASMO - INIZIO 19/04/2022
*!*	IF _TOPLEVEL
*!*		DO FORM FORM\PJ_INPUTBOX_TOP_LEVEL WITH _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE,_PASSWORDCHAR
*!*	ELSE
*!*		DO FORM FORM\PJ_INPUTBOX WITH _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE,_PASSWORDCHAR
*!*	ENDIF
*!*	**=> ERASMO - INIZIO 19/04/2022
**=> ERASMO - INIZIO 18/06/2024
IF _TOPLEVEL
	DO FORM FORM\PJ_INPUTBOX_TOP_LEVEL WITH _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE,_PASSWORDCHAR,_FORMAT,_INPUTMASK
ELSE
	DO FORM FORM\PJ_INPUTBOX WITH _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE,_PASSWORDCHAR,_FORMAT,_INPUTMASK
ENDIF
**=> ERASMO - INIZIO 18/06/2024

RETURN(_CRETURN)

** 28/06/2023 SERGIO INIZIO

***************************************************************************
* Funzione - pj_inputcampi               Data: 28/06/2023   Autore: Project
***************************************************************************
*
*  Consente di digitare un valore testuale su 3 campi distinti 
*  
*  Es.:
*
*  _NEW_EMAIL = PJ_INPUTCAMPI("Digitare il valore:","Titolo","testo di default",_STRINGA)
*
*
*  La funzione elabora la stringa in input dividendola in 3 stringhe di 84 CHR  
*  La stringa viene concatenate in un unico campo al momento del rilascio
*
*
***********************************************************************
FUNCTION PJ_INPUTCAMPI
***********************************************************************

PARAMETERS _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE,_STRINGA_INPUT

IF PARAMETERS() < 1 .OR. TYPE("_CINPUTPROMPT") <> 'C'
   _CINPUTPROMPT = "Digitare il valore"
ENDIF

IF PARAMETERS() < 2 .OR. TYPE("_CDIALOGCAPTION") <> 'C'
   _CDIALOGCAPTION = "Aquarius"
ENDIF

IF PARAMETERS() < 3 .OR. TYPE("_CDEFAULTVALUE") <> 'C'
   _CDEFAULTVALUE = ""
ELSE
   _CDEFAULTVALUE = RTRIM(_CDEFAULTVALUE)
ENDIF


PJ_CRETURN = "" 


DO FORM FORM\PJ_INPUTCAMPI WITH _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE,_STRINGA_INPUT

RETURN(PJ_CRETURN)

** 28/06/2023 SERGIO FINE

***************************************************************************
* Funzione - checkConSpe                 Data: 26/05/2009   Autore: Project
***************************************************************************
*
*  Consente di verificare se la condizione di pagamento ha impostato il flag
*  di CONDIZIONE SPECIALE
*  
*  La funzione restituisce : 
*     - .T. se la condizione di pagamento ha il flag impostato a 'S'
*   altrimenti
*     - .F. 
*
***********************************************************************
FUNCTION checkConSpe
***********************************************************************

PARAMETER _cond_pag

__NPARA = PARAMETERS()
IF __NPARA < 1
   RETURN .F.
ENDIF

_x_return = .F.

_SAVSELX = SELECT()


x_cpa = "codice = CPA'" + ALLTRIM(_cond_pag) + "'"
cSql = "select SUBSTRING(LIBERA,8,1) AS CONSPE,CODICE,DESCRI from PARA where codice = 'CPA" + ALLTRIM(_cond_pag) + "'"
IF !ExecCommand(cSql,"check_cpa")
   return(.f.)
ENDIF
SELECT check_cpa
GO TOP
IF EOF()
   SELECT(_SAVSELX)
   RETURN(_x_return)
ENDIF

IF UPPER(ALLTRIM(CONSPE)) == 'S'
    _x_return = .T.
ENDIF


SELECT(_SAVSELX)
RETURN(_x_return)



***************************************************************************
* Funzione - descriPara		           Data: 16/09/2009   Autore: Project
***************************************************************************
*
*  La funzione restituisce : 
*
*     # la descrizione contenuta nel campo DESCRI della tabella PARA
*		in base al contenuto del campo CODICE di PARA passato come parametro
*
***********************************************************************
FUNCTION descriPara
***********************************************************************

PARAMETER _campo_codice

__NPARA = PARAMETERS()
IF __NPARA < 1
   RETURN .F.
ENDIF

_x_return = _campo_codice

_SAVSELX = SELECT()

x_cond = "CODICE = '" + _campo_codice + "'"
cSql = "select DESCRI from PARA where " + x_cond
IF !ExecCommand(cSql,"ds_para")
   return(.f.)
ENDIF

SELECT ds_para
GO TOP
IF EOF()
   SELECT(_SAVSELX)
   RETURN(_x_return)
ENDIF


IF !EMPTY(ALLTRIM(DESCRI))
    _x_return = ALLTRIM(DESCRI)
ELSE    
    _x_return = _campo_codice
ENDIF


SELECT(_SAVSELX)
RETURN(_x_return)



***************************************************************************
* Funzione - getNazione            Data: 10/11/2009   Autore: Project
***************************************************************************
*
*  Consente di verificare di quale nazionalità è il cliente/fornitore
*  testando l'anagrafica cliente/fornitore
*  
*  La funzione restituisce : 
*     - il codice nazione salvato in anagrafica
*
***********************************************************************
FUNCTION getNazione            
***********************************************************************

PARAMETER _codice, _alias

__NPARA = PARAMETERS()
IF __NPARA < 2
   RETURN .F.
ENDIF

_x_return = ""

_SAVSELX = SELECT()

IF UPPER(_alias) = "U_CLI_AN"
	x_sql = "select cli_nazion from " + ALLTRIM(_alias) + " where cli_codcli = '"+ALLTRIM(_codice)+"'"
ELSE
	x_sql = "select for_nazion from " + ALLTRIM(_alias) + " where for_codcli = '"+ALLTRIM(_codice)+"'"
ENDIF

IF !ExecCommand(x_sql,"naz_anag")
   return(.f.)
ENDIF
SELECT naz_anag
GO TOP
IF EOF()
   SELECT(_SAVSELX)
   RETURN(_x_return)
ENDIF

IF UPPER(_alias) = "U_CLI_AN"
	_x_return = naz_anag.cli_nazion
ELSE
	_x_return = naz_anag.for_nazion
ENDIF


SELECT(_SAVSELX)
RETURN(_x_return)




*!*	*******************************************
*!*	PROCEDURE SendViaMAPI(tcReturn, tcTo, tcSubject, tcBody, taFiles, tcCC, tcBCC, tcUserName, tcPassword, tlOpenEmail)
*!*	*******************************************
*!*	 #DEFINE PRIMARY 1
*!*	 #DEFINE CARBON_COPY 2
*!*	 #DEFINE BLIND_CARBON_COPY 3

*!*	 LOCAL loSession, loMessages, lnAttachments, loError AS EXCEPTION, loErrorSend AS EXCEPTION

*!*	 tcReturn = ""

*!*	 TRY
*!*	  loSession = CREATEOBJECT( "MSMAPI.MAPISession" )
*!*	  IF TYPE("tcUserName") = "C"
*!*	   loSession.UserName = tcUserName
*!*	  ENDIF
*!*	  IF TYPE("tcPassword") = "C"
*!*	   loSession.PASSWORD = tcPassword
*!*	  ENDIF
*!*	  loSession.Signon()
*!*	  IF (loSession.SessionID > 0)
*!*	   loMessages = CREATEOBJECT( "MSMAPI.MAPIMessages" )
*!*	   loMessages.SessionID = loSession.SessionID
*!*	  ENDIF
*!*	  WITH loMessages
*!*	   .Compose()
*!*	   .RecipDisplayName = tcTo
*!*	   .RecipType = PRIMARY
*!*	   .ResolveName()
*!*	   IF TYPE("tcCC") = "C"
*!*	    .RecipIndex = .RecipCount
*!*	    .RecipDisplayName = tcCC
*!*	    .RecipType = CARBON_COPY
*!*	    .ResolveName()
*!*	   ENDIF
*!*	   IF TYPE("tcBCC") = "C"
*!*	    .RecipIndex = .RecipCount
*!*	    .RecipDisplayName = tcBCC
*!*	    .RecipType = BLIND_CARBON_COPY
*!*	    .ResolveName()
*!*	   ENDIF
*!*	   .MsgSubject = tcSubject
*!*	   .MsgNoteText = tcBody
*!*	   IF TYPE("taFiles", 1) = "A"
*!*	    lnAttachments = ALEN(taFiles)
*!*	    IF LEN(tcBody) < lnAttachments && Make sure body is large enough for attachments
*!*	     tcBody = PADR(tcBody, lnAttachments, " ")
*!*	    ENDIF
*!*	    FOR lnCountAttachments = 1 TO lnAttachments
*!*	     .AttachmentIndex = .AttachmentCount
*!*	     .AttachmentPosition = .AttachmentIndex
*!*	     .AttachmentName = JUSTFNAME(taFiles(lnCountAttachments))
*!*	     .AttachmentPathName = taFiles(lnCountAttachments)
*!*	    ENDFOR
*!*	   ENDIF
*!*	   TRY
*!*	    .SEND(tlOpenEmail)
*!*	   CATCH TO loErrorSend
*!*	    IF tlOpenEmail && Did user cancel the operation from their email client?
*!*	     tcReturn = "User cancelled sending of email."
*!*	    ELSE
*!*	     THROW loErrorSend
*!*	    ENDIF
*!*	   ENDTRY
*!*	  ENDWITH
*!*	  loSession.Signoff()
*!*	 CATCH TO loError
*!*	  tcReturn = [Error: ] + STR(loError.ERRORNO) + CHR(13) + ;
*!*	   [LineNo: ] + STR(loError.LINENO) + CHR(13) + ;
*!*	   [Message: ] + loError.MESSAGE + CHR(13) + ;
*!*	   [Procedure: ] + loError.PROCEDURE + CHR(13) + ;
*!*	   [Details: ] + loError.DETAILS + CHR(13) + ;
*!*	   [StackLevel: ] + STR(loError.STACKLEVEL) + CHR(13) + ;
*!*	   [LineContents: ] + loError.LINECONTENTS
*!*	 FINALLY
*!*	  STORE .NULL. TO loSession, loMessages
*!*	  RELEASE loSession, loMessages
*!*	 ENDTRY
*!*	ENDPROC

*!*	RETURN


*********************************************************************************
* Funzione - SetResolutionBackground Data: 01/09/2010   Autore: Project
*********************************************************************************
*
* Consente di settare lo sfondo della finestra principale di Aquarius nella
* risoluzione ideale previa esistenza del file con nome precisamente identificato
*
*********************************************************************************
FUNCTION SetResolutionBackground
*********************************************************************************

PARAMETERS _defa_filename

IF PARAMETERS() < 1
	RETURN ""
ENDIF

_defa_filename = ALLTRIM(_defa_filename)
_defa_fileext = ALLTRIM(SUBSTR(_defa_filename,RAT('.',_defa_filename,1)))  && ERASMO - 19/10/2012
_x_resolution = ALLTRIM(STR(SYSMETRIC(1))) + 'X' + ALLTRIM(STR(SYSMETRIC(2)))
*_radice_nomefile = SUBSTR(_defa_filename,1,LEN(_defa_filename)-4)
_radice_nomefile = STRTRAN(_defa_filename,_defa_fileext,"")  && ERASMO - 19/10/2012
*_x_nomefile = _radice_nomefile + '_' + _x_resolution + ".JPG"
_x_nomefile = _radice_nomefile + '_' + _x_resolution + _defa_fileext  && ERASMO - 19/10/2012

*!*	IF FILE(_x_nomefile)
*!*		_SCREEN.Picture = _x_nomefile
*!*	ENDIF

RETURN _x_nomefile  && ERASMO - 19/10/2012


***********************************************************************
* Funzione - DIFF_MESI Data: 25/03/2011   Autore: Project
***********************************************************************
*
*  Consente di CALCOLARE IL NUMERO DI MESI COMPRESI TRA DUE DATE IN INPUT
*
***********************************************************************
FUNCTION DIFF_MESI

LPARAMETERS _CDATA1,_CDATA2

_NMESI = 0

_MESE1 = MONTH(CTOD(_CDATA1))
_ANNO1 = YEAR(CTOD(_CDATA1))
_MESE2 = MONTH(CTOD(_CDATA2))
_ANNO2 = YEAR(CTOD(_CDATA2))

_NMESI = ABS(_MESE2 - _MESE1) + 1 + ABS((_ANNO2 - _ANNO1) * 12)

RETURN _NMESI


***********************************************************************
* Funzione - checkEmailAddress     Data: 28/09/2007   Autore: Project
***********************************************************************
*
*  Consente di verificare che il contenuto di una stringa passata come 
*  parametro sia formalmente corretto per essere utilizzato come 
*  indirizzo di posta elettronica valido - Valori di ritorno: .T./.F.
*
***********************************************************************
FUNCTION checkEmailAddress     
***********************************************************************

PARAMETER _strEmail

_x_strEmail = ALLTRIM(_strEmail)
_x_return   = .T.

_ADMITTED_LOCAL_STRING  = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&'*+-/=?^_`{|}~."
_ADMITTED_DOMAIN_STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-."

IF EMPTY(_strEmail)
	_x_return = .F.
ELSE
	_XX_AT  = OCCURS("@",_x_strEmail) = 1 .AND. !EMPTY(SUBSTR(_x_strEmail,ATC("@",_x_strEmail)-1,1)) .AND. ;
				 !EMPTY(SUBSTR(_x_strEmail,ATC("@",_x_strEmail)+1,1)) .AND. SUBSTR(_x_strEmail,ATC("@",_x_strEmail)+1,1) <> "."
	_XX_DOT = OCCURS(".",_x_strEmail) > 0 .AND. !EMPTY(SUBSTR(_x_strEmail,RAT(".",_x_strEmail)-1,1)) .AND. ;
				 !EMPTY(SUBSTR(_x_strEmail,RAT(".",_x_strEmail)+1,1)) .AND. SUBSTR(_x_strEmail,RAT(".",_x_strEmail)-1,1) <> "@"
	_XX_SPACE = OCCURS(" ",_x_strEmail) = 0
	IF _XX_AT .AND. _XX_DOT .AND. _XX_SPACE
		*** VERIFICA STRINGA LOCAL INDIRIZZO E-MAIL
		_LOCAL_STRING = SUBSTR(_x_strEmail,1,ATC("@",_x_strEmail)-1)
		FOR I = 1 TO LEN(_LOCAL_STRING)
			IF SUBSTR(_LOCAL_STRING,I,1) $ _ADMITTED_LOCAL_STRING
			ELSE
				_x_return = .F.
			ENDIF
		ENDFOR
		IF OCCURS("--",_LOCAL_STRING) > 0
			_x_return = .F.
		ENDIF
		
		*** VERIFICA STRINGA DOMAIN INDIRIZZO E-MAIL
		_DOMAIN_STRING = SUBSTR(_x_strEmail,ATC("@",_x_strEmail)+1)
		FOR I = 1 TO LEN(_DOMAIN_STRING)
			IF SUBSTR(_DOMAIN_STRING,I,1) $ _ADMITTED_DOMAIN_STRING
			ELSE
				_x_return = .F.
			ENDIF
		ENDFOR
		IF OCCURS("--",_DOMAIN_STRING) > 0 .OR. OCCURS("..",_DOMAIN_STRING) > 0
			_x_return = .F.
		ENDIF
		**=> ERASMO - INIZIO 10/11/2020
		IF !OCCURS(".",_DOMAIN_STRING) > 0
			_x_return = .F.
		ENDIF
		**=> ERASMO - FINE 10/11/2020
	ELSE
		_x_return = .F.
	ENDIF
ENDIF


RETURN(_x_return)


***********************************************************************
* Funzione - checkSMTPserver     Data: 06/06/2011   Autore: Project
***********************************************************************
*
*  Consente di verificare che il contenuto di una stringa passata come 
*  parametro sia formalmente corretto per essere utilizzato come 
*  nome di server SMTP - Valori di ritorno: .T./.F.
*
***********************************************************************
FUNCTION checkSMTPserver
***********************************************************************

PARAMETER _strSMTP

_x_strSMTP = ALLTRIM(_strSMTP)
_x_return  = .T.

_ADMITTED_DOMAIN_STRING = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-."

IF EMPTY(_strSMTP)
	_x_return = .F.
ELSE
	_XX_DOT = OCCURS(".",_x_strSMTP) > 0 .AND. !EMPTY(SUBSTR(_x_strSMTP,RAT(".",_x_strSMTP)-1,1)) .AND. !EMPTY(SUBSTR(_x_strSMTP,RAT(".",_x_strSMTP)+1,1))
	_XX_SPACE = OCCURS(" ",_x_strSMTP) = 0
	IF _XX_DOT .AND. _XX_SPACE
		*** VERIFICA STRINGA SMTP
		FOR I = 1 TO LEN(_x_strSMTP)
			IF SUBSTR(_x_strSMTP,I,1) $ _ADMITTED_DOMAIN_STRING
			ELSE
				_x_return = .F.
			ENDIF
		ENDFOR
		IF OCCURS("--",_x_strSMTP) > 0 .OR. OCCURS("..",_x_strSMTP) > 0
			_x_return = .F.
		ENDIF
	ELSE
		_x_return = .F.
	ENDIF
ENDIF


RETURN(_x_return)


*!*	***********************************
*!*	PROCEDURE CHIUDI_APPLICAZIONE
*!*	***********************************

*!*	_RISP = MESSAGEBOX("Chiudere l'applicazione Aquarius?",4+32+256,"Attenzione")
*!*	IF _RISP <> 6
*!*		RETURN
*!*	ENDIF

*!*	CLEAR EVENTS

*!*	RETURN

*!*	*!*	** Uscita dal menu
*!*	*!*	SET SYSMENU TO DEFAULT
*!*	*!*	SET TALK ON

*!*	*!*	ON KEY LABEL "CTRL+H"
*!*	*!*	ON KEY LABEL "CTRL+Q"
*!*	*!*	ON KEY LABEL "ALT+0"
*!*	*!*	ON KEY LABEL "CTRL+D"
*!*	*!*	ON KEY LABEL "CTRL+LEFTARROW"
*!*	*!*	ON KEY LABEL "RIGHTMOUSE"
*!*	*!*	ON KEY LABEL "SHIFT+F1"
*!*	*!*	ON KEY LABEL "SHIFT+F2"
*!*	*!*	ON KEY LABEL "SHIFT+F3"
*!*	*!*	ON KEY LABEL "SHIFT+F4"
*!*	*!*	ON KEY LABEL "SHIFT+F5"
*!*	*!*	ON KEY LABEL "SHIFT+F6"
*!*	*!*	ON KEY LABEL "SHIFT+F7"
*!*	*!*	ON KEY LABEL "SHIFT+F8"
*!*	*!*	ON KEY LABEL "SHIFT+F9"
*!*	*!*	ON KEY LABEL "SHIFT+F10"
*!*	*!*	ON KEY LABEL F1

*!*	*!*	ON READERROR

*!*	*!*	CLEAR WINDOW ALL
*!*	*!*	DEACTIVATE WINDOW DEBUG
*!*	*!*	MODIFY WINDOW SCREEN

*!*	*!*	ON SHUTDOWN

*!*	*!*	ON ERROR

*!*	*!*	SET TALK OFF
*!*	*!*	*SET NOTIFY OFF

*!*	*!*	** Chiude tutte le finestre aperte 
*!*	*!*	FOR x=_SCREEN.FORMCOUNT TO 1 STEP -1
*!*	*!*	    IF TYPE("_SCREEN.FORMS(x).PARENT")=="O" 
*!*	*!*	       IF PEMSTATUS(_SCREEN.FORMS(x).PARENT,"RELEASE",5)
*!*	*!*	          _SCREEN.FORMS(x).PARENT.RELEASE
*!*	*!*	       ENDIF
*!*	*!*	    ENDIF
*!*	*!*	    IF TYPE("_SCREEN.FORMS(x)")=="O" 
*!*	*!*	       IF PEMSTATUS(_SCREEN.FORMS(x),"RELEASE",5)
*!*	*!*	          _SCREEN.FORMS(x).RELEASE
*!*	*!*	       ENDIF   
*!*	*!*	    ENDIF
*!*	*!*	NEXT

*!*	*!*	*_SCREEN.Visible = _OLD_SCREEN_Visible

*!*	*!*	CLEAR ALL
*!*	*!*	CLOSE ALL
*!*	*!*	CLEAR

*!*	*!*	* Fine programma

*!*	ENDPROC


***********************************
PROCEDURE ORDINA_COLONNA_GRIGLIA
***********************************
*PARAMETERS _CURSOR,_CAMPO,_NOME_INDICE
PARAMETERS _CURSOR,_CAMPO,_NOME_INDICE,_EXPR_INDICE  && ERASMO - 15/03/2024

**=> ERASMO - INIZIO 15/03/2024
IF PCOUNT() >= 4
ELSE
	_EXPR_INDICE = ""
ENDIF
**=> ERASMO - FINE 15/03/2024

LOCAL _TAG_NAME,_TAG_KEY,_TAG_ORDER,_CONTA_INDICI
LOCAL ARRAY _AINDEX[1]


IF PCOUNT()<3
	MESSAGEBOX("NUMERO PARAMETRI NON VALIDO",48,"PROCEDURE ORDINA_COLONNA_GRIGLIA")
	RETURN
ENDIF

SELECT &_CURSOR

ATAGINFO(_AINDEX)

_TAG_NAME=""
_TAG_KEY=""
_TAG_ORDER="DESCENDING"

IF ASCAN( _AINDEX, _NOME_INDICE , -1, -1, 1, 15 ) > 0

	FOR _CONTA_INDICI=1 TO ALEN(_AINDEX,1)
	 	_TAG_NAME= _AINDEX[_CONTA_INDICI,1]
	 	_TAG_KEY = _AINDEX[_CONTA_INDICI,3]
	 	_TAG_ORDER = _AINDEX[_CONTA_INDICI,5]
	 	
	 	IF _TAG_NAME=_NOME_INDICE
	 		EXIT
	 	ENDIF

	NEXT
ENDIF

*!*	IF _TAG_ORDER = "DESCENDING"
*!*		INDEX ON &_CAMPO TAG &_NOME_INDICE 
*!*	ELSE
*!*		INDEX ON &_CAMPO TAG &_NOME_INDICE DESC
*!*	ENDIF
IF EMPTY(_EXPR_INDICE)  && ERASMO - 15/03/2024
	**=> ERASMO - INIZIO 19/10/2022
	IF TYPE(_CAMPO) == 'C'
		LOCAL _NOMECAMPO,_DIMENSIONE_CAMPO
		_DIMENSIONE_CAMPO = 0
		SELECT &_CURSOR
		AFIELDS(_A_CURSORE)
		FOR I = 1 TO ALEN(_A_CURSORE,1)
			_NOMECAMPO = ALLTRIM(_A_CURSORE[I,1])
			IF UPPER(ALLTRIM(_CURSOR)) + '.' + UPPER(ALLTRIM(_NOMECAMPO)) == UPPER(ALLTRIM(_CAMPO))
				_DIMENSIONE_CAMPO = _A_CURSORE[I,3]
				EXIT
			ENDIF
		ENDFOR
		IF _DIMENSIONE_CAMPO > 100
			IF _TAG_ORDER = "DESCENDING"
				INDEX ON SUBSTR(&_CAMPO,1,100) TAG &_NOME_INDICE 
			ELSE
				INDEX ON SUBSTR(&_CAMPO,1,100) TAG &_NOME_INDICE DESC
			ENDIF
		ELSE
			IF _TAG_ORDER = "DESCENDING"
				INDEX ON &_CAMPO TAG &_NOME_INDICE 
			ELSE
				INDEX ON &_CAMPO TAG &_NOME_INDICE DESC
			ENDIF
		ENDIF
	ELSE
		IF _TAG_ORDER = "DESCENDING"
			INDEX ON &_CAMPO TAG &_NOME_INDICE 
		ELSE
			INDEX ON &_CAMPO TAG &_NOME_INDICE DESC
		ENDIF
	ENDIF
	**=> ERASMO - FINE 19/10/2022
**=> ERASMO - INIZIO 15/03/2024
ELSE
	IF _TAG_ORDER = "DESCENDING"
		INDEX ON &_EXPR_INDICE TAG &_NOME_INDICE 
	ELSE
		INDEX ON &_EXPR_INDICE TAG &_NOME_INDICE DESC
	ENDIF
ENDIF
**=> ERASMO - FINE 15/03/2024

RETURN 

* FINE PROCEDURE ORDINA_COLONNA_GRIGLIA
***********************************


***************************************************************************************
* Funzione - FIND_WORDS  Data: 20.07.2016   Autore: Project
***************************************************************************************
* Questa funzione permette di cercare una parola desiderata contenuta
* in una stringa di caratteri, restituisce inoltre le variabili:
* PUB_POSIZIONE_PAROLA : è la posizione iniziale della stringa che si desidera cercare
* PUB_POSIZIONE_PAROLA_SUCCESSIVA : è la posizione iniziale della parola successiva
* PUB_PAROLA_SUCCESSIVA : CONTIENE LA PRIMA PAROLA SUCCESSIVA
* PUB_PAROLA_SUCCESSIVA2 : CONTIENE LA SECONDA PAROLA SUCCESSIVA
***************************************************************************************
FUNCTION FIND_WORDS  
*******************
LPARAMETERS  gcString,gcFindWord

PUB_PAROLA_SUCCESSIVA               = ""
PUB_PAROLA_SUCCESSIVA2              = ""
PUB_POSIZIONE_PAROLA				= 0
PUB_POSIZIONE_PAROLA_SUCCESSIVA		= 0 


gcSpace = " "
PUB_POSIZIONE_PAROLA 	= AT(gcFindWord,gcString)	&& posizione della parola nella stringa

IF PUB_POSIZIONE_PAROLA <> 0																		&& parola trovata
	len_gcString    		= LEN(ALLTRIM(gcString))												&& lunghezza totale della stringa
	len_gcFindWord 			= LEN(ALLTRIM(gcFindWord))												&& lunghezza totale della parola da ricercare
	new_gcString   			= SUBSTR(gcString,PUB_POSIZIONE_PAROLA + len_gcFindWord ,len_gcString)	&& nuova stringa che parte dal primo carattere libero dopo la parola da ricercare
	primo_chr_libero		=  AT(gcSpace,new_gcString)												&& posizione del primo chr libero
	IF primo_chr_libero <> 0
	    _len_stringa_contenente_parola_cercata = LEN(SUBSTR(gcString,1,PUB_POSIZIONE_PAROLA + len_gcFindWord))
		IF  primo_chr_libero +1 < len_gcString														&& verifico che lo spazio sia contenuto nella stringa    
			PUB_POSIZIONE_PAROLA_SUCCESSIVA = _len_stringa_contenente_parola_cercata + primo_chr_libero
			gcFrase_Successiva_Completa      = SUBSTR(gcString,PUB_POSIZIONE_PAROLA_SUCCESSIVA,len_gcString)
			primo_chr_libero	=  AT(gcSpace,gcFrase_Successiva_Completa)							&& primo crattere libero
			IF primo_chr_libero <> 0

				*1) PRIMA PAROLA SUCCESSIVA
					PUB_PAROLA_SUCCESSIVA = SUBSTR(gcFrase_Successiva_Completa,1,primo_chr_libero -1)	&& parola successiva
					PUB_PAROLA_SUCCESSIVA = APITOSPA(PUB_PAROLA_SUCCESSIVA)

				*2) SECONDA PAROLA SUCCESSIVA
					len_gcString    		= LEN(ALLTRIM(gcFrase_Successiva_Completa))
					primo_chr_libero		= AT(gcSpace,gcFrase_Successiva_Completa)	
					IF primo_chr_libero <> 0
						primo_chr_seconda_parola     = primo_chr_libero +1
						gcFrase_Successiva_Completa2 = SUBSTR(gcFrase_Successiva_Completa,primo_chr_seconda_parola,len_gcString)	&& frase contenente la SECONDA PAROLA
						primo_chr_libero2     		 = AT(gcSpace,gcFrase_Successiva_Completa2)
						IF primo_chr_libero2 <> 0
							PUB_PAROLA_SUCCESSIVA2   = ALLTRIM(SUBSTR(gcFrase_Successiva_Completa2,1,primo_chr_libero2))    
							PUB_PAROLA_SUCCESSIVA2   = APITOSPA(PUB_PAROLA_SUCCESSIVA2)
						ENDIF 
					ENDIF

			ELSE
				PUB_PAROLA_SUCCESSIVA = ""
			ENDIF

		ELSE 
			PUB_POSIZIONE_PAROLA_SUCCESSIVA = 0
		ENDIF 	
	ELSE 
			PUB_POSIZIONE_PAROLA_SUCCESSIVA = 0
	ENDIF 
	
ELSE 
	PUB_POSIZIONE_PAROLA_SUCCESSIVA = 0
ENDIF 


RETURN


*************************************
PROCEDURE TAB_DELIMITED_TO_VFP_CURSOR
*************************************
LPARAMETERS _par_nomecur_out,_par_NomeFileText

cInputFile = FileToStr(_par_NomeFileText)
cElabFileName = SYS(5)+SYS(2003)+"\"+SYS(2015)+".txt"
IF SUBSTR(cInputFile,1,3) = 'ÿþ"'
	cInputFile = SUBSTR(cInputFile,3)
	StrToFile(Strconv(cInputFile,10),cElabFileName)
ELSE
	StrToFile(cInputFile,cElabFileName)
ENDIF

*** LEGGO IL NUMERO DI COLONNE DEL CSV
gnFileHandle = FOPEN(_par_NomeFileText)
*lcLine = FGETS(gnFileHandle)
lcLine = FGETS(gnFileHandle,8192)  && ERASMO - 30/11/2018
nCols = OCCURS(CHR(9),lcLine) + 1
FCLOSE(gnFileHandle)

*** CREO IL CURSORE NEL QUALE IMPORTERO' I DATI
_cCommand = "CREATE CURSOR " + _par_nomecur_out + "("
_cColumns = ""
LOCAL I
I=0
FOR I=1 TO nCols
	_cColDef = ALLTRIM(n2c(I)) + " C(254)"
	_cColumns = ALLTRIM(_cColumns) + IIF(EMPTY(_cColumns),"",", ") + _cColDef
NEXT
_cCommand = _cCommand + _cColumns + ")"
&_cCommand

SELECT &_par_nomecur_out
_cCommand = "APPEND FROM '" + cElabFileName + "' DELIMITED WITH TAB"
&_cCommand

_cCommand = "ERASE '" + cElabFileName + "'"
&_cCommand

SELECT &_par_nomecur_out
GO TOP

RETURN .T.


**************************************
PROCEDURE CHAR_DELIMITED_TO_VFP_CURSOR
**************************************
LPARAMETERS _par_nomecur_out,_par_NomeFileText,_par_Delimiter

cInputFile = FileToStr(_par_NomeFileText)
cElabFileName = SYS(5)+SYS(2003)+"\"+SYS(2015)+".txt"
IF SUBSTR(cInputFile,1,3) = 'ÿþ"'
	cInputFile = SUBSTR(cInputFile,3)
	StrToFile(Strconv(cInputFile,10),cElabFileName)
ELSE
	StrToFile(cInputFile,cElabFileName)
ENDIF

*** LEGGO IL NUMERO DI COLONNE DEL CSV
gnFileHandle = FOPEN(_par_NomeFileText)
*lcLine = FGETS(gnFileHandle)
lcLine = FGETS(gnFileHandle,8192)  && ERASMO - 30/11/2018
nCols = OCCURS(_par_Delimiter,lcLine) + 1
FCLOSE(gnFileHandle)

*** CREO IL CURSORE NEL QUALE IMPORTERO' I DATI
_cCommand = "CREATE CURSOR " + _par_nomecur_out + "("
_cColumns = ""
LOCAL I
I=0
FOR I=1 TO nCols
	_cColDef = ALLTRIM(n2c(I)) + "__ C(254)"
	_cColumns = ALLTRIM(_cColumns) + IIF(EMPTY(_cColumns),"",", ") + _cColDef
NEXT
_cCommand = _cCommand + _cColumns + ")"
&_cCommand

SELECT &_par_nomecur_out
_cCommand = "APPEND FROM '" + cElabFileName + "' DELIMITED WITH CHARACTER '" + _par_Delimiter + "'"
&_cCommand

_cCommand = "ERASE '" + cElabFileName + "'"
&_cCommand

SELECT &_par_nomecur_out
GO TOP

RETURN .T.


***************************************
PROCEDURE VERIFICA_VALIDITA_PARTITA_IVA
***************************************
LPARAMETERS _par_nazion,_par_pariva

IF !IsInternetConnected()
	MESSAGEBOX("Connessione internet non disponibile",48,"Attenzione")
	RETURN .F.
ENDIF

IF EMPTY(_par_nazion)
	MESSAGEBOX("Digitare prima il codice Nazione",48,"Attenzione")
	RETURN .F.
ENDIF

IF EMPTY(_par_pariva)
	MESSAGEBOX("Digitare prima il numero di Partita Iva",48,"Attenzione")
	RETURN .F.
ENDIF

V_ER=SOTTOGEN(_par_nazion)
IF PUB_STATO_CEE OR SUBSTR(_par_nazion,1,2) == "IT"
ELSE
	MESSAGEBOX("Verifica disponibile per sole Nazioni UE",64,"Informazione")
	RETURN .F.	
ENDIF

_VATNUMBER = ALLTRIM(_par_pariva)
_COUNTRYCODE = ""
v_seek   = 'STA' + ALLTRIM(_par_nazion)
v_chiave = "codice"
cSql="select LIBERA from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecCommand(cSql,"CU_PARA")
	return(.f.)
ENDIF
SELECT CU_PARA
GO TOP
IF !EOF()
	_COUNTRYCODE = UPPER(SUBSTR(LIBERA,1,2))
ENDIF

IF EMPTY(_COUNTRYCODE)
	MESSAGEBOX("Codice ISO 3166-1 alpha-2 non configurato per il codice Nazione '" + ALLTRIM(_par_nazion) + "'",48,"Attenzione")
	RETURN .F.
ENDIF

**=> ERASMO - INIZIO 12/11/2021
IF ISALPHA(SUBSTR(_VATNUMBER,1,1)) AND ISALPHA(SUBSTR(_VATNUMBER,2,1))
	IF UPPER(SUBSTR(_VATNUMBER,1,2)) == _COUNTRYCODE
		_VATNUMBER = SUBSTR(_VATNUMBER,3,20)
	ELSE
		MESSAGEBOX("Il codice ISO 3166-1 alpha-2 configurato per il codice Nazione '" + ALLTRIM(_par_nazion) + "' non corrisponde con i primi 2 caratteri alfabetici della Partita Iva",48,"Attenzione")
		RETURN .F.
	ENDIF
ENDIF
**=> ERASMO - FINE 12/11/2021

lcfileName = "ViesSOAPCheckVat.XML"
lcXml = ""
IF !FILE(lcfileName )
	MESSAGEBOX("File '" + lcfileName + "' non presente nella directory di AQUARIUS" + REPLICATE(CHR(13),2) + "Contattare assistenza",48,"Attenzione")
	RETURN .F.
ENDIF
lcXml = FILETOSTR(lcfileName)
lcXml = STRTRAN(lcXml,"#COUNTRYCODE#",_COUNTRYCODE)
lcXml = STRTRAN(lcXml,"#VATNUMBER#",_VATNUMBER)

WAIT WINDOWS "Richiesta validità Partita Iva in corso..." NOWAIT

loRequest = Createobject('MsXml2.XmlHttp')
lcUrl = "http://ec.europa.eu/taxation_customs/vies/services/checkVatService"
loRequest.Open("POST",lcUrl,.F.)
loRequest.SetRequestHeader('Content-Type','text/xml;charset=UTF-8')
loRequest.setRequestHeader("SOAPAction", "")
TRY
	loRequest.Send(lcXml)
	loResponse = STRCONV(loRequest.ResponseBody,11)
CATCH
	loResponse = ""
ENDTRY
RELEASE loRequest

WAIT CLEAR

IF EMPTY(loResponse)
	MESSAGEBOX("Servizio non disponibile",64,"Informazione")
	RETURN .F.
ENDIF

*!*	IF "<faultstring>INVALID_INPUT</faultstring>" $ loResponse
*!*		MESSAGEBOX("Errore nei dati inseriti di Partita Iva o Nazione",64,"Informazione")
*!*		RETURN .F.
*!*	ENDIF

*!*	_VALID = STREXTRACT(loResponse,'<valid>','</valid>',1)
*!*	IF _VALID = "true"
*!*		_NAME = STREXTRACT(loResponse,'<name>','</name>',1)
*!*		_ADDRESS = STREXTRACT(loResponse,'<address>','</address>',1)
*!*		IF _NAME = "---"
*!*			_NAME = "<Non Disponibile>"
*!*		ENDIF
*!*		IF _ADDRESS = "---"
*!*			_ADDRESS = "<Non Disponibile>"
*!*		ENDIF
*!*		MESSAGEBOX("Esito controllo: Partita Iva VALIDA" + REPLICATE(CHR(13),2) + ;
*!*			"Nome azienda rilevato: " + _NAME + CHR(13) + ;
*!*			"Indirizzo azienda rilevato: " + _ADDRESS,64,"Informazione")
*!*		RETURN .T.
*!*	ELSE
*!*		MESSAGEBOX("Esito controllo: Partita Iva NON VALIDA per transazioni transfrontaliere nell'UE (o non registrata nel sistema VIES)" + REPLICATE(CHR(13),2) + ;
*!*			"Effettuare la verifica con altri sistemi",48,"Informazione")
*!*		RETURN .F.
*!*	ENDIF

**=> ERASMO - INIZIO 27/10/2022
IF "<ns2:faultstring>INVALID_INPUT</ns2:faultstring>" $ loResponse
	MESSAGEBOX("Errore nei dati inseriti di Partita Iva o Nazione",64,"Informazione")
	RETURN .F.
ENDIF

_VALID = STREXTRACT(loResponse,'<ns2:valid>','</ns2:valid>',1)
IF _VALID = "true"
	_NAME = STREXTRACT(loResponse,'<ns2:name>','</ns2:name>',1)
	_ADDRESS = STREXTRACT(loResponse,'<ns2:address>','</ns2:address>',1)
	IF _NAME = "---"
		_NAME = "<Non Disponibile>"
	ENDIF
	IF _ADDRESS = "---"
		_ADDRESS = "<Non Disponibile>"
	ENDIF
	MESSAGEBOX("Esito controllo: Partita Iva VALIDA" + REPLICATE(CHR(13),2) + ;
		"Nome azienda rilevato: " + _NAME + CHR(13) + ;
		"Indirizzo azienda rilevato: " + _ADDRESS,64,"Informazione")
	RETURN .T.
ELSE
	MESSAGEBOX("Esito controllo: Partita Iva NON VALIDA per transazioni transfrontaliere nell'UE (o non registrata nel sistema VIES)" + REPLICATE(CHR(13),2) + ;
		"Effettuare la verifica con altri sistemi",48,"Informazione")
	RETURN .F.
ENDIF
**=> ERASMO - FINE 27/10/2022

RETURN

**************************************************************************************
FUNCTION REDUCEMEMORY
**************************************************************************************

PRIVATE NPROC,BB
DECLARE INTEGER SetProcessWorkingSetSize IN kernel32 AS SetProcessWorkingSetSize  ;
	INTEGER hProcess , INTEGER dwMinimumWorkingSetSize , ;
	INTEGER dwMaximumWorkingSetSize
DECLARE INTEGER GetCurrentProcess IN kernel32 AS GetCurrentProcess
NPROC = GETCURRENTPROCESS()
BB = SETPROCESSWORKINGSETSIZE(NPROC,-1,-1)
CLEAR DLLS SETPROCESSWORKINGSETSIZE
CLEAR DLLS GETCURRENTPROCESS

RETURN(.T.)


**************************************************************************************
FUNCTION CREATE_ZIP_FILE
**************************************************************************************
* ES.:
* 	IF !CREATE_ZIP_FILE("C:\TEST\IT03153711209_01654.xml","C:\TEST\IT03153711209_01654.zip",.T.)
*		MESSAGEBOX("Errore")
*	ENDIF
************************************************************************************************
LPARAMETERS _filename_in,_filename_out,_erase_input_file

IF PCOUNT() >= 1
ELSE
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

IF PCOUNT() >= 2
ELSE
	_filename_out = JUSTFNAME(_filename_in)+".zip"
ENDIF

IF PCOUNT() >= 3
ELSE
	_erase_input_file = .F.
ENDIF

IF FILE("C:\Program Files\WinRAR\rar.exe")
ELSE
	MESSAGEBOX("WinRAR non installato",16,"Attenzione")
	RETURN .F.
ENDIF

_path = JUSTPATH(_filename_in)
_drive = JUSTDRIVE(_filename_in)

_c_temp_bat_file = 'echo off'
_c_temp_bat_file = _c_temp_bat_file + 'cls'
_c_temp_bat_file = _c_temp_bat_file + CHR(13) + CHR(10)+ _drive
_c_temp_bat_file = _c_temp_bat_file + CHR(13) + CHR(10)+ 'cd ' + _path
*_c_temp_bat_file = _c_temp_bat_file + CHR(13) + CHR(10)+ '"C:\Program Files\WinRAR\winrar.exe" A "' + JUSTFNAME(_filename_out) + '" "' + JUSTFNAME(_filename_in) + '"'
_c_temp_bat_file = _c_temp_bat_file + CHR(13) + CHR(10)+ '"C:\Program Files\WinRAR\winrar.exe" A "' + _filename_out + '" "' + JUSTFNAME(_filename_in) + '"'  && ERASMO - 19/11/2025
_c_temp_bat_file = _c_temp_bat_file + CHR(13) + CHR(10)+ 'exit'

_c_temp_filename_bat = Addbs(Sys(2023)) + Sys(3) + ".BAT"
STRTOFILE(_c_temp_bat_file,_c_temp_filename_bat,0)

IF FILE(_c_temp_filename_bat)
	_V_RUN = '/N "' + _c_temp_filename_bat + '"'
	RUN &_V_RUN
ELSE
	MESSAGEBOX("File Batch non trovato",16,"Attenzione")
	RETURN .F.
ENDIF

DO AQM_ATTENDI_N_SECONDI WITH 2
					
_SEC_INI = SECONDS()
DO WHILE .T.
	IF FILE(_filename_out)
		EXIT
	ENDIF
	_SEC_FIN = SECONDS()
	IF _SEC_FIN - _SEC_INI > 3
		EXIT
	ENDIF
ENDDO

ERASE _c_temp_filename_bat

IF !FILE(_filename_out)
	RETURN .F.
ENDIF

IF _erase_input_file 
	ERASE _filename_in
ENDIF

RETURN .T.


** 26/12/2022 SERGIO INIZIO
**********************************************************
FUNCTION COPY_FILE
**********************************************************
*
* - IN FUNZIONE DELLA METODOLOGIA DI COPIA LA FUNZIONE COPIA IL CONTENUTO DI UN CAMPO MEMO DEL FILE IN INPUT IN UNA DIRECTORY SPECIFICATA 
*   O IN ALTERNATIVA COPIA/MUOVE IL FILE IN IMPUT IN UA DIRECTORY DI ARRIVO (SE LA DIRECTORY DI ARRIVO NON ESISTE LA CREA)
*
* _metodologia_copia:			SE = MEMO , COPIA IL CONTENUTO DI UN CAMPO MEMO DI UN CURSORE IN INPUT IN UNA DIRECTORY DI ARRIVO
*								SE = FILE , COPIA IL FILE IL INPUT IN AUNA DIRECTORY DI ARRIVO
*
* _metodologia_copia:			= MEMO	
* _cursor_file					CURSORE IN INPUT CHE CONTIENE IL FILE DA COPIARE
* _nome_campo_file:				NOME DELLA COLONNA DEL RECORD CONTENENTE IL FILE DI TESTO DA COPIARE
* _nome_file_partenza:			= "" NON USATO
* _nome_file_arrivo:			NOME DEL FILE DI ARRIVO DA COPIARE
* _nome_directory_di_arrivo:	NOME DELLA DIRECTORY DOVE COPIARE IL FILE, SE NON ESISTE LA CREA
*
* _metodologia_copia:			= FILE 	
* _cursor_file					= "" NON USATO
* _nome_campo_file:				= "" NON USATO
* _nome_file_partenza:			NOME DEL FILE DI PARTENZA DA COPIARE CON IL PERCORSO COMPLETO OVE SI TROVA
* _nome_file_arrivo:			NOME DEL FILE DI ARRIVO DA COPIARE  CON IL PERCORSO COMPLETO IN CUI DEVE ESSERE DEPOSITATO
* _nome_directory_di_arrivo:	NOME DELLA DIRECTORY DOVE COPIARE IL FILE, SE NON ESISTE LA CREA
*
*	
PARAMETERS _metodologia_copia,_cursor_file,_nome_campo_file,_nome_file_partenza,_nome_file_arrivo,_nome_directory_di_arrivo

S11FESC=STR(SELECT())

IF !FILE(_nome_file_partenza)
	MSGBOX('Fattura elettronica inesistente nel documento selezionato: impossibile proseguire','ATTENZIONE',31)
	SELECT &S11FESC
	SET DEFA TO &PUB_DIR
	RETURN(.F.)
ENDIF

DO CASE

	CASE _metodologia_copia = "MEMO"	&& COPIA IL FILE CONTENUTO IN UN CAMPO MEMO DA UN CURSORE DI INPUT
	
		_directorydestinazione =alltrim(_nome_directory_di_arrivo)
		_nomefile=_nome_file_arrivo
		
		IF !DIRECTORY(_directorydestinazione)
			_COMMAND = "MKDIR '" + ALLTRIM(_directorydestinazione) + "'"
			&_COMMAND
		ENDIF
		
		SELECT &__nome_campo_file 
		GO TOP
		
		SET DEFAULT TO &_directoryDestinazione 
		ERASE &_nomefile

		COPY MEMO &_nome_campo_file TO &_nomefile

		SET DEFA TO &PUB_DIR
	
	CASE _metodologia_copia = "FILE"	&& COPIA IL FILE PRESENTE IN UNA DIRECTORY DI INPUT IN UNA DIRECTORY DI DESTINAZIONE

		_directorydestinazione =alltrim(_nome_directory_di_arrivo)
		_nomefile=_nome_file_arrivo
		
		IF !DIRECTORY(_directorydestinazione)
			_COMMAND = "MKDIR '" + ALLTRIM(_directorydestinazione) + "'"
			&_COMMAND
		ENDIF


		SET DEFAULT TO &_directoryDestinazione 
		ERASE &_nomefile

		_COMM='COPY FILE "'+_nome_file_partenza+'" TO "'+_nome_file_arrivo+'"'
		&_COMM
		
		SET DEFA TO &PUB_DIR

ENDCASE





SELECT &S11FESC


RETURN(.T.)
** 26/12/2022 SERGIO FINE


** 29/12/2022 SERGIO INIZIO
**********************************************************
FUNCTION SCORPORA_PATH_FILE
**********************************************************
* SCORPORA IL PATH DAL NOME DEL FILE
*	
PARAMETERS _filexml_con_path,_filexml_senza_path


S12FESC=STR(SELECT())

** 
_GCSTRING   						= ALLTRIM(_filexml_con_path)
_GCFINDWORD 						= ALLTRIM(_filexml_senza_path) 
PUB_PAROLA_SUCCESSIVA               = ""
PUB_PAROLA_SUCCESSIVA2              = ""
PUB_POSIZIONE_PAROLA				= 0
PUB_POSIZIONE_PAROLA_SUCCESSIVA		= 0 

=FIND_WORDS(_GCSTRING,_GCFINDWORD)


SELECT &S12FESC


RETURN(.T.)
** 29/12/2022 SERGIO FINE



***********************************************************************
FUNCTION checkNoDisp
***********************************************************************

LPARAMETERS _codice_cliente

__NPARA = PCOUNT()
IF __NPARA < 1
   RETURN .F.
ENDIF

_x_return = .F.

_SAVESEL = SELECT()

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_clie = "cli_codcli = '" + ALLTRIM(_codice_cliente) + "'"
x_cond = x_soci + " and " + x_clie 
cSql = "select CLI_NODISP from u_cli_an where " + x_cond
IF !ExecCommand(cSql,"chk_cli_an")
   return(.f.)
ENDIF
SELECT chk_cli_an
GO TOP
IF EOF()
   SELECT(_SAVESEL)
   RETURN(_x_return)
ENDIF
IF CLI_NODISP
   _x_return = .T.
ENDIF

SELECT(_SAVESEL)
RETURN(_x_return)


**=> ERASMO - INIZIO 21/05/2026
********************************************************************************
* Funzione: UTC_A_OraLocale
* Descrizione: Converte un campo DateTime UTC nell'ora locale (italiana) 
*              gestendo automaticamente l'ora solare e legale.
********************************************************************************
FUNCTION UTC_A_OraLocale(tUtcDateTime)

IF EMPTY(tUtcDateTime) OR TYPE("tUtcDateTime") != "T"
    RETURN {//::} && Ritorna un datetime vuoto se l'input non è valido
ENDIF

* Dichiariamo le API di Windows necessarie
DECLARE INTEGER SystemTimeToTzSpecificLocalTime IN Kernel32;
    STRING lpTimeZoneInformation, STRING lpUniversalTime, STRING @lpLocalTime

LOCAL lcUtcStruct, lcLocalStruct, lnResult, tLocalDateTime

* 1. Costruiamo la struttura SYSTEMTIME per il tempo UTC (Input)
* Formato SYSTEMTIME: 8 WORD (Anno, Mese, GiornoDellaSettimana, Giorno, Ora, Minuto, Secondo, Millisecondo)
lcUtcStruct = BINTOC(YEAR(tUtcDateTime), "2rs")  + ;
              BINTOC(MONTH(tUtcDateTime), "2rs") + ;
              BINTOC(0, "2rs")                   + ; && Giorno settimana (ignorato in input)
              BINTOC(DAY(tUtcDateTime), "2rs")   + ;
              BINTOC(HOUR(tUtcDateTime), "2rs")  + ;
              BINTOC(MINUTE(tUtcDateTime), "2rs") + ;
              BINTOC(SEC(tUtcDateTime), "2rs")   + ;
              BINTOC(0, "2rs")                       && Millisecondi

* 2. Prepariamo una struttura vuota da 16 byte per il tempo Locale (Output)
lcLocalStruct = REPLICATE(CHR(0), 16)

* 3. Eseguiamo la conversione tramite l'API di Windows.
* Passando 0 (NULL) come primo parametro, Windows usa il fuso orario corrente del PC.
lnResult = SystemTimeToTzSpecificLocalTime(0, lcUtcStruct, @lcLocalStruct)

IF lnResult != 0
    * 4. Estraiamo i dati dalla struttura locale convertita
    LOCAL lnYear, lnMonth, lnDay, lnHour, lnMin, lnSec
    lnYear  = CTOBIN(SUBSTR(lcLocalStruct, 1, 2), "2rs")
    lnMonth = CTOBIN(SUBSTR(lcLocalStruct, 3, 2), "2rs")
    lnDay   = CTOBIN(SUBSTR(lcLocalStruct, 7, 2), "2rs")
    lnHour  = CTOBIN(SUBSTR(lcLocalStruct, 9, 2), "2rs")
    lnMin   = CTOBIN(SUBSTR(lcLocalStruct, 11, 2), "2rs")
    lnSec   = CTOBIN(SUBSTR(lcLocalStruct, 13, 2), "2rs")

    * Ricostruiamo il tipo DateTime nativo di FoxPro
    tLocalDateTime = DATETIME(lnYear, lnMonth, lnDay, lnHour, lnMin, lnSec)
ELSE
    * Fallback in caso di errore dell'API
    tLocalDateTime = {//::}
ENDIF

RETURN tLocalDateTime
    
ENDFUNC
**=> ERASMO - FINE 21/05/2026
