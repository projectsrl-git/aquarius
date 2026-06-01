**************************************************************************************
*  TRASFERIMENTO IN CONTABILITA GENERALE DELLE FATTURE CLIENTI 				      	 *
*																					 *
*																					 *
*	GESTIRE I SALDI CLIENTI SALDI_CLI												 *
*																					 *
**************************************************************************************
PUBLIC PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,V_CONTRO,XSD
COMPENSO = 0
TIVA     = 0
CIVA     = 0
TOP_TOP  = SPACE(03)
XSD      = 0

PUBLIC DATA_SCAD,TOP_CONT
DATA_SCAD = ""
TOP_CONT  = ""

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

CREATE CURSOR W_FAT (W_CONTO C(13),W_DA C(1),W_IVA C(3), ;
        W_IMPONI N(13) ,W_IMPOSTA N(13),W_PUBBLI N(13)  ,W_NUMDOC C(10),W_DTDOC C(10))
        
SELECT W_FAT        
INDEX ON W_CONTO+ W_DA + W_IVA TAG DETTA
SET ORDER TO DETTA

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

v_seek	 = 'CMV'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro CMV conto vendita merce"
   RETURN
ENDIF
V_CMV=SUBSTR(LIBERA,1,13)

v_seek	 = 'CAS'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   WAIT WINDOW "Errore manca parametro CAS conto cassa"
   RETURN
ENDIF
V_CODCASSA=SUBSTR(LIBERA,1,13)
 
v_seek	 = 'IVA'+PUB_IVA
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   CON_IVA=ALLTRIM(SUBSTR(LIBERA,5,13))             && CONTO IVA CLIENTI
ELSE
   WAIT WINDOW "Errore manca conto iva generale = " + pub_iva
   RETURN
ENDIF

CT       = 0
CTRELAB  = 0
PERDAL   = RIBALTA2(DATADAL)
PERAL    = RIBALTA2(DATAAL)
DATREG   = XDATA      && FORZA LA DATA DI REGISTRAZIONE CON LA DATA DIGITATA

******************************* GESTIONE INCASSI DA AGENTI ******************
x_data = "cli_dtpag >= '" + PERDAL + "'"
x_cond = x_data
Csql   = "select * from u_cli_op where " + x_cond + " order by cli_dtpag"
IF !ExecRW(Csql,"U_CLI_OP","R")
   return(.f.)
