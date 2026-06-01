*********************************************************************************
*                            STAMPA PRIMA NOTA                                  * 
*********************************************************************************

RELEASE _TOTALE_DARE_FINALE,_TOTALE_AVERE_FINALE
PUBLIC _TOTALE_DARE_FINALE,_TOTALE_AVERE_FINALE
_TOTALE_DARE_FINALE   = 0
_TOTALE_AVERE_FINALE  = 0


RELEASE PRIM_NOTA_OK
PUBLIC PRIM_NOTA_OK
PRIM_NOTA_OK = .T.


RELEASE INVALUTA,_STAMPA_SINGOLO_CONTO
PUBLIC  INVALUTA,_STAMPA_SINGOLO_CONTO 	
_STAMPA_SINGOLO_CONTO = .F.		

INVALUTA=.F.
IF SINTESI
   RIT = MESSAGEBOX('Desidera la stampa in valuta della prima nota ?',4+32,"Stampa sintetica")
   IF RIT=6
      INVALUTA=.T.
   ELSE
      INVALUTA=.F.
   ENDIF
ENDIF

SET DECIMAL TO 3

IF V_CHIU
   F_CHIUSURA = .T.
ELSE
   F_CHIUSURA = .F.
ENDIF

DATA_DA   = RIBALTA2(DATADAL)
DATA_A    = RIBALTA2(DATAAL)


PRIMOGIRO = .T.
PUBLIC WIMPD,WIMPA,DAR,AVV,W_IMP,NEW_PAG,RIGA_SP,WNRI,HOLD_NUM,WNUMINT,_DIFF

RELEASE WI_DREG,WI_NREG
PUBLIC WI_DREG,WI_NREG
WI_DREG  = SPACE(10)
WI_NREG  = SPACE(06)
WNUMINT  = ""
HOLD_NUM = ""
AVV      = .F.
DAR      = .F.
_DIFF    = 0
WIMPD    = 0
WIMPA    = 0
WCODVAL  = ""
*WCAMBIO  = ""
WCAMBIO  = 0  && ERASMO - 11/05/2022
W_IMP    = 0
RIGA_SP  = 0
NEW_PAG  = 60
WNRI     = 0

*!*	IF SINTESI
*!*	   * SERVE PER STAMPARE
*!*	   CREATE CURSOR TEMPO;
*!*		(I_DREG C(10),I_NREG C(6),NRI C(3),DREG C(10),NREG C(6),DTORI C(10),NDORI C(6),NPROT C(6),COD C(13),DES_CON C(40),DES_TOP  C(40),NDOCUM C(6),DTDOC C(10),DARE C(17),AVERE C(17),DES_MANU C(100),NUMINT C(10),TOP C(10),CAM_BIO N(17,10),CODVAL C(3),CONTABILITA_PREVISIONALE C(1),;
*!*		 OBBLIGO_COMMESSA L, POSBIL C(1), NUMCOM C(30))	&& SIMONE - 06/09/2011
*!*	ELSE
*!*	   * SERVE PER STAMPARE
*!*	   CREATE CURSOR TEMPO;
*!*		(I_DREG C(10),I_NREG C(6),NRI C(3),DREG C(10),NREG C(6),DTORI C(10),NDORI C(6),NPROT C(6),COD C(13),DES_CON C(40),DES_TOP  C(40),NDOCUM C(6),DTDOC C(10),DARE C(17),AVERE C(17),DES_MANU C(100),NUMINT C(10),TOP C(10),CAM_BIO N(17,10),CODVAL C(3),CONTABILITA_PREVISIONALE C(1),;
*!*		 OBBLIGO_COMMESSA L, POSBIL C(1), NUMCOM C(30))	&& SIMONE - 06/09/2011
*!*	ENDIF

CREATE CURSOR TEMPO;
	(I_DREG C(10),I_NREG C(6),NRI C(3),DREG C(10),NREG C(6),DTORI C(10),NDORI C(6),NPROT C(6),COD C(13),DES_CON C(40),DES_TOP  C(40),NDOCUM C(6),DTDOC C(10),DARE C(17),AVERE C(17),DES_MANU C(100),NUMINT C(10),TOP C(10),CAM_BIO N(17,10),CODVAL C(3),CONTABILITA_PREVISIONALE C(1),;
	OBBLIGO_COMMESSA L, POSBIL C(1), NUMCOM C(30), DTSCAD C(10))	&& ERASMO - 05/11/2020


IF SELEZ = 1
   INDEX ON I_DREG+STR(VAL(I_NREG),6,0)            TAG TEMPO ADDITIVE
ELSE
   INDEX ON I_DREG                                 TAG TEMPO ADDITIVE
ENDIF

WAIT WINDOWS "Caricamento delle prime note in corso , attendere prego" nowait

****  RIPORTA RECNO SU MOVIMENTI CONTABILI A ELABORARE
x_dt1  = DATA_DA
x_dt2  = DATA_A

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "1=1"  			&& non considera + l'anno ma la data di registrazione : sergio
x_datda = "mov_dtreg >= '" + DATA_DA + "'"
x_data  = "mov_dtreg <= '" + DATA_A  + "'"

x_cont  = "mov_conto = '" + M.CODICE + "'"


x_nregda  = "mov_nregis >= '" + M.NREGDAL + "'"
x_nregal  = "mov_nregis <= '"  + M.NREGAL + "'"


IF !EMPTY(M.XTOP)
	DO ELABORA_PN_PER_TIPO_OPERAZIONE
	RETURN
ENDIF 


IF !EMPTY(M.CODICE)	
	DO ELABORA_PN_PER_CONTO_CONTABILE
	RETURN
ENDIF 

**==> SERGIO 2019-01-04 INIZIO
*!*	Csql   = "select * from indice where " + x_soci + " and " + x_anno + " and " + x_datda + " and " + x_data+ ;
*!*	                                     " order by mov_soc,mov_anno,mov_dtreg,mov_numpro"

Csql   = "select MOV_SOC,MOV_ANNO,MOV_NUMPRO,MOV_NREGIS,MOV_DTREG,MOV_TOP,MOV_CONTABILITA_PREVISIONALE from indice where " + x_soci + " and " + x_anno + " and " + x_datda + " and " + x_data+ ;
                                     " order by mov_soc,mov_anno,mov_dtreg,mov_numpro"
