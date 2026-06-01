**************************************************************************************************************
* 			 TRASFERIMENTO IN CONTABILITA GENERALE DEGLI INCASSI DEI PDV       								 *
*																			 								 *
*	NOTE :																									 *
*			VEDIART = ROUTIN PER DETERMINARE IL CONTO CONTABILE DELLA CONTROPARTITA							 *
*					  - 1) STEP ACCEDE SU ANAGRAFICA PUNTO DI VENDITA PRELEVA LA CONTROPARTITA 				 *
*					  - 2) STEP ACCEDE SU ANAGRAFICA ARTICOLI PRELEVA LA CONTROPARTITA 						 *
*					  - 3) STEP ACCEDE SU PARAMETRO CRA SE ATTIVO IL TRASFERIMENTO PER LINEA/NAZIONE 		 *
*					  - 4) STEP VERIFICA IN PIANO CONTI CONGRUENZA CONTO	 				 				 *
*					  - 5) STEP SE NON ESISTE SU PIANO CONTI O SE VUOTO PRENDE CONTROPARTITA DI DEFAULT (CMV)*
*																											 *
**************************************************************************************************************

RELEASE V_DTSCA,XDESF,XVALUTA,XCAMBIO,_NAZ,XDESFF,_ALRID,_ESENZI,SPESE,SP_INCA, ;
        SP_TRAS,VALFAT,V_TOTALE,PN_C,NREG,COMPENSO,TIVA,CIVA,V_CODCLI,_DIFVAL,_OKDIFC, ;
        DATA_SCAS,CT,CTRELAB,PERDAL,PERAL,FL_OK,FL_OKCAM,XXX_UNIQUE,XXX_CODPDV,XXX_PRIMA, ;
        V_CODPDV,V_CODCLI,V_CONTO,V_CONTRO,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,Csql1,CONTO, ;
        VALORE,AR_PU,IVA,W_SEQUEN,DATREG
PUBLIC  V_DTSCA,XDESF,XVALUTA,XCAMBIO,_NAZ,XDESFF,_ALRID,_ESENZI,SPESE,SP_INCA, ;
        SP_TRAS,VALFAT,V_TOTALE,PN_C,NREG,COMPENSO,TIVA,CIVA,V_CODCLI,_DIFVAL,_OKDIFC, ;
        DATA_SCAS,CT,CTRELAB,PERDAL,PERAL,FL_OK,FL_OKCAM,XXX_UNIQUE,XXX_CODPDV,XXX_PRIMA, ;
        V_CODPDV,V_CODCLI,V_CONTO,V_CONTRO,V_RAGSOC,V_INDIRI,V_CAP,V_LOCALI,Csql1,CONTO, ;
        VALORE,AR_PU,IVA,W_SEQUEN,DATREG

XDESF      = "REGISTRAZIONE AUTOMATICA"
XDESFF     = ""
COMPENSO   = 0
TIVA       = 0
CIVA       = 0
_DIFVAL    = 0
DATA_SCAD  = ""
CT         = 0
CTRELAB    = 0
PERDAL     = RIBALTA2(DATADAL)
PERAL      = RIBALTA2(DATAAL)
FL_OK      = .T.
FL_OKCAM   = .T.
XXX_UNIQUE = " "
XXX_CODPDV = " "
XXX_PRIMA  = .T.
V_CODPDV   = SPACE(10)
V_CONTO    = SPACE(13)
V_CONTRO   = SPACE(13)
V_RAGSOC   = SPACE(50)
V_INDIRI   = SPACE(50)
V_CAP      = SPACE(10)   
V_LOCALI   = SPACE(50)
PERDAL     = RIBALTA2(DATADAL)
PERAL      = RIBALTA2(DATAAL)
W_SEQUEN   = 0
DATREG     = SPACE(10)

CREATE CURSOR W_FAT (W_CONTO C(13),     W_DA C(1),        W_IVA C(3),       W_IMPONI N(17,3), ;
                     W_IMPOSTA N(17,3), W_SPINCA N(17,3), W_SPTRAS N(17,3), W_PUBBLI N(17,3), ;
                     W_NUMDOC C(10),    W_DTDOC C(10))
SELECT W_FAT
INDEX ON ALLTRIM(W_CONTO)+ W_DA + W_IVA TAG DETTA
SET ORDER TO DETTA

