*************************************************************************************************
*							CONVERSIONE ANAGRAFICA Clienti										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Giugno 2010 				 																*
*************************************************************************************************



*** DEFINIZIONE VARIABILI

		RELEASE _elabora_kompasso 
		PUBLIC _elabora_kompasso 
		


*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica clienti per studi professionali	 ?",292,"ATTENZIONE")
		IF RIT = 7
		   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
		   RETURN
		ENDIF


		RIT = MESSAGEBOX("Stai convertendo le anagrafiche dello "+CHR(13)+"studio Kompasso ? ",292,"ATTENZIONE")
		IF RIT = 7
			_elabora_kompasso = .f.
		ELSE 
			_elabora_kompasso = .t.
		ENDIF


** ASSEGNAZIONE DELLA VARIABILE PATH **************************
		
		
		=OPENDB("PERCORSO")
		SELECT PERCORSO
		SET ORDER TO I_TIPO

		SELECT PERCORSO
		V_PATH = ALLTRIM(PER_PATH)
		
		**=> ERASMO - INIZIO 18/06/2010
		****************************************************************************************************
		*** BISOGNA CONTROLLARE ALMENO CHE IL PATH SIA VALIDO ALTRIMENTI MI RITROVO CON L'ANAGRAFICA VUOTA!!
		****************************************************************************************************
		IF DIRECTORY(V_PATH)
		ELSE
			MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
				"Controllare il file PERCORSO.DBF",16,"Attenzione")
			RETURN .F.
		ENDIF
		**=> ERASMO - FINE 18/06/2010

		SET DEFAULT TO &V_PATH 

****** DEFINIZIONE DEI CURSORI STP


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA CLIENTI" NOWAIT

		IF !ExecCommand("select * from U_CLI_AN where 1=0","curs_u_cli_an")
		   return
		ENDIF


		* -->> Creazione cursore vuoto di testata contratto I livello
		* -----------------------------------------------------------
		IF !ExecCommand("select * from CONTRSTUDI where 0=1","CU_CONTRSTUDI")
		  return(.f.)
		ENDIF
		SELECT CU_CONTRSTUDI

		* -->> Creazione cursore vuoto di dettaglio contratto II livello
		* --------------------------------------------------------------
		IF !ExecCommand("select * from CONTRST_DD where 0=1","CU_CONTRST_DD")
		  return(.f.)
		ENDIF
		SELECT CU_CONTRST_DD
		INDEX ON SEQUEN TAG I_SEQUEN
		SET ORDER TO I_SEQUEN

		* -->> Creazione cursore vuoto di dettaglio contratto III livello
		* ---------------------------------------------------------------
		IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
		  return(.f.)
		ENDIF
		SELECT CU_CONTRST_DL
		INDEX ON AAAAMM TAG I_AAAAMM
		SET ORDER TO I_AAAAMM




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

*** CANCELLAZIONE CONTRATTI

		cSql = "delete from CONTRSTUDI where 1=1"
		IF !ExecCommand(cSql,"CONTRSTUDI")
		   return(.f.)
		ENDIF

		cSql = "delete from CONTRST_DD where 1=1"
		IF !ExecCommand(cSql,"CONTRST_DD")
		   return(.f.)
		ENDIF

		cSql = "delete from CONTRST_DL where 1=1"
		IF !ExecCommand(cSql,"CONTRST_DL")
		   return(.f.)
		ENDIF


******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO

		RELEASE Y_CAMPO,V_CAMPO,_CTR,_PROGRE,___CODICE_CLIENTE_TROVATO,_PROGRESSIVO_CLIENTE,M.CLI_CODCLI,__SEQUEN,M.TAGGANCIO,M.IDATTIVITA 
		PUBLIC Y_CAMPO,V_CAMPO,_CTR,_PROGRE,___CODICE_CLIENTE_TROVATO,_PROGRESSIVO_CLIENTE,M.CLI_CODCLI,__SEQUEN,M.TAGGANCIO,M.IDATTIVITA
		Y_CAMPO = ""
		V_CAMPO = ""
		_CTR    = 0
		_PROGRE = ""
		___CODICE_CLIENTE_TROVATO = .F.
		_PROGRESSIVO_CLIENTE = 2
		M.CLI_CODCLI = ""
		__SEQUEN = 0
		M.TAGGANCIO	= ""
		M.IDATTIVITA = ""


