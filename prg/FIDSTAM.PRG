cSql="select * from u_cli_fi where 0=1"
IF !ExecCommand(cSql,"CURSORE")
   return(.f.)
ENDIF
SELECT CURSORE
GO TOP
APPEND BLANK
GO TOP

PUB_ERRORE=MESSAGEBOX("Confermi la stampa del modulo di fidelizzazione ?",292,"*** ATTENZIONE ***") 
IF PUB_ERRORE = 6  && RISPOSTA SI
   DO PRG\MENUSTA WITH "CURSORE",.F.,.T.,"XXX","FIDMOD","FIDMOD.FRX"
ELSE
   RETURN
ENDIF