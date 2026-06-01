*************************************************************************************************
*							CONVERSIONE ANAGRAFICA COMUNI										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Ottobre 2021 : Assolo					 													*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica comuni ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
   RETURN
ENDIF


SET DEFAULT TO &PUB_DIR

RELEASE _V_DBDA,_V_DBAL
PUBLIC _V_DBDA,_V_DBAL

** INIZIO DA INSERIRE/MODIFICARE ***************************************
__connectString = PUB_NOMEDB
__connectString_DATABASE = SUBSTR(__connectString,AT("DATABASE=",__connectString),AT(';',SUBSTR(__connectString,AT("DATABASE=",__connectString)))-1)
_V_DBAL = STRTRAN(__connectString_DATABASE,"DATABASE=","")
__config_name = "conversioni_" + _V_DBAL + ".cfg"
_V_DBDA =legge_config(__config_name,"NOME_DB_ASSOLO")						&& RICERCA VARIABILE
__NOME_DATA_BASE__ = _V_DBDA
*_V_DBDA =legge_config("conversioni.cfg","NOME_DB_ASSOLO")					&& RICERCA VARIABILE
*_V_DBAL =legge_config("conversioni.cfg","NOME_DB_AQUARIUS")				&& RICERCA VARIABILE
** FINE DA INSERIRE/MODIFICARE *****************************************




WAIT WINDOWS "Verifiche connessioni DataBases in corso..." NOWAIT

*** CONTROLLO DB DI ORIGINE E Alternativo
IF EMPTY(ALLTRIM(_V_DBDA))
   MESSAGEBOX("Impossibile effettuare il trasferimento" + CHR(13) + CHR(13) +;
              "DB Locale non specificato",16,"Attenzione")
   RETURN .F.
ENDIF

IF !SwicthDBConnection(ALLTRIM(_V_DBDA))
   MESSAGEBOX("DataBase Locale inesistente",16,"Attenzione")
   IF !SetHomeDB()
      RETURN(.f.)
   ENDIF
   RETURN .F.
ENDIF


**==> CARICAMENTO DATI DA CONVERTIRE
_V_NOME_TABELLA_INPUT_COMUNI = 'DatiComuniIT'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_COMUNI 							&& COMUNI
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON Cap	TAG I_CODICE 
SET ORDER TO I_CODICE 



IF EMPTY(ALLTRIM(_V_DBAL))
   MESSAGEBOX("Impossibile effettuare il trasferimento" + CHR(13) + CHR(13) +;
              "DB Alternativo non specificato",16,"Attenzione")
   RETURN .F.
ENDIF

IF !SwicthDBConnection(ALLTRIM(_V_DBAL))
   MESSAGEBOX("DataBase Alternativo inesistente",16,"Attenzione")
   IF !SetHomeDB()
      RETURN(.f.)
   ENDIF
   RETURN .F.
ENDIF

IF !SetHomeDB()
   RETURN(.f.)
ENDIF

IF ALLTRIM(_V_DBDA) == ALLTRIM(_V_DBAL)
   MESSAGEBOX("Impossibile effettuare il trasferimento" + CHR(13) + CHR(13) +;
              "DB Locale e DB Alternativo non devono essere corrispondenti",16,"Attenzione")
   RETURN .F.
ENDIF





****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from PROVINCE where 1=0","curs_PROVINCE")
   return
ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA PROVINCE 


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHI COMUNI" NOWAIT
cSql = "delete from COMUNI"
IF !ExecCommand(cSql,"COMUNI")
   return(.f.)
ENDIF

WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIE REGIONI" NOWAIT
cSql = "delete from REGIONI"
IF !ExecCommand(cSql,"REGIONI")
   return(.f.)
ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0


*!*	DATI DA CONVERTIRE
*!*	ID
*!*	Istat
*!*	Comune
*!*	Provincia
*!*	Regione
*!*	Prefisso
*!*	CAP
*!*	CodFisco
*!*	Abitanti
*!*	Link


__CODICE_REGIONE = 0
__COD_REGIONE    = 0
***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT CU_INPUT
GO TOP 


DO WHILE !EOF()

    IF DELETED()
       SELECT CU_INPUT   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    SCATTER MEMVAR MEMO
    
*!*	#####################################################



	M.CAP			= CONV_CLEAR(M.CAP)
	__CAP           = M.CAP
	M.COMUNE		= CONV_CLEAR(M.Comune)
	__COMUNE        = ALLTRIM(M.COMUNE)
	*M.PROVINCIA		= CONV_CLEAR(M.Provincia)
	M.COD_PROVINCIA	= CONV_CLEAR(M.Provincia)  && ERASMO - 23/03/2023
	M.REGIONE		= CONV_CLEAR(M.Regione)
	M.COD_FIS		= CONV_CLEAR(M.CodFisco)
		
*!*		IF UPPER(ALLTRIM(M.COMUNE)) = "PAVIA"
*!*			SET STEP ON
*!*		ENDIF

	x_cond = "regione = '" + M.REGIONE + "'"
	cSql = "select * from REGIONI where " + x_cond + " order by regione "
	IF !ExecCommand(cSql,"REGIONI")
	   RETURN .F.
	ENDIF

 	SELECT REGIONI 
	GO TOP
	IF EOF()
		APPEND BLANK
  		__CODICE_REGIONE = __CODICE_REGIONE +1
  		__COD_REGIONE	 = __CODICE_REGIONE 
		REPLACE CODICE		WITH __CODICE_REGIONE
		REPLACE REGIONE 	WITH M.REGIONE
	ELSE
		__COD_REGIONE	= CODICE						&& ATTRIBUISCO IL CODICE DELLA REGIONE IN PRECEDENZA INSERITO
	ENDIF
	IF !ExecRW('','REGIONI','I','','REGIONI')
	  return(.f.)
	ENDIF	



	*x_cond = "sigla = '" + M.PROVINCIA + "'"
	x_cond = "sigla = '" + M.COD_PROVINCIA + "'"  && ERASMO - 23/03/2023
	cSql = "select * from PROVINCE where " + x_cond + " order by sigla"
	IF !ExecCommand(cSql,"PROVINCE")
	   RETURN .F.
	ENDIF

 	SELECT PROVINCE 
	GO TOP
	IF !EOF()
		REPLACE REGIONE 	WITH __COD_REGIONE			&& RIPORTO IL CODICE REGIONE SULLA PROVINCIA
	ENDIF
	IF !ExecRW('','PROVINCE','I','','PROVINCE')
	  return(.f.)
	ENDIF	


	  
	x_cond = "cap = '" + __CAP + "'"
	cSql = "select * from COMUNI where " + x_cond + " order by cap"
	IF !ExecCommand(cSql,"COMUNI")
	   RETURN .F.
	ENDIF

	SELECT COMUNI 
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
	
	REPLACE CAP			WITH __CAP 
	REPLACE COMUNE      WITH __COMUNE
	*REPLACE PROVINCIA 	WITH M.PROVINCIA
	REPLACE PROVINCIA 	WITH M.COD_PROVINCIA  && ERASMO - 23/03/2023
	REPLACE REGIONE 	WITH __COD_REGIONE
	REPLACE COD_FIS		WITH M.COD_FIS
	
	IF !ExecRW('','COMUNI','I','','COMUNI')
	  return(.f.)
	ENDIF	


    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT CU_INPUT
	SKIP

ENDDO

	 
****** AGGIORNA TABELLA PROVINCE SQL
IF !ExecRW('','PROVINCE','I','','curs_PROVINCE')
   return(.f.)
ENDIF
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 