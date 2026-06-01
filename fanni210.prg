**********************************************************************************************
* FASE  DI SIMULAZIONE CHIUSURA  CON :
*
*  - PAREGGIO  DEL CONTO ORIGINALE
*  - CREAZIONE DEL MOVIMENTO DI CHIUSURA AL 31/12/XX
*  - CREAZIONE DEL MOVIMENTO DI APERTURA AL 01/01/(XX+1)
*
*
* 1) ELABORAZIONE DEL D.B. CONTICA
*
* 2) PER OGNI CONTO ELEMENTARE IN ELABORAZIONE CALCOLO DEL SALDO
*
* 3) SE SALDO < 0 :
*
*   --> Pareggia il CONTO sommando la differenza in ABS sul :
*        -  DARE  del CONTO originale
*        -  AVERE del CONTO BILANCIO DI CHIUSURA
*        -  DARE  del CONTO BILANCIO DI APERTURA
*
*   --> Crea una registrazione al 31/12/xx     con :
*         - partita primaria  in DARE  sul CONTO originale
*         - partita secondaria in AVERE sul CONTO BILANCIO di CHIUSURA
*   --> Crea una registrazione al 01/01/(xx+1) con :
*         - partita primaria  in AVERE sul CONTO originale
*         - partita secondaria in DARE sul CONTO BILANCIO di APERTURA
*
*
* 4) SE SALDO > 0 :
*
*   --> Pareggia il CONTO sommando la differenza in ABS sul :
*        -  AVERE del CONTO originale
*        -  DARE  del CONTO BILANCIO DI CHIUSURA
*        -  AVERE del CONTO BILANCIO DI APERTURA
*
*
*   --> Crea una registrazione al 31/12/xx     con :
*         - partita primaria  in AVERE sul CONTO originale
*         - partita secondaria in DARE sul CONTO BILANCIO di CHIUSURA
*   --> Crea una registrazione al 01/01/(xx+1) con :
*         - partita primaria  in DARE sul CONTO originale
*         - partita secondaria in AVERE sul CONTO BILANCIO di APERTURA
*

**--> CONTI PER CHIUSURA PRESI DA DB CHIUSURA
PUBLIC CONTO_PEP,CONTO_UTI,CONTO_PER,CONTO_CHI,CONTO_APE,V_ANNO,V_GGCHI,V_MMCHI,V_AACHI,V_GGAPE,V_MMAPE,V_AAAPE

** ===>>> SA = MESE INIZIALE ; SM = MESE FINALE
SA     = 1
SM     = 12
V_ANNO = PUB_ANNO

x_soci = "fin_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci 
Csql   = "select * from chiusura where " + x_cond + " order by fin_codsoc"
IF !ExecCommand(cSql,"chiusura")
   return(.f.)
ENDIF
SELECT chiusura
GO TOP
IF !EOF()
   CONTO_PEP=FIN_PROPER       && PROFITTI E PERDITE
   CONTO_UTI=FIN_UTIESE       && UTILE D'ESERCIZIO
   CONTO_PER=FIN_PERESE       && PERDITA D'ESERCIZIO
   CONTO_CHI=FIN_BILCHI       && BILANCIO DI CHIUSURA
   CONTO_APE=FIN_BILAPE       && BILANCIO D'APERTURA
   V_CONT1=FIN_BILCHI         && BILANCIO DI APERTURA
   V_CONT2=FIN_BILAPE         && BILANCIO DI CHIUSURA
   V_GGCHI=FIN_GGCHI          && GIORNO PER CHIUSURA
   V_MMCHI=FIN_MMCHI          && MESE   PER CHIUSURA
   V_AACHI=FIN_AACHI          && ANNO   PER CHIUSURA
   V_GGAPE=FIN_GGAPE          && GIORNO PER APERTURA
   V_MMAPE=FIN_MMAPE          && MESE   PER APERTURA
   V_AAAPE=FIN_AAAPE          && ANNO   PER APERTURA
ELSE
   =MESSAGEBOX("Conti di chiusura non trovati in archivio CHIUSURA",64,"*** ATTENZIONE ***")
   RETURN
ENDIF

*SET STEP ON 

PUBLIC FLAG_ECO