**==> SERGIO 2019-01-04 FINE

IF !ExecCommand(Csql,"_MOV_CONT_CUR")
   return(.f.)
ENDIF
IF !USED("_MOV_CONT_CUR")
    *RIT=MSGBOX("Elaborazione interrotta dall'utente","ATTENZIONE",31)
	RETURN
ENDIF


SELECT _MOV_CONT_CUR
GO TOP

_TOTALE_DARE_FINALE  = 0
_TOTALE_AVERE_FINALE = 0
 
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF


   IF EMPTY(M.NREGAL) 
	  IF MOV_DTREG <= DATA_A
	  ELSE
	     EXIT
	  ENDIF
   ENDIF
   
   
   M.MOV_NUMPRO=MOV_NUMPRO

   IF !EMPTY(M.XTOP)                && SCARTA I TOP NON GESTITI
      IF UPPER(ALLTRIM(MOV_TOP)) <> UPPER(ALLTRIM(M.XTOP))  && ERASMO - 12/02/2016
         SKIP +1
         LOOP
      ENDIF
   ENDIF

   IF MOV_TOP = "CHI"
      IF !F_CHIUSURA                && NON STAMPA I MOVIMENTI DI CHIUSURA
         SKIP +1
         LOOP
      ENDIF
   ENDIF
   

   _DARE = 0
   _AVERE= 0

		
   		
  	DO CASE 
   		

  		CASE ___PNTOTALI								&& TUTTE LE REGISTRAZIONI



  		CASE ___PNPREVISIONALI 							&& SOLO PREVISIONALI

  			IF  MOV_CONTABILITA_PREVISIONALE <> "P"		&& SOLO PREVISIONALI
		         SKIP +1
        		 LOOP
			ENDIF


  		CASE ___PNDEFINITIVE 							&& SOLO DEFINITIVE

  			IF  MOV_CONTABILITA_PREVISIONALE <> " "		&& SOLO EFFETTIVE
		         SKIP +1
        		 LOOP
			ENDIF



  	ENDCASE

   WAIT windows "Elaborazione della registrazione numero : " + mov_nregis nowait

   PRIM_NOTA_OK = .T.
   DO VQUADRA  WITH M.MOV_NUMPRO
   
   IF ___PNDAVERIFICARE 
   		IF !PRIM_NOTA_OK 
	   		DO CREATEMP WITH M.MOV_NUMPRO	&& SOLO PRIME NOTE DA VERIFICARE
	   		DO TOTALE
		ENDIF
   ELSE
   		DO CREATEMP WITH M.MOV_NUMPRO	
   		DO TOTALE
   ENDIF


   SELECT _MOV_CONT_CUR
   SKIP +1

ENDDO 




IF ___PNSENZACOMMESSA

	SELECT TEMPO
	GO TOP

	&& CANCELLO TUTTI I RECORD CHE NON SONO NE CONTI ECONOMICI, NE HANNO L'OBBLIGO DI DIGITAZIONE CODICE COMMESSA IN PRIMA NOTA
	DELETE FOR POSBIL <> 'E' AND OBBLIGO_COMMESSA <> .T. ALL            


	SELECT TEMPO
	GO TOP

	&& CANCELLO TUTTI I RECORD CHE HANNO CODICE COMMESSA PIENO
	DELETE FOR !EMPTY(ALLTRIM(NUMCOM)) ALL            

	
ENDIF


SELECT TEMPO
GO TOP


IF EOF()
   RIT=MSGBOX('Periodo selezionato privo di registrazioni','ATTENZIONE',31)
   DEACTIVATE WINDOWS TEMP
   RELEASE WINDOWS TEMP
   PUSH KEY CLEAR
   RETURN
ENDIF

IF STAMPER = 1
   DO STP_GRA
ENDIF

IF STAMPER = 2
   DO STP_SPOOL
ENDIF

RELEASE INVALUTA

RETURN






*****************************************
PROCEDURE ELABORA_PN_PER_CONTO_CONTABILE
*****************************************


IF !EMPTY(M.NREGAL) 
	cSql   = "SELECT MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE FROM MOV_CONT WHERE " + x_soci + " and " + x_cont + " and " + x_anno + " and " + x_nregda  + " and " + x_nregal + ;
	                                     " group by MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE"
ELSE
	cSql   = "SELECT MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE FROM MOV_CONT WHERE " + x_soci + " and " + x_cont + " and " + x_anno + " and " + x_datda  + " and " + x_data + ;
	                                     " group by MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE"
ENDIF



IF !ExecCommand(cSql,"CURS_MOV_CONT")
   return(.f.)
ENDIF
SELECT CURS_MOV_CONT
GO TOP


_TOTALE_DARE_FINALE  = 0
_TOTALE_AVERE_FINALE = 0


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF


   IF EMPTY(M.NREGAL) 
	  IF MOV_DTREG <= DATA_A
	  ELSE
	     EXIT
	  ENDIF
   ENDIF
   
   
   M.MOV_NUMPRO=MOV_NUMPRO

   IF !EMPTY(M.XTOP)                && SCARTA I TOP NON GESTITI
      *IF MOV_TOP <> M.XTOP
      IF UPPER(ALLTRIM(MOV_TOP)) <> UPPER(ALLTRIM(M.XTOP))  && ERASMO - 12/02/2016
         SKIP +1
         LOOP
      ENDIF
   ENDIF

   IF MOV_TOP = "CHI"
      IF !F_CHIUSURA                && NON STAMPA I MOVIMENTI DI CHIUSURA
         SKIP +1
         LOOP
      ENDIF
   ENDIF
   

   _DARE = 0
   _AVERE= 0

		
   		
  	DO CASE 
   		

  		CASE ___PNTOTALI				&& TUTTE LE REGISTRAZIONI



  		CASE ___PNPREVISIONALI 			&& SOLO PREVISIONALI

  			IF  MOV_CONTABILITA_PREVISIONALE <> "P"	&& SOLO PREVISIONALI
		         SKIP +1
        		 LOOP
			ENDIF

  		CASE ___PNDEFINITIVE 			&& SOLO DEFINITIVE

  			IF  MOV_CONTABILITA_PREVISIONALE <> " "	&& SOLO EFFETTIVE
		         SKIP +1
        		 LOOP
			ENDIF



  	ENDCASE

   WAIT windows "Elaborazione della registrazione numero : " + mov_nregis nowait

	
   _STAMPA_SINGOLO_CONTO = .F.		
   PRIM_NOTA_OK = .T.
   DO VQUADRA  WITH M.MOV_NUMPRO
   
   IF ___PNDAVERIFICARE 
   		IF !PRIM_NOTA_OK 
		    IF _STAMPA_SINGOLO_CONTO  
			   DO CREATEMP WITH M.MOV_NUMPRO	&& SOLO PRIME NOTE DA VERIFICARE
			   DO TOTALE
		    ENDIF
		ENDIF
   ELSE
	    IF _STAMPA_SINGOLO_CONTO  
		   DO CREATEMP WITH M.MOV_NUMPRO
		   DO TOTALE
	    ENDIF
   ENDIF





   SELECT CURS_MOV_CONT
   SKIP +1