WAIT WINDOWS 'Inizio Elaborazione Prego attendere......... ' NOWAIT

x_data = "cas_datope >= '" + PERDAL + "'"
x_tipo = "cas_tipinc = '   '"
x_cge  = "cas_cge = 0"
x_maga = "cas_codpdv = '" + ALLTRIM(_V_CMAGAZ) + "'"
x_cond = x_data + " and " + x_tipo + " and " + x_cge 
IF EMPTY(AGEDAL) .OR. AGEDAL = SPACE(10)
ELSE
   x_cond = x_cond + " and " + x_maga
ENDIF
Csql1 = "select * from u_pdv_ca where " + x_cond + " order by cas_datope,cas_codpdv"
IF !ExecRW(Csql1,"U_PDV_CA","R")
   return(.f.)
ENDIF
SELECT U_PDV_CA
GO TOP
IF EOF()
   =MESSAGEBOX("Nessun incasso da elaborare",16,"Attenzione")
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

   IF CAS_DATOPE > PERAL
      EXIT
   ENDIF
   
   SCATTER MEMVAR MEMO

   IF XXX_PRIMA
      XXX_PRIMA = .F.
      DO VERIFICA_PDV
      DO INIZIALIZZA_DATI
      SELECT U_PDV_CA
      LOOP
   ENDIF

   IF M.CAS_CODPDV = XXX_CODPDV
   ELSE
      DO SCRIVI_CONTABILE
      DO VERIFICA_PDV
      DO INIZIALIZZA_DATI
      SELECT U_PDV_CA
      LOOP
   ENDIF
   
   CTRELAB = CTRELAB+1
   WAIT WINDOW "Incassi elaborati "+STR(CTRELAB,6,0) NOWAIT

   CONTO    = VEDIART(M.CAS_CODART,V_CONTRO)				&& MANTIENE ULTIMO CONTO
   VALORE   = ROUND((CAS_IMPORT / ((CAS_IVA / 100) + 1)),2) && SCORPORATO DELL'IVA
   AR_PU    = " "
   IVA      = CAS_CODIVA
   V_TOTALE = V_TOTALE + VALORE
   IF AR_PU = 'S'
      V_TOTALE = V_TOTALE - VALORE       					&& TOGLIE MATERIALE PUBBLICITARIO
   ENDIF

   SELECT W_FAT
   _SEEK = ALLTRIM(CONTO) + 'A' + IVA
   SEEK _SEEK
   IF FOUND()
      REPLACE W_IMPONI WITH W_IMPONI + VALORE
	  IF AR_PU = 'S'
		 REPLACE W_PUBBLI WITH W_PUBBLI + VALORE   && ARTICOLO PUBBLICITARIO
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE W_IMPONI WITH VALORE
      REPLACE W_CONTO  WITH CONTO
      REPLACE W_IVA    WITH IVA
      REPLACE W_DA     WITH 'A'
      IF AR_PU = 'S'
         REPLACE W_PUBBLI WITH  VALORE              && ARTICOLO PUBBLICITARIO
	  ENDIF
   ENDIF

   SELECT U_PDV_CA
   REPLACE CAS_CGE WITH .T.

   CT = CT +1
   SKIP +1

ENDDO

DO SCRIVI_CONTABILE

IF !ExecRW(Csql1,"U_PDV_CA","W")
   return(.f.)
ENDIF

RELEASE WINDOW DISPLAY

WAIT WINDOWS 'Elaborate n. '+str(CT,5,0)+' Fatture/Note Credito'+CHR(13)
WAIT WINDOWS 'Elaborazione completata ...' NOWAIT

=MESSAGEBOX("Trasferimento fatture in contabilità terminato correttamente",62,"ATTENZIONE")

RELEASE WINDOW DISPLAY

RETURN


**********************
PROCEDURE VERIFICA_PDV
**********************
  
x_cond = "pdv_codice = '" + ALLTRIM(M.CAS_CODPDV) + "'"
Csql   = "select * from u_pdv_an where " + x_cond + " order by pdv_codice"
IF !ExecCommand(Csql,"CU_PDV_AN")
   return(.f.)
