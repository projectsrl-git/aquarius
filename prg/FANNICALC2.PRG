   


*************************************************************************************************************
*  CALCOLO DEL BILANCIO DI CHIUSURA ESERCIZIO PER IL PERIODO DAL 01/05/XXXX AL 30/04/XXXX                   *
*************************************************************************************************************



RELEASE SA,SM
PUBLIC SA,SM
SA = 1
SM = 12



WAIT WINDOWS "Fase 0 : ricreazione parametro bil in corso "  nowait
DO parabil2 										&& ricrea parametro bil 
WAIT WINDOWS "Fase 1 : Calcolo bilancio in corso attendere prego "  nowait



DO FORM FORM\ATTENDI  LINKED


*!*	_________________________________________________________________________________________________AZZERA I GRUPPI/SOTTOGRUPPI E CREA CURSORE DI SUPPORTO CON 10 DECIMALI

IF !ExecCommand("select * from contica where 0=1","CU_BILANCIO")  && ERASMO - 25/05/2011
  return(.f.)
ENDIF
SELECT CU_BILANCIO
AA = AFIELDS(BB)
CREATE CURSOR BILANCIO FROM ARRAY BB	
INDEX ON CON_SOC + CON_ANNO + CON_CONTO TAG I_CONTO ADDITIVE

*!*	_________________________________________________________________________SALVA I DATI RELATIVI AI CONTI ELEMENTERI SUL CURSORE DEL BILANCIO CON 10 DECIMALI

CTRELAB=0

SELECT CU_contica_DEC  
SET ORDER TO I_CONTO
GO TOP
DO WHILE .NOT. EOF()


   	IF DELETED()
		SELECT CU_contica_DEC
      	SKIP +1
      	LOOP
   	ENDIF    

   	CODICE_CONTO=CON_CONTO
  
   	IF (LEN(ALLTRIM(CODICE_CONTO))=PUB_MASTRO-1) .OR. (LEN(ALLTRIM(CODICE_CONTO))=PUB_SOTTOG-1)
		SELECT CU_contica_DEC
      	SKIP +1
      	LOOP
   	ENDIF

   	TDA = CON_DA01+CON_DA02+CON_DA03+CON_DA04+CON_DA05+CON_DA06+CON_DA07+CON_DA08+CON_DA09+CON_DA10+CON_DA11+CON_DA12
   	TAV = CON_AV01+CON_AV02+CON_AV03+CON_AV04+CON_AV05+CON_AV06+CON_AV07+CON_AV08+CON_AV09+CON_AV10+CON_AV11+CON_AV12
 
   	IF TDA = 0  .AND.  TAV  = 0   && NON CARICA I CONTI CON IMPORTI A ZERO
		SELECT CU_contica_DEC
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

	SELECT CU_contica_DEC  
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

   IF EOF()    && RIELABORA IL CURSORE PER AGGIORNARE IL DB.contica
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


*!* ________________________________________________________________________________________CONTROAGGIORNA contica RIPORTANDO ARROTONDANDO UNA SOLA VOLTA I GRUPPI/SOTTOGRUPPI
*!* ________________________________________________________________________________________I CONTI ELEMENTARI SONO STATI AGGIORNATI NELLA FASE DI CREAZIONE SALDI
SELECT CU_contica_DEC  
SET ORDER TO I_CONTO
GO TOP
DO WHILE .NOT. EOF()


   	CODICE_CONTO=CON_CONTO
  
   	IF (LEN(ALLTRIM(CODICE_CONTO))=PUB_MASTRO-1) .OR. (LEN(ALLTRIM(CODICE_CONTO))=PUB_SOTTOG-1)
   	ELSE
		SELECT CU_contica_DEC
      	SKIP +1
      	LOOP
   	ENDIF



    SCATTER MEMVAR memo 
    
	x_soci 	= "con_soc = '" + PUB_CODSOC + "'"
	x_anno 	= "con_anno = '" + PUB_ANNO + "'"
	x_conto	= "con_conto = '" + M.CON_CONTO + "'"
	
	x_cond = x_soci + " and " + x_anno + " and " + x_conto
	Csql   = "select * from contica where " + x_cond + " order by con_soc,con_anno,con_conto"
	IF !ExecRW(cSql,"contica","R")
	   return(.f.)
	ENDIF
	SELECT contica
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
			_DARE_10DEC		=	ROUND(((M.CON_DA&V_MM)),10)			&& VARIABILI DI CU_contica_DEC
			_AVERE_10DEC	=	ROUND(((M.CON_AV&V_MM)),10)			&& VARIABILI DI CU_contica_DEC
		    REPLACE CON_DA&V_MM WITH _DARE_10DEC					&& AGGIORNO contica					
		    REPLACE CON_AV&V_MM WITH _AVERE_10DEC					&& AGGIORNO contica	
		    MESE = MESE +1
		ENDDO
		T_DARE_10DEC		=	ROUND(((M.CON_IMP_D)),10)				&& VARIABILI DI CU_contica_DEC
		T_AVERE_10DEC		=	ROUND(((M.CON_IMP_A)),10)				&& VARIABILI DI CU_contica_DEC
   		REPLACE CON_IMP_D 	WITH T_DARE_10DEC							&& AGGIORNO contica	
   		REPLACE CON_IMP_A 	WITH T_AVERE_10DEC							&& AGGIORNO contica	
	ENDIF
	IF !ExecRW(cSql,"contica","W")
	   return(.f.)
	ENDIF


	SELECT CU_contica_DEC  
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


