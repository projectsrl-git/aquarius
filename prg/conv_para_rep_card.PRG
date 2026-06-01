*************************************************************************************************
*							      CONVERSIONE LINEE PRODOTTO									*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.														*
*	Ottobre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione delle Linee prodotto dalla tabella CARD_TABDIST?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


WAIT WINDOWS "Cancellazione vecchie Linee prodotto in corso..." NOWAIT

cSql = "DELETE FROM PARA WHERE CODICE LIKE 'REP%'"
IF !ExecCommand(cSql,"DEL_PARA_REP")
   return
ENDIF


WAIT WINDOWS "Conversione Linee prodotto in corso..." NOWAIT


*** AGGIORNAMENTO TABELLA DELLE LINEE PRODOTTO
_TOT_COUNT = 0
cSql = "SELECT * FROM CARD_TABDIST ORDER BY COD"
IF !ExecCommand(cSql,"CX_CARD_TABDIST")
	RETURN .F.
ENDIF
SELECT CX_CARD_TABDIST
GO TOP
SCAN

	SCATTER MEMVAR

	x_codi = "CODICE = 'REP" + ALLTRIM(M.COD) + "'"
	x_cond = x_codi
	cSql = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecRW(cSql,"PARA","R")
		RETURN .F.
	ENDIF
	SELECT PARA
	GO TOP
	IF EOF()
		APPEND BLANK
		REPLACE CODICE WITH "REP" + ALLTRIM(M.COD)
		REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
	ENDIF
	
	REPLACE DESCRI WITH ALLTRIM(M.DESCR)
	REPLACE DESIVA WITH ALLTRIM(M.TPDOC)
	REPLACE LIBERA WITH ALLTRIM(M.CODMAG)
	
	IF !ExecRW(cSql,"PARA","W")
		RETURN .F.
	ENDIF
		
	_TOT_COUNT = _TOT_COUNT + 1

ENDSCAN

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Linee prodotto convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 