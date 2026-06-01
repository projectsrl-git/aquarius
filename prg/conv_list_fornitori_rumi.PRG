*************************************************************************************************
*							    CONVERSIONE LISTINI FORNITORI									*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	GENNAIO  2014: Rumi					 														*
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

RIT = MESSAGEBOX("Conversione listini fornitori/articolo da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF



RIT = MESSAGEBOX("Desideri cancellare i listini esistenti ??" + REPLICATE(CHR(13),2) + ;
		 "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT <> 7

	WAIT WINDOWS "Cancellazione vecchi Listini in corso..." NOWAIT


	cSql = "DELETE FROM U_LIS_AA"
	IF !ExecCommand(cSql,"DEL_LIS_TT")
	   return
	ENDIF

*!*		cSql = "DELETE FROM U_LIS_LG"
*!*		IF !ExecCommand(cSql,"DEL_LIS_LG")
*!*		   return
*!*		ENDIF


ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0

						
					

CREATE CURSOR IMPORTAXLS ( ;
	DL__GUID	C(15), ;
	DLCODICE	C(100), ;
	DLCODART	C(100), ;
	DLUNIMIS	C(100), ;
	DLPREZZO	C(100), ;
	DLDATINI	C(100), ;
	DLDATFIN	C(100))

APPEND FROM (gcFile) TYPE XLS


_TOT_COUNT = 0


SELECT IMPORTAXLS
GO TOP

SET STEP ON 

DO WHILE !EOF()


	WAIT WINDOWS "Conversione Listino " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
		
    IF DELETED()
       SELECT IMPORTAXLS  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF UPPER(ALLTRIM(DL__GUID)) = "DL__GUID"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS  && SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 

    SCATTER MEMVAR MEMO 
  	
    _DLDATINI  = ALLTRIM(M.DLDATINI)
    
	__LIS_CODSOC = PUB_CODSOC
	__LIS_TIPOAZI = ALLTRIM(M.DLCODICE)
	__LIS_DESLIS  = "Listino "+__LIS_TIPOAZI 
	__LIS_DATLIS  = SUBSTR(_DLDATINI,7,4) + '/' + SUBSTR(_DLDATINI,4,2) + '/' + SUBSTR(_DLDATINI,1,2)
	__LIS_ALLIST  = "2999/12/31"		&& SUBSTR(M.DLDATFIN,7,4) + '/' + SUBSTR(M.DLDATFIN,4,2) + '/' + SUBSTR(M.DLDATFIN,1,2)
	__LIS_CODART  = ALLTRIM(M.DLCODART)
	__LIS_PREZZO  = VAL(M.DLPREZZO)
	__LIS_DESART  = "?????????"
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
	
	

	
	=LIS_LOGA("XXX",M.LIS_DATLIS,M.LIS_ALLIST,"TIPOLOGIA","XXX","XXX",M.LIS_TIPOAZI)	&& AGGIORNA LOG LISTINO
		
	_TOT_COUNT = _TOT_COUNT + 1
	
	
    	
    SELECT IMPORTAXLS
	SKIP
	
	
ENDDO


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale righe Listini convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 