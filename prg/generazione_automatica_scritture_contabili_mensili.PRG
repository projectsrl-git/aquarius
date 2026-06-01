*****************************************************
* GENERAZIONE AUTOMATICA SCRITTURE CONTABILI MENSILI
*****************************************************

*!*	LPARAMETERS _PAR_DATA_DAL,_PAR_DATA_AL

*!*	IF PCOUNT()<1
*!*		RETURN .F.
*!*	ENDIF


LOCAL _SAVE_SEL,_PDF_SUBDIR_,_FILE_DA_ALLEGARE,_PDF_DESCRIZIONE_,_PDF_SELECT_ ,_PDF_REPORT_ ,_PROGRESSIVO_PROGRAMMA,_ALLEGATI,DATA_REGI

RELEASE _PRIMA_NOTA_GIA_TRATTATA,PUB_NUOVO_NREG_ASSEGNATO
PUBLIC _PRIMA_NOTA_GIA_TRATTATA,PUB_NUOVO_NREG_ASSEGNATO
_PRIMA_NOTA_GIA_TRATTATA = .F.
PUB_NUOVO_NREG_ASSEGNATO = ""

DATA_REGI = RIBALTA2(DTOC(DATE()))		&& DATA REGISTRAZIONE 
__PUB_ANNO__ = SUBSTR(DATA_REGI ,1,4)	&& ANNO CONTABILE SU CUI VIENE CREATA LA REGISTRAZIONE



** DETERMINA IL MESE PRECEDENTE DALLA DATA CORRENTE
_nAnno = VAL(SUBSTR(DTOC(DATE()),7,4))
_nMese = VAL(SUBSTR(DTOC(DATE()),4,2))
_nMese = _nMese - 1
IF _nMese = 0
	_nMese = 12
	_nAnno = _nAnno - 1
ENDIF
_Anno = TRC(4,ALLTRIM(STR(_nAnno,4,0)))
_Mese = TRC(2,ALLTRIM(STR(_nMese,2,0)))
_PAR_DATA_DALx= "01/" + _Mese + "/" + _Anno
_PAR_DATA_ALx= DATA_FINE_MESE(_Mese + "/" + _Anno)

_PAR_DATA_DAL= RIBALTA2(_PAR_DATA_DALx)
_PAR_DATA_AL = RIBALTA2(_PAR_DATA_ALx)


_SAVE_SEL = SELECT()
_PROGRESSIVO_PROGRAMMA = SYS(2015)

_ALLEGATI=""
_FILE_DA_ALLEGARE=""
_PDF_DESCRIZIONE_=""
_PDF_SELECT_ =""
_PDF_REPORT_ =""
_PDF_SUBDIR_ = LEGGE_CONFIG("AQ_SCHEDULER_CONFIG.CFG","PATH_EMAIL")	&& RICERCA DIRECTORY E SOTTODIRECTORY CONTENENTE IL FILE PDF DA CREARE

RELEASE V_TITOLO
PUBLIC V_TITOLO



V_TITOLO	= "Generazione automatica scritture contabili mensili"

WAIT WINDOWS "ESEGUE PROGRAMMA CONTABILITA' GENERALE PER LA CREAZIONE SCRITTURE MENSILI AUTOMATICHE" TIMEOUT 3


cSql=""     
cNomeCursorSql="CU_INDICE"


TEXT TO cSql NOSHOW

	SELECT 
		MOV_SOC,
		MOV_ANNO,
		MOV_CONTO,
		MOV_CONTO,
		MOV_NREGIS, 
		MOV_DTREG,
		MOV_NPROT,
		MOV_NDOC,
		MOV_DTDOC,
	    MOV_TOP,
		MOV_IMP,
		MOV_TMOV,
		MOV_VALUTA,
		MOV_CAMBIO,
		MOV_IVA,
		MOV_NUMPRO,	
		MOV_DESMOV,
		MOV_CONTABILITA_PREVISIONALE
	FROM INDICE AS INDI
	LEFT OUTER JOIN PARA AS PARA1
	ON 'TOP'+INDI.MOV_TOP = PARA1.CODICE
	WHERE MOV_DTREG BETWEEN '<<_PAR_DATA_DAL>>' AND '<<_PAR_DATA_AL>>'
		AND MOV_TOP <> 'CHI' 
		AND MOV_CONTABILITA_PREVISIONALE<>'P'
		AND SUBSTRING(PARA1.LIBERA,79,1)='S'
	    ORDER BY MOV_NUMPRO,MOV_DTREG,MOV_NREGIS


