*************************************************************************************************
*							CONVERSIONE EMAIL 													*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2011 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'email clienti da foglio Execl	 ?",292,"ATTENZIONE")
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

		CREATE CURSOR IMPORTAXLS (CLI_CODCLI  c(06),;
			CLI_RAGSOC   c(80),;			
			CLI_LOCALI   c(80),;
			CLI_PROVIN   c(02),;
			CLI_TELEFO   c(30),;
			CLI_PARIVA   c(11),;
			CLI_CONPAG   c(03),;
			CLI_DESPAG   c(80),;
			CLI_TIPO	 c(05),;
			CLI_EMAIL    c(150))

		
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
    

    IF ALLTRIM(CLI_CODCLI) = "Codice"
       SELECT IMPORTAXLS   && scarto primo record
       SKIP +1
       LOOP
    ENDIF 


    
    
*!*	#####################################################


    M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(CLI_CODCLI))
 	M.CLI_EMAIL	    = CLI_EMAIL								
 				


	* -->> aggiorna anagrafica
	* --------------------------
    x_soci  = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codc  = "cli_codcli = '" + M.CLI_CODCLI + "'"
	x_cond  = x_soci + " and " + x_codc
	cSql    = "select * from u_cli_an where " + x_cond + " order by cli_codcli"
	IF !ExecRW(cSql,"u_cli_an","R")
	   return(.f.)
	ENDIF
	  
	IF RECCOUNT() <> 0
	
	   REPLACE CLI_EMAIL   WITH M.CLI_EMAIL	  

	   IF !ExecRW(cSql,"u_cli_an","W")
	      return(.f.)
	   ENDIF

	ENDIF 




*!*	#####################################################

 							   
   	_CTR = _CTR +1
   	WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   

    	
    SELECT IMPORTAXLS
	SKIP

ENDDO



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 