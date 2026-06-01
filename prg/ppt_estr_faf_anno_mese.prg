
_C_ANNO = PJ_INPUTBOX("Inserire l'anno di riferimento","Estrazione fatturato fornitori al mese selezionato",ALLTRIM(STR(VAL(PUB_ANNO))))
IF VAL(_C_ANNO) > 0
ELSE
	MESSAGEBOX("Anno di riferimento non valido",16,"Attenzione")
	RETURN .F.
ENDIF

_C_MESE = PJ_INPUTBOX("Inserire il mese fino al quale effettuare l'estrazione","Estrazione fatturato fornitori al mese selezionato",PADL(ALLTRIM(STR(MONTH(DATE()))),2,'0'))
_C_MESE = PADL(ALLTRIM(_C_MESE),2,'0')
IF VAL(_C_MESE) > 0 AND VAL(_C_MESE) <= 12
ELSE
	MESSAGEBOX("Mese Al non valido",16,"Attenzione")
	RETURN .F.
ENDIF

_RISP = MESSAGEBOX("Estrarre in excel i dati del fatturato fornitori al mese selezionato?",4+32,"Attenzione")
IF _RISP <> 6
	RETURN .F.
ENDIF

WAIT WINDOWS "Estrazione dati in corso..." NOWAIT		

x_anno = "SUBSTRING(MOV_DTDOC,1,4) = '" + _C_ANNO + "'"
x_mese = "SUBSTRING(MOV_DTDOC,6,2) <= '" + _C_MESE + "'"
x_cond = x_anno + " and " + x_mese 
cSql   = ""
TEXT TO cSql NOSHOW
	SELECT
		con_descr AS RAG_SOCIALE,
		SUBSTRING(MOV_DTDOC,1,7) AS ANNO_MESE,
		SUM((CASE WHEN SUBSTRING(LIBERA,11,1) = 'S' THEN -1 ELSE 1 END) * MOV_IMP) AS IMPORTO
	FROM (
		SELECT mov_cont.*, conti.con_descr, conti.con_tipoco, COALESCE(para.libera,'') AS libera 
		FROM mov_cont 
		LEFT OUTER JOIN conti on conti.con_soc = 01 and conti.con_anno = mov_cont.mov_anno and conti.con_conto = mov_cont.mov_conto 
		LEFT OUTER JOIN para on para.codice = 'TOP'+mov_cont.mov_top 
		WHERE 
			con_tipoco in ('F') and SUBSTRING(libera,2,1) = 'S' AND
			<<x_cond>>
		) AS MAIN
	GROUP BY MOV_CONTO,CON_DESCR,SUBSTRING(MOV_DTDOC,1,7)
	ORDER BY CON_DESCR,SUBSTRING(MOV_DTDOC,1,7)
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
	MESSAGEBOX("Nessun dato estratto",48,"Attenzione")
ELSE
	_TITOLO_EXCEL1 =  "Estrazione fatturato fornitori fino al mese selezionato"
	_TITOLO_EXCEL2 =  "ANNO DI RIFERIMENTO: " + _C_ANNO 
	_TITOLO_EXCEL3 =  "FINO AL MESE: " + _C_MESE
	DO ESTRXLS WITH "CUR_EXCEL",_TITOLO_EXCEL1,_TITOLO_EXCEL2,_TITOLO_EXCEL3,.T.
ENDIF

WAIT WINDOWS "Estrazione dati in corso..." NOWAIT		

x_anno = "SUBSTRING(MOV_DTDOC,1,4) = '" + _C_ANNO + "'"
x_mese = "SUBSTRING(MOV_DTDOC,6,2) <= '" + _C_MESE + "'"
x_cond = x_anno + " and " + x_mese 
cSql   = ""
TEXT TO cSql NOSHOW
	SELECT
		con_descr AS RAG_SOCIALE,
		SUBSTRING(MOV_DTDOC,1,4) AS ANNO,
		SUM((CASE WHEN SUBSTRING(LIBERA,11,1) = 'S' THEN -1 ELSE 1 END) * MOV_IMP) AS IMPORTO
	FROM (
		SELECT mov_cont.*, conti.con_descr, conti.con_tipoco, COALESCE(para.libera,'') AS libera 
		FROM mov_cont 
		LEFT OUTER JOIN conti on conti.con_soc = 01 and conti.con_anno = mov_cont.mov_anno and conti.con_conto = mov_cont.mov_conto 
		LEFT OUTER JOIN para on para.codice = 'TOP'+mov_cont.mov_top 
		WHERE 
			con_tipoco in ('F') and SUBSTRING(libera,2,1) = 'S' AND
			<<x_cond>>
		) AS MAIN
	GROUP BY MOV_CONTO,CON_DESCR,SUBSTRING(MOV_DTDOC,1,4)
	ORDER BY CON_DESCR
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
	MESSAGEBOX("Nessun dato estratto",48,"Attenzione")
ELSE
	_TITOLO_EXCEL1 =  "Estrazione fatturato fornitori raggruppato fino al mese selezionato"
	_TITOLO_EXCEL2 =  "ANNO DI RIFERIMENTO: " + _C_ANNO 
	_TITOLO_EXCEL3 =  "FINO AL MESE: " + _C_MESE
	DO ESTRXLS WITH "CUR_EXCEL",_TITOLO_EXCEL1,_TITOLO_EXCEL2,_TITOLO_EXCEL3,.T.
ENDIF

MESSAGEBOX("Fine estrazione",64,"Informazione")

RETURN

