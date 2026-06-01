**************************************************************************************
*  TRASFERIMENTO IN CONTABILITA GENERALE DELLE RICEVUTE MANUALI CLIENTI         	 *
*																					 *
*																					 *
*	NOTE  TECNICHE :	PER MOTIVI DI CONVERSIONE DATI 								 *
*						SE NON TROVA LE CONDIZIONI DI PAGAMENTO						 *
*						IN ANAGRAFICA FORZA IL CODICE 101 CONTANTI	 				 *
*																	 				 *
*																					 *
**************************************************************************************
PUBLIC PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG
COMPENSO = 0
TIVA     = 0
CIVA     = 0
TOP_TOP  = SPACE(03)

IF !ExecCommand("select * from u_rim_dd where 0=1","u_rim_dd")
   return(.f.)
ENDIF
SELECT U_RIM_DD
RRDD=AFIELDS(RD)
CREATE CURSOR RIC_DD FROM ARRAY RD

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

CREATE CURSOR W_FAT (W_CONTO C(13),W_DA C(1),W_IVA C(3), ;
        W_IMPONI N(17,3) ,W_IMPOSTA N(17,3),W_PUBBLI N(17,3)  ,W_NUMDOC C(10),W_DTDOC C(10))
        
SELECT W_FAT        
INDEX ON W_CONTO+ W_DA + W_IVA TAG DETTA
SET ORDER TO DETTA
SET NEAR ON
SET EXACT OFF

***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE
v_seek	 = 'GEN'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro GEN 4 caratteri conti clienti"
   RETURN
ENDIF
CC=SUBSTR(LIBERA,1,4)

CT      = 0
CTRELAB = 0

******************************* GESTIONE RICEVUTE BANCARIE ******************

DATREG = XDATA      && FORZA LA DATA DI REGISTRAZIONE CON LA DATA DIGITATA
PERDAL  = RIBALTA2(DATADAL)
PERAL   = RIBALTA2(DATAAL)
CTRELAB = 0
XSD     = 0

             
x_soci = "ric_codsoc = '" + PUB_CODSOC + "'"
x_data = "ric_dtfatt >= '" + PERDAL + "'"
x_cond = x_soci + " and " + x_data
Csql = "select * from u_rim_tt where " + x_cond + " order by ric_codsoc,ric_dtfatt"
IF !ExecRW(Csql,"U_RIM_TT","R")
   return(.f.)
ENDIF
SELECT U_RIM_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   IF RIC_CGE
      SKIP +1
      LOOP
   ENDIF  

   IF RIC_DTFATT > PERAL
      SKIP +1
      LOOP
   ENDIF  

   CTRELAB=CTRELAB+1 
   WAIT WINDOW  "Ricevute Elaborate "+STR(CTRELAB,6,0) NOWAIT

   DO REG_NUMRPN
   DO REG_NUMREG

   SELECT U_RIM_TT
   WGAN = TAGGANCIO
   RIC  = SELECT()

