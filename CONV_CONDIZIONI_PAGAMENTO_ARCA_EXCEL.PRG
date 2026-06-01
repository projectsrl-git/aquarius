*************************************************************************************************
*						    CONVERSIONE CODICI CONDIZIONI DI PAGAMENTO    						*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Luglio 2021 : Arca			 			 													*
*************************************************************************************************

SET DEFAULT TO &PUB_DIR

RIT = MESSAGEBOX("Conversione tabella CONDIZIONI PAGAMENTO ? " + REPLICATE(CHR(13),2) + ;
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
*!*	_V_NOME_TABELLA_INPUT_DATI_COND_PAGAMENTO = 'MASSERA_PG'
*!*	cSql = "Select * from "+_V_NOME_TABELLA_INPUT_DATI_COND_PAGAMENTO 			&& CONDIZIONI PAGAMENTO
*!*	IF !ExecCommand(cSql,"CU_INPUT")
*!*	  return(.f.)
*!*	ENDIF
*!*	SELECT CU_INPUT
*!*	INDEX ON Cd_Pg 	TAG I_CODICE ADDITIVE 
*!*	SET ORDER TO I_CODICE 


*!*	_V_NOME_TABELLA_INPUT_DATI_COND_PAGAMENTO_RATA = 'MASSERA_PGRata'
*!*	cSql = "Select * from "+_V_NOME_TABELLA_INPUT_DATI_COND_PAGAMENTO_RATA 		&& CONDIZIONI PAGAMENTO
*!*	IF !ExecCommand(cSql,"CU_INPUTR")
*!*	  return(.f.)
*!*	ENDIF
*!*	SELECT CU_INPUTR
*!*	INDEX ON Cd_Pg	+	ALLTRIM(STR(Id_PGRata,4,0)) 					TAG I_CODICE ADDITIVE
*!*	SET ORDER TO I_CODICE 


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


****** CAMPI DA TABELLA DI INPUT DA CONVERTIRE

** PG
*!*	Id_PG
*!*	Cd_PG
*!*	Cd_CGConto_Banca
*!*	Descrizione
*!*	Note_PG
*!*	Sconto
*!*	Provvigione
*!*	Partenza
*!*	PrimaRata
*!*	NumeroRate
*!*	Blocco
*!*	AccontoFissoE
*!*	AccontoPerc
*!*	ApplicaNC
*!*	UserIns
*!*	UserUpd
*!*	TimeIns
*!*	TimeUpd
*!*	Ts

** PGRata
*!*	Id_PGRata
*!*	Cd_PG
*!*	Descrizione
*!*	TipoRata
*!*	Giorni
*!*	Imponibile
*!*	Imposta
*!*	Spese
*!*	Cd_Aliquota_Spese
*!*	Cd_CGConto_Spese
*!*	UserIns
*!*	UserUpd
*!*	TimeIns
*!*	TimeUpd
*!*	Ts
*!*	FTE_TipoPagamento




** ASSEGNAZIONE DELLA VARIABILE PATH **************************
V_PATH = ""
=OPENDB("PERCORSO")
SELECT PERCORSO
SET ORDER TO I_TIPO
GO TOP
SEEK "MAS"
IF FOUND()
	V_PATH = ALLTRIM(PER_PATH)
ELSE
	MESSAGEBOX("Percorso 'MAS' non configurato" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	USE
	RETURN .F.
ENDIF

IF DIRECTORY(V_PATH)
ELSE
	MESSAGEBOX("Percorso '" + ALLTRIM(V_PATH) + "' non trovato!" + CHR(13) + CHR(13) + ;
		"Controllare il file PERCORSO.DBF",16,"Attenzione")
	RETURN .F.
ENDIF

RIT = MESSAGEBOX("Conversione parametro CPA  da foglio Excel TABELLA PG: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


SET DEFAULT TO &V_PATH

**** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF

						

CREATE CURSOR CU_INPUT( ;
	Id_PG 				L, ;
	Cd_PG 				C(100), ;
	Cd_CGConto_Banca 	C(100), ;
	Descrizione 		C(200), ;	
	Note_PG 			C(100), ;
	Sconto 				N(8,3), ;
	Provvigione 		N(13,3), ;
	Partenza			N(13,0), ;
	PrimaRata			N(13,0), ;
	NumeroRate			N(13,0), ;
	Blocco				N(13,0), ;
	AccontoFissoE		N(13,3), ;
	AccontoPerc			N(13,3), ;
	ApplicaNC			N(13,3), ;
	UserIns				C(100), ;
	UserUpd				C(100), ;
	TimeIns				C(100), ;
	TimeUpd				C(100), ;
	Ts					C(100))


APPEND FROM (gcFile) TYPE XLS

SELECT CU_INPUT
GO TOP


RIT = MESSAGEBOX("Conversione parametro CPA  da foglio Excel TABELLA PGRata: " + REPLICATE(CHR(13),2) + ;
		ALLTRIM(V_PATH) + REPLICATE(CHR(13),2) + "Continuare?",4+32+256,"ATTENZIONE")
		
IF RIT = 7
   MESSAGEBOX("Operazione abbandonata",48,"Informazione")
   RETURN
ENDIF


SET DEFAULT TO &V_PATH

**** CARICAMENTO DEL FILE IN FORMATO EXCEL 5.0 !!!!!!!!!!!!!! IL FORMATO OFFICE 2007 IN POI NON FUNZIONA
gcFile = GETFILE('XLS', '', 'Browse', 1, 'Seleziona')
SET DEFAULT TO &PUB_DIR

IF EMPTY(gcFile)
	MESSAGEBOX("Nessun file selezionato",64,"Informazione")
	RETURN
ENDIF

						

CREATE CURSOR CU_INPUTR( ;
	Id_PGRata			C(100), ;
	Cd_PG 				C(100), ;
	Descrizione			C(100), ;
	TipoRata			C(200), ;	
	Giorni				N(8,0), ;
	Imponibile			N(13,3), ;
	Imposta				N(13,3), ;
	Spese				N(13,3), ;
	Cd_Aliquota_Spese	C(100), ;
	Cd_CGConto_Spese	C(100), ;
	UserIns				C(100), ;
	UserUpd				C(100), ;
	TimeIns				C(100), ;
	TimeUpd				C(100), ;
	Ts					C(100), ;
	FTE_TipoPagamento	C(100))


APPEND FROM (gcFile) TYPE XLS

SELECT CU_INPUTR
INDEX ON Cd_Pg	+ Id_PGRata	TAG I_CODICE ADDITIVE
SET ORDER TO I_CODICE 




****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select *, '          ' AS SELEZIONE from PARA where 1=0","curs_PARA_CPA")
   return
ENDIF

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF

*** CANCELLAZIONE DEI RECORD DELLA TABELLA CONDIZIONI DI PAGAMENTO SQL 


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA CONDIZIONI DI PAGAMENTO" NOWAIT
cSql = "delete from PARA where CODICE LIKE 'CPA%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF





=CERCA_CONDIZIONI_PAGAMENTO_STANDARD()


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
       SELECT CU_INPUT		&& SCARTO I RECORD CANCELLATI
       SKIP +1
       LOOP
    ENDIF 
    
    SCATTER MEMVAR MEMO
 

	=ELABORA_CPA()   
  	
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

********************************
FUNCTION ELABORA_CPA
********************************


	M.CODICE0 	= alltrim(m.Cd_PG)	
	M.CODICE1   = CONV_CLEAR(APITOSPA(ALLTRIM(M.CODICE0))) 
	M.CODICE    = "CPA"+M.CODICE1
  
	M.DESCRI 	= ALLTRIM(APITOSPA(ALLTRIM(M.Descrizione)))	
	M.DESCRI    = CONV_CLEAR(APITOSPA(ALLTRIM(M.DESCRI))) 


	M.SCADEN      						= ""
	M.PERCENTUALI 						= ""
	HO_TROVATO_ALMENO_UNA_PERCENTUALE 	= .F.

		
	M.LIBERA	= ""


	** VERIFICA SE E' UNA RICEVUTA BANCARIA
	_RIBA 			= " "	

	IF "RIBA" $ UPPER(ALLTRIM(M.DESCRI))									&& E' UNA RI.BA
		_RIBA 	= "X"														&& E' UNA RI.BA
	ENDIF

	IF "R.B." $ UPPER(ALLTRIM(M.DESCRI))									&& E' UNA RI.BA
		_RIBA 	= "X"														&& E' UNA RI.BA
	ENDIF

	IF "RIC" $ UPPER(ALLTRIM(M.DESCRI))										&& E' UNA RI.BA
		_RIBA 	= "X"														&& E' UNA RI.BA
	ENDIF	
		  
	IF "RB" $ UPPER(ALLTRIM(M.DESCRI))										&& E' UNA RI.BA
		_RIBA 	= "X"														&& E' UNA RI.BA
	ENDIF			  
		  
	
	
	
		  
	TIPOLOGIA_PAGAMEN 	= ""												&& DA DATA FATTURA/DA FINE MESE
	PRIMA_SCADENZA 		= ""
	SCADENZE_SUCCESSIVE = ""
    M.SCADEN            = ""


	=ELABORA_RIGHE_RATE_CONDIZIONI_PAGAMENTO(M.CODICE1)


	_FINE_MESE = "DF"
	IF TIPOLOGIA_PAGAMEN = "D"
		_FINE_MESE = "DF"
	ENDIF
	IF TIPOLOGIA_PAGAMEN = "F"
		_FINE_MESE = "FM"			
	ENDIF



    ** CERCO I GG DA SOMMARE ALLA SCADENZA
	M.SCAFISS  = 0
*!*		_PAROLA = UPPER(ALLTRIM(M.DESCRI))
*!*	    _POSIZIONE_PAROLA_PIU = AT("+",M._PAROLA)   
*!*	    IF _POSIZIONE_PAROLA_PIU <> 0
*!*			M.SCAFISS  = VAL(SUBSTR(M.DESCRI,_POSIZIONE_PAROLA_PIU + 1,3))													 
*!*	    ENDIF


	*!*	DF BON    90 120                                                                                                                                                                                        
	*!*	FM       X30 60 90                                                                                                                                                                                      
	IF _RIBA  = "X"                                                                                                                                                                                      
		M.LIBERA = _FINE_MESE + SPACE(07) + _RIBA + M.SCADEN 
	ELSE
		M.LIBERA = _FINE_MESE + SPACE(01) + "BON" + SPACE(03) + _RIBA + M.SCADEN 
	ENDIF



	SELECT curs_PARA					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   	APPEND BLANK
   	GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 




    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT



RETURN



************************************************
FUNCTION ELABORA_RIGHE_RATE_CONDIZIONI_PAGAMENTO
************************************************
LPARAMETERS _CODICE

_S1ZXXF = SELECT()

*!*	ACCESSO ALLA TABELLA RATE CONDIZIONI PAGAMENTO

SELECT CU_INPUTR
SET FILTER TO ALLTRIM(Cd_PG) = ALLTRIM(_CODICE)
SET ORDER TO I_CODICE 
GO TOP
M.SCADEN = ""

DO WHILE .NOT.EOF()

	SCATTER MEMVAR MEMO
	
	IF M.TipoRata = 'D'
		TIPOLOGIA_PAGAMEN = "D"		&& DATA FATTURA
	ELSE
		TIPOLOGIA_PAGAMEN = "F"		&& FINE MESE
	ENDIF

	M.SCADEN   = M.SCADEN + ALLTRIM(STR(M.GIORNI,4,0)) + " "			&& SI COMPONE I GIORNI DI INTERVALLO
	
   
	SELECT CU_INPUTR
	SKIP +1

ENDDO

	
SELECT CU_INPUTR
SET FILTER TO 

SELECT(_S1ZXXF)

RETURN .T.

ENDFUNC


********************************************
FUNCTION CERCA_CONDIZIONI_PAGAMENTO_STANDARD
********************************************


SELECT CU_INPUT
*SET ORDER TO I_CODICE 
GO TOP

DO WHILE !EOF()

	SCATTER MEMVAR MEMO
	SELECT curs_PARA_CPA
	APPEND BLANK
	REPLACE SELEZIONE 	WITH ''
	REPLACE CODICE 		WITH "CPA"+ALLTRIM(CONV_CLEAR(M.Cd_PG))
	REPLACE DESCRI 		WITH ALLTRIM(CONV_CLEAR(M.Descrizione))
	

	SELECT CU_INPUT
	SKIP +1
		
ENDDO

SELECT curs_PARA_CPA
GO TOP

IF !EOF()
	DO prg\browseview WITH "curs_PARA_CPA","Seleziona CONDIZIONI PAGAMENTO STANDARD da riportare in U_AZI_AN","W:4;codice:codice CPA,W:10;DESCRI:descrizione CPA,W:35;"
	SELECT curs_PARA_CPA
	GO TOP
	IF NumeroRecordLetti = 0
		MESSAGGIO_STILE_WIN8("Seleziona PER FAVORE CONDIZIONI PAGAMENTO STANDARD da aggiornare" + CHR(13) + "Fare click su OK per continuare")
	    RETURN 
	ELSE
			** INTERCETTA CONDIZIONI PAGAMENTO STANDARD
			SELECT curs_PARA_CPA
			GO TOP

			DO WHILE !EOF()

				IF EMPTY(SELEZIONE)
					SELECT curs_PARA_CPA
					SKIP +1
					LOOP
				ENDIF
				
				_CONDIZIONI_PAGAMENTO_STANDARD 	= ALLTRIM(SUBSTR(CODICE,4,10))
				
				EXIT

			
			ENDDO	


			WAIT WINDOWS 	"CONDIZIONI DI PAGAMENTO STANDARD "		+ _CONDIZIONI_PAGAMENTO_STANDARD 
	

			_CONDIZIONI_PAGAMENTO_STANDARD 	= ALLTRIM(_CONDIZIONI_PAGAMENTO_STANDARD)



			* -->> Aggiorna u_azi_an
			* --------------------------
			_seek = PUB_CODSOC
			x_cod = "azi_codsoc = '" + _seek + "'"
			cSql="SELECT * FROM u_azi_an WHERE " + x_cod
			IF !ExecRW(cSql,"u_azi_an","R")
			   return(.f.)
			ENDIF

			SELECT u_azi_an
			REPLACE AZI_CPA WITH _CONDIZIONI_PAGAMENTO_STANDARD 

			IF !ExecRW(cSql,"u_azi_an","W")
			   return(.f.)
			ENDIF


	
	ENDIF
ELSE
	MESSAGGIO_STILE_WIN8("CONDIZIONI PAGAMENTO STANDARD trovata rivolgersi al RESPONSABILE" + CHR(13) + "Fare click su OK per continuare")
    RETURN 
ENDIF



RETURN