ENDDO 




*** SIMONE - 06/09/2011 - INIZIO
IF ___PNSENZACOMMESSA

	SELECT TEMPO
	GO TOP

	&& CANCELLO TUTTI I RECORD CHE NON SONO NE CONTI ECONOMICI, NE HANNO L'OBBLIGO DI DIGITAZIONE CODICE COMMESSA IN PRIMA NOTA
	DELETE FOR POSBIL <> 'E' AND OBBLIGO_COMMESSA <> .T. ALL            


	SELECT TEMPO
	GO TOP

	&& CANCELLO TUTTI I RECORD CHE HANNO CODICE COMMESSA PIENO
	DELETE FOR !EMPTY(ALLTRIM(NUMCOM)) ALL            

	
ENDIF
*** SIMONE - 06/09/2011 - FINE


SELECT TEMPO
GO TOP


IF EOF()
   RIT=MSGBOX('Periodo selezionato privo di registrazioni','ATTENZIONE',31)
   DEACTIVATE WINDOWS TEMP
   RELEASE WINDOWS TEMP
   PUSH KEY CLEAR
   RETURN
ENDIF

IF STAMPER = 1
   DO STP_GRA
ENDIF

IF STAMPER = 2
   DO STP_SPOOL
ENDIF

RELEASE INVALUTA

RETURN




*****************************************
PROCEDURE ELABORA_PN_PER_TIPO_OPERAZIONE
*****************************************



IF !EMPTY(M.CODICE)
	IF !EMPTY(M.NREGAL) 
		cSql   = "SELECT MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE FROM MOV_CONT WHERE " + x_soci + " and " + x_cont + " and " + x_anno + " and " + x_nregda  + " and " + x_nregal + ;
		                                     " group by MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE"
	ELSE
		cSql   = "SELECT MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE FROM MOV_CONT WHERE " + x_soci + " and " + x_cont + " and " + x_anno + " and " + x_datda  + " and " + x_data + ;
		                                     " group by MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE"
	ENDIF
ELSE
	IF !EMPTY(M.NREGAL) 
		cSql   = "SELECT MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE FROM MOV_CONT WHERE " + x_soci + " and " + x_anno + " and " + x_nregda  + " and " + x_nregal + ;
		                                     " group by MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE"
	ELSE
		cSql   = "SELECT MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE FROM MOV_CONT WHERE " + x_soci + " and " + x_anno + " and " + x_datda  + " and " + x_data + ;
		                                     " group by MOV_DTREG, MOV_NREGIS, MOV_NUMPRO, MOV_TOP, MOV_CONTABILITA_PREVISIONALE"
	ENDIF
ENDIF



IF !ExecCommand(cSql,"CURS_MOV_CONT")
   return(.f.)
ENDIF
SELECT CURS_MOV_CONT
GO TOP


_TOTALE_DARE_FINALE  = 0
_TOTALE_AVERE_FINALE = 0


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF


   IF EMPTY(M.NREGAL) 
	  IF MOV_DTREG <= DATA_A
	  ELSE
	     EXIT
	  ENDIF
   ENDIF
   
   
   M.MOV_NUMPRO=MOV_NUMPRO

   IF !EMPTY(M.XTOP)                && SCARTA I TOP NON GESTITI
      *IF MOV_TOP <> M.XTOP
      IF UPPER(ALLTRIM(MOV_TOP)) <> UPPER(ALLTRIM(M.XTOP))  && ERASMO - 12/02/2016
         SKIP +1
         LOOP
      ENDIF
   ENDIF

   IF MOV_TOP = "CHI"
      IF !F_CHIUSURA                && NON STAMPA I MOVIMENTI DI CHIUSURA
         SKIP +1
         LOOP
      ENDIF
   ENDIF
   

   _DARE = 0
   _AVERE= 0

		
   		
  	DO CASE 
   		

  		CASE ___PNTOTALI				&& TUTTE LE REGISTRAZIONI



  		CASE ___PNPREVISIONALI 			&& SOLO PREVISIONALI

  			IF  MOV_CONTABILITA_PREVISIONALE <> "P"	&& SOLO PREVISIONALI
		         SKIP +1
        		 LOOP
			ENDIF

  		CASE ___PNDEFINITIVE 			&& SOLO DEFINITIVE

  			IF  MOV_CONTABILITA_PREVISIONALE <> " "	&& SOLO EFFETTIVE
		         SKIP +1
        		 LOOP
			ENDIF



  	ENDCASE

   WAIT windows "Elaborazione della registrazione numero : " + mov_nregis nowait

*!*	   _STAMPA_SINGOLO_CONTO = .F.		
   PRIM_NOTA_OK = .T.
   DO VQUADRA  WITH M.MOV_NUMPRO
