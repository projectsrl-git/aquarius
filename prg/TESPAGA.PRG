****************************** CREA PRIME NOTE A FRONTE DEI PAGAMENTI FATTI A FORNITORE *********************************



PUB_ERRORE=MESSAGEBOX("Desideri contabilizzare i pagamenti ? ",292,'*** ATTENZIONE ***') 
DO CASE
   CASE PUB_ERRORE= 6  && RISPOSTA SI
   CASE PUB_ERRORE= 7  && RISPOSTA NO
      RETURN .F.
ENDCASE


******************************************* DEFINIZIONE DELLE VARIABILI *****************************

RELEASE ___COSATRATTA 		
RELEASE ___GRADOIMPORTANZA 	
RELEASE ___FORMAPAGAMENTO 	
RELEASE ___TIPOCONTRATTO 	
RELEASE ___CODACQ 			
RELEASE ___PRIPAGA 			
RELEASE ___RAGSOC  		

PUBLIC ___COSATRATTA 		
PUBLIC ___GRADOIMPORTANZA 	
PUBLIC ___FORMAPAGAMENTO 	
PUBLIC ___TIPOCONTRATTO 	
PUBLIC ___CODACQ 			
PUBLIC ___PRIPAGA 			
PUBLIC ___RAGSOC  			

IF EMPTY(PUB_PAGAFOR)
	PUB_PAGAFOR="PGF"
ENDIF

IF EMPTY(PUB_PAGANCR)
	PUB_PAGANCR="PNC"				&& PAGAMENTO NOTA CREDITO
ENDIF

IF EMPTY(PUB_TRF)
	PUB_TRF="TRF"
ENDIF

___COSATRATTA 			= SPACE(05)
___GRADOIMPORTANZA 		= SPACE(05)
___FORMAPAGAMENTO 		= SPACE(05)	
___TIPOCONTRATTO 		= SPACE(05)
___CODACQ 				= SPACE(03) 
___PRIPAGA				= SPACE(03) 
___RAGSOC				= SPACE(30)


******************************************* DEFINIZIONE DELLE VARIABILI *****************************

*SET STEP ON

SELECT TESORERIA_PAGATI
GO TOP
IF EOF()
   PUB_ERRORE=MESSAGEBOX("NESUN PAGAMENTO DA CONTABILIZZARE",64,"*** ATTENZIONE ***") 
   RETURN
ENDIF
CONTAMOV = 0


DO WHILE !EOF()


		SELECT TESORERIA_PAGATI

		SCATTER MEMVAR MEMO
		=DEF_AQUAREP()
		KABBUO      = 0
		saldo_prec  = 0

		*___desfor   =ricerca_fornitore(codfor)
		*___desban   =ricerca_conto(contocont)

		___xrecno	=RECNO()
		___totpag   =ABS(quantavalu)

		___codfor   =codfor
		___desfor   =DES_A
		___codban   =contocont
		___desban   =DES_DA

		___dtscad   =ribalta2(dtscad)
		___dtvalu   =ribalta2(quandovalu)
		___npart    =npart
		___ndocu    =STR(___npart,6,0)
		                       
		___COSATRATTA 		= cosatratta    
		___GRADOIMPORTANZA 	= gradoimpor
		___FORMAPAGAMENTO 	= formapagam 
		___TIPOCONTRATTO 	= tipocontra  
		___CODACQ 			= codacq           
		___PRIPAGA 			= pripaga   	      	
		___TIPOLOGIA		= TIPOLOGIA

		CGE_TOPX			= PUB_PAGAFOR		&& PAGAMENTO FORNITORE/RISORSA (DEFAULT)			


		IF quantavalu > 0 						&& NOTE CREDITO							
			CGE_TOPX=PUB_PAGANCR
		ENDIF


		IF ___TIPOLOGIA="TRAS-FONDI"			&& TRASFERIMENTO FONDI
			CGE_TOPX=PUB_TRF
			___codfor   =contocont
			___desfor   =DES_DA
			___codban   =codfor
			___desban   =DES_A
		ENDIF
	
		
		
		=MOVIMENTO_DARE()
		=MOVIMENTO_AVERE()

		CONTAMOV = CONTAMOV + 1

		SELECT TESORERIA_PAGATI
		SKIP +1
	
	
		
ENDDO WHILE !EOF()




PUB_ERRORE=MESSAGEBOX("CONTABILIZZAZIONE EFFETTUATA , NUMERO MOVIMENTI CREATI :"+STR(CONTAMOV,8,0),64,"*** ATTENZIONE ***") 


