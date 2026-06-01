*************************************************************************************************
*							CONVERSIONE NAZIONI													*
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

RIT = MESSAGEBOX("Conversione parametro nazioni da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


cSql = "DELETE FROM PARA WHERE CODICE LIKE 'STA%'"
IF !ExecCommand(cSql,"DEL_PARA_STA")
   return
ENDIF

*!*	*** AGGIORNAMENTO PARAMETRO 'GEN' PER DETERMINAZIONE CONTI IN TRASFERIMENTI CONTABILI
*!*	cSql = "UPDATE PARA SET NOTE = '' WHERE CODICE LIKE 'GEN%' AND CODICE <> 'GEN01'"
*!*	IF !ExecCommand(cSql,"UPD_PARA_GEN")
*!*		RETURN .F.
*!*	ENDIF




WAIT WINDOWS "Conversione nazioni in corso..." NOWAIT		


CREATE CURSOR CX_CARD_STATIEST( ;
	codice		C(15), ;
	descri      C(100), ;
	nacodiso    C(100), ;
	w_stampa    C(100), ;
	nacodval    C(100), ;
	vadesval    C(100), ;
	nacodest    C(5))
	


APPEND FROM (gcFile) TYPE XLS

_TOT_COUNT = 0




SELECT CX_CARD_STATIEST
GO TOP
SCAN

    IF UPPER(ALLTRIM(CODICE)) = "CODICE"  && SCARTO PRIMO RECORD (INTESTAZIONI DI COLONNA)
		LOOP
    ENDIF 


	WAIT WINDOWS "Conversione Nazione " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
		
	SCATTER MEMVAR
	

	M.CODICE_AQUARIUS = APITOSPA(ALLTRIM(SUBSTR(M.CODICE,1,3)))
	
	x_codi = "CODICE = 'STA" + ALLTRIM(M.CODICE_AQUARIUS) + "'"
	x_cond = x_codi
	cSql = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecRW(cSql,"PARA","R")
		RETURN .F.
	ENDIF
	SELECT PARA
	GO TOP
	APPEND BLANK
	
	REPLACE CODICE WITH "STA" + ALLTRIM(M.CODICE_AQUARIUS)
	REPLACE DESCRI WITH ALLTRIM(M.descri)
	REPLACE LIBERA WITH IIF(!ISNULL(M.nacodiso),ALLTRIM(M.nacodiso),"")
	REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
	
	IF !ExecRW(cSql,"PARA","W")
		RETURN .F.
	ENDIF

	
	
	_TOT_COUNT = _TOT_COUNT + 1

ENDSCAN






WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale nazioni convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 