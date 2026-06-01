
******************************************************************************************************************
******************************************************************************************************************
*** LIBRERIA PER FUNZIONI GENERICHE LEGATE ALLE GIACENZE DI MAGAZZINO E AI PROGRAMMI DI PRODUZIONE DEA TAPPETO ***
******************************************************************************************************************
******************************************************************************************************************

*****************************************
PROCEDURE PRD_STAMPA_ROTOLI_GIA_EVADIBILI
*****************************************

PARAMETERS _WW_PJ_PRGPRD1

IF PARAMETERS() < 1
   MESSAGEBOX("Parametri insufficienti per la procedura",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione in corso  -  Prego attendere..." NOWAIT

x_cprg = IIF(EMPTY(ALLTRIM(_WW_PJ_PRGPRD1)),"pj_prgprd1 = pj_prgprd1","pj_prgprd1 = '" + ALLTRIM(_WW_PJ_PRGPRD1) + "'" )
x_cond = x_cprg
Csql = "select * FROM U_PRD_D1 where " + x_cond
IF !ExecCommand(cSql,'STA_PRD_D1')
   return(.f.)
ENDIF
SELECT STA_PRD_D1
GO TOP
IF EOF()
   WAIT CLEAR
   MESSAGEBOX("Programma di produzione non trovato",16,"Attenzione")
   RETURN .F.
ELSE
   _XX_NUMPRG = ALLTRIM(PR1_NUMPRG)
ENDIF

x_cprg = IIF(EMPTY(ALLTRIM(_WW_PJ_PRGPRD1)),"pj_prgprd1 = pj_prgprd1","pj_prgprd1 = '" + ALLTRIM(_WW_PJ_PRGPRD1) + "'" )
x_cint = "pr5_codint <> ''"
x_fddt = "pr5_flgddt = 0"
x_inmg = "pr5_inmaga = 1"
x_cond = x_cprg + " and " + x_cint + " and " + x_fddt + " and " + x_inmg 
Csql = "select PR5_CODCLI,PR5_RAGSOC,PR5_NUMORD,PR5_DATORD,PR5_CODART,PR5_ALTEZZ,PR5_LUNGHE,PR5_ALTTAG,PR5_LUNTAG," + ;
       "COUNT(*) AS ST5_NUMROT,0 AS ST5_ROTORD,0 AS ST5_ROTEVA,PR5_INMAGA," + ;
       "ST5_INMAGA = (CASE PR5_INMAGA WHEN 1 THEN 'SI' ELSE 'NO' END) FROM U_PRD_D5 where " + x_cond + ;
       " group by PR5_CODCLI,PR5_RAGSOC,PR5_NUMORD,PR5_DATORD,PR5_CODART,PR5_ALTEZZ,PR5_LUNGHE,PR5_ALTTAG,PR5_LUNTAG,PR5_INMAGA"
IF !ExecCommand(cSql,'STA_PRD_D5')
   return(.f.)
ENDIF
SELECT STA_PRD_D5
GO TOP
IF EOF()
   WAIT CLEAR
   MESSAGEBOX("Nessun rotolo pronto in magazzino da stampare",64,"Informazione")
   SELECT STA_PRD_D5
   USE
   RETURN .F.
ENDIF

*** DETERMINAZIONE NUMERO ROTOLI ORDINATI ED EVASI
SELECT STA_PRD_D5
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
*!*	   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
*!*	   x_arti = "mag_codart = '" + ALLTRIM(M.PR4_CODINT) + "'" 
*!*	   x_maga = "mag_codmag = mag_codmag"
*!*	   x_data = "mag_datagg <> SPACE(10)"
*!*	   x_giac = "mag_giacen <> 0"
*!*	   x_cond = x_soci + " and " + x_arti + " and " + x_maga + " and " + x_data + " and " + x_giac 
*!*	   cSql = "select * FROM u_mag_gg where " + x_cond
*!*	   IF !ExecCommand(cSql,'CHK_MAG_GG')
*!*	      return(.f.)
*!*	   ENDIF
*!*	   SELECT CHK_MAG_GG
*!*	   GO TOP
*!*	   IF EOF()
*!*	      SELECT STA_PRD_D5
*!*	      DELETE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
   
   x_cprg = IIF(EMPTY(ALLTRIM(_WW_PJ_PRGPRD1)),"pj_prgprd1 = pj_prgprd1","pj_prgprd1 = '" + ALLTRIM(_WW_PJ_PRGPRD1) + "'" )
   x_clie = "pr5_codcli = '" + ALLTRIM(PR5_CODCLI) + "'"
   x_nord = "pr5_numord = '" + ALLTRIM(PR5_NUMORD) + "'"
   x_dord = "pr5_datord = '" + ALLTRIM(PR5_DATORD) + "'"
   x_arti = "pr5_codart = '" + ALLTRIM(PR5_CODART) + "'"
   x_alte = "pr5_altezz = " + STR(PR5_ALTEZZ,5,0)
   x_lung = "pr5_lunghe = " + STR(PR5_LUNGHE,6,0)
   x_cond = x_cprg + " and " + x_clie + " and " + x_nord + " and " + x_dord + " and " + x_arti + " and " + x_alte + " and " + x_lung
   Csql = "select COUNT(*) AS NUMERO_ROTOLI FROM U_PRD_D5 where " + x_cond
   IF !ExecCommand(cSql,'CHK_PRD_D5')
      return(.f.)
   ENDIF
   SELECT CHK_PRD_D5
   GO TOP
   __NUMROT = NUMERO_ROTOLI   
   SELECT STA_PRD_D5
   REPLACE ST5_ROTORD WITH __NUMROT 
   
   x_cprg = IIF(EMPTY(ALLTRIM(_WW_PJ_PRGPRD1)),"pj_prgprd1 = pj_prgprd1","pj_prgprd1 = '" + ALLTRIM(_WW_PJ_PRGPRD1) + "'" )
   x_clie = "pr5_codcli = '" + ALLTRIM(PR5_CODCLI) + "'"
   x_nord = "pr5_numord = '" + ALLTRIM(PR5_NUMORD) + "'"
   x_dord = "pr5_datord = '" + ALLTRIM(PR5_DATORD) + "'"
   x_arti = "pr5_codart = '" + ALLTRIM(PR5_CODART) + "'"
   x_alte = "pr5_altezz = " + STR(PR5_ALTEZZ,5,0)
   x_lung = "pr5_lunghe = " + STR(PR5_LUNGHE,6,0)
   x_fddt = "pr5_flgddt = 1"
   x_cond = x_cprg + " and " + x_clie + " and " + x_nord + " and " + x_dord + " and " + x_arti + " and " + x_alte + " and " + x_lung + " and " + x_fddt
   Csql = "select COUNT(*) AS NUMERO_ROTOLI FROM U_PRD_D5 where " + x_cond
   IF !ExecCommand(cSql,'CHK_PRD_D5')
      return(.f.)
   ENDIF
   SELECT CHK_PRD_D5
   GO TOP
   __NUMROT = NUMERO_ROTOLI   
   SELECT STA_PRD_D5
   REPLACE ST5_ROTEVA WITH __NUMROT 
   
   SELECT STA_PRD_D5
   SKIP +1
ENDDO

WAIT CLEAR

SELECT STA_PRD_D5
INDEX ON PR5_CODCLI+PR5_NUMORD+PR5_DATORD+PR5_CODART+STR(PR5_ALTTAG)+STR(PR5_LUNTAG)+ST5_INMAGA TAG I_STAMPA ADDITIVE
SET ORDER TO I_STAMPA
GO TOP
DO PRG\MENUSTA WITH "STA_PRD_D5",.T.,.F.,"XXX","ROTOLI_EVADIBILI","ROTOLI_EVADIBILI.FRX",.F.,"Stampa rotoli evadibili"

SELECT STA_PRD_D1
USE

SELECT STA_PRD_D5
USE

*!*	SELECT CHK_MAG_GG
*!*	USE

SELECT CHK_PRD_D5
USE

RETURN


******************************************
PROCEDURE PRD_STAMPA_BARRE_GIA_DISPONIBILI
******************************************

PARAMETERS _WW_PJ_PRGPRD1

IF PARAMETERS() < 1
   MESSAGEBOX("Parametri insufficienti per la procedura",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione in corso  -  Prego attendere..." NOWAIT

x_cprg = IIF(EMPTY(ALLTRIM(_WW_PJ_PRGPRD1)),"pj_prgprd1 = pj_prgprd1","pj_prgprd1 = '" + ALLTRIM(_WW_PJ_PRGPRD1) + "'" )
x_cond = x_cprg
Csql = "select * FROM U_PRD_D1 where " + x_cond
IF !ExecCommand(cSql,'STA_PRD_D1')
   return(.f.)
ENDIF
SELECT STA_PRD_D1
GO TOP
IF EOF()
   WAIT CLEAR
   MESSAGEBOX("Programma di produzione non trovato",16,"Attenzione")
   RETURN .F.
ELSE
   _XX_NUMPRG = ALLTRIM(PR1_NUMPRG)
ENDIF


x_cprg = IIF(EMPTY(ALLTRIM(_WW_PJ_PRGPRD1)),"pj_prgprd1 = pj_prgprd1","pj_prgprd1 = '" + ALLTRIM(_WW_PJ_PRGPRD1) + "'" )
x_cint = "pr4_codint <> ''"
x_inmg = "pr4_inmaga = 1"
x_cond = x_cprg + " and " + x_cint + " and " + x_inmg 
Csql = "select CAST('' AS TEXT) AS PR4_CLIENT,* FROM U_PRD_D4 where " + x_cond
IF !ExecCommand(cSql,'STA_PRD_D4')
   return(.f.)
ENDIF
SELECT STA_PRD_D4
GO TOP
IF EOF()
   WAIT CLEAR
   MESSAGEBOX("Nessuna barra disponibile in magazzino",64,"Informazione")
   SELECT STA_PRD_D4
   USE
   RETURN .F.
ENDIF

*** VERIFICA ESISTENZA IN MAGAZZINO E RICERCA CLIENTI
SELECT STA_PRD_D4
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_arti = "mag_codart = '" + ALLTRIM(PR4_CODINT) + "'" 
   x_maga = "mag_codmag = mag_codmag"
   x_data = "mag_datagg <> SPACE(10)"
   x_giac = "mag_giacen <> 0"
   x_cond = x_soci + " and " + x_arti + " and " + x_maga + " and " + x_data + " and " + x_giac 
   cSql = "select * FROM u_mag_gg where " + x_cond
   IF !ExecCommand(cSql,'CHK_MAG_GG')
      return(.f.)
   ENDIF
   SELECT CHK_MAG_GG
   GO TOP
   IF EOF()
      SELECT STA_PRD_D4
      DELETE
      SKIP +1
      LOOP
   ENDIF
   
   *** RICERCA CLIENTI
   _PR4_CLIENT = ""
   CREATE CURSOR CURS_CLIENTI (CLI_CODCLI C(10),  CLI_RAGSOC C(80))
   INDEX ON CLI_CODCLI TAG I_CLIENT
   SELECT STA_PRD_D4
   x_pj_1 = "pj_prgprd1 = '" + ALLTRIM(PJ_PRGPRD1) + "'"
   x_pj_2 = "pj_prgprd2 = '" + ALLTRIM(PJ_PRGPRD2) + "'"
   x_pj_3 = "pj_prgprd3 = '" + ALLTRIM(PJ_PRGPRD3) + "'"
   x_pj_4 = "pj_prgprd4 = '" + ALLTRIM(PJ_PRGPRD4) + "'"
   x_cond = x_pj_1 + " and " + x_pj_2 + " and " + x_pj_3 + " and " + x_pj_4
   cSql   = "SELECT PR5_CODCLI,PR5_RAGSOC FROM U_PRD_D5 WHERE " + x_cond + " order by PR5_PROGRE"
   IF !ExecCommand(cSql,"CX_PRD_D5")
      return(.f.)
   ENDIF
   SELECT CX_PRD_D5
   GO TOP
   SCAN
      _XX_CODCLI = PR5_CODCLI
      _XX_RAGSOC = PR5_RAGSOC
      SELECT CURS_CLIENTI 
      SET ORDER TO I_CLIENT
      GO TOP
      _SEEK = _XX_CODCLI 
      SEEK _SEEK
      IF FOUND()
      ELSE
         APPEND BLANK
         REPLACE CLI_CODCLI WITH _XX_CODCLI 
         REPLACE CLI_RAGSOC WITH _XX_RAGSOC
      ENDIF
   ENDSCAN
   SELECT CURS_CLIENTI 
   GO TOP
   SCAN
      IF EMPTY(ALLTRIM(_PR4_CLIENT))
         _PR4_CLIENT = ALLTRIM(CLI_CODCLI) + " - " + ALLTRIM(CLI_RAGSOC)
      ELSE
         _PR4_CLIENT = _PR4_CLIENT + CHR(13) + ALLTRIM(CLI_CODCLI) + " - " + ALLTRIM(CLI_RAGSOC)
      ENDIF
   ENDSCAN
   SELECT STA_PRD_D4
   REPLACE PR4_CLIENT WITH _PR4_CLIENT
   
   SELECT STA_PRD_D4
   SKIP +1
ENDDO

WAIT CLEAR

SELECT STA_PRD_D4
INDEX ON PR4_PROGRE+PR4_CODART+STR(PR4_ALTCAR)+STR(PR4_LUNCAR) TAG I_STAMPA ADDITIVE
SET ORDER TO I_STAMPA
GO TOP
DO PRG\MENUSTA WITH "STA_PRD_D4",.T.,.F.,"XXX","BARRE_DISPONIBILI","BARRE_DISPONIBILI.FRX",.F.,"Stampa barre disponibili"

IF USED("STA_PRD_D1")
	SELECT STA_PRD_D1
	USE
ENDIF

IF USED("STA_PRD_D4")
	SELECT STA_PRD_D4
	USE
ENDIF

IF USED("CHK_MAG_GG")
	SELECT CHK_MAG_GG
	USE
ENDIF

IF USED("CURS_CLIENTI")
	SELECT CURS_CLIENTI 
	USE
ENDIF

RETURN




*********************************************
PROCEDURE PRD_STAMPA_BOBINE_GIA_DISPONIBILI
*********************************************

PARAMETERS _WW_PJ_PRGPRD1

IF PARAMETERS() < 1
   MESSAGEBOX("Parametri insufficienti per la procedura",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Elaborazione in corso  -  Prego attendere..." NOWAIT

x_cprg = IIF(EMPTY(ALLTRIM(_WW_PJ_PRGPRD1)),"pj_prgprd1 = pj_prgprd1","pj_prgprd1 = '" + ALLTRIM(_WW_PJ_PRGPRD1) + "'" )
x_cond = x_cprg
Csql = "select * FROM U_PRD_D1 where " + x_cond
IF !ExecCommand(cSql,'STA_PRD_D1')
   return(.f.)
ENDIF
SELECT STA_PRD_D1
GO TOP
IF EOF()
   WAIT CLEAR
   MESSAGEBOX("Programma di produzione non trovato",16,"Attenzione")
   RETURN .F.
ELSE
   _XX_NUMPRG = ALLTRIM(PR1_NUMPRG)
ENDIF


x_cprg = IIF(EMPTY(ALLTRIM(_WW_PJ_PRGPRD1)),"pj_prgprd1 = pj_prgprd1","pj_prgprd1 = '" + ALLTRIM(_WW_PJ_PRGPRD1) + "'" )
x_cint = "pr3_codint <> ''"
x_inmg = "pr3_inmaga = 1"
x_cond = x_cprg + " and " + x_cint + " and " + x_inmg 
Csql = "select * FROM U_PRD_D3 where " + x_cond
IF !ExecCommand(cSql,'STA_PRD_D3')
   return(.f.)
ENDIF
SELECT STA_PRD_D3
GO TOP
IF EOF()
   WAIT CLEAR
   MESSAGEBOX("Nessuna bobina disponibile in magazzino",64,"Informazione")
   SELECT STA_PRD_D3
   USE
   RETURN .F.
ENDIF

*** VERIFICA ESISTENZA IN MAGAZZINO E RICERCA CLIENTI
SELECT STA_PRD_D3
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
   x_arti = "mag_codart = '" + ALLTRIM(PR3_CODINT) + "'" 
   x_maga = "mag_codmag = mag_codmag"
   x_data = "mag_datagg <> SPACE(10)"
   x_giac = "mag_giacen <> 0"
   x_cond = x_soci + " and " + x_arti + " and " + x_maga + " and " + x_data + " and " + x_giac 
   cSql = "select * FROM u_mag_gg where " + x_cond
   IF !ExecCommand(cSql,'CHK_MAG_GG')
      return(.f.)
   ENDIF
   SELECT CHK_MAG_GG
   GO TOP
   IF EOF()
      SELECT STA_PRD_D3
      DELETE
      SKIP +1
      LOOP
   ENDIF
   
   SELECT STA_PRD_D3
   SKIP +1
ENDDO

WAIT CLEAR

SELECT STA_PRD_D3
INDEX ON PR3_PROGRE+PR3_CODBOB TAG I_STAMPA ADDITIVE
SET ORDER TO I_STAMPA
GO TOP
DO PRG\MENUSTA WITH "STA_PRD_D3",.T.,.F.,"XXX","BOBINE_DISPONIBILI","BOBINE_DISPONIBILI.FRX",.F.,"Stampa bobine disponibili"

IF USED("STA_PRD_D1")
	SELECT STA_PRD_D1
	USE
ENDIF

IF USED("STA_PRD_D3")
	SELECT STA_PRD_D3
	USE
ENDIF

IF USED("CHK_MAG_GG")
	SELECT CHK_MAG_GG
	USE
ENDIF

RETURN
