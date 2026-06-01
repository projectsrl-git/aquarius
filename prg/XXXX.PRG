
*** ########################################################### AGGIORNA DATI IMPIANTO ###########################################################



SELECT CU_IMPIANTI_TT
_ACT_ID_PMKEY = ID_PMKEY
SCATTER MEMVAR MEMO
	
	
IF DELETED()	&& ########################################### CANCELLA IMPIANTO ###########################################
	x_cond = "id_pmkey = '" + ALLTRIM(M.ID_PMKEY) + "'"
	cSql   = "DELETE from IMPIANTI_TT where " + x_cond
	IF !ExecCommand(cSql,"DEL_IMPIANTI_TT")
	   return(.f.)
	ENDIF

	x_cond = "id_pmkey = '" + ALLTRIM(M.ID_PMKEY) + "'"
	cSql   = "DELETE from IMPIANTI_DD where " + x_cond
	IF !ExecCommand(cSql,"DEL_IMPIANTI_DD")
	   return(.f.)
	ENDIF

	x_cond = "id_pmkey = '" + ALLTRIM(M.ID_PMKEY) + "'"
	cSql   = "DELETE from IMPIANTI_TE where " + x_cond
	IF !ExecCommand(cSql,"DEL_IMPIANTI_TE")
	   return(.f.)
	ENDIF
    
ELSE

	x_cond = "id_pmkey = '" + ALLTRIM(M.ID_PMKEY) + "'"
	cSql   = "select * from IMPIANTI_TT where " + x_cond
	IF !ExecRW(cSql,"IMPIANTI_TT","R")
	   return(.f.)
	ENDIF
	SELECT IMPIANTI_TT
	GO TOP
	IF EOF()
		APPEND BLANK
	ELSE
		M.ID_UNIQUE = ID_UNIQUE
	ENDIF

	_TotFields=afields(_NameFields)
	for _x=1 to _TotFields
		IF ALLTRIM(_NameFields[_x,1]) == "ID_UNIQUE"
		ELSE
			_cField  = _NameFields[_x,1]
			_cMemvar = "M." + _NameFields[_x,1]
			REPLACE &_cField WITH &_cMemvar 
		ENDIF
	NEXT

	IF !ExecRW(cSql,"IMPIANTI_TT","W")
		return(.f.)
	ENDIF


ENDIF

