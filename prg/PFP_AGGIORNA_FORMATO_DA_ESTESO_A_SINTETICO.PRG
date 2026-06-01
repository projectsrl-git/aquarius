
_RISP = MESSAGEBOX("Aggiornare la tabella PROD_AVANZA con il formato sintetico '9999 x 9999 rt.|9999 x 9999 rt.|...' ove necessario?",4+48+256,"Attenzione")
IF _RISP = 6
ELSE
	RETURN .F.
ENDIF

WAIT WINDOWS "Caricamento tabella PROD_AVANZA..." NOWAIT

_RECAGG = 0
*** CARICAMENTO TABELLA PROD_AVANZA
Csql = "SELECT * FROM PROD_AVANZA ORDER BY IDPRG, SEQUEN"
IF !ExecCommand(Csql,"CX_PROD_AVANZA")
	return(.f.)
ENDIF
SELECT CX_PROD_AVANZA
GO TOP
SCAN
	
	WAIT WINDOWS "Aggiornamento tabella PROD_AVANZA in corso (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT
	
	_ID_UNIQUE = ID_UNIQUE
	_OLD_FORMATO = FORMATO
	IF "rt." $ _OLD_FORMATO
		LOOP
	ENDIF
	
	_NEW_FORMATO = PFP_FORMATO_SINTETICO(_OLD_FORMATO)
	
	x_cond = "ID_UNIQUE = '" + _ID_UNIQUE + "'"
	Csql = "SELECT * FROM PROD_AVANZA WHERE " + x_cond 
	IF !ExecRW(Csql,"PROD_AVANZA","R")
		return(.f.)
	ENDIF
	SELECT PROD_AVANZA
	GO TOP
	IF !EOF()
		REPLACE FORMATO WITH _NEW_FORMATO
	ENDIF
	IF !ExecRW(Csql,"PROD_AVANZA","W")
		return(.f.)
	ENDIF
	
	_RECAGG = _RECAGG + 1

ENDSCAN

IF _RECAGG > 0
	MESSAGEBOX("Operazione effettuata" + REPLICATE(CHR(13),2) + ALLTRIM(STR(_RECAGG)) + " records della tabella PROD_AVANZA aggiornati correttamente",64,"Informazione")
ELSE
	MESSAGEBOX("Operazione effettuata" + REPLICATE(CHR(13),2) + "Nessun record della tabella PROD_AVANZA da aggiornare",64,"Informazione")
ENDIF

RETURN
