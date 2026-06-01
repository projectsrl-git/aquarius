*************************************************************************************************
*							CONVERSIONE SCONTI X CLASSE MERCEOLOGICA							*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Novembre 2011 : Xilopan 			 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"anagrafica GRUPPI MERCEOLOGICI da foglio Execl	 ?",292,"ATTENZIONE")
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


*** CANCELLAZIONE DEI RECORD DELLA TABELLA NAZIONI SQL 


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA NAZIONI" NOWAIT


		cSql = "delete from PARA where CODICE LIKE 'MER%' "
		IF !ExecCommand(cSql,"PARA")
		   return(.f.)
		ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO

		RELEASE __DATINS,_CTR
		PUBLIC __DATINS,_CTR
		__DATINS = DTOC(DATE())
		_CTR = 0



**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA




		gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF



		WAIT WINDOWS "Selezionato file EXCEL >>>>>>>>>>> "+gcFile 		

		CREATE CURSOR IMPORTAXLS (CAMPO1  c(100),;
			CAMPO2   c(100),CAMPO3   c(100),CAMPO4   c(100),CAMPO5   c(100),CAMPO6   c(100))

		
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
	    

	    IF ALLTRIM(CAMPO2) = "30/11/2011"
	       SELECT IMPORTAXLS   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF 
	        
	    IF SUBSTR(CAMPO2,1,5) = "-----"
	       SELECT IMPORTAXLS   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         
	        

	    IF SUBSTR(CAMPO2,1,7) = "CLIENTE"
	       SELECT IMPORTAXLS   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         
	        


	    IF SUBSTR(CAMPO2,1,3) = "---"
	       SELECT IMPORTAXLS   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         
	        
	    
	*!*	#####################################################



		M.CODICE 	= "MER"+SUBSTR(CAMPO2,1,3)
	   	M.DESCRI 	= APITOSPA(ALLTRIM(SUBSTR(CAMPO3,5,100)))	
	   	M.LIBERA	= ""

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

	    	
	    SELECT IMPORTAXLS
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


 