RETURN




**************************************************************************
FUNCTION MOVIMENTO_DARE           && CREA IL MOVIMENTO DARE : FORNITORE
**************************************************************************


*CGE_TOPX			= PUB_PAGAFOR		&& TIPO OPERAZIONE						
_NPARF 				= ""		      	&& SE NON IMPOSTATA CARICA AUTOMATICAMENTE CGE_NPARF
CGE_NPARF			= ___NPART			
_NUMPRO 			= "CARICA"      	&& AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
_INDICE 			= "CARICA"      	&& CREA INDICE
_NREG				= "CARICA"			&&CERCA IL NUMERO DI REGISTRAZIONE UTENTE
_NDOC				= ___NDOCU  		&& IMPOSTA IL NUMERO DI DOCUMENTO = PARTITA


CGE_CON				= ___codfor

CGE_DA   			= ___totpag
CGE_AV   			= 0

IF CGE_TOPX=PUB_PAGANCR
	CGE_DA   			= 0
	CGE_AV   			= ___totpag
ENDIF

CGE_IV   			= "NO"
CGE_IMP  			= 0.00

CGE_DESCO  			= ___desfor
CGE_CECOS  			= SPACE(13)  
CGE_WCCAGE 			= SPACE(3)
CGE_KABBUO 			= 0
CGE_XNOTE  			= SPACE(13)
CGE_XCCLI  			= SPACE(10)
CGE_XCFOR  			= SPACE(10)
CGE_DATAREG			= DTOC(DATE())
CGE_DATADOC			= DTOC(DATE())
CGE_NDOC			= ___NDOCU
CGE_FR				= .F.
CGE_PESO			= 0
CGE_TISPE			= SPACE(03)
CGE_PORTO			= SPACE(03)
CGE_CLDOG			= SPACE(16)
CGE_BANCA			= "001"
CGE_DATASCAD		= ___dtscad
CGE_CPA				= PUB_CPA
CGE_BOLLATOIVA		= SPACE(01)

CGE_COSATRATTA		= ___COSATRATTA
CGE_GRADOIMPORTANZA	= ___GRADOIMPORTANZA
CGE_FORMAPAGAMENTO	= ___FORMAPAGAMENTO
CGE_TIPOCONTRATTO	= ___TIPOCONTRATTO 
CGE_CODACQ			= ___CODACQ
CGE_PRIPAGA			= ___PRIPAGA


CGE_XCAMBIO			= PUB_CAMBIO
CGE_XVALUTA			= "EUR"
CGE_XDATAVAL		= ___dtscad 
CGE_XANOMAX			= SPACE(3) 
CGE_CECO			= SPACE(10)
CGE_SEQUEN			= 10				&& AD OGNI RIGA INSERITA SOMMARE 10 

CGE_COMM 			= "PAGAMENTO N.: "+ALLTRIM(CGE_NDOC)+" DEL "+CGE_DATADOC
CGE_COM1 			= "REGISTRAZIONE DEL : "+CGE_DATAREG


IF pub_consolida_prev=1
	PUB_TIPOGE			= "PREVISIONALE"	&& CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ELSE
	PUB_TIPOGE			= "EFFETTIVA"	&& CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ENDIF

=AQUAREP("FOR",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)



RETURN



**************************************************************************
FUNCTION MOVIMENTO_AVERE           && CREA IL MOVIMENTO AVERE : BANCA
**************************************************************************
************************************************* RECORD BANCA  *****************************
*CGE_TOPX			= PUB_PAGAFOR		&& TIPO OPERAZIONE						
_NPARF 			    = ""				&& SE NON IMPOSTATA CARICA AUTOMATICAMENTE CGE_NPARF
_NUMPRO 			= CGE_NUMPRO      	&& AGGIORNA PARAMETRO NUM.INTERNO DI PRIMANOTA
_INDICE 			= "INDICE CARICATO" && NON CREA INDICE
_NREG				= ""				&& MANTIENE IL NUMERO DI REGISTRAZIONE UTENTE
_NDOC				= ""				&& MANTIENE IL NUMERO DI REGISTRAZIONE PRECEDENTE

CGE_CON				= ___codban

CGE_DA   			= 0
CGE_AV   			= ___totpag

IF CGE_TOPX=PUB_PAGANCR
	CGE_DA   			= ___totpag
	CGE_AV   			= 0
ENDIF

