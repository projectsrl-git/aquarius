*********************************************************************************
*                        STAMPA LIBRO GIORNALE FISCALE                          *
*********************************************************************************
 
NP    = 0              && NUMERO PROGRESSIVO LIBRO GIORNALE
OK_NP =.F.             && SERVE PER UN DOPPIO CONTROLLO SU ABILITAZIONE E PER CREARE IN AUTOMATICO A FINE ANNO IL PARAMETRO NUMLIB : SERGI

RELEASE INVALUTA,_TXDARE,_TXAVERE
PUBLIC  INVALUTA,_TXDARE,_TXAVERE
INVALUTA = .F.

v_seek   = 'NUMLIB'+PUB_ANNO+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   IF SUBSTR(DESCRI,1,1) = "S"
      NP = VAL(SUBSTR(LIBERA,1,7))
   ELSE
      NP = 0
   ENDIF
ELSE
   NP = 1
ENDIF


** 30/11/2023 SERGIO INIZIO: SE STAMPA FISCALE E MESE DAL = GENNAIO: IL NUMERO PROGRESSIVO DI REGISTRAZIONE PARTE SEMPRE DA 1
IF SFISC   = 'S'

	MMDAL_N = VAL(SUBSTR(M.DATADAL,4,2))
	IF MMDAL_N = 1
		NP = 1
	ENDIF
   
ENDIF
** 30/11/2023 SERGIO FINE: SE STAMPA FISCALE E MESE DAL = GENNAIO: IL NUMERO PROGRESSIVO DI REGISTRAZIONE PARTE SEMPRE DA 1


IF V_CHIU
   F_CHIUSURA = .T.
ELSE
   F_CHIUSURA = .F.
ENDIF

IF V_SOLOCHI
   F_SOLOCHI = .T.
ELSE
   F_SOLOCHI = .F.
ENDIF

**--->>>> VERIFICA SE ABILITATO ALLA RINUMERAZIONE
v_seek   = 'NUMLIB'+PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   IF SUBSTR(DESCRI,1,1) = "S"
      OK_NP = .T.
   ELSE
      NP    =  0
      OK_NP = .F.
   ENDIF
ELSE
   OK_NP = .F.
ENDIF

**************************************************************************************

DATA_DA   = RIBALTA2(DATADAL)
DATA_A    = RIBALTA2(DATAAL)
PRIMOGIRO = .T.

PUBLIC WIMPD,WIMPA,DAR,AVV,W_IMP,NEW_PAG,RIGA_SP,WNRI,_DIFF
RELEASE WI_DREG,WI_NREG
PUBLIC WI_DREG,WI_NREG
WI_DREG = SPACE(10)
WI_NREG = SPACE(06)
_DIFF   = 0
AVV     = .F.
DAR     = .F.
WIMPD   = 0
WIMPA   = 0
W_IMP   = 0
RIGA_SP = 0
NEW_PAG = OK_NUMRIG
WNRI    = 0
WCODVAL = ""
WCAMBIO = ""


*** NUMERO PROGRESSIVO UNIVOCO
RELEASE WNPRU
PUBLIC WNPRU
WNPRU = 0

**=> ERASMO - INIZIO 18/03/2021
*** NUMERO PAGINA
RELEASE WNPAG
PUBLIC WNPAG
WNPAG = 0
**=> ERASMO - FINE 18/03/2021

IF TYPE("_V_INI_NPRU") == "N" AND TYPE("_V_OPZ_NPRU") == "L"
	WNPRU = _V_INI_NPRU - 1
ELSE
	_V_INI_NPRU = 0
	_V_OPZ_NPRU = .F.
ENDIF

IF !ExecCommand("select libera from para where codice='000SPOOL'","_tmp")
  return(.f.)
ENDIF
SELECT _tmp
IF _TALLY <> 0
	NEW_PAG=OK_NUMRIG  	&& FA SALTO PAGINA
	RIGA_SP=OK_NUMRIG+10
ENDIF

CREATE CURSOR TEMPO;
  (I_DREG C(10),I_NREG C(6),I_NPROT C(6),NRI C(3),DREG C(10),NREG C(6),NPROT C(6),COD C(13),DES_CON C(40),DES_TOP  C(40),NDOC C(6),DTDOC C(10),DARE C(17),AVERE C(17),DES_MANU C(40),NUMINT C(10),TOP C(10),CAM_BIO N(15,10),CODVAL C(3), NPRU C(6))
INDEX ON RIBALTA2(I_DREG)  TAG TEMPO ADDITIVE

WAIT WINDOWS "Caricamento delle prime note in corso , attendere prego" nowait

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + PUB_ANNO + "'"
x_datda = "mov_dtreg >= '" + DATA_DA + "'"
x_data  = "mov_dtreg <= '" + DATA_A  + "'"

Csql   = "select * from indice where " + x_soci + " and " + x_anno + " and " + x_datda + " and " + x_data+ ;
                                     " order by mov_anno,mov_dtreg,cast(mov_nregis as numeric(10,0))"
IF !ExecCommand(Csql,"INDICE")
   return(.f.)
ENDIF
SELECT INDICE
GO TOP

