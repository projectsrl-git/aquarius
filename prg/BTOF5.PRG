*************************************************************************************
*    INIZIO PROGRAMMA CREAZIONE PRE-FATTURE DA BOLLE : TIPO DI FATTURAZIONE         *
*************************************************************************************
RIT = MESSAGEBOX("Procedo con la creazione "+CHR(13)+"delle pre-fatture",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

PUBLIC YES,CONTA_FAT,OK_PRELEVA,X_NUMORD,XXX_NUMORD
YES        = 0
CONTA_FAT  = 0
XXX_NUMORD = ""

PUBLIC IVA_ESE,IVA_CLI,V_CLIES,V_DTCLES,V_NSES,V_DTNSES

DEFINE WINDOW WSELESOC;
AT 0,0 SIZE 15,80;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW WSELESOC CENTER

IF !ExecCommand("select * from u_prf_tt where 0=1","cu_prf_tt")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_prf_dd where 0=1","cu_prf_dd")
   return(.f.)
ENDIF

IF !ExecCommand("select * from u_bol_tt where 0=1","u_bol_tt")
   return(.f.)
ENDIF
SELECT U_BOL_TT
HH=AFIELDS(TRAN_BOL)

CREATE CURSOR CBOL_RR FROM ARRAY TRAN_BOL
SELECT  CBOL_RR
INDEX ON ORD_CODEMI + RIBALTA2(ORD_INTRAS) + ORD_DESTIN + ORD_VETTO1 TAG T_RIEP ADDITIVE
INDEX ON ORD_SYSCOD													 TAG T_SYSRIEP ADDITIVE

CREATE CURSOR CBOL_TT FROM ARRAY TRAN_BOL
SELECT  CBOL_TT
INDEX ON ORD_CODEMI+ORD_SYSCOD			 TAG T_NUMERIC ADDITIVE
INDEX ON ORD_SYSCOD						 TAG T_SYSCOD  ADDITIVE
INDEX ON ORD_CODEMI+STR(VAL(ord_numord)) TAG T_NUMORD  ADDITIVE

=_ELABOL("DATY",DATADAL,DATAAL,PUB_ANNO,SPACE(06),"  ",CLIDAL,SPACE(03))

******* PER GESTIRE I LEGAMI TRA I DOCUMENTI
CREATE CURSOR BOLLE_CUR (CUR_NUMORD C(06), CUR_DATORD C(10), CUR_CODCLI C(10), CUR_RAGSOC C(10))
INDEX ON CUR_NUMORD + CUR_DATORD TAG I_BOLLE ADDITIVE  
******* CRI ***   FINE 17/09 **** PER GESTIRE I LEGAMI TRA I DOCUMENTI

SELECT  CBOL_TT
SET ORDER TO T_NUMORD
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

   SELECT CBOL_RR
   SET ORDER TO T_RIEP
   SEEK M.ORD_CODEMI + RIBALTA2(M.ORD_INTRAS) + M.ORD_DESTIN + M.ORD_VETTO1

   IF FOUND()
      IF M.ORD_MAGS = PUB_CODM
         V_NOTE = ALLTRIM(ORD_NOTE) + CHR(13) + "D.d.T. " + "FPS" + " N. "+ALLTRIM(M.ORD_NUMORD)+" Del "+M.ORD_DATORD
      ELSE
         V_NOTE = ALLTRIM(ORD_NOTE) + CHR(13) + "D.d.T. " + ALLTRIM(M.ORD_MAGS) + " N. "+ALLTRIM(M.ORD_NUMORD)+" Del "+M.ORD_DATORD
      ENDIF
      REPLACE ORD_NOTE WITH V_NOTE
      IF M.ORD_DESFAT = SPACE(60) .OR. EMPTY(M.ORD_DESFAT)
         IF ORD_DESFAT = SPACE(60) .OR. EMPTY(ORD_DESFAT)
            REPLACE ORD_DESFAT WITH ALLTRIM(M.ORD_DESTIN)
         ENDIF
      ELSE
         IF ORD_DESFAT = SPACE(60) .OR. EMPTY(ORD_DESFAT)
            REPLACE ORD_DESFAT WITH ALLTRIM(M.ORD_DESFAT)
         ENDIF
      ENDIF
      IF M.ORD_VALDAF = 0
      ELSE
         IF ORD_VALDAF = 0
            REPLACE ORD_VALDAF WITH M.ORD_VALDAF
         ENDIF
      ENDIF
      M.ORD_SYSCOD = ORD_SYSCOD
   ELSE
      M.ORD_SYSCOD = SYS(2015)
      APPEND BLANK
      GATHER MEMVAR MEMO
      IF M.ORD_MAGS = PUB_CODM
         V_NOTE ="D.d.T. " + "FPS" + " N. "+ALLTRIM(M.ORD_NUMORD)+" Del "+M.ORD_DATORD
      ELSE
         V_NOTE ="D.d.T. " + ALLTRIM(M.ORD_MAGS) + " N. "+ALLTRIM(M.ORD_NUMORD)+" Del "+M.ORD_DATORD
      ENDIF
      REPLACE ORD_NOTE WITH V_NOTE
      IF M.ORD_DESFAT = SPACE(60) .OR. EMPTY(M.ORD_DESFAT)
         REPLACE ORD_DESFAT WITH ALLTRIM(M.ORD_DESTIN)
      ENDIF
   ENDIF

   SELECT CBOL_TT
   REPLACE ORD_SYSCOD WITH M.ORD_SYSCOD

   SKIP +1

ENDDO

SELECT  CBOL_RR
SET ORDER TO T_RIEP
GO TOP

_SELEFAT = .T.
_SOLOEXP = .F.
_SELEFAT = .T.

IF _SELEFAT

   DEFINE WINDOW WSELESOC;
   AT 0,0 SIZE 30,100;
   SYSTEM CLOSE NOGROW FLOAT;
   FONT 'Courier New',8
   MOVE WINDOW WSELESOC CENTER

   SELECT  CBOL_RR
   SET ORDER TO T_RIEP
   GO TOP

   IF PUB_VALRIF = "LIT" .OR. PUB_VALRIF = "ITL"
	  BROWSE FIELDS ORD_INTRAS:15:H='Data trasporto':R,       ;
  	                ORD_DESTIN:30:H='Destinazione':R,         ;
	                ORD_VETTO1:10:H='Vettore':R,              ;
	                ORD_NOTE:20:H='Riferimenti DDT':R,        ;
	                ORD_DESFAT:60:H='Descrizione in fattura', ;
	                ORD_VALDAF:20:H='Valore da fatturare':P='9,999,999,999',    ;
	                ORD_CODEMI:15:H='Codice cliente':R,       ;
	                ORD_RAGEMI:35:H='Ragione sociale':R NOMENU  NODELETE WINDOW WSELESOC
   ELSE
	  BROWSE FIELDS ORD_INTRAS:15:H='Data trasporto':R,       ;
  	                ORD_DESTIN:30:H='Destinazione':R,         ;
	                ORD_VETTO1:10:H='Vettore':R,              ;
	                ORD_NOTE:20:H='Riferimenti DDT':R,        ;
	                ORD_DESFAT:60:H='Descrizione in fattura', ;
	                ORD_VALDAF:20:H='Valore da fatturare':P='99,999,999.99',    ;
	                ORD_CODEMI:15:H='Codice cliente':R,       ;
	                ORD_RAGEMI:35:H='Ragione sociale':R NOMENU  NODELETE WINDOW WSELESOC
   ENDIF

   RELEASE WINDOWS WSELESOC
   PUSH KEY CLEAR

ENDIF

OK_PRELEVA  = .T.
M.T_IMPONIB = 0
M.T_IMPOSTA = 0
MATPUBX     = 0
V_SPESE     = 0
SOLO_ORA	= .T.

SELECT  CBOL_RR
SET ORDER TO T_RIEP
GO TOP

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ORD_VALDAF > 0
   ELSE
 	  SELECT  CBOL_RR
	  SKIP +1
	  LOOP
   ENDIF

   IF SOLO_ORA
      CLINEW = ORD_CODEMI
      SOLO_ORA = .F.
   ENDIF

   * SE ROTTURA CLIENTE CREO LA TESTATA FATTURE SU SCATTER MEMVAR VECCHIA

   KATT = ORD_CODEMI
   KPRE = CLINEW

   IF KATT <> KPRE
      DO NFATTU

      ******* PER GESTIRE I LEGAMI TRA I DOCUMENTI
      RELEASE _TABLE,_CAUS,_DOCRE,_CLOSE,_ORDCR
      PUBLIC  _TABLE,_CAUS,_DOCRE,_CLOSE,_ORDCR
      _TABLE = "CBOL_TT"
      _CAUS  = "BOLL"
      _DOCRE = "PRFA"
      _CLOSE = .F.
      _ORDCR = M.ORD_NUMORD
      SELECT BOLLE_CUR
      GO TOP
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF
         RIS_FUN=LEGDFUNZ(_TABLE,_CAUS,SUBSTR(CUR_DATORD,7,4),CUR_CODCLI,CUR_RAGSOC,CUR_NUMORD, ;
                          CUR_DATORD,_DOCRE,_ORDCR,DATAREGI,_CLOSE)
         SELECT BOLLE_CUR
         SKIP +1
      ENDDO
      CREATE CURSOR BOLLE_CUR (CUR_NUMORD C(06), CUR_DATORD C(10), CUR_CODCLI C(10), CUR_RAGSOC C(10))
      INDEX ON CUR_NUMORD + CUR_DATORD TAG I_BOLLE ADDITIVE  
      ******* CRI ***   FINE 17/09 **** PER GESTIRE I LEGAMI TRA I DOCUMENTI

      X_SPINC = 0

      =CREA_SPIN("FAT","CU_PRF_DD",M.ORD_VALUTA,M.ORD_CPA)  && CREA ARTICOLO CON SPESE D'INCASSO

      SELECT CU_PRF_TT
      REPLACE ORD_VALORE	WITH ORD_VALORE + X_SPINC && AGGIUNGE SPESE INCASSO
  
      DO ESENOTB         && GESTIONE ESENZIONI
  
      SELECT CBOL_RR
  
      CLINEW = ORD_CODEMI
   ENDIF

   V_DESFAT = ORD_DESFAT
   V_VALDAF = ORD_VALDAF
   V_NOTE   = ORD_NOTE
   V_DESTIN = ORD_DESTIN
   V_SYSCOD = ORD_SYSCOD

   SELECT CBOL_TT
   SET ORDER TO T_SYSCOD
   SEEK V_SYSCOD

   IF FOUND()

      SCATTER MEMVAR MEMO

      x_cond = "art_codpri = '" + PUB_CADEF + "'"
      cSql = "select * from u_art_pr where " + x_cond + " order by art_codpri"
      IF !ExecCommand(cSql,"CUR_ARTICOLI")
         RETURN .F.
      ENDIF
      SELECT CUR_ARTICOLI
      GO TOP
      IF EOF()
         M.ORD_DESART = 'TRASPORTI'
         IVA_CLI      = '20'
      ELSE
         M.ORD_DESART = ART_DESCR
         IVA_CLI      = ART_CODIVA
      ENDIF

      IF OK_PRELEVA
         M.TAGGANCIO = STR(NEWPROG('NUMPRF'),10)
         X_UNCINO    =  M.TAGGANCIO
         OK_PRELEVA  = .F.
      ENDIF

      * PRELEVA IL N.DI PRE-FATTURA DA ASSEGNARE ALLE RIGHE
      v_seek	= 'NUMPRF' + PUB_CODSOC
      v_chiave  = "codice"
      IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
         SELECT CUR_PARA
         V2=VAL(SUBSTR(LIBERA,1,7)) + 1
         X_NUMORD = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
      ELSE
         RIT = MSGBOX('Parametro numero pre-fattura non trovato','ATTENZIONE',31)
         RETURN
      ENDIF

      M.DAGGANCIO   = X_UNCINO
      m.ord_codart  = PUB_CADEF
      M.ORD_MAGA	= M.ORD_MAGS
      M.ORD_DES2	= SPACE(25)
      M.ORD_UM		= 'NR'
      M.ORD_IVA		= IVA_CLI
      M.ORD_PREZZO	= V_VALDAF
      M.ORD_QTAORD  = 1
      M.ORD_PRZNET  = V_VALDAF
      M.ORD_VALORE  = V_VALDAF
      M.ORD_SC1     = 0
      M.ORD_SC2     = 0
      M.ORD_SC3     = 0	
      M.ORD_NOTE    = ""
      M.ORD_PUBBLI 	= " "
      M.ORD_CODICE  = SPACE(10)
      M.ORD_VALCO   = 0

      SELECT CU_PRF_DD
      APPEND BLANK
      GATHER MEMVAR MEMO

      REPLACE ORS_NUMDDT WITH SPACE(06)
      REPLACE ORS_DATDDT WITH SPACE(10)
      REPLACE ORS_NUMORD WITH X_NUMORD
      REPLACE ORS_DATORD WITH DATAREGI
      REPLACE ORS_CODCLI WITH M.ORD_CODEMI
      REPLACE ORS_RAGSOC WITH M.ORD_RAGEMI
      REPLACE ORS_CODEMI WITH M.ORD_CODEMI
      REPLACE ORS_RAGEMI WITH M.ORD_RAGEMI
      REPLACE ORS_DESTIN WITH V_DESTIN
      REPLACE ORS_VETTO1 WITH M.ORD_VETTO1
      REPLACE ORS_VETTO2 WITH M.ORD_VETTO2
      REPLACE ORS_VETTO3 WITH M.ORD_VETTO3

      CIVA = ORD_IVA
      v_seek	= 'IVA' + CIVA
      v_chiave = "codice"
      IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
         SELECT CUR_PARA
         VIVA = VAL(SUBSTR(LIBERA,1,3))
      ELSE
   	     VIVA = 0
      ENDIF

      SELECT CU_PRF_DD
      M.T_IMPONIB = M.T_IMPONIB + ORD_VALORE
      M.T_IMPOSTA = M.T_IMPOSTA + (ORD_VALORE * (VIVA/100))

      M.DAGGANCIO   = X_UNCINO
      M.ORD_CODART  = SPACE(16)
      M.ORD_MAGA	= SPACE(06)
      M.ORD_DESART	= "*** COMMENTO ***"
      M.ORD_DES2	= SPACE(25)
      M.ORD_UM		= SPACE(02)
      M.ORD_IVA		= SPACE(02)
      M.ORD_PREZZO	= 0
      M.ORD_QTAORD  = 0
      M.ORD_PRZNET  = 0
      M.ORD_VALORE  = 0
      M.ORD_SC1     = 0
      M.ORD_SC2     = 0
      M.ORD_SC3     = 0	
      M.ORD_PUBBLI  = " "
      M.ORD_CODICE  = SPACE(10)
      M.ORD_VALCO   = 0
      M.ORS_MAGS    = SPACE(06)
      M.ORS_CODCLI 	= SPACE(10)
      M.ORS_RAGSOC 	= SPACE(40)
      M.ORS_NUMORD 	= SPACE(06)
      M.ORS_DATORD 	= SPACE(10)
      M.ORS_CODEMI 	= SPACE(10)
      M.ORS_RAGEMI 	= SPACE(10)
      M.ORS_TIPORD 	= SPACE(03)
      M.ORS_SALCON 	= SPACE(01)
      M.SELEZIONE  	= SPACE(10)
      M.ORS_NUMORC 	= SPACE(06)
      M.ORS_DATORC 	= SPACE(10)
      M.ORS_DESTIN 	= SPACE(30)
      M.ORD_QTCONF 	= 0
      M.ORD_QTXCON 	= 0
      M.ORS_NUMDDT 	= SPACE(06)
      M.ORS_DATDDT 	= SPACE(10)
      M.ORD_NOTE    = ALLTRIM(V_DESFAT) + CHR(13) + V_NOTE

      SELECT CU_PRF_DD
      APPEND BLANK
      GATHER MEMVAR MEMO

      YES = 1

      V_PRIMA  = .T.
      NOTE_ORD = ""

      SELECT CBOL_TT

      DO WHILE .T.

         IF EOF()
            EXIT
         ENDIF

         IF DELETED()
            SKIP +1
            LOOP
         ENDIF

         IF ORD_SYSCOD = V_SYSCOD
         ELSE
            EXIT
         ENDIF

         UNCINO = TAGGANCIO
         x_cond = "daggancio = '" + ALLTRIM(UNCINO) + "'"
         Csql   = "select * from u_bol_dd where " + x_cond + " order by daggancio"
         IF !ExecCommand(cSql,"CU_BOL_DD")
            return(.f.)
         ENDIF
         SELECT CU_BOL_DD
         GO TOP
         IF !EOF()
            DO WHILE .T.
               IF EOF()
                  EXIT
               ENDIF
               IF DELETED()
                  SKIP +1
                  LOOP
               ENDIF
               IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
               ELSE
                  SKIP +1
                  LOOP
               ENDIF
               IF V_PRIMA
                  NOTE_ORD = ALLTRIM(ORD_NOTE)
                  V_PRIMA  = .F.
               ELSE
                  NOTE_ORD = ALLTRIM(NOTE_ORD) + CHR(13) + ALLTRIM(ORD_NOTE)
               ENDIF

               SELECT CU_BOL_DD
               SKIP +1
            ENDDO
         ENDIF

         SELECT CBOL_TT

         M.ORD_CODSYS = ORD_CODSYS
         M.ORD_SYSCOD = ORD_SYSCOD

         v_seek   = M.ORD_CODSYS
         v_chiave = "ord_codsys"
         cSql     = "select * from u_bol_tt where " + v_chiave + " = '" + v_seek + "'"
         IF !ExecRW(cSql,"U_BOL_TT","R")
            return(.f.)
         ENDIF
         SELECT U_BOL_TT
         IF RECCOUNT() <> 0 
            REPLACE ORD_FLTRAS WITH  "S"        && AGGIORNA LA TESTATA DELLA BOLLA (FLAG ELABORATO)
            REPLACE ORD_SYSCOD WITH  M.ORD_SYSCOD
         ENDIF

         IF !ExecRW(cSql,"U_BOL_TT","W")
            return(.f.)
         ENDIF

         SELECT CBOL_TT
         SKIP +1

      ENDDO

   ENDIF

   * AGGIORNA UNCINO
   M.DAGGANCIO = X_UNCINO
   M.ORD_NOTE  = NOTE_ORD

   SELECT CU_PRF_DD
   APPEND BLANK
   GATHER MEMVAR MEMO

   SELECT CBOL_RR
   
   ******* PER GESTIRE I LEGAMI TRA I DOCUMENTI
   M.CUR_NUMORD = ORD_NUMORD
   M.CUR_DATORD = ORD_DATORD
   M.CUR_CODCLI = ORD_CODCLI
   M.CUR_RAGSOC = ORD_RAGSOC
   SELECT BOLLE_CUR
   SET ORDER TO I_BOLLE
   SEEK M.CUR_NUMORD + M.CUR_DATORD
   IF FOUND()
   ELSE
      APPEND BLANK
      GATHER MEMVAR MEMO
   ENDIF
   ******* CRI ***   FINE 17/09 **** PER GESTIRE I LEGAMI TRA I DOCUMENTI

   SELECT CBOL_RR
   SKIP +1

ENDDO


IF YES = 1
   DO NFATTU

   ******* PER GESTIRE I LEGAMI TRA I DOCUMENTI
   RELEASE _TABLE,_CAUS,_DOCRE,_CLOSE,_ORDCR
   PUBLIC  _TABLE,_CAUS,_DOCRE,_CLOSE,_ORDCR
   _TABLE = "CBOL_TT"
   _CAUS  = "BOLL"
   _DOCRE = "PRFA"
   _CLOSE = .F.
   _ORDCR = M.ORD_NUMORD
   SELECT BOLLE_CUR
   GO TOP
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      RIS_FUN=LEGDFUNZ(_TABLE,_CAUS,SUBSTR(CUR_DATORD,7,4),CUR_CODCLI,CUR_RAGSOC,CUR_NUMORD, ;
                       CUR_DATORD,_DOCRE,_ORDCR,DATAREGI,_CLOSE)
      SELECT BOLLE_CUR
      SKIP +1
   ENDDO
   CREATE CURSOR BOLLE_CUR (CUR_NUMORD C(06), CUR_DATORD C(10), CUR_CODCLI C(10), CUR_RAGSOC C(10))
   INDEX ON CUR_NUMORD + CUR_DATORD TAG I_BOLLE ADDITIVE  
   SELECT  CBOL_TT
   ******* CRI ***   FINE 17/09 **** PER GESTIRE I LEGAMI TRA I DOCUMENTI

   X_SPINC = 0
   
   =CREA_SPIN("FAT","CU_PRF_DD",M.ORD_VALUTA,M.ORD_CPA)  && CREA ARTICOLO CON SPESE D'INCASSO
   
   SELECT CU_PRF_TT
   REPLACE ORD_VALORE WITH ORD_VALORE + X_SPINC && AGGIUNGE SPESE INCASSO
  
   DO ESENOTB         && GESTIONE ESENZIONI
   
   SELECT CBOL_TT
   USE
   PUB_ERRORE=MESSAGEBOX('Totale pre-fatture create :'+STR(CONTA_FAT,5,0)+CHR(13)+'correttamente',64,'*** ATTENZIONE ***')
ELSE
   PUB_ERRORE=MESSAGEBOX('Nessuna pre-fattura '+CHR(13)+'creata',64,'*** ATTENZIONE ***')
ENDIF

IF !ExecRW('','u_prf_tt','I','','CU_PRF_TT')
   return(.f.)
ENDIF
IF !ExecRW('','u_prf_dd','I','','CU_PRF_DD')
   return(.f.)
ENDIF

RELEASE IVA_ESE,IVA_CLI,V_CLIES,V_DTCLES,V_NSES,V_DTNSES
RETURN


***************
FUNCTION INDATA
***************

IF RIBALTA2(ORD_DATORD)>=RIBALTA2(DATADAL) .AND. RIBALTA2(ORD_DATORD)<=RIBALTA2(DATAAL)
   OUT = .T.
ELSE
   OUT = .F.
ENDIF

RETURN(OUT)

****************
PROCEDURE NFATTU
****************

*******************************************************************************************
*   CREA TESTATA PRE-FATTURA
*******************************************************************************************

M.ORD_NPROT = SPACE(06)

* PRELEVA IL N.DI PRE-FATTURA
v_seek   = 'NUMPRF'+PUB_CODSOC
v_chiave = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
   V2=VAL(SUBSTR(LIBERA,1,7)) + 1
   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
   M.ORD_NUMORD = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
ELSE
   RIT = MSGBOX('Parametro numero pre-fattura non trovato','ATTENZIONE',31)
   RETURN
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

PUB_LNO      = 6
M.ORD_NUMORD = TRC(PUB_LNO,ALLTRIM(M.ORD_NUMORD))
M.ORD_ANNO   = PUB_ANNO

M.TAGGANCIO =  X_UNCINO

*** CALCOLO DATA DI SCADENZA

PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2],DATA_SCAD

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CODEMI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"cur_cliente")
   return(.f.)
