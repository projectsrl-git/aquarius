*************************************************************************************************
*							CONVERSIONE PROVVIGIONI AGENTI										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Luglio 2011 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica provvigioni da foglio Execl	 ?",292,"ATTENZIONE")
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


*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_AGE_AN SQL 



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = RIBALTA2(DTOC(DATE()))
_CTR = 0



**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA




		gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF



		WAIT WINDOWS "Selezionato file EXCEL >>>>>>>>>>> "+gcFile 		

		CREATE CURSOR IMPORTAXLS (CAMPO1  c(80),;
		    CAMPO2   c(80),;
		    CAMPO3   c(80),;
		    CAMPO4   c(80),;
		    CAMPO5   c(80),;
		    CAMPO6   c(80),;
		    CAMPO7   c(80))
		APPEND FROM (gcFile) TYPE xls	



***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP


SELECT IMPORTAXLS 
GO TOP


_CONTAREC = 0

DO WHILE .NOT. EOF()


    IF DELETED()
       SELECT IMPORTAXLS   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 
    
    
    
    IF EMPTY(ALLTRIM(CAMPO1)) 
       SELECT IMPORTAXLS   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 


    
    _CERCA_PAROLA_DUE_PUNTI = ":"
    _POSIZIONE_PAROLA_DUE_PUNTI = AT(_CERCA_PAROLA_DUE_PUNTI,CAMPO3)   
	IF _POSIZIONE_PAROLA_DUE_PUNTI <> 0
       SELECT IMPORTAXLS   && scarto i record non gestiti
       SKIP +1
       LOOP
	ENDIF

  
    IF ALLTRIM(CAMPO3) = "Ragione sociale" 
       SELECT IMPORTAXLS   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF   
 
 
    IF ALLTRIM(CAMPO1) = "Age" 
       SELECT IMPORTAXLS   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF   
  
    
    IF ALLTRIM(CAMPO1) = "* *" 
       SELECT IMPORTAXLS   && scarto i record non gestiti
       SKIP +1
       LOOP
    ENDIF 


  
   
*!*	#####################################################


    M.CLI_AGE = ALLTRIM(SUBSTR(CAMPO1,1,3))
    IF LEN(M.CLI_AGE) = 1
      M.CLI_AGE = "00"+M.CLI_AGE
    ENDIF

    IF LEN(M.CLI_AGE) = 2
      M.CLI_AGE = "0"+M.CLI_AGE
    ENDIF
    
    M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(SUBSTR(CAMPO2,1,10)))  
    
	_PROVVI 	= VAL(ALLTRIM(SUBSTR(CAMPO7,01,17)))

    x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
    x_codi = "cli_codcli = '" + M.CLI_CODCLI + "'"
    x_cond = x_soci + " and " + x_codi
    cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"

	IF !ExecRW(cSql,"u_cli_an","R")
	  return(.f.)
	ENDIF
	
	SELECT u_cli_an	
	IF RECCOUNT() <> 0
	
		REPLACE CLI_PROVVI WITH _PROVVI 
		REPLACE CLI_AGE    WITH M.CLI_AGE
		
	    IF !ExecRW("","u_cli_an","W")
		  return(.f.)
		ENDIF
	ENDIF


	_CONTAREC = _CONTAREC + 1
	WAIT WINDOWS "RECORD : "+STR(_CONTAREC,5,0) NOWAIT
	
	SELECT IMPORTAXLS 
	SKIP +1
	
ENDDO



	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


