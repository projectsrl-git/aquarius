

*!*	**************************************************************************************************
*!*	*                       VERIFICA EVENTUALI CENTESIMI DI ARROTONDAMENTO
*!*	**************************************************************************************************


    


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


**************************************************************************
*                     CALCOLO DEL BILANCIO                               *
**************************************************************************


WAIT WINDOWS "Fase 1 : Calcolo bilancio in corso attendere prego "  nowait


IF !ExecCommand("select * from CONTICA where 0=1","CONTICA_DEC")  
  return(.f.)
ENDIF
SELECT CONTICA_DEC
AA = AFIELDS(BB)
CREATE CURSOR CU_CONTICA_DEC FROM ARRAY BB	
INDEX ON CON_SOC + CON_ANNO + CON_CONTO TAG I_CONTO ADDITIVE

CREATE CURSOR XCONTICA FROM ARRAY BB	
INDEX ON CON_SOC + CON_ANNO + CON_CONTO TAG CONTO ADDITIVE


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

*** AZZERAMENTO CONTICA

WAIT WINDOW "Sto azzerando i saldi e ricreo CONTICA"  TIMEOUT 2  

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cond = x_soci + " and " + x_anno
Csql   = "select * from CONTICA where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"CONTICA","R")
   return(.f.)
ENDIF
SELECT CONTICA
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

	*!*	_________________________________________________________________________CREA CU_CONTICA_DEC CON I CONTICA : GRUPPO !! SOTTOGRUPPO !! CONTO ELEMENTARE
	SELECT CU_CONTICA_DEC  
	SET ORDER TO I_CONTO
	___SEEK = PUB_CODSOC+PUB_ANNO+ALLTRIM(__CONTOX)

	SEEK ___SEEK 
	IF !FOUND()
		APPEND BLANK
		GATHER MEMVAR MEMO
	ENDIF
	*!*	_________________________________________________________________________CREA CU_CONTICA_DEC CON I CONTICA : GRUPPO!!-SOTTOGRUPPO!!-CONTO ELEMENTARE AZZERANDOLI


    	
   SELECT CONTICA
   SKIP +1

ENDDO  



SELECT CU_CONTICA_DEC 
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
  

  *** NON HA SENSO FARE LE CHIUSURE CON I PREVISIONALI
  IF MOV_CONTABILITA_PREVISIONALE = 'P'
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
		  _VALORE   = CAMBIO(_CODVAL,_IMP,_CAMBIO,(_SOC+_ANNO+_CONTO),.F.,10)   

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

	*#### INIZIO RICALCOLA_DEC ########################################################
	AGG_D   = .F.
	AGG_A   = .F.
	DIFLIRA = ABS(_DIFDA)

	SELECT WW_TEMPO
	GO TOP

	QU = 0

	DO WHILE !EOF()

	    *** AGGIORNO IL DATABASES CONTICA

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
	      DA =   CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO,(MOV_SOC+MOV_ANNO+MOV_CONTO),.F.,10)  
	    ENDIF
	    IF MOV_TMOV  = "A"
	      AV =   CAMBIO(MOV_VALUTA,MOV_IMP,MOV_CAMBIO,(MOV_SOC+MOV_ANNO+MOV_CONTO),.F.,10)  
	    ENDIF
	     
	    XCONTO  = MOV_CONTO 
	    DATAREG = MOV_DTREG 
	      
	 
		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO ELEMENTARE SU CU_CONTICA_DEC
		SELECT CU_CONTICA_DEC  
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
		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO ELEMENTARE SU CU_CONTICA_DEC


		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO SOTTOGRUPPO SU CU_CONTICA_DEC
		SELECT CU_CONTICA_DEC  
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
		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO SOTTOGRUPPO SU CU_CONTICA_DEC
		

		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO MASTRO SU CU_CONTICA_DEC
		SELECT CU_CONTICA_DEC  
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
		*!* ________________________________________________________________________________________AGGIORNA SALDO CONTO DI TIPO MASTRO SU CU_CONTICA_DEC

	   QU=QU+1
	  
	   SELECT WW_TEMPO
	   SKIP +1
	  
	ENDDO
	*#### FINE RICALCOLA_DEC   ########################################################
  
  SELECT INDICE
  SKIP +1
  
