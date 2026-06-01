*************************************************************************************************
*							CONVERSIONE ANAGRAFICA CLIENTI										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Maggio 2011 : Xilopan 				 														*
*************************************************************************************************




*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica clienti CON EMAIL da foglio Execl	 ?",292,"ATTENZIONE")
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


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA CLIENTI" NOWAIT

		IF !ExecCommand("select * from U_CLI_AN where 1=0","curs_U_CLI_AN")
		   return
		ENDIF




*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_CLI_AN SQL ESCLUDENDO IL CODICE CLIENTE AZIENDA PER LA GESTIONE AZIENDA


*!*			__SOC= "01"
*!*			__CLI= "000000" 

*!*			x_soci = "cli_codsoc = '" + __SOC + "'"
*!*			x_codi = "cli_codcli <> '" + __CLI + "'"
*!*			x_cond = x_soci + " and " + x_codi

*!*			cSql   = "delete from u_cli_an where " + x_cond 
*!*			IF !ExecCommand(cSql,"U_CLI_AN")
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

		CREATE CURSOR IMPORTAXLS (CLI_CODCLI  c(06),;
			CLI_RAGSOC   c(80),;			
			CLI_RAGDUE   c(80),;
			CLI_INDIR    c(70),;
			CLI_LOCALI   c(80),;
			CLI_PROVIN   c(02),;
			CLI_CAP      c(10),;
			CLI_TELEFO   c(30),;
			CLI_CODFIS   c(16),;
			CLI_PARIVA   c(11),;
			CLI_VALUTA   c(03),;
			CLI_CONPAG   c(03),;
			CLI_CODABI   c(05),;
			CLI_CODCAB   c(05),;
			CLI_NOTE     c(200),;
			CLI_CBASC    c(05),;
			CLI_FAX      c(30),;
			CLI_EMAIL    c(90))
		
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

    SCATTER MEMVAR MEMO
    
    
