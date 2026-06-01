*************************************************************************************************
*							CONVERSIONE VOCI PAGA SISPAC DA RIFATTURARE							*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Luglio 2010 				 																*
*************************************************************************************************

*** DEFINIZIONE VARIABILI



*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"della tabella voci paga sispac da rifatturare ?",292,"ATTENZIONE")
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
		**=> ERASMO - FINE 18/06/2010

		SET DEFAULT TO &V_PATH 

****** DEFINIZIONE DEI CURSORI STP


		IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
		   return
		ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL

		cSql = "delete from PARA where CODICE LIKE 'CSI%' "
		IF !ExecCommand(cSql,"PARA")
		   return(.f.)
		ENDIF

******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO

		RELEASE Y_CAMPO,V_CAMPO,_CTR,_PROGRE,___CODICE_CLIENTE_TROVATO,_PROGRESSIVO_CLIENTE,M.CLI_CODCLI,__SEQUEN,M.TAGGANCIO,M.IDATTIVITA,A 
		PUBLIC Y_CAMPO,V_CAMPO,_CTR,_PROGRE,___CODICE_CLIENTE_TROVATO,_PROGRESSIVO_CLIENTE,M.CLI_CODCLI,__SEQUEN,M.TAGGANCIO,M.IDATTIVITA,A
		Y_CAMPO = ""
		V_CAMPO = ""
		_CTR    = 0
		_PROGRE = ""
		___CODICE_CLIENTE_TROVATO = .F.
		_PROGRESSIVO_CLIENTE = 2
		M.CLI_CODCLI = ""
		__SEQUEN = 0
		M.TAGGANCIO	= ""
		M.IDATTIVITA = ""
		A = 1



**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA

		WAIT WINDOWS "ATTENDERE PREGO, CARICAMENTO FILE DA CONVERTIRE" NOWAIT


		gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			
			SET DEFAULT TO &PUB_DIR  && ERASMO - 08/07/2010
			
			RETURN
		ENDIF


		WAIT WINDOWS "Selezionato file EXCEL "+gcFile 	NOWAIT 	

			
		CREATE CURSOR IMPORTAXLS (__DESVOCE   c(100),;
			__CODVOCE  c(05))



		SELECT IMPORTAXLS
		APPEND FROM (gcFile) TYPE xls	


***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP



		SELECT IMPORTAXLS
		GO TOP 


		DO WHILE !EOF()

		    IF DELETED()
		       SELECT IMPORTAXLS   && scarto i record cancellati
		       SKIP +1
		       LOOP
		    ENDIF 
		    
		    
		    
		        SCATTER MEMVAR memo

		        
		        IF ALLTRIM(M.__DESVOCE) ="descrizione"
			       SELECT IMPORTAXLS   && scarto i record non contenente dati ATTIVITA'
			       SKIP +1
			       LOOP
			    ENDIF 
		        

                M.CODVOCE 	= ALLTRIM(SUBSTR(M.__CODVOCE,1,3))
		        M.CODICE 	= 'CSI'+M.CODVOCE 
			    M.DESCRI 	= ALLTRIM(M.__DESVOCE)  
			    M.DESCRI 	= APITOSPA(M.DESCRI)


                SELECT curs_PARA				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
 			  	APPEND BLANK               
			    GATHER MEMVAR MEMO 				&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

           		
				
				
				****** AGGIORNA TABELLA PARA SQL

				IF !ExecRW('','PARA','I','','curs_para')
				   return(.f.)
				ENDIF


  			    ****** RIPUISCE IL CURSORI STP DEI PARAMETRI

				IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
				   return
				ENDIF

												   
		   		_CTR = _CTR +1
		   		WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
		   
		    	
		    	
		    	
		    SELECT IMPORTAXLS
			SKIP
		ENDDO





=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


   
