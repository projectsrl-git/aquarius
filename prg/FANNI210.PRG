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
 


RELEASE CONTO_PEP,CONTO_UTI,CONTO_PER,CONTO_CHI,CONTO_APE,V_ANNO,V_GGCHI,V_MMCHI,V_AACHI,V_GGAPE,V_MMAPE,V_AAAPE,CODICE,DESCRI
PUBLIC CONTO_PEP,CONTO_UTI,CONTO_PER,CONTO_CHI,CONTO_APE,V_ANNO,V_GGCHI,V_MMCHI,V_AACHI,V_GGAPE,V_MMAPE,V_AAAPE,CODICE,DESCRI

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
   CONTO_PEP=ALLTRIM(FIN_PROPER)       && PROFITTI E PERDITE
   CONTO_UTI=ALLTRIM(FIN_UTIESE)       && UTILE D'ESERCIZIO
   CONTO_PER=ALLTRIM(FIN_PERESE)       && PERDITA D'ESERCIZIO
   CONTO_CHI=ALLTRIM(FIN_BILCHI)       && BILANCIO DI CHIUSURA
   CONTO_APE=ALLTRIM(FIN_BILAPE)       && BILANCIO D'APERTURA
   V_CONT1=ALLTRIM(FIN_BILCHI)         && BILANCIO DI APERTURA
   V_CONT2=ALLTRIM(FIN_BILAPE)         && BILANCIO DI CHIUSURA
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
    
       * 2) PER OGNI CONTO ELEMENTARE IN ELABORAZIONE CALCOLO DEL SALDO ###############################################################################################

       HO_CONTO = ALLTRIM(CON_CONTO)
       V_DIFF   = 0
       
       ** SERGIO 09/02/2023 INIZIO
*!*	       IF LEN(ALLTRIM(CON_CONTO))> (PUB_SOTTOG-1)
*!*	          V_TOTDA1 = CON_DA01+CON_DA02+CON_DA03+CON_DA04+CON_DA05+CON_DA06+CON_DA07+CON_DA08+CON_DA09+CON_DA10+CON_DA11+CON_DA12
*!*	          V_TOTAV1 = CON_AV01+CON_AV02+CON_AV03+CON_AV04+CON_AV05+CON_AV06+CON_AV07+CON_AV08+CON_AV09+CON_AV10+CON_AV11+CON_AV12
*!*	          V_DIFF   = V_TOTDA1 - V_TOTAV1
*!*	       ENDIF 
       IF PUB_CONTOSIMILCEE 
       
			IF IS_GRUPPO_CONTI(CON_CONTO) && TRATTA SOLO I CONTI ELEMENTARI
          	ELSE
 	          V_TOTDA1 = CON_DA01+CON_DA02+CON_DA03+CON_DA04+CON_DA05+CON_DA06+CON_DA07+CON_DA08+CON_DA09+CON_DA10+CON_DA11+CON_DA12
	          V_TOTAV1 = CON_AV01+CON_AV02+CON_AV03+CON_AV04+CON_AV05+CON_AV06+CON_AV07+CON_AV08+CON_AV09+CON_AV10+CON_AV11+CON_AV12
	          V_DIFF   = V_TOTDA1 - V_TOTAV1
          	ENDIF
          	
       ELSE

			IF LEN(ALLTRIM(CON_CONTO))> (PUB_SOTTOG-1)
	          V_TOTDA1 = CON_DA01+CON_DA02+CON_DA03+CON_DA04+CON_DA05+CON_DA06+CON_DA07+CON_DA08+CON_DA09+CON_DA10+CON_DA11+CON_DA12
	          V_TOTAV1 = CON_AV01+CON_AV02+CON_AV03+CON_AV04+CON_AV05+CON_AV06+CON_AV07+CON_AV08+CON_AV09+CON_AV10+CON_AV11+CON_AV12
	          V_DIFF   = V_TOTDA1 - V_TOTAV1
	      	ENDIF 
	      	
       ENDIF
       ** SERGIO 09/02/2023 FINE 


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


