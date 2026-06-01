**************************************************************************************************************
* 			 TRASFERIMENTO IN CONTABILITA GENERALE DELLE FATTURE FORNITORI   								 *
*																			 								 *
*	NOTE :																									 *
*			VEDIART = ROUTIN PER DETERMINARE IL CONTO CONTABILE DELLA CONTROPARTITA							 *
*					  - 1) STEP ACCEDE SU ANAGRAFICA FORNITORI PRELEVA LA CONTROPARTITA 					 *
*					  - 2) STEP VERIFICA IN PIANO CONTI CONGRUENZA CONTO	 				 				 *
*					  - 3) STEP SE NON ESISTE SU PIANO CONTI O SE VUOTO PRENDE CONTROPARTITA DI DEFAULT (ACS)*
*																											 *
**************************************************************************************************************
PUBLIC PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,XDESF,V_CODCLI,DATA_SCAD,CT
RELEASE NPROT,__CEE
PUBLIC  NPROT,__CEE
XDESF    = "REGISTRAZIONE AUTOMATICA"
COMPENSO = 0
TIVA     = 0
CIVA     = 0
TOP_TOP  = SPACE(03)
DATA_SCAD = ""

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

CREATE CURSOR W_FAT (W_CONTO C(13),W_DA C(1),W_IVA C(3), ;
        W_IMPONI N(17,3) ,W_IMPOSTA N(17,3),W_SPINCA N(17,3),W_SPTRAS N(17,3),W_PUBBLI N(17,3)  ,W_NUMDOC C(10),W_DTDOC C(10))
        
SELECT W_FAT        
INDEX ON W_CONTO+ W_DA + W_IVA TAG DETTA
SET ORDER TO DETTA

***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL FORNITORE
v_seek	 = 'GEN'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro GEN 4 caratteri conti clienti"
   RETURN
ENDIF
FF=SUBSTR(LIBERA,18,4)

v_seek	 = 'ACS'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro ACS conto acquisto servizio"
   RETURN
ENDIF
V_ACS=SUBSTR(LIBERA,1,13)

v_seek	 = 'IVA'+'20'
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro conto iva 20%" 
   RETURN
ENDIF
CON_IVA=ALLTRIM(SUBSTR(LIBERA,29,13))      && CONTO IVA FORNITORI

DATREG  = XDATA      && FORZA LA DATA DI REGISTRAZIONE CON LA DATA DIGITATA
CTRELAB = 0
CT      = 0
PERDAL  = RIBALTA2(DATADAL)
PERAL   = RIBALTA2(DATAAL)

x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_data = "ord_datord >= '" + PERDAL + "'"
x_cond = x_soci + " and " + x_data
Csql = "select * from u_fam_tt where " + x_cond + " order by ord_codsoc,ord_datord"
IF !ExecRW(Csql,"U_FAM_TT","R")
   return(.f.)
