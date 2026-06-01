*************************************************************************************************
*							CONVERSIONE CODICI IVA      										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2013 : Cardioline 				 													*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei codici iva in formato testo ?",292,"ATTENZIONE")
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


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA IVA" NOWAIT


		cSql = "delete from PARA where CODICE LIKE 'IVA%' "
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

    IF SUBSTR(CAMPO1,01,06) = "Cod. V"
       SELECT IMPORTATXT   && scarto il record 
       SKIP +1
       LOOP
    ENDIF 
 
 
    IF SUBSTR(CAMPO1,01,06) = "Regime"
       SELECT IMPORTATXT   && scarto il record 
       SKIP +1
       LOOP
    ENDIF     
  
  
    IF SUBSTR(CAMPO1,01,05) = "99999"
       SELECT IMPORTATXT   && scarto il record 
       SKIP +1
       LOOP
    ENDIF       
  
  
    
*!*	#########################################################
*!*	S                	04              	04%                                               	                        	Regime IVA normale	                        	4,00
*!*	S                	04              	04%                                               	                        	Regime IVA normale	                        	4,00%                    	N                  
*!*	S                	04              	04%                                               	                        	Regime IVA normale	                        	4,00%                    	N                       	N                  	         
*!*	123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890

	M.CODICE1 	=SUBSTR(CAMPO1,18,05)	
	M.CODICE1   =CONV_CLEAR(APITOSPA(ALLTRIM(M.CODICE1))) 	
	M.CODICE2   =CARDIOLINE_DECODIFICA_CODICE_IVA(M.CODICE1)
	M.CODICE    ="IVA"+M.CODICE2
    M.DESCRI 	=ALLTRIM(APITOSPA(ALLTRIM(SUBSTR(CAMPO1,35,50))))	
	M.DESCRI    =CONV_CLEAR(APITOSPA(ALLTRIM(M.DESCRI))) 


*campo libera  	
*021  2092201                1011101                                                                I         40                                                                                         
*123456789012345678901234567890


    _CONTO_CLI = "44010001" && DA 6 PER 13
    _CONTO_FOR = "12040001" && DA 29 PER 13
    
   	M.LIBERA	=""
	M.LIBERA1 	=SUBSTR(CAMPO1,155,05)
	M.LIBERA2   =ALLTRIM(SUBSTR(M.LIBERA1,1,AT(',',M.LIBERA1)-1))  	&& SI FERMA QUANDO TROVA LA PRIMA ,,,,,, VIRGOLA


	M.LIBERA2   =CONV_CLEAR(APITOSPA(ALLTRIM(M.LIBERA2)))  
	M.LIBERA2   =STRTRAN(M.LIBERA2,"	","")						&& CARATTERE STRANO TROVATO IN ARCHIVI CARDIOLINE
	
	
	IF LEN(M.LIBERA2) = 1
		M.LIBERA2 = "00"+M.LIBERA2
	ENDIF

	IF LEN(M.LIBERA2) = 2
		M.LIBERA2 = "0"+M.LIBERA2
	ENDIF

    LEN_LIBERA  =LEN(M.LIBERA2)
    M.LIBERA3   =M.LIBERA2+REPLICATE("_" ,(5-LEN_LIBERA))+_CONTO_CLI 

    LEN_LIBERA  =LEN(M.LIBERA3)
    M.LIBERA4   =M.LIBERA3+REPLICATE("_" ,(28-LEN_LIBERA))+_CONTO_FOR
    M.LIBERA4    =STRTRAN(M.LIBERA4,"_"," ")
    M.LIBERA     =M.LIBERA4



 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT IMPORTATXT
	SKIP

ENDDO



SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
SCATTER MEMVAR memo 
APPEND BLANK
GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

REPLACE CODICE WITH "IVANO"
REPLACE DESCRI WITH "NESSUNA IVA"                                                                                                                                                                                                           
REPLACE LIBERA WITH "000  44010001               12040001               "



	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 