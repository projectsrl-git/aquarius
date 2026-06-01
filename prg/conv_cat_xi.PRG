*************************************************************************************************
*							CONVERSIONE CLASSE MERCEOLOGICA										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Novembre 2011 : Xilopan 			 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"anagrafica GRUPPI MERCEOLOGICI in formato testo	 ?",292,"ATTENZIONE")
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


*** CANCELLAZIONE DEI RECORD DELLA TABELLA GRUPPI MERCEOLOGICI SQL 


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA GRUPPI MERCEOLOGICI" NOWAIT


		cSql = "delete from PARA where CODICE LIKE 'MER%' "
		IF !ExecCommand(cSql,"PARA")
		   return(.f.)
		ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO

		RELEASE __DATINS,_CTR
		PUBLIC __DATINS,_CTR
		__DATINS = DTOC(DATE())
		_CTR = 0



**** CARICAMENTO DEL FILE IN FORMATO TESTO




		gcFile = GETFILE('TXT', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF



		WAIT WINDOWS "Selezionato file di testo  >>>>>>>>>>> "+gcFile 		

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
	    

	    IF ALLTRIM(CAMPO1) = "*** FINE STAMPA ***"
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF 
	    
	    IF ALLTRIM(CAMPO1) = "Gestione tabelle"
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF 
 	    
	        
	    IF SUBSTR(CAMPO1,1,11) = "-----------"
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         
	        
	    IF SUBSTR(CAMPO1,1,11) = "Richiedente"
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         
	  
	    IF SUBSTR(CAMPO1,1,11) = "Data       "
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         
	  
	  
	    IF SUBSTR(CAMPO1,1,11) = "Ora        "
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         

	    IF SUBSTR(CAMPO1,1,11) = "MAGIC      "
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF      

	    IF SUBSTR(CAMPO1,1,11) = "Gruppo Merc"
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF      


	    IF SUBSTR(CAMPO1,1,11) = "           "
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF      
		  	  
	    IF SUBSTR(CAMPO1,1,11) = "Cd merceol."
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF      

	    IF SUBSTR(CAMPO1,1,11) = "Cd merceol."
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF      

	    
	*!*	#####################################################



		M.CODICE 	= "MER"+ALLTRIM(SUBSTR(CAMPO1,4,3))
	   	M.DESCRI 	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,19,42)))	
	   	*M.LIBERA	= ""
	   	M.LIBERA	= ALLTRIM(SUBSTR(CAMPO1,62,3))  && ERASMO - 13/12/2011 - INSERIMENTO FAMIGLIA DELLA CATEGORIA MERCEOLOGICA

	 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
	   	APPEND BLANK
	   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
	    SCATTER MEMVAR MEMO


		x_cond = "codice = '" + M.CODICE + "'"
		cSql = "select * from PARA where " + x_cond + " order by CODICE"



		IF !ExecCommand(cSql,"PARA")
		   RETURN .F.
		ENDIF

		SELECT PARA
		GO TOP
		IF EOF()
			APPEND BLANK
		ENDIF
		DO PARA
		IF !ExecRW('','PARA','I','','PARA')
		  return(.f.)
		ENDIF	





	    _CTR = _CTR +1
	    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

	    	
	    SELECT IMPORTATXT
		SKIP

	ENDDO

	*!*		 
	*!*	****** AGGIORNA TABELLA PARASQL
	*!*	IF !ExecRW('','PARA','I','','curs_PARA')
	*!*	   return(.f.)
	*!*	ENDIF
	*!*		 
	*!*		 
	=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

	SET DEFAULT TO &PUB_DIR

	RETURN


 