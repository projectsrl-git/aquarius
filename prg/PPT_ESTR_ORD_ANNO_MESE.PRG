
_C_ANNO = PJ_INPUTBOX("Inserire l'anno di riferimento","Estrazione ordinato clienti raggruppata per tipo pannello al mese selezionato",ALLTRIM(STR(VAL(PUB_ANNO))))
IF VAL(_C_ANNO) > 0
ELSE
	MESSAGEBOX("Anno di riferimento non valido",16,"Attenzione")
	RETURN .F.
ENDIF

_C_MESE = PJ_INPUTBOX("Inserire il mese fino al quale effettuare l'estrazione","Estrazione ordinato clienti raggruppata per tipo pannello al mese selezionato",PADL(ALLTRIM(STR(MONTH(DATE()))),2,'0'))
_C_MESE = PADL(ALLTRIM(_C_MESE),2,'0')
IF VAL(_C_MESE) > 0 AND VAL(_C_MESE) <= 12
ELSE
	MESSAGEBOX("Mese Al non valido",16,"Attenzione")
	RETURN .F.
ENDIF

_RISP = MESSAGEBOX("Estrarre in excel i dati dell'ordinato clienti raggruppati per tipo pannello al mese selezionato?",4+32,"Attenzione")
IF _RISP <> 6
	RETURN .F.
ENDIF

WAIT WINDOWS "Estrazione dati in corso..." NOWAIT		

x_anno = "SUBSTRING(ANNO_MESE,1,4) = '" + _C_ANNO + "'"
x_mese = "SUBSTRING(ANNO_MESE,6,2) <= '" + _C_MESE + "'"
x_cond = x_anno + " and " + x_mese 
cSql   = ""
TEXT TO cSql NOSHOW
	SELECT 
		SUBSTRING(ANNO_MESE,1,4) AS ANNO,
		TIPO,
		DESCRIZIONE,
		SUM(QTA_MC) AS QTA_MC,
		SUM(VALORE) AS VALORE
	FROM (
		SELECT
			MAIN.ANNO_MESE,
			MAIN.TIPO,
			COALESCE(P_TIG.DESCRI,'') AS DESCRIZIONE,
			SUM(QTA_MC) AS QTA_MC,
			SUM(VALORE) AS VALORE
		FROM (
			SELECT 
				SUBSTRING(ORS_DATORD,1,7) AS ANNO_MESE,
				SUBSTRING(ORD_CODART,1,2) AS TIPO,
				ORD_QTAMC AS QTA_MC,
				ORD_VALORE AS VALORE
			FROM U_ORD_DD
			WHERE ORD_DESART <> '*** COMMENTO ***' AND ORD_CODART <> '' AND 
				ORD_CODART IN (SELECT ART_CODPRI FROM U_ART_PR WHERE ART_CODMAT = '008' AND LEN(RTRIM(ART_CODPRI)) = 16 AND ART_GRUPRD <> ART_CODPRI)
			) AS MAIN
		LEFT OUTER JOIN PARA AS P_TIG ON P_TIG.CODICE = 'TIG'+MAIN.TIPO
		WHERE 
			<<x_cond>>
		GROUP BY MAIN.ANNO_MESE, MAIN.TIPO, COALESCE(P_TIG.DESCRI,'')
		) AS SQ
	GROUP BY SUBSTRING(SQ.ANNO_MESE,1,4), SQ.TIPO, SQ.DESCRIZIONE
	ORDER BY TIPO
ENDTEXT

IF !ExecPreparedCommand(cSql,"CUR_EXCEL")
   RETURN .F.
ENDIF
SELECT CUR_EXCEL
GO TOP

WAIT CLEAR

SELECT CUR_EXCEL
GO TOP
IF EOF()
	MESSAGEBOX("Nessun cliente/fornitore estratto",48,"Attenzione")
ELSE
	_TITOLO_EXCEL1 =  "Estrazione ordinato clienti raggruppata per tipo pannello fino al mese selezionato"
	_TITOLO_EXCEL2 =  "ANNO DI RIFERIMENTO: " + _C_ANNO 
	_TITOLO_EXCEL3 =  "FINO AL MESE: " + _C_MESE
	DO ESTRXLS WITH "CUR_EXCEL",_TITOLO_EXCEL1,_TITOLO_EXCEL2,_TITOLO_EXCEL3,.T.
ENDIF

MESSAGEBOX("Fine estrazione",64,"Informazione")

RETURN

