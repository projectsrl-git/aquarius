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

*!*	CREATE CURSOR BILANCIO ;
*!*	(COD_CONTO C(13),COD_ANNO C(4),POSBIL C(1),IMP_D N(17,3),IMP_A N(17,3),D01 N(17,3),;
*!*	   A01 N(17,3),D02 N(17,3),A02 N(17,3),D03 N(17,3),A03 N(17,3),D04 N(17,3),;
*!*	   A04 N(17,3),D05 N(17,3),A05 N(17,3),D06 N(17,3),A06 N(17,3),D07 N(17,3),;
*!*	   A07 N(17,3),D08 N(17,3),A08 N(17,3),D09 N(17,3),A09 N(17,3),D10 N(17,3),;
*!*	   A10 N(17,3),D11 N(17,3),A11 N(17,3),D12 N(17,3),A12 N(17,3))

*!*	** FASE DI AZZERAMENTO DEI CONTI PARZIALI 2/4 CHR

*!*	CTRELAB=0

*!*	WAIT WINDOWS "Elaborazione CONTICA fase 4 ....."  nowait
*!*	x_soci = "con_soc = '" + PUB_CODSOC + "'"
*!*	x_anno = "con_anno = '" + PUB_ANNO + "'"
*!*	x_cond = x_soci + " and " + x_anno
*!*	Csql   = "select * from contica where " + x_cond + " order by con_soc,con_anno,con_conto"
*!*	IF !ExecRW(cSql,"contica","R")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT contica
*!*	GO TOP

*!*	DO WHILE .T.

*!*	   IF EOF()
*!*	      EXIT
*!*	   ENDIF
*!*	   
*!*	   IF DELETED()
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   CODICE_CONTO=CON_CONTO

*!*	   IF (LEN(ALLTRIM(CODICE_CONTO))=2) .OR. (LEN(ALLTRIM(CODICE_CONTO))=4)
*!*	      REPLACE CON_IMP_D WITH 0
*!*	      REPLACE CON_IMP_A WITH 0
*!*	      FOR I=1 TO 12
*!*	          IF I < 10
*!*	             II='0'+STR(I,1,0)
*!*	          ELSE
*!*	             II=STR(I,2,0)
*!*	          ENDIF
*!*	          VARD='CON_DA'+II
*!*	          VARA='CON_AV'+II
*!*	          REPLACE &VARD WITH 0
*!*	          REPLACE &VARA WITH 0
*!*	      NEXT
*!*	   ENDIF

*!*	   CTRELAB=CTRELAB+1
*!*	   WAIT WINDOW  "Azzeramento Conti"+STR(CTRELAB,6,0) NOWAIT

*!*	   SELECT CONTICA
*!*	   SKIP +1

*!*	ENDDO


*!*	*!*	IF !ExecRW(cSql,"contica","W")
*!*	*!*	   return(.f.)
*!*	*!*	ENDIF

*!*	WAIT WINDOWS "Aggiornamento CONTICA fase 5 ....."  nowait
*!*	IF !ExecRW('','contica','I','','CONTICA')
*!*	   return(.f.)
*!*	ENDIF


*!*	** CREA IL CURSORE CONTENENTE SOLO I CONTI ELEMENTARI

*!*	CTRELAB=0

*!*	IF USED('CONTICA')
*!*	  SELECT CONTICA
*!*	  USE 
*!*	ENDIF

*!*	WAIT WINDOWS "Elaborazione CONTICA fase 6 ....."  nowait
*!*	x_soci = "con_soc = '" + PUB_CODSOC + "'"
*!*	x_anno = "con_anno = '" + PUB_ANNO + "'"
*!*	x_cond = x_soci + " and " + x_anno
*!*	Csql   = "select * from contica where " + x_cond + " order by con_soc,con_anno,con_conto"

*!*	*!*	IF !ExecCommand(cSql,"contica")
*!*	IF !ExecRW(cSql,"contica","R")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT contica
*!*	GO TOP

*!*	DO WHILE .T.

*!*	   IF EOF()
*!*	      EXIT
*!*	   ENDIF
*!*	   
*!*	   IF DELETED()
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF
*!*	 
*!*	   CODICE_CONTO=CON_CONTO
*!*	   IF (LEN(ALLTRIM(CODICE_CONTO))=2) .OR. (LEN(ALLTRIM(CODICE_CONTO))=4)
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   C_CONTO       = CON_CONTO
*!*	   C_ANNO        = CON_ANNO
*!*	   C_IMD         = CON_IMP_D
*!*	   C_IMA         = CON_IMP_A
*!*	   VPOSBIL       = CON_POSBIL
*!*	   DA01=CON_DA01
*!*	   AV01=CON_AV01
*!*	   DA02=CON_DA02
*!*	   AV02=CON_AV02
*!*	   DA03=CON_DA03
*!*	   AV03=CON_AV03
*!*	   DA04=CON_DA04
*!*	   AV04=CON_AV04
*!*	   DA05=CON_DA05
*!*	   AV05=CON_AV05
*!*	   DA06=CON_DA06
*!*	   AV06=CON_AV06
*!*	   DA07=CON_DA07
*!*	   AV07=CON_AV07
*!*	   DA08=CON_DA08
*!*	   AV08=CON_AV08
*!*	   DA09=CON_DA09
*!*	   AV09=CON_AV09
*!*	   DA10=CON_DA10
*!*	   AV10=CON_AV10
*!*	   DA11=CON_DA11
*!*	   AV11=CON_AV11
*!*	   DA12=CON_DA12
*!*	   AV12=CON_AV12

*!*	   * SOMMA I DARE/AVERE
*!*	   TDA = DA01+DA02+DA03+DA04+DA05+DA06+DA07+DA08+DA09+DA10+DA11+DA12
*!*	   TAV = AV01+AV02+AV03+AV04+AV05+AV06+AV07+AV08+AV09+AV10+AV11+AV12

*!*	   IF TDA = 0  .AND.  TAV  = 0   && NON CARICA I CONTI CON IMPORTI A ZERO
*!*	      SKIP +1
*!*	      LOOP
*!*	   ENDIF

