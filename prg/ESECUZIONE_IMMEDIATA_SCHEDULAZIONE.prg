
LPARAMETERS _par_codice

IF PCOUNT()<1
	MESSAGEBOX("Manca parametro codice schedulazione",16,"Attenzione",3000)
	RETURN .F.
ENDIF

cSql = "SELECT * FROM SCHEDULER WHERE CODICE = '" + ALLTRIM(_par_codice) + "'"
IF !ExecCommand(cSql,"TMP_SCHEDULER")
	return(.F.)
ENDIF
SELECT TMP_SCHEDULER
GO TOP
IF EOF()
	USE
	MESSAGEBOX("Schedulazione con codice '" + ALLTRIM(_par_codice) + "' inesistente",48,"Attenzione",3000)
	RETURN .F.
ENDIF
IF ALLTRIM(STATO) = 'SOSPESO'
	MESSAGEBOX("Schedulazione con codice '" + ALLTRIM(_par_codice) + "' impostata come SOSPESA",48,"Attenzione",3000)
	RETURN .F.
ENDIF
IF ALLTRIM(STATO) = 'ESEGUI'
	MESSAGEBOX("Schedulazione con codice '" + ALLTRIM(_par_codice) + "' già in esecuzione" + REPLICATE(CHR(13),2) + ;
		"Attendere il termine dell'esecuzione o contattare l'assistenza",64,"Informazione",3000)
	RETURN .F.
ENDIF
SELECT TMP_SCHEDULER
USE

cSql = "UPDATE SCHEDULER SET STATO = 'ESEGUI' WHERE CODICE = '" + ALLTRIM(_par_codice) + "'"
IF !ExecCommand(cSql,"UPD_SCHEDULER")
	return(.F.)
ENDIF

MESSAGEBOX("Schedulazione avviata",64,"Informazione",3000)

RETURN .T.