**** CARICAMENTO DEL FILE IN FORMATO EXCELL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA

		WAIT WINDOWS "ATTENDERE PREGO, CARICAMENTO FILE DA CONVERTIRE" NOWAIT


		gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')

		IF EMPTY(gcFile)
			*THISFORM.VisualizzaMessaggio("Nessun file selezionato.")
			
			**=> ERASMO - INIZIO 18/06/2010
			*****************************************************************************
			*** IL COMANDO ASTERISCATO DAVA ERRORE IN QUANTO LA SINTASSI NON E' CORRETTA: 
			*** NON ESISTE NESSUN "THISFORM" ALL'INTERNO DI UN QUALSIASI .PRG!!!!!!!
			*****************************************************************************
			MESSAGEBOX("Nessun file selezionato",64,"Informazione")
			**=> ERASMO - FINE 18/06/2010
			
			SET DEFAULT TO &PUB_DIR  && ERASMO - 08/07/2010
			
			RETURN
		ENDIF



		WAIT WINDOWS "Selezionato file EXCEL "+gcFile 	NOWAIT 	

		**=> ERASMO - INIZIO 29/11/2010
		*** CORREZIONE PER DESCRIZIONE ATTIVITA' PIU' LUNGA DI 100 CARATTERI			
		CREATE CURSOR IMPORTAXLS (__RAGSOC  c(55),;
			__INDIRIZZO   c(55),;
			__LOCALITA  c(55),;
			__CAP c(5),;
			__PARTITAIVA  c(11),;
			__CODICEFISCALE c(16),;
			__TELEFONO c(25),;
			__FAX c(25),;
			__CODICEATTIVITA c(06),;
			__DESCRIZIONEATTIVITA c(254),;
			__UMXRICAVO c(02),;			
			__RICAVOXDIP N(16,3),;
			__UMXCOSTO c(02),;					
			__COSTOXDIP N(16,3),;
			__NUMERODIP N(5,0),;
			__MAIL C(100),;
			__MESE_14 N(5,0),;			
			__TIPO_FATT C(1),;
			__RICAVI_TRIMESTRALI C(2),;
			__FATT_VOLTA_IN_VOLTA C(1),;
			__MESE_VOLTA_IN_VOLTA N(5,0),;
			__FATT_SALTUARIA C(1))
		**=> ERASMO - FINE 29/11/2010

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


				IF !EMPTY(M.__TIPO_FATT)
					M.__COSTOXDIP  = M.__COSTOXDIP / 12
					M.__RICAVOXDIP = M.__RICAVOXDIP / 12
				ENDIF

		        
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


           		M.CLI_CODCLI = STR(_PROGRESSIVO_CLIENTE ,10,0)
                M.CLI_CODCLI = TRC(PUB_LCL,ALLTRIM(M.CLI_CODCLI))

 				M.CLI_RAGSOC = ALLTRIM (M.__RAGSOC)
   		        M.CLI_RAGSOC = UPPER(M.CLI_RAGSOC)
                M.CLI_RAGSOC = APITOSPA(M.CLI_RAGSOC)

				DO VERIFICA_CLIENTE

				IF ___CODICE_CLIENTE_TROVATO 
				
			        *!*	##################################################################
			        DO CREA_SECONDO_TERZO_LIVELLO_CONTRATTO_CLIENTE_CORRENTE       &&&&&&&
			        *!*	##################################################################				
				
					SELECT IMPORTAXLS
					SKIP +1
					LOOP
				ENDI

				_PROGRESSIVO_CLIENTE = _PROGRESSIVO_CLIENTE + 1
				__SEQUEN  = 0

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

			    M.CLI_BDAL    = "0108"
			    M.CLI_BAL     = "3108"
			    M.CLI_GG1     = "1009"
			    M.CLI_B2DAL   = "2012"
			    M.CLI_B2AL    = "3112"
			    M.CLI_GG2     = "1001"
			    M.CLI_TIPFAT  = "FDV"
			    M.CLI_FLGTRA  = .T.
 				M.CLI_EMAIL	  = M.__MAIL 

				
				

			 	M.CLI_DATNEW = RIBALTA2(DTOC(DATE()))
				M.CLI_DATINS = RIBALTA2(DTOC(DATE()))
				
				IF _elabora_kompasso
					M.CLI_ENPACL = 0
					M.CLI_RA     = 0
				ELSE
					M.CLI_ENPACL = 2
					M.CLI_RA     = 20
				ENDIF

			 
			  	SELECT curs_u_CLI_an			&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
			  	APPEND BLANK
			 	GATHER MEMVAR MEMO 				&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



				****** AGGIORNA TABELLA U_CLI_AN SQL

				IF !ExecRW('','U_CLI_AN','I','','curs_u_CLI_an')
				   return(.f.)
				ENDIF



				*!*	###########################################
				DO CREA_CONTRATTI					&&&&&&&&&&&
				*!*	###########################################
				

	 

				****** RIPUISCE IL CURSORI STP DELL'ANAGRAFICA CLIENTI

				IF !ExecCommand("select * from U_CLI_AN where 1=0","curs_u_cli_an")
				   return
				ENDIF

												   
		   		_CTR = _CTR +1
		   		WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
		   
		    	
		    	
		    	
		    SELECT IMPORTAXLS
			SKIP
		ENDDO



DO RICALCOLA_IL_VALORE_DEI_CONTRATTI WITH "999999",PUB_ANNO,.T.



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

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


***************************************
PROCEDURE CREA_CONTRATTI
***************************************



	*!*	CREA TABELLA CONTRSTUDI : I LIVELLO

   
    *** PRELEVA DALLA TABELLA DEI CONTRATTI L'ULTIMO NUMERO E LO INCREMENTA DI UNO 
    x_cond = "substring(data,1,4) = '" + PUB_ANNO + "'"
    cSql   = "select NUMERO AS ULT_NUMERO from CONTRSTUDI WHERE " + x_cond + " ORDER BY NUMERO DESC"
    IF !ExecCommand(cSql,"NUMERI_CONTRSTUDI")
      return(.f.)
    ENDIF
    SELECT NUMERI_CONTRSTUDI
    GO TOP
    IF EOF()
       M.NUMERO = "00001"
    ELSE
       M.NUMERO = TRC(5,STR((VAL(ULT_NUMERO) + 1),5,0))
    ENDIF


    M.TAGGANCIO = SYS(2015)

	M.ORAINS      = ""
    M.UTENTEINS   = PUB_CODOPE 
    M.DATAINS     = DTOC(DATE())    
    
    SELECT CU_CONTRSTUDI
    APPEND BLANK
    
    REPLACE ID_UNIQUE       WITH "" 
	REPLACE TAGGANCIO 		WITH M.TAGGANCIO 
	REPLACE NUMERO 			WITH M.NUMERO 
	=CAMBIADT(M.DATAINS,"DATA")
	REPLACE CODCLI 			WITH M.CLI_CODCLI
	REPLACE RAGSOC 			WITH M.CLI_RAGSOC 
	REPLACE INDIRI 			WITH M.CLI_INDIR
	REPLACE LOCALI 			WITH M.CLI_LOCALI
	REPLACE CAP 			WITH M.CLI_CAP 
	REPLACE PROVIN 			WITH M.CLI_PROVIN 
	REPLACE NOTE 			WITH ""
	REPLACE UTENTEINS 		WITH M.UTENTEINS
    =CAMBIADT(M.DATAINS,"DATAINS")
	REPLACE ORAINS 			WITH M.ORAINS 
	REPLACE UTENTEMOD 		WITH ""
	REPLACE DATAMOD			WITH ""
	REPLACE ORAMOD 			WITH ""
	REPLACE CHIUSO 			WITH .F.



   IF !ExecRW('','CONTRSTUDI','I','','CU_CONTRSTUDI')
	   return(.f.)
   ENDIF



   * -->> Creazione cursore vuoto di testata contratto I livello
   * -----------------------------------------------------------
   IF !ExecCommand("select * from CONTRSTUDI where 0=1","CU_CONTRSTUDI")
    return(.f.)
   ENDIF



   *!*	##################################################################
   DO CREA_SECONDO_TERZO_LIVELLO_CONTRATTO_CLIENTE_CORRENTE       &&&&&&&&
   *!*	##################################################################				