*!*	   SELECT BILANCIO
*!*	   APPEND BLANK
*!*	   REPLACE  COD_CONTO WITH  C_CONTO
*!*	   REPLACE  POSBIL    WITH  VPOSBIL
*!*	   REPLACE  COD_ANNO  WITH  C_ANNO
*!*	   REPLACE  IMP_D     WITH  C_IMD
*!*	   REPLACE  IMP_A     WITH  C_IMA
*!*	   REPLACE  D01       WITH  DA01
*!*	   REPLACE  A01       WITH  AV01
*!*	   REPLACE  D02       WITH  DA02
*!*	   REPLACE  A02       WITH  AV02
*!*	   REPLACE  D03       WITH  DA03
*!*	   REPLACE  A03       WITH  AV03
*!*	   REPLACE  D04       WITH  DA04
*!*	   REPLACE  A04       WITH  AV04
*!*	   REPLACE  D05       WITH  DA05
*!*	   REPLACE  A05       WITH  AV05
*!*	   REPLACE  D06       WITH  DA06
*!*	   REPLACE  A06       WITH  AV06
*!*	   REPLACE  D07       WITH  DA07
*!*	   REPLACE  A07       WITH  AV07
*!*	   REPLACE  D08       WITH  DA08
*!*	   REPLACE  A08       WITH  AV08
*!*	   REPLACE  D09       WITH  DA09
*!*	   REPLACE  A09       WITH  AV09
*!*	   REPLACE  D10       WITH  DA10
*!*	   REPLACE  A10       WITH  AV10
*!*	   REPLACE  D11       WITH  DA11
*!*	   REPLACE  A11       WITH  AV11
*!*	   REPLACE  D12       WITH  DA12
*!*	   REPLACE  A12       WITH  AV12

*!*	   SELECT CONTICA
*!*	   SKIP +1

*!*	   CTRELAB=CTRELAB+1
*!*	   WAIT WINDOW  "Conti Elementari "+STR(CTRELAB,6,0) NOWAIT

*!*	ENDDO

*!*	** RIELABORA IL CURSORE PER AGGIORNARE IL DB.CONTICA

*!*	CTRELAB         = 0
*!*	PAT_DARE        = 0
*!*	PAT_AVERE       = 0
*!*	PAT_ATTIVO      = 0
*!*	PAT_PASSIVO     = 0
*!*	PAT_SALDO       = 0
*!*	ECO_DARE        = 0
*!*	ECO_AVERE       = 0
*!*	ECO_ATTIVO      = 0
*!*	ECO_PASSIVO     = 0
*!*	ECO_SALDO       = 0
*!*	TOT_DARE        = 0
*!*	TOT_AVERE       = 0
*!*	TOT_ATTIVO      = 0
*!*	TOT_PASSIVO     = 0
*!*	TOT_SALDO       = 0

*!*	SELECT BILANCIO
*!*	GO TOP

*!*	DO WHILE .T.

*!*	   IF EOF()
*!*	      EXIT
*!*	   ENDIF
*!*	   
*!*	   C_CONTO  = COD_CONTO
*!*	   C_ANNO   = COD_ANNO
*!*	   V_CERCA4 = SUBSTR(C_CONTO,1,4)
*!*	   V_CERCA2 = SUBSTR(C_CONTO,1,2)
*!*	   C_IMD    = 0
*!*	   C_IMA    = 0

*!*	   DECLARE VETTORE_D(12)
*!*	   DECLARE VETTORE_A(12)

*!*	   *===>>> AZZERO I VETTORI DARE / AVERE
*!*	 
*!*	   FOR I=1 TO 12
*!*	       VETTORE_D[I]=0
*!*	       VETTORE_A[I]=0
*!*	   NEXT

*!*	   *===>>> CARICO IL VETTORE CON I DARE/AVERE DEL CONTO ELEMENTARE

*!*	   FOR I=SA TO SM
*!*	       IF I < 10
*!*	          S_I='0'+STR(I,1,0)
*!*	       ELSE
*!*	          S_I=STR(I,2,0)
*!*	       ENDIF
*!*	       VET_D='D'+S_I
*!*	       VET_A='A'+S_I
*!*	       DD=&VET_D              && CARCA I MESI DEL DETTAGLIO CONTO IN DD/AA
*!*	       AA=&VET_A
*!*	       VETTORE_D[I]=DD        && ASSEGNA IL CONTENUTO
*!*	       VETTORE_A[I]=AA
*!*	       C_IMD  = C_IMD + DD    && SOMMA NEL TOTALE GENERALE
*!*	       C_IMA  = C_IMA + AA
*!*	       IF POSBIL="P"
*!*	          PAT_DARE  =PAT_DARE+VETTORE_D[I]
*!*	          PAT_AVERE =PAT_AVERE+VETTORE_A[I]
*!*	          PAT_SALDO =PAT_SALDO+VETTORE_D[I]-VETTORE_A[I]
*!*	          IF VETTORE_D[I]-VETTORE_A[I]>=0
*!*	             PAT_ATTIVO=PAT_ATTIVO+VETTORE_D[I]-VETTORE_A[I]
*!*	          ELSE
*!*	             PAT_PASSIVO=PAT_PASSIVO-VETTORE_D[I]-VETTORE_A[I]
*!*	          ENDIF
*!*	       ENDIF
*!*	       IF POSBIL="E"
*!*	          ECO_DARE  =ECO_DARE+VETTORE_D[I]
*!*	          ECO_AVERE =ECO_AVERE+VETTORE_A[I]
*!*	          ECO_SALDO =ECO_SALDO+VETTORE_D[I]-VETTORE_A[I]
*!*	          IF VETTORE_D[I]-VETTORE_A[I]>=0
*!*	             ECO_ATTIVO=ECO_ATTIVO+VETTORE_D[I]-VETTORE_A[I]
*!*	          ELSE
*!*	             ECO_PASSIVO=ECO_PASSIVO-VETTORE_D[I]-VETTORE_A[I]
*!*	          ENDIF
*!*	       ENDIF
*!*	   NEXT

*!*	   SELECT BILANCIO
*!*	   SKIP +1

*!*	   CTRELAB=CTRELAB+1
*!*	   WAIT WINDOW  "Calcolo Bilancio"+STR(CTRELAB,6,0) NOWAIT

*!*	ENDDO

