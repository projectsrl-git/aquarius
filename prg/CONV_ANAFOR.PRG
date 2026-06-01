*************************************************************************************************
*							CONVERSIONE ANAGRAFICA FORNITORI										*
*							 																	*
*	by Fabio Luconi per Project S.r.l.															*
*	Febbraio 2004				 																*
*************************************************************************************************

*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica fornitori	 ?",292,"ATTENZIONE")
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

		V_PATH = ""


****** DEFINIZIONE DEL CURSORE STP

		IF !ExecCommand("select * from U_FOR_AN where 1=0","curs_u_for_an")
		   return
		ENDIF


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA FORNITORI" NOWAIT


*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_CLI_AN SQL

		cSql = "delete from U_FOR_AN where 1=1"
		IF !ExecCommand(cSql,"U_FOR_AN")
		   return(.f.)
		ENDIF

******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO

		RELEASE Y_CAMPO,V_CAMPO,_CTR,_PROGRE
		PUBLIC Y_CAMPO,V_CAMPO,_CTR,_PROGRE
		Y_CAMPO = ""
		V_CAMPO = ""
		_CTR    = 0
		_PROGRE = ""
		CREATE CURSOR TRANSITO (TRA_RECORD C(200))

		*SELECT TRANSITO
		*APPEND FROM &V_PATH SDF



**** CARICAMENTO DEL FILE IN FORMATO TESTO

		SELECT TRANSITO  
		gcTable = GETFILE('', 'Seleziona file fornitori da convertire', 'Converti',0)
		IF empty(gcTable) .or. gcTable = ""
		   =MESSAGEBOX("Nessun file selezionato, operazione abbandonata",62,"ATTENZIONE")
		   RETURN
		ENDIF
		APPEND FROM &gcTable SDF
		GO TOP

***** TOGLIE I RECORD SUPERFLUI

		SELECT TRANSITO

		DELETE FOR SUBSTR(TRA_RECORD,2,5) = "-----"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,5,7) = "Azienda"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,1,2) = "=="  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,2,2) = "=="  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,50,5) = "-----"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,50,9) = "Indirizzo"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,50,8) = "Telefono"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,50,9) = "Part. Iva"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,50,6) = "Codice"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,12,6) = "Codice"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,1,7) = "Ordinam"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,50,5) = "Campo"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,10,1) = ":"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,1,9) = "Fornitore"  ALL
		GO TOP
		DELETE FOR empty(TRA_RECORD)   ALL
		GO TOP
		
*!*			GO TOP
*!*			BROWSE
*!*			RETURN

***** ELABORA IL CURSORE transito PER DARE A TUTTE LE RIGHE L'ABBINAMENTO CON IL RELATIVO CODICE FORNITORE
_PROGRE=""
DO WHILE !EOF()
	IF EMPTY(SUBSTR(TRA_RECORD,1,6))
	   REPLACE TRA_RECORD WITH _PROGRE+SUBSTR(TRA_RECORD,7,LEN(TRA_RECORD))
	   SKIP + 1 
	   LOOP
	ELSE
		_PROGRE = SUBSTR(TRA_RECORD,1,6) 
		SKIP + 1 
	   LOOP 
	ENDIF
ENDDO


IF !ExecCommand("select * from u_ban_an ","curs_u_ban_an")
   return(.f.)
ENDIF
SELECT CURS_U_BAN_AN	
INDEX ON BAN_CODABI + BAN_CODCAB TAG CODBAN ADDITIVE


SELECT TRANSITO



