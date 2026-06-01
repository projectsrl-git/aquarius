*************************************************************************************************
*							CONVERSIONE PIANO DEI CONTI											*
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Ottobre 2021 : Assolo/Eurocont		 														*
*************************************************************************************************

_answer__ = messagebox("Procedo con la conversione del PIANO DEI CONTI ? ",292,"Attenzione")
if _answer__  = 7
	MessageBox("Nessuna conversione effettuata!",64,"Informazione")
	return .f.
endif


SET DEFAULT TO &PUB_DIR

RELEASE _V_DBDA,_V_DBAL
PUBLIC _V_DBDA,_V_DBAL
_V_DBDA =legge_config("conversioni.cfg","NOME_DB_EUROCONT")						&& RICERCA VARIABILE
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
_V_NOME_TABELLA_INPUT_PIANO_CONTI = 'PianoConti'
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_PIANO_CONTI 						&& PIANO DEI CONTI
IF !ExecCommand(cSql,"CU_INPUT_PIANO_CONTI")
  return(.f.)
ENDIF
SELECT CU_INPUT_PIANO_CONTI
INDEX ON CodicePC	TAG I_CODICE 
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
*!*	CodicePC
*!*	TipoConto
*!*	Mastro
*!*	Titolo
*!*	RiclassificazioneCEE
*!*	RiclassificazioneAziendale
*!*	RiclassificazioneFiscale
*!*	RiclassificazioneCivile
*!*	Livello
*!*	MastroAnagrafico
*!*	CostiDaVentilare
*!*	ContoAmmortamenti
*!*	ContoSpese
*!*	ContoImponibileIVA
*!*	ContoIVA
*!*	ContoAnticipazioni
*!*	ContoPrevidenza
*!*	ContoBolli
*!*	ContoSoggettoRAP
*!*	ContoRAP
*!*	ContoSoggettoINPS
*!*	ContoINPS
*!*	ContoIRAP
*!*	GiroConto
*!*	MovimentaCdC
*!*	RiclassificazioneEsterna
*!*	TipoContoAllegatoIVA
*!*	CCDC



****** DEFINIZIONE DEI CURSORI STP


WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIO PIANO DEI CONTI" NOWAIT

IF !ExecCommand("select * from CONTI where 1=0","curs_CONTI")
   return
ENDIF
SELECT curs_CONTI
INDEX ON CON_CONTO TAG I_CONTO



*** CANCELLAZIONE DEI RECORD DELLA TABELLA CONTI SQL 

cSql   = "delete from CONTI " 
IF !ExecCommand(cSql,"CONTI")
   return(.f.)
ENDIF


******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _CTR
PUBLIC _CTR
_CTR = 0

												

RELEASE MASTRO_CORRENTE,PE_CORRENTE  
PUBLIC MASTRO_CORRENTE,PE_CORRENTE  

MASTRO_CORRENTE = ""
PE_CORRENTE     = ""


***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT CU_INPUT_PIANO_CONTI
GO TOP 


DO WHILE !EOF()

 
  
    SCATTER MEMVAR MEMO 

*!*	    IF m.CodicePC = '001020'
*!*	    SET STEP ON 
*!*	    ENDIF
    
    
	M.CON_CONTO  		= CONVERTE_CODICE_CONTO_CONTABILE_ASSOLO(m.CodicePC)

    
    MASTRO_CORRENTE  	= M.CON_CONTO
    LEN_MASTRO       	= LEN(MASTRO_CORRENTE)

    DO CASE 
    	CASE LEN_MASTRO   = (PUB_MASTRO -1)
  			=INTERCETTA_DATI_CONTO()  
    
    	CASE LEN_MASTRO   = (PUB_SOTTOG -1)
			=INTERCETTA_DATI_SOTTOCONTO()
		
		OTHERWISE         
    		 =INTERCETTA_DATI_CONTO_ELEMENTARE()  
   		  
    ENDCASE
    

    	
    SELECT CU_INPUT_PIANO_CONTI
	SKIP

ENDDO




*!*	SELECT curs_CONTI
*!*	SET ORDER TO I_CONTO
*!*	GO TOP

*!*	*!*	** CREA I GRUPPI/SOTTOGRUPPI MANCANTI SUL PIANO DEI CONTI ORIGINALE
*!*	SCATTER MEMVAR MEMO
*!*	APPEND BLANK
*!*	GATHER MEMVAR MEMO
*!*	REPLACE CON_CONTO WITH "1.20."
*!*	REPLACE CON_DESCR  WITH "PERDITE ESERCIZI PRECEDENTI"
*!*	REPLACE CON_POSBIL WITH "P"

