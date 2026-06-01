**********************************************************************************************************
**							  																			**
**							ARTICOLI CHE IDENTIFICANO "ESENZIONE IVA"									**
**																										**
**********************************************************************************************************
**									-	ARTICOLO  10													**
**********************************************************************************************************

* select distinct SUBSTR(LIBERA,1,3) from para where codice like 'IVA%'

**********************************************************************************************************
**																										**
**						ARTICOLI CHE IDENTIFICANO IL CAMPO "NON IMPONIBILE"								**
**																										**
**********************************************************************************************************
**									-	ARTICOLO  8														**
**									-	ARTICOLO  8-bis													**
**									-	ARTICOLO  9														**
**									-	ARTICOLO  72													**
**									-	ARTICOLO  40													**
**									-	ARTICOLO  41													**
**									-	ARTICOLO  52													**
**********************************************************************************************************
RELEASE imponibile_indeducibile,imposta_indeducibile,_elenco_codAltro,OK_PROTCL 
PUBLIC imponibile_indeducibile,imposta_indeducibile,_elenco_codAltro,OK_PROTCL 

imponibile_indeducibile	= 0
imposta_indeducibile	= 0
_elenco_codAltro	    = ''
OK_PROTCL = 0


CREATE CURSOR PRINT_SPESOMETRO	(CODCLI C(10), RAGSOC C(40), INDIRI C(30), LOCALI C(30), CAP C(5), PROVI C(4) ,CODFIS C(16), PARIVA C(25), NAZIONE C(3) ,;
								VALORE N(17,3), IMPONI N(17,3), IVA N(17,3),;
								ESENZ N(17,3), ART8 N(17,3),ART8BIS N(17,3),ART9 N(17,3),ART40 N(17,3),ART41 N(17,3),ART52 N(17,3),ART72 N(17,3),ALTREES N(17,3),;
								IMPONI_INDEDUCIBILE N(17,3),IVA_INDEDUCIBILE N(17,3),;
								PIVACOD C(3), PIVADES C(40), PIVAPERC N(3,0), PIVATIPO C(1), PIVAPERI N(3,0), TIPOREC C(1),;
								FATNOT C(1), DTFATT C(8), NUMDOC C(15), TOP C(3), CLIFOR C(1), ;
								COGNOME C(24), NOME C(20), DTNASCITA C(8), COMUNENAS C(40), PROVINAS C(2), STATODOM C(3), ;
					  		    DENOMINAZ C(60), CITTALEG C(40), STATOLEG C(3), INDIREST C(40), TIPOSOGGETTO C(1), ;
					  		    MODPAG C(01), TIPOOPE C(01), DATAFAT C(08), NUMEROFAT C(15), VARIMPONI C(01), VARIMPOST C(01), INELENCO C(1) )
SELECT PRINT_SPESOMETRO					  		         
INDEX ON ALLTRIM(TIPOREC)+ALLTRIM(CODCLI) TAG IDX

SELECT PRINT_SPESOMETRO
HH=AFIELDS(TRANSPRN)
CREATE CURSOR TMP_PRINT FROM ARRAY TRANSPRN


** Creo cursore finale
CREATE CURSOR CUR_SPESOMETRO ( codcli C(10), ragsoc C(40), indiri C(30), locali C(30), cap C(5), provi C(4) ,codfis C(16), pariva C(25), nazione C(3) ,valore N(17,3), imponi N(17,3), iva N(17,3),;
							  esenz N(17,3), art8 N(17,3),art8bis N(17,3),art9 N(17,3),art40 N(17,3),art41 N(17,3),art52 N(17,3),art72 N(17,3),altrees N(17,3),imponi_indeducibile N(17,3),iva_indeducibile N(17,3),;
							  pivacod C(3), pivades C(40), pivaperc N(3,0), pivatipo C(1), pivaperI N(3,0), ;
						  	  FATNOT C(1), DTFATT c(8), NUMDOC C(15), TOP C(3), CLIFOR c(1), ;
							  COGNOME C(24), NOME C(20), DTNASCITA C(8), COMUNENAS C(40), PROVINAS C(2), STATODOM C(3), ;
					  		  DENOMINAZ C(60), CITTALEG C(60), STATOLEG C(3), INDIREST C(40), TIPOSOGGETTO C(1), INELENCO C(1), ;
					  		  FLAG_SEZIONE C(2))

INDEX ON ALLTRIM(CODCLI) + PADR(ALLTRIM(NUMDOC),15,' ') TAG M_NDOC
INDEX ON ALLTRIM(CODCLI) + ALLTRIM(FATNOT) TAG DESCFAT

CREATE CURSOR ELENCOALTRO ( CODICEALTRO C(50) )

ANNODAL=SUBSTR(DATADAL,7,4)
MESEDAL=SUBSTR(DATADAL,4,2)

IF (EMPTY(MESEDAL)) .OR. (EMPTY(ANNODAL))  
  RETURN
ENDIF  

WAIT WINDOWS "Lettura archivi in corso...  -  Prego attendere" nowait

DO SELECT_ARCHIVI

DO SELECT_BLACK_LIST

DO CREA_LISTA_ALIQUOTE

*** ESTRAI FATTURATO DA BOLLATI CLI/FOR
*DO SELECT_BOLLATI
**=> ERASMO - INIZIO 02/09/2016
IF _OPZ_SPESOMETRO
	DO SELECT_BOLLATI
	INSERT INTO U_IVA_CL SELECT * FROM S_IVA_CL
	INSERT INTO U_IVF_CL SELECT * FROM S_IVF_CL
ENDIF
IF _OPZ_BLACKLIST
	DO SELECT_BOLLATI_BLACKLIST
	INSERT INTO U_IVA_CL SELECT * FROM S_IVA_CL
	INSERT INTO U_IVF_CL SELECT * FROM S_IVF_CL
ENDIF
**=> ERASMO - FINE 02/09/2016

WAIT WINDOWS "Elaborazione dati in corso...  -  Prego attendere" nowait

DO VERIFICA_SE_ESISTE_PARAMETRO_IVA

DO PREFISSO_CONTO_CLIENTI_FORNITORI

IF __CLIFOR = 1
	DO CLIENTI WITH __FATNOT
ELSE
	DO FORNITORI WITH __FATNOT
ENDIF

RELEASE WINDOW DISPLAY

SELECT DISTINCT CODICEALTRO FROM ELENCOALTRO INTO CURSOR ELENCOALTRO
SELECT ELENCOALTRO

DO WHILE !EOF()

	_SINGOLOCOD = ALLTRIM(CODICEALTRO)
	_ELENCO_CODALTRO = _ELENCO_CODALTRO + _SINGOLOCOD + CHR(13)
	
	SELECT ELENCOALTRO
	SKIP + 1
	
ENDDO

SELECT * FROM DIVIDIALIQUOTA WHERE IMPO_DED <> 0 OR IMPO_NO_D <> 0 OR IVA_DED <> 0 OR IVA_NO_D <> 0 ;
		OR ESE_NOIMP <> 0 ;
		OR ALTRO <> 0 ;
		INTO CURSOR DIVIDIALIQUOTA
		
SELECT DIVIDIALIQUOTA

** Stampo
_TOTALE_PER_FORNITURA = 0
SELECT CUR_SPESOMETRO
GO TOP

DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF
	

	SELECT CUR_SPESOMETRO
	__STATODOM = STATODOM
	__STATOLEG = STATOLEG	
	
