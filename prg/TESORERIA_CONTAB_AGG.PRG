*********************************************************************************************************
* TESORERIA_CONTAB_AGG
*
*********************************************************************************************************
PUBLIC	_TOTALE_PRIMA_NOTA

LOCAL 	_PAR_CLIFOR,;
		_PAR_NUMPRO ,;  
		_PAR_INDICE ,;  
		_PAR_NREG   ,;
		_PAR_NDOC   

	
SELECT TESORERIA_PAGATI
_ID_PARTITA	=	ID_MOVIMEN

*** VERIFICO NELLE PARTITE AGGIUNTIVE SE SONO PRESENTI DEI RECORD
*** DA CONTABILIZZARE CORRISPONDENTI A QUESTA PARTITA
***
SELECT AGGIUNTIVI
SET ORDER TO ID_PARTITA
SEEK _ID_PARTITA

*** SE NON CE NE SONO
*** ESCO SENZA FAR NULLA
***
IF !FOUND()
	RETURN
ENDIF

*** SE CE NE SONO LI ELABORO

_TOTALE_PRIMA_NOTA=___totpag

SELECT AGGIUNTIVI
SET ORDER TO PARTCONTRO

SET EXACT OFF

IF LEN(_ID_PARTITA)>100
	_ID_PARTITA= SUBSTR(_ID_PARTITA,1,100)
ENDIF
SEEK _ID_PARTITA

SET EXACT ON

DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF

	IF ID_PARTITA<>_ID_PARTITA
		EXIT
	ENDIF

	_PAR_NUMPRO = CGE_NUMPRO          	&& AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
	_PAR_INDICE = "INDICE CARICATO" 	&& NON CREA INDICE
	_PAR_NREG   = ""                	&& MANTIENE IL NUMERO DI REGISTRAZIONE UTENTE
	_PAR_NDOC   = ""                	&& MANTIENE IL NUMERO DI REGISTRAZIONE PRECEDENTE
	
	***CGE_TOPX    NON VARIA RISPETTO A PRIMA
	***CGE_NPARF  NON VARIA RISPETTO A PRIMA
	
	CGE_CON		= CODFOR
	CGE_DESCO 	= RAGSOC

	IF EMPTY(ALLTRIM(CGE_CON))
		CGE_CON		= ___codban		&& E' LA BANCA DI CONTROPOARTITA DELLA PARTITA PADRE
		CGE_DESCO	= ___desban		&& E' DESCRIZIONE DELLA BANCA DI CONTROPOARTITA DELLA PARTITA PADRE
	ENDIF
	
	CGE_DA 		= NDARE
	CGE_AV 		= NAVERE

	CGE_COMM	= "Partita aggiunta da Tesoreria"		&& DESCRIZIONE DINAMICA DEL TIPO MOVIMENTO 
	CGE_DATASCAD = RIBALTA2(DTSCAD )
	
	CGE_FORMAPAGAMENTO    	= FORMAPAGAM
	CGE_COSATRATTA        	= COSATRATTA
	CGE_GRADOIMPORTANZA    	= GRADOIMPOR
	CGE_TIPOCONTRATTO    	= TIPOCONTRA 
	CGE_CODACQ            	= CODACQ
	CGE_PRIPAGA            	= PRIPAGA	


	IF SUBSTR(CGE_CON,1,LEN(PUB_CC))!=PUB_CC 
	*** CONTABILIZZO MOVIMENTO CLIENTE
		_PAR_CLIFOR="CLI"
	ENDIF
	
	IF SUBSTR(CGE_CON,1,LEN(PUB_FF))!=PUB_FF 
		_PAR_CLIFOR="FOR"
	ENDIF

	DO CREA_MOVIMENTO WITH	_PAR_CLIFOR,;
							_PAR_NUMPRO ,;  
							_PAR_INDICE ,;  
							_PAR_NREG   ,;
							_PAR_NDOC   

	SELECT 	AGGIUNTIVI
	SKIP
ENDDO
	