*!*	SCATTER MEMVAR MEMO
*!*	APPEND BLANK
*!*	GATHER MEMVAR MEMO
*!*	REPLACE CON_CONTO WITH "1.21."
*!*	REPLACE CON_DESCR  WITH "PERDITA D'ESERCIZIO"
*!*	REPLACE CON_POSBIL WITH "P"

*!*	SCATTER MEMVAR MEMO
*!*	APPEND BLANK
*!*	GATHER MEMVAR MEMO
*!*	REPLACE CON_CONTO WITH "4.10."
*!*	REPLACE CON_DESCR  WITH "ONERI FINANZIARI"
*!*	REPLACE CON_POSBIL WITH "E"



*!*	SCATTER MEMVAR MEMO
*!*	APPEND BLANK
*!*	GATHER MEMVAR MEMO
*!*	REPLACE CON_CONTO WITH "4.12."
*!*	REPLACE CON_DESCR  WITH "ONERI STRAORDINARI"
*!*	REPLACE CON_POSBIL WITH "E"

*!*	SCATTER MEMVAR MEMO
*!*	APPEND BLANK
*!*	GATHER MEMVAR MEMO
*!*	REPLACE CON_CONTO WITH "4.20."
*!*	REPLACE CON_DESCR  WITH "IMPOSTE E TASSE"
*!*	REPLACE CON_POSBIL WITH "E"

WAIT windows "Creazione conti contabili da anagrafica clienti/fornitori" nowait    
=CREA_CONTI_CONTABILI_DA_CLIENTI_FORNITORI()    
    
    

SELECT curs_CONTI
SET ORDER TO I_CONTO
GO TOP


****** AGGIORNA TABELLA CONTI SQL
IF !ExecRW('','CONTI','I','','curs_CONTI')
   return(.f.)
ENDIF
	 
IF !ExecCommand("select * from CONTI where 1=0","curs_CONTI")
   return
ENDIF


_AGGIORNA_DB = .T.
=CREA_CONTROLLA_STRUTTURA_PIANO_CONTI_MULTILIVELLO(_AGGIORNA_DB)							&& CONTROLLO DELLA STRUTTURA DEL PIANO DEI CONTI MULTILIVELLO

=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN


****************************************************************
FUNCTION INTERCETTA_DATI_CONTO 
****************************************************************
  
  
	   M.CON_DESCR  = alltrim(CONV_CLEAR(m.Titolo))
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   

       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN


****************************************************************
FUNCTION INTERCETTA_DATI_SOTTOCONTO 
****************************************************************

	   
	   M.CON_DESCR  = alltrim(CONV_CLEAR(m.Titolo))
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   

       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN



****************************************************************
FUNCTION INTERCETTA_DATI_CONTO_ELEMENTARE 
****************************************************************
	   
	   M.CON_DESCR  = alltrim(CONV_CLEAR(m.Titolo))
	   M.CON_DESCR  = UPPER(M.CON_DESCR)
	   M.CON_DESCR  = APITOSPA(M.CON_DESCR)	   
   
       =COMPILA_ALTRI_DATI_PIANO_DEI_CONTI()

RETURN

****************************************************************
FUNCTION COMPILA_ALTRI_DATI_PIANO_DEI_CONTI
****************************************************************
*!*	CAMPI DA CONVERTIRE
*!*	CodicePC
*!*	TipoConto
*!*	Mastro
*!*	Titolo
*!*	RiclassificazioneCEE
*!*	RiclassificazioneAziendale
*!*	RiclassificazioneFiscale
*!*	RiclassificazioneCivile
*!*	Livello
*!*	MastroAnagrafico
*!*	CostiDaVentilare
*!*	ContoAmmortamenti
*!*	ContoSpese
*!*	ContoImponibileIVA
*!*	ContoIVA
*!*	ContoAnticipazioni
*!*	ContoPrevidenza
*!*	ContoBolli
*!*	ContoSoggettoRAP
*!*	ContoRAP
*!*	ContoSoggettoINPS
*!*	ContoINPS
*!*	ContoIRAP
*!*	GiroConto
*!*	MovimentaCdC
*!*	RiclassificazioneEsterna
*!*	TipoContoAllegatoIVA
*!*	CCDC


   m.id_unique = "" 				
   M.CON_SOC   = PUB_CODSOC
   M.CON_ANNO  = PUB_ANNO
   M.CON_TIPOCO = 'X'
   M.CON_TIPO_CONTO = STR(M.TipoConto,1,0)
 
   IF VAL(SUBSTR(M.CON_CONTO,1,1))  < 3			
      PE_CORRENTE = 'P'							&& PATRIMONIALI
   ELSE
      PE_CORRENTE = 'E'							&& ECONOMICI
   ENDIF	 
	     
   M.CON_POSBIL = PE_CORRENTE

  
