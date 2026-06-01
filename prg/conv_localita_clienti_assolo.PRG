*************************************************************************************************
*			  	             CONVERSIONE CODICI LOCALITA' CONSEGNA CLIENTI					    *
*							 																	*
*	by Sergio Piaggi per Project S.r.l.															*
*	Agosto 2013 : Cardioline 				 													*
*************************************************************************************************

**=> ERASMO - INIZIO 09/08/2022
LPARAMETERS _par_clifor

IF PCOUNT() >= 1
ELSE
	_par_clifor = 'C'
ENDIF
**=> ERASMO - FINE 09/08/2022

*** conferma utente

*RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei codici località consegna clienti ?",292,"ATTENZIONE")
RIT = MESSAGEBOX("Procedo con la conversione "+CHR(13)+"dei codici località consegna " + IIF(_par_clifor='C',"clienti","fornitori") + "?",292,"ATTENZIONE")  && ERASMO - 09/08/2022
IF RIT = 7
   =MESSAGEBOX("Operazione abbandonata",62,"ATTENZIONE")
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
_V_NOME_TABELLA_INPUT_ALTRI_RECAPITI = '[DATI ALTRI RECAPITI]' 
cSql = "Select * from "+_V_NOME_TABELLA_INPUT_ALTRI_RECAPITI 					&& ALTRI RECAPITI
IF !ExecCommand(cSql,"CU_INPUT")
  return(.f.)
ENDIF
SELECT CU_INPUT
INDEX ON Codice+STR(Progressivo) ADDITIVE TAG I_CODICE 
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
cSql = "Select * from U_LOC_AN where 1=0"
IF !ExecCommand(cSql,"CU_LOC_AN")
   return(.f.)
ENDIF
 
*** CANCELLAZIONE DEI RECORD DELLA TABELLA ZONE SQL 

WAIT WINDOWS "ATTENDERE PREGO, CANCELLAZIONE VECCHIA TABELLA località consegna clienti" NOWAIT
*cSql = "delete from U_LOC_AN where LOC_CF = 'C' "
*cSql = "delete from U_LOC_AN"
cSql = "delete from U_LOC_AN where LOC_CF = '" + _par_clifor + "'"  && ERASMO - 09/08/2022
IF !ExecCommand(cSql,"U_LOC_AN")
   return(.f.)
ENDIF



******** DEFINISCE LE VARIABILI E CREA IL CURSORE DI SUPPORTO
RELEASE _PROGRESSIVO_LOC,_CODICE_CLI_ATT,_CODICE_CLI_PRE
PUBLIC _PROGRESSIVO_LOC_CODICE_CLI_ATT,_CODICE_CLI_PRE
_PROGRESSIVO_LOC = 0

_CODICE_CLI_ATT	= ''
_CODICE_CLI_PRE = ''


RELEASE __DATINS,_CTR
PUBLIC __DATINS,_CTR
__DATINS = DTOC(DATE())
_CTR = 0


*!*	CAMPI DA CONVERTIRE
*!*	Codice
*!*	Progressivo
*!*	ARTitolo
*!*	ARRagioneSociale
*!*	ARIndirizzo
*!*	ARLocalità
*!*	ARProvincia
*!*	ARCap
*!*	ARTelefono
*!*	ARFax
*!*	ARInternet
*!*	ARBbs
*!*	ARRuolo
*!*	Tipo1
*!*	Tipo2
*!*	Note altro recapito



=DEFINISCE_VARIABILI()



***** ELABORA IL CURSORE transito PER CREARE IL CURSORE STP

SELECT CU_INPUT
GO TOP 
_CODICE_CLI_ATT	= ALLTRIM(CONV_CLEAR(Codice))
_CODICE_CLI_PRE	= ALLTRIM(CONV_CLEAR(Codice))
_PROGRESSIVO_LOC 	= 0 	