ENDIF
SELECT CU_PDV_AN
GO TOP
IF EOF()
   =MESSAGEBOX("Manca il punto di vendita in anagrafica"+CHR(13)+;
               "by passo il record e vado avanti. codice pdv mancante " + m.cas_codpdv,16,"Attenzione")
   SELECT U_PDV_CA
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF CAS_CODPDV = XXX_CODPDV  
      ELSE
         EXIT
      ENDIF 
      SKIP +1
   ENDDO
   RETURN
ENDIF

IF PDV_CODCON = SPACE(13) .OR. EMPTY(PDV_CODCON)
   =MESSAGEBOX("Manca il conto contabile sulla anagrafica del punto di vendita"+CHR(13)+;
               "by passo il record e vado avanti. codice punto di vendita " + m.cas_codpdv,16,"Attenzione")
    SELECT U_PDV_CA
    DO WHILE .T.
       IF EOF()
          EXIT
       ENDIF
       IF CAS_CODPDV = XXX_CODPDV  
       ELSE
          EXIT
       ENDIF 
       SKIP +1
    ENDDO
    RETURN
ENDIF     

IF PDV_CODCGE = SPACE(13) .OR. EMPTY(PDV_CODCGE)
   PDV_CODCGE = V_CMV
ENDIF     

V_CODCLI = PDV_CODCLI
V_CODPDV = PDV_CODICE
V_CONTO  = PDV_CODCON
V_CONTRO = PDV_CODCGE
V_RAGSOC = PDV_DESCRI
V_INDIRI = PDV_INDIRI
V_CAP    = PDV_CAP   
V_LOCALI = PDV_LOCALI

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(V_CONTO) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(cSql,"conti")
   return(.f.)
ENDIF
SELECT conti
GO TOP
IF EOF()
   =MESSAGEBOX("Manca il conto contabile in archivio conti"+CHR(13)+;
               "by passo il record e vado avanti. codice pdv " + v_codpdv+CHR(13)+;
               "Codice conto non trovato " + ALLTRIM(V_CONTO),16,"Attenzione")
   SELECT U_PDV_CA
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF CAS_CODPDV = XXX_CODPDV  
      ELSE
         EXIT
      ENDIF 
      SKIP +1
   ENDDO
   RETURN
ENDIF     

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(V_CONTRO) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(cSql,"conti")
   return(.f.)
ENDIF
SELECT conti
GO TOP
IF EOF()
   =MESSAGEBOX("Manca la contropartita contabile in archivio conti"+CHR(13)+;
               "by passo il record e vado avanti. Codice pdv : " + v_codpdv+CHR(13)+;
               "Codice conto non trovato " + ALLTRIM(V_CONTRO),16,"Attenzione")
   SELECT U_PDV_CA
   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF CAS_CODPDV = XXX_CODPDV  
      ELSE
         EXIT
      ENDIF 
      SKIP +1
   ENDDO
   RETURN
ENDIF

RETURN


**************************
PROCEDURE INIZIALIZZA_DATI
**************************

XXX_CODPDV = M.CAS_CODPDV
V_DTSCA    = M.CAS_DATOPE
XDESF      = V_RAGSOC
XVALUTA    = PUB_VALRIF
XCAMBIO    = 1
_NAZ       = PUB_NAZI
XDESFF     = "PDV : "+ALLTRIM(V_RAGSOC)+" INCASSO DEL "+RIBALTA2(M.CAS_DATOPE)
_ALRID     = PUB_IVA
_ESENZI    = .F.				&& CLIENTE NON IN ESENZIONE
SPESE      = 0
SP_INCA    = 0    && SPESE INCASSO
SP_TRAS    = 0    && SPESE TRASPORTO
VALFAT     = 0
V_TOTALE   = 0
W_SEQUEN   = 0
 
SELECT W_FAT
ZAP

RETURN


**************************
PROCEDURE SCRIVI_CONTABILE
**************************

IF SP_INCA > 0  && SPESE INCASSO
   V_TOTALE = V_TOTALE + SP_INCA
   SELECT W_FAT
   APPEND BLANK
   REPLACE W_CONTO  WITH CONTOSP
   REPLACE W_IMPONI WITH SP_INCA
   IF !_ESENZI                                && SOLO SE NON IN ESENZIONE
      REPLACE W_IVA    WITH PUB_IVA
   ELSE
	  REPLACE W_IVA    WITH _ALRID
   ENDIF			   	
   REPLACE W_DA     WITH 'A'
   SP_INCA    = 0
