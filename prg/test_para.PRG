DO setlib

SET STEP ON 

*!*	CLI_DESVET = "SAIMA AVANDERO"
*!*	V_SEEK = "VET"+ALLTRIM(CLI_DESVET)
*!*	IF SEEK_STD('PARA',V_SEEK,'DESCRI','VET_PARA')
*!*	    SELECT VET_PARA
*!*	    M.CLI_VETTO1   	= SUBSTR(CODICE,4,3)
*!*	ELSE
*!*		M.CLI_VETTO1   	= ""
*!*	ENDIF       				






*!*	ACCESSO PER DESCRIZIONE PARAMETRO
gcFindString= "SAIMA AVANDERO"
TIPO_PARAMETRO = "VET"
X_CHIAVE = "SUBSTRING(CODICE,1,3) = '" + TIPO_PARAMETRO + "'"
X_DESCRI = "DESCRI = '" + gcFindString + "'"
x_cond = x_chiave  + " and " + x_descri 
Csql    = "SELECT * FROM PARA WHERE " + x_cond
IF !ExecCommand(cSql,"vet_para")
   return(.f.)
ENDIF
SELECT vet_para
GO top
IF !EOF()
    M.CLI_VETTO1   	= SUBSTR(CODICE,4,3)
ELSE
	M.CLI_VETTO1   	= ""
ENDIF       				






