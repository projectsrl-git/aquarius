
LPARAMETERS _par_aggiorna_przcos,_par_descr_wait,_par_opzdbcost,_par_non_aggiorna_u_dis_tt

IF PCOUNT() > 0
ELSE
	_par_aggiorna_przcos = .F.
ENDIF

IF PCOUNT() > 1
ELSE
	_par_descr_wait = ""
ENDIF

**=> ERASMO - INIZIO 11/08/2020
IF PCOUNT() > 2
ELSE
	_par_opzdbcost = PUB_OPZDBCOST
ENDIF

IF PCOUNT() > 3
ELSE
	_par_non_aggiorna_u_dis_tt = .f.
ENDIF
**=> ERASMO - FINE 11/08/2020

IF EMPTY(_par_descr_wait)
	_RISP = MESSAGEBOX("Rivalutare tutti i campi di testata delle Di.Ba. presenti" + IIF(_par_aggiorna_przcos," ed il prezzo di costo standard in anagrafica articoli","") + "?",48+4,"Attenzione")
	IF _RISP = 6
	ELSE
		MESSAGEBOX("Operazione abbandonata",64,"Informazione")
		RETURN .F.
	ENDIF
ENDIF

*!*	**=> ERASMO - INIZIO 11/08/2020
*!*	_SAVE_OPZDBCOST = PUB_OPZDBCOST
*!*	PUB_OPZDBCOST = _par_opzdbcost
*!*	**=> ERASMO - FINE 11/08/2020

**=> ERASMO - INIZIO 25/10/2020
IF TYPE("PUB_OPZDBCOST") == 'N' AND PUB_OPZDBCOST > 0
	_SAVE_OPZDBCOST = PUB_OPZDBCOST
ELSE
	_SAVE_OPZDBCOST = 1
ENDIF
PUB_OPZDBCOST = _par_opzdbcost
**=> ERASMO - FINE 25/10/2020

_conta = 0

*!*	cSql = "SELECT DIT_GRUPPO FROM U_DIS_TT ORDER BY DIT_GRUPPO"
*!*	IF !ExecCommand(cSql,"TMP_DIS_TT")
*!*		RETURN(.F.)
*!*	ENDIF
**=> ERASMO - INIZIO 11/08/2020
*** TRAMITE LA QUERY RICORSIVA DI ESPLOSIONE DI.BA., CERCO TUTTI I GRUPPI DI.BA. ORDINANDOLI DAL LIVELLO PIU' BASSO IN QUANTO IL COSTO DEI LIVELLI PIU' ALTI DIPENDE ANCHE DA QUESTI
cSql=""     
cNomeCursorSql="TMP_DIS_TT"
TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY

	WITH AlberoDIBA
	AS (
	    SELECT 
			1 AS LIVELLO,
			DIS_GRUPPO AS PADRE,
			CAST(COALESCE(RTRIM(DIS_CODART),'') AS VARCHAR(1000)) AS GERARCHIA,
			U_DIS_DD.*
	    FROM U_DIS_DD
	    UNION ALL
	    SELECT 
			LIVELLO + 1,
			DD.DIS_GRUPPO AS PADRE,
			CAST(AlberoDIBA.GERARCHIA+' -> '+RTRIM(DD.DIS_CODART) AS VARCHAR(1000)) AS GERARCHIA,
			DD.*
	    FROM U_DIS_DD AS DD
	    INNER JOIN AlberoDIBA
	    ON DD.DIS_GRUPPO = AlberoDIBA.DIS_CODART
	)

	SELECT MAX(LIVELLO) AS LIV_MAX,PADRE AS DIT_GRUPPO FROM AlberoDIBA WHERE PADRE IN (SELECT DIT_GRUPPO FROM U_DIS_TT)
	GROUP BY PADRE
	ORDER BY LIV_MAX DESC

ENDTEXT					&& FINE SCRITTURA QUERY

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF
**=> ERASMO - FINE 11/08/2020