FOR I=1 TO 2
  
    IF I=1
       TCONTO='E'
    ELSE
       TCONTO='P'
    ENDIF
  
    * 1) ELABORAZIONE DEL D.B. CONTICA

	WAIT WINDOWS "Elaborazione CONTICA fase 1 ....."  nowait


	IF USED('CU_CONTICA')
	  SELECT CU_CONTICA
	  USE 
	ENDIF

    x_soci = "con_soc = '" + PUB_CODSOC + "'"
    x_anno = "con_anno = '" + PUB_ANNO  + "'"
    x_cond = x_soci + " and " + x_anno
    Csql   = "select * from contica where " + x_cond + " order by con_soc,con_anno,con_conto"

*!*	    IF !ExecCommand(cSql,"cu_contica")
    IF !ExecRW(cSql,"cu_contica","R")
       return(.f.)
    ENDIF
    SELECT cu_contica
    GO TOP

    DO WHILE .T.

       IF EOF()
          EXIT
       ENDIF

       IF DELETED()
          SKIP +1
          LOOP
       ENDIF    

       IF ALLTRIM(CON_POSBIL)<>ALLTRIM(TCONTO)
          SKIP +1
          LOOP
       ENDIF

       IF ALLTRIM(V_CONT1)==ALLTRIM(CON_CONTO)  && SCARTA IL CONTO DI CHIUSURA
          SKIP +1
          LOOP
       ENDIF 
    
       IF ALLTRIM(V_CONT2)==ALLTRIM(CON_CONTO)  && SCARTA IL CONTO DI APERTURA
          SKIP +1
          LOOP
       ENDIF 
    
       IF CONTO_PEP == ALLTRIM(CON_CONTO)  		&& SCARTA IL CONTO PROFITTI E PERDITE
          SKIP +1
          LOOP
       ENDIF 
    
       * 2) PER OGNI CONTO ELEMENTARE IN ELABORAZIONE CALCOLO DEL SALDO

       HO_CONTO = ALLTRIM(CON_CONTO)
       V_DIFF   = 0
       
       IF LEN(ALLTRIM(CON_CONTO))>4
          V_TOTDA1 = CON_DA01+CON_DA02+CON_DA03+CON_DA04+CON_DA05+CON_DA06+CON_DA07+CON_DA08+CON_DA09+CON_DA10+CON_DA11+CON_DA12
          V_TOTAV1 = CON_AV01+CON_AV02+CON_AV03+CON_AV04+CON_AV05+CON_AV06+CON_AV07+CON_AV08+CON_AV09+CON_AV10+CON_AV11+CON_AV12
          V_DIFF   = V_TOTDA1 - V_TOTAV1
       ENDIF 

       FLAG_ECO = .F.
       OLD_CHIU = V_CONT1

       IF V_DIFF<0 
          V_DIFF=ABS(V_DIFF)
          IF ALLTRIM(CON_POSBIL)='E'
             V_CONT1=CONTO_PEP
             FLAG_ECO=.T.
             DO FANNICOD   && CHIUDE IN DARE IL CONTO ORIGINALE E SOMMA IN DARE SUL CONTO BIL.CHIUSURA
             DO FANNIDBC   && 31/12 CREA MOV IN DARE SU CONTO ORIG. E AVERE SU BIL.CHIU.
             V_CONT1=OLD_CHIU
          ELSE
             DO FANNICOD   && CHIUDE IN DARE IL CONTO ORIGINALE E SOMMA IN DARE SUL CONTO BIL.CHIUSURA
             DO FANNIDBC   && 31/12 CREA MOV IN DARE SU CONTO ORIG. E AVERE SU BIL.CHIU.
             DO FANNIABA   && 01/01 CREA MOV IN AVERE SU CONTO ORIG. E DARE SU BIL.APER.
          ENDIF
          SELECT CU_CONTICA
          SKIP +1
          LOOP
       ENDIF
    
       IF V_DIFF>0
          IF ALLTRIM(CON_POSBIL)='E'
             V_CONT1=CONTO_PEP
             FLAG_ECO=.T.
             V_DIFF=ABS(V_DIFF)
             DO FANNICOA   && CHIUDE IN AVERR IL CONTO ORIGINALE E SOMMA IN AVERE SUL CONTO BIL.CHIUSURA
             DO FANNIABC   && 31/12 CREA MOV IN AVERE SU CONTO ORIG. E DARE SU BIL.CHIU.
             V_CONT1=OLD_CHIU
          ELSE
             V_DIFF=ABS(V_DIFF)
             DO FANNICOA   && CHIUDE IN AVERR IL CONTO ORIGINALE E SOMMA IN AVERE SUL CONTO BIL.CHIUSURA
             DO FANNIABC   && 31/12 CREA MOV IN AVERE SU CONTO ORIG. E DARE SU BIL.CHIU.
             DO FANNIDBA   && 01/01 CREA MOV IN DARE SU CONTO ORIG. E AVERE SU BIL.APER.
          ENDIF
          SELECT CU_CONTICA
          SKIP +1
          LOOP
       ENDIF
    
       SELECT CU_CONTICA
       SKIP +1
  
    ENDDO