*!*	   
*!*	   IF ___PNDAVERIFICARE 
*!*	   		IF !PRIM_NOTA_OK 
*!*			    IF _STAMPA_SINGOLO_CONTO  
*!*				   DO CREATEMP WITH M.MOV_NUMPRO	&& SOLO PRIME NOTE DA VERIFICARE
*!*				   DO TOTALE
*!*			    ENDIF
*!*			ENDIF
*!*	   ELSE
*!*		    IF _STAMPA_SINGOLO_CONTO  
*!*			   DO CREATEMP WITH M.MOV_NUMPRO
*!*			   DO TOTALE
*!*		    ENDIF
*!*	   ENDIF
   **=> SERGIO/ERASMO - INIZIO 17/02/2023
   DO CREATEMP WITH M.MOV_NUMPRO
   DO TOTALE
   **=> SERGIO/ERASMO - FINE 17/02/2023

   SELECT CURS_MOV_CONT
   SKIP +1

ENDDO 




*** SIMONE - 06/09/2011 - INIZIO
IF ___PNSENZACOMMESSA

	SELECT TEMPO
	GO TOP

	&& CANCELLO TUTTI I RECORD CHE NON SONO NE CONTI ECONOMICI, NE HANNO L'OBBLIGO DI DIGITAZIONE CODICE COMMESSA IN PRIMA NOTA
	DELETE FOR POSBIL <> 'E' AND OBBLIGO_COMMESSA <> .T. ALL            


	SELECT TEMPO
	GO TOP

	&& CANCELLO TUTTI I RECORD CHE HANNO CODICE COMMESSA PIENO
	DELETE FOR !EMPTY(ALLTRIM(NUMCOM)) ALL            

	
ENDIF
*** SIMONE - 06/09/2011 - FINE


SELECT TEMPO
GO TOP

IF EOF()
   RIT=MSGBOX('Periodo selezionato privo di registrazioni','ATTENZIONE',31)
   DEACTIVATE WINDOWS TEMP
   RELEASE WINDOWS TEMP
   PUSH KEY CLEAR
   RETURN
ENDIF

IF STAMPER = 1
   DO STP_GRA
ENDIF

IF STAMPER = 2
   DO STP_SPOOL
ENDIF

RELEASE INVALUTA

RETURN



************************
PROCEDURE VQUADRA         && EFFETTUA UN CONTROLLO DI QUADRATURA SULLE REGISTRAZIONI IN VALUTA
************************
PARA _NUMPRO

*!*	x_soci = "mov_soc = '" + PUB_CODSOC + "'"
*!*	*x_anno = "mov_anno = '" + PUB_ANNO + "'"
*!*	x_anno  = "1=1"     	&& considera solo la data di registrazione e non + l'anno : sergio
*!*	x_nint = "mov_numpro = '" + ALLTRIM(_NUMPRO) + "'"
*!*	cSql="SELECT * FROM mov_cont WHERE " + x_soci + " and " + x_anno + " and " + x_nint +;
*!*	                                  " order by mov_soc,mov_anno,mov_numpro,mov_sequen"
*!*	**=> ERASMO - INIZIO 18/12/2020
*!*	x_soci = "MOV_CONT.mov_soc = '" + PUB_CODSOC + "'"
*!*	x_nint = "MOV_CONT.mov_numpro = '" + ALLTRIM(_NUMPRO) + "'"
*!*	x_cond = x_soci + " and " + x_nint
*!*	cSql="SELECT mov_cont.*, INDICE.MOV_DATSCAD AS IND_DATSCAD FROM mov_cont LEFT OUTER JOIN INDICE ON mov_cont.MOV_NUMPRO = INDICE.MOV_NUMPRO " + ;
*!*		 "WHERE " + x_cond + " order by MOV_CONT.mov_sequen"
*!*	**=> ERASMO - FINE 18/12/2020
**=> ERASMO - INIZIO 28/01/2021
x_soci = "MOV_CONT.mov_soc = '" + PUB_CODSOC + "'"
x_nint = "MOV_CONT.mov_numpro = '" + ALLTRIM(_NUMPRO) + "'"
x_cond = x_soci + " and " + x_nint
cSql="SELECT mov_cont.*, INDICE.MOV_DATSCAD AS IND_DATSCAD, SPACE(10) AS PAR_DTSCAD FROM mov_cont LEFT OUTER JOIN INDICE ON mov_cont.MOV_NUMPRO = INDICE.MOV_NUMPRO " + ;
	 "WHERE " + x_cond + " order by MOV_CONT.mov_sequen"
**=> ERASMO - FINE 28/01/2021
IF !ExecCommand(cSql,"WW_TEMPO")
   return(.f.)
ENDIF
SELECT WW_TEMPO
GO TOP

IF EOF()
   WAIT WINDOW "Non trovato il numero interno di legame indice - MOV_CONT "+_NUMPRO
