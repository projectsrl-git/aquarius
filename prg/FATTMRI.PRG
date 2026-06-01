*********************************************************************************
*    INIZIO PROGRAMMA CREAZIONE FATTURE DA MANDATI - BOLLE    				    *
*********************************************************************************
RIT = MESSAGEBOX("Procedo con la creazione "+CHR(13)+"delle fatture",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF

PUBLIC YES,CONTA_FAT,OK_PRELEVA,X_NUMORD,LO_DESTIN,XX_FATT,XXX_NUMORD
YES        = 0
CONTA_FAT  = 0
XXX_NUMORD = ""

PUBLIC IVA_ESE,IVA_CLI,V_CLIES,V_DTCLES,V_NSES,V_DTNSES,XX_FAT

XX_FAT = SPACE(04)

DEFINE WINDOW WSELESOC;
AT 0,0 SIZE 15,80;
SYSTEM CLOSE NOGROW FLOAT;
FONT 'Courier New',8
MOVE WINDOW WSELESOC CENTER

IF !ExecCommand("select * from u_fat_tt where 0=1","cu_fat_tt")
   return(.f.)
ENDIF
IF !ExecCommand("select * from u_fat_dd where 0=1","cu_fat_dd")
   return(.f.)
ENDIF

IF !ExecCommand("select * from u_mri_tt where 0=1","u_mri_tt")
   return(.f.)
ENDIF
SELECT U_MRI_TT
HH=AFIELDS(TRAN_BOL)

CREATE CURSOR CBOL_TT FROM ARRAY TRAN_BOL
SELECT CBOL_TT
INDEX ON ORD_CODCLI+ORD_CPA+STR(VAL(ord_numord)) TAG T_NUMERIC ADDITIVE

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_dt1  = RIBALTA2(DATADAL)
x_dt2  = RIBALTA2(DATAAL)
x_data = "ord_datord between '" + x_dt1 + "' and '" + x_dt2 + "'"
x_cond = x_soci + " and " + x_data

cSql="SELECT * FROM U_MRI_TT WHERE " + x_cond + " order by ord_codsoc,ord_datord"
IF !ExecCommand(cSql,"CU_MRI_TT")
   return(.f.)
ENDIF
SELECT CU_MRI_TT
GO TOP
IF EOF()
   =MESSAGEBOX("Nessun mandato di rifornimento da elaborare",16,"Attenzione")
   RETURN
ENDIF

DO WHILE .T.
   
   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
	  LOOP
   ENDIF

   IF ORD_CHIUSO = .T. .AND. ORD_FLBOL  = 'S'
   ELSE
      SKIP +1
      LOOP
   ENDIF

   *==> E' OK SE IL FLAG DA FATTURARE (ORD_FLDAF) E' = 'S'
   *==>     E SE IL FLAG FATTURATO (ORD_FLFAT) NON E' UGUALE A 'S'

   IF ORD_FLDFA  = 'S' .AND. ORD_FLFAT  <> 'S'
   ELSE
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR MEMO

   SELECT  CBOL_TT
   APPEND BLANK
   GATHER MEMVAR MEMO
		
   REPLACE SELEZIONE WITH SPACE(10)	&& IMPOSTA CAMPO SELEZIONE

   SELECT CU_MRI_TT
   SKIP +1

ENDDO

SELECT  CBOL_TT
SET ORDER TO T_NUMERIC
GO TOP

IF _SELEFAT
   ON KEY LABEL ENTER DO CHK2
   ON KEY LABEL F DO CHKR
   ON KEY LABEL RIGHTMOUSE DO CHKR
   DEFINE WINDOW WSELESOC;
   AT 0,0 SIZE 15,81;
   SYSTEM CLOSE NOGROW FLOAT;
   FONT 'Courier New',8
   MOVE WINDOW WSELESOC CENTER
   BROWSE FIELDS SELEZIONE:10:H='SELEZIONE',ORD_CODCLI:10:H='CLIENTE', ;
      ORD_RAGSOC:35:H='RAGIONE SOCIALE',ORD_DATORD:10:H='DATA MANDATO', ;
      ORD_NUMORD:10:H='NUM.MANDATO' NOMENU  NODELETE NOEDIT WINDOW WSELESOC
   RELEASE WINDOWS WSELESOC
   PUSH KEY CLEAR
ENDIF

******* PER GESTIRE I LEGAMI TRA I DOCUMENTI
CREATE CURSOR BOLLE_CUR (CUR_NUMORD C(06), CUR_DATORD C(10), CUR_CODCLI C(10), CUR_RAGSOC C(10))
INDEX ON CUR_NUMORD + CUR_DATORD TAG I_BOLLE ADDITIVE  
******* CRI ***   FINE 17/09 **** PER GESTIRE I LEGAMI TRA I DOCUMENTI

OK_PRELEVA  = .T.
M.T_IMPONIB = 0
M.T_IMPOSTA = 0
MATPUBX     = 0
V_SPESE     = 0
SOLO_ORA	= .T.

SELECT  CBOL_TT
SET ORDER TO T_NUMERIC
GO TOP

CLINEW = ORD_CODCLI
CPANEW = ORD_CPA

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   IF _SELEFAT
      IF SELEZIONE <> '=>'
	     SKIP +1
	     LOOP
      ENDIF
   ENDIF	

   IF SOLO_ORA
	  CLINEW = ORD_CODCLI
	  CPANEW = ORD_CPA
	  SOLO_ORA = .F.
   ENDIF	

   * SE ROTTURA CLIENTE CREO LA TESTATA FATTURE SU SCATTER MEMVAR VECCHIA

   KATT = ORD_CODCLI+ORD_CPA
   KPRE = CLINEW+CPANEW

   IF KATT <> KPRE
      DO NFATTU

      ******* PER GESTIRE I LEGAMI TRA I DOCUMENTI
      RELEASE _TABLE,_CAUS,_DOCRE,_CLOSE,_ORDCR
      PUBLIC  _TABLE,_CAUS,_DOCRE,_CLOSE,_ORDCR
      _TABLE = "CBOL_TT"
      _CAUS  = "MRIF"
      _DOCRE = "FATT"
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

      =CREA_SPIN("FAT","CU_FAT_DD",M.ORD_VALUTA,M.ORD_CPA)  && CREA ARTICOLO CON SPESE D'INCASSO

      =CREA_NOTE("FAT","CU_FAT_DD")

      SELECT CU_FAT_TT
      REPLACE ORD_VALORE	WITH ORD_VALORE + X_SPINC && AGGIUNGE SPESE INCASSO

      DO ESENOTB         && GESTIONE ESENZIONI
   ENDIF

   SELECT  CBOL_TT

   IF OK_PRELEVA  	  && PRELEVA UNCINO PER LEGARE TESTATA/DETTAGLIO
      OK_PRELEVA  = .F.
	  M.TAGGANCIO = STR(NEWPROG('NUMFAT'),10)
	  X_UNCINO    = M.TAGGANCIO
   ENDIF

   SELECT  CBOL_TT

   CLINEW  = ORD_CODCLI
   CPANEW  = ORD_CPA
   OR_DINE = ORD_NUMORD
   DT_ORDI = ORD_DATORD
   UNCINO  = TAGGANCIO

   IF ORD_LOCC = SPACE(30) .OR. EMPTY(ORD_LOCC)
      LO_DESTIN = SPACE(30)
   ELSE
      LO_DESTIN = ORD_LOCC
   ENDIF

   SCATTER MEMVAR MEMO	

   V_SPESE  = V_SPESE  + M.ORD_SPBOLL + M.ORD_SPTRAS
   V_SPBOLL = V_SPBOLL + M.ORD_SPBOLL
   V_SPTRAS = V_SPTRAS + M.ORD_SPTRAS

   * PRELEVA IL N.DI FATTURA DA ASSEGNARE ALLE RIGHE
   v_seek	= ACCESS_YEAR('NUMFAT' + PUB_CODSOC)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      V2=VAL(SUBSTR(LIBERA,1,7)) + 1
      X_NUMORD = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
   ELSE
      RIT = MSGBOX('Parametro numero fattura non trovato','ATTENZIONE',31)
      RETURN
   ENDIF

   x_nume = "ors_numorc = '" + M.ORD_NUMORD + "'"
   x_data = "ors_datorc = '" + M.ORD_DATORD + "'"
   x_codi = "ors_codcli = '" + M.ORD_CODCLI + "'"
   x_cond = x_nume + " and " + x_data + " and " + x_codi
   Csql   = "select * from u_bol_dd where " + x_cond + " order by daggancio"
   IF !ExecCommand(cSql,"PIPPO1")
      return(.f.)
   ENDIF
 
   SELECT DAGGANCIO ;
          FROM PIPPO1 ;
          INTO CURSOR PIPPO ;
          WHERE ORS_NUMORC = M.ORD_NUMORD .AND. ;
                ORS_DATORC = M.ORD_DATORD .AND. ;
                ORS_CODCLI = M.ORD_CODCLI ;
          GROUP BY DAGGANCIO

   SELECT PIPPO
   GO TOP
   
   IF EOF()
      SELECT  CBOL_TT
 	  SKIP +1
	  LOOP
   ENDIF

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF
      
      IF DELETED()
         SKIP +1
         LOOP
      ENDIF
       
      UNCINO = DAGGANCIO

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
            IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   && VERIFICA SE DEVE GESTIRE IL COMMENTO
     	       IF !GEST_NOTE("FAT",ORD_CODICE)
                  SELECT U_BOL_DD
                  SKIP +1
                  LOOP
               ENDIF          	
            ENDIF
            IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
            ELSE
               OR_DINE = ORS_NUMORD
               DT_ORDI = ORS_DATORD
            ENDIF

            * SI CREA LE VARIABILI DAL RECORD
	        SCATTER MEMVAR MEMO	
	
	        * AGGIORNA UNCINO
	        M.DAGGANCIO = X_UNCINO
	
	        * AGGIORNA I DETTAGLI
	        SELECT CU_FAT_DD
	        APPEND BLANK
	        GATHER MEMVAR MEMO

 	        REPLACE ORS_NUMDDT WITH ORS_NUMORD
	        REPLACE ORS_DATDDT WITH ORS_DATORD
	        REPLACE ORS_NUMORD WITH X_NUMORD
	        REPLACE ORS_DATORD WITH DATAREGI

            IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"
               REPLACE ORS_MAGS   WITH SPACE(06)
               REPLACE ORS_CODCLI WITH SPACE(10)
               REPLACE ORS_RAGSOC WITH SPACE(40)
               REPLACE ORS_NUMORD WITH SPACE(06)
               REPLACE ORS_DATORD WITH SPACE(10)
               REPLACE ORS_CODEMI WITH SPACE(10)
               REPLACE ORS_RAGEMI WITH SPACE(10)
               REPLACE ORS_TIPORD WITH SPACE(03)
               REPLACE ORS_SALCON WITH SPACE(01)
               REPLACE SELEZIONE  WITH SPACE(10)
               REPLACE ORS_NUMORC WITH SPACE(06)
               REPLACE ORS_DATORC WITH SPACE(10)
               REPLACE ORS_DESTIN WITH SPACE(30)
               REPLACE ORD_QTCONF WITH 0
               REPLACE ORD_QTXCON WITH 0
               REPLACE ORS_NUMDDT WITH SPACE(06)
               REPLACE ORS_DATDDT WITH SPACE(10)
            ENDIF
 	        CIVA = ORD_IVA
            v_seek	= 'IVA' + CIVA
            v_chiave = "codice"
            IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
               SELECT CUR_PARA
               VIVA = VAL(SUBSTR(LIBERA,1,3))
            ELSE
     	       VIVA = 0
            ENDIF
	        SELECT CU_FAT_DD
	        IF ORD_PUBBLI = "S"
	           MATPUBX = MATPUBX + ORD_VALORE
	        ENDIF
	        M.T_IMPONIB = M.T_IMPONIB + ORD_VALORE
	        M.T_IMPOSTA = M.T_IMPOSTA + (ORD_VALORE * (VIVA/100))
            SELECT CU_BOL_DD
            SKIP +1
         ENDDO
         DO COMMENTO   && INSERISCE RIFERIMENTO A DOCUMENTO DI TRASPORTO
      ELSE
         PUB_ERRORE=MESSAGEBOX('Dettagli inesistenti ordine : '+ OR_DINE,64,'*** ATTENZIONE ***')
      ENDIF

      SELECT PIPPO
      SKIP +1

   ENDDO

   SELECT  PIPPO
   GO TOP

   DO WHILE .T.

      IF EOF()
         EXIT
      ENDIF

      UNCINO = DAGGANCIO

      v_seek   = ALLTRIM(UNCINO)
      v_chiave = "taggancio"
      cSql     = "select * from u_bol_tt where " + v_chiave + " = '" + v_seek + "'"
      IF !ExecRW(cSql,"U_BOL_TT","R")
         return(.f.)
      ENDIF
      SELECT U_BOL_TT
      IF RECCOUNT() <> 0 
 	     REPLACE ORD_FLBOL WITH  "S"        && AGGIORNA LA TESTATA DELLA BOLLA (FLAG ELABORATO)
      ENDIF

      IF !ExecRW(cSql,"U_BOL_TT","W")
         return(.f.)
      ENDIF

      SELECT PIPPO
      SKIP +1

   ENDDO

   SELECT  CBOL_TT

   UNCINO = TAGGANCIO

   v_seek   = ALLTRIM(UNCINO)
   v_chiave = "taggancio"
   cSql     = "select * from u_mri_tt where " + v_chiave + " = '" + v_seek + "'"
   IF !ExecRW(cSql,"U_MRI_TT","R")
      return(.f.)
   ENDIF
   SELECT U_MRI_TT
   IF RECCOUNT() <> 0 
 	  REPLACE ORD_FLFAT WITH 'S'        && AGGIORNA LA TESTATA DELLA BOLLA (FLAG ELABORATO)
   ENDIF

   IF !ExecRW(cSql,"U_MRI_TT","W")
      return(.f.)
   ENDIF

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
      GATHER MEMVAR
   ENDIF
   ******* CRI ***   FINE 17/09 **** PER GESTIRE I LEGAMI TRA I DOCUMENTI

   YES = 1

   SELECT CBOL_TT
   SKIP +1

ENDDO

IF YES = 1

   DO NFATTU

   ******* PER GESTIRE I LEGAMI TRA I DOCUMENTI
   RELEASE _TABLE,_CAUS,_DOCRE,_CLOSE,_ORDCR
   PUBLIC  _TABLE,_CAUS,_DOCRE,_CLOSE,_ORDCR
   _TABLE = "CBOL_TT"
   _CAUS  = "MRIF"
   _DOCRE = "FATT"
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

   =CREA_SPIN("FAT","CU_FAT_DD",M.ORD_VALUTA,M.ORD_CPA)  && CREA ARTICOLO CON SPESE D'INCASSO

   =CREA_NOTE("FAT","CU_FAT_DD")

   SELECT CU_FAT_TT
   REPLACE ORD_VALORE WITH ORD_VALORE + X_SPINC && AGGIUNGE SPESE INCASSO

   DO ESENOTB         && GESTIONE ESENZIONI

   SELECT CBOL_TT
   USE
   PUB_ERRORE=MESSAGEBOX('Totale fatture create :'+STR(CONTA_FAT,5,0)+CHR(13)+'correttamente',64,'*** ATTENZIONE ***')
ELSE
   PUB_ERRORE=MESSAGEBOX('Nessuna fattura '+CHR(13)+'creata',64,'*** ATTENZIONE ***')
ENDIF

DO GESTIONE_RIEPILOGO WITH 'INS','FAT',PUB_FATTU,SPACE(10)	&& INSERIMENTO NUOVI RIEPILOGHI SU U_VEN_CL

IF !ExecRW('','u_fat_tt','I','','CU_FAT_TT')
   return(.f.)
ENDIF
IF !ExecRW('','u_fat_dd','I','','CU_FAT_DD')
   return(.f.)
ENDIF

RELEASE  IVA_ESE,IVA_CLI,V_CLIES,V_DTCLES,V_NSES,V_DTNSES
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
*   CREA TESTATA FATTURA
*******************************************************************************************

M.ORD_NPROT = SPACE(06)
v_seek      = 'NUMPRC'+PUB_CODSOC
v_chiave    = "codice"
cSql        = "select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
   V2=VAL(SUBSTR(LIBERA,1,7)) + 1
   REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
   M.ORD_NPROT = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
ELSE
   RIT = MSGBOX('Parametro numero fattura non trovato','ATTENZIONE',31)
   RETURN
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

* PRELEVA IL N.DI FATTURA
v_seek   = ACCESS_YEAR('NUMFAT'+PUB_CODSOC)
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
   RIT = MSGBOX('Parametro numero fattura non trovato','ATTENZIONE',31)
   RETURN
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

PUB_LNO      = 6
M.ORD_NUMORD = TRC(PUB_LNO,ALLTRIM(M.ORD_NUMORD))
M.ORD_ANNO   = PUB_ANNO

** PRELEVA UNCINO PER LEGARE TESTATA/DETTAGLIO

M.TAGGANCIO = X_UNCINO

** CALCOLO DATA DI SCADENZA

PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2],DATA_SCAD

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
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
  ___FLAG_POSALL = CLI_POSALL		&& 2010-08-04 sergio posticipi per tutto l'anno
  ___CLIENTE     = M.ORD_CODCLI		&& 2010-08-04 sergio posticipi per tutto l'anno