RETURN


***************************************************************
PROCEDURE CREA_SECONDO_TERZO_LIVELLO_CONTRATTO_CLIENTE_CORRENTE
***************************************************************

*!*	CREA TABELLA CONTRSTUDI : II LIVELLO

	M.IDATTIVITA 	= SYS(2015)
	__SEQUEN  		= __SEQUEN  +10
	M.SEQUEN  		= __SEQUEN  
	M.DATAINIZIO    = "01/01/"+PUB_ANNO
	M.DATAFINE      = "31/12/"+PUB_ANNO
	
	IF ALLTRIM(M.__UMXRICAVO) = "MM"
		M.__UTILE 		= 0
	ELSE
	
		IF M.__RICAVOXDIP > 0	
			M.__UTILE 		= M.__RICAVOXDIP - M.__COSTOXDIP 
		ELSE
			M.__UTILE 		= 0
		ENDIF
	
			
	ENDIF
	

    SELECT CU_CONTRST_DD 	
    APPEND BLANK 

    REPLACE ID_UNIQUE   	WITH ""     
	REPLACE DAGGANCIO 		WITH M.TAGGANCIO  
	REPLACE IDATTIVITA 		WITH M.IDATTIVITA
	REPLACE SEQUEN 			WITH M.SEQUEN 
	=CAMBIADT(M.DATAINIZIO,"DATAINIZIO")
	=CAMBIADT(M.DATAFINE,"DATAFINE")
	*REPLACE CODATTIV 		WITH SUBSTR(ALLTRIM(M.__CODICEATTIVITA),2,8) 
	REPLACE CODATTIV 		WITH TRC(5,SUBSTR(ALLTRIM(M.__CODICEATTIVITA),2,8))  && ERASMO - 23/06/2010
	REPLACE DESATTIV 		WITH UPPER(M.__DESCRIZIONEATTIVITA)
	REPLACE VALCOSTO 		WITH M.__COSTOXDIP 
	REPLACE VALRICAVO 		WITH M.__RICAVOXDIP 
	REPLACE VALUTILE 		WITH M.__UTILE 
	REPLACE ANNOTAZIONI 	WITH ""
	
	
	
   IF !ExecRW('','CONTRST_DD','I','','CU_CONTRST_DD')
	   return(.f.)
   ENDIF




   * -->> Creazione cursore vuoto di testata contratto II livello
   * ------------------------------------------------------------
   IF !ExecCommand("select * from CONTRST_DD where 0=1","CU_CONTRST_DD")
    return(.f.)
   ENDIF


*!*	CREA TABELLA CONTRSTUDI : III LIVELLO

			*!*	FORZATURE ############################
				IF EMPTY(ALLTRIM(M.__UMXRICAVO))	
					M.__UMXRICAVO = 'NR'
				ENDIF
					
				IF EMPTY(ALLTRIM(M.__UMXCOSTO))	
					M.__UMXCOSTO = 'NR'
				ENDIF
			*!*	FORZATURE ############################


            DO CASE
            
            
            		CASE M.__UMXRICAVO = "NR" 



						IF ALLTRIM(M.__FATT_VOLTA_IN_VOLTA)	 = "V"
						
		                    	=FATTURAZIONE_DI_VOLTA_IN_VOLTA()
						
						ELSE
						
 
		                    IF ALLTRIM(M.__FATT_SALTUARIA) = "S"
		                    
		                    	=FATTURAZIONE_SALTUARIA()
		                    	
		                    ELSE
		                    
		                    	=FATTURAZIONE_NORMALE_01()
		                    	
		                    ENDIF
		                    
		                    
		    			ENDIF	

            		CASE M.__UMXRICAVO = "MM" 


						IF ALLTRIM(M.__FATT_VOLTA_IN_VOLTA)	 = "V"

		                    =FATTURAZIONE_DI_VOLTA_IN_VOLTA()
						
						ELSE
						
		                    IF ALLTRIM(M.__FATT_SALTUARIA) = "S"
		                    
		                    	=FATTURAZIONE_SALTUARIA()
		                    	
		                    ELSE
		                    
		                    	=FATTURAZIONE_NORMALE_02()
		                    	
		                    ENDIF
						
						ENDIF 




            		OTHERWISE


** SERGIO ???
						IF ALLTRIM(M.__FATT_VOLTA_IN_VOLTA)	 = "V"
						
						
		                    =FATTURAZIONE_DI_VOLTA_IN_VOLTA()						
						
						
						ELSE

		                    IF ALLTRIM(M.__FATT_SALTUARIA) = "S"
		                    
		                    	=FATTURAZIONE_SALTUARIA()
		                    	
		                    ELSE
		                    
		                    	=FATTURAZIONE_NORMALE_03()
		                    	
		                    ENDIF


						ENDIF
								    
            ENDCASE



RETURN



