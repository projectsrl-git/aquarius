**************************************************************************************************************
* 			 TRASFERIMENTO IN CO.GE. DELLE RITENUTE D'ACCONTO           								     *
**************************************************************************************************************


RELEASE NOTAC	
PUBLIC NOTAC	
NOTAC = ""


PUBLIC PN_C,NREG,COMPENSO,TIVA,CIVA,TOP_TOP,V_CONPAG,XDESF,V_CODCLI,DATA_SCAD,CT
XDESF    ="REGISTRAZIONE AUTOMATICA"
COMPENSO = 0
TIVA     = 0
CIVA     = 0
TOP_TOP  = SPACE(03)
DATA_SCAD = ""
PUBLIC _NPART
_NPART = " "

RELEASE __SEQUEN 
PUBLIC __SEQUEN 
__SEQUEN  = 0

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

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
V_CTE=SUBSTR(LIBERA,1,13)

DATREG  = XDATA      && FORZA LA DATA DI REGISTRAZIONE CON LA DATA DIGITATA
CTRELAB = 0
CT      = 0
PERDAL  = RIBALTA2(DATADAL)
PERAL   = RIBALTA2(DATAAL)


TOP_TOP  = PUB_VERSRA	&& sergio 13/01/2011 TOP STANDARD            

v_seek	= 'TOP' + TOP_TOP
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      NOTAC	      = SUBSTR(LIBERA,11,1)      
ELSE
      WAIT WINDOW "Errore manca parametro PER LA GESTIONE DEL VERSAMENTO RITENUTA ACCONTO , TOP : " + TOP_TOP 
      NOTAC	  = ""
      TOP_TOP =PUB_PAGAFOR
      RETURN 
ENDIF



x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_data = "ord_datord >= '" + PERDAL + "'"
x_cond = x_soci + " and " + x_data
Csql = "select * from u_ria_tt where " + x_cond + " order by ord_codsoc,ord_datord"
IF !ExecRW(Csql,"U_RIA_TT","R")
   return(.f.)
ENDIF
SELECT U_RIA_TT
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF


   IF EMPTY(ORD_DTVERS) .OR. ORD_DTVERS = SPACE(10) .OR. ORD_DTVERS = "  /  /    "
      SKIP +1
      LOOP
   ENDIF


*!*	   IF ORD_FLGFTC
*!*	   ELSE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF  

*!*	   IF ORD_FLGFPA
*!*	   ELSE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF  