*!*	TOT_DARE    = PAT_DARE    +  ECO_DARE
*!*	TOT_AVERE   = PAT_AVERE   +  ECO_AVERE
*!*	TOT_ATTIVO  = PAT_ATTIVO  +  ECO_ATTIVO
*!*	TOT_PASSIVO = PAT_PASSIVO +  ECO_PASSIVO
*!*	TOT_SALDO   = PAT_SALDO   +  ECO_SALDO

*!*	DO FORM FORM\BILRIE LINKED

*!*	RETURN



**=> ERASMO - INIZIO 18/07/2011

DECLARE VETTORE_D[12]
DECLARE VETTORE_A[12]  
DECLARE TOTALE_D[12]
DECLARE TOTALE_A[12]

RELEASE SA,SM,M.AL,M.DAL,M.ANDAL,M.ANAL,V_PNPC,V_QTPN,V_RISA,V_CHIMAN,V_RISA_ALL
PUBLIC SA,SM,M.AL,M.DAL,M.ANDAL,M.ANAL,V_PNPC,V_QTPN,V_RISA,V_CHIMAN,V_RISA_ALL
M.DAL    = SPACE(2)
M.AL     = SPACE(2)
M.ANDAL  = PUB_ANNO
M.ANAL   = PUB_ANNO
SA       = 1
SM       = 12
V_PNPC   = .T.
V_QTPN   = .T.
V_RISA   = .F.
V_CHIMAN = .F.
V_RISA_ALL = .T.

*!*	*** SIMONE - 14/09/2009 - FINE
*!*	IF (SA > 12) .OR. (SA < 1)
*!*	   PUB_ERRORE=MESSAGEBOX('Mese digitato'+CHR(13)+'in periodo dal : non valido',64,'*** ATTENZIONE ***') 
*!*	   RETURN .F.
*!*	ENDIF
*!*	IF (SM > 12) .OR. (SM < 1)
*!*	   PUB_ERRORE=MESSAGEBOX('Mese digitato'+CHR(13)+'in periodo al : non valido',64,'*** ATTENZIONE ***') 
*!*	   RETURN .F.
*!*	ENDIF
*!*	*** SIMONE - 14/09/2009 - FINE


**************************************************************************
*                     CALCOLO DEL BILANCIO                               *
**************************************************************************


***************************************************************************************
__CODICE_DA_RICERCARE	= "100"		&& VERIFICA SE AGGIORNAMENTO PRIMA NOTA IN CORSO
__VALORE_DA_AGGIORNARE	= "SI"
__ELABORAZIONE_IN_CORSO=VERIFICA_ELABORAZIONI_CONTABILI(__CODICE_DA_RICERCARE)
IF __ELABORAZIONE_IN_CORSO = "SI"
   RETURN(.F.)
ENDIF
***************************************************************************************

***************************************************************************************
__CODICE_DA_RICERCARE	= "200"		&& VERIFICA SE CALCOLO BILANCIO IN CORSO
__VALORE_DA_AGGIORNARE	= "SI"
__ELABORAZIONE_IN_CORSO=VERIFICA_ELABORAZIONI_CONTABILI(__CODICE_DA_RICERCARE)
IF __ELABORAZIONE_IN_CORSO = "SI"
   RETURN(.F.)
ENDIF
***************************************************************************************

***************************************************************************************
__CODICE_DA_RICERCARE	= "300"		&& VERIFICA SE CARICAMENTO BOLLATO IVA IN CORSO
__VALORE_DA_AGGIORNARE	= "SI"
__ELABORAZIONE_IN_CORSO=VERIFICA_ELABORAZIONI_CONTABILI(__CODICE_DA_RICERCARE)
IF __ELABORAZIONE_IN_CORSO = "SI"
   RETURN(.F.)
ENDIF
***************************************************************************************

*!*	PUB_ERRORE=MESSAGEBOX('Sei sicuro di voler fare il calcolo del bilancio ' + CHR(13) + ;
*!*	                      'Ricordati di fare prima i controlli preventivi',292,'*** ATTENZIONE ***') 
*!*	DO CASE
*!*	   CASE PUB_ERRORE= 7  && RISPOSTA NO
*!*			THISFORM.REFRESH
*!*			RETURN
*!*	ENDCASE

*********************************************************************************
WAIT WINDOWS "Fase 0 : ricreazione parametro bil in corso "  nowait
DO parabil2 										&& ricrea parametro bil 
WAIT WINDOWS "Fase 1 : Calcolo bilancio in corso attendere prego "  nowait


*!*	*!*	IF V_RISA_ALL
*!*		thisform.ricrea_saldi_anno_dec()		&& ricrea i saldi di tutto l'anno sino al mese corrente automatico e arrotonda a due decimali UNA SOLA VOLTA
*!*	*!*	ENDIF
**==> RICREA SALDI SEMPRE A PRESCINDERE DI QUELLO CHE VUOLE L'UTENTE

*IF !ExecCommand("select * from CONTI_DEC where 0=1","CONTI_DEC")
IF !ExecCommand("select * from CONTI where 0=1","CONTI_DEC")  && ERASMO - 25/05/2011
  return(.f.)
ENDIF
SELECT CONTI_DEC
AA = AFIELDS(BB)
CREATE CURSOR CU_CONTI_DEC FROM ARRAY BB	
INDEX ON CON_SOC + CON_ANNO + CON_CONTO TAG I_CONTO ADDITIVE



AA = PUB_ANNO
MM = STR(SA,2,0)
IF LEN(ALLTRIM(MM)) = 2
ELSE
   MM = '0' + ALLTRIM(MM)
ENDIF
GG = '01'
DDAL = GG + "/" + MM + "/" + AA

AA = PUB_ANNO
__SM = 12				&& VALORE FISSO
MM = STR(__SM,2,0)
IF LEN(ALLTRIM(MM)) = 2
ELSE
   MM = '0' + ALLTRIM(MM)
ENDIF
GG = '31'
IF VAL(MM) = 2
   GG = '28'
ENDIF
IF VAL(MM) = 4 .OR. VAL(MM) = 6 .OR. VAL(MM) = 9 .OR. VAL(MM) = 11
   GG = '30'
ENDIF
DAL = GG + "/" + MM + "/" + AA


PUBLIC QU,F_CHIUSURA,F_CHIMAN,MESE,V_INCRO,MESEXX
QU         = 0
F_CHIUSURA = .F.
V_INCRO    = .F.