SELECT TMP_DIS_TT
GO TOP
SCAN	
	_XY_GRUPPO = DIT_GRUPPO
	
	WAIT WINDOWS IIF(EMPTY(_par_descr_wait),"Rivalutazione",ALLTRIM(_par_descr_wait)) + " Costi / Ricavi / Tempi di produzione Di.Ba. gruppo " + ALLTRIM(_XY_GRUPPO) + " (" + ALLTRIM(STR(RECNO() / RECCOUNT() * 100,10,0)) + "%) ..."  NOWAIT
	
	cSql = "SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = '" + _XY_GRUPPO + "'"
*!*		IF !ExecRW(cSql,"U_DIS_TT","R")
*!*			RETURN(.F.)
*!*		ENDIF
	**=> ERASMO - INIZIO 11/08/2020
	IF _par_non_aggiorna_u_dis_tt
		IF !ExecCommand(cSql,"U_DIS_TT")
			RETURN(.F.)
		ENDIF
	ELSE
		IF !ExecRW(cSql,"U_DIS_TT","R")
			RETURN(.F.)
		ENDIF
	ENDIF
	**=> ERASMO - FINE 11/08/2020
	
	SCATTER MEMVAR MEMO
	DO RIVALUTA_CAMPI_U_DIS_TT WITH "U_DIS_TT"
	
	IF _par_aggiorna_przcos
		SELECT U_DIS_TT
		GO TOP
		IF !EOF()
*!*				cSql = "UPDATE U_ART_PR SET ART_PRZCOS = " + STRTRAN(STR(DIT_COSTO,19,6),',','.') + " WHERE ART_CODPRI = '" + _XY_GRUPPO + "'"
*!*				IF !ExecCommand(cSql,"UPD_ART_PR")
*!*					RETURN(.F.)
*!*				ENDIF
			
			SCATTER MEMVAR MEMO
			
			x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
			x_codi = "art_codpri = '" + ALLTRIM(M.DIT_GRUPPO) + "'"
			x_cond = x_soci + " and " + x_codi
			Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
			IF !ExecRW(cSql,"u_art_pr","R")
			   return(.f.)
			ENDIF
			SELECT u_art_pr
			GO TOP
			IF !EOF()
			   	REPLACE ART_GRUPPO WITH .T.
				REPLACE ART_PRZCOS WITH M.DIT_COSTO
				IF PUB_PRZDIB
					REPLACE ART_COSLAI WITH M.DIT_COSLAI
					REPLACE ART_COSLAE WITH M.DIT_COSLAE
					REPLACE ART_COSMAT WITH M.DIT_COSMAT
					REPLACE ART_COSATR WITH M.DIT_COSATR
					REPLACE ART_ORELAV WITH M.DIT_ORELAV
					REPLACE ART_OREATT WITH M.DIT_OREATT
					REPLACE ART_OREIMP WITH M.DIT_OREIMP
					REPLACE ART_SECIMP WITH M.DIT_SECIMP
					REPLACE ART_SECLAV WITH M.DIT_SECLAV
					REPLACE ART_SECATT WITH M.DIT_SECATT
				ENDIF
			ENDIF
			IF !ExecRW(cSql,"U_ART_PR","W")
			   return(.f.)
			ENDIF

		ENDIF
	ENDIF
	
*!*		IF !ExecRW(cSql,"U_DIS_TT","W")
*!*			RETURN(.F.)
*!*		ENDIF
	**=> ERASMO - INIZIO 11/08/2020
	IF _par_non_aggiorna_u_dis_tt
	ELSE
		IF !ExecRW(cSql,"U_DIS_TT","R")
			RETURN(.F.)
		ENDIF
	ENDIF
	**=> ERASMO - FINE 11/08/2020
	
	_conta = _conta + 1
ENDSCAN

**=> ERASMO - INIZIO 11/08/2020
PUB_OPZDBCOST = _SAVE_OPZDBCOST
**=> ERASMO - FINE 11/08/2020

IF EMPTY(_par_descr_wait)
	MESSAGEBOX("Operazione terminata" + REPLICATE(CHR(13),2) + ;
		"Totale gruppi Di.Ba. rivalutati: " + ALLTRIM(STR(_conta,10,0)),64,"Informazione")
ENDIF