ENDDO


WAIT WINDOW "Stò ricalcolando il saldo totale "  TIMEOUT 1   

SELECT CU_CONTICA_DEC 
SET ORDER TO I_CONTO
GO TOP
DO WHILE .NOT. EOF()

   	TDARE  = CON_DA01 + CON_DA02 + CON_DA03 + CON_DA04 + CON_DA05 + CON_DA06 + CON_DA07 + CON_DA08 + CON_DA09 + CON_DA10 + CON_DA11 + CON_DA12
   	TAVERE = CON_AV01 + CON_AV02 + CON_AV03 + CON_AV04 + CON_AV05 + CON_AV06 + CON_AV07 + CON_AV08 + CON_AV09 + CON_AV10 +	CON_AV11 + CON_AV12
	
   	REPLACE CON_IMP_D WITH TDARE
   	REPLACE CON_IMP_A WITH TAVERE

	SELECT CU_CONTICA_DEC
	SKIP +1
	
ENDDO


SELECT CU_CONTICA_DEC 
SET ORDER TO I_CONTO
GO TOP



** CONTROAGGIORNA IL DATABASE CONTICA ARROTONDANDO UNA SOLA VOLTA A DUE DECIMALI E PRENDENDO I VALORI DA CU_CONTICA_DEC

SELECT CONTICA
GO TOP
DO WHILE .NOT. EOF()

    XCONTO = ALLTRIM(CON_CONTO)


	SELECT CU_CONTICA_DEC  
	SET ORDER TO I_CONTO
	___SEEK = PUB_CODSOC+PUB_ANNO+ALLTRIM(XCONTO)
	SEEK ___SEEK 
	IF FOUND()

		SCATTER MEMVAR 
		
		MESE = SA
		
		SELECT CONTICA
					
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


	SELECT CONTICA
	SKIP +1
	
ENDDO
GO TOP

IF !ExecRW(cSql,"CONTICA","W")
   return(.f.)
ENDIF



*!*	_________________________________________________________________________________________________AZZERA I GRUPPI/SOTTOGRUPPI E CREA CURSORE DI SUPPORTO CON 10 DECIMALI



IF !ExecCommand("select * from CONTICA where 0=1","CU_BILANCIO")
  return(.f.)
ENDIF
SELECT CU_BILANCIO
AA = AFIELDS(BB)
CREATE CURSOR BILANCIO FROM ARRAY BB	
INDEX ON CON_SOC + CON_ANNO + CON_CONTO TAG I_CONTO ADDITIVE

*!*	_________________________________________________________________________SALVA I DATI RELATIVI AI CONTICA ELEMENTERI SUL CURSORE DEL BILANCIO CON 10 DECIMALI

CTRELAB=0

SELECT CU_CONTICA_DEC  
SET ORDER TO I_CONTO
GO TOP
DO WHILE .NOT. EOF()


   	IF DELETED()
		SELECT CU_CONTICA_DEC
      	SKIP +1
      	LOOP
   	ENDIF    

   	CODICE_CONTO=CON_CONTO
  
   	IF (LEN(ALLTRIM(CODICE_CONTO))=PUB_MASTRO-1) .OR. (LEN(ALLTRIM(CODICE_CONTO))=PUB_SOTTOG-1)
		SELECT CU_CONTICA_DEC
      	SKIP +1
      	LOOP
   	ENDIF

   	TDA = CON_DA01+CON_DA02+CON_DA03+CON_DA04+CON_DA05+CON_DA06+CON_DA07+CON_DA08+CON_DA09+CON_DA10+CON_DA11+CON_DA12
   	TAV = CON_AV01+CON_AV02+CON_AV03+CON_AV04+CON_AV05+CON_AV06+CON_AV07+CON_AV08+CON_AV09+CON_AV10+CON_AV11+CON_AV12
 
   	IF TDA = 0  .AND.  TAV  = 0   && NON CARICA I CONTICA CON IMPORTI A ZERO
		SELECT CU_CONTICA_DEC
		SKIP +1
      	LOOP
   	ENDIF    
      
	SCATTER MEMVAR MEMO
	
	SELECT BILANCIO  
	SET ORDER TO I_CONTO
	APPEND BLANK
	GATHER MEMVAR MEMO


   	CTRELAB=CTRELAB+1 
   
   	WAIT WINDOW  "Fase di creazione CONTICA elementari in corso"+STR(CTRELAB,6,0) NOWAIT

	SELECT CU_CONTICA_DEC  
	SKIP +1
	