IF V_CHIMAN 
   F_CHIMAN = .T.
ELSE
   F_CHIMAN = .F.
ENDIF  

*** AZZERAMENTO CONTI

*WAIT WINDOW "Stò azzerando i saldi e ricreo CONTI_DEC"  TIMEOUT 2
WAIT WINDOW "Sto azzerando i saldi e ricreo CONTI"  TIMEOUT 2  && ERASMO - 25/05/2011

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"CONTI","R")
   return(.f.)
ENDIF
SELECT CONTI
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   MESE = SA
   __CONTOX = CON_CONTO
   __DESCRX = CON_DESCR

   DO WHILE .T.
    
      IF MESE > __SM
         EXIT
      ENDIF
    
      V_MM = STR(MESE,2,0)
      IF LEN(ALLTRIM(V_MM)) = 2
      ELSE
         V_MM = '0' + ALLTRIM(V_MM)
      ENDIF

	  REPLACE CON_DA&V_MM WITH 0
	  REPLACE CON_AV&V_MM WITH 0

      MESE = MESE +1
       
   ENDDO


    SCATTER MEMVAR MEMO

	*!*	_________________________________________________________________________CREA CU_CONTI_DEC CON I CONTI : GRUPPO !! SOTTOGRUPPO !! CONTO ELEMENTARE
	SELECT CU_CONTI_DEC  
	SET ORDER TO I_CONTO
	___SEEK = PUB_CODSOC+PUB_ANNO+ALLTRIM(__CONTOX)

	SEEK ___SEEK 
	IF !FOUND()
		APPEND BLANK
		GATHER MEMVAR MEMO
	ENDIF
	*!*	_________________________________________________________________________CREA CU_CONTI_DEC CON I CONTI : GRUPPO!!-SOTTOGRUPPO!!-CONTO ELEMENTARE AZZERANDOLI


    	
   SELECT CONTI
   SKIP +1

ENDDO  



SELECT CU_CONTI_DEC 
GO TOP


WAIT WINDOW "Stò aggiornando i saldi"  TIMEOUT 2  

**** ELABORO INDICE PER CACOLARE DARE / AVERE VALORIZZATI AL CAMBIO DELLA SINGOLA REGISTRAZIONE

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
cSql="SELECT * FROM INDICE WHERE " + x_cond + " order by mov_soc,mov_anno,mov_dtreg"
IF !ExecCommand(cSql,"INDICE")
    return(.f.)
ENDIF
SELECT INDICE
GO TOP

