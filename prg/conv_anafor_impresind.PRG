*************************************************************************************************
*							CONVERSIONE ANAGRAFICA FORNITORI									*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2016 : Im,presind			 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica fornitori in formato DBF ?",292,"ATTENZIONE")
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


SET DEFAULT TO &V_PATH 

****** DEFINIZIONE DEI CURSORI STP


*!*	WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA FORNITORI" NOWAIT

*!*	IF !ExecCommand("select * from U_FOR_AN where 1=0","curs_U_FOR_AN")
*!*	   return
*!*	ENDIF

CREATE CURSOR curs_U_FOR_AN (FOR_CODCLI C(10), ;
					   FOR_RAGSOC  C(90))




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



*!*	*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_FOR_AN SQL ESCLUDENDO IL CODICE CLIENTE AZIENDA PER LA GESTIONE AZIENDA


*!*	__SOC= "01"
*!*	__CLI= "000000" 

*!*	x_soci = "FOR_codsoc = '" + __SOC + "'"
*!*	x_codi = "FOR_codcli <> '" + __CLI + "'"
*!*	x_cond = x_soci + " and " + x_codi

*!*	cSql   = "delete from U_FOR_AN where " + x_cond 
*!*	IF !ExecCommand(cSql,"U_FOR_AN")
*!*	   return(.f.)
*!*	ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CODICE_ZONA
PUBLIC _CODICE_ZONA
_CODICE_ZONA = 0



RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



**** CARICAMENTO DEL FILE IN FORMATO DBF


gcFile = GETFILE('DBF', '', 'Browse', 1, 'Seleziona')

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	SET DEFAULT TO &PUB_DIR  
	
	RETURN
ENDIF


WAIT WINDOWS "Selezionato file .DBF >>>>>>>>>>> "+gcFile 		

CREATE CURSOR IMPORTADBF (ANCODICE    C(15),  ;
		ANDESCRI    C(60),  ;
		ANTIPCON    C(1),  ;
		ANDESCR2    C(60),  ;
		ANINDIRI    C(35),  ;
		AN___CAP    C(9),  ;
		ANLOCALI    C(30),  ;
		ANPROVIN    C(2),  ;
		ANNAZION    C(3),  ;
		ANTELEFO    C(18),  ;
		ANTELFAX    C(18),  ;
		ANNUMCEL    C(18),  ;
		ANPERFIS    C(1),  ;
		AN_SESSO    C(1),  ;
		ANDATNAS    C(10), ;        
		ANLOCNAS    C(30),  ;
		ANPRONAS    C(2),  ;
		ANCODFIS    C(16),  ;
		ANPARIVA    C(12),  ;
		ANCATCON    C(5),  ;
		ANPARTSN    C(1),  ;
		ANCODPAG    C(5),  ;
		ANCODZON    C(3),  ;
		ANCODVAL    C(3),  ;
		ANCODBAN    C(10),  ;
		AN1MESCL    N(11),  ;
		ANGIOSC1    C(110),  ;
		AN2MESCL    C(110),  ;
		ANGIOSC2    C(110),  ;
		AN1SCONT    N(8,2),  ;
		AN2SCONT    N(8,2),  ;
		ANNUMLIS    C(5),  ;
		ANCODLIN    C(3),  ;
		ANNUMCOR    C(25),  ;
		AN__NOTE    C(100), ;   
		ANCATCOM    C(3),  ;
		ANINDWEB    C(254),  ;
		AN_EMAIL    C(254),  ;
		ANCONSUP    C(15),  ;
		ANDTOBSO    C(10), ;
		DDCODDES    C(10),  ;
		DDTIPRIF    C(10),  ;
		DDNOMDES    C(40),  ;
		ANRITENU    C(1),  ;
		ANFLINCA    C(1),  ;
		ANSPEINC    N(11,2),  ;
		ANTIPOPE    C(10),  ;
		IBAN        C(35),  ;
		AN__BBAN    C(30),  ;
		ANCODBA2    C(15),  ;
		PADESCRI    C(30),  ;
		BACODABI    C(5),  ;
		BACODCAB    C(5),  ;
		ANDESCR3    C(60),  ;
		ANDESCR4    C(60),  ;
		ANINDIR3    C(35),  ;
		ANINDIR4    C(35),  ;
		ANLOCAL2    C(30),  ;
		ANCODSTU    C(10),  ;
		COINDMAI    C(254),  ;
		CONUMTEL    C(20),  ;
		CORIFPER    C(125),  ;
		CONUMCEL    C(20),  ;
		TIPO        C(1),  ;
		ANINDIR2    C(35),  ;
		AN_EMPEC    C(254))