NEXT

*
* CONTROLLO L'UTILE E IL BILANCIO
* SE STESSO ABS(SALDO) ALLORA CREO LA SCRITTURA UTILE DI BILANCIO
*

PUBLIC SALDO,SALDO1

WAIT WINDOWS "Elaborazione CONTICA fase 2 ....."  nowait
x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(CONTO_PEP) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from contica where " + x_cond + " order by con_soc,con_anno,con_conto"

*!*	    IF !ExecCommand(cSql,"contica")
IF !ExecRW(cSql,"contica","R")
   return(.f.)
ENDIF
SELECT contica
GO TOP
IF !EOF()
   SALDO=CON_IMP_D-CON_IMP_A
ELSE
   SALDO=0
ENDIF

WAIT WINDOWS "Elaborazione CONTICA fase 3 ....."  nowait
x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(V_CONT1) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from contica where " + x_cond + " order by con_soc,con_anno,con_conto"


*!*	    IF !ExecCommand(cSql,"contica")
IF !ExecRW(cSql,"contica","R")
   return(.f.)
ENDIF
SELECT contica
GO TOP
IF !EOF()
   SALDO1=CON_IMP_D-CON_IMP_A
ELSE
   SALDO1=0
ENDIF

IF ABS(SALDO)=ABS(SALDO1) .AND. SALDO<0  && TUTTE LE REGISTRAZIONI SONO OK
                                         && FACCIO LE SCRITTURE
   SALDO=ABS(SALDO)
   DO FANNINEG
   DO FANNISNE
ENDIF

IF ABS(SALDO)=ABS(SALDO1) .AND. SALDO1<0  && TUTTE LE REGISTRAZIONI SONO OK
                                          && FACCIO LE SCRITTURE
   SALDO=ABS(SALDO)
   DO FANNIPOS
   DO FANNISPO
ENDIF

** RICALCOLO DEL BILANCIO
************************************************************************

CREATE CURSOR BILANCIO ;
(COD_CONTO C(13),COD_ANNO C(4),POSBIL C(1),IMP_D N(17,3),IMP_A N(17,3),D01 N(17,3),;
   A01 N(17,3),D02 N(17,3),A02 N(17,3),D03 N(17,3),A03 N(17,3),D04 N(17,3),;
   A04 N(17,3),D05 N(17,3),A05 N(17,3),D06 N(17,3),A06 N(17,3),D07 N(17,3),;
   A07 N(17,3),D08 N(17,3),A08 N(17,3),D09 N(17,3),A09 N(17,3),D10 N(17,3),;
   A10 N(17,3),D11 N(17,3),A11 N(17,3),D12 N(17,3),A12 N(17,3))

** FASE DI AZZERAMENTO DEI CONTI PARZIALI 2/4 CHR

CTRELAB=0

WAIT WINDOWS "Elaborazione CONTICA fase 4 ....."  nowait
x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from contica where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"contica","R")
   return(.f.)
ENDIF
SELECT contica
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   CODICE_CONTO=CON_CONTO

   IF (LEN(ALLTRIM(CODICE_CONTO))=2) .OR. (LEN(ALLTRIM(CODICE_CONTO))=4)
      REPLACE CON_IMP_D WITH 0
      REPLACE CON_IMP_A WITH 0
      FOR I=1 TO 12
          IF I < 10
             II='0'+STR(I,1,0)
          ELSE
             II=STR(I,2,0)
          ENDIF
          VARD='CON_DA'+II
          VARA='CON_AV'+II
          REPLACE &VARD WITH 0
          REPLACE &VARA WITH 0
      NEXT
   ENDIF

   CTRELAB=CTRELAB+1
   WAIT WINDOW  "Azzeramento Conti"+STR(CTRELAB,6,0) NOWAIT

   SELECT CONTICA
   SKIP +1