ELSE


   DO WHILE .T.
      IF EOF()
         EXIT
      ENDIF
      IF DELETED()
         SKIP +1
         LOOP
      ENDIF
      VSGRUPPO = SUBSTR(MOV_CONTO,1,PUB_MASTRO+1)
      KTOP     = MOV_TOP

      IF SI_TUTREG <> 'SI'    && VERIFICA SE STAMPA TUTTO

        IF SI_PRINOT == 'NO'  .AND. TIPOCO(VSGRUPPO)=3 && ALTRE TIPOLOGIE DI REGISTRAZIONI
           DELETE
           SKIP
           LOOP
        ENDIF
        IF SI_FATVEN == 'NO' .AND. TIPOCO(VSGRUPPO) = 1 && FATTURE CLIENTE
           DELETE
           SKIP
           LOOP
        ENDIF
        IF SI_FATACQ == 'NO' .AND. TIPOCO(VSGRUPPO) = 2 && FATTURE FORNITORE
           DELETE
           SKIP
           LOOP
        ENDIF
        IF SI_INCASSI == 'NO' .AND. TIPOCO(VSGRUPPO) = 4 && INCASSO CLIENTE
           DELETE
           SKIP
           LOOP
        ENDIF
        IF SI_PAGAMENTI == 'NO' .AND. TIPOCO(VSGRUPPO) = 5 && PAGAMENTO A FORNITORE
           DELETE
           SKIP
           LOOP
        ENDIF


      ENDIF
      
      **=> ERASMO - INIZIO 28/01/2021
      SELECT WW_TEMPO
      x_npro = "PAR_NUMPRO = '" + MOV_NUMPRO + "'"
      x_prog = "PAR_NPROG <> '100'"
      x_cond = x_npro + " and " + x_prog 
      x_sele = IIF(TIPOCO(VSGRUPPO) = 1 OR TIPOCO(VSGRUPPO) = 4,"PART_CLI","PART_FOR")
      cSql   = "SELECT TOP 1 PAR_DTSCAD FROM " + x_sele + " WHERE " + x_cond + " ORDER BY PAR_DTSCAD"
      IF !ExecCommand(cSql,"TMP_PART_CF")
         return(.f.)
      ENDIF
      SELECT TMP_PART_CF
      GO TOP
      IF !EOF()
         _PAR_DTSCAD = PAR_DTSCAD
         SELECT WW_TEMPO
         REPLACE PAR_DTSCAD WITH _PAR_DTSCAD
      ENDIF
      SELECT WW_TEMPO
      **=> ERASMO - FINE 28/01/2021

	   IF !EMPTY(ALLTRIM(M.PRIMADESCRI)) 
          IF ALLTRIM(M.PRIMADESCRI) $ MOV_DESMOV
	      ELSE
		    DELETE
		    SKIP 
	    	LOOP
	   	  ENDIF
	   ENDIF



	   IF !EMPTY(ALLTRIM(M.SECONDADESCRI)) 
	   	  IF ALLTRIM(M.SECONDADESCRI) $ MOV_DESMO1      
	      ELSE
		    DELETE
		    SKIP 
	    	LOOP
	   	  ENDIF
	   ENDIF


 	 ** SE CONTO CONTABILE DIGITATO E ESISTE UN CONTO NELLA P.N. >>>>> STAMPO	      
     IF !EMPTY(M.CODICE)		
	     IF ALLTRIM(M.CODICE) = ALLTRIM(MOV_CONTO)	
			   _STAMPA_SINGOLO_CONTO = .T.	
		 ENDIF
	 ENDIF


      _SOC      = MOV_SOC
      _ANNO     = MOV_ANNO
      _CONTO    = MOV_CONTO
      _TMOV     = MOV_TMOV
      _TOP      = MOV_TOP
      _IMP      = MOV_IMP
      _CAMBIO   = MOV_CAMBIO
      _CODVAL   = MOV_VALUTA
     
      _VALORE   = CAMBIO(_CODVAL,_IMP,_CAMBIO,(_SOC+_ANNO+_CONTO),INVALUTA)
      
      IF SUBSTR(_TMOV,1,1)='A'
         _AVERE=_AVERE + _VALORE
      ENDIF
      IF SUBSTR(_TMOV,1,1)='D'
         _DARE=_DARE + _VALORE
      ENDIF
      SELECT WW_TEMPO
      SKIP +1

   ENDDO

   _DIFF = _DARE  -  _AVERE

ENDIF

RETURN


************************
PROCEDURE CREATEMP
************************
PARA _NUMPRO

SELECT WW_TEMPO
GO TOP

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

*!*	   IF MOV_IMP  = 0             							&& SCARTA RECORD IVA ESENTI CON IMPORTO IVA = 0
*!*	  		
*!*	  		IF MOV_TOP = 'CHI' OR  MOV_TOP = 'APE'			&& SERGIO 2022/05/02 CONSIDERA PER0' LE REGISTRAZIONI DI APERTURA/CHIUSURA CON SALDO = 0
*!*	  		ELSE											&& SERGIO 2022/05/02 CONSIDERA PER0' LE REGISTRAZIONI DI APERTURA/CHIUSURA CON SALDO = 0
*!*	      		SKIP +1
*!*	      		LOOP
*!*	      	ENDIF 
*!*	      	
*!*	   ENDIF
  **=> ERASMO/SERGIO - INIZIO 11/04/2023
  IF MOV_IMP = 0
	  XXCONTO=MOV_CONTO
	  *** SCARTA I RECORD IVA DETERMINATI AUTOMATICAMENTE 
	  IF (ALLTRIM(MOV_IVA)<>'NO') .AND. (MOV_IMPOST=0)
	  	 x_soci = "con_soc = '" + PUB_CODSOC + "'"
	     x_anno = "con_anno = '" + PUB_ANNO + "'"
	     x_cont = "con_conto = '" + ALLTRIM(XXCONTO) + "'"
	     x_cond = x_soci + " and " + x_anno + " and " + x_cont
	     Csql   = "select CON_TIPOCO from conti where " + x_cond
	     IF !ExecCommand(cSql,"tmp_conti")
	        return(.f.)
	     ENDIF
	     SELECT tmp_conti
	     GO TOP
	     IF EOF()
	        XXTIPOCO = 'I'
	     ELSE
	        XXTIPOCO = CON_TIPOCO
	     ENDIF
	     SELECT WW_TEMPO
	     IF XXTIPOCO='I'
	        SKIP +1
	        LOOP
	     ENDIF  
	  ENDIF
  ENDIF
  **=> ERASMO/SERGIO - FINE 11/04/023


   IF ___PNTOTALI_SOLO_RATEI_RISCONTI										&& SOLO RATEI / RISCONTI PREVISIONALI
	  	IF  MOV_CONTABILITA_PREVISIONALE = "P" AND MOV_REGAUT = "RAT-RIS"	&& SOLO RATEI / RISCONTI PREVISIONALI
	    ELSE
	         SKIP +1
    		 LOOP
		ENDIF
   ENDIF
   
   VSGRUPPO = SUBSTR(MOV_CONTO,1,4)
   KTOP     = MOV_TOP

   DO STAMPA

   SELECT WW_TEMPO
   SKIP +1

ENDDO

RETURN


***********************
PROCEDURE STAMPA
***********************

SELECT WW_TEMPO

WI_DREG   = MOV_DTREG
WI_NREG   = MOV_NREGIS
WDREG     = RIBALTA2(MOV_DTREG)
WDTDOC    = RIBALTA2(MOV_DTDOC)
WNPROT    = MOV_NPROT
WNREG     = MOV_NREGIS
WCOD      = MOV_CONTO
WCONTABILITA_PREVISIONALE      = MOV_CONTABILITA_PREVISIONALE
WNUMEROCOMMESSA = MOV_NUCOM		&& SIMONE - 04/10/2011
WDTSCAD   = RIBALTA2(IND_DATSCAD)  && ERASMO - 18/12/2020
**=> ERASMO - INIZIO 28/01/2021
IF !EMPTY(PAR_DTSCAD)
	WDTSCAD = RIBALTA2(PAR_DTSCAD)
