
_RISP = MESSAGEBOX("Continuare con la sistemazione righe U_BOL_DD con campo ORD_CODSYS vuoto?",4+48+256,"Attenzione")
IF _RISP = 6
ELSE
	RETURN .F.
ENDIF

WAIT WINDOWS "Ricerca righe U_BOL_DD in corso..." NOWAIT

x_csys = "RTRIM(ord_codsys) = ''"
x_cond = x_csys
cSql = "select * from U_BOL_DD where " + x_cond
IF !ExecRW(cSql,"U_BOL_DD","R")
   return(.f.)
ENDIF
SELECT U_BOL_DD
GO TOP
_reccount = RECCOUNT()
SCAN
	WAIT WINDOWS "Elaborazione riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(_reccount)) + " in corso..." NOWAIT
	IF EMPTY(ORD_CODSYS)
		REPLACE ORD_CODSYS WITH SYS(2015)
	ENDIF
ENDSCAN

WAIT WINDOWS "Memorizzazione in corso..." NOWAIT

IF !ExecRW(cSql,"U_BOL_DD","W")
   return(.f.)
ENDIF

WAIT CLEAR

MESSAGEBOX("Operazione effettuata" + CHR(13) + CHR(13) + ;
	"Righe U_BOL_DD sistemate: " + ALLTRIM(STR(_reccount)),64,"Informazione")

RETURN .T.
