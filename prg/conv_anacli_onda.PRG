*************************************************************************************************
*							CONVERSIONE ANAGRAFICA CLIENTI										*
*							 																	*
*	by Project S.r.l.																			*
*	giugno 2018 : 	Onda   					 													*
*************************************************************************************************

** ASSEGNAZIONE DELLA VARIABILE PATH **************************



V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "OND"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'OND' non configurato" + CHR(13) + CHR(13) + ;
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


RIT = MESSAGEBOX("Conversione anagrafica clienti da da foglio Excel ANAGRAFICA: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


SET DEFAULT TO &V_PATH




**** CARICAMENTO DEL FILE IN FORMATO DBF 
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF



RIT = MESSAGEBOX("Conversione anagrafica clienti da da foglio Excel ANAGRAFICA FIDO: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


SET DEFAULT TO &V_PATH




**** CARICAMENTO DEL FILE IN FORMATO DBF 
gcFileFido = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFileFido)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF



WAIT WINDOWS "Cancellazione vecchia anagrafica clienti in corso..." NOWAIT

cSql = "DELETE FROM U_CLI_AN"
IF !ExecCommand(cSql,"DEL_CLI_AN")
   return
ENDIF

cSql = "DELETE FROM U_ANA_CL"
IF !ExecCommand(cSql,"DEL_ANA_CL")
   return
ENDIF

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





CREATE CURSOR IMPORTAXLS ( ;
	RagioneSociale      C(240), ;
	NumeroBlocco        C(240), ;	
	FineValidità        C(240), ;	
	PartitaIva        	C(240), ;	
	CodiceFiscale       C(240), ;	
	CodConto        	C(240), ;	
	Indirizzo        	C(240), ;	
	Città        		C(240), ;	
	Cap        			C(240), ;	
	Provincia        	C(240), ;	
	Telefono        	C(240), ;	
	Nazione        		C(240), ;	
	Divisa        		C(240), ;	
	IdAnagrafica      	C(240), ;	
	Utente        		C(240), ;	
	UltimaModifica      C(240), ;	
	E_mail        		C(240), ;	
	VecchioCodice       C(240))	


APPEND FROM (gcFile) TYPE XLS


*!*	_COMMAND = "APPEND FROM '" + ALLTRIM(gcFile) + "'"
*!*	&_COMMAND



CREATE CURSOR IMPORTAXLSFIDO ( ;
	RagioneSociale      C(240), ;
	IdAnagrafica      	C(240), ;	
	DataUltAgg			C(240), ;	
	RitardoNrGiorni		C(240), ;	
	MaxFido				C(240))	


APPEND FROM (gcFileFido) TYPE XLS


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


    IF EMPTY(ALLTRIM(IdAnagrafica))  && SCARTO RECORD 
		LOOP
    ENDIF 


    IF ALLTRIM(RagioneSociale) = 'RagioneSociale' && SCARTO RECORD 
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
	

   	M.CLI_CODCLI = ALLTRIM(M.IdAnagrafica)
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
		SELECT IMPORTAXLS
		LOOP
	ENDIF  
  
  
  
	SELECT IMPORTAXLS
    **REPLACE AN_EMPEC    WITH "CLIENTE INESISTENTE"	&& IDENTIFICO SUL DBF DI PARTENZA IL FORNITORE DA IMPORTARE
   
     	
	M.CLI_RAGSOC = APITOSPA(ALLTRIM(M.RagioneSociale))
	M.CLI_RAGDUE = '' 
	M.CLI_INDIR  = APITOSPA(ALLTRIM(M.Indirizzo)) 
	M.CLI_CAP    = ALLTRIM(M.Cap)
	M.CLI_LOCALI = APITOSPA(ALLTRIM(M.Città)) 
	M.CLI_PROVIN = ALLTRIM(M.Provincia)
	M.CLI_NAZION = ALLTRIM(M.Nazione)
	IF EMPTY(M.CLI_NAZION)
		M.CLI_NAZION = 'ITA'
	ENDIF
	IF ALLTRIM(M.CLI_NAZION) = "IT"
		M.CLI_NAZION = 'ITA'
	ENDIF	
	
	M.CLI_CODFIS = ALLTRIM(M.CodiceFiscale)
	M.CLI_PARIVA = ALLTRIM(M.PartitaIva)
	M.CLI_TELEFO = ALLTRIM(M.Telefono)
	M.CLI_FAX    = ""
	M.CLI_TELEX  = ""
	M.CLI_HOMPAG = ""
	M.CLI_EMAIL  = ALLTRIM(M.E_mail)
	M.CLI_RECCAT = 0
	M.CLI_ESTCOM = ""
	M.CLI_ESTNAS = ""
	
	M.CLI_CODIVA = "22"	&& CONVERTE_CODICE_IVA_ZUCCHETTI(ALLTRIM(M.ANCODIVA))
	
	M.CLI_VALIMP   	= 0
    M.CLI_NUMINSOL 	= 0

	IF SUBSTR(M.CLI_RAGSOC,1,1)= '.'
		m.cli_obsol = "S"
	ENDIF

    
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

	M.CLI_LINGUA = "010"  && ITALIANO

	M.CLI_VALUTA = "EUR"


	*** ################################## CREA PARAMETRO ZONA ##################################
	*!*	ACCESSO PER DESCRIZIONE PARAMETRO AL PARAMETRO ZONA

	M.CLI_ZONA = "01"
	
	
	
*!*		gcFindString= ALLTRIM(M.CLI_ZONA)
*!*		TIPO_PARAMETRO = "ZON"
*!*		X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
*!*		X_CODICE = "DESCRI = '" + gcFindString + "'"
*!*		x_cond = x_chiave  + " and " + x_codice 
*!*		Csql    = "SELECT * FROM PARA WHERE " + x_cond
*!*		IF !ExecCommand(cSql,"zon_para")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT zon_para
*!*		GO top
*!*		IF !EOF()
*!*		    M.CLI_ZONA   	= SUBSTR(CODICE,4,3)
*!*		ELSE
*!*			x_codi = "codice = 'ZON"+M.CLI_ZONA+"'"
*!*			x_cond = x_codi
*!*			cSql = "select * from PARA where " + x_cond
*!*			IF !ExecRW(cSql,"PARA","R")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT PARA
*!*			GO TOP
*!*			IF EOF()
*!*			   APPEND BLANK
*!*			   V1 = "ZON"+M.CLI_ZONA
*!*			   REPLACE CODICE WITH V1
*!*			   REPLACE DESCRI WITH 'ZONA : '+ALLTRIM(M.CLI_ZONA) +' ????'
*!*			ENDIF
*!*			IF !ExecRW(cSql,"PARA","W")
*!*			   return(.f.)
*!*			ENDIF
*!*		ENDIF       				
 	SELECT IMPORTAXLS 
 
	*** ################################## CREA PARAMETRO ZONA ##################################


    M.CLI_AGE = "001"  

	IF EMPTY(M.CLI_AGE)
	   M.CLI_AGE = '001'
	ENDIF 
	
	M.CLI_SC1 = 0
	M.CLI_SC2 = 0
	
		
	M.CLI_CONPAG = "101"  	&& CONVERTE_CODICE_CPA_ZUCCHETTI(ALLTRIM(M.ANCODPAG))	
	
	M.CLI_BAE 	 = ''
	M.CLI_NUMCC  = ''	
	M.CLI_LISCLI = ''

	
	M.CLI_DATNEW = RIBALTA2(DTOC(DATE()))
	M.CLI_DATINS = RIBALTA2(DTOC(DATE()))



*!*	   	SELECT curs_U_CLI_AN				&& SALVATAGGIO PER ELENCO CLIENTI INESISTENTI DA VERIFICARE
*!*	    APPEND BLANK
*!*	   	GATHER MEMVAR MEMO 					  
*!*	    SCATTER MEMVAR MEMO


	
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



**==> AGGIORNAMENTO FIDO CLIENTE

SELECT IMPORTAXLSFIDO
GO TOP 
SCAN   


    IF EMPTY(ALLTRIM(IdAnagrafica))  && SCARTO RECORD 
		LOOP
    ENDIF 


    IF ALLTRIM(RagioneSociale) = 'RagioneSociale' && SCARTO RECORD 
		LOOP
    ENDIF 

    SCATTER MEMVAR MEMO
    
        
    
	WAIT WINDOWS "Conversione Cliente " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
	
   	M.CLI_CODCLI = ALLTRIM(M.IdAnagrafica)
    M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(M.CLI_CODCLI))  
    M.CLI_IMPFID = VAL(ALLTRIM(M.MAXFIDO))
  
	*!*	VERIFICO SE GIA' ESISTE IN AQUARIUS IL CLIENTE E NEL CASO LO SCARTO
  
	x_soci = "CLI_CODSOC = '" + PUB_CODSOC + "'"
	x_codi = "CLI_CODCLI = '" + M.CLI_CODCLI+ "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "SELECT * FROM U_CLI_AN WHERE " + x_cond
	
	IF !ExecRW(cSql,"U_CLI_AN","R")
		RETURN .F.
	ENDIF

	IF RECCOUNT() = 0
	ELSE
	   REPLACE CLI_IMPFID WITH M.CLI_IMPFID 
	   REPLACE CLI_CLFIDO WITH 'A'
	ENDIF 
	IF !ExecRW(cSql,"U_CLI_AN","W")
	   return(.f.)
	ENDIF


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




*!*	SELECT curs_U_CLI_AN
*!*	GO TOP
*!*	COPY TO ANACLI_INE SDF



MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale clienti convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 