ENDIF

IF SP_TRAS > 0  && SPESE TRASPORTO
   V_TOTALE=V_TOTALE+SP_TRAS
   SELECT W_FAT
   APPEND BLANK
   REPLACE W_CONTO  WITH CONTOST
   REPLACE W_IMPONI WITH SP_TRAS
   IF !_ESENZI                                && SOLO SE NON IN ESENZIONE
      REPLACE W_IVA    WITH PUB_IVA
   ELSE
      REPLACE W_IVA    WITH _ALRID
   ENDIF			   	
   REPLACE W_DA     WITH 'A'
   SP_TRAS    = 0
ENDIF	

****CALCOLA TUTTE LE IVE****
TIVA = 0
DO CALCIVA
****************************

****SCRIVO I MOVIMENTI / SALDI / PARTITARI ***

DO REG_NUMRPN

DO REG_NUMREG
   
M.CONTO	 = V_CONTO
M.DTD	 = V_DTSCA
M.DOC	 = '888'
M.OLFAT	 = '888'
M.CCAGE  = SPACE(03)

IF EMPTY(XDATA)
   DATREG = RIBALTA2(M.DTD) && FORZA COME DATA DI REGISTRAZIONE LA DATA DI FATTURA
ELSE
   DATREG = XDATA           && FORZA COME DATA DI REGISTRAZIONE LA DATA DIGITATA
ENDIF

M.RAGSOC  = V_RAGSOC

D_A = "D"
IF NOTAC = "S" 		   && NOTA CREDITO
   DAVD  = "A"
   DAVA  = "D"
ELSE
   DAVD  = "D"         && FATTURA
   DAVA  = "A"
ENDIF

DIFF_TOT = 0

*IF V_TOTALE <> VALFAT
*   DIFF_TOT = VALFAT - V_TOTALE
*   V_TOTALE = VALFAT
*ENDIF

DO movcreat WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO	&& PARTITA PRIMARIA
DO movcreai WITH DAVD,V_TOTALE,0,'NO',M.CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO	&& INDICE

SELECT W_FAT
GO TOP
 
* CONTROLLO DI QUADRATURA TRA VALORE CALCOLATO E VALORE TOTALE DEL DOCUMENTO
IF DIFF_TOT <> 0
   FOR H=1 TO RECCOUNT()
       IF W_IMPOSTA <> 0
          REPLACE W_IMPOSTA WITH  W_IMPOSTA + DIFF_TOT
          EXIT
       ENDIF
       SKIP+1  
   NEXT
ENDIF

GO TOP

X_TOTALE = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF W_PUBBLI <> 0
      REPLACE W_IMPONI WITH  W_IMPONI - W_PUBBLI  && SE CONTROPARTITA CON MAT.PUBBLIC.
   ENDIF

   OLD_DESF = XDESF
   XDESF    = XDESFF
   _OKDIFC  = .T.   && GESTIONE DIFFERENZA CAMBIO

   DO movcrea WITH DAVA,W_IMPONI,W_IMPOSTA,W_IVA,W_CONTO,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC  	&&DET VENDITA

   _OKDIFC  = .F.

   DO movcrea WITH DAVA,W_IMPOSTA,0,W_IVA,CON_IVA,TOP_TOP,M.DOC,M.DTD,M.OLFAT,XVALUTA,XCAMBIO,_OKDIFC			&&DET IVA

   SKIP +1

ENDDO

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
REPLACE MOV_DESMOV WITH XDESFF
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