*!*	   x_agga = "daggancio = '" + ALLTRIM(WGAN) + "'"
*!*	   x_cond = x_agga
*!*	   Csql   = "select * from u_rim_dd where " + x_cond + " order by daggancio"
*!*	   IF !ExecCommand(Csql,"RIC_DD")
*!*	      return(.f.)
*!*	   ENDIF
*!*	   SELECT RIC_DD
*!*	   GO TOP

   SELECT U_RIM_TT

   DD_TOP=RIC_TOP

   v_seek	= 'TOP' + DD_TOP
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
   ELSE
      WAIT WINDOW "Errore manca parametro TOP"
      RETURN
   ENDIF

   XXCONTO = CONTO1
   IF EMPTY(CONTO1)
      WAIT WINDOW "Errore manca conto nel parametro TOP : "+DD_TOP
      RETURN
   ENDIF

   SELECT U_RIM_TT
  
   V_CODCLI = RIC_CODCLI
   KCON     = CC+RIC_CODCLI
 
   x_soci   = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi   = "cli_codcli = '" + ALLTRIM(V_CODCLI) + "'"
   x_cond   = x_soci + " and " + x_codi
   Csql     = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"cur_cliente")
      return(.f.)
   ENDIF
   SELECT cur_cliente
   GO TOP
   IF !EOF()
      V_NAZION  = CLI_NAZION
   ELSE
      V_NAZION  = SPACE(03)
   ENDIF 

   V_ER=SOTTOGEN(V_NAZION)
   IF !V_ER
	  CC = PUB_CC
   ENDIF 
 
   SELECT U_RIM_TT
  
   M.CONTO  = CC+RIC_CODCLI
   XCON     = CC+RIC_CODCLI
   M.DTD    = RIC_DTFATT
   M.DOC    = RIC_NFATT
   M.OLFAT  = RIC_NFATT
   M.RAGSOC = RIC_RAGSOC
   V_TOTALE = RIC_TOTFAT
   M.NUMASS = ""
   M.BANCA  = RIC_BACLI
   DATA_PAGA= RIC_DTSCAD  
   AGENTE   = "   "      && SUBSTR(CLI_AGE,1,3)
   XCLI_COD = RIC_CODCLI
   XXCODAGE = "   "      
   TOP_TOP  = RIC_TOP    
   XVALUTA  = RIC_VALUTA
   XCAMBIO  = RIC_CAMBIO 
   V_CONPAG = "101"               
   CIVA     = "NO" 
   TIVA     = 0
   XNOTA    = RIC_NOTE
   DAVD     = "A"

   ** CREA MOVIMENTO IN AVERE SU CLIENTE  
   DO MOVCRINC WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,.T.,M.OLFAT,XVALUTA,XCAMBIO   &&TESTATA
   DO MOVCREAI WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO       &&INDICE
   ** CREA MOVIMENTO IN DARE SU PORTAFOGLIO EFFETTI
   DO MOVCRINC WITH "D",V_TOTALE,0,'NO',XXCONTO,TOP_TOP,M.DOC,M.DTD,.F.,M.OLFAT,XVALUTA,XCAMBIO    &&DETTAGLI
          
   SELECT U_RIM_TT
  
   REPLACE RIC_CGE WITH .T.
  
   XSD = XSD +1
   SKIP +1

ENDDO

IF !ExecRW(Csql,"U_RIM_TT","W")
   return(.f.)
ENDIF

WAIT WINDOWS 'Elaborati n. '+str(XSD,5,0)+' Ricevute Mnuali' 
WAIT WINDOWS 'Elaborazione completata ...' NOWAIT

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


***************************************************************************
PROCEDURE movcreai      && crea la partita primaria SU INDICE
***************************************************************************
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
REPLACE MOV_DESMOV WITH XNOTA
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


***************************************************************************
PROCEDURE MOVCRINC      && crea la partita primaria e il partitario clienti
***************************************************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,PARTITARIO,NPRO,YVALUTA,YCAMBIO

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
REPLACE MOV_DESMOV WITH XNOTA
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
   P_IMPA= CON_IMP_A
   P_IMPD= CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
      REPLACE   CON_IMP_D   WITH P_IMPD+IMP
      REPLACE   &VAR2       WITH IMP+&VAR2
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA+IMP
      REPLACE   &VAR        WITH IMP+&VAR
   ENDIF
ELSE
   APPEND BLANK
   REPLACE CON_SOC    WITH PUB_CODSOC
   REPLACE CON_ANNO   WITH PUB_ANNO
   REPLACE CON_CONTO  WITH CON
   REPLACE CON_DESCR  WITH M.RAGSOC
   REPLACE CON_TIPOCO WITH "C"
   REPLACE CON_POSBIL WITH "P"
   REPLACE CON_IVASN  WITH .F. 
   P_IMPA = CON_IMP_A
   P_IMPD = CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
	  REPLACE   CON_IMP_D   WITH P_IMPD+IMP
      REPLACE   &VAR2       WITH IMP+&VAR2
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA+IMP
      REPLACE   &VAR        WITH IMP+&VAR
   ENDIF
ENDIF 
IF !ExecRW(cSql,"conti","W")
   return(.f.)
ENDIF

IF PARTITARIO
   DO RED_PARINC    && AGGIORNA PARTITARIO CLIENTI
ENDIF  
 
SELECT(SELE)

RETURN


************************************************************************* 
*   AGGIORNAMENTO PARTITARIO CLIENTI                                    *
************************************************************************* 
PROCEDURE RED_PARINC