*!*		SELECT BLACK
*!*		SET ORDER TO COD
*!*		SEEK __STATODOM 
*!*		IF FOUND()
*!*		   SELECT CUR_SPESOMETRO
*!*		   SKIP +1
*!*		   LOOP
*!*		ENDIF
*!*		
*!*		SELECT BLACK
*!*		SET ORDER TO COD
*!*		SEEK __STATOLEG 
*!*		IF FOUND()
*!*		   SELECT CUR_SPESOMETRO
*!*		   SKIP +1
*!*		   LOOP
*!*		ENDIF
	
	SELECT CUR_SPESOMETRO


	WAIT WINDOW "Elaborazione doc.nr. "+CUR_SPESOMETRO.NUMDOC+" del "+CUR_SPESOMETRO.DTFATT NOWAIT 

	*** ##########################################################################################	
	***   VISIONE DEGLI IMPORTI FRAZIONATI -- DEVO VERIFICARE GLI ORDINI
	***   INIZIO
	
	REGIS_DA_INCLUDERE_IN_ELENCO = .T.
	__MODALITAPAG = "1"
	__NUMERODOC = CUR_SPESOMETRO.NUMDOC
	__DATADOC   = SUBSTR(CUR_SPESOMETRO.DTFATT,5,4) + "/" + SUBSTR(CUR_SPESOMETRO.DTFATT,3,2) + "/" + SUBSTR(CUR_SPESOMETRO.DTFATT,1,2)
	__TOTDOCU 	= CUR_SPESOMETRO.imponi + CUR_SPESOMETRO.imponi_indeducibile		
		
	SELECT CUR_SPESOMETRO		


	IF CLIFOR == "F"	&& SOLO PER I FORNITORI
		__INELENCO = CUR_SPESOMETRO.INELENCO	
		IF __INELENCO == "S"
			REGIS_DA_INCLUDERE_IN_ELENCO = .T.
			__MODALITAPAG = "2"
		ENDIF
	ENDIF
	
	
	IF REGIS_DA_INCLUDERE_IN_ELENCO
	ELSE
	    _TOTIMPONIBILE 	= CUR_SPESOMETRO.imponi + CUR_SPESOMETRO.imponi_indeducibile		
	    _TOTALE_PER_FORNITURA = _TOTIMPONIBILE

	ENDIF
	
	***   VISIONE DEGLI IMPORTI FRAZIONATI -- DEVO VERIFICARE GLI ORDINI
	***   FINE
	*** ##########################################################################################	


	SCATTER MEMVAR MEMO	
	SELECT TMP_PRINT 
	APPEND BLANK
	GATHER MEMVAR MEMO

	*** DEFINIZIONE DEI TIPI RECORD
	
	*** CLIENTI - FATTURE
	IF (__CLIFOR == 1 .AND. __FATNOT == "F")
	
	   IF (ALLTRIM(m.nazione) == 'ITA')   
		   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'  
			   REPLACE TIPOREC	WITH "2"   
		   ELSE
			   REPLACE TIPOREC	WITH "1"   	     && PERSONA FISICA
		   ENDIF
	   ELSE
		   REPLACE TIPOREC	WITH "3"   
	   ENDIF
	
	   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'
		   IF (ALLTRIM(m.nazione) == 'ITA')
			   ***REPLACE MODPAG   WITH "1"
			   REPLACE MODPAG   WITH __MODALITAPAG 
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			      REPLACE TIPOOPE    WITH "1"	&& Cessiono e/o prestazione 
			   ELSE
			      REPLACE TIPOOPE    WITH "2"	&& Cessione e/o prestazione ricevuta
			   ENDIF       
		   ELSE
			   ***REPLACE MODPAG   WITH "1"
			   REPLACE MODPAG   WITH __MODALITAPAG 
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			      REPLACE TIPOOPE    WITH "1"	&& Cessiono e/o prestazione 
			   ELSE
			      REPLACE TIPOOPE    WITH "2"	&& Cessione e/o prestazione ricevuta
			   ENDIF       
		   ENDIF
	   ELSE									 && PERSONA FISICA
		   ***REPLACE MODPAG   WITH "1"
		   REPLACE MODPAG   WITH __MODALITAPAG 
	   ENDIF
	ENDIF

	*** CLIENTI - NOTE VARIAZIONE
	IF (__CLIFOR == 1 .AND. __FATNOT == "N")
	   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'
		   IF (ALLTRIM(m.nazione) == 'ITA')
			   REPLACE TIPOREC	  WITH "4"  
	      	   REPLACE DATAFAT    WITH "3112"+SUBSTR(ALLTRIM(M.DTFATT),5)
	           REPLACE NUMEROFAT  WITH SPACE(15)
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			  	  VARIAZIONE = "C"	&& Credito
			   ELSE
			  	  VARIAZIONE = "D"	&& Debito
			   ENDIF      
		       REPLACE VARIMPONI  WITH VARIAZIONE 
		       REPLACE VARIMPOST  WITH VARIAZIONE 			   
		   ELSE
			   REPLACE TIPOREC	WITH "5"  
	      	   REPLACE DATAFAT    WITH "3112"+SUBSTR(ALLTRIM(M.DTFATT),5)
	           REPLACE NUMEROFAT  WITH SPACE(15)
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			  	  VARIAZIONE = "C"	&& Credito
			   ELSE
			  	  VARIAZIONE = "D"	&& Debito
			   ENDIF      
		       REPLACE VARIMPONI  WITH VARIAZIONE 
		       REPLACE VARIMPOST  WITH VARIAZIONE 			   			   
		   ENDIF
	   ELSE									 && PERSONA FISICA (NON INTERESSANO LE NOTE DI VARIAZIONE)
		   SKIP+1
		   LOOP
	   ENDIF
	ENDIF

	*** FORNITORI - FATTURE
	IF (__CLIFOR == 2 .AND. __FATNOT == "F")
	
	   IF (ALLTRIM(m.nazione) == 'ITA')   
		   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'  
			   REPLACE TIPOREC	WITH "2"   
		   ELSE
			   REPLACE TIPOREC	WITH "1"   	     && PERSONA FISICA
		   ENDIF
	   ELSE
		   REPLACE TIPOREC	WITH "3"   
	   ENDIF
	
	   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'
		   IF (ALLTRIM(m.nazione) == 'ITA')
			   ***REPLACE MODPAG   WITH "1"
			   REPLACE MODPAG   WITH __MODALITAPAG 
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			      REPLACE TIPOOPE    WITH "1"	&& Cessiono e/o prestazione 
			   ELSE
			      REPLACE TIPOOPE    WITH "2"	&& Cessione e/o prestazione ricevuta
			   ENDIF       
		   ELSE
			   ***REPLACE MODPAG   WITH "1"
			   REPLACE MODPAG   WITH __MODALITAPAG 
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			      REPLACE TIPOOPE    WITH "1"	&& Cessiono e/o prestazione 
			   ELSE
			      REPLACE TIPOOPE    WITH "2"	&& Cessione e/o prestazione ricevuta
			   ENDIF       
		   ENDIF
	   ELSE									 && PERSONA FISICA 
		   ***REPLACE MODPAG   WITH "1"
		   REPLACE MODPAG   WITH __MODALITAPAG 
	   ENDIF   
	ENDIF

	*** FORNITORI - NOTE VARIAZIONE
	IF (__CLIFOR == 2 .AND. __FATNOT == "N")
	   IF (ALLTRIM(m.TIPOSOGGETTO) == '1')   && SOCIETA'
		   IF (ALLTRIM(m.nazione) == 'ITA')
			   REPLACE TIPOREC	WITH "4"
	      	   REPLACE DATAFAT    WITH "3112"+SUBSTR(ALLTRIM(M.DTFATT),5)
	           REPLACE NUMEROFAT  WITH SPACE(15)
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			  	  VARIAZIONE = "C"	&& Credito
			   ELSE
			  	  VARIAZIONE = "D"	&& Debito
			   ENDIF      
		       REPLACE VARIMPONI  WITH VARIAZIONE 
		       REPLACE VARIMPOST  WITH VARIAZIONE 			   			      
		   ELSE
			   REPLACE TIPOREC	WITH "5"
	      	   REPLACE DATAFAT    WITH "3112"+SUBSTR(ALLTRIM(M.DTFATT),5)
	           REPLACE NUMEROFAT  WITH SPACE(15)
			   IF (ALLTRIM(M.CLIFOR) == "C")	&& DOCUMENTO RELATIVO AL CLIENTE
			  	  VARIAZIONE = "C"	&& Credito
			   ELSE
			  	  VARIAZIONE = "D"	&& Debito
			   ENDIF      
		       REPLACE VARIMPONI  WITH VARIAZIONE 
		       REPLACE VARIMPOST  WITH VARIAZIONE 			   			         
		   ENDIF
	   ELSE									 && PERSONA FISICA (NON INTERESSANO LE NOTE DI VARIAZIONE)
		   SKIP+1
		   LOOP
	   ENDIF   
	ENDIF
		
	SELECT CUR_SPESOMETRO
	SKIP + 1
ENDDO

SELECT TMP_PRINT 
GO TOP
DO WHILE !EOF()
	IF !EMPTY(ALLTRIM(TIPOREC))
		SCATTER MEMVAR MEMO
		SELECT PRINT_SPESOMETRO
		APPEND BLANK
		GATHER MEMVAR MEMO
	ENDIF
	SELECT TMP_PRINT 
	SKIP + 1
ENDDO


SELECT PRINT_SPESOMETRO
SET ORDER TO IDX
GO TOP

RELEASE PUB_TITOLO
PUBLIC PUB_TITOLO
PUB_TITOLO="STAMPA ELENCO "

IF __CLIFOR = 1
	PUB_TITOLO=	PUB_TITOLO + "CLIENTI"
	IF __FATNOT = "F"
		PUB_TITOLO=	PUB_TITOLO + " - FATTURE"
	ELSE
		PUB_TITOLO=	PUB_TITOLO + " - NOTE DI VARIAZIONE"	
	ENDIF
ELSE
	PUB_TITOLO=	PUB_TITOLO + "FORNITORI"
	IF __FATNOT = "F"
		PUB_TITOLO=	PUB_TITOLO + " - FATTURE"
	ELSE
		PUB_TITOLO=	PUB_TITOLO + " - NOTE DI VARIAZIONE"	
	ENDIF
ENDIF

WAIT CLEAR

SELECT PRINT_SPESOMETRO
GO TOP 

DELETE FOR EMPTY(TIPOOPE ) AND TIPOSOGGETTO ="0"
GO TOP 


IF _WW_OKSTA
   *DO PRG\MENUSTA WITH "PRINT_SPESOMETRO",.T.,.T.,"XXX","spesometro_ctrl_2013.frx","spesometro_ctrl_2013.frx"
   DO PRG\MENUSTA WITH "dividiAliquota",.T.,.T.,"XXX","spesometro_ctrl_rie.frx","spesometro_ctrl_rie.frx"
ENDIF

RELEASE PUB_TITOLO

RETURN



*###################################################################################
***
***    F O R N I T O R I 
***
*###################################################################################
PROCEDURE FORNITORI    
*###################################################################################

LPARAMETERS __FATTURA_O_NOTACREDITO
__FTNC = ALLTRIM(__FATTURA_O_NOTACREDITO)

SET NEAR OFF
SET EXACT ON
SET EXCLUSIVE OFF

SELECT U_IVF_CL
HH=AFIELDS(TRANSIVC)
CREATE CURSOR IVA FROM ARRAY TRANSIVC

SELECT U_IVF_CL
SET ORDER TO DATAFATT
GO TOP

CTRELAB = 0

DO WHILE !EOF()       && CARICA I RECORD PRINCIPALI DI FATTURAZIONE

  ** Salto tutti i record DIVERSI DAL PARAMETRO PASSATO IN INPUT ALLA PROCEDURA
  IF (ALLTRIM(IVF_FATNOT) != ALLTRIM(__FTNC))
    SELECT U_IVF_CL
    SKIP +1
    LOOP
  ENDIF
  
  
  SELECT U_IVF_CL
  _CODICE=ALLTRIM(IVF_CODCLI)
  _CODIVA=ALLTRIM(IVF_CODIVA)
  
  SELECT FORNITORI_SPESOMETRO
  SET ORDER TO FOR_CODCLI
  SEEK _CODICE

  IF FOUND() AND !EMPTY(SELEZIONE)
	  SELECT U_IVF_CL
	  SKIP 
	  LOOP
  ENDIF  

  *** VERIFICA SE CODICE IVA DA CONSIDERARE
  SELECT IVA_SPESOMETRO 
  SET ORDER TO CODICE
  SEEK _CODIVA
  
  IF !FOUND() OR EMPTY(SELEZIONE)
	  SELECT U_IVF_CL
	  SKIP 
	  LOOP
  ENDIF  
  
  SELECT U_IVF_CL
  

  SCATTER MEMVAR MEMO	    && Salva i vecchi valori
  SELECT IVA
  APPEND BLANK
  GATHER MEMVAR MEMO		&& Salva le modifiche
  
  REPLACE IVF_IMPOST WITH IVF_IMPOST - IVA_REVERSE  && ERASMO/FABIANO - 13/09/2016

  CTRELAB=CTRELAB+1 
  WAIT WINDOW "Movimenti FORNITORI - "+ALLTRIM(STR(CTRELAB)) NOWAIT


  SELECT U_IVF_CL
  SKIP

ENDDO



CT = 0
SELECT IVA
GO TOP


*************************
* INIZIA L'ELABORAZIONE *
*************************
DO WHILE !EOF()
	
	IF DELETED()
        SELECT IVA
    	SKIP +1
    	LOOP
  	ENDIF
  	