DO WHILE !EOF()

    IF DELETED()
       SELECT CU_INPUT   && scarto i record cancellati
       SKIP +1
       LOOP
    ENDIF 
    
    SCATTER MEMVAR MEMO
    
	_CODICE_CLI_ATT	= ALLTRIM(CONV_CLEAR(M.Codice))

	=CARICA_DATI_CLIENTE()
	
	**=> ERASMO - INIZIO 09/08/2022
	M.LOC_CF = _par_clifor
	DO CASE

		CASE _par_clifor = 'C'
	           
	           x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
	 	       x_codi = "cli_codcli = '" + ALLTRIM(M.LOC_CODCLI) + "'"
			   x_cond = x_soci + " and " + x_codi
	           Csql   = "select * from u_cli_an where " + x_cond
	           IF !ExecCommand(cSql,"cur_cliente__")
	              return(.f.)
	           ENDIF
	           SELECT cur_cliente__
	           GO TOP
	           
		CASE _par_clifor = 'F'

	           x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
	 	       x_codi = "for_codcli = '" + ALLTRIM(M.LOC_CODCLI) + "'"
			   x_cond = x_soci + " and " + x_codi
	           Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
	           IF !ExecCommand(cSql,"cur_fornitori__")
	              return(.f.)
	           ENDIF
	           SELECT cur_fornitori__
	           GO TOP			
	ENDCASE
	IF EOF()
	   SELECT CU_INPUT
	   DELETE
	   SKIP +1
	   LOOP
	ENDIF
	**=> ERASMO - FINE 09/08/2022

	=CARICA_DATI_DESTINAZIONE()		    

	=CARICA_DATI_INDIRIZZO()	
 		
	=CARICA_DATI_TELEFONO_FAX()	

   	
    SELECT CU_INPUT
	SKIP

ENDDO


	 
=MESSAGEBOX("OPERAZIONE TERMINATA CORRETTAMENTE ",62,"ATTENZIONE")

SET DEFAULT TO &PUB_DIR

RETURN

***********************************
FUNCTION CARICA_DATI_CLIENTE
***********************************

SELECT CU_INPUT
=DEFINISCE_VARIABILI()


M.CODICE1 	 		= ALLTRIM(CONV_CLEAR(M.Codice))
M.LOC_CODCLI 		= TRC(PUB_LCL,ALLTRIM(M.CODICE1))
M.LOC_RAGSOC 		= ALLTRIM(APITOSPA(CONV_CLEAR(M.ARRagioneSociale)))	
M.ID_UNIQUE      	= ""
M.LOC_CODSOC     	= PUB_CODSOC
*M.LOC_CF         	= "C"												&& CLIENTE
M.LOC_TRASME     	= SPACE(02)
M.LOC_DATINS     	= RIBALTA2(DTOC(DATE()))
M.SELEZIONE      	= SPACE(10)   	
M.LOC_VARIE      	= ""
M.LOC_INDIRI     	= ""	
M.LOC_CAP        	= ""	
M.LOC_LOCALI     	= ""
M.LOC_ATTENZIONE 	= ""
M.LOC_PROVIN     	= ""
M.LOC_GGEVAS     	= 0




RETURN

********************************* 
FUNCTION CARICA_DATI_DESTINAZIONE
*********************************

SELECT CU_INPUT

IF _CODICE_CLI_ATT <> _CODICE_CLI_PRE 
	_CODICE_CLI_PRE  = _CODICE_CLI_ATT 
	_PROGRESSIVO_LOC = 0
ENDIF

_PROGRESSIVO_LOC = _PROGRESSIVO_LOC + 1	
M.LOC_CODLOC 	 = STR(_PROGRESSIVO_LOC,3,0) 
IF LEN(ALLTRIM(M.LOC_CODLOC)) = 1
	M.LOC_CODLOC = "00"+ALLTRIM(M.LOC_CODLOC)
ENDIF

IF LEN(ALLTRIM(M.LOC_CODLOC)) = 2
	M.LOC_CODLOC = "0"+ALLTRIM(M.LOC_CODLOC)
ENDIF



RETURN


********************************* 
FUNCTION CARICA_DATI_INDIRIZZO
*********************************

SELECT CU_INPUT
M.LOC_INDIRI 		= ALLTRIM(APITOSPA(CONV_CLEAR(M.ARIndirizzo)))	
M.LOC_CAP    		= ALLTRIM(APITOSPA(CONV_CLEAR(M.ARCap)))	
M.LOC_LOCALI 		= ALLTRIM(APITOSPA(CONV_CLEAR(M.ARLocalità))) 
M.LOC_ATTENZIONE 	= ALLTRIM(APITOSPA(CONV_CLEAR(M.ARTitolo)))
M.LOC_PROVIN 		= ""
M.LOC_GGEVAS 		= 0
M.LOC_EMAIL 		= ALLTRIM(APITOSPA(CONV_CLEAR(M.ARInternet)))  && ERASMO - 05/05/2026

IF !EXECCOMMAND("SELECT * FROM COMUNI WHERE COMUNE='"+M.LOC_LOCALI+"' AND CAP='"+M.LOC_CAP+"'  ORDER BY COMUNE ","CURS_COMUNI")
   RETURN .F.
ENDIF
SELECT CURS_COMUNI
GO TOP
IF !EOF()
	M.LOC_PROVIN = CURS_COMUNI.PROVINCIA
