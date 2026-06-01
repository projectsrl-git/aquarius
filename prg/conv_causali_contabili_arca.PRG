*************************************************************************************************
*						CONVERSIONE CAUSALI	CONTABILI											*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Luglio 2022 : Arca					 														*
*************************************************************************************************


SET DEFAULT TO &PUB_DIR

RIT = MESSAGEBOX("Conversione tabella causali contabili ? " + REPLICATE(CHR(13),2) + ;
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



SET DEFAULT TO &PUB_DIR

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
_V_NOME_TABELLA_INPUT_CAUSALI_CONTABILI = 'CGCausale'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_CAUSALI_CONTABILI 				&& CAUSALI CONTABILI
IF !ExecCommand(cSql,"CU_INPUT_CONTAB")
  return(.f.)
ENDIF
SELECT CU_INPUT_CONTAB
INDEX ON Cd_CGCausale	TAG I_CODICE 
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
*!*	Id_CGCausale
*!*	Cd_CGCausale
*!*	Descrizione
*!*	DescBreve
*!*	Tipo
*!*	Cd_CGRegistro
*!*	Cd_CN
*!*	Cd_CSCausale
*!*	CreaScadenze
*!*	SezioneIva
*!*	AggiornaFixing
*!*	FacileDoc
*!*	BollaDoganale
*!*	Corrispettivo
*!*	Cespite
*!*	Leasing
*!*	Cd_CGLiq
*!*	RR_Enabled
*!*	Cd_RRConfig
*!*	Compensazione
*!*	UserIns
*!*	UserUpd
*!*	TimeIns
*!*	TimeUpd
*!*	Ts
*!*	PosticipoIva
*!*	BeniUsati
*!*	Cd_BUCausale
*!*	DF_Escluso
*!*	DF_TipoDocumento



****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


*!*	*** CANCELLAZIONE DEI RECORD DELLA TABELLA CAUSALI SQL 


*!*	WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA CAUSALI" NOWAIT


cSql = "delete from PARA where CODICE LIKE 'TOP%'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0


*** ################################################################### CAUSALI CONTABILI ###############################################################

=CONVERTE_CODICI_CAUSALI_CONTABILI_ARCA()
	 

*** ################################################################### INSERT CAUSAL AQUARIUS ###############################################################


=CREA_CAUSALI_AQUARIUS_CAUSALI_DOCUMENTI_ARCA()


	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF





_CTR = _CTR + 1
WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 