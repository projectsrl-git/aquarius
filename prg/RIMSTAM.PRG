*************************************************************
* PROGRAMMA DI ESTRAZIONE DATI PER STAMPA MODULO DI ACCONTO *
*************************************************************

RELEASE XXX_ACCONT,XXX_DATRIM,XXX_CODCLI,XXX_RAGSOC,XXX_TELEFO,XXX_LOCALI,XXX_INDIRI
PUBLIC  XXX_ACCONT,XXX_DATRIM,XXX_CODCLI,XXX_RAGSOC,XXX_TELEFO,XXX_LOCALI,XXX_INDIRI
XXX_ACCONT = 0
XXX_DATRIM = ""
XXX_CODCLI = ""
XXX_RAGSOC = ""
XXX_TELEFO = ""
XXX_LOCALI = ""
XXX_INDIRI = ""

* PRELEVO DATI PER STAMPA
SELECT CU_ORD_DD
GO TOP

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_tagg = "taggancio = '" + DAGGANCIO + "'"
x_cond = x_soci + " and " + x_tagg
cSql = "select * from u_ord_tt where " + x_cond + " order by ord_codsoc,taggancio"
IF !ExecCommand(cSql,"CUR_TESTATA")
   RETURN .F.
ENDIF 
SELECT CUR_TESTATA
GO TOP
IF !EOF()
   XXX_NUMORD = ORD_NUMORD
   XXX_ACCONT = ORD_ACCONT
   XXX_DATRIM = ORD_DATRIM
   XXX_CODCLI = ORD_CODCLI   
   XXX_RAGSOC = ORD_RAGSOC
   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + XXX_CODCLI + "'"
   x_cond = x_soci + " and " + x_codi
   cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"CUR_CLIENTI")
      RETURN .F.
   ENDIF
   SELECT CUR_CLIENTI
   GO TOP
   IF !EOF()
      XXX_TELEFO = CLI_TELEFO
      XXX_LOCALI = CLI_LOCALI
      XXX_INDIRI = CLI_INDIR
   ENDIF
ENDIF

IF !EOF()
   IF PUB_ARRIVO = 'ECASH'
      _Z_REPORT  = "REPORT\RIMSTA"
      REPORT FORM &_Z_REPORT NOEJECT NOCONSOLE TO PRINTER PROMPT
   ELSE     
      DO PRG\MENUSTA WITH "CU_ORD_DD",.T.,.T.,"XXX","RIMSTA","RIMSTA.FRX"
   ENDIF
ELSE
   =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
ENDIF

RETURN