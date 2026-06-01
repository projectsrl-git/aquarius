*************************************************************************************************
*							CONVERSIONE ANAGRAFICA BANCHE										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Maggio 2011 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica banche da foglio Execl	 ?",292,"ATTENZIONE")
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


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA BANCHE" NOWAIT

		IF !ExecCommand("select * from U_BAN_AN where 1=0","curs_u_ban_an")
		   return
		ENDIF



*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_CLI_AN SQL ESCLUDENDO IL CODICE CLIENTE STUDIO PER LA GESTIONE AZIENDA


*!*			cSql = "delete from U_BAN_AN where 1=1"
*!*			IF !ExecCommand(cSql,"U_BAN_AN")
*!*			   return(.f.)
*!*			ENDIF


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

		**=> ERASMO - INIZIO 29/11/2010
		*** CORREZIONE PER DESCRIZIONE ATTIVITA' PIU' LUNGA DI 100 CARATTERI			
		CREATE CURSOR IMPORTAXLS (__CODABI  c(05),;
			__CODCAB   c(05),;			
			__DESBAN   c(80),;
			__AGENZI   c(80),;
			__INDIR    c(50),;
			__LOCA	   c(30),;
			__PROVIN   c(02))
		**=> ERASMO - FINE 29/11/2010

		
		APPEND FROM (gcFile) TYPE xls	
        GO TOP
        BROWSE NORMAL


		gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			SET DEFAULT TO &PUB_DIR  
			
			RETURN
		ENDIF




		WAIT WINDOWS "Selezionato file EXCEL >>>>>>>>>>> "+gcFile 				

		
		APPEND FROM (gcFile) TYPE xls	
        GO TOP
        BROWSE NORMAL



***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT IMPORTAXLS
GO TOP 

REC_AGGIORNATI = 0
REC_INSERITI = 0

DO WHILE !EOF()

    IF DELETED()
       SELECT IMPORTAXLS   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    IF ALLTRIM(__CODABI) = "Abi"
       SELECT IMPORTAXLS   && scarto primo record
       SKIP +1
       LOOP
    ENDIF 



   	M.BAN_CODSOC = '01' 

 		   		


  	M.BAN_CODABI = ALLTRIM(__CODABI)
	IF LEN(M.BAN_CODABI) = 4
		M.BAN_CODABI = '0'+M.BAN_CODABI 
	ENDIF
  	
 	
   	M.BAN_CODCAB = ALLTRIM(__CODCAB)	
	IF LEN(M.BAN_CODCAB) = 4
		M.BAN_CODCAB = '0'+M.BAN_CODCAB
	ENDIF

   	M.BAN_CODBAN = ALLTRIM(M.BAN_CODABI)	+ 	ALLTRIM(M.BAN_CODCAB)				 

   	M.BAN_DESBAN = ALLTRIM(__DESBAN)
  	M.BAN_DESBAN = UPPER(M.BAN_DESBAN)
   	M.BAN_DESBAN = APITOSPA(M.BAN_DESBAN)
   

   	M.BAN_INDIR = ALLTRIM(__INDIR)
   	M.BAN_INDIR = UPPER(M.BAN_INDIR)
   	M.BAN_INDIR = APITOSPA(M.BAN_INDIR)


   	M.BAN_LOCA = ALLTRIM(__LOCA)
   	M.BAN_LOCA = UPPER(M.BAN_LOCA)
   	M.BAN_LOCA = APITOSPA(M.BAN_LOCA)


   	M.BAN_PROVIN = ALLTRIM(__PROVIN)
   	M.BAN_PROVIN = UPPER(M.BAN_PROVIN)
   	M.BAN_PROVIN = APITOSPA(M.BAN_PROVIN)

	M.BAN_DATINS = RIBALTA2(__DATINS)

   	M.BAN_NOTE1 = ALLTRIM(__AGENZI)
   	M.BAN_NOTE1 = UPPER(M.BAN_NOTE1)
   	M.BAN_NOTE1 = APITOSPA(M.BAN_NOTE1)

   	SELECT curs_u_ban_an				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
    SCATTER MEMVAR memo 
    
     
   
	x_soci = "ban_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "ban_codban = '" + M.BAN_CODBAN + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_BAN_AN where " + x_cond + " order by ban_codsoc,ban_codban"



	IF !ExecCommand(cSql,"U_BAN_AN")
	   RETURN .F.
	ENDIF

	SELECT U_BAN_AN
	GO TOP
	IF EOF()
		APPEND BLANK
	   REC_INSERITI = REC_INSERITI + 1		
	ELSE
	   REC_AGGIORNATI = REC_AGGIORNATI + 1
	ENDIF
	
	DO U_BAN_AN
	IF !ExecRW('','U_BAN_AN','I','','U_BAN_AN')
	  return(.f.)
	ENDIF	
    
    
    
    
    
							   
   	_CTR = _CTR +1
   	WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   


    	
    SELECT IMPORTAXLS
	SKIP

ENDDO


SELECT curs_u_ban_an
GO TOP



*!*	****** AGGIORNA TABELLA U_BAN_AN SQL
*!*	IF !ExecRW('','U_BAN_AN','I','','curs_u_ban_an')
*!*	   return(.f.)
*!*	ENDIF
*!*		 

WAIT WINDOWS "RECORD AGGIORNATI :"+STR(REC_AGGIORNATI,5,0)+ " RECORD INSERITI :" + STR(REC_INSERITI,5,0) 

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 