_RISP = MESSAGEBOX("Vuoi riattivare le attività di tutti gli utenti ?",4+48,"Attenzione")
IF _RISP <> 6
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF


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
	REPLACE LOCKED WITH .F.
ENDIF

REPLACE LOCKED WITH .F.

USE

MESSAGEBOX("Operazione effettuata" + CHR(13) + CHR(13) + ;
	"Gli utenti possono rientrare in Aquarius",64,"Informazione")

RETURN .T.
