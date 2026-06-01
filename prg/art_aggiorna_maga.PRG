
LPARAMETERS _par_nometabella,_par_nomecampoart,_par_nomecampomag,_par_nomecampodesmag,_par_addwherecondition

WAIT WINDOWS "Lettura tabella " + ALLTRIM(_par_nometabella) + " in corso..." NOWAIT

__NOMETABELLA = ALLTRIM(_par_nometabella)
__NOMECURSORE = "CX_" + ALLTRIM(_par_nometabella)
__NOMECAMPOART = ALLTRIM(_par_nomecampoart)
__NOMECAMPOMAG = ALLTRIM(_par_nomecampomag)
__NOMECAMPODESMAG = ALLTRIM(_par_nomecampodesmag)
__ADDWHERECONDITION = _par_addwherecondition

cSql = "select &__NOMECAMPOART, ID_UNIQUE from &__NOMETABELLA"
IF !EMPTY(__ADDWHERECONDITION)
	cSql = cSql + " where " + __ADDWHERECONDITION
ENDIF
cSql = cSql + " order by &__NOMECAMPOART"
IF !ExecCommand(cSql,__NOMECURSORE)
	return(.f.)
ENDIF

_nRecordUpdated = 0

SELECT &__NOMECURSORE
GO TOP
SCAN

	WAIT WINDOWS "Aggiornamento tabella " + ALLTRIM(_par_nometabella) + " (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
	
	__CODART = ALLTRIM(&__NOMECAMPOART)
	
	SELECT &__NOMECURSORE
	
	_OK_TIPO = .F.
	X_TIPO = CERCATIPO(__CODART)
	IF _V_TIPO_6 AND X_TIPO == '6'  && PANNELLI TRUCIOLARI
		_OK_TIPO = .T.
	ENDIF
	IF !_OK_TIPO
		SELECT &__NOMECURSORE
		LOOP
	ENDIF
	
	IF _V_TIPELA = 1
		x_soci = "u_art_pr.art_codsoc = '" + PUB_CODSOC + "'"
		x_codi = "u_art_pr.art_codpri = '" + __CODART + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "select ART_CODMAT, ART_SPESSO, ART_TIPON from u_art_pr left outer join u_art_an on u_art_an.art_codsoc = u_art_pr.art_codsoc " + ;
		       "and u_art_an.art_codpri = u_art_pr.art_codpri where " + x_cond
		IF !ExecCommand(cSql,"CUR_ARTICOLI_N")
			RETURN .F.
		ENDIF
		SELECT CUR_ARTICOLI_N
		GO TOP
		IF !EOF()
			NEW_CODMAG = DETERMINA_MAGAZZINO(ART_CODMAT,ART_SPESSO,ART_TIPON)
			NEW_DESMAG = ""
			x_cond = "CODICE = 'MAG" + ALLTRIM(NEW_CODMAG) + "'"
			cSql = "select * from PARA where " + x_cond
			IF !ExecCommand(cSql,"CUR_PARA")
				RETURN .F.
			ENDIF
			SELECT CUR_PARA
			GO TOP
			IF !EOF()
				NEW_DESMAG = DESCRI
			ENDIF
		ENDIF
	ENDIF
	
	SELECT &__NOMECURSORE
	__ID_UNIQUE = ID_UNIQUE
	IF !EMPTY(NEW_CODMAG) AND !EMPTY(__NOMECAMPOMAG)
		cSql = "UPDATE &__NOMETABELLA SET &__NOMECAMPOMAG = '" + ALLTRIM(NEW_CODMAG) + "' WHERE ID_UNIQUE = '" + ID_UNIQUE + "'"
		IF !ExecCommand(cSql,"UPDATE_MAG")
			return(.f.)
		ENDIF
		IF !EMPTY(NEW_DESMAG) AND !EMPTY(__NOMECAMPODESMAG)
			cSql = "UPDATE &__NOMETABELLA SET &__NOMECAMPODESMAG = '" + ALLTRIM(NEW_DESMAG) + "' WHERE ID_UNIQUE = '" + ID_UNIQUE + "'"
			IF !ExecCommand(cSql,"UPDATE_DESMAG")
				return(.f.)
			ENDIF
		ENDIF
		_nRecordUpdated = _nRecordUpdated + 1
	ENDIF
ENDSCAN

WAIT CLEAR

RETURN