DO WHILE .T.
   
  IF EOF()
     EXIT
  ENDIF
  
  IF DELETED()
     SKIP +1
     LOOP
  ENDIF
  
  IF MOV_TOP = "CHI"
     IF !F_CHIUSURA 		&& NON TRATTA I MOVIMENTI DI CHIUSURA
        SKIP +1
        LOOP
     ENDIF	
  ENDIF

  M.MOV_NUMPRO = MOV_NUMPRO
  _DARE        = 0
  _AVERE       = 0
  
  *THISFORM.VQUADRA(M.MOV_NUMPRO)
	*#### INIZIO VQUADRA ########################################################
	_NUMPRO = M.MOV_NUMPRO

	IF !ExecCommand("select * from mov_cont where 0=1","mov_cont")
	   return(.f.)
	ENDIF
	SELECT MOV_CONT
	AA=AFIELDS(ASD)
	CREATE CURSOR WW_TEMPO FROM ARRAY ASD

	x_soci = "mov_soc = '" + PUB_CODSOC + "'"
	x_anno = "mov_anno = '" + PUB_ANNO + "'"
	x_nume = "mov_numpro = '" + ALLTRIM(_NUMPRO) + "'"
	x_cond = x_soci + " and " + x_anno + " and " + x_nume
	cSql="SELECT * FROM MOV_CONT WHERE " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
	IF !ExecCommand(cSql,"MOV_CONT")
	   return(.f.)
	ENDIF
	SELECT MOV_CONT
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
	      
	  	  _TMOV     = MOV_TMOV
		  _TOP      = MOV_TOP
		  _IMP      = MOV_IMP
		  _CAMBIO   = MOV_CAMBIO
		  _CODVAL   = MOV_VALUTA
		  _SOC	    = MOV_SOC
		  _ANNO	    = MOV_ANNO
		  _CONTO	= MOV_CONTO
	*!*		  _VALORE   = CAMBIO(_CODVAL,_IMP,_CAMBIO,(_SOC+_ANNO+_CONTO))
		  _VALORE   = CAMBIO(_CODVAL,_IMP,_CAMBIO,(_SOC+_ANNO+_CONTO),.F.,10)  && ERASMO - 20/05/2011

		  IF SUBSTR(_TMOV,1,1)='A'
		     _AVERE = _AVERE + _VALORE
		  ENDIF
		  IF SUBSTR(_TMOV,1,1)='D'
		     _DARE  = _DARE + _VALORE
		  ENDIF

	      SELECT MOV_CONT
	      SCATTER MEMVAR  && MEMO
	      SELECT WW_TEMPO
	      APPEND BLANK
	      GATHER MEMVAR && MEMO
	      SELECT MOV_CONT
	      SKIP +1
	   ENDDO
	ELSE
	   WAIT WINDOW "Non trovato il numero interno di legame INDICE - MOV_CONT "+_NUMPRO
	ENDIF
	*#### FINE VQUADRA   ########################################################
  

  WAIT WINDOWS "Ricalcola Saldi per registrazione con numero interno (NUMPRO) : "+ M.MOV_NUMPRO NOWAIT

  _DIFDA = _DARE - _AVERE

  *THISFORM.RICALCOLA_DEC(.F.,.F.,ABS(_DIFDA))
	*#### INIZIO RICALCOLA_DEC ########################################################
	AGG_D   = .F.
	AGG_A   = .F.
	DIFLIRA = ABS(_DIFDA)

	SELECT WW_TEMPO
	GO TOP

	QU = 0

	DO WHILE !EOF()

	    *** AGGIORNO IL DATABASES CONTI

	    DA  = 0
	    AV  = 0

	    IF MOV_TMOV  = "D" .OR. MOV_TMOV  = "A"
	    ELSE
		  WAIT WINDOW "Registrazione senza D/A"+STR(MOV_NREGIS,10,0)+"<<<<<<<<<<<<"
		  SELECT WW_TEMPO
		  SKIP +1
		  LOOP
	    ENDIF

	    IF MOV_TMOV  = "D"
	      DA =   CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO,(MOV_SOC+MOV_ANNO+MOV_CONTO),.F.,10) && ERASMO - 20/05/2011
	    ENDIF
	    IF MOV_TMOV  = "A"
	      AV =   CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO,(MOV_SOC+MOV_ANNO+MOV_CONTO),.F.,10) && ERASMO - 20/05/2011
	    ENDIF
	     
	    XCONTO  = MOV_CONTO 
	    DATAREG = MOV_DTREG 
	      
	 
		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO ELEMENTARE SU CU_CONTI_DEC
		SELECT CU_CONTI_DEC  
		SET ORDER TO I_CONTO
		___SEEK = PUB_CODSOC+PUB_ANNO+ALLTRIM(XCONTO)
		SEEK ___SEEK 
		IF FOUND()
			MESEXX   = SUBSTR(DATAREG,6,2)
			D_ARE    = "CON_DA"+MESEXX
			A_VERE   = "CON_AV"+MESEXX
			P_IMPD   = CON_IMP_D
			P_IMPA   = CON_IMP_A
			IF DA <> 0
			   REPLACE &D_ARE      WITH &D_ARE+DA   && SINGOLO MESE
			ENDIF
			IF AV <> 0
			   REPLACE &A_VERE     WITH &A_VERE+AV  && SINGOLO MESE
			ENDIF	 
		ELSE
	        WAIT WINDOW "RICALCOLA_DEC 001 : Conto inesistente :"+___SEEK 
		ENDIF
		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO ELEMENTARE SU CU_CONTI_DEC


		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO SOTTOGRUPPO SU CU_CONTI_DEC
		SELECT CU_CONTI_DEC  
		SET ORDER TO I_CONTO
		___SEEK = PUB_CODSOC+PUB_ANNO+ALLTRIM(SUBSTR(XCONTO,1,PUB_SOTTOG-1))
		SEEK ___SEEK 
		IF FOUND()
			MESEXX   = SUBSTR(DATAREG,6,2)
			D_ARE    = "CON_DA"+MESEXX
			A_VERE   = "CON_AV"+MESEXX
			P_IMPD   = CON_IMP_D
			P_IMPA   = CON_IMP_A
			IF DA <> 0
			   REPLACE &D_ARE      WITH &D_ARE+DA   && SINGOLO MESE
			ENDIF
			IF AV <> 0
			   REPLACE &A_VERE     WITH &A_VERE+AV  && SINGOLO MESE
			ENDIF	 
		ELSE
	        WAIT WINDOW "RICALCOLA_DEC 002 : Conto inesistente :"+___SEEK 
		ENDIF
		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO SOTTOGRUPPO SU CU_CONTI_DEC
		

		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO MASTRO SU CU_CONTI_DEC
		SELECT CU_CONTI_DEC  
		SET ORDER TO I_CONTO
		___SEEK = PUB_CODSOC+PUB_ANNO+ALLTRIM(SUBSTR(XCONTO,1,PUB_MASTRO-1))
		SEEK ___SEEK 
		IF FOUND()
			MESEXX   = SUBSTR(DATAREG,6,2)
			D_ARE    = "CON_DA"+MESEXX
			A_VERE   = "CON_AV"+MESEXX
			P_IMPD   = CON_IMP_D
			P_IMPA   = CON_IMP_A
			IF DA <> 0
			   REPLACE &D_ARE      WITH &D_ARE+DA   && SINGOLO MESE
			ENDIF
			IF AV <> 0
			   REPLACE &A_VERE     WITH &A_VERE+AV  && SINGOLO MESE
			ENDIF	 
		ELSE
	        WAIT WINDOW "RICALCOLA_DEC 003 : Conto inesistente :"+___SEEK 
		ENDIF
		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO MASTRO SU CU_CONTI_DEC

	   QU=QU+1
	  
	   SELECT WW_TEMPO
	   SKIP +1
	  
	ENDDO
	*#### FINE RICALCOLA_DEC   ########################################################
  
  SELECT INDICE
  SKIP +1
  
ENDDO


WAIT WINDOW "Stò ricalcolando il saldo totale "  TIMEOUT 1   

SELECT CU_CONTI_DEC 
SET ORDER TO I_CONTO
GO TOP
DO WHILE .NOT. EOF()

   	TDARE  = CON_DA01 + CON_DA02 + CON_DA03 + CON_DA04 + CON_DA05 + CON_DA06 + CON_DA07 + CON_DA08 + CON_DA09 + CON_DA10 + CON_DA11 + CON_DA12
   	TAVERE = CON_AV01 + CON_AV02 + CON_AV03 + CON_AV04 + CON_AV05 + CON_AV06 + CON_AV07 + CON_AV08 + CON_AV09 + CON_AV10 +	CON_AV11 + CON_AV12
	
   	REPLACE CON_IMP_D WITH TDARE
   	REPLACE CON_IMP_A WITH TAVERE

	SELECT CU_CONTI_DEC
	SKIP +1
	
ENDDO


SELECT CU_CONTI_DEC 
SET ORDER TO I_CONTO
GO TOP



** CONTROAGGIORNA IL DATABASE CONTI ARROTONDANDO UNA SOLA VOLTA A DUE DECIMALI E PRENDENDO I VALORI DA CU_CONTI_DEC

