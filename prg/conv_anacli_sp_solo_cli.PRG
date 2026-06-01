*************************************************************************************************
*							CONVERSIONE ANAGRAFICA Clienti										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2010 				 																*
*************************************************************************************************

*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica clienti per studi professionali	 ?",292,"ATTENZIONE")
		IF RIT = 7
		   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
		   RETURN
		ENDIF




** ASSEGNAZIONE DELLA VARIABILE PATH **************************
		
		*!*	=OPENDB("PERCORSO")
		*!*	SELECT PERCORSO
		*!*	SET ORDER TO I_TIPO
		*!*	SEEK 'BAN'
		*!*	IF FOUND()
		*!*	ELSE
		*!*	   RETURN
		*!*	ENDIF

		*!*	SELECT PERCORSO
		*!*	V_PATH = ALLTRIM(PER_PATH)

		*!*	V_PATH = ""
		SET DEFAULT TO C:\AQUARIUS\FILE_DA_CONVERTIRE

****** DEFINIZIONE DEI CURSORI STP


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA CLIENTI" NOWAIT

		IF !ExecCommand("select * from U_CLI_AN where 1=0","curs_u_cli_an")
		   return
		ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_CLI_AN SQL ESCLUDENDO IL CODICE CLIENTE STUDIO PER LA GESTIONE AZIENDA


		__SOC= "01"
		__CLI= "000000001" 

		x_soci = "cli_codsoc = '" + __SOC + "'"
		x_codi = "cli_codcli <> '" + __CLI + "'"
		x_cond = x_soci + " and " + x_codi

		cSql   = "delete from u_cli_an where " + x_cond 
		IF !ExecCommand(cSql,"U_CLI_AN")
		   return(.f.)
		ENDIF

******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO

		RELEASE Y_CAMPO,V_CAMPO,_CTR,_PROGRE,___CODICE_CLIENTE_TROVATO,_CODCLI 
		PUBLIC Y_CAMPO,V_CAMPO,_CTR,_PROGRE,___CODICE_CLIENTE_TROVATO,_CODCLI 
		Y_CAMPO = ""
		V_CAMPO = ""
		_CTR    = 0
		_PROGRE = ""
		___CODICE_CLIENTE_TROVATO = .F.
		_CODCLI = 2