ENDDO

          

CTRELAB=0



SELECT BILANCIO
SET ORDER TO I_CONTO
GO TOP

* WAIT WINDOW "FASE : AGGIORNAMENTO D.B. CONTICA"
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

   IF EOF()    && RIELABORA IL CURSORE PER AGGIORNARE IL DB.CONTICA
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


*!* ________________________________________________________________________________________CONTROAGGIORNA CONTICA RIPORTANDO ARROTONDANDO UNA SOLA VOLTA I GRUPPI/SOTTOGRUPPI
*!* ________________________________________________________________________________________I CONTICA ELEMENTARI SONO STATI AGGIORNATI NELLA FASE DI CREAZIONE SALDI
SELECT CU_CONTICA_DEC  
SET ORDER TO I_CONTO
GO TOP
DO WHILE .NOT. EOF()


   	CODICE_CONTO=CON_CONTO
  
   	IF (LEN(ALLTRIM(CODICE_CONTO))=PUB_MASTRO-1) .OR. (LEN(ALLTRIM(CODICE_CONTO))=PUB_SOTTOG-1)
   	ELSE
		SELECT CU_CONTICA_DEC
      	SKIP +1
      	LOOP
   	ENDIF



    SCATTER MEMVAR memo 
    
	x_soci 	= "con_soc = '" + PUB_CODSOC + "'"
	x_anno 	= "con_anno = '" + PUB_ANNO + "'"
	x_conto	= "con_conto = '" + M.CON_CONTO + "'"
	
	x_cond = x_soci + " and " + x_anno + " and " + x_conto
	Csql   = "select * from CONTICA where " + x_cond + " order by con_soc,con_anno,con_conto"
	IF !ExecRW(cSql,"CONTICA","R")
	   return(.f.)
	ENDIF
	SELECT CONTICA
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
			_DARE_10DEC		=	ROUND(((M.CON_DA&V_MM)),10)			&& VARIABILI DI CU_CONTICA_DEC
			_AVERE_10DEC	=	ROUND(((M.CON_AV&V_MM)),10)			&& VARIABILI DI CU_CONTICA_DEC
		    REPLACE CON_DA&V_MM WITH _DARE_10DEC						&& AGGIORNO CONTICA					
		    REPLACE CON_AV&V_MM WITH _AVERE_10DEC					&& AGGIORNO CONTICA	
		    MESE = MESE +1
		ENDDO
		T_DARE_10DEC		=	ROUND(((M.CON_IMP_D)),10)				&& VARIABILI DI CU_CONTICA_DEC
		T_AVERE_10DEC		=	ROUND(((M.CON_IMP_A)),10)				&& VARIABILI DI CU_CONTICA_DEC
   		REPLACE CON_IMP_D 	WITH T_DARE_10DEC							&& AGGIORNO CONTICA	
   		REPLACE CON_IMP_A 	WITH T_AVERE_10DEC							&& AGGIORNO CONTICA	
	ENDIF
	IF !ExecRW(cSql,"CONTICA","W")
	   return(.f.)
	ENDIF


	SELECT CU_CONTICA_DEC  
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