ENDIF
SELECT U_CLI_OP
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   IF CLI_DTPAG > PERAL
      EXIT
   ENDIF

   IF CLI_OPE="FAT" 
      SKIP +1
      LOOP
   ENDIF  

   IF CLI_CGE
      SKIP +1
      LOOP
   ENDIF

   IF AGEDAL  <> "999"
	  IF VAL(CLI_AGE) <> VAL(AGEDAL)
 	     SKIP +1
	     LOOP
	  ENDIF
   ENDIF

   CTRELAB=CTRELAB+1 
   WAIT WINDOW  "Incassi Elaborati"+STR(CTRELAB,6,0) NOWAIT

   DO REG_NUMRPN
   DO REG_NUMREG
  
   SELECT U_CLI_OP

   V_CODCLI = CLI_COD
   KCON     = CC+CLI_COD
   
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
      V_CONTRO  = CLI_CONTO1
   ELSE
      V_NAZION  = SPACE(03)
      V_CONTRO  = V_CODCASSA
   ENDIF 

   V_ER=SOTTOGEN(V_NAZION)
   IF !V_ER
	  CC = PUB_CC
   ENDIF 
 
   SELECT U_CLI_OP
  
   M.CONTO  = CC+CLI_COD
   XCON     = CC+CLI_COD
   M.DTD    = CLI_DTFAT
   IF SUBSTR(M.DTD,3,1) = '/'
   ELSE
      M.DTD = RIBALTA2(M.DTD)
   ENDIF
   M.DOC    = SUBSTR(CLI_NFAT,1,6)
   M.OLFAT  = SUBSTR(CLI_NFAT,1,6)
   M.RAGSOC = CLI_DESCRI
   DAVD     = "A"
   XVALUTA  = PUB_VALRIF				&& FORZATURA IN BASE A VALUTA DI RIFERIMENTO
   XCAMBIO  = 1
   V_TOTALE = CAMBIO(XVALUTA,CLI_INCA,XCAMBIO)
   M.NUMASS = CLI_NASS
   M.BANCA  = CLI_BANCA
   DATA_PAGA= CLI_DTPAG  
   AGENTE   = SUBSTR(CLI_AGE,1,3)
   XCLI_COD = CLI_COD
   XXCODAGE = CLI_AGE
   TOP_TOP  = "PDV"
   V_CONPAG = "101"               
   CIVA     = "NO" 
   TIVA     = 0

   x_soci   = "ord_codsoc = '" + PUB_CODSOC + "'"
   x_agen   = "ord_age = '" + ALLTRIM(AGENTE) + "'"
   x_anno   = "ord_anno = '" + SUBSTR(M.DTD,7,4) + "'"
   x_nord   = "ord_numord = '" + ALLTRIM(M.DOC) + "'"
   x_clie   = "ord_codcli = '" + ALLTRIM(XCLI_COD) + "'"
   x_data   = "ord_datord = '" + RIBALTA2(M.DTD) + "'"
   x_cond   = x_soci + " and " + x_agen + " and " + x_anno + " and " + x_nord + " and " + x_clie + " and " + x_data
   Csql     = "select * from u_fat_tt where " + x_cond + " order by ord_codsoc,ord_age,ord_anno,ord_numord,ord_codcli,ord_datord"
   IF !ExecCommand(cSql,"u_fat_tt")
      return(.f.)
   ENDIF
   SELECT u_fat_tt
   GO TOP
   IF !EOF()
 	  M.DOC		= ORD_NPROT       && FORZA NUMERO PROTOCOLLO
	  M.OLFAT	= ORD_NUMORD
	  IF EMPTY(M.DOC)
		 M.DOC	= ORD_NUMORD
	  ENDIF
   ENDIF

   XXCONTO = V_CONTRO
   IF EMPTY(XXCONTO)
	  =MESSAGEBOX("Conto contabile mancante in anagrafica agente : "+XXCODAGE,62,"ATTENZIONE")
	  RETURN
   ENDIF
  
   SELECT U_CLI_OP
    
   DO MOVCRINC WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,.T.,M.OLFAT,XVALUTA,XCAMBIO  &&TESTATA
   DO MOVCREAI WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO      &&INDICE
   DO MOVCRINC WITH "D",V_TOTALE,0,'NO',XXCONTO,TOP_TOP,M.DOC,M.DTD,.F.,M.OLFAT,XVALUTA,XCAMBIO   &&DETTAGLI
          
   SELECT U_CLI_OP
  
   REPLACE CLI_CGE WITH .T.
  
   XSD = XSD +1
   SKIP +1

ENDDO

IF !ExecRW(Csql,"U_CLI_OP","W")
   return(.f.)
ENDIF

WAIT WINDOWS 'Elaborati n. '+str(XSD,5,0)+' Incassi' 
WAIT WINDOWS 'Elaborazione completata ...' NOWAIT

=MESSAGEBOX("Trasferimento incassi agenti in contabilità terminato correttamente",62,"ATTENZIONE")

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
IF !EMPTY(M.NUMASS)
   REPLACE MOV_DESMOV WITH "I.FT:"+ALLTRIM(NPRO)+" CL: "+ALLTRIM(SUBSTR(XCON,5,9))+" AS:"+ALLTRIM(M.NUMASS)+" BA:"+ALLTRIM(M.BANCA)
ELSE
   REPLACE MOV_DESMOV WITH "I.FT:"+ALLTRIM(NPRO)+" CL: "+ALLTRIM(SUBSTR(XCON,5,9))
ENDIF 
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


*****************
PROCEDURE CALCIVA
*****************
SELECT W_FAT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   VALIVA	 = W_IMPONI * IVAREAL(W_IVA)
   TIVA  	 = TIVA + VALIVA
   CIVA  	 = W_IVA
   REPLACE W_IMPOSTA WITH VALIVA
   V_TOTALE	 = V_TOTALE + VALIVA	
   SKIP +1
ENDDO

RETURN


*****************
FUNCTION IVAREAL
*****************
PARA FG
SELE=SELECT()
RET = 0

v_seek	 = 'IVA'+FG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   =MSGBOX('Iva non trovata '+FG,'ATTENZIONE',31)
   LIB=0