ENDIF
**=> ERASMO - INIZIO 28/01/2021

WTOP      = MOV_TOP
IF _VERYFA(WTOP)
   WNDOC  = MOV_NPROT		&& TRATTASI DI FATTURA/NOTA CREDITO CLIENTE
ELSE
   WNDOC  = MOV_NDOC
ENDIF

WNDORI 	= ALLTRIM(MOV_NDORI)
WDTORI 	= RIBALTA2(MOV_DTORI)
IF !EMPTY(MOV_NPORI)
	WNPROT  = MOV_NPORI
ENDIF


IF SINTESI
   WDES_MANU = ALLTRIM(MOV_DESMOV) 
ELSE
   WDES_MANU = ALLTRIM(MOV_DESMOV) + "-" + ALLTRIM(MOV_DESMO1)
ENDIF
WNUMINT   = MOV_NUMPRO
WIMP      = MOV_IMP
WCAMBIO   = MOV_CAMBIO
WCODVAL   = MOV_VALUTA
XVALORE   = CAMBIO(WCODVAL,MOV_IMP,WCAMBIO,(MOV_SOC+MOV_ANNO+MOV_CONTO),INVALUTA)

v_seek	= 'TOP' + ALLTRIM(WTOP)
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   WDES_TOP=DESCRI
ELSE
   WDES_TOP="TOP INESISTENTE SU PARAMETRI"
ENDIF

SELECT WW_TEMPO

IF SUBSTR(MOV_TMOV,1,1)='A'
   _TOTALE_AVERE_FINALE = _TOTALE_AVERE_FINALE + XVALORE
   WAVERE=STR(XVALORE,17,3)
   WDARE=SPACE(17)
   AVV=.T.
   W_IMP = XVALORE
ENDIF

IF SUBSTR(MOV_TMOV,1,1)='D'
   _TOTALE_DARE_FINALE = _TOTALE_DARE_FINALE + XVALORE
   WDARE=STR(XVALORE,17,3)
   WAVERE=SPACE(17)
   DAR=.T.
   W_IMP = XVALORE
ENDIF

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(WCOD) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont

***Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"   && SIMONE - 06/09/2011
Csql   = "select CON_DESCR,CON_NOCOMME,CON_POSBIL from conti where " + x_cond + " order by con_soc,con_anno,con_conto"   && SIMONE - 06/09/2011
IF !ExecCommand(cSql,"cur_conti")
   return(.f.)
ENDIF
SELECT cur_conti
GO TOP
IF EOF()
   WDES_CON=SPACE(25)
   WOBBLIGO_COMMESSA = .F.			&& SIMONE - 06/09/2011
   WPOSBIL = ''						&& SIMONE - 06/09/2011
ELSE
   WDES_CON=ALLTRIM(CON_DESCR)
   WOBBLIGO_COMMESSA = CON_NOCOMME	&& SIMONE - 06/09/2011
   WPOSBIL = CON_POSBIL				&& SIMONE - 06/09/2011
ENDIF


SELECT TEMPO
APPEND BLANK
DO AGG_TEMPO

RETURN


*********************
PROCEDURE TOTALE
*********************

IF STAMPER = 1  && GRAFICA
   IF WIMPD = 0 .AND. WIMPA = 0
   ELSE
      SELECT TEMPO
      APPEND BLANK
      IF STAMPER = 2
         REPLACE COD       WITH "Valuta:."+WCODVAL
         REPLACE DES_CON   WITH "Cambio:."+STR(WCAMBIO,13,6)
         REPLACE DES_MANU  WITH 'TOTALI =========>>>'  && VIDEO
      ELSE
         IF SINTESI
         ELSE
            REPLACE COD       WITH "Valuta:."+WCODVAL
            REPLACE DES_CON   WITH "Cambio:."+STR(WCAMBIO,13,6)
            REPLACE DES_MANU  WITH 'TOTALI =========>>>'   && STAMPA
         ENDIF
      ENDIF
      TOTALED   = STR(WIMPD,17,3)
      TOTALEA   = STR(WIMPA,17,3)
      REPLACE DARE     WITH ALLTRIM(TOTALED)
      REPLACE AVERE    WITH ALLTRIM(TOTALEA)
      REPLACE I_DREG   WITH  WI_DREG      &&  KEY DI SELEZIONE
      REPLACE I_NREG   WITH  WI_NREG
      APPEND BLANK
      DO ROTT_TEMPO
   ENDIF
ELSE
   SELECT TEMPO
   APPEND BLANK
   IF STAMPER = 2
      REPLACE DES_MANU  WITH 'TOTALI =========>>>'  && STAMPA
   ELSE
      IF SINTESI
      ELSE
         REPLACE DES_CON  WITH 'TOTALI =========>>>'   && VIDEO
      ENDIF
   ENDIF
   TOTALED   = STR(WIMPD,17,3)
   TOTALEA   = STR(WIMPA,17,3)
   REPLACE DARE     WITH ALLTRIM(TOTALED)
   REPLACE AVERE    WITH ALLTRIM(TOTALEA)
   REPLACE I_DREG   WITH  WI_DREG      &&  KEY DI SELEZIONE
   REPLACE I_NREG   WITH  WI_NREG
   APPEND BLANK
   DO ROTT_TEMPO
ENDIF

WIMPD=0
WIMPA=0

RETURN

****************************
PROCEDURE AGG_TEMPO
****************************

WNRI = WNRI +1