SELECT CONTI
GO TOP
DO WHILE .NOT. EOF()

    XCONTO = ALLTRIM(CON_CONTO)


	SELECT CU_CONTI_DEC  
	SET ORDER TO I_CONTO
	___SEEK = PUB_CODSOC+PUB_ANNO+ALLTRIM(XCONTO)
	SEEK ___SEEK 
	IF FOUND()

		SCATTER MEMVAR 
		
		MESE = SA
		
		SELECT CONTI
					
		DO WHILE .T.
		    
		    IF MESE > SM
		      EXIT
		    ENDIF
		    
		    V_MM = STR(MESE,2,0)
		    IF LEN(ALLTRIM(V_MM)) = 2
		    ELSE
		       V_MM = '0' + ALLTRIM(V_MM)   
		    ENDIF

			_DARE_10DEC		=ROUND(((M.CON_DA&V_MM)),10)
			_AVERE_10DEC	=ROUND(((M.CON_AV&V_MM)),10)

		    REPLACE CON_DA&V_MM WITH _DARE_10DEC
		    REPLACE CON_AV&V_MM WITH _AVERE_10DEC

		    MESE = MESE +1
		       
		ENDDO

		T_DARE_10DEC		=ROUND(((M.CON_IMP_D)),10)
		T_AVERE_10DEC		=ROUND(((M.CON_IMP_A)),10)

   		REPLACE CON_IMP_D WITH T_DARE_10DEC
   		REPLACE CON_IMP_A WITH T_AVERE_10DEC
		
		
	ELSE
        WAIT WINDOW "RICREA_SALDI_ANNO_DEC 001 : Conto inesistente :"+XCONTO  
	ENDIF


	SELECT CONTI
	SKIP +1
	
ENDDO
GO TOP

IF !ExecRW(cSql,"CONTI","W")
   return(.f.)
ENDIF

*WAIT WINDOWS "Fine ricalcolo saldi automatico ......" nowait

***************************************************************************
__CODICE_DA_RICERCARE	= "200"		&& INIZIO CALCOLO BILANCIO
__VALORE_DA_AGGIORNARE	= "SI"
=AGGIORNA_ELABORAZIONI_CONTABILI(__CODICE_DA_RICERCARE,__VALORE_DA_AGGIORNARE)
***************************************************************************


*DO FORM FORM\ATTENDI  LINKED


*!*	_________________________________________________________________________________________________AZZERA I GRUPPI/SOTTOGRUPPI E CREA CURSORE DI SUPPORTO CON 10 DECIMALI



IF !ExecCommand("select * from CONTI where 0=1","CU_BILANCIO")
  return(.f.)
ENDIF
SELECT CU_BILANCIO
AA = AFIELDS(BB)
CREATE CURSOR BILANCIO FROM ARRAY BB	
INDEX ON CON_SOC + CON_ANNO + CON_CONTO TAG I_CONTO ADDITIVE

*!*	_________________________________________________________________________SALVA I DATI RELATIVI AI CONTI ELEMENTERI SUL CURSORE DEL BILANCIO CON 10 DECIMALI

CTRELAB=0

SELECT CU_CONTI_DEC  
SET ORDER TO I_CONTO
GO TOP
DO WHILE .NOT. EOF()


   	IF DELETED()
		SELECT CU_CONTI_DEC
      	SKIP +1
      	LOOP
   	ENDIF    

   	CODICE_CONTO=CON_CONTO
  
   	IF (LEN(ALLTRIM(CODICE_CONTO))=PUB_MASTRO-1) .OR. (LEN(ALLTRIM(CODICE_CONTO))=PUB_SOTTOG-1)
		SELECT CU_CONTI_DEC
      	SKIP +1
      	LOOP
   	ENDIF

   	TDA = CON_DA01+CON_DA02+CON_DA03+CON_DA04+CON_DA05+CON_DA06+CON_DA07+CON_DA08+CON_DA09+CON_DA10+CON_DA11+CON_DA12
   	TAV = CON_AV01+CON_AV02+CON_AV03+CON_AV04+CON_AV05+CON_AV06+CON_AV07+CON_AV08+CON_AV09+CON_AV10+CON_AV11+CON_AV12
 
   	IF TDA = 0  .AND.  TAV  = 0   && NON CARICA I CONTI CON IMPORTI A ZERO
		SELECT CU_CONTI_DEC
		SKIP +1
      	LOOP
   	ENDIF    
      
	SCATTER MEMVAR MEMO
	
	SELECT BILANCIO  
	SET ORDER TO I_CONTO
	APPEND BLANK
	GATHER MEMVAR MEMO


   	CTRELAB=CTRELAB+1 
   
   	WAIT WINDOW  "Fase di creazione conti elementari in corso"+STR(CTRELAB,6,0) NOWAIT

	SELECT CU_CONTI_DEC  
	SKIP +1
	
ENDDO

          

CTRELAB=0



SELECT BILANCIO
SET ORDER TO I_CONTO
GO TOP

* WAIT WINDOW "FASE : AGGIORNAMENTO D.B. CONTI"
CTRELAB     = 0
PAT_DARE    = 0
PAT_AVERE   = 0
PAT_ATTIVO  = 0
PAT_PASSIVO = 0
PAT_SALDO   = 0
ECO_DARE    = 0
ECO_AVERE   = 0
ECO_ATTIVO  = 0
ECO_PASSIVO = 0
ECO_SALDO   = 0
TOT_DARE    = 0
TOT_AVERE   = 0
TOT_ATTIVO  = 0
TOT_PASSIVO = 0
TOT_SALDO   = 0



DO WHILE .T.

   IF EOF()    && RIELABORA IL CURSORE PER AGGIORNARE IL DB.CONTI
      EXIT
   ENDIF
   
   C_CONTO  = CON_CONTO
   C_ANNO   = CON_ANNO
   POSBIL   = CON_POSBIL
   
   V_CERCA4 = SUBSTR(C_CONTO,1,PUB_SOTTOG-1)
   V_CERCA2 = SUBSTR(C_CONTO,1,PUB_MASTRO-1)
   C_IMD    = 0
   C_IMA    = 0
    
   DECLARE VETTORE_D(12)
   DECLARE VETTORE_A(12)  
  
   *!*	_________________________________________________________________________________________________AZZERO I VETTORI DARE / AVERE
  
   FOR I=1 TO 12
       VETTORE_D[I]=0
       VETTORE_A[I]=0
   NEXT  
  
   *!*	_________________________________________________________________________________________________CARICO IL VETTORE CON I DARE/AVERE DEL CONTO ELEMENTARE
  
   FOR I=SA TO SM

       IF I < 10
          S_I='0'+STR(I,1,0)
       ELSE
          S_I=STR(I,2,0)
       ENDIF

       VET_D		=	'CON_DA'+S_I
       VET_A		=	'CON_AV'+S_I
       DD			=	&VET_D              	&& CARICA I MESI DEL DETTAGLIO CONTO IN DD/AA
       AA			=	&VET_A
       VETTORE_D[I]	=	DD        				&& ASSEGNA IL CONTENUTO
       VETTORE_A[I]	=	AA
       C_IMD  		= 	C_IMD + DD    			&& SOMMA NEL TOTALE GENERALE 
       C_IMA  		= 	C_IMA + AA

       IF POSBIL="P"
          PAT_DARE	=	PAT_DARE+VETTORE_D[I]
          PAT_AVERE	=	PAT_AVERE+VETTORE_A[I]
          PAT_SALDO	=	PAT_SALDO+VETTORE_D[I]-VETTORE_A[I]
 
          IF VETTORE_D[I]-VETTORE_A[I]>=0
             PAT_ATTIVO=PAT_ATTIVO+VETTORE_D[I]-VETTORE_A[I]
          ELSE
             PAT_PASSIVO=PAT_PASSIVO-VETTORE_D[I]-VETTORE_A[I]
          ENDIF  

       ENDIF  

       IF POSBIL="E"
          ECO_DARE	=	ECO_DARE+VETTORE_D[I]
          ECO_AVERE	=	ECO_AVERE+VETTORE_A[I]
          ECO_SALDO	=	ECO_SALDO+VETTORE_D[I]-VETTORE_A[I]

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


