*************************************************************************************************
*							CONVERSIONE ANAGRAFICA CLIENTI										*
*							 																	*
*	by Project S.r.l.																			*
*	giugno 2017 : 	Impresind				 													*
*************************************************************************************************

** ASSEGNAZIONE DELLA VARIABILE PATH **************************



V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "IMP"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'IMP' non configurato" + CHR(13) + CHR(13) + ;
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


RIT = MESSAGEBOX("Conversione anagrafica clienti da .DBF: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


SET DEFAULT TO &V_PATH




**** CARICAMENTO DEL FILE IN FORMATO DBF 
gcFile = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF



*!*	WAIT WINDOWS "Cancellazione vecchia anagrafica clienti in corso..." NOWAIT

*!*	*!*	cSql = "DELETE FROM U_CLI_AN"
*!*	*!*	IF !ExecCommand(cSql,"DEL_CLI_AN")
*!*	*!*	   return
*!*	*!*	ENDIF


*!*	*!*	WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA ZONE" NOWAIT
*!*	*!*	cSql = "delete from PARA where CODICE LIKE 'ZON%' "
*!*	*!*	IF !ExecCommand(cSql,"PARA")
*!*	*!*	   return(.f.)
*!*	*!*	ENDIF


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

*!*	IF !ExecCommand("select * from U_CLI_AN where 1=0","curs_U_CLI_AN")
*!*	   return
*!*	ENDIF


CREATE CURSOR curs_U_CLI_AN (CLI_CODCLI C(10), ;
					   CLI_RAGSOC  C(90))



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CODICE_ZONA,_CODICE_AGENTE 
PUBLIC _CODICE_ZONA,_CODICE_AGENTE 
_CODICE_ZONA = 0
_CODICE_AGENTE  = 0


WAIT WINDOWS "Conversione anagrafica clienti in corso..." NOWAIT		



_TOT_COUNT = 0



CREATE CURSOR IMPORTADBF ( ;
	TIPO            C(1), ;
	ANCODICE        C(15), ;
	ANDESCRI        C(60), ;
	ANTIPCON        C(1), ;
	ANDESCR2        C(60), ;
	ANINDIRI        C(35), ;
	AN___CAP        C(9), ;
	ANLOCALI        C(30), ;
	ANPROVIN        C(2), ;
	ANNAZION        C(3), ;
	ANTELEFO        C(18), ;
	ANTELFAX        C(18), ;
	ANNUMCEL        C(18), ;
	ANPERFIS        C(1), ;
	AN_SESSO        C(1), ;
	ANDATNAS        C(10), ;
	ANLOCNAS        C(30), ;
	ANPRONAS        C(2), ;
	ANCODFIS        C(16), ;
	ANPARIVA        C(12), ;
	ANCATCON        C(5), ;
	ANPARTSN        C(1), ;
	ANCODPAG        C(5), ;
	ANCODZON        C(3), ;
	ANCODAG1        C(5), ;
	ANCODVAL        C(3), ;
	ANCODBAN        C(10), ;
	AN1MESCL        N(11), ;
	ANGIOSC1        N(11), ;
	AN2MESCL        N(11), ;
	ANGIOSC2        N(11), ;
	AN1SCONT        N(8,2), ;
	AN2SCONT        N(8,2), ;
	ANNUMLIS        C(5), ;
	ANTIPFAT        C(1), ;
	ANBOLFAT        C(1), ;
	ANPREBOL        C(1), ;
	ANSCORPO        C(1), ;
	ANCODLIN        C(3), ;
	ANNUMCOR        C(25), ;
	AN__NOTE        C(100), ;
	ANCATCOM        C(3), ;
	ANINDWEB        C(254), ;
	AN_EMAIL        C(254), ;
	ANCONSUP        C(15), ;
	ANDTOBSO        C(10), ;
	DDNOMDES        C(40), ;
	DDCODDES        C(5), ;
	DDTIPRIF        C(2), ;
	ANFLFIDO        C(1), ;
	ANVALFID        N(20,4), ;
	ANMAXORD        N(20,4), ;
	ANFLBLVE        C(1), ;
	ANDATMOR        C(10), ;
	ANGIOFIS        N(11), ;
	ANCATSCM        C(5), ;
	ANRITENU        C(1), ;
	ANCOGNOM        C(50), ;
	AN__NOME        C(50), ;
	ANTIPSOT        C(1), ;
	ANCCNOTE        C(50), ;
	ANCCTAGG        C(1), ;
	ANDTINVA        C(10), ;
	ANNOTAIN        N(11), ;
	ANTIPCLF        C(1), ;
	ANFLRAGG        C(1), ;
	ANDATAVV        C(10), ;
	ANFLGAVV        C(1), ;
	ANTIPRIF        C(1), ;
	ANCONRIF        C(15), ;
	ANFLESIG        C(1), ;
	ANFLCODI        C(1), ;
	ANCODIVA        C(5), ;
	AFFLINTR        C(1), ;
	ANCONCON        C(1), ;
	ANPAGPAR        C(5), ;
	ANFLCONA        C(1), ;
	ANCOIMPS        C(20), ;
	ANPEINPS        N(8,2), ;
	ANRIINPS        N(8,2), ;
	ANCOINPS        N(8,2), ;
	ANCODATT        N(11), ;
	ANCODTR2        C(5), ;
	ANGESCON        C(1), ;
	ANFLGCON        C(1), ;
	ANCODSTU        C(10), ;
	ANMAGTER        C(5), ;
	ANIBARID        C(16), ;
	ANFLAACC        C(1), ;
	ANRISESE        C(1), ;
	ANGRUPRO        C(5), ;
	ANCODBA2        C(15), ;
	FIDPAP          N(20,4), ;
	FIDESC          N(20,4), ;
	FIDESO          N(20,4), ;
	FIDORD          N(20,4), ;
	FIDDDT          N(20,4), ;
	FIDFAT          N(20,4), ;
	FIDDAT          C(10), ;
	ANINDIR2        C(35), ;
	ANFLSGRE        C(1), ;
	ANSPEINC        N(11,2), ;
	ANFLINCA        C(1), ;
	ANTIPOPE        C(10), ;
	ANFLRITE        C(1), ;
	ANCODIRP        C(5), ;
	AN__IBAN        C(35), ;
	AN__BBAN        C(30), ;
	ANTIPOCL        C(5), ;
	ANPAGFOR        C(5), ;
	ANDESCR3        C(60), ;
	ANDESCR4        C(60), ;
	ANINDIR3        C(35), ;
	ANINDIR4        C(35), ;
	ANLOCAL2        C(30), ;
	COINDMAI        C(254), ;
	CONUMTEL        C(20), ;
	CORIFPER        C(125), ;
	CONUMCEL        C(20), ;
	AN_EMPEC        C(254))		

_COMMAND = "APPEND FROM '" + ALLTRIM(gcFile) + "'"
&_COMMAND


* -->> Creazione cursore vuoto
* ----------------------------
IF !ExecCommand("select * from u_cli_an where 0=1","u_cli_an")
   return(.f.)
ENDIF
SELECT u_cli_an
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK

SELECT IMPORTADBF
GO TOP 
SCAN   


    IF EMPTY(ALLTRIM(ANCODICE))  && SCARTO RECORD 
		LOOP
    ENDIF 


    IF ALLTRIM(TIPO) = 'B' && SCARTO RECORD 
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
	

   	M.CLI_CODCLI = ALLTRIM(M.ANCODICE)
    M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(M.CLI_CODCLI))  
    
  
	*!*	VERIFICO SE GIA' ESISTE IN AQUARIUS IL CLIENTE E NEL CASO LO SCARTO
  
	x_soci = "CLI_CODSOC = '" + PUB_CODSOC + "'"
	x_codi = "CLI_CODCLI = '" + M.CLI_CODCLI+ "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "SELECT * FROM U_CLI_AN WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_CLI_AN")
		RETURN .F.
	ENDIF
	SELECT CX_CLI_AN
	GO TOP
	IF !EOF()
		SELECT IMPORTADBF
		LOOP
	ENDIF  
  
  
  
	SELECT IMPORTADBF
    **REPLACE AN_EMPEC    WITH "CLIENTE INESISTENTE"	&& IDENTIFICO SUL DBF DI PARTENZA IL FORNITORE DA IMPORTARE
   
     	
	M.CLI_RAGSOC = APITOSPA(ALLTRIM(M.ANDESCRI))
	M.CLI_RAGDUE = '' && APITOSPA(ALLTRIM(M.ANDESCR2))
	M.CLI_INDIR  = APITOSPA(ALLTRIM(M.ANINDIRI)) && + " " + APITOSPA(ALLTRIM(M.ANINDIR2))
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

    M.CLI_CONTO1 = ""  
    M.CLI_CONTO2 = ""  
    M.CLI_CONTO3 = ""  
    M.CLI_CONTO4 = ""  
    M.CLI_CONTO5 = ""  

	M.CLI_ccost1 = ""  
	M.CLI_ccost2 = ""  
	M.CLI_ccost3 = ""  
	M.CLI_ccost4 = ""  
	M.CLI_ccost5 = ""  




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

	M.CLI_ZONA = ALLTRIM(M.ANCODZON)
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
		   REPLACE DESCRI WITH 'ZONA : '+ALLTRIM(M.CLI_ZONA) +' ????'
		ENDIF
		IF !ExecRW(cSql,"PARA","W")
		   return(.f.)
		ENDIF
	ENDIF       				
 	SELECT IMPORTADBF 
 
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



   	SELECT curs_U_CLI_AN				&& SALVATAGGIO PER ELENCO CLIENTI INESISTENTI DA VERIFICARE
    APPEND BLANK
   	GATHER MEMVAR MEMO 					  
    SCATTER MEMVAR MEMO


	
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


WAIT WINDOWS "Completamento dati anagrafici clienti in corso..." NOWAIT

cSql = "DELETE FROM U_ANA_CL"
IF !ExecCommand(cSql,"DEL_CLI_AN")
   return
ENDIF

cSql = "INSERT INTO U_ANA_CL (CLI_CODSOC, CLI_CODCLI) (SELECT CLI_CODSOC, CLI_CODCLI FROM U_CLI_AN)"
IF !ExecCommand(cSql,"DEL_CLI_AN")
   return
ENDIF




SELECT curs_U_CLI_AN
GO TOP
COPY TO ANACLI_INE SDF



MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale clienti convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 