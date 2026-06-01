*************************************************************************************************
*						    CONVERSIONE CODICI CONDIZIONI DI PAGAMENTO    						*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2013 : Cardioline 				 													*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei codici condizioni di pagamento in formato testo ?",292,"ATTENZIONE")
		IF RIT = 7
		   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
		   RETURN
		ENDIF


** ASSEGNAZIONE DELLA VARIABILE PATH **************************
		
		
		=OPENDB("PERCORSO")
		SELECT PERCORSO
		SET ORDER TO I_TIPO

		SELECT PERCORSO
		V_PATH = ALLTRIM(PER_PATH)
		
		IF DIRECTORY(V_PATH)
		ELSE
			MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
				"Controllare il file PERCORSO.DBF",16,"Attenzione")
			RETURN .F.
		ENDIF

		SET DEFAULT TO &V_PATH 


****** DEFINIZIONE DEI CURSORI STP

		IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
		   return
		ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA CONDIZIONI DI PAGAMENTO SQL 


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA CONDIZIONI DI PAGAMENTO" NOWAIT
		cSql = "delete from PARA where CODICE LIKE 'CPA%' "
		IF !ExecCommand(cSql,"PARA")
		   return(.f.)
		ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0




		gcFile = GETFILE('TXT', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF



		WAIT WINDOWS "Selezionato file TESTO >>>>>>>>>>> "+gcFile 		

*!*			CREATE CURSOR IMPORTATXT (CAMPO1  c(200),;
*!*				CAMPO2   c(100))

		CREATE CURSOR IMPORTATXT (CAMPO1  c(200))
			
		
		APPEND FROM (gcFile) TYPE sdf		


***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTATXT
GO TOP 


DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTATXT   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    IF SUBSTR(CAMPO1,12,04) = "Riga"
       SELECT IMPORTATXT   && scarto il record 
       SKIP +1
       LOOP
	ENDIF     
        
    
    IF EMPTY(ALLTRIM(SUBSTR(CAMPO1,14,01)))
	    IF EMPTY(ALLTRIM(SUBSTR(CAMPO1,01,01)))
	       SELECT IMPORTATXT   && scarto il record 
	       SKIP +1
	       LOOP
	    ENDIF 
	ENDIF     
    
 
    IF SUBSTR(CAMPO1,01,06) = "Attivo"
       SELECT IMPORTATXT   && scarto il record 
       SKIP +1
       LOOP
    ENDIF     
  
  
    IF SUBSTR(CAMPO1,01,05) = "99999" OR SUBSTR(CAMPO1,01,05) = "00002"
       SELECT IMPORTATXT   && scarto il record 
       SKIP +1
       LOOP
    ENDIF       
  
  
    IF !EMPTY(ALLTRIM(SUBSTR(CAMPO1,12,01)))	&& PER OGNI RECORD DI TESTATA IL PROGRAMMA ELABORA I SUOI DETTAGLI E CREA IL CURSORE DELLE CPA
		=ELABORA_RECORD_TESTATA()   
    ENDIF 

		    
    	
    SELECT IMPORTATXT
	SKIP

ENDDO

	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

********************************
FUNCTION ELABORA_RECORD_TESTATA
********************************


	M.CODICE0 	=SUBSTR(CAMPO1,12,04)	
	M.CODICE1   =CONV_CLEAR(APITOSPA(ALLTRIM(M.CODICE0))) 
	M.CODICE2   =CARDIOLINE_DECODIFICA_CODICE_CPA(M.CODICE1)
	M.CODICE    ="CPA"+M.CODICE2
    M.DESCRI 	=ALLTRIM(APITOSPA(ALLTRIM(SUBSTR(CAMPO1,24,50))))	
	M.DESCRI    =CONV_CLEAR(APITOSPA(ALLTRIM(M.DESCRI))) 
   	M.LIBERA	=""


	cSql = "select * from PARA where CODICE ='CPA"+ALLTRIM(M.CODICE2)+"'"
	IF !ExecCommand(cSql,"___temp_cpa")
	   RETURN .F.
	ENDIF
	SELECT ___temp_cpa
	GO TOP
	IF EOF()
	ELSE
		RETURN
    ENDIF       



	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

	=ELABORA_RECORD_DETTAGLIO()			&& ELABORA I RECORD DI DETTAGLIO DELLA SPECIFICA CPA CONTENENTI INFORMAZIONI RELATIVE AI GIORNI ED ALLE PERCENTUALI DI RIPARTIZIONE IMPORTI


    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT



RETURN

*********************************
FUNCTION ELABORA_RECORD_DETTAGLIO
*********************************

S_CARD_S=STR(SELECT())

SELECT IMPORTATXT
__SONO_SU_QUESTO_RECORD = RECNO()


_RIBA 			= " "
_POSIZIONE_RIBA = AT("RB",ALLTRIM(APITOSPA(ALLTRIM(SUBSTR(CAMPO1,24,50)))))	&& CERCO RB
IF _POSIZIONE_RIBA = 0			&& NON TROVATO CERCO R.B
	_POSIZIONE_RIBA = AT("R.B",ALLTRIM(APITOSPA(ALLTRIM(SUBSTR(CAMPO1,24,50)))))
	IF _POSIZIONE_RIBA = 0		&& NON TROVATO
	ELSE
		_RIBA 	= "X"			&& E' UNA RI.BA	
	ENDIF
ELSE
	_RIBA 	= "X"				&& E' UNA RI.BA
ENDIF


TIPOLOGIA_PAGAMEN = ALLTRIM(SUBSTR(CAMPO1,93,15))					&& DA DATA FATTURA/DA FINE MESE
_FINE_MESE = "DF"
IF TIPOLOGIA_PAGAMEN = "Da data fattura"
	_FINE_MESE = "DF"
ENDIF
IF TIPOLOGIA_PAGAMEN = "Da fine mese"
	_FINE_MESE = "FM"			
ENDIF



*!*	ELABORA I RECORD DI DETTAGLIO CONTNENTI I GIORNI E LA PERCENTUALE DI RIPARTIZIONE IMPORTO
SELECT IMPORTATXT
SKIP +1				&& SI SPOSTA SUL PRIMO RECORD DI DETTAGLIO

M.SCADEN      						= ""
M.PERCENTUALI 						= ""
HO_TROVATO_ALMENO_UNA_PERCENTUALE 	= .F.

DO WHILE .NOT.EOF()

    IF !EMPTY(ALLTRIM(SUBSTR(CAMPO1,14,01))) 							&& VERIFICA SE SONO TERMINATI I RECORD ASSOCIATI ALLA SCADENZA DA ELABORARE
		IF !EMPTY(ALLTRIM(SUBSTR(CAMPO1,01,01))) 
			EXIT
		ENDIF	  
    ENDIF 

	INTERVALLO_GIORNI = ALLTRIM(SUBSTR(CAMPO1,24,03))
	RIPARTIZIONE_PERC = ALLTRIM(SUBSTR(CAMPO1,75,07))
	IF VAL(RIPARTIZIONE_PERC) <> 0
		HO_TROVATO_ALMENO_UNA_PERCENTUALE = .T.
	ENDIF

	M.SCADEN        = M.SCADEN + INTERVALLO_GIORNI + " "				&& SI COMPONE I GIORNI DI INTERVALLO
	M.PERCENTUALI   = M.PERCENTUALI + RIPARTIZIONE_PERC + " " 			&& SI COMPONE LE PERCENTUALI DI RIPARTIZIONE IMPORTO



    SELECT IMPORTATXT
	SKIP
	
ENDDO

IF !HO_TROVATO_ALMENO_UNA_PERCENTUALE 
	M.PERCENTUALI = "" 													&& NON ESISTONO PERCENTUALI DA GESTIRE
ENDIF

*!*	DF BON    90 120                                                                                                                                                                                        
*!*	FM       X30 60 90                                                                                                                                                                                      
IF _RIBA  = "X"                                                                                                                                                                                      
	M.LIBERA = _FINE_MESE + SPACE(07) + _RIBA + M.SCADEN 
ELSE
	M.LIBERA = _FINE_MESE + SPACE(01) + "BON" + SPACE(03) + _RIBA + M.SCADEN 
ENDIF

SELECT curs_PARA							&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
REPLACE LIBERA		WITH M.LIBERA
REPLACE PERCENTUALI	WITH M.PERCENTUALI


SELECT IMPORTATXT
GO __SONO_SU_QUESTO_RECORD 	&& MI RIPOSIZIONO SUL RECORD DI TESTATA DELLA CONDIZIONE DI PAGAMENTO



SELECT &S_CARD_S

RETURN