*!*	  	IF IVF_CODCLI='410200003'
*!*	  		SET STEP ON 
*!*	  	ENDIF

	__IVFDL78 = ""
	IF IVF_DL78
		__IVFDL78 = "S"
	ENDIF
	
  	ANNO   	= IVF_ANNO
  	WTOP   	= IVF_TOP
  	WCONTO 	= IVF_CODCLI
  	WCODCLI = IVF_CODCLI
  	__FLAG_SEZIONE = FLAG_SEZIONE
  	

  	CT = CT + 1

  	_NUMFAT     = IVF_NUMFAT
  	_ANNO       = IVF_ANNO
  	
  	WCODIVA	= IVF_CODIVA  && ERASMO - 05/04/2017

	IF (__FTNC == "F")
		WAIT WINDOWS "Fattura FORNITORE elaborata n. " + _NUMFAT     NOWAIT	
	ELSE
		WAIT WINDOWS "Nota Variazione FORNITORE elaborata n. " + _NUMFAT     NOWAIT	
	ENDIF

  	WTOP        = IVF_TOP
  	
	___RAGSOC= IVF_RAGSOC  	
  
  	** Prelevo i dati anagrafici dei clienti (dati non contabili)
    SELECT U_FOR_AN
    SET ORDER TO U_FOR_AN
	GO TOP
    WCOD = ALLTRIM(WCODCLI)
    
    SEEK PUB_CODSOC+ALLTRIM(WCOD)
    IF FOUND()
    
      WRAGSOC   = FOR_RAGLEG
	  IF EMPTY(WRAGSOC)	      
	      WRAGSOC   = FOR_RAGSOC
	  ENDIF
	  
      WINDIRI   = FOR_INDLEG
	  IF EMPTY(WINDIRI)	      
	      WINDIRI = FOR_INDIR
	  ENDIF
	  
      WLOCALI   = FOR_LOCLEG
	  IF EMPTY(WLOCALI)	      
	      WLOCALI = FOR_LOCALI
	  ENDIF
	  
      WCAP      = FOR_CAPLEG
	  IF EMPTY(WCAP)	      
	      WCAP = FOR_CAP
	  ENDIF
	  
      WPARIVA   = FOR_PIVALG
	  IF EMPTY(WPARIVA)	      
	      WPARIVA   = FOR_PARIVA
	      *IF EMPTY(FOR_PARIVA) AND ALLTRIM(LEN(FOR_CODFIS))=11
	      IF EMPTY(FOR_PARIVA) AND LEN(ALLTRIM(FOR_CODFIS))=11
		      WPARIVA   = FOR_CODFIS
	      ENDIF
	  ENDIF
	  
      WCODFIS   = FOR_CFISLG
	  IF EMPTY(WCODFIS)	      
	      WCODFIS   = FOR_CODFIS
	  ENDIF
	  
      WNAZION   = FOR_NAZION
	  
	  *** GESTIONE IVA CEE
      WIVCELG   = FOR_IVCELG
	  IF EMPTY(WIVCELG)	      
	      WIVCELG   = FOR_IVACEE
	  ENDIF      
	  
      *WCODIVA	= FOR_CODIVA
	  WPROVI    = ""

  	  WTIPOSOGGETTO = ALLTRIM(STR(FOR_RECCAT))  	  
      WCOGNOME      = FOR_reccog
      WNOME		    = FOR_recnom
      WDATANAS  	= FOR_ESTNAS      
	  WPROVINAS     = FOR_PRONAS       
      WCOMUNESTNAS  = FOR_ESTCOM
      WSTATOESTDOM  = FOR_ESTDOM      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
      WSTATOESTLEG  = FOR_ESTNAZ      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
      *WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
      *WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<
      WCITTAESTERO	= WLOCALI  && ERASMO/FABIANO - 07/04/2016 
      WINDESTERO	= WINDIRI  && ERASMO/FABIANO - 07/04/2016     
      	  
    ELSE
    
      *** NON L'HO TROVATO
      *** CERCO PER RAGIONE SOCIALE
	  SELECT U_FOR_AN
	  SET ORDER TO U_FOR_RG
	  GO TOP
	  *SEEK PUB_CODSOC+ALLTRIM(___RAGSOC)
	  SEEK PUB_CODSOC+SUBSTR(ALLTRIM(___RAGSOC),1,50)  && ERASMO - 08/04/2016
      
	  IF FOUND()
	  
	      WRAGSOC   = FOR_RAGLEG
		  IF EMPTY(WRAGSOC)	      
	    	  WRAGSOC   = FOR_RAGSOC
		  ENDIF
	  
    	  WINDIRI   = FOR_INDLEG
		  IF EMPTY(WINDIRI)	      
		      WINDIRI = FOR_INDIR
		  ENDIF
	  
    	  WLOCALI   = FOR_LOCLEG
		  IF EMPTY(WLOCALI)	      
		      WLOCALI = FOR_LOCALI
		  ENDIF
	  
	      WCAP      = FOR_CAPLEG
		  IF EMPTY(WCAP)	      
		      WCAP = FOR_CAP
		  ENDIF
	  
	      WPARIVA   = FOR_PIVALG
		  IF EMPTY(WPARIVA)	      
		      WPARIVA   = FOR_PARIVA
		      *IF EMPTY(FOR_PARIVA) AND ALLTRIM(LEN(FOR_CODFIS))=11
		      IF EMPTY(FOR_PARIVA) AND LEN(ALLTRIM(FOR_CODFIS))=11
			      WPARIVA   = FOR_CODFIS
		      ENDIF
		  ENDIF
	  
	      WCODFIS   = FOR_CFISLG
		  IF EMPTY(WCODFIS)	      
		      WCODFIS   = FOR_CODFIS
		  ENDIF

	      WNAZION   = FOR_NAZION	  
	      *WCODIVA	= FOR_CODIVA

		  *** GESTIONE IVA CEE
	      WIVCELG   = FOR_IVCELG
		  IF EMPTY(WIVCELG)	      
		      WIVCELG   = FOR_IVACEE
		  ENDIF      
      
		  WPROVI    = ""
		  
	  	  WTIPOSOGGETTO = ALLTRIM(STR(FOR_RECCAT))  		  
	      WCOGNOME      = FOR_reccog
	      WNOME		    = FOR_recnom
	      WDATANAS  	= FOR_ESTNAS 
		  WPROVINAS     = FOR_PRONAS       	           
	      WCOMUNESTNAS  = FOR_ESTCOM
	      WSTATOESTDOM  = FOR_ESTDOM      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
	      WSTATOESTLEG  = FOR_ESTNAZ      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
	      *WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
	      *WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<
	      WCITTAESTERO	= WLOCALI  && ERASMO/FABIANO - 07/04/2016 
	      WINDESTERO	= WINDIRI  && ERASMO/FABIANO - 07/04/2016
		  

	  ELSE      
	  

	      *** NON L'HO TROVATO NEANCHE PER RAGIONE SOCIALE
	      *** USO I CAMPI SUL CURSOR IVA GIA' VALORIZZATI
	      *** MI ACCORGO CHE SONO IN QUESTO CASO PERCHE' NEL DETTAGLIO
	      *** DEL FORNITORE MANCA IL CAMPO IVA E CODICE FISCALE
	      *** CHE QUI VALORIZZO A ""
	      *** 
	      SELECT IVA
      
    	  WRAGSOC   = IVF_RAGSOC
	      WINDIRI   = IVF_INDIRI
	      WLOCALI   = IVF_LOCALI
	      WCAP      = IVF_CAP
	      WPARIVA   = IVF_PARIVA
	      WCODFIS   = ""
		  *WCODIVA	= ""      
		  WPROVI    = ""
	      WNAZION   = ""
    	  WIVCELG   = ""	
    	  
	  	  WTIPOSOGGETTO = ""
	      WCOGNOME      = ""
	      WNOME		    = ""
	      WDATANAS  	= ""
		  WPROVINAS     = ""
	      WCOMUNESTNAS  = ""
	      WSTATOESTDOM  = ""      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
	      WSTATOESTLEG  = ""      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
	      WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
	      WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<
    	  
    	  	  
	   ENDIF
	   
	ENDIF

	SELECT PARA
	SET ORDER TO CODICE
	SEEK 'IVA'+WCODIVA
	IF FOUND()
		WDESIVA	   = alltrim(DESCRI)			&& Descrizione del codice IVA
		WPERCIVA   = VAL(SUBSTR(LIBERA,1,3))	&& Percentuale IVA
		WPERCIVACHR= SUBSTR(LIBERA,1,3)			&& CARATTERE Percentuale IVA		
  		WTIPOIVA   = SUBSTR(LIBERA,100,1)		&& Tipo IVA ( SE = "I" è INDEDUCIBILE )
  		WPERCIVA_I = VAL(SUBSTR(LIBERA,110,3))  && Percentuale di INDEDUCIBILITA'		
	ELSE
		WDESIVA	   = ''  && Descrizione del codice IVA
  		WPERCIVA   = 0	 && PERCENTUALE IVA INESISTENTE (caso assurdo) ???
		WPERCIVACHR= ''  && CARATTERE PERCENTUALE IVA INESISTENTE (caso assurdo) ???  		
	  	WTIPOIVA   = ''	 && Non ha il valore che mi interessa : "I" di indeducibile
  		WPERCIVA_I = 0	 && Non ha valore se non esiste la "I" di indeducibile
	ENDIF


	SELECT IVA
    
	*** AZZERA LE VARIABILI USATE PER LA STAMPA
	
	Imponibile 				= 0
	Imposta    				= 0
	ValoreTot  				= 0
	imponibile_indeducibile	= 0
	imposta_indeducibile	= 0
	
	__totArt10 		= 0
	__totArt8 		= 0
	__totArt8bis 	= 0
	__totArt9 		= 0
	__totArt40		= 0
	__totArt41 		= 0
	__totArt52 		= 0
	__totArt72 		= 0
	__totAltro 		= 0
	

	WTOTIM      = IVF_IMPONI
	WTOTIMPO    = IVF_IMPOST

	WFATNOT	  = ALLTRIM(IVF_FATNOT)
	
	_datafatt = RIBALTA2(ALLTRIM(IVF_DTFATT))
	WDTFATT	  = SUBSTR(_datafatt,1,2) + SUBSTR(_datafatt,4,2) + SUBSTR(_datafatt,7,4)		    && DATA DOCUMENTO
	WNUMDOC	  = PADR(ALLTRIM(IVF_NUMFAT),15,' ')										 		&& NUMERO DOCUMENTO			
	WTOPDOC	  = ALLTRIM(IVF_TOP)			    												&& TIPO OPERAZIONE			
	IF !EMPTY(ALLTRIM(WDATANAS))
		__DATANASCITA = SUBSTR(WDATANAS,1,2) + SUBSTR(WDATANAS,4,2) + SUBSTR(WDATANAS,7,4)
	ELSE	
		__DATANASCITA = SPACE(8)
	ENDIF	
     		 	      		 	      		 	
	ValoreTot  = WTOTIM

      		
	DO RIPARTIZIONE_IMPONIBILI_ESENZIONI_FORNITORI		   		

	** Salvo nel mio cursore finale i totali calcolati
	SELECT CUR_SPESOMETRO
	SET ORDER TO M_NDOC		&& ordinato per numero fattura fornitore (solo per i fornitori ci possono essere più righe)
	__seek_numfat = ALLTRIM(WCODCLI) + PADL(ALLTRIM(WNUMDOC),15,' ')
	SEEK __seek_numfat 
	
	IF FOUND()
	
		** Il numero fattura è già stato trovato
		** Sommo i totali calcolati a quelli già presenti
		REPLACE Iva    					with 	Iva     + Imposta
		REPLACE valore 					with 	valore  + ValoreTot
		REPLACE imponi 					with 	imponi  + Imponibile
		REPLACE imponi_indeducibile 	with	imponi_indeducibile + imponibile_indeducibile
		REPLACE iva_indeducibile 		with	iva_indeducibile + imposta_indeducibile

		REPLACE esenz  					with 	esenz   + __totArt10			
		REPLACE art8  					with 	art8  	 + __totArt8			
		REPLACE art8bis 				with 	art8bis + __totArt8bis
		REPLACE art9  					with 	art9  	 + __totArt9
		REPLACE art40  					with 	art40   + __totArt40
		REPLACE art41  					with 	art41   + __totArt41
		REPLACE art52  					with 	art52   + __totArt52
		REPLACE art72  					with 	art72   + __totArt72
		REPLACE altrees					with 	altrees + __totAltro	
				
	ELSE
	
		** Il numero fattura NON E' ANCORA stato trovato
		** Credo il record con il nuovo dato
		APPEND BLANK
		REPLACE INELENCO	 		    WITH __IVFDL78			&& SIMONE - 16/12/2011		
		REPLACE TIPOSOGGETTO 		    WITH WTIPOSOGGETTO
		REPLACE codcli  				with WCOD
		REPLACE ragsoc  				with WRAGSOC
		REPLACE indiri  				with WINDIRI
		REPLACE locali  				with WLOCALI
		REPLACE cap						with WCAP
		REPLACE provi					with WPROVI
		REPLACE nazione 				with WNAZION
		IF !EMPTY(ALLTRIM(WPARIVA))
			REPLACE pariva  			with WPARIVA
		ELSE	
			REPLACE pariva  			with WIVCELG			    && PARTITA IVA CEE
		ENDIF	
		REPLACE codfis  				with WCODFIS
		REPLACE pivacod					with WCODIVA	&& Codice IVA
		REPLACE pivades  				with WDESIVA	&& Descrizione del codice IVA
		REPLACE pivaperc  				with WPERCIVA	&& Percentuale IVA
		REPLACE pivatipo  				with WTIPOIVA	&& Tipo IVA ( SE = "I" è INDEDUCIBILE )
		REPLACE pivaperI  				with WPERCIVA_I	&& Percentuale di INDEDUCIBILITA'
	  	REPLACE FATNOT 					with WFATNOT    && FATTURA / NOTA CREDITO
	  	REPLACE DTFATT					with WDTFATT    && DATA DOCUMENTO
	  	REPLACE NUMDOC					with WNUMDOC    && NUMERO DOCUMENTO				
	  	REPLACE TOP  					with WTOPDOC	&& TIPO OPERAZIONE DOCUMENTO				
	  	REPLACE CLIFOR					with "F"	    && FORNITORE
		&& INIZIO ESTERO #################################################################################
		  && PERSONA FISICA -----------------------------------------------------------------------
		  REPLACE COGNOME 				WITH WCOGNOME		&& OBBLIGATORIO SE PERSONA FISICA
		  REPLACE NOME 					WITH WNOME			&& OBBLIGATORIO SE PERSONA FISICA
		  REPLACE DTNASCITA 			WITH __DATANASCITA 	&& OBBLIGATORIO SE PERSONA FISICA
		  REPLACE COMUNENAS 			WITH WCOMUNESTNAS  	&& OBBLIGATORIO SE PERSONA FISICA
		  REPLACE PROVINAS 				WITH WPROVINAS	 	&& OBBLIGATORIO SE PERSONA FISICA - GESTITA NEL FORM
		  REPLACE STATODOM 				WITH WSTATOESTDOM  	&& CODICE STATO COME DA MODELLO "UNICO"
		  && PERSONA GIURIDICA --------------------------------------------------------------------
		  REPLACE DENOMINAZ 			WITH WRAGSOC		&& OBBLIGATORIO SE PERSONA GIURIDICA
		  REPLACE CITTALEG				WITH WCITTAESTERO	&& NON OBBLIGATORIO
		  REPLACE STATOLEG 				WITH WSTATOESTLEG	&& CODICE STATO COME DA MODELLO "UNICO"
		  REPLACE INDIREST 				WITH WINDESTERO		&& NON OBBLIGATORIO
		&& FINE ESTERO ###################################################################################	  
		REPLACE valore  				with ValoreTot
		REPLACE imponi  				with Imponibile
		REPLACE Iva     				with Imposta
		REPLACE imponi_indeducibile 	WITH imponibile_indeducibile
		REPLACE iva_indeducibile 		WITH imposta_indeducibile
		REPLACE esenz  					with __totArt10			
		REPLACE art8  					with __totArt8			
		REPLACE art8bis 				with __totArt8bis
		REPLACE art9  					with __totArt9
		REPLACE art40  					with __totArt40
		REPLACE art41  					with __totArt41
		REPLACE art52  					with __totArt52
		REPLACE art72  					with __totArt72
		REPLACE altrees					with __totAltro			
		
	ENDIF
	
	REPLACE FLAG_SEZIONE WITH __FLAG_SEZIONE
	
	SELECT IVA
    SKIP +1

