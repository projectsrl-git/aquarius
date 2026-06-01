
* -->> lettura para
* ----------------------
TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'CPA'+?m.cli_codcli
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA




* -->> utilizzo di elenco
* --------------------------------
SWS=SELECT()
	
	TEXT TO cSql NOSHOW
		SELECT *
		FROM para
		where codice = 'IVA'+?m.cli_codiva
	ENDTEXT
    PUB_SELECT = "para"
	PUB_SEEK   = cSql
    PUB_TESTA  = "Codice;Descrizione"
	PUB_VISTA  = "SUBSTR(CODICE,4,3);DESCRI"
   	PUB_RIT    = "SUBSTR(CODICE,4,3)"

	DO Form elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri"

   	STORE PUB_RIT TO M.CLI_CODIVA

SELECT(SWS)
