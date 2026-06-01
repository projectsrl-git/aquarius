*************************************************************************************************
*					            CONVERSIONE CATEGORIE MERCEOLOGICHE								*
*							 																	*
*	by Sergio Piaggi Project S.r.l.																*
*	Ottobre 2021: Assolo			 															*
*************************************************************************************************


*** conferma utente

RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"delle categorie merceologiche ?",292,"ATTENZIONE")
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
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
_V_NOME_TABELLA_INPUT_CATEGORIE_MERCEOLOGICHE = 'CATEGORIE_MERCE'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_CATEGORIE_MERCEOLOGICHE 			&& CATEGORIE MERCEOLOGICHE
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON CodiceCauDocu	TAG I_CODICE 
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


cSql = "delete from PARA where CODICE LIKE 'MER%' "
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF




******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0



*!*	CAMPI DA CONVERTIRE
*!*	CodiceCat
*!*	Descrizione
*!*	Mastro
*!*	CodicePartita
*!*	Conto1
*!*	Conto2
*!*	Conto3
*!*	Quantità1
*!*	Quantità2
*!*	Quantità3
*!*	Quantità4
*!*	Formula1
*!*	Quantità5
*!*	Formula2
*!*	Formula3
*!*	Formula4
*!*	Formula5
*!*	CdR
*!*	QtaPerDB1
*!*	QtaPerDB2
*!*	QtaPerDB3
*!*	QtaPerDB4
*!*	QtaPerDB5
*!*	UniMis1
*!*	UniMis2
*!*	UniMis3
*!*	UniMis4
*!*	UniMis5

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

	M._CATMERX= ALLTRIM(APITOSPA(CONV_CLEAR(M.CodiceCat)))
	LEN_CAT_MER  = LEN(_CATMERX)
	IF LEN_FAT_MER > 3
		M._CATMER = SUBSTR(M._CATMERX,LEN_CAT_MER  - 2,3)
	ELSE
		M._CATMER = SUBSTR(M._CATMERX,1,3)
	ENDIF

	M.CODICE 	= "MER"+M._CATMER
   	M.DESCRI  	= APITOSPA(CONV_CLEAR(M.Descrizione))
   	M.LIBERA	= ""

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


 