ENDTEXT


 
IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF	

** ############################### ELABORA DA INDICE LE PRIME NOTE DUPLICANDOLE NEL MESE SUCCESSIVO DI COMPETENZA #############################


IF USED("indice_prime_note_duplicate")
	SELECT indice_prime_note_duplicate
	USE	
ENDIF
IF !ExecCommand("select * from mov_cont where 0=1","indice_prime_note_duplicate")	
	 return(.f.)													
ENDIF	


SELECT CU_INDICE													&& INDICE PRIME NOTE DA DUPLICARE
GO TOP
SCAN


   SCATTER MEMVAR MEMO

   _PRIMA_NOTA_GIA_TRATTATA = .F.
   =VERIFICA_SE_PRIMA_NOTA_GIA_TRATTATA(M.MOV_ANNO,M.MOV_NREGIS)
   IF _PRIMA_NOTA_GIA_TRATTATA 
   	  SELECT CU_INDICE
   	  LOOP
   ENDIF

   PUB_NUOVO_NUMPRO_ASSEGNATO = ""									&& PRELEVA IL NUMERO DI PRIMA NOTA INTERNO
   PUB_NUOVO_NREG_ASSEGNATO   = ""									&& PRELEVA IL NUMERO DI REGISTRAZIONE UTENTE DELLA PRIMA NOTA
   DO REG_NUMRPN 													&& PRELEVA IL NUMERO DI PRIMA NOTA INTERNO
   DO REG_NUMREG             										&& PRELEVA IL NUMERO DI REGISTRAZIONE UTENTE DELLA PRIMA NOTA

   ** ______________________________________________________________AGGIORNA INDICE____________________________
   																	
   IF !ExecCommand("select * from indice where 0=1","cur_indice")	&& AGGIORNA IL D.B.INDICE PRIME NOTE
     return(.f.)													&& AGGIORNA IL D.B.INDICE PRIME NOTE
   ENDIF															&& AGGIORNA IL D.B.INDICE PRIME NOTE
   SELECT CUR_INDICE												&& AGGIORNA IL D.B.INDICE PRIME NOTE
   APPEND BLANK														&& AGGIORNA IL D.B.INDICE PRIME NOTE
   GATHER MEMVAR MEMO												&& AGGIORNA IL D.B.INDICE PRIME NOTE
   
   REPLACE ID_UNIQUE 	WITH ""										&& RIPULISCE ID_UNIQUE  
   REPLACE MOV_NUMPRO 	WITH ALLTRIM(PUB_NUOVO_NUMPRO_ASSEGNATO)	&& CAMBIA IL NUMERO INTERNO DI PRIMA NOTA
   REPLACE MOV_DTREG	WITH DATA_REGI 								&& CAMBIA LA DATA DI REGISTRAZIONE DI PRIMA NOTA
   REPLACE MOV_NREGIS	WITH PUB_NUOVO_NREG_ASSEGNATO   			&& CAMBIA IL NUMERO DI REGISTRAZIONE DI PRIMA NOTA
   REPLACE MOV_ANNO     WITH __PUB_ANNO__ 							&& AGGIORNA ANNO DI REGISTRAZIONE DI PRIMA NOTA (PER IL FINE ANNO)

   IF M.MOV_TMOV   = "D"											&& CAMBIA LA NATURA DARE/AVERE DELLA PRIMA NOTA
     REPLACE MOV_TMOV   WITH "A"									&& CAMBIA LA NATURA DARE/AVERE DELLA PRIMA NOTA
   ELSE																&& CAMBIA LA NATURA DARE/AVERE DELLA PRIMA NOTA
     REPLACE MOV_TMOV   WITH "D"									&& CAMBIA LA NATURA DARE/AVERE DELLA PRIMA NOTA
   ENDIF	      													&& CAMBIA LA NATURA DARE/AVERE DELLA PRIMA NOTA
 
   IF !ExecRW('','indice','I','','CUR_INDICE')						&& CREA IL DATABASE INDICE
     return(.f.)													&& CREA IL DATABASE INDICE
   ENDIF															&& CREA IL DATABASE INDICE


  ** ______________________________________________________________AGGIORNA MOV_CONT/CONTI____________________________	
  
  
   __aggiorna_cursore_indice_prime_note_duplicate = .f.
   
   SELECT CU_INDICE
   _SOC__    = MOV_SOC												&& ACCESSO ALLA PRIMA NOTA IN BASE A MOV_ANNO DI INDICE : POTREBBE ESSERE UNA ELABORAZIONE DI GENNAIO DUPLICANDO LE PRIME NOTE DI DICEMBRE ANNO PRECEDENTE	
   _ANNO__   = MOV_ANNO												&& ACCESSO ALLA PRIMA NOTA IN BASE A MOV_ANNO DI INDICE : POTREBBE ESSERE UNA ELABORAZIONE DI GENNAIO DUPLICANDO LE PRIME NOTE DI DICEMBRE ANNO PRECEDENTE	
   _NUMPRO__ = MOV_NUMPRO											&& ACCESSO ALLA PRIMA NOTA IN BASE A MOV_ANNO DI INDICE : POTREBBE ESSERE UNA ELABORAZIONE DI GENNAIO DUPLICANDO LE PRIME NOTE DI DICEMBRE ANNO PRECEDENTE	

   * ACCESSO ALLA REGISTRAZIONE PER LA DUPLICAZIONE SUCCESSIVA		&& ACCESSO ALLA PRIMA NOTA IN BASE A MOV_ANNO DI INDICE : POTREBBE ESSERE UNA ELABORAZIONE DI GENNAIO DUPLICANDO LE PRIME NOTE DI DICEMBRE ANNO PRECEDENTE	
   x_soci = "mov_soc = '" + _SOC__    + "'"
   x_anno = "mov_anno = '" + _ANNO__   + "'"
   x_npro = "mov_numpro = '" + ALLTRIM(_NUMPRO__) + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_npro
   Csql   = "select * from mov_cont where " + x_cond + " order by mov_soc,mov_anno,mov_numpro,mov_sequen"
   IF !ExecCommand(cSql,"MOV_CONT_DUPLI")
      return(.f.)
   ENDIF
   SELECT MOV_CONT_DUPLI
   GO TOP
   IF !EOF()
   
		   SCAN
		   
		       SELECT MOV_CONT_DUPLI
		       
			   SCATTER MEMVAR MEMO
			   
			   __XCONTO__ 	= MOV_CONTO
			   __XTIMOV__ 	= MOV_TMOV   
			   __XIMPORTO__ = MOV_IMP
			   __XCAMBIO__	= MOV_CAMBIO
			   __XVALUTA__  = MOV_VALUTA
			   __XCHIAVE__  = MOV_ANNO+ALLTRIM(MOV_NREGIS)
			
			   IF !ExecCommand("select * from MOV_CONT where 0=1","cur_mov_cont")	&& AGGIORNA IL D.B.MOV_CONT PRIME NOTE
			     return(.f.)														&& AGGIORNA IL D.B.MOV_CONT PRIME NOTE
			   ENDIF																&& AGGIORNA IL D.B.MOV_CONT PRIME NOTE
			   SELECT cur_mov_cont													&& AGGIORNA IL D.B.MOV_CONT PRIME NOTE
			   APPEND BLANK															&& AGGIORNA IL D.B.MOV_CONT PRIME NOTE
			   GATHER MEMVAR MEMO													&& AGGIORNA IL D.B.MOV_CONT PRIME NOTE
			  
			   REPLACE ID_UNIQUE 	WITH ""											&& RIPULISCE ID_UNIQUE
			   REPLACE MOV_NUMPAUT 	WITH ALLTRIM(__XCHIAVE__)						&& SI SALVA ANNO+NUMERO REGISTRAZIONE RIGINALE PER POTER VERIFICARE SE LA REGISTRAZIONE ORIGINALE E' STATA DUPLICATA
			   REPLACE MOV_NUMPRO 	WITH ALLTRIM(PUB_NUOVO_NUMPRO_ASSEGNATO)		&& CAMBIA IL NUMERO INTERNO DI PRIMA NOTA
  				
  			   REPLACE MOV_ANNO     WITH __PUB_ANNO__ 								&& AGGIORNA ANNO DI REGISTRAZIONE DI PRIMA NOTA (PER IL FINE ANNO)
   			   REPLACE MOV_DTREG	WITH DATA_REGI 									&& CAMBIA LA DATA DI REGISTRAZIONE DI PRIMA NOTA
  			   REPLACE MOV_NREGIS	WITH PUB_NUOVO_NREG_ASSEGNATO   				&& CAMBIA IL NUMERO DI REGISTRAZIONE DI PRIMA NOTA

			   IF M.MOV_TMOV   = "D"												&& CAMBIA LA NATURA DARE/AVERE DELLA PRIMA NOTA
			     REPLACE MOV_TMOV   WITH "A"										&& CAMBIA LA NATURA DARE/AVERE DELLA PRIMA NOTA
			   ELSE																	&& CAMBIA LA NATURA DARE/AVERE DELLA PRIMA NOTA
			     REPLACE MOV_TMOV   WITH "D"										&& CAMBIA LA NATURA DARE/AVERE DELLA PRIMA NOTA
			   ENDIF	      														&& CAMBIA LA NATURA DARE/AVERE DELLA PRIMA NOTA
			 
			 
			   IF  !__aggiorna_cursore_indice_prime_note_duplicate					&& CREA CURSORE DI APPOGGIO PER LA STAMPA DELLE PRIME NOTE DUPLICATE
			   		 __aggiorna_cursore_indice_prime_note_duplicate = .t.			&& CREA CURSORE DI APPOGGIO PER LA STAMPA DELLE PRIME NOTE DUPLICATE
			   		 SCATTER MEMVAR MEMO											&& CREA CURSORE DI APPOGGIO PER LA STAMPA DELLE PRIME NOTE DUPLICATE
			   		 SELECT indice_prime_note_duplicate								&& CREA CURSORE DI APPOGGIO PER LA STAMPA DELLE PRIME NOTE DUPLICATE
			   		 APPEND BLANK													&& CREA CURSORE DI APPOGGIO PER LA STAMPA DELLE PRIME NOTE DUPLICATE
			   		 GATHER MEMVAR memo												&& CREA CURSORE DI APPOGGIO PER LA STAMPA DELLE PRIME NOTE DUPLICATE
	   			     REPLACE MOV_NUMPAUT 	WITH ""									&& NEL CURSORE DI APPOGGIO RIPULISCE LA VARIABILE IN QUANTO IN QUESTO CASO NEL REPORT NON DEVE ESSRE FATTA NESSUNA SEGNALAZIONE DI ANOMALIA RISCONTRATA
			   	ENDIF 																&& CREA CURSORE DI APPOGGIO PER LA STAMPA DELLE PRIME NOTE DUPLICATE


			   SELECT cur_mov_cont													&& CREA IL DATABASE MOV_CONT 
			   IF !ExecRW('','mov_cont','I','','cur_mov_cont')						&& CREA IL DATABASE MOV_CONT 
			     return(.f.)														&& CREA IL DATABASE MOV_CONT 
			   ENDIF																&& CREA IL DATABASE MOV_CONT 

			  
			   x_soci = "con_soc = '" + PUB_CODSOC + "'"
			   x_anno = "con_anno = '" + __PUB_ANNO__ + "'"
			   x_cont = "con_conto = '" + ALLTRIM(__XCONTO__) + "'"
			   x_cond = x_soci + " and " + x_anno + " and " + x_cont
			   Csql  = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
			   IF !ExecRW(cSql,"CONTI","R")
			      return(.f.)
			   ENDIF
			   SELECT CONTI
			   IF RECCOUNT() <> 0

			      P_IMPA= CON_IMP_A
			      P_IMPD= CON_IMP_D
			      MESE    = SUBSTR(DATA_REGI,6,2)
			      VAR     = "CON_AV"+MESE
			      VAR2    = "CON_DA"+MESE
			      
			      IF __XTIMOV__ = "A"		  && TIPO MOVIMENTO ORIGINALE
				  		REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(__XVALUTA__,__XIMPORTO__,__XCAMBIO__)		&& CONTROAGGIORNO LA NATURA CONRTRARIA IN DARE
			      		REPLACE   &VAR2       WITH CAMBIO(__XVALUTA__,__XIMPORTO__,__XCAMBIO__)+&VAR2		&& CONTROAGGIORNO LA NATURA CONRTRARIA IN DARE
			      ELSE
			      		REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(__XVALUTA__,__XIMPORTO__,__XCAMBIO__)		&& CONTROAGGIORNO LA NATURA CONRTRARIA IN AVERE
			     		REPLACE   &VAR        WITH CAMBIO(__XVALUTA__,__XIMPORTO__,__XCAMBIO__)+&VAR		&& CONTROAGGIORNO LA NATURA CONRTRARIA IN AVERE
			      ENDIF
			      

			   ENDIF
			   IF !ExecRW(cSql,"CONTI","W")
			      return(.f.)
			   ENDIF


			   SELECT MOV_CONT_DUPLI

			
			ENDSCAN 		
		
   		
   
   ENDIF
   ** ______________________________________________________________AGGIORNA MOV_CONT/CONTI____________________________	
  


   SELECT CU_INDICE


