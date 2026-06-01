**************************************************************************************************************
* 			 TRASFERIMENTO IN CO.GE. DELLE RITENUTE D'ACCONTO           								 *
**************************************************************************************************************


PUBLIC PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,XDESF,V_CODCLI,DATA_SCAD,CT,V_SEQUEN
XDESF     = "REGISTRAZIONE AUTOMATICA"
COMPENSO  = 0
TIVA      = 0
CIVA      = 0
TOP_TOP   = SPACE(03)
DATA_SCAD = ""
V_SEQUEN  = 0

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

***CERCA PRIMI 4/5 CARATTERI DEL CONTO PER IL FORNITORE
v_seek	 = 'GEN'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro GEN 4/5 caratteri conti clienti"
   RETURN
ENDIF
CC=SUBSTR(LIBERA,1,PUB_SOTTOG-1)
FF=SUBSTR(LIBERA,18,PUB_SOTTOG-1)

v_seek	 = 'CTB'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro CTB conto banca"
   RETURN
ENDIF
V_CTB=SUBSTR(LIBERA,1,13)

v_seek	 = 'CTE'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro CTE conto erario ritenuta"
   RETURN
ENDIF
V_CTE = SUBSTR(LIBERA,1,13)

DATREG    = XDATA      && FORZA LA DATA DI REGISTRAZIONE CON LA DATA DIGITATA
CTRELAB   = 0
CT        = 0
PERDAL    = RIBALTA2(DATADAL)
PERAL     = RIBALTA2(DATAAL)
X_ANNODA  = SUBSTR(DATADAL,7,4)
X_MESEDA  = SUBSTR(DATADAL,4,2)
X_ANNOAL  = SUBSTR(DATAAL,7,4)
X_MESEAL  = SUBSTR(DATAAL,4,2)
V_PERI_DA = X_ANNODA + "/" + X_MESEDA
V_PERI_AL = X_ANNOAL + "/" + X_MESEAL

x_soci = "PER_CODSOC = '" + PUB_CODSOC + "'"
x_anno = "PER_ANNO >= '" + X_ANNODA + "'"
x_mese = "PER_MESE >= '" + X_MESEDA + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_mese

cSql = "SELECT * FROM U_PER_CO WHERE " + x_cond + " order by per_codsoc,per_anno,per_mese,per_codpdv,per_codice,per_tipcon"
IF !ExecRW(cSql,"U_PER_CO","R")
   return(.f.)
ENDIF

SELECT U_PER_CO
GO TOP
IF EOF()
   =MESSAGEBOX("Nessun compenso da elaborare",16,"Attenzione")
   THISFORM.TXTCMAGDA.SETFOCUS
   RETURN