ENDIF
SELECT U_FAM_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF ORD_CGE
      SKIP +1
      LOOP
   ENDIF  

   IF ORD_DATORD > PERAL
      EXIT
   ENDIF  

   CTRELAB=CTRELAB+1 
   WAIT WINDOW  "Fatture Elaborate"+STR(CTRELAB,6,0) NOWAIT

   ****DATI DI TESTATA DELLA SINGOLA FATTURA ****
 
   SELECT U_FAM_TT
 	
   V_CODCLI = ORD_CODCLI
   V_CONPAG = ORD_CPA
   V_DTSCA  = ORD_DTSCAD
   XDESF    = ORD_RAGSOC
   XVALUTA  = ORD_VALUTA
   XCAMBIO  = ORD_CAMBIO
   _NAZ     = ORD_CODNAZ
   _ALRID   = "20"
   _ESENZI  = .F.				
   V_SEEK   = TAGGANCIO
   VALFAT   = ORD_VALORE
   TOP_TOP  = 'ACQ'            

   v_seek	= 'TOP' + TOP_TOP
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
   ELSE
      WAIT WINDOW "Errore manca parametro TOP : " + TOP_TOP
      TOP_TOP ="ACQ"
   ENDIF
    
   v_seek	= "CPA"+V_CONPAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
   ELSE
  	  V_CONPAG  = "101"   && FORZATURA CPA CONTANTI
   ENDIF 
  
   SELECT U_FAM_TT

   V_TOTALE = 0
   CONTO    = VEDIFOR(V_CODCLI)
   V_SEEK   = TAGGANCIO
  
   SELECT W_FAT
   ZAP
 	
   x_agga = "daggancio = '" + ALLTRIM(V_SEEK) + "'"
   x_cond = x_agga
   Csql   = "select * from u_fam_dd where " + x_cond + " order by daggancio"
   IF !ExecRW(Csql,"u_fam_dd","R")
      return(.f.)
   ENDIF
   SELECT U_FAM_DD
   GO TOP
   IF !EOF()
      DO WHILE .T.
         IF EOF()
            EXIT
         ENDIF              
         IF ORD_VALORE = 0
	        SKIP +1
	        LOOP
	     ENDIF
 	     VALORE   = ORD_VALORE
         IVA      = ORD_IVA
	     V_TOTALE = V_TOTALE + VALORE
 	     SELECT W_FAT
         GO TOP 
	     SEEK CONTO + 'D' +IVA
  	     IF FOUND()
	        REPLACE W_IMPONI WITH W_IMPONI + VALORE
	     ELSE
	        APPEND BLANK 
	        REPLACE W_IMPONI WITH VALORE
	        REPLACE W_CONTO  WITH CONTO
	        REPLACE W_IVA    WITH IVA
	        REPLACE W_DA     WITH 'D'
 	     ENDIF
	     SELECT U_FAM_DD
	     REPLACE ORD_RCGE WITH .T.
	     SKIP +1
	  ENDDO
      IF !ExecRW(Csql,"u_fam_dd","W")
         return(.f.)
      ENDIF
	  ****CALCOLA TUTTE LE IVE****
	  TIVA = 0
	  DO CALCIVA
   ELSE
	  WAIT WINDOW 'Non trovo le righe di dettaglio fattura '+V_SEEK 	
   ENDIF

   ****SCRIVO I MOVIMENTI / SALDI / PARTITARI ***
 
   DO REG_NUMRPN

   DO REG_NUMREG

   VER_CONTO = "F"
   FATTURA   = "S"
   X_NPROT   = ""
   NPROT     = ""
   __CEE     = ""
   
   DO REG_NUMPRO

   SELECT U_FAM_TT

   V_CODFOR = ORD_CODCLI
   KCON     = FF+ORD_CODCLI

   x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "for_codcli = '" + ALLTRIM(V_CODFOR) + "'"
   x_cond = x_soci + " and " + x_codi   
   cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
   IF !ExecCommand(cSql,"CUR_FORNITORE")
      RETURN .F.
   ENDIF
   SELECT CUR_FORNITORE
   GO TOP   
   IF !EOF()
      V_NAZION  = FOR_NAZION
   ELSE
      V_NAZION  = SPACE(03)
   ENDIF 

   V_ER=SOTTOGEN(V_NAZION)
   IF !V_ER
 	  FF = PUB_FF
   ENDIF 

   SELECT U_FAM_TT

   M.CONTO	 = FF+ORD_CODCLI
   M.DTD	 = ORD_DATORD
   M.DOC	 = ORD_NUMORD
   M.OLFAT	 = ORD_NUMORD
   M.CCAGE   = SPACE(03)
   DATREG	 = XDATA        && FORZA LA DATA DI REGISTRAZIONE CON LA DATA DIGITATA
   M.RAGSOC  = ORD_RAGSOC
   D_A       = "A"
   DAVD      = "A"
   DAVA      = "D"

   ** >>> CONTROLLI INCROCIATI SU VALORE RICALCOLATO E TOTALE FATTURA
   
   * CONTROLLO SU TOTALE ELABORATO E TOTALE FATTURA

   DIFF_TOT = 0
 
   IF V_TOTALE <> VALFAT
      DIFF_TOT = VALFAT - V_TOTALE
      V_TOTALE = VALFAT
   ENDIF  
 
   DO movcreat WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO	&&TESTATA
   DO movcreai WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO	&&INDICE
   
   SELECT W_FAT
   GO TOP

   X_TOTALE = 0
 
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF 
      X_TOTALE = X_TOTALE + (W_IMPONI + W_IMPOSTA)
      IF (V_TOTALE - X_TOTALE) > 0 .AND. (V_TOTALE - X_TOTALE) <= 1
         REPLACE W_IMPOSTA WITH  W_IMPOSTA + DIFF_TOT
         DIFF_TOT  = 0
      ENDIF     
      OLD_DESF=XDESF
      XDESF="FOR:"+ALLTRIM(SUBSTR(M.CONTO,5,9))+" N.F:"+M.OLFAT+" DEL "+M.DTD
      DO movcrea WITH DAVA,W_IMPONI,W_IMPOSTA,W_IVA,W_CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO  	&&DET ACQUISTO
      DO movcrea WITH DAVA,W_IMPOSTA,0,W_IVA,CON_IVA,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO			&&DET IVA
      SELECT W_FAT
 	  SKIP +1
   ENDDO
   
   SELECT U_FAM_TT
   REPLACE ORD_CGE    WITH .T.
   REPLACE ORD_DATCGE WITH DTOC(DATE())
   REPLACE ORD_CHIUSO WITH .T.
 
   CT = CT +1
   SKIP +1