V_CONTICA="01,02,03,99"
v_seek 	 = "DTE_CO"+PUB_CODSOC     && PARAMETRO - DATI TESTATA RIGA 3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_CONTICA=ALLTRIM(LIBERA)
ENDIF
V_ECODAL = STR_EXTRACT(V_CONTICA,",",1)
V_ECOAL  = STR_EXTRACT(V_CONTICA,",",2)
V_PATDAL = STR_EXTRACT(V_CONTICA,",",3)
V_PATAL  = STR_EXTRACT(V_CONTICA,",",4)
V_DAL    = SA
V_AL     = SM
_DB = "XCONTICA"											&& NON USATO
=SALDIATT(_DB)	&& AGGIUNGE I SALDI DELL'ANNO PRECEDENTE 				
STAMPA_SOLO_I_CLIENTI_FORNITORI = .F.
NON_STAMPA_I_CLIENTI_FORNITORI  = .F.
ANNOP__ = ""
STAMPA_SOLO_I_GRUPPI_SOTTOGRUPPI = .F.
OK_SALDI = .T.  && Non stampa i  CONTICA con saldo  a zero

WAIT WINDOW "Attendere elaborazione bilancio in corso ..." NOWAIT
VA_TOTALE = 0
VD_TOTALE = 0
DO SBCCHIU WITH "P",V_ECODAL,V_ECOAL,V_DAL,V_AL,PUB_ANNO,_DB,STAMPA_SOLO_I_CLIENTI_FORNITORI,STAMPA_SOLO_I_GRUPPI_SOTTOGRUPPI,ANNOP__,NON_STAMPA_I_CLIENTI_FORNITORI
PAT_DARE    = round(va_totale,2)
PAT_AVERE   = round(vd_totale,2)
PAT_SALDO   = round(va_totale,2)-round(vd_totale,2)

VA_TOTALE = 0
VD_TOTALE = 0
DO SBCCHIU WITH "E",V_PATDAL,V_PATAL,V_DAL,V_AL,PUB_ANNO,_DB,STAMPA_SOLO_I_CLIENTI_FORNITORI,STAMPA_SOLO_I_GRUPPI_SOTTOGRUPPI,ANNOP__,NON_STAMPA_I_CLIENTI_FORNITORI

ECO_DARE    = round(va_totale,2)
ECO_AVERE   = round(vd_totale,2)
ECO_SALDO   = round(va_totale,2)-round(vd_totale,2)

TOT_SALDO	= PAT_SALDO + ECO_SALDO


*** FAB - 12/11/2011 ARROTONDAMENTO DEI CENTESIMI
***
*** SE HO UNO SBILANCIO MINORE DI +/- 10 CENT. FACCIO UN UPDATE DELLO SBILANCIO SU
*** 1) IL CONTO IMPOSTATO NEI PARAMETRI COME CONTO DI ARROTONDAMENTO
*** 2) SE 1) NON ESISTE SU PARA OPPURE ESISTE SU PARA MA NON SU CONTI, ALLORA FACCIO UN UPDATE SUL PRIMO CONTO CHE TROVO SULL'ANNO E RICALCOLO I SALDI