**=> ERASMO - INIZIO 07/06/2011
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


V_contica="01,02,03,99"
v_seek 	 = "DTE_CO"+PUB_CODSOC     && PARAMETRO - DATI TESTATA RIGA 3
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_contica=ALLTRIM(LIBERA)
ENDIF
V_ECODAL = STR_EXTRACT(V_contica,",",1)
V_ECOAL  = STR_EXTRACT(V_contica,",",2)
V_PATDAL = STR_EXTRACT(V_contica,",",3)
V_PATAL  = STR_EXTRACT(V_contica,",",4)
V_DAL    = SA
V_AL     = SM

_DB = "Xcontica"
=SALDICONTICA(_DB)	&& CREA I SALDI SU CONTICA

SELECT Xcontica
GO TOP


STAMPA_SOLO_I_CLIENTI_FORNITORI = .F.
NON_STAMPA_I_CLIENTI_FORNITORI  = .F.
ANNOP__ = ""
STAMPA_SOLO_I_GRUPPI_SOTTOGRUPPI = .F.
OK_SALDI = .T.  && Non stampa i  contica con saldo  a zero

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


*** FAB - 12/11/2011 ARROTONDAMENTO DEI CENTESIMI
***
*** SE HO UNO SBILANCIO MINORE DI +/- 10 CENT. FACCIO UN UPDATE DELLO SBILANCIO SU
*** 1) IL CONTO IMPOSTATO NEI PARAMETRI COME CONTO DI ARROTONDAMENTO
*** 2) SE 1) NON ESISTE SU PARA OPPURE ESISTE SU PARA MA NON SU contica, ALLORA FACCIO UN UPDATE SUL PRIMO CONTO CHE TROVO SULL'ANNO E RICALCOLO I SALDI

IF TOT_SALDO <> 0 .AND. ABS(TOT_SALDO) < 0.10

	_strdelta = ALLTRIM(STRTRAN(STR(TOT_SALDO,20,2),',','.'))
	
	*** CERCO IL CONTO INPOSTATO NEI PARAMETRI COME CONTO DI ARROTONDAMENTO
	
	Csql   = "SELECT * FROM PARA WHERE CODICE='CAA"+PUB_ANNO+"'"
	IF !ExecCommand(Csql,"UPD_contica")
	   return(.f.)
	ENDIF	
	
	SELECT UPD_contica
	
	_CONTO_ARROTONDAMENTI = ""
	
	IF !EOF()
		_CONTO_ARROTONDAMENTI = ALLTRIM(LIBERA)
	ENDIF
	
	*** IL CONTO PER GLI ARROTONDAMENTI E' IMPOSTATO SU PARA
	*** ORA LO CERCO SU contica
	
	Csql   = "SELECT * FROM contica WHERE CON_CONTO='"+_CONTO_ARROTONDAMENTI+"' AND CON_ANNO='"+PUB_ANNO+"' " 
	IF !ExecCommand(Csql,"UPD_contica")
	   return(.f.)
	ENDIF	
	
	SELECT UPD_contica
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
		Csql   = "UPDATE contica SET CON_DA01 = CON_DA01 - (&_strdelta) , CON_IMP_D = CON_IMP_D - (&_strdelta) where CON_CONTO='" +_CONTO_ARROTONDAMENTI  + "' AND " + x_anno
	ELSE
		*** FACCIO UN UPDATE SUL PRIMO CONTO CHE TROVO SULL'ANNO E RICALCOLO I SALDI
		x_soci = "con_soc = '" + PUB_CODSOC + "'"
		x_anno = "con_anno = '" + PUB_ANNO + "'"
		x_cont = "LEN(CON_CONTO) >= "+ ALLTRIM(STR(PUB_SOTTOG))
		x_pbil = "CON_POSBIL = 'P'"
		x_cimp = "CON_IMP_D <> CON_IMP_A"
		x_cond = x_soci + " and " + x_anno + " and " + x_cont + " and " + x_pbil + " and " + x_cimp 
		Csql   = "UPDATE contica SET CON_DA01 = CON_DA01 - (&_strdelta) , CON_IMP_D = CON_IMP_D - (&_strdelta) where CON_CONTO IN " + ;
				"(SELECT TOP 1 CON_CONTO FROM contica WHERE " + x_cond + " ORDER BY CON_CONTO ) AND " + x_anno
	
	ENDIF 	
	
	IF !ExecCommand(Csql,"UPD_contica")
	   return(.f.)
	ENDIF
	

	_DB = "Xcontica"
	=SALDICONTICA(_DB)	&& CREA I SALDI SU CONTICA
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
**=> ERASMO - FINE 07/06/2011





DO FORM FORM\BILRIE LINKED



SET CURSOR ON






PUB_ERRORE=MESSAGEBOX('Calcolo bilancio '+CHR(13)+'terminato correttamente',64,'*** ATTENZIONE ***') 


