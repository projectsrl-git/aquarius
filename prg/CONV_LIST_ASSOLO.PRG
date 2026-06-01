*************************************************************************************************
*							    CONVERSIONE LISTINI CLIENTI										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Ottobre 2021: Assolo			 												  			*
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

RIT = MESSAGEBOX("Conversione listini clienti-fornitori/articolo da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF



RIT = MESSAGEBOX("Desideri cancellare i listini esistenti ??" + REPLICATE(CHR(13),2) + ;
		 "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT <> 7

	WAIT WINDOWS "Cancellazione vecchi Listini in corso..." NOWAIT

	cSql = "DELETE FROM U_LIS_AV"
	IF !ExecCommand(cSql,"DEL_LIS_TT")
	   return
	ENDIF


	cSql = "DELETE FROM U_LIS_AA"
	IF !ExecCommand(cSql,"DEL_LIS_TT")
	   return
	ENDIF

	cSql = "DELETE FROM U_LIS_LG"
	IF !ExecCommand(cSql,"DEL_LIS_LG")
	   return
	ENDIF


ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0

					

CREATE CURSOR IMPORTAXLS ( ;
	LSCODLIS	C(15), ;
	LSVALLIS	C(100), ;
	LSDESLIS	C(100), ;
	LSIVALIS	C(100), ;
	LSTIPLIS	C(100), ;
	LSFLGCIC	C(100), ;
	LSFLGPRO	C(100), ;
	LSPRIORI	C(100), ;
	LSFLGCOM	C(100), ;
	LSLISWEB	C(100), ;
	LSFLUCOA	C(100), ;
	LSFLSTAT	C(100), ;
	LSLINTER	C(100), ;
	LSNOVALU	C(100), ;
	LSAPCLRI	C(100), ;
	GUID		C(100), ;
	LICODVAR	C(100), ;
	DLDATINI	C(100), ;
	DLDATFIN	C(100), ;
	DLUNIMIS	C(100), ;
	DLTIPCLF	C(100), ;
	DLCODCLF	C(100), ;
	DLESPMUL	C(100), ;
	DLMULOFF	C(100), ;
	DLSCAINI	C(100), ;
	DLSCAFIN	C(100), ;
	DLPREZZO	C(100), ;
	DLSCONT1	C(100), ;
	DLSCONT2	C(100), ;
	DLSCONT3	C(100), ;
	DLSCONT4	C(100), ;
	DLSCONTV	C(100), ;
	DLPERPRO	C(100), ;
	DLVALPRO	C(100), ;
	DLFLPROV	C(100), ;
	DLPRCALC	C(100), ;
	DLPERRIC	C(100), ;
	ARCODART	C(100), ;
	ARDESART	C(100), ;
	ARUNMIS1	C(100), ;
	ARMOLTIP	C(100), ;
	ARUNMIS2	C(100), ;
	ARGRUMER	C(100), ;
	ARCATOMO	C(100), ;
	ARCODFAM	C(100), ;
	GMDESCRI	C(100), ;
	VADECTOT	C(100), ;
	ATTRIB		C(100), ;
	CACODMOD	C(100), ;
	CACODFAM	C(100), ;
	CACODGRU	C(100), ;
	CAVALATT	C(100), ;
	CAFLPRIO	C(100), ;
	CADESCRI	C(100), ;
	DLQTARIC	C(100), ;
	DLQTAPAT	C(100), ;
	DLLOTMUL	C(100), ;
	DLQTAMIN	C(100), ;
	DLGIOAPP	C(100), ;
	DLPERRIP	C(100), ;
	DLRIFFOR	C(100))

APPEND FROM (gcFile) TYPE XLS


_TOT_COUNT = 0


SELECT IMPORTAXLS
GO TOP


DO WHILE !EOF()
*!*		
*!*	IF ALLTRIM(LSCODLIS) = 'ACQ'
*!*	SET STEP ON 
*!*	ENDIF
*!*			
	WAIT WINDOWS "Conversione Listino " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
		
    IF DELETED()
       SELECT IMPORTAXLS  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF UPPER(ALLTRIM(LSCODLIS)) = "LSCODLIS"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS  && SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 

	IF "COSTO" $ UPPER(ALLTRIM(LSDESLIS))				&& LISTINO ACQUISTI 
	ELSE
	    IF SUBSTR(DLDATINI,7,4) < "2013"
	       SELECT IMPORTAXLS  && SCARTO I RECORD NON DEL 2013
	       SKIP +1
	       LOOP
	    ENDIF 
	ENDIF

	IF VAL(DLPREZZO) = 0  
       SELECT IMPORTAXLS  && SCARTO  
       SKIP +1
       LOOP
    ENDIF 
  
  
    SCATTER MEMVAR MEMO 
  	

	__LIS_CODSOC = PUB_CODSOC
	__LIS_TIPOAZI = ALLTRIM(M.LSCODLIS)
	__LIS_DESLIS  = ALLTRIM(M.LSDESLIS)
	__LIS_DATLIS  = SUBSTR(M.DLDATINI,7,4) + '/' + SUBSTR(M.DLDATINI,4,2) + '/' + SUBSTR(M.DLDATINI,1,2)
	__LIS_ALLIST  = SUBSTR(M.DLDATFIN,7,4) + '/' + SUBSTR(M.DLDATFIN,4,2) + '/' + SUBSTR(M.DLDATFIN,1,2)
	__LIS_CODART  = ALLTRIM(M.ARCODART)
	__LIS_PREZZO  = VAL(M.DLPREZZO)
	__LIS_DESART  = ALLTRIM(M.ARDESART)
	__LIS_UMMAGA  = ALLTRIM(M.DLUNIMIS)

	
	x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
	x_codi = "ART_CODPRI = '" + __LIS_CODART + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "SELECT ART_CODPRI,ART_DESCR,ART_UMMAGA FROM U_ART_PR WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_ART_PR")
		RETURN .F.
	ENDIF
	SELECT CX_ART_PR
	GO TOP
	IF !EOF()
		__LIS_DESART = ALLTRIM(ART_DESCR)
		__LIS_UMMAGA = ALLTRIM(ART_UMMAGA)
	ENDIF
		
		
 
	IF "COSTO" $ UPPER(ALLTRIM(M.LSDESLIS))				&& LISTINO ACQUISTI 

		cSql = "SELECT * FROM U_LIS_AA WHERE 1=0"
		IF !ExecRW(cSql,"U_LIS_AA","R")
		   return
		ENDIF
		SELECT U_LIS_AA
		APPEND BLANK
		
		REPLACE LIS_CODSOC WITH __LIS_CODSOC 
		REPLACE LIS_TIPOAZI WITH __LIS_TIPOAZI 
		REPLACE LIS_DESLIS WITH __LIS_DESLIS
		REPLACE LIS_CODART WITH __LIS_CODART 
		REPLACE LIS_DESART WITH __LIS_DESART 
		REPLACE LIS_DATLIS WITH __LIS_DATLIS 
		REPLACE LIS_ALLIST WITH __LIS_ALLIST 
		REPLACE LIS_PREZZO WITH __LIS_PREZZO 
		REPLACE LIS_UMMAGA WITH __LIS_UMMAGA
			
		SCATTER MEMVAR
		
		IF !ExecRW(cSql,"U_LIS_AA","W")
		   return
		ENDIF	
		


	ELSE 												&& LISTINO VENDITE
	
		
		cSql = "SELECT * FROM U_LIS_AV WHERE 1=0"
		IF !ExecRW(cSql,"U_LIS_AV","R")
		   return
		ENDIF
		SELECT U_LIS_AV
		APPEND BLANK
		
		REPLACE LIS_CODSOC WITH __LIS_CODSOC 
		REPLACE LIS_TIPOAZI WITH __LIS_TIPOAZI 
		REPLACE LIS_DESLIS WITH __LIS_DESLIS
		REPLACE LIS_CODART WITH __LIS_CODART 
		REPLACE LIS_DESART WITH __LIS_DESART 
		REPLACE LIS_DATLIS WITH __LIS_DATLIS 
		REPLACE LIS_ALLIST WITH __LIS_ALLIST 
		REPLACE LIS_PREZZO WITH __LIS_PREZZO 
		REPLACE LIS_UMMAGA WITH __LIS_UMMAGA
			
		SCATTER MEMVAR
		
		IF !ExecRW(cSql,"U_LIS_AV","W")
		   return
		ENDIF	
		
	
    ENDIF 

		

	
	=LIS_LOGA("XXX",M.LIS_DATLIS,M.LIS_ALLIST,"TIPOLOGIA","XXX","XXX",M.LIS_TIPOAZI)	&& AGGIORNA LOG LISTINO
		
	_TOT_COUNT = _TOT_COUNT + 1
	
	
    	
    SELECT IMPORTAXLS
	SKIP
	
	
ENDDO


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale righe Listini convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 