*!*	APPEND FROM (gcFile) TYPE xls	


_COMMAND = "APPEND FROM '" + ALLTRIM(gcFile) + "'"
&_COMMAND




* -->> Creazione cursore vuoto
* ----------------------------
IF !ExecCommand("select * from u_for_an where 0=1","u_for_an")
   return(.f.)
ENDIF
SELECT u_for_an
=DEFPUB(SELECT())
SCATTER MEMVAR MEMO BLANK


***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTADBF  
GO TOP

DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTADBF   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    IF UPPER(ALLTRIM(TIPO)) = "B"  && SCARTO RECORD
       SELECT IMPORTADBF   
       SKIP +1
       LOOP
    ENDIF 


    SCATTER MEMVAR MEMO


 	WAIT WINDOWS "Conversione Fornitore " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT    
    
*!*	#####################################################


    M.ID_UNIQUE  = ""
   	M.FOR_CODSOC = PUB_CODSOC 
    M.FOR_CODCLI = ALLTRIM(M.ANCODICE)
    
    M.FOR_CODCLI = TRC(PUB_LCL,ALLTRIM(M.FOR_CODCLI)) 
    
    
 	*!*	VERIFICO SE GIA' ESISTE IN AQUARIUS IL FORNITORE E NEL CASO LO SCARTO
  
	x_soci = "FOR_CODSOC = '" + PUB_CODSOC + "'"
	x_codi = "FOR_CODCLI = '" + M.FOR_CODCLI+ "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "SELECT * FROM U_FOR_AN WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_FOR_AN")
		RETURN .F.
	ENDIF
	SELECT CX_FOR_AN
	GO TOP
	IF !EOF()
       SELECT IMPORTADBF   
       SKIP +1
       LOOP
	ENDIF  
     
    
    SELECT IMPORTADBF 
    
    ***REPLACE AN_EMPEC    WITH "FORITORE INESISTENTE"	&& IDENTIFICO SUL DBF DI PARTENZA IL FORNITORE DA IMPORTARE
         	
 	M.FOR_RAGSOC = ALLTRIM(M.ANDESCRI)
   	M.FOR_RAGSOC = UPPER(M.FOR_RAGSOC)
    M.FOR_RAGSOC = APITOSPA(M.FOR_RAGSOC)
 	M.FOR_RAGDUE = ALLTRIM(M.ANDESCR2)
   	M.FOR_RAGDUE = UPPER(M.FOR_RAGDUE)
    M.FOR_RAGDUE = APITOSPA(M.FOR_RAGDUE)    
   	M.FOR_INDIR  = APITOSPA(ALLTRIM(M.ANINDIRI))
   	M.FOR_INDLEG = APITOSPA(ALLTRIM(M.ANINDIR2))		
    M.FOR_LOCALI = APITOSPA(ALLTRIM(M.ANLOCALI))
	M.FOR_CAP    = ALLTRIM(M.AN___CAP)
    M.FOR_PROVIN = APITOSPA(ALLTRIM(M.ANPROVIN))
    M.FOR_NAZION = APITOSPA(ALLTRIM(M.ANNAZION))
	IF EMPTY(M.FOR_NAZION)
		M.FOR_NAZION = 'ITA'
	ENDIF    
	M.FOR_TELEFO = ALLTRIM(M.ANTELEFO)		
	M.FOR_FAX    = ALLTRIM(M.ANTELFAX)
    M.FOR_NOTE   = ALLTRIM(M.ANNUMCEL)	
	M.FOR_HOMPAG = APITOSPA(ALLTRIM(LOWER(M.ANINDWEB)))
    M.FOR_EMAIL  = APITOSPA(ALLTRIM(LOWER(M.AN_EMAIL)))
	M.FOR_CODFIS = APITOSPA(ALLTRIM(UPPER(M.ANCODFIS)))
	M.FOR_PARIVA = APITOSPA(ALLTRIM(UPPER(M.ANPARIVA)))	

	M.FOR_RECCOG = ""  		&&  APITOSPA(ALLTRIM(M.ANCOGNOM))
    M.FOR_RECNOM = ""  		&&  APITOSPA(ALLTRIM(M.AN__NOME)) 
	M.FOR_CODIVA = "022" 	&& CONVERTE_CODICE_IVA_ZUCCHETTI(ALLTRIM(M.ANCODIVA))
	M.FOR_CONPAG = CONVERTE_CODICE_CPA_ZUCCHETTI(ALLTRIM(M.ANCODPAG))
	M.FOR_VALUTA = APITOSPA(ALLTRIM(UPPER(SUBSTR(M.ANCODVAL,1,3))))
	IF EMPTY(M.FOR_VALUTA)
		M.FOR_VALUTA = 'EUR'
	ENDIF
	M.FOR_ZONA   	= ALLTRIM(M.ANPROVIN)	
	M.FOR_VETTO1   	= ""

	*** ################################## DECODIFICA IBAN ##################################
	*M.FOR_CODCHE = ""
	*M.FOR_CODCIN = ""
	M.FOR_CODABI = APITOSPA(ALLTRIM(M.bacodabi))
	M.FOR_CODCAB = APITOSPA(ALLTRIM(M.bacodcab))
	M.FOR_NUMCOC = APITOSPA(ALLTRIM(M.annumcor))
	**=DECODIFICA_CODICE_IBAN(ALLTRIM(FOR_CDIBAN),'FOR')
    M.FOR_BAE    = M.FOR_CODABI+M.FOR_CODCAB				   
	*** ################################## DECODIFICA IBAN ##################################


    M.FOR_CONTO1 = ""  
    M.FOR_CONTO2 = ""  
    M.FOR_CONTO3 = ""  
    M.FOR_CONTO4 = ""  
    M.FOR_CONTO5 = ""  

	M.FOR_CCOST1 = ""  
	M.FOR_CCOST2 = ""  
	M.FOR_CCOST3 = ""  
	M.FOR_CCOST4 = ""  
	M.FOR_CCOST5 = ""  
    M.FOR_BSWFOR = ""
    M.FOR_IDLIST = ""
           

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



 	M.FOR_DATNEW = RIBALTA2(DTOC(DATE()))
	M.FOR_DATINS = RIBALTA2(DTOC(DATE()))
	M.FOR_LISFOR = ALLTRIM(M.ANNUMLIS)	


   	SELECT curs_U_FOR_AN				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
    SCATTER MEMVAR MEMO
    


	x_soci = "FOR_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "FOR_codcli = '" + M.FOR_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_FOR_AN where " + x_cond + " order by FOR_codsoc,FOR_codcli"



	IF !ExecCommand(cSql,"U_FOR_AN")
	   RETURN .F.
	ENDIF

	SELECT U_FOR_AN
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	DO U_FOR_AN
	IF !ExecRW('','U_FOR_AN','I','','U_FOR_AN')
	  return(.f.)
	ENDIF	

							   
   	_CTR = _CTR +1
   	WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   

    	
    SELECT IMPORTADBF
	SKIP

ENDDO






=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE RECORD SCRITTI: "+STR(_CTR,10,0),62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR



SELECT curs_U_FOR_AN
GO TOP
COPY TO ANAFOR_INE SDF


RETURN


 