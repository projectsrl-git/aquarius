*************************************************************************************************
*						          CONVERSIONE CLASSI DOGANALI									*
*							 																	*
*	by Erasmo Masiello per Project S.r.l.														*
*	Ottobre 2013: Cardioline			 														*
*************************************************************************************************

RIT = MESSAGEBOX("Procedo con la conversione delle Classi doganali dalla tabella CARD_CODDOGAN?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


WAIT WINDOWS "Cancellazione vecchie Classi doganali in corso..." NOWAIT

cSql = "DELETE FROM PARA WHERE CODICE LIKE 'DOG%'"
IF !ExecCommand(cSql,"DEL_PARA_DOG")
   return
ENDIF


WAIT WINDOWS "Conversione Classi doganali in corso..." NOWAIT

cSql = ""
TEXT TO cSql NOSHOW

	INSERT INTO PARA (CODICE,DESCRI,LIBERA,PAR_DATINS)
		SELECT 
			'DOG'+CHIAVE AS CODICE,
			DESCR AS DESCRI,
			UNISUPP_SN AS LIBERA,
			SUBSTRING(ULT_AGG,1,4) + '/' + SUBSTRING(ULT_AGG,3,2) + '/' + SUBSTRING(ULT_AGG,5,2) AS PAR_DATINS
		FROM CARD_CODDOGAN

ENDTEXT

IF !ExecCommand(cSql,"INS_PARA_DOG")
   return
ENDIF


_TOT_COUNT = 0
cSql = "SELECT COUNT(*) AS CONTA FROM PARA WHERE CODICE LIKE 'DOG%'"
IF !ExecCommand(cSql,"TMP_PARA_DOG")
   return
ENDIF
SELECT TMP_PARA_DOG
GO TOP
IF !EOF()
	_TOT_COUNT = CONTA
ENDIF

WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale Classi doganali convertite: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 