***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP


		SELECT TRANSITO
		GO TOP
		_appo = SUBSTR(TRA_RECORD,1,6) && VALORIZZO UNA VARIABILE DI APPOGGIO UGUALE AL PRIMO CODICE DEL CLIENTE
		

		
		DO WHILE .T.

		   IF EOF()
		      EXIT
		   ENDIF

		

		******** ASSEGNAZIONE VARIABILI DEL FILE DI TESTO CHE E' CONTENUTO NEL CURSORE TRANSITO

		   SELECT TRANSITO
		   	            
           
            M.FOR_CODSOC = '01' 
           IF  SUBSTR(TRA_RECORD,1,6) = _appo 
           
           		M.FOR_CODCLI = _APPO
 	            M.FOR_CODCLI = TRC(PUB_LCL,ALLTRIM(M.FOR_CODCLI))
 	            
  				M.FOR_RAGSOC = ALLTRIM (SUBSTR(TRA_RECORD,7,43))
   		        M.FOR_RAGSOC = UPPER(M.FOR_RAGSOC)
                M.FOR_RAGSOC = APITOSPA(M.FOR_RAGSOC)

		   		M.FOR_INDIR = ALLTRIM (SUBSTR(TRA_RECORD,50,36))
   		        M.FOR_INDIR  = UPPER(M.FOR_INDIR)
                M.FOR_INDIR  = APITOSPA(M.FOR_INDIR)

				M.FOR_CAP = ALLTRIM (SUBSTR(TRA_RECORD,86,5))
				
				M.FOR_LOCALI = ALLTRIM (SUBSTR(TRA_RECORD,92,25))
   		        M.FOR_LOCALI = UPPER(M.FOR_LOCALI)
                M.FOR_LOCALI = APITOSPA(M.FOR_LOCALI)

				M.FOR_PROVIN = ALLTRIM (SUBSTR(TRA_RECORD,118,2))
   		        M.FOR_PROVIN = UPPER(M.FOR_PROVIN)
                M.FOR_PROVIN = APITOSPA(M.FOR_PROVIN)

			   M.FOR_BDAL 	= '0108'
			   M.FOR_BAL 	= '3108'
			   M.FOR_GG1 	= '1009'
			   M.FOR_B2DAL  = '2012'
			   M.FOR_B2AL 	= '3112'
			   M.FOR_GG2 	= '1001'

			   M.FOR_COSATRATTA 		= 'GENER'
			   M.FOR_GRADOIMPORTANZA 	= 'PRIMA'
			   M.FOR_FORMAPAGAMENTO 	= 'RIMES'
			   M.FOR_TIPOCONTRATTO 		= 'SCADE'
			   M.FOR_CODACQ	 			= '001'
			   M.FOR_PRIPAGA			= '0500'



                _seek      = "'"+ALLTRIM(M.FOR_locali)+"'"
                cSql 	   = "SELECT * FROM comuni where comune = " + _seek + " order by comune"
    		    IF !ExecCommand(cSql,'COMUNI')
		           return(.f.)
		        ENDIF
                SELECT COMUNI
                GO TOP
                IF EOF()
                ELSE
   				   M.FOR_LOCALI = UPPER(COMUNE)
				   M.FOR_PROVIN = UPPER(PROVINCIA)
				   M.FOR_CAP    = CAP
				ENDIF
				
				SELECT TRANSITO				
				SKIP+1
				M.FOR_TELEFO = ALLTRIM (SUBSTR(TRA_RECORD,50,16))
				M.FOR_FAX = ALLTRIM (SUBSTR(TRA_RECORD,69,16))
				
				SKIP+1
				M.FOR_IVACEE=""
				M.FOR_PARIVA=""
				M.FOR_CODFIS=""
				IF !EMPTY (ALLTRIM(SUBSTR(TRA_RECORD,84,16))) && VERIFICO SE HA UNA P.IVA ESTERA E VALORIZZO IL CAMPO IVACEE
					M.FOR_IVACEE = SUBSTR(TRA_RECORD,84,16)
				ELSE
					M.FOR_PARIVA = SUBSTR(TRA_RECORD,50,11)
					IF !EMPTY(ALLTRIM(SUBSTR(TRA_RECORD,67,16))) && VERIFICO SE è PRESENTE ANCHE IL CODICE FISCALE
						M.FOR_CODFIS = SUBSTR(TRA_RECORD,67,16)	
					ENDIF
				ENDIF
				
				SKIP+1
				
				M.TIPOFOR = ""
				M.for_Dtnasc= ""
				M.for_lunasc=""
				M.FOR_PRVNASC=""
				IF SUBSTR(TRA_RECORD,50,7)= "Normale"
					M.TIPOFOR = SUBSTR(TRA_RECORD,50,7)
					SKIP+1
				ELSE
					M.TIPOFOR = SUBSTR(TRA_RECORD,50,7)
					M.for_Dtnasc = "19" + SUBSTR(TRA_RECORD,70,2) + "/" + SUBSTR(TRA_RECORD,67,2) + "/" + SUBSTR(TRA_RECORD,64,2)	
					M.for_lunasc = ALLTRIM(SUBSTR(TRA_RECORD,72,28))
					M.FOR_PRVNASC = SUBSTR(TRA_RECORD,102,2)
					SKIP+1
				ENDIF

				M.FOR_NAZION = "ITA"
				IF SUBSTR(TRA_RECORD,50,3) <> 'Val'
					V_NAZION = SUBSTR(TRA_RECORD,50,2) 
					IF EMPTY(ALLTRIM(V_NAZION))
					   M.FOR_NAZION = 'ITA'
					ENDIF
					IF V_NAZION = 'AT'
					   M.FOR_NAZION = 'AUT'
					ENDIF
					IF V_NAZION = 'DE'
					   M.FOR_NAZION = 'GER'
					ENDIF
					IF V_NAZION = 'ES'
					   M.FOR_NAZION = 'SPA'
					ENDIF
					IF V_NAZION = 'FR'
					   M.FOR_NAZION = 'FRA'
					ENDIF
					IF V_NAZION = 'GB'
					   M.FOR_NAZION = 'ING'
					ENDIF
					IF V_NAZION = 'GR'
					   M.FOR_NAZION = 'GRE'
					ENDIF
					IF V_NAZION = 'PT'
					   M.FOR_NAZION = 'POR'
					ENDIF
					IF V_NAZION = 'US'
					   M.FOR_NAZION = 'U.S'
					ENDIF
					SKIP +1
				ENDIF
 
 				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,62,17))
				M.FOR_VALORD = VAL (A)
				A= ALLTRIM (SUBSTR(TRA_RECORD,95,13))
				M.FOR_IMPFID = VAL (A)
			 	SKIP +1
			    
			    M.FOR_LINGUA = ALLTRIM (SUBSTR(TRA_RECORD,64,3))
			    SKIP + 1
			    
			    M.FOR_VALUTA = ALLTRIM (SUBSTR(TRA_RECORD,64,3))
			    IF EMPTY(ALLTRIM(M.FOR_VALUTA))
			       M.FOR_VALUTA = 'EUR'
			    ENDIF
			    IF ALLTRIM(M.FOR_VALUTA) = '0'
			       M.FOR_VALUTA = 'EUR'
			    ENDIF
			    SKIP + 1
			    
			    M.FOR_AGE = ALLTRIM (SUBSTR(TRA_RECORD,63,4))
			    SKIP + 1
			    
			    M.FOR_CONPAG = ALLTRIM (SUBSTR(TRA_RECORD,63,3))
			    SKIP + 1
			    
                PUB_LNO = 5
			    M.FOR_ABI = ALLTRIM (SUBSTR(TRA_RECORD,63,4))
                M.FOR_ABI = TRC(PUB_LNO,ALLTRIM(FOR_ABI))
				
			    SKIP + 1
			    M.FOR_CAB = ALLTRIM (SUBSTR(TRA_RECORD,62,5))
                M.FOR_CAB = TRC(PUB_LNO,ALLTRIM(FOR_CAB))
			    SKIP + 1
			    
			    M.FOR_ABI2 = ALLTRIM (SUBSTR(TRA_RECORD,63,4))
                M.FOR_ABI2 = TRC(PUB_LNO,ALLTRIM(FOR_ABI2))
			    SKIP + 1
			    M.FOR_CAB2 = ALLTRIM (SUBSTR(TRA_RECORD,62,5))
                M.FOR_CAB2 = TRC(PUB_LNO,ALLTRIM(FOR_CAB2))
			    SKIP + 1
			    
			    M.FOR_ZONA = ALLTRIM (SUBSTR(TRA_RECORD,64,3))
			    SKIP + 1
			    M.FOR_SOTZONA = ALLTRIM (SUBSTR(TRA_RECORD,63,3))
			    SKIP + 1
			    M.FOR_MEZZO = ALLTRIM (SUBSTR(TRA_RECORD,64,3))
			    SKIP + 1
			    
			    M.FOR_LISTIN = ALLTRIM (SUBSTR(TRA_RECORD,64,3))
			    M.FOR_SC1 = ALLTRIM (SUBSTR(TRA_RECORD,78,8))
			    M.FOR_BOLLI = ALLTRIM (SUBSTR(TRA_RECORD,115,4))
			    M.FOR_SPINCA = ALLTRIM (SUBSTR(TRA_RECORD,129,4))
			   
			    XCODCAB = M.FOR_CAB
				XCODABI = M.FOR_ABI

				*!*	INIZIO A CARICARE IL CURSORE CURS_U_BAN_AN DALLA TABELLA DELLE BANCHE U_BAN_AN PER COMPLETARE L'INSERIMENTO DEI DATI IN U_CLI_AN
				SELECT CURS_U_BAN_AN	
				SET ORDER TO CODBAN
				SEEK XCODABI + XCODCAB
				IF EOF()
  			  	   M.FOR_CODABI = SPACE(05)
				   M.FOR_CODCAB = SPACE(05)
				   M.FOR_CODCIN = SPACE(02)
				ELSE
				   M.FOR_CODABI = BAN_CODABI
				   M.FOR_CODCAB = BAN_CODCAB
				   M.FOR_CODCIN = BAN_CIN
				   PUB_LNO      = 5
				   M.FOR_CODABI = TRC(PUB_LNO,ALLTRIM(M.FOR_CODABI))
				   M.FOR_CODCAB = TRC(PUB_LNO,ALLTRIM(M.FOR_CODCAB))
				   PUB_LNO      = 2
				   M.FOR_CODCIN = TRC(PUB_LNO,ALLTRIM(M.FOR_CODCIN))
				ENDIF
				M.FOR_CODCHE = ' '
				M.FOR_NUMCC  = SPACE(10)
                m.FOR_cdiban = SUBSTR(m.FOR_nazion,1,2) + m.FOR_codche + m.FOR_codcin + m.FOR_codabi + m.FOR_codcab + m.FOR_numcc
				XCODBAN = BAN_CODBAN
				XCODCIN = BAN_CIN

				SELECT TRANSITO
				M.FOR_BAE = XCODBAN

                M.FOR_BDAL   = "0108"
                M.FOR_BAL    = "3108"
                M.FOR_GG1    = "1009"
                M.FOR_B2DAL  = "2012"
                M.FOR_B2AL   = "3112"
                M.FOR_GG2    = "1001"
                M.FOR_TIPFAT = "FDV"
                M.FOR_FLGTRA = .T.
                M.FOR_CODIVA = '20'

 				M.FOR_DATNEW = RIBALTA2(DTOC(DATE()))
				M.FOR_DATINS = RIBALTA2(DTOC(DATE()))
 
		  		 SELECT curs_u_FOR_an				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
		  		 APPEND BLANK
		 	  	 GATHER MEMVAR MEMO 				&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
												   
		   
		   		_CTR = _CTR +1
		   		WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

		   		SELECT TRANSITO      
		   		SKIP +1
		  ELSE
		        SELECT TRANSITO
		        _appo = SUBSTR(TRA_RECORD,1,6)

		  ENDIF      
		ENDDO