ENDSCAN





SELECT indice_prime_note_duplicate
GO TOP

_PDF_REPORT_ 		=ALLTRIM(CERCAREPO("XXX","SCRITURE_CONTABILI_AUTOMATICHE_MENSILI","SCRITURE_CONTABILI_AUTOMATICHE_MENSILI.FRX"))
_PDF_DESCRIZIONE_	= V_TITOLO+_PROGRESSIVO_PROGRAMMA 
_PDF_SELECT_ 		= "indice_prime_note_duplicate"

IF !EMPTY(_PDF_SUBDIR_)
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_,_PDF_SUBDIR_)
ELSE
	=CREA_FILE_PDF(_PDF_SELECT_,_PDF_REPORT_,_PDF_DESCRIZIONE_)
ENDIF


_FILE_DA_ALLEGARE = ALLTRIM(_PDF_DESCRIZIONE_)+".PDF"

_ALLEGATI = _ALLEGATI + IIF(EMPTY(_ALLEGATI),"",";")+_FILE_DA_ALLEGARE 


_ERRORE =.F.
DO PRG\INVIA_MAIL_SCHEDULATE WITH _ERRORE,_ALLEGATI ,_ID_EMAIL_DA_INVIARE


SELECT(_SAVE_SEL )
	
RETURN