****************************************
FUNCTION FATTURAZIONE_SALTUARIA
****************************************

    CNT = 12
    FOR DDD=1 TO CNT

	
		    SELECT CU_CONTRST_DL 	
		    APPEND BLANK 
		    
		    IF LEN(ALLTRIM(STR(DDD,3,0))) = 1
		       __MESE = "0"+ALLTRIM(STR(DDD,3,0))
		    ELSE
		    	__MESE = ALLTRIM(STR(DDD,3,0))
		    ENDIF
	
		    _DESMESE  = "xxxxxxxxxxxxxxxxx"	
		    
		    IF __MESE = "01"
		    	_DESMESE  = "Gennaio"
		    ENDIF
		    IF __MESE = "02"
		    	_DESMESE  = "Febbraio"
		    ENDIF
		    IF __MESE = "03"
		    	_DESMESE  = "Marzo"
		    ENDIF
		    IF __MESE = "04"
		    	_DESMESE  = "Aprile"
		    ENDIF
		    IF __MESE = "05"
		    	_DESMESE  = "Maggio"
		    ENDIF
		    IF __MESE = "06"
		    	_DESMESE  = "Giugno"
		    ENDIF
		    IF __MESE = "07"
		    	_DESMESE  = "Luglio"
		    ENDIF
		    IF __MESE = "08"
		    	_DESMESE  = "Agosto"
		    ENDIF
		    IF __MESE = "09"
		    	_DESMESE  = "Settembre"
		    ENDIF
		    IF __MESE = "10"
		    	_DESMESE  = "Ottobre"
		    ENDIF
		    IF __MESE = "11"
		    	_DESMESE  = "Novembre"
		    ENDIF
		    IF __MESE = "12"
		    	_DESMESE  = "Dicembre"
		    ENDIF
		    
		    		    
		    M.AAAAMM = PUB_ANNO+"/"+__MESE 
		    M.ANNOTAZIONI = "Elaborazione del mese di "+_DESMESE + " " + PUB_ANNO  && ERASMO - 08/10/2010
		    

    		REPLACE ID_UNIQUE   	WITH ""   		    
			REPLACE DAGGANCIO 		WITH M.TAGGANCIO  
			REPLACE IDATTIVITA 		WITH M.IDATTIVITA 
			REPLACE AAAAMM 			WITH M.AAAAMM 
		

			REPLACE UMCOSTO 		WITH M.__UMXCOSTO								
			REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
			IF M.__UMXCOSTO = "NR"
				REPLACE QTACOSTO 		WITH M.__NUMERODIP
				REPLACE COSTO 			WITH M.__COSTOXDIP * M.__NUMERODIP									
			ELSE								
				REPLACE QTACOSTO 		WITH 1
				REPLACE COSTO 			WITH M.__COSTOXDIP 									
			ENDIF
			
			REPLACE UMRICAVO 		WITH M.__UMXRICAVO
			REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP
			IF M.__UMXRICAVO = "NR"
				REPLACE QTARICAVO 		WITH M.__NUMERODIP
				REPLACE RICAVO 			WITH M.__RICAVOXDIP * M.__NUMERODIP									
			ELSE
				REPLACE QTARICAVO 		WITH 1
				REPLACE RICAVO 			WITH M.__RICAVOXDIP 
			ENDIF
			
			
			REPLACE QtaRicavo2      WITH 0
			REPLACE UTILE 			WITH RICAVO - COSTO 
			REPLACE ANNOTAZIONI 	WITH M.ANNOTAZIONI 
			REPLACE FLGFATTURAB 	WITH .F.   

			REPLACE Tipo_fatt       WITH "S" &&  FATTURAZIONE TRIMESTRALE
			REPLACE UMCOSTO 		WITH "MM"
			REPLACE UMRICAVO 		WITH "MM"
			REPLACE QTARICAVO 		WITH 1
			REPLACE QTACOSTO 		WITH 1
			REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
			REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP								
			REPLACE RICAVO 			WITH M.__RICAVOXDIP 
			REPLACE COSTO 			WITH M.__COSTOXDIP 
			REPLACE UTILE 			WITH RICAVO - COSTO

			REPLACE TIPO_ELAB 		WITH "M"	
			REPLACE IDDETTAGLI 		WITH SYS(2015)								

			SELECT CU_CONTRST_DL 
			SCATTER MEMVAR MEMO    								
			

		    IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
			   return(.f.)
		    ENDIF


		    * -->> Creazione cursore vuoto di testata contratto III livello
		    * -------------------------------------------------------------
		    IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
		      return(.f.)
		    ENDIF

    NEXT


*!*	    SELECT CU_CONTRST_DL 	
*!*	    APPEND BLANK 
*!*	    IF LEN(ALLTRIM(STR(M.__MESE_VOLTA_IN_VOLTA,3,0))) = 1
*!*	       __MESE = "0"+ALLTRIM(STR(M.__MESE_VOLTA_IN_VOLTA,3,0))
*!*	    ELSE
*!*	    	__MESE = ALLTRIM(STR(M.__MESE_VOLTA_IN_VOLTA,3,0))
*!*	    ENDIF
*!*	    _DESMESE  = "xxxxxxxxxxxxxxxxx"	
*!*	    IF __MESE = "01"
*!*	    	_DESMESE  = "Gennaio"
*!*	    ENDIF
*!*	    IF __MESE = "02"
*!*	    	_DESMESE  = "Febbraio"
*!*	    ENDIF
*!*	    IF __MESE = "03"
*!*	    	_DESMESE  = "Marzo"
*!*	    ENDIF
*!*	    IF __MESE = "04"
*!*	    	_DESMESE  = "Aprile"
*!*	    ENDIF
*!*	    IF __MESE = "05"
*!*	    	_DESMESE  = "Maggio"
*!*	    ENDIF
*!*	    IF __MESE = "06"
*!*	    	_DESMESE  = "Giugno"
*!*	    ENDIF
*!*	    IF __MESE = "07"
*!*	    	_DESMESE  = "Luglio"
*!*	    ENDIF
*!*	    IF __MESE = "08"
*!*	    	_DESMESE  = "Agosto"
*!*	    ENDIF
*!*	    IF __MESE = "09"
*!*	    	_DESMESE  = "Settembre"
*!*	    ENDIF
*!*	    IF __MESE = "10"
*!*	    	_DESMESE  = "Ottobre"
*!*	    ENDIF
*!*	    IF __MESE = "11"
*!*	    	_DESMESE  = "Novembre"
*!*	    ENDIF
*!*	    IF __MESE = "12"
*!*	    	_DESMESE  = "Dicembre"
*!*	    ENDIF
*!*	    M.AAAAMM = PUB_ANNO+"/"+__MESE 
*!*	    M.ANNOTAZIONI = "Elaborazione del mese di "+_DESMESE + " " + PUB_ANNO  && ERASMO - 08/10/2010
*!*		REPLACE ID_UNIQUE   	WITH ""   		    
*!*		REPLACE DAGGANCIO 		WITH M.TAGGANCIO  
*!*		REPLACE IDATTIVITA 		WITH M.IDATTIVITA 
*!*		REPLACE AAAAMM 			WITH M.AAAAMM 
*!*		REPLACE QTACOSTO 		WITH M.__NUMERODIP
*!*		REPLACE UMCOSTO 		WITH M.__UMXCOSTO
*!*		REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
*!*		REPLACE COSTO 			WITH M.__COSTOXDIP * M.__NUMERODIP
*!*		REPLACE QTARICAVO 		WITH M.__NUMERODIP
*!*		REPLACE QtaRicavo2      WITH 0
*!*		REPLACE UMRICAVO 		WITH M.__UMXRICAVO
*!*		REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP
*!*		REPLACE RICAVO 			WITH M.__RICAVOXDIP * M.__NUMERODIP
*!*		REPLACE UTILE 			WITH RICAVO - COSTO
*!*		REPLACE ANNOTAZIONI 	WITH M.ANNOTAZIONI 
*!*		REPLACE Tipo_fatt       WITH "S" &&  FATTURAZIONE DI VOLTA IN VOLTA
*!*		REPLACE UMCOSTO 		WITH "NR"
*!*		REPLACE UMRICAVO 		WITH "NR"
*!*		REPLACE QTARICAVO 		WITH 1
*!*		REPLACE QTACOSTO 		WITH 1
*!*		REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
*!*		REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP									
*!*		REPLACE RICAVO 			WITH M.__RICAVOXDIP 
*!*		REPLACE COSTO 			WITH M.__COSTOXDIP 
*!*		REPLACE UTILE 			WITH RICAVO - COSTO
*!*		REPLACE FLGFATTURAB 	WITH .F.
*!*		REPLACE TIPO_ELAB 		WITH "M"	
*!*		REPLACE IDDETTAGLI 		WITH SYS(2015)