***************************************************************************
PROCEDURE movcreat      && crea la partita primaria e il partitario clienti
***************************************************************************
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
REPLACE MOV_DESMOV WITH XDESFF
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
W_SEQUEN = W_SEQUEN + 10
REPLACE MOV_SEQUEN WITH W_SEQUEN
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
*SET STEP ON 
IF !EOF()
   P_IMPA  = CON_IMP_A
   P_IMPD  = CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
	  REPLACE   CON_IMP_D   WITH P_IMPD + CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR2       WITH &VAR2 + CAMBIO(YVALUTA,IMP,YCAMBIO)
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA + CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH &VAR + CAMBIO(YVALUTA,IMP,YCAMBIO)
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
   P_IMPA  = CON_IMP_A
   P_IMPD  = CON_IMP_D
   MESE    = SUBSTR(DATREG,4,2)
   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
   IF DA_AV = 'D'
      REPLACE   CON_IMP_D   WITH P_IMPD + CAMBIO(YVALUTA,IMP,YCAMBIO)
	  REPLACE   &VAR2       WITH &VAR2 + CAMBIO(YVALUTA,IMP,YCAMBIO)
   ELSE
      REPLACE   CON_IMP_A   WITH P_IMPA + CAMBIO(YVALUTA,IMP,YCAMBIO)
      REPLACE   &VAR        WITH &VAR + CAMBIO(YVALUTA,IMP,YCAMBIO)
   ENDIF
ENDIF
IF !ExecRW(cSql,"conti","W")
   return(.f.)
ENDIF

DO REG_PARCLI    && AGGIORNA PARTITARIO CLIENTI

SELECT(SELE)

RETURN


**************************************
PROCEDURE movcrea                               && CREA LE CONTROPARTITE
**************************************
PARA DA_AV,IMP,TAS,IV,CON,TOP,NDOC,DTD,NPRO,YVALUTA,YCAMBIO,YOKDIFC

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
IF SUBSTR(DTD,3,1) = '/'
   REPLACE MOV_DTVAL  WITH RIBALTA2(DTD)
ELSE
   REPLACE MOV_DTVAL  WITH DTD
ENDIF
W_SEQUEN = W_SEQUEN + 10
REPLACE MOV_SEQUEN WITH W_SEQUEN
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
    P_IMPA  = CON_IMP_A
    P_IMPD  = CON_IMP_D
    MESE    = SUBSTR(DATREG,4,2)
    VAR     = "CON_AV"+MESE
    VAR2    = "CON_DA"+MESE
    * SE ESISTE DEFFERENZA DI UNA O PIU' LIRE SCALO UNA LIRA PER OGNI DETTAGLIO
    * DELLA FATTURA
    _LIRA  = 0
    IF YOKDIFC       && GESTIONE RECOR IMPONIBILE
       IF _DIFVAL < 0
          _LIRA=-1
       ELSE
          _LIRA=1
       ENDIF
       IF _DIFVAL = 0
          _LIRA=0
       ENDIF
       _DIFVAL=_DIFVAL-_LIRA
    ENDIF
    CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
    IF DA_AV = 'D'
	   REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(YVALUTA,IMP,YCAMBIO)-_LIRA
	   REPLACE   &VAR2       WITH CAMBIO(YVALUTA,IMP,YCAMBIO)-_LIRA+&VAR2
	ELSE
	   REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(YVALUTA,IMP,YCAMBIO)-_LIRA
	   REPLACE   &VAR        WITH CAMBIO(YVALUTA,IMP,YCAMBIO)-_LIRA+&VAR
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
   VALIVA = W_IMPONI * IVAREAL(W_IVA)
   CIVA  = W_IVA
   IF XVALUTA = "ITL" .OR.  XVALUTA = "LIT"
      VALIVA	=	ROUND((VALIVA+.49),0)
   ELSE
      VALIVA	=	ROUND((VALIVA+.0000),2)
   ENDIF
   TIVA  = TIVA + VALIVA
   REPLACE    W_IMPOSTA WITH VALIVA
   V_TOTALE = V_TOTALE + VALIVA
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
********************

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
PN   = VAL(SUBSTR(LIBERA,1,10))
PN   = PN + 1
PN_C = STR(PN)
*  REPLACE LIBERA WITH ALLTRIM(PN_C)
PN_C = sys(2015)
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
PARA FG,CPC

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
   _LIN = ART_LINEA
   IF EMPTY(ART_CGE) .OR. ART_CGE = SPACE(13)
 	  RET = CPC
   ELSE
      RET = ART_CGE
   ENDIF
ELSE
   RET  = CPC
   _LIN = "X"
ENDIF

** 1.1) DETERMINA CONTROPARTITA SU BASE PERSONALIZZAZIONE RICHIESTA
IF _TFPER 					&& VERIFICA SE ESISTE PERSONALIZZAZIONE
   _CODA = FG
   _COCO = SPACE(13)
   =TFCGRUP()
   IF EMPTY(_COCO)
      _COCO=CPC
   ENDIF
   RET=ALLTRIM(_COCO)
   SELECT(SELE)
   RETURN(RET)