ELSE
	IF !EXECCOMMAND("SELECT * FROM COMUNI WHERE COMUNE='"+M.LOC_LOCALI+"'  ORDER BY COMUNE ","CURS_COMUNI")
	   RETURN .F.
	ENDIF
	SELECT CURS_COMUNI
	GO TOP
	IF !EOF()
		M.LOC_PROVIN = CURS_COMUNI.PROVINCIA
	ENDIF
ENDIF



RETURN

********************************* 
FUNCTION CARICA_DATI_TELEFONO_FAX
*********************************

S_CARD_LOC_S=STR(SELECT())

SELECT CU_INPUT
_TELEFONO 	= ALLTRIM(APITOSPA(CONV_CLEAR(M.ARTelefono)))
_FAX      	= ALLTRIM(APITOSPA(CONV_CLEAR(ARFax))) 
M.LOC_VARIE = ""
IF !EMPTY(ALLTRIM(_TELEFONO))
	M.LOC_VARIE = "TEL: " + _TELEFONO 
ENDIF

IF !EMPTY(ALLTRIM(_FAX))
	M.LOC_VARIE = M.LOC_VARIE + " FAX: " + _FAX
ENDIF

M.LOC_CODSOC = PUB_CODSOC
M.LOC_TRASME = SPACE(02)
M.LOC_DATINS = RIBALTA2(DTOC(DATE()))
M.SELEZIONE  = SPACE(10)   	


SELECT CU_LOC_AN					&& CREAZIONE DEL CURSORE STP PER IL SUCCESSIVO AGGIORNAMENTO IN AMBIENTE SQL
APPEND BLANK
GATHER MEMVAR MEMO 						&& EFFETTUA LA REPLACE NEL CURSORE STP FOX SOSTITUENDO LE REPLACE DI OGNI SINGOLO CAMPO 


	 
****** AGGIORNA TABELLA U_LOC_AN  SQL
IF !ExecRW('','U_LOC_AN','I','','CU_LOC_AN')
   return(.f.)
ENDIF


****** DEFINIZIONE DEI CURSORI STP
cSql = "Select * from U_LOC_AN where 1=0"
IF !ExecCommand(cSql,"CU_LOC_AN")
   return(.f.)
ENDIF
SELECT CU_LOC_AN
	 
_CTR = _CTR +1
WAIT WINDOWS "RECORDS SCRITTI : "+STR(_CTR,10,0) NOWAIT


SELECT &S_CARD_LOC_S


RETURN

****************************
FUNCTION DEFINISCE_VARIABILI
****************************

RELEASE M.LOC_CODSOC 
RELEASE M.LOC_CODLOC 
RELEASE M.LOC_CODCLI 
RELEASE M.LOC_RAGSOC 
RELEASE M.LOC_LOCALI 
RELEASE M.LOC_INDIRI 
RELEASE M.LOC_CAP    
RELEASE M.LOC_CF     
RELEASE M.LOC_PROVIN 
RELEASE M.LOC_TRASME 
RELEASE M.LOC_DATINS 
RELEASE M.LOC_GGEVAS 
RELEASE M.LOC_ATTENZIONE   
RELEASE M.LOC_VARIE   
RELEASE M.LOC_EMAIL  && ERASMO - 05/05/2026

PUBLIC M.LOC_CODSOC 
PUBLIC M.LOC_CODLOC 
PUBLIC M.LOC_CODCLI 
PUBLIC M.LOC_RAGSOC 
PUBLIC M.LOC_LOCALI 
PUBLIC M.LOC_INDIRI 
PUBLIC M.LOC_CAP    
PUBLIC M.LOC_CF     
PUBLIC M.LOC_PROVIN 
PUBLIC M.LOC_TRASME 
PUBLIC M.LOC_DATINS 
PUBLIC M.LOC_GGEVAS 
PUBLIC M.LOC_ATTENZIONE   
PUBLIC M.LOC_VARIE
PUBLIC M.LOC_EMAIL  && ERASMO - 05/05/2026

M.LOC_CODSOC = PUB_CODSOC
M.LOC_CODLOC = ""
M.LOC_CODCLI = ""
M.LOC_RAGSOC = ""
M.LOC_LOCALI = ""
M.LOC_INDIRI = ""
M.LOC_CAP    = ""
M.LOC_CF     = ""
M.LOC_PROVIN = ""
M.LOC_TRASME = ""
M.LOC_DATINS = ""
M.LOC_GGEVAS = 0
M.LOC_ATTENZIONE = ""   
M.LOC_VARIE = "" 
M.LOC_EMAIL = ""  && ERASMO - 05/05/2026


RETURN