**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA

		WAIT WINDOWS "ATTENDERE PREGO, CARICAMENTO FILE DA CONVERTIRE" NOWAIT


		gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')




		IF EMPTY(gcFile)
			THISFORM.VisualizzaMessaggio("Nessun file selezionato.")		
			RETURN
		ENDIF

		WAIT WINDOWS "Selezionato file EXCEL "+gcFile 	NOWAIT 	

			
		CREATE CURSOR IMPORTAXLS (__RAGSOC  c(35),;
			__INDIRIZZO   c(35),;
			__LOCALITA  c(35),;
			__CAP c(5),;
			__PARTITAIVA  c(11),;
			__CODICEFISCALE c(16),;
			__TELEFONO c(25),;
			__FAX c(25),;
			__CODICEATTIVITA c(06),;
			__DESCRIZIONEATTIVITA c(35),;
			__UMXRICAVO c(02),;			
			__RICAVOXDIP N(16,3),;
			__UMXCOSTO c(02),;					
			__COSTOXDIP N(16,3))


		SELECT IMPORTAXLS
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
		    
		    
		    
		        SCATTER MEMVAR memo
		        
		        
		        
		        IF ALLTRIM(M.__RAGSOC) ="ragione sociale"
			       SELECT IMPORTAXLS   && scarto i record non contenente dati anagrafici
			       SKIP +1
			       LOOP
			    ENDIF 
		        
		        IF EMPTY(ALLTRIM(M.__RAGSOC))
			       SELECT IMPORTAXLS   && scarto i record non contenente dati anagrafici
			       SKIP +1
			       LOOP
			    ENDIF 



         
                M.ID_UNIQUE  = ""
           		M.CLI_CODSOC = '01' 


           		M.CLI_CODCLI = STR(_CODCLI ,10,0)
                M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(M.CLI_CODCLI))

 				M.CLI_RAGSOC = ALLTRIM (M.__RAGSOC)
   		        M.CLI_RAGSOC = UPPER(M.CLI_RAGSOC)
                M.CLI_RAGSOC = APITOSPA(M.CLI_RAGSOC)

				DO VERIFICA_CLIENTE

				IF ___CODICE_CLIENTE_TROVATO 
					SELECT IMPORTAXLS
					SKIP +1
					LOOP
				ENDIF

				_CODCLI = _CODCLI + 1

			   	M.CLI_INDIR  = ALLTRIM (M.__INDIRIZZO)
			   	M.CLI_INDIR  = UPPER(M.CLI_INDIR)
			    M.CLI_INDIR  = APITOSPA(M.CLI_INDIR)

				M.CLI_CAP    = ALLTRIM (M.__CAP)

				M.CLI_LOCALI = ALLTRIM (M.__LOCALITA)
			   	M.CLI_LOCALI = UPPER(M.CLI_LOCALI)
			    M.CLI_LOCALI = APITOSPA(M.CLI_LOCALI)



				
			    _seek      = "'"+ALLTRIM(M.cli_locali)+"'"
			    cSql 	   = "SELECT * FROM comuni where comune = " + _seek + " order by comune"
			    IF !ExecCommand(cSql,'COMUNI')
			       return(.f.)
			    ENDIF
			    SELECT COMUNI
			    GO TOP
			    IF EOF()
			    ELSE
			   				   M.CLI_LOCALI = UPPER(COMUNE)
				   M.CLI_PROVIN = UPPER(PROVINCIA)
				   M.CLI_CAP    = CAP
				ENDIF

				IF ALLTRIM( M.CLI_LOCALI) = "MILANO"
					M.CLI_PROVIN = "MI"
			   		        M.CLI_PROVIN = UPPER(M.CLI_PROVIN)
			        M.CLI_PROVIN = APITOSPA(M.CLI_PROVIN)
				ENDIF

				
				M.CLI_TELEFO 	= ALLTRIM(M.__TELEFONO)
				M.CLI_FAX	 	= ALLTRIM(M.__FAX)				
				
				
				
				M.CLI_CONTO1 	= "101008"
				
				M.CLI_IVACEE 	= ""
				M.CLI_PARIVA 	= M.__PARTITAIVA  
				M.CLI_CODFIS 	= M.__CODICEFISCALE 
				M.CLI_NAZION 	= "ITA"
				M.CLI_VALIMP   	= 0
				M.CLI_IMPFID   	= 0
			    M.CLI_NUMINSOL 	= 0
			    M.CLI_CODIVA   	= "20"
			    
			    M.CLI_LINGUA 	= ""
			    
			    M.CLI_VALUTA 	= "EUR"

			    
			    M.CLI_AGE 		= "01"
			    M.CLI_PROVVI 	= ""
			    
			    M.CLI_CONPAG 	= "101"



			    M.CLI_ABI  		= ""
			    M.CLI_CAB  		= ""
			    M.CLI_ABI2 		= ""
			    M.CLI_CAB2 		= ""
			    M.CLI_ZONA 		= ""
			    M.CLI_SOTZONA 	= ""
			    M.CLI_ZONA 		= M.CLI_ZONA + M.CLI_SOTZONA
			    M.CLI_MEZZO 	= ""
			    M.CLI_VETTO1 	= ""
			    M.CLI_PORTO 	= ""
			    M.CLI_LISTIN 	= ""
			    M.CLI_SC1 		= ""
			    M.CLI_BOLLI 	= ""
			    M.CLI_SPINCA 	= ""

				M.CLI_BAE 		= ""

			    M.CLI_BDAL   = "0108"
			    M.CLI_BAL    = "3108"
			    M.CLI_GG1    = "1009"
			    M.CLI_B2DAL  = "2012"
			    M.CLI_B2AL   = "3112"
			    M.CLI_GG2    = "1001"
			    M.CLI_TIPFAT = "FDV"
			    M.CLI_FLGTRA = .T.

			 	M.CLI_DATNEW = RIBALTA2(DTOC(DATE()))
				M.CLI_DATINS = RIBALTA2(DTOC(DATE()))
				
				M.CLI_ENPACL = 2
				M.CLI_RA     = 20
				

			 
			  	SELECT curs_u_CLI_an			&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
			  	APPEND BLANK
			 	GATHER MEMVAR MEMO 				&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



				****** AGGIORNA TABELLA U_CLI_AN SQL

				IF !ExecRW('','U_CLI_AN','I','','curs_u_CLI_an')
				   return(.f.)
				ENDIF
			 

				****** DEFINIZIONE DEL CURSORE STP

				IF !ExecCommand("select * from U_CLI_AN where 1=0","curs_u_cli_an")
				   return
				ENDIF

												   
		   		_CTR = _CTR +1
		   		WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
		   
		    	
		    	
		    	
		    SELECT IMPORTAXLS
			SKIP
		ENDDO







=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

		SET DEFAULT TO C:\AQUARIUS

RETURN


   
*********************
PROCEDURE TOGLI_PUNTI
*********************

YY      = LEN(V_CAMPO)
XX      = 1
Y_CAMPO =  ' '
DO WHILE .T.
   IF XX > YY
      EXIT
   ENDIF
   IF SUBSTR(V_CAMPO,XX,1) = '.' 
   ELSE
      Y_CAMPO = Y_CAMPO + SUBSTR(V_CAMPO,XX,1) 
   ENDIF
   XX = XX + 1
ENDDO

RETURN


**************************
PROCEDURE VERIFICA_CLIENTE
**************************

___CODICE_CLIENTE_TROVATO = .F.


x_cond = "cli_ragsoc = '" + M.CLI_RAGSOC + "'"
cSql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecRW(cSql,"u_cli_an","R")
   return
ENDIF
SELECT u_cli_an
IF !EOF()
	___CODICE_CLIENTE_TROVATO = .T.
ENDIF

RETURN









