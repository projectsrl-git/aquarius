*************************************************************************************************
*						    CONVERSIONE CODICI CONDIZIONI DI PAGAMENTO    						*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Settembre 2021 : Assolo		 			 													*
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
_V_NOME_TABELLA_INPUT_DATI_COND_PAGAMENTO = 'COND_PAGAMENTO'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_DATI_COND_PAGAMENTO 		&& CONDIZIONI PAGAMENTO
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON CODICEPAGA 	TAG I_CODICE 
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


****** CAMPI DA TABELLA DI INPUT DA CONVERTIRE

*!*	CodicePaga
*!*	Descrizione
*!*	Sconto
*!*	SpeseIncasso
*!*	FmDf
*!*	NumeroRate
*!*	PrimaScadenza
*!*	GiorniInc
*!*	TipoDocPagam
*!*	RipartScad
*!*	Conto1
*!*	Conto2
*!*	ContoIncasso
*!*	CausaleIncasso
*!*	ModPagFE
*!*	ModPagFEI




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



	M.CODICE0 	= alltrim(m.CodicePaga)	
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
	IF SUBSTR(M.CODICE1,1,2) = 'RB'											&& E' UNA RI.BA
		_RIBA 	= "X"														&& E' UNA RI.BA
	ENDIF

	IF "RIBA" $ UPPER(ALLTRIM(M.DESCRI))									&& E' UNA RI.BA
		_RIBA 	= "X"														&& E' UNA RI.BA
	ENDIF

	IF "R.B." $ UPPER(ALLTRIM(M.DESCRI))									&& E' UNA RI.BA
		_RIBA 	= "X"														&& E' UNA RI.BA
	ENDIF

	IF "RIC." $ UPPER(ALLTRIM(M.DESCRI))									&& E' UNA RI.BA
		_RIBA 	= "X"														&& E' UNA RI.BA
	ENDIF	
		  
	IF "RB" $ UPPER(ALLTRIM(M.DESCRI))										&& E' UNA RI.BA
		_RIBA 	= "X"														&& E' UNA RI.BA
	ENDIF			  
		  
		  
	TIPOLOGIA_PAGAMEN = ALLTRIM(M.FmDf)										&& DA DATA FATTURA/DA FINE MESE
	_FINE_MESE = "DF"
	IF TIPOLOGIA_PAGAMEN = "D"
		_FINE_MESE = "DF"
	ENDIF
	IF TIPOLOGIA_PAGAMEN = "F"
		_FINE_MESE = "FM"			
	ENDIF


	PRIMA_SCADENZA = ALLTRIM(STR(M.PrimaScadenza,3,0))
	SCADENZE_SUCCESSIVE = ALLTRIM(STR(M.GiorniInc,3,0))


	IF M.NumeroRate = 0
		M.NumeroRate = 1 
	ENDIF  


	IF M.NumeroRate = 1 
		M.SCADEN        = PRIMA_SCADENZA + " "										&& SI COMPONE I GIORNI DI INTERVALLO
	ELSE
	
		M.SCADEN        = PRIMA_SCADENZA + " "										&& SI COMPONE I GIORNI DI INTERVALLO
	
		SCADENZE_SUCCESSIVE_NUM = M.PrimaScadenza + M.GiorniInc 
		SCADENZE_SUCCESSIVE     = ALLTRIM(STR(SCADENZE_SUCCESSIVE_NUM,3,0))
	
		FOR HF=2 TO NumeroRate 
		
			M.SCADEN                = M.SCADEN + SCADENZE_SUCCESSIVE + " "			&& SI COMPONE I GIORNI DI INTERVALLO
			SCADENZE_SUCCESSIVE_NUM = SCADENZE_SUCCESSIVE_NUM + M.GiorniInc
			SCADENZE_SUCCESSIVE     = ALLTRIM(STR(SCADENZE_SUCCESSIVE_NUM,3,0))
			
		NEXT

	ENDIF



    ** CERCO I GG DA SOMMARE ALLA SCADENZA
	M.SCAFISS  = 0
	_PAROLA = UPPER(ALLTRIM(M.DESCRI))
    _POSIZIONE_PAROLA_PIU = AT("+",M._PAROLA)   
    IF _POSIZIONE_PAROLA_PIU <> 0
		M.SCAFISS  = VAL(SUBSTR(M.DESCRI,_POSIZIONE_PAROLA_PIU + 1,3))													 
    ENDIF


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
*!*		REPLACE DESCRI   	WITH M.DESCRI
*!*		REPLACE LIBERA		WITH M.LIBERA
*!*		REPLACE PERCENTUALI	WITH M.PERCENTUALI



    _CTR = _CTR +1
    WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT



RETURN


********************************************
FUNCTION CERCA_CONDIZIONI_PAGAMENTO_STANDARD
********************************************


SELECT CU_INPUT
SET ORDER TO I_CODICE 
GO TOP

DO WHILE !EOF()

	SCATTER MEMVAR MEMO
	SELECT curs_PARA_CPA
	APPEND BLANK
	REPLACE SELEZIONE 	WITH ''
	REPLACE CODICE 		WITH "CPA"+ALLTRIM(CodicePaga)
	REPLACE DESCRI 		WITH ALLTRIM(Descrizione)
	

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