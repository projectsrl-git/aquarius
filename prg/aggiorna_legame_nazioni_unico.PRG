************************************************************************************************************
*** AGGIORNAMENTO LEGAME TABELLA DEGLI STATI AQUARIUS CON TABELLA NAZIONI_UNICO PER ELENCO CLIENTI/FORNITORI
************************************************************************************************************

WAIT WINDOWS "Elaborazione in corso..." NOWAIT

_CONTA_TOT = 0
_CONTA_LEG = 0
cSql = "SELECT * FROM PARA WHERE CODICE LIKE 'STA%' ORDER BY CODICE"
IF !ExecRW(cSql,"PARA","R")
   RETURN .F.
ENDIF
SELECT PARA
GO TOP
SCAN
   
	_CONTA_TOT = _CONTA_TOT + 1
	
	**SERGIO 24/08/2014 CAMPO IN CONFLITTO CON GESTIONE INTRASTAT
	**REPLACE LIBERA WITH ""  && SBIANCO LIBERA, CHE CONTERRA' IL LEGAME COL CODICE DI NAZIONI_UNICO
	REPLACE DTIPOMOV WITH ""  && SBIANCO DTIPOMOV, CHE CONTERRA' IL LEGAME COL CODICE DI NAZIONI_UNICO
	**SERGIO 24/08/2014 CAMPO IN CONFLITTO CON GESTIONE INTRASTAT
	
	SCATTER MEMVAR MEMO
	
	x_desc = "DESCRI = '" + M.DESCRI + "'"
	x_cond = x_desc 
	cSql = "select * from nazioni_unico where " + x_cond + " order by codice"
	IF !ExecCommand(cSql,"CX_NAZIONI_UNICO")
	  return(.f.)
	ENDIF
	SELECT CX_NAZIONI_UNICO
	GO TOP
	IF !EOF()
		_X_CODICE = CODICE
		SELECT PARA
		**SERGIO 24/08/2014 CAMPO IN CONFLITTO CON GESTIONE INTRASTAT
		**REPLACE LIBERA WITH ALLTRIM(_X_CODICE)
		REPLACE DTIPOMOV WITH ALLTRIM(_X_CODICE)
		_CONTA_LEG = _CONTA_LEG + 1
	ENDIF
	
ENDSCAN
IF !ExecRW(cSql,"PARA","W")
   RETURN .F.
ENDIF

WAIT CLEAR

MESSAGEBOX("Fine aggiornamento legame:" + REPLICATE(CHR(13),2) + ;
	"Totale Nazioni Aquarius lette: " + ALLTRIM(STR(_CONTA_TOT)) + CHR(13) + ;
	"Totale Nazioni Aquarius legate automaticamente: " + ALLTRIM(STR(_CONTA_LEG)) + CHR(13) + ;
	"Totale Nazioni Aquarius da legare manualmente: " + ALLTRIM(STR(_CONTA_TOT - _CONTA_LEG)),64,"Informazione")

IF _CONTA_LEG < _CONTA_TOT
	_RISP = MESSAGEBOX("Aggiornare manualmente il legame per le nazioni rimanenti?",4+32,"Attenzione")
	IF _RISP = 6
		_ACT_FRM_RIF = _SCREEN.ActiveForm
		_ACT_FRM_RIF.HIDE
		DO FORM FORM\LEGAME_NAZIONI_UNICO LINKED
		_ACT_FRM_RIF.SHOW
	ENDIF
ENDIF

RETURN