ENDIF

** 1.2) DETERMINA CONTROPARTITA SU BASE TIPO OPERAZIONE
IF _TFTOP 				&& VERIFICA SE ESISTE PERSONALIZZAZIONE
   _CODA = FG
   _COCO = TOP_CONT		&& CONTROPARTITA DA PARAMETRO TOP
   IF EMPTY(_COCO)
      _COCO=CPC
   ENDIF
   RET=ALLTRIM(_COCO)
   SELECT(SELE)
   RETURN(RET)
ENDIF

** 2) ANAGRAFICA CLIENTI----------------------------------------------
x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(V_CODCLI) + "'"
x_cond = x_soci + " and " + x_codi   
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP   
IF !EOF()
   IF !EMPTY(CLI_CONTO1)
      RET=CLI_CONTO1
   ENDIF
ENDIF

* 3) ACCESSO SE RICHIESTO AL PARAMETRO LINEA / NAZIONE ---------------

IF _TLIN 					&& VERIFICA SE RICHIESTO
   v_seek	= 'CRA'+ALLTRIM(_LIN)+ALLTRIM(_NAZ)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      RET=ALLTRIM(LIBERA)
   ENDIF
ENDIF

* 4) VERIFICA SU PIANO DEI CONTI ESISTENZA CONTO : SI DA PER SCONTATO CHE IL CONTO AUTOMATICO
* DI DEFAULT ESISTA SU CONTI

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
   RET = CPC
ENDIF

IF EMPTY(RET)
   RET = CPC
ENDIF

SELECT(SELE)

RETURN(RET)


*************************************************************************
*   AGGIORNAMENTO PARTITARIO CLIENTI                                    *
*************************************************************************
PROCEDURE REG_PARCLI
********************

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
   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
ELSE
   V_TELEFO  = SPACE(15)
   V_PARIVA  = SPACE(16)
   V_RAGSOC  = "CLIENTE INESISTENTE"
   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
   VET_DAL[1]= "0000"
   VET_DAL[2]= "0000"
   VET_AL[1] = "0000"
   VET_AL[2] = "0000"
   VET_DAY[1]= "0000"
   VET_DAY[2]= "0000"
ENDIF

v_seek	 = "CPA"+V_CONPAG
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   V_CONPAG  = PUB_CPA   && FORZATURA CPA CONTANTI
ENDIF

IF NOTAC  = "S"       && FORZATURA CPA CONTANTI SE NOTA CREDITO
   V_CONPAG  = PUB_CPA
ENDIF

IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
   return(.f.)
ENDIF
SELECT CU_PARTCLI
APPEND BLANK
REC_PART=RECNO()
REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
IF NOTAC  = "S"  && NOTA CREDITO
   REPLACE PAR_TIPODO  WITH "FAT"     && E' PAR_TIPFAT CHE DETERMINA N.CREDITO
   REPLACE PAR_TMOV    WITH "A"
ELSE
   REPLACE PAR_TIPODO  WITH "FAT"
   REPLACE PAR_TMOV    WITH "D"
ENDIF
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
REPLACE PAR_NPROT   WITH NPRO               && NUMERO DI FATTURA AGENTE
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
IF !ExecRW('','part_cli','I','','CU_PARTCLI')
   return(.f.)
ENDIF

DO REG_SCAD      && GESTIONE SCADENZIARIO CLIENTI

RETURN


*************************************************************************
*    GESTIONE SCADENZIARIO CLIENTI                                      *
*************************************************************************
PROCEDURE REG_SCAD
******************

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
DATA_SCAD=SPACE(10)
IF !EOF()
   V_TELEFO  = CLI_TELEFO
   V_PARIVA  = CLI_PARIVA
   PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
   VET_DAL[1]= CLI_BDAL
   VET_DAL[2]= CLI_B2DAL
   VET_AL[1] = CLI_BAL
   VET_AL[2] = CLI_B2AL
   VET_DAY[1]= CLI_GG1
   VET_DAY[2]= CLI_GG2
   v_seek	= "CPA"+V_CONPAG
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
   ELSE
      V_CONPAG  = PUB_CPA   && FORZATURA CPA CONTANTI
   ENDIF
   V_TUTTO=TRANCHE("PARA",V_CONPAG,RIBALTA2(DTD),IMP,VET_DAL,VET_AL,VET_DAY,YVALUTA)
   DO PERIODI     && CREA I PERIODI DI SCADENZA