ENDDO


*SELECT * from CUR_SPESOMETRO where valore <> 0 order by ragsoc into cursor CUR_SPESOMETRO
SELECT CUR_SPESOMETRO
GO TOP

RETURN




**********************************************************************************
** RIPARTISCE il valore dell' imponibile e/o esenzioni per ogni movimento iva   **
** 
** solo per fornitori
**
**********************************************************************************
PROCEDURE RIPARTIZIONE_IMPONIBILI_ESENZIONI_FORNITORI

__moviva = alltrim(IVA.IVF_CODIVA)
__E_INDEDUCIBILE= .F.

IF "*" $ __moviva
	__E_INDEDUCIBILE= .T.
ENDIF

IF IVA.IVF_IND100="S"
	__E_INDEDUCIBILE= .T.
ENDIF

__imponibile_indeducibile	= 0
__imposta_indeducibile		= 0	
__imponibile_deducibile		= 0
__imposta_deducibile		= 0	
      		 		
IF __E_INDEDUCIBILE		&& iva indeducibile
	__imponibile_indeducibile   = IVA.IVF_IMPONI
	__imposta_indeducibile		= IVA.IVF_IMPOST
ELSE
	__imponibile_deducibile   	= IVA.IVF_IMPONI
	__imposta_deducibile		= IVA.IVF_IMPOST
ENDIF

__classIva = classiva(__moviva)
  
  

     		 	      
DO CASE
    
		CASE __classIva = 1
    		__totArt10 = __totArt10 + (WTOTIM)    	&& ESENZIONE ARTICOLO 10
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
 
    	CASE __classIva = 2
    		__totArt8 = __totArt8 + (WTOTIM)			&& NON IMPONIBILE ARTICOLO 8 
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 3
    		__totArt8bis = __totArt8bis + (WTOTIM)	&& NON IMPONIBILE ARTICOLO 8-BIS
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 4
    		__totArt9 = __totArt9 + (WTOTIM)			&& NON IMPONIBILE ARTICOLO 9
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 5
    		__totArt40 = __totArt40 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 40
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 6
    		__totArt41 = __totArt41 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 41
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 7
    		__totArt52 = __totArt52 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 52
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 8
    		__totArt72 = __totArt72 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 72
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					
    		      		 			
    	CASE __classIva = 9
    		__totAltro = __totAltro + (WTOTIM)		&& ALTRE ESENZIONI NON IN ELENCO CLIENTI / FORNITORI
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ALTRO        with ALTRO    + (WTOTIM)
			ENDIF	      		 					

    		      		 				
    	OTHERWISE
   			imponibile_indeducibile = imponibile_indeducibile + (__imponibile_indeducibile)								&& IMPONIBILE INDEDUCIBILE
   			imposta_indeducibile 	= imposta_indeducibile + (__imposta_indeducibile)
   			Imponibile 				= Imponibile + (__imponibile_deducibile)		&& IMPONIBILE al netto dell'imponibile indeducibile e dell'imposta indeducibile
   			Imposta 				= Imposta 	 + (__imposta_deducibile)		
    		
    			
			select dividiAliquota
			set order to pAli
			go top
   			SEEK __moviva
   			IF FOUND()
				REPLACE Impo_NO_D  with Impo_NO_D + (__imponibile_indeducibile)   	
				REPLACE Iva_NO_D   with Iva_NO_D + (__imposta_indeducibile)
				REPLACE Impo_DED   with Impo_DED + (__imponibile_deducibile)
				REPLACE Iva_DED    with Iva_DED + (__imposta_deducibile)		
			ENDIF	      		 					

    	
ENDCASE
  		 		     
RETURN

*###################################################################################


*###################################################################################
***
***    C L I E N T I 
***
*###################################################################################
PROCEDURE CLIENTI    
*###################################################################################

LPARAMETERS __FATTURA_O_NOTACREDITO
__FTNC = ALLTRIM(__FATTURA_O_NOTACREDITO)


SET NEAR OFF
SET EXACT ON
SET EXCLUSIVE OFF

SELECT U_IVA_CL
HH=AFIELDS(TRANSIVC)
CREATE CURSOR IVA FROM ARRAY TRANSIVC
INDEX ON VAL(IVA_NUMDOC) TAG I_NDOC

SELECT U_IVA_CL
SET ORDER TO DATAFATT
GO TOP

CTRELAB = 0


