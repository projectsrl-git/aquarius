*************************************************************************************************
*						               CONVERSIONE MAGAZZINI									*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.														*
*	Ottobre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione delle Magazzini dalla tabella CARD_TABMAGAZ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


WAIT WINDOWS "Cancellazione vecchi Magazzini in corso..." NOWAIT

cSql = "DELETE FROM PARA WHERE CODICE LIKE 'MAG%'"
IF !ExecCommand(cSql,"DEL_PARA_MAG")
   return
ENDIF


WAIT WINDOWS "Conversione Magazzini in corso..." NOWAIT

cSql = ""
TEXT TO cSql NOSHOW

	INSERT INTO PARA (CODICE,DESCRI,LIBERA,PAR_DATINS)
		SELECT
			CASE CODMAGAZ
				WHEN 'VEN' THEN 'MAGSEDE'
				ELSE 'MAG'+CODMAGAZ
			END AS CODICE,
			DESCRMAGAZ AS DESCRI,
			GF_MAGAZ AS LIBERA,
			SUBSTRING(ULT_AGG,1,4) + '/' + SUBSTRING(ULT_AGG,3,2) + '/' + SUBSTRING(ULT_AGG,5,2) AS PAR_DATINS
		FROM CARD_TABMAGAZ

ENDTEXT

IF !ExecCommand(cSql,"INS_PARA_MAG")
   return
ENDIF


_TOT_COUNT = 0
cSql = "SELECT COUNT(*) AS CONTA FROM PARA WHERE CODICE LIKE 'MAG%'"
IF !ExecCommand(cSql,"TMP_PARA_MAG")
   return
ENDIF
SELECT TMP_PARA_MAG
GO TOP
IF !EOF()
	_TOT_COUNT = CONTA
ENDIF

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Magazzini convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 