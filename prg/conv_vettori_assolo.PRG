*************************************************************************************************
*							    CONVERSIONE CODICI 	VETTORI    		  							*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Settembre 2021 : Assolo 				 													*
*************************************************************************************************


SET DEFAULT TO &PUB_DIR



RIT = MESSAGEBOX("Conversione tabella vettori ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF



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
_V_NOME_TABELLA_INPUT_VETTORI = 'VETTORI'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_VETTORI 		&& VETTORI
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON CODICEVETT 	TAG I_CODICE 
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


*** CANCELLAZIONE DEI RECORD DELLA TABELLA VETTORI SQL 


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA VETTORI" NOWAIT
cSql = "delete from PARA where CODICE LIKE 'VET%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



*!*	CAMPI DA CONVERTIRE					
*!*	CodiceVett
*!*	CodiceAnag
*!*	DescVett
*!*	NumIscrizione


***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT CU_INPUT
GO TOP 


DO WHILE !EOF()


    SCATTER MEMVAR MEMO 
 
 	M.CODICE1 	=ALLTRIM(CONV_CLEAR(APITOSPA(ALLTRIM(CodiceVett)))) 
	M.CODICE    ="VET"+M.CODICE1
    M.DESCRI 	=ALLTRIM(APITOSPA(ALLTRIM(m.DescVett)))	
	M.DESCRI    =CONV_CLEAR(APITOSPA(ALLTRIM(M.DESCRI))) 
	
   	M.LIBER		=CONV_CLEAR(M.NumIscrizione) 
   	M.LIBERA	=APITOSPA(ALLTRIM(M.LIBER)) 
*!*	   	M.NOT		=CONV_CLEAR(M.CodiceAnag) 
*!*	   	M.NOTE		=APITOSPA(ALLTRIM(M.NOT)) 
	**=> ERASMO - INIZIO 06/04/2022
   	M.CODPGO	=APITOSPA(ALLTRIM(CONV_CLEAR(M.CodiceAnag)))
	**=> ERASMO - FINE 06/04/2022

*!*		cSql = "select * from PARA where CODICE ='VET"+ALLTRIM(M.CODICE1)+"'"
*!*		IF !ExecCommand(cSql,"___temp_vett")
*!*		   RETURN .F.
*!*		ENDIF
*!*		SELECT ___temp_vett
*!*		GO TOP
*!*		IF EOF()
*!*		ELSE
*!*	       SELECT CU_INPUT   && scarto il record 
*!*	       SKIP +1
*!*	       LOOP
*!*	    ENDIF       



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


 