*!* ________________________________________________________________________________________CONTROAGGIORNA CONTI RIPORTANDO ARROTONDANDO UNA SOLA VOLTA I GRUPPI/SOTTOGRUPPI
*!* ________________________________________________________________________________________I CONTI ELEMENTARI SONO STATI AGGIORNATI NELLA FASE DI CREAZIONE SALDI
SELECT CU_CONTI_DEC  
SET ORDER TO I_CONTO
GO TOP
DO WHILE .NOT. EOF()


   	CODICE_CONTO=CON_CONTO
  
   	IF (LEN(ALLTRIM(CODICE_CONTO))=PUB_MASTRO-1) .OR. (LEN(ALLTRIM(CODICE_CONTO))=PUB_SOTTOG-1)
   	ELSE
		SELECT CU_CONTI_DEC
      	SKIP +1
      	LOOP
   	ENDIF



    SCATTER MEMVAR memo 
    
	x_soci 	= "con_soc = '" + PUB_CODSOC + "'"
	x_anno 	= "con_anno = '" + PUB_ANNO + "'"
	x_conto	= "con_conto = '" + M.CON_CONTO + "'"
	
	x_cond = x_soci + " and " + x_anno + " and " + x_conto
	Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
	IF !ExecRW(cSql,"CONTI","R")
	   return(.f.)
	ENDIF
	SELECT CONTI
	GO TOP
	IF !EOF()
		MESE = SA
		DO WHILE .T.
		    IF MESE > SM
		      EXIT
		    ENDIF
		    V_MM = STR(MESE,2,0)
		    IF LEN(ALLTRIM(V_MM)) = 2
		    ELSE
		       V_MM = '0' + ALLTRIM(V_MM)   
		    ENDIF
			_DARE_10DEC		=	ROUND(((M.CON_DA&V_MM)),10)			&& VARIABILI DI CU_CONTI_DEC
			_AVERE_10DEC	=	ROUND(((M.CON_AV&V_MM)),10)			&& VARIABILI DI CU_CONTI_DEC
		    REPLACE CON_DA&V_MM WITH _DARE_10DEC						&& AGGIORNO CONTI					
		    REPLACE CON_AV&V_MM WITH _AVERE_10DEC					&& AGGIORNO CONTI	
		    MESE = MESE +1
		ENDDO
		T_DARE_10DEC		=	ROUND(((M.CON_IMP_D)),10)				&& VARIABILI DI CU_CONTI_DEC
		T_AVERE_10DEC		=	ROUND(((M.CON_IMP_A)),10)				&& VARIABILI DI CU_CONTI_DEC
   		REPLACE CON_IMP_D 	WITH T_DARE_10DEC							&& AGGIORNO CONTI	
   		REPLACE CON_IMP_A 	WITH T_AVERE_10DEC							&& AGGIORNO CONTI	
	ENDIF
	IF !ExecRW(cSql,"CONTI","W")
	   return(.f.)
	ENDIF


	SELECT CU_CONTI_DEC  
	SKIP +1
	
ENDDO


*!*	PAT_DARE    = ROUND(PAT_DARE    ,2)    
*!*	PAT_AVERE   = ROUND(PAT_AVERE   ,2)
*!*	PAT_ATTIVO  = ROUND(PAT_ATTIVO  ,2)
*!*	PAT_PASSIVO = ROUND(PAT_PASSIVO ,2)
*!*	PAT_SALDO   = ROUND(PAT_SALDO   ,2)
*!*	ECO_DARE    = ROUND(ECO_DARE    ,2)
*!*	ECO_AVERE   = ROUND(ECO_AVERE   ,2)
*!*	ECO_ATTIVO  = ROUND(ECO_ATTIVO  ,2)
*!*	ECO_PASSIVO = ROUND(ECO_PASSIVO ,2)
*!*	ECO_SALDO   = ROUND(ECO_SALDO   ,2)

*!*	TOT_DARE	= PAT_DARE 		+ ECO_DARE
*!*	TOT_AVERE	= PAT_AVERE 	+ ECO_AVERE
*!*	TOT_ATTIVO	= PAT_ATTIVO 	+ ECO_ATTIVO
*!*	TOT_PASSIVO	= PAT_PASSIVO 	+ ECO_PASSIVO
*!*	TOT_SALDO	= PAT_SALDO 	+ ECO_SALDO


*!*	TOT_DARE    = ROUND(TOT_DARE    ,2)
*!*	TOT_AVERE   = ROUND(TOT_AVERE   ,2)
*!*	TOT_ATTIVO  = ROUND(TOT_ATTIVO  ,2)
*!*	TOT_PASSIVO = ROUND(TOT_PASSIVO ,2)
*!*	TOT_SALDO   = ROUND(TOT_SALDO   ,2)


PAT_DARE    = 0
PAT_AVERE   = 0
PAT_ATTIVO  = 0
PAT_PASSIVO = 0
PAT_SALDO   = 0
ECO_DARE    = 0
ECO_AVERE   = 0
ECO_ATTIVO  = 0
ECO_PASSIVO = 0
ECO_SALDO   = 0
TOT_DARE	= 0
TOT_AVERE	= 0
TOT_ATTIVO	= 0
TOT_PASSIVO	= 0
TOT_SALDO	= 0


