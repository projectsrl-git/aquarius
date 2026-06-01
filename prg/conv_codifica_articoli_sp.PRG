*************************************************************************************************
*							CONVERSIONE ANAGRAFICA Articoli/tabella Attività					*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2010 				 																*
*************************************************************************************************

*** DEFINIZIONE VARIABILI



*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica articoli/parametro attività per studi professionali	 ?",292,"ATTENZIONE")
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


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA ARTICOLI" NOWAIT

		IF !ExecCommand("select * from U_ART_PR where 1=0","curs_u_art_pr")
		   return
		ENDIF

		IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
		   return
		ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_CLI_AN SQL ESCLUDENDO IL CODICE CLIENTE STUDIO PER LA GESTIONE AZIENDA



		__SOC= "01"
		__ART= "." 

		x_soci = "art_codsoc = '" + __SOC + "'"
		x_codi = "art_codpri <> '" + __ART + "'"
		x_cond = x_soci + " and " + x_codi

		cSql   = "delete from U_ART_PR where " + x_cond 
		IF !ExecCommand(cSql,"U_ART_PR")
		   return(.f.)
		ENDIF

		*!*	*** CANCELLAZIONE DEI RECORD DELLA TABELLA PARA SQL

		cSql = "delete from PARA where CODICE LIKE 'AST%' "
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

			
		CREATE CURSOR IMPORTAXLS (__CODATT  c(05),;
			__DESATT   c(100),;
			__DESATT2   c(100),;
			__RICAVOXDIP N(16,3),;
			__COSTOXDIP N(16,3),;
			__FINO_A N(16,3),;
			__FINO_A_RICAVOXDIP N(16,3),;			
			__FINO_A_COSTOXDIP N(16,3),;
			__OLTRE_A N(16,3),;
			__OLTRE_A_RICAVOXDIP N(16,3),;
			__OLTRE_A_COSTOXDIP N(16,3))


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

		        
		        IF ALLTRIM(M.__CODATT) ="cod."
			       SELECT IMPORTAXLS   && scarto i record non contenente dati ATTIVITA'
			       SKIP +1
			       LOOP
			    ENDIF 
		        
		        IF EMPTY(M.__DESATT)
			       SELECT IMPORTAXLS   && scarto i record non contenente dati ATTIVITA'
			       SKIP +1
			       LOOP
			    ENDIF 


                M.CODATT = '0'+ALLTRIM(SUBSTR(M.__CODATT,2,8))
		        M.CODICE = 'AST'+M.CODATT
			    M.DESCRI = ALLTRIM(M.__DESATT) + ' ' + ALLTRIM(M.__DESATT2)
*!*				    M.DESCRI = UPPER(M.DESCRI)
			    M.DESCRI = APITOSPA(M.DESCRI)


                SELECT curs_PARA				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
 			  	APPEND BLANK               
			    GATHER MEMVAR MEMO 				&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

				REPLACE PAR_COSTCAD1 WITH M.__COSTOXDIP                  
				REPLACE PAR_RICCAD1  WITH M.__RICAVOXDIP  
				REPLACE PAR_FINOA    WITH M.__FINO_A
				REPLACE PAR_COSFINOA WITH M.__FINO_A_COSTOXDIP
				REPLACE PAR_RICFINOA WITH M.__FINO_A_RICAVOXDIP
				REPLACE PAR_OLTREA   WITH M.__OLTRE_A
				REPLACE PAR_COSOLTRA WITH M.__OLTRE_A_COSTOXDIP
				REPLACE PAR_RICOLTRA WITH M.__OLTRE_A_RICAVOXDIP
				                  
 
 
            		
		 
			  	SELECT curs_u_art_pr			&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
			  	APPEND BLANK


				REPLACE ART_CODSOC WITH __SOC
				REPLACE ART_CODPRI WITH M.CODATT
				REPLACE ART_DESCR  WITH ALLTRIM(M.__DESATT)
				REPLACE ART_DESEST WITH ALLTRIM(M.__DESATT2)			
				REPLACE ART_UNIMIS WITH 'NR'
				REPLACE ART_UMMAGA WITH 'NR'  && ERASMO  - 30/08/2010
				REPLACE ART_LINEA  WITH '05'
				REPLACE ART_PRZVEN WITH 0
				REPLACE ART_PRZVE2 WITH 0
				REPLACE ART_PRZVE3 WITH 0
				REPLACE ART_PRZVE4 WITH 0
				REPLACE ART_PRZVE5 WITH 0
				REPLACE ART_PRZCOS WITH 0
				REPLACE ART_CODIVA WITH '20'
				REPLACE ART_MAGA   WITH 'SEDE'

				REPLACE ART_CCO    WITH ''
				
				
				M._DATINS = RIBALTA2(DTOC(DATE()))
				=CAMBIADT(M._DATINS,"ART_DATINS")

				*REPLACE ART_CODMAT WITH '005'
				REPLACE ART_CODMAT WITH '001'  && ERASMO  - 30/08/2010
				REPLACE ART_DESMAT WITH 'GENERICO'  && ERASMO  - 30/08/2010
				REPLACE ART_TIPART WITH 'A'
				REPLACE ART_DISBAS WITH 'S'
				REPLACE ART_RIPCOM WITH 'S'
				REPLACE ART_TIPOPR WITH ''				
				
				
				****** AGGIORNA TABELLA PARA SQL

				IF !ExecRW('','PARA','I','','curs_para')
				   return(.f.)
				ENDIF



				****** AGGIORNA TABELLA U_ART_PR SQL

				IF !ExecRW('','U_ART_PR','I','','curs_u_art_pr')
				   return(.f.)
				ENDIF



				****** RIPUISCE IL CURSORI STP DELL'ANAGRAFICA ARTICOLI

				IF !ExecCommand("select * from U_ART_PR where 1=0","curs_u_art_pr")
				   return
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


   
