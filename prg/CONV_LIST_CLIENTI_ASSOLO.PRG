*************************************************************************************************
*							    CONVERSIONE LISTINI CLIENTI										*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Ottobre 2021: Assolo			 												  			*
*************************************************************************************************


RIT = MESSAGEBOX("Conversione listini clienti azienda/articolo " + REPLICATE(CHR(13),2) + ;
		"Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


SET DEFAULT TO &PUB_DIR

RELEASE _V_DBDA,_V_DBAL
PUBLIC _V_DBDA,_V_DBAL
_V_DBDA =legge_config("conversioni.cfg","NOME_DB_ASSOLO")						&& RICERCA VARIABILE
_V_DBAL =legge_config("conversioni.cfg","NOME_DB_AQUARIUS")						&& RICERCA VARIABILE



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
_V_NOME_TABELLA_INPUT_ARTICOLI_LISTINI = 'ARTICOLI_LISTINI'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_ARTICOLI_LISTINI 					&& DETTAGLIO ARTICOLO LISTINI
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON CodiceListino	TAG I_CODICE 
SET ORDER TO I_CODICE 


**==> CARICAMENTO DATI DA CONVERTIRE
_V_NOME_TABELLA_INPUT_TESTATA_LISTINI = 'LISTINI'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_TESTATA_LISTINI 					&& TESTATA LISTINI
IF !ExecCommand(cSql,"CU_INPUT_TESTATA_LIS")
  return(.f.)
ENDIF
SELECT CU_INPUT_TESTATA_LIS
INDEX ON CodiceListino	TAG I_CODICE 
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





*!*	RIT = MESSAGEBOX("Desideri cancellare i listini esistenti ??" + REPLICATE(CHR(13),2) + ;
*!*			 "Continuare?",4+32+256,"ATTENZIONE")
*!*			
*!*	IF RIT <> 7

	WAIT WINDOWS "Cancellazione vecchi Listini in corso..." NOWAIT

	cSql = "DELETE FROM U_LIS_TT"
	IF !ExecCommand(cSql,"DEL_LIS_TT")
	   return
	ENDIF


	cSql = "DELETE FROM U_LIS_AV"
	IF !ExecCommand(cSql,"DEL_LIS_AV")
	   return
	ENDIF


*!*		cSql = "DELETE FROM U_LIS_AA"
*!*		IF !ExecCommand(cSql,"DEL_LIS_TT")
*!*		   return
*!*		ENDIF

*!*		cSql = "DELETE FROM U_LIS_LG"
*!*		IF !ExecCommand(cSql,"DEL_LIS_LG")
*!*		   return
*!*		ENDIF


*!*	ENDIF


*!*	CAMPI DA CONVERTIRE ARTICOLI_LISTINI
*!*	CodiceListino
*!*	CodiceArticolo
*!*	ArticoloFornitore
*!*	Prezzo
*!*	Notaart


*!*	CAMPI DA CONVERTIRE LISTINI (TESTATA)
*!*	CodiceListino
*!*	Descrizione
*!*	Valuta
*!*	DataInizio
*!*	DataFine
*!*	AcqVend
*!*	TipoImporto
*!*	FattoreRicarico
*!*	Nota




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0


_TOT_COUNT = 0

SET STEP ON 

SELECT CU_INPUT
GO TOP


DO WHILE !EOF()
		
	WAIT WINDOWS "Conversione Listino " + ALLTRIM(STR(RECNO(),10,0)) + " di " + ALLTRIM(STR(RECCOUNT(),10,0)) + ;
		" (" + ALLTRIM(STR(RECNO() * 100 / RECCOUNT(),10,0)) + "%)" NOWAIT 
		
    IF DELETED()
       SELECT CU_INPUT  && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    

    SCATTER MEMVAR MEMO 
  	
	** DETTAGLIO LISTINO
	__LIS_CODSOC  = PUB_CODSOC
	__LIS_TIPOAZI = ALLTRIM(CONV_CLEAR(M.CodiceListino))	
	__LIS_CODART  = ALLTRIM(CONV_CLEAR(M.CodiceArticolo))
	__LIS_ARTFOR  = ALLTRIM(CONV_CLEAR(M.ArticoloFornitore))
	__LIS_PREZZO  = M.Prezzo
	__LIS_DESART  = ''
	__LIS_UMMAGA  = ''
	
	** TESTATA LISTINO
	SELECT CU_INPUT_TESTATA_LIS
	SET ORDER TO I_CODICE 
    V_SEEK = __LIS_TIPOAZI 
    SEEK V_SEEK
    IF FOUND()
		__ACQVEND     = CONV_CLEAR(AcqVend)
 		__LIS_DESLIS  = ALLTRIM(CONV_CLEAR(Descrizione)) 
		__LIS_DATLIS  = SUBSTR(DTOC(DataInizio),1,2) + '/' + SUBSTR(DTOC(DataInizio),4,2) + '/' + SUBSTR(DTOC(DataInizio),7,4)
		__LIS_ALLIST  = SUBSTR(DTOC(DataFine),1,2) + '/' + SUBSTR(DTOC(DataFine),4,2) + '/' + SUBSTR(DTOC(DataFine),7,4)
	ELSE
		__ACQVEND     = 'X'
		__LIS_DESLIS  = ""
		__LIS_DATLIS  = "1990/01/01"
		__LIS_ALLIST  = "2990/01/01"
    ENDIF	
	
	x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
	x_codi = "ART_CODPRI = '" + __LIS_CODART + "'"
	x_cond = x_soci + " and " + x_codi
	cSql = "SELECT ART_CODPRI,ART_DESCR,ART_UMMAGA FROM U_ART_PR WHERE " + x_cond
	IF !ExecCommand(cSql,"CX_ART_PR")
		RETURN .F.
	ENDIF
	SELECT CX_ART_PR
	GO TOP
	IF !EOF()
		__LIS_DESART = ALLTRIM(ART_DESCR)
		__LIS_UMMAGA = ALLTRIM(ART_UMMAGA)
	ENDIF

	SELECT CU_INPUT

	_E_UN_CLIENTE = .F.
	_E_UN_FORNITORE = .F.
	_E_UN_AZIENDA_ARTICOLO = .F.

	_CODCLFO = TRC(PUB_LCL,ALLTRIM(__LIS_CODART))

    IF __ACQVEND = 'V'
		*!*	VERIFICO SE E' UN LISTINO CLIENTE
		x_soci = "CLI_CODSOC = '" + PUB_CODSOC + "'"
		x_codi = "CLI_CODCLI = '" + _CODCLFO + "'"
		x_cond = x_soci + " and " + x_codi
		cSql = "SELECT CLI_CODSOC,CLI_CODCLI,CLI_RAGSOC FROM U_CLI_AN WHERE " + x_cond
		IF !ExecCommand(cSql,"CX_CLI_AN")
			RETURN .F.
		ENDIF
		SELECT CX_CLI_AN
		GO TOP
		IF !EOF()
			_E_UN_CLIENTE = .T.
			_E_UN_AZIENDA_ARTICOLO = .F.
		ELSE
			_E_UN_CLIENTE = .F.
			_E_UN_AZIENDA_ARTICOLO = .T.
		ENDIF
	ENDIF


*!*	    IF __ACQVEND = 'A'
*!*			*!*	VERIFICO SE E' UN LISTINO FORNITORE
*!*			x_soci = "FOR_CODSOC = '" + PUB_CODSOC + "'"
*!*			x_codi = "FOR_CODCLI = '" + _CODCLFO + "'"
*!*			x_cond = x_soci + " and " + x_codi
*!*			cSql = "SELECT FOR_CODSOC,FOR_CODCLI,FOR_RAGSOC FROM U_FOR_AN WHERE " + x_cond
*!*			IF !ExecCommand(cSql,"CX_FOR_AN")
*!*				RETURN .F.
*!*			ENDIF
*!*			SELECT CX_FOR_AN
*!*			GO TOP
*!*			IF !EOF()
*!*				_E_UN_FORNITORE = .T.
*!*			ELSE
*!*				_E_UN_FORNITORE = .F.
*!*			ENDIF
*!*		ENDIF		
	


	DO CASE 

		CASE _E_UN_CLIENTE									&& LISTINI VENDITA CLIENTE/ARTICOLO 	

			WAIT WINDOWS "LISTINO CLIENTE " + _CODCLFO  NOWAIT
		
		CASE _E_UN_AZIENDA_ARTICOLO 	
			
			cSql = "SELECT * FROM U_LIS_AV WHERE 1=0"		&& LISTINI VENDITA AZIENDA/ARTICOLO
			IF !ExecRW(cSql,"U_LIS_AV","R")
			   return
			ENDIF
			SELECT U_LIS_AV
			APPEND BLANK
			
			REPLACE LIS_CODSOC WITH __LIS_CODSOC 
			REPLACE LIS_TIPOAZI WITH __LIS_TIPOAZI 
			REPLACE LIS_DESLIS WITH __LIS_DESLIS
			REPLACE LIS_CODART WITH __LIS_CODART 
			REPLACE LIS_DESART WITH __LIS_DESART 
			REPLACE LIS_DATLIS WITH RIBALTA2(__LIS_DATLIS)
			REPLACE LIS_ALLIST WITH RIBALTA2(__LIS_ALLIST)
			REPLACE LIS_PREZZO WITH __LIS_PREZZO 
			REPLACE LIS_UMMAGA WITH __LIS_UMMAGA
				
			SCATTER MEMVAR
			
			IF !ExecRW(cSql,"U_LIS_AV","W")
			   return
			ENDIF	
			
	ENDCASE
		

	
	=LIS_LOGA("XXX",M.LIS_DATLIS,M.LIS_ALLIST,"TIPOLOGIA","XXX","XXX",M.LIS_TIPOAZI)	&& AGGIORNA LOG LISTINO
		
	_TOT_COUNT = _TOT_COUNT + 1
	
	
    	
    SELECT CU_INPUT
	SKIP
	
	
ENDDO


WAIT CLEAR

MESSAGEBOX("Operazione terminata correttamente" + REPLICATE(CHR(13),2) + ;
	"Totale righe Listini convertiti: " + ALLTRIM(STR(_TOT_COUNT,10,0)),64,"Informazione")

RETURN


 