=AGGIORNA_TOTINDICE(CGE_NUMPRO ,_TOTALE_PRIMA_NOTA)

RELEASE _TOTALE_PRIMA_NOTA

*** FINE TESORERIA_CONTAB_AGGIUNTIVI
**************************************************************************


**************************************************************************
PROCEDURE CREA_MOVIMENTO
**************************************************************************
*
* impostare  
* CGE_CON	= CONTO
* CGE_DA 	= DARE
* CGE_AV 	= AVERE
* CGE_DESCO = DESCRI
* 
**************************************************************************
PARAMETERS _PAR_CLIFOR ,;
		   _PAR_NUMPRO ,;  
           _PAR_INDICE ,;  
           _PAR_NREG   ,;
           _PAR_NDOC   
            

_NPARF              = ""                  && SE NON IMPOSTATA CARICA AUTOMATICAMENTE CGE_NPARF

IF PCOUNT()>=1
	_CLIFOR				= _PAR_CLIFOR
ELSE
	RETURN
ENDIF


IF PCOUNT()>=2 
	_NUMPRO             = _PAR_NUMPRO          
ELSE
	_NUMPRO             = "CARICA"          && AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
ENDIF

IF PCOUNT()>=3 
	_INDICE             = _PAR_INDICE          
ELSE
	_INDICE             = "CARICA"          && CREA INDICE
ENDIF

IF PCOUNT()>=4 
	_NREG               = _PAR_NREG          
ELSE
	_NREG               = "CARICA"            &&CERCA IL NUMERO DI REGISTRAZIONE UTENTE
ENDIF

IF PCOUNT()>=5 
	_NDOC               = _PAR_NDOC         
ELSE
	_NDOC               = ___NDOCU          && IMPOSTA IL NUMERO DI DOCUMENTO = PARTITA
ENDIF

CGE_IV               = "NO"
CGE_IMP              = 0.00

CGE_CECOS              = SPACE(13)  
CGE_WCCAGE             = SPACE(3)
CGE_KABBUO             = 0
CGE_XNOTE              = SPACE(13)
CGE_XCCLI              = SPACE(10)
CGE_XCFOR              = SPACE(10)
CGE_DATAREG            = ___DATAREGISTRAZIONE
CGE_DATADOC            = DTOC(DATE())
CGE_NDOC            = ___NDOCU
CGE_FR               = .F.
CGE_PESO            = 0
CGE_TISPE            = SPACE(03)
CGE_PORTO            = SPACE(03)
CGE_CLDOG            = SPACE(16)
CGE_BANCA            = "001"
CGE_CPA                = PUB_CPA
CGE_BOLLATOIVA        = SPACE(01)

CGE_XCAMBIO            = PUB_CAMBIO
CGE_XVALUTA            = "EUR"

*** Fabiano 14/04/2005 - GESTIONE DATA VALUTA
CGE_XDATAVAL        = ___dtvalu 
CGE_XANOMAX            = SPACE(3) 
CGE_CECO            = SPACE(10)
CGE_SEQUEN            = CGE_SEQUEN            +10                && AD OGNI RIGA INSERITA SOMMARE 10 

*CGE_COMM             = "PAGAMENTO N.: "+ALLTRIM(CGE_NDOC)+" DEL "+CGE_DATADOC
CGE_COM1             = "N.PART: "+ALLTRIM(STR(CGE_NPARF))+" - REG.DEL: "+CGE_DATAREG

*** Fabiano 14/04/2005 - GESTIONE DATA VALUTA
CGE_DTPAG			 = ___dtscad

IF pub_consolida_prev=1
    PUB_TIPOGE            = "PREVISIONALE"    && CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ELSE
    PUB_TIPOGE            = "EFFETTIVA"    && CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ENDIF

_TOTALE_PRIMA_NOTA=_TOTALE_PRIMA_NOTA	+	CGE_DA

=AQUAREP(_CLIFOR,_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)

RETURN
*** FINE PROCEDURE CREA_MOVIMENTO
**************************************************************************