ENDIF
SELECT cur_cliente
IF reccount() <> 0
   VET_DAL[1] = CLI_BDAL
   VET_DAL[2] = CLI_B2DAL
   VET_AL[1]  = CLI_BAL
   VET_AL[2]  = CLI_B2AL
   VET_DAY[1] = CLI_GG1
   VET_DAY[2] = CLI_GG2
   IVA_ESE    = CLI_ALRID
   IVA_CLI    = CLI_CODIVA
   V_CLIES    = CLI_CLIES
   V_DTCLES   = CLI_DTCLES
   V_NSES	  = CLI_NSES
   V_DTNSES   = CLI_DTNSES
   _ALRID     = CLI_ALRID
   IF !EMPTY(CLI_ALRID)
      _ESENZI = .T.			&& CLIENTE IN ESENZIONE
   ELSE
      _ALRID  = "20"
      _ESENZI = .F.			&& CLIENTE NON IN ESENZIONE
   ENDIF
   M.ORD_CODCLI = CLI_CODCLI
   M.ORD_RAGSOC = CLI_RAGSOC
   M.ORD_INDIRI = CLI_INDIR
   M.ORD_CAP    = CLI_CAP
   M.ORD_LOCALI = CLI_LOCALI
   M.ORD_PARIVA = CLI_PARIVA
   M.ORD_CPA    = CLI_CONPAG
   M.ORD_BANCA  = CLI_BAE
   M.ORD_AGE    = CLI_AGE
   M.ORD_CODNAZ = CLI_NAZION
   M.ORD_CODLOC = SPACE(10)
   M.ORD_LOCC   = SPACE(30)
   M.ORD_RAGC   = SPACE(30)
   M.ORD_CAPC   = SPACE(10)
   M.ORD_INDC   = SPACE(30)
   M.ORD_ALTDES = 0
   ___FLAG_POSALL = CLI_POSALL		&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = M.ORD_CODCLI	&& 2010-08-04 sergio posticipi per tutto l'anno   