*!*		SELECT CU_CONTRST_DL 
*!*		SCATTER MEMVAR MEMO    

*!*	    IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
*!*		   return(.f.)
*!*	    ENDIF


*!*	    * -->> Creazione cursore vuoto di testata contratto III livello
*!*	    * -------------------------------------------------------------
*!*	    IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
*!*	      return(.f.)
*!*	    ENDIF






RETURN




****************************************
FUNCTION FATTURAZIONE_DI_VOLTA_IN_VOLTA
****************************************

    SELECT CU_CONTRST_DL 	
    APPEND BLANK 
    IF LEN(ALLTRIM(STR(M.__MESE_VOLTA_IN_VOLTA,3,0))) = 1
       __MESE = "0"+ALLTRIM(STR(M.__MESE_VOLTA_IN_VOLTA,3,0))
    ELSE
    	__MESE = ALLTRIM(STR(M.__MESE_VOLTA_IN_VOLTA,3,0))
    ENDIF
    _DESMESE  = "xxxxxxxxxxxxxxxxx"	
    IF __MESE = "01"
    	_DESMESE  = "Gennaio"
    ENDIF
    IF __MESE = "02"
    	_DESMESE  = "Febbraio"
    ENDIF
    IF __MESE = "03"
    	_DESMESE  = "Marzo"
    ENDIF
    IF __MESE = "04"
    	_DESMESE  = "Aprile"
    ENDIF
    IF __MESE = "05"
    	_DESMESE  = "Maggio"
    ENDIF
    IF __MESE = "06"
    	_DESMESE  = "Giugno"
    ENDIF
    IF __MESE = "07"
    	_DESMESE  = "Luglio"
    ENDIF
    IF __MESE = "08"
    	_DESMESE  = "Agosto"
    ENDIF
    IF __MESE = "09"
    	_DESMESE  = "Settembre"
    ENDIF
    IF __MESE = "10"
    	_DESMESE  = "Ottobre"
    ENDIF
    IF __MESE = "11"
    	_DESMESE  = "Novembre"
    ENDIF
    IF __MESE = "12"
    	_DESMESE  = "Dicembre"
    ENDIF
    M.AAAAMM = PUB_ANNO+"/"+__MESE 
    M.ANNOTAZIONI = "Elaborazione del mese di "+_DESMESE + " " + PUB_ANNO  && ERASMO - 08/10/2010
	REPLACE ID_UNIQUE   	WITH ""   		    
	REPLACE DAGGANCIO 		WITH M.TAGGANCIO  
	REPLACE IDATTIVITA 		WITH M.IDATTIVITA 
	REPLACE AAAAMM 			WITH M.AAAAMM 
	REPLACE QTACOSTO 		WITH M.__NUMERODIP
	REPLACE UMCOSTO 		WITH M.__UMXCOSTO
	REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
	REPLACE COSTO 			WITH M.__COSTOXDIP * M.__NUMERODIP
	REPLACE QTARICAVO 		WITH M.__NUMERODIP
	REPLACE QtaRicavo2      WITH 0
	REPLACE UMRICAVO 		WITH M.__UMXRICAVO
	REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP
	REPLACE RICAVO 			WITH M.__RICAVOXDIP * M.__NUMERODIP
	REPLACE UTILE 			WITH RICAVO - COSTO
	REPLACE ANNOTAZIONI 	WITH M.ANNOTAZIONI 
	REPLACE Tipo_fatt       WITH "V" &&  FATTURAZIONE DI VOLTA IN VOLTA
	REPLACE UMCOSTO 		WITH "NR"
	REPLACE UMRICAVO 		WITH "NR"
	REPLACE QTARICAVO 		WITH 1
	REPLACE QTACOSTO 		WITH 1
	REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
	REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP									
	REPLACE RICAVO 			WITH M.__RICAVOXDIP 
	REPLACE COSTO 			WITH M.__COSTOXDIP 
	REPLACE UTILE 			WITH RICAVO - COSTO
	REPLACE FLGFATTURAB 	WITH .F.
	REPLACE TIPO_ELAB 		WITH "M"	
	REPLACE IDDETTAGLI 		WITH SYS(2015)

	SELECT CU_CONTRST_DL 
	SCATTER MEMVAR MEMO    

    IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
	   return(.f.)
    ENDIF


    * -->> Creazione cursore vuoto di testata contratto III livello
    * -------------------------------------------------------------
    IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
      return(.f.)
    ENDIF