ENDDO

IF !ExecRW(Csql,"U_FAM_TT","W")
   return(.f.)
ENDIF

RELEASE WINDOW DISPLAY

WAIT WINDOWS 'Elaborate n. '+str(CT,5,0)+' Fatture'+CHR(13)
WAIT WINDOWS 'Elaborazione completata ...' NOWAIT
=MESSAGEBOX("Trasferimento fatture in co.ge. terminato correttamente",62,"ATTENZIONE")

RELEASE WINDOW DISPLAY

RETURN


*************
PROCEDURE CHK
*************
PUSH KEY CLEAR
IF SELEZIONE='=>'
   REPLACE SELEZIONE WITH ' '
ELSE
   REPLACE SELEZIONE WITH '=>'
ENDIF
POP KEY 
KEYBOARD "{RIGHTARROW}+{LEFTARROW}" 
RETURN

*************************************************************
PROCEDURE movcreai      && crea la partita primaria SU INDICE
*************************************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,NPRO,YVALUTA,YCAMBIO

SELE=SELECT()

IF !ExecCommand("select * from indice where 0=1","cu_indice")
   return(.f.)
ENDIF
SELECT CU_INDICE
APPEND BLANK
REPLACE MOV_SOC    WITH PUB_CODSOC
REPLACE MOV_ANNO   WITH PUB_ANNO
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE MOV_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE MOV_DTREG  WITH DATREG           
ENDIF
REPLACE MOV_NREGIS WITH ALLTRIM(NREG)
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTDOC  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTDOC  WITH DTD
ENDIF
REPLACE MOV_NDOC   WITH NDOC
REPLACE MOV_TOP    WITH TOP 
REPLACE MOV_NPROT  WITH ALLTRIM(X_NPROT)
REPLACE MOV_CONTO  WITH CON
REPLACE MOV_IVA    WITH IV
REPLACE MOV_IMPOST WITH TAS
REPLACE MOV_DESMOV WITH 'REGISTRAZIONE AUTOMATICA'
REPLACE MOV_NUMPRO WITH ALLTRIM(PN_C)
REPLACE MOV_IMP    WITH IMP
REPLACE MOV_TMOV   WITH DA_AV
REPLACE MOV_VALUTA WITH YVALUTA
REPLACE MOV_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF
IF !ExecRW('','indice','I','','CU_INDICE')
   return(.f.)
ENDIF
  
SELECT(SELE)
RETURN


*****************************************************************************
PROCEDURE movcreat      && crea la partita primaria e il partitario fornitori
*****************************************************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,NPRO,YVALUTA,YCAMBIO

