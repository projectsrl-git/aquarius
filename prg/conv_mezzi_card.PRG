*************************************************************************************************
*									CONVERSIONE TABELLA MEZZI DI TRASPORTO						*
*							 																	*
*	by Sergio Piagi per Project S.r.l.				    										*
*	Novembre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione dalla tabella MEZZI DI TRASPORTO ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


WAIT WINDOWS "Cancellazione vecchia tabella MEZZI DI TRASPORTO in corso..." NOWAIT

cSql = "DELETE FROM PARA WHERE CODICE LIKE 'MEZ%'"
IF !ExecCommand(cSql,"DEL_PARA_MEZ")
   return
ENDIF


WAIT WINDOWS "Conversione dalla tabella MEZZI DI TRASPORTO ..." NOWAIT
 

*** AGGIORNAMENTO TABELLA DELLE UNITA' DI MISURA
_TOT_COUNT = 0
cSql = "SELECT * FROM CARD_MODSPEDI ORDER BY CODICE"
IF !ExecCommand(cSql,"CX_CARD_MODSPEDI")
	RETURN .F.
ENDIF
SELECT CX_CARD_MODSPEDI
GO TOP
SCAN

	SCATTER MEMVAR

	x_codi = "CODICE = 'MEZ" + SUBSTR(M.CODICE,1,1) + "'"
	x_cond = x_codi
	cSql = "SELECT * FROM PARA WHERE " + x_cond
	IF !ExecRW(cSql,"PARA","R")
		RETURN .F.
	ENDIF
	SELECT PARA
	GO TOP
	IF EOF()
		APPEND BLANK
		REPLACE CODICE WITH "MEZ" + SUBSTR(M.CODICE,1,1)
		REPLACE PAR_DATINS WITH RIBALTA2(DTOC(DATE()))
	ENDIF
	
	REPLACE DESCRI WITH ALLTRIM(M.DESCRIZION)
	REPLACE LIBERA WITH "TIPO TRASPORTO INTRASTAT:"+ALLTRIM(M.TRASPORTO)
	REPLACE NOTE   WITH "POS-26"

	
	IF !ExecRW(cSql,"PARA","W")
		RETURN .F.
	ENDIF
		
	_TOT_COUNT = _TOT_COUNT + 1

ENDSCAN


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale MEZZI DI TRASPORTO convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 