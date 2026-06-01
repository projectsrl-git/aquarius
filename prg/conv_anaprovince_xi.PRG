*************************************************************************************************
*							CONVERSIONE ANAGRAFICA PROVINCE										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Gennaio 2012 : Xilopan 					 													*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica province in formato testo ?",292,"ATTENZIONE")
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

		IF !ExecCommand("select * from PROVINCE where 1=0","curs_PROVINCE")
		   return
		ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA ZONE SQL 


*!*			WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA ZONE" NOWAIT
*!*			cSql = "delete from PROVINCE where CODICE LIKE 'ZON%' "
*!*			IF !ExecCommand(cSql,"PROVINCE")
*!*			   return(.f.)
*!*			ENDIF




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



		WAIT WINDOWS "Selezionato file EXCEL >>>>>>>>>>> "+gcFile 		

		CREATE CURSOR IMPORTAXLS (CAMPO1  c(100),;
			CAMPO2   c(100))

		
		APPEND FROM (gcFile) TYPE sdf		



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



	M.SIGLA 		= SUBSTR(CAMPO1,05,02)
	M.PROVINCIA 	= SUBSTR(CAMPO1,20,30)
	M.PRV_COSTOTX	= SUBSTR(CAMPO1,76,12)
*!*		M.PRV_COSTOT	= STRTRAN(M.PRV_COSTOTX,",",".")
	M.PRV_COSTOT	= VAL(M.PRV_COSTOTX)
		
	  
	x_cond = "sigla = '" + M.SIGLA + "'"
	cSql = "select * from PROVINCE where " + x_cond + " order by sigla"


	IF !ExecCommand(cSql,"PROVINCE")
	   RETURN .F.
	ENDIF

	SELECT PROVINCE 
	GO TOP
	IF EOF()
	    WAIT WINDOWS "PROVINCIA INESISTENTE" + M.SIGLA
		APPEND BLANK
	ENDIF
	
	REPLACE SIGLA     	WITH M.SIGLA
	REPLACE PROVINCIA 	WITH M.PROVINCIA
	REPLACE PRV_COSTOT	WITH M.PRV_COSTOT
	
	IF !ExecRW('','PROVINCE','I','','PROVINCE')
	  return(.f.)
	ENDIF	



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT IMPORTAXLS
	SKIP

ENDDO

	 
****** AGGIORNA TABELLA PROVINCE SQL
IF !ExecRW('','PROVINCE','I','','curs_PROVINCE')
   return(.f.)
ENDIF
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 