REPLACE I_DREG   WITH  WI_DREG      &&  KEY DI SELEZIONE
REPLACE I_NREG   WITH  WI_NREG
REPLACE NRI      WITH  STR(WNRI,3,0)
REPLACE DREG     WITH  WDREG
REPLACE DTDOC    WITH  WDTDOC
REPLACE NPROT    WITH  WNPROT
REPLACE NREG     WITH  WNREG
REPLACE NDORI    WITH  WNDORI 	
REPLACE DTORI    WITH  WDTORI 	
REPLACE COD      WITH  WCOD
REPLACE DES_CON  WITH  ALLTRIM(WDES_CON)
REPLACE DES_TOP  WITH  WDES_TOP
REPLACE TOP      WITH  WTOP
REPLACE NDOCUM   WITH  WNDOC
REPLACE DES_MANU WITH  WDES_MANU
REPLACE NUMINT   WITH  WNUMINT
REPLACE AVERE    WITH  ALLTRIM(WAVERE)
REPLACE DARE     WITH  ALLTRIM(WDARE)
REPLACE CAM_BIO  WITH  WCAMBIO
REPLACE CODVAL   WITH  WCODVAL
REPLACE CONTABILITA_PREVISIONALE WITH WCONTABILITA_PREVISIONALE
REPLACE OBBLIGO_COMMESSA  WITH WOBBLIGO_COMMESSA	&& SIMONE - 06/09/2011
REPLACE POSBIL            WITH WPOSBIL            	&& SIMONE - 06/09/2011
REPLACE NUMCOM			  WITH WNUMEROCOMMESSA 		&& SIMONE - 04/10/2011
REPLACE DTSCAD			  WITH WDTSCAD				&& ERASMO - 05/11/2020
&& SIMONE - 06/09/2011
XVALORE   = W_IMP

IF AVV
   AVV=.F.
   WIMPA = WIMPA+XVALORE
ENDIF

IF DAR
   DAR=.F.
   WIMPD = WIMPD+XVALORE
ENDIF

RETURN


****************************
 PROCEDURE ROTT_TEMPO
****************************

WNRI = 0

REPLACE I_DREG   WITH  WI_DREG      &&  KEY DI SELEZIONE
REPLACE I_NREG   WITH  WI_NREG

RETURN


****************************
PROCEDURE STP_SPOOL
****************************

CREATE CURSOR XSTAMPA(RIGA C (220))

TDARE  = 0
TAVERE = 0

DO LIBTES WITH .F.          && STAMPA TESTATA SENZA SALTO PAGINA

SELECT TEMPO
GO TOP

IF EOF()
   PUB_ERRORE=MESSAGEBOX('Periodo selezionato'+CHR(13)+'privo di registrazioni',62,'*** ATTENZIONE ***')
   RETURN
ENDIF

NUM_INOL = " "

SELECT TEMPO

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF SUBSTR(DREG,1,5) = "====="
      SELECT TEMPO
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR

   IF SUBSTR(M.DES_MANU,1,6) = "TOTALI"
      SELECT TEMPO
      SKIP +1
      LOOP
   ENDIF

   IF RIGA_SP > NEW_PAG
      DO LIBTES WITH .T.          && STAMPA TESTATA CON SALTO PAGINA
   ENDIF

   IF NUM_INOL <> NUMINT
      SELECT XSTAMPA
      APPEND BLANK
      REPLACE RIGA WITH   "------ Rifer. P.NOTA Numero:.."+M.NREG+"...Data Registrazione:."+M.DREG+" "+M.NREG+"..Valuta:."+M.CODVAL+"...Cambio:."+STR(M.CAM_BIO,13,6)+"---------------------------------------------------------------------------------------------"
      NUM_INOL = NUMINT
      RIGA_SP = RIGA_SP + 1
   ENDIF

   SELECT XSTAMPA
   APPEND BLANK

   IF F_CHIUSURA && OK STAMPA MOVIMENTI DI CHIUSURA  E CONTEGGIA IN TOTALI SE CHIUS.AL 31/12
      IF M.TOP = "CHI"
         IF SUBSTR(DREG,4,2) = "12"
            TDARE  = TDARE  + VAL(M.DARE)
            TAVERE = TAVERE + VAL(M.AVERE)
         ENDIF
      ELSE
         TDARE  = TDARE  + VAL(M.DARE)
         TAVERE = TAVERE + VAL(M.AVERE)
      ENDIF M.TOP = "CHI"
   ELSE
      TDARE  = TDARE  + VAL(M.DARE)
      TAVERE = TAVERE + VAL(M.AVERE)
   ENDIF

   SEPARA = SPACE(12)

   IF SINTESI
	  *IF VAL(M.DARE) <> 0
	  IF !EMPTY(ALLTRIM(M.DARE))  && ERASMO/SERGIO - 02/05/2022 - PER GESTIRE ANCHE IMPORTI IN DARE E/O IN AVERE UGUALI A ZERO
         REPLACE RIGA WITH   "|"+M.NRI+" |"+ M.DES_CON+" | "+ M.TOP+"  "+  M.NDOCUM+""+M.DTDOC+" "+M.NPROT+" | "+ TRANSFORM(VAL(M.DARE),'999,999,999.999') + "   " + SEPARA +" | " + SUBSTR(M.DES_MANU,1,16)+"| " +M.CONTABILITA_PREVISIONALE +" |"                                   
	  ELSE
         REPLACE RIGA WITH   "|"+M.NRI+" |"+ M.DES_CON+" | "+ M.TOP+"  "+  M.NDOCUM+""+M.DTDOC+" "+M.NPROT+" | "+ SEPARA  + "   " + TRANSFORM(VAL(M.AVERE),'999,999,999.999') +" | " + SUBSTR(M.DES_MANU,1,16)+"| " +M.CONTABILITA_PREVISIONALE+" |"
	  ENDIF
   ELSE
	  *IF VAL(M.DARE) <> 0
	  IF !EMPTY(ALLTRIM(M.DARE))  && ERASMO/SERGIO - 02/05/2022 - PER GESTIRE ANCHE IMPORTI IN DARE E/O IN AVERE UGUALI A ZERO
         REPLACE RIGA WITH   "|"+M.NRI+" |"+ M.DES_CON+" | "+ M.TOP+"  "+  M.NDOCUM+""+M.DTDOC+" "+M.NPROT+" | "+ TRANSFORM(VAL(M.DARE),'999,999,999.999') + "   " + SEPARA +" | " + SUBSTR(M.DES_MANU,1,88)+"| " +M.CONTABILITA_PREVISIONALE+" |"
	  ELSE
         REPLACE RIGA WITH   "|"+M.NRI+" |"+ M.DES_CON+" | "+ M.TOP+"  "+  M.NDOCUM+""+M.DTDOC+" "+M.NPROT+" | "+ SEPARA  + "   " + TRANSFORM(VAL(M.AVERE),'999,999,999.999') +" | " + SUBSTR(M.DES_MANU,1,88)+"| " +M.CONTABILITA_PREVISIONALE+" |"
	  ENDIF
   ENDIF

   RIGA_SP = RIGA_SP + 1

   SELECT TEMPO
   SKIP +1