SELECT curs_u_FOR_an
GO TOP
***BROWSE NORMAL


****** AGGIORNA TABELLA U_FOR_AN SQL

		IF !ExecRW('','U_FOR_AN','I','','curs_u_FOR_an')
		   return(.f.)
		ENDIF
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

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

x_soci = "cli_codsoc = '" + M.CLI_CODSOC + "'"
x_codi = "cli_codcli = '" + M.CLI_CODCLI + "'"
x_cond = x_soci + " and " + x_codi
cSql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecRW(cSql,"u_cli_an","R")
   return
ENDIF
SELECT u_cli_an
IF EOF()
   m.id_unique = ""
   APPEND BLANK
ENDIF
M.CLI_RAGSOC = UPPER(M.CLI_RAGSOC)
M.CLI_RAGSOC = APITOSPA(M.CLI_RAGSOC)
M.CLI_INDIR  = UPPER(M.CLI_INDIR)
M.CLI_INDIR  = APITOSPA(M.CLI_INDIR)
M.CLI_LOCALI = UPPER(M.CLI_LOCALI)
M.CLI_LOCALI = APITOSPA(M.CLI_LOCALI)
M.CLI_PROVIN = UPPER(M.CLI_PROVIN)
M.CLI_PROVIN = APITOSPA(M.CLI_PROVIN)
M.CLI_CODFIS = UPPER(M.CLI_CODFIS)
M.CLI_CODFIS = APITOSPA(M.CLI_CODFIS)

