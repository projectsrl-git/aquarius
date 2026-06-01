*************************************************************************************************
*						CONVERSIONE CAUSALI	DOCUMENTO/MAGAZZINO									*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Settembre 2021 : Assolo				 														*
*************************************************************************************************


SET DEFAULT TO &PUB_DIR

RIT = MESSAGEBOX("Conversione tabella causali documenti/magazzini ? " + REPLICATE(CHR(13),2) + ;
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
_V_NOME_TABELLA_INPUT_CAUSALI_DOCUMENTI = 'CAUSALI_DOCUMENTI'
_V_NOME_TABELLA_INPUT_CAUSALI_MAGAZZINO = 'CAUSALI_MAGAZZINO'

*cSql = "Select * from "+_V_NOME_TABELLA_INPUT_CAUSALI_DOCUMENTI 		&& CAUSALI DOCUMENTI
cSql = "Select CD.*,COALESCE(CM.Giacenza,'') AS GIACENZA from "+_V_NOME_TABELLA_INPUT_CAUSALI_DOCUMENTI+" AS CD LEFT OUTER JOIN "+_V_NOME_TABELLA_INPUT_CAUSALI_MAGAZZINO+" AS CM ON CM.CodiceCauMaga = CD.CausaleMaga"  && ERASMO - 17/11/2021
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON CodiceCauDocu	TAG I_CODICE 
SET ORDER TO I_CODICE 

cSql = "Select * from "+_V_NOME_TABELLA_INPUT_CAUSALI_MAGAZZINO 		&& CAUSALI MAGAZZINO
IF !ExecCommand(cSql,"CU_INPUT_MAG")
  return(.f.)
ENDIF
SELECT CU_INPUT_MAG
INDEX ON CodiceCauMaga	TAG I_CODICE 
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

*!*	TABELLA CAUSALI_DOCUMENTI
*!*	CodiceCauDocu
*!*	CausaleMaga
*!*	CausaleCntbl
*!*	CausaleDocu
*!*	DocuInput
*!*	Numerazione
*!*	NumerazImposto
*!*	PassMaga
*!*	PassCntbl
*!*	PassScadenze
*!*	PassFatture
*!*	FormatoStampa
*!*	Descrizione
*!*	CliFor
*!*	Tipo
*!*	EsplodeDB
*!*	EsplodeConf
*!*	MonoLivello
*!*	Ritenuta
*!*	CfatEle
*!*	CauFE
*!*	Winport
*!*	SubCodiceRAP
*!*	PercImponibileRAP
*!*	Cassa
*!*	TCassa

*!*	TABELLA CAUSALI_MAGAZZINO
*!*	CodiceCauMaga
*!*	Descrizione
*!*	CausaleCocat
*!*	Raggruppamento
*!*	Magazzino
*!*	Giacenza
*!*	Vendite
*!*	Acquisti
*!*	Produzione
*!*	Resi
*!*	Impegni
*!*	OrdiniFornitori
*!*	Costi
*!*	Ricavi
*!*	EsplodeDB
*!*	LivelloMinimo
*!*	EsplodeConf
*!*	MonoLivello





****** DEFINIZIONE DEI CURSORI STP

IF !ExecCommand("select * from PARA where 1=0","curs_PARA")
   return
ENDIF


*** CANCELLAZIONE DEI RECORD DELLA TABELLA CAUSALI SQL 


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA ANAGRAFICA CAUSALI" NOWAIT


*cSql = "delete from PARA where CODICE LIKE 'TOP%'"
cSql = "delete from PARA where CODICE LIKE 'TOP%' AND CODICE NOT IN ('TOPCAM','TOPSCM')"  && ERASMO - 17/11/2021
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



*** ################################################################### CAUSALI DOCUMENTI ###############################################################

=CONVERTE_CODICI_CAUSALI_DOCUMENTI_ASSOLO()

*** ################################################################### CAUSALI MAGAZZINO ###############################################################

IF _V_DBAL = "AQ_TREVICALOR"
ELSE											&& 27/07/2023 NON CARICA LE CAUSALI DI MAGAZZINO DELLA TREVICALOR
	=CONVERTE_CODICI_CAUSALI_MAGAZZINO_ASSOLO()		
ENDIF

*** ################################################################### INSERT CAUSALI AQUARIUS ###############################################################


=CREA_CAUSALI_AQUARIUS_CAUSALI_DOCUMENTI_ASSOLO()

	 
****** AGGIORNA TABELLA PARASQL
IF !ExecRW('','PARA','I','','curs_PARA')
   return(.f.)
ENDIF



=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


 