IF TOT_SALDO <> 0 .AND. ABS(TOT_SALDO) < 0.10

	_strdelta = ALLTRIM(STRTRAN(STR(TOT_SALDO,20,2),',','.'))
	
	*** CERCO IL CONTO INPOSTATO NEI PARAMETRI COME CONTO DI ARROTONDAMENTO
	
	Csql   = "SELECT * FROM PARA WHERE CODICE='CAA"+PUB_ANNO+"'"
	IF !ExecCommand(Csql,"UPD_CONTICA")
	   return(.f.)
	ENDIF	
	
	SELECT UPD_CONTI
	
	_CONTO_ARROTONDAMENTI = ""
	
	IF !EOF()
		_CONTO_ARROTONDAMENTI = ALLTRIM(LIBERA)
	ENDIF
	
	*** IL CONTO PER GLI ARROTONDAMENTI E' IMPOSTATO SU PARA
	*** ORA LO CERCO SU CONTI
	
	Csql   = "SELECT * FROM CONTICA WHERE CON_CONTO='"+_CONTO_ARROTONDAMENTI+"' AND CON_ANNO='"+PUB_ANNO+"' " 
	IF !ExecCommand(Csql,"UPD_CONTICA")
	   return(.f.)
	ENDIF	
	
	SELECT UPD_CONTICA
	IF EOF()
		_CONTO_ARROTONDAMENTI = ""
	ENDIF	
	
	
	IF !EMPTY(_CONTO_ARROTONDAMENTI )
		*** FACCIO UN UPDATE SUL CONTO IMPOSTATO NEI PARAMETRI COME CONTO DI ARROTONDAMENTO
		x_soci = "con_soc = '" + PUB_CODSOC + "'"
		x_anno = "con_anno = '" + PUB_ANNO + "'"
		x_cont = "LEN(CON_CONTO) >= "+ ALLTRIM(STR(PUB_SOTTOG))
		x_pbil = "CON_POSBIL = 'P'"
		x_cimp = "CON_IMP_D <> CON_IMP_A"
		x_cond = x_soci + " and " + x_anno + " and " + x_cont + " and " + x_pbil + " and " + x_cimp 
		Csql   = "UPDATE CONTICA SET CON_DA01 = CON_DA01 - (&_strdelta) , CON_IMP_D = CON_IMP_D - (&_strdelta) where CON_CONTO='" +_CONTO_ARROTONDAMENTI  + "' AND " + x_anno
	ELSE
		*** DEL PRIMO CONTO CHE TROVO SULL'ANNO E RICALCOLO I SALDI
		_strdelta = ALLTRIM(STRTRAN(STR(TOT_SALDO,20,2),',','.'))
		x_soci = "con_soc = '" + PUB_CODSOC + "'"
		x_anno = "con_anno = '" + PUB_ANNO + "'"
		x_cont = "LEN(CON_CONTO) >= "+ ALLTRIM(STR(PUB_SOTTOG))
		x_pbil = "CON_POSBIL = 'P'"
		x_cimp = "CON_IMP_D <> CON_IMP_A"
		x_cond = x_soci + " and " + x_anno + " and " + x_cont + " and " + x_pbil + " and " + x_cimp 
		Csql   = "UPDATE CONTICA SET CON_DA01 = CON_DA01 - (&_strdelta) , CON_IMP_D = CON_IMP_D - (&_strdelta) where CON_CONTO IN " + ;
				"(SELECT TOP 1 CON_CONTO FROM CONTICA WHERE " + x_cond + " ORDER BY CON_CONTO ) AND " + x_anno
	ENDIF 	
	IF !ExecCommand(Csql,"UPD_CONTICA")
	   return(.f.)
	ENDIF

	_DB = "XCONTICA"											&& NON USATO
	=SALDIATT(_DB)	&& AGGIUNGE I SALDI DELL'ANNO PRECEDENTE				
	WAIT WINDOW "Attendere elaborazione bilancio in corso ..." NOWAIT
	VA_TOTALE = 0
	VD_TOTALE = 0
	DO SBCCHIU WITH "P",V_ECODAL,V_ECOAL,V_DAL,V_AL,PUB_ANNO,_DB,STAMPA_SOLO_I_CLIENTI_FORNITORI,STAMPA_SOLO_I_GRUPPI_SOTTOGRUPPI,ANNOP__,NON_STAMPA_I_CLIENTI_FORNITORI
	PAT_DARE    = round(va_totale,2)
	PAT_AVERE   = round(vd_totale,2)
	PAT_SALDO   = round(va_totale,2)-round(vd_totale,2)

	VA_TOTALE = 0
	VD_TOTALE = 0
	DO SBCCHIU WITH "E",V_PATDAL,V_PATAL,V_DAL,V_AL,PUB_ANNO,_DB,STAMPA_SOLO_I_CLIENTI_FORNITORI,STAMPA_SOLO_I_GRUPPI_SOTTOGRUPPI,ANNOP__,NON_STAMPA_I_CLIENTI_FORNITORI

	ECO_DARE    = round(va_totale,2)
	ECO_AVERE   = round(vd_totale,2)
	ECO_SALDO   = round(va_totale,2)-round(vd_totale,2)

	TOT_SALDO	= PAT_SALDO + ECO_SALDO

ENDIF

WAIT CLEAR




DO FORM FORM\BILRIE LINKED


SET CURSOR ON



PUB_ERRORE=MESSAGEBOX('Calcolo bilancio '+CHR(13)+'terminato correttamente',64,'*** ATTENZIONE ***') 


RETURN