ENDDO


*!*	IF !ExecRW(cSql,"contica","W")
*!*	   return(.f.)
*!*	ENDIF

WAIT WINDOWS "Aggiornamento CONTICA fase 5 ....."  nowait
IF !ExecRW('','contica','I','','CONTICA')
   return(.f.)
ENDIF


** CREA IL CURSORE CONTENENTE SOLO I CONTI ELEMENTARI

CTRELAB=0

IF USED('CONTICA')
  SELECT CONTICA
  USE 
ENDIF

WAIT WINDOWS "Elaborazione CONTICA fase 6 ....."  nowait
x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from contica where " + x_cond + " order by con_soc,con_anno,con_conto"

*!*	IF !ExecCommand(cSql,"contica")
IF !ExecRW(cSql,"contica","R")
   return(.f.)
ENDIF
SELECT contica
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
 
   CODICE_CONTO=CON_CONTO
   IF (LEN(ALLTRIM(CODICE_CONTO))=2) .OR. (LEN(ALLTRIM(CODICE_CONTO))=4)
      SKIP +1
      LOOP
   ENDIF

   C_CONTO       = CON_CONTO
   C_ANNO        = CON_ANNO
   C_IMD         = CON_IMP_D
   C_IMA         = CON_IMP_A
   VPOSBIL       = CON_POSBIL
   DA01=CON_DA01
   AV01=CON_AV01
   DA02=CON_DA02
   AV02=CON_AV02
   DA03=CON_DA03
   AV03=CON_AV03
   DA04=CON_DA04
   AV04=CON_AV04
   DA05=CON_DA05
   AV05=CON_AV05
   DA06=CON_DA06
   AV06=CON_AV06
   DA07=CON_DA07
   AV07=CON_AV07
   DA08=CON_DA08
   AV08=CON_AV08
   DA09=CON_DA09
   AV09=CON_AV09
   DA10=CON_DA10
   AV10=CON_AV10
   DA11=CON_DA11
   AV11=CON_AV11
   DA12=CON_DA12
   AV12=CON_AV12

   * SOMMA I DARE/AVERE
   TDA = DA01+DA02+DA03+DA04+DA05+DA06+DA07+DA08+DA09+DA10+DA11+DA12
   TAV = AV01+AV02+AV03+AV04+AV05+AV06+AV07+AV08+AV09+AV10+AV11+AV12

   IF TDA = 0  .AND.  TAV  = 0   && NON CARICA I CONTI CON IMPORTI A ZERO
      SKIP +1
      LOOP
   ENDIF

   SELECT BILANCIO
   APPEND BLANK
   REPLACE  COD_CONTO WITH  C_CONTO
   REPLACE  POSBIL    WITH  VPOSBIL
   REPLACE  COD_ANNO  WITH  C_ANNO
   REPLACE  IMP_D     WITH  C_IMD
   REPLACE  IMP_A     WITH  C_IMA
   REPLACE  D01       WITH  DA01
   REPLACE  A01       WITH  AV01
   REPLACE  D02       WITH  DA02
   REPLACE  A02       WITH  AV02
   REPLACE  D03       WITH  DA03
   REPLACE  A03       WITH  AV03
   REPLACE  D04       WITH  DA04
   REPLACE  A04       WITH  AV04
   REPLACE  D05       WITH  DA05
   REPLACE  A05       WITH  AV05
   REPLACE  D06       WITH  DA06
   REPLACE  A06       WITH  AV06
   REPLACE  D07       WITH  DA07
   REPLACE  A07       WITH  AV07
   REPLACE  D08       WITH  DA08
   REPLACE  A08       WITH  AV08
   REPLACE  D09       WITH  DA09
   REPLACE  A09       WITH  AV09
   REPLACE  D10       WITH  DA10
   REPLACE  A10       WITH  AV10
   REPLACE  D11       WITH  DA11
   REPLACE  A11       WITH  AV11
   REPLACE  D12       WITH  DA12
   REPLACE  A12       WITH  AV12

   SELECT CONTICA
   SKIP +1

   CTRELAB=CTRELAB+1
   WAIT WINDOW  "Conti Elementari "+STR(CTRELAB,6,0) NOWAIT