ENDIF

RETURN


*!*	*************************
*!*	PROCEDURE PERIODI_2011_07_14_ORIGINALE
*!*	*************************

*!*	CONTA_TRA = 0
*!*	** RICERCA IMPORTO TRANCHE
*!*	IS=0
*!*	XPAROLA = ''
*!*	DO PAROLA
*!*	*IMP_TRANK=INT(VAL(XPAROLA))
*!*	IMP_TRANK=VAL(XPAROLA)

*!*	DO WHILE .T.
*!*	   CONTA_TRA = CONTA_TRA + 1
*!*	   * CNT IDENTIFICA IL NUMERO DI TRANCHE DETERMINATO DA TRANCHE
*!*	   IF CONTA_TRA > CNT
*!*	      RETURN
*!*	   ENDIF
*!*	   IF CONTA_TRA = CNT
*!*	      IMP_TRANK = IMP_TRANK + COMPENSO
*!*	   ENDIF
*!*	   ** RICERCA DATA SCADENZA
*!*	   XPAROLA = ''
*!*	   DO PAROLA
*!*	   DATA_SCAD=XPAROLA
*!*	   DO CREA_PERI
*!*	ENDDO

*!*	RETURN


*************************
PROCEDURE PERIODI
*************************

SELECT CU_TRANK
GO TOP
DO WHILE .NOT. EOF()


    DATA_SCAD = TK_DSCAD
	IMP_TRANK = TK_IMP_SCAD 
	
	DO CREA_PERI
	
	SELECT CU_TRANK
	SKIP +1

ENDDO

RETURN


*************************
PROCEDURE PAROLA
*************************
DO WHILE .T.
   IS=IS + 1
   IF IS > LEN(ALLTRIM(V_TUTTO))
      EXIT
   ENDIF
   CARATT = SUBSTR(V_TUTTO,IS,1)
   IF !EMPTY(CARATT)
      XPAROLA = XPAROLA + SUBSTR(V_TUTTO,IS,1)
   ELSE
      EXIT
   ENDIF
ENDDO

RETURN


*************************
PROCEDURE CREA_PERI
*************************
** ===>>> CREA I PERIODI DI SCADENZA

IF !ExecCommand("select * from part_cli where 0=1","cu_partcli")
   return(.f.)
ENDIF
SELECT CU_PARTCLI
APPEND BLANK
REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
IF NOTAC  = "S"
   REPLACE PAR_TIPODO  WITH "FAT"     && E' PAR_TIPFAT CHE DETERMINA N.CREDITO
   REPLACE PAR_TMOV    WITH  "A"
ELSE
   REPLACE PAR_TIPODO  WITH "FAT"
   REPLACE PAR_TMOV    WITH  "D"
ENDIF
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
REPLACE PAR_FATT    WITH IMP_TRANK
REPLACE PAR_NPROT   WITH NPRO              && NUMERO DI FATTURA AGENTE
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
IF SUBSTR(DATA_SCAD,3,1) = '/'
   REPLACE PAR_DTSCAD  WITH RIBALTA2(DATA_SCAD) && DT.SCAD DA FATTURA
ELSE
   REPLACE PAR_DTSCAD  WITH DATA_SCAD           && DT.SCAD DA FATTURA
ENDIF
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


************************
FUNCTION TFCGRUP				&& OTTIENE LA CONTROPARTITA SU OZIONE PERSONALIZZAZIONE
************************

SXXS=STR(SELECT())

V_ER=SOTTOGEN(_NAZ)    && PRELEVA IL GRUPPO
IF !V_ER
   CC = PUB_CC
ENDIF

DO CASE
   CASE CC = "1011"	&& CLIENTE ITALIA
        DO PRNITALI
   CASE CC = "1012"	&& CLIENTE CEE
        DO PRNCOCEE
   CASE CC = "1013"	&& CLIENTE EXTRACEE
        DO PRNEXTRA
ENDCASE

SELECT &SXXS
RETURN
