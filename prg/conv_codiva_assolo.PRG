*************************************************************************************************
*							CONVERSIONE CODICI IVA DOCUMENTI									*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	SETTEMBRE 2021 : Assolo	 				 													*
*************************************************************************************************


SET DEFAULT TO &PUB_DIR

RIT = MESSAGEBOX("Conversione tabella CODICI IVA DOCUMENTI ? " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")
    _CONVERTE_TABELLA_CONTABILE = .T.

		
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
_V_NOME_TABELLA_INPUT_ALIQUOTE_IVA = 'ALIQUOTE_IVA'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_ALIQUOTE_IVA 						&& ALIQUOTE IVA
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON CodiceIva	TAG I_CODICE 
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
*!*	TABELLA ALIQUOTE_IVA DOCUMENTI
*!*	CodiceIva
*!*	Descrizione
*!*	CodicePartita
*!*	Conto1
*!*	Conto2
*!*	Aliquota
*!*	ScorporoIva
*!*	CodiceCnt1
*!*	CodiceCnt2
*!*	Natfe
*!*	EsiIva

*!*	TABELLA CNT32_AliquoteIVA
*!*	CodicaAliquota
*!*	Descrizione
*!*	ContoIVA
*!*	ExContoIVA


****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA IVA SQL 


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA IVA" NOWAIT


cSql = "delete from PARA where CODICE LIKE 'IVA%' "
IF !ExecCommand(cSql,"PARA")
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


    SCATTER MEMVAR MEMO

 
	M.CODICE1 	=CONV_CLEAR(M.CodiceIva)	
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
	
	SELECT CU_INPUT
	
	M.NOTE = "## CONVERTITO DA DB ASSOLO ##"
	**=> ERASMO - FINE 12/01/2024    
    
*campo libera  	
*D22  1414002                1414001                                                                I        100                                                                                                                                               
*21S  1414002                1414001                                                                I         60                                                                                                                                        
*22   1414002                1414001                                                                                                                                                                                                                     
*021  2092201                1011101                                                                I         40                                                                                         
*123456789012345678901234567890
*IND.POS 72 
*PER.IND 11   
    


    ___IVPERIVA 	= ALLTRIM(STR(M.Aliquota,5,0))
    LEN_CODICE2 	=LEN(___IVPERIVA)
    M.CODICE2X  	=___IVPERIVA+REPLICATE(" ",(5-LEN_CODICE2)) 
    M.LIBERA    	=M.CODICE2X
    

	_CONTO_CLI	    =CONVERTE_CODICE_CONTO_CONTABILE_ASSOLO(M.Conto1)
	_CONTO_FOR	    =CONVERTE_CODICE_CONTO_CONTABILE_ASSOLO(M.Conto2)
 
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


*!*	    IF VAL(ALLTRIM(M.IVPERIND)) > 0			&& IVA INDEDUCIBILE
*!*	    
*!*	    	LEN_IVPERIND   =LEN(M.IVPERIND)
*!*	    	IF LEN_IVPERIND   = 2
*!*	      	    M.LIBERA 		=M.LIBERA + "I"
*!*			    LEN_IVPERINDX   =LEN(ALLTRIM(M.IVPERIND))
*!*			    _IVPERINDX		=REPLICATE(" " ,(11-LEN_IVPERINDX))+ALLTRIM(M.IVPERIND)
*!*			    M.LIBERA    	=M.LIBERA + _IVPERINDX
*!*	        ELSE
*!*	      	    M.LIBERA 		=M.LIBERA + "I"
*!*			    LEN_IVPERINDX   =LEN(ALLTRIM(M.IVPERIND))
*!*			    _IVPERINDX		=REPLICATE(" " ,(12-LEN_IVPERINDX))+ALLTRIM(M.IVPERIND)
*!*			    M.LIBERA    	=M.LIBERA + _IVPERINDX
*!*	        ENDIF
*!*	        
*!*	    ENDIF

	**=> ERASMO - INIZIO 04/04/2022
	IF !ISNULL(M.Natfe)
	ELSE
		M.Natfe = ""
	ENDIF 
	M.NATURA = IIF(M.Aliquota > 0, SPACE(4), PADR(ALLTRIM(M.Natfe),4,' '))
	M.LIBERA = M.LIBERA + SPACE(45) + M.NATURA
	M.BENI_SERVIZI = .F.
	**=> ERASMO - FINE 04/04/2022
	
 	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

    	
    SELECT CU_INPUT
	SKIP

ENDDO
	 

	 
** INSERISCE CODICE IVA: NO	 
 
M.CODICE    	="IVANO"
M.DESCRI 		="NESSUNA IVA APPLICATA"

*!*		0    2.1.1.54.              2.1.2.54.                                                                                                                                                                                                                         

*!*		LIBERA DALLA 1 ALLA 5 COSI COME E'
*!*		LIBERA DALLA 6 ALLA 23
*!*		LIBERA DALLA 24 IN POI					
*!*			
_LEN          				= LEN(_CONTO_CLIX)
_NR_BLANC     				= 23 - _LEN
_NR_SPAZI     				= " "
_NR_SPAZI     				= REPLICATE(_NR_SPAZI,_NR_BLANC)     
_CONTO_CLIX					= _CONTO_CLIX  + _NR_SPAZI     
M.LIBERA = '0    ' + _CONTO_CLIX + _CONTO_FORX					

SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
APPEND BLANK
GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 
 
 		 
	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF
	 
	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 