*!*	   IF SUBSTR(ALLTRIM(M.CON_CONTO),1,4) = "1414" 	&& MASTRO IVA ####################################### DA GESTIRE
*!*		    IF LEN(ALLTRIM(M.CON_CONTO)) > 4 
*!*	       		M.CON_TIPOCO = 'I'						&& CONTO IVA
*!*	   		ENDIF
*!*	   ENDIF


*!*	#####################################################

   SELECT curs_CONTI					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
   APPEND BLANK
   GATHER MEMVAR MEMO 					&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 

							   
   _CTR = _CTR +1
   WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT
   




RETURN




****************************************************************
FUNCTION CREA_CONTI_CONTABILI_DA_CLIENTI_FORNITORI
****************************************************************


*!*	################################################# CREA PIANO DEI CONTI DA ANAGRAFICA CLIENTI #################################################

v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

CCC=SUBSTR(LIBERA,1,4)

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTI")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTI
GO TOP

CTRELAB = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   CPA=CLI_CONPAG
   CLI=CLI_CODCLI +" " + SUBSTR(CLI_RAGSOC,1,30)

   V_ER = SOTTOGEN(CLI_NAZION)
   IF !V_ER
      CC = PUB_CC
   ELSE
      CCC= CCC
   ENDIF

   SELECT CUR_CLIENTI

   SCATTER MEMVAR MEMO

   XXX_CODCLI = CC + ALLTRIM(STR(VAL(M.CLI_CODCLI)))	&& TOGLIE GLI 0 NON SIGNIFICATIVI IN QUANTO IL CLIENTE NEL PIANO DEI CONTI E' MEMORIZZATO SENZA ZERI
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + PUB_ANNO + "'"
   x_cont = "con_conto = '" + XXX_CODCLI + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"CONTI","R")
      RETURN .F.
   ENDIF
   SELECT CONTI
   GO TOP
   IF EOF()
	  SELECT curs_CONTI
	  APPEND BLANK
	  REPLACE CON_SOC    WITH PUB_CODSOC
	  REPLACE CON_ANNO   WITH PUB_ANNO
	  REPLACE CON_CONTO  WITH XXX_CODCLI
	  REPLACE CON_DESCR  WITH M.CLI_RAGSOC
	  REPLACE CON_TIPOCO WITH 'C'
	  REPLACE CON_POSBIL WITH 'P'
   ENDIF

   SELECT CUR_CLIENTI
   SKIP +1

ENDDO

*!*	################################################# CREA PIANO DEI CONTI DA ANAGRAFICA FORNITORI #################################################

v_seek	= 'GEN' + PUB_CODSOC
v_chiave = "codice"
IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
   SELECT CUR_PARA
ELSE
   PUB_ERRORE=MESSAGEBOX('Parametro GEN'+CHR(13)+'inesistente',64,'*** ATTENZIONE ***')
   RETURN .F.
ENDIF

FFF=SUBSTR(LIBERA,18,4)

x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_cond = x_soci
cSql = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"CUR_FORNITORI")
   RETURN .F.
ENDIF
SELECT CUR_FORNITORI
GO TOP

CTRELAB = 0

DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF

   IF DELETED()
      SKIP +1
      LOOP
   ENDIF

   CPA=FOR_CONPAG

	V_ER = SOTTOGEN(FOR_NAZION)
	IF !V_ER
	    FF = PUB_FF
	ELSE
	    FFF= FFF
	ENDIF

   SELECT CUR_FORNITORI


   SCATTER MEMVAR MEMO

   XXX_CODFOR = FF + ALLTRIM(STR(VAL(M.FOR_CODCLI)))	&& TOGLIE GLI 0 NON SIGNIFICATIVI IN QUANTO IL FORNITORE NEL PIANO DEI CONTI E' MEMORIZZATO SENZA ZERI
   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + PUB_ANNO + "'"
   x_cont = "con_conto = '" + XXX_CODfor + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   cSql = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   IF !ExecRW(cSql,"CONTI","R")
      RETURN .F.
   ENDIF
   SELECT CONTI
   GO TOP
   IF EOF()
	  SELECT curs_CONTI
	  APPEND BLANK
	  REPLACE CON_SOC    WITH PUB_CODSOC
	  REPLACE CON_ANNO   WITH PUB_ANNO
	  REPLACE CON_CONTO  WITH XXX_CODFOR
	  REPLACE CON_DESCR  WITH M.FOR_RAGSOC
	  REPLACE CON_TIPOCO WITH 'F'
	  REPLACE CON_POSBIL WITH 'P'
   ENDIF

   SELECT CUR_FORNITORI
   SKIP +1

ENDDO



RETURN




