*************************************************************************************************
*						CONVERSIONE GRUPPI MERCEOLOGICI INDUSTRIALI								*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.														*
*	Ottobre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione dei Gruppi merceologici industriali dalla tabella CARD_GRUPMERC?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


WAIT WINDOWS "Cancellazione vecchi Gruppi merceologici in corso..." NOWAIT

cSql = "DELETE FROM PARA WHERE CODICE LIKE 'GMI%'"
IF !ExecCommand(cSql,"DEL_PARA_GMI")
   return
ENDIF


WAIT WINDOWS "Conversione Gruppi merceologici industriali in corso..." NOWAIT

cSql = ""
TEXT TO cSql NOSHOW

	INSERT INTO PARA (CODICE,DESCRI,LIBERA,PAR_DATINS)
		SELECT
			'GMI'+COMPLETO AS CODICE,
			DESCRIZION AS DESCRI,
			'' AS LIBERA,
			SUBSTRING(ULT_AGG,1,4) + '/' + SUBSTRING(ULT_AGG,3,2) + '/' + SUBSTRING(ULT_AGG,5,2) AS PAR_DATINS
		FROM CARD_GRUPMERC

ENDTEXT

IF !ExecCommand(cSql,"INS_PARA_GMI")
   return
ENDIF


_TOT_COUNT = 0
cSql = "SELECT COUNT(*) AS CONTA FROM PARA WHERE CODICE LIKE 'GMI%'"
IF !ExecCommand(cSql,"TMP_PARA_GMI")
   return
ENDIF
SELECT TMP_PARA_GMI
GO TOP
IF !EOF()
	_TOT_COUNT = CONTA
ENDIF

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Gruppi merceologici industriali convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 