*!*	   IF (LEN(ALLTRIM(CODICE_CONTO))=2) .OR. (LEN(ALLTRIM(CODICE_CONTO))=4)
*!*	   IF (LEN(ALLTRIM(CODICE_CONTO))=(PUB_MASTRO-1)) .OR. (LEN(ALLTRIM(CODICE_CONTO))=(PUB_SOTTOG-1))
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


   ** SERGIO 09/02/2023 INIZIO
   IF PUB_CONTOSIMILCEE 
   
		IF IS_GRUPPO_CONTI(CODICE_CONTO) 																		&& AZZERA I CONTI NON ELEMENTARI 
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

   ELSE
	*!*	   IF (LEN(ALLTRIM(CODICE_CONTO))=2) .OR. (LEN(ALLTRIM(CODICE_CONTO))=4)
	   IF (LEN(ALLTRIM(CODICE_CONTO))=(PUB_MASTRO-1)) .OR. (LEN(ALLTRIM(CODICE_CONTO))=(PUB_SOTTOG-1))			&& AZZERA I CONTI NON ELEMENTARI
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
   ENDIF
   ** SERGIO 09/02/2023 FINE 




   CTRELAB=CTRELAB+1
   WAIT WINDOW  "Azzeramento Conti"+STR(CTRELAB,6,0) NOWAIT

   SELECT CONTICA
   SKIP +1

ENDDO

***-------------------------------


WAIT WINDOWS "Aggiornamento CONTICA fase 5 ....."  nowait
IF !ExecRW('','contica','I','','CONTICA')
   return(.f.)
ENDIF


*!*	   CONTO_PEP=ALLTRIM(FIN_PROPER)       && PROFITTI E PERDITE
*!*	   CONTO_UTI=ALLTRIM(FIN_UTIESE)       && UTILE D'ESERCIZIO
*!*	   CONTO_PER=ALLTRIM(FIN_PERESE)       && PERDITA D'ESERCIZIO
*!*	   CONTO_CHI=ALLTRIM(FIN_BILCHI)       && BILANCIO DI CHIUSURA
*!*	   CONTO_APE=ALLTRIM(FIN_BILAPE)       && BILANCIO D'APERTURA
*!*	   V_CONT1=ALLTRIM(FIN_BILCHI)         && BILANCIO DI APERTURA
*!*	   V_CONT2=ALLTRIM(FIN_BILAPE)         && BILANCIO DI CHIUSURA


WAIT WINDOWS "Verifica bilancio chiusura 6 ....."  nowait
*!*	VERIFICA INCROCIATA SUL CONTO BILANCIO DI CHIUSURA PER L'ESERCIZIO CHIUSO

*!*	1)  SE DARE > AVERE CREA REGISTRAZIONE CON TOP CHI IN QUESTO MODO :
*!*		_____________________________________________DARE____________AVERE___________
*!*		CONTO BILANCIO CHIUSURA  CONTO_CHI  :						85723,05
*!*		CONTO UTILE ESERCIZIO  CONTO_UTI	:   	85723,05
*!*		_____________________________________________DARE____________AVERE___________
*!*		CONTO BILANCIO CHIUSURA  CONTO_PEP  :		85723,05
*!*		CONTO UTILE ESERCIZIO   CONTO_UTI	:   					85723,05


*!*	2)  SE DARE < AVERE CREA REGISTRAZIONE CON TOP CHI IN QUESTO MODO :
*!*		_____________________________________________DARE____________AVERE___________
*!*		CONTO BILANCIO CHIUSURA  CONTO_CHI  :		85723,05
*!*		CONTO PROFITTI PERDITE   CONTO_UTI	:   					85723,05
*!*		_____________________________________________DARE____________AVERE___________
*!*		CONTO BILANCIO CHIUSURA  CONTO_PEP  :						85723,05
*!*		CONTO PROFITTI PERDITE   CONTO_UTI	:   	85723,05


x_soci  = "mov_soc = '" + PUB_CODSOC + "'"
x_anno  = "mov_anno = '" + V_ANNO  + "'"
x_conto = "mov_conto = '" + CONTO_CHI  + "'"

x_cond = x_soci + " and " + x_anno + " and " + x_conto
Csql   = "select * from mo_conca where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecCommand(cSql,"cu_mo_conca")
   return(.f.)
ENDIF
_saldo_dare  = 0
_saldo_avere = 0
SELECT cu_mo_conca
GO TOP
DO WHILE .T.
    IF EOF()
      EXIT
    ENDIF
    IF DELETED()
      SKIP +1
      LOOP
    ENDIF
 
    IF MOV_TMOV = 'D'
		_SALDO_DARE  = _SALDO_DARE  + MOV_IMP
	ENDIF


    IF MOV_TMOV = 'A'
		_SALDO_AVERE = _SALDO_AVERE + MOV_IMP
	ENDIF

    SKIP +1
ENDDO

*!*	IF _SALDO_DARE  <> _SALDO_AVERE 
*!*		DO FANNI_CREA_PRIMA_REGISTRAZIONE_CHIUSURA_PER_ESERCIZIO_CHIUSO WITH CONTO_CHI,CONTO_UTI,_SALDO_DARE,_SALDO_AVERE 
*!*		DO FANNI_CREA_SECONDA_REGISTRAZIONE_CHIUSURA_PER_ESERCIZIO_CHIUSO WITH CONTO_PEP,CONTO_UTI,_SALDO_DARE,_SALDO_AVERE 
*!*	ENDIF

