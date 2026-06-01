*************************************************************************************************
*							    CONVERSIONE CODICI VETTORI     		  							*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2013 : Cardioline 				 													*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei codici vettori in formato testo ?",292,"ATTENZIONE")
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


*** CANCELLAZIONE DEI RECORD DELLA TABELLA ZONE SQL 


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA VETTORI" NOWAIT
		cSql = "delete from PARA where CODICE LIKE 'VET%' "
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
    
    
    IF EMPTY(ALLTRIM(SUBSTR(CAMPO1,01,01)))
       SELECT IMPORTATXT   && scarto il record 
       SKIP +1
       LOOP
    ENDIF 
    
    
 
    IF SUBSTR(CAMPO1,01,06) = "Attivo"
       SELECT IMPORTATXT   && scarto il record 
       SKIP +1
       LOOP
    ENDIF     
  
  
    IF SUBSTR(CAMPO1,01,05) = "99999"
       SELECT IMPORTATXT   && scarto il record 
       SKIP +1
       LOOP
    ENDIF       
  
  
    
	M.CODICE1 	=SUBSTR(CAMPO1,12,05)
	M.CODICE2   =CONV_CLEAR(APITOSPA(ALLTRIM(M.CODICE1))) 
	M.CODICE2   =CARDIOLINE_DECODIFICA_CODICE_VET(M.CODICE2)
	M.CODICE    ="VET"+M.CODICE2
    M.DESCRI 	=ALLTRIM(APITOSPA(ALLTRIM(SUBSTR(CAMPO1,32,50))))	
	M.DESCRI    =CONV_CLEAR(APITOSPA(ALLTRIM(M.DESCRI))) 
   	
   	
   	M.LIBERA	=""


	cSql = "select * from PARA where CODICE ='VET"+ALLTRIM(M.CODICE2)+"'"
	IF !ExecCommand(cSql,"___temp_vettori")
	   RETURN .F.
	ENDIF
	SELECT ___temp_vettori
	GO TOP
	IF EOF()
	ELSE
       SELECT IMPORTATXT   && scarto il record 
       SKIP +1
       LOOP
    ENDIF       



	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
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


 