SELE=SELECT()

IF !ExecCommand("select * from mov_cont where 0=1","cu_movcont")
   return(.f.)
ENDIF
SELECT CU_MOVCONT
APPEND BLANK
REPLACE MOV_SOC    WITH PUB_CODSOC
REPLACE MOV_ANNO   WITH PUB_ANNO
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE MOV_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE MOV_DTREG  WITH DATREG           
ENDIF
REPLACE MOV_NREGIS WITH ALLTRIM(NREG)
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTDOC  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTDOC  WITH DTD
ENDIF
REPLACE MOV_ANNODO WITH SUBSTR(MOV_DTDOC,1,4)    
REPLACE MOV_NDOC   WITH NDOC
REPLACE MOV_TOP    WITH TOP 
REPLACE MOV_NPROT  WITH ALLTRIM(X_NPROT)
REPLACE MOV_CONTO  WITH CON
REPLACE MOV_IVA    WITH IV
REPLACE MOV_IMPOST WITH TAS
REPLACE MOV_DESMOV WITH 'REGISTRAZIONE AUTOMATICA'
REPLACE MOV_NUMPRO WITH ALLTRIM(PN_C)
REPLACE MOV_IMP    WITH IMP
REPLACE MOV_TMOV   WITH DA_AV
REPLACE MOV_CEE    WITH M.CCAGE 
REPLACE MOV_VALUTA WITH YVALUTA
REPLACE MOV_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF
IF !ExecRW('','mov_cont','I','','CU_MOVCONT')
   return(.f.)
ENDIF
 
******AGGIORNA IL D.B. DEI CONTI
   
x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(CON) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"conti","R")
   return(.f.)
ENDIF
SELECT conti
GO TOP
IF !EOF()
   P_IMPA   = CON_IMP_A
   P_IMPD   = CON_IMP_D
   MESE     = SUBSTR(DATREG,4,2)
   VAR      = "CON_AV"+MESE
   VAR2     = "CON_DA"+MESE
   CLI_FOR  = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
	  REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR2       WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR2
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR
   ENDIF
ELSE
   ****WAIT WINDOW "INSERISCO IL CONTO SUL PIANO DEI CONTI" 
   APPEND BLANK
   REPLACE CON_SOC    WITH PUB_CODSOC
   REPLACE CON_ANNO   WITH PUB_ANNO
   REPLACE CON_CONTO  WITH CON
   REPLACE CON_DESCR  WITH M.RAGSOC
   REPLACE CON_TIPOCO WITH "F"
   REPLACE CON_POSBIL WITH "P"
   REPLACE CON_IVASN  WITH .F. 
   P_IMPA   = CON_IMP_A
   P_IMPD   = CON_IMP_D
   MESE     = SUBSTR(DATREG,4,2)
   VAR      = "CON_AV"+MESE
   VAR2     = "CON_DA"+MESE
   CLI_FOR  = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
	  REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR2       WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR2
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR
   ENDIF
ENDIF 
IF !ExecRW(cSql,"conti","W")
   return(.f.)
ENDIF

DO REG_PARFOR    && AGGIORNA PARTITARIO FORNITORI
 
SELECT(SELE)
RETURN


**********************************************
PROCEDURE movcrea     && CREA LE CONTROPARTITE
**********************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,NPRO,YVALUTA,YCAMBIO

SELE=SELECT()

IF !ExecCommand("select * from mov_cont where 0=1","cu_movcont")
   return(.f.)
