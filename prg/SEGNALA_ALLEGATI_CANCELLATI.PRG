
LPARAMETERS _TIPO,_PATH

CREATE CURSOR CU_ALERT_ALLEGATI (FILENAME C(254), DOCUMENTO C(100))

x_tipo = "TIPO = '" + _TIPO + "'"
x_cond = x_tipo
cSql = "select * from ATTACHMENTS where " + x_cond
IF !ExecCommand(cSql,"CX_ATTACHMENTS")
  return(.f.)
ENDIF
SELECT CX_ATTACHMENTS
GO TOP
SCAN
	SCATTER MEMVAR MEMO
	M.FULLPATH = _PATH + "\" + ALLTRIM(M.FILENAME)
	IF !FILE(M.FULLPATH)
		SELECT CU_ALERT_ALLEGATI
		APPEND BLANK
		REPLACE FILENAME WITH M.FULLPATH
		IF _TIPO = "ORF"
			M.DOCUMENTO = ""
			x_agga = "TAGGANCIO = '" + M.IDDOCUMENTO + "'"
			x_cond = x_agga 
			cSql = "select ORD_NUMORD,ORD_DATORD from U_ORF_TT where " + x_cond
			IF !ExecCommand(cSql,"TMP_ORF_TT")
			  return(.f.)
			ENDIF
			SELECT TMP_ORF_TT
			GO TOP
			IF !EOF()
				M.DOCUMENTO = "Ordine fornitore N° " + ALLTRIM(ORD_NUMORD) + " del " + RIBALTA2(ORD_DATORD)
				SELECT CU_ALERT_ALLEGATI
				REPLACE DOCUMENTO WITH M.DOCUMENTO
			ENDIF
		ENDIF
	ENDIF
ENDSCAN

SELECT CU_ALERT_ALLEGATI 
GO TOP
IF EOF()
	MESSAGEBOX("Nessun allegato cancellato",64,"Informzione")
	RETURN
ENDIF

cFileName = _PATH + "\Allegati_" + _TIPO + "_cancellati.XLS"
EXPORT TO &cFileName TYPE XL5

DO Open_with_default_windows_program WITH cFileName

RETURN