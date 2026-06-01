*************************************************************************************************
*						CONVERSIONE TABELLA DESCRIZIONE ARTICOLI IN LINGUA						*
*							 																	*
*	by Sergio Piaggi Project S.r.l.																*
*	Gennaio 2014: Rumi					 														*
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

RIT = MESSAGEBOX("Conversione descrizioni in lingua da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF





RIT = MESSAGEBOX("Vui cancellare le descrizioni in lingua vecchie ??",292,"ATTENZIONE")
	IF RIT <> 7
	WAIT WINDOWS "Cancellazione vecchi Descrizione Articoli in Lingua in corso..." NOWAIT

	cSql = "DELETE FROM DESLINGUE WHERE TIPODES = 'ARTICOLO'"
	IF !ExecCommand(cSql,"DEL_DESLINGUE")
	   return
	ENDIF
ENDIF



_TOT_COUNT = 0


WAIT WINDOWS "Conversione Descrizione Articoli in Lingua in corso..." NOWAIT



CREATE CURSOR IMPORTAXLS ( ;
	CACODICE	C(100), ;
	CADESART	C(100), ;
	CADESSUP	C(100), ;
	CACODART	C(100), ;
	CACODVAR	C(100), ;
	CATIPCON	C(100), ;
	CACODCON	C(100), ;
	CA__TIPO	C(100), ;
	CATIPBAR	C(100), ;
	CAFLSTAM	C(100), ;
	CAUNIMIS	C(100), ;
	CAOPERAT	C(100), ;
	CAMOLTIP	C(100), ;
	CADTOBSO	C(100), ;
	ARDESART	C(100), ;
	ARCODVAR	C(100), ;
	DVDESCRI	C(100), ;
	LGCODLIN	C(100), ;
	LGDESCOD	C(100), ;
	LGDESSUP	C(100), ;
	LGCODICE	C(100), ;
	CADTINVA	C(100), ;
	CAPESNE3	C(100), ;
	CAPESLO3	C(100), ;
	CATPCON3	C(100), ;
	CAPZCON3	C(100), ;
	CACOCOL3	C(100), ;
	CADIMLU3	C(100), ;
	CAUMVOL3	C(100), ;
	CADIMLA3	C(100), ;
	CADIMAL3	C(100), ;
	CAUMDIM3	C(100), ;
	CADESVO3	C(100), ;
	CATIPMA3	C(100), ;
	CAFLCON3	C(100), ;
	CACAUZI3	C(100), ;
	CAIMBRE3	C(100), ;
	CAIMBCA3	C(100), ;
	CC_CONTO	C(100), ;
	CCDESPIA	C(100), ;
	CAPREZUM	C(100), ;
	CAFLUMVA	C(100), ;
	CAFLIMBA	C(100), ;
	CATIPCO3	C(100))

APPEND FROM (gcFile) TYPE XLS






SELECT IMPORTAXLS
GO TOP
DO WHILE !EOF()


	WAIT WINDOWS "Conversione Descrizione Articolo in Lingua " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
	
	SCATTER MEMVAR
	


    IF DELETED()
       SELECT IMPORTAXLS  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF UPPER(ALLTRIM(CACODICE)) = "CACODICE"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
       SELECT IMPORTAXLS  && SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 

    IF EMPTY(ALLTRIM(LGDESCOD)) 
       SELECT IMPORTAXLS  && SCARTO I RECORD SENZA DESCRIZIONI IN LINGUA
       SKIP +1
       LOOP
    ENDIF 

  
    SCATTER MEMVAR MEMO 
  

	
	__IDDESLING = SYS(2015)
	__TIPODES   = "ARTICOLO"
	__LINGUA    = "008"   && INGLESE M.LGCODLIN
	__CODICE    = ALLTRIM(M.CACODART)
	__DESCRI    = IIF(!ISNULL(M.LGDESCOD),ALLTRIM(M.LGDESCOD),"")
	__DESEST    = ""
	

	cSql = "SELECT * FROM DESLINGUE WHERE 1=0"
	IF !ExecRW(cSql,"DESLINGUE","R")
	   return
	ENDIF
	SELECT DESLINGUE
	APPEND BLANK
	REPLACE IDDESLING WITH __IDDESLING
	REPLACE TIPODES   WITH __TIPODES  
	REPLACE LINGUA    WITH __LINGUA   
	REPLACE CODICE    WITH __CODICE   
	REPLACE DESCRI    WITH __DESCRI   
	REPLACE DESEST    WITH __DESEST   
	IF !ExecRW(cSql,"DESLINGUE","W")
	   return
	ENDIF
	
	_TOT_COUNT = _TOT_COUNT + 1


	SELECT IMPORTAXLS
	SKIP +1
	
ENDDO 

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Descrizione Articoli in Lingua convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 