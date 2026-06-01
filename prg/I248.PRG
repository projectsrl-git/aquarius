**********************************************************************************************************
**																										**
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

** Creo cursore finale
CREATE CURSOR MyFinalCursor ( codcli C(10), ragsoc C(40), indiri C(30), locali C(30), cap C(5), provi C(4) ,codfis C(16), pariva C(25), nazione C(3) ,valore N(17,3), imponi N(17,3), iva N(17,3),;
							  esenz N(17,3), art8 N(17,3),art8bis N(17,3),art9 N(17,3),art40 N(17,3),art41 N(17,3),art52 N(17,3),art72 N(17,3),altrees N(17,3),imponi_indeducibile N(17,3),iva_indeducibile N(17,3),;
							  pivacod C(3), pivades C(40), pivaperc N(3,0), pivatipo C(1), pivaperI N(3,0) )							  
INDEX ON alltrim(codcli) TAG Cliente
INDEX ON alltrim(ragsoc) TAG DesCli

CREATE CURSOR elencoAltro ( codiceAltro C(50) )

CREATE CURSOR dividiAliquota ( Aliq C(3), cdIVA C(3), dsIVA C(40), Impo_DED N(17,3), Impo_NO_D N(17,3), Iva_DED N(17,3), Iva_NO_D N(17,3), ESE_NOIMP N(17,3), ALTRO N(17,3))
INDEX ON cdIVA TAG pAli

**=> ERASMO - INIZIO 21/03/2007
cSql = "select * from PARA"
IF !ExecCommand(cSql,"PARA")
   RETURN .F.
ENDIF
SELECT PARA
INDEX ON CODICE TAG CODICE ADDITIVE
**=> ERASMO - FINE 21/03/2007

select distinct SUBSTR(codice,4,3) as codAliq, SUBSTR(LIBERA,1,3) as perAliq, alltrim(descri) as desAliq from para where codice like 'IVA%' into cursor listaAliquote

select listaAliquote
DO WHILE !EOF()
	if EOF()
		EXIT
	endif
	_PerAliq = perAliq
	_codAliq = codAliq
	_desAliq = desAliq
		
	select dividiAliquota
	append blank

	REPLACE cdIVA 		with 	_codAliq	
	REPLACE dsIVA 		with 	_desAliq
	REPLACE Aliq 		with 	_PerAliq	
	REPLACE Impo_DED	with 	0
	REPLACE Impo_NO_D	with 	0
	REPLACE Iva_DED		with 	0
	REPLACE Iva_NO_D	with 	0			
	REPLACE ESE_NOIMP 	WITH    0
	REPLACE ALTRO 		WITH    0
	
	select listaAliquote
	skip + 1
ENDDO

ANNODAL=SUBSTR(DATADAL,7,4)
MESEDAL=SUBSTR(DATADAL,4,2)
V_ANNO		=ANNODAL
V_MESE		=MESEDAL
CONTA_REC 	=0

RELEASE imponibile_indeducibile,imposta_indeducibile,_elenco_codAltro
PUBLIC imponibile_indeducibile,imposta_indeducibile,_elenco_codAltro
imponibile_indeducibile	= 0
imposta_indeducibile	= 0
_elenco_codAltro	    = ''

PUBLIC  OK_PROTCL 
OK_PROTCL = 0


*!*	=OPENDB("PARA")
*!*	=OPENDB("U_AZI_AN")
*!*	=OPENDB("U_IVA_CL")
*!*	=OPENDB("U_IVF_CL")
*!*	=OPENDB("U_IVA_TO")
*!*	=OPENDB("MOV_CONT")
*!*	=OPENDB("CONTI")
*!*	=OPENDB("U_FOR_AN")
*!*	=OPENDB("U_CLI_AN")

**=> ERASMO - INIZIO 13/03/2007
WAIT WINDOWS "Lettura archivi in corso...  -  Prego attendere" nowait

cSql = "select * from U_AZI_AN"
IF !ExecCommand(cSql,"U_AZI_AN")
   RETURN .F.
ENDIF
SELECT U_AZI_AN
INDEX ON AZI_CODSOC TAG U_AZI_AN ADDITIVE

cSql = "select * from U_IVA_CL"
IF !ExecCommand(cSql,"U_IVA_CL")
   RETURN .F.
ENDIF
SELECT U_IVA_CL
INDEX ON IVA_CODSOC+IVA_ANNO+IVA_MESE TAG ANNOMESE ADDITIVE
INDEX ON IVA_CODSOC+IVA_DTFATT TAG DATAFATT ADDITIVE  && ERASMO - 08/10/2007

cSql = "select * from U_IVF_CL"
IF !ExecCommand(cSql,"U_IVF_CL")
   RETURN .F.
ENDIF
SELECT U_IVF_CL
INDEX ON IVF_CODSOC+IVF_ANNO+IVF_MESE TAG ANNOMESE ADDITIVE
INDEX ON IVF_CODSOC+IVF_DTFATT TAG DATAFATT ADDITIVE  && ERASMO - 08/10/2007

