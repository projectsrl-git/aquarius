*************************************************************************************************
*							CONVERSIONE ANAGRAFICA AGENTI										*
*							 																	*
*	by Fabio Luconi per Project S.r.l.															*
*	18 Febbraio 2004				 																*
*************************************************************************************************

*** conferma utente

		RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica agenti	 ?",292,"ATTENZIONE")
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

		IF !ExecCommand("select * from U_AGE_AN where 1=0","curs_u_AGE_an")
		   return
		ENDIF

		IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
		   return
		ENDIF


		WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA AGENTI" NOWAIT


*** CANCELLAZIONE DEI RECORD DELLA TABELLA U_CLI_AN SQL

		cSql = "delete from U_AGE_AN where 1=1"
		IF !ExecCommand(cSql,"U_AGE_AN")
		   return(.f.)
		ENDIF

		cSql = "delete from PARA where SUBSTRING(CODICE,1,3) = 'AGE'"
		IF !ExecCommand(cSql,"PARA")
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
		gcTable = GETFILE('', 'Seleziona file agenti da convertire', 'Converti',0)
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
		DELETE FOR SUBSTR(TRA_RECORD,1,13) = "Ag. Indirizzo"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,5,9) = "Cap/Citta"  ALL
		GO TOP
		DELETE FOR SUBSTR(TRA_RECORD,1,14) = "Cod Nominativo"  ALL
		GO TOP
		DELETE FOR empty(TRA_RECORD)   ALL
		GO TOP
		
		

***** ELABORA IL CURSORE transito PER DARE A TUTTE LE RIGHE L'ABBINAMENTO CON IL RELATIVO CODICE CLIENTE
_PROGRE=""
DO WHILE !EOF()
	IF EMPTY(SUBSTR(TRA_RECORD,1,3))
	   REPLACE TRA_RECORD WITH _PROGRE+SUBSTR(TRA_RECORD,4,LEN(TRA_RECORD))
	   SKIP + 1 
	   LOOP
	ELSE
		_PROGRE = SUBSTR(TRA_RECORD,1,3) 
		SKIP + 1 
	   LOOP 
	ENDIF
ENDDO

SELECT TRANSITO
*!*			GO TOP
*!*			BROWSE
*!*			RETURN


***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP


		SELECT TRANSITO
		GO TOP
		_appo = SUBSTR(TRA_RECORD,1,3) && VALORIZZO UNA VARIABILE DI APPOGGIO UGUALE AL PRIMO CODICE DEL CLIENTE
		

		
		DO WHILE .T.

		   IF EOF()
		      EXIT
		   ENDIF

		

		******** ASSEGNAZIONE VARIABILI DEL FILE DI TESTO CHE E' CONTENUTO NEL CURSORE TRANSITO

		   SELECT TRANSITO
		   	            
           IF  SUBSTR(TRA_RECORD,1,3) = _appo 
           
           		M.AGE_CODICE = _APPO
 				M.AGE_RAGSOC = ALLTRIM (SUBSTR(TRA_RECORD,5,34))
   		        M.AGE_RAGSOC = UPPER(M.AGE_RAGSOC)
                M.AGE_RAGSOC = APITOSPA(M.AGE_RAGSOC)
 				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,39,12))
				M.AGE_IMPPRO = VAL (A)
				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,54,13))
				M.AGE_BADG1 = VAL (A)
				_CODFIS=0
 				_CDFIS=LEN(ALLTRIM(SUBSTR(TRA_RECORD,69,16)))
 				IF _CDFIS = 16
 					M.AGE_CF = ALLTRIM(SUBSTR(TRA_RECORD,69,16))
 				ELSE
 					M.AGE_PI =ALLTRIM(SUBSTR(TRA_RECORD,69,16))
 				ENDIF
 				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,103,5))
				M.AGE_SCAPROV0 = VAL (A)
				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,109,5))
				M.AGE_SCAPROV1 = VAL (A)
				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,115,5))
				M.AGE_SCAPROV2 = VAL (A)
				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,121,5))
				M.AGE_SCAPROV3 = VAL (A)
				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,127,5))
				M.AGE_SCAPROV4 = VAL (A)
				SKIP+1
				M.AGE_INDIRI=""
				IF !EMPTY(ALLTRIM(SUBSTR(TRA_RECORD,5,29)))		
		   			M.AGE_INDIRI = ALLTRIM (SUBSTR(TRA_RECORD,5,29))
   		            M.AGE_INDIRI = UPPER(M.AGE_INDIRI)
                    M.AGE_INDIRI = APITOSPA(M.AGE_INDIRI)
		   		ENDIF
		   		A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,39,12))
				M.AGE_PROVMAT = VAL (A)
				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,54,13))
				M.AGE_BADG2 = VAL (A)
				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,103,5))
				M.AGE_SCAPROV5 = VAL (A)
				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,109,5))
				M.AGE_SCAPROV6 = VAL (A)
				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,115,5))
				M.AGE_SCAPROV7 = VAL (A)
				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,121,5))
				M.AGE_SCAPROV8 = VAL (A)
				A=""
				A=	ALLTRIM (SUBSTR(TRA_RECORD,127,5))
				M.AGE_SCAPROV9 = VAL (A)
				SKIP+1
				
				IF SUBSTR(TRA_RECORD,1,3)= _APPO
					M.AGE_CAP = ALLTRIM (SUBSTR(TRA_RECORD,5,5))
					M.AGE_LOCALI = ALLTRIM (SUBSTR(TRA_RECORD,11,20))
   		            M.AGE_LOCALI = UPPER(M.AGE_LOCALI)
                    M.AGE_LOCALI = APITOSPA(M.AGE_LOCALI)
					M.AGE_PROVIN = ALLTRIM (SUBSTR(TRA_RECORD,32,2))
   		            M.AGE_PROVIN = UPPER(M.AGE_PROVIN)
                    M.AGE_PROVIN = APITOSPA(M.AGE_PROVIN)
	                _seek      = "'"+ALLTRIM(M.AGE_LOCALI)+"'"
	                cSql 	   = "SELECT * FROM comuni where comune = " + _seek + " order by comune"
 		   	        IF !ExecCommand(cSql,'COMUNI')
			            return(.f.)
			        ENDIF
  	                SELECT COMUNI
  		            GO TOP
                    IF EOF()
                    ELSE
   				       M.AGE_LOCALI = UPPER(COMUNE)
			     	   M.AGE_PROVIN = UPPER(PROVINCIA)
				       M.AGE_CAP    = CAP
				    ENDIF
				    SELECT TRANSITO				
					SKIP + 1
				ENDIF
 
                M.CODICE = 'AGE' + M.AGE_CODICE
                M.DESCRI = M.AGE_RAGSOC
 
		  		 SELECT curs_u_AGE_an				&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
		  		 APPEND BLANK
		 	  	 GATHER MEMVAR MEMO 				&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
												   

		  		 SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
		  		 APPEND BLANK
		 	  	 GATHER MEMVAR MEMO 				&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
		   
		   		_CTR = _CTR +1
		   		WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

		   		SELECT TRANSITO      
		   	
		  ELSE
		        SELECT TRANSITO
		        _appo = SUBSTR(TRA_RECORD,1,3)

		  ENDIF      
		ENDDO


SELECT curs_u_AGE_an
GO TOP
***BROWSE NORMAL


****** AGGIORNA TABELLA U_AGE_AN SQL

		IF !ExecRW('','U_AGE_AN','I','','curs_u_AGE_an')
		   return(.f.)
		ENDIF

		IF !ExecRW('','PARA','I','','curs_PARA')
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