ENDIF
SELECT CU_MOVCONT
APPEND BLANK
REPLACE MOV_SOC    WITH PUB_CODSOC
REPLACE MOV_ANNO   WITH PUB_ANNO
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE MOV_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE MOV_DTREG  WITH DATREG           
ENDIF
REPLACE MOV_NREGIS WITH ALLTRIM(NREG)
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTDOC  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTDOC  WITH DTD
ENDIF
REPLACE MOV_ANNODO WITH SUBSTR(MOV_DTDOC,1,4)    
REPLACE MOV_NDOC   WITH NDOC
REPLACE MOV_TOP    WITH TOP 
REPLACE MOV_NPROT  WITH ALLTRIM(X_NPROT)
REPLACE MOV_CONTO  WITH CON
REPLACE MOV_IVA    WITH IV
REPLACE MOV_IMPOST WITH TAS
REPLACE MOV_DESMOV WITH XDESF
REPLACE MOV_NUMPRO WITH ALLTRIM(PN_C)
REPLACE MOV_IMP    WITH IMP
REPLACE MOV_TMOV   WITH DA_AV
REPLACE MOV_CEE    WITH M.CCAGE 
REPLACE MOV_VALUTA WITH YVALUTA
REPLACE MOV_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF
IF !ExecRW('','mov_cont','I','','CU_MOVCONT')
   return(.f.)
ENDIF
 
*******AGGIORNA IL D.B. DEI CONTI

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(CON) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"conti","R")
   return(.f.)
ENDIF
SELECT conti
GO TOP
IF !EOF()
   P_IMPA   = CON_IMP_A
   P_IMPD   = CON_IMP_D
   MESE     = SUBSTR(DATREG,4,2)
   VAR      = "CON_AV"+MESE
   VAR2     = "CON_DA"+MESE
   CLI_FOR  = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
      REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR2       WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR2
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR
   ENDIF
ELSE
   WAIT WINDOW 'Conto :'+ALLTRIM(CON)+CHR(13)+'inesistente su conti'
ENDIF 
IF !ExecRW(cSql,"conti","W")
   return(.f.)
ENDIF
 
SELECT(SELE)
RETURN


*****************
PROCEDURE CALCIVA
*****************

SELECT W_FAT
GO TOP

DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   VALIVA	= W_IMPONI * IVAREAL(W_IVA)
   TIVA  	= TIVA + VALIVA
   CIVA  	= W_IVA
   REPLACE  W_IMPOSTA WITH VALIVA
   V_TOTALE = V_TOTALE + VALIVA	
   SKIP +1
ENDDO

RETURN


****************
FUNCTION IVAREAL
****************

PARA FG
SELE=SELECT()
RET = 0

v_seek	 = 'IVA'+FG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   LIB=VAL(SUBSTR(LIBERA,1,3))
ELSE
   =MSGBOX('Iva non trovata '+FG,'ATTENZIONE',31)
   LIB=0
ENDIF

RET = LIB/100

SELECT(SELE)

RETURN(RET)


**************
PROCEDURE CHK2
**************

PUSH KEY CLEAR
IF SELEZIONE='=>'
   REPLACE SELEZIONE WITH '  '
ELSE
   REPLACE SELEZIONE WITH '=>'
ENDIF
POP KEY 
KEYBOARD "{RIGHTARROW}+{LEFTARROW}"
RETURN


**************
PROCEDURE CHKR
**************

PUSH KEY CLEAR
KEYBOARD "{CTRL+W}"
POP KEY


***********************************************
* AGG. NUMERO DI REGISTRAZIONE  INTERNO DI PN *
***********************************************
PROCEDURE REG_NUMRPN

v_seek   = 'NUMREGPN'+PUB_CODSOC
v_chiave = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
ELSE
   RIT=MSGBOX('Numero di registrazione (NUMREGPN) interno non trovato','ATTENZIONE',31)
   RETURN
ENDIF
PN=VAL(SUBSTR(LIBERA,1,10))
PN=PN + 1
PN_C=STR(PN)
*REPLACE LIBERA WITH ALLTRIM(PN_C)  
PN_C=sys(2015)
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF
  
RETURN




***********************************************
* AGG. NUMERO DI REGISTRAZIONE  UTENTE        *
***********************************************
PROCEDURE REG_NUMREG

v_seek   = 'NUMREG'+PUB_ANNO+PUB_CODSOC
v_chiave = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
ELSE
   RIT=MSGBOX("Errore durante l'aggiornamento del numero di registrazione",'ATTENZIONE',31)
   RETURN
