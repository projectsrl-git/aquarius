*************************************************************************************************
*							CONVERSIONE ANAGRAFICA CLIENTI										*
*							 																	*
*	by Project S.r.l.																			*
*	dicembre 2013 : Rumi					 													*
*************************************************************************************************

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

**** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF

RIT = MESSAGEBOX("Conversione anagrafica clienti da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


WAIT WINDOWS "Cancellazione vecchia anagrafica clienti in corso..." NOWAIT

cSql = "DELETE FROM U_CLI_AN"
IF !ExecCommand(cSql,"DEL_CLI_AN")
   return
ENDIF


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA ZONE" NOWAIT
cSql = "delete from PARA where CODICE LIKE 'ZON%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF


*!*	WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA NAZIONI" NOWAIT
*!*	cSql = "delete from PARA where CODICE LIKE 'STA%' "
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF


*!*	*WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA AGENTI" NOWAIT
*!*	cSql = "delete from PARA where CODICE LIKE 'AGE%' "
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF

*!*	*WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA AGENTI" NOWAIT
*!*	cSql = "delete from U_AGE_AN"
*!*	IF !ExecCommand(cSql,"U_AGE_AN")
*!*	   return(.f.)
*!*	ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CODICE_ZONA,_CODICE_AGENTE 
PUBLIC _CODICE_ZONA,_CODICE_AGENTE 
_CODICE_ZONA = 0
_CODICE_AGENTE  = 0


WAIT WINDOWS "Conversione anagrafica clienti in corso..." NOWAIT		

CREATE CURSOR IMPORTAXLS ( ;
	ANTIPCON  C(1), ;
	ANCODICE  C(15), ;
	ANDESCRI  C(100), ;
	ANDESCR2  C(100), ;
	ANINDIRI  C(100), ;
	ANINDIR2  C(100), ;
	AN___CAP  C(5), ;
	ANLOCALI  C(50), ;
	ANPROVIN  C(2), ;
	ANNAZION  C(3), ;
	ANCODFIS  C(16), ;
	ANPARIVA  C(11), ;
	ANTELEFO  C(50), ;
	ANTELFAX  C(50), ;
	ANNUMCEL  C(50), ;
	ANINDWEB  C(100), ;
	AN_EMAIL  C(100), ;
	ANPERFIS  C(1), ;
	ANFLGIS4  C(1), ;
	ANLOCNAS  C(50), ;
	ANDATNAS  C(20), ;
	ANPRONAS  C(2), ;
	AN_SESSO  C(1), ;
	ANDTINVA  C(20), ;
	ANDTOBSO  C(20), ;
	ANCONSUP  C(4), ;
	ANCATCON  C(10), ;
	ANTIPRIF  C(1), ;
	ANCONRIF  C(100), ;
	ANCODIVA  C(5), ;
	ANFLESIG  C(1), ;
	ANPARTSN  C(1), ;
	AFFLINTR  C(1), ;
	ANPRIPIA  N(10,0), ;
	ANCATCOM  C(3), ;
	ANCATSCM  C(100), ;
	ANGRUPRO  C(5), ;
	ANCODLIN  C(3), ;
	ANCODVAL  C(3), ;
	ANNUMLIS  C(100), ;
	AN1SCONT  N(3,0), ;
	AN2SCONT  N(3,0), ;
	ANCODZON  C(3), ;
	ANCODAG1  C(3), ;
	ANCODAG2  C(3), ;
	ANTIPFAT  C(1), ;
	ANCONCON  C(1), ;
	ANBOLFAT  C(1), ;
	ANPREBOL  C(1), ;
	ANSCORPO  C(1), ;
	ANFLCODI  C(1), ;
	ANCODPAG  C(4), ;
	ANGIOFIS  N(10,0), ;
	AN1MESCL  N(10,0), ;
	ANGIOSC1  N(10,0), ;
	AN2MESCL  N(10,0), ;
	ANGIOSC2  N(10,0), ;
	ANCODBAN  C(10), ;
	ANNUMCOR  C(12), ;
	ANCODBA2  C(10), ;
	ANFLRAGG  C(1), ;
	ANFLGAVV  C(1), ;
	ANDATAVV  C(20), ;
	ANFLFIDO  C(1), ;
	ANFLBLVE  C(1), ;
	ANVALFID  N(17,2), ;
	ANMAXORD  N(17,2), ;
	ANPAGPAR  C(100), ;
	ANDATMOR  C(20), ;
	ANSTACON  C(3), ;
	ANCHKSTA  C(100), ;
	ANCHKMAI  C(100), ;
	ANCHKFAX  C(100), ;
	ANCHKWWP  C(100), ;
	ANCHKPTL  C(100), ;
	ANESTCOD  C(100), ;
	ANGESGRU  C(1), ;
	ANFATDIF  C(100), ;
	ANCHKCPZ  C(100), ;
	ANTIPOPE  C(100), ;
	ANINTMOR  C(1), ;
	ANMORTAS  N(10,0), ;
	ANFLSGRE  C(1), ;
	ANFLINCA  C(1), ;
	ANSPEINC  N(17,2), ;
	ANFLIMBA  C(1), ;
	ANCOGNOM  C(100), ;
	AN__NOME  C(100), ;
	ANFLGCPZ  C(1), ;
	ANFLPRIV  C(1), ;
	ANCOFAST  C(100), ;
	ANRITENU  C(100), ;
	ANTIPSOT  C(100), ;
	ANRISESE  C(100), ;
	ANCCNOTE  C(100), ;
	ANCCTAGG  C(100), ;
	ANNOTAIN  N(10,0), ;
	ANTIPCLF  C(100), ;
	ANFLCONA  C(1), ;
	ANCOIMPS  C(100), ;
	ANPEINPS  N(10,0), ;
	ANRIINPS  N(10,0), ;
	ANCOINPS  N(10,0), ;
	ANCODATT  N(10,0), ;
	ANCODTRI  C(100), ;
	ANCODTR2  C(100), ;
	ANMAGTER  C(100), ;
	ANACCATT  C(100), ;
	ANCODASS  C(100), ;
	ANBENDEP  C(100), ;
	ANCODIRP  C(100), ;
	ANCAURIT  C(100), ;
	ANCASPRO  N(10,0), ;
	ANCATOPE  C(2), ;
	ANFLGEST  C(1), ;
	ANCOFISC  C(16), ;
	GESTGUID  C(14), ;
	ANCOFASS  C(100), ;
	ANFLGDIS  C(100), ;
	ANRATATT  C(100), ;
	ANRATPAS  C(100), ;
	ANRISATT  C(100), ;
	ANRISPAS  C(100), ;
	ANFLCLIS  C(100), ;
	ANIDRIDY  C(1), ;
	ANTIIDRI  N(10,0), ;
	ANCOIDRI  C(100), ;
	ANFLRITE  C(100), ;
	ANCODIRP1 C(100), ;
	ANCACLFO  C(100), ;
	ANGESCRE  C(100), ;
	ANCODPOR  C(100), ;
	ANNUMCAR  C(100), ;
	ANDATBLO  C(100), ;
	ANVALEXF  N(10,0), ;
	ANCLARIS  C(100))


APPEND FROM (gcFile) TYPE XLS

_TOT_COUNT = 0



* -->> Creazione cursore vuoto
* ----------------------------
IF !ExecCommand("select * from u_cli_an where 0=1","u_cli_an")
   return(.f.)
ENDIF
SELECT u_cli_an
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK

SELECT IMPORTAXLS
GO TOP 
SCAN   

    IF UPPER(ALLTRIM(ANCODICE)) = "ANCODICE"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
		LOOP
    ENDIF 

    SCATTER MEMVAR MEMO
    
	WAIT WINDOWS "Conversione Cliente " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
	
	cSql = "SELECT * FROM U_CLI_AN WHERE 1=0"
	IF !ExecCommand(cSql,"CX_CLI_AN")
	   RETURN .F.
	ENDIF
	
	SCATTER MEMVAR MEMO BLANK
	
	M.CLI_CODSOC = PUB_CODSOC
	
    IF LEN(ALLTRIM(M.ANCODICE)) = 15
    	M.CLI_CODCLI = SUBSTR(M.ANCODICE,8,8)
    ELSE
    	M.CLI_CODCLI = ALLTRIM(M.ANCODICE)
    ENDIF
    
    M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(M.CLI_CODCLI))   	
	M.CLI_RAGSOC = APITOSPA(ALLTRIM(M.ANDESCRI))
	M.CLI_RAGDUE = APITOSPA(ALLTRIM(M.ANDESCR2))
	M.CLI_INDIR  = APITOSPA(ALLTRIM(M.ANINDIRI)) + " " + APITOSPA(ALLTRIM(M.ANINDIR2))
	M.CLI_CAP    = ALLTRIM(M.AN___CAP)
	M.CLI_LOCALI = APITOSPA(ALLTRIM(M.ANLOCALI)) 
	M.CLI_PROVIN = ALLTRIM(M.ANPROVIN)
	M.CLI_NAZION = ALLTRIM(M.ANNAZION)
	IF EMPTY(M.CLI_NAZION)
		M.CLI_NAZION = 'ITA'
	ENDIF
	M.CLI_CODFIS = ALLTRIM(M.ANCODFIS)
	M.CLI_PARIVA = ALLTRIM(M.ANPARIVA)
	M.CLI_TELEFO = ALLTRIM(M.ANTELEFO)
	M.CLI_FAX    = ALLTRIM(M.ANTELFAX)
	M.CLI_TELEX  = ALLTRIM(M.ANNUMCEL)
	M.CLI_HOMPAG = ALLTRIM(M.ANINDWEB)
	M.CLI_EMAIL  = ALLTRIM(M.AN_EMAIL)
	M.CLI_RECCAT = IIF(M.ANPERFIS = 'S',2,1)
	M.CLI_ESTCOM = APITOSPA(ALLTRIM(M.ANLOCNAS))
	M.CLI_ESTNAS = SUBSTR(M.ANDATNAS,1,10)
	
	M.CLI_CODIVA = CONVERTE_CODICE_IVA_ZUCCHETTI(ALLTRIM(M.ANCODIVA))
	
	M.CLI_VALIMP   	= 0
    M.CLI_NUMINSOL 	= 0

    
    M.CLI_LINGUA 	= ""

    M.CLI_ABI  		= ""
    M.CLI_CAB  		= ""
    M.CLI_ABI2 		= ""
    M.CLI_CAB2 		= ""
    M.CLI_MEZZO 	= ""


    M.CLI_LISTIN 	= ""
    M.CLI_SC1 		= ""
    M.CLI_BOLLI 	= ""
    M.CLI_SPINCA 	= 0

    M.CLI_BDAL    = "0108"
    M.CLI_BAL     = "3108"
    M.CLI_GG1     = "1009"
    M.CLI_B2DAL   = "2012"
    M.CLI_B2AL    = "3112"
    M.CLI_GG2     = "1001"
    M.CLI_TIPFAT  = "FDV"
    M.CLI_FLGTRA  = .T.


	M.CLI_01DAL = '0101'
	M.CLI_02DAL = '0102'
	M.CLI_03DAL = '0103'
	M.CLI_04DAL = '0104'
	M.CLI_05DAL = '0105'
	M.CLI_06DAL = '0106'
	M.CLI_07DAL = '0107'
	M.CLI_09DAL = '0109'
	M.CLI_10DAL = '0110'
	M.CLI_11DAL = '0111'


	M.CLI_01AL = '3101'
	M.CLI_02AL = '2802'
	M.CLI_03AL = '3103'
	M.CLI_04AL = '3004'
	M.CLI_05AL = '3105'
	M.CLI_06AL = '3006'
	M.CLI_07AL = '3107'
	M.CLI_09AL = '3009'
	M.CLI_10AL = '3110'
	M.CLI_11AL = '3011'


	M.CLI_01GG = '0502'
	M.CLI_02GG = '0503'
	M.CLI_03GG = '0504'
	M.CLI_04GG = '0505'
	M.CLI_05GG = '0506'
	M.CLI_06GG = '0507'
	M.CLI_07GG = '0509'
	M.CLI_09GG = '0510'
	M.CLI_10GG = '0511'
	M.CLI_11GG = '0512'

    M.CLI_CONTO1 = ""  && ??????????????????????
    M.CLI_CONTO2 = ""  && ??????????????????????
    M.CLI_CONTO3 = ""  && ??????????????????????
    M.CLI_CONTO4 = ""  && ??????????????????????
    M.CLI_CONTO5 = ""  && ??????????????????????

	M.CLI_ccost1 = ""  && ??????????????????????
	M.CLI_ccost2 = ""  && ??????????????????????
	M.CLI_ccost3 = ""  && ??????????????????????
	M.CLI_ccost4 = ""  && ??????????????????????
	M.CLI_ccost5 = ""  && ??????????????????????




 	M.CLI_DATNEW = RIBALTA2(DTOC(DATE()))
	M.CLI_DATINS = RIBALTA2(DTOC(DATE()))
	
	M.CLI_ENPACL = 0
	M.CLI_RA     = 0

	DO CASE
		CASE ALLTRIM(M.ANCODLIN) = 'ITA'
			M.CLI_LINGUA = '010'  && ITALIANO
		CASE ALLTRIM(M.ANCODLIN) = 'ING'
			M.CLI_LINGUA = '008'  && INGLESE
		OTHERWISE
			M.CLI_LINGUA = '010'  && ITALIANO
	ENDCASE
	M.CLI_VALUTA = ALLTRIM(M.ANCODVAL)
    IF EMPTY(M.CLI_VALUTA)
    	M.CLI_VALUTA = 'EUR'
    ENDIF 


	*** ################################## CREA PARAMETRO ZONA ##################################
	*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO ZONA

	*M.CLI_ZONA = ALLTRIM(M.ANCODZON)
	M.CLI_ZONA = ALLTRIM(M.ANPROVIN)


	gcFindString= ALLTRIM(M.CLI_ZONA)
	TIPO_PARAMETRO = "ZON"
	X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
	X_CODICE = "DESCRI = '" + gcFindString + "'"
	x_cond = x_chiave  + " and " + x_codice 
	Csql    = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecCommand(cSql,"zon_para")
	   return(.f.)
	ENDIF
	SELECT zon_para
	GO top
	IF !EOF()
	    M.CLI_ZONA   	= SUBSTR(CODICE,4,3)
	ELSE
		x_codi = "codice = 'ZON"+M.CLI_ZONA+"'"
		x_cond = x_codi
		cSql = "select * from PARA where " + x_cond
		IF !ExecRW(cSql,"PARA","R")
		   return(.f.)
		ENDIF
		SELECT PARA
		GO TOP
		IF EOF()
		   APPEND BLANK
		   V1 = "ZON"+M.CLI_ZONA
		   REPLACE CODICE WITH V1
		   REPLACE DESCRI WITH ALLTRIM(M.CLI_ZONA)
		ENDIF
		IF !ExecRW(cSql,"PARA","W")
		   return(.f.)
		ENDIF
	ENDIF       				
 	SELECT IMPORTAXLS 
 
	*** ################################## CREA PARAMETRO ZONA ##################################


    M.CLI_AGE = ALLTRIM(M.ANCODAG1)  

	IF EMPTY(M.CLI_AGE)
	   M.CLI_AGE = '000'
	ENDIF 
	
	M.CLI_SC1 = M.AN1SCONT
	M.CLI_SC2 = M.AN2SCONT
	
		
	M.CLI_CONPAG = CONVERTE_CODICE_CPA_ZUCCHETTI(ALLTRIM(M.ANCODPAG))	
	
	M.CLI_BAE 	 = ALLTRIM(M.ANCODBAN)
	M.CLI_NUMCC  = ALLTRIM(M.ANNUMCOR)	
	M.CLI_LISCLI = ALLTRIM(M.ANNUMLIS)

	
	M.CLI_DATNEW = RIBALTA2(DTOC(DATE()))
	M.CLI_DATINS = RIBALTA2(DTOC(DATE()))
	
	cSql = "SELECT * FROM U_CLI_AN WHERE 1=0"
	IF !ExecRW(cSql,"U_CLI_AN","R")
	   RETURN .F.
	ENDIF
	SELECT U_CLI_AN
	APPEND BLANK
    DO u_cli_an


	IF !ExecRW(cSql,"U_CLI_AN","W")
	   RETURN .F.
	ENDIF
		   
   	_TOT_COUNT = _TOT_COUNT + 1
ENDSCAN

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale clienti convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 