ENDIF
LIB=VAL(SUBSTR(LIBERA,1,3))
RET=LIB/100

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
*  REPLACE LIBERA WITH ALLTRIM(PN_C)  
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
C_NUM  = SUBSTR(LIBERA,1,10)
V_NUM  = VAL(C_NUM)
T_NUM  = V_NUM+1
TC_NUM = STR(T_NUM)
REPLACE LIBERA WITH ALLTRIM(TC_NUM)  
NREG   = TC_NUM
X_NREG = NREG
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN


***********************************************
FUNCTION VEDIART
***********************************************

*** FUNZIONE PER DECODIFICA DELLA CONTROPARTITA
PARA FG

SELE=SELECT()

** 1) ANAGRAFICA ARTICOLI --------------------------------------------
x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(FG) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
IF !ExecCommand(cSql,"cur_articoli")
   return(.f.)
ENDIF
SELECT cur_articoli
GO TOP
IF !EOF()
   IF EMPTY(ART_CGE)
 	  RET=V_CMV
   ELSE
      RET=ART_CGE
   ENDIF   
ELSE
   RET=V_CMV
ENDIF

SELECT(SELE)

RETURN(RET)


*************************
PROCEDURE PAROLA
*************************
 
DO WHILE .T.
   IS=IS + 1
   CARATT = SUBSTR(V_TUTTO,IS,1)
   IF !EMPTY(CARATT)
      XPAROLA = XPAROLA + SUBSTR(V_TUTTO,IS,1) 
   ELSE
      EXIT      
   ENDIF
ENDDO 
     
RETURN
 

*************************
PROCEDURE PERINC
*************************
  
CONTA_TRA = 0  
** RICERCA IMPORTO TRANCHE
IS=0
XPAROLA = '' 
DO PAROLA 
IMP_TRANK=INT(VAL(XPAROLA))
  
DO WHILE .T.
   CONTA_TRA = CONTA_TRA + 1 
   * CNT IDENTIFICA IL NUMERO DI TRANCHE DETERMINATO DA TRANCHE 
   IF CONTA_TRA > CNT
      RETURN
   ENDIF
   IF CONTA_TRA = CNT
      IMP_TRANK = IMP_TRANK + COMPENSO
   ENDIF   
   ** RICERCA DATA SCADENZA
   XPAROLA = '' 
   DO PAROLA 
   DATA_SCAD=XPAROLA
   IF NOTAC  <> "S"      && NON CREA I PERIODI PER NOTE CREDITO
      DO CREA_INC 
   ENDIF
ENDDO 

RETURN


*************************
PROCEDURE CREA_INC
*************************
 
** ===>>> CREA I PERIODI DI SCADENZA
    
IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
   return(.f.)
ENDIF
SELECT CU_PARTCLI
APPEND BLANK
REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
REPLACE PAR_TIPODO  WITH "INC"
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
IF SUBSTR(DATA_SCAD,3,1) = '/'
   REPLACE PAR_DTSCAD  WITH RIBALTA2(DATA_SCAD) && DT.SCAD DA FATTURA
ELSE
   REPLACE PAR_DTSCAD  WITH DATA_SCAD           && DT.SCAD DA FATTURA
ENDIF
REPLACE PAR_TOTIM   WITH 0
REPLACE PAR_TIMPOS  WITH 0
REPLACE PAR_FATT    WITH IMP_TRANK
REPLACE PAR_NUMFAT  WITH NDOC
XPRG = CONTA_TRA * 100
REPLACE PAR_NPROG   WITH XPRG + 100 
REPLACE PAR_NPART   WITH VAL(NDOC)
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(NREG)     
REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)  
REPLACE PAR_CIVA1   WITH CIVA
REPLACE PAR_IMPO1   WITH (IMP - TIVA)
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
REPLACE PAR_VALUTA WITH YVALUTA
REPLACE PAR_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTVAL  WITH DTD
ENDIF
REPLACE PAR_IMPVAL WITH IMP_TRANK          && VALORE IN VALUTA
IF !ExecRW('','part_cli','I','','CU_PARTCLI')
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
IF !EMPTY(M.NUMASS)
   REPLACE MOV_DESMOV WITH "I.FT:"+ALLTRIM(NPRO)+" CL: "+ALLTRIM(SUBSTR(XCON,5,9))+" AS:"+ALLTRIM(M.NUMASS)+" BA:"+ALLTRIM(M.BANCA)
