*************************************************************************************************
*							CONVERSIONE ANAGRAFICA FORNITORI RIDOTTA							*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2013 : Rumi  				 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica fornitori da foglio Execl	 ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


** ASSEGNAZIONE DELLA VARIABILE PATH **************************
		
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "RUM"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'RUM' non configurato" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	USE
	RETURN .F.
ENDIF

IF DIRECTORY(V_PATH)
ELSE
	MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	RETURN .F.
ENDIF


SET DEFAULT TO &V_PATH 

****** DEFINIZIONE DEI CURSORI STP


*!*	WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA FORNITORI" NOWAIT

*!*	IF !ExecCommand("select * from U_FOR_AN where 1=0","curs_U_FOR_AN")
*!*	   return
*!*	ENDIF

*!*	*WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA ZONE" NOWAIT
*!*	cSql = "delete from PARA where CODICE LIKE 'ZON%' "
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF

*!*	*WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA NAZIONI" NOWAIT
*!*	cSql = "delete from PARA where CODICE LIKE 'STA%' "
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF



*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_FOR_AN SQL ESCLUDENDO IL CODICE CLIENTE AZIENDA PER LA GESTIONE AZIENDA


__SOC= "01"
__CLI= "000000" 

x_soci = "FOR_codsoc = '" + __SOC + "'"
x_codi = "FOR_codcli <> '" + __CLI + "'"
x_cond = x_soci + " and " + x_codi

cSql   = "delete from U_FOR_AN where " + x_cond 
IF !ExecCommand(cSql,"U_FOR_AN")
   return(.f.)
ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CODICE_ZONA
PUBLIC _CODICE_ZONA
_CODICE_ZONA = 0



RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA




gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	
	RETURN
ENDIF


WAIT WINDOWS "Selezionato file EXCEL >>>>>>>>>>> "+gcFile 		

CREATE CURSOR IMPORTAXLS (ancodice   c(30),;
	andescri   c(80),;	
	anindiri   c(80),;	
	antelefo   c(30),;
	antipcon   c(30),;
	anpariva   c(30),;	
	ancodfis   c(30),;	
	anlocali   c(80),;	
	anprovin   c(30))
APPEND FROM (gcFile) TYPE xls	



* -->> Creazione cursore vuoto
* ----------------------------
IF !ExecCommand("select * from u_for_an where 0=1","u_for_an")
   return(.f.)
ENDIF
SELECT u_for_an
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK



***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTAXLS  
GO TOP

DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTAXLS   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    IF UPPER(ALLTRIM(ANCODICE)) = "ANCODICE"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 


    SCATTER MEMVAR MEMO
    
    
