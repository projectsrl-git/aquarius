*************************************************************************************************
*							CONVERSIONE NAZIONI			 										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Ottobre 2021 : Assolo 				 														*
*************************************************************************************************




*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"anagrafica nazioni ?",292,"ATTENZIONE")
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
_V_NOME_TABELLA_INPUT_STATI = 'Stati'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_STATI 							&& STATI/NAZIONI
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON Codicestato	TAG I_CODICE 
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


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA NAZIONI" NOWAIT


cSql = "delete from PARA where CODICE LIKE 'STA%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR,_COMUNITA_ERUROPEA_GENCE,_COMUNITA_ERUROPEA_GENEX
PUBLIC __DATINS,_CTR,_COMUNITA_ERUROPEA_GENCE,_COMUNITA_ERUROPEA_GENEX
__DATINS = DTOC(DATE())
_CTR = 0
_COMUNITA_ERUROPEA_GENCE  = ''
_COMUNITA_ERUROPEA_GENEX  = ''


*!*	CAMPI DA CONVERTIRE
*!*	Codicestato
*!*	Descrizione
*!*	Denominazione ufficiale
*!*	Valuta
*!*	UE
*!*	CodiceISO3
*!*	CodiceISTAT
*!*	CodiceAgenziaEntrate
*!*	FlagBL


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


	_NAZIONE_ = ALLTRIM(CONV_CLEAR(M.Codicestato))
	
	
*!*		IF SUBSTR(_NAZIONE_,1,2) = 'IT' 
*!*			SELECT CU_INPUT
*!*			SKIP +1
*!*			LOOP
*!*		ENDIF 	
	
	
	
	IF SUBSTR(_NAZIONE_,1,2) <> 'IT'                                                               

	    DO CASE 
	    
	    	CASE M.UE = 'S'
				_COMUNITA_ERUROPEA_GENCE  = _COMUNITA_ERUROPEA_GENCE +_NAZIONE_ + '.'		&& STATO CEE
	    	CASE M.UE = 'N'
	 			_COMUNITA_ERUROPEA_GENEX  = _COMUNITA_ERUROPEA_GENEX +_NAZIONE_ + '.'		&& STATO EXTRA CEE    	
	    ENDCASE 

    ENDIF

	M.CODICE 	= "STA"+CONV_CLEAR(M.Codicestato)
   	M.DESCRI  	= APITOSPA(CONV_CLEAR(M.Descrizione))
	M.DESIVA 	= "STATOCEE:"
    M.DTIPOMOV  = CONV_CLEAR(M.CodiceAgenziaEntrate)
	M.codpgo 	= CONV_CLEAR(M.CodiceISTAT)
   	M.LIBERA	= CONV_CLEAR(M.Codicestato)

	IF ALLTRIM(M.DESCRI)  	= "Italia"
		*M.CODICE 	= "STAITA"			&& FORZA ITA
		M.LIBERA	= "IT"
	ENDIF

 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT CU_INPUT
	SKIP

ENDDO

*!*	** INSERISCE LA NAZIONE ITA

*!*	M.CODICE 	= "STAITA"
*!*	M.DESCRI  	= "Italia"
*!*	M.DESIVA 	= "STATOCEE:"
*!*	M.LIBERA	= "IT"
*!*	M.DTIPOMOV  = ""
*!*	M.codpgo 	= ""
*!*	M.LIBERA	= ""

*!*	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
*!*	APPEND BLANK
*!*	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF
	 
 
****** AGGIORNA PARAMETRO GENCE
_SEEK = "GENCE"
TEXT TO cSql NOSHOW
SELECT *
	FROM PARA
	where CODICE = ?_SEEK
ENDTEXT
IF !ExecRW(cSql,"PARA","R")
  return(.f.)
ENDIF
IF !EOF()
    REPLACE NOTE WITH _COMUNITA_ERUROPEA_GENCE  
	IF !ExecRW("","PARA","W")
	   return(.f.)
	ENDIF
ENDIF

****** AGGIORNA PARAMETRO GENEX
_SEEK = "GENEX"
TEXT TO cSql NOSHOW
SELECT *
	FROM PARA
	where CODICE = ?_SEEK
ENDTEXT
IF !ExecRW(cSql,"PARA","R")
  return(.f.)
ENDIF
IF !EOF()
    REPLACE NOTE WITH _COMUNITA_ERUROPEA_GENEX 
	IF !ExecRW("","PARA","W")
	   return(.f.)
	ENDIF
ENDIF




	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 