**** FILTRO DEI MOVIMENTI DA STAMPARE
DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   WAIT windows "Elaborazione della registrazione numero : " + ALLTRIM(mov_nregis) + " del " + RIBALTA2(mov_dtreg) + " (" + ALLTRIM(STR(RECNO() / RECCOUNT() * 100,10,0)) + "%)" NOWAIT  && ERASMO 30/10/2025

   IF MOV_DTREG > DATA_A
      EXIT
   ENDIF

   WTOP   	= MOV_TOP
   v_seek	= 'TOP'+ALLTRIM(WTOP)
   v_chiave = "codice"
   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      PRINTLIBFIS	= SUBSTR(LIBERA,55,1)
   ELSE
      PRINTLIBFIS	= SPACE(1)
   ENDIF

   SELECT INDICE

   IF PRINTLIBFIS = 'N'
      SELECT INDICE
	  SKIP +1
	  LOOP
   ENDIF


   M.MOV_NUMPRO=MOV_NUMPRO

   IF V_SOLOCHI              && STAMPA SOLO I MOVIMENTI DI CHIUSURA
      IF MOV_TOP <> "CHI"
         SKIP +1
         LOOP
      ENDIF
   ENDIF

   IF EMPTY(MOV_CONTABILITA_PREVISIONALE) 		&& SCARTA I MOVIMENTI NON EFFETTIVI
   ELSE
      SKIP +1
      LOOP
   ENDIF

   IF !V_SOLOCHI
      IF MOV_TOP = "CHI"
         IF !F_CHIUSURA                			&& NON STAMPA I MOVIMENTI DI CHIUSURA
            SKIP +1
            LOOP
         ENDIF
      ENDIF
   ENDIF

   _DARE = 0
   _AVERE= 0

   *WAIT windows "Elaborazione della registrazione numero : " + mov_nregis nowait
    
   DO VQUADRA  WITH M.MOV_NUMPRO
   DO CREATEMP WITH M.MOV_NUMPRO
   DO TOTALE

   SELECT INDICE
   SKIP +1

ENDDO 

SELECT TEMPO
GO TOP


IF EOF()
   RIT=MSGBOX('Periodo selezionato; privo di registrazioni','ATTENZIONE',31)
   DEACTIVATE WINDOWS TEMP
   RELEASE WINDOWS TEMP
   PUSH KEY CLEAR
   RETURN
ENDIF


IF V_TOTAN
	DO TOT_FINALE
ENDIF

DO STP_SPOOL

DO AGGIOLIB       && AGGIORNA IL NUMERO PROGRESSIVO

IF SFISC = "S"
   DO CHIUDIM
ENDIF

RETURN

************************
PROCEDURE TOT_FINALE         && CALCOLA IL TOTALE ANNUO FINALE
************************

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + PUB_ANNO + "'"
Csql   = "select * from indice where " + x_soci + " and " + x_anno + ;
                                     " order by mov_soc,mov_anno,mov_dtreg,mov_numpro"
IF !ExecCommand(Csql,"INDICE")
   return(.f.)
ENDIF
SELECT INDICE
GO TOP
_TXDARE = 0
_TXAVERE= 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   WAIT windows "Elaborazione totali riepilogativi... (" + ALLTRIM(STR(RECNO() / RECCOUNT() * 100,10,0)) + "%)" NOWAIT  && ERASMO 30/10/2025

   IF MOV_ANNO <> PUB_ANNO
      EXIT
   ENDIF

   M.MOV_NUMPRO=MOV_NUMPRO

   IF V_SOLOCHI              && STAMPA SOLO I MOVIMENTI DI CHIUSURA
      IF MOV_TOP <> "CHI"
         SKIP +1
         LOOP
      ENDIF
   ENDIF

   IF EMPTY(MOV_CONTABILITA_PREVISIONALE) 		&& SCARTA I MOVIMENTI NON EFFETTIVI
   ELSE
      SKIP +1
      LOOP
   ENDIF

   IF !V_SOLOCHI
      IF MOV_TOP = "CHI"
         IF !F_CHIUSURA                			&& NON STAMPA I MOVIMENTI DI CHIUSURA
            SKIP +1
            LOOP
         ENDIF
      ENDIF
   ENDIF


   DO VQUADRA_TOT_FINALE  WITH M.MOV_NUMPRO

   SELECT INDICE
   SKIP +1

ENDDO 

**DO TOTALE_FINALE
RETURN


************************
PROCEDURE VQUADRA         && EFFETTUA UN CONTROLLO DI QUADRATURA SULLE REGISTRAZIONI IN VALUTA
************************
PARA _NUMPRO

IF !ExecCommand("select * from mov_cont where 0=1","mov_cont")
  return(.f.)
ENDIF
SELECT MOV_CONT
AA=AFIELDS(ASD)
CREATE CURSOR WW_TEMPO FROM ARRAY ASD

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + PUB_ANNO + "'"
x_nint = "mov_numpro = '" + ALLTRIM(_NUMPRO) + "'"
cSql="SELECT * FROM mov_cont WHERE " + x_soci + " and " + x_anno + " and " + x_nint + ;
                                  " order by mov_soc,mov_anno,mov_numpro,mov_sequen"
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
      VSGRUPPO=SUBSTR(MOV_CONTO,1,4)
      KTOP=MOV_TOP
      IF SI_TUTREG <> 'SI'    && VERIFICA SE STAMPA TUTTO
         IF SI_PRINOT == 'NO'  .AND. TIPOCO(VSGRUPPO)=3
            SKIP +1
            LOOP
         ENDIF
         IF SI_FATVEN == 'NO' .AND. TIPOCO(VSGRUPPO) = 1
            SKIP +1
            LOOP
         ENDIF
         IF SI_FATACQ == 'NO' .AND. TIPOCO(VSGRUPPO) = 2
            SKIP +1
            LOOP
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
      *_VALORE   = CAMBIO(_CODVAL,_IMP,_CAMBIO,(_SOC+_ANNO+_CONTO),INVALUTA)
      _VALORE   = CAMBIO(_CODVAL,_IMP,_CAMBIO,(_SOC+_ANNO+_CONTO),INVALUTA,3)  && ERASMO - 30/10/2025
      IF SUBSTR(_TMOV,1,1)='A'
         _AVERE=_AVERE + _VALORE
      ENDIF
      IF SUBSTR(_TMOV,1,1)='D'
         _DARE=_DARE + _VALORE
      ENDIF
      SELECT MOV_CONT
      SCATTER MEMVAR MEMO
      SELECT WW_TEMPO
      APPEND BLANK
      GATHER MEMVAR MEMO
      SELECT MOV_CONT
      SKIP +1
   ENDDO
   _DIFF = _DARE  -  _AVERE
