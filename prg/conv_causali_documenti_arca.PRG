*************************************************************************************************
*						CONVERSIONE CAUSALI	DOCUMENTI											*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Luglio 2022 : Arca					 														*
*************************************************************************************************


SET DEFAULT TO &PUB_DIR

RIT = MESSAGEBOX("Conversione tabella causali documenti ? " + REPLICATE(CHR(13),2) + ;
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
_V_NOME_TABELLA_INPUT_CAUSALI_DOCUMENTI = 'DO'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_CAUSALI_DOCUMENTI 				&& CAUSALI DOCUMENTI
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
*!*	Id_Do
*!*	Cd_Do
*!*	Descrizione
*!*	DescrizioneBreve
*!*	TipoDocumento
*!*	Esecutivo
*!*	Prelevabile
*!*	Modificabile
*!*	ImportiIvati
*!*	AutoArchivia
*!*	CAEnabled
*!*	CAGenerate
*!*	IvaPerRiga
*!*	AggiornaUltimoCosto
*!*	AggiornaUltimoCosto_AM
*!*	Contabile
*!*	NoteDo
*!*	CliFor
*!*	Cd_MGCausale
*!*	Cd_CGCausale
*!*	Cd_CN
*!*	Cd_DOVettore_1
*!*	Cd_DOVettore_2
*!*	Cd_DOAspBene
*!*	Cd_DOTrasporto
*!*	Cd_DOSped
*!*	Cd_DOPorto
*!*	Cd_LS_1
*!*	Cd_LS_2
*!*	Cd_LS_C
*!*	ScontoCassa
*!*	ScontoRiga
*!*	ProvvigioneRiga_1
*!*	ProvvigioneRiga_2
*!*	Sconto
*!*	Provvigione
*!*	PkLstEnabled
*!*	PkLstMode
*!*	PkLstFormat
*!*	PkLstInputMask
*!*	MtrEnabled
*!*	MtrFormat
*!*	MtrInputMask
*!*	SegnoSCPrevista
*!*	SegnoFido
*!*	SegnoFatturato
*!*	PromozioniADataConsegna
*!*	RR_Enabled
*!*	Cd_RRConfig
*!*	CGDefinitivo
*!*	BloccaContabilizzati
*!*	ARLottoAuto
*!*	UIChkGiacenza
*!*	UIChkDisponibile
*!*	UIChkDisponibileImmediato
*!*	UIPropDataOra
*!*	UIRigaRifGenera
*!*	UIRigaRifExp
*!*	UIRigaRifPreleva
*!*	UIChkFido
*!*	UIChkFidoBlk
*!*	UIChkFidoBlkE
*!*	UIChkFidoVis
*!*	UIChkFidoFin
*!*	UIChkFidoBo
*!*	UIChkFidoOc
*!*	UIMgMovEdit
*!*	UIAbilitaTipoPC
*!*	UIPropDataConsegna
*!*	ExportToADW
*!*	ArrotondamentoN
*!*	ArrotondamentoC
*!*	UserIns
*!*	UserUpd
*!*	TimeIns
*!*	TimeUpd
*!*	Ts
*!*	DIEnabled
*!*	DICheck
*!*	RiportaNoteAR
*!*	FTE_TipoDocumento
*!*	DIExecutive
*!*	FTE_NoteT
*!*	FTE_NoteTCon
*!*	FTE_NoteR
*!*	FTE_NoteRDes
*!*	FTE_RigaRif
*!*	FTE_DIRif
*!*	FTE_DIRifTipo
*!*	FTE_NoteTTipo
*!*	DISave
*!*	FTE_AutoTipo
*!*	FTE_AutoOnly
*!*	FTE_Scadenze
*!*	FTE_NotaIva
*!*	FTE_TipoScontoT
*!*	FTE_TipoScontoR
*!*	FTE_AutoTD
*!*	FTE_AutoTD_Cd_DO
*!*	FTE_AutoTD_UI
*!*	FTE_TutteLeRighe



****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


*!*	*** CANCELLAZIONE DEI RECORD DELLA TABELLA CAUSALI SQL 
*!*	WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA CAUSALI" NOWAIT
*!*	cSql = "delete from PARA where CODICE LIKE 'TOP%'"
*!*	IF !ExecCommand(cSql,"PARA")
*!*	   return(.f.)
*!*	ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0


*** ################################################################### CAUSALI CONTABILI ###############################################################


=CONVERTE_CODICI_CAUSALI_DOCUMENTI_ARCA()
	  


_CTR = _CTR + 1
WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 