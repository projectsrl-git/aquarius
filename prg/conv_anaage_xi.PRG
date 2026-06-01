*************************************************************************************************
*							CONVERSIONE ANAGRAFICA AGENTI										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2011 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica agenti da foglio Execl	 ?",292,"ATTENZIONE")
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

		IF !ExecCommand("select * from U_AGE_AN where 1=0","curs_U_AGE_AN")
		   return
		ENDIF


		IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
		   return
		ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_AGE_AN SQL 


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA AGENTI" NOWAIT


		cSql   = "delete from U_AGE_AN "  
		IF !ExecCommand(cSql,"U_AGE_AN")
		   return(.f.)
		ENDIF


		cSql = "delete from PARA where CODICE LIKE 'AGE%' "
		IF !ExecCommand(cSql,"PARA")
		   return(.f.)
		ENDIF




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

		CREATE CURSOR IMPORTAXLS (CAMPO1  c(100),;
			CAMPO2   c(100))

		
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
    

    
    
*!*	#####################################################


    M.AGE_CODICE = SUBSTR(CAMPO1,1,3)
 	M.AGE_RAGSOC = APITOSPA(ALLTRIM(SUBSTR(CAMPO1,5,100)))						
 				

    SELECT curs_U_AGE_AN
    APPEND BLANK 
    REPLACE AGE_CODSOC    WITH PUB_CODSOC
    REPLACE AGE_CODICE    WITH M.AGE_CODICE   
    REPLACE AGE_RAGSOC    WITH M.AGE_RAGSOC   
    REPLACE AGE_CODIVA    WITH "20 "
    REPLACE AGE_VALUTA    WITH "EUR"
    REPLACE AGE_DATINS    WITH __DATINS 



	M.CODICE 	= "AGE"+M.AGE_CODICE
   	M.DESCRI 	= M.AGE_RAGSOC 
   	M.LIBERA	= ""

 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 






    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT




    	
    SELECT IMPORTAXLS
	SKIP

ENDDO



****** AGGIORNA TABELLA U_AGE_AN SQL
IF !ExecRW('','U_AGE_AN','I','','curs_U_AGE_AN')
   return(.f.)
ENDIF
	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 