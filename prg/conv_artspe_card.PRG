*************************************************************************************************
*							CONVERSIONE SPECIFICHE ANAGRAFICA ARTICOLI							*
*							 																	*
*	by Erasmo Masiello Project S.r.l.															*
*	Marzo 2014: Cardioline			 															*
*************************************************************************************************

** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "CAR"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'CAR' non configurato" + CHR(13) + CHR(13) + ;
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

**** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2003 IN POI NON FUNZIONA
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF

RIT = MESSAGEBOX("Conversione Specifiche anagrafica articoli da foglio Excel: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


WAIT WINDOWS "Cancellazione vecchie Specifiche anagrafica articoli in corso..." NOWAIT

cSql = "DELETE FROM U_ART_SP"
IF !ExecCommand(cSql,"DEL_ART_SP")
   return
ENDIF


WAIT WINDOWS "Conversione Specifiche anagrafica articoli in corso..." NOWAIT		

CREATE CURSOR IMPORTAXLS ( ;
	A C(200), ;
	B C(200), ;
	C C(200), ;
	D C(200), ;
	E C(200), ;
	F C(200), ;
	G C(200), ;
	H C(200), ;
	I C(200), ;
	J C(200), ;
	K C(200), ;
	L C(200))

_COMMAND = "APPEND FROM '" + ALLTRIM(gcFile) + "' TYPE xls"
&_COMMAND


_TOT_COUNT = 0

SELECT IMPORTAXLS
GO TOP
DO WHILE .T.
	IF EOF()
		EXIT
	ENDIF
	
	WAIT WINDOWS "Conversione Specifiche anagrafica articoli in corso... (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
    IF EMPTY(C) OR EMPTY(E)
    	SKIP +1
		LOOP
    ENDIF
    
    SCATTER MEMVAR MEMO
    
	_X_CODART = ALLTRIM(M.C)  && COLONNA "COD ART"
	_X_CODSPE = ALLTRIM(M.E)  && COLONNA "SPEC"
	_X_CDARFO = ALLTRIM(M.F)  && COLONNA "SUPPLIER CODE"
	_X_DESFOR = ALLTRIM(M.I)  && COLONNA "SUPPLIER DESCRIPTION"
	_X_NOTEFO = ALLTRIM(M.J)  && COLONNA "SUPPLIER NOTES"
	_X_NOTESP = ALLTRIM(M.L)  && COLONNA "SPECIFICATION NOTES"

	cSql = "SELECT * FROM U_ART_SP WHERE 1=0"
	IF !ExecRW(cSql,"U_ART_SP","R")
	   return
	ENDIF
	SELECT U_ART_SP
	GO TOP
	APPEND BLANK
	REPLACE CODART WITH _X_CODART
	REPLACE CODSPE WITH _X_CODSPE
	REPLACE CDARFO WITH _X_CDARFO
	REPLACE DESFOR WITH _X_DESFOR
	REPLACE NOTEFO WITH _X_NOTEFO
	REPLACE NOTESP WITH _X_NOTESP
	IF !ExecRW(cSql,"U_ART_SP","W")
	   return
	ENDIF
	
	_TOT_COUNT = _TOT_COUNT + 1
	
	SELECT IMPORTAXLS
	SKIP +1
	
ENDDO


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Specifiche articoli convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN
