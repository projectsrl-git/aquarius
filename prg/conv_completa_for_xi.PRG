*************************************************************************************************
*							COMPLETAMENTO ANAGRAFICA FORNITORI									*
*						 																	    *
*	Crea L'anagrafica del fornitore															    *
*	Crea tabella vettori 																	    *
*						 																	    *
*	by Sergio Piaggi per Project S.r.l.															*
*	Dicembre 2011 : Xilopan 			 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con il completamento "+CHR(13)+"dell'anagrafica FORNTORI in formato testo	 ?",292,"ATTENZIONE")
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

        RELEASE M.FOR_RAGSOC
        PUBLIC M.FOR_RAGSOC
        M.FOR_RAGSOC = ''
		RELEASE REC_INSERITI,REC_AGGIORNATI
		PUBLIC  REC_INSERITI,REC_AGGIORNATI
		REC_INSERITI = 0 
		REC_AGGIORNATI = 0
				

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
	__CONTA_INS = 0
	SALVA_CODFOR    = ""
 	_RAGDUE = ""	

 
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
		M.FOR_CONTO1 = ""


		M.FOR_PARIVA = "" 
		M.FOR_CODFIS = ""
		M.FOR_IVACEE = ""
        M.FOR_RAGSOC = ""
        M.FOR_RAGDUE = ""
        M.FOR_INDIR  = ""
        M.FOR_TELEFO = ""
		M.FOR_CAP    = ""
        M.FOR_LOCALI = ""
		M.FOR_PROVIN = ""
        M.FOR_NAZION = ""        
        M.FOR_FAX    = ""        
        M.FOR_CONPAG = ""
	    M.FOR_CODIVA  = "21"
		M.FOR_BA2ABI	= ""
		M.FOR_BA2CAB  	= ""
		M.FOR_BA2CC     = ""
		M.FOR_CLICEE	= ""
	 	M.FOR_DATNEW = RIBALTA2(DTOC(DATE()))
		M.FOR_DATINS = RIBALTA2(DTOC(DATE()))
		M.FOR_COSATRATTA 		= PUB_COSATRATTA
		M.FOR_GRADOIMPORTANZA 	= PUB_GRADOIMPORTANZA
		M.FOR_FORMAPAGAMENTO 	= PUB_FORMAPAGAMENTO
	    M.FOR_TIPOCONTRATTO 	= PUB_TIPOCONTRATTO
		M.FOR_CODACQ 			= ALLTRIM(PUB_CONAQUISTO)	
		M.FOR_PRIPAGA 			= ALLTRIM(PUB_PRIORITAPAGAMENTO)	




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
  

		_PAROLA	= ALLTRIM(SUBSTR(CAMPO1,53,19))	
        IF _PAROLA  = "Modalita' pagamento"
			M.FOR_CONPAG 	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,86,03)))
		ENDIF


		_PAROLA	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,45,03)))	
        IF _PAROLA  = "Fax"
			M.FOR_FAX 	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,49,20)))
		ENDIF


		_PAROLA	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,53,07)))	
        IF _PAROLA  = "Nazione"
			M.FOR_NAZION 	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,86,02)))
			IF  EMPTY(M.FOR_NAZION) 
			  	M.FOR_NAZION 	= "IT"
			ENDIF
		ENDIF

		_PAROLA	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,53,08)))	
        IF _PAROLA  = "Telefono"
			M.FOR_TELEFO 	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,69,20)))
			M.FOR_CAP       = APITOSPA(ALLTRIM(SUBSTR(CAMPO1,14,05)))
			M.FOR_LOCALI    = APITOSPA(ALLTRIM(SUBSTR(CAMPO1,20,26)))
			M.FOR_PROVIN    = APITOSPA(ALLTRIM(SUBSTR(CAMPO1,46,02)))
		ENDIF
		
		

		_PAROLA	= SUBSTR(CAMPO1,53,38)	
        IF _PAROLA  = SPACE(38)
            =COMPONE_RAGSOC()
		ENDIF

 			 			
		_PAROLA	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,53,11)))	
        IF _PAROLA  = "Partita IVA"
			M.FOR_PARIVA 	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,78,11)))
		ENDIF



		_PAROLA	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,53,14)))	
        IF _PAROLA  = "Codice fiscale"
			M.FOR_CODFIS 	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,73,16)))
			M.FOR_INDIR 	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,14,38)))
		ENDIF
        

        IF !EMPTY(ALLTRIM(M.FOR_CODFIS))
        	IF SUBSTR(M.FOR_CODFIS,3,1) = ""
        		M.FOR_IVACEE = M.FOR_CODFIS
				M.FOR_CODFIS = ""
        	ENDIF
        ENDIF



		_PAROLA	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,14,19)))	
        IF _PAROLA  = "Conto contropartita"
			M.FOR_CONTOX	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,36,09)))
			M.FOR_CONTO1	= ALLTRIM(SUBSTR(M.FOR_CONTOX,2,5) + SUBSTR(M.FOR_CONTOX,8,2)) 
        ENDIF
   
   

   

		x_codc  = "FOR_CODCLI = '" + M.FOR_CODCLI + "'"
		x_cond  = x_codc 
		cSql = "select * from u_for_an where " + x_cond + " order by FOR_CODCLI"
		IF !ExecCommand(cSql,"u_for_an")
		   RETURN .F.
		ENDIF

		SELECT u_for_an
		GO TOP
		IF EOF()
			SELECT u_for_an
			APPEND BLANK
			GATHER MEMVAR memo
		    REC_INSERITI = REC_INSERITI + 1		
		ELSE 
	   		REC_AGGIORNATI = REC_AGGIORNATI + 1		
		ENDIF

	
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


		REPLACE FOR_CODIVA WITH M.FOR_CODIVA
		REPLACE FOR_RAGDUE WITH M.FOR_RAGDUE 
		
	 	REPLACE FOR_DATNEW WITH M.FOR_DATNEW
		REPLACE FOR_DATINS WITH M.FOR_DATINS
		REPLACE FOR_COSATRATTA			WITH M.FOR_COSATRATTA
		REPLACE FOR_GRADOIMPORTANZA		WITH M.FOR_GRADOIMPORTANZA
		REPLACE FOR_FORMAPAGAMENTO		WITH M.FOR_FORMAPAGAMENTO
		REPLACE FOR_TIPOCONTRATTO		WITH M.FOR_TIPOCONTRATTO
		REPLACE FOR_PRIPAGA				WITH M.FOR_PRIPAGA
		REPLACE FOR_CODACQ 				WITH M.FOR_CODACQ 



		IF !EMPTY(ALLTRIM(M.FOR_CONPAG))
			REPLACE FOR_CONPAG WITH M.FOR_CONPAG 
		ENDIF

		IF !EMPTY(ALLTRIM(M.FOR_FAX))
			REPLACE FOR_FAX WITH M.FOR_FAX 
		ENDIF

		IF !EMPTY(ALLTRIM(M.FOR_NAZION))
			REPLACE FOR_NAZION WITH M.FOR_NAZION
		ENDIF

		IF !EMPTY(ALLTRIM(M.FOR_CAP))
			REPLACE FOR_CAP WITH M.FOR_CAP
		ENDIF

		IF !EMPTY(ALLTRIM(M.FOR_LOCALI))
			REPLACE FOR_LOCALI WITH M.FOR_LOCALI
		ENDIF

		IF !EMPTY(ALLTRIM(M.FOR_PROVIN))
			REPLACE FOR_PROVIN WITH M.FOR_PROVIN 
		ENDIF

		IF !EMPTY(ALLTRIM(M.FOR_TELEFO))
			REPLACE FOR_TELEFO WITH M.FOR_TELEFO
		ENDIF
		
		
		IF !EMPTY(ALLTRIM(M.FOR_RAGSOC))
			REPLACE FOR_RAGSOC WITH M.FOR_RAGSOC
		ENDIF

		IF !EMPTY(ALLTRIM(M.FOR_INDIR))
			REPLACE FOR_INDIR WITH M.FOR_INDIR
		ENDIF

	
		IF !EMPTY(ALLTRIM(M.FOR_PARIVA))
			REPLACE FOR_PARIVA WITH M.FOR_PARIVA
		ENDIF

		IF !EMPTY(ALLTRIM(M.FOR_CODFIS))
			REPLACE FOR_CODFIS WITH M.FOR_CODFIS
		ENDIF

		IF !EMPTY(ALLTRIM(M.FOR_IVACEE))
			REPLACE FOR_IVACEE WITH M.FOR_IVACEE
		ENDIF



	    IF !EMPTY(ALLTRIM(M.FOR_CONTO1)) 
			REPLACE FOR_CONTO1 WITH ALLTRIM(M.FOR_CONTO1)
		ENDIF
	

		SELECT u_for_an
		


		IF !ExecRW('','u_for_an','I','','u_for_an')
		  return(.f.)
		ENDIF	


	    M.FOR_CODCLI 	= SALVA_CODFOR    
	    
	    SELECT IMPORTATXT
		SKIP

	ENDDO
 

	WAIT WINDOWS "RECORD AGGIORNATI :"+STR(REC_AGGIORNATI,9,0)+ " RECORD INSERITI :" + STR(REC_INSERITI,9,0) 
	
	=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

	SET DEFAULT TO &PUB_DIR

	RETURN




RETURN



***********************
FUNCTION COMPONE_RAGSOC
*********************^^

SELE=SELECT()

DO CASE

	CASE SUBSTR(CAMPO1,14,09) = "Divisione"
	CASE SUBSTR(CAMPO1,14,15) = "Conto fornitori"
	CASE SUBSTR(CAMPO1,14,19) = "Conto contropartita"
	CASE SUBSTR(CAMPO1,14,19) = "Conto contropartita"			
	CASE SUBSTR(CAMPO1,14,22) = "Cliente corrispondente"
	CASE SUBSTR(CAMPO1,14,13) = "C/C fornitore"	
	CASE SUBSTR(CAMPO1,14,25) = "Registrazione predefinita"
	CASE SUBSTR(CAMPO1,14,19) = "Categoria contabile"
	CASE SUBSTR(CAMPO1,14,20) = "Modalita' spedizione"
	CASE SUBSTR(CAMPO1,14,18) = "Modalita' consegna"
	CASE SUBSTR(CAMPO1,14,05) = "Telex"



	OTHERWISE	

       	M.FOR_RAGSOC 	= APITOSPA(ALLTRIM(SUBSTR(CAMPO1,14,38)))
	
		SELECT IMPORTATXT     
		SKIP +1
		IF !EOF()
			DO CASE 
				CASE SUBSTR(CAMPO1,14,09) = "Divisione"
						M.FOR_RAGSOC 	= ""
				CASE SUBSTR(CAMPO1,14,15) = "Conto fornitori"
						M.FOR_RAGSOC 	= ""
				CASE SUBSTR(CAMPO1,14,19) = "Conto contropartita"
						M.FOR_RAGSOC 	= ""
				CASE SUBSTR(CAMPO1,14,19) = "Conto contropartita"			
						M.FOR_RAGSOC 	= ""
				CASE SUBSTR(CAMPO1,14,22) = "Cliente corrispondente"
						M.FOR_RAGSOC 	= ""
				CASE SUBSTR(CAMPO1,14,13) = "C/C fornitore"	
						M.FOR_RAGSOC 	= ""
				CASE SUBSTR(CAMPO1,14,25) = "Registrazione predefinita"
						M.FOR_RAGSOC 	= ""
				CASE SUBSTR(CAMPO1,14,19) = "Categoria contabile"
						M.FOR_RAGSOC 	= ""
				CASE SUBSTR(CAMPO1,14,20) = "Modalita' spedizione"
						M.FOR_RAGSOC 	= ""
				CASE SUBSTR(CAMPO1,14,18) = "Modalita' consegna"
						M.FOR_RAGSOC 	= ""
				CASE SUBSTR(CAMPO1,14,05) = "Telex"
						M.FOR_RAGSOC 	= ""
						
				OTHERWISE	
					_RAGDUE 		= ALLTRIM(APITOSPA(ALLTRIM(SUBSTR(CAMPO1,14,38))))
					IF !EMPTY(ALLTRIM(_RAGDUE))
			 			M.FOR_RAGSOC    = ALLTRIM(M.FOR_RAGSOC) + ALLTRIM(_RAGDUE)
			 		ENDIF
			ENDCASE
		ENDIF
		SKIP -1
	
ENDCASE


SELECT(SELE)
RETURN