DO WHILE !EOF()       && CARICA I RECORD PRINCIPALI DI FATTURAZIONE

  ** Salto tutti i record DIVERSI DAL PARAMETRO PASSATO IN INPUT ALLA PROCEDURA
  IF (ALLTRIM(IVA_FATNOT) != ALLTRIM(__FTNC))
    SELECT U_IVA_CL
    SKIP +1
    LOOP
  ENDIF

  SELECT U_IVA_CL
  _CODICE=ALLTRIM(IVA_CODCLI)
  _CODIVA=ALLTRIM(IVA_CODIVA)
  
  SELECT CLIENTI_SPESOMETRO
  SET ORDER TO CLI_CODCLI
  SEEK _CODICE
  
  IF FOUND() AND !EMPTY(SELEZIONE)
	  SELECT U_IVA_CL
	  SKIP 
	  LOOP
  ENDIF

  *** VERIFICA SE CODICE IVA DA CONSIDERARE
  SELECT IVA_SPESOMETRO 
  SET ORDER TO CODICE
  SEEK _CODIVA
  
  IF !FOUND() OR EMPTY(SELEZIONE)
	  SELECT U_IVA_CL
	  SKIP 
	  LOOP
  ENDIF  
  
  SELECT U_IVA_CL

  SCATTER MEMVAR MEMO	    && Salva i vecchi valori
  SELECT IVA
  APPEND BLANK
  GATHER MEMVAR MEMO		&& Salva le modifiche

  CTRELAB=CTRELAB+1 
  WAIT WINDOW "Movimenti CLIENTI - "+ALLTRIM(STR(CTRELAB)) NOWAIT

  SELECT U_IVA_CL
  SKIP

ENDDO


CT = 0
SELECT IVA
SET ORDER TO I_NDOC
GO TOP


*************************
* INIZIA L'ELABORAZIONE *
*************************
DO WHILE !EOF()
	
	ANNO   	= IVA_ANNO
  	WCONTO 	= IVA_CODCLI
  	WCODCLI = IVA_CODCLI
  	__FLAG_SEZIONE = FLAG_SEZIONE

  	CT = CT + 1

  	_NUMDOC     = IVA_NUMDOC
  	_ANNO       = IVA_ANNO
  	
  	WCODIVA	= IVA_CODIVA  && ERASMO - 05/04/2017

	IF (__FTNC == "F")
		WAIT WINDOWS "Fattura CLIENTE elaborata n. " + _NUMDOC     NOWAIT	
	ELSE
		WAIT WINDOWS "Nota Variazione CLIENTE elaborata n. " + _NUMDOC     NOWAIT	
	ENDIF

	___RAGSOC= IVA_RAGSOC  	
  
  	** Prelevo i dati anagrafici dei clienti (dati non contabili)
    SELECT U_CLI_AN
    SET ORDER TO U_CLI_AN
    GO TOP

    WCOD = ALLTRIM(WCODCLI)

    SEEK PUB_CODSOC+ALLTRIM(WCOD)
    
    IF FOUND()
    
      WRAGSOC   = CLI_RAGLEG
	  IF EMPTY(WRAGSOC)	      
	      WRAGSOC   = CLI_RAGSOC
	  ENDIF
	  
      WINDIRI   = CLI_INDLEG
	  IF EMPTY(WINDIRI)	      
	      WINDIRI = CLI_INDIR
	  ENDIF
	  
      WLOCALI   = CLI_LOCLEG
	  IF EMPTY(WLOCALI)	      
	      WLOCALI = CLI_LOCALI
	  ENDIF
	  
      WCAP      = CLI_CAPLEG
	  IF EMPTY(WCAP)	      
	      WCAP = CLI_CAP
	  ENDIF
	  
      WPARIVA   = CLI_PIVALG
	  IF EMPTY(WPARIVA)	      
	      WPARIVA   = CLI_PARIVA
	      *IF EMPTY(CLI_PARIVA) AND ALLTRIM(LEN(CLI_CODFIS))=11
	      IF EMPTY(CLI_PARIVA) AND LEN(ALLTRIM(CLI_CODFIS))=11
		      WPARIVA   = CLI_CODFIS
	      ENDIF	      
	  ENDIF
	  
	  WCODFIS   = CLI_RECCDF
	  IF EMPTY(WCODFIS)	      
	      WCODFIS   = CLI_CFISLG
		  IF EMPTY(WCODFIS)	      
		      WCODFIS   = CLI_CODFIS
		  ENDIF
	  ENDIF	  

      WNAZION   = CLI_NAZLEG
	  IF EMPTY(WNAZION)	      
	      WNAZION   = CLI_NAZION
	  ENDIF

	  *** GESTIONE IVA CEE
      WIVCELG   = CLI_IVCELG
	  IF EMPTY(WIVCELG)	      
	      WIVCELG   = CLI_IVACEE
	  ENDIF      
	  
	  WPROVI    = CLI_PROLEG
	  IF EMPTY(WPROVI)	      
	      WPROVI = CLI_PROVIN
	  ENDIF
	  
      *WCODIVA	= CLI_CODIVA

	  WTIPOSOGGETTO = ALLTRIM(STR(CLI_RECCAT))  
      WCOGNOME      = cli_reccog
      WNOME		    = cli_recnom
      WDATANAS  	= CLI_ESTNAS  
	  WPROVINAS     = CLI_PRONAS                 
      WCOMUNESTNAS  = CLI_ESTCOM
      WSTATOESTDOM  = CLI_ESTDOM      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
      WSTATOESTLEG  = CLI_ESTNAZ      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
      *WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
      *WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<
      WCITTAESTERO	= WLOCALI  && ERASMO/FABIANO - 05/09/2016 
      WINDESTERO	= WINDIRI  && ERASMO/FABIANO - 05/09/2016     
      

    ELSE
    
      *** NON L'HO TROVATO
      *** CERCO PER RAGIONE SOCIALE
	  SELECT U_CLI_AN
	  SET ORDER TO U_CLI_RG
	  GO TOP
	  *SEEK PUB_CODSOC+ALLTRIM(___RAGSOC)
	  SEEK PUB_CODSOC+SUBSTR(ALLTRIM(___RAGSOC),1,50)  && ERASMO - 08/04/2016
      
	  IF FOUND()
	  
	      WRAGSOC   = CLI_RAGLEG
		  IF EMPTY(WRAGSOC)	      
	    	  WRAGSOC   = CLI_RAGSOC
		  ENDIF
	  
    	  WINDIRI   = CLI_INDLEG
		  IF EMPTY(WINDIRI)	      
		      WINDIRI = CLI_INDIR
		  ENDIF
	  
    	  WLOCALI   = CLI_LOCLEG
		  IF EMPTY(WLOCALI)	      
		      WLOCALI = CLI_LOCALI
		  ENDIF
	  
	      WCAP      = CLI_CAPLEG
		  IF EMPTY(WCAP)	      
		      WCAP = CLI_CAP
		  ENDIF
	  
	      WPARIVA   = CLI_PIVALG
		  IF EMPTY(WPARIVA)	      
		      WPARIVA   = CLI_PARIVA
		      *IF EMPTY(CLI_PARIVA) AND ALLTRIM(LEN(CLI_CODFIS))=11
		      IF EMPTY(CLI_PARIVA) AND LEN(ALLTRIM(CLI_CODFIS))=11
			      WPARIVA   = CLI_CODFIS
		      ENDIF
		      
		  ENDIF
	  
		  WCODFIS   = CLI_RECCDF
		  IF EMPTY(WCODFIS)	      
		      WCODFIS   = CLI_CFISLG
			  IF EMPTY(WCODFIS)	      
			      WCODFIS   = CLI_CODFIS
			  ENDIF
		  ENDIF	  
	  
	      WNAZION   = CLI_NAZLEG
		  IF EMPTY(WNAZION)	      
		      WNAZION   = CLI_NAZION
		  ENDIF
	  
	      *WCODIVA	= CLI_CODIVA

		  *** GESTIONE IVA CEE
	      WIVCELG   = CLI_IVCELG
		  IF EMPTY(WIVCELG)	      
		      WIVCELG   = CLI_IVACEE
		  ENDIF      
      
		  WPROVI    = CLI_PROLEG
		  IF EMPTY(WPROVI)	      
		      WPROVI = CLI_PROVIN
		  ENDIF

	  	  WTIPOSOGGETTO = ALLTRIM(STR(CLI_RECCAT))  
	      WCOGNOME      = cli_reccog
	      WNOME		    = cli_recnom
     	  WDATANAS  	= CLI_ESTNAS   
		  WPROVINAS     = CLI_PRONAS            	     
	      WCOMUNESTNAS  = CLI_ESTCOM
	      WSTATOESTDOM  = CLI_ESTDOM      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
	      WSTATOESTLEG  = CLI_ESTNAZ      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
	      *WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
	      *WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<
	      WCITTAESTERO	= WLOCALI  && ERASMO/FABIANO - 05/09/2016 
	      WINDESTERO	= WINDIRI  && ERASMO/FABIANO - 05/09/2016   


	  ELSE      
	      
	      *** NON L'HO TROVATO NEANCHE PER RAGIONE SOCIALE
	      *** USO I CAMPI SUL CURSOR IVA GIA' VALORIZZATI
	      *** MI ACCORGO CHE SONO IN QUESTO CASO PERCHE' NEL DETTAGLIO
	      *** DEL CLIENTE MANCA IL CAMPO IVA E CODICE FISCALE
	      *** CHE QUI VALORIZZO A ""
	      *** 
	      SELECT IVA
      
    	  WRAGSOC   = IVA_RAGSOC
	      WINDIRI   = IVA_INDIRI
	      WLOCALI   = IVA_LOCALI
	      WCAP      = IVA_CAP
	      WPARIVA   = IVA_PARIVA
	      WCODFIS   = ""
		  *WCODIVA	= ""      
		  WPROVI    = ""
		  
	  	  WTIPOSOGGETTO = ""
	      WCOGNOME      = ""
	      WNOME		    = ""
     	  WDATANAS  	= ""
		  WPROVINAS     = ""
	      WCOMUNESTNAS  = ""
	      WSTATOESTDOM  = ""      && STATO ESTERO DOMICILIO (NUMERICO 3 CHR - MODELLO "UNICO")
	      WSTATOESTLEG  = ""      && STATO ESTERO SEDE LEGALE (NUMERICO 3 CHR - MODELLO "UNICO")
	      WCITTAESTERO	= ""	  && CITTA ESTERA >>> NON OBBLIGATORIO <<<      
	      WINDESTERO	= ""	  && INDIRIZZO ESTERO >>> NON OBBLIGATORIO <<<
		  
		  
	   ENDIF
	   
	ENDIF

	SELECT PARA
	SET ORDER TO CODICE
	SEEK 'IVA'+WCODIVA
	IF FOUND()
		WDESIVA	   = alltrim(DESCRI)			&& Descrizione del codice IVA
		WPERCIVA   = VAL(SUBSTR(LIBERA,1,3))	&& Percentuale IVA
		WPERCIVACHR= SUBSTR(LIBERA,1,3)			&& CARATTERE Percentuale IVA		
  		WTIPOIVA   = SUBSTR(LIBERA,100,1)		&& Tipo IVA ( SE = "I" è INDEDUCIBILE )
  		WPERCIVA_I = VAL(SUBSTR(LIBERA,110,3))  && Percentuale di INDEDUCIBILITA'		
	ELSE
		WDESIVA	   = ''  && Descrizione del codice IVA
  		WPERCIVA   = 0	 && PERCENTUALE IVA INESISTENTE (caso assurdo) ???
		WPERCIVACHR= ''  && CARATTERE PERCENTUALE IVA INESISTENTE (caso assurdo) ???  		
	  	WTIPOIVA   = ''	 && Non ha il valore che mi interessa : "I" di indeducibile
  		WPERCIVA_I = 0	 && Non ha valore se non esiste la "I" di indeducibile
	ENDIF


	SELECT IVA
    
	*** AZZERA LE VARIABILI USATE PER LA STAMPA
	
	Imponibile 				= 0
	Imposta    				= 0
	ValoreTot  				= 0
	imponibile_indeducibile	= 0
	imposta_indeducibile	= 0
	
	__totArt10 		= 0
	__totArt8 		= 0
	__totArt8bis 	= 0
	__totArt9 		= 0
	__totArt40		= 0
	__totArt41 		= 0
	__totArt52 		= 0
	__totArt72 		= 0
	__totAltro 		= 0
	

	WTOTIM      = IVA_IMPONI
	WTOTIMPO    = IVA_IMPOST

	
	WFATNOT	  = ALLTRIM(IVA_FATNOT)			    												&& FATTURA / NOTA CREDITO
	_datafatt = RIBALTA2(ALLTRIM(IVA_DTFATT))
	WDTFATT	  = SUBSTR(_datafatt,1,2) + SUBSTR(_datafatt,4,2) + SUBSTR(_datafatt,7,4)		    && DATA DOCUMENTO
	WNUMDOC	  = PADR(ALLTRIM(IVA_NUMDOC),15,' ')						 			    		&& NUMERO DOCUMENTO			
	WTOPDOC	  = ALLTRIM(IVA_TOP)			    												&& TIPO OPERAZIONE			
	IF !EMPTY(ALLTRIM(WDATANAS))
		__DATANASCITA = SUBSTR(WDATANAS,1,2) + SUBSTR(WDATANAS,4,2) + SUBSTR(WDATANAS,7,4)
	ELSE	
		__DATANASCITA = SPACE(8)
	ENDIF	

	ValoreTot  = WTOTIM 

      		
	DO RIPARTIZIONE_IMPONIBILI_ESENZIONI_CLIENTI		   		


	** Salvo nel mio cursore finale i totali calcolati
	SELECT CUR_SPESOMETRO
	APPEND BLANK
	REPLACE TIPOSOGGETTO 		    WITH WTIPOSOGGETTO	
	REPLACE codcli  				with WCOD
	REPLACE ragsoc  				with WRAGSOC	
	REPLACE indiri  				with WINDIRI
	REPLACE locali  				with WLOCALI
	REPLACE cap						with WCAP
	REPLACE provi					with WPROVI
	REPLACE nazione 				with WNAZION
	IF !EMPTY(ALLTRIM(WPARIVA))
		REPLACE pariva  			with WPARIVA
	ELSE	
		REPLACE pariva  			with WIVCELG			    && PARTITA IVA CEE
	ENDIF	
	REPLACE codfis  				with WCODFIS
	REPLACE pivacod					with WCODIVA	&& Codice IVA
	REPLACE pivades  				with WDESIVA	&& Descrizione del codice IVA
	REPLACE pivaperc  				with WPERCIVA	&& Percentuale IVA
	REPLACE pivatipo  				with WTIPOIVA	&& Tipo IVA ( SE = "I" è INDEDUCIBILE )
	REPLACE pivaperI  				with WPERCIVA_I	&& Percentuale di INDEDUCIBILITA'
	REPLACE FATNOT 					with WFATNOT    && FATTURA / NOTA CREDITO
	REPLACE DTFATT					with WDTFATT    && DATA DOCUMENTO
	REPLACE NUMDOC					with WNUMDOC    && NUMERO DOCUMENTO				
	REPLACE TOP  					with WTOPDOC	&& TIPO OPERAZIONE DOCUMENTO				
	REPLACE CLIFOR					with "C"	    && CLIENTE
	&& INIZIO ESTERO #################################################################################
	&& PERSONA FISICA -----------------------------------------------------------------------
	REPLACE COGNOME 				WITH WCOGNOME		&& OBBLIGATORIO SE PERSONA FISICA
	REPLACE NOME 					WITH WNOME			&& OBBLIGATORIO SE PERSONA FISICA
	REPLACE DTNASCITA 				WITH __DATANASCITA 	&& OBBLIGATORIO SE PERSONA FISICA
	REPLACE COMUNENAS 				WITH WCOMUNESTNAS  	&& OBBLIGATORIO SE PERSONA FISICA
	REPLACE PROVINAS 				WITH WPROVINAS 		&& OBBLIGATORIO SE PERSONA FISICA - GESTITA NEL FORM
	REPLACE STATODOM 				WITH WSTATOESTDOM  	&& CODICE STATO COME DA MODELLO "UNICO"
	&& PERSONA GIURIDICA --------------------------------------------------------------------
	REPLACE DENOMINAZ 				WITH WRAGSOC		&& OBBLIGATORIO SE PERSONA GIURIDICA
	REPLACE CITTALEG				WITH WCITTAESTERO	&& NON OBBLIGATORIO
	REPLACE STATOLEG 				WITH WSTATOESTLEG	&& CODICE STATO COME DA MODELLO "UNICO"
	REPLACE INDIREST 				WITH WINDESTERO		&& NON OBBLIGATORIO
	&& FINE ESTERO ###################################################################################	  
	REPLACE valore  				with ValoreTot
	REPLACE imponi  				with Imponibile
	REPLACE Iva     				with Imposta
	REPLACE imponi_indeducibile 	WITH imponibile_indeducibile
	REPLACE iva_indeducibile 		WITH imposta_indeducibile
	REPLACE esenz  					with __totArt10			
	REPLACE art8  					with __totArt8			
	REPLACE art8bis 				with __totArt8bis
	REPLACE art9  					with __totArt9
	REPLACE art40  					with __totArt40
	REPLACE art41  					with __totArt41
	REPLACE art52  					with __totArt52
	REPLACE art72  					with __totArt72
	REPLACE altrees					with __totAltro			
	
	REPLACE FLAG_SEZIONE WITH __FLAG_SEZIONE
			
	SELECT IVA
    SKIP +1