cSql = "select * from U_IVA_TO"
IF !ExecCommand(cSql,"U_IVA_TO")
   RETURN .F.
ENDIF

cSql = "select * from MOV_CONT"
IF !ExecCommand(cSql,"MOV_CONT")
   RETURN .F.
ENDIF

cSql = "select * from CONTI"
IF !ExecCommand(cSql,"CONTI")
   RETURN .F.
ENDIF

cSql = "select * from U_FOR_AN"
IF !ExecCommand(cSql,"U_FOR_AN")
   RETURN .F.
ENDIF
SELECT U_FOR_AN
INDEX ON FOR_CODSOC+FOR_CODCLI TAG U_FOR_AN ADDITIVE
INDEX ON FOR_CODSOC+FOR_RAGSOC TAG U_FOR_RG ADDITIVE

cSql = "select * from U_CLI_AN"
IF !ExecCommand(cSql,"U_CLI_AN")
   RETURN .F.
ENDIF
SELECT U_CLI_AN
INDEX ON CLI_CODSOC+CLI_CODCLI TAG U_CLI_AN ADDITIVE
INDEX ON CLI_CODSOC+CLI_RAGSOC TAG U_CLI_RG ADDITIVE

WAIT WINDOWS "Elaborazione dati in corso...  -  Prego attendere" nowait
**=> ERASMO - FINE 13/03/2007

IF (EMPTY(MESEDAL)) .OR. (EMPTY(ANNODAL))  
  RETURN
ENDIF  

***CERCA SU U_AZI_AN SE E' NECESSARIO GESTIRE LE ESENZIONI SUL CLIENTE NEL CASO DI ARTICOLO PUBBLICITARIO

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

IF __CLIFOR = 1
	DO CLIENTI
ELSE
	DO FORNITORI
ENDIF

RELEASE WINDOW DISPLAY

select distinct codiceAltro from elencoAltro into cursor elencoAltro
select elencoAltro

DO WHILE !EOF()
	if EOF()
		EXIT
	endif
	_singoloCod = alltrim(codiceAltro)
	_elenco_codAltro = _elenco_codAltro + _singoloCod + chr(13)
	
	select elencoAltro
	skip + 1
	
ENDDO

select * from dividiAliquota where Impo_DED <> 0 or Impo_NO_D <> 0 or Iva_DED <> 0 or Iva_NO_D <> 0 ;
		OR ESE_NOIMP <> 0 ;
		OR ALTRO <> 0 ;
		into cursor dividiAliquota
		
select dividiAliquota

** Stampo
SELECT MyFinalCursor

RELEASE PUB_TITOLO
PUBLIC PUB_TITOLO
PUB_TITOLO="STAMPA ELENCO "

IF __CLIFOR = 1
	PUB_TITOLO=	PUB_TITOLO + "CLIENTI"
ELSE
	PUB_TITOLO=	PUB_TITOLO + "FORNITORI"
ENDIF

*!*	REPORT FORM I248.frx NOCONSOLE PREVIEW
*!*	REPORT FORM I248.frx NOEJECT NOCONSOLE TO PRINTER PROMPT

*!*	*** Stampa del riepilogo
*!*	select dividiAliquota
*!*	REPORT FORM I248_rie.frx NOCONSOLE PREVIEW
*!*	REPORT FORM I248_rie.frx NOEJECT NOCONSOLE TO PRINTER PROMPT

*!*	**=> ERASMO - INIZIO 21/03/2007
*!*	WAIT CLEAR
*!*	DO PRG\MENUSTA WITH "MyFinalCursor",.T.,.T.,"XXX","I248.frx","I248.frx"
*!*	DO PRG\MENUSTA WITH "dividiAliquota",.T.,.T.,"XXX","I248_rie.frx","I248_rie.frx"
*!*	**=> ERASMO - FINE 21/03/2007

**=> ERASMO - INIZIO 20/09/2007
WAIT CLEAR
IF _WW_OKSTA
   DO PRG\MENUSTA WITH "MyFinalCursor",.T.,.T.,"XXX","I248.frx","I248.frx"
   DO PRG\MENUSTA WITH "dividiAliquota",.T.,.T.,"XXX","I248_rie.frx","I248_rie.frx"
ENDIF
**=> ERASMO - FINE 20/09/2007

RELEASE PUB_TITOLO

RETURN



*###################################################################################
***
***    F O R N I T O R I 
***
*###################################################################################


***********************************************************************************************
     PROCEDURE FORNITORI    
***********************************************************************************************
SET NEAR OFF
SET EXACT ON
SET EXCLUSIVE OFF

SELECT U_IVF_CL
HH=AFIELDS(TRANSIVC)
CREATE CURSOR IVA FROM ARRAY TRANSIVC


DATA_DA = RIBALTA2(DATADAL)
DATA_A =  RIBALTA2(DATAAL)

ANNO_DA = substr(data_da,1,4)
MESE_DA = substr(data_da,6,2)

***ANNO_A NON MI SERVE PERCHE' ELABORO SOLO UN ANNO ALLA VOLTA
MESE_A = substr(data_a,6,2)


