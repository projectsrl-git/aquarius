*************************************************************************************************
*							CONVERSIONE ANAGRAFICA PROVINCE										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Ottobre 2021 : Assolo 					 													*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dell'anagrafica province ?",292,"ATTENZIONE")
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
_V_NOME_TABELLA_INPUT_PROVINCE = 'PROVINCIE'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_PROVINCE 							&& PROVINCE
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON Codice	TAG I_CODICE 
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


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIE PROVINCE" NOWAIT
cSql = "delete from PROVINCE"
IF !ExecCommand(cSql,"PROVINCE")
   return(.f.)
ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0




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



	M.SIGLA 		= CONV_CLEAR(M.Codice)
	M.PROVINCIA 	= CONV_CLEAR(M.Provincia)
	M.PRV_COSTOT	= 0
		
	  
	x_cond = "sigla = '" + M.SIGLA + "'"
	cSql = "select * from PROVINCE where " + x_cond + " order by sigla"


	IF !ExecCommand(cSql,"PROVINCE")
	   RETURN .F.
	ENDIF

	SELECT PROVINCE 
	GO TOP
	IF EOF()
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


 