ENDDO

** RIELABORA IL CURSORE PER AGGIORNARE IL DB.CONTICA

CTRELAB         = 0
PAT_DARE        = 0
PAT_AVERE       = 0
PAT_ATTIVO      = 0
PAT_PASSIVO     = 0
PAT_SALDO       = 0
ECO_DARE        = 0
ECO_AVERE       = 0
ECO_ATTIVO      = 0
ECO_PASSIVO     = 0
ECO_SALDO       = 0
TOT_DARE        = 0
TOT_AVERE       = 0
TOT_ATTIVO      = 0
TOT_PASSIVO     = 0
TOT_SALDO       = 0

SELECT BILANCIO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   C_CONTO  = COD_CONTO
   C_ANNO   = COD_ANNO
   V_CERCA4 = SUBSTR(C_CONTO,1,4)
   V_CERCA2 = SUBSTR(C_CONTO,1,2)
   C_IMD    = 0
   C_IMA    = 0

   DECLARE VETTORE_D(12)
   DECLARE VETTORE_A(12)

   *===>>> AZZERO I VETTORI DARE / AVERE
 
   FOR I=1 TO 12
       VETTORE_D[I]=0
       VETTORE_A[I]=0
   NEXT

   *===>>> CARICO IL VETTORE CON I DARE/AVERE DEL CONTO ELEMENTARE

   FOR I=SA TO SM
       IF I < 10
          S_I='0'+STR(I,1,0)
       ELSE
          S_I=STR(I,2,0)
       ENDIF
       VET_D='D'+S_I
       VET_A='A'+S_I
       DD=&VET_D              && CARCA I MESI DEL DETTAGLIO CONTO IN DD/AA
       AA=&VET_A
       VETTORE_D[I]=DD        && ASSEGNA IL CONTENUTO
       VETTORE_A[I]=AA
       C_IMD  = C_IMD + DD    && SOMMA NEL TOTALE GENERALE
       C_IMA  = C_IMA + AA
       IF POSBIL="P"
          PAT_DARE  =PAT_DARE+VETTORE_D[I]
          PAT_AVERE =PAT_AVERE+VETTORE_A[I]
          PAT_SALDO =PAT_SALDO+VETTORE_D[I]-VETTORE_A[I]
          IF VETTORE_D[I]-VETTORE_A[I]>=0
             PAT_ATTIVO=PAT_ATTIVO+VETTORE_D[I]-VETTORE_A[I]
          ELSE
             PAT_PASSIVO=PAT_PASSIVO-VETTORE_D[I]-VETTORE_A[I]
          ENDIF
       ENDIF
       IF POSBIL="E"
          ECO_DARE  =ECO_DARE+VETTORE_D[I]
          ECO_AVERE =ECO_AVERE+VETTORE_A[I]
          ECO_SALDO =ECO_SALDO+VETTORE_D[I]-VETTORE_A[I]
          IF VETTORE_D[I]-VETTORE_A[I]>=0
             ECO_ATTIVO=ECO_ATTIVO+VETTORE_D[I]-VETTORE_A[I]
          ELSE
             ECO_PASSIVO=ECO_PASSIVO-VETTORE_D[I]-VETTORE_A[I]
          ENDIF
       ENDIF
   NEXT

   SELECT BILANCIO
   SKIP +1

   CTRELAB=CTRELAB+1
   WAIT WINDOW  "Calcolo Bilancio"+STR(CTRELAB,6,0) NOWAIT

ENDDO

TOT_DARE    = PAT_DARE    +  ECO_DARE
TOT_AVERE   = PAT_AVERE   +  ECO_AVERE
TOT_ATTIVO  = PAT_ATTIVO  +  ECO_ATTIVO
TOT_PASSIVO = PAT_PASSIVO +  ECO_PASSIVO
TOT_SALDO   = PAT_SALDO   +  ECO_SALDO

DO FORM FORM\BILRIE LINKED

RETURN
