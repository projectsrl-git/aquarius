*************************************************************************************************
*							CONVERSIONE CODICI IVA CONTABILI									*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	NOVEMBRE 2021 : Assolo	 				 													*
*************************************************************************************************

SET DEFAULT TO &PUB_DIR

RIT = MESSAGEBOX("Conversione tabella CODICI IVA CONTABILI ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")

IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


** VERIFICA SE E' USATO O MENO IL SISTEMA CONTABILE ***************************************
__connectString = PUB_NOMEDB
__connectString_DATABASE = SUBSTR(__connectString,AT("DATABASE=",__connectString),AT(';',SUBSTR(__connectString,AT("DATABASE=",__connectString)))-1)
_V_DBAL = STRTRAN(__connectString_DATABASE,"DATABASE=","")
__config_name = "conversioni_" + _V_DBAL + ".cfg"
_VERIFICA_SISTEMA_CONTABILE =legge_config(__config_name,"GESTIONE_CONTABILITA")						&& VERIFICA SE E' USATO O MENO IL SISTEMA CONTABILE 

IF _VERIFICA_SISTEMA_CONTABILE = "SI"
ELSE
   MESSAGEBOX("PER QUESTA INSTALLAZIONE NON E' PREVISTO NESSUN SISTEMA CONTABILE"+CHR(13)+"NON E' POSSIBILE CONVERTIRE LA TABELLA",48,"Informazione")
   RETURN
ENDIF
** VERIFICA SE E' USATO O MENO IL SISTEMA CONTABILE ***************************************


RELEASE _V_DBDA,_V_DBAL
PUBLIC _V_DBDA,_V_DBAL

** INIZIO DA INSERIRE/MODIFICARE ***************************************
__connectString = PUB_NOMEDB
__connectString_DATABASE = SUBSTR(__connectString,AT("DATABASE=",__connectString),AT(';',SUBSTR(__connectString,AT("DATABASE=",__connectString)))-1)
_V_DBAL = STRTRAN(__connectString_DATABASE,"DATABASE=","")
__config_name = "conversioni_" + _V_DBAL + ".cfg"
_V_DBDA =legge_config(__config_name,"NOME_DB_EUROCONT")						&& RICERCA VARIABILE
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
_V_NOME_TABELLA_INPUT_ALIQUOTE_IVA = 'AliquoteIVA'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_ALIQUOTE_IVA 						&& ALIQUOTE IVA CONTABILI
IF !ExecCommand(cSql,"CU_INPUT_ALIQIVA_CONTAB")
  return(.f.)
ENDIF
SELECT CU_INPUT_ALIQIVA_CONTAB
INDEX ON CodiceAliquota	TAG I_CODICE 
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



*!*	CAMPI DA CONVERTIRE
*!*	TABELLA ALIQUOTE IVA CONTABILI
*!*	CodiceAliquota
*!*	Descrizione
*!*	PercentualeIVA
*!*	PercentualeIndetraibile
*!*	CodicePCIVA
*!*	CodicePCindetraibile
*!*	TipoLibroIVA
*!*	FlagScorporo
*!*	FlagProrata
*!*	FlagVentilazione
*!*	ExContoIVA
*!*	TipoIVA
*!*	Description
*!*	DichiarazioneIva
*!*	AllegatiCliFor
*!*	AnnoPrec
*!*	ImpEseNonimp
*!*	Natura
*!*	VersamentiAutoUE

*!*	TABELLA CNT32_AliquoteIVA
*!*	CodicaAliquota
*!*	Descrizione
*!*	ContoIVA
*!*	ExContoIVA



*!*	****** DEFINIZIONE DEI CURSORI STP

*!*	IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
*!*	   return
*!*	ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA IVA SQL 


*!*	WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA IVA" NOWAIT
*!*	cSql = "delete from PARA where CODICE LIKE 'IVA%' "
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF


	 
******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0


***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT CU_INPUT_ALIQIVA_CONTAB
GO TOP 

DO WHILE !EOF()

    SCATTER MEMVAR MEMO

 
	M.CODICE1 	=CONV_CLEAR(M.CodiceAliquota)	
	M.CODICE1   =APITOSPA(ALLTRIM(M.CODICE1)) 	
	M.CODICE2   =CONVERTE_CODICE_IVA_ASSOLO(M.CODICE1)
	M.CODICE    ="IVA"+M.CODICE2
    M.DESCRI 	=CONV_CLEAR(ALLTRIM(M.Descrizione))
	M.DESCRI    =APITOSPA(ALLTRIM(M.DESCRI)) 
	
    _CONTO_CLI = "1414002" 
    _CONTO_FOR = "1414001" 
    
	**=> ERASMO - INIZIO 12/01/2024
	*** CONTROLLO EVENTUALE INSERIMENTO DOPPIONI, FACENDO PREVALERE L'INSERIMENTO ATTUALE
	IF !ExecCommand("DELETE from PARA where CODICE = '" + ALLTRIM(M.CODICE) + "'","DEL_PARA")
	   return
	ENDIF
	
	SELECT CU_INPUT_ALIQIVA_CONTAB
	
	M.NOTE = "## CONVERTITO DA DB EUROCNT ##"
	**=> ERASMO - FINE 12/01/2024
    