ELSE
   WAIT WINDOW "Non trovato il numero interno di legame INDICE - MOV_CONT "+_NUMPRO
ENDIF

RETURN

*****************************
PROCEDURE VQUADRA_TOT_FINALE         && EFFETTUA UN CONTROLLO DI QUADRATURA SULLE REGISTRAZIONI IN VALUTA
*****************************
PARA _NUMPRO

IF !ExecCommand("select * from mov_cont where 0=1","mov_cont")
  return(.f.)
ENDIF
SELECT MOV_CONT
AA=AFIELDS(ASD)
CREATE CURSOR WW_TEMPO FROM ARRAY ASD

x_soci = "mov_soc = '" + PUB_CODSOC + "'"
x_anno = "mov_anno = '" + PUB_ANNO + "'"
x_nint = "mov_numpro = '" + ALLTRIM(_NUMPRO) + "'"
cSql="SELECT * FROM mov_cont WHERE " + x_soci + " and " + x_anno + " and " + x_nint + ;
                                  " order by mov_soc,mov_anno,mov_numpro,mov_sequen"
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
      VSGRUPPO=SUBSTR(MOV_CONTO,1,4)
      KTOP=MOV_TOP
      IF SI_TUTREG <> 'SI'    && VERIFICA SE STAMPA TUTTO
         IF SI_PRINOT == 'NO'  .AND. TIPOCO(VSGRUPPO)=3
            SKIP +1
            LOOP
         ENDIF
         IF SI_FATVEN == 'NO' .AND. TIPOCO(VSGRUPPO) = 1
            SKIP +1
            LOOP
         ENDIF
         IF SI_FATACQ == 'NO' .AND. TIPOCO(VSGRUPPO) = 2
            SKIP +1
            LOOP
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
      *_VALORE   = CAMBIO(_CODVAL,_IMP,_CAMBIO,(_SOC+_ANNO+_CONTO),INVALUTA)
      _VALORE   = CAMBIO(_CODVAL,_IMP,_CAMBIO,(_SOC+_ANNO+_CONTO),INVALUTA,3)  && ERASMO - 30/10/2025

      IF SUBSTR(_TMOV,1,1)='A'
         _TXAVERE=_TXAVERE + _VALORE
      ENDIF
      IF SUBSTR(_TMOV,1,1)='D'
         _TXDARE=_TXDARE + _VALORE
      ENDIF


      SELECT MOV_CONT
      SKIP +1

   ENDDO
   _DIFF = _DARE  -  _AVERE
ELSE
   WAIT WINDOW "Non trovato il numero interno di legame INDICE - MOV_CONT "+_NUMPRO
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

   IF ALLTRIM(MOV_NUMPRO) < ALLTRIM(_NUMPRO)
      SKIP +1
      LOOP
   ENDIF

   IF ALLTRIM(MOV_NUMPRO) > ALLTRIM(_NUMPRO)
      EXIT
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

   VSGRUPPO=SUBSTR(MOV_CONTO,1,4)
   KTOP=MOV_TOP

   IF SI_TUTREG <> 'SI'    && VERIFICA SE STAMPA TUTTO
      IF SI_PRINOT == 'NO'  .AND. TIPOCO(VSGRUPPO)=3
         SKIP
         LOOP
      ENDIF
      IF SI_FATVEN == 'NO' .AND. TIPOCO(VSGRUPPO) = 1
         SKIP
         LOOP
      ENDIF
      IF SI_FATACQ == 'NO' .AND. TIPOCO(VSGRUPPO) = 2
         SKIP
         LOOP
      ENDIF
   ENDIF
   
   DO STAMPA

   SELECT WW_TEMPO
   SKIP +1

ENDDO

RETURN


***********************
PROCEDURE STAMPA
***********************

SELECT WW_TEMPO

WI_DREG   = RIBALTA2(MOV_DTREG)
WI_NREG   = ALLTRIM(MOV_NREGIS)
WDREG     = RIBALTA2(MOV_DTREG)
WDTDOC    = RIBALTA2(MOV_DTDOC)
WNPROT    = MOV_NPROT
WNREG     = MOV_NREGIS
WCOD      = MOV_CONTO
WTOP      = MOV_TOP
IF _VERYFA(WTOP)
   WNDOC  = MOV_NPROT		&& TRATTASI DI FATTURA/NOTA CREDITO CLIENTE
ELSE
   WNDOC  = MOV_NDOC
ENDIF
WDES_MANU = MOV_DESMOV
WNUMINT   = ALLTRIM(MOV_NUMPRO)
WIMP      = MOV_IMP
WCAMBIO   = MOV_CAMBIO
WCODVAL   = MOV_VALUTA
*XVALORE   = CAMBIO(WCODVAL,MOV_IMP,WCAMBIO,(MOV_SOC+MOV_ANNO+MOV_CONTO),INVALUTA)
XVALORE   = CAMBIO(WCODVAL,MOV_IMP,WCAMBIO,(MOV_SOC+MOV_ANNO+MOV_CONTO),INVALUTA,3)  && ERASMO - 30/10/2025

