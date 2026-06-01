*************************************************************************************************
*							CONVERSIONE SCONTI PER CATEGORIA MERCEOLOGICA						*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Novembre 2011 : Xilopan 			 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"anagrafica SCONTI PER CATEGORIA MERCEOLOGICA in formato testo	 ?",292,"ATTENZIONE")
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

		IF !ExecCommand("select * from U_SCO_CM where 1=0","curs_U_SCO_CM")
		   return
		ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA GRUPPI MERCEOLOGICI SQL 


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA GRUPPI MERCEOLOGICI" NOWAIT


		cSql = "delete from U_SCO_CM"
		IF !ExecCommand(cSql,"U_SCO_CM")
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
	    

	    IF SUBSTR(CAMPO1,1,11) = "30/11/11   "
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF      
	        
	    IF SUBSTR(CAMPO1,1,11) = "-----------"
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         
	        
   
	  
	    IF SUBSTR(CAMPO1,1,11) = "CLIENTE    "
	       SELECT IMPORTATXT   && scarto i record 
	       SKIP +1
	       LOOP
	    ENDIF         
	  

	    
	*!*	#####################################################

		M.SCO_CODSOC	= PUB_CODSOC

	    __CODICE_ROTTURA = ALLTRIM(SUBSTR(CAMPO1,01,06)) 
	    IF  !EMPTY(__CODICE_ROTTURA) 
			M.SCO_CODCLI	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,01,06)))
			M.SCO_CODCLI 	= TRC(PUB_LCL,ALLTRIM(M.SCO_CODCLI))
			M.SCO_RAGSOC	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,08,35)))	
	    ENDIF 
    
	
		M.SCO_CATMER	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,44,03)))	
		M.SCO_DESMER	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,48,40)))	
		M.SCO_DATLIS	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,126,02)))
		IF LEN(M.SCO_DATLIS) = 1
			M.SCO_DATLIS = "0"+M.SCO_DATLIS
		ENDIF
		M.SCO_DATLIS	= M.SCO_DATLIS+"/"+APITOSPA(ALLTRIM(SUBSTR(CAMPO1,128,02)))+"/"+APITOSPA(ALLTRIM(SUBSTR(CAMPO1,130,02)))
        M.SCO_DATLIS    = OK_DATA(M.SCO_DATLIS)
        M.SCO_ALLIST    = "31/12/2999"

				
		M.SCO_SC1		= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,88,06)))
		M.SCO_SC1   	= VAL(M.SCO_SC1)
		*M.SCO_SC1   	= VAL(REPLACEALLCHR(M.SCO_SC1,".",""))			
				
		M.SCO_SC2		= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,98,06)))
		M.SCO_SC2   	= VAL(M.SCO_SC2)
		*M.SCO_SC2   	= VAL(REPLACEALLCHR(M.SCO_SC2,".",""))			

		M.SCO_SC3		= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,108,06)))
		M.SCO_SC3   	= VAL(M.SCO_SC3)
		*M.SCO_SC3   	= VAL(REPLACEALLCHR(M.SCO_SC3,".",""))			
		
		
		M.SCO_SC4		= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,118,06)))
		M.SCO_SC4   	= VAL(M.SCO_SC4)
		*M.SCO_SC4   	= VAL(REPLACEALLCHR(M.SCO_SC4,".",""))			

		M.SCO_CODVAL	= "EUR"	


	 	SELECT curs_U_SCO_CM					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
	   	APPEND BLANK
	   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
	    SCATTER MEMVAR MEMO


		x_codc  = "sco_codcli = '" + M.SCO_CODCLI + "'"
		x_catm  = "sco_catmer = '" + M.SCO_CATMER + "'"
		x_cond  = x_codc + " and " + x_catm  
		cSql = "select * from U_SCO_CM where " + x_cond + " order by sco_codcli"
		IF !ExecCommand(cSql,"U_SCO_CM")
		   RETURN .F.
		ENDIF

		SELECT U_SCO_CM
		GO TOP
		IF EOF()
			APPEND BLANK
		ENDIF
		DO U_SCO_CM
		IF !ExecRW('','U_SCO_CM','I','','U_SCO_CM')
		  return(.f.)
		ENDIF	





	    _CTR = _CTR +1
	    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

	    	
	    SELECT IMPORTATXT
		SKIP

	ENDDO

	*!*		 
	*!*	****** AGGIORNA TABELLA U_SCO_CMSQL
	*!*	IF !ExecRW('','U_SCO_CM','I','','curs_U_SCO_CM')
	*!*	   return(.f.)
	*!*	ENDIF
	*!*		 
	*!*		 
	=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

	SET DEFAULT TO &PUB_DIR

	RETURN


 