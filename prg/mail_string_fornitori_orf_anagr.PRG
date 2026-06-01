
RELEASE _V_DIRECTORY_FILE_PDF
PUBLIC _V_DIRECTORY_FILE_PDF
_V_DIRECTORY_FILE_PDF =""

*!*	PRELEVA LA DIRECTORY OVE MEMORIZZARE I FILE PDF
RELEASE _DIRECTORY_PDF 
PUBLIC _DIRECTORY_PDF 

v_seek	  = 'FSDEMAIL'
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
   _V_DIRECTORY_FILE_PDF  = "C:\FILE_PDF_DA_SPEDIRE"
   APPEND BLANK
   REPLACE CODICE WITH 'FSDEMAIL'
   REPLACE DESCRI WITH "DIRECTORY PER IL SALVATAGGIO DEI FILE PDF DA SPEDIRE"
   REPLACE LIBERA WITH ALLTRIM(_V_DIRECTORY_FILE_PDF)
   IF !ExecRW(cSql,"PARA","W")
	  return(.f.)
   ENDIF
ELSE
	_V_DIRECTORY_FILE_PDF = ALLTRIM(LIBERA)
ENDIF

_risp = MESSAGEBOX("Estrarre gli indirizzi e-mail concatenati dei fornitori?",4+32,"Attenzione")
IF _risp = 6
ELSE
	MESSAGEBOX("Operazione abbandonata",64,"Informazione")
	RETURN .F.
ENDIF

cSql=""     
cNomeCursorSql="EMAIL_FORNITORI"
TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
	
	SELECT 
			CAST(coalesce(stuff((select  DISTINCT ';' + RTRIM(EMAIL) FROM (

									SELECT CAST(EMAIL AS VARCHAR(200)) AS EMAIL FROM (
										SELECT
											CASE
												WHEN SUBSTRING(IND_EMAIL_A_ORF,1,1) <> '' THEN IND_EMAIL_A_ORF	ELSE IND_EMAIL_ANAGR
											END AS EMAIL
										FROM GRUPPI_MAIL_FORNITORI WHERE CODICE IN (SELECT FOR_CODCLI FROM U_FOR_AN WHERE FOR_OBSOL = '')
										) AS MAIN
									WHERE SUBSTRING(EMAIL,1,1) <> ''

									) AS MAIN2

	                    for xml path('')
	                ),1,1,''),'') AS TEXT) AS EMAILS
	                
	                
ENDTEXT					&& FINE SCRITTURA QUERY
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT EMAIL_FORNITORI
GO TOP
IF EOF()
	MESSAGEBOX("Nessun indirizzo e-mail fornitori trovato",48,"Informazione")
	RETURN .F.
ENDIF

STRTOFILE(ALLTRIM(EMAILS),_V_DIRECTORY_FILE_PDF+"\Indirizzi_e-mail_concatenati_fornitori"+SYS(2015)+".txt",0)
_V_RUN = "/N Explorer /e," + ALLTRIM(_V_DIRECTORY_FILE_PDF)
RUN &_V_RUN

MESSAGEBOX("Operazione effettuata",64,"Informazione")

RETURN .t.