ELSE
   VET_DAL[1] = "0000"
   VET_DAL[2] = "0000"
   VET_AL[1]  = "0000"
   VET_AL[2]  = "0000"
   VET_DAY[1] = "0000"
   VET_DAY[2] = "0000"
   IVA_ESE	  = ""
   IVA_CLI	  = ""
   V_CLIES	  = ""
   V_DTCLES   = ""
   V_NSES	  = ""
   V_DTNSES   = ""
   _ALRID     = "20"
   _ESENZI	  = .F.				&& CLIENTE NON IN ESENZIONE
  ___FLAG_POSALL = .F.		&& 2010-08-04 sergio posticipi per tutto l'anno
  ___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno 
ENDIF

M.ORD_DATORD = RIBALTA2(DATAREGI)

* CALCOLO DEL TOTALE FATTURA
V_SPESE =  V_SPBOLL+V_SPTRAS

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
   M.T_IMPOSTA	=	ROUND((M.T_IMPOSTA),2)
ENDIF

M.T_VALORE   = M.T_IMPONIB + M.T_IMPOSTA - MATPUBX
M.ORD_VALORE = M.T_VALORE


RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= M.T_VALORE - M.T_IMPOSTA   
__T_IMPOS   = M.T_IMPOSTA   

V_CONPAG = M.ORD_CPA
V_TUTTO  = TRANCHE("PARA",M.ORD_CPA,RIBALTA2(M.ORD_DATORD),M.ORD_VALORE,VET_DAL,VET_AL,VET_DAY,M.ORD_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)


