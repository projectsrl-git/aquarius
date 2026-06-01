*************************************************************************************************
*									CONVERSIONE TABELLA CENTRI DI COSTO 						*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.				    										*
*	Dicembre 2013: Cardioline			 														*
*************************************************************************************************


RELEASE _ANNO_CONTABILE
PUBLIC _ANNO_CONTABILE
_ANNO_CONTABILE = ""



RIT = MESSAGEBOX("Procedo con la conversione dalla tabella CENTRI DI COSTO (CENTRCOS) ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


_ANNO_CONTABILE = PJ_INPUTBOX("Digitare l'esercizio contabile","",ALLTRIM(PUB_ANNO))
IF EMPTY(_ANNO_CONTABILE)
	MESSAGEBOX("Operazione annullata",48,"Attenzione")
	RETURN .F.
ENDIF

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + _ANNO_CONTABILE + "'"
x_cond = x_soci + " and " + x_anno		
cSql   = "delete from CCOSTO WHERE " + x_cond 
IF !ExecCommand(cSql,"CCOSTO")
   return(.f.)
ENDIF

*WAIT WINDOWS "Cancellazione vecchia tabella CENTRI DI COSTO (CENTRCOS) in corso..." NOWAIT



WAIT WINDOWS "Conversione dalla tabella CENTRI DI COSTO (CENTRCOS) ..." NOWAIT
 


_TOT_COUNT = 0
cSql = "SELECT * FROM CARD_CENTRCOS ORDER BY CODICE"
IF !ExecCommand(cSql,"CX_CARD_CENTRCOS")
	RETURN .F.
ENDIF
SELECT CX_CARD_CENTRCOS
GO TOP
SCAN

	SCATTER MEMVAR

	cSql = "SELECT * FROM CCOSTO WHERE 1=0"
	IF !ExecRW(cSql,"CCOSTO","R")
		RETURN .F.
	ENDIF
	SELECT CCOSTO 
	GO TOP
	APPEND BLANK
	REPLACE CON_SOC    WITH PUB_CODSOC
	REPLACE CON_ANNO   WITH _ANNO_CONTABILE 
	REPLACE CON_CONTO  WITH M.CODICE
	REPLACE CON_DESCR  WITH M.DESCRIZION
	IF !ExecRW(cSql,"CCOSTO","W")
		RETURN .F.
	ENDIF
		
	_TOT_COUNT = _TOT_COUNT + 1

ENDSCAN


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale CENTRI DI COSTO (CENTRCOS) convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 