ELSE
   VET_DAL[1] = "0000"
   VET_DAL[2] = "0000"
   VET_AL[1]  = "0000"
   VET_AL[2]  = "0000"
   VET_DAY[1] = "0000"
   VET_DAY[2] = "0000"
   IVA_ESE	  = ""
   IVA_CLI    = ""
   V_CLIES	  = ""
   V_DTCLES   = ""
   V_NSES	  = ""
   V_DTNSES   = ""
   _ALRID     = "20"
   _ESENZI	  = .F.				&& CLIENTE NON IN ESENZIONE
   ___FLAG_POSALL = .F.			&& 2010-08-04 sergio posticipi per tutto l'anno
   ___CLIENTE     = ""			&& 2010-08-04 sergio posticipi per tutto l'anno 
ENDIF

M.ORD_DATORD = RIBALTA2(DATAREGI)

* CALCOLO DEL TOTALE FATTURA
V_SPESE = V_SPBOLL+V_SPTRAS

IF !_ESENZI      					&& SOLO SE NON IN ESENZIONE
   V_IMPSP = V_SPESE * (20/100)
ELSE
   V_IMPSP = 0		 				&& ESENTE
ENDIF

M.T_IMPOSTA = M.T_IMPOSTA + V_IMPSP
M.T_IMPONIB = M.T_IMPONIB + (V_SPBOLL+V_SPTRAS)

