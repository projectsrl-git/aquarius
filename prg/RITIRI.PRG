DATADAL = RIBALTA2(DATADAL)

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_agen = "cli_age = '" + ALLTRIM(AGEDAL) + "'"
x_cond = x_soci



*** Simone - 16/06/2009 - INIZIO
IF V_NAZIONE = 1
	x_nazio = " and cli_nazion = 'ITA' "
ENDIF

IF V_NAZIONE = 2
	x_nazio = " and cli_nazion <> 'ITA' "
ENDIF

IF V_NAZIONE = 3
	x_nazio = ""
ENDIF
*** Simone - 16/06/2009 - FINE


IF BALL_SCELTA=1
ELSE
   x_cond = x_cond + " and " + x_agen
ENDIF

**=> ERASMO - INIZIO 27/11/2018
WAIT WINDOWS "Elaborazione in corso..." NOWAIT

*** INVECE DI SCANSIONARE L'INTERA TABELLA DEI CLIENTI, ESTRAGGO SOLO QUELLI INTERESSATI
x_cond = x_cond + " and CLI_CODCLI NOT IN (SELECT STC_CODCLI FROM U_STC_AN WHERE stc_dtdoc  >= '" + DATADAL + "')"
IF PUB_NOCLICEE  && SCARTO I CLIENTI UTILIZZATI SOLO AI FINI DEL MECCANISMO DEL REVERE CHARGE
	x_cond = x_cond + " and CLI_CODCLI NOT IN (SELECT FOR_CLICEE FROM U_FOR_AN)"
ENDIF
IF _OPZCLINOFAT
	x_cond = x_cond + " and CLI_CODCLI IN (SELECT ORD_CODCLI FROM U_FAT_TT)"
ENDIF
**=> ERASMO - FINE 27/11/2018  
   
cSql="SELECT * FROM U_CLI_AN WHERE " + x_cond + x_nazio  + "order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"cur_cli_an")
   return(.f.)
ENDIF

SELECT CUR_CLI_AN
GO TOP

QQ=AFIELDS(PIPPO)
CREATE CURSOR WORK FROM ARRAY PIPPO
INDEX ON CLI_AGE+CLI_RAGSOC TAG WORK
INDEX ON CLI_CODCLI TAG WORK1

SELECT CUR_CLI_AN
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
    
   SCATTER MEMVAR MEMO
   CODCLI = CLI_CODCLI
   RAGCLI = CLI_RAGSOC   
  
   OUT=.F.
   
   x_soci = "stc_codsoc = '" + PUB_CODSOC + "'" 
   x_codi = "stc_codcli = '" + CODCLI + "'"
   x_data = "stc_dtdoc  >= '" + DATADAL + "'"
   cSql="SELECT * FROM U_STC_AN WHERE " + x_soci + " and " + x_codi + ;
                                   " and " + x_data + " order by stc_codsoc,stc_codcli"
   IF !ExecCommand(cSql,"cur_stc_an")
      return(.f.)
   ENDIF
   SELECT CUR_STC_AN
   GO TOP
   IF EOF()
      OUT = .F.
   ELSE
      OUT = .T.
   ENDIF

*!*	*!*	   *** Simone - 16/06/2009 - INIZIO
*!*	*!*	   *** SCARTO DALL'ANALISI TUTTI I FORNITORI CHE SONO ANCHE CLIENTI
*!*	*!*	   x_soci = "for_codsoc = '" + PUB_CODSOC + "'" 
*!*	*!*	   x_codi = "for_RAGSOC = '" + RAGCLI + "'"
*!*	*!*	   cSql="SELECT for_codcli FROM U_for_AN WHERE " + x_soci + " and " + x_codi
*!*	*!*	   IF !ExecCommand(cSql,"CU_FOR_AN")
*!*	*!*	      return(.f.)
*!*	*!*	   ENDIF
*!*	*!*	   SELECT CU_FOR_AN
*!*	*!*	   GO TOP
*!*	*!*	   IF !EOF()
*!*	*!*		   OUT = .T.
*!*	*!*	   ENDIF
*!*	*!*	   *** Simone - 16/06/2009 - FINE
   
   IF !OUT
      SELECT WORK
      APPEND BLANK
      GATHER MEMVAR MEMO
   ENDIF
  
   SELECT CUR_CLI_AN
   WAIT WINDOW "Codice cliente: "+CODCLI NOWAIT 
   SKIP +1
   
ENDDO



IF ORDINA<>1
   SELECT WORK 
   SET ORDER TO WORK
   GO TOP

   IF !EOF()   
      DO MENUSTA WITH "WORK",.T.,.T.,"XXX","RITIRI","RITIRI.FRX"
   ELSE
      =MESSAGEBOX("Nessun dato statistico da stampare",64,"*** INFORMAZIONE ***")
   ENDIF
*   IF EOF()
*      =MESSAGEBOX("Nessun dato statistico da stampare",16,"Attenzione")
*   ENDIF

*   V_REPORT=CERCAREPO("XXX","RITIRI","RITIRI.FRX")
*   RIT = MESSAGEBOX("Vuoi il preview del modulo ?",292,"ATTENZIONE")
*   IF RIT = 6
*      REPORT FORM &V_REPORT NOEJECT NOCONSOLE PREVIEW
*   ENDIF
*   REPORT FORM &V_REPORT NOEJECT NOCONSOLE TO PRINTER PROMPT
ELSE
   SELECT WORK 
   SET ORDER TO WORK1
   GO TOP

   IF !EOF()   
      DO PRG\MENUSTA WITH "WORK",.T.,.T.,"XXX","RITIRI1","RITIRI1.FRX"
   ELSE
      =MESSAGEBOX("Nessun dato statistico da stampare",64,"*** INFORMAZIONE ***")
   ENDIF
*   IF EOF()
*      =MESSAGEBOX("Nessun dato statistico da stampare",16,"Attenzione")
*      RETURN
*   ENDIF

*   V_REPORT=CERCAREPO("XXX","RITIRI1","RITIRI1.FRX")
*   RIT = MESSAGEBOX("Vuoi il preview del modulo ?",292,"ATTENZIONE")
*   IF RIT = 6
*      REPORT FORM &V_REPORT NOEJECT NOCONSOLE PREVIEW
*   ENDIF
*   REPORT FORM &V_REPORT NOEJECT NOCONSOLE TO PRINTER PROMPT
ENDIF

DATADAL = RIBALTA2(DATADAL)

RETURN

***************
FUNCTION DESAGE
***************
PARA DDDA

SS=STR(SELECT())

x_soci = "age_codsoc = '" + PUB_CODSOC + "'"
x_codi = "age_codice = '" + DDDA + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_age_an where " + x_cond + " order by age_codsoc,age_codice"
IF !ExecCommand(cSql,"CUR_AGEN")
   RETURN .F.
ENDIF
SELECT CUR_AGEN
GO TOP   
IF EOF()
   OUT = ""
ELSE
   OUT = AGE_RAGSOC
ENDIF         

SELECT &SS
RETURN(OUT)