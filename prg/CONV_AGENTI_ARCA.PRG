*************************************************************************************************
*							    CONVERSIONE CODICI AGENTI    		  							*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Luglio 2022 : Arca		 				 													*
*************************************************************************************************


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
_V_NOME_TABELLA_INPUT_AGENTI = 'Agente'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_AGENTI 							&& AGENTI
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON Cd_Agente	TAG I_CODICE 
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

IF !ExecCommand("select * from U_AGE_AN where 1=0","curs_U_AGE_AN")
   return
ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA PORTO SQL 


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA AGENTI" NOWAIT
cSql = "delete from PARA where CODICE LIKE 'AGE%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF



cSql   = "delete from U_AGE_AN "  
IF !ExecCommand(cSql,"U_AGE_AN")
   return(.f.)
ENDIF


*!*	CAMPI DA CONVERTIRE
*!*	Id_Agente
*!*	Cd_Agente
*!*	Cd_CF_For
*!*	Descrizione
*!*	Sconto
*!*	Provvigione
*!*	Email
*!*	UserIns
*!*	UserUpd
*!*	TimeIns
*!*	TimeUpd
*!*	Ts
*!*	NoteXML
*!*	Attributi
*!*	Note_Agente



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0


***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT CU_INPUT
GO TOP 
APPEND BLANK 
REPLACE Cd_Agente WITH '000'
GO TOP 

DO WHILE !EOF()

     IF DELETED()
       SELECT CU_INPUT  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

  
    SCATTER MEMVAR MEMO 
  
     
	M.CODICE1   =ALLTRIM(CONV_CLEAR(ALLTRIM(M.Cd_Agente))) 
	
	_LEN_AGE    =LEN(M.CODICE1)
	IF _LEN_AGE = 4
		M.CODICE1 = SUBSTR(M.CODICE1,2,3)
	ENDIF
	IF _LEN_AGE = 5
		M.CODICE1 = SUBSTR(M.CODICE1,3,3)
	ENDIF
	IF _LEN_AGE = 6
		M.CODICE1 = SUBSTR(M.CODICE1,4,3)
	ENDIF
	IF _LEN_AGE = 7
		M.CODICE1 = SUBSTR(M.CODICE1,5,3)
	ENDIF
	IF _LEN_AGE = 8
		M.CODICE1 = SUBSTR(M.CODICE1,6,3)
	ENDIF
		
		
	M.CODICE    ="AGE"+M.CODICE1
    M.DESCRI 	=ALLTRIM(CONV_CLEAR(ALLTRIM(M.Descrizione))) 
   	M.LIBERA	=""
   	


    SELECT curs_U_AGE_AN
    APPEND BLANK 
    REPLACE AGE_CODSOC    WITH PUB_CODSOC
    REPLACE AGE_CODICE    WITH M.CODICE1  
    REPLACE AGE_RAGSOC    WITH M.DESCRI   
    REPLACE AGE_CODIVA    WITH "22 "
    REPLACE AGE_VALUTA    WITH "EUR"
    REPLACE AGE_DATINS    WITH __DATINS 
    REPLACE AGE_PROVVI    WITH VAL(M.Provvigione)


	cSql = "select * from PARA where CODICE ='AGE"+ALLTRIM(M.CODICE1)+"'"
	IF !ExecCommand(cSql,"___temp_age")
	   RETURN .F.
	ENDIF
	SELECT ___temp_age
	GO TOP
	IF EOF()
	ELSE
       SELECT CU_INPUT   && scarto il record se già esiste
       SKIP +1
       LOOP
    ENDIF       



	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT CU_INPUT
	SKIP

ENDDO



****** AGGIORNA TABELLA U_AGE_AN SQL
IF !ExecRW('','U_AGE_AN','I','','curs_U_AGE_AN')
   return(.f.)
ENDIF
	 
	 
	 
	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF
	 
	 
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 