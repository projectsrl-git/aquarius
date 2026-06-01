
LPARAMETERS _par_descr_wait

IF PCOUNT() > 0
ELSE
	_par_descr_wait = ""
ENDIF

IF EMPTY(_par_descr_wait)
	_RISP = MESSAGEBOX("Forzare il popolamento del prezzo di costo di ultimo carico in anagrafica articoli da Di.Ba.?",48+4,"Attenzione")
	IF _RISP = 6
	ELSE
		MESSAGEBOX("Operazione abbandonata",64,"Informazione")
		RETURN .F.
	ENDIF
ENDIF

_conta = 0
_conta_prz_zero = 0

cSql = "SELECT DIT_GRUPPO FROM U_DIS_TT WHERE DIT_GRUPPO IN (SELECT ART_CODPRI FROM U_ART_PR WHERE ART_ULPCAR = 0 AND ART_OBSOL <> 'S') ORDER BY DIT_GRUPPO"
IF !ExecCommand(cSql,"TMP_DIS_TT")
	RETURN(.F.)
ENDIF
SELECT TMP_DIS_TT
GO TOP
SCAN	
	_XY_GRUPPO = DIT_GRUPPO
	
	WAIT WINDOWS IIF(EMPTY(_par_descr_wait),"Rivalutazione",ALLTRIM(_par_descr_wait)) + " Costi / Ricavi / Tempi di produzione Di.Ba. gruppo " + ALLTRIM(_XY_GRUPPO) + " (" + ALLTRIM(STR(RECNO() / RECCOUNT() * 100,10,0)) + "%) ..."  NOWAIT
	
	cSql = "SELECT * FROM U_DIS_TT WHERE DIT_GRUPPO = '" + _XY_GRUPPO + "'"
*!*		IF !ExecRW(cSql,"U_DIS_TT","R")
*!*			RETURN(.F.)
*!*		ENDIF
	IF !ExecCommand(cSql,"CU_DIS_TT")
		RETURN(.F.)
	ENDIF
	
	SCATTER MEMVAR MEMO
	DO RIVALUTA_CAMPI_U_DIS_TT WITH "CU_DIS_TT"
	

	SELECT CU_DIS_TT
	GO TOP
	IF !EOF()
	
		SCATTER MEMVAR MEMO
		
		IF M.DIT_COSTO > 0
		
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
				REPLACE ART_ULPCAR WITH M.DIT_COSTO
			ENDIF
			IF !ExecRW(cSql,"U_ART_PR","W")
			   return(.f.)
			ENDIF
		
		ELSE
			_conta_prz_zero = _conta_prz_zero + 1
		ENDIF

	ENDIF
	
*!*		IF !ExecRW(cSql,"U_DIS_TT","W")
*!*			RETURN(.F.)
*!*		ENDIF
	
	_conta = _conta + 1
ENDSCAN

IF EMPTY(_par_descr_wait)
	MESSAGEBOX("Operazione terminata" + REPLICATE(CHR(13),2) + ;
		"Totale articoli aggiornati: " + ALLTRIM(STR(_conta,10,0)) + ;
		IIF(_conta_prz_zero > 0,REPLICATE(CHR(13),2) + "di cui articoli non valorizzati: " + ALLTRIM(STR(_conta_prz_zero,10,0)),""),64,"Informazione")
ENDIF