CGE_IV   			= "NO"
CGE_IMP  			= 0					&& IMPOSTA CALCOLATA SOLO SE SI TRATTA DI FATTURA

CGE_DESCO  			= ___desban
CGE_CECOS  			= SPACE(13)  
CGE_WCCAGE 			= SPACE(3)
CGE_KABBUO 			= 0
CGE_XNOTE  			= SPACE(13)
CGE_XCCLI  			= SPACE(10)
CGE_XCFOR  			= SPACE(10)
CGE_DATAREG			= DTOC(DATE())
CGE_DATADOC			= DTOC(DATE())
CGE_NDOC			= ___NDOCU
CGE_FR				= .F.
CGE_PESO			= 0
CGE_TISPE			= SPACE(03)
CGE_PORTO			= SPACE(03)
CGE_CLDOG			= SPACE(16)
CGE_BANCA			= "001"
CGE_DATASCAD		= ___dtscad
CGE_CPA				= PUB_CPA
CGE_BOLLATOIVA		= SPACE(01)

CGE_COSATRATTA		= ___COSATRATTA
CGE_GRADOIMPORTANZA	= ___GRADOIMPORTANZA
CGE_FORMAPAGAMENTO	= ___FORMAPAGAMENTO
CGE_TIPOCONTRATTO	= ___TIPOCONTRATTO 
CGE_CODACQ			= ___CODACQ
CGE_PRIPAGA			= ___PRIPAGA



CGE_XCAMBIO			= PUB_CAMBIO
CGE_XVALUTA			= "EUR"
CGE_XDATAVAL		= ___dtscad 
CGE_XANOMAX			= SPACE(3) 
CGE_CECO			= SPACE(10)
CGE_SEQUEN			= 20				&& AD OGNI RIGA INSERITA SOMMARE 10 

IF pub_consolida_prev=1
	PUB_TIPOGE			= "PREVISIONALE"	&& CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ELSE
	PUB_TIPOGE			= "EFFETTIVA"	&& CONSIDERA LA REGISTRAZIONE COME REGISTRAZNE EFFETTIVA
ENDIF
CGE_COMM 			= "PAGAMENTO N.: "+ALLTRIM(CGE_NDOC)+" DEL "+CGE_DATADOC
CGE_COM1 			= "REGISTRAZIONE DEL : "+CGE_DATAREG


=AQUAREP("FOR",_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC)





RETURN



******************************************************************************
FUNCTION RICERCA_FORNITORE           && RICERCA DATI ANAGRAFICI DEL FORNITORE
******************************************************************************
PARA CODICE_FORNITORE 

x_codi = "for_codcli = '" + ALLTRIM(SUBSTR(CODICE_FORNITORE,PUB_SOTTOG,PUB_CONTO)) + "'"
x_cond = x_codi
cSql = "select * from u_for_an where " + x_cond + " order by for_codcli"
IF !ExecCommand(cSql,"CUR_FORNITORE")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORE
GO TOP
IF EOF()
   =MESSAGEBOX("Nessun fonitore selezionato",64,"*** INFORMAZIONE ***")
   return(.f.)
endif

___COSATRATTA 		= FOR_COSATRATTA
___GRADOIMPORTANZA 	= FOR_GRADOIMPORTANZA
___FORMAPAGAMENTO 	= FOR_FORMAPAGAMENTO
___TIPOCONTRATTO 	= FOR_TIPOCONTRATTO
___CODACQ 			= ALLTRIM(FOR_CODACQ)	
___PRIPAGA 			= ALLTRIM(FOR_PRIPAGA)	

___RAGSOC  			= FOR_RAGSOC

RETURN(___RAGSOC)

***********************************************************
FUNCTION RICERCA_CONTO
***********************************************************
PARA CONTO_CONTABILE 
 
         

    *!*	PRELEVA LA DESCRIZIONE DEL CONTO CONTABILE
    
	x_soci = "con_soc = '" + PUB_CODSOC + "'"
	x_anno = "con_anno = '" + PUB_ANNO + "'"
	x_cont = "con_conto = '" + ALLTRIM(CONTO_CONTABILE) + "'"
	x_cond = x_soci + " and " + x_anno + " and " + x_cont
	Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
	IF !ExecCommand(cSql,"conti")
	   return(.f.)
	ENDIF
	SELECT conti
	GO TOP
	IF EOF()
	   return(.f.)
	ENDIF
  
    
	CGE_DESCO  			= CON_DESCR



RETURN(CGE_DESCO)