REPLACE CLI_CODSOC WITH M.CLI_CODSOC
REPLACE CLI_CODCLI WITH M.CLI_CODCLI
REPLACE CLI_RAGSOC WITH M.CLI_RAGSOC
REPLACE CLI_INDIR  WITH M.CLI_INDIR
REPLACE CLI_CAP    WITH M.CLI_CAP
REPLACE CLI_LOCALI WITH M.CLI_LOCALI
REPLACE CLI_PROVIN WITH M.CLI_PROVIN
REPLACE CLI_PARIVA WITH M.CLI_PARIVA
REPLACE CLI_CODFIS WITH M.CLI_CODFIS
REPLACE CLI_AGE    WITH M.CLI_AGE
REPLACE CLI_SC1    WITH M.CLI_SC1
REPLACE CLI_SC2    WITH M.CLI_SC2
REPLACE CLI_TELEFO WITH M.CLI_TELEFO
REPLACE CLI_TELEX  WITH M.CLI_TELEX
REPLACE CLI_FAX    WITH M.CLI_FAX
REPLACE CLI_VALUTA WITH PUB_VALU
REPLACE CLI_NAZION WITH PUB_NAZI
REPLACE CLI_DATNEW WITH RIBALTA2(DTOC(DATE()))
REPLACE CLI_DATINS WITH RIBALTA2(DTOC(DATE()))
REPLACE CLI_CONPAG WITH PUB_CPA
REPLACE CLI_CODIVA WITH PUB_IVA
REPLACE CLI_BDAL   WITH "0108"
REPLACE CLI_BAL    WITH "3108"
REPLACE CLI_GG1    WITH "1009"
REPLACE CLI_B2DAL  WITH "2012"
REPLACE CLI_B2AL   WITH "3112"
REPLACE CLI_GG2    WITH "1001"
REPLACE CLI_TIPFAT WITH "FDV"
REPLACE CLI_FLGTRA WITH .T.

IF !ExecRW(cSql,"u_cli_an","W")
   return
ENDIF



_CTR = _CTR +1
WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

RETURN