RETURN



****************************************
FUNCTION FATTURAZIONE_NORMALE_01
****************************************


    CNT = 12          
    FOR DDD=1 TO CNT



	    SELECT CU_CONTRST_DL 	
	    APPEND BLANK 
	    
	    IF LEN(ALLTRIM(STR(DDD,3,0))) = 1
	       __MESE = "0"+ALLTRIM(STR(DDD,3,0))
	    ELSE
	    	__MESE = ALLTRIM(STR(DDD,3,0))
	    ENDIF

	    _DESMESE  = "xxxxxxxxxxxxxxxxx"	
	    
	    IF __MESE = "01"
	    	_DESMESE  = "Gennaio"
	    ENDIF
	    IF __MESE = "02"
	    	_DESMESE  = "Febbraio"
	    ENDIF
	    IF __MESE = "03"
	    	_DESMESE  = "Marzo"
	    ENDIF
	    IF __MESE = "04"
	    	_DESMESE  = "Aprile"
	    ENDIF
	    IF __MESE = "05"
	    	_DESMESE  = "Maggio"
	    ENDIF
	    IF __MESE = "06"
	    	_DESMESE  = "Giugno"
	    ENDIF
	    IF __MESE = "07"
	    	_DESMESE  = "Luglio"
	    ENDIF
	    IF __MESE = "08"
	    	_DESMESE  = "Agosto"
	    ENDIF
	    IF __MESE = "09"
	    	_DESMESE  = "Settembre"
	    ENDIF
	    IF __MESE = "10"
	    	_DESMESE  = "Ottobre"
	    ENDIF
	    IF __MESE = "11"
	    	_DESMESE  = "Novembre"
	    ENDIF
	    IF __MESE = "12"
	    	_DESMESE  = "Dicembre"
	    ENDIF
	    
	    		    
	    M.AAAAMM = PUB_ANNO+"/"+__MESE 
	    M.ANNOTAZIONI = "Elaborazione del mese di "+_DESMESE + " " + PUB_ANNO  && ERASMO - 08/10/2010
	    
		
		REPLACE ID_UNIQUE   	WITH ""   		    
		REPLACE DAGGANCIO 		WITH M.TAGGANCIO  
		REPLACE IDATTIVITA 		WITH M.IDATTIVITA 
		REPLACE AAAAMM 			WITH M.AAAAMM 
	

		
		REPLACE QTACOSTO 		WITH M.__NUMERODIP
		REPLACE UMCOSTO 		WITH M.__UMXCOSTO
		REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
		REPLACE COSTO 			WITH M.__COSTOXDIP * M.__NUMERODIP
		REPLACE QTARICAVO 		WITH M.__NUMERODIP
		
		REPLACE QtaRicavo2      WITH 0

		
		REPLACE UMRICAVO 		WITH M.__UMXRICAVO
		REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP
		REPLACE RICAVO 			WITH M.__RICAVOXDIP * M.__NUMERODIP
		REPLACE UTILE 			WITH RICAVO - COSTO
		REPLACE ANNOTAZIONI 	WITH M.ANNOTAZIONI 


		IF !EMPTY(M.__TIPO_FATT)
			REPLACE Tipo_fatt       WITH "A" &&  FATTURAZIONE ANNUALE
		ENDIF
		
		IF ALLTRIM(M.__RICAVI_TRIMESTRALI) = "RT"
			REPLACE Tipo_fatt       WITH "T" &&  FATTURAZIONE TRIMESTRALE
			REPLACE UMCOSTO 		WITH "NR"
			REPLACE UMRICAVO 		WITH "NR"
			REPLACE QTARICAVO 		WITH 1
			REPLACE QTACOSTO 		WITH 1
			REPLACE PRZCOSTO 		WITH M.__COSTOXDIP / 3
			REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP	/ 3								
			REPLACE RICAVO 			WITH M.__RICAVOXDIP / 3
			REPLACE COSTO 			WITH M.__COSTOXDIP / 3
			REPLACE UTILE 			WITH RICAVO - COSTO
		ENDIF


		IF ALLTRIM(M.__FATT_VOLTA_IN_VOLTA)	 = "V"
			REPLACE Tipo_fatt       WITH "V" &&  FATTURAZIONE TRIMESTRALE
			REPLACE UMCOSTO 		WITH "MM"
			REPLACE UMRICAVO 		WITH "MM"
			REPLACE QTARICAVO 		WITH 1
			REPLACE QTACOSTO 		WITH 1
			REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
			REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP									
			REPLACE RICAVO 			WITH M.__RICAVOXDIP 
			REPLACE COSTO 			WITH M.__COSTOXDIP 
			REPLACE UTILE 			WITH RICAVO - COSTO
		ENDIF


		
		REPLACE FLGFATTURAB 	WITH .F.

		REPLACE TIPO_ELAB 		WITH "M"	
		REPLACE IDDETTAGLI 		WITH SYS(2015)

		SELECT CU_CONTRST_DL 
		SCATTER MEMVAR MEMO    
		    


	    IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
		   return(.f.)
	    ENDIF


		IF 	M.__MESE_14   = VAL(__MESE)  				&& CREA RECORD 14ma


		    * -->> Creazione cursore vuoto di testata contratto III livello
		    * -------------------------------------------------------------
		    IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
		      return(.f.)
		    ENDIF
		
		    SELECT CU_CONTRST_DL 
		    APPEND BLANK
		    M.IDDETTAGLI = SYS(2015)  && ERASMO - 07/10/2010
		    M.ANNOTAZIONI = "Elaborazione quattordicesima del mese di "+_DESMESE + " " + PUB_ANNO  && ERASMO - 08/10/2010
		    GATHER MEMVAR MEMO
			REPLACE TIPO_ELAB 		WITH "Q"	
	   	 	IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
			   return(.f.)
	    	ENDIF
		
		
		ENDIF

		IF 	VAL(__MESE)   = 12  				&& CREA RECORD 13ma

		    * -->> Creazione cursore vuoto di testata contratto III livello
		    * -------------------------------------------------------------
		    IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
		      return(.f.)
		    ENDIF

		
		    SELECT CU_CONTRST_DL 
		    APPEND BLANK
		    M.IDDETTAGLI = SYS(2015)  && ERASMO - 07/10/2010
		    M.ANNOTAZIONI = "Elaborazione tredicesima del mese di "+_DESMESE + " " + PUB_ANNO  && ERASMO - 08/10/2010
		    GATHER MEMVAR MEMO							    
			REPLACE TIPO_ELAB 		WITH "T"	
	   	 	IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
			   return(.f.)
	    	ENDIF
		
		
		ENDIF

		

	    * -->> Creazione cursore vuoto di testata contratto III livello
	    * -------------------------------------------------------------
	    IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
	      return(.f.)
	    ENDIF


    NEXT