IF M.ORD_VALUTA = "ITL" .OR.  M.ORD_VALUTA = "LIT"
   IF M.T_IMPOSTA-INT(M.T_IMPOSTA)<>0
      M.T_IMPOSTA=INT(M.T_IMPOSTA)+1
   ENDIF
ELSE
   M.T_IMPOSTA = ROUND((M.T_IMPOSTA),2)
ENDIF

M.T_VALORE   = M.T_IMPONIB + M.T_IMPOSTA - MATPUBX
M.ORD_VALORE = M.T_VALORE



RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= M.T_VALORE - M.T_IMPOSTA  
__T_IMPOS   = M.T_IMPOSTA   


V_CONPAG  = M.ORD_CPA
V_TUTTO   = TRANCHE("PARA",M.ORD_CPA,RIBALTA2(M.ORD_DATORD),M.ORD_VALORE,VET_DAL,VET_AL,VET_DAY,M.ORD_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)

DO SCADULT     && RICERCA ULTIMA DATA SCADENZA
M.ORD_DTSCAD = RIBALTA2(DATA_SCAD)

* AGGIORNA TESTATA
SELECT CU_PRF_TT
APPEND BLANK
GATHER MEMVAR MEMO

XXX_NUMORD = M.ORD_NUMORD
REPLACE ORD_DATORD WITH RIBALTA2(DATAREGI)
REPLACE ORD_CAUS   WITH PUB_FATTR
REPLACE TNUMERO    WITH M.ORD_NUMORD
REPLACE ORD_SPBOLL WITH V_SPBOLL
REPLACE ORD_SPTRAS WITH V_SPTRAS
REPLACE ORD_CGE    WITH .F.
REPLACE ORD_FLBOL  WITH " "
IF ORD_VALUTA = "ITL" .OR. ORD_VALUTA = "LIT"
   REPLACE ORD_CAMBIO      WITH 1
ENDIF ORD_VALUTA = "ITL" .OR. ORD_VALUTA = "LIT"

WAIT WINDOW  "PRE-FATTURA N. "+XXX_NUMORD+" CREATA" NOWAIT
CONTA_FAT = CONTA_FAT + 1

OK_PRELEVA  = .T.
M.T_IMPONIB = 0
M.T_IMPOSTA = 0
MATPUBX     = 0
V_SPESE     = 0
V_SPBOLL	= 0
V_SPTRAS	= 0

SELECT CBOL_TT

RETURN