ENDIF   

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF CT = 1
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF PER_PAGATO				&& elabora solo i compensi già pagati
   ELSE
      SKIP +1
      LOOP
   ENDIF  

   IF PER_COGE					&& elabora solo i compensi non ancora trasmessi in co.ge.
      SKIP +1
      LOOP
   ENDIF  
   
   V_PERIODO = PER_ANNO + "/" + PER_MESE

   IF V_PERIODO < V_PERI_DA		&& elabora solo i compensi compresi nel periodo digitato 
      SKIP +1
      LOOP
   ENDIF  

   IF V_PERIODO > V_PERI_AL		&& Testa il fine elaborazione
      EXIT 
   ENDIF  
   
   SCATTER MEMVAR

   x_soci = "PER_CODSOC = '" + PUB_CODSOC + "'"
   x_codi = "PER_CODICE = '" + ALLTRIM(M.PER_CODICE) + "'"
   x_cond = x_soci + " and " + x_codi
   cSql   = "SELECT * FROM U_PER_AN WHERE " + x_cond 
   IF !ExecCommand(cSql,"CU_PER_AN")
      return(.f.)
   ENDIF
   SELECT CU_PER_AN
   GO TOP
   IF EOF()
      SELECT U_PER_CO
      SKIP +1
      LOOP
   ENDIF
   
   CTRELAB = CTRELAB + 1 
   WAIT WINDOW  "Compensi Elaborati "+STR(CTRELAB,6,0) NOWAIT

   ****DATI DI TESTATA DELLA SINGOLA FATTURA ****
 
   V_CODFOR = PER_CONTO
   XDESF    = PER_RAGSOC
   XVALUTA  = PUB_VALU
   XCAMBIO  = 1
   TOP_TOP  = 'RIT'            

   v_seek	= 'TOP' + TOP_TOP
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
   ELSE
      WAIT WINDOW "Errore manca parametro TOP : " + TOP_TOP
      TOP_TOP = "RIT"
   ENDIF
    
   ****SCRIVO I MOVIMENTI / SALDI / PARTITARI ***
 
   DO REG_NUMRPN

   DO REG_NUMREG

   SELECT U_PER_CO

   DAVD      = "D"
   DAVA      = "A"
   V_RITACC  = PER_RITENU
   M.CONTO	 = V_CODFOR
   M.DOC	 = '999'
   IF PER_MESE = '04' .OR. PER_MESE = '06' .OR. PER_MESE = '09' .OR. PER_MESE = '11'
      M.DTD	 = RIBALTA2(V_PERIODO + "/" + '30')
   ELSE
      IF PER_MESE = '02'
         M.DTD	 = RIBALTA2(V_PERIODO + "/" + '28')
      ELSE
         M.DTD	 = RIBALTA2(V_PERIODO + "/" + '31')
      ENDIF    
   ENDIF
   M.OLFAT	 = '999'
   M.CCAGE   = SPACE(03)
   DATREG	 = XDATA        && FORZA LA DATA DI REGISTRAZIONE CON LA DATA DIGITATA
   M.RAGSOC  = PER_RAGSOC
   V_CONPAG  = " "
   
   V_DTSCA  = M.DTD
   _NAZ     = PUB_NAZI
   _ALRID   = "20"
   _ESENZI  = .F.				

   ** >>> CONTROLLI INCROCIATI SU VALORE RICALCOLATO E TOTALE FATTURA
    
   OLD_DESF  = XDESF
   XDESF     = "COLL. : " + ALLTRIM(M.CONTO) + " COMPENSO DEL " + V_PERIODO
   
   V_CTE     = "22660" + ALLTRIM(PER_CODPDV) + "00"
   
   V_SEQUEN  = 0

   DO movcreat WITH DAVD,V_RITACC,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO	&&TESTATA
   DO movcreai WITH DAVD,V_RITACC,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO	&&INDICE
   DO movcrea  WITH DAVA,V_RITACC,0,'NO',V_CTE,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO		&&BANCA
  
   SELECT U_PER_CO
   REPLACE PER_COGE WITH .T.
 
   CT = CT +1
   SKIP +1

ENDDO

IF !ExecRW(Csql,"U_PER_CO","W")
   return(.f.)
ENDIF

RELEASE WINDOW DISPLAY

WAIT WINDOWS 'Elaborate n. '+str(CT,5,0)+' Compensi'+CHR(13)
WAIT WINDOWS 'Elaborazione completata ...' NOWAIT

=MESSAGEBOX("Trasferimento ritenute d'acconto in co.ge. terminato correttamente",62,"ATTENZIONE")

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
REPLACE MOV_NPROT  WITH ALLTRIM(NPRO)
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
V_SEQUEN = V_SEQUEN + 10
REPLACE MOV_SEQUEN WITH V_SEQUEN
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
REPLACE MOV_NPROT  WITH ALLTRIM(NPRO)
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
REPLACE MOV_NPROT  WITH ALLTRIM(NPRO)
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
V_SEQUEN = V_SEQUEN + 10
REPLACE MOV_SEQUEN WITH V_SEQUEN
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


*************************************************************
PROCEDURE REG_PARFOR    && AGGIORNAMENTO PARTITARIO FORNITORI                                  
*************************************************************

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_codi = "for_codcli = '" + SUBSTR(CON,PUB_SOTTOG,9) + "'"
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
   V_RAGSOC  = "FORNITORE INESISTENTE"
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
REPLACE PAR_TIPODO  WITH "PAG"    
REPLACE PAR_TMOV    WITH "D"
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
REPLACE PAR_TOTIM   WITH IMP 
REPLACE PAR_TIMPOS  WITH 0
REPLACE PAR_FATT    WITH IMP
REPLACE PAR_NUMFAT  WITH NDOC
REPLACE PAR_NPROG   WITH 900
REPLACE PAR_NPART   WITH VAL(NDOC)
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(NREG)     
REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)  
REPLACE PAR_CIVA1   WITH "NO"
REPLACE PAR_IMPO1   WITH 0
REPLACE PAR_IMPOS1  WITH 0
REPLACE PAR_TOT1    WITH 0
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
IF !ExecRW('','part_for','I','','CU_PARTFOR')
   return(.f.)
ENDIF

RETURN