ENDDO


*SELECT * from CUR_SPESOMETRO where valore <> 0 order by ragsoc into cursor CUR_SPESOMETRO
SELECT CUR_SPESOMETRO
GO TOP

RETURN



**********************************************************************************
** RIPARTISCE il valore dell' imponibile e/o esenzioni per ogni movimento iva   **
** 
** solo per CLIENTI
**
**********************************************************************************
PROCEDURE RIPARTIZIONE_IMPONIBILI_ESENZIONI_CLIENTI

__moviva = alltrim(IVA.IVA_CODIVA)
__E_INDEDUCIBILE= .F.

IF "*" $ __moviva
	__E_INDEDUCIBILE= .T.
ENDIF


__imponibile_indeducibile	= 0
__imposta_indeducibile		= 0	
__imponibile_deducibile		= 0
__imposta_deducibile		= 0	
      		 		
IF __E_INDEDUCIBILE		&& iva indeducibile
	__imponibile_indeducibile   = IVA.IVA_IMPONI
	__imposta_indeducibile		= IVA.IVA_IMPOST
ELSE
	__imponibile_deducibile   	= IVA.IVA_IMPONI
	__imposta_deducibile		= IVA.IVA_IMPOST
ENDIF

__classIva = classiva(__moviva)
  
DO CASE
    
		CASE __classIva = 1
    		__totArt10 = __totArt10 + (WTOTIM)    	&& ESENZIONE ARTICOLO 10
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
 
    	CASE __classIva = 2
    		__totArt8 = __totArt8 + (WTOTIM)			&& NON IMPONIBILE ARTICOLO 8 
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 3
    		__totArt8bis = __totArt8bis + (WTOTIM)	&& NON IMPONIBILE ARTICOLO 8-BIS
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 4
    		__totArt9 = __totArt9 + (WTOTIM)			&& NON IMPONIBILE ARTICOLO 9
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 5
    		__totArt40 = __totArt40 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 40
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 6
    		__totArt41 = __totArt41 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 41
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 7
    		__totArt52 = __totArt52 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 52
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 8
    		__totArt72 = __totArt72 + (WTOTIM)		&& NON IMPONIBILE ARTICOLO 72
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM)
			ENDIF	      		 					
    		      		 			
    	CASE __classIva = 9
    		__totAltro = __totAltro + (WTOTIM)		&& ALTRE ESENZIONI NON IN ELENCO CLIENTI / FORNITORI
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ALTRO        with ALTRO    + (WTOTIM)
			ENDIF	      		 					

    		      		 				
    	OTHERWISE
   			imponibile_indeducibile = imponibile_indeducibile + __imponibile_indeducibile								&& IMPONIBILE INDEDUCIBILE
   			imposta_indeducibile 	= imposta_indeducibile + __imposta_indeducibile
   			Imponibile 				= Imponibile + __imponibile_deducibile		&& IMPONIBILE al netto dell'imponibile indeducibile e dell'imposta indeducibile
   			Imposta 				= Imposta 	 + __imposta_deducibile		
    		
    			
			select dividiAliquota
			set order to pAli
			go top
   			SEEK __moviva
   			IF FOUND()
				REPLACE Impo_NO_D  with Impo_NO_D + __imponibile_indeducibile   	
				REPLACE Iva_NO_D   with Iva_NO_D + __imposta_indeducibile
				REPLACE Impo_DED   with Impo_DED + __imponibile_deducibile
				REPLACE Iva_DED    with Iva_DED + __imposta_deducibile		
			ENDIF	      		 					

    	
ENDCASE
  		 		     
RETURN



*###################################################################################


**********************************************************************************
** Funzione per la determinazione della classe di appartenenza del codice IVA	**
** che verrà riportato nell'elenco Clienti/Fornitori							**
**********************************************************************************
FUNCTION CLASSIVA
**********************************************************************************

PARA _CODIVA

PRIVATE ___SELECT_TEMP