**=> ERASMO - INIZIO 24/09/2019
IF _SALDO_DARE  <> _SALDO_AVERE
	IF _SALDO_DARE  > _SALDO_AVERE
		DO FANNI_CREA_PRIMA_REGISTRAZIONE_CHIUSURA_PER_ESERCIZIO_CHIUSO WITH CONTO_CHI,CONTO_UTI,_SALDO_DARE,_SALDO_AVERE 
		DO FANNI_CREA_SECONDA_REGISTRAZIONE_CHIUSURA_PER_ESERCIZIO_CHIUSO WITH CONTO_PEP,CONTO_UTI,_SALDO_DARE,_SALDO_AVERE 
	ELSE
		DO FANNI_CREA_PRIMA_REGISTRAZIONE_CHIUSURA_PER_ESERCIZIO_CHIUSO WITH CONTO_CHI,CONTO_PER,_SALDO_DARE,_SALDO_AVERE 
		DO FANNI_CREA_SECONDA_REGISTRAZIONE_CHIUSURA_PER_ESERCIZIO_CHIUSO WITH CONTO_PEP,CONTO_PER,_SALDO_DARE,_SALDO_AVERE 
	ENDIF
ENDIF
**=> ERASMO - FINE 24/09/2019



WAIT WINDOWS "Verifica bilancio apertura 7 ....."  nowait
*!*	VERIFICA INCROCIATA SUL CONTO BILANCIO DI APERTURA PER L'ESERCIZIO APERTO
*!*	1)  SE DARE > AVERE CREA REGISTRAZIONE CON TOP APE IN QUESTO MODO :
*!*		____________________________________________DARE____________AVERE___________
*!*		CONTO BILANCIO APERTURA  CONTO_APE  :						85723,05
*!*		CONTO UTILE D'ESERCIZIO  CONTO_UTI  :   85723,05

*!*	2)	SE DARE < AVERE CREA REGISTRAZIONE CON TOP CHI IN QUESTO MODO :
*!*		____________________________________________DARE____________AVERE___________
*!*		CONTO BILANCIO CHIUSURA  CONTO_APE  :	 85723,05
*!*		CONTO UTILE D'ESERCIZIO  CONTO_UTI  :   					85723,05



x_soci  = "mov_soc = '" + PUB_CODSOC + "'"
x_anno  = "mov_anno = '" + V_AAAPE + "'"
x_conto = "mov_conto = '" + CONTO_APE  + "'"

x_cond = x_soci + " and " + x_anno + " and " + x_conto
Csql   = "select * from mo_conca where " + x_cond + " order by mov_soc,mov_anno,mov_numpro"
IF !ExecCommand(cSql,"cu_mo_conca")
   return(.f.)
ENDIF
_saldo_dare  = 0
_saldo_avere = 0
SELECT cu_mo_conca
GO TOP
DO WHILE .T.
    IF EOF()
      EXIT
    ENDIF
    IF DELETED()
      SKIP +1
      LOOP
    ENDIF
 
    IF MOV_TMOV = 'D'
		_SALDO_DARE  = _SALDO_DARE  + MOV_IMP
	ENDIF


    IF MOV_TMOV = 'A'
		_SALDO_AVERE = _SALDO_AVERE + MOV_IMP
	ENDIF

    SKIP +1
ENDDO

*!*	IF _SALDO_DARE  <> _SALDO_AVERE 
*!*		DO FANNI_CREA_REGISTRAZIONE_SU_BILANCIO_APERTURA_UTILE_ESERCIZIO_PER_ESERCIZIO_APERTO WITH CONTO_APE,CONTO_UTI,_SALDO_DARE,_SALDO_AVERE 
*!*	ENDIF

**=> ERASMO - INIZIO 24/09/2019
IF _SALDO_DARE  <> _SALDO_AVERE 
	IF _SALDO_DARE  > _SALDO_AVERE
		DO FANNI_CREA_REGISTRAZIONE_SU_BILANCIO_APERTURA_UTILE_ESERCIZIO_PER_ESERCIZIO_APERTO WITH CONTO_APE,CONTO_PER,_SALDO_DARE,_SALDO_AVERE
	ELSE
		DO FANNI_CREA_REGISTRAZIONE_SU_BILANCIO_APERTURA_UTILE_ESERCIZIO_PER_ESERCIZIO_APERTO WITH CONTO_APE,CONTO_UTI,_SALDO_DARE,_SALDO_AVERE
	ENDIF
ENDIF
**=> ERASMO - FINE 24/09/2019


RETURN