RETURN





****************************************
FUNCTION FATTURAZIONE_NORMALE_02
****************************************




    CNT = 12
    FOR DDD=1 TO CNT

	
		    SELECT CU_CONTRST_DL 	
		    APPEND BLANK 
		    
		    IF LEN(ALLTRIM(STR(DDD,3,0))) = 1
		       __MESE = "0"+ALLTRIM(STR(DDD,3,0))
		    ELSE
		    	__MESE = ALLTRIM(STR(DDD,3,0))
		    ENDIF
	
		    _DESMESE  = "xxxxxxxxxxxxxxxxx"	
		    
		    IF __MESE = "01"
		    	_DESMESE  = "Gennaio"
		    ENDIF
		    IF __MESE = "02"
		    	_DESMESE  = "Febbraio"
		    ENDIF
		    IF __MESE = "03"
		    	_DESMESE  = "Marzo"
		    ENDIF
		    IF __MESE = "04"
		    	_DESMESE  = "Aprile"
		    ENDIF
		    IF __MESE = "05"
		    	_DESMESE  = "Maggio"
		    ENDIF
		    IF __MESE = "06"
		    	_DESMESE  = "Giugno"
		    ENDIF
		    IF __MESE = "07"
		    	_DESMESE  = "Luglio"
		    ENDIF
		    IF __MESE = "08"
		    	_DESMESE  = "Agosto"
		    ENDIF
		    IF __MESE = "09"
		    	_DESMESE  = "Settembre"
		    ENDIF
		    IF __MESE = "10"
		    	_DESMESE  = "Ottobre"
		    ENDIF
		    IF __MESE = "11"
		    	_DESMESE  = "Novembre"
		    ENDIF
		    IF __MESE = "12"
		    	_DESMESE  = "Dicembre"
		    ENDIF
		    
		    		    
		    M.AAAAMM = PUB_ANNO+"/"+__MESE 
		    *M.ANNOTAZIONI = "Attività svolte nel mese di "+_DESMESE + " " + PUB_ANNO
		    M.ANNOTAZIONI = "Elaborazione del mese di "+_DESMESE + " " + PUB_ANNO  && ERASMO - 08/10/2010
		    

    		REPLACE ID_UNIQUE   	WITH ""   		    
			REPLACE DAGGANCIO 		WITH M.TAGGANCIO  
			REPLACE IDATTIVITA 		WITH M.IDATTIVITA 
			REPLACE AAAAMM 			WITH M.AAAAMM 
		

			REPLACE UMCOSTO 		WITH M.__UMXCOSTO								
			REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
			IF M.__UMXCOSTO = "NR"
				REPLACE QTACOSTO 		WITH M.__NUMERODIP
				REPLACE COSTO 			WITH M.__COSTOXDIP * M.__NUMERODIP									
			ELSE								
				REPLACE QTACOSTO 		WITH 1
				REPLACE COSTO 			WITH M.__COSTOXDIP 									
			ENDIF
			
			REPLACE UMRICAVO 		WITH M.__UMXRICAVO
			REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP
			IF M.__UMXRICAVO = "NR"
				REPLACE QTARICAVO 		WITH M.__NUMERODIP
				REPLACE RICAVO 			WITH M.__RICAVOXDIP * M.__NUMERODIP									
			ELSE
				REPLACE QTARICAVO 		WITH 1
				REPLACE RICAVO 			WITH M.__RICAVOXDIP 
			ENDIF
			
			
			REPLACE QtaRicavo2      WITH 0
			REPLACE UTILE 			WITH RICAVO - COSTO 
			REPLACE ANNOTAZIONI 	WITH M.ANNOTAZIONI 
			REPLACE FLGFATTURAB 	WITH .F.



			IF !EMPTY(M.__TIPO_FATT)
				REPLACE Tipo_fatt       WITH "A" &&  FATTURAZIONE ANNUALE
			ENDIF

			IF ALLTRIM(M.__RICAVI_TRIMESTRALI) = "RT"
				REPLACE Tipo_fatt       WITH "T" &&  FATTURAZIONE TRIMESTRALE
				REPLACE UMCOSTO 		WITH "NR"
				REPLACE UMRICAVO 		WITH "NR"
				REPLACE QTARICAVO 		WITH 1
				REPLACE QTACOSTO 		WITH 1
				REPLACE PRZCOSTO 		WITH M.__COSTOXDIP / 3
				REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP	/ 3								
				REPLACE RICAVO 			WITH M.__RICAVOXDIP / 3
				REPLACE COSTO 			WITH M.__COSTOXDIP / 3
				REPLACE UTILE 			WITH RICAVO - COSTO
			ENDIF

			IF ALLTRIM(M.__FATT_VOLTA_IN_VOLTA)	 = "V"
				REPLACE Tipo_fatt       WITH "V" &&  FATTURAZIONE TRIMESTRALE
				REPLACE UMCOSTO 		WITH "MM"
				REPLACE UMRICAVO 		WITH "MM"
				REPLACE QTARICAVO 		WITH 1
				REPLACE QTACOSTO 		WITH 1
				REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
				REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP								
				REPLACE RICAVO 			WITH M.__RICAVOXDIP 
				REPLACE COSTO 			WITH M.__COSTOXDIP 
				REPLACE UTILE 			WITH RICAVO - COSTO
			ENDIF


			REPLACE TIPO_ELAB 		WITH "M"	
			REPLACE IDDETTAGLI 		WITH SYS(2015)								

			SELECT CU_CONTRST_DL 
			SCATTER MEMVAR MEMO    								
			

		    IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
			   return(.f.)
		    ENDIF


			IF 	M.__MESE_14   = VAL(__MESE)  				&& CREA RECORD 14ma


			    * -->> Creazione cursore vuoto di testata contratto III livello
			    * -------------------------------------------------------------
			    IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
			      return(.f.)
			    ENDIF
			
			    SELECT CU_CONTRST_DL 
			    APPEND BLANK
			    M.IDDETTAGLI = SYS(2015)  && ERASMO - 07/10/2010
			    M.ANNOTAZIONI = "Elaborazione quattordicesima del mese di "+_DESMESE + " " + PUB_ANNO  && ERASMO - 08/10/2010
			    GATHER MEMVAR MEMO
				REPLACE TIPO_ELAB 		WITH "Q"	
		   	 	IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
				   return(.f.)
		    	ENDIF
			
			
			ENDIF

			IF 	VAL(__MESE)   = 12  				&& CREA RECORD 13ma


				    * -->> Creazione cursore vuoto di testata contratto III livello
			    * -------------------------------------------------------------
			    IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
			      return(.f.)
			    ENDIF
		
			    SELECT CU_CONTRST_DL 
			    APPEND BLANK
			    M.IDDETTAGLI = SYS(2015)  && ERASMO - 07/10/2010
			    M.ANNOTAZIONI = "Elaborazione tredicesima del mese di "+_DESMESE + " " + PUB_ANNO  && ERASMO - 08/10/2010
			    GATHER MEMVAR MEMO							    
				REPLACE TIPO_ELAB 		WITH "T"	
		   	 	IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
				   return(.f.)
		    	ENDIF
			
			
			ENDIF






		    * -->> Creazione cursore vuoto di testata contratto III livello
		    * -------------------------------------------------------------
		    IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
		      return(.f.)
		    ENDIF

    NEXT