*!*	#####################################################


                M.ID_UNIQUE  = ""
           		M.CLI_CODSOC = '01' 

                M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(CLI_CODCLI))

 				M.CLI_RAGSOC = ALLTRIM (CLI_RAGSOC)
   		        M.CLI_RAGSOC = UPPER(M.CLI_RAGSOC)
                M.CLI_RAGSOC = APITOSPA(M.CLI_RAGSOC)

 				M.CLI_RAGDUE = ALLTRIM (CLI_RAGDUE)
   		        M.CLI_RAGDUE = UPPER(M.CLI_RAGDUE)
                M.CLI_RAGDUE = APITOSPA(M.CLI_RAGDUE)	
	
			   	M.CLI_INDIR  = ALLTRIM (CLI_INDIR)
			   	M.CLI_INDIR  = UPPER(M.CLI_INDIR)
			    M.CLI_INDIR  = APITOSPA(M.CLI_INDIR)

				M.CLI_LOCALI = ALLTRIM (CLI_LOCALI)
			   	M.CLI_LOCALI = UPPER(M.CLI_LOCALI)
			    M.CLI_LOCALI = APITOSPA(M.CLI_LOCALI)

				M.CLI_PROVIN = ALLTRIM (CLI_PROVIN)
		   		M.CLI_PROVIN = UPPER(M.CLI_PROVIN)
		        M.CLI_PROVIN = APITOSPA(M.CLI_PROVIN)

				M.CLI_CAP    = ALLTRIM(CLI_CAP)
				M.CLI_TELEFO = ALLTRIM(CLI_TELEFO)
				M.CLI_CODFIS = UPPER(CLI_CODFIS)			
				M.CLI_PARIVA = UPPER(CLI_PARIVA)				
			    M.CLI_VALUTA = UPPER(SUBSTR(CLI_VALUTA,1,3))			
				
			    M.CLI_CONPAG = UPPER(CLI_CONPAG)	

			    M.CLI_CODABI = UPPER(CLI_CODABI)	
			    M.CLI_CODCAB = UPPER(CLI_CODCAB)

			    M.CLI_BAE    = M.CLI_CODABI+M.CLI_CODCAB
		    	
   			    M.CLI_NOTE   = ALLTRIM (CLI_NOTE)
		   		M.CLI_NOTE   = UPPER(M.CLI_NOTE)
		        M.CLI_NOTE   = APITOSPA(M.CLI_NOTE)			    
			    
			    
			    M.CLI_CDIBAN = ""
			    IF SUBSTR(M.CLI_NOTE,1,2) = "IT"
	               M.CLI_CDIBAN = M.CLI_NOTE 
	            ENDIF		    
		
				M.CLI_FAX	 = ALLTRIM(CLI_FAX)				

 				M.CLI_EMAIL	 = ALLTRIM(CLI_EMAIL)	

				*!*	 ######################################################  INFORMAZIONI MANCANTI  ###################################################à
 
			    M.CLI_AGE 		= ""
				M.CLI_NAZION 	= "IT"
			    M.CLI_PROVVI 	= 0				
			    M.CLI_ZONA 		= ""
			    M.CLI_SOTZONA 	= ""
			    M.CLI_ZONA 		= M.CLI_ZONA + M.CLI_SOTZONA
				M.CLI_CONTO1    = "6010101"
				
				*!*	 ######################################################  VALORI DI DEFAULT   ###################################################à
 				

				
				IF EMPTY(ALLTRIM(M.CLI_PROVIN))				&& SONO CLIENTI ESTERI 
					M.CLI_IVACEE = M.CLI_CODFIS
				ELSE
					M.CLI_IVACEE = ""			
				ENDIF


				M.CLI_VALIMP   	= 0
				M.CLI_IMPFID   	= 0
			    M.CLI_NUMINSOL 	= 0
			    M.CLI_CODIVA   	= "21"
			    
			    M.CLI_LINGUA 	= ""



			    M.CLI_ABI  		= ""
			    M.CLI_CAB  		= ""
			    M.CLI_ABI2 		= ""
			    M.CLI_CAB2 		= ""
			    M.CLI_MEZZO 	= ""
			    M.CLI_VETTO1 	= ""
			    M.CLI_PORTO 	= ""
			    M.CLI_LISTIN 	= ""
			    M.CLI_SC1 		= ""
			    M.CLI_BOLLI 	= ""
			    M.CLI_SPINCA 	= ""

			    M.CLI_BDAL    = "0108"
			    M.CLI_BAL     = "3108"
			    M.CLI_GG1     = "1009"
			    M.CLI_B2DAL   = "2012"
			    M.CLI_B2AL    = "3112"
			    M.CLI_GG2     = "1001"
			    M.CLI_TIPFAT  = "FDV"
			    M.CLI_FLGTRA  = .T.


				M.CLI_01DAL = '0101'
				M.CLI_02DAL = '0102'
				M.CLI_03DAL = '0103'
				M.CLI_04DAL = '0104'
				M.CLI_05DAL = '0105'
				M.CLI_06DAL = '0106'
				M.CLI_07DAL = '0107'
				M.CLI_09DAL = '0109'
				M.CLI_10DAL = '0110'
				M.CLI_11DAL = '0111'


				M.CLI_01AL = '3101'
				M.CLI_02AL = '2802'
				M.CLI_03AL = '3103'
				M.CLI_04AL = '3004'
				M.CLI_05AL = '3105'
				M.CLI_06AL = '3006'
				M.CLI_07AL = '3107'
				M.CLI_09AL = '3009'
				M.CLI_10AL = '3110'
				M.CLI_11AL = '3011'


				M.CLI_01GG = '0502'
				M.CLI_02GG = '0503'
				M.CLI_03GG = '0504'
				M.CLI_04GG = '0505'
				M.CLI_05GG = '0506'
				M.CLI_06GG = '0507'
				M.CLI_07GG = '0509'
				M.CLI_09GG = '0510'
				M.CLI_10GG = '0511'
				M.CLI_11GG = '0512'

			

			 	M.CLI_DATNEW = RIBALTA2(DTOC(DATE()))
				M.CLI_DATINS = RIBALTA2(DTOC(DATE()))
				
				M.CLI_ENPACL = 0
				M.CLI_RA     = 0




   	SELECT curs_U_CLI_AN				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
    SCATTER MEMVAR MEMO
    


	x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	x_codi = "cli_codcli = '" + M.CLI_CODCLI + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "select * from U_CLI_AN where " + x_cond + " order by cli_codsoc,cli_codcli"



	IF !ExecCommand(cSql,"U_CLI_AN")
	   RETURN .F.
	ENDIF

	SELECT U_CLI_AN
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	DO U_CLI_AN
	IF !ExecRW('','U_CLI_AN','I','','U_CLI_AN')
	  return(.f.)
	ENDIF	

							   
   	_CTR = _CTR +1
   	WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   




    	
    SELECT IMPORTAXLS
	SKIP

ENDDO


SELECT curs_U_CLI_AN
GO TOP



*!*	****** AGGIORNA TABELLA U_CLI_AN SQL
*!*	IF !ExecRW('','U_CLI_AN','I','','curs_U_CLI_AN')
*!*	   return(.f.)
*!*	ENDIF
*!*		 



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 