ENDIF
C_NUM=SUBSTR(LIBERA,1,10)
V_NUM=VAL(C_NUM)
T_NUM=V_NUM+1
TC_NUM=STR(T_NUM)
REPLACE LIBERA WITH ALLTRIM(TC_NUM)  
NREG=TC_NUM
X_NREG = NREG
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN



****************************************************************
FUNCTION VEDIFOR  && FUNZIONE PER DECODIFICA DELLA CONTROPARTITA
****************************************************************

PARA FG

SELE=SELECT()

** 1) ANAGRAFICA FORNITORI----------------------------------------------
x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_codi = "for_codcli = '" + ALLTRIM(FG) + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"CUR_FORNITORE")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORE
GO TOP   
IF !EOF()
   RET=FOR_CONTO1     
ELSE
   RET=""
ENDIF

IF EMPTY(RET)
   RET=V_ACS
ENDIF

** 2) VERIFICA SU PIANO DEI CONTI ESISTENZA CONTO : SI DA PER SCONTATO CHE IL CONTO AUTOMATICO
** DI DEFAULT ESISTA SU CONTI

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(RET) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(cSql,"cur_conti")
   return(.f.)
ENDIF
SELECT cur_conti
GO TOP
IF EOF()
   RET=V_ACS
ENDIF  

IF EMPTY(RET)
   RET=V_ACS
ENDIF

SELECT(SELE)

RETURN(RET)

  
*************************************************************
PROCEDURE REG_PARFOR    && AGGIORNAMENTO PARTITARIO FORNITORI                                  
*************************************************************

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
*x_codi = "for_codcli = '" + SUBSTR(CON,PUB_SOTTOG,9) + "'"
x_codi = "cli_codcli = '" + IIF(PUB_CONTOSIMILCEE, TRC(PUB_LCL,ALLTRIM(SUBSTR(CON,RAT('.',CON,1)+1))), ALLTRIM(SUBSTR(CON,PUB_SOTTOG,PUB_CONTO))) + "'"  && SERGIO - 18/12/2021
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"CUR_FORNITORE")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORE
GO TOP   
IF !EOF()
   V_TELEFO  = FOR_TELEFO
   V_PARIVA  = FOR_PARIVA 
   V_RAGSOC  = FOR_RAGSOC 
ELSE
   V_TELEFO  = SPACE(15)
   V_PARIVA  = SPACE(16) 
   V_RAGSOC  = "CLIENTE INESISTENTE"
ENDIF 

v_seek	 = "CPA"+V_CONPAG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   V_CONPAG  = "101"   && FORZATURA CPA CONTANTI
ENDIF 

IF !ExecCommand("select * from part_for where 0=1","cu_partfor")
   return(.f.)
ENDIF

SELECT CU_PARTFOR    
APPEND BLANK
REC_PART=RECNO()     
REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
REPLACE PAR_TIPODO  WITH "FAT"    
REPLACE PAR_TMOV    WITH "A"
REPLACE PAR_CODCLI  WITH CON
REPLACE PAR_RAGSOC  WITH V_RAGSOC
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE PAR_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE PAR_DTREG  WITH DATREG           
ENDIF
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTFAT  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTFAT  WITH DTD
ENDIF
REPLACE PAR_TIPFAT  WITH TOP
REPLACE PAR_TOTIM   WITH IMP - TIVA
REPLACE PAR_TIMPOS  WITH TIVA
REPLACE PAR_FATT    WITH IMP
REPLACE PAR_NUMFAT  WITH NDOC
REPLACE PAR_NPROG   WITH 100
REPLACE PAR_NPART   WITH VAL(NDOC)
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(NREG)     
REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)  
REPLACE PAR_CIVA1   WITH CIVA
REPLACE PAR_IMPO1   WITH IMP - TIVA
REPLACE PAR_IMPOS1  WITH TIVA
REPLACE PAR_TOT1    WITH IMP
REPLACE PAR_CIVA2   WITH "   "
REPLACE PAR_IMPO2   WITH 0
REPLACE PAR_IMPOS2  WITH 0
REPLACE PAR_TOT2    WITH 0
REPLACE PAR_CIVA3   WITH "   "
REPLACE PAR_IMPO3   WITH 0
REPLACE PAR_IMPOS3  WITH 0
REPLACE PAR_TOT3    WITH 0
REPLACE PAR_CIVA4   WITH "   "
REPLACE PAR_IMPO4   WITH 0
REPLACE PAR_IMPOS4  WITH 0
REPLACE PAR_TOT4    WITH 0
REPLACE PAR_CIVA5   WITH "   "
REPLACE PAR_IMPO5   WITH 0
REPLACE PAR_IMPOS5  WITH 0
REPLACE PAR_TOT5    WITH 0
IF SUBSTR(V_DTSCA,3,1) = '/'
   REPLACE PAR_DTSCAD  WITH RIBALTA2(V_DTSCA)	&& DT.SCAD DA FATTURA
