*************************************************************
* PROGRAMMA DI ESTRAZIONE DATI PER STAMPA MODULO DI ACCONTO *
*************************************************************

RELEASE XXX_ACCONT,XXX_NUMSCO,XXX_CODCLI,XXX_RAGSOC,XXX_TELEFO,XXX_EMAIL,XXX_CODART,XXX_DESART,XXX_QTAORD,XXX_PRZNET,XXX_AUTORE,XXX_EDITOR,XXX_CODIVA
PUBLIC  XXX_ACCONT,XXX_NUMSCO,XXX_CODCLI,XXX_RAGSOC,XXX_TELEFO,XXX_EMAIL,XXX_CODART,XXX_DESART,XXX_QTAORD,XXX_PRZNET,XXX_AUTORE,XXX_EDITOR,XXX_CODIVA
XXX_ACCONT = 0
XXX_NUMSCO = ""
XXX_CODCLI = ""
XXX_RAGSOC = ""
XXX_TELEFO = ""
XXX_EMAIL  = ""
XXX_CODART = ""
XXX_DESART = ""
XXX_QTAORD = 0
XXX_PRZNET = 0
XXX_AUTORE = ""
XXX_EDITOR = ""
XXX_CODIVA = ""

* CREO CURSORE PER RACCOLTA DATI
CREATE CURSOR CUR_STAMPA ;
  (STM_CODART C(30), STM_DESART C(40), STM_AUTORE C(50), ;
   STM_EDITOR C(50), STM_QTAORD N(10,2), STM_PRZNET N(17,6), STM_CODIVA C(03))
   
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
   XXX_DATACC = ORD_DATACC
   XXX_NUMSCO = ORD_NUMSCO
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
      XXX_EMAIL  = CLI_EMAIL
   ENDIF
ENDIF

SELECT CU_ORD_DD
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
      
   XXX_CODART = M.ORD_CODART
   XXX_DESART = M.ORD_DESART
   XXX_QTAORD = M.ORD_QTAORD
   XXX_PRZNET = M.ORD_PRZNET
   XXX_CODIVA = M.ORD_IVA
   x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "art_codpri = '" + XXX_CODART + "'"
   x_cond = x_soci + " and " + x_codi
   cSql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
   IF !ExecCommand(cSql,"CUR_ARTICOLI")
      RETURN .F.
   ENDIF
   SELECT CUR_ARTICOLI
   GO TOP
   IF !EOF()
      XXX_AUTORE = ART_AUTORE
      XXX_EDITOR = ART_EDITOR
   ENDIF
      
   SELECT CUR_STAMPA
   APPEND BLANK
   REPLACE STM_CODART WITH XXX_CODART
   REPLACE STM_DESART WITH XXX_DESART   
   REPLACE STM_QTAORD WITH XXX_QTAORD
   REPLACE STM_PRZNET WITH XXX_PRZNET
   REPLACE STM_AUTORE WITH XXX_AUTORE   
   REPLACE STM_EDITOR WITH XXX_EDITOR
   REPLACE STM_CODIVA WITH XXX_CODIVA
   
   SELECT CU_ORD_DD
   SKIP +1

ENDDO

SELECT CUR_STAMPA
GO TOP

IF !EOF()
   IF PUB_ARRIVO = 'ECASH'
      _Z_REPORT  = "REPORT\ACCSTA"
      REPORT FORM &_Z_REPORT NOEJECT NOCONSOLE TO PRINTER PROMPT
   ELSE     
      DO PRG\MENUSTA WITH "CUR_STAMPA",.T.,.T.,"XXX","ACCSTA","ACCSTA.FRX"
   ENDIF
ELSE
   =MESSAGEBOX("Nessun dato da stampare",64,"*** INFORMAZIONE ***")
ENDIF

RETURN