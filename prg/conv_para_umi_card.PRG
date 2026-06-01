*************************************************************************************************
*									CONVERSIONE UNITA DI MISURA									*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.														*
*	Ottobre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione delle Unità di Misura dalla tabella CARD_TABUM/CARD_TABTC?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


*!*	WAIT WINDOWS "Cancellazione vecchie Unità di Misura in corso..." NOWAIT

*!*	cSql = "DELETE FROM PARA WHERE CODICE LIKE 'UMI%'"
*!*	IF !ExecCommand(cSql,"DEL_PARA_UMI")
*!*	   return
*!*	ENDIF


WAIT WINDOWS "Conversione Unità di Misura in corso..." NOWAIT


*** AGGIORNAMENTO TABELLA DELLE UNITA' DI MISURA
_TOT_COUNT = 0
cSql = "SELECT * FROM CARD_TABUM ORDER BY COD"
IF !ExecCommand(cSql,"CX_CARD_TABUM")
	RETURN .F.
ENDIF
SELECT CX_CARD_TABUM
GO TOP
SCAN

	SCATTER MEMVAR

	x_codi = "CODICE = 'UMI" + ALLTRIM(M.COD) + "'"
	x_cond = x_codi
	cSql = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecRW(cSql,"PARA","R")
		RETURN .F.
	ENDIF
	SELECT PARA
	GO TOP
	IF EOF()
		APPEND BLANK
		REPLACE CODICE WITH "UMI" + ALLTRIM(M.COD)
		REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
	ENDIF
	
	REPLACE DESCRI WITH ALLTRIM(M.DESCR)
	REPLACE DESIVA WITH ALLTRIM(M.TIPO)
	REPLACE LIBERA WITH ALLTRIM(STR(M.COEFF,20,5))
	
	IF !ExecRW(cSql,"PARA","W")
		RETURN .F.
	ENDIF
		
	_TOT_COUNT = _TOT_COUNT + 1

ENDSCAN

cSql = "SELECT * FROM CARD_TABTC ORDER BY COD"
IF !ExecCommand(cSql,"CX_CARD_TABTC")
	RETURN .F.
ENDIF
SELECT CX_CARD_TABTC
GO TOP
SCAN

	SCATTER MEMVAR

	x_codi = "CODICE = 'UMI" + ALLTRIM(M.COD) + "'"
	x_cond = x_codi
	cSql = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecRW(cSql,"PARA","R")
		RETURN .F.
	ENDIF
	SELECT PARA
	GO TOP
	IF EOF()
		APPEND BLANK
		REPLACE CODICE WITH "UMI" + ALLTRIM(M.COD)
		REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
	ENDIF
	
	REPLACE DESCRI WITH ALLTRIM(M.DESCR)
	REPLACE LIBERA WITH ALLTRIM(STR(M.COEFF,20,8))
	
	IF !ExecRW(cSql,"PARA","W")
		RETURN .F.
	ENDIF
		
	_TOT_COUNT = _TOT_COUNT + 1

ENDSCAN

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Unità di Misura convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 