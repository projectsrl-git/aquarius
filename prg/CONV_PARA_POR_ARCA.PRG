*************************************************************************************************
*					            		CONVERSIONE PORTO										*
*							 																	*
*	by Sergio Piaggi Project S.r.l.																*
*	Luglio 2022: Arca				 															*
*************************************************************************************************


*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"della tabella Porto ?",292,"ATTENZIONE")
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
_V_NOME_TABELLA_INPUT_PORTO = 'DOPorto'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_PORTO 							&& PORTO
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON Cd_DOPorto	TAG I_CODICE 
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

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA NAZIONI SQL 


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA PORTO" NOWAIT


cSql = "delete from PARA where CODICE LIKE 'POR%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



*!*	CAMPI DA CONVERTIRE
*!*	Id_DOPorto
*!*	Cd_DOPorto
*!*	Descrizione
*!*	Cd_IntraConsegna
*!*	UserIns
*!*	UserUpd
*!*	TimeIns
*!*	TimeUpd
*!*	Ts
*!*	Cd_ASW_TipologiaConsegna


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

	M._PORTOX= ALLTRIM(APITOSPA(CONV_CLEAR(M.Cd_DOPorto)))
	LEN_PORTO  = LEN(_PORTOX)
	IF LEN_PORTO  > 3
		M._PORTO_ = SUBSTR(M._PORTOX,LEN_PORTO - 2,3)
	ELSE
		M._PORTO_ = SUBSTR(M._PORTOX,1,3)
	ENDIF

	M.CODICE 	= "POR"+M._PORTO_
   	M.DESCRI  	= APITOSPA(CONV_CLEAR(M.Descrizione))
   	M.LIBERA	= ""

 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT CU_INPUT
	SKIP

ENDDO

	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 