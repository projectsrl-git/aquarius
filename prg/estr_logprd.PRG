
WAIT WINDOWS "Estrazione dati di Log produzione in corso..." NOWAIT

IF !ExecCommand("select * from logprd order by codope,idattivita,data,ora","TMP_LOGPRD")
  return(.f.)
ENDIF

WAIT CLEAR

SELECT TMP_LOGPRD
GO TOP
IF !EOF()
	WAIT WINDOWS "Estrazione dati di Log produzione in corso..." NOWAIT
	DO ESTRXLS WITH "TMP_LOGPRD","Log produzione"
	WAIT CLEAR
ELSE
	MESSAGEBOX("Nessun dato disponibile",64,"Informazione")
ENDIF

RETURN