V_CONTI="01,02,03,99"
v_seek 	 = "DTE_CO"+PUB_CODSOC     && PARAMETRO - DATI TESTATA RIGA 3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CONTI=ALLTRIM(LIBERA)
ENDIF
V_ECODAL = STR_EXTRACT(V_CONTI,",",1)
V_ECOAL  = STR_EXTRACT(V_CONTI,",",2)
V_PATDAL = STR_EXTRACT(V_CONTI,",",3)
V_PATAL  = STR_EXTRACT(V_CONTI,",",4)
V_DAL    = SA
V_AL     = SM
_DB = "XCONTI"
=SALDIATT(_DB)	&& AGGIUNGE I SALDI DELL'ANNO PRECEDENTE
STAMPA_SOLO_I_CLIENTI_FORNITORI = .F.
NON_STAMPA_I_CLIENTI_FORNITORI  = .F.
ANNOP__ = ""
STAMPA_SOLO_I_GRUPPI_SOTTOGRUPPI = .F.
OK_SALDI = .T.  && Non stampa i  conti con saldo  a zero

WAIT WINDOW "Attendere elaborazione bilancio in corso ..." NOWAIT
VA_TOTALE = 0
VD_TOTALE = 0
DO SBC400 WITH "P",V_ECODAL,V_ECOAL,V_DAL,V_AL,PUB_ANNO,_DB,STAMPA_SOLO_I_CLIENTI_FORNITORI,STAMPA_SOLO_I_GRUPPI_SOTTOGRUPPI,ANNOP__,NON_STAMPA_I_CLIENTI_FORNITORI
PAT_DARE    = round(va_totale,2)
PAT_AVERE   = round(vd_totale,2)
PAT_SALDO   = round(va_totale,2)-round(vd_totale,2)

VA_TOTALE = 0
VD_TOTALE = 0
DO SBC400 WITH "E",V_PATDAL,V_PATAL,V_DAL,V_AL,PUB_ANNO,_DB,STAMPA_SOLO_I_CLIENTI_FORNITORI,STAMPA_SOLO_I_GRUPPI_SOTTOGRUPPI,ANNOP__,NON_STAMPA_I_CLIENTI_FORNITORI

ECO_DARE    = round(va_totale,2)
ECO_AVERE   = round(vd_totale,2)
ECO_SALDO   = round(va_totale,2)-round(vd_totale,2)

TOT_SALDO	= PAT_SALDO + ECO_SALDO

IF TOT_SALDO <> 0 .AND. ABS(TOT_SALDO) < 0.10
	*** SE HO UNO SBILANCIO MINORE DI +/- 10 CENT. FACCIO UN UPDATE 
	*** DEL PRIMO CONTO CHE TROVO SULL'ANNO E RICALCOLO I SALDI
	_strdelta = ALLTRIM(STRTRAN(STR(TOT_SALDO,20,2),',','.'))
	x_soci = "con_soc = '" + PUB_CODSOC + "'"
	x_anno = "con_anno = '" + PUB_ANNO + "'"
	x_cont = "LEN(CON_CONTO) >= "+ ALLTRIM(STR(PUB_SOTTOG))
	x_pbil = "CON_POSBIL = 'P'"
	x_cimp = "CON_IMP_D <> CON_IMP_A"
	x_cond = x_soci + " and " + x_anno + " and " + x_cont + " and " + x_pbil + " and " + x_cimp 
	Csql   = "UPDATE CONTI SET CON_DA01 = CON_DA01 - (&_strdelta) , CON_IMP_D = CON_IMP_D - (&_strdelta) where CON_CONTO IN " + ;
			"(SELECT TOP 1 CON_CONTO FROM CONTI WHERE " + x_cond + " ORDER BY CON_CONTO ) AND " + x_anno
	IF !ExecCommand(Csql,"UPD_CONTI")
	   return(.f.)
	ENDIF

	_DB = "XCONTI"
	=SALDIATT(_DB)	&& AGGIUNGE I SALDI DELL'ANNO PRECEDENTE
	WAIT WINDOW "Attendere elaborazione bilancio in corso ..." NOWAIT
	VA_TOTALE = 0
	VD_TOTALE = 0
	DO SBC400 WITH "P",V_ECODAL,V_ECOAL,V_DAL,V_AL,PUB_ANNO,_DB,STAMPA_SOLO_I_CLIENTI_FORNITORI,STAMPA_SOLO_I_GRUPPI_SOTTOGRUPPI,ANNOP__,NON_STAMPA_I_CLIENTI_FORNITORI
	PAT_DARE    = round(va_totale,2)
	PAT_AVERE   = round(vd_totale,2)
	PAT_SALDO   = round(va_totale,2)-round(vd_totale,2)

	VA_TOTALE = 0
	VD_TOTALE = 0
	DO SBC400 WITH "E",V_PATDAL,V_PATAL,V_DAL,V_AL,PUB_ANNO,_DB,STAMPA_SOLO_I_CLIENTI_FORNITORI,STAMPA_SOLO_I_GRUPPI_SOTTOGRUPPI,ANNOP__,NON_STAMPA_I_CLIENTI_FORNITORI

	ECO_DARE    = round(va_totale,2)
	ECO_AVERE   = round(vd_totale,2)
	ECO_SALDO   = round(va_totale,2)-round(vd_totale,2)

	TOT_SALDO	= PAT_SALDO + ECO_SALDO

ENDIF

WAIT CLEAR



*THISFORM.Hide

DO FORM FORM\BILRIE LINKED

*THISFORM.Show


SET CURSOR ON



***************************************************************************
__CODICE_DA_RICERCARE	= "200"		&& FINE  CALCOLO BILANCIO
__VALORE_DA_AGGIORNARE	= ""
=AGGIORNA_ELABORAZIONI_CONTABILI(__CODICE_DA_RICERCARE,__VALORE_DA_AGGIORNARE)
***************************************************************************


PUB_ERRORE=MESSAGEBOX('Calcolo bilancio '+CHR(13)+'terminato correttamente',64,'*** ATTENZIONE ***') 

*RELEASE THISFORM
RETURN

**=> ERASMO - FINE 18/07/2011

