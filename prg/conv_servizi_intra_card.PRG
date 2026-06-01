*************************************************************************************************
*									CONVERSIONE TABELLA SERVIZI INTRASTAT						*
*							 																	*
*	by Sergio Piagi per Project S.r.l.				    										*
*	Novembre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione dalla tabella SERVIZI intrastat?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


WAIT WINDOWS "Cancellazione vecchia tabella SERVIZI intrastat in corso..." NOWAIT

cSql = "DELETE FROM PARA WHERE CODICE LIKE 'SEI%'"
IF !ExecCommand(cSql,"DEL_PARA_SEI")
   return
ENDIF


WAIT WINDOWS "Conversione dalla tabella SERVIZI intrastat..." NOWAIT


*** AGGIORNAMENTO TABELLA DELLE UNITA' DI MISURA
_TOT_COUNT = 0
cSql = "SELECT * FROM CARD_SERVIZI ORDER BY CODICE"
IF !ExecCommand(cSql,"CX_CARD_SERVIZI")
	RETURN .F.
ENDIF
SELECT CX_CARD_SERVIZI
GO TOP
SCAN

	SCATTER MEMVAR

	x_codi = "CODICE = 'SEI" + ALLTRIM(M.CODICE) + "'"
	x_cond = x_codi
	cSql = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecRW(cSql,"PARA","R")
		RETURN .F.
	ENDIF
	SELECT PARA
	GO TOP
	IF EOF()
		APPEND BLANK
		REPLACE CODICE WITH "SEI" + ALLTRIM(M.CODICE)
		REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
	ENDIF
	
	REPLACE DESCRI WITH ALLTRIM(M.DESCRIZION)

	
	IF !ExecRW(cSql,"PARA","W")
		RETURN .F.
	ENDIF
		
	_TOT_COUNT = _TOT_COUNT + 1

ENDSCAN


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Servizi convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 