*!*	   IF ORD_FLGFPT
*!*	   ELSE
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF  

   IF ORD_FLGRCT			&& GIA' TRASFRITA IN CNTABILITA'
      SKIP +1
      LOOP
   ENDIF  


   IF ORD_DATORD > PERAL
      EXIT
   ENDIF  


 
   CTRELAB=CTRELAB+1 
   WAIT WINDOW  "Fatture Elaborate"+STR(CTRELAB,6,0) NOWAIT

   ****DATI DI TESTATA DELLA SINGOLA FATTURA ****
 
   SELECT U_RIA_TT
 	
   V_CODCLI = ORD_CODCLI
   V_CONPAG = ORD_CPA
   V_DTSCA  = ORD_DTSCAD
   XDESF    = ORD_RAGSOC
   XVALUTA  = ORD_VALUTA
   XCAMBIO  = ORD_CAMBIO
   _NAZ     = ORD_CODNAZ
   _NPART   = ORD_NPART
      
   _ALRID   = "20"
   _ESENZI  = .F.				
   V_SEEK   = TAGGANCIO
   V_RITACC = ORD_TOTRAC
   TOP_TOP  = PUB_VERSRA	&& SERGIO 13/01/2011 TOP STANDARD            

   v_seek	= 'TOP' + ORD_CAUS
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      NOTAC	      = SUBSTR(LIBERA,11,1)      
   ELSE
      WAIT WINDOW "Errore manca parametro TOP : " + TOP_TOP
      NOTAC	  = ""
      TOP_TOP =PUB_PAGAFOR
   ENDIF
    
   v_seek	= "CPA"+V_CONPAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
   ELSE
  	  V_CONPAG  = "101"   && FORZATURA CPA CONTANTI
   ENDIF 
  
   SELECT U_RIA_TT

   ****SCRIVO I MOVIMENTI / SALDI / PARTITARI ***
 
   DO REG_NUMRPN

   DO REG_NUMREG

   SELECT U_RIA_TT

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
	  *V_CTE		= FOR_CONTRO  
	  V_CTE		= IIF(!EMPTY(ALLTRIM(FOR_CONTRO)), ALLTRIM(FOR_CONTRO), ALLTRIM(V_CTE))  && ERASMO - 21/03/2025
	  V_BANCA   = FOR_BANPRA    
   ELSE
      V_NAZION  = SPACE(03)
      V_BANCA   = SPACE(10) 
   ENDIF 


   **==>> SERGIO 2018/09/30 SE NON E' STATA CODIFICATA IN ANAGRAFICA FORNITORI GESTISCO LA BANCA APPENA IMPUTATA
   IF EMPTY(V_BANCA)
		V_BANCA = _BANPRA
   ENDIF 
   **==>> SERGIO 2018/09/30 SE NON E' STATA CODIFICATA IN ANAGRAFICA FORNITORI GESTISCO LA BANCA APPENA IMPUTATA



   V_ER=SOTTOGEN(V_NAZION)
   IF !V_ER
  	  FF = PUB_FF
   ENDIF 

   SELECT U_RIA_TT

   *M.CONTO	 = FF+ORD_CODCLI
   M.CONTO	 = FF+TRASFORMA_CODICE_CONTO_CONTABILE('CODICE_CLI_FOR',ORD_CODCLI)	&& 06/04/2023 SERGIO 
   
   
   
   M.DTD	 = ORD_DATORD
   M.DOC	 = ORD_NUMORD
   M.OLFAT	 = ORD_NUMORD
   M.CCAGE   = SPACE(03)
   DATREG	 = XDATA        && FORZA LA DATA DI REGISTRAZIONE CON LA DATA DIGITATA
   M.RAGSOC  = ORD_RAGSOC
 
   DAVD      = "D"
   DAVA      = "A"
   	 


   ** >>> CONTROLLI INCROCIATI SU VALORE RICALCOLATO E TOTALE FATTURA
    
    OLD_DESF=XDESF
   
	* 18/12/2021 SERGIO INIZIO
	IF PUB_CONTOSIMILCEE
        _CODCLIFOR 	= ALLTRIM(SCORPRA_CODICE_CLIENTE_FORNITORE_SE_SIMILCEE(M.CONTO))
	    XDESF   	= DESCRIZIONE_AUTOMATICA(XDESF,_CODCLIFOR,M.OLFAT,M.DTD)  && ERASMO - 07/08/2015
	ELSE
		XDESF		= "FOR:"+ALLTRIM(SUBSTR(M.CONTO,5,9))+" N.F:"+M.OLFAT+" DEL "+M.DTD
	ENDIF         
	* 18/12/2021 SERGIO FINE



   IF NOTAC	  = "S"
  
	   DO movcreat WITH DAVA,V_RITACC,0,'NO',V_CTE,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO		&&ERARIO 
	   DO movcreai WITH DAVA,V_RITACC,0,'NO',V_CTE,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO		&&INDICE
	   DO movcrea  WITH DAVD,V_RITACC,0,'NO',V_BANCA,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO	&&BANCA 
  
   ELSE
   
 	   DO movcreat WITH DAVD,V_RITACC,0,'NO',V_CTE,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO		&&ERARIO 
	   DO movcreai WITH DAVD,V_RITACC,0,'NO',V_CTE,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO		&&INDICE
	   DO movcrea  WITH DAVA,V_RITACC,0,'NO',V_BANCA,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO	&&BANCA 
   
   ENDIF
  
   SELECT U_RIA_TT
   REPLACE ORD_FLGRCT WITH .T.
   REPLACE ORD_DATRCT WITH DTOC(DATE())
 
   CT = CT +1
   SKIP +1

ENDDO

IF !ExecRW(Csql,"U_RIA_TT","W")
   return(.f.)
ENDIF

RELEASE WINDOW DISPLAY

WAIT WINDOWS 'Elaborate n. '+str(CT,5,0)+' Fatture'+CHR(13)
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

TAS = ABS(TAS)
IMP = ABS(IMP)


IF !ExecCommand("select * from mov_cont where 0=1","cu_movcont")
   return(.f.)
ENDIF
SELECT CU_MOVCONT
APPEND BLANK

__SEQUEN = __SEQUEN  + 10

REPLACE MOV_SEQUEN WITH __SEQUEN 
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

TAS = ABS(TAS)
IMP = ABS(IMP)

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

TAS = ABS(TAS)
IMP = ABS(IMP)

IF !ExecCommand("select * from mov_cont where 0=1","cu_movcont")
   return(.f.)
ENDIF
SELECT CU_MOVCONT
APPEND BLANK

__SEQUEN = __SEQUEN  + 10

REPLACE MOV_SEQUEN WITH __SEQUEN 
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

 
SELECT(SELE)
RETURN

***********************************************
FUNCTION DESCRIZIONE_AUTOMATICA
***********************************************
LPARAMETERS _par_descr_standard,_par_codcli,_par_numfat,_par_datfat

DO CASE

	CASE PUB_PRDISP  && AZIENDA PRODUZIONE DISPOSITIVI MEDICALI
		_RIT = ALLTRIM(CERCA_CLI(ALLTRIM(_par_codcli),15)) + " N.F:" + ALLTRIM(_par_numfat) + " DEL " + IIF(SUBSTR(_par_datfat,3,1)='/',_par_datfat,RIBALTA2(_par_datfat))
		
	OTHERWISE
		_RIT = ALLTRIM(_par_descr_standard)

ENDCASE

RETURN _RIT

ENDFUNC







