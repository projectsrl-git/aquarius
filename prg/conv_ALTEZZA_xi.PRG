*************************************************************************************************
*							CONVERSIONE LUNGHEZZA 										        *
*							 																	*
*	by Luca Remiddi per Project S.r.l.															*
*	Agosto 2011 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"delle codifiche  altezze IN FORMATO TXT	 ?",292,"ATTENZIONE")
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


*** CANCELLAZIONE DEI RECORD DELLA TABELLA FINITURE SQL 


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA CODIFICA FINITURE" NOWAIT


		cSql = "delete from PARA where CODICE LIKE 'CLA%' "
		IF !ExecCommand(cSql,"PARA")
		   return(.f.)
		ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA




		gcFile = GETFILE('TXT', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF



		WAIT WINDOWS "Selezionato file TXT >>>>>>>>>>> "+gcFile 		

		CREATE CURSOR IMPORTATXT (CAMPO1  c(100),;
			CAMPO2   c(100))

		
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
    
    IF EMPTY(ALLTRIM(CAMPO1))
   	   SELECT IMPORTATXT   && scarto i record vuoti
       SKIP +1
       LOOP
    ENDIF 
    

    IF SUBSTR(CAMPO1,1,2) = "--"
   	   SELECT IMPORTATXT   && scarto i record vuoti
       SKIP +1
       LOOP
    ENDIF 

    IF SUBSTR(CAMPO1,15,6) = "CODICE"
   	   SELECT IMPORTATXT   && scarto i record vuoti
       SKIP +1
       LOOP
    ENDIF 


    IF EMPTY(SUBSTR(CAMPO1,1,2)) 
    ELSE
   	   SELECT IMPORTATXT   && scarto i record vuoti
       SKIP +1
       LOOP
    ENDIF 

    

    
    
*!*	#####################################################



	M.CODICE 	= "CLA"+SUBSTR(CAMPO1,17,2)
   	M.LIBERA	= SUBSTR(CAMPO1,31,5)
    M.LIBERA	= ALLTRIM(STRTRAN(M.LIBERA,".",""))
   	M.DESCRI 	= SUBSTR(CAMPO1,17,2) + " Altezza " + M.LIBERA



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


 