v_seek   = 'TOP'+ALLTRIM(WTOP)
v_chiave = "codice"
IF seek_std('PARA',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   WDES_TOP=DESCRI
ELSE
   WDES_TOP="TOP INESISTENTE SU PARAMETRI"
ENDIF

SELECT WW_TEMPO

IF SUBSTR(MOV_TMOV,1,1)='A'
   WAVERE=STR(XVALORE,17,3)
   WDARE=SPACE(17)
   AVV=.T.
   W_IMP = XVALORE
ENDIF

IF SUBSTR(MOV_TMOV,1,1)='D'
   WDARE=STR(XVALORE,17,3)
   WAVERE=SPACE(17)
   DAR=.T.
   W_IMP = XVALORE
ENDIF

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(WCOD) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecCommand(cSql,"CUR_CONTI")
   return(.f.)
ENDIF
SELECT CUR_CONTI
GO TOP
IF !EOF()
   WDES_CON=CON_DESCR
ELSE
   WDES_CON=SPACE(25)
ENDIF

SELECT TEMPO
APPEND BLANK
DO AGG_TEMPO

RETURN


*********************
PROCEDURE TOTALE
*********************
IF STAMPER = 1  && GRAFICA
*!*	   IF WIMPD = 0 .AND. WIMPA = 0
*!*	   ELSE
      SELECT TEMPO
      APPEND BLANK
      IF STAMPER = 2
         REPLACE COD       WITH "Valuta:."+WCODVAL
         REPLACE DES_CON   WITH "Cambio:."+STR(WCAMBIO,13,6)
         REPLACE DES_MANU  WITH 'TOTALI ==============>>>'  && VIDEO
      ELSE
         REPLACE COD       WITH "Valuta:."+WCODVAL
         REPLACE DES_CON   WITH "Cambio:."+STR(WCAMBIO,13,6)
         REPLACE DES_MANU  WITH 'TOTALI ==============>>>'   && STAMPA
      ENDIF
      TOTALED   = STR(WIMPD,17,3)
      TOTALEA   = STR(WIMPA,17,3)
      REPLACE DARE  WITH ALLTRIM(TOTALED)
      REPLACE AVERE WITH ALLTRIM(TOTALEA)
      REPLACE I_DREG   WITH  WI_DREG      &&  KEY DI SELEZIONE
      REPLACE I_NREG   WITH  WI_NREG
      APPEND BLANK
      DO ROTT_TEMPO
*!*	   ENDIF
ELSE
   SELECT TEMPO
   APPEND BLANK
   IF STAMPER = 2
      REPLACE DES_MANU  WITH 'TOTALI ==============>>>'  && STAMPA
   ELSE
      REPLACE DES_CON  WITH 'TOTALI ==============>>>'   && VIDEO
   ENDIF
   TOTALED   = STR(WIMPD,17,3)
   TOTALEA   = STR(WIMPA,17,3)
   REPLACE DARE  WITH ALLTRIM(TOTALED)
   REPLACE AVERE WITH ALLTRIM(TOTALEA)
   REPLACE I_DREG   WITH  WI_DREG      &&  KEY DI SELEZIONE
   REPLACE I_NREG   WITH  WI_NREG
   APPEND BLANK
   DO ROTT_TEMPO
ENDIF

WIMPD=0
WIMPA=0

RETURN


*************************
PROCEDURE TOTALE_FINALE
*************************
IF STAMPER = 1  && GRAFICA


   IF _DARE = 0 .AND. _AVERE = 0
   ELSE
      SELECT TEMPO
      APPEND BLANK
      IF STAMPER = 2
         REPLACE COD       WITH "Valuta:."+WCODVAL
         REPLACE DES_CON   WITH "Cambio:."+STR(WCAMBIO,13,6)
         REPLACE DES_MANU  WITH 'TOTALI ESERCIZIO=====>>>'  && VIDEO
      ELSE
         REPLACE COD       WITH "Valuta:."+WCODVAL
         REPLACE DES_CON   WITH "Cambio:."+STR(WCAMBIO,13,6)
         REPLACE DES_MANU  WITH 'TOTALI ESERCIZIO=====>>>'   && STAMPA
      ENDIF

      TOTALED   = STR(_DARE,17,3)
      TOTALEA   = STR(_AVERE,17,3)
      
      REPLACE DARE  WITH ALLTRIM(TOTALED)
      REPLACE AVERE WITH ALLTRIM(TOTALEA)
      REPLACE I_DREG   WITH  WI_DREG      &&  KEY DI SELEZIONE
      REPLACE I_NREG   WITH  WI_NREG
      APPEND BLANK
      DO ROTT_TEMPO
   ENDIF

ELSE

   SELECT TEMPO
   APPEND BLANK
   IF STAMPER = 2
      REPLACE DES_MANU  WITH 'TOTALI ESERCIZIO=====>>>'  && STAMPA
   ELSE
      REPLACE DES_CON  WITH 'TOTALI ESERCIZIO=====>>>'   && VIDEO
   ENDIF

   TOTALED   = STR(_DARE,17,3)
   TOTALEA   = STR(_AVERE,17,3)
   
   REPLACE DARE  WITH ALLTRIM(TOTALED)
   REPLACE AVERE WITH ALLTRIM(TOTALEA)
   REPLACE I_DREG   WITH  WI_DREG      &&  KEY DI SELEZIONE
   REPLACE I_NREG   WITH  WI_NREG
   APPEND BLANK
   DO ROTT_TEMPO

ENDIF

_DARE = 0
_AVERE= 0

RETURN



****************************
PROCEDURE AGG_TEMPO
****************************

WNRI = WNRI +1

REPLACE I_DREG   WITH  WI_DREG      &&  KEY DI SELEZIONE
REPLACE I_NPROT  WITH  WNPROT		&&  KEY DI SELEZIONE
REPLACE I_NREG   WITH  WI_NREG

REPLACE NRI      WITH  STR(WNRI,3,0)
REPLACE DREG     WITH  WDREG
REPLACE DTDOC    WITH  WDTDOC
REPLACE NPROT    WITH  WNPROT
REPLACE NREG     WITH  WNREG


** 21/11/2023 SERGIO INIZIO:&& FUNZIONE PER RINUMERARE IL NUMERO DI REGISTRAZIONE DELLE PRIME NOTE SOLO NELLA STAMPA SENZA AGGIORNARE IL DATABASE
IF PUB_RICALCSTP   						&& FUNZIONE PER RINUMERARE IL NUMERO DI REGISTRAZIONE DELLE PRIME NOTE SOLO NELLA STAMPA SENZA AGGIORNARE IL DATABASE
	IF SFISC     = 'S'             		&& RINUMERA SOLO SE STAMPA FISCALE PER TUTTE
	   IF ALLTRIM(SI_TUTREG) = "SI"     && LE REGISTRAZIONI E SE E' IMPOSTATA L'OPZIONE SU PARAMETRO
	      IF NP > 0
	         REPLACE NREG     WITH  ALLTRIM(STR(NP,7,0))
	         REPLACE I_NREG   WITH  ALLTRIM(STR(NP,7,0))
	      ENDIF 
	   ENDIF
	ENDIF
ENDIF
** 21/11/2023 SERGIO FINE: && FUNZIONE PER RINUMERARE IL NUMERO DI REGISTRAZIONE DELLE PRIME NOTE SOLO NELLA STAMPA SENZA AGGIORNARE IL DATABASE

REPLACE COD      WITH  WCOD
REPLACE DES_CON  WITH  WDES_CON
REPLACE DES_TOP  WITH  WDES_TOP
REPLACE TOP      WITH  WTOP
REPLACE NDOC     WITH  WNDOC
REPLACE DES_MANU WITH  WDES_MANU
REPLACE NUMINT   WITH  WNUMINT
REPLACE AVERE    WITH  ALLTRIM(WAVERE)
REPLACE DARE     WITH  ALLTRIM(WDARE)
REPLACE CAM_BIO  WITH  WCAMBIO
REPLACE CODVAL   WITH  WCODVAL

IF AVV
   AVV=.F.
   WIMPA = WIMPA+W_IMP
ENDIF

IF DAR
   DAR=.F.
   WIMPD = WIMPD+W_IMP
ENDIF

**=> ERASMO - INIZIO 14/04/2016
WNPRU = WNPRU + 1
REPLACE NPRU WITH STR(WNPRU,6,0)
**=> ERASMO - FINE 14/04/2016

RETURN


****************************
 PROCEDURE ROTT_TEMPO
****************************

WNRI = 0

REPLACE I_DREG   WITH  WI_DREG      &&  KEY DI SELEZIONE
REPLACE I_NREG   WITH  WI_NREG
REPLACE NRI      WITH  REPLICATE('=',3)
REPLACE DREG     WITH  REPLICATE('=',10)
REPLACE DTDOC    WITH  REPLICATE('=',10)
REPLACE NPROT    WITH  REPLICATE('=',6)
REPLACE NREG     WITH  REPLICATE('=',6)

** 07/11/2023 SERGIO INIZIO: && FUNZIONE PER RINUMERARE IL NUMERO DI REGISTRAZIONE DELLE PRIME NOTE SOLO NELLA STAMPA SENZA AGGIORNARE IL DATABASE
IF PUB_RICALCSTP   						&& && FUNZIONE PER RINUMERARE IL NUMERO DI REGISTRAZIONE DELLE PRIME NOTE SOLO NELLA STAMPA SENZA AGGIORNARE IL DATABASE
	IF SFISC     = 'S'                 	&& RINUMERA SOLO SE STAMPA FISCALE PER TUTTE
	   IF ALLTRIM(SI_TUTREG) = "SI"    	&& LE REGISTRAZIONI E SE E' IMPOSTATA L'OPZIONE SU PARAMETRO
	      IF NP > 0
	         NP=NP + 1                 	&& INCREMENTA A ROTTURA DI NUMERO INTERNO
	      ENDIF 
	   ENDIF
	ENDIF
ENDIF
** 07/11/2023 SERGIO FINE: && FUNZIONE PER RINUMERARE IL NUMERO DI REGISTRAZIONE DELLE PRIME NOTE SOLO NELLA STAMPA SENZA AGGIORNARE IL DATABASE


REPLACE COD      WITH  REPLICATE('=',12)
REPLACE DES_CON  WITH  REPLICATE('=',24)
REPLACE TOP      WITH  REPLICATE('=',3)
REPLACE DES_TOP  WITH  REPLICATE('=',40)
REPLACE NDOC     WITH  REPLICATE('=',6)
REPLACE DES_MANU WITH  REPLICATE('=',23)
REPLACE NUMINT   WITH  REPLICATE('=',6)
REPLACE AVERE    WITH  REPLICATE('=',17)
REPLACE DARE     WITH  REPLICATE('=',17)

**=> ERASMO - INIZIO 14/04/2016
REPLACE NPRU WITH REPLICATE('=',6)
**=> ERASMO - FINE 14/04/2016

RETURN


****************************
PROCEDURE STP_SPOOL
****************************

CREATE CURSOR XSTAMPA(RIGA C (150))

TDARE  = 0
TAVERE = 0

TPAGENO = 0  && ERASMO - 18/03/2021

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
      SKIP +1
      LOOP
   ENDIF

   SCATTER MEMVAR

   IF SUBSTR(M.DES_MANU,1,6) = "TOTALI"
      SKIP +1
      LOOP
   ENDIF

   IF RIGA_SP > NEW_PAG
      DO LIBTES WITH .T.          && STAMPA TESTATA CON SALTO PAGINA
   ENDIF

   IF NUM_INOL <> NUMINT
   
      SELECT XSTAMPA
      APPEND BLANK
      REPLACE RIGA WITH   "------ Rifer. P.NOTA Numero:.."+M.NREG+"...Data Registrazione:."+M.DREG+" "+SPACE(6)+"..Valuta:."+M.CODVAL+"...Cambio:."+STR(M.CAM_BIO,13,6)+"----------------------"  && ERASMO - 14/04/2016
      
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
      ENDIF
   ELSE
      TDARE  = TDARE  + VAL(M.DARE)
      TAVERE = TAVERE + VAL(M.AVERE)
   ENDIF

   SEPARA = SPACE(12)
	   
	   
	IF _V_OPZ_NPRU  && SE STAMPA BOLLATO CON NUMERO PROGRESSIVO UNIVOCO, INVECE DEL NUMERO RIGA PRIMA NOTA
		*IF VAL(M.DARE) <> 0
		IF !EMPTY(ALLTRIM(M.DARE))  && ERASMO/SERGIO - 02/05/2022 - PER GESTIRE ANCHE IMPORTI IN DARE E/O IN AVERE UGUALI A ZERO
			REPLACE RIGA WITH   "|"+M.NPRU+"|"+SUBSTR(M.COD,1,13)+"-"+ M.DES_CON+" | "+ M.TOP+"  "+  M.NDOC+""+M.DTDOC+" "+M.NPROT+" | "+ TRANSFORM(VAL(M.DARE),'99,999,999,999.999') + "   " + SEPARA +" | " + SUBSTR(M.DES_MANU,1,24)
		ELSE
			REPLACE RIGA WITH   "|"+M.NPRU+"|"+SUBSTR(M.COD,1,13)+"-"+ M.DES_CON+" | "+ M.TOP+"  "+  M.NDOC+""+M.DTDOC+" "+M.NPROT+" | "+ SEPARA  + "   " + TRANSFORM(VAL(M.AVERE),'99,999,999,999.999') +" | " + SUBSTR(M.DES_MANU,1,24)
		ENDIF
	ELSE
		*IF VAL(M.DARE) <> 0
		IF !EMPTY(ALLTRIM(M.DARE))  && ERASMO/SERGIO - 02/05/2022 - PER GESTIRE ANCHE IMPORTI IN DARE E/O IN AVERE UGUALI A ZERO
			REPLACE RIGA WITH   "|  "+M.NRI+" |"+SUBSTR(M.COD,1,13)+"-"+ M.DES_CON+" | "+ M.TOP+"  "+  M.NDOC+""+M.DTDOC+" "+M.NPROT+" | "+ TRANSFORM(VAL(M.DARE),'99,999,999,999.999') + "   " + SEPARA +" | " + SUBSTR(M.DES_MANU,1,24)
		ELSE
			REPLACE RIGA WITH   "|  "+M.NRI+" |"+SUBSTR(M.COD,1,13)+"-"+ M.DES_CON+" | "+ M.TOP+"  "+  M.NDOC+""+M.DTDOC+" "+M.NPROT+" | "+ SEPARA  + "   " + TRANSFORM(VAL(M.AVERE),'99,999,999,999.999') +" | " + SUBSTR(M.DES_MANU,1,24)
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
*REPLACE RIGA WITH  SPACE(20)+"Totali Generali :"+ TRAN(ROUND(TDARE,2),"9,999,999,999,999.999") + "  "  + TRAN(ROUND(TAVERE,2),"9,999,999,999,999.999") + TRAN((ROUND(TDARE,2) - ROUND(TAVERE,2)),"99,999,999,999.999")  && ERASMO/FABIANO - 31/03/2016
REPLACE RIGA WITH  SPACE(20)+"Totali Generali :"+ TRAN(TDARE,"9,999,999,999,999.99") + "  "  + TRAN(TAVERE,"9,999,999,999,999.99") + TRAN(VAL(STR(TDARE,19,2)) - VAL(STR(TAVERE,19,2)),"99,999,999,999.99")  && ERASMO - 30/10/2025



IF V_TOTAN
	SELECT XSTAMPA
	APPEND BLANK
	REPLACE RIGA WITH "    "
	APPEND BLANK
	REPLACE RIGA WITH "    "
	APPEND BLANK
	*REPLACE RIGA WITH  SPACE(10)+"Totali esercizio corrente :"+ TRAN(ROUND(_TXDARE,2),"9,999,999,999,999.999") + "  "  + TRAN(ROUND(_TXAVERE,2),"9,999,999,999,999.999") + TRAN((ROUND(TDARE,2) - ROUND(TAVERE,2)),"99,999,999,999.999")  && ERASMO/FABIANO - 31/03/2016
	REPLACE RIGA WITH  SPACE(10)+"Totali esercizio corrente :"+ TRAN(_TXDARE,"9,999,999,999,999.99") + "  "  + TRAN(_TXAVERE,"9,999,999,999,999.99") + TRAN(VAL(STR(_TXDARE,19,2)) - VAL(STR(_TXAVERE,19,2)),"99,999,999,999.99")  && ERASMO - 30/10/2025
*!*		SELECT XSTAMPA
*!*		APPEND BLANK
*!*		REPLACE RIGA WITH ""
*!*		GO TOP
*!*	ELSE
*!*		SELECT XSTAMPA
*!*		APPEND BLANK
*!*		REPLACE RIGA WITH ""
*!*		GO TOP
ENDIF



IF OK_FORMATO = 1
ELSE
   =MESSAGEBOX("Fine elaborazione. Procedi con la stampa tramite lo spooler",62,"ATTENZIONE")
   RETURN
ENDIF

DO CREA_SPOOL WITH "XSTAMPA","L.GIORNALE "+DATADAL+" "+DATAAL


X_COMPRESSO = 1

DO STAMPA_A4 WITH _NUMF,X_COMPRESSO,1



RETURN


****************************
PROCEDURE LIBTES
****************************
PARA SALTA_P

IF SALTA_P
   M.RIGA0=""				 && SALTO PAGINA SPOOLER
ELSE
   M.RIGA0=""
ENDIF

M.RIGA1=SPACE(050)+"LIBRO GIORNALE FISCALE"+"   PERIODO DAL "+DATADAL+" AL "+DATAAL
M.RIGA2=SPACE(130)
*!*	M.RIGA3="---------------------------------------------------------------------------------------------------------------------------------------------------"
*!*	M.RIGA4="|NUM.|         P  A  R  T  I  T  E                             |      D O C U M E N T O       |           I M P O R T I           | ULTERIORE     |"
*!*	M.RIGA5="|RIGA|     DESCRIZIONE CONTI CONTABILI                         | CAUS  NUM    DATA   PROT.IVA |       D A R E       A V E R E     | DESCRIZIONE   |"
*!*	M.RIGA6="---------------------------------------------------------------------------------------------------------------------------------------------------"
**=> ERASMO - INIZIO 14/04/2016
M.RIGA3="---------------------------------------------------------------------------------------------------------------------------------------------------"
M.RIGA4="| NUM. |         P  A  R  T  I  T  E                           |      D O C U M E N T O       |           I M P O R T I           | ULTERIORE     |"
M.RIGA5="| RIGA |     DESCRIZIONE CONTI CONTABILI                       | CAUS  NUM    DATA   PROT.IVA |       D A R E       A V E R E     | DESCRIZIONE   |"
M.RIGA6="---------------------------------------------------------------------------------------------------------------------------------------------------"
**=> ERASMO - FINE 14/04/2016
M.RIGA7=SPACE(130)

_WW_RAGSOC = ""
_WW_INDIRI = ""
_WW_LOCALI = ""
_WW_PARIVA = ""  && ERASMO - 18/03/2021
x_soci = "azi_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
Csql   = "select * from u_azi_an where " + x_cond + " order by azi_codsoc"
IF !ExecCommand(cSql,"CX_AZI_AN")
   return(.f.)
ENDIF
SELECT CX_AZI_AN
GO TOP
IF EOF()
ELSE
   _WW_RAGSOC = ALLTRIM(AZI_RAGSOC) + " - "
   _WW_INDIRI = ALLTRIM(AZI_INDIRI) + " - "
   _WW_LOCALI = ALLTRIM(AZI_CAP) + " " + ALLTRIM(AZI_LOCALI)
   *_WW_LOCALI = ALLTRIM(AZI_CAP) + " " + ALLTRIM(AZI_LOCALI) + " - "  && ERASMO - 18/03/2021
   _WW_PARIVA = ALLTRIM(AZI_PIVA)  && ERASMO - 18/03/2021
ENDIF
_WW_INTESTA = _WW_RAGSOC + _WW_INDIRI + _WW_LOCALI
*_WW_INTESTA = _WW_RAGSOC + _WW_INDIRI + _WW_LOCALI + _WW_PARIVA  && ERASMO - 18/03/2021
_WW_INTESTA = ALLTRIM(_WW_INTESTA) + IIF(!EMPTY(_WW_PARIVA)," - P.IVA " + _WW_PARIVA,"")  && ERASMO - 22/09/2023

SELECT XSTAMPA
APPEND BLANK
REPLACE RIGA WITH M.RIGA0

**=> ERASMO - INIZIO 18/03/2021
TPAGENO = TPAGENO + 1
IF _V_OPZ_NPAG
	WNPAG = TPAGENO + (_V_INI_NPAG - 1)
	*_cPageNo = "PAG. " + ALLTRIM(STR(WNPAG))
	_cPageNo = "PAG. " + ALLTRIM(STR(WNPAG)) + "/" + ALLTRIM(PUB_ANNO)  && ERASMO - 23/11/2021
	REPLACE RIGA WITH ALLTRIM(RIGA) + SPACE(LEN(M.RIGA3)-LEN(_cPageNo)) + _cPageNo
ENDIF
**=> ERASMO - FINE 18/03/2021

SELECT XSTAMPA
APPEND BLANK
*REPLACE RIGA WITH IIF(_Y_INTAZI,_WW_INTESTA," ")
REPLACE RIGA WITH IIF(_Y_INTAZI,_WW_INTESTA," ") + IIF(SFISC = 'S',"","   ########## STAMPA NON DEFINITIVA ##########")   && ERASMO/SERGIO - 08/11/2023

APPEND BLANK
REPLACE RIGA WITH " "
APPEND BLANK
REPLACE RIGA WITH " "

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

RIGA_SP = 10


****************************
PROCEDURE STP_GRA
****************************

IF SFISC = "S"
   DO CHIUDIM
ENDIF

SELECT TEMPO
GO TOP
IF EOF()
   =MESSAGEBOX("Nessun dato da stampare",62,"ATTENZIONE")
ELSE
   _V_PREVIEW = .T.
   _V_STAMPA  = .T.
   DO PRG\MENUSTA WITH "TEMPO ",_V_PREVIEW,_V_STAMPA,"XXX","LIB000","LIB000.FRX"
ENDIF

RETURN


****************************************************************
FUNCTION TIPOCO
****************************************************************
PARA V1

SS= SELECT()

***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE/FORNITORE
v_seek	 = 'TOP'+KTOP
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
   V_FLFATTU = SUBSTR(LIBERA,02,1)
   V_CF      = SUBSTR(LIBERA,12,1)
ELSE
  SELECT (SS)
  RETURN(3)
ENDIF

SELECT(SS)

IF V_CF="C" .AND. V_FLFATTU="S"       && CLIENTE
   RETURN(1)
ENDIF

IF V_CF="F" .AND. V_FLFATTU="S"       && FORNITORE
   RETURN(2)
ENDIF

RETURN(3)                             && ALTRO


****************************
PROCEDURE CHIUDIM
****************************

SS= SELECT()

** 30/11/2023 SERGIO INIZIO: CHIUDE TUTTI I MESI CONTABILI STAMOATI FISCALMENTE

MMDAL_N = VAL(SUBSTR(M.DATADAL,4,2))
MMAL_N = VAL(SUBSTR(M.DATAAL,4,2))

MELAB = MMDAL_N 

FOR FF=MMDAL_N TO MMAL_N

	MM_ELAB =  STR(MELAB,2,0)
	
	IF LEN(ALLTRIM(MM_ELAB)) = 1
		MMCLO = '0'+ ALLTRIM(MM_ELAB)
	ELSE 
		MMCLO = ALLTRIM(MM_ELAB)
	ENDIF
	
	v_seek  = 'MES'+PUB_ANNO+MMCLO
	v_chiave= "codice"
	cSql    ="select * from para where " + v_chiave + " = '" + v_seek + "'"
	IF !ExecRW(cSql,"PARA","R")
	   return(.f.)
	ENDIF
	SELECT PARA
	IF RECCOUNT() <> 0
	   REPLACE LIBERA WITH "S"
	   REPLACE DESCRI WITH "MESE CONTABILE CHIUSO"
	ELSE
	   APPEND BLANK
	   REPLACE CODICE WITH "MES"+PUB_ANNO + MMCLO
	   REPLACE LIBERA WITH "S"
	   REPLACE DESCRI WITH "MESE CONTABILE CHIUSO"
	ENDIF
	IF !ExecRW(cSql,"PARA","W")
	   return(.f.)
	ENDIF

	MELAB = MELAB + 1
	
NEXT
** 30/11/2023 SERGIO FINE: CHIUDE TUTTI I MESI CONTABILI STAMOATI FISCALMENTE






RIT=MSGBOX("Mese/i contabile/i "+PUB_ANNO+MMCLO+" chiuso/i",'ATTENZIONE',31)

SELECT(SS)
RETURN


****************************
PROCEDURE AGGIOLIB
****************************

** AGGIORNA IL NUMERO PROGRESSIVO SOLO SE STAMPA FISCALE + OPZIONE DI RINUM.SUPARAM.

IF SFISC   <> 'S'
   RETURN
ENDIF

IF ALLTRIM(SI_TUTREG) <> "SI"
   RETURN
ENDIF

IF NP = 0
   RETURN
ENDIF

MMCLO = SUBSTR(M.DATADAL,4,2)

v_seek  = 'MES'+PUB_ANNO+MMCLO
v_chiave= "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() <> 0
   IF SUBSTR(LIBERA,1,1) = "S"     && SOLO SE MESE APERTO
      RETURN
   ENDIF
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

IF OK_NP                            && SOLO SE ABILITATO ALLA RINUMERAZIONE
   v_seek  = 'NUMLIB'+PUB_ANNO+PUB_CODSOC
   v_chiave= "codice"
   cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
   IF !ExecRW(cSql,"PARA","R")
      return(.f.)
   ENDIF
   SELECT PARA
   IF RECCOUNT() <> 0
      IF SUBSTR(DESCRI,1,1) = "S"
         REPLACE LIBERA WITH SUBSTR(STR(NP,7,0),1,7)
      ENDIF
   ELSE
      APPEND BLANK
      REPLACE CODICE WITH 'NUMLIB'+PUB_ANNO+PUB_CODSOC
      REPLACE DESCRI WITH "S=RINUMERA LIBRO GIORNALE"
      REPLACE LIBERA WITH SUBSTR(STR(NP,7,0),1,7)
   ENDIF
   IF !ExecRW(cSql,"PARA","W")
      return(.f.)
   ENDIF
ENDIF


****************************************************************
FUNCTION CTR_IVA
****************************************************************
PARA V1

CTR = SELECT()
OUT = .F.

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
IF !EOF()
   IF CON_TIPOCO = "I"
      OUT=.T.
   ENDIF
ENDIF
SELECT(CTR)

RETURN(OUT)