x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
*x_codi = "cli_codcli = '" + SUBSTR(CON,PUB_SOTTOG,9) + "'"
x_codi = "cli_codcli = '" + IIF(PUB_CONTOSIMILCEE, TRC(PUB_LCL,ALLTRIM(SUBSTR(CON,RAT('.',CON,1)+1))), ALLTRIM(SUBSTR(CON,PUB_SOTTOG,PUB_CONTO))) + "'"  && SERGIO - 18/12/2021
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP   
IF !EOF()
   V_TELEFO  = CLI_TELEFO
   V_PARIVA  = CLI_PARIVA 
   V_RAGSOC  = CLI_RAGSOC 
   V_CODAGE  = CLI_AGE
ELSE
   V_TELEFO  = SPACE(15)
   V_PARIVA  = SPACE(16) 
   V_RAGSOC  = "CLIENTE INESISTENTE"
   V_CODAGE  = "   "
ENDIF 

v_seek	 = "CPA"+V_CONPAG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   V_CONPAG  = "101"   && FORZATURA CPA CONTANTI
ENDIF 

IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
   return(.f.)
ENDIF


   M.ORD_NPROT = SPACE(06)
   v_seek  = 'NUMPRC'+PUB_CODSOC
   v_chiave= "codice"
   cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
   IF !ExecRW(cSql,"PARA","R")
      return(.f.)
   ENDIF
   SELECT PARA
   IF RECCOUNT() <> 0
	  V2=VAL(SUBSTR(LIBERA,1,7)) + 1
	  REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
	  M.ORD_NPROT = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
   ELSE
      RIT = MSGBOX('Parametro numero protocollo non trovato','ATTENZIONE',31)
 	  RETURN
   ENDIF
   IF !ExecRW(cSql,"PARA","W")
      return(.f.)
   ENDIF
  

   SELECT CU_PARTCLI
   APPEND BLANK
   REC_PART=RECNO()     
   REPLACE PAR_CODSOC  WITH PUB_CODSOC
   REPLACE PAR_ANNO    WITH PUB_ANNO
   REPLACE PAR_TIPODO  WITH "PAG"
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
   IF SUBSTR(DATA_PAGA,3,1) = '/'
      REPLACE PAR_DTSCAD  WITH RIBALTA2(DATA_PAGA)
      REPLACE PAR_DATPAG  WITH RIBALTA2(DATA_PAGA)
   ELSE
      REPLACE PAR_DTSCAD  WITH DATA_PAGA          
      REPLACE PAR_DATPAG  WITH DATA_PAGA
   ENDIF
   REPLACE PAR_TIPFAT  WITH TOP
   REPLACE PAR_NPROT   WITH NPRO               && NUMERO DI FATTURA AGENTE
   REPLACE PAR_TOTIM   WITH IMP
   REPLACE PAR_TIMPOS  WITH TIVA
   REPLACE PAR_FATT    WITH IMP
   REPLACE PAR_NUMFAT  WITH ALLTRIM(M.ORD_NPROT) &&NDOC
   REPLACE PAR_NPROG   WITH 900
   REPLACE PAR_NPART   WITH VAL(M.ORD_NPROT)   &&VAL(NDOC)        
   REPLACE PAR_CODPAG  WITH V_CONPAG
   REPLACE PAR_TEL     WITH V_TELEFO
   REPLACE PAR_IVA     WITH V_PARIVA
   REPLACE PAR_NREG    WITH ALLTRIM(NREG)     
   REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)  
   REPLACE PAR_CIVA1   WITH CIVA
   REPLACE PAR_IMPO1   WITH IMP
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
   REPLACE PAR_VALUTA  WITH YVALUTA
   REPLACE PAR_CAMBIO  WITH YCAMBIO
   REPLACE PAR_DTVAL   WITH DTD
   REPLACE PAR_IMPVAL  WITH 0	          && VALORE IN VALUTA


IF !ExecRW('','part_cli','I','','CU_PARTCLI')
   return(.f.)
ENDIF

*!*	2008-05-30 SERGIO/SIMONE - NO SALDI
*!*	=CREA_SALDI_CF("C",CON,ALLTRIM(M.ORD_NPROT),"XXXXXXXXXX","CREA")


RETURN