DO SCADULT     && RICERCA ULTIMA DATA SCADENZA
M.ORD_DTSCAD = RIBALTA2(DATA_SCAD)

* AGGIORNA TESTATA
SELECT CU_FAT_TT
APPEND BLANK
GATHER MEMVAR MEMO

XXX_NUMORD = M.ORD_NUMORD
REPLACE ORD_DATORD WITH RIBALTA2(DATAREGI)
REPLACE ORD_CAUS   WITH PUB_FATTU
REPLACE TNUMERO    WITH M.ORD_NUMORD
REPLACE ORD_NPROT  WITH M.ORD_NPROT
REPLACE ORD_SPBOLL WITH V_SPBOLL
REPLACE ORD_SPTRAS WITH V_SPTRAS
REPLACE ORD_CGE    WITH .F.

IF ORD_VALUTA = "ITL" .OR. ORD_VALUTA = "LIT"
   REPLACE ORD_CAMBIO WITH 1
ENDIF

WAIT WINDOW "FATTURA N. "+XXX_NUMORD+" CREATA" NOWAIT
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

******************
PROCEDURE COMMENTO
******************

* INSERISCE COMMENTO IN FATTURA
SELECT CU_FAT_DD
APPEND BLANK
M.DAGGANCIO  = X_UNCINO
m.ord_codart = SPACE(16)
M.ORD_MAGA	 = SPACE(06)
M.ORD_DESART = "*** COMMENTO ***"
M.ORD_DES2	 = SPACE(25)
M.ORD_UM	 = SPACE(02)
M.ORD_IVA	 = SPACE(02)
M.ORD_PREZZO = 0
M.ORD_QTAORD = 0
M.ORD_PRZNET = 0
M.ORD_VALORE = 0
M.ORD_SC1    = 0
M.ORD_SC2    = 0
M.ORD_SC3    = 0	
M.ORD_NOTE   = "D.d.T. N. "+ALLTRIM(OR_DINE)+" Del "+DT_ORDI
M.ORD_PUBBLI = " "
M.ORD_CODICE = SPACE(10)
M.ORD_VALCO  = 0

GATHER MEMVAR MEMO

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(M.ORD_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"cur_cliente")
   return(.f.)
ENDIF
SELECT cur_cliente
IF reccount() <> 0
   IVA_ESE  = CLI_ALRID
   IVA_CLI  = CLI_CODIVA
   V_CLIES  = CLI_CLIES
   V_DTCLES = CLI_DTCLES
   V_NSES	= CLI_NSES
   V_DTNSES = CLI_DTNSES
ELSE
   IVA_ESE  = ""
   IVA_CLI  = ""
   V_CLIES  = ""
   V_DTCLES = ""
   V_NSES	= ""
   V_DTNSES = ""
ENDIF

SELECT CU_FAT_DD

RETURN