ELSE
   REPLACE MOV_DESMOV WITH "I.FT:"+ALLTRIM(NPRO)+" CL: "+ALLTRIM(SUBSTR(XCON,5,9))
ENDIF 
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
	  REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR2       WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR2
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH CAMBIO(YVALUTA,IMP,YCAMBIO)+&VAR
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

IF PARTITARIO
   DO REG_PARINC    && AGGIORNA PARTITARIO CLIENTI
ENDIF  
 
SELECT(SELE)
RETURN

*************************************************
PROCEDURE REG_PARINC
*************************************************

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
   V_CONPAG  = CLI_CONPAG
   V_TELEFO  = CLI_TELEFO
   V_PARIVA  = CLI_PARIVA 
   V_RAGSOC  = CLI_RAGSOC 
ELSE
   V_CONPAG  = "001"
   V_TELEFO  = SPACE(15)
   V_PARIVA  = SPACE(16) 
   V_RAGSOC  = "CLIENTE INESISTENTE"
ENDIF 
 
v_seek	 = "CPA"+V_CONPAG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   V_CONPAG  = PUB_CPA   && FORZATURA CPA CONTANTI
ENDIF
  
IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
   return(.f.)
ENDIF
SELECT CU_PARTCLI
APPEND BLANK
REC_PART=RECNO()     
REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
REPLACE PAR_TIPODO  WITH "INC"
REPLACE PAR_TMOV    WITH "A"
REPLACE PAR_NPROT   WITH NPRO               && NUMERO DI FATTURA AGENTE
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
REPLACE PAR_TOTIM   WITH (IMP - TIVA)
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
REPLACE PAR_IMPO1   WITH (IMP - TIVA)
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
IF SUBSTR(DATA_PAGA,3,1) = '/'
   REPLACE PAR_DATPAG  WITH RIBALTA2(DATA_PAGA) 
ELSE
   REPLACE PAR_DATPAG  WITH DATA_PAGA           
ENDIF
REPLACE PAR_VALUTA WITH YVALUTA
REPLACE PAR_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTVAL  WITH DTD
ENDIF
REPLACE PAR_IMPVAL WITH IMP	          && VALORE IN VALUTA
IF !ExecRW('','part_cli','I','','CU_PARTCLI')
   return(.f.)
ENDIF
   
DO CREA_PERINC
 
RETURN


*************************
PROCEDURE CREA_PERINC
*************************

** ===>>> CREA I PERIODI DI SCADENZA
    
IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
   return(.f.)
ENDIF
SELECT CU_PARTCLI
APPEND BLANK
REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
REPLACE PAR_TIPODO  WITH "INC"
REPLACE PAR_TMOV    WITH  "A"
REPLACE PAR_NPROT   WITH NPRO               && NUMERO DI FATTURA AGENTE
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
REPLACE PAR_TIMPOS  WITH 0
REPLACE PAR_FATT    WITH (IMP - TIVA)
REPLACE PAR_NUMFAT  WITH NDOC
REPLACE PAR_NPROG   WITH 200
REPLACE PAR_NPART   WITH VAL(NDOC)
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(NREG)     
REPLACE PAR_NUMPRO  WITH ALLTRIM(PN_C)  
REPLACE PAR_CIVA1   WITH CIVA
REPLACE PAR_IMPO1   WITH (IMP - TIVA)
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
IF SUBSTR(DATA_SCAD,3,1) = '/'
   REPLACE PAR_DATPAG  WITH RIBALTA2(DATA_SCAD) && DT.SCAD DA FATTURA
ELSE
   REPLACE PAR_DATPAG  WITH DATA_SCAD           && DT.SCAD DA FATTURA
ENDIF
REPLACE PAR_VALUTA WITH YVALUTA
REPLACE PAR_CAMBIO WITH YCAMBIO
IF SUBSTR(DTD,3,1) = '/'
   REPLACE PAR_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE PAR_DTVAL  WITH DTD
ENDIF
REPLACE PAR_IMPVAL WITH IMP	          && VALORE IN VALUTA
IF !ExecRW('','part_cli','I','','CU_PARTCLI')
   return(.f.)
ENDIF

RETURN 