************************************************************************
FUNCTION DATA_FINE_MESE
************************************************************************

PARAMETERS _MMAAAA

_nMese = VAL(SUBSTR(_MMAAAA,1,2))
_nAnno = VAL(SUBSTR(_MMAAAA,4,4))

_nUltimoGiorno = 28

DO WHILE .T.
	_cData = TRC(2,STR(_nUltimoGiorno,2,0)) + "/" + TRC(2,STR(_nMese,2,0)) + "/" + TRC(4,STR(_nAnno,4,0))
	_dData = CTOD(_cData)
	_dData = _dData + 1
	IF VAL(SUBSTR(DTOC(_dData),1,2)) > _nUltimoGiorno
		_nUltimoGiorno = _nUltimoGiorno + 1
	ELSE
		EXIT
	ENDIF
ENDDO

_cDataUltimoGiorno = TRC(2,STR(_nUltimoGiorno,2,0)) + "/" + TRC(2,STR(_nMese,2,0)) + "/" + TRC(4,STR(_nAnno,4,0))

RETURN _cDataUltimoGiorno




***********************************************************************
* Funzione - TRC     Data: 18.03.97   Autore: Project S.r.L.
***********************************************************************
*
*  AGGIUNGE ZERI INIZIALI AD UN NUMERO IN FORMATO CARATTERE
*  PARAMETRI DA PASSARE
*  _LUN  = LUNGEZZA DEL CAMPO
*  _COD = VARIABILE CONTENENTE VALORE
*
*  sintassi:
*  V_COD=TRC(10,V_COD)
**************************
FUNCTION TRC
**************************
PARA _LUN,_COD

