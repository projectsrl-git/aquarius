
LPARAMETERS _par_timeout

IF PCOUNT() > 0
ELSE
	_par_timeout = 0
ENDIF

*!*	_RISP = MESSAGEBOX("Vuoi interrompere le attività di tutti gli utenti trà 100 secondi ?",4+48,"Attenzione")
*!*	IF _RISP <> 6
*!*		MESSAGEBOX("Operazione abbandonata",64,"Informazione")
*!*		RETURN .F.
*!*	ENDIF

IF !FILE("TBL_BLOCCO.DBF")
	_RISP = MESSAGEBOX("Tabella TBL_BLOCCO.DBF inesistente, crearla automaticamente?",4+48,"Attenzione")
	IF _RISP <> 6
		MESSAGEBOX("Operazione abbandonata",64,"Informazione")
		RETURN .F.
	ENDIF
	
	CREATE TABLE TBL_BLOCCO (APP_NAME C(20), STIMEOUT N(3,0), LOCKED L)
	SELECT TBL_BLOCCO
	USE
ENDIF

IF !USED("TBL_BLOCCO")
   USE TBL_BLOCCO IN 0 AGAIN
ENDIF

SELECT TBL_BLOCCO
SET FILTER TO UPPER(ALLTRIM(APP_NAME)) == 'AQUARIUS'
GO TOP
IF EOF()
	APPEND BLANK
	REPLACE APP_NAME WITH 'AQUARIUS'
	REPLACE STIMEOUT WITH 100
	REPLACE LOCKED WITH .T.
ENDIF

IF _par_timeout > 0
	REPLACE STIMEOUT WITH _par_timeout
ENDIF
*REPLACE LOCKED WITH .T.

_nSecTimeout = STIMEOUT

**=> ERASMO - INIZIO 13/12/2022
IF LOCKED
	SELECT TBL_BLOCCO
	USE
	MESSAGEBOX("Attività già bloccate",64,"Informazione")
	RETURN .F.
ENDIF
_RISP = MESSAGEBOX("Vuoi interrompere le attività di tutti gli utenti entro i prossimi " + ALLTRIM(STR(_nSecTimeout)) + " secondi ?",4+48,"Attenzione")
IF _RISP <> 6
	SELECT TBL_BLOCCO
	USE
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF
SELECT TBL_BLOCCO
REPLACE LOCKED WITH .T.
**=> ERASMO - FINE 13/12/2022

USE

MESSAGEBOX("Operazione effettuata" + CHR(13) + CHR(13) + ;
	"Gli utenti saranno costretti ad uscire da Aquarius entro i prossimi " + ALLTRIM(STR(_nSecTimeout)) + ;
	" secondi a meno di eventuali elaborazioni già in corso",64,"Informazione",5000)
	
*DO FORM FORM\AQSQLMONITOR

RETURN .T.
