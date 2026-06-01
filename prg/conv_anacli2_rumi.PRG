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


*!*	WAIT WINDOWS "Cancellazione vecchia anagrafica clienti in corso..." NOWAIT

*!*	cSql = "DELETE FROM U_CLI_AN"
*!*	IF !ExecCommand(cSql,"DEL_CLI_AN")
*!*	   return
*!*	ENDIF


*!*	WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA ZONE" NOWAIT
*!*	cSql = "delete from PARA where CODICE LIKE 'ZON%' "
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF


*!*	WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA NAZIONI" NOWAIT
*!*	cSql = "delete from PARA where CODICE LIKE 'STA%' "
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CODICE_ZONA,_CODICE_AGENTE 
PUBLIC _CODICE_ZONA,_CODICE_AGENTE 
_CODICE_ZONA = 0
_CODICE_AGENTE  = 0


WAIT WINDOWS "Conversione anagrafica clienti RIDOTTA in corso..." NOWAIT		


CREATE CURSOR IMPORTAXLS ( ;
	ANTIPCON  C(1), ;
	ANCODICE  C(15), ;
	ANDESCRI  C(100), ;
	ANINDIRI  C(100), ;
	ANTELEFO  C(50), ;
	ANPARIVA  C(11), ;
	ANCODFIS  C(16), ;
	ANLOCALI  C(50), ;
	ANPROVIN  C(2))

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
	M.CLI_RAGDUE = ''
	M.CLI_INDIR  = APITOSPA(ALLTRIM(M.ANINDIRI))  
	M.CLI_LOCALI = APITOSPA(ALLTRIM(M.ANLOCALI)) 
	M.CLI_PROVIN = ALLTRIM(M.ANPROVIN)

    M.CLI_CAP    = ""
	gcFindString= M.CLI_LOCALI
	x_cond = "COMUNE = '" + gcFindString + "'"
	Csql    = "SELECT * FROM COMUNI WHERE " + x_cond
	IF !ExecCommand(cSql,"COMUNI")
	   return(.f.)
	ENDIF
	SELECT COMUNI
	GO top
	IF !EOF()
	    M.CLI_CAP   	= ALLTRIM(CAP)
    ENDIF

    SELECT IMPORTAXLS

	M.CLI_NAZION = 'ITA'

	M.CLI_CODFIS = ALLTRIM(M.ANCODFIS)
	M.CLI_PARIVA = ALLTRIM(M.ANPARIVA)
	M.CLI_TELEFO = ALLTRIM(M.ANTELEFO)
	
	
	M.CLI_CODIVA = "22"
	
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
	M.ANCODLIN   = 'ITA'


	DO CASE
		CASE ALLTRIM(M.ANCODLIN) = 'ITA'
			M.CLI_LINGUA = '010'  && ITALIANO
		CASE ALLTRIM(M.ANCODLIN) = 'ING'
			M.CLI_LINGUA = '008'  && INGLESE
		OTHERWISE
			M.CLI_LINGUA = '010'  && ITALIANO
	ENDCASE
  
   	M.CLI_VALUTA = 'EUR'


	*** ################################## CREA PARAMETRO ZONA ##################################
	*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO ZONA



	M.CLI_ZONA = ALLTRIM(M.ANPROVIN)

	IF !EMPTY(ALLTRIM(M.CLI_ZONA))
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
	ENDIF
	
 	SELECT IMPORTAXLS 
 
	*** ################################## CREA PARAMETRO ZONA ##################################


    M.CLI_AGE = '000'
	
	M.CLI_SC1 = 0
	M.CLI_SC2 = 0
	
		
	M.CLI_CONPAG = '001'
	
	M.CLI_BAE 	 = ''
	M.CLI_NUMCC  = ''	
	*M.CLI_LISCLI = ''
	M.CLI_CONTO1 = "8010001"

	
	M.CLI_DATNEW = RIBALTA2(DTOC(DATE()))
	M.CLI_DATINS = RIBALTA2(DTOC(DATE()))
	
            
	x_codi = "cli_codcli = '" + M.CLI_CODCLI + "'"
	cSql="SELECT * FROM U_CLI_AN WHERE "+ x_codi + " order by cli_codcli"
    IF !ExecRW(cSql,"u_cli_an","R")
 	   return(.f.)
    ENDIF

	SELECT u_cli_an
	IF EOF()
	
		APPEND BLANK
		REPLACE CLI_CODSOC WITH M.CLI_CODSOC
		REPLACE CLI_CODCLI WITH M.CLI_CODCLI
		REPLACE CLI_PARIVA WITH M.CLI_PARIVA
		REPLACE CLI_CODFIS WITH M.CLI_CODFIS
		REPLACE CLI_RAGSOC WITH M.CLI_RAGSOC
		REPLACE CLI_INDIR  WITH M.CLI_INDIR
		REPLACE CLI_LOCALI WITH M.CLI_LOCALI
		REPLACE CLI_NAZION WITH M.CLI_NAZION
		REPLACE CLI_ZONA   WITH M.CLI_ZONA
		REPLACE CLI_AGE    WITH M.CLI_AGE
		REPLACE CLI_TELEFO WITH M.CLI_TELEFO
		REPLACE CLI_CONPAG WITH M.CLI_CONPAG
		REPLACE CLI_BAE    WITH M.CLI_BAE
		REPLACE CLI_CODIVA WITH M.CLI_CODIVA
		REPLACE CLI_VALUTA WITH M.CLI_VALUTA
		REPLACE CLI_CONTO1 WITH M.CLI_CONTO1
   		_TOT_COUNT = _TOT_COUNT + 1		
	
	ENDIF
		
	IF !ExecRW(cSql,"U_CLI_AN","W")
	   RETURN .F.
	ENDIF
		   

 	SELECT IMPORTAXLS 

ENDSCAN

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale clienti inseriti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 