_COD=ALLTRIM(_COD)
IF LEN(_COD) > _LUN
 RETURN(_COD)
ENDIF

_LUN1=_LUN - LEN(_COD)
_OUT=REPLICATE('0',_LUN1)+_COD

RETURN(_OUT)

***********************************************
* AGG. NUMERO DI REGISTRAZIONE  INTERNO DI PN *
***********************************************
PROCEDURE REG_NUMRPN

v_seek	  = 'NUMREGPN'+PUB_CODSOC
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
   APPEND BLANK
   PN        = 1
   PN_C      = sys(2015)    &&   STR(PN)
   NUMEROINT = PN_C
   REPLACE CODICE WITH 'NUMREGPN'+PUB_CODSOC
   REPLACE DESCRI WITH "N.REG.INTERNO PN"
   REPLACE LIBERA WITH ALLTRIM(PN_C)
ELSE
   PN        = VAL(SUBSTR(LIBERA,1,10))
   PN        = PN + 1
   PN_C      = STR(PN)
   NUMEROINT = PN_C
   PN_C      = SYS(2015)
   NUMEROINT = PN_C
ENDIF

PUB_NUOVO_NUMPRO_ASSEGNATO = PN_C

IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN


********************************
FUNCTION CAMBIO
********************************

* -->> MODIFICA 21/03/2001
* -----------------------------------------
* -->> aggiunto il parametro opzionale _CONTO_CONTABILE
* -->> che e'la chiave di lettura della tabella CONTI(indice CONTO)
* -->> chiave composta da SOCIETA'+ANNO+CONTO
* -->> quando e' valorizzato il nuovo parametro controllo se il conto
* -->> e' un conto IVA e in questo caso aggiungo 0.49 se lire o 0.0000 se euro
* -->> per poter arrotondare alla lira/centesimo superiore.