___SELECT_TEMP=SELECT()

SELECT PARA
SET ORDER TO CODICE

SEEK 'IVA'+_CODIVA
IF FOUND()
  _VALRIT  = VAL(CLASSIVA)
  IF VAL(CLASSIVA) = 9
  	_DESC = ALLTRIM(DESCRI)
  	SELECT ELENCOALTRO
  	APPEND BLANK
  	REPLACE CODICEALTRO WITH ALLTRIM(_CODIVA) + " - "+ _DESC + ";"
  ENDIF
ELSE
  _VALRIT = 10   && ASSUME IL VALORE DI "NESSUNA CLASSIFICAZIONE" SUL FORM PARA006
ENDIF

SELECT(___SELECT_TEMP)

RETURN _VALRIT



********************************************
PROCEDURE SELECT_BOLLATI
********************************************
*** ESTRAI FATTURATO DA BOLLATI CLI/FOR
********************************************


DATA_DA = RIBALTA2(DATADAL)
DATA_A  =  RIBALTA2(DATAAL)
ANNO_DA = substr(data_da,1,4)
MESE_DA = substr(data_da,6,2)
MESE_A  = substr(data_a,6,2)

*!*	cSql = "SELECT * FROM U_IVA_CL WHERE IVA_DTFATT BETWEEN '"+DATA_DA+"' AND '"+DATA_A+"' AND IVA_BOLLATOIVA<>'F'"
*!*	IF !ExecCommand(cSql,"U_IVA_CL")
*!*	   RETURN .F.
*!*	ENDIF
*!*	SELECT U_IVA_CL
*!*	INDEX ON IVA_CODSOC+IVA_ANNO+IVA_MESE TAG ANNOMESE ADDITIVE
*!*	INDEX ON IVA_CODSOC+IVA_DTFATT TAG DATAFATT ADDITIVE 
  
*!*	cSql = "select * from U_IVF_CL WHERE IVF_DTFATT BETWEEN '"+DATA_DA+"' AND '"+DATA_A+"' "
*!*	IF !ExecCommand(cSql,"U_IVF_CL")
*!*	   RETURN .F.
*!*	ENDIF
*!*	SELECT U_IVF_CL
*!*	INDEX ON IVF_CODSOC+IVF_ANNO+IVF_MESE TAG ANNOMESE ADDITIVE
*!*	INDEX ON IVF_CODSOC+IVF_DTFATT TAG DATAFATT ADDITIVE 

**=> ERASMO/FABIANO - INIZIO 07/04/2016
*** EVITO DI FARE TEST SU BLACK LIST
*** INTEGRO IL TUTTO DIRETTAMENTE SULLE SELECT DEI BOLLATI

***********************************************************************
*** CLIENTI ITALIA CON IVA<>0
***********************************************************************
cSql = 	"SELECT * FROM (" + CHR(13) + ;
		"SELECT 'FA' AS FLAG_SEZIONE, * FROM U_IVA_CL WHERE  " + CHR(13) + ;
		"	IVA_CODCLI IN (SELECT CLI_CODCLI FROM U_CLI_AN WHERE CLI_NAZION = 'ITA' OR CLI_NAZION = 'IT') " + CHR(13) + ;
		"	AND (IVA_ALIQUO <> 0 OR IVA_CODIVA IN (SELECT SUBSTRING(CODICE,4,3) FROM PARA WHERE SUBSTRING(INGLESE,1,39) = 'FORZA_INCLUSIONE_IVA_IN_SPESOMETRO_2013'))" + CHR(13) + ;
		"	AND IVA_BOLLATOIVA<>'F' " + CHR(13) + ;
		") AS T1 " + CHR(13) + ;
		"WHERE IVA_DTFATT BETWEEN '"+DATA_DA+"' AND '"+DATA_A+"' " + ;
		"AND IVA_FCHIUS=0 "  && ERASMO-FABIANO - 10/02/2017
*IF !ExecCommand(cSql,"S_IVA_CL")
IF !ExecCommand(cSql,"S_IVA_CL")  && ERASMO - 02/09/2016
   RETURN .F.
ENDIF
*!*	SELECT U_IVA_CL
*!*	INDEX ON IVA_CODSOC+IVA_ANNO+IVA_MESE TAG ANNOMESE ADDITIVE
*!*	INDEX ON IVA_CODSOC+IVA_DTFATT TAG DATAFATT ADDITIVE 


***********************************************************************
*** FORNITORI CEE DA CUI HO ACQUISTATO SERVIZI E NON ENTRATI IN INTRA  
*** UNION
*** FORNITORI ITALIA CON IVA<>0
*** UNION
*** FORNITORI ESTERI DI SERVIZI EXTRACEE NON BLACKLIST CON ALIQUOTA <>0
***********************************************************************
cSql = 	"SELECT 0 AS IVA_REVERSE,* FROM (" + CHR(13) + ;
		"SELECT 'BL' AS FLAG_SEZIONE, * FROM U_IVF_CL WHERE " + CHR(13) + ;
		"	IVF_CODIVA NOT IN (SELECT SUBSTRING(CODICE,4,3) FROM PARA WHERE SUBSTRING(LIBERA,1,3) = '000' OR ITALIANO LIKE '%INTRASTAT%') " + CHR(13) + ;
		"	AND IVF_CODCLI IN (SELECT FOR_CODCLI FROM U_FOR_AN WHERE FOR_NAZION <> 'ITA' AND FOR_NAZION <> 'IT' AND (SELECT NOTE FROM PARA WHERE CODICE = 'GENCE') LIKE '%'+RTRIM(U_FOR_AN.FOR_NAZION)+'%') " + CHR(13) + ;
		"	AND IVF_ALIQUO <> 0 " + CHR(13) + ;
		"	AND CAST(IVF_CHIAVE AS VARCHAR(10)) NOT IN (SELECT MOV_NPROT FROM MOV_CONT WHERE SUBSTRING(MOV_CONTO,"+ALLTRIM(STR(PUB_SOTTOG+1,1,0))+",10) = U_IVF_CL.IVF_CODCLI  " + CHR(13) + ;
		"      AND MOV_DTDOC = U_IVF_CL.IVF_DTFATT AND MOV_NUMPRO IN (SELECT LEG_NUMPRO FROM U_BFO_LE)) " + CHR(13) + ;
		"UNION " + CHR(13) + ;
		"SELECT 'FA' AS FLAG_SEZIONE, * FROM U_IVF_CL WHERE  " + CHR(13) + ;
		"	IVF_CODCLI IN (SELECT FOR_CODCLI FROM U_FOR_AN WHERE FOR_NAZION = 'ITA' OR FOR_NAZION = 'IT') " + CHR(13) + ;
		"	AND (IVF_ALIQUO <> 0 OR IVF_CODIVA IN (SELECT SUBSTRING(CODICE,4,3) FROM PARA WHERE SUBSTRING(INGLESE,1,39) = 'FORZA_INCLUSIONE_IVA_IN_SPESOMETRO_2013'))" + CHR(13) + ;
		" " + CHR(13) + ;
		"UNION  " + CHR(13) + ;
		" " + CHR(13) + ;
		"SELECT 'BL' AS FLAG_SEZIONE, * FROM U_IVF_CL WHERE  " + CHR(13) + ;
		"	IVF_CODIVA NOT IN (SELECT SUBSTRING(CODICE,4,3) FROM PARA WHERE SUBSTRING(LIBERA,1,3) = '000' OR ITALIANO LIKE '%INTRASTAT%')  " + CHR(13) + ;
		"	AND IVF_CODCLI IN (SELECT FOR_CODCLI FROM U_FOR_AN WHERE FOR_NAZION IN ( " + CHR(13) + ;
		"		SELECT NAZIONE FROM ( " + CHR(13) + ;
		"			SELECT SUBSTRING(PARA.CODICE,4,3) AS NAZIONE, NAZIONI_UNICO.*, CASE WHEN (SELECT NOTE FROM PARA WHERE CODICE = 'GENCE') LIKE '%'+RTRIM(SUBSTRING(PARA.CODICE,4,3))+'%' THEN 'S' ELSE ' ' END AS CEE " + CHR(13) + ;
		"			FROM NAZIONI_UNICO " + CHR(13) + ;
		"			LEFT OUTER JOIN PARA ON PARA.CODICE LIKE 'STA%' AND PARA.DTIPOMOV = NAZIONI_UNICO.CODICE " + CHR(13) + ;
		"			) AS MAIN " + CHR(13) + ;
		"		WHERE BLACK <> 'X' AND CEE <> 'S')) " + CHR(13) + ;
		"	AND IVF_ALIQUO <> 0 " + CHR(13) + ;
		"	AND CAST(IVF_CHIAVE AS VARCHAR(10)) NOT IN (SELECT MOV_NPROT FROM MOV_CONT WHERE SUBSTRING(MOV_CONTO,"+ALLTRIM(STR(PUB_SOTTOG+1,1,0))+",10) = U_IVF_CL.IVF_CODCLI  " + CHR(13) + ;
		"      AND MOV_DTDOC = U_IVF_CL.IVF_DTFATT AND MOV_NUMPRO IN (SELECT LEG_NUMPRO FROM U_BFO_LE)) " + CHR(13) + ;
		") AS T1 " + CHR(13) + ;
		"WHERE IVF_DTFATT BETWEEN '"+DATA_DA+"' AND '"+DATA_A+"' " + ;
		"AND IVF_FCHIUS=0 "  && ERASMO-FABIANO - 10/02/2017
*IF !ExecCommand(cSql,"U_IVF_CL")
IF !ExecCommand(cSql,"S_IVF_CL")  && ERASMO - 02/09/2016
   RETURN .F.
ENDIF
*!*	SELECT U_IVF_CL
*!*	INDEX ON IVF_CODSOC+IVF_ANNO+IVF_MESE TAG ANNOMESE ADDITIVE
*!*	INDEX ON IVF_CODSOC+IVF_DTFATT TAG DATAFATT ADDITIVE 
**=> ERASMO/FABIANO - FINE 07/04/2016

RETURN


**=> ERASMO - INIZIO 02/09/2016
*************************************************
PROCEDURE SELECT_BOLLATI_BLACKLIST
*************************************************
*** ESTRAI FATTURATO BLACKLIST DA BOLLATI CLI/FOR
*************************************************

DATA_DA = RIBALTA2(DATADAL)
DATA_A  =  RIBALTA2(DATAAL)
ANNO_DA = substr(data_da,1,4)
MESE_DA = substr(data_da,6,2)
MESE_A  = substr(data_a,6,2)