RETURN





****************************************
FUNCTION FATTURAZIONE_NORMALE_03
****************************************


					
    M.AAAAMM = PUB_ANNO+"/"+"12" 
    M.ANNOTAZIONI = "Elaborazione svolta nell'anno : "+PUB_ANNO
    
    SELECT CU_CONTRST_DL 	
    APPEND BLANK 

	REPLACE ID_UNIQUE   	WITH ""   		    
	REPLACE DAGGANCIO 		WITH M.TAGGANCIO  
	REPLACE IDATTIVITA 		WITH M.IDATTIVITA 
	REPLACE AAAAMM 			WITH M.AAAAMM 
	REPLACE TIPO_FATT 		WITH M.__TIPO_FATT 								

	IF !EMPTY(M.__TIPO_FATT)
		REPLACE Tipo_fatt       WITH "A" &&  FATTURAZIONE ANNUALE
	ENDIF


	REPLACE UMCOSTO 		WITH M.__UMXCOSTO
	REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
	IF M.__UMXCOSTO = "NR"
		REPLACE QTACOSTO 		WITH M.__NUMERODIP
		REPLACE COSTO 			WITH M.__COSTOXDIP * M.__NUMERODIP									
	ELSE								
		REPLACE QTACOSTO 		WITH 1
		REPLACE COSTO 			WITH M.__COSTOXDIP 									
	ENDIF


	REPLACE UMRICAVO 		WITH M.__UMXRICAVO
	REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP
	IF M.__UMXRICAVO = "NR"
		REPLACE QTARICAVO 		WITH M.__NUMERODIP
		REPLACE RICAVO 			WITH M.__RICAVOXDIP * M.__NUMERODIP									
	ELSE
		REPLACE QTARICAVO 		WITH 1
		REPLACE RICAVO 			WITH M.__RICAVOXDIP 
	ENDIF
	
	REPLACE UTILE 			WITH RICAVO - COSTO
	REPLACE ANNOTAZIONI 	WITH M.ANNOTAZIONI 
	REPLACE FLGFATTURAB 	WITH .F.

	REPLACE TIPO_ELAB 		WITH "M"	
	REPLACE IDDETTAGLI 		WITH SYS(2015)


	IF ALLTRIM(M.__RICAVI_TRIMESTRALI) = "RT"
		REPLACE Tipo_fatt       WITH "T" &&  FATTURAZIONE TRIMESTRALE
		REPLACE UMCOSTO 		WITH "NR"
		REPLACE UMRICAVO 		WITH "NR"
		REPLACE QTARICAVO 		WITH 1
		REPLACE QTACOSTO 		WITH 1
		REPLACE PRZCOSTO 		WITH M.__COSTOXDIP / 3
		REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP	/ 3								
		REPLACE RICAVO 			WITH M.__RICAVOXDIP / 3
		REPLACE COSTO 			WITH M.__COSTOXDIP / 3
		REPLACE UTILE 			WITH RICAVO - COSTO
	ENDIF


	IF ALLTRIM(M.__FATT_VOLTA_IN_VOLTA)	 = "V"
		REPLACE Tipo_fatt       WITH "V" &&  FATTURAZIONE TRIMESTRALE
		REPLACE UMCOSTO 		WITH "MM"
		REPLACE UMRICAVO 		WITH "MM"
		REPLACE QTARICAVO 		WITH 1
		REPLACE QTACOSTO 		WITH 1
		REPLACE PRZCOSTO 		WITH M.__COSTOXDIP 
		REPLACE PRZRICAVO 		WITH M.__RICAVOXDIP									
		REPLACE RICAVO 			WITH M.__RICAVOXDIP 
		REPLACE COSTO 			WITH M.__COSTOXDIP 
		REPLACE UTILE 			WITH RICAVO - COSTO
	ENDIF


    IF !ExecRW('','CONTRST_DL','I','','CU_CONTRST_DL')
	   return(.f.)
    ENDIF



    * -->> Creazione cursore vuoto di testata contratto III livello
    * -------------------------------------------------------------
    IF !ExecCommand("select * from CONTRST_DL where 0=1","CU_CONTRST_DL")
      return(.f.)
    ENDIF




RETURN