*!*	#####################################################


    M.ID_UNIQUE  = ""
   	M.FOR_CODSOC = PUB_CODSOC 
    IF LEN(ALLTRIM(M.ANCODICE)) = 15
    	M.FOR_CODCLI = SUBSTR(M.ANCODICE,8,8)
    ELSE
    	M.FOR_CODCLI = ALLTRIM(M.ANCODICE)
    ENDIF
    
    M.FOR_CODCLI = TRC(PUB_LCL,ALLTRIM(M.FOR_CODCLI))      	
 	M.FOR_RAGSOC = ALLTRIM(M.ANDESCRI)
   	M.FOR_RAGSOC = UPPER(M.FOR_RAGSOC)
    M.FOR_RAGSOC = APITOSPA(M.FOR_RAGSOC)
 	M.FOR_RAGDUE = ""
   	M.FOR_INDIR  = APITOSPA(ALLTRIM(M.ANINDIRI))
    M.FOR_LOCALI = APITOSPA(ALLTRIM(M.ANLOCALI))
    M.FOR_PROVIN = APITOSPA(ALLTRIM(M.ANPROVIN))  
    M.FOR_ZONA   = M.FOR_PROVIN      

    M.FOR_CAP    = ""
	gcFindString= M.FOR_LOCALI
	x_cond = "COMUNE = '" + gcFindString + "'"
	Csql    = "SELECT * FROM COMUNI WHERE " + x_cond
	IF !ExecCommand(cSql,"COMUNI")
	   return(.f.)
	ENDIF
	SELECT COMUNI
	GO top
	IF !EOF()
	    M.FOR_CAP   	= ALLTRIM(CAP)
    ENDIF


    SELECT IMPORTAXLS	

    M.FOR_NAZIONE = "ITA"
	M.FOR_CODFIS = APITOSPA(ALLTRIM(UPPER(M.ANCODFIS)))
	M.FOR_PARIVA = APITOSPA(ALLTRIM(UPPER(M.ANPARIVA)))	
    M.FOR_VALUTA = 'EUR'
    M.FOR_CONPAG = "101"
    M.FOR_TELEFO = APITOSPA(ALLTRIM(UPPER(M.antelefo)))	

    M.FOR_CONTO1 = ""  && ??????????????????????
    M.FOR_CONTO2 = ""  && ??????????????????????
    M.FOR_CONTO3 = ""  && ??????????????????????
    M.FOR_CONTO4 = ""  && ??????????????????????
    M.FOR_CONTO5 = ""  && ??????????????????????

	M.FOR_ccost1 = ""  && ??????????????????????
	M.FOR_ccost2 = ""  && ??????????????????????
	M.FOR_ccost3 = ""  && ??????????????????????
	M.FOR_ccost4 = ""  && ??????????????????????
	M.FOR_ccost5 = ""  && ??????????????????????

           
    M.ANCODLIN = "ITA"
	DO CASE
		CASE ALLTRIM(M.ANCODLIN) = 'ITA'
			M.CLI_LINGUA = '010'  && ITALIANO
		CASE ALLTRIM(M.ANCODLIN) = 'ING'
			M.CLI_LINGUA = '008'  && INGLESE
		OTHERWISE
			M.CLI_LINGUA = '010'  && ITALIANO
	ENDCASE    

	*!*	 ######################################################  VALORI DI DEFAULT   ###################################################à

    M.FOR_BDAL    = "0108"
    M.FOR_BAL     = "3108"
    M.FOR_GG1     = "1009"
    M.FOR_B2DAL   = "2012"
    M.FOR_B2AL    = "3112"
    M.FOR_GG2     = "1001"

    M.FOR_CLICEE  = ""
    M.FOR_IVACEE  = ""
    M.FOR_PF      = ""
    M.FOR_BPF     = ""
    M.FOR_INDEFF  = ""
    M.FOR_CODIVA  = "22"
    M.FOR_CONTO1  = "6010003"



 	M.FOR_DATNEW = RIBALTA2(DTOC(DATE()))
	M.FOR_DATINS = RIBALTA2(DTOC(DATE()))
	M.FOR_LISFOR = "ACQ"


	x_soci = "FOR_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "FOR_codcli = '" + M.FOR_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_FOR_AN where " + x_cond + " order by FOR_codsoc,FOR_codcli"


    IF !ExecRW(cSql,"U_FOR_AN","R")
 	   return(.f.)
    ENDIF

	SELECT U_FOR_AN
	GO TOP
	IF EOF()
		APPEND BLANK
		REPLACE FOR_CODSOC WITH M.FOR_CODSOC
		REPLACE FOR_CODCLI WITH M.FOR_CODCLI
		REPLACE FOR_PARIVA WITH M.FOR_PARIVA
		REPLACE FOR_CODFIS WITH M.FOR_CODFIS
		REPLACE FOR_RAGSOC WITH M.FOR_RAGSOC
		REPLACE FOR_INDIR  WITH M.FOR_INDIR
		REPLACE FOR_CAP    WITH M.FOR_CAP
		REPLACE FOR_LOCALI WITH M.FOR_LOCALI
		REPLACE FOR_NAZION WITH M.FOR_NAZION
		REPLACE FOR_VALUTA WITH M.FOR_VALUTA
		REPLACE FOR_ZONA   WITH M.FOR_ZONA
		REPLACE FOR_TELEFO WITH M.FOR_TELEFO
		REPLACE FOR_CONPAG WITH M.FOR_CONPAG
		REPLACE FOR_CODIVA WITH M.FOR_CODIVA
		REPLACE FOR_CONTO1 WITH M.FOR_CONTO1
		REPLACE FOR_LISFOR WITH M.FOR_LISFOR
		
	   	_CTR = _CTR +1
	   	WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
	ENDIF
	

	IF !ExecRW(cSql,"U_FOR_AN","W")
	   RETURN .F.
	ENDIF
    	
    SELECT IMPORTAXLS
	SKIP

ENDDO


MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale fornitori inseriti: " + ALLTRIM(STR(_CTR,10,0)),64,"Informazione")


SET DEFAULT TO &PUB_DIR

RETURN


 