***********************************************************************
*** CLIENTI BLACKLIST
***********************************************************************
cSql = 	"SELECT * FROM (" + CHR(13) + ;
		"SELECT 'B1' AS FLAG_SEZIONE, * FROM U_IVA_CL WHERE  " + CHR(13) + ;
		"	IVA_CODCLI IN (SELECT CLI_CODCLI FROM U_CLI_AN WHERE CLI_NAZION IN ( " + CHR(13) + ;
		"		SELECT NAZIONE FROM ( " + CHR(13) + ;
		"			SELECT SUBSTRING(PARA.CODICE,4,3) AS NAZIONE, NAZIONI_UNICO.*, CASE WHEN (SELECT NOTE FROM PARA WHERE CODICE = 'GENCE') LIKE '%'+RTRIM(SUBSTRING(PARA.CODICE,4,3))+'%' THEN 'S' ELSE ' ' END AS CEE " + CHR(13) + ;
		"			FROM NAZIONI_UNICO " + CHR(13) + ;
		"			LEFT OUTER JOIN PARA ON PARA.CODICE LIKE 'STA%' AND PARA.DTIPOMOV = NAZIONI_UNICO.CODICE " + CHR(13) + ;
		"			) AS MAIN " + CHR(13) + ;
		"		WHERE BLACK = 'X')) " + CHR(13) + ;
		"	AND IVA_BOLLATOIVA<>'F' " + CHR(13) + ;
		") AS T1 " + CHR(13) + ;
		"WHERE IVA_DTFATT BETWEEN '"+DATA_DA+"' AND '"+DATA_A+"' " + ;
		"AND IVA_FCHIUS=0 "  && ERASMO-FABIANO - 10/02/2017
IF !ExecCommand(cSql,"S_IVA_CL")
   RETURN .F.
ENDIF

***********************************************************************
*** FORNITORI BLACKLIST
***********************************************************************
cSql = 	"SELECT COALESCE(CL.IVA_IMPOST,0) AS IVA_REVERSE, T1.* FROM (" + CHR(13) + ;
		"SELECT 'B1' AS FLAG_SEZIONE, * FROM U_IVF_CL WHERE  " + CHR(13) + ;
		"	IVF_CODIVA NOT IN (SELECT SUBSTRING(CODICE,4,3) FROM PARA WHERE ITALIANO LIKE '%INTRASTAT%')  " + CHR(13) + ;
		"	AND IVF_CODCLI IN (SELECT FOR_CODCLI FROM U_FOR_AN WHERE FOR_NAZION IN ( " + CHR(13) + ;
		"		SELECT NAZIONE FROM ( " + CHR(13) + ;
		"			SELECT SUBSTRING(PARA.CODICE,4,3) AS NAZIONE, NAZIONI_UNICO.*, CASE WHEN (SELECT NOTE FROM PARA WHERE CODICE = 'GENCE') LIKE '%'+RTRIM(SUBSTRING(PARA.CODICE,4,3))+'%' THEN 'S' ELSE ' ' END AS CEE " + CHR(13) + ;
		"			FROM NAZIONI_UNICO " + CHR(13) + ;
		"			LEFT OUTER JOIN PARA ON PARA.CODICE LIKE 'STA%' AND PARA.DTIPOMOV = NAZIONI_UNICO.CODICE " + CHR(13) + ;
		"			) AS MAIN " + CHR(13) + ;
		"		WHERE BLACK = 'X')) " + CHR(13) + ;
		") AS T1 " + CHR(13) + ;
		"LEFT OUTER JOIN U_IVA_CL AS CL ON CL.IVA_BOLLATOIVA = 'F' AND CL.IVA_ANNO = T1.IVF_ANNO AND CL.IVA_MESE = T1.IVF_MESE AND CL.IVA_NUMFAT = T1.IVF_NUMFAT AND CL.IVA_CODCLI = (SELECT FOR_CLICEE FROM U_FOR_AN WHERE FOR_CODCLI = T1.IVF_CODCLI)" + CHR(13) + ;
		"WHERE IVF_DTFATT BETWEEN '"+DATA_DA+"' AND '"+DATA_A+"' " + ;
		"AND IVF_FCHIUS=0 "  && ERASMO-FABIANO - 10/02/2017
IF !ExecCommand(cSql,"S_IVF_CL")
   RETURN .F.
ENDIF

RETURN
**=> ERASMO - FINE 02/09/2016


********************************************
PROCEDURE CREA_LISTA_ALIQUOTE
********************************************

CREATE CURSOR DIVIDIALIQUOTA ( ;
	ALIQ C(3), CDIVA C(3), DSIVA C(40), ;
	IMPO_DED N(17,3), IMPO_NO_D N(17,3),;
	IVA_DED N(17,3), IVA_NO_D N(17,3),  ;
	ESE_NOIMP N(17,3), ALTRO N(17,3))
INDEX ON CDIVA TAG PALI


SELECT ;
	DISTINCT SUBSTR(CODICE,4,3) AS CODALIQ, ;
	SUBSTR(LIBERA,1,3) AS PERALIQ, ;
	ALLTRIM(DESCRI) AS DESALIQ ;
FROM PARA ;
WHERE CODICE LIKE 'IVA%' ;
INTO CURSOR LISTAALIQUOTE


SELECT LISTAALIQUOTE

DO WHILE !EOF()

	_PerAliq = perAliq
	_codAliq = codAliq
	_desAliq = desAliq
		
	SELECT DIVIDIALIQUOTA
	APPEND BLANK

	REPLACE CDIVA 		WITH 	_CODALIQ	
	REPLACE DSIVA 		WITH 	_DESALIQ
	REPLACE ALIQ 		WITH 	_PERALIQ	
	REPLACE IMPO_DED	WITH 	0
	REPLACE IMPO_NO_D	WITH 	0
	REPLACE IVA_DED		WITH 	0
	REPLACE IVA_NO_D	WITH 	0			
	REPLACE ESE_NOIMP 	WITH    0
	REPLACE ALTRO 		WITH    0
	
	SELECT LISTAALIQUOTE
	SKIP + 1
ENDDO







********************************************
PROCEDURE SELECT_BLACK_LIST
********************************************

***cSql = "select * from NAZIONI_UNICO WHERE BLACK = 'X'"
cSql = "select * from NAZIONI_UNICO"
IF !ExecCommand(cSql,"BLACK")
   RETURN .F.
ENDIF
SELECT BLACK
INDEX ON CODICE TAG COD ADDITIVE



********************************************
PROCEDURE SELECT_ARCHIVI
********************************************
cSql = "SELECT * FROM PARA"
IF !ExecCommand(cSql,"PARA")
   RETURN .F.
ENDIF
SELECT PARA
INDEX ON CODICE TAG CODICE ADDITIVE


cSql = "SELECT * FROM U_AZI_AN"
IF !ExecCommand(cSql,"U_AZI_AN")
   RETURN .F.
ENDIF
SELECT U_AZI_AN
INDEX ON AZI_CODSOC TAG U_AZI_AN ADDITIVE


cSql = "SELECT * FROM U_FOR_AN"
IF !ExecCommand(cSql,"U_FOR_AN")
   RETURN .F.
ENDIF
SELECT U_FOR_AN
INDEX ON FOR_CODSOC+FOR_CODCLI TAG U_FOR_AN ADDITIVE
*INDEX ON FOR_CODSOC+ALLTRIM(FOR_RAGSOC) TAG U_FOR_RG ADDITIVE
INDEX ON FOR_CODSOC+SUBSTR(ALLTRIM(FOR_RAGSOC),1,50) TAG U_FOR_RG ADDITIVE  && ERASMO - 08/04/2016

cSql = "SELECT * FROM U_CLI_AN"
IF !ExecCommand(cSql,"U_CLI_AN")
   RETURN .F.
ENDIF
SELECT U_CLI_AN
INDEX ON CLI_CODSOC+CLI_CODCLI TAG U_CLI_AN ADDITIVE
*INDEX ON CLI_CODSOC+ALLTRIM(CLI_RAGSOC) TAG U_CLI_RG ADDITIVE
INDEX ON CLI_CODSOC+SUBSTR(ALLTRIM(CLI_RAGSOC),1,50) TAG U_CLI_RG ADDITIVE  && ERASMO - 08/04/2016

**=> ERASMO - INIZIO 02/09/2016
cSql = "SELECT '  ' AS FLAG_SEZIONE, * FROM U_IVA_CL WHERE 1=0"
IF !ExecCommand(cSql,"U_IVA_CL")
   RETURN .F.
ENDIF
SELECT U_IVA_CL
INDEX ON IVA_CODSOC+IVA_ANNO+IVA_MESE TAG ANNOMESE ADDITIVE
INDEX ON IVA_CODSOC+IVA_DTFATT TAG DATAFATT ADDITIVE 

cSql = "SELECT CAST(0 AS NUMERIC(19,2)) AS IVA_REVERSE, '  ' AS FLAG_SEZIONE, * FROM U_IVF_CL WHERE 1=0"
IF !ExecCommand(cSql,"U_IVF_CL")
   RETURN .F.
ENDIF
SELECT U_IVF_CL
INDEX ON IVF_CODSOC+IVF_ANNO+IVF_MESE TAG ANNOMESE ADDITIVE
INDEX ON IVF_CODSOC+IVF_DTFATT TAG DATAFATT ADDITIVE 
**=> ERASMO - FINE 02/09/2016



********************************************
PROCEDURE VERIFICA_SE_ESISTE_PARAMETRO_IVA
********************************************

SELECT U_AZI_AN
SET ORDER TO U_AZI_AN

SEEK PUB_CODSOC
IF FOUND()
  OK_ESECLI = AZI_ARTPUB  && ARTICOLO PUBBLICITARIO
  OK_PROTCL = AZI_PROTCL
ELSE
  OK_ESECLI = .F.  && ARTICOLO PUBBLICITARIO
  OK_PROTCL = -1
  WAIT WINDOW "PER CORTESIA CODIFICA IL PARAMETRO BOLLATI IVA" 
ENDIF



********************************************
PROCEDURE PREFISSO_CONTO_CLIENTI_FORNITORI
********************************************

***CERCA PRIMI 4 CARATTERI DEL CONTO PER IL CLIENTE/FORNITORE
SELECT PARA
SET ORDER TO CODICE

SEEK 'GEN'+PUB_CODSOC
IF !FOUND()
  RIT=MSGBOX("ERRORE MANCA PARAMETRO GEN 4 CARATTERI CONTI CLI",'ATTENZIONE',31)
  RETURN(3)
ENDIF
CCC=SUBSTR(LIBERA,01,PUB_SOTTOG-1)
FFF=SUBSTR(LIBERA,18,PUB_SOTTOG-1)