ELSE
   REPLACE PAR_DTSCAD  WITH V_DTSCA				&& DT.SCAD DA FATTURA
ENDIF
REPLACE PAR_VALUTA WITH YVALUTA
REPLACE PAR_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTVAL  WITH DTD
ENDIF
REPLACE PAR_IMPVAL WITH IMP	          && VALORE IN VALUTA


SELECT CU_PARTFOR    
APPEND BLANK
REC_PART=RECNO()     
REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
REPLACE PAR_TIPODO  WITH "FAT"    
REPLACE PAR_TMOV    WITH "A"
REPLACE PAR_CODCLI  WITH CON
REPLACE PAR_RAGSOC  WITH V_RAGSOC
IF SUBSTR(DATREG,3,1) = '/'
   REPLACE PAR_DTREG  WITH RIBALTA2(DATREG)
ELSE
   REPLACE PAR_DTREG  WITH DATREG           
ENDIF
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTFAT  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTFAT  WITH DTD
ENDIF
REPLACE PAR_TIPFAT  WITH TOP
REPLACE PAR_TOTIM   WITH 0
REPLACE PAR_TIMPOS  WITH TIVA
REPLACE PAR_FATT    WITH IMP
REPLACE PAR_NUMFAT  WITH NDOC
REPLACE PAR_NPROG   WITH 200
REPLACE PAR_NPART   WITH VAL(NDOC)
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(NREG)     
REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)  
REPLACE PAR_CIVA1   WITH CIVA
REPLACE PAR_IMPO1   WITH IMP - TIVA
REPLACE PAR_IMPOS1  WITH TIVA
REPLACE PAR_TOT1    WITH IMP
REPLACE PAR_CIVA2   WITH "   "
REPLACE PAR_IMPO2   WITH 0
REPLACE PAR_IMPOS2  WITH 0
REPLACE PAR_TOT2    WITH 0
REPLACE PAR_CIVA3   WITH "   "
REPLACE PAR_IMPO3   WITH 0
REPLACE PAR_IMPOS3  WITH 0
REPLACE PAR_TOT3    WITH 0
REPLACE PAR_CIVA4   WITH "   "
REPLACE PAR_IMPO4   WITH 0
REPLACE PAR_IMPOS4  WITH 0
REPLACE PAR_TOT4    WITH 0
REPLACE PAR_CIVA5   WITH "   "
REPLACE PAR_IMPO5   WITH 0
REPLACE PAR_IMPOS5  WITH 0
REPLACE PAR_TOT5    WITH 0
IF SUBSTR(V_DTSCA,3,1) = '/'
   REPLACE PAR_DTSCAD  WITH RIBALTA2(V_DTSCA) && DT.SCAD DA FATTURA
ELSE
   REPLACE PAR_DTSCAD  WITH V_DTSCA           && DT.SCAD DA FATTURA       
ENDIF
REPLACE PAR_VALUTA WITH YVALUTA
REPLACE PAR_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTVAL  WITH DTD
ENDIF
REPLACE PAR_IMPVAL WITH IMP	          && VALORE IN VALUTA

IF !ExecRW('','part_for','I','','CU_PARTFOR')
   return(.f.)
ENDIF

RETURN




