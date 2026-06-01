*************************************************************************************************
*							COMPLETAMENTO ANAGRAFICA FORNITORI									*
*						 																	    *
*	Completa informazioni come :															    *
*						 																	    *
*			Banca fornitore 			 			53  per 15 COLONNA 2 84 5				    *
*			Agenzia fornitore 			 			53  per 17 COLONNA 2 84 5				    *
*			C/C fornitore							14	per 13 COLONNA 1 36 15				    *
*			Cliente corrispondente					14	per 22 COLONNA 1 43 06				    *
*						 																	    *
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2011 : Xilopan 			 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con il completamento "+CHR(13)+"dell'anagrafica FORNTORI in formato testo	(BANCA/CC/CLI CEE) ?",292,"ATTENZIONE")
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

		IF !ExecCommand("select * from u_for_an where 1=0","curs_u_for_an")
		   return
		ENDIF


*!*	*** CANCELLAZIONE DEI RECORD DELLA TABELLA GRUPPI MERCEOLOGICI SQL 


*!*			WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA GRUPPI MERCEOLOGICI" NOWAIT


*!*			cSql = "delete from u_for_an"
*!*			IF !ExecCommand(cSql,"u_for_an")
*!*			   return(.f.)
*!*			ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO

		RELEASE __DATINS,_CTR
		PUBLIC __DATINS,_CTR
		__DATINS = DTOC(DATE())
		_CTR = 0

        RELEASE _key_para
        PUBLIC _key_para
        _key_para = 0

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
	__CONTA_INS = 0
	SALVA_CODFOR    = ""


	DO WHILE !EOF()

	    IF DELETED()
	       SELECT IMPORTATXT   && scarto i record cancellati
	       SKIP +1
	       LOOP
	    ENDIF 
	    

        
	    IF SUBSTR(CAMPO1,1,11) = "-----------"
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         
	        
   
	  
	    IF SUBSTR(CAMPO1,1,11) = "XILOPAN    "
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         
	  
	  
	    IF SUBSTR(CAMPO1,1,11) = "Stato Codic"
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         
	  

	    
	*!*	#####################################################

		M.FOR_CODSOC	= PUB_CODSOC

	    __CODICE_ROTTURA = ALLTRIM(SUBSTR(CAMPO1,07,06)) 
	    IF  EMPTY(__CODICE_ROTTURA) OR __CODICE_ROTTURA = "-" 
	    ELSE
			M.FOR_CODCLI	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,07,06)))
			M.FOR_CODCLI 	= TRC(PUB_LCL,ALLTRIM(M.FOR_CODCLI))
			SALVA_CODFOR    = M.FOR_CODCLI 
		    _CTR = _CTR +1
		    WAIT WINDOWS "RECORDS AGGIORNATI : "+STR(_CTR,10,0) NOWAIT
	    ENDIF 
    

		*!*	IMPOSTA I VALORI DI DEFAULT DELLE VARIABILI GESTITE------------------------------------

		M.for_ba2abi	= ""
		M.for_ba2cab  	= ""
		m.for_ba2cc     = ""
		M.for_clicee	= ""


		_PAROLA	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,53,15)))	
        IF _PAROLA  = "Banca fornitore"
			M.C = ALLTRIM(APITOSPA(ALLTRIM(SUBSTR(CAMPO1,84,05))))
        ENDIF

		_PAROLA	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,53,17)))	
        IF _PAROLA  = "Agenzia fornitore"
			M.for_ba2cab = ALLTRIM(APITOSPA(ALLTRIM(SUBSTR(CAMPO1,84,05))))
        ENDIF
 
 	  
 		_PAROLA	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,36,15)))	
        IF _PAROLA  = "C/C fornitore"
			m.for_ba2cc  = ALLTRIM(APITOSPA(ALLTRIM(SUBSTR(CAMPO1,36,15))))
        ENDIF
    


 		_PAROLA	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,14,22)))	
        IF _PAROLA  = "Cliente corrispondente"
			M.for_clicee  = ALLTRIM(APITOSPA(ALLTRIM(SUBSTR(CAMPO1,43,06))))
			IF !EMPTY(ALLTRIM(M.for_clicee))
				M.for_clicee  = TRC(PUB_LCL,ALLTRIM(M.for_clicee))
    		ENDIF 
        ENDIF
  

	 	SELECT curs_u_for_an					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
	   	APPEND BLANK
	   	GATHER MEMVAR MEMO 						&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 


		x_codc  = "FOR_CODCLI = '" + M.FOR_CODCLI + "'"
		x_cond  = x_codc 
		cSql = "select * from u_for_an where " + x_cond + " order by FOR_CODCLI"
		IF !ExecCommand(cSql,"u_for_an")
		   RETURN .F.
		ENDIF

		SELECT u_for_an
		GO TOP
		IF !EOF()
		
	
	        IF !EMPTY(ALLTRIM(M.for_ba2abi))
				REPLACE for_ba2abi  WITH M.for_ba2abi 
	        ENDIF


	        IF !EMPTY(ALLTRIM(M.for_ba2cab))
				REPLACE for_ba2cab WITH M.for_ba2cab
	        ENDIF
 
 
 	        IF !EMPTY(ALLTRIM(m.for_ba2cc))
				REPLACE for_ba2cc  WITH m.for_ba2cc
	        ENDIF


 	        IF !EMPTY(ALLTRIM(M.for_clicee))
				REPLACE for_clicee  WITH M.for_clicee
	        ENDIF



			SELECT u_for_an
			
			IF !ExecRW('','u_for_an','I','','u_for_an')
			  return(.f.)
			ENDIF	
		ENDIF





	    M.FOR_CODCLI 	= SALVA_CODFOR    
	    
	    SELECT IMPORTATXT
		SKIP

	ENDDO
 


	
	=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

	SET DEFAULT TO &PUB_DIR

	RETURN




RETURN