* -->> MODIFICA 03/11/2012 - FABIANO
* -->>     SE LA VALUTA DI RIFERIMENTO PUB_VALRIF ='EUR' E LA VALUTA DEL CAMBIO _COD_VAL='EUR'
* -->>     ALLORA NON SERVE ACCEDERE A CONTI PER STABILIRE SE SI TRATTA DI UN CONTO IVA
* -->>     PERCHE' COMUNQUE AGGIUNGEREI  _IVA_EURO  = 0 ALL'IMPORTO CALCOLATO
* -----------------------------------------

PARA _COD_VAL,_IMP_DOC,_CAM_DOC,_CONTO_CONTABILE,_FL_INVAL,_DECIMALS  

_W_PR=PARAMETER()

IF _W_PR < 3
   WAIT WINDOW "Routine cambio mancano i parametri"
   RETURN(0)
ENDIF

IF _W_PR = 3
   _CONTO_CONTABILE=""
   _FL_INVAL       = .F.  && STAMPA IN ITL/LIT
ENDIF

IF _W_PR = 4
   _FL_INVAL       = .F.  && STAMPA IN ITL/LIT
ENDIF


*** IMPOSTO DA PARAMETRO IL NUMERO DI DECIMALI PER L'ARROTONDAMENTO CON CUI VOGLIO IL 
*** CALCOLO DEL CAMBIO PER ESEMPIO NEL CALCOLO DEL BILANCIO PRETENDO UNA PRECISIONE DI 3 DECIMALI
IF _W_PR < 6
	_DECIMALS = 2
ENDIF


* -->> se richiedo la stampa in valuta non eseguo la routine cambio
* ------------------------------------------------------------------
IF _FL_INVAL     && STAMPA IN VALUTA USCITA FORZATA
   RETURN(_IMP_DOC)
ENDIF

_IVA_LIRE=0
_IVA_EURO=0


*** SE LA VALUTA DI RIFERIMENTO PUB_VALRIF ='EUR' E LA VALUTA DEL CAMBIO _COD_VAL='EUR'
*** ALLORA NON SERVE ACCEDERE A CONTI PER STABILIRE SE SI TRATTA DI UN CONTO IVA
*** PERCHE' COMUNQUE AGGIUNGEREI  _IVA_EURO  = 0 ALL'IMPORTO CALCOLATO
***
IF PUB_VALRIF ='EUR' AND _COD_VAL ='EUR'
ELSE
	IF !EMPTY(_CONTO_CONTABILE)
	   _SELE_PARA=SELECT()
	   _LENG  = LEN(ALLTRIM(_CONTO_CONTABILE)) - 6
	   x_soci = "con_soc = '" + SUBSTR(_CONTO_CONTABILE,1,2) + "'"
	   x_anno = "con_anno = '" + SUBSTR(_CONTO_CONTABILE,3,4) + "'"
	   x_cont = "con_conto = '" + SUBSTR(_CONTO_CONTABILE,7,_LENG) + "'"
	   x_cond = x_soci + " and " + x_anno + " and " + x_cont
	   Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
	   IF !ExecCommand(cSql,"cur_conti")
	      return(.f.)
	   ENDIF
	   SELECT cur_conti
	   GO TOP
	   IF EOF()
	   ELSE
	      IF CON_TIPOCO = "I"    && CONTO IVA
	         _IVA_LIRE  = .49
	         _IVA_EURO  = .0000
	      ENDIF
	   ENDIF        
	   SELECT(_SELE_PARA)
	ENDIF