*campo libera  	
*D22  1414002                1414001                                                                I        100                                                                                                                                               
*21S  1414002                1414001                                                                I         60                                                                                                                                        
*22   1414002                1414001                                                                                                                                                                                                                     
*021  2092201                1011101                                                                I         40                                                                                         
*123456789012345678901234567890
*IND.POS 72 
*PER.IND 11   
    


    ___IVPERIVA 	= ALLTRIM(STR(M.PercentualeIVA,3,0))
    LEN_CODICE2 	=LEN(___IVPERIVA)
    M.CODICE2X  	=___IVPERIVA+REPLICATE(" ",(5-LEN_CODICE2)) 
    M.LIBERA    	=M.CODICE2X
    

	_CONTO_CLI	    =CONVERTE_CODICE_CONTO_CONTABILE_ASSOLO(M.CodicePCIVA)
	_CONTO_FOR	    =CONVERTE_CODICE_CONTO_CONTABILE_ASSOLO(M.CodicePCIVA)
	
	**=> ERASMO - INIZIO 12/01/2024
	IF _V_DBAL = "AQ_TREVICALOR"
	    _CONTO_CLI = "3.3.5." 
	    _CONTO_FOR = "3.3.5." 
	ENDIF
	**=> ERASMO - FINE 12/01/2024
 
    LEN_CONTO_CLI   =LEN(_CONTO_CLI)
    _CONTO_CLIX		=_CONTO_CLI+REPLICATE(" " ,(23-LEN_CONTO_CLI))
    M.LIBERA    	=M.LIBERA + _CONTO_CLIX

    LEN_CONTO_FOR   =LEN(_CONTO_FOR)
    _CONTO_FORX		=_CONTO_FOR+REPLICATE(" " ,(71-LEN_CONTO_FOR))
    M.LIBERA    	=M.LIBERA + _CONTO_FORX


    IF M.PercentualeIndetraibile > 0			&& IVA INDEDUCIBILE/INDETRAIBILE

    	LEN_IVPERIND   =LEN(ALLTRIM(STR(M.PercentualeIndetraibile,3,0)))
    	IF LEN_IVPERIND   = 2
      	    M.LIBERA 		=M.LIBERA + "I"
		    LEN_IVPERINDX   =LEN(ALLTRIM(STR(M.PercentualeIndetraibile,2,0)))
		    _IVPERINDX		=REPLICATE(" " ,(11-LEN_IVPERINDX))+ALLTRIM(STR(M.PercentualeIndetraibile,2,0))
		    M.LIBERA    	=M.LIBERA + _IVPERINDX
        ELSE
      	    M.LIBERA 		=M.LIBERA + "I"
		    LEN_IVPERINDX   =LEN(ALLTRIM(STR(M.PercentualeIndetraibile,3,0)))
		    _IVPERINDX		=REPLICATE(" " ,(12-LEN_IVPERINDX))+ALLTRIM(STR(M.PercentualeIndetraibile,3,0))
		    M.LIBERA    	=M.LIBERA + _IVPERINDX
        ENDIF
        
    ENDIF
    

	*** CONTROLLO CHE NON ESISTA GIA' IL CODICE IVA (RIF. CONVERSIONE CODICI IVA DOCUMENTI), ALTRIMENTI SOVRASCRIVO IL RECORD
	x_cond = "CODICE = '" + ALLTRIM(M.CODICE) + "'"
	cSql   = "Select * from PARA WHERE " + x_cond 
	IF !ExecRW(cSql,"PARA","R")
	  return(.f.)
	ENDIF
	SELECT PARA
	GO TOP
	IF EOF()
		APPEND BLANK
	ENDIF
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
   	
	IF !ExecRW(cSql,"PARA","W")
	  return(.f.)
	ENDIF
	
*!*	 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
*!*	   	APPEND BLANK
*!*	   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
    	
    SELECT CU_INPUT_ALIQIVA_CONTAB
	SKIP

ENDDO
	 
 		 
	 
*!*	****** AGGIORNA TABELLA PARASQL
*!*	IF !ExecRW('','PARA','I','','curs_PARA')
*!*	   return(.f.)
*!*	ENDIF
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 