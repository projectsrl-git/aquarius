*************************************************************************************************
*							CONVERSIONE ANAGRAFICA FORNITORI									*
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


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA FORNITORI" NOWAIT

IF !ExecCommand("select * from U_FOR_AN where 1=0","curs_U_FOR_AN")
   return
ENDIF

*WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA ZONE" NOWAIT
cSql = "delete from PARA where CODICE LIKE 'ZON%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF

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

CREATE CURSOR IMPORTAXLS (antipcon   c(30),;
	ancodice   c(30),;	
	andescri   c(80),;	
	andescr2   c(80),;	
	anindiri   c(80),;	
	anindir2   c(80),;	
	an___cap   c(30),;	
	anlocali   c(80),;	
	anprovin   c(30),;	
	annazion   c(30),;	
	ancodfis   c(30),;	
	anpariva   c(30),;	
	antelefo   c(30),;	
	antelfax   c(30),;	
	annumcel   c(30),;	
	anindweb   c(30),;	
	an_email   c(30),;	
	ancognom   c(30),;	
	an__nome   c(30),;	
	anlocnas   c(30),;	
	anpronas   c(30),;	
	an_sesso   c(30),;	
	andatnas   c(30),;	
	andtinva   c(30),;	
	andtobso   c(30),;	
	anconsup   c(30),;	
	ancatcon   c(30),;	
	antiprif   c(30),;	
	anconrif   c(30),;	
	ancodiva   c(30),;	
	anritenu   c(30),;	
	ancodtr2   c(30),;	
	anpeinps   c(30),;	
	anriinps   c(30),;	
	ancoinps   c(30),;	
	ancoimps   c(30),;	
	ancodatt   c(30),;	
	anpartsn   c(30),;	
	afflintr   c(30),;	
	ancatcom   c(30),;	
	ancatscm   c(30),;	
	ancodlin   c(30),;	
	ancodval   c(30),;	
	annumlis   c(30),;	
	an1scont   c(30),;	
	an2scont   c(30),;	
	ancodzon   c(30),;	
	anconcon   c(30),;	
	anmagter   c(30),;	
	anscorpo   c(30),;	
	anflcodi   c(30),;	
	ancodpag   c(30),;	
	angiofis   c(30),;	
	an1mescl   c(30),;	
	angiosc1   c(30),;	
	an2mescl   c(30),;	
	angiosc2   c(30),;	
	ancodban   c(30),;	
	bacodabi   c(30),;	
	bacodcab   c(30),;	
	annumcor   c(30),;	
	andatavv   c(30),;	
	anflgavv   c(30),;	
	ancodba2   c(30),;	
	anflragg   c(30),;	
	anperfis   c(30),;	
	antipclf   c(30),;	
	anchksta   c(30),;	
	anchkmai   c(30),;	
	anchkfax   c(30),;	
	anchkwwp   c(30),;	
	anchkptl   c(30),;	
	anestcod   c(30),;	
	angesgru   c(30),;	
	anfatdif   c(30),;	
	anchkcpz   c(30),;	
	antipope   c(30),;	
	ancodirp   c(30),;	
	ancaurit   c(30),;	
	ancaspro   c(30),;	
	ancodass   c(30),;	
	anflgest   c(30),;	
	anflsgre   c(30),;	
	ancofisc   c(30),;	
	anbendep   c(30),;	
	anintmor   c(30),;	
	anmortas   c(30),;	
	anflinca   c(30),;	
	anspeinc   c(30),;	
	ancofast   c(30),;	
	ancofass   c(30),;	
	codescri   c(30)) 


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
 	M.FOR_RAGDUE = ALLTRIM(M.ANDESCR2)
   	M.FOR_RAGDUE = UPPER(M.FOR_RAGDUE)
    M.FOR_RAGDUE = APITOSPA(M.FOR_RAGDUE)    
   	M.FOR_INDIR  = APITOSPA(ALLTRIM(M.ANINDIRI))
   	M.FOR_INDLEG = APITOSPA(ALLTRIM(M.ANINDIR2))		&& ???????????????
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

	M.FOR_RECCOG = APITOSPA(ALLTRIM(M.ANCOGNOM))
    M.FOR_RECNOM = APITOSPA(ALLTRIM(M.AN__NOME)) 
	M.FOR_CODIVA = CONVERTE_CODICE_IVA_ZUCCHETTI(ALLTRIM(M.ANCODIVA))
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
   

    	
    SELECT IMPORTAXLS
	SKIP

ENDDO


SELECT curs_U_FOR_AN
GO TOP



*!*	****** AGGIORNA TABELLA U_FOR_AN SQL
*!*	IF !ExecRW('','U_FOR_AN','I','','curs_U_FOR_AN')
*!*	   return(.f.)
*!*	ENDIF
*!*		 



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 