SET NEAR ON
SELECT U_IVF_CL
*!*	SET ORDER TO ANNOMESE
*!*	_SK = PUB_CODSOC+ANNO_DA+MESE_DA

**=> ERASMO - INIZIO 08/10/2007
SET ORDER TO DATAFATT
GO TOP
_SK = PUB_CODSOC+DATA_DA
**=> ERASMO - FINE 08/10/2007

SEEK _SK

CTRELAB = 0


DO WHILE !EOF()       && CARICA I RECORD PRINCIPALI DI FATTURAZIONE
  IF DELETED()
    SELECT U_IVF_CL
    SKIP +1
    LOOP
  ENDIF
 
 *IF ALLTRIM(IVF_CODCLI) = '3031000069' AND IVF_CODIVA = "64"

*  IF IVF_CODIVA = "08*"   && TEST 
*  ELSE
*    SELECT U_IVF_CL
*    SKIP +1
*    LOOP
*  ENDIF
  
*!*	  ** Se si supera la data di filtro ( ovvero dell'anno si esce dal ciclo )
*!*	  IF IVF_ANNO > ANNO_DA
*!*	    EXIT
*!*	  ENDIF
*!*	  
*!*	  IF IVF_MESE > MESE_A
*!*	    EXIT
*!*	  ENDIF

  **=> ERASMO - INIZIO 08/10/2007
  ** Se la data fattura è minore della data inizio (01/01/anno) allora la scarto
  IF IVF_DTFATT < DATA_DA
    EXIT
  ENDIF
  **=> ERASMO - FINE 08/10/2007
  
*!*	  ** Salto tutti i record precedenti alla data di filtro
*!*	  IF IVF_ANNO < ANNO_DA
*!*	    SELECT U_IVF_CL
*!*	    SKIP +1
*!*	    LOOP
*!*	  ENDIF
*!*	  
*!*	  IF IVF_MESE < MESE_DA
*!*	    SELECT U_IVF_CL
*!*	    SKIP +1
*!*	    LOOP
*!*	  ENDIF
  
  **=> ERASMO - INIZIO 08/10/2007
  ** Salto tutti i record successivi alla data fine (31/12/anno)
  IF IVF_DTFATT > DATA_A
    SELECT U_IVF_CL
    SKIP +1
    LOOP
  ENDIF
  **=> ERASMO - FINE 08/10/2007
  
  
  SELECT U_IVF_CL
  

  SCATTER MEMVAR MEMO	    && Salva i vecchi valori
  SELECT IVA
  APPEND BLANK
  GATHER MEMVAR MEMO		&& Salva le modifiche

  CTRELAB=CTRELAB+1 
  =CONTATORE("Movimenti fornitori",CTRELAB)


  SELECT U_IVF_CL
  SKIP

ENDDO



CT = 0
SELECT IVA
GO TOP

*** test simone
*browse normal
*GO TOP
*SET STEP ON


*************************
* INIZIA L'ELABORAZIONE *
*************************

DO WHILE !EOF()
	
	
	IF DELETED()
        SELECT IVA
    	SKIP +1
    	LOOP
  	ENDIF


  	ANNO   	= IVF_ANNO
  	WTOP   	= IVF_TOP
  	WCONTO 	= IVF_CODCLI
  	
  	WCODCLI = IVF_CODCLI

  	CT = CT + 1

  	_NUMFAT     = IVF_NUMFAT
  	_ANNO       = IVF_ANNO

	WAIT WINDOWS "Fattura Fornitore elaborata n. " + _NUMFAT    NOWAIT

  	WTOP        = IVF_TOP
  	
	___RAGSOC= IVF_RAGSOC  	
  
  	** Prelevo i dati anagrafici dei clienti (dati non contabili)
    SELECT U_FOR_AN
    SET ORDER TO U_FOR_AN

*!*	    WCOD = SUBSTR(WCODCLI,PUB_SOTTOG,len(ALLTRIM(WCODCLI)))
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
	  
      WCODIVA	= FOR_CODIVA
      
	  WPROVI    = ""
	  
	  **=> ERASMO - INIZIO 02/10/2007
      ** Se non sono ITALIA, li scarto
      if alltrim(upper(WNAZION)) <> 'ITA'
      	SELECT IVA
    	SKIP +1
    	LOOP
      endif	

	  ** Se sono PRIVATI, li scarto      
	  if alltrim(WPARIVA) = '' and alltrim(WCODFIS) <> ''
	   	SELECT IVA
	  	SKIP +1
	   	LOOP	      
	  ENDIF
	  **=> ERASMO - FINE 02/10/2007
	  
    ELSE
    
      *** NON L'HO TROVATO
      *** CERCO PER RAGIONE SOCIALE

	  SELECT U_FOR_AN
	  SET ORDER TO U_FOR_RG
	  SEEK PUB_CODSOC+ALLTRIM(___RAGSOC)
      
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
		  ENDIF
	  
	      WCODFIS   = FOR_CFISLG
		  IF EMPTY(WCODFIS)	      
		      WCODFIS   = FOR_CODFIS
		  ENDIF

	      WNAZION   = FOR_NAZION	  
	      WCODIVA	= FOR_CODIVA

		  *** GESTIONE IVA CEE
	      WIVCELG   = FOR_IVCELG
		  IF EMPTY(WIVCELG)	      
		      WIVCELG   = FOR_IVACEE
		  ENDIF      
      
		  WPROVI    = ""
		  
		  **=> ERASMO - INIZIO 02/10/2007
	      ** Se non sono ITALIA, li scarto
	      if alltrim(upper(WNAZION)) <> 'ITA'
	      	SELECT IVA
	    	SKIP +1
	    	LOOP	    	
	      endif	
	
	      ** Se sono PRIVATI, li scarto      
	      if alltrim(WPARIVA) = '' and alltrim(WCODFIS) <> ''
	      	SELECT IVA
	    	SKIP +1
	    	LOOP	      
	      ENDIF
	      **=> ERASMO - FINE 02/10/2007
	  
	  ELSE      
	  
***  	      WAIT WINDOW "NON TROVATO "+WCODCLI+"----- CASO IVA"

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
		  WCODIVA	= ""      
		  WPROVI    = ""
	      WNAZION   = ""
    	  WIVCELG   = ""		  
	   ENDIF
	   
	ENDIF

	SELECT PARA
	SET ORDER TO CODICE
	SEEK 'IVA'+WCODIVA
	IF FOUND()
		WDESIVA	   = alltrim(DESCRI)			&& Descrizione del codice IVA
		WPERCIVA   = VAL(SUBSTR(LIBERA,1,3))	&& Percentuale IVA
		WPERCIVACHR= SUBSTR(LIBERA,1,3)&& CARATTERE Percentuale IVA		
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
	

	
*	WTOTIM      = CAMBIO(IVF_VALUTA,IVF_IMPONI,IVF_CAMBIO)
*	WTOTIMPO    = CAMBIO(IVF_VALUTA,IVF_IMPOST,IVF_CAMBIO)

	WTOTIM      = IVF_IMPONI
	WTOTIMPO    = IVF_IMPOST

 	IF ALLTRIM(IVF_FATNOT) = 'N'				&& NOTA CREDITO
 		_coeff = -1
 	else
 		_coeff = +1
 	endif
     		 	      		 	      		 	
	ValoreTot  = WTOTIM * _coeff

      		
	DO RIPARTIZIONE_IMPONIBILI_ESENZIONI		   		

	** Salvo nel mio cursore finale i totali calcolati
	SELECT MyFinalCursor
	SET ORDER TO Cliente
	GO TOP
		
	SEEK alltrim(WCOD)
		
	IF FOUND()
		** Il codice cliente è già stato trovato
		** Sommo i totali calcolati a quelli già presenti

		REPLACE Iva    					with 	Iva     + Imposta
		REPLACE valore 					with 	valore  + ValoreTot
		REPLACE imponi 					with 	imponi  + Imponibile
		REPLACE imponi_indeducibile 	with	imponi_indeducibile + imponibile_indeducibile
		REPLACE iva_indeducibile 		with	iva_indeducibile + imposta_indeducibile

		REPLACE esenz  	with esenz   + __totArt10			
		REPLACE art8  	with art8  	 + __totArt8			
		REPLACE art8bis with art8bis + __totArt8bis
		REPLACE art9  	with art9  	 + __totArt9
		REPLACE art40  	with art40   + __totArt40
		REPLACE art41  	with art41   + __totArt41
		REPLACE art52  	with art52   + __totArt52
		REPLACE art72  	with art72   + __totArt72
		REPLACE altrees	with altrees + __totAltro			
				
	ELSE
		** Il codice cliente non è stato ancora trovato
		** Credo il record con il nuovo dato
		SELECT MyFinalCursor
		APPEND BLANK
		
		REPLACE codcli  with WCOD
		REPLACE ragsoc  with WRAGSOC
		REPLACE indiri  with WINDIRI
		REPLACE locali  with WLOCALI
		REPLACE cap		with WCAP
		REPLACE provi	with WPROVI
		REPLACE nazione with WNAZION
		IF !EMPTY(ALLTRIM(WPARIVA))
			REPLACE pariva  with WPARIVA
		ELSE	
			REPLACE pariva  with WIVCELG			    && PARTITA IVA CEE
		ENDIF	
		REPLACE codfis  with WCODFIS
		REPLACE pivacod					with WCODIVA	&& Codice IVA
		REPLACE pivades  				with WDESIVA	&& Descrizione del codice IVA
		REPLACE pivaperc  				with WPERCIVA	&& Percentuale IVA
		REPLACE pivatipo  				with WTIPOIVA	&& Tipo IVA ( SE = "I" è INDEDUCIBILE )
		REPLACE pivaperI  				with WPERCIVA_I	&& Percentuale di INDEDUCIBILITA'
					
		REPLACE valore  with ValoreTot
		REPLACE imponi  with Imponibile
		REPLACE Iva     with Imposta
		REPLACE imponi_indeducibile 	with	imponibile_indeducibile
		REPLACE iva_indeducibile 		with	imposta_indeducibile

		REPLACE esenz  	with __totArt10			
		REPLACE art8  	with __totArt8			
		REPLACE art8bis with __totArt8bis
		REPLACE art9  	with __totArt9
		REPLACE art40  	with __totArt40
		REPLACE art41  	with __totArt41
		REPLACE art52  	with __totArt52
		REPLACE art72  	with __totArt72
		REPLACE altrees	with __totAltro			
			
	ENDIF
		

	SELECT IVA
    SKIP +1

ENDDO


SELECT * from MyFinalCursor where valore <> 0 order by ragsoc into cursor MyFinalCursor
SELECT MyFinalCursor
GO TOP


RETURN




**********************************************************************************
** RIPARTISCE il valore dell' imponibile e/o esenzioni per ogni movimento iva   **
** 
** solo per fornitori
**
**********************************************************************************
PROCEDURE RIPARTIZIONE_IMPONIBILI_ESENZIONI

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
  
if ALLTRIM(IVA.IVF_FATNOT) = 'N'				&& NOTA CREDITO
	__coeff = -1
else
	__coeff = +1
endif
     
     		 	      
DO CASE
    
		CASE __classIva = 1
    		__totArt10 = __totArt10 + (WTOTIM * __coeff)    	&& ESENZIONE ARTICOLO 10
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
 
    	CASE __classIva = 2
    		__totArt8 = __totArt8 + (WTOTIM * __coeff)			&& NON IMPONIBILE ARTICOLO 8 
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 3
    		__totArt8bis = __totArt8bis + (WTOTIM * __coeff)	&& NON IMPONIBILE ARTICOLO 8-BIS
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 4
    		__totArt9 = __totArt9 + (WTOTIM * __coeff)			&& NON IMPONIBILE ARTICOLO 9
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 5
    		__totArt40 = __totArt40 + (WTOTIM * __coeff)		&& NON IMPONIBILE ARTICOLO 40
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 6
    		__totArt41 = __totArt41 + (WTOTIM * __coeff)		&& NON IMPONIBILE ARTICOLO 41
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 7
    		__totArt52 = __totArt52 + (WTOTIM * __coeff)		&& NON IMPONIBILE ARTICOLO 52
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 8
    		__totArt72 = __totArt72 + (WTOTIM * __coeff)		&& NON IMPONIBILE ARTICOLO 72
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					
    		      		 			
    	CASE __classIva = 9
    		__totAltro = __totAltro + (WTOTIM * __coeff)		&& ALTRE ESENZIONI NON IN ELENCO CLIENTI / FORNITORI
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ALTRO        with ALTRO    + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					

    		      		 				
    	OTHERWISE
   			imponibile_indeducibile = imponibile_indeducibile + (__imponibile_indeducibile * __coeff)								&& IMPONIBILE INDEDUCIBILE
   			imposta_indeducibile 	= imposta_indeducibile + (__imposta_indeducibile * __coeff)
   			Imponibile 				= Imponibile + (__imponibile_deducibile * __coeff)		&& IMPONIBILE al netto dell'imponibile indeducibile e dell'imposta indeducibile
   			Imposta 				= Imposta 	 + (__imposta_deducibile * __coeff)		
    		
    			
			select dividiAliquota
			set order to pAli
			go top
   			SEEK __moviva
   			IF FOUND()
				REPLACE Impo_NO_D  with Impo_NO_D + (__imponibile_indeducibile * __coeff)   	
				REPLACE Iva_NO_D   with Iva_NO_D + (__imposta_indeducibile * __coeff)
				REPLACE Impo_DED   with Impo_DED + (__imponibile_deducibile * __coeff)
				REPLACE Iva_DED    with Iva_DED + (__imposta_deducibile * __coeff)		
			ENDIF	      		 					

    	
ENDCASE
  		 		     
RETURN

*###################################################################################


*###################################################################################
***
***    C L I E N T I 
***
*###################################################################################


***********************************************************************************************
     PROCEDURE CLIENTI    
***********************************************************************************************
SET NEAR OFF
SET EXACT ON
SET EXCLUSIVE OFF

SELECT U_IVA_CL
HH=AFIELDS(TRANSIVC)
CREATE CURSOR IVA FROM ARRAY TRANSIVC


DATA_DA = RIBALTA2(DATADAL)
DATA_A =  RIBALTA2(DATAAL)

ANNO_DA = substr(data_da,1,4)
MESE_DA = substr(data_da,6,2)

***ANNO_A NON MI SERVE PERCHE' ELABORO SOLO UN ANNO ALLA VOLTA
MESE_A = substr(data_a,6,2)


SET NEAR ON
SELECT U_IVA_CL
*!*	SET ORDER TO ANNOMESE
*!*	_SK = PUB_CODSOC+ANNO_DA+MESE_DA

**=> ERASMO - INIZIO 08/10/2007
SET ORDER TO DATAFATT
GO TOP
_SK = PUB_CODSOC+DATA_DA
**=> ERASMO - FINE 08/10/2007

SEEK _SK

CTRELAB = 0


DO WHILE !EOF()       && CARICA I RECORD PRINCIPALI DI FATTURAZIONE
  IF DELETED()
    SELECT U_IVA_CL
    SKIP +1
    LOOP
  ENDIF
 
* IF ALLTRIM(IVA_CODCLI) = '40410074700'

*  IF IVA_CODIVA = "41"   && TEST 
*  ELSE
*    SELECT U_IVA_CL
*    SKIP +1
*    LOOP
*  ENDIF
 
	
  
*!*	  ** Se si supera la data di filtro ( ovvero dell'anno si esce dal ciclo )
*!*	  IF IVA_ANNO > ANNO_DA
*!*	    EXIT
*!*	  ENDIF
*!*	  
*!*	  IF IVA_MESE > MESE_A
*!*	    EXIT
*!*	  ENDIF
  
  **=> ERASMO - INIZIO 08/10/2007
  ** Se la data fattura è minore della data inizio (01/01/anno) allora la scarto
  IF IVA_DTFATT < DATA_DA
    EXIT
  ENDIF
  **=> ERASMO - FINE 08/10/2007
  
  
*!*	  ** Salto tutti i record precedenti alla data di filtro
*!*	  IF IVA_ANNO < ANNO_DA
*!*	    SELECT U_IVA_CL
*!*	    SKIP +1
*!*	    LOOP
*!*	  ENDIF
*!*	  
*!*	  IF IVA_MESE < MESE_DA
*!*	    SELECT U_IVA_CL
*!*	    SKIP +1
*!*	    LOOP
*!*	  ENDIF
  
  **=> ERASMO - INIZIO 08/10/2007
  ** Salto tutti i record successivi alla data fine (31/12/anno)
  IF IVA_DTFATT > DATA_A
    SELECT U_IVA_CL
    SKIP +1
    LOOP
  ENDIF
  **=> ERASMO - FINE 08/10/2007
  
  
  SELECT U_IVA_CL
  

  SCATTER MEMVAR MEMO	    && Salva i vecchi valori
  SELECT IVA
  APPEND BLANK
  GATHER MEMVAR MEMO		&& Salva le modifiche

  CTRELAB=CTRELAB+1 
  =CONTATORE("Movimenti CLIENTI",CTRELAB)

  SELECT U_IVA_CL
  SKIP

ENDDO


CT = 0
SELECT IVA
GO TOP
*browse normal
*GO TOP
*SET STEP ON


*************************
* INIZIA L'ELABORAZIONE *
*************************

DO WHILE !EOF()
	
	
	IF DELETED()
        SELECT IVA
    	SKIP +1
    	LOOP
  	ENDIF


  	ANNO   	= IVA_ANNO
  	WCONTO 	= IVA_CODCLI
  	
  	WCODCLI = IVA_CODCLI

  	CT = CT + 1

  	_NUMFAT     = IVA_NUMFAT
  	_ANNO       = IVA_ANNO

	WAIT WINDOWS "Fattura CLIENTE elaborata n. " + _NUMFAT    NOWAIT

	___RAGSOC= IVA_RAGSOC  	
  
  	** Prelevo i dati anagrafici dei clienti (dati non contabili)
    SELECT U_CLI_AN
    SET ORDER TO U_CLI_AN

*!*	    WCOD = SUBSTR(WCODCLI,PUB_SOTTOG,len(ALLTRIM(WCODCLI)))
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
	  ENDIF
	  
      WCODFIS   = CLI_CFISLG
	  IF EMPTY(WCODFIS)	      
	      WCODFIS   = CLI_CODFIS
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
	      *WPROVI = CLI_PROV
	      WPROVI = CLI_PROVIN
	  ENDIF
	  
      WCODIVA	= CLI_CODIVA
      
      **=> ERASMO - INIZIO 02/10/2007
      ** Se non sono ITALIA, li scarto
      if alltrim(upper(WNAZION)) <> 'ITA'
      	SELECT IVA
    	SKIP +1
    	LOOP
      endif	
      
	  ** Se sono PRIVATI, li scarto      
	  if alltrim(WPARIVA) = '' and alltrim(WCODFIS) <> ''
	   	SELECT IVA
	   	SKIP +1
	   	LOOP	      
	  ENDIF
	  **=> ERASMO - FINE 02/10/2007
      
    ELSE
    
      *** NON L'HO TROVATO
      *** CERCO PER RAGIONE SOCIALE

	  SELECT U_CLI_AN
	  SET ORDER TO U_CLI_RG
	  SEEK PUB_CODSOC+ALLTRIM(___RAGSOC)
      
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
		  ENDIF
	  
	      WCODFIS   = CLI_CFISLG
		  IF EMPTY(WCODFIS)	      
		      WCODFIS   = CLI_CODFIS
		  ENDIF

	      WNAZION   = CLI_NAZLEG
		  IF EMPTY(WNAZION)	      
		      WNAZION   = CLI_NAZION
		  ENDIF
	  
	      WCODIVA	= CLI_CODIVA

		  *** GESTIONE IVA CEE
	      WIVCELG   = CLI_IVCELG
		  IF EMPTY(WIVCELG)	      
		      WIVCELG   = CLI_IVACEE
		  ENDIF      
      
		  WPROVI    = CLI_PROLEG
		  IF EMPTY(WPROVI)	      
		      *WPROVI = CLI_PROV
		      WPROVI = CLI_PROVIN
		  ENDIF

		  **=> ERASMO - INIZIO 02/10/2007
	      ** Se non sono ITALIA, li scarto
	      if alltrim(upper(WNAZION)) <> 'ITA'
	      	SELECT IVA
	    	SKIP +1
	    	LOOP	    	
	      endif	

	      ** Se sono PRIVATI, li scarto      
	      if alltrim(WPARIVA) = '' and alltrim(WCODFIS) <> ''
	      	SELECT IVA
	    	SKIP +1
	    	LOOP	      
	      ENDIF
	      **=> ERASMO - FINE 02/10/2007
	  
	  ELSE      
	      
***  	      WAIT WINDOW "NON TROVATO "+WCODCLI+"----- CASO IVA"
	  
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
		  WCODIVA	= ""      
		  WPROVI    = ""
	   ENDIF
	   
	ENDIF

	SELECT PARA
	SET ORDER TO CODICE
	SEEK 'IVA'+WCODIVA
	IF FOUND()
		WDESIVA	   = alltrim(DESCRI)			&& Descrizione del codice IVA
		WPERCIVA   = VAL(SUBSTR(LIBERA,1,3))	&& Percentuale IVA
		WPERCIVACHR= SUBSTR(LIBERA,1,3)&& CARATTERE Percentuale IVA		
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
	

	
*	WTOTIM      = CAMBIO(IVA_VALUTA,IVA_IMPONI,IVA_CAMBIO)
*	WTOTIMPO    = CAMBIO(IVA_VALUTA,IVA_IMPOST,IVA_CAMBIO)

	WTOTIM      = IVA_IMPONI
	WTOTIMPO    = IVA_IMPOST

 	IF ALLTRIM(IVA_FATNOT) = 'N'				&& NOTA CREDITO
 		_coeff = -1
 	else
 		_coeff = +1
 	endif
     		 	      		 	      		 	
	ValoreTot  = WTOTIM * _coeff

      		
	DO RIPARTIZIONE_IMPONIBILI_ESENZIONI_CLIENTI		   		

	** Salvo nel mio cursore finale i totali calcolati
	SELECT MyFinalCursor
	SET ORDER TO Cliente
	GO TOP
		
	SEEK alltrim(WCOD)
		
	IF FOUND()
		** Il codice cliente è già stato trovato
		** Sommo i totali calcolati a quelli già presenti

		REPLACE Iva    					with 	Iva     + Imposta
		REPLACE valore 					with 	valore  + ValoreTot
		REPLACE imponi 					with 	imponi  + Imponibile
		REPLACE imponi_indeducibile 	with	imponi_indeducibile + imponibile_indeducibile
		REPLACE iva_indeducibile 		with	iva_indeducibile + imposta_indeducibile

		REPLACE esenz  	with esenz   + __totArt10			
		REPLACE art8  	with art8  	 + __totArt8			
		REPLACE art8bis with art8bis + __totArt8bis
		REPLACE art9  	with art9  	 + __totArt9
		REPLACE art40  	with art40   + __totArt40
		REPLACE art41  	with art41   + __totArt41
		REPLACE art52  	with art52   + __totArt52
		REPLACE art72  	with art72   + __totArt72
		REPLACE altrees	with altrees + __totAltro			
				
	ELSE
		** Il codice cliente non è stato ancora trovato
		** Credo il record con il nuovo dato
		SELECT MyFinalCursor
		APPEND BLANK
		
		REPLACE codcli  with WCOD
		REPLACE ragsoc  with WRAGSOC
		REPLACE indiri  with WINDIRI
		REPLACE locali  with WLOCALI
		REPLACE cap		with WCAP
		REPLACE provi	with WPROVI
		REPLACE nazione with WNAZION
		IF !EMPTY(ALLTRIM(WPARIVA))
			REPLACE pariva  with WPARIVA
		ELSE	
			REPLACE pariva  with WIVCELG			    && PARTITA IVA CEE
		ENDIF	
		REPLACE codfis  with WCODFIS
		REPLACE pivacod					with WCODIVA	&& Codice IVA
		REPLACE pivades  				with WDESIVA	&& Descrizione del codice IVA
		REPLACE pivaperc  				with WPERCIVA	&& Percentuale IVA
		REPLACE pivatipo  				with WTIPOIVA	&& Tipo IVA ( SE = "I" è INDEDUCIBILE )
		REPLACE pivaperI  				with WPERCIVA_I	&& Percentuale di INDEDUCIBILITA'
					
		REPLACE valore  with ValoreTot
		REPLACE imponi  with Imponibile
		REPLACE Iva     with Imposta
		REPLACE imponi_indeducibile 	with	imponibile_indeducibile
		REPLACE iva_indeducibile 		with	imposta_indeducibile

		REPLACE esenz  	with __totArt10			
		REPLACE art8  	with __totArt8			
		REPLACE art8bis with __totArt8bis
		REPLACE art9  	with __totArt9
		REPLACE art40  	with __totArt40
		REPLACE art41  	with __totArt41
		REPLACE art52  	with __totArt52
		REPLACE art72  	with __totArt72
		REPLACE altrees	with __totAltro			
			
	ENDIF
		

	SELECT IVA
    SKIP +1

ENDDO


SELECT * from MyFinalCursor where valore <> 0 order by ragsoc into cursor MyFinalCursor
SELECT MyFinalCursor
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
  
if ALLTRIM(IVA.IVA_FATNOT) = 'N'				&& NOTA CREDITO
	__coeff = -1
else
	__coeff = +1
endif
     
     		 	      
DO CASE
    
		CASE __classIva = 1
    		__totArt10 = __totArt10 + (WTOTIM * __coeff)    	&& ESENZIONE ARTICOLO 10
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
 
    	CASE __classIva = 2
    		__totArt8 = __totArt8 + (WTOTIM * __coeff)			&& NON IMPONIBILE ARTICOLO 8 
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 3
    		__totArt8bis = __totArt8bis + (WTOTIM * __coeff)	&& NON IMPONIBILE ARTICOLO 8-BIS
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 4
    		__totArt9 = __totArt9 + (WTOTIM * __coeff)			&& NON IMPONIBILE ARTICOLO 9
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 5
    		__totArt40 = __totArt40 + (WTOTIM * __coeff)		&& NON IMPONIBILE ARTICOLO 40
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 6
    		__totArt41 = __totArt41 + (WTOTIM * __coeff)		&& NON IMPONIBILE ARTICOLO 41
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 7
    		__totArt52 = __totArt52 + (WTOTIM * __coeff)		&& NON IMPONIBILE ARTICOLO 52
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					      		 				
    	
    	CASE __classIva = 8
    		__totArt72 = __totArt72 + (WTOTIM * __coeff)		&& NON IMPONIBILE ARTICOLO 72
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ESE_NOIMP     with ESE_NOIMP + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					
    		      		 			
    	CASE __classIva = 9
    		__totAltro = __totAltro + (WTOTIM * __coeff)		&& ALTRE ESENZIONI NON IN ELENCO CLIENTI / FORNITORI
			select dividiAliquota
			set order to pAli
			go top
    		SEEK __moviva
    		IF FOUND()
				REPLACE ALTRO        with ALTRO    + (WTOTIM * __coeff)
			*	REPLACE Impo_DED     with Impo_DED + (WTOTIM * __coeff)
			ENDIF	      		 					

    		      		 				
    	OTHERWISE
   			imponibile_indeducibile = imponibile_indeducibile + (__imponibile_indeducibile * __coeff)								&& IMPONIBILE INDEDUCIBILE
   			imposta_indeducibile 	= imposta_indeducibile + (__imposta_indeducibile * __coeff)
   			Imponibile 				= Imponibile + (__imponibile_deducibile * __coeff)		&& IMPONIBILE al netto dell'imponibile indeducibile e dell'imposta indeducibile
   			Imposta 				= Imposta 	 + (__imposta_deducibile * __coeff)		
    		
    			
			select dividiAliquota
			set order to pAli
			go top
   			SEEK __moviva
   			IF FOUND()
				REPLACE Impo_NO_D  with Impo_NO_D + (__imponibile_indeducibile * __coeff)   	
				REPLACE Iva_NO_D   with Iva_NO_D + (__imposta_indeducibile * __coeff)
				REPLACE Impo_DED   with Impo_DED + (__imponibile_deducibile * __coeff)
				REPLACE Iva_DED    with Iva_DED + (__imposta_deducibile * __coeff)		
			ENDIF	      		 					

    	
ENDCASE
  		 		     
RETURN



*###################################################################################


**********************************************************************************
** Funzione per la determinazione della classe di appartenenza del codice IVA	**
** che verrà riportato nell'elenco Clienti/Fornitori							**
**********************************************************************************
function classiva
PARA _CODIVA

AABBSSIMO=SELECT()

*!*	=OPENDB("PARA")
**=> ERASMO - INIZIO 13/03/2007
cSql = "select * from PARA"
IF !ExecCommand(cSql,"PARA")
   RETURN .F.
ENDIF
SELECT PARA
INDEX ON CODICE TAG CODICE ADDITIVE
**=> ERASMO - FINE 13/03/2007
SELECT PARA
SET ORDER TO CODICE

SEEK 'IVA'+_CODIVA
IF FOUND()
  _valRit  = val(CLASSIVA)
  if VAL(CLASSIVA) = 9
  	_desc = alltrim(DESCRI)
  	select elencoAltro
  	append blank
  	REPLACE codiceAltro with alltrim(_CODIVA) + " - "+ _desc + ";"
  endif
ELSE
  _valRit = 10   && Assume il valore di "Nessuna classificazione" sul form PARA006
ENDIF

SELECT(AABBSSIMO)

RETURN _valRit