ENDDO


IF RIGA_SP > NEW_PAG
   DO LIBTES WITH .T.          && STAMPA TESTATA CON SALTO PAGINA
ENDIF

SELECT XSTAMPA
APPEND BLANK
REPLACE RIGA WITH "    "
APPEND BLANK
REPLACE RIGA WITH "    "
APPEND BLANK
REPLACE RIGA WITH  SPACE(20)+"Totali Generali :"+ TRAN(TDARE,"99,999,999,999.999") + "  "  + TRAN(TAVERE,"99,999,999,999.999") + TRAN((TDARE - TAVERE),"99,999,999,999.999")

SELECT XSTAMPA
APPEND BLANK
REPLACE RIGA WITH ""
GO TOP
DO CREA_SPOOL WITH "XSTAMPA","PRIMA NOTA "+DATADAL+" "+DATAAL




=MESSAGEBOX("Fine elaborazione. Procedi con la stampa tramite lo spooler",62,"ATTENZIONE")

RETURN


****************************
PROCEDURE LIBTES
****************************
PARA SALTA_P

IF SALTA_P
   M.RIGA0=""+PUB_DESSOC   && SALTO PAGINA SPOOLER
ELSE
   M.RIGA0=PUB_DESSOC
ENDIF

M.RIGA1=SPACE(040)+"STAMPA PRIMA NOTA "+"   PERIODO DAL "+DATADAL+" AL "+DATAAL
M.RIGA2=SPACE(130)
M.RIGA3="--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
M.RIGA4="|NUM.|         P  A  R  T  I  T  E             |      D O C U M E N T O       |                I M P O R T I      | ULTERIORE                                                                            | P |"
M.RIGA5="|RIGA|     DESCRIZIONE CONTI CONTABILI         | CAUS  NUM    DATA   PROT.IVA |           D A R E       A V E R E | DESCRIZIONE                                                                          | E |"
M.RIGA6="--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------"
M.RIGA7=SPACE(130)

SELECT XSTAMPA
APPEND BLANK
REPLACE RIGA WITH M.RIGA0
APPEND BLANK
REPLACE RIGA WITH M.RIGA1
APPEND BLANK
REPLACE RIGA WITH M.RIGA2
APPEND BLANK
REPLACE RIGA WITH M.RIGA3
APPEND BLANK
REPLACE RIGA WITH M.RIGA4
APPEND BLANK
REPLACE RIGA WITH M.RIGA5
APPEND BLANK
REPLACE RIGA WITH M.RIGA6
APPEND BLANK
REPLACE RIGA WITH M.RIGA7
APPEND BLANK

RIGA_SP = 7

RETURN


****************************
PROCEDURE STP_GRA
****************************

SELECT TEMPO
GO TOP
IF SINTESI
   DELETE FOR EMPTY(NRI) ALL            && CANCELLA I TOTALI DI OGNI SINGOLA REGISTRAZIONE PER STAMPA SINTETICA
ENDIF

SELECT TEMPO
GO TOP


IF SINTESI
   IF INVALUTA
      DO PRG\MENUSTA WITH "TEMPO",.T.,.F.,"XXX","PRIMAVVAX","PRIMAVVA.FRX"
   ELSE
      DO PRG\MENUSTA WITH "TEMPO",.T.,.F.,"XXX","PRIMASIX","PRIMASI.FRX"
   ENDIF
ELSE
   DO PRG\MENUSTA WITH "TEMPO",.T.,.F.,"XXX","PRIMASIX","PRIMASI.FRX"
ENDIF
   


RETURN


****************************************************************
FUNCTION TIPOCO
****************************************************************
* RESTITUISCE : 
* 1 >> FATTURA CLIENTE
* 2 >> FATTURA FORNITORE
* 3 >> ALTRE TIPOLOGIE DI PRIME NOTE
* 4 >> INCASSO CLIENTE
* 5 >> PAGAMENTO A FORNITORE

PARA V1

SS= SELECT()

***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE/FORNITORE
v_seek   = 'TOP'+KTOP
v_chiave = "codice"
IF seek_std('PARA',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_FLFATTU = SUBSTR(LIBERA,02,1)
   V_CF      = SUBSTR(LIBERA,12,1)
ELSE
   SELECT (SS)
   RETURN(3)
ENDIF

SELECT(SS)

IF V_CF="C" .AND. V_FLFATTU="S"       && FATTURA CLIENTE
   RETURN(1)
ENDIF

IF V_CF="F" .AND. V_FLFATTU="S"       && FATTURA FORNITORE
   RETURN(2)
ENDIF

IF V_CF="C" .AND. V_FLFATTU="P"       && INCASSO CLIENTE
   RETURN(4)
ENDIF

IF V_CF="C" .AND. V_FLFATTU="C"       && INCASSO CLIENTE CORRISPETTIVI
   RETURN(4)
ENDIF


IF V_CF="F" .AND. V_FLFATTU="P"       && PAGAMENTO FORNITORE
   RETURN(5)
ENDIF


RETURN(3)                             && ALTRE TIPOLOGIE DI REGISTRAZIONI


****************************************************************
FUNCTION CTR_IVA
****************************************************************
PARA V1

CTR=SELECT()
OUT=.F.

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(V1) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(cSql,"cur_conti")
   return(.f.)
ENDIF
SELECT cur_conti
GO TOP
IF EOF()
ELSE
   IF CON_TIPOCO = "I"
      OUT=.T.
   ENDIF
ENDIF

*** v_seek = PUB_CODSOC+PUB_ANNO+ALLTRIM(V1)
*** v_chiave  = "con_soc+con_anno+con_conto"
*** IF seek_std('CONTI',v_seek,v_chiave,'CUR_CONTI')
***    SELECT CUR_CONTI
***    IF CON_TIPOCO = "I"
***       OUT=.T.
***    ENDIF
*** ENDIF

SELECT(CTR)

RETURN(OUT)