ENDIF

_CALCOLO=_IMP_DOC*_CAM_DOC

IF _COD_VAL $ "ITL.LIT" AND PUB_VALRIF $ "ITL.LIT"
   RETURN(ROUND(_CALCOLO+_IVA_LIRE,0))
ELSE
   IF PUB_VALRIF $ "ITL.LIT"
      RETURN(ROUND(_CALCOLO+_IVA_LIRE,0))
   ELSE
      *RETURN(ROUND(_CALCOLO+_IVA_EURO,2))
      RETURN(ROUND(_CALCOLO+_IVA_EURO,_DECIMALS))  
   ENDIF
ENDIF



************************************************************************
FUNCTION VERIFICA_SE_PRIMA_NOTA_GIA_TRATTATA
************************************************************************

LPARAMETERS _jANNO,_jNREGIS

   S_X_S=STR(SELECT())

   _jCHIAVE = _jANNO+ALLTRIM(_jNREGIS)

   ** SE ESISTE NEL MESE SUCCESSIVO LA REGISTRAZIONE GIA' DUPLICATA IN BASE A MOV_NUMPALT CHE CONTIENE ANNO E NUMERO DI REGISTRAZIONE
   x_cond = "mov_numpaut = '" + ALLTRIM(_jCHIAVE ) + "'"
   Csql   = "select * from mov_cont where " + x_cond + " order by mov_soc,mov_anno,mov_numpro,mov_sequen"
   IF !ExecCommand(cSql,"MOV_CONT_VERY")
      return(.f.)
   ENDIF
   SELECT MOV_CONT_VERY
   GO TOP
   IF !EOF()
	   _PRIMA_NOTA_GIA_TRATTATA = .T.
	   SCATTER MEMVAR MEMO											&& CREA CURSORE DI APPOGGIO PER LA STAMPA DELLE PRIME NOTE DUPLICATE
	   SELECT indice_prime_note_duplicate							&& CREA CURSORE DI APPOGGIO PER LA STAMPA DELLE PRIME NOTE DUPLICATE
	   APPEND BLANK													&& CREA CURSORE DI APPOGGIO PER LA STAMPA DELLE PRIME NOTE DUPLICATE
	   GATHER MEMVAR memo											&& CREA CURSORE DI APPOGGIO PER LA STAMPA DELLE PRIME NOTE DUPLICATE
   ELSE
	   _PRIMA_NOTA_GIA_TRATTATA = .F.
   ENDIF
   
 
   
      
   SELECT &S_X_S
   
   
RETURN



***********************************************
* AGG. NUMERO DI REGISTRAZIONE  UTENTE        *
***********************************************
PROCEDURE REG_NUMREG
***********************************************

v_seek	  = 'NUMREG'+__PUB_ANNO__+PUB_CODSOC
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
   T_NUM     = 1
   TC_NUM    = STR(T_NUM)
   APPEND BLANK
   REPLACE CODICE WITH 'NUMREG'+PUB_ANNO+PUB_CODSOC
   REPLACE DESCRI WITH "N.REGISTRAZIONE UTENTE"
   REPLACE LIBERA WITH ALLTRIM(TC_NUM)
   NREG      = TC_NUM
   X_NREG    = NREG
   _NREG_    = NREG
   REG_UTE   = TC_NUM
   PUB_NUOVO_NREG_ASSEGNATO   = ALLTRIM(NREG) 
ELSE
   C_NUM  = SUBSTR(LIBERA,1,10)
   V_NUM  = VAL(C_NUM)
   T_NUM  = V_NUM+1
   TC_NUM = STR(T_NUM)
   REPLACE LIBERA WITH ALLTRIM(TC_NUM)
   NREG      = TC_NUM
   X_NREG    = NREG
   _NREG_    = NREG   
   REG_UTE   = TC_NUM
   PUB_NUOVO_NREG_ASSEGNATO   = ALLTRIM(NREG)
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN
