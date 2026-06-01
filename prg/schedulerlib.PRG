*!*	##############################################################################################################
  
					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA DELLE APPLICAZIONI SCHEDULATE                           ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################
  





DEFINE CLASS AqSchedulerTimerMaster AS Timer
	
	PROCEDURE Timer
		
		DO VERIFICA_TIMERS
		
	ENDPROC
	
ENDDEFINE


DEFINE CLASS AqSchedulerDynamicTimer AS Timer
	
	InEsecuzione = .F.
	
	PROCEDURE Timer
	
		DO VERIFICA_FUNZIONE WITH THIS
		
	ENDPROC
	
ENDDEFINE



*************************
PROCEDURE VERIFICA_TIMERS
*************************
*** CREA/RILASCIA N TIMER PER OGNI RIGA DELLA TABELLA SCHEDULER

IF USED("TMP_SCHEDULER")
	SELECT TMP_SCHEDULER
	USE
ENDIF

*IF !EXECCOMMAND("SELECT * FROM SCHEDULER","TMP_SCHEDULER")
**=> ERASMO - INIZIO 10/12/2024
*** CERCO SOLO LE FUNZIONI GENERICHE (SCHEDULER.SERVICENAME = '') O SPECIFICHE DI QUEL DETERMINATO SERVIZIO IN ESECUZIONE (ES. SCHEDULER.SERVICENAME = 'AQ_SERVICE.EXE', OPPURE SCHEDULER.SERVICENAME = 'AQ_SERVICE_PREORDINI.EXE')
IF !ExecCommand("SELECT * FROM SCHEDULER WHERE SERVICENAME = '' OR SERVICENAME = '" + ALLTRIM(JUSTSTEM(SYS(16,0))) + "'","TMP_SCHEDULER")
**=> ERASMO - FINE 10/12/2024
	RETURN .F.
ENDIF

*** TRA TUTTI GLI OGGETTI DEL CONTENITORE _SCREEN VERIFICO SE ESISTONO DEI TIMER CHE IN REALTA' NON ESISTONO PIU' SULLA TABELLA SCHEDULER
*** IN QUANTO L'UTENTE NEL FRATTEMPO POTREBBE AVERLI ELIMINATI: IN TAL CASO LI RIMUOVO
LOCAL _i
IF _SCREEN.ControlCount > 0
	FOR _i = 1 TO _SCREEN.ControlCount
		IF TYPE("_SCREEN.Controls(_i)") == 'O' AND !ISNULL(_SCREEN.Controls(_i))
			IF _SCREEN.Controls(_i).BaseClass = "Timer"
				_nomeTimer = _SCREEN.Controls(_i).Name
				IF UPPER(ALLTRIM(_nomeTimer)) == UPPER("AqSchedulerTimerMasterM")
					LOOP
				ENDIF
				IF USED("XX_TMP_SCHEDULER")
					SELECT XX_TMP_SCHEDULER
					USE
				ENDIF
				SELECT "Timer" + ALLTRIM(ID_FUNZIONE) AS NOME_TIMER FROM TMP_SCHEDULER ;
					WHERE UPPER("Timer" + ALLTRIM(ID_FUNZIONE)) == UPPER(ALLTRIM(_nomeTimer)) INTO CURSOR XX_TMP_SCHEDULER
				SELECT XX_TMP_SCHEDULER
				GO TOP
				IF EOF()
					_SCREEN.RemoveObject(_nomeTimer)
					*WAIT WINDOWS "Oggetto " + _nomeTimer + " RIMOSSO" NOWAIT
				ENDIF
				USE
			ENDIF
		ENDIF
	ENDFOR
ENDIF

SELECT TMP_SCHEDULER
GO TOP
SCAN
	_nomeTimer = "Timer" + ALLTRIM(ID_FUNZIONE)
	_cObject = "_SCREEN."+_nomeTimer
	
	IF TYPE(_cObject) == "O"  && ESISTE GIA' L'OGGETTO TIMER CON NOME _cObject???
	ELSE
		_SCREEN.AddObject(_nomeTimer,"AqSchedulerDynamicTimer")
		
		*WAIT WINDOWS "Oggetto " + _nomeTimer + " AGGIUNTO" NOWAIT
		
		_cCommand = "_SCREEN."+_nomeTimer+".Interval = 1000"
		&_cCommand
		_cCommand = "_SCREEN."+_nomeTimer+".Tag = '" + ALLTRIM(ID_FUNZIONE) + "'"
		&_cCommand
	ENDIF
	
ENDSCAN

SELECT TMP_SCHEDULER
USE


ENDPROC



********************************
PROCEDURE VERIFICA_FUNZIONE
********************************
LPARAMETERS _par_oggetto_timer

LOCAL _NOME_TIMER,_ID_FUNZIONE,_NOME_CURSORE

_NOME_TIMER = _par_oggetto_timer.name
_ID_FUNZIONE = _par_oggetto_timer.tag
*_NOME_CURSORE = "TMP_FUNZIONE" + SYS(2015)
_NOME_CURSORE = "F" + SYS(2015)

*_par_oggetto_timer.INTERVAL = 0

*DO SCRIVI_FILE_TESTO WITH _par_oggetto_timer,"FASE 1: ENTRATO IN PROCEDURA 'VERIFICA_FUNZIONE'"

IF USED(_NOME_CURSORE)
	SELECT &_NOME_CURSORE
	USE
ENDIF
IF !ExecCommand("SELECT * FROM SCHEDULER WHERE ID_FUNZIONE = '" + _ID_FUNZIONE + "'",_NOME_CURSORE)
	RETURN .F.
ENDIF
SELECT &_NOME_CURSORE
GO TOP
IF EOF()
	USE
	RETURN
ENDIF


****** ESECUZIONE ISTANTANEA PER I JOB IN STATO "ESEGUI" E CAMBIO DI STATO********************
*IF STATO = "ESEGUI"
IF UPPER(ALLTRIM(STATO)) = "ESEGUI"  && ERASMO - 07/02/2023
	_par_oggetto_timer.InEsecuzione = .T.

	__PROGRAMMA   = PROGRAMMA  
	__GO_EMAIL    = GO_EMAIL   
	__ID_FUNZIONE = ID_FUNZIONE

	_cCommand = "DO PRG\PROGRAMMA_SCHEDULATO WITH ALLTRIM(__PROGRAMMA),__GO_EMAIL,__ID_FUNZIONE,_par_oggetto_timer"
	&_cCommand
	_par_oggetto_timer.InEsecuzione = .F.
	
	IF !ExecCommand("UPDATE SCHEDULER SET STATO = 'ATTIVO' WHERE ID_FUNZIONE = '" + _ID_FUNZIONE + "'",_NOME_CURSORE)
		RETURN .F.
	ENDIF


	RETURN
ENDIF
****** ESECUZIONE ISTANTANEA PER I JOB IN STATO "ESEGUI" E CAMBIO DI STATO********************

**=> ERASMO - INIZIO 07/02/2023
*** ESECUZIONI SCHEDULATE SOLO SE STATO "ATTIVO"
SELECT &_NOME_CURSORE
GO TOP
IF UPPER(ALLTRIM(STATO)) = "ATTIVO"
ELSE
	USE
	RETURN
ENDIF
**=> ERASMO - FINE 07/02/2023

IF RIBALTA2(DTOC(DATE())) >= PERIDAL AND RIBALTA2(DTOC(DATE())) <= PERIAL
ELSE
	USE
	RETURN
ENDIF

LOCAL __PROGRAMMA,__GO_EMAIL,__ID_FUNZIONE, ;
	__LU_TIME1,__LU_TIME2,__LU_TIME3,__LU_TIME4, ;
	__MA_TIME1,__MA_TIME2,__MA_TIME3,__MA_TIME4, ;
	__ME_TIME1,__ME_TIME2,__ME_TIME3,__ME_TIME4, ;
	__GI_TIME1,__GI_TIME2,__GI_TIME3,__GI_TIME4, ;
	__VE_TIME1,__VE_TIME2,__VE_TIME3,__VE_TIME4, ;
	__SA_TIME1,__SA_TIME2,__SA_TIME3,__SA_TIME4, ;
	__DO_TIME1,__DO_TIME2,__DO_TIME3,__DO_TIME4
	
SELECT &_NOME_CURSORE
GO TOP
__PROGRAMMA   = PROGRAMMA  
__GO_EMAIL    = GO_EMAIL   
__ID_FUNZIONE = ID_FUNZIONE
__LU_TIME1    = LU_TIME1   
__LU_TIME2    = LU_TIME2   
__LU_TIME3    = LU_TIME3   
__LU_TIME4    = LU_TIME4   
__MA_TIME1    = MA_TIME1   
__MA_TIME2    = MA_TIME2   
__MA_TIME3    = MA_TIME3   
__MA_TIME4    = MA_TIME4   
__ME_TIME1    = ME_TIME1   
__ME_TIME2    = ME_TIME2   
__ME_TIME3    = ME_TIME3   
__ME_TIME4    = ME_TIME4   
__GI_TIME1    = GI_TIME1   
__GI_TIME2    = GI_TIME2   
__GI_TIME3    = GI_TIME3   
__GI_TIME4    = GI_TIME4   
__VE_TIME1    = VE_TIME1   
__VE_TIME2    = VE_TIME2   
__VE_TIME3    = VE_TIME3   
__VE_TIME4    = VE_TIME4   
__SA_TIME1    = SA_TIME1   
__SA_TIME2    = SA_TIME2   
__SA_TIME3    = SA_TIME3   
__SA_TIME4    = SA_TIME4   
__DO_TIME1    = DO_TIME1   
__DO_TIME2    = DO_TIME2   
__DO_TIME3    = DO_TIME3   
__DO_TIME4    = DO_TIME4

__TIPO_ELAB   = TIPO_ELAB
__GGMMHH      = GGMMHH

SELECT &_NOME_CURSORE
USE

IF __TIPO_ELAB = 1  && ELABORAZIONE SETTIMANALE

	LOCAL _W_XX_TIME,_W_NN_GIORNO_SETT,_W_XX_GIORNO_SETT,_cNomeCampo,_ii
	_W_XX_TIME = TIME()
	_W_NN_GIORNO_SETT = DOW(DATE())
	_W_XX_GIORNO_SETT = ""
	DO CASE
	   CASE _W_NN_GIORNO_SETT = 1
	      _W_XX_GIORNO_SETT = "DO"
	   CASE _W_NN_GIORNO_SETT = 2
	      _W_XX_GIORNO_SETT = "LU"
	   CASE _W_NN_GIORNO_SETT = 3
	      _W_XX_GIORNO_SETT = "MA"
	   CASE _W_NN_GIORNO_SETT = 4
	      _W_XX_GIORNO_SETT = "ME"
	   CASE _W_NN_GIORNO_SETT = 5
	      _W_XX_GIORNO_SETT = "GI"
	   CASE _W_NN_GIORNO_SETT = 6
	      _W_XX_GIORNO_SETT = "VE"
	   CASE _W_NN_GIORNO_SETT = 7
	      _W_XX_GIORNO_SETT = "SA"
	ENDCASE

	LOCAL _TIMER_DB,_TIMER_NOW

	FOR _ii = 1 TO 4
		_cNomeVar = "__" + _W_XX_GIORNO_SETT + "_TIME" + ALLTRIM(STR(_ii))
		IF EMPTY(&_cNomeVar) OR &_cNomeVar = "  :  :  "
		ELSE
			_TIMER_DB  = CTOT(&_cNomeVar)
			_TIMER_NOW = CTOT(_W_XX_TIME)
			IF !_par_oggetto_timer.InEsecuzione
				IF _TIMER_NOW - _TIMER_DB >= 0 AND _TIMER_NOW - _TIMER_DB <= 2
					_par_oggetto_timer.InEsecuzione = .T.
					*** ADESSO FAI QUELLO CHE VUOI !!!
					
					*DO SCRIVI_FILE_TESTO WITH _par_oggetto_timer,"FASE 2.1: ENTRATO NELLA CONDIZIONE DEL RICHIAMO ALLA PROCEDURA 'ELABORA_PROGRAMMA_SCHEDULATO' IN PROCEDURA 'VERIFICA_FUNZIONE' CON I PARAMETRI:" + CHR(13) + CHR(10) + ;
						"1°: " + ALLTRIM(__PROGRAMMA) + CHR(13) + CHR(10) + ;
						"2°: " + ALLTRIM(__GO_EMAIL) + CHR(13) + CHR(10) + ;
						"3°: " + ALLTRIM(__ID_FUNZIONE)
					
					*DO ELABORA_PROGRAMMA_SCHEDULATO WITH ALLTRIM(__PROGRAMMA),__GO_EMAIL,__ID_FUNZIONE,_par_oggetto_timer
					
	*!*					LOCAL old_sqlhd
	*!*					old_sqlhd = pub_sqlhd
	*!*					DO AQ_PROGRAMMA_SCHEDULATO WITH PUB_CODOPE,PUB_NOMEDB,ALLTRIM(__PROGRAMMA),__GO_EMAIL,__ID_FUNZIONE,_par_oggetto_timer  && ERASMO - 15/12/2014
	*!*					pub_sqlhd = old_sqlhd

*!*						_cCommand = "SET PROCEDURE TO PRG\PROGRAMMA_SCHEDULATO ADDITIVE"
*!*						&_cCommand
					_cCommand = "DO PRG\PROGRAMMA_SCHEDULATO WITH ALLTRIM(__PROGRAMMA),__GO_EMAIL,__ID_FUNZIONE,_par_oggetto_timer"
					&_cCommand
*!*						_cCommand = "RELEASE PROCEDURE PRG\PROGRAMMA_SCHEDULATO"
*!*						&_cCommand
					
					_par_oggetto_timer.InEsecuzione = .F.
				ENDIF
			ENDIF
		ENDIF
	NEXT

ENDIF

IF __TIPO_ELAB = 2  && ELABORAZIONE MENSILE

	LOCAL _W_XX_TIME,_W_NN_GIORNO_SETT,_W_XX_GIORNO_SETT,_cNomeCampo,_ii
	_W_XX_TIME = TIME()
	_W_XX_GIORNO_MESE = SUBSTR(DTOC(DATE()),1,2)
	_W_NN_MESE = VAL(SUBSTR(DTOC(DATE()),4,2))
	_W_XX_MESE = ""
	DO CASE
	   CASE _W_NN_MESE = 1
	      _W_XX_MESE = "GEN"
	   CASE _W_NN_MESE = 2
	      _W_XX_MESE = "FEB"
	   CASE _W_NN_MESE = 3
	      _W_XX_MESE = "MAR"
	   CASE _W_NN_MESE = 4
	      _W_XX_MESE = "APR"
	   CASE _W_NN_MESE = 5
	      _W_XX_MESE = "MAG"
	   CASE _W_NN_MESE = 6
	      _W_XX_MESE = "GIU"
	   CASE _W_NN_MESE = 7
	      _W_XX_MESE = "LUG"
	   CASE _W_NN_MESE = 8
	      _W_XX_MESE = "AGO"
	   CASE _W_NN_MESE = 9
	      _W_XX_MESE = "SET"
	   CASE _W_NN_MESE = 10
	      _W_XX_MESE = "OTT"
	   CASE _W_NN_MESE = 11
	      _W_XX_MESE = "NOV"
	   CASE _W_NN_MESE = 12
	      _W_XX_MESE = "DIC"
	ENDCASE
	
	LOCAL _STRINGA_TIMER,_STRINGA_TIMER_MENO_1,_STRINGA_TIMER_MENO_2,_STRINGA_TIMER_MENO_3,_STRINGA_TIMER_MENO_4,_STRINGA_TIMER_MENO_5, ;
		_STRINGA_TIMER_PIU_1,_STRINGA_TIMER_PIU_2,_STRINGA_TIMER_PIU_3,_STRINGA_TIMER_PIU_4,_STRINGA_TIMER_PIU_5
	
	*** TOLLERANZA DI + O - 2 SECONDI
	
	IF _W_XX_TIME = "00:00:00"
		_W_XX_TIME = TTOC(CTOT(_W_XX_TIME)+2,2)
	ENDIF
	IF _W_XX_TIME = "23:59:59"
		_W_XX_TIME = TTOC(CTOT(_W_XX_TIME)-2,2)
	ENDIF
	
	_STRINGA_TIMER = _W_XX_GIORNO_MESE + " " + _W_XX_MESE + " alle ore " + ALLTRIM(_W_XX_TIME)
	_STRINGA_TIMER_MENO_1 = _W_XX_GIORNO_MESE + " " + _W_XX_MESE + " alle ore " + TTOC(CTOT(_W_XX_TIME)-1,2)
	_STRINGA_TIMER_MENO_2 = _W_XX_GIORNO_MESE + " " + _W_XX_MESE + " alle ore " + TTOC(CTOT(_W_XX_TIME)-2,2)
	_STRINGA_TIMER_PIU_1 = _W_XX_GIORNO_MESE + " " + _W_XX_MESE + " alle ore " + TTOC(CTOT(_W_XX_TIME)+1,2)
	_STRINGA_TIMER_PIU_2 = _W_XX_GIORNO_MESE + " " + _W_XX_MESE + " alle ore " + TTOC(CTOT(_W_XX_TIME)+2,2)

	IF !_par_oggetto_timer.InEsecuzione
		IF 	_STRINGA_TIMER $ __GGMMHH OR ;
			_STRINGA_TIMER_MENO_1 $ __GGMMHH OR ;
			_STRINGA_TIMER_MENO_2 $ __GGMMHH OR ;
			_STRINGA_TIMER_PIU_1 $ __GGMMHH OR ;
			_STRINGA_TIMER_PIU_2 $ __GGMMHH
		
			_par_oggetto_timer.InEsecuzione = .T.
			
			_cCommand = "SET PROCEDURE TO PRG\PROGRAMMA_SCHEDULATO ADDITIVE"
			&_cCommand
			_cCommand = "DO PRG\PROGRAMMA_SCHEDULATO WITH ALLTRIM(__PROGRAMMA),__GO_EMAIL,__ID_FUNZIONE,_par_oggetto_timer"
			&_cCommand
			_cCommand = "RELEASE PROCEDURE PRG\PROGRAMMA_SCHEDULATO"
			&_cCommand
			
			_par_oggetto_timer.InEsecuzione = .F.
		ENDIF
	ENDIF

ENDIF

*DO SCRIVI_FILE_TESTO WITH _par_oggetto_timer,"FASE 3: USCITA DA PROCEDURA 'VERIFICA_FUNZIONE'"

ENDPROC



********************************
PROCEDURE SCRIVI_FILE_TESTO 
********************************
LPARAMETERS _par_oggetto_timer,_par_commento

LOCAL _NOME_TIMER,_ID_FUNZIONE,_NOME_CURSORE

_NOME_TIMER = _par_oggetto_timer.name
_ID_FUNZIONE = _par_oggetto_timer.tag

_ACT_SEL = SELECT()

LOCAL _X_FILENAME,V_FILE,_STRINGA

_X_FILENAME = "D:\TEST_TIMER\FILE_TIMER_" + STRTRAN(DTOC(DATE()),'/','-')+"_"+STRTRAN(TIME(),':','-') + "_" + STRTRAN(TRANSFORM(SECONDS()),',','_') + SYS(2015) + ".TXT"

IF FILE(_X_FILENAME)
	_cEraseExistingFile = "ERASE '" + _X_FILENAME + "'"
	&_cEraseExistingFile
ENDIF
V_FILE = FCREATE(_X_FILENAME)

_STRINGA = 	"NOME TIMER: " + ALLTRIM(_NOME_TIMER) + CHR(13) + CHR(10) + ;
			"ID FUNZIONE: " + ALLTRIM(_ID_FUNZIONE) + CHR(13) + CHR(10) + ;
			"GENERATO ALLE ORE: " + TIME() + CHR(13) + CHR(10) + ;
			"COMMENTO: " + ALLTRIM(_par_commento)

FPUTS(V_FILE,_STRINGA)
=FCLOSE(V_FILE)

SELECT(_ACT_SEL)
	
ENDPROC





*!*	################################################################################################################################################################

*********************************************************************************************
FUNCTION SetHomeDB
*********************************************************************************************

IF !SwicthDBConnection(PUB_NOMEDB)
	RETURN (.f.)
ENDIF 

RETURN .t.
*********************************************************************************************


*********************************************************************************************
FUNCTION SwicthDBConnection
*********************************************************************************************
PARAMETERS V_NOMEDB

IF !FILE("STRINGSQL.DBF")
  	=MESSAGEBOX("Errore connessione SQL",16,"*** ATTENZIONE ***")
	RETURN(.f.)
ELSE
  SELECT ALLTRIM(STRINGA) AS cString FROM STRINGSQL WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED() INTO CURSOR _TMP
  IF _TALLY = 0
		=MESSAGEBOX("Errore connessione SQL",16,"*** ATTENZIONE ***")
		RETURN(.f.)
  ELSE
		SELECT _TMP
		
		IF "DRIVER=" $ V_NOMEDB .AND. "SERVER=" $ V_NOMEDB .AND. "UID=" $ V_NOMEDB .AND. "PWD=" $ V_NOMEDB .AND. "DATABASE=" $ V_NOMEDB  && ERASMO - 07/09/2009
			
			*** NEL PARAMETRO E' DEFINITA TUTTA LA STRINGA DI CONNESSIONE
			
			cString=ALLTRIM(V_NOMEDB)
		
		ELSE
		
			*** AGGIORNO SOLO LA PARTE RELATIVA AL NOME DB NELLA STRINGA DI CONNESSIONE
		
			V_PREFIX=SUBSTR(cString,1,AT("DATABASE=",cString)-1)
			V_SUFFIX=SUBSTR(cString,AT("DATABASE=",cString))
			V_SUFFIX=SUBSTR(V_SUFFIX,AT(";",V_SUFFIX))
			cString=ALLTRIM(V_PREFIX+"DATABASE="+V_NOMEDB+V_SUFFIX)
			
		ENDIF
			
		UPDATE STRINGSQL SET STRINGA=cString WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED()		
		SQLDISCONNECT(pub_sqlhd)
		pub_sqlhd =0
  ENDIF
ENDIF

IF !ExecConnect()
	RETURN(.f.)
ENDIF 

RETURN(.t.)

*********************************************************************************************
FUNCTION ExecConnect
*********************************************************************************************
* -->> Esegue la connessione a Sql server utilizzando i parametri presenti nella tabella
* -->> Visual FoxPro presente nella cartella locale.
*
* -->> Se non esiste la tabella Viasual FoxPro locale, questa viene creata automaticamente
* -->> e vengono inseriti i dati prelevati da stinga di connessione ritornata dalla popap 
* -->> del Driver di connessione.
*
* -->> Il canale di connessione restituito è inserito nella variabile pubblica PUB_SQLHD.
*********************************************************************************************

IF !FILE("STRINGSQL.DBF")
   cString = ""
   DO VerificaDbsocieta WITH "cString"
   pub_sqlhd = SQLSTRINGCONNECT(cString)
   cString = SQLGETPROP(pub_sqlhd, 'CONNECTSTRING')
   CREATE TABLE STRINGSQL(ID_DATA C(10),CONNDEF C(1),DE_NAME C(100),ID_WRK C(100),STRINGA C(200))
   INSERT INTO STRINGSQL (ID_DATA,CONNDEF,DE_NAME,ID_WRK,STRINGA) VALUES ('SQL','S','User system',SYS(0),cString)
   
   SELECT ALLTRIM(STRINGA) AS cString FROM STRINGSQL WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED() INTO CURSOR _TMP  && ERASMO - 09/09/2009
ELSE
   SELECT ALLTRIM(STRINGA) AS cString FROM STRINGSQL WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED() INTO CURSOR _TMP
   IF _TALLY = 0
      cString = ""
      DO VerificaDbsocieta WITH "cString"
      pub_sqlhd = SQLSTRINGCONNECT(cString)
      cString = SQLGETPROP(pub_sqlhd, 'CONNECTSTRING')
      INSERT INTO STRINGSQL (ID_DATA,CONNDEF,DE_NAME,ID_WRK,STRINGA) VALUES ('SQL','S','User system',SYS(0),cString)
   ELSE
	  pub_sqlhd = SQLSTRINGCONNECT(_TMP.cString)
      IF pub_sqlhd < 0
      	=MESSAGEBOX("Errore connessione SQL",16,"*** ATTENZIONE ***")
		RETURN(.f.)
	  ENDIF
   ENDIF
ENDIF

pub_datawh = _TMP.cString

RETURN(.t.)

*********************************************************************************************
FUNCTION ExecPreparedCommand
*********************************************************************************************
PARAMETERS _stringsql,_nomesql
IF pub_sqlhd < 1
	IF !ExecConnect()
	  return(.f.)
	ENDIF 
ENDIF

**=> ERASMO - INIZIO 12/02/2013
IF TYPE("PUB_LOGSQL") == 'L' AND PUB_LOGSQL AND _nomesql <> 'LOGSQL'
	_nLogSqlSecondsIni = SECONDS()
ENDIF
**=> ERASMO - FINE 12/02/2013

= SQLPREPARE(pub_sqlhd, _stringsql,_nomesql)
_RT=SQLEXEC(pub_sqlhd)
IF _RT < 0
	=MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
*	SQLDISCONNECT(pub_sqlhd)
*	pub_sqlhd=0
	RETURN(.f.)
ENDIF

**=> ERASMO - INIZIO 12/02/2013
IF TYPE("PUB_LOGSQL") == 'L' AND PUB_LOGSQL AND _nomesql <> 'LOGSQL'
	_nLogSqlSecondsFin = SECONDS()
	_nLogSqlDeltaSeconds = _nLogSqlSecondsFin - _nLogSqlSecondsIni
	IF _nLogSqlDeltaSeconds >= 1
		ASTACKINFO(ArrayStackInfo)
		_nStackLevels = ALEN(ArrayStackInfo, 1)
		_nCallingLevel = _nStackLevels - 1
		DO WriteLogSql WITH ALLTRIM(_stringsql)
	ENDIF
ENDIF
**=> ERASMO - FINE 12/02/2013

RETURN(.t.)

*********************************************************************************************
* Eof FUNCTION ExecPreparedCommand
*********************************************************************************************


*********************************************************************************************
* Begin PROCEDURE InitializeStringsql
*********************************************************************************************
PROCEDURE VerificaDbsocieta
*********************************************************************************************
PARAMETERS _cString_name

&_cString_name = ""

DO WHILE .T.
   IF FILE("DBSOCIETA.DBF")
      IF !USED("DBSOCIETA")
         USE DBSOCIETA IN 0 AGAIN SHARED
      ENDIF
      SELECT DBSOCIETA
      GO TOP
      V_CONTARECORD=0

      DO WHILE !EOF()

      	IF DELETED()
            SKIP
            LOOP
      	ENDIF
      	
      	V_CONTARECORD=V_CONTARECORD+1

      	SKIP
      ENDDO
         
      IF V_CONTARECORD = 0
         _RISP = MESSAGEBOX("File DBSOCIETA.DBF vuoto",16,"Attenzione")
         QUIT
      ELSE
      	SELECT TOP 1 * FROM DBSOCIETA ORDER BY CODICE INTO CURSOR TMPDBSOC
       	SELECT TMPDBSOC
       	GO TOP
       	&_cString_name = ALLTRIM(NOMEDB)
       	USE
       	EXIT
      ENDIF
   ELSE
      MESSAGEBOX("File DBSOCIETA.DBF inesistente per lo startup di Aquarius su questa postazione",16,"*** ATTENZIONE ***")
      QUIT
   ENDIF
ENDDO
   
RETURN
*********************************************************************************************
* End PROCEDURE InitializeStringsql
*********************************************************************************************

*********************************************************************************************
FUNCTION ExecCommand
*********************************************************************************************
* -->> Esegue il comando specificata nel parametro << _stringsql >>.
* -->> Il cursore STP ritornato dalla query avrà il nome specificato in << _nomesql >>.
* -->> Prima di eseguire la query, effettua la verifica del canale di connesione e se 
* -->> non ancora aperto, effettua la connessione.
* -->> Se passato il terzo parametro _canstop = .T. mostra una finestra che permette
* -->> l'annullo dell'esecuzione SQL
*********************************************************************************************

*PARAMETERS _stringsql,_nomesql
PARAMETERS _stringsql,_nomesql,_canstop,_NomeVarStopped  && ERASMO - 12/07/2024

IF pub_sqlhd < 1
	IF !ExecConnect()
	  return(.f.)
	ENDIF
ENDIF

_canstop = .F.			&& ERASMO - 12/07/2024
_NomeVarStopped = ""	&& ERASMO - 12/07/2024

_RT=SQLEXEC(pub_sqlhd, _stringsql, _nomesql)
IF _RT < 0
	=MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
*	SQLDISCONNECT(pub_sqlhd)
*	pub_sqlhd=0
	RETURN(.f.)
ENDIF

RETURN(.t.)

*********************************************************************************************
* Eof FUNCTION ExecCommand
*********************************************************************************************




*********************************************************************************************
FUNCTION ExecRW
*********************************************************************************************
* -->> Esegue la creazione ed il settaggio del cursore STP con il parametro << _tipoexec >>
* -->> settato con 'R' o 'r' (Read).
* -->> Esegue l'aggiornamento della tabella relativa al cursore STP specificato
* -->> in << _nomesql >> se il parametro << _tipoexec >> è settato a 'W' o 'w' (Write).
* -->> E' possibile indicizzare il cursore inserendo le istruzioni per la creazione 
* -->> degli indici nel parametro << _indexed >> separati dal carattere << ; >>
* -->> esempio: _indexed="INDEX ON CLI_CODSOC+CLI_CODCLI TAG U_CLI_AN ADDITIVE"
* -->>          _indexed=_indexed+";"+"INDEX ON CLI_RAGSOC TAG U_CLI_RG ADDITIVE"  
*********************************************************************************************
PARAMETERS _stringsql,_nomesql,_tipoexec,_indexed,_nomecur

DO CASE 
	CASE _tipoexec $ "R.r"			&& Crea il cursore STP
	    IF !ExecCommand(_stringsql,_nomesql)
	      RETURN (.f.)
	    ENDIF 
		SELECT &_nomesql
		xx=AFIELDS(tf)
		UpdateNameList=""
		UpdatableFieldList=""
		FOR h=1 TO xx
		   IF EMPTY(UpdateNameList)
		     UpdateNameList=tf[h,1]+" "+ALIAS(SELECT())+"."+tf[h,1]
		   ELSE
		     UpdateNameList=UpdateNameList+","+tf[h,1]+" "+ALIAS(SELECT())+"."+tf[h,1]
		   ENDIF
		   IF EMPTY(UpdatableFieldList)
		     UpdatableFieldList=tf[h,1]
		   ELSE
		     UpdatableFieldList=UpdatableFieldList+","+tf[h,1]
		   ENDIF
		NEXT

		IF !EMPTY(_indexed)
			_nIndex=OCCURS(_indexed,';')+1
			FOR y=1 TO _nIndex
				_IndexComm=str_extract(_indexed,';',y)
				&_IndexComm
			NEXT 
		ENDIF 

		* -->> Setto le proprietà del cursore STP
		* --------------------------------------------
		a1=CURSORSETPROP("Buffering" , 5,_nomesql)
		a2=CURSORSETPROP("UpdateNameList" , UpdateNameList,_nomesql)
		a3=CURSORSETPROP("UpdatableFieldList", UpdatableFieldList, _nomesql)
		a4=CURSORSETPROP("KeyFieldList" , "ID_unique", _nomesql)
		a5=CURSORSETPROP("Tables" , _nomesql, _nomesql)
		a6=CURSORSETPROP("WhereType" , 1, _nomesql)
		a7=CURSORSETPROP("SendUpdates" , .T., _nomesql)

	CASE _tipoexec $ "W.w"			&& Aggiorna la tabella SQL con il cursore STP
	
		**=> ERASMO - INIZIO 15/01/2013
		IF TYPE("PUB_LOGSQL") == 'L' AND PUB_LOGSQL AND _nomesql <> 'LOGSQL'
			_nLogSqlSecondsIni = SECONDS()
		ENDIF
		**=> ERASMO - FINE 15/01/2013
		
		DO BlackBox WITH "",_nomesql,"EXECRW_W",_nomesql  && ERASMO - 17/04/2013
		
		IF !TABLEUPDATE(2, .T., _nomesql)
			MESSAGEBOX(MESSAGE())
			TABLEREVERT(.T.,_nomesql)
			RETURN(.f.)
		ENDIF
		USE IN &_nomesql
		
		**=> ERASMO - INIZIO 15/01/2013
		IF TYPE("PUB_LOGSQL") == 'L' AND PUB_LOGSQL AND _nomesql <> 'LOGSQL'
			_nLogSqlSecondsFin = SECONDS()
			_nLogSqlDeltaSeconds = _nLogSqlSecondsFin - _nLogSqlSecondsIni
			IF _nLogSqlDeltaSeconds >= 1
				ASTACKINFO(ArrayStackInfo)
				_nStackLevels = ALEN(ArrayStackInfo, 1)
				_nCallingLevel = _nStackLevels - 1
				DO WriteLogSql WITH ALLTRIM(_stringsql)
			ENDIF
		ENDIF
		**=> ERASMO - FINE 15/01/2013

	CASE _tipoexec $ "I.i"			&& Inserisco dati su tabella SQL senza cursore STP
	    
		SELECT &_nomecur
		xx=AFIELDS(tf)
		UpdateVarList=""
		UpdatableFieldList=""
		FOR h=2 TO xx
		   * -->> elenco delle variabili
		   * ---------------------------------------
		   IF EMPTY(UpdateVarList)
		     UpdateVarList="?_"+tf[h,1]
		   ELSE
		     UpdateVarList=UpdateVarList+",?_"+tf[h,1]
		   ENDIF

		   * -->> elenco dei campi della tabella
		   * ---------------------------------------
		   IF EMPTY(UpdatableFieldList)
		     UpdatableFieldList=tf[h,1]
		   ELSE
		     UpdatableFieldList=UpdatableFieldList+","+tf[h,1]
		   ENDIF
		NEXT
		
		DO BlackBox WITH "",_nomesql,"EXECRW_I",_nomecur  && ERASMO - 17/04/2013
		
        SELECT &_nomecur
        SET DELETED OFF
        GO TOP
        SCAN
          SCATTER MEMVAR MEMO
		  FOR h=1 TO xx
		     * -->> valorizzo le variabili
		     * ---------------------------------------
		     _var="_"+tf[h,1]
		     _dbf="m."+tf[h,1]
		     &_var=&_dbf
		  NEXT
	         
          IF EMPTY(_id_unique)
	         IF !DELETED()
		         _stringsql="insert into "+_nomesql+" ("+UpdatableFieldList+") values ("+UpdateVarList+")"
		         IF !ExecCommand(_stringsql,_nomesql)
	    	       RETURN (.f.)
  	   	    	 ENDIF 
  	   	     ENDIF
          ELSE
	         _stringsql="delete from "+_nomesql+" where id_unique=?_id_unique"
	         IF !ExecCommand(_stringsql,_nomesql)
	           RETURN (.f.)
  	   	     ENDIF 

	         IF !DELETED()
		         _stringsql="insert into "+_nomesql+" ("+UpdatableFieldList+") values ("+UpdateVarList+")"	         
		         IF !ExecCommand(_stringsql,_nomesql)
	    	       RETURN (.f.)
  	   	    	 ENDIF 
  	   	     ENDIF
          ENDIF
  
        ENDSCAN
        SET DELETED ON
        
ENDCASE 
RETURN(.t.)

*********************************************************************************************
* Eof FUNCTION ExecRW
*********************************************************************************************

*************************************************************************
* Funzione - STR_EXTRACT      Data: 26.07.94     Autore: Project
*************************************************************************
* Questa funzione permette di estrarre da una stringa determinate
* sottostringhe contenute tra il delimitatore specificato.
* Esempio:
*     AA="Pippo,Pluto,Paperino"
*     ? STR_EXTRACT(AA,",",2)      && Ritornerà  "Pluto"
* Sintassi:
*     STR_EXTRACT(<ExpC1>,<ExpC2>,<ExpN1>)
*     ExpC1 - Stringa di origine
*     ExpC2 - Carattere delimitatore di lista
*     ExpN1 - Numero di occorrenze nella lista
*
*************************************************************************
FUNCTION STR_EXTRACT
********************

PARA SRIG,DEL,OCC

SRIG=SRIG+DEL

FOR K=1 TO OCC-1
   STAR=AT(DEL,SRIG)+1
   IF STAR >LEN(SRIG)
      SRIG=""
      EXIT
   ENDIF
   SRIG=SUBSTR(SRIG,STAR)
NEXT

FINE=AT(DEL,SRIG)

IF SRIG==""
   RETURN("")
ELSE
   RETURN(SUBSTR(SRIG,1,FINE-1))
ENDIF


*************************
FUNCTION CERCA_CHR
*************************
* RESTITUISCE LA POSIZIONE DEL PUNTATORE DELLA STRINGA DA CERCARE

PARA _STRINGA,_STRINGA_DA_CERCARE,_LUNGHEZZA_DA_CERCARE

_LA_STRINGA_PARTE_DA_QUI = 0
IST = 0

DO WHILE .T.

   IST=IST + 1
   CARATT = SUBSTR(_STRINGA,IST,1)
   IF CARATT = SUBSTR(_STRINGA_DA_CERCARE,1,1)
   
      IF SUBSTR(_STRINGA,IST,_LUNGHEZZA_DA_CERCARE) = SUBSTR(_STRINGA_DA_CERCARE,1,_LUNGHEZZA_DA_CERCARE)
	      
	      _LA_STRINGA_PARTE_DA_QUI = LEN(SUBSTR(_STRINGA,1,IST))
          EXIT
      
      ENDIF
   
   ENDIF

   IF IST = 300
     EXIT
   ENDIF

ENDDO

RETURN(_LA_STRINGA_PARTE_DA_QUI)


**=> ERASMO - INIZIO 17/04/2013
*********************************************************************************************
* Begin PROCEDURE BlackBox
*********************************************************************************************
PROCEDURE BlackBox
*********************************************************************************************
PARAMETERS _par_stringsql,_par_nomesql,_par_exectype,_par_nomecur,_par_note

IF PCOUNT() >= 4
ELSE
	_par_nomecur = _par_nomesql
ENDIF

IF PCOUNT() >= 5
ELSE
	_par_note = ""
ENDIF

_Before_BlackBox_ALIAS = SELECT()

IF EMPTY(_par_nomesql) OR EMPTY(_par_nomecur)
	SELECT(_Before_BlackBox_ALIAS)
	RETURN .F.
ENDIF

_BlackBox_MainTableName = ""
DO CASE
	*CASE _par_exectype = "EXECCOMMAND"
	*	DO FindLeftDelimitedTableName WITH "INSERT INTO ", _par_stringsql
	*	IF EMPTY(_BlackBox_MainTableName)
	*		DO FindLeftDelimitedTableName WITH "UPDATE ", _par_stringsql
	*		IF EMPTY(_BlackBox_MainTableName)
	*			DO FindLeftDelimitedTableName WITH "DELETE ", _par_stringsql
	*		ENDIF
	*	ENDIF

	CASE _par_exectype = "EXECRW_W"
		_BlackBox_MainTableName = UPPER(ALLTRIM(_par_nomesql))
		IF !USED(_BlackBox_MainTableName)
			SELECT(_Before_BlackBox_ALIAS)
			RETURN .F.
		ENDIF
		
	CASE _par_exectype = "EXECRW_I"
		_BlackBox_MainTableName = UPPER(ALLTRIM(_par_nomesql))
		IF !USED(_par_nomecur)
			SELECT(_Before_BlackBox_ALIAS)
			RETURN .F.
		ENDIF
		
	CASE _par_exectype = "APPLICATION"
		_BlackBox_MainTableName = UPPER(ALLTRIM(_par_nomesql))
		IF !USED(_par_nomecur)
			SELECT(_Before_BlackBox_ALIAS)
			RETURN .F.
		ENDIF
		
	OTHERWISE
		RETURN
ENDCASE

*** SE NON ANCORA CREATO, CREO IL CURSORE PUBBLICO PER LA VERIFICA DELLE TABELLE DI CUI CREARE IL LOG
IF !USED("PUB_ELENCO_X_BlackBox")
	DO Crea_PUB_ELENCO_X_BLACKBOX
ENDIF

*** VERIFICO SE DEVO CREARE IL LOG PER LA TABELLA IN LINEA
SELECT PUB_ELENCO_X_BlackBox
SET ORDER TO I_TABNAME
GO TOP
SEEK UPPER(ALLTRIM(_BlackBox_MainTableName))
IF !FOUND()
	SELECT(_Before_BlackBox_ALIAS)
	RETURN .F.
ENDIF

_BlackBox_CODOPE = IIF(TYPE("PUB_CODOPE")=='C',ALLTRIM(PUB_CODOPE),"")
_BlackBox_NOMOPE = IIF(TYPE("PUB_NOMOPE")=='C',ALLTRIM(PUB_NOMOPE),"")
_BlackBox_WORKSTAT = SYS(0)
_BlackBox_EXECTYPE = _par_exectype
_BlackBox_CallingFormFileName = ""
_BlackBox_Note = _par_note
_BlackBox_CSQL = ALLTRIM(_par_stringsql)

ASTACKINFO(AStackInfoBlackBox)
_nStackLevels = ALEN(AStackInfoBlackBox, 1)
FOR _nLevel = (_nStackLevels - 1) TO 1 STEP -1
	_CurrentProgramFilename = ALLTRIM(AStackInfoBlackBox(_nLevel,2))
	IF FILE(_CurrentProgramFilename) AND UPPER(JUSTEXT(_CurrentProgramFilename)) == "SCT"
		_BlackBox_CallingFormFileName = _CurrentProgramFilename
		EXIT
	ENDIF
NEXT

_BlackBox_PrevFieldsValues = ""
_BlackBox_FieldsValues = ""

IF USED("TEMP_ELENCO_X_BlackBox")
	SELECT TEMP_ELENCO_X_BlackBox
	USE
ENDIF

SELECT &_par_nomecur
GO TOP

SELECT * FROM PUB_ELENCO_X_BlackBox ;
WHERE UPPER(ALLTRIM(NOME_TAB)) == UPPER(ALLTRIM(_BlackBox_MainTableName)) ;
ORDER BY SEQUEN ;
INTO CURSOR TEMP_ELENCO_X_BlackBox

SELECT TEMP_ELENCO_X_BlackBox
GO TOP
_BlackBox_MainTableDescr = ALLTRIM(DESC_TAB)

SELECT &_par_nomecur
DO WHILE !EOF()
	
	*** ACCESSO ALLA TABELLA SQL PER LA CREAZIONE CONTENUTO DEL CAMPO MEMO PrevFieldsValues (SITUAZIONE PRECEDENTE)
	_BlackBox_WhereCondKey = ""
	SELECT TEMP_ELENCO_X_BlackBox
	GO TOP
	SCAN
		IF !FLG_CHIAVE
			LOOP
		ENDIF
		_cNOME_CAMPO = ALLTRIM(NOME_CAMPO)
		SELECT &_par_nomecur
		IF TYPE(_cNOME_CAMPO) <> "U"
			_uVALORE_CAMPO = &_cNOME_CAMPO
			IF EMPTY(TRANSFORM(_uVALORE_CAMPO))  && SE LA CHIAVE UNIVOCA CONFIGURATA, CONTENUTA NEL CURSORE PASSATO, NON E' SIGNIFICATIVA, ALLORA NON POSSO CONTINUARE
				_BlackBox_WhereCondKey = ""
				EXIT
			ENDIF
			_BlackBox_WhereCondKey = _BlackBox_WhereCondKey + IIF(!EMPTY(_BlackBox_WhereCondKey)," AND ","") + ALLTRIM(_cNOME_CAMPO) + " = '" + RTRIM(TRANSFORM(_uVALORE_CAMPO)) + "'"
		ENDIF		
	ENDSCAN
	IF EMPTY(_BlackBox_WhereCondKey)  && CHIAVE UNIVOCA NON CONFIGURATA CORRETTAMENTE
		SELECT(_Before_BlackBox_ALIAS)
		RETURN .F.
	ENDIF
	
	IF USED("")
		SELECT Prev_BlackBox
		USE
	ENDIF
	ssSql=""
	ssNomeCursorSql="Prev_BlackBox"
	TEXT TO ssSql NOSHOW
		SELECT * FROM <<_BlackBox_MainTableName>> WHERE <<_BlackBox_WhereCondKey>>
	ENDTEXT
	IF !ExecPreparedCommand(ssSql,ssNomeCursorSql)
		return(.F.)
	ENDIF
	SELECT Prev_BlackBox
	GO TOP
	IF EOF()  && STATO PRECEDENTE RECORD NON TROVATO -> NON C'E' BISOGNO DI MEMORIZZARE LA RIGA DI LOG
		SELECT &_par_nomecur
		SKIP +1
		LOOP
	ENDIF
	IF RECCOUNT() > 1  && TROVATE TROPPE RIGHE CORRISPONDENTI --> LA CHIAVE NON E' UNIVOCA O NON E' CONFIGURATA CORRETTAMENTE
		SELECT &_par_nomecur
		SKIP +1
		LOOP
	ENDIF
	
	*** CREAZIONE CONTENUTO DEL CAMPO MEMO PrevFieldsValues (SITUAZIONE PRECEDENTE)
	SELECT TEMP_ELENCO_X_BlackBox
	GO TOP
	SCAN
		IF EMPTY(_BlackBox_PrevFieldsValues)
		ELSE
			_BlackBox_PrevFieldsValues = _BlackBox_PrevFieldsValues + '|'
		ENDIF
		_cNOME_TAB = ALLTRIM(NOME_TAB)
		_cNOME_CAMPO = ALLTRIM(NOME_CAMPO)
		_cDESC_CAMPO = ALLTRIM(DESC_CAMPO)
		SELECT Prev_BlackBox
		IF TYPE(_cNOME_CAMPO) <> "U"
			_uVALORE_CAMPO = &_cNOME_CAMPO
			_BlackBox_PrevFieldsValues = _BlackBox_PrevFieldsValues + ;
				IIF(!EMPTY(_cDESC_CAMPO),_cDESC_CAMPO + SPACE(1),"") + ;
				"[" + _cNOME_CAMPO + "]: " + ;
				RTRIM(TRANSFORM(_uVALORE_CAMPO))
		ENDIF
	ENDSCAN
	SELECT Prev_BlackBox
	USE
	
	*** CREAZIONE CONTENUTO DEL CAMPO MEMO FieldsValues (SITUAZIONE SUCCESSIVA)
	SELECT TEMP_ELENCO_X_BlackBox
	GO TOP
	SCAN
		IF EMPTY(_BlackBox_FieldsValues)
		ELSE
			_BlackBox_FieldsValues = _BlackBox_FieldsValues + '|'
		ENDIF
		_cNOME_TAB = ALLTRIM(NOME_TAB)
		_cNOME_CAMPO = ALLTRIM(NOME_CAMPO)
		_cDESC_CAMPO = ALLTRIM(DESC_CAMPO)
		SELECT &_par_nomecur
		IF TYPE(_cNOME_CAMPO) <> "U"
			_uVALORE_CAMPO = &_cNOME_CAMPO
			_BlackBox_FieldsValues = _BlackBox_FieldsValues + ;
				IIF(!EMPTY(_cDESC_CAMPO),_cDESC_CAMPO + SPACE(1),"") + ;
				"[" + _cNOME_CAMPO + "]: " + ;
				RTRIM(TRANSFORM(_uVALORE_CAMPO))
		ENDIF
	ENDSCAN
	
	IF ALLTRIM(_BlackBox_PrevFieldsValues) == ALLTRIM(_BlackBox_FieldsValues)
		SELECT &_par_nomecur
		SKIP +1
		LOOP
	ENDIF
	
	*** INSERIMENTO RECORD DI LOG
	iiSql=""     
	iiNomeCursorSql="BlackBox"
	TEXT TO iiSql NOSHOW
		INSERT INTO BlackBox (
			CODOPE,
			NOMOPE,
			WORKSTAT,
			EXECTYPE,
			CSQL,
			CallingFormFileName,
			MainTableName,
			MainTableDescr,
			WhereCondKey,
			PrevFieldsValues,
			FieldsValues,
			Note)
		VALUES (
			'<<_BlackBox_CODOPE>>',
			'<<_BlackBox_NOMOPE>>',
			'<<_BlackBox_WORKSTAT>>',
			'<<_BlackBox_EXECTYPE>>',
			'<<STRTRAN(_BlackBox_CSQL,"'","''")>>',
			'<<_BlackBox_CallingFormFileName>>',
			'<<_BlackBox_MainTableName>>',
			'<<STRTRAN(_BlackBox_MainTableDescr,"'","''")>>',
			'<<STRTRAN(_BlackBox_WhereCondKey,"'","''")>>',
			'<<STRTRAN(_BlackBox_PrevFieldsValues,"'","''")>>',
			'<<STRTRAN(_BlackBox_FieldsValues,"'","''")>>',
			'<<STRTRAN(_BlackBox_Note,"'","''")>>')
	ENDTEXT

	IF !ExecPreparedCommand(iiSql,iiNomeCursorSql)
		return(.F.)
	ENDIF
	
	_BlackBox_FieldsValues = ""
	
	SELECT &_par_nomecur
	SKIP +1
ENDDO

SELECT TEMP_ELENCO_X_BlackBox
USE

SELECT(_Before_BlackBox_ALIAS)
   
RETURN
*********************************************************************************************
* End PROCEDURE BlackBox
*********************************************************************************************


*********************************************************************************************
* Begin PROCEDURE Crea_PUB_ELENCO_X_BLACKBOX
*********************************************************************************************
PROCEDURE Crea_PUB_ELENCO_X_BLACKBOX
*********************************************************************************************
IF USED("PUB_ELENCO_X_BlackBox")
	SELECT PUB_ELENCO_X_BlackBox
	USE
ENDIF

LOCAL _stringsql
_stringsql = "SELECT * FROM ELENCO_X_BlackBox WHERE FLG_ATTIVA = 1"
IF !ExecCommand(_stringsql,"PUB_ELENCO_X_BlackBox")
	RETURN (.f.)
ENDIF
SELECT PUB_ELENCO_X_BlackBox
INDEX ON UPPER(ALLTRIM(NOME_TAB)) TAG I_TABNAME

ENDPROC
*********************************************************************************************
* End PROCEDURE Crea_PUB_ELENCO_X_BLACKBOX
*********************************************************************************************
**=> ERASMO - FINE 17/04/2013



**=> ERASMO - INIZIO 12/02/2013
*********************************************************************************************
* Begin PROCEDURE WriteLogSql
*********************************************************************************************
PROCEDURE WriteLogSql
*********************************************************************************************
PARAMETERS _par_stringsql

_LOGSQL_CODOPE = IIF(TYPE("PUB_CODOPE")=='C',ALLTRIM(PUB_CODOPE),"")
_LOGSQL_NOMOPE = IIF(TYPE("PUB_NOMOPE")=='C',ALLTRIM(PUB_NOMOPE),"")
_LOGSQL_WORKSTAT = SYS(0)
_LOGSQL_TIME = _nLogSqlDeltaSeconds
_LOGSQL_CallStackLevel = ArrayStackInfo(_nCallingLevel,1)
_LOGSQL_CurrentProgramFilename = ALLTRIM(ArrayStackInfo(_nCallingLevel,2))
_LOGSQL_ModuleOrObjectName = ALLTRIM(ArrayStackInfo(_nCallingLevel,3))
_LOGSQL_ModuleOrObjectSourceFilename = ALLTRIM(ArrayStackInfo(_nCallingLevel,4))
_LOGSQL_LineNumberObjectSourceFile = ArrayStackInfo(_nCallingLevel,5)
_LOGSQL_SourceLineContents = ALLTRIM(ArrayStackInfo(_nCallingLevel,6))
_Before_LOGSQL_ALIAS = SELECT()

_LOGSQL_CSQL = ALLTRIM(_par_stringsql)

_LOGSQL_MainTableNames = ""
DO FindLeftDelimitedTableName WITH "FROM "
DO FindLeftDelimitedTableName WITH "JOIN "
DO FindLeftDelimitedTableName WITH "UPDATE "

_LOGSQL_WhereCondFields = ""
FOR _nCsqlCounter1 = 1 TO OCCURS("WHERE ",UPPER(_LOGSQL_CSQL))
	_nWhereCondStartPosition = AT("WHERE ",UPPER(_LOGSQL_CSQL),_nCsqlCounter1)+6
	_cSubstr = SUBSTR(UPPER(_LOGSQL_CSQL),_nWhereCondStartPosition)
	FOR _nCsqlCounter2 = 1 TO LEN(_cSubstr)
		IF SUBSTR(_cSubstr,_nCsqlCounter2,9) = "ORDER BY " OR ;
			SUBSTR(_cSubstr,_nCsqlCounter2,7) = "SELECT " OR ;
			SUBSTR(_cSubstr,_nCsqlCounter2,6) = "WHERE " OR ;
			_nCsqlCounter2 = _nCsqlCounter2 - 1
			EXIT
		ENDIF
	NEXT
	_nWhereCondCharacters = _nCsqlCounter2
	_cWhereCond = SUBSTR(UPPER(_LOGSQL_CSQL),_nWhereCondStartPosition,_nWhereCondCharacters)
	DO FindRightDelimitedWhereCondFields WITH ">"
	DO FindRightDelimitedWhereCondFields WITH "<"
	DO FindRightDelimitedWhereCondFields WITH "="
	DO FindRightDelimitedWhereCondFields WITH " LIKE"
	DO FindRightDelimitedWhereCondFields WITH " BETWEEN"
	DO FindRightDelimitedWhereCondFields WITH " IN"
	DO FindRightDelimitedWhereCondFields WITH " NOT IN"
NEXT

*!*	IF !ExecRW("SELECT * FROM LOGSQL WHERE 1=0","LOGSQL","R")
*!*		RETURN .F.
*!*	ENDIF
*!*	SELECT LOGSQL
*!*	APPEND BLANK
*!*	REPLACE CODOPE WITH _LOGSQL_CODOPE 
*!*	REPLACE NOMOPE WITH _LOGSQL_NOMOPE 
*!*	REPLACE WORKSTAT WITH _LOGSQL_WORKSTAT 
*!*	REPLACE CSQL WITH _LOGSQL_CSQL 
*!*	REPLACE MainTableNames WITH _LOGSQL_MainTableNames
*!*	REPLACE WhereCondFields WITH _LOGSQL_WhereCondFields 
*!*	REPLACE CallStackLevel WITH _LOGSQL_CallStackLevel 
*!*	REPLACE CurrentProgramFilename WITH _LOGSQL_CurrentProgramFilename 
*!*	REPLACE ModuleOrObjectName WITH _LOGSQL_ModuleOrObjectName 
*!*	REPLACE ModuleOrObjectSourceFilename WITH _LOGSQL_ModuleOrObjectSourceFilename 
*!*	REPLACE LineNumberObjectSourceFile WITH _LOGSQL_LineNumberObjectSourceFile 
*!*	REPLACE SourceLineContents WITH _LOGSQL_SourceLineContents 
*!*	REPLACE TIME WITH _LOGSQL_TIME 
*!*	IF !ExecRW("SELECT * FROM LOGSQL WHERE 1=0","LOGSQL","W")
*!*		RETURN .F.
*!*	ENDIF

iiSql=""     
iiNomeCursorSql="LOGSQL"
TEXT TO iiSql NOSHOW
	INSERT INTO LOGSQL (
		CODOPE,
		NOMOPE,
		WORKSTAT,
		CSQL,
		MainTableNames,
		WhereCondFields,
		CallStackLevel,
		CurrentProgramFilename,
		ModuleOrObjectName,
		ModuleOrObjectSourceFilename,
		LineNumberObjectSourceFile,
		SourceLineContents,
		Time)
	VALUES (
		'<<_LOGSQL_CODOPE>>',
		'<<_LOGSQL_NOMOPE>>',
		'<<_LOGSQL_WORKSTAT>>',
		'<<STRTRAN(_LOGSQL_CSQL,"'","''")>>',
		'<<_LOGSQL_MainTableNames>>',
		'<<_LOGSQL_WhereCondFields>>',
		<<_LOGSQL_CallStackLevel>>,
		'<<_LOGSQL_CurrentProgramFilename>>',
		'<<_LOGSQL_ModuleOrObjectName>>',
		'<<_LOGSQL_ModuleOrObjectSourceFilename>>',
		<<_LOGSQL_LineNumberObjectSourceFile>>,
		'<<STRTRAN(_LOGSQL_SourceLineContents,"'","''")>>',
		<<STRTRAN(STR(_LOGSQL_TIME,20,3),",",".")>>)
ENDTEXT

IF !ExecPreparedCommand(iiSql,iiNomeCursorSql)
	return(.F.)
ENDIF

SELECT(_Before_LOGSQL_ALIAS)
   
RETURN
*********************************************************************************************
* End PROCEDURE WriteLogSql
*********************************************************************************************

*********************************************************************************************
* Begin PROCEDURE FindLeftDelimitedTableName
*********************************************************************************************
PROCEDURE FindLeftDelimitedTableName
*********************************************************************************************
PARAMETERS _par_SqlClause, _par_SqlString

IF PCOUNT() > 1
ELSE
	_par_SqlString = _LOGSQL_CSQL
ENDIF

FOR _nCsqlCounter1 = 1 TO OCCURS(_par_SqlClause,UPPER(_par_SqlString))
	_nTableNameStartPosition = AT(_par_SqlClause,UPPER(_par_SqlString),_nCsqlCounter1)+LEN(_par_SqlClause)
	_cSubstr = SUBSTR(UPPER(_par_SqlString),_nTableNameStartPosition)
	FOR _nCsqlCounter2 = 1 TO LEN(_cSubstr)
		IF SUBSTR(_cSubstr,_nCsqlCounter2,1) $ (SPACE(1) + CHR(13))
			_nCsqlCounter2 = _nCsqlCounter2 - 1
			EXIT
		ENDIF
	NEXT
	_nTableNameCharacters = _nCsqlCounter2
	_cTableName = SUBSTR(UPPER(_par_SqlString),_nTableNameStartPosition,_nTableNameCharacters)
	IF TYPE("_LOGSQL_MainTableNames") == "C" AND !(_cTableName $ _LOGSQL_MainTableNames) AND ALLTRIM(_cTableName) <> "(" AND UPPER(ALLTRIM(_cTableName)) <> "(SELECT"
		_LOGSQL_MainTableNames = _LOGSQL_MainTableNames + IIF(EMPTY(_LOGSQL_MainTableNames),""," ; ") + _cTableName
	ENDIF
NEXT
   
RETURN
*********************************************************************************************
* End PROCEDURE FindLeftDelimitedTableName
*********************************************************************************************

*********************************************************************************************
* Begin PROCEDURE FindRightDelimitedWhereCondFields
*********************************************************************************************
PROCEDURE FindRightDelimitedWhereCondFields
*********************************************************************************************
PARAMETERS _par_SqlOperator

FOR _nCsqlCounter3 = 1 TO OCCURS(_par_SqlOperator,_cWhereCond)
	_nFieldNameFinalPosition = AT(_par_SqlOperator,_cWhereCond,_nCsqlCounter3)-1
	_cSubstr = RTRIM(SUBSTR(_cWhereCond,1,_nFieldNameFinalPosition))
	FOR _nCsqlCounter4 = LEN(_cSubstr) TO 1 STEP -1
		IF SUBSTR(_cSubstr,_nCsqlCounter4,1) $ (SPACE(1) + CHR(13))
			EXIT
		ENDIF
	NEXT
	_nCsqlCounter4 = _nCsqlCounter4 + 1
	_cFieldName = SUBSTR(_cSubstr,_nCsqlCounter4)
	IF RIGHT(_cFieldName,1) == '<' OR RIGHT(_cFieldName,1) == '>' OR RIGHT(_cFieldName,1) == '=' OR RIGHT(_cFieldName,1) == '!'
		_cFieldName = ALLTRIM(SUBSTR(_cFieldName,1,LEN(_cFieldName)-1))
	ENDIF
	IF !EMPTY(_cFieldName) AND !(_cFieldName $ _LOGSQL_WhereCondFields) AND ALLTRIM(_cFieldName) <> '0' AND ALLTRIM(_cFieldName) <> '1' AND UPPER(ALLTRIM(_cFieldName)) <> 'NOT'
		_LOGSQL_WhereCondFields = _LOGSQL_WhereCondFields + IIF(EMPTY(_LOGSQL_WhereCondFields),""," ; ") + _cFieldName
	ENDIF
NEXT
   
RETURN
*********************************************************************************************
* End PROCEDURE FindRightDelimitedWhereCondFields
*********************************************************************************************
**=> ERASMO - FINE 12/02/2013



**=> ERASMO - INIZIO 17/04/2013
*********************************************************************************************
* Begin PROCEDURE BlackBox
*********************************************************************************************
PROCEDURE BlackBox
*********************************************************************************************
PARAMETERS _par_stringsql,_par_nomesql,_par_exectype,_par_nomecur,_par_note

IF PCOUNT() >= 4
ELSE
	_par_nomecur = _par_nomesql
ENDIF

IF PCOUNT() >= 5
ELSE
	_par_note = ""
ENDIF

_Before_BlackBox_ALIAS = SELECT()

IF EMPTY(_par_nomesql) OR EMPTY(_par_nomecur)
	SELECT(_Before_BlackBox_ALIAS)
	RETURN .F.
ENDIF

_BlackBox_MainTableName = ""
DO CASE
	*CASE _par_exectype = "EXECCOMMAND"
	*	DO FindLeftDelimitedTableName WITH "INSERT INTO ", _par_stringsql
	*	IF EMPTY(_BlackBox_MainTableName)
	*		DO FindLeftDelimitedTableName WITH "UPDATE ", _par_stringsql
	*		IF EMPTY(_BlackBox_MainTableName)
	*			DO FindLeftDelimitedTableName WITH "DELETE ", _par_stringsql
	*		ENDIF
	*	ENDIF

	CASE _par_exectype = "EXECRW_W"
		_BlackBox_MainTableName = UPPER(ALLTRIM(_par_nomesql))
		IF !USED(_BlackBox_MainTableName)
			SELECT(_Before_BlackBox_ALIAS)
			RETURN .F.
		ENDIF
		
	CASE _par_exectype = "EXECRW_I"
		_BlackBox_MainTableName = UPPER(ALLTRIM(_par_nomesql))
		IF !USED(_par_nomecur)
			SELECT(_Before_BlackBox_ALIAS)
			RETURN .F.
		ENDIF
		
	CASE _par_exectype = "APPLICATION"
		_BlackBox_MainTableName = UPPER(ALLTRIM(_par_nomesql))
		IF !USED(_par_nomecur)
			SELECT(_Before_BlackBox_ALIAS)
			RETURN .F.
		ENDIF
		
	OTHERWISE
		RETURN
ENDCASE

*** SE NON ANCORA CREATO, CREO IL CURSORE PUBBLICO PER LA VERIFICA DELLE TABELLE DI CUI CREARE IL LOG
IF !USED("PUB_ELENCO_X_BlackBox")
	DO Crea_PUB_ELENCO_X_BLACKBOX
ENDIF

*** VERIFICO SE DEVO CREARE IL LOG PER LA TABELLA IN LINEA
SELECT PUB_ELENCO_X_BlackBox
SET ORDER TO I_TABNAME
GO TOP
SEEK UPPER(ALLTRIM(_BlackBox_MainTableName))
IF !FOUND()
	SELECT(_Before_BlackBox_ALIAS)
	RETURN .F.
ENDIF

_BlackBox_CODOPE = IIF(TYPE("PUB_CODOPE")=='C',ALLTRIM(PUB_CODOPE),"")
_BlackBox_NOMOPE = IIF(TYPE("PUB_NOMOPE")=='C',ALLTRIM(PUB_NOMOPE),"")
_BlackBox_WORKSTAT = SYS(0)
_BlackBox_EXECTYPE = _par_exectype
_BlackBox_CallingFormFileName = ""
_BlackBox_Note = _par_note
_BlackBox_CSQL = ALLTRIM(_par_stringsql)

ASTACKINFO(AStackInfoBlackBox)
_nStackLevels = ALEN(AStackInfoBlackBox, 1)
FOR _nLevel = (_nStackLevels - 1) TO 1 STEP -1
	_CurrentProgramFilename = ALLTRIM(AStackInfoBlackBox(_nLevel,2))
	IF FILE(_CurrentProgramFilename) AND UPPER(JUSTEXT(_CurrentProgramFilename)) == "SCT"
		_BlackBox_CallingFormFileName = _CurrentProgramFilename
		EXIT
	ENDIF
NEXT

_BlackBox_PrevFieldsValues = ""
_BlackBox_FieldsValues = ""

IF USED("TEMP_ELENCO_X_BlackBox")
	SELECT TEMP_ELENCO_X_BlackBox
	USE
ENDIF

SELECT &_par_nomecur
GO TOP

SELECT * FROM PUB_ELENCO_X_BlackBox ;
WHERE UPPER(ALLTRIM(NOME_TAB)) == UPPER(ALLTRIM(_BlackBox_MainTableName)) ;
ORDER BY SEQUEN ;
INTO CURSOR TEMP_ELENCO_X_BlackBox

SELECT TEMP_ELENCO_X_BlackBox
GO TOP
_BlackBox_MainTableDescr = ALLTRIM(DESC_TAB)

SELECT &_par_nomecur
DO WHILE !EOF()
	
	*** ACCESSO ALLA TABELLA SQL PER LA CREAZIONE CONTENUTO DEL CAMPO MEMO PrevFieldsValues (SITUAZIONE PRECEDENTE)
	_BlackBox_WhereCondKey = ""
	SELECT TEMP_ELENCO_X_BlackBox
	GO TOP
	SCAN
		IF !FLG_CHIAVE
			LOOP
		ENDIF
		_cNOME_CAMPO = ALLTRIM(NOME_CAMPO)
		SELECT &_par_nomecur
		IF TYPE(_cNOME_CAMPO) <> "U"
			_uVALORE_CAMPO = &_cNOME_CAMPO
			IF EMPTY(TRANSFORM(_uVALORE_CAMPO))  && SE LA CHIAVE UNIVOCA CONFIGURATA, CONTENUTA NEL CURSORE PASSATO, NON E' SIGNIFICATIVA, ALLORA NON POSSO CONTINUARE
				_BlackBox_WhereCondKey = ""
				EXIT
			ENDIF
			_BlackBox_WhereCondKey = _BlackBox_WhereCondKey + IIF(!EMPTY(_BlackBox_WhereCondKey)," AND ","") + ALLTRIM(_cNOME_CAMPO) + " = '" + RTRIM(TRANSFORM(_uVALORE_CAMPO)) + "'"
		ENDIF		
	ENDSCAN
	IF EMPTY(_BlackBox_WhereCondKey)  && CHIAVE UNIVOCA NON CONFIGURATA CORRETTAMENTE
		SELECT(_Before_BlackBox_ALIAS)
		RETURN .F.
	ENDIF
	
	IF USED("")
		SELECT Prev_BlackBox
		USE
	ENDIF
	ssSql=""
	ssNomeCursorSql="Prev_BlackBox"
	TEXT TO ssSql NOSHOW
		SELECT * FROM <<_BlackBox_MainTableName>> WHERE <<_BlackBox_WhereCondKey>>
	ENDTEXT
	IF !ExecPreparedCommand(ssSql,ssNomeCursorSql)
		return(.F.)
	ENDIF
	SELECT Prev_BlackBox
	GO TOP
	IF EOF()  && STATO PRECEDENTE RECORD NON TROVATO -> NON C'E' BISOGNO DI MEMORIZZARE LA RIGA DI LOG
		SELECT &_par_nomecur
		SKIP +1
		LOOP
	ENDIF
	IF RECCOUNT() > 1  && TROVATE TROPPE RIGHE CORRISPONDENTI --> LA CHIAVE NON E' UNIVOCA O NON E' CONFIGURATA CORRETTAMENTE
		SELECT &_par_nomecur
		SKIP +1
		LOOP
	ENDIF
	
	*** CREAZIONE CONTENUTO DEL CAMPO MEMO PrevFieldsValues (SITUAZIONE PRECEDENTE)
	SELECT TEMP_ELENCO_X_BlackBox
	GO TOP
	SCAN
		IF EMPTY(_BlackBox_PrevFieldsValues)
		ELSE
			_BlackBox_PrevFieldsValues = _BlackBox_PrevFieldsValues + '|'
		ENDIF
		_cNOME_TAB = ALLTRIM(NOME_TAB)
		_cNOME_CAMPO = ALLTRIM(NOME_CAMPO)
		_cDESC_CAMPO = ALLTRIM(DESC_CAMPO)
		SELECT Prev_BlackBox
		IF TYPE(_cNOME_CAMPO) <> "U"
			_uVALORE_CAMPO = &_cNOME_CAMPO
			_BlackBox_PrevFieldsValues = _BlackBox_PrevFieldsValues + ;
				IIF(!EMPTY(_cDESC_CAMPO),_cDESC_CAMPO + SPACE(1),"") + ;
				"[" + _cNOME_CAMPO + "]: " + ;
				RTRIM(TRANSFORM(_uVALORE_CAMPO))
		ENDIF
	ENDSCAN
	SELECT Prev_BlackBox
	USE
	
	*** CREAZIONE CONTENUTO DEL CAMPO MEMO FieldsValues (SITUAZIONE SUCCESSIVA)
	SELECT TEMP_ELENCO_X_BlackBox
	GO TOP
	SCAN
		IF EMPTY(_BlackBox_FieldsValues)
		ELSE
			_BlackBox_FieldsValues = _BlackBox_FieldsValues + '|'
		ENDIF
		_cNOME_TAB = ALLTRIM(NOME_TAB)
		_cNOME_CAMPO = ALLTRIM(NOME_CAMPO)
		_cDESC_CAMPO = ALLTRIM(DESC_CAMPO)
		SELECT &_par_nomecur
		IF TYPE(_cNOME_CAMPO) <> "U"
			_uVALORE_CAMPO = &_cNOME_CAMPO
			_BlackBox_FieldsValues = _BlackBox_FieldsValues + ;
				IIF(!EMPTY(_cDESC_CAMPO),_cDESC_CAMPO + SPACE(1),"") + ;
				"[" + _cNOME_CAMPO + "]: " + ;
				RTRIM(TRANSFORM(_uVALORE_CAMPO))
		ENDIF
	ENDSCAN
	
	IF ALLTRIM(_BlackBox_PrevFieldsValues) == ALLTRIM(_BlackBox_FieldsValues)
		SELECT &_par_nomecur
		SKIP +1
		LOOP
	ENDIF
	
	*** INSERIMENTO RECORD DI LOG
	iiSql=""     
	iiNomeCursorSql="BlackBox"
	TEXT TO iiSql NOSHOW
		INSERT INTO BlackBox (
			CODOPE,
			NOMOPE,
			WORKSTAT,
			EXECTYPE,
			CSQL,
			CallingFormFileName,
			MainTableName,
			MainTableDescr,
			WhereCondKey,
			PrevFieldsValues,
			FieldsValues,
			Note)
		VALUES (
			'<<_BlackBox_CODOPE>>',
			'<<_BlackBox_NOMOPE>>',
			'<<_BlackBox_WORKSTAT>>',
			'<<_BlackBox_EXECTYPE>>',
			'<<STRTRAN(_BlackBox_CSQL,"'","''")>>',
			'<<_BlackBox_CallingFormFileName>>',
			'<<_BlackBox_MainTableName>>',
			'<<STRTRAN(_BlackBox_MainTableDescr,"'","''")>>',
			'<<STRTRAN(_BlackBox_WhereCondKey,"'","''")>>',
			'<<STRTRAN(_BlackBox_PrevFieldsValues,"'","''")>>',
			'<<STRTRAN(_BlackBox_FieldsValues,"'","''")>>',
			'<<STRTRAN(_BlackBox_Note,"'","''")>>')
	ENDTEXT

	IF !ExecPreparedCommand(iiSql,iiNomeCursorSql)
		return(.F.)
	ENDIF
	
	_BlackBox_FieldsValues = ""
	
	SELECT &_par_nomecur
	SKIP +1
ENDDO

SELECT TEMP_ELENCO_X_BlackBox
USE

SELECT(_Before_BlackBox_ALIAS)
   
RETURN
*********************************************************************************************
* End PROCEDURE BlackBox
*********************************************************************************************


*********************************************************************************************
* Begin PROCEDURE Crea_PUB_ELENCO_X_BLACKBOX
*********************************************************************************************
PROCEDURE Crea_PUB_ELENCO_X_BLACKBOX
*********************************************************************************************
IF USED("PUB_ELENCO_X_BlackBox")
	SELECT PUB_ELENCO_X_BlackBox
	USE
ENDIF

LOCAL _stringsql
_stringsql = "SELECT * FROM ELENCO_X_BlackBox WHERE FLG_ATTIVA = 1"
IF !ExecCommand(_stringsql,"PUB_ELENCO_X_BlackBox")
	RETURN (.f.)
ENDIF
SELECT PUB_ELENCO_X_BlackBox
INDEX ON UPPER(ALLTRIM(NOME_TAB)) TAG I_TABNAME

ENDPROC
*********************************************************************************************
* End PROCEDURE Crea_PUB_ELENCO_X_BLACKBOX
*********************************************************************************************
**=> ERASMO - FINE 17/04/2013



***********************************************************************
* Funzione - RIBALTA2     Data: 15.11.95   Autore: Project
***********************************************************************
*
*  Consente di convertire il formato data
*  AAAA.MM.GG in GG.MM.AAAA e viceversa
*  Sintassi: RIBALTA(Stringa da convertire)
*  Parametro: Carattere
*  Ritorna:   Carattere
*  Se il contenuto di GG,MM,AA è nullo ritorna SPACE(10)
*
***********************************************************************
FUNCTION RIBALTA2
*****************

PARAMETER _VALCAMPO

_SEPARA="/.-"

DO CASE
   CASE SUBSTR(_VALCAMPO,3,1) $ _SEPARA   && GG.MM.AAAA
        _SEPARA=SUBSTR(_VALCAMPO,3,1)
        _GIORNO=SUBSTR(_VALCAMPO,1,2)
        _MESE  =SUBSTR(_VALCAMPO,4,2)
        _ANNO  =SUBSTR(_VALCAMPO,7,4)
        _TUTTO =_ANNO+_SEPARA+_MESE+_SEPARA+_GIORNO
   CASE SUBSTR(_VALCAMPO,5,1) $ _SEPARA   && AAAA.MM.GG
        _SEPARA=SUBSTR(_VALCAMPO,5,1)
        _GIORNO=SUBSTR(_VALCAMPO,9,2)
        _MESE  =SUBSTR(_VALCAMPO,6,2)
        _ANNO  =SUBSTR(_VALCAMPO,1,4)
        _TUTTO =_GIORNO+_SEPARA+_MESE+_SEPARA+_ANNO
   OTHERWISE                              && NON VALIDO !
        _TUTTO=SPACE(10)
ENDCASE

RETURN(_TUTTO)


*****************************
procedure legge_config
*****************************
parameters _configfile,_proprieta

LOCAL _valore,_chiave

_valore=""
_chiave=""

IF FILE(ALLTRIM(_configfile))	  && Esiste il file? 

	gnConfigFile = FOPEN(ALLTRIM(_configfile))	  	&& Se esiste, lo apre in lettura
	IF gnConfigFile >= 0  					&& Verifica errore in apertura del file
											&& Se non viene trovato alcun errore legge file

		do while !feof(gnConfigFile)
		
			riga=ALLTRIM(FGETS(gnConfigFile))
			
			IF SUBSTR(riga,1,1)="*"
				LOOP
			ENDIF
			
			if at('=',riga)>0
				_chiave=ALLTRIM(substr(riga,1,at("=",riga)-1))
				_valore=ALLTRIM(substr(riga,at("=",riga)+1))

				if	UPPER(_chiave)==UPPER(ALLTRIM(_proprieta))
					***WAIT WINDOW 	"***"+_chiave+"*** = ****"+_proprieta+"***"+_valore	TIMEOUT 3
					EXIT
				ENDIF
				
			endif
		enddo
	ENDIF
	
	=FCLOSE(gnConfigFile)	

ENDIF

return _valore

ENDPROC


************************************************************************
* Procedura - ZERRORE
************************************************************************
* Procedura tappo per gestione evento VALID
PROCEDURE ZERRORE
RETURN


**************************************************************************
* Procedura - OPENDB                    Data: 10.11.95   Autore: Project
**************************************************************************
* Procedura da utilizzare per aprire un DB
*
**************************************************************************
PROCEDURE OPENDB
*****************

PARA V1

IF !USED(V1)
   USE &V1 IN 0 AGAIN
ENDIF

SELECT &V1
SET FILTER TO
SET ORDER TO
GO TOP
RETURN



FUNCTION TRANCHE
PARAMETERS _SSELECT,_CONPAG,_DTFATT,_IMPTOT,VETDAL,VETAL,VETDAY,C__VAL,_FLAG_POSALL__,_CLIENTE__,__TOT_IMPON__,__TOT_IMPOS__

_N_PAR  = PARAMETERS()


X__VAL       = PUB_VALRIF
_FLAG_POSALL = .F.
_CLIENTE     = ""

IF _N_PAR   = 8
  X__VAL = C__VAL
ENDIF

IF _N_PAR   = 10					&& GESTIONE POSTICIPI PER TUTTO L'ANNO A LIVELLO DI CLIENTE
  X__VAL       = C__VAL
  _FLAG_POSALL = _FLAG_POSALL__
  _CLIENTE     = _CLIENTE__
ENDIF


IF _N_PAR   = 11					&& GESTIONE POSTICIPI PER TUTTO L'ANNO A LIVELLO DI CLIENTE
  X__VAL       = C__VAL
  _FLAG_POSALL = _FLAG_POSALL__
  _CLIENTE     = _CLIENTE__
ENDIF


IF _N_PAR   = 12					&& GESTIONE POSTICIPI PER TUTTO L'ANNO A LIVELLO DI CLIENTE
  X__VAL       = C__VAL
  _FLAG_POSALL = _FLAG_POSALL__
  _CLIENTE     = _CLIENTE__
ENDIF


IF _N_PAR   <> 12					&& NUOVA GESTIONE TRANCHE DI SCADENZA
  __TOT_IMPON = _IMPTOT
  __TOT_IMPOS = 0
ELSE
  __TOT_IMPON = __TOT_IMPON__
  __TOT_IMPOS = __TOT_IMPOS__
ENDIF



IF SUBSTR(_DTFATT,3,1) = '/'
   _DTFATT = RIBALTA2(_DTFATT)
ENDIF
 
 

RELEASE V_SCAFISS,V_SOLOIMPIVA,V_PERIMPO,V_SCAFISS_1RATA,V_TIPI_TRANCHE,V_PERCENTUALI      
PUBLIC V_SCAFISS,V_SOLOIMPIVA,V_PERIMPO,V_SCAFISS_1RATA,V_TIPI_TRANCHE,V_PERCENTUALI      
V_SCAFISS 	 		= 0    	&& sono i giorni fissi da sommare alla data di scadenza
V_SCAFISS_1RATA 	= 0		&& sono i giorni fissi da sommare solo alla data di scadenza della prima rata
V_SOLOIMPIVA    	= ""	&& scorpora il valore dell'IVA dall'imponibile e lo attribuisce alla prima scadenza della fattura
V_PERIMPO    		= 0		&& calcola i xxx % dell'imponibile e lo somma alla prima scadenza della fattura , il resto viene suddiviso alle restanti scadenze in parti uguali
V_RIBA       		= ""   	&& serve per verificare se ribba o meno
V_TIPI_TRANCHE      = ""    && contiene il tipo di tranche per ogni scadenza
V_PERCENTUALI       = ""	&& calcola la percentuale sull'importo totale e la attribuisce alla singola scadenza creata


_OLDSEL=SELECT()


declare MESIVET[12]
MESIVET[1]=31
MESIVET[2]=28
MESIVET[3]=31
MESIVET[4]=30
MESIVET[5]=31
MESIVET[6]=30
MESIVET[7]=31
MESIVET[8]=31
MESIVET[9]=30
MESIVET[10]=31
MESIVET[11]=30
MESIVET[12]=31


	v_seek   = 'CPA'+_CONPAG
	v_chiave = 'codice'
	cSql="SELECT * FROM para WHERE "+V_CHIAVE+ " = ?V_SEEK"
	IF !ExecCommand(cSql,"para")
	   return(.f.)
	ENDIF
	SELECT PARA
	GO TOP
	IF EOF()
	   	
	   	
	   	WAIT WINDOWS "CONDIZIONE DI PAGAMENTO MANCANTE IMPOSTO AUTOMATICAMENTE LA CONDIZIONE DI PAGAMENTO PREFERITA !!!!!!" NOWAIT
	   	
	   	_CONPAG = PUB_CPA

		v_seek   = 'CPA'+_CONPAG
		v_chiave = 'codice'
		cSql="SELECT * FROM para WHERE "+V_CHIAVE+ " = ?V_SEEK"
		IF !ExecCommand(cSql,"para")
		   return(.f.)
		ENDIF
		SELECT PARA
		GO TOP
		IF EOF()
		
		   WAIT WINDOWS "CONDIZIONE DI PAGAMENTO MANCANTE E CONDIZIONE DI PAGAMENTO PREFERITA MANCANTE , AGGIORNA IL PARAMETRO PER FAVORE !!!!!!" NOWAIT

		   **=> ERASMO - INIZIO 04/10/2011
		   *!*	CURSORE CONTENENTE IMPORTI E DATE DI SCADENZA PER LA NUOVA FUNZIONE TRANCHE
		   CREATE CURSOR CU_TRANK;
			  (TK_DSCAD C(10),TK_IMP_SCAD N(15,2),TK_NUM_TRAN N(5),TK_TISCA C(02))
		   **=> ERASMO - FINE 04/10/2011

		   SELECT(_OLDSEL)
		   RETURN("")


		ENDIF   
	   
	    V_CPAG = ALLTRIM(DESCRI)
		** ACCESSO ALL'ANAGRAFICA CLIENTI PER LA GESTIONE DEI DOCUMENTI IN LINGUA **
		x_soci = "CLI_CODSOC = '" + PUB_CODSOC + "'"
		x_codi = "CLI_CODCLI = '" + _CLIENTE + "'"
		x_cond = x_soci + " and " + x_codi 
		cSql   = "SELECT CLI_LINGUA FROM U_CLI_AN WHERE " + x_cond
		IF !ExecCommand(cSql,"TMP_CLI_AN_cu")
		   RETURN _RIT
		ENDIF
		SELECT TMP_CLI_AN_cu
		GO TOP
		IF !EOF()
			* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
			DL_LINGUA       = CLI_LINGUA
			DL_TIPODES 		= 'COND.PAGAM'
			DL_CODICE  		= _CONPAG
			_DESCR_LINGUA 	= CERCA_DESCRIZIONI_IN_LINGUA(DL_TIPODES,DL_LINGUA,DL_CODICE)
			IF !EMPTY(_DESCR_LINGUA)
				X__DESCPA  = _DESCR_LINGUA    
				V_CPAG     = _DESCR_LINGUA
			ENDIF
			* -------------------------------------------------------------------------- descrizioni in lingua ---------- 'COND.PAGAM' ---------- *
		ENDIF
		
        SELECT PARA

   
	ENDIF

   
   SELECT PARA
   V_TIPI_TRANCHE 	= ALLTRIM(DESIVA)	 && contiene la gestione della tranche nella procedura delle RIBA : RB=RICEVUTA BANCARIA , NO= NON GESTISCE LA TRANCHE NELLA PROCEDURA DELLE RICEVUTE BANCARIE
 
   IF "FM" $ LIBERA
     FM=.T.										&& fine mese
   ELSE
     FM=.F.
   ENDIF
   V_LIBERA				= LTRIM(SUBSTR(LIBERA,11))
   V_RIBA  				= UPPER(SUBSTR(LIBERA,10,1))	&& serve per verificare se ribba o meno
   V_SCAFISS 			= SCAFISS    					&& sono i giorni fissi da sommare alla data di scadenza
   V_SCAFISS_1RATA 		= SCAFISS_1R	  				&& sono i giorni fissi da sommare solo alla data di scadenza della prima rata
   V_SOLOIMPIVA    		= SOLOIMPIVA					&& scorpora il valore dell'IVA dall'imponibile e lo attribuisce alla prima scadenza della fattura
   V_PERIMPO    		= PERIMPO						&& calcola i xxx % dell'imponibile e lo somma alla prima scadenza della fattura , il resto viene suddiviso alle restanti scadenze in parti uguali
   V_PERCENTUALI        = PERCENTUALI 					&& calcola la percentuale sull'importo totale e la attribuisce alla singola scadenza creata

   PUBLIC  TRANK[100],TRANK1[100]
   CNT=0
   P=1
   ST='0'
   OLDCH='!'
   
   
   * ----->> 
   DO WHILE .T.

	     IF EMPTY(V_LIBERA) 
	       CNT=CNT+1
	       TRANK[CNT]=0
	       TRANK1[CNT]=0
	       EXIT
	     ENDIF  

	     CH=SUBSTR(V_LIBERA,P,1)
	     IF CH=SPACE(01) .AND. OLDCH=SPACE(01)
	        EXIT
	     ENDIF
	     ST=ST+CH
	     IF CH=SPACE(01)
	         CNT=CNT+1
	         TRANK[CNT]=VAL(ST)
	         TRANK1[CNT]=VAL(ST)         
	         ST='0'
	     ENDIF
	     P=P+1
	     OLDCH=CH
   
   ENDDO

   IF X__VAL = "ITL" .OR. X__VAL = "LIT"
	   _IMPPAR=ROUND(_IMPTOT/CNT,0)
   ELSE
	   _IMPPAR=ROUND(_IMPTOT/CNT,2)
   ENDIF

 
   _RET=""
   
   * COMPENSO=INT(_IMPTOT-(INT(_IMPPAR)*CNT))
   COMPENSO=_IMPTOT-(_IMPPAR*CNT)	   
                

* WAIT WINDOWS "IMMPAR"+STR(_IMPPAR,13,2)+"<<<IMPTOT "+STR(_IMPTOT,13,2)+" COMPENSO "+STR(COMPENSO,13,2)
  
   MESEADESS=SUBSTR(_DTFATT,6,2)
   MESEADESS=VAL(MESEADESS)
   FOR DDDD=1 TO CNT
     IF TRANK1[DDDD]<>0
       APP_TRAN=TRANK1[DDDD]
       TRANK1[DDDD]=0

       FOR FF=1 TO APP_TRAN/30
         IF MESEADESS+FF>12
           _INDICE=MESEADESS+FF-12
         ELSE
           _INDICE=MESEADESS+FF
         ENDIF
         DO WHILE _INDICE>12
           _INDICE=_INDICE-12
         ENDDO
         TRANK1[DDDD]=TRANK1[DDDD]+MESIVET[_INDICE]
       NEXT
     ENDIF
   NEXT
  
   **--> CREO LE VARIE SCADENZE E RIPORTO LA DATA A FINE MESE SE FM
  
   FOR I=1 TO CNT
     
	     IF (TRANK[I]/30) - (INT(TRANK[I]/30))=0     && CASO DI SCADENZE MULTIPLE DI 30GG
	       
	       IF FM  
	       ** PORTA A FINE MESE LA DATA DI FATTURA E AGGIUNGE I GG DI SCADENZA DI OGNI TRANCHE
	         DATAINI=_DTFATT
	         MESE  =VAL(SUBSTR(DATAINI,6,2))
	         ANNO  =VAL(SUBSTR(DATAINI,1,4))
	         BISESTILE=(ANNO/4)=INT(ANNO/4)
	         DO CASE
		           CASE MESE=11 .OR. MESE=4 .OR. MESE=6 .OR. MESE=9
		             GIORNO=30
		           CASE MESE=2
		             IF BISESTILE
		               GIORNO=29
		             ELSE
		               GIORNO=28
		             ENDIF
		           OTHERWISE
		             GIORNO=31
	         ENDCASE
	         
	         _DTSCAD=STR(GIORNO,2)+'.'+STR(MESE,2)+'.'+STR(ANNO,4)
	         _DTSCAD=CTOD(_DTSCAD)+TRANK1[I]
	         
	       ELSE
	         _DTSCAD=CTOD(RIBALTA2(_DTFATT))+TRANK[I]  
	       ENDIF
	         
	       IF FM
		         DATAINI=_DTSCAD
		         MESE  =VAL(SUBSTR(DTOC(_DTSCAD),4,2))
		         ANNO  =VAL(SUBSTR(DTOC(_DTSCAD),7,4))
		         BISESTILE=(ANNO/4)=INT(ANNO/4)
		         DO CASE
		           CASE MESE=11 .OR. MESE=4 .OR. MESE=6 .OR. MESE=9
		             GIORNO=30
		           CASE MESE=2
		             IF BISESTILE
		               GIORNO=29
		             ELSE
		               GIORNO=28
		             ENDIF
		           OTHERWISE
		             GIORNO=31
		         ENDCASE
		         _DTSCAD=CTOD(STR(GIORNO,2)+'.'+STR(MESE,2)+'.'+STR(ANNO,4))
	       ENDIF
     ELSE
	       IF FM
		         DATAINI=_DTFATT
		         MESE  =VAL(SUBSTR(DATAINI,6,2))
		         ANNO  =VAL(SUBSTR(DATAINI,1,4))
		         BISESTILE=(ANNO/4)=INT(ANNO/4)
		         DO CASE
		           CASE MESE=11 .OR. MESE=4 .OR. MESE=6 .OR. MESE=9
		             GIORNO=30
		           CASE MESE=2
		             IF BISESTILE
		               GIORNO=29
		             ELSE
		               GIORNO=28
		             ENDIF
		           OTHERWISE
		             GIORNO=31
		         ENDCASE
		         _DTSCAD=STR(GIORNO,2)+'.'+STR(MESE,2)+'.'+STR(ANNO,4)
		         _DTSCAD=CTOD(_DTSCAD)+TRANK[I]
		   ELSE
			     DATAINI=_DTFATT
		    	 _DTSCAD=CTOD(RIBALTA2(DATAINI))+TRANK[I]         
		   ENDIF
     ENDIF

     IF V_SCAFISS <> 0 					&& SE SCADENZA FISSA MODIFICA DATA SCADENZA PER TUTTE LE CONDIZIONI DI PAGAMENTO

	   _GGGGFISSI_       = STR(V_SCAFISS,2,0)   
	   DATA_SCAD_OLD_    = DTOC(_DTSCAD)
	   DATA_SCAD_RIC_    = CTOD(DATA_SCAD_OLD_)+VAL(_GGGGFISSI_) 
	   _DTSCAD           = DATA_SCAD_RIC_    
	
	 ENDIF


     IF I = 1 							&& SOLO SULLA PRIMA SCADENZA
   	    IF V_SCAFISS_1RATA <> 0			&& IMPOSTA SCADENZA FISSA SOLO ALLA DATA DI PRIMA SCADENZA PER TUTTE LE CONDIZIONI DI PAGAMENTO
           _GGGGFISSI_       = STR(V_SCAFISS_1RATA,2,0)  
		   DATA_SCAD_OLD_    = DTOC(_DTSCAD)
		   DATA_SCAD_RIC_    = CTOD(DATA_SCAD_OLD_)+VAL(_GGGGFISSI_) 
		   _DTSCAD           = DATA_SCAD_RIC_    
		ENDIF          
     ENDIF 


     XX= _N_PAR  

     * -->> NON ESEGUE IL CALCOLO DEI POSTICIPI SE NON RIBA OPPURE SE E' ATTIVATA LA GESTIONE DEI POSTICIPI SU TUTTO L'ANNO A LIVELLO DI CLIENTE
     * -->> 
       
     
     IF V_RIBA<>"X"
       _RET=_RET+DTOC(_DTSCAD)+' '
	   SELECT(_OLDSEL)
	   LOOP
     ENDIF
     
     
     IF _FLAG_POSALL 						&& GESTIONE POSTICIPI FISSI PREVITI PER TUTTI I MESI DELL'ANNO A LIVELLO DI CLIENTE
       _RET=_RET+DTOC(_DTSCAD)+' '
	   SELECT(_OLDSEL)
	   LOOP
     ENDIF

*!*	     IF I = 1 							&& SOLO SULLA PRIMA SCADENZA
*!*	   	    IF V_SCAFISS_1RATA <> 0			&& IMPOSTA SCADENZA FISSA SOLO ALLA DATA DI PRIMA SCADENZA
*!*	           _GGGGFISSI_       = STR(V_SCAFISS_1RATA,2,0)  
*!*			   DATA_SCAD_OLD_    = DTOC(_DTSCAD)
*!*			   DATA_SCAD_RIC_    = CTOD(DATA_SCAD_OLD_)+VAL(_GGGGFISSI_) 
*!*			   _DTSCAD           = DATA_SCAD_RIC_    
*!*			ENDIF          
*!*	     ENDIF 
 
*!*	     IF V_SCAFISS <> 0 					&& SE SCADENZA FISSA MODIFICA DATA SCADENZA

*!*		   _GGGGFISSI_       = STR(V_SCAFISS,2,0)   
*!*		   DATA_SCAD_OLD_    = DTOC(_DTSCAD)
*!*		   DATA_SCAD_RIC_    = CTOD(DATA_SCAD_OLD_)+VAL(_GGGGFISSI_) 
*!*		   _DTSCAD           = DATA_SCAD_RIC_    
*!*		
*!*		 ENDIF
    
     FATTO=.F.
     IF _N_PAR  >= 8  && ERASMO - 28/09/2011		&& CICLO DI GESTIONE DEI POSTICIPI DI AGOSTO/DICEMBRE SIA PER CLIENTE CHE PER FORNITORE


       _DTSCAD1=DTOC(_DTSCAD)
       _GGGG=SUBSTR(_DTSCAD1,1,2)
       _MMMM=SUBSTR(_DTSCAD1,4,2)
       _AAAA=SUBSTR(_DTSCAD1,7,4)


       FOR _X_I=1 TO ALEN(VET_DAL)
         IF _MMMM+_GGGG >= GIRA(VET_DAL[_X_I]) .AND. _MMMM+_GGGG <= GIRA(VET_AL[_X_I])
           _ANNO_ATT=_AAAA
           _ANNO_PRO=STR((VAL(_ANNO_ATT)+1),4,0)
           IF _MMMM<='11'
             _DTSCAD1=SUBSTR(VET_DAY[_X_I],1,2)+'.'+SUBSTR(VET_DAY[_X_I],3,2)+'.'+_ANNO_ATT
           ELSE

             IF VET_DAY[_X_I]=VET_AL[_X_I]
                _DTSCAD1=SUBSTR(VET_DAY[_X_I],1,2)+'.'+SUBSTR(VET_DAY[_X_I],3,2)+'.'+_ANNO_ATT
             ELSE
                _DTSCAD1=SUBSTR(VET_DAY[_X_I],1,2)+'.'+SUBSTR(VET_DAY[_X_I],3,2)+'.'+_ANNO_PRO
             ENDIF        
           ENDIF
           _DTSCAD=CTOD(_DTSCAD1)
           _RET=_RET+DTOC(_DTSCAD)+' '

           FATTO=.T.
         ENDIF
       NEXT
     ENDIF
     IF !FATTO
       _RET=_RET+DTOC(_DTSCAD)+' '
     ENDIF


   NEXT
 
 
   _RET=ALLTRIM(STR(_IMPPAR,15,2))+' '+_RET
   _RET=SUBSTR(_RET,1,LEN(_RET)-1)


*!*	   IF V_SCAFISS <> 0											&& IMPOSTA SCADENZA FISSA A TUTTE LE DATE DI SCADENZA
*!*	      _RET=SCADENZAFISSA(_RET)
*!*	   ENDIF
   
*!*	   IF V_SCAFISS_1RATA <> 0										&& IMPOSTA SCADENZA FISSA SOLO ALLA DATA DI PRIMA SCADENZA
*!*	   	 _RET=SCADENZAFISSA_SOLO_PER_LA_PRIMA_RATA_DI_SCADENZA(_RET)
*!*	   ENDIF  
   
   IF _FLAG_POSALL 												&& GESTIONE POSTICIPI FISSI PREVISTI PER TUTTI I MESI DELL'ANNO A LIVELLO DI CLIENTE
      _RET=POSTICIPIFISSI(_RET)   
   ENDIF


 
   **=> ERASMO - INIZIO 04/10/2011
   *!*	CURSORE CONTENENTE IMPORTI E DATE DI SCADENZA PER LA NUOVA FUNZIONE TRANCHE
   CREATE CURSOR CU_TRANK;
	  (TK_DSCAD C(10),TK_IMP_SCAD N(15,2),TK_NUM_TRAN N(5),TK_TISCA C(02))
   **=> ERASMO - FINE 04/10/2011
	  

   =CREA_CU_TRANK(_RET,__TOT_IMPON,__TOT_IMPOS,_IMPTOT)			&& CREAZIONE DEL CURSORE CON SCADENZE E IMPORTI IN FUNZIONE DELLE NUOVE REGOLE 



   SELECT(_OLDSEL)
   RETURN(_RET)






RETURN


***********************
PROCEDURE CREA_CU_TRANK
***********************
PARAMETERS _STRINGA,__TOT_IMPON__,__TOT_IMPOS__,__TOT_IMPTOT

*!*	 _STRINGA 		:	CONTIENE SOLO LE DATE DI SCADENZA DI OGNI TRANCHE
*!*	 __TOT_IMPON__	:	TOTALE IMPONIBILE
*!*	 __TOT_IMPOS__	:	TOTALE IMPOSTA
*!*	 __TOT_IMPTOT	:	TOTALE DOCUMENTO


IF __TOT_IMPOS = 0		&& PER LA VECCHIA GESTIONE NON TIENE CONTO DEL IVA SUBITO ALLA PRIMA RATA
	V_SOLOIMPIVA = ""
ENDIF 


*!*	CARICA LE DATE DI SCADENZA NEL CURSORE

CONTA_TRA = 0
IS        = 0

_IMPORTO_PRIMA_TRANCHE = 0
IF V_SOLOIMPIVA    = "IVA"	
	_IMPORTO_PRIMA_TRANCHE = __TOT_IMPOS__
ENDIF

IF V_PERIMPO > 0
	__IMPONIBILE_DA_SOMMARE = (__TOT_IMPON__ * V_PERIMPO)/100
	_IMPORTO_PRIMA_TRANCHE  = _IMPORTO_PRIMA_TRANCHE + __IMPONIBILE_DA_SOMMARE 
ENDIF

IF EMPTY(V_SOLOIMPIVA)    
	IF V_PERIMPO > 0
		__IMPONIBILE_DA_SOMMARE = (__TOT_IMPTOT  * V_PERIMPO)/100					&& IN QUESTO CASO USA IL TOTALE DEL DOCUMENTO IN QUANTO NON E' IL CASO DI PAGAMENTO ANTICIPATO DELL'IVA
		_IMPORTO_PRIMA_TRANCHE  =  __IMPONIBILE_DA_SOMMARE 
	ENDIF
ENDIF


__RESTO_DA_SOMMARE = __TOT_IMPTOT  - _IMPORTO_PRIMA_TRANCHE  

IF CNT > 2	&& SE HO PIU' DI DUE TRANCHE DEVO RIPARTIRE IL RESTO IN FUNZIONE DEL NUMERO DI TRANCHE IN ECCEDENZA ALLA PRIMA
  _NUMERO_SCADENZE 		= CNT - 1
  __RESTO_DA_SOMMARE 	= __RESTO_DA_SOMMARE / _NUMERO_SCADENZE 
ENDIF

IF _IMPORTO_PRIMA_TRANCHE  = 0	&& NESSUNA OPZIONE SU IVA O PERCENTUALE IN ANTICIPO : LA PRIMA SCADENZA E' GESTITA COME LE ALTRE SCADENZE
  _NUMERO_SCADENZE 			= CNT 
  __RESTO_DA_SOMMARE 		= __TOT_IMPTOT  / _NUMERO_SCADENZE 
  _IMPORTO_PRIMA_TRANCHE	= __RESTO_DA_SOMMARE 
ENDIF


** VERIFICA SE IMPOSTATA LA GESTIONE DELLA RIPARTIZIONE IMPORTI IN FUNZIONE DELLE PERCENTUALI
IF !EMPTY(ALLTRIM(V_PERCENTUALI))	
	_STRING     = ALLTRIM(V_PERCENTUALI)
	NUMERO_PERC = CERCA_GG_SCADENZA(_STRING)	&& CARICA LE PERCENTUALI NEL VETTORE GG_SCADENZA[I_GG]
ENDIF


CONTA_TRA = 0
** RICERCA IMPORTO TRANCHE
IS=0
IS2=0						&& INDICE CHE DETERMINA LA PARTENZA/FINE DELLA DATA SCADENZA
_XPAROLA = ''
=CERCA_PAROLA(_STRINGA) 	&& ORA SI PARTE DAL PRIMO CARATTERE DELLA PRIMA DATA SCADENZA


DO WHILE .T.

   CONTA_TRA = CONTA_TRA + 1

   * CNT IDENTIFICA IL NUMERO DI TRANCHE DETERMINATO DA TRANCHE
   IF CONTA_TRA > CNT
      EXIT
   ENDIF


   ** RICERCA TIPO DI TRANCHE
   _XPAROLA2 = ''
   =CERCA_PAROLA2(V_TIPI_TRANCHE)   
   _TIPO_TRANK =_XPAROLA2 					&& contiene il tipo di tranche RB=RICEVUTA BANCARIA  , NO= NON GESTISCE LA TRANCHE NELLA PROCEDURA DELLE RICEVUTE BANCARIE
 

   ** RICERCA DATA SCADENZA
   _XPAROLA = ''
   =CERCA_PAROLA(_STRINGA)   
   DATA_SCAD=_XPAROLA
   
   
   
   SELECT CU_TRANK
   APPEND BLANK
   REPLACE TK_NUM_TRAN  WITH CONTA_TRA
   REPLACE TK_DSCAD     WITH DATA_SCAD
   REPLACE TK_TISCA     WITH _TIPO_TRANK 

   
   
   IF CONTA_TRA = 1												&& PRIMA SCADENZA
		REPLACE TK_IMP_SCAD  WITH _IMPORTO_PRIMA_TRANCHE  			
   ELSE 														&& SCADENZE RESTANTI
		REPLACE TK_IMP_SCAD  WITH __RESTO_DA_SOMMARE			
   ENDIF 


  IF !EMPTY(ALLTRIM(V_PERCENTUALI))		&& RICALCOLA IL VALORE SE IMPOSTATA LA GESTIONE DELLA RIPARTIZIONE IMPORTI IN FUNZIONE DELLE PERCENTUALI
	* OTTENGO LA %   
    _PERCENTUALE_SU_TOTALE_DOCUMENTO = GG_SCADENZA[CONTA_TRA]
    _NUOVO_IMPORTO_SINGOLA_TRANCHE    = (__TOT_IMPTOT * _PERCENTUALE_SU_TOTALE_DOCUMENTO) / 100
	SELECT CU_TRANK
	REPLACE TK_IMP_SCAD  WITH _NUOVO_IMPORTO_SINGOLA_TRANCHE    	&& NUOVO IMPORTO RICALCOLATO
  ENDIF 


ENDDO



*!*	VERIFICA SE IL TOTALE DELLE SCADENZE QUADRA CON IL TOTALE DEL DOCUMENTO
_SOMMA_TK_IMP_SCAD = 0
SELECT CU_TRANK
GO TOP
DO WHILE .NOT. EOF()

	_SOMMA_TK_IMP_SCAD = _SOMMA_TK_IMP_SCAD + TK_IMP_SCAD 

	SKIP +1
	
ENDDO

IF  __TOT_IMPTOT > _SOMMA_TK_IMP_SCAD 
	_DELTA = __TOT_IMPTOT - _SOMMA_TK_IMP_SCAD
	SELECT CU_TRANK
	GO BOTTOM  
	REPLACE TK_IMP_SCAD  WITH TK_IMP_SCAD   + _DELTA 
ENDIF

IF  __TOT_IMPTOT < _SOMMA_TK_IMP_SCAD 
	_DELTA = _SOMMA_TK_IMP_SCAD - __TOT_IMPTOT 
	SELECT CU_TRANK
	GO BOTTOM  
	REPLACE TK_IMP_SCAD  WITH TK_IMP_SCAD   - _DELTA 
ENDIF


RETURN




*************************
FUNCTION CERCA_PAROLA
*************************
PARAMETERS _STRINGA
DO WHILE .T.

   IS=IS + 1
   CARATT = SUBSTR(_STRINGA,IS,1)
   IF !EMPTY(CARATT)
      _XPAROLA = _XPAROLA + SUBSTR(_STRINGA,IS,1)
   ELSE
      EXIT
   ENDIF

ENDDO

RETURN

*************************
FUNCTION CERCA_PAROLA2
*************************
PARAMETERS _STRINGA2
DO WHILE .T.

   IS2=IS2 + 1
   CARATT2 = SUBSTR(_STRINGA2,IS2,1)
   IF !EMPTY(CARATT2)
      _XPAROLA2 = _XPAROLA2 + SUBSTR(_STRINGA2,IS2,1)
   ELSE
      EXIT
   ENDIF

ENDDO

RETURN


**********************
FUNCTION CREA_SCADENZE
**********************

__TOTALE_SCADENZA = 0

SELECT CU_TRANK
GO TOP

DO WHILE .NOT. EOF()

	SCATTER MEMVAR MEMO
	
	SELECT PERIODI
	APPEND BLANK
	REPLACE IMP_SCAD  WITH M.TK_IMP_SCAD 
	REPLACE NUM_TRAN  WITH M.TK_NUM_TRAN 
	REPLACE DSCAD     WITH M.TK_DSCAD 	
		
    __TOTALE_SCADENZA  = __TOTALE_SCADENZA  + IMP_SCAD  

	SELECT CU_TRANK
	SKIP +1
	
ENDDO



*!*	CONTROLLO INCROCIATO CON IL TOTALE DEL DOCUMENTO E GLI IMPORTI DELLE SCADENZE : OTTENGO COMPENSO E LO SOMMO SULL'ULTIMA TRANCHE


__T_TOTALE_DOCUMENTO =  __T_IMPON  + __T_IMPOS   

COMPENSO = 0
IF __TOTALE_SCADENZA  <> __T_TOTALE_DOCUMENTO 

	COMPENSO = ABS(__T_TOTALE_DOCUMENTO - __TOTALE_SCADENZA)
	SELECT PERIODI
	GO BOTTOM
	REPLACE IMP_SCAD  WITH IMP_SCAD  + COMPENSO

ENDIF



*!*	RIPORTA LE DATE DI SCADENZA E IMPORTO NEL VETTORE RELATIVO ALLA GESTIONE DELLE SCADENZE DEL REPORT

RELEASE DATA            && ERASMO - 27/07/2011
RELEASE IMPORTO         && ERASMO - 27/07/2011

PUBLIC ARRAY DATA(7)
PUBLIC ARRAY IMPORTO(7)

RELEASE DESCR_SCAD			&& ERASMO - 11/06/2013
PUBLIC ARRAY DESCR_SCAD(7)	&& ERASMO - 11/06/2013


I = 0
SELECT PERIODI
GO TOP

DO WHILE (!EOF()) .AND. (I < 7)

   I = I + 1

   DATA[I]     = DSCAD
   IMPORTO[I]  = IMP_SCAD
   DESCR_SCAD[I] = ""  && ERASMO - 11/06/2013

   SELECT PERIODI

   SKIP +1

ENDDO

I = I + 1

FOR HH = I TO 7

   DATA[HH]     = SPACE(10)
   IMPORTO[HH]  = 0
   DESCR_SCAD[HH] = ""  && ERASMO - 11/06/2013

NEXT



RETURN



******************
FUNCTION CAMPOMASK
******************
PARAMETERS _NUMDEC,_INTERO

IF _NUMDEC = 0
   _CAMPOMASK = _INTERO
   RETURN(_CAMPOMASK)
ENDIF

X_DECIMA = ""
X_INDICE = 1
DO WHILE .T.
   IF X_INDICE > _NUMDEC
      EXIT
   ENDIF
   X_DECIMA = X_DECIMA + '9'
   X_INDICE = X_INDICE + 1
ENDDO
_CAMPOMASK = _INTERO + "." + X_DECIMA

RETURN(_CAMPOMASK)


**************************************************************************
FUNCTION CERCA_DESCRIZIONI_IN_LINGUA
**************************************************************************
*** RICERCA E RESTITUISCE LA DESCRIZIONE IN LINGUA DEL MOVIMENTO RICHIESTO
*!*	tipologia_movimento = 'ARTICOLO'
*!*	tipologia_movimento = 'COND.PAGAM'
*!*	tipologia_movimento = 'MEZZI.CONS'
*!*	tipologia_movimento = 'CODI.PORTO'
*!*	tipologia_movimento = 'ASPET.BENI'
*!*	tipologia_movimento = 'CODICE-TOP'
*!*	tipologia_movimento = 'TESTOCONAI'
*!*	tipologia_movimento = 'RIFERI-ORD'
*!*	tipologia_movimento = 'RIFERI-DDT'
**************************************************************************
LPARAMETERS _par_tipodes,_par_lingua,_par_codice

_RIT = ""
LOCAL ACT_SEL
ACT_SEL = SELECT()

x_tipo = "TIPODES = '" + _par_tipodes + "'"		
x_ling = "LINGUA = '" + _par_lingua + "'"
x_codi = "CODICE = '" + _par_codice + "'"
x_cond = x_tipo + " and " + x_ling + " and " + x_codi
cSql   = "SELECT DESCRI FROM DESLINGUE WHERE " + x_cond
IF !ExecCommand(cSql,"TMP_DESLINGUE")
   RETURN _RIT
ENDIF
SELECT TMP_DESLINGUE
GO TOP
IF !EOF()
	_RIT = ALLTRIM(DESCRI)
ENDIF



SELECT(ACT_SEL)

RETURN _RIT

******************************
FUNCTION GIRA
******************************
PARAMETERS CHI
_APPO=SUBSTR(CHI,3,2)+SUBSTR(CHI,1,2)
RETURN(_APPO)



*************************************************************************************************************************************
FUNCTION POSTICIPIFISSI		&& FORZA LA DATA DI SCADENZA FISSA PER I CLIENTI CHE DESIDERANO IL POSTICIPO FISSO PIANIFICATO NELL'ANNO
*************************************************************************************************************************************
PARA _TRANCHE_

_SELX_ = SELECT()



   x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
   x_codi = "cli_codcli = '" + ALLTRIM(_CLIENTE) + "'"
   x_cond = x_soci + " and " + x_codi
   Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
   IF !ExecCommand(cSql,"u_cli_an")
      return(.f.)
   ENDIF
   SELECT u_cli_an
   GO TOP
   IF EOF()
	  SELECT(_SELX_)
	  RETURN(_TRANCHE_)
   ELSE
      PUBLIC _VET_DAL[12],_VET_AL[12],_VET_DAY[12]
      _VET_DAL[01]= CLI_01DAL
      _VET_DAL[02]= CLI_02DAL
      _VET_DAL[03]= CLI_03DAL
      _VET_DAL[04]= CLI_04DAL      
      _VET_DAL[05]= CLI_05DAL      
      _VET_DAL[06]= CLI_06DAL      
      _VET_DAL[07]= CLI_07DAL      
      _VET_DAL[08]= CLI_BDAL
      _VET_DAL[09]= CLI_09DAL      
      _VET_DAL[10]= CLI_10DAL      
      _VET_DAL[11]= CLI_11DAL      
      _VET_DAL[12]= CLI_B2DAL
      
      _VET_AL[01]= CLI_01AL
      _VET_AL[02]= CLI_02AL
      _VET_AL[03]= CLI_03AL
      _VET_AL[04]= CLI_04AL      
      _VET_AL[05]= CLI_05AL      
      _VET_AL[06]= CLI_06AL      
      _VET_AL[07]= CLI_07AL      
      _VET_AL[08]= CLI_BAL
      _VET_AL[09]= CLI_09AL      
      _VET_AL[10]= CLI_10AL      
      _VET_AL[11]= CLI_11AL      
      _VET_AL[12]= CLI_B2AL


      _VET_DAY[01]= CLI_01GG
      _VET_DAY[02]= CLI_02GG
      _VET_DAY[03]= CLI_03GG
      _VET_DAY[04]= CLI_04GG      
      _VET_DAY[05]= CLI_05GG      
      _VET_DAY[06]= CLI_06GG      
      _VET_DAY[07]= CLI_07GG      
      _VET_DAY[08]= CLI_GG1    
      _VET_DAY[09]= CLI_09GG      
      _VET_DAY[10]= CLI_10GG      
      _VET_DAY[11]= CLI_11GG      
      _VET_DAY[12]= CLI_GG2   

   ENDIF



V_TUTTO = _TRANCHE_


LEN_V_TUTTO = LEN(ALLTRIM(_TRANCHE_))

CONTA_TRA = 0
** RICERCA IMPORTO TRANCHE
IS=0						&& INDICE CHE DETERMINA LA PARTENZA/FINE DELLA DATA SCADENZA
XPAROLA = ''

DO PAROLA
_IMP_TRANK=VAL(XPAROLA)		&& ORA INDICE PARTE DAL PRIMO CARATTERE DELLA PRIMA DATA SCADENZA

XX = IS


DO WHILE .T.

   CONTA_TRA = CONTA_TRA + 1
   * CNT IDENTIFICA IL NUMERO DI TRANCHE DETERMINATO DA TRANCHE
   IF CONTA_TRA > CNT
      EXIT
   ENDIF

   ** MODIFICA DATA SCADENZA

   DATA_SCAD_OLD     = SUBSTR(V_TUTTO,IS+1,10)
   DATA_SCAD_NEW     = DATA_SCAD_OLD
  
   DO CASE 
   
   		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "01"
   				
   				IF !EMPTY(SUBSTR(_VET_DAY[01],1,2))
   					DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[01],1,2) + "/" + SUBSTR(_VET_DAY[01],3,2) + "/" + SUBSTR(DATA_SCAD_OLD,7,4)
   				ENDIF
   				
   		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "02"
   		

   				IF !EMPTY(SUBSTR(_VET_DAY[02],1,2))
   					DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[02],1,2) + "/" + SUBSTR(_VET_DAY[02],3,2) + "/" + SUBSTR(DATA_SCAD_OLD,7,4)
   				ENDIF
   				   				
   		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "03"
   		
   				IF !EMPTY(SUBSTR(_VET_DAY[03],1,2))
   					DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[03],1,2) + "/" + SUBSTR(_VET_DAY[03],3,2) + "/" + SUBSTR(DATA_SCAD_OLD,7,4)
   				ENDIF
   				
   		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "04"
   		

   				IF !EMPTY(SUBSTR(_VET_DAY[04],1,2))
    				DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[04],1,2) + "/" + SUBSTR(_VET_DAY[04],3,2) + "/" + SUBSTR(DATA_SCAD_OLD,7,4)
   				ENDIF 
   				
  		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "05"
  		
   				IF !EMPTY(SUBSTR(_VET_DAY[05],1,2))
    				DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[05],1,2) + "/" + SUBSTR(_VET_DAY[05],3,2) + "/" + SUBSTR(DATA_SCAD_OLD,7,4)
   				ENDIF
   				    			
  		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "06"
 
  		
   				IF !EMPTY(SUBSTR(_VET_DAY[06],1,2))
    				DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[06],1,2) + "/" + SUBSTR(_VET_DAY[06],3,2) + "/" + SUBSTR(DATA_SCAD_OLD,7,4)
   				ENDIF
   				    			
  		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "07"

   				IF !EMPTY(SUBSTR(_VET_DAY[07],1,2))
    				DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[07],1,2) + "/" + SUBSTR(_VET_DAY[07],3,2) + "/" + SUBSTR(DATA_SCAD_OLD,7,4)
    			ENDIF
    			
  		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "08"
  		
   				IF !EMPTY(SUBSTR(_VET_DAY[08],1,2))
    				DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[08],1,2) + "/" + SUBSTR(_VET_DAY[08],3,2) + "/" + SUBSTR(DATA_SCAD_OLD,7,4)
   				ENDIF
   				    			
  		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "09"

   				IF !EMPTY(SUBSTR(_VET_DAY[09],1,2))
    				DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[09],1,2) + "/" + SUBSTR(_VET_DAY[09],3,2) + "/" + SUBSTR(DATA_SCAD_OLD,7,4)
   				ENDIF
   				    			
  		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "10"
  		
   				IF !EMPTY(SUBSTR(_VET_DAY[10],1,2))
    				DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[10],1,2) + "/" + SUBSTR(_VET_DAY[10],3,2) + "/" + SUBSTR(DATA_SCAD_OLD,7,4)
   				ENDIF
   				    			
  		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "11"
  		

   				IF !EMPTY(SUBSTR(_VET_DAY[11],1,2))
    				DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[11],1,2) + "/" + SUBSTR(_VET_DAY[11],3,2) + "/" + SUBSTR(DATA_SCAD_OLD,7,4)
      			ENDIF
      				 			
  		CASE	SUBSTR(DATA_SCAD_OLD,4,2) = "12"
  		
   				IF !EMPTY(SUBSTR(_VET_DAY[12],1,2))
  					___ANNO = STR(VAL(SUBSTR(DATA_SCAD_OLD,7,4))+1,4,0)
    				DATA_SCAD_NEW	  = SUBSTR(_VET_DAY[12],1,2) + "/" + SUBSTR(_VET_DAY[12],3,2) + "/" + ___ANNO 
    			ENDIF 
   		
   ENDCASE
   
   
*!*	   _TRANCHE_ = STRTRAN(_TRANCHE_,DATA_SCAD_OLD,ALLTRIM(DATA_SCAD_NEW))


   _TRANCHE_ = ALLTRIM(SUBSTR(_TRANCHE_,1,IS)+ALLTRIM(DATA_SCAD_NEW)+SUBSTR(_TRANCHE_,IS+11,1000))


 
   ** RICERCA DATA SCADENZA SUCCESSIVA

   XPAROLA = ''
   DO PAROLA


ENDDO

SELECT(_SELX_)

RETURN(_TRANCHE_)

****************************
FUNCTION CERCA_GG_SCADENZA
****************************
PARAMETERS _STRINGA_
*!*	LA FUNZIONE CONTA I GIORNI DI SCADENZA DELLE CONDIZIONI DI PAGAMENTO 
*!*	RESTITUISCE DOPO AVER ANALIZZATO LA STRINGA IN INPUT :
*!*	IL NUMERO DEI GIORNI TROVATI
*!*	IL CURSORE  GG_SCADENZA CONTENETE LE PERCENTUALI DA ATTRIBUIRE AI GIORNI DI SCADENZA
*!*	IL CAMPO _TIPO_ERRORE CHE ASSUME I SEGUENTI VALORI :
*!*			 _TIPO_ERRORE = 1 : LE PERCENTUALI DIGITATE NON SONO CORRETTE (CONTENGONO CARATTEREI ERRATI)
*!*			 _TIPO_ERRORE = 2 : IL TOTALE DELLE PERCENTUALI NON VALE 100%

   ScKS=STR(SELECT())


   RELEASE  _TIPO_ERRORE  
   PUBLIC   GG_SCADENZA[100],_TIPO_ERRORE  
   __NGG  		= 0 
   I_GG   		= 0
   I_P    		= 1
   ST_ST 		= '0'
   _OLDCH 		='!'
   _TIPO_ERRORE = 0
   _SOMMA_PERCENTUALI = 0
   _ERRORE_CARATTERE = .F.
   
   * ----->> 
   DO WHILE .T.

     IF EMPTY(_STRINGA_) 
       __NGG = 0
       I_GG=I_GG+1
       GG_SCADENZA[I_GG]=0
       EXIT
     ENDIF  

     _CH=SUBSTR(_STRINGA_,I_P,1)
     IF _CH=SPACE(01) .AND. _OLDCH=SPACE(01)
        EXIT
     ENDIF
     ST_ST=ST_ST+_CH

     IF _CH<>SPACE(01) 		&& CONTROLLA IL CARATTERE DIGITATO , DEVE ASSUMERE VALORI COME 0 1 2 3 4 5 6 7 8 9 , TUTTI GLI ALTRI NON SONO ACCETTATI
         
         _CARATTERE_ERRATO = .F.
         DO CASE 
         	CASE _CH = '0'
         		_CARATTERE_ERRATO = .F.
          	CASE _CH = '1'
         		_CARATTERE_ERRATO = .F.
         	CASE _CH = '2'
         		_CARATTERE_ERRATO = .F.
          	CASE _CH = '3'
         		_CARATTERE_ERRATO = .F.
         	CASE _CH = '4'
         		_CARATTERE_ERRATO = .F.
          	CASE _CH = '5'
         		_CARATTERE_ERRATO = .F.
         	CASE _CH = '6'
         		_CARATTERE_ERRATO = .F.
          	CASE _CH = '7'
         		_CARATTERE_ERRATO = .F.
         	CASE _CH = '8'
         		_CARATTERE_ERRATO = .F.
          	CASE _CH = '9'
         		_CARATTERE_ERRATO = .F.
          	CASE _CH = ','
         		_CARATTERE_ERRATO = .F.
			OTHERWISE
         		_CARATTERE_ERRATO = .T.
         ENDCASE
         IF !_ERRORE_CARATTERE 
	         IF _CARATTERE_ERRATO 
	         	_ERRORE_CARATTERE = .T.
	         ENDIF   
	     ENDIF
     ENDIF
        
              
     IF _CH=SPACE(01)
         I_GG=I_GG+1
         GG_SCADENZA[I_GG]=VAL(ST_ST)
         _SOMMA_PERCENTUALI = _SOMMA_PERCENTUALI + VAL(ST_ST)
         ST_ST='0'
         __NGG = __NGG + 1
     ENDIF
     I_P=I_P+1
     _OLDCH=_CH
   ENDDO
   
   SELECT &ScKS


   IF _SOMMA_PERCENTUALI <> 100			&& SOMMA DEI VALORI NON CORRISPONDENTE AL 100%
      _TIPO_ERRORE = 2
   ENDIF

   IF _ERRORE_CARATTERE 				&& ESISTE ALMENO UN CARATTERE ERRATO NELLA STRINGA
 	  _TIPO_ERRORE = 1
   ENDIF


RETURN(__NGG)




*************************
PROCEDURE PAROLA
*************************

DO WHILE .T.

   IS=IS + 1
   CARATT = SUBSTR(V_TUTTO,IS,1)
   IF !EMPTY(CARATT)
      XPAROLA = XPAROLA + SUBSTR(V_TUTTO,IS,1)
   ELSE
      EXIT
   ENDIF

ENDDO

RETURN

***********************************
PROCEDURE SEND_EVENTO_COMPLETO
***********************************

PARAMETERS _DESCRIZIONE,_TIPO_EVENTO,_MITTENTE,_DESTINATARI,_GRUPPO_EVENTO,_CAMPO_MODIFICATO,_VALORE_PREC,_VALORE_SUCC,_RISPOSTA,_ID_EVENTO_SUCC

LOCAL _DATA_EVENTO,_ORA_EVENTO,_STATO_EVENTO,_COD_USER,_CURSOR,_eSql,nRows, IDX_DEST ,_ID_EVENTO 
LOCAL ARRAY A_DESTINATARI(100)

IF !USED("TEMP_EVENTI")
	_eSql="SELECT * FROM LOG_EVENTI WHERE 1=0"
	_CURSOR=SYS(2015)+"_LOG_EVENTI"
	IF !ExecCommand("SELECT * FROM LOG_EVENTI WHERE 0=1",_CURSOR)
	   return(.f.)
	ENDIF
	SELECT &_CURSOR 
	AFIELDS(_FIELDS)
	CREATE CURSOR TEMP_EVENTI FROM ARRAY _FIELDS
ENDIF

nRows = ALINES(A_DESTINATARI, STRTRAN(_DESTINATARI,",",CHR(13)))


FOR IDX_DEST = 1 TO nRows 

	SELECT TEMP_EVENTI
	APPEND BLANK

	_ID_EVENTO=SYS(2015) 
	
	REPLACE ID_EVENTO 			WITH _ID_EVENTO 
	REPLACE COD_USER 			WITH _MITTENTE
	REPLACE GRUPPO_EVENTO 		WITH _GRUPPO_EVENTO
	REPLACE DESCRIZIONE 		WITH _DESCRIZIONE
	REPLACE TIPO_EVENTO 		WITH _TIPO_EVENTO
	REPLACE DATA_EVENTO 		WITH RIBALTA2(DTOC(DATE()))
	REPLACE ORA_EVENTO 			WITH TIME()
	REPLACE RUOLO_DEST 			WITH A_DESTINATARI[IDX_DEST]
	REPLACE CAMPO_MODIFICATO 	WITH _CAMPO_MODIFICATO
	REPLACE VALORE_PREC 		WITH _VALORE_PREC
	REPLACE VALORE_SUCC 		WITH _VALORE_SUCC
	REPLACE RISPOSTA	 		WITH _RISPOSTA
	IF _RISPOSTA 
		REPLACE ID_EVENTO_SUCC 		WITH _ID_EVENTO_SUCC	
	ELSE
		REPLACE ID_EVENTO_SUCC 		WITH ""	
	ENDIF

NEXT

SELECT TEMP_EVENTI
GO TOP
IF !ExecRW('','LOG_EVENTI','I','','TEMP_EVENTI')
   return(.f.)
ENDIF

SELECT TEMP_EVENTI
ZAP




***********************************
PROCEDURE SPLIT
***********************************

PARAMETERS paArr, pcLine, pcDiv
PRIVATE lnLen, lnWid, lnCnt, lnNum, lnStrt, lnPos, lcSub
  lnLen = aLen( paArr, 1 ) && Number of rows
  lnWid = aLen( paArr, 2 ) && Number of cols
  
  lnCnt = OCCURS( pcDiv, pcLine+pcDiv )
  if lnLen < lnCnt
    if lnWid > 0
      DIMENSION paArr[ lnCnt, lnWid ]
    else
      DIMENSION paArr[ lnCnt ]
    endif
  endif
  lnStrt = 1
  lnNum  = 0
  do While atc( pcDiv, pcLine+pcDiv, lnNum+1 ) > 0
    lnNum = lnNum + 1
    lnPos = atc( pcDiv, pcLine+pcDiv, lnNum )
    if lnStrt > len(pcLine) && 9/23/99 wgcs
      lcSub = ''
    else
      lcSub = Substr( pcLine, lnStrt, lnPos-lnStrt )
    endif
    lnStrt = lnPos + len(pcDiv)
    if lnWid > 0
      paArr[ lnNum, 1 ] = lcSub
    else
      paArr[ lnNum ] = lcSub
    endif
  enddo
    
RETURN lnCnt



******************************
FUNCTION AQUADOCU       && CARICA I DOCUMENTI PREVISTI NEL SISTEMA INFORMATIVO
******************************

SS=STR(SELECT())

IF !ExecCommand("select * from u_azi_an","u_azi_an")
   return
ENDIF

SELECT u_azi_an
GO TOP 
IF reccount() <> 0
   SCATTER MEMVAR MEMO
ELSE
   WAIT WINDOW "Per cortesia codificare i parametri aziendali"
   RETURN
ENDIF

PUB_MESERR = M.AZI_MESERR
PUB_FAMTU  = M.AZI_FAMTU
PUB_BOLLA  = M.AZI_BOLLA
PUB_FAPRO  = M.AZI_FAPRO
PUB_ORDIN  = M.AZI_ORDIN
PUB_FATTU  = M.AZI_FATTU
PUB_FATTR  = M.AZI_FATTR
PUB_EFFE   = M.AZI_EFFE
PUB_ORFO   = M.AZI_ORFO
PUB_OFFE   = M.AZI_OFFE
PUB_COMM   = M.AZI_COMM
PUB_CTLO   = M.AZI_CTLO
PUB_CODM   = M.AZI_CODM
PUB_SAU    = M.AZI_SAU
PUB_NOSC   = M.AZI_NOSC
PUB_SKART  = M.AZI_SKART
PUB_RISOLU = M.AZI_RISOLU
PUB_IVA    = M.AZI_IVA
PUB_NCR    = M.AZI_NCR
PUB_ESIVA  = M.AZI_ESIVA
PUB_NORD   = M.AZI_NORD
PUB_TFTOP  = M.AZI_TFTOP
PUB_COMCEE = M.AZI_COMCEE
PUB_PREZZI = M.AZI_PREZZI
PUB_NBOBA  = M.AZI_NBOBA
PUB_CTRGIA = M.AZI_CTRGIA
PUB_CTRORF = M.AZI_CTRORF
PUB_CLIDIR = M.AZI_CLIDIR
PUB_CAUDIR = M.AZI_CAUDIR
PUB_CERTIF = M.AZI_CERTIF
PUB_GIAADF = M.AZI_GIAADF
PUB_FORPRE = M.AZI_FORPRE
PUB_TIPCON = M.AZI_TIPCON  
PUB_PRZBAS = M.AZI_PRZBAS  
PUB_DATOLD = M.AZI_DATOLD  
PUB_CAMCOS = M.AZI_CAMCOS 
PUB_CAUANT = M.AZI_CAUANT
PUB_CAUAVA = M.AZI_CAUAVA
PUB_CAUSAL = M.AZI_CAUSAL
PUB_COMSEM = M.AZI_COMSEM
PUB_CPAINC = M.AZI_CPAINC
PUB_ARTINC = M.AZI_ARTINC
PUB_CAUCFO = M.AZI_CAUCFO
PUB_CAUCSP = M.AZI_CAUCSP
PUB_CAUSSP = M.AZI_CAUSSP
PUB_CAUSFA = M.AZI_CAUSFA
PUB_OREGIO = M.AZI_OREGIO
PUB_CAUCMA = M.AZI_CAUCMA
PUB_DDTRIC = M.AZI_DDTRIC
IF EMPTY(PUB_IVA)
   PUB_IVA = "22 "
ENDIF
PUB_PERCENTUALE_IVA_DEFAULT  = 0
=DETERMINA_ALIQUOTA_IVA_DEFAULT()
PUB_UM     = M.AZI_UM
IF EMPTY(PUB_UM)
   PUB_UM = "NR"
ENDIF
PUB_VERYD  = M.AZI_VERYD
PUB_SPINC  = M.AZI_SPINC
PUB_SCAFA  = M.AZI_SCAFA
PUB_CFDEF  = M.AZI_CFDEF
PUB_CADEF  = M.AZI_CADEF
PUB_WEBRCF = M.AZI_WEBRCF
PUB_WEBRCD = M.AZI_WEBRCD
PUB_WEBTRF = M.AZI_WEBTRF
PUB_WEBTRD = M.AZI_WEBTRD
PUB_MLPLTU = M.AZI_MLPLTU
PUB_MLPLDT = M.AZI_MLPLDT
PUB_MLEBDT = M.AZI_MLEBDT
PUB_QTAORF = M.AZI_QTAORF
PUB_MAGLOG = M.AZI_MAGLOG
PUB_PROGAA = M.AZI_PROGAA
PUB_NOSPOO = M.AZI_NOSPOO
PUB_CAULES = M.AZI_CAULES
PUB_SC1    = M.AZI_SC1
PUB_SC2    = M.AZI_SC2
PUB_SC3    = M.AZI_SC3
PUB_PROVVI = M.AZI_PROVVI
PUB_PAGANT = M.AZI_PAGANT
PUB_BFO    = M.AZI_BFO
PUB_BOLFOR = M.AZI_BOLFOR
PUB_CTRLBF = M.AZI_CTRLBF
PUB_CODBUN = M.AZI_CODBUN
PUB_VISRIC = M.AZI_VISRIC
PUB_VISRID = M.AZI_VISRID
PUB_CAUPDV = M.AZI_CAUPDV
PUB_FTPROT = M.AZI_FTPROT
PUB_FTPRIC = M.AZI_FTPRIC
PUB_CAUTRA = ALLTRIM(M.AZI_CAUTRA)
PUB_RESCLI = ALLTRIM(M.AZI_RESCLI)
PUB_GESTIONE_MULTIANNO = M.AZI_MULTIANNO    		
PUB_NFATDIFFERITA      = M.AZI_NFATDIFFERITA    	
PUB_CAUSOS = M.AZI_CAUSOS
PUB_RICONF = M.AZI_RICONF   
PUB_DECQTA = M.AZI_DECQTA   
PUB_DECPRZ = M.AZI_DECPRZ  
PUB_DECVAL = M.AZI_DECVAL  
PUB_CARORF = M.AZI_CARORF
PUB_CQUMPC = M.AZI_CQUMPC
PUB_CQUMPN = M.AZI_CQUMPN
PUB_SPAPRO = M.AZI_SPAPRO
PUB_SPAMPR = M.AZI_SPAMPR
PUB_SPACQS = M.AZI_SPACQS
PUB_CQUSLC = M.AZI_CQUSLC
PUB_CQUSLN = M.AZI_CQUSLN
PUB_RIBPRO = M.AZI_RIBPRO
PUB_RIBSLR = M.AZI_RIBSLR
PUB_RIBSLO = M.AZI_RIBSLO
PUB_TAGPRO = M.AZI_TAGPRO
PUB_TAGSLR = M.AZI_TAGSLR
PUB_TAGPFO = M.AZI_TAGPFO
PUB_ALTLUN = M.AZI_ALTLUN
*=RICERCA_DESMAGPROD()
SELECT u_azi_an
IF EMPTY(PUB_CADEF)
   PUB_CADEF = '0001004         '
ENDIF
PUB_NBOIE  = M.AZI_NBOIE
PUB_NFANC  = M.AZI_NFANC
PUB_LIS01  = M.AZI_LIS01
PUB_LIS02  = M.AZI_LIS02
PUB_LIS03  = M.AZI_LIS03
PUB_LIS04  = M.AZI_LIS04
PUB_LIS05  = M.AZI_LIS05
PUB_LIS06  = M.AZI_LIS06
PUB_LIS07  = M.AZI_LIS07
PUB_LIS08  = M.AZI_LIS08
PUB_LIS09  = M.AZI_LIS09
PUB_LIS10  = M.AZI_LIS10
PUB_LIS0A  = M.AZI_LIS0A
PUB_LINEA  = M.AZI_LINEA
PUB_STFAD  = M.AZI_STFAD
PUB_STFAT  = M.AZI_STFAT
PUB_STFAP  = M.AZI_STFAP
IF EMPTY(PUB_LINEA)
   PUB_LINEA = "1 "
ENDIF
PUB_CPA    = M.AZI_CPA
IF EMPTY(PUB_CPA)
   PUB_CPA = "101"
ENDIF
PUB_AGE    = M.AZI_AGE
IF EMPTY(PUB_AGE)
   PUB_AGE = "001"
ENDIF
PUB_VALU  = M.AZI_VALU
IF EMPTY(PUB_VALU)
   PUB_VALU = PUB_VALRIF
ENDIF
PUB_NAZI  = M.AZI_NAZI
IF EMPTY(PUB_NAZI)
   PUB_NAZI = "ITL"
ENDIF
PUB_CLISOC = AZI_CODCLI
PUB_RAGSOC = AZI_RAGSOC
PUB_FORMAR = AZI_FORMAR
PUB_LOCALI = ALLTRIM(AZI_LOCALI)   		&& SERGIO 10/08/2011
PUB_PIVA   = AZI_PIVA					&& SERGIO 29/04/2012
PUB_CODFIS = AZI_CODFIS					&& SERGIO 29/04/2012
PUB_LIBERA = AZI_LIBERA				    && SERGIO 29/04/2012
PUB_IVACEE = AZI_IVACEE					&& SERGIO 29/04/2012
PUB_TELEFO = AZI_TELEFO					&& SERGIO 29/04/2012
PUB_FAX    = AZI_FAX					&& SERGIO 29/04/2012
PUB_INDIRI = ALLTRIM(AZI_INDIRI)		&& SERGIO 29/04/2012
PUB_MLDOCA = AZI_MLDOCA
PUB_MASTRO = AZI_MASTRO   && GRUPPO CONTABILITA GENERALE       + 1
PUB_SOTTOG = AZI_SOTTOG   && SOTTOGRUPPO CONTABILITA GENERALE  + 1
PUB_LCL    = AZI_CONTO    && CONTO CONTABILE
PUB_CONTO  = AZI_CONTO
IF PUB_MASTRO <> 0
   PUB_MASTRO = PUB_MASTRO + 1
ELSE
   PUB_MASTRO = 4
ENDIF
IF PUB_SOTTOG <> 0
   PUB_SOTTOG = PUB_ + 1
ELSE
   PUB_SOTTOG = 6
ENDIF
IF PUB_LCL = 0					&& valore già impostato e valido anche per i clienti/fornitori
   PUB_LCL = (14 - PUB_SOTTOG)
ENDIF

PUB_EAISBN = M.AZI_EAISBN

PUB_CTRTAG = M.AZI_CTRTAG
PUB_CTRCOL = M.AZI_CTRCOL
PUB_CATACO = M.AZI_CATACO
PUB_ARTRES = M.AZI_ARTRES
PUB_CAURES = M.AZI_CAURIF
PUB_CAUREC = M.AZI_CAUREC
PUB_CAUREF = M.AZI_CAUREF
PUB_CAUCAS = M.AZI_CAUCAS
PUB_CODCAS = M.AZI_CODCAS
PUB_GESEDI = M.AZI_GESEDI
PUB_NUMLOT = M.AZI_NUMLOT
PUB_TIPCAS = M.AZI_TIPCAS
PUB_ARTABB = M.AZI_ARTABB
PUB_COSATRATTA 				= M.AZI_COSATRATTA
PUB_GRADOIMPORTANZA 		= M.AZI_GRADOIMPORTANZA
PUB_FORMAPAGAMENTO 			= M.AZI_FORMAPAGAMENTO
PUB_TIPOCONTRATTO 			= M.AZI_TIPOCONTRATTO
PUB_CONAQUISTO 				= M.AZI_CONAQUISTO	
PUB_PRIORITAPAGAMENTO 		= M.AZI_PRIPAGA	
PUB_NOSOL  = AZI_NOSOL
PUB_AACDAL = AZI_AACDAL
PUB_AACAL  = AZI_AACAL
PUB_AACDAL_P = gdata(alltrim(str(val(substr(ribalta2(PUB_AACDAL),1,4))-1))+SUBSTR(ribalta2(PUB_AACDAL),5,6))
PUB_AACAL_P  = gdata(alltrim(str(val(substr(ribalta2(PUB_AACAL),1,4))-1))+SUBSTR(ribalta2(PUB_AACAL),5,6))
IF PUB_NOSOL
ELSE
   PUB_AACDAL = SPACE(10)
   PUB_AACAL  = SPACE(10)
   PUB_AACDAL_P = SPACE(10)
   PUB_AACAL_P  = SPACE(10)
ENDIF
PUB_PAGAFOR = M.AZI_PAGAFOR
PUB_TRF   	= AZI_TRF
PUB_PAGANCR = AZI_PAGANCR
PUB_IMPEGN 	 	= AZI_IMPEGN  	
=_OPERAT(PUB_CODOPE)  && GESTIONE ABILITAZIONE FUNZIONI OPERATORE
IF !ExecCommand("select * from u_azi_pa","u_azi_pa")
   return
ENDIF
SELECT u_azi_pa
GO TOP 
IF reccount() <> 0
ELSE
   WAIT WINDOW "Per cortesia codificare i parametri aziendali U_AZI_PA"
   RETURN
ENDIF
PUB_VMAGAZ   =  AZI_VMAGAZ
PUB_VARTIC   =  AZI_VARTIC
PUB_VMAGPE   =  AZI_VMAGPE
PUB_VMAGAR   =  AZI_VMAGAR
PUB_VMARPE   =  AZI_VMARPE
PUB_VFOMAR   =  AZI_VFOMAR
PUB_VFOMAP   =  AZI_VFOMAP
PUB_VFORNI   =  AZI_VFORNI
PUB_VMAGTC   =  AZI_VMAGTC
PUB_VMATCH   =  AZI_VMATCH 
PUB_VAMFTC   =  AZI_VAMFTC  
PUB_POLIEC   =  AZI_POLIEC
PUB_TOPINV   =  AZI_TOPINV
PUB_FISCALE  =  AZI_FISCALE
PUB_NOTCEE  =  AZI_NOTCEE
PUB_FATRC   =  AZI_FATRC
PUB_NOTRC   =  AZI_NOTRC
PUB_IVANAG  =  AZI_IVANAG
PUB_PRGPRD  = AZI_PRGPRD
PUB_SISCUR  = AZI_SISCUR
PUB_CODREC  = AZI_CODREC
PUB_LIS11   = AZI_LIS11
PUB_GGDTSP  = AZI_GGDTSP
PUB_STIPE   = AZI_STIPE
PUB_INCCLI  = AZI_INCCLI
PUB_EFFPAS  = AZI_EFFPAS
PUB_EFFATT  = AZI_EFFATT
PUB_CONTR   = AZI_CONTR
PUB_LEASIN  = AZI_LEASIN
PUB_FINAN   = AZI_FINAN
PUB_COMCLI  = AZI_COMCLI
PUB_COMFOR  = AZI_COMFOR
PUB_DARE    = AZI_DARE
PUB_AVERE   = AZI_AVERE
PUB_MOVLOG  = AZI_MOVLOG
PUB_ANTRIB  = AZI_ANTRIB
PUB_USATES = AZI_USATES 
PUB_NRSEBF = AZI_NRSEBF		
PUB_PROTFA = AZI_PROTFA    
PUB_AGGPRO = AZI_AGGPRO 
PUB_PROTCI = AZI_PROTCI 
PUB_NRSEBC = AZI_NRSEBC	
PUB_RRIFOR = AZI_RRIFOR
PUB_CCOSTD = AZI_CCOSTD		
PUB_CCOACLI = AZI_CCOACLI	
PUB_CCOAART = AZI_CCOAART	
PUB_CCOPDC = AZI_CCOPDC	
PUB_CCOCLI = AZI_CCOCLI		
PUB_CCOFOR = AZI_CCOFOR		
PUB_CCOSTD = AZI_CCOSTD		
PUB_MAGNO0 = AZI_MAGNO0		
PUB_TOPCAM = AZI_TOPCAM		
PUB_BENDUR = AZI_BENDUR	
PUB_FATRIA = AZI_FATRIA     && SERGIO 01/04/2007
PUB_NUCOCG = AZI_NUCOCG		&& SERGIO 01/04/2007
PUB_NUCOAQ = AZI_NUCOAQ		&& SERGIO 01/04/2007
PUB_NUCOAS = AZI_NUCOAS		&& SERGIO 01/04/2007
PUB_NUCOOK = AZI_NUCOOK		&& SERGIO 01/04/2007
PUB_CLIRIC = AZI_CLIRIC		&& ERASMO 13/04/2007
PUB_CARFOR = AZI_CARFOR		&& SERGIO 15/04/2007
PUB_SDBSIG = AZI_SDBSIG     && SERGIO 01/07/2007
PUB_SDBNOG = AZI_SDBNOG     && SERGIO 01/07/2007
PUB_CDBSIG = AZI_CDBSIG     && SERGIO 01/07/2007
PUB_CDBNOG = AZI_CDBNOG     && SERGIO 01/07/2007
PUB_IDSOCI = AZI_IDSOCI 	&& SERGIO 14/10/2007
PUB_CEEUNO = AZI_CEEUNO 	&& SERGIO 14/01/2008
PUB_PRENOT = AZI_PRENOT 	&& ERASMO 12/05/2008
PUB_ORDINT = AZI_ORDINT 	&& FABIANO 02/06/2008
PUB_FABBIS = AZI_FABBIS	    && FABIANO 02/06/2008
PUB_PRSSTD  = AZI_PRSSTD   	&& SERGIO 02/08/2008
PUB_PRDFILM = AZI_PRDFILM	&& SERGIO 02/08/2008
PUB_PRMMOL  = AZI_PRMMOL	&& SERGIO 02/08/2008
PUB_PRTTES  = AZI_PRTTES	&& SERGIO 02/08/2008
PUB_ECORIS  = AZI_ECORIS	&& SERGIO 19/08/2008
PUB_SPASCA  = AZI_SPASCA	&& SIMONE - 25/02/2009
PUB_LOGBOL  = AZI_LOGBOL	&& ERASMO - 02/11/2009
PUB_TAGAGE  = AZI_TAGAGE	&& ERASMO - 06/08/2010
PUB_CAUMOV  = AZI_CAUMOV	&& ERASMO - 17/09/2010
PUB_DESKTOP = AZI_DESKTOP   && SERGIO 26/08/2010	
PUB_PASS  	= AZI_PASS  	&& SERGIO 26/08/2010
PUB_PASS_SW	= AZI_PASS_SW	&& SERGIO 26/08/2010
PUB_SCRIT_B	= AZI_SCRIT_B	&& SERGIO 26/08/2010
PUB_SCRIT_N	= AZI_SCRIT_N	&& SERGIO 26/08/2010 
PUB_SCRIT_R	= AZI_SCRIT_R	&& SERGIO 26/08/2010
PUB_AQUAR   = AZI_AQUAR   	&& SERGIO 26/08/2010
PUB_PASS_B  = AZI_PASS_B  	&& SERGIO 26/08/2010
PUB_PASS_N  = AZI_PASS_N 	&& SERGIO 26/08/2010
PUB_PASS_R  = AZI_PASS_R 	&& SERGIO 26/08/2010
PUB_SUBMEN  = AZI_SUBMEN 	&& SERGIO 26/08/2010
PUB_SCRIT   = AZI_SCRIT   	&& SERGIO 26/08/2010
PUB_PRORATA = AZI_PRORATA	&& SERGIO 25/11/2010
PUB_CGMAGA  = AZI_CGMAGA	&& ERASMO - 28/12/2010
PUB_VERSRA  = AZI_VERSRA	&& SERGIO 13/01/2011 INIZIO
PUB_NOQUAD  = AZI_NOQUAD	&& SERGIO 01/02/2011
PUB_FATSTU  = AZI_FATSTU	&& ERASMO - 03/02/2011
PUB_NRSENO  = AZI_NRSENO	&& SIMONE - 07/03/2011
PUB_PROTNO  = AZI_PROTNO	&& SIMONE - 07/03/2011    
PUB_INSBFO  = AZI_INSBFO	&& ERASMO - 27/04/2011
PUB_MPIU    = AZI_MPIU		&& SERGIO - 05/05/2011
PUB_MMEN    = AZI_MMEN		&& SERGIO - 05/05/2011
PUB_ZTLSHW  = AZI_ZTLSHW	&& ERASMO - 18/05/2011
PUB_BFP     = AZI_BFP		&& SERGIO - 23/08/2011
PUB_MAXRDA = AZI_MAXRDA 	&& ERASMO - 02/09/2011 
PUB_MACINA = AZI_MACINA 	&& ERASMO - 02/09/2011
PUB_PRESSA = AZI_PRESSA 	&& ERASMO - 02/09/2011 
PUB_TAGLIO = AZI_TAGLIO 	&& ERASMO - 02/09/2011 
PUB_LEVIGA = AZI_LEVIGA 	&& ERASMO - 02/09/2011 
PUB_NOBILI = AZI_NOBILI 	&& ERASMO - 02/09/2011 
PUB_PROFIN = AZI_PROFIN 	&& ERASMO - 02/09/2011 
PUB_TFATT  = AZI_TFATT	    && SERGIO - 25/09/2011 
PUB_PRGPLET = AZI_PRGPLET   && SERGIO - 16/10/2011 
PUB_CBI     = AZI_CBI       && FABIANO - 27/11/2011 
PUB_ARRNID = AZI_ARRNID     && ERASMO - 29/11/2011 
PUB_LIS12  = AZI_LIS12      && SERGIO - 08/12/2011 
PUB_LIS13  = AZI_LIS13      && SERGIO - 08/12/2011 
PUB_LIS14  = AZI_LIS14      && SERGIO - 08/13/2011 
PUB_TOPTRI = AZI_TOPTRI		&& FABIANO - 23/12/2011
PUB_TOPPNC = AZI_TOPPNC		&& FABIANO - 23/12/2011
PUB_GGRIBA = AZI_GGRIBA		&& FABIANO - 30/12/2011
PUB_YESLOGBOL  	= AZI_YESLOGBOL	&& ERASMO - 19/01/2012
PUB_DOGCOM  	= AZI_DOGCOM  	&& ERASMO - 19/01/2012
PUB_NOPOSTI     = AZI_NOPOSTI   && SERGIO - 18/02/2012
PUB_TRATTA     	= AZI_TRATTA    && FABIANO - 22/03/2012
PUB_NBOREF     	= AZI_NBOREF    && SERGIO - 03/06/2012
PUB_LEVIGA1 	= AZI_LEVIGA1 	&& ERASMO - 28/06/2012 
PUB_LEVIGA2 	= AZI_LEVIGA2 	&& ERASMO - 28/06/2012
PUB_LEVIGA3 	= AZI_LEVIGA3 	&& ERASMO - 28/06/2012
PUB_LIFSCO  	= AZI_LIFSCO    && SERGIO - 09/07/2012
PUB_CAUVBA  	= AZI_CAUVBA	&& SERGIO - 13/07/2012
PUB_CLIMAG  	= AZI_CLIMAG	&& SERGIO - 15/07/2012
PUB_SCAPPT  	= AZI_SCAPPT	&& SERGIO - 18/08/2012
PUB_CAIPPT  	= AZI_CAIPPT	&& SERGIO - 20/08/2012
PUB_ARTPRE	 	= AZI_ARTPRE 	&& ERASMO - 27/08/2012
PUB_GIANEG      = AZI_GIANEG	&& SERGIO - 05/09/2012
PUB_CAUGNE		= AZI_CAUGNE	&& SERGIO - 16/09/2012 
PUB_CAPAGL		= AZI_CAPAGL	&& SERGIO - 16/09/2012 
PUB_CAUSMP 		= AZI_CAUSMP	&& SERGIO - 16/09/2012 
PUB_CAURIM 		= AZI_CAURIM 	&& SERGIO - 16/09/2012
PUB_CAUSPR 		= AZI_CAUSPR 	&& SERGIO - 16/09/2012
PUB_ARTSPR 		= AZI_ARTSPR 	&& SERGIO - 16/09/2012
PUB_CAUCAL 		= AZI_CAUCAL 	&& SERGIO - 16/09/2012
PUB_CAUSCL 		= AZI_CAUSCL 	&& SERGIO - 16/09/2012
PUB_CACARI 		= AZI_CACARI 	&& SERGIO - 16/09/2012
PUB_CASCRI 		= AZI_CASCRI 	&& SERGIO - 16/09/2012
PUB_CACATA 		= AZI_CACATA 	&& SERGIO - 16/09/2012
PUB_CASCTA 		= AZI_CASCTA 	&& SERGIO - 16/09/2012
PUB_CACART 		= AZI_CACART 	&& SERGIO - 16/09/2012
PUB_CASCRT 		= AZI_CASCRT 	&& SERGIO - 16/09/2012
PUB_CASCLE 		= AZI_CASCLE 	&& SERGIO - 16/09/2012
PUB_ARTSLE 		= AZI_ARTSLE 	&& SERGIO - 16/09/2012
PUB_CAPRNO 		= AZI_CAPRNO 	&& SERGIO - 16/09/2012
PUB_SCPRNO 		= AZI_SCPRNO 	&& SERGIO - 16/09/2012
PUB_CASCNO 		= AZI_CASCNO 	&& SERGIO - 16/09/2012
PUB_ARTSNO 		= AZI_ARTSNO 	&& SERGIO - 16/09/2012
PUB_LCKPRE	 	= AZI_LCKPRE 	&& ERASMO - 26/09/2012
PUB_LCKLEV	 	= AZI_LCKLEV 	&& ERASMO - 26/09/2012
PUB_LCKNOB	 	= AZI_LCKNOB 	&& ERASMO - 26/09/2012
PUB_GGCONS 	 	= AZI_GGCONS  	&& ERASMO - 10/10/2012
PUB_FLGPCO 	 	= AZI_FLGPCO  	&& ERASMO - 25/10/2012
PUB_NODBPN 	 	= AZI_NODBPN  	&& ERASMO - 06/11/2012
PUB_CDAPRD 		= AZI_CDAPRD		&& ERASMO - 13/12/2012
PUB_MSGORDNODB 	= AZI_MSGORDNODB	&& ERASMO - 13/12/2012
PUB_LCKORDNODB 	= AZI_LCKORDNODB	&& ERASMO - 13/12/2012
PUB_IVAXCA      = AZI_IVAXCA    && SERGIO - 03/01/2013
PUB_SAUFOR 	 	= AZI_SAUFOR  	&& ERASMO - 29/01/2013
PUB_PRZDIB 		= AZI_PRZDIB 	&& SERGIO - 30/01/2013
PUB_LOGSQL 	 	= AZI_LOGSQL  	&& ERASMO - 12/02/2013
PUB_CESCOM	 	= AZI_CESCOM	&& SERGIO - 22/02/2013
PUB_DOGBOL	 	= AZI_DOGBOL	&& ERASMO - 25/02/2013
PUB_DOGART	 	= AZI_DOGART	&& ERASMO - 25/02/2013
PUB_OPZRSK	 	= AZI_OPZRSK	&& ERASMO - 07/03/2013
PUB_PKRSTA	 	= AZI_PKRSTA	&& ERASMO - 07/03/2013
PUB_BOLIVA1	 	= AZI_BOLIVA1	&& SERGIO - 08/03/2013
PUB_DDTQTADOPPIE = AZI_DDTQTADOPPIE && FABIANO - 09/03/2013
PUB_PKREML 	 	= AZI_PKREML	&& ERASMO - 14/03/2013
PUB_NOSALDI	 	= AZI_NOSALDI	&& SERGIO - 20/03/2013
PUB_PKAUPE 	 	= AZI_PKAUPE	&& ERASMO - 22/03/2013
PUB_DDTLCK 	 	= AZI_DDTLCK	&& ERASMO - 22/03/2013
PUB_PKNCAU 	 	= AZI_PKNCAU	&& ERASMO - 25/03/2013
PUB_FATIDR      = AZI_FATIDR	&& SERGIO - 06/04/2013
PUB_PERIDR		= AZI_PERIDR	&& SERGIO - 06/04/2013
PUB_PGGCLS 	 	= AZI_PGGCLS	&& ERASMO - 14/05/2013
PUB_SSPORD 	 	= AZI_SSPORD	&& ERASMO - 11/06/2013
PUB_SSPFAP 	 	= AZI_SSPFAP	&& ERASMO - 11/06/2013
PUB_SSPFAT 	 	= AZI_SSPFAT	&& ERASMO - 11/06/2013
PUB_SSPORF 	 	= AZI_SSPORF	&& ERASMO - 11/06/2013
PUB_PRGDADI	 	= AZI_PRGDADI	&& ERASMO - 13/06/2013
PUB_NUMBAN	 	= AZI_NUMBAN	&& SERGIO - 21/06/2013
PUB_PERRIM	 	= AZI_PERRIM	&& ERASMO - 08/10/2013
PUB_PRDISP	 	= AZI_PRDISP	&& ERASMO - 10/10/2013
PUB_RIPACC      = AZI_RIPACC    && SERGIO - 13/10/2013
PUB_CAPPDMPREL	= AZI_CAPPDMPREL	&& ERASMO - 24/10/2013
PUB_SCPPDMPREL	= AZI_SCPPDMPREL	&& ERASMO - 24/10/2013
PUB_CAPPDMVERS	= AZI_CAPPDMVERS	&& ERASMO - 24/10/2013
PUB_SCPPDMVERS	= AZI_SCPPDMVERS	&& ERASMO - 24/10/2013
PUB_PDMLINPF	= AZI_PDMLINPF		&& ERASMO - 24/10/2013
PUB_PDMLINSL	= AZI_PDMLINSL		&& ERASMO - 24/10/2013
PUB_MAGPDMPREL	= AZI_MAGPDMPREL	&& ERASMO - 24/10/2013
PUB_MAGPDMVERS	= AZI_MAGPDMVERS	&& ERASMO - 24/10/2013
PUB_OASFAT		= AZI_OASFAT	    && ERASMO - 31/10/2013
PUB_DDTFATALL	= AZI_DDTFATALL	    && SERGIO - 14/11/2013
PUB_NUMAUTRDA	= AZI_NUMAUTRDA	    && SERGIO - 14/11/2013
PUB_REMOTE		= AZI_REMOTE		&& SERGIO - 16/11/2013
PUB_CONTES 		= AZI_CONTES		&& SERGIO - 01/12/2013
PUB_CONDET 		= AZI_CONDET		&& SERGIO - 01/12/2013 
PUB_CONXRIG 	= AZI_CONXRIG		&& SERGIO - 01/12/2013 
PUB_CONOBL 		= AZI_CONOBL		&& SERGIO - 01/12/2013 
PUB_CCOTES 		= AZI_CCOTES		&& SERGIO - 01/12/2013 
PUB_CCODET 		= AZI_CCODET		&& SERGIO - 01/12/2013 
PUB_CCOXRIG 	= AZI_CCOXRIG		&& SERGIO - 01/12/2013 
PUB_CCOOBL 		= AZI_CCOOBL		&& SERGIO - 01/12/2013 
PUB_NORIFORD 	= AZI_NORIFORD		&& SERGIO - 01/12/2013 
PUB_NORIFFAT 	= AZI_NORIFFAT		&& SERGIO - 01/12/2013 
PUB_TPAEGRU 	= AZI_TPAEGRU		&& SERGIO - 05/12/2013 
PUB_CCORIGA 	= AZI_CCORIGA		&& SERGIO - 05/12/2013 
PUB_NORIFBOL	= AZI_NORIFBOL		&& SERGIO - 06/12/2013     
PUB_LISAV		= AZI_LISAV			&& SERGIO - 13/12/2013     
PUB_LISAA		= AZI_LISAA			&& SERGIO - 13/12/2013     
PUB_ANTEP		= AZI_ANTEP			&& SERGIO - 15/12/2013     
PUB_CONFAT		= AZI_CONFAT		&& SERGIO - 15/12/2013 
PUB_PDMLINSE	= AZI_PDMLINSE		&& ERASMO - 16/12/2013
PUB_OPZPRN		= AZI_OPZPRN		&& ERASMO - 18/12/2013
PUB_XLSALL		= AZI_XLSALL		&& ERASMO - 18/12/2013
PUB_LDTBFO		= AZI_LDTBFO		&& ERASMO - 19/12/2013
PUB_NCLBOL		= AZI_NCLBOL		&& ERASMO - 30/12/2013
PUB_NODSTFAT	= AZI_NODSTFAT		&& ERASMO - 31/12/2013
PUB_INTRASTAT	= AZI_INTRASTAT		&& SERGIO - 01/01/2014
PUB_ULTCAM		= AZI_ULTCAM		&& FABIANO- 01/01/2014
PUB_CODSIA		= AZI_CODSIA		&& FABIANO- 07/01/2014 CODICE SIA
PUB_DIRCBI		= AZI_DIRCBI		&& FABIANO- 07/01/2014 DIRECTORY FILE CBI
PUB_CAUDEP		= AZI_CAUDEP		&& ERASMO - 14/01/2014
PUB_SETSNO 		= AZI_SETSNO		&& ERASMO - 14/01/2014
PUB_COMSNO 		= AZI_COMSNO		&& ERASMO - 14/01/2014
PUB_ANACLI      = AZI_ANACLI        && SERGIO - 18/01/2014
IF !ExecCommand("select * from u_azi_pb","u_azi_pb")	&& SERGIO - 18/01/2014
   return												&& SERGIO - 18/01/2014
ENDIF													&& SERGIO - 18/01/2014
SELECT u_azi_pb											&& SERGIO - 18/01/2014
GO TOP 													&& SERGIO - 18/01/2014
IF reccount() <> 0										&& SERGIO - 18/01/2014
ELSE													&& SERGIO - 18/01/2014
   WAIT WINDOW "Per cortesia codificare i parametri aziendali U_AZI_PB"
   RETURN
ENDIF
PUB_NOSKPROD 			= AZI_NOSKPROD      		&& SERGIO - 18/01/2014
PUB_NOCONTI  			= AZI_NOCONTI       		&& SERGIO - 18/01/2014
PUB_NOCAMPICLI  		= AZI_NOCAMPICLI    		&& SERGIO - 18/01/2014
PUB_ANAART				= AZI_ANAART				&& SERGIO - 21/01/2014
PUB_DOCDDT				= AZI_DOCDDT 				&& SERGIO - 21/01/2014
PUB_DOCORD				= AZI_DOCORD 				&& SERGIO - 22/01/2014
PUB_IVAINTRA    		= AZI_IVAINTRA				&& SERGIO - 26/01/2014
PUB_NOSKALTRID  		= AZI_NOSKALTRID			&& SERGIO - 26/01/2014
PUB_NODATISPE   		= AZI_NODATISPE				&& SERGIO - 26/01/2014
PUB_NOCAMPIORD  		= AZI_NOCAMPIORD			&& SERGIO - 04/02/2014
PUB_CALCSCO				= AZI_CALCSCO				&& SERGIO - 05/02/2014
PUB_NOCAMPIART 			= AZI_NOCAMPIART 			&& SERGIO - 08/02/2014
PUB_CALSCOF 			= AZI_CALSCOF				&& SERGIO - 12/02/2014
PUB_CALSCBO 			= AZI_CALSCBO				&& SERGIO - 12/02/2014
PUB_CALSCFP 			= AZI_CALSCFP				&& SERGIO - 12/02/2014
PUB_CALSCFT 			= AZI_CALSCFT				&& SERGIO - 12/02/2014
PUB_CALSCOR 			= AZI_CALSCOR				&& SERGIO - 12/02/2014
PUB_PLAFACQ 			= AZI_PLAFACQ				&& SERGIO - 15/02/2014
PUB_TIMEEV	 			= AZI_TIMEEV				&& FABIANO - 17/02/2014
PUB_IVADEDU  			= AZI_IVADEDU 				&& SERGIO - 24/02/2014
PUB_CAPPMIPREL			= AZI_CAPPMIPREL			&& ERASMO - 26/02/2014
PUB_SCPPMIPREL			= AZI_SCPPMIPREL			&& ERASMO - 26/02/2014
PUB_CAPPMIVERS			= AZI_CAPPMIVERS			&& ERASMO - 26/02/2014
PUB_SCPPMIVERS			= AZI_SCPPMIVERS			&& ERASMO - 26/02/2014
PUB_PMILINPF			= AZI_PMILINPF				&& ERASMO - 26/02/2014
PUB_PMILINSL			= AZI_PMILINSL				&& ERASMO - 26/02/2014
PUB_PMILINSE			= AZI_PMILINSE				&& ERASMO - 26/02/2014
PUB_MAGPMIPREL			= AZI_MAGPMIPREL			&& ERASMO - 26/02/2014
PUB_MAGPMIVERS			= AZI_MAGPMIVERS			&& ERASMO - 26/02/2014
PUB_REGISTRA_TOOLBAR  	= AZI_REGISTRA_TOOLBAR 		&& SERGIO - 26/02/2014
PUB_DOCOFF				= AZI_DOCOFF				&& SERGIO - 01/03/2014
PUB_DOCFAP				= AZI_DOCFAP				&& SERGIO - 01/03/2014
PUB_DOCFAT				= AZI_DOCFAT				&& SERGIO - 01/03/2014
PUB_QUOAMM				= AZI_QUOAMM				&& SERGIO - 09/03/2014
PUB_GNELAU				= AZI_GNELAU				&& ERASMO - 10/03/2014
PUB_STBIL_DA_MOV_CONT	= AZI_STBIL_DA_MOV_CONT		&& SERGIO - 11/03/2014
PUB_RICFLD				= AZI_RICFLD				&& ERASMO - 11/03/2014
PUB_NOUPPER				= AZI_NOUPPER				&& ERASMO - 11/03/2014
PUB_PDMLINPV			= AZI_PDMLINPV				&& ERASMO - 28/04/2014
PUB_OPZDBCOST			= AZI_OPZDBCOST				&& ERASMO - 09/05/2014
PUB_CSTSEC				= AZI_CSTSEC				&& ERASMO - 19/05/2014
PUB_PRDFPR				= AZI_PRDFPR				&& ERASMO - 20/05/2014
PUB_TYPERDA				= AZI_TYPERDA				&& ERASMO - 05/06/2014
PUB_CTRLCCO 			= AZI_CTRLCCO 				&& SERGIO - 22/06/2014
PUB_WEBRDA				= AZI_WEBRDA				&& ERASMO - 20/06/2014
PUB_PFPLINPV 			= AZI_PFPLINPV				&& ERASMO - 03/07/2014
PUB_PERSFAT 			= AZI_PERSFAT				&& SERGIO - 10/08/2014
PUB_NOSTPCOMPESORD 		= AZI_NOSTPCOMPESORD		&& ERASMO - 25/08/2014
PUB_NOSTPCOMPESBOL 		= AZI_NOSTPCOMPESBOL		&& ERASMO - 25/08/2014
PUB_NOSTPCOMPESFAT 		= AZI_NOSTPCOMPESFAT		&& ERASMO - 25/08/2014
PUB_NOSTPCOMPESFAP 		= AZI_NOSTPCOMPESFAP		&& ERASMO - 25/08/2014
PUB_NOLOGO				= AZI_NOLOGO				&& SERGIO - 26/08/2014
PUB_STPORDMAG			= AZI_STPORDMAG				&& ERASMO - 27/08/2014
PUB_NOSTPCOMPESORDEXT	= AZI_NOSTPCOMPESORDEXT		&& ERASMO - 29/08/2014
PUB_NOSTPCOMPESBOLEXT	= AZI_NOSTPCOMPESBOLEXT		&& ERASMO - 29/08/2014
PUB_NOSTPCOMPESFATEXT	= AZI_NOSTPCOMPESFATEXT		&& ERASMO - 29/08/2014
PUB_NOSTPCOMPESFAPEXT	= AZI_NOSTPCOMPESFAPEXT		&& ERASMO - 29/08/2014
PUB_STPPES_LOR_NET_IMB  = AZI_STPPES_LOR_NET_IMB 	&& SERGIO - 29/08/2014
PUB_STPDESTINAZIONE		= AZI_STPDESTINAZIONE	 	&& SERGIO - 29/08/2014
PUB_NOLOCCF				= AZI_NOLOCCF	 			&& SERGIO - 13/09/2014
PUB_NOLOCCM				= AZI_NOLOCCM	 			&& SERGIO - 13/09/2014
PUB_FLCONF				= AZI_FLCONF				&& SERGIO - 30/09/2014
PUB_FLDTCON				= AZI_FLDTCON				&& SERGIO - 30/09/2014
PUB_FLPORTO				= AZI_FLPORTO				&& SERGIO - 01/10/2014
PUB_GGCNSO				= AZI_GGCNSO				&& ERASMO - 28/10/2014
PUB_PDMCCOSTO			= AZI_PDMCCOSTO				&& ERASMO - 07/11/2014
PUB_PDMOPZPC			= AZI_PDMOPZPC				&& ERASMO - 07/11/2014
PUB_CAPPDMSPED			= AZI_CAPPDMSPED			&& ERASMO - 26/11/2014
PUB_SCPPDMSPED			= AZI_SCPPDMSPED			&& ERASMO - 26/11/2014
PUB_OBLGBCKCOL			= AZI_OBLGBCKCOL			&& ERASMO - 03/12/2014
PUB_RDACCO				= AZI_RDACCO				&& ERASMO - 09/12/2014
PUB_PERSDOC				= AZI_PERSDOC				&& ERASMO - 11/12/2014
PUB_NOWINM				= AZI_NOWINM 			    && FABIANO - 05/01/2015
PUB_DDT_POLIEC			= AZI_DDT_POLIEC		    && SERGIO - 21/01/2015
PUB_COMSTD				= AZI_COMSTD				&& ERASMO - 30/01/2015
PUB_OSPEPOL				= AZI_OSPEPOL				&& ERASMO - 02/02/2015
PUB_RICCONTDES			= AZI_RICCONTDES			&& FABIANO - 09/02/2015
PUB_RICCLIDES			= AZI_RICCLIDES				&& SERGIO - 11/02/2015
PUB_RICFORDES			= AZI_RICFORDES				&& SERGIO - 11/02/2015
PUB_RICBANDES			= AZI_RICBANDES				&& SERGIO - 11/02/2015
PUB_RICARTDES			= AZI_RICARTDES				&& SERGIO - 11/02/2015
PUB_ORDOBL 				= AZI_ORDOBL				&& SERGIO - 16/02/2015
PUB_CLIOBL 				= AZI_CLIOBL				&& SERGIO - 16/02/2015
PUB_FOROBL 				= AZI_FOROBL				&& SERGIO - 16/02/2015
PUB_CTRCLOF 			= AZI_CTRCLOF 				&& SERGIO - 22/02/2015
PUB_CTRCLOR 			= AZI_CTRCLOR 				&& SERGIO - 22/02/2015
PUB_CTRRISD 			= AZI_CTRRISD 				&& SERGIO - 22/02/2015
PUB_CTRRISD2 			= AZI_CTRRISD2 				&& SERGIO - 22/02/2015
PUB_NONVAL				= AZI_NONVAL				&& ERASMO - 24/02/2015
PUB_ANTCLI_CONTO		= AZI_ANTCLI_CONTO			&& FABIANO 02/03/2015 - GESTIONE ANTICIPI
PUB_ANTCLI_REGAUT		= AZI_ANTCLI_REGAUT			&& FABIANO 02/03/2015 - GESTIONE ANTICIPI
PUB_ANTCLI_TOP 			= AZI_ANTCLI_TOP			&& FABIANO 02/03/2015 - GESTIONE ANTICIPI
PUB_ORD_POLIEC			= AZI_ORD_POLIEC		    && SERGIO - 04/03/2015
PUB_ELNODISA 			= AZI_ELNODISA 				&& FABIANO 05/03/2015 - NON VISUALIZZA I PARAMETRI DISATTIVATI IN ELENCO
PUB_ORD_POLIEC_ANT		= AZI_ORD_POLIEC_ANT		&& ERASMO - 10/03/2015
PUB_NOSTPNAZ			= AZI_NOSTPNAZ				&& ERASMO - 10/03/2015
PUB_NOBLOPN				= AZI_NOBLOPN		        && SERGIO - 10/03/2015
PUB_ALLDANG				= AZI_ALLDANG		        && SERGIO - 12/03/2015
PUB_RICBILA				= AZI_RICBILA		        && SERGIO - 17/03/2015
PUB_CTRDETINTRA			= AZI_CTRDETINTRA		    && ERASMO/SERGIO - 19/03/2015
PUB_PRIMANOT			= AZI_PRIMANOT		   		&& SERGIO - 20/03/2015
PUB_RICAIMP				= AZI_RICAIMP		   		&& SERGIO - 26/03/2015
PUB_INTXLS 				= AZI_INTXLS				&& ERASMO - 31/03/2015
PUB_ARTTRA 				= AZI_ARTTRA				&& ERASMO - 03/04/2015
PUB_PRIMAN				= AZI_PRIMAN				&& SERGIO - 22/04/2015
PUB_SICONS				= AZI_SICONS				&& SERGIO - 07/05/2015
PUB_STOPACQ				= AZI_STOPACQ				&& SERGIO - 18/05/2015
PUB_MAXACQ				= AZI_MAXACQ				&& FABIANO - 23/05/2015
PUB_VISACH				= AZI_VISACH				&& ERASMO - 26/06/2015
PUB_MAGVIS				= AZI_MAGVIS				&& ERASMO - 30/06/2015
PUB_CLSIOBBL			= AZI_CLSIOBBL				&& SERGIO - 07/07/2015
PUB_TXTVARI				= AZI_TXTVARI				&& SERGIO - 08/07/2015
PUB_RICCONTDES2			= AZI_RICCONTDES2			&& SERGIO - 21/07/2015
PUB_ORDMDD				= AZI_ORDMDD				&& ERASMO - 22/07/2015
PUB_CFPIOBBL			= AZI_CFPIOBBL				&& ERASMO - 28/07/2015
PUB_PLAFACQF 			= AZI_PLAFACQF				&& SERGIO - 30/07/2015
PUB_PLAFACQMSG			= AZI_PLAFACQMSG			&& ERASMO - 06/08/2015
PUB_IVANAF				= AZI_IVANAF				&& ERASMO - 06/08/2015
PUB_SPFNRDS				= AZI_SPFNRDS				&& ERASMO - 04/09/2015
PUB_MENU_WIN8			= AZI_MENU_WIN8				&& SERGIO - 23/09/2015
PUB_RICPARDES			= AZI_RICPARDES				&& ERASMO - 09/10/2015
PUB_RICPSNDDT			= AZI_RICPSNDDT				&& ERASMO - 17/11/2015
PUB_NOCLICEE			= AZI_NOCLICEE				&& ERASMO - 18/11/2015
PUB_LCKUNQSCAD			= AZI_LCKUNQSCAD			&& ERASMO - 27/11/2015
PUB_PNAUTO				= AZI_PNAUTO				&& SERGIO - 12/12/2015
PUB_CREIVACEE			= AZI_CREIVACEE				&& SERGIO - 12/12/2015
PUB_CREIVAREV			= AZI_CREIVAREV				&& SERGIO - 12/12/2015
PUB_RATRIS				= AZI_RATRIS				&& SERGIO - 28/12/2015
PUB_RICPRG				= AZI_RICPRG				&& ERASMO - 04/01/2016
PUB_MULTIA				= AZI_MULTIA				&& SERGIO - 09/01/2016
PUB_NEWYEAR				= AZI_NEWYEAR				&& SERGIO - 15/01/2016
PUB_RAR					= AZI_RAR					&& SERGIO - 16/01/2016
PUB_NOIVASPINC			= AZI_NOIVASPINC			&& SERGIO - 03/02/2016
PUB_IVASPINC			= AZI_IVASPINC				&& SERGIO - 03/02/2016
PUB_INTE				= AZI_TOPINT				&& SERGIO - 25/02/2016
PUB_ACCOIVA				= AZI_ACCOIVA				&& SERGIO - 28/02/2016
PUB_MAGPMIEST			= AZI_MAGPMIEST				&& ERASMO - 25/03/2016
PUB_OMACIO2 			= AZI_OMACIO2				&& ERASMO/SERGIO - 01/04/2016
PUB_LISBANCO 			= AZI_LISBANCO				&& ERASMO/SERGIO - 01/04/2016
PUB_SGRU1				= AZI_SGRU1					&& SERGIO - 13/04/2016
PUB_VALTC1				= AZI_VALTC1				&& SERGIO - 13/04/2016
PUB_SGRU2				= AZI_SGRU2					&& SERGIO - 13/04/2016
PUB_VALTC2				= AZI_VALTC2				&& SERGIO - 13/04/2016

PUB_FLGSCF				= AZI_FLGSCF				&& SERGIO - 19/04/2016

=RICERCA_DESMAGPROD()


SELECT &SS

RETURN(.T.)


***************************************
FUNCTION DETERMINA_ALIQUOTA_IVA_DEFAULT
***************************************
SS=STR(SELECT())

PUB_PERCENTUALE_IVA_DEFAULT  = 21
IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(PUB_IVA) + "'","cx_iva_para")
   return
ENDIF

SELECT cx_iva_para
IF reccount() <> 0
   cxxALIQ = SUBSTR(LIBERA,1,3)
   PUB_PERCENTUALE_IVA_DEFAULT = VAL(cxxALIQ)
ENDIF

IF PUB_PERCENTUALE_IVA_DEFAULT = 0			&& SE NON TROVATO PARAMETRO
	PUB_PERCENTUALE_IVA_DEFAULT = 21
ENDIF

SELECT &SS


RETURN


******************************
FUNCTION _OPERAT
******************************
* GESTIONE LIVELLO ACCESSO A INFORMAZIONI PER OPERATORE
* __DATO = CAMPO DA CONTROLLARE

PARA __DATO

v_seek	 = ALLTRIM(__dato)
v_chiave = "codice"
IF seek_std('Res_Oper',v_seek,v_chiave,'Res_Oper')
   SELECT Res_Oper
   PUB_PREZZI = NO_PREZZI
   PUB_COSTI  = NO_COSTI
   PUB_TEMPI  = NO_TEMPI
   PUB_FATINF = NO_FATINF  	&& ERASMO - 27/11/2008
   PUB_RISINF = NO_RISINF  	&& ERASMO - 01/04/2009
   PUB_OK_LAB_PROCEDURE = OK_LAB_PROCEDURE && FABIANO - 03/01/2011
   PUB_MAIL = MAIL	&& LUCA 28/04/2011
   PUB_MITTENTE 	= ALLTRIM(MITTENTE)	&& LUCA 28/04/2011
   PUB_SMTP 		= ALLTRIM(SMTP)		&& LUCA 28/04/2011
   PUB_PORT 		= ALLTRIM(PORT)		&& LUCA 28/04/2011
   PUB_CRYPTO		= ALLTRIM(CRYPTO)	&& LUCA 28/04/2011
   PUB_AUTH_USER	= ALLTRIM(AUTH_USER)	&& LUCA 28/04/2011
   PUB_AUTH_PASS	= ALLTRIM(AUTH_PASS)	&& LUCA 28/04/2011
   PUB_NOTIFICA		= ALLTRIM(NOTIFICA)	&& LUCA 24/05/2011
   PUB_FIRMA_MAIL 	= ALLTRIM(FIRMA_MAIL)  && ERASMO - 01/06/2011
ELSE
   PUB_PREZZI = .F.
   PUB_COSTI  = .F.
   PUB_TEMPI  = .F.
   PUB_FATINF = .F.  		&& ERASMO - 27/11/2008
   PUB_RISINF = .F.  		&& ERASMO - 01/04/2009
   PUB_OK_LAB_PROCEDURE =.F. && FABIANO - 03/01/2011
   PUB_MAIL 		= ""  && ERASMO - 25/05/2011
   PUB_MITTENTE 	= ""  && ERASMO - 25/05/2011
   PUB_SMTP 		= ""  && ERASMO - 25/05/2011
   PUB_PORT 		= ""  && ERASMO - 25/05/2011
   PUB_CRYPTO		= ""  && ERASMO - 25/05/2011
   PUB_AUTH_USER	= ""  && ERASMO - 25/05/2011
   PUB_AUTH_PASS	= ""  && ERASMO - 25/05/2011
   PUB_NOTIFICA		= ""  && ERASMO - 25/05/2011
   PUB_FIRMA_MAIL 	= ""  && ERASMO - 01/06/2011
ENDIF

RETURN


**********************************************************************
* -->> FUNZIONE CHE IDENTIFICA SE LA DATA IN OGGETTO E' RIBALTATA
* -->> IN QUESTO CASO LA RIPORTA IN FORMATO GG/MM/AAAA
**********************************************************************
FUNCTION GDATA  
**********************************************************************
PARA _DATA

OUT=_DATA

IF SUBSTR(_DATA,5,1)="/"
  OUT=RIBALTA2(_DATA)
ENDIF  

RETURN(OUT)


***************************
FUNCTION RICERCA_DESMAGPROD
***************************

*=> Ricerca la descrizione del magazzino in fase di carico con documenti del fornitore
x_cond = "codice = 'MAG" + ALLTRIM(PUB_CARORF) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_CARORF = SPACE(50)
ELSE
   DES_CARORF = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino dopo l'analisi della M.P. con prodotto risultato conforme
x_cond = "codice = 'MAG" + ALLTRIM(PUB_CQUMPC) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_CQUMPC = SPACE(50)
ELSE
   DES_CQUMPC = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino dopo l'analisi della M.P. con prodotto risultato NON conforme
x_cond = "codice = 'MAG" + ALLTRIM(PUB_CQUMPN) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_CQUMPN = SPACE(50)
ELSE
   DES_CQUMPN = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino della produzione spalmatura
x_cond = "codice = 'MAG" + ALLTRIM(PUB_SPAPRO) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_SPAPRO = SPACE(50)
ELSE
   DES_SPAPRO = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il reso della M.P. non spalmata
x_cond = "codice = 'MAG" + ALLTRIM(PUB_SPAMPR) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_SPAMPR = SPACE(50)
ELSE
   DES_SPAMPR = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il film spalmato
x_cond = "codice = 'MAG" + ALLTRIM(PUB_SPACQS) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_SPACQS = SPACE(50)
ELSE
   DES_SPACQS = DESCRI
ENDIF

*** SIMONE - 25/02/2009
*=> Ricerca la descrizione del magazzino per il film spalmato
x_cond = "codice = 'MAG" + ALLTRIM(PUB_SPASCA) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_SPASCA = SPACE(50)
ELSE
   DES_SPASCA = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino dopo l'analisi del S.L. con prodotto risultato conforme
x_cond = "codice = 'MAG" + ALLTRIM(PUB_CQUSLC) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_CQUSLC = SPACE(50)
ELSE
   DES_CQUSLC = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino dopo l'analisi del S.L. con prodotto NON risultato conforme
x_cond = "codice = 'MAG" + ALLTRIM(PUB_CQUSLN) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_CQUSLN = SPACE(50)
ELSE
   DES_CQUSLN = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per la produzione della ribobinatura
x_cond = "codice = 'MAG" + ALLTRIM(PUB_RIBPRO) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_RIBPRO = SPACE(50)
ELSE
   DES_RIBPRO = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il reso del S.L. non ribobinato
x_cond = "codice = 'MAG" + ALLTRIM(PUB_RIBSLR) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_RIBSLR = SPACE(50)
ELSE
   DES_RIBSLR = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il film ribobinato
x_cond = "codice = 'MAG" + ALLTRIM(PUB_RIBSLO) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_RIBSLO = SPACE(50)
ELSE
   DES_RIBSLO = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per la produzione del taglio
x_cond = "codice = 'MAG" + ALLTRIM(PUB_TAGPRO) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_TAGPRO = SPACE(50)
ELSE
   DES_TAGPRO = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il reso del S.L. non tagliato
x_cond = "codice = 'MAG" + ALLTRIM(PUB_TAGSLR) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_TAGSLR = SPACE(50)
ELSE
   DES_TAGSLR = DESCRI
ENDIF

*=> Ricerca la descrizione del magazzino per il film tagliato
x_cond = "codice = 'MAG" + ALLTRIM(PUB_TAGPFO) + "'"
cSql   = "select * from para where " + x_cond
IF !ExecCommand(cSql,"PARA")
   RETURN
ENDIF
IF EOF()
   DES_TAGPFO = SPACE(50)
ELSE
   DES_TAGPFO = DESCRI
ENDIF

RETURN(.T.)




******************
FUNCTION CAMPOMASK
******************
PARAMETERS _NUMDEC,_INTERO

IF _NUMDEC = 0
   _CAMPOMASK = _INTERO
   RETURN(_CAMPOMASK)
ENDIF

X_DECIMA = ""
X_INDICE = 1
DO WHILE .T.
   IF X_INDICE > _NUMDEC
      EXIT
   ENDIF
   X_DECIMA = X_DECIMA + '9'
   X_INDICE = X_INDICE + 1
ENDDO
_CAMPOMASK = _INTERO + "." + X_DECIMA

RETURN(_CAMPOMASK)


*****************************
FUNCTION TROVA_MQ_DA_AL
*****************************
PARAMETERS _ALTEZZ,_LUNGHE,_NUMBOB

_QTA = ROUND((_ALTEZZ / 1000) * _LUNGHE,2)  
_QTA = ROUND((_QTA * _NUMBOB),2)

RETURN(_QTA)


*****************************
FUNCTION TROVA_NR_DA_MQ_FILM
*****************************
PARAMETERS _ALTEZZ,_LUNGHE,_TOT_MQ

_QTX = 0
IF _ALTEZZ > 0 AND _LUNGHE > 0
	_QTX = _TOT_MQ * 1000 / (_ALTEZZ * _LUNGHE)
ENDIF
_QTA = ROUND(_QTX,0)

RETURN(_QTA)



*****************************
FUNCTION TROVA_PREZZO_IN_MQ_DA_PREZZO_IN_RT
*****************************
PARAMETERS _ALTEZZ,_LUNGHE,_PREZZO_IN_RT

LOCAL _PREZZO_IN_MQ

_PREZZO_IN_MQ= 0

IF _ALTEZZ > 0 AND _LUNGHE > 0 AND _PREZZO_IN_RT > 0
	_PREZZO_IN_MQ= _PREZZO_IN_RT /((_ALTEZZ/1000) * _LUNGHE)
ENDIF


RETURN(_PREZZO_IN_MQ)


*****************************
FUNCTION TROVA_PREZZO_IN_RT_DA_PREZZO_IN_MQ
*****************************
PARAMETERS _ALTEZZ,_LUNGHE,_PREZZO_IN_MQ

LOCAL _PREZZO_IN_RT

_PREZZO_IN_RT= 0

IF _ALTEZZ > 0 AND _LUNGHE > 0 AND _PREZZO_IN_MQ > 0	
	_PREZZO_IN_RT = _PREZZO_IN_MQ * ((_ALTEZZ/1000) * _LUNGHE)
ENDIF


RETURN(_PREZZO_IN_RT)


*****************************
FUNCTION TROVA_PREZZO_IN_MQ_DA_PREZZO_IN_ML
*****************************
PARAMETERS _ALTEZZ,_PREZZO_IN_ML

LOCAL _PREZZO_IN_MQ

_PREZZO_IN_MQ= 0

IF _ALTEZZ > 0 AND _PREZZO_IN_ML > 0 
	_PREZZO_IN_MQ= _PREZZO_IN_ML/(_ALTEZZ/1000)
ENDIF


RETURN(_PREZZO_IN_MQ)



*****************************
FUNCTION TROVA_PREZZO_IN_ML_DA_PREZZO_IN_MQ
*****************************
PARAMETERS _ALTEZZ,_PREZZO_IN_MQ

LOCAL _PREZZO_IN_ML

_PREZZO_IN_ML= 0

IF _ALTEZZ > 0 AND _PREZZO_IN_MQ > 0
	_PREZZO_IN_ML = _PREZZO_IN_MQ * (_ALTEZZ/1000)
ENDIF


RETURN(_PREZZO_IN_ML)




*****************************
FUNCTION TROVA_NR_DA_ML_FILM
*****************************
PARAMETERS _LUNGHE,_TOT_ML

_QTX = 0
IF _LUNGHE > 0
	_QTX = _TOT_ML / _LUNGHE
ENDIF
_QTA = ROUND(_QTX,0)

RETURN(_QTA)


*****************************
FUNCTION TROVA_MQ_DA_AL_LEGNO
*****************************
PARAMETERS _ALTEZZ,_LUNGHE,_NUMBOB

_QTX = (_ALTEZZ * _LUNGHE * _NUMBOB)/1000000
*** INVECE DI ARROTONDARE A TRE DECIMALI, EFFETTUO UN TRONCAMENTO
_cQTA = ALLTRIM(STR(_QTX,20,8))
_cQTA = SUBSTR(_cQTA,1,AT(',',_cQTA,1)+3)
_QTA  = VAL(_cQTA)

RETURN(_QTA)

*****************************
FUNCTION TROVA_MC_DA_AL_LEGNO
*****************************
PARAMETERS _ALTEZZ,_LUNGHE,_NUMBOB,_SPESSO,_DECIMALS

IF PCOUNT() >= 5
ELSE
	_DECIMALS = 3
ENDIF

_QTX = (_ALTEZZ * _LUNGHE * _SPESSO * _NUMBOB)/1000000000
_QTA = ROUND(_QTX,_DECIMALS)  


RETURN(_QTA)

*****************************
FUNCTION TROVA_NR_DA_MC_LEGNO
*****************************
PARAMETERS _ALTEZZ,_LUNGHE,_MC,_SPESSO

_QTX = 0
IF _ALTEZZ > 0 AND _LUNGHE > 0 AND _SPESSO > 0
	_QTX = _MC * 1000000000 / (_ALTEZZ * _LUNGHE * _SPESSO)
ENDIF
_QTA = ROUND(_QTX,0)

RETURN(_QTA)

*****************************
FUNCTION TROVA_NR_DA_MQ_LEGNO
*****************************
PARAMETERS _ALTEZZ,_LUNGHE,_MQ

_QTX = 0
IF _ALTEZZ > 0 AND _LUNGHE > 0
	_QTX = _MQ * 1000000 / (_ALTEZZ * _LUNGHE)
ENDIF
_QTA = ROUND(_QTX,0)

RETURN(_QTA)


***********************
FUNCTION TROVA_ML_DA_LU
***********************
PARAMETERS _LUNGHE,_NUMBOB

_QTA = _LUNGHE 
_QTA = ROUND((_QTA * _NUMBOB),2)

RETURN(_QTA)


***********************
FUNCTION TROVA_KG_DA_MQ
***********************
PARAMETERS _CODART,_SPESSO,_QUANTI,_NUMBOB

SS=STR(SELECT())

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond 
IF !ExecCommand(cSql,"CU_ART_PR")
   return(.f.)
ENDIF
SELECT CU_ART_PR
GO TOP
IF EOF()
   V_PESOUM = 0
   X_QTXCON = 0
   X_QTCONF = 0
ELSE
   V_PESOUM = ART_PESOUM
   X_QTXCON = ART_QTACON
   X_QTCONF = ART_QTACON
ENDIF

IF V_PESOUM = 0
   V_PESOUM = ROUND((0.922 * ROUND((_SPESSO / 1000),3)),5)
ELSE
   V_PESOUM = ROUND((V_PESOUM * ROUND((_SPESSO / 1000),3)),5)
ENDIF

_QTA = _QUANTI * V_PESOUM
_QTA = ROUND((_QTA * _NUMBOB),2)

SELECT &SS

RETURN(_QTA)



***********************
FUNCTION TROVA_KG_DA_MQ_TEST
***********************
PARAMETERS _CODART,_SPESSO,_QUANTI,_NUMBOB,_PESOUM

SS=STR(SELECT())

V_PESOUM = _PESOUM


IF V_PESOUM = 0
   V_PESOUM = ROUND((0.922 * ROUND((_SPESSO / 1000),3)),5)
ELSE
   V_PESOUM = ROUND((V_PESOUM * ROUND((_SPESSO / 1000),3)),5)
ENDIF

_QTA = _QUANTI * V_PESOUM
_QTA = ROUND((_QTA * _NUMBOB),2)

SELECT &SS

RETURN(_QTA)



***********************
FUNCTION TROVA_MQ_DA_KG
***********************
PARAMETERS _CODART,_SPESSO,_QUANTI

WW=SELECT()

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_art_pr where " + x_cond 
IF !ExecCommand(cSql,"CU_ART_PR")
   return(.f.)
ENDIF
SELECT CU_ART_PR
GO TOP
IF EOF()
   V_PESOUM = 0
ELSE
   V_PESOUM = ART_PESOUM
ENDIF

IF V_PESOUM = 0
   V_PESOUM = 0.922
ENDIF

_PESOUM = ROUND((V_PESOUM * ROUND((_SPESSO / 1000),3)),5)

IF _PESOUM = 0
   _QTA = 0
ELSE
   _QTA = ROUND((_QUANTI / _PESOUM),2) 
ENDIF

SELECT(WW)

RETURN(_QTA)


***********************
FUNCTION TROVA_ML_DA_MQ
***********************
PARAMETERS _ALTEZZ,_QUANTI

IF _ALTEZZ = 0
   _QTA = 0
ELSE
   _QTA = ROUND((_QUANTI / (_ALTEZZ / 1000)),2) 
ENDIF

RETURN(_QTA)


******************
FUNCTION CERCATIPO
******************
PARAMETERS _CODART

WW=SELECT()

x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
x_codi = "art_codpri = '" + ALLTRIM(_CODART) + "'"
x_cond = x_soci + " and " + x_codi
*Csql   = "select * from u_art_pr where " + x_cond
Csql   = "select ART_CODMAT, ART_CODCAT from u_art_pr where " + x_cond  && ERASMO - 06/11/2012
IF !ExecCommand(cSql,"cur_articoli")
   return(.f.)
ENDIF
SELECT cur_articoli
GO TOP
IF EOF()
   _CODMAT = '001'
   _CODCAT = '  '
ELSE
   _CODMAT = ART_CODMAT
   _CODCAT = ART_CODCAT
ENDIF

x_codi = "codice = 'MAT" + _CODMAT + "'"
*Csql   = "select * from para where " + x_codi
Csql   = "select LIBERA from para where " + x_codi   
IF !ExecCommand(cSql,"cur_para")
   return(.f.)
ENDIF
SELECT cur_para
GO TOP
IF EOF()
   _TIPO = '0'
ELSE
   _TIPO = SUBSTR(LIBERA,1,1)
ENDIF  

IF EMPTY(ALLTRIM(_CODCAT))
ELSE
   IF _CODCAT = 'BO'
      _TIPO = '1'
   ENDIF
   IF _CODCAT = 'AD'
      _TIPO = '2'
   ENDIF
   IF _CODCAT = 'MA'
      _TIPO = '3'
   ENDIF
   IF _CODCAT = 'SC'
      _TIPO = '4'
   ENDIF
   IF _CODCAT = 'PE'
      _TIPO = '5'
   ENDIF
   IF _CODCAT = 'PA'
      _TIPO = '6'
   ENDIF
   IF _CODCAT = 'CG'
      _TIPO = '7'
   ENDIF
   IF _CODCAT = 'CI'
      _TIPO = '8'
   ENDIF
   IF _CODCAT = 'DP'
      _TIPO = '9'
   ENDIF
ENDIF

SELECT(WW)

RETURN(_TIPO)


*** ERASMO - 10/06/2025 - ASTERISCATE TUTTE LE FUNZIONI DI AQMLIB.PRG IN QUANTO OBSOLETE E SOSTITUIBILI CON UNA "SET PROCEDURE TO PRG\AQMLIB.PRG"
*!*	**********************************
*!*	FUNCTION AQM_RILEVA_NUMERO_INTERNO
*!*	**********************************

*!*	LOCAL _AQM_SS
*!*	_AQM_SS=SELECT()

*!*	x_cond = "codice = 'NUMCSI01'"
*!*	Csql   = "select * from para where " + x_cond 
*!*	IF !ExecRW(cSql,"PARA","R")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT PARA
*!*	IF RECCOUNT() <> 0
*!*	ELSE
*!*	   APPEND BLANK
*!*	   REPLACE CODICE WITH 'NUMCSI01'
*!*	   REPLACE DESCRI WITH 'NUMERO PROGRESSIVO PRELIEVO/CARICO INTERNO MAG. FISCALE'
*!*	   REPLACE LIBERA WITH '0000000'
*!*	ENDIF
*!*	   
*!*	V2=VAL(SUBSTR(LIBERA,1,7)) + 1
*!*	REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
*!*	___NUMCSI = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
*!*	___NUMCSI = TRC(6,ALLTRIM(___NUMCSI))

*!*	IF !ExecRW(cSql,"PARA","W")
*!*	   return(.f.)
*!*	ENDIF

*!*	SELECT(_AQM_SS)

*!*	return(___NUMCSI)


*!*	***********************************************
*!*	FUNCTION AQM_DEFINISCE_AQM_VARIABILI_MAGAZZINO      && _________________________________________________________________________________________________________ VARIABILI DI GESTIONE DEL MAGAZZINO
*!*	***********************************************

*!*	*!*	____________________________________________________________________________________________________________________________________ VARIABILI PER L'ACCESSO A U_MAG_GG
*!*	RELEASE AQM_CODSOC,AQM_DATAGG,AQM_ORACAR,AQM_CODART,AQM_CODMAG,AQM_CODFOR,AQM_GIACEN,AQM_FILA_N,AQM_PIAN_N,AQM_UBIC_N,AQM_PRZCON,AQM_ANAART
*!*	PUBLIC  AQM_CODSOC,AQM_DATAGG,AQM_ORACAR,AQM_CODART,AQM_CODMAG,AQM_CODFOR,AQM_GIACEN,AQM_FILA_N,AQM_PIAN_N,AQM_UBIC_N,AQM_PRZCON,AQM_ANAART


*!*	*!*	____________________________________________________________________________________________________________________________________ VARIABILI TABELLA U_MAG_GG
*!*	RELEASE AQM_DADOVE,AQM_DESART,AQM_CODPDV,AQM_DESFOR,AQM_QTAKG,AQM_QTAMQ,AQM_QTAML,AQM_FILA_X,AQM_PIAN_X,AQM_UBIC_X
*!*	RELEASE AQM_CODCLI,AQM_DESCLI
*!*	RELEASE AQM_QUAPRO,AQM_CLIINV	 


*!*	PUBLIC  AQM_DADOVE,AQM_DESART,AQM_CODPDV,AQM_DESFOR,AQM_QTAKG,AQM_QTAMQ,AQM_QTAML,AQM_FILA_X,AQM_PIAN_X,AQM_UBIC_X
*!*	PUBLIC  AQM_CODCLI,AQM_DESCLI
*!*	PUBLIC  AQM_QUAPRO,AQM_CLIINV	 


*!*	*!*	____________________________________________________________________________________________________________________________________ VARIABILI TABELLA U_MAG_MO

*!*	RELEASE AQM_NOTE  && SERGIO - 21/07/2015
*!*	RELEASE AQM_PRSPOT
*!*	RELEASE AQM_TOP,AQM_NUMDOC,AQM_DTDOCU,AQM_PREVEN,AQM_PREACQ,AQM_SCONTO,AQM_IVAVEN,AQM_DTREGI,AQM_UM,AQM_COORD,AQM_VALUTA
*!*	RELEASE AQM_SERIE,AQM_AAPROD,AQM_CODTAG,AQM_DESTAG,AQM_CODCOL,AQM_DESCOL,AQM_CODMAT,AQM_DESMAT,AQM_NOTVAR,AQM_CODPDV
*!*	RELEASE AQM_SEGNO,AQM_TIPMOV,AQM_LEGSYS,AQM_LEGAME,AQM_NUMORF,AQM_DATORF,AQM_NUMIDE,AQM_SPESSO,AQM_ALTEZZ,AQM_LUNGHE
*!*	RELEASE AQM_NRLINT,AQM_NRDBOB,AQMSERBOL,AQM_SERNUM,AQM_NUMEDA,AQM_NUMEAL,AQM_CBFISC,AQM_NUMMOV
*!*	RELEASE AQM_SC1,AQM_SC2,AQM_SC3,AQM_SC4,AQM_SC5,AQM_NUMMOV,AQM_CODINT 
*!*	RELEASE AQM_QTAIMP,AQM_GMLIMP,AQM_GKGIMP 
*!*	RELEASE AQM_UNIQUE,AQM_SAVE_LEGSYS  

*!*	PUBLIC  AQM_NOTE  && SERGIO - 21/07/2015
*!*	PUBLIC  AQM_PRSPOT
*!*	PUBLIC  AQM_TOP,AQM_NUMDOC,AQM_DTDOCU,AQM_PREVEN,AQM_PREACQ,AQM_SCONTO,AQM_IVAVEN,AQM_DTREGI,AQM_UM,AQM_COORD,AQM_VALUTA
*!*	PUBLIC  AQM_SERIE,AQM_AAPROD,AQM_CODTAG,AQM_DESTAG,AQM_CODCOL,AQM_DESCOL,AQM_CODMAT,AQM_DESMAT,AQM_NOTVAR,AQM_CODPDV
*!*	PUBLIC  AQM_SEGNO,AQM_TIPMOV,AQM_LEGSYS,AQM_LEGAME,AQM_NUMORF,AQM_DATORF,AQM_NUMIDE,AQM_SPESSO,AQM_ALTEZZ,AQM_LUNGHE
*!*	PUBLIC  AQM_NRLINT,AQM_NRDBOB,AQM_SERBOL,AQM_SERNUM,AQM_NUMEDA,AQM_NUMEAL,AQM_CBFISC,AQM_NUMMOV
*!*	PUBLIC  AQM_SC1,AQM_SC2,AQM_SC3,AQM_SC4,AQM_SC5,AQM_NUMMOV,AQM_CODINT  
*!*	PUBLIC  AQM_QTAIMP,AQM_GMLIMP,AQM_GKGIMP 
*!*	PUBLIC  AQM_UNIQUE,AQM_SAVE_LEGSYS  

*!*	RELEASE AQM_CDAFOR,AQM_OINFOR,AQM_PINFOR,AQM_DTPFOR,AQM_TRAFOR,AQM_NBAFOR,AQM_BDAFOR,AQM_BALFOR,AQM_PNKFOR
*!*	PUBLIC  AQM_CDAFOR,AQM_OINFOR,AQM_PINFOR,AQM_DTPFOR,AQM_TRAFOR,AQM_NBAFOR,AQM_BDAFOR,AQM_BALFOR,AQM_PNKFOR

*!*	RELEASE AQM_QUAPRO_MOV,AQM_CLIINV_MOV	 
*!*	PUBLIC  AQM_QUAPRO_MOV,AQM_CLIINV_MOV	 


*!*	RELEASE AQM_QTAMC
*!*	PUBLIC  AQM_QTAMC

*!*	RELEASE AQM_QTANR,AQM_GIANEG
*!*	PUBLIC  AQM_QTANR,AQM_GIANEG

*!*	RELEASE AQM_ORAMOV
*!*	PUBLIC  AQM_ORAMOV

*!*	RELEASE AQM_SERIAL
*!*	PUBLIC  AQM_SERIAL

*!*	**=> ERASMO - INIZIO 16/02/2015
*!*	*** VARIABILE PER MEMORIZZARE LA DATA ORIGINALE DI PRIMO CARICO (ES. CASO BOBINE FILM NUDO RICARICATE A MAGAZZINO IN PRODUZIONE SPALMATURA)
*!*	RELEASE AQM_DATORI
*!*	PUBLIC  AQM_DATORI
*!*	**=> ERASMO - FINE 16/02/2015

*!*	**=> ERASMO - INIZIO 22/07/2015
*!*	*** VARIABILE PER MEMORIZZARE COD. FORNITORE SUPPORTO FILM SPALMATO
*!*	RELEASE AQM_FORNSUPP
*!*	PUBLIC  AQM_FORNSUPP
*!*	**=> ERASMO - FINE 22/07/2015

*!*	**=> ERASMO - INIZIO 25/02/2016
*!*	*** VARIABILI PER MEMORIZZARE I DATI RELATIVI ALLE FATTURE PROFORMA GENERATE TRAMITE APPLICAZIONE AQ_SUWAMA
*!*	RELEASE AQM_VIA,AQM_PORT
*!*	PUBLIC  AQM_VIA,AQM_PORT
*!*	**=> ERASMO - FINE 25/02/2016

*!*	=AQM_PULISCE_VARIABILI_MAGAZZINO()

*!*	RETURN(.T.)


*!*	****************************************
*!*	FUNCTION AQM_PULISCE_VARIABILI_MAGAZZINO && _________________________________________________________________________________________________________ VARIABILI DI GESTIONE DEL MAGAZZINO
*!*	****************************************
*!*	*!*	____________________________________________________________________________________________________________________________________ VARIABILI PER L'ACCESSO A U_MAG_GG
*!*	AQM_CODSOC	= ""
*!*	AQM_DATAGG  = ""
*!*	AQM_ORACAR  = ""
*!*	AQM_CODART  = ""
*!*	AQM_CODMAG  = ""
*!*	AQM_CODFOR  = ""
*!*	AQM_GIACEN  = 0
*!*	AQM_FILA_N  = 0
*!*	AQM_PIAN_N  = 0
*!*	AQM_UBIC_N  = 0
*!*	AQM_PRZCON  = 0
*!*	AQM_ANAART = ""
*!*	*!*	____________________________________________________________________________________________________________________________________ VARIABILI TABELLA U_MAG_GG
*!*	AQM_DADOVE = ""
*!*	AQM_DESART = ""
*!*	AQM_CODPDV = ""
*!*	AQM_DESFOR = ""
*!*	AQM_CODCLI = ""
*!*	AQM_DESCLI = ""
*!*	AQM_QTAKG  = 0
*!*	AQM_QTAMQ  = 0 
*!*	AQM_QTAML  = 0
*!*	AQM_QTAMC  = 0  	 
*!*	AQM_QTANR  = 0		 
*!*	AQM_GIANEG = .F.	 

*!*	AQM_FILA_X = "" 
*!*	AQM_PIAN_X = ""
*!*	AQM_UBIC_X = ""
*!*	AQM_QUAPRO = ""  
*!*	AQM_CLIINV = "" && PRODUZIONE PER CLIENTE RILEVATA DA INVENTARIO
*!*	*!*	____________________________________________________________________________________________________________________________________ VARIABILI TABELLA U_MAG_MO
*!*	AQM_PRSPOT = .F.
*!*	AQM_TOP    = ""
*!*	AQM_NUMDOC = ""
*!*	AQM_DTDOCU = ""
*!*	AQM_PREVEN = 0
*!*	AQM_PREACQ = 0
*!*	AQM_SCONTO = 0
*!*	AQM_IVAVEN = ""
*!*	AQM_DTREGI = ""
*!*	AQM_UM     = ""
*!*	AQM_COORD  = "     -     -     -     "
*!*	AQM_VALUTA = ""
*!*	AQM_SERIE  = ""
*!*	AQM_AAPROD = 0
*!*	AQM_CODTAG = ""
*!*	AQM_DESTAG = ""
*!*	AQM_CODCOL = ""
*!*	AQM_DESCOL = ""
*!*	AQM_CODMAT = ""
*!*	AQM_DESMAT = ""
*!*	AQM_NOTVAR = ""
*!*	AQM_CODPDV = ""
*!*	AQM_SEGNO  = ""
*!*	AQM_TIPMOV = ""
*!*	AQM_LEGSYS = ""
*!*	AQM_LEGAME = ""
*!*	AQM_NUMORF = ""
*!*	AQM_DATORF = ""
*!*	AQM_NUMIDE = ""
*!*	AQM_SPESSO = 0
*!*	AQM_ALTEZZ = 0
*!*	AQM_LUNGHE = 0
*!*	AQM_NRLINT = 0
*!*	AQM_NRDBOB = 0
*!*	AQM_SERBOL = ""
*!*	AQM_SERNUM = ""
*!*	AQM_NUMEDA = 0
*!*	AQM_NUMEAL = 0
*!*	AQM_CBFISC = ""
*!*	AQM_NUMMOV = ""
*!*	AQM_SC1    = 0
*!*	AQM_SC2    = 0
*!*	AQM_SC3    = 0
*!*	AQM_SC4    = 0  && ERASMO - 22/04/2016
*!*	AQM_SC5    = 0  && ERASMO - 22/04/2016
*!*	AQM_CODINT = ""
*!*	AQM_QTAIMP = 0
*!*	AQM_GMLIMP = 0
*!*	AQM_GKGIMP = 0 
*!*	AQM_UNIQUE = ""
*!*	AQM_SAVE_LEGSYS = ""

*!*	AQM_CDAFOR = ""
*!*	AQM_OINFOR = ""
*!*	AQM_PINFOR = ""
*!*	AQM_DTPFOR = ""
*!*	AQM_TRAFOR = ""
*!*	AQM_NBAFOR = 0
*!*	AQM_BDAFOR = 0
*!*	AQM_BALFOR = 0
*!*	AQM_PNKFOR = 0
*!*	AQM_QUAPRO_MOV = ''	 	 
*!*	AQM_CLIINV_MOV = ''		&& PRODUZIONE PER CLIENTE RILEVATA DA INVENTARIO

*!*	AQM_ORAMOV = ""  

*!*	AQM_SERIAL = ""

*!*	AQM_DATORI = ""  && ERASMO - 16/02/2015
*!*	AQM_NOTE   = ""  && SERGIO - 21/07/2015
*!*	AQM_FORNSUPP = ""  && ERASMO - 22/07/2015

*!*	AQM_VIA = ""   && ERASMO - 25/02/2016
*!*	AQM_PORT = ""  && ERASMO - 25/02/2016


*!*	RETURN(.T.)


*!*	******************************************
*!*	FUNCTION AQM_VALORIZZA_VARIABILI_MAGAZZINO
*!*	******************************************
*!*	PARAMETERS _dADOVE

*!*	LOCAL _OLD_SELECT
*!*	_OLD_SELECT = SELECT()

*!*	DO CASE

*!*		CASE _dADOVE == "MENU_BOL000"					&& SCARICO PER VENDITA
*!*		
*!*			AQM_CODSOC	= PUB_CODSOC
*!*			AQM_DATAGG  = ""							&& SOLO PER CARICO DI MAGAZZINO								*CARICO*
*!*			AQM_ORACAR	= ""
*!*			AQM_CODART  = M.ORD_CODART
*!*			AQM_ANAART  = M.ORD_CODART
*!*			AQM_CODMAG  = M.ORD_MAGA				
*!*			AQM_CODFOR  = ""							&& CODICE FORNITORE PER CARICHI								*CARICO*
*!*			AQM_CODCLI  = M.ORD_CODCLI					&& CODICE CLIENTE PER SCARICHI
*!*			*AQM_GIACEN  = M.ORD_QTAORD					&& QUANTITA' DA SCARICARE PER UNITA' DI MISURA
*!*			
*!*			*** VALORIZZO LA QTA DA SCARICARE IN BASE ALLA UNITA' DI MISURA DI MAGAZZINO (NON NECESSARIAMENTE QUELLA DI VENDITA)
*!*			_X_UMMAGA = AQM_TROVA_UMMAGA(AQM_ANAART)
*!*			IF ALLTRIM(M.ORD_UM) == ALLTRIM(_X_UMMAGA)
*!*				AQM_GIACEN = M.ORD_QTAORD
*!*			ELSE
*!*				DO CASE
*!*					CASE ALLTRIM(_X_UMMAGA) == "KG"
*!*						AQM_GIACEN = M.ORD_QTAKG
*!*						
*!*					CASE ALLTRIM(_X_UMMAGA) == "MQ"
*!*						AQM_GIACEN = M.ORD_QTAMQ
*!*											
*!*					CASE ALLTRIM(_X_UMMAGA) == "ML"
*!*						AQM_GIACEN = M.ORD_QTAML
*!*					
*!*					CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*						AQM_GIACEN = M.ORD_QTAMC
*!*										
*!*					OTHERWISE
*!*						AQM_GIACEN = M.ORD_QTAORD
*!*						
*!*				ENDCASE
*!*			ENDIF
*!*			
*!*			AQM_QTAKG   = M.ORD_QTAKG					&& QUANTITA' DA SCARICARE IN KG
*!*			AQM_QTAMQ   = M.ORD_QTAMQ					&& QUANTITA' DA SCARICARE IN METRI QUADRI
*!*			AQM_QTAML   = M.ORD_QTAML					&& QUANTITA' DA SCARICARE IN METRI LINEARI
*!*			AQM_QTAMC   = M.ORD_QTAMC   
*!*			

*!*			AQM_PRZCON  = 0								&& PREZZO DI ACQUISTO										*CARICO*
*!*			AQM_FILA_N  = 0								&& MAGAZZINO A LOCAZIONI : FILA
*!*			AQM_PIAN_N  = 0								&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_N  = 0								&& MAGAZZINO A LOCAZIONI : UBICAZIONE
*!*			AQM_FILA_X  = "" 							&& MAGAZZINO A LOCAZIONI : FILA	
*!*			AQM_PIAN_X  = ""							&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_X  = ""							&& MAGAZZINO A LOCAZIONI : UBICAZIONE


*!*			AQM_DADOVE  = "MENU_BOL000"					&& PROCEDURA DI PROVENIENZA
*!*			AQM_TOP 	= M.ORD_CAUS					&& CAUSALE DI CARICO/SCARICO
*!*			AQM_NUMDOC  = M.ORD_NUMORD					&& NUMERO DOCUMENTO
*!*			AQM_DTDOCU  = M.ORD_DATORD					&& DATA DOCUMENTO
*!*			AQM_DTREGI  = RIBALTA2(DTOC(DATE()))		&& DATA REGISTRAZIONE
*!*			
*!*			IF TYPE("PUB_DATREG") == 'C' .AND. !EMPTY(PUB_DATREG) 
*!*				AQM_DTREGI = RIBALTA2(PUB_DATREG)
*!*			ENDIF
*!*			
*!*			IF TYPE("PUB_ORAMOV") == 'C' .AND. !EMPTY(PUB_ORAMOV) 
*!*				AQM_ORAMOV = PUB_ORAMOV
*!*			ENDIF

*!*			AQM_VALUTA  = M.ORD_VALUTA					&& VALUTA DI RIFERIMENTO
*!*			IF EMPTY(AQM_VALUTA)
*!*				AQM_VALUTA = PUB_VALRIF
*!*			ENDIF
*!*			AQM_COORD   = M.ORD_COORD
*!*			AQM_CODPDV  = M.ORD_CODBUN					&& CODICE PUNTO DI VENDITA
*!*			AQM_UM      = M.ORD_UM						&& UNITA' DI MISURA
*!*			AQM_NRLINT  = 0								&& NUMERO LOTTO INTERNO *?*

*!*			AQM_ALTEZZ = M.ORD_ALTEZZ					&& ALTEZZA PRODOTTO
*!*			AQM_LUNGHE = M.ORD_LUNGHE					&& LUNGHEZZA PRODOTTO
*!*			AQM_SPESSO = M.ORD_SPESSO					&& SPESSORE PRODOTTO
*!*			*AQM_NRDBOB = M.ORD_NUMBOB					&& NUMERO BOBINE	
*!*			AQM_NRDBOB = 0								&& NUMERO BOBINA SCARICATA
*!*			AQM_PREACQ = 0								&& PREZZO DI ACQUISTO 										*CARICO*
*!*			AQM_PREVEN = M.ORD_PRZNET					&& PREZZO DI VENDITA
*!*			AQM_SCONTO = M.ORD_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC1    = M.ORD_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC2    = M.ORD_SC2						&& 2° SCONTO DI VENDITA
*!*			AQM_SC3    = M.ORD_SC3						&& 3° SCONTO DI VENDITA
*!*			AQM_IVAVEN = M.ORD_IVA						&& IVA
*!*			AQM_CODTAG = M.ORD_CODTAG					&& CODICE TAGLIA 
*!*			AQM_DESTAG = M.ORD_DESTAG					&& DESCRIZIONE TAGLIA
*!*			AQM_CODMAT = M.ORD_CODMAT					&& CODICE MATERIALE
*!*			AQM_DESMAT = M.ORD_DESMAT					&& DESCRIZIONE MATERIALE
*!*			AQM_CODCOL = M.ORD_CODCOL					&& CODICE COLORE
*!*			AQM_DESCOL = M.ORD_DESCOL					&& DESCRIZIONE COLORE		
*!*			AQM_SERIE  = M.ORD_SERIE					&& MAGAZZINO FISCALE : SERIE
*!*			AQM_AAPROD = M.ORD_ANNOPR					&& MAGAZZINO FISCALE : ANNO DI PRODUZIONE
*!*			AQM_SERBOL = M.ORD_SERBOL					&& MAGAZZINO FISCALE : SERIE BOLLETTA
*!*			AQM_SERNUM = M.ORD_SERNUM					&& MAGAZZINO FISCALE : NUMERO DI SERIE
*!*			AQM_NUMEDA = M.ORD_NUMEDA					&& MAGAZZINO FISCALE : NUMERO DA
*!*			AQM_NUMEAL = M.ORD_NUMEAL					&& MAGAZZINO FISCALE : NUMERO A
*!*			AQM_CBFISC = M.ORD_CBFISC					&& MAGAZZINO FISCALE : CODICE A BARRE FISCALE
*!*			AQM_NOTVAR = M.ORD_NOTE						&& NOTE
*!*			AQM_NUMMOV = PUB_NUMCSI						&& CARICO SCARICO *?*
*!*			AQM_LEGSYS = M.ORD_SYSMAG					&& SYS DELLA RIGA DDT CHE PERMETTE DI AGGANCIARE LA RIGA ORDINE A FORNITORE ORIGINALE SULLA BFO MENTRE SEVE PER AGGANCIARE LA RIGA DELLA DDT AL MOVIMENTO SE TRATTO UNA DDT DA MENU_BOL000



*!*		CASE _dADOVE == "AQMLIB_MOVIMENTO_MAGAZZINO"		&& RIPRENDE I DATI DAL RECORD DEL MOVIMENTO DI MAGAZZINO
*!*		


*!*			AQM_GIANEG = M.MOV_GIANEG 					 

*!*			AQM_CODSOC = PUB_CODSOC
*!*			AQM_NUMIDE = M.MOV_NUMIDE
*!*			AQM_LEGAME = M.MOV_LEGAME					&& AGGANCIA U_MAG_GG
*!*			*AQM_UNIQUE = SYS(2015)						&& M.MOV_UNIQUE
*!*			
*!*	 
*!*			AQM_UNIQUE = M.MOV_MAGUNQ					&& CORRISPONDENTE AL CAMPO U_MAG_GG.MAG_UNIQUE
*!*			IF EMPTY(AQM_UNIQUE)
*!*				AQM_UNIQUE = SYS(2015)
*!*			ENDIF
*!*	 
*!*			
*!*			AQM_DATAGG = M.MOV_DATSCA					&& DATA 1° CARICO DELLA GIACENZA CHE STO MOVIMENTANDO
*!*			AQM_ORACAR = TIME()							&& ORA 1° CARICO DELLA GIACENZA CHE STO MOVIMENTANDO
*!*			AQM_DTDOCU = M.MOV_DTDOCU					&& DATA DOCUMENTO
*!*			AQM_NUMDOC = M.MOV_NUMDOC					&& NUMERO DOCUMENTO
*!*			AQM_CODART = M.MOV_CODART					&& CODICE ARTICOLO+NUMERO IDENTIFICATIVO DEL PRODOTTO PER IL MAGAZZINO	
*!*			AQM_ANAART = M.MOV_ANAART					&& CODICE ARTICOLO E BASTA DI ANAGRAFICA ARTICOLI
*!*			AQM_CODMAG = M.MOV_CODMAG					&& CODICE MAGAZZINO
*!*			AQM_UM     = M.MOV_UM						&& UNITA' DI MISURA
*!*			AQM_CODFOR = M.MOV_CODFOR					&& CODICE FORNITORE PER CARICHI								*CARICO*
*!*			AQM_CODCLI = M.MOV_CODCLI					&& CODICE CLIENTE PER SCARICHI
*!*			AQM_GIACEN = M.MOV_QTAMOV					&& QUANTITA' DA SCARICARE PER UNITA' DI MISURA

*!*			AQM_QTAKG  = M.MOV_QTAKG					&& QUANTITA' DA SCARICARE IN KG
*!*			AQM_QTAMQ  = M.MOV_QTAMQ					&& QUANTITA' DA SCARICARE IN METRI QUADRI
*!*			AQM_QTAML  = M.MOV_QTAML					&& QUANTITA' DA SCARICARE IN METRI LINEARI
*!*			AQM_QTAMC  = M.MOV_QTAMC  					&& QUANTITA' DA SCARICARE IN METRI CUBI 					  
*!*			AQM_QTANR  = M.MOV_QTANR  					&& QUANTITA' DA SCARICARE A  NUMERO 						

*!*			AQM_NUMORF = M.MOV_NUMORF					&& NUMERO ORDINE A FORNITORE
*!*			AQM_DATORF = M.MOV_DATORF 					&& DATA ORDINE A FORNITORE
*!*			

*!*			AQM_PRZCON = M.MOV_PREACQ					&& PREZZO DI ACQUISTO										*CARICO*
*!*			AQM_FILA_N = M.MOV_FILA_N					&& MAGAZZINO A LOCAZIONI : FILA
*!*			AQM_PIAN_N = M.MOV_PIAN_N					&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_N = M.MOV_UBIC_N					&& MAGAZZINO A LOCAZIONI : UBICAZIONE
*!*			AQM_FILA_X = M.MOV_FILA_X 					&& MAGAZZINO A LOCAZIONI : FILA	
*!*			AQM_PIAN_X = M.MOV_PIAN_X					&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_X = M.MOV_UBIC_X					&& MAGAZZINO A LOCAZIONI : UBICAZIONE


*!*			AQM_DADOVE = "AQMLIB_MOVIMENTO_MAGAZZINO"	&& PROCEDURA DI PROVENIENZA
*!*			AQM_TOP    = M.MOV_TOP						&& CAUSALE DI CARICO/SCARICO
*!*			*AQM_DTREGI = M.MOV_DTREGI					&& DATA REGISTRAZIONE
*!*			*AQM_DTREGI = RIBALTA2(DTOC(DATE()))		&& DATA REGISTRAZIONE
*!*			AQM_DTREGI = M.MOV_DTREGI					&& DATA REGISTRAZIONE  
*!*			AQM_VALUTA = M.MOV_VALUTA					&& VALUTA DI RIFERIMENTO
*!*			IF EMPTY(AQM_VALUTA)
*!*				AQM_VALUTA  = PUB_VALRIF
*!*			ENDIF
*!*			AQM_COORD  = M.MOV_COORD
*!*			AQM_CODPDV = M.MOV_CODBUN					&& CODICE PUNTO DI VENDITA
*!*			AQM_UM     = M.MOV_CODBUN					&& UNITA' DI MISURA
*!*			AQM_NRLINT = M.MOV_NRLINT					&& NUMERO LOTTO INTERNO

*!*			AQM_ALTEZZ = M.MOV_ALTEZZ					&& ALTEZZA PRODOTTO
*!*			AQM_LUNGHE = M.MOV_LUNGHE					&& LUNGHEZZA PRODOTTO
*!*			AQM_SPESSO = M.MOV_SPESSO					&& SPESSORE PRODOTTO
*!*			AQM_NRDBOB = M.MOV_NRDBOB					&& NUMERO BOBINE	
*!*			AQM_PREACQ = M.MOV_PREACQ					&& PREZZO DI ACQUISTO 										*CARICO*
*!*			AQM_PREVEN = M.MOV_PREVEN					&& PREZZO DI VENDITA
*!*			AQM_SCONTO = M.MOV_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC1    = M.MOV_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC2    = M.MOV_SC2						&& 2° SCONTO DI VENDITA
*!*			AQM_SC3    = M.MOV_SC3						&& 3° SCONTO DI VENDITA
*!*			AQM_SC4    = 0  && ERASMO - 22/04/2016
*!*			AQM_SC5    = 0  && ERASMO - 22/04/2016
*!*			
*!*			AQM_IVAVEN = M.MOV_IVAVEN						&& IVA
*!*			AQM_CODTAG = M.MOV_CODTAG					&& CODICE TAGLIA 
*!*			AQM_DESTAG = M.MOV_DESTAG					&& DESCRIZIONE TAGLIA
*!*			AQM_CODMAT = M.MOV_CODMAT					&& CODICE MATERIALE
*!*			AQM_DESMAT = M.MOV_DESMAT					&& DESCRIZIONE MATERIALE
*!*			AQM_CODCOL = M.MOV_CODCOL					&& CODICE COLORE
*!*			AQM_DESCOL = M.MOV_DESCOL					&& DESCRIZIONE COLORE		
*!*			AQM_SERIE  = M.MOV_SERIE					&& MAGAZZINO FISCALE : SERIE
*!*			AQM_AAPROD = M.MOV_AAPROD					&& MAGAZZINO FISCALE : ANNO DI PRODUZIONE
*!*			AQM_SERBOL = M.MOV_SERBOL					&& MAGAZZINO FISCALE : SERIE BOLLETTA
*!*			AQM_SERNUM = M.MOV_SERNUM					&& MAGAZZINO FISCALE : NUMERO DI SERIE
*!*			AQM_NUMEDA = M.MOV_NUMEDA					&& MAGAZZINO FISCALE : NUMERO DA
*!*			AQM_NUMEAL = M.MOV_NUMEAL					&& MAGAZZINO FISCALE : NUMERO A
*!*			AQM_CBFISC = M.MOV_CBFISC					&& MAGAZZINO FISCALE : CODICE A BARRE FISCALE
*!*			AQM_NOTVAR = M.MOV_NOTVAR					&& NOTE
*!*			AQM_NUMMOV = M.MOV_NUMMOV					&& CARICO SCARICO *?*
*!*			AQM_LEGSYS = M.MOV_LEGSYS					&& SYS DELLA RIGA DDT CHE PERMETTE DI AGGANCIARE LA RIGA ORDINE A FORNITORE ORIGINALE SULLA BFO MENTRE SEVE PER AGGANCIARE LA RIGA DELLA DDT AL MOVIMENTO SE TRATTO UNA DDT DA MENU_BOL000
*!*			
*!*			AQM_CDAFOR = M.MOV_CDAFOR
*!*			AQM_OINFOR = M.MOV_OINFOR
*!*			AQM_PINFOR = M.MOV_PINFOR
*!*			AQM_DTPFOR = M.MOV_DTPFOR
*!*			AQM_TRAFOR = M.MOV_TRAFOR
*!*			AQM_NBAFOR = M.MOV_NBAFOR
*!*			AQM_BDAFOR = M.MOV_BDAFOR
*!*			AQM_BALFOR = M.MOV_BALFOR
*!*			AQM_PNKFOR = M.MOV_PNKFOR
*!*			
*!*			AQM_SERIAL = M.MOV_SERIAL
*!*			
*!*			AQM_DATORI = M.MOV_DATORI  && ERASMO - 16/02/2015
*!*			
*!*			AQM_FORNSUPP = M.MOV_FORNSUPP  && ERASMO - 22/07/2015

*!*		
*!*		CASE _dADOVE == "CU_BFO_DD-DL"  && DATI DA VALORIZZARE IN BASE AL CURSORE DI DETTAGLI DI 2° E 3° LIVELLO
*!*			
*!*			AQM_CODSOC = PUB_CODSOC
*!*			IF TYPE("PUB_DATREG") == 'C' .AND. !EMPTY(PUB_DATREG)  && DATA 1° CARICO DELLA GIACENZA CHE STO MOVIMENTANDO
*!*				AQM_DATAGG = RIBALTA2(PUB_DATREG)
*!*			ELSE
*!*				AQM_DATAGG = RIBALTA2(DTOC(DATE()))
*!*			ENDIF
*!*			
*!*			AQM_ORACAR = TIME()							&& ORA 1° CARICO DELLA GIACENZA CHE STO MOVIMENTANDO
*!*			
*!*			IF TYPE("PUB_ORAMOV") == 'C' .AND. !EMPTY(PUB_ORAMOV)
*!*				AQM_ORACAR = PUB_ORAMOV
*!*				AQM_ORAMOV = PUB_ORAMOV
*!*			ENDIF
*!*			
*!*			AQM_ANAART = XXX_ANAART
*!*			AQM_NUMIDE = XXX_NUMIDE
*!*			AQM_UNIQUE = SYS(2015)						&& IDENTIFICA UNIVOCAMENTE LA RIGA DI GIACENZA	
*!*			
*!*			IF EMPTY(M.ORD_CODART) .OR. M.ORD_NRLINT <= 0
*!*				AQM_NUMERO_LOTTO_INTERNO(AQM_ANAART)  && VALORIZZA LE VARIABILI AQM_CODART,AQM_NRLINT,AQM_CODINT PER UN NUOVO NUMERO DI LOTTO INTERNO
*!*			ELSE
*!*				AQM_CODART = M.ORD_CODART
*!*				AQM_CODINT = M.ORD_CODART
*!*				AQM_NRLINT = M.ORD_NRLINT
*!*			ENDIF
*!*			
*!*			AQM_CODMAG  = M.ORD_MAGA
*!*			AQM_CODFOR  = XXX_CODFOR					&& CODICE FORNITORE PER CARICHI								*CARICO*
*!*			AQM_CODCLI  = ""							&& CODICE CLIENTE PER SCARICHI
*!*			*AQM_GIACEN  = M.ORD_QTAORD					&& QUANTITA' DA SCARICARE PER UNITA' DI MISURA
*!*			
*!*			*** VALORIZZO LA QTA DA CARICARE IN BASE ALLA UNITA' DI MISURA DI MAGAZZINO (NON NECESSARIAMENTE QUELLA DI ACQUISTO)
*!*			_X_UMMAGA = AQM_TROVA_UMMAGA(AQM_ANAART)

*!*			AQM_GIACEN = 0
*!*			
*!*			*** CONSIDERO LA QUANTITA' IN UM MAGAZZINO PER IL SINGOLO DETTAGLIO DI CU_BFO_DL (ULTIMO DAL QUALE HO INVOCATO LA 'SCATTER MEMVAR')
*!*			DO CASE
*!*				CASE ALLTRIM(_X_UMMAGA) == "KG"
*!*					AQM_GIACEN = M.ORD_QTAKG
*!*					
*!*				CASE ALLTRIM(_X_UMMAGA) == "MQ"
*!*					AQM_GIACEN = M.ORD_QTAMQ
*!*										
*!*				CASE ALLTRIM(_X_UMMAGA) == "ML"
*!*					AQM_GIACEN = M.ORD_QTAML
*!*					
*!*				CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*					AQM_GIACEN = M.ORD_QTAMC
*!*									
*!*				OTHERWISE
*!*					AQM_GIACEN = M.ORD_QTAMQ
*!*					
*!*			ENDCASE	
*!*			
*!*			*AQM_NOTE   = M.ORD_NOTEBO					&& SERGIO 2015/07/21 : DA ORA IN MOVIMAGA E' POSSIBILE DIGITARE NOTE/COMMENTI
*!*			AQM_NOTE   = M.ORS_ERRNOT					&& ERASMO - 27/07/2015 - NEI DETTAGLI BOBINE DA CU_BFO_DL QUESTO CAMPO CORRISPONDE CON ORS_ERRNOT
*!*			
*!*			AQM_QTAKG   = M.ORD_QTAKG					&& QUANTITA' DA CARICARE IN KG
*!*			AQM_QTAMQ   = M.ORD_QTAMQ					&& QUANTITA' DA CARICARE IN METRI QUADRI
*!*			AQM_QTAML   = M.ORD_QTAML					&& QUANTITA' DA CARICARE IN METRI LINEARI
*!*			AQM_QTAMC   = M.ORD_QTAMC  
*!*			
*!*			AQM_PRZCON  = M.ORD_PRZNET					&& PREZZO DI ACQUISTO										*CARICO*
*!*			AQM_FILA_N  = M.ORD_FILA_N					&& MAGAZZINO A LOCAZIONI : FILA
*!*			AQM_PIAN_N  = M.ORD_PIAN_N					&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_N  = M.ORD_UBIC_N					&& MAGAZZINO A LOCAZIONI : UBICAZIONE
*!*			AQM_FILA_X  = M.ORD_FILA_X					&& MAGAZZINO A LOCAZIONI : FILA	
*!*			AQM_PIAN_X  = M.ORD_PIAN_X					&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_X  = M.ORD_UBIC_X					&& MAGAZZINO A LOCAZIONI : UBICAZIONE

*!*			AQM_DADOVE  = "MENU_BFO000"					&& PROCEDURA DI PROVENIENZA
*!*			AQM_TOP 	= XXX_CAUS						&& CAUSALE DI CARICO/SCARICO
*!*			AQM_NUMDOC  = XXX_NUMORD					&& NUMERO DOCUMENTO
*!*			AQM_DTDOCU  = XXX_DATORD					&& DATA DOCUMENTO
*!*			AQM_DTREGI  = AQM_DATAGG					&& DATA REGISTRAZIONE
*!*			AQM_VALUTA  = XXX_VALUTA					&& VALUTA DI RIFERIMENTO
*!*			AQM_COORD   = M.ORD_COORD
*!*			AQM_CODPDV  = XXX_CODBUN					&& CODICE PUNTO DI VENDITA
*!*			AQM_UM      = M.ORD_UM						&& UNITA' DI MISURA

*!*			AQM_ALTEZZ = M.ORD_ALTEZZ					&& ALTEZZA PRODOTTO
*!*			AQM_LUNGHE = M.ORD_LUNGHE					&& LUNGHEZZA PRODOTTO
*!*			AQM_SPESSO = M.ORD_SPESSO					&& SPESSORE PRODOTTO
*!*			AQM_NRDBOB = M.ORD_NRDBOB					&& NUMERO BOBINA	
*!*			AQM_PREACQ = M.ORD_PREZZO					&& PREZZO DI ACQUISTO 										*CARICO*
*!*			AQM_PREVEN = 0								&& PREZZO DI VENDITA
*!*			AQM_SCONTO = M.ORD_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC1    = M.ORD_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC2    = M.ORD_SC2						&& 2° SCONTO DI VENDITA
*!*			AQM_SC3    = M.ORD_SC3						&& 3° SCONTO DI VENDITA
*!*			
*!*			AQM_IVAVEN = M.ORD_IVA						&& IVA
*!*			AQM_CODTAG = M.ORD_CODTAG					&& CODICE TAGLIA 
*!*			AQM_DESTAG = M.ORD_DESTAG					&& DESCRIZIONE TAGLIA
*!*			AQM_CODMAT = M.ORD_CODMAT					&& CODICE MATERIALE
*!*			AQM_DESMAT = M.ORD_DESMAT					&& DESCRIZIONE MATERIALE
*!*			AQM_CODCOL = M.ORD_CODCOL					&& CODICE COLORE
*!*			AQM_DESCOL = M.ORD_DESCOL					&& DESCRIZIONE COLORE		
*!*			AQM_SERIE  = M.ORD_SERIE					&& MAGAZZINO FISCALE : SERIE
*!*			AQM_AAPROD = M.ORD_AAPROD					&& MAGAZZINO FISCALE : ANNO DI PRODUZIONE
*!*			AQM_SERBOL = M.ORD_SERBOL					&& MAGAZZINO FISCALE : SERIE BOLLETTA
*!*			AQM_SERNUM = M.ORD_SERNUM					&& MAGAZZINO FISCALE : NUMERO DI SERIE
*!*			AQM_NUMEDA = M.ORD_NUMEDA					&& MAGAZZINO FISCALE : NUMERO DA
*!*			AQM_NUMEAL = M.ORD_NUMEAL					&& MAGAZZINO FISCALE : NUMERO A
*!*			AQM_CBFISC = M.ORD_CBFISC					&& MAGAZZINO FISCALE : CODICE A BARRE FISCALE
*!*			AQM_NOTVAR = M.ORD_NOTE						&& NOTE
*!*			AQM_NUMMOV = PUB_NUMCSI						&& CARICO SCARICO *?*
*!*			AQM_LEGSYS = M.ORD_SYSMAG					&& SYS DELLA RIGA DDT CHE PERMETTE DI AGGANCIARE LA RIGA ORDINE A FORNITORE ORIGINALE SULLA BFO MENTRE SEVE PER AGGANCIARE LA RIGA DELLA DDT AL MOVIMENTO SE TRATTO UNA DDT DA MENU_BOL000
*!*					
*!*			AQM_CDAFOR = M.ORD_CDAFOR
*!*			AQM_OINFOR = M.ORD_OINFOR
*!*			AQM_PINFOR = M.ORD_PINFOR
*!*			AQM_DTPFOR = M.ORD_DTPFOR
*!*			AQM_TRAFOR = M.ORD_TRAFOR
*!*			AQM_NBAFOR = M.ORD_NBAFOR
*!*			AQM_BDAFOR = M.ORD_BDAFOR
*!*			AQM_BALFOR = M.ORD_BALFOR
*!*			AQM_PNKFOR = M.ORD_PNKFOR
*!*			
*!*			AQM_SERIAL = M.ORS_NLOTFO
*!*			
*!*			**=> ERASMO - INIZIO 07/11/2014
*!*			*** SE VALORIZZAZIONE PREZZO OBBLIGATORIA E PREZZO PASSATO = 0, VALORIZZO CON PREZZO DI COSTO STANDARD
*!*			IF PUB_FLGPCO AND AQM_PRZCON = 0
*!*				LOCAL _cNomeCurArticoli
*!*				_cNomeCurArticoli = "CUR_ARTICOLI" + SYS(2015)
*!*				x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
*!*				x_codi = "art_codpri = '" + ALLTRIM(AQM_ANAART) + "'"
*!*				x_cond = x_soci + " and " + x_codi
*!*				cSql = "select ART_PRZCOS,ART_PRZCO1 from u_art_pr where " + x_cond
*!*				IF !ExecCommand(cSql,_cNomeCurArticoli)
*!*				   RETURN .F.
*!*				ENDIF
*!*				SELECT &_cNomeCurArticoli
*!*				GO TOP
*!*				IF !EOF()
*!*					IF ART_PRZCOS > 0
*!*						AQM_PRZCON = ART_PRZCOS
*!*					ELSE
*!*						IF ART_PRZCO1 > 0
*!*							AQM_PRZCON = ART_PRZCO1
*!*						ENDIF			
*!*					ENDIF
*!*				ENDIF
*!*				USE
*!*			ENDIF
*!*			AQM_PREACQ = AQM_PRZCON
*!*			**=> ERASMO - FINE 07/11/2014
*!*			
*!*			AQM_DATORI = IIF(TYPE("M.ORD_DATORI") <> 'C', "", IIF(!EMPTY(M.ORD_DATORI), M.ORD_DATORI, ""))  && ERASMO - 16/02/2015
*!*			
*!*			AQM_FORNSUPP = IIF(TYPE("M.ORD_FORNSUPP") <> 'C', "", IIF(!EMPTY(M.ORD_FORNSUPP), M.ORD_FORNSUPP, ""))  && ERASMO - 22/07/2015
*!*			
*!*				
*!*		CASE _dADOVE == "CU_BFO_DD"  && DATI DA VALORIZZARE IN BASE AL CURSORE DI DETTAGLI DI 2° LIVELLO
*!*			
*!*			AQM_CODSOC = PUB_CODSOC
*!*			IF TYPE("PUB_DATREG") == 'C' .AND. !EMPTY(PUB_DATREG)  && DATA 1° CARICO DELLA GIACENZA CHE STO MOVIMENTANDO
*!*				AQM_DATAGG = RIBALTA2(PUB_DATREG)
*!*			ELSE
*!*				AQM_DATAGG = RIBALTA2(DTOC(DATE()))
*!*			ENDIF
*!*			AQM_ORACAR = TIME()							&& ORA 1° CARICO DELLA GIACENZA CHE STO MOVIMENTANDO
*!*			
*!*			IF TYPE("PUB_ORAMOV") == 'C' .AND. !EMPTY(PUB_ORAMOV)
*!*				AQM_ORACAR = PUB_ORAMOV
*!*				AQM_ORAMOV = PUB_ORAMOV
*!*			ENDIF
*!*			
*!*			AQM_ANAART = XXX_ANAART
*!*			AQM_NUMIDE = XXX_NUMIDE
*!*			AQM_UNIQUE = SYS(2015)						&& IDENTIFICA UNIVOCAMENTE LA RIGA DI GIACENZA		
*!*			
*!*			AQM_CODART = IIF(EMPTY(M.ORD_CODFIS),M.ORD_CODART,M.ORD_CODFIS)
*!*			AQM_CODINT = IIF(EMPTY(M.ORD_CODFIS),M.ORD_CODART,M.ORD_CODFIS)
*!*			AQM_NRLINT = M.ORD_NRLINT
*!*			
*!*	        AQM_PRSPOT = M.ORD_PRSPOT					&& SERGIO 2014/09/27 IDENTIFICA IL CASO DI ARTICOLO ACQUISTATO IN MODALITA' SPOT

*!*			
*!*			AQM_CODMAG  = M.ORD_MAGA
*!*			AQM_CODFOR  = XXX_CODFOR					&& CODICE FORNITORE PER CARICHI								*CARICO*
*!*			AQM_CODCLI  = ""							&& CODICE CLIENTE PER SCARICHI
*!*			
*!*			*** VALORIZZO LA QTA DA CARICARE IN BASE ALLA UNITA' DI MISURA DI MAGAZZINO (NON NECESSARIAMENTE QUELLA DI ACQUISTO)
*!*			_X_UMMAGA = AQM_TROVA_UMMAGA(AQM_ANAART)
*!*			IF ALLTRIM(M.ORD_UM) == ALLTRIM(_X_UMMAGA)
*!*				AQM_GIACEN = M.ORD_QTAORD
*!*			ELSE
*!*				DO CASE
*!*					CASE ALLTRIM(_X_UMMAGA) == "KG"
*!*						AQM_GIACEN = M.ORD_QTAKG
*!*						
*!*					CASE ALLTRIM(_X_UMMAGA) == "MQ"
*!*						AQM_GIACEN = M.ORD_QTAMQ
*!*											
*!*					CASE ALLTRIM(_X_UMMAGA) == "ML"
*!*						AQM_GIACEN = M.ORD_QTAML
*!*						
*!*					CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*						AQM_GIACEN = M.ORD_QTAMC
*!*					
*!*					OTHERWISE
*!*						AQM_GIACEN = M.ORD_QTAORD
*!*						
*!*				ENDCASE
*!*			ENDIF
*!*			
*!*			X_TIPO = CERCATIPO(AQM_ANAART)
*!*			IF X_TIPO = '3'  && MANICOTTI
*!*				IF ALLTRIM(_X_UMMAGA) == "NR"
*!*					AQM_GIACEN = M.ORD_NUMBOB
*!*				ENDIF
*!*			ENDIF
*!*			
*!*			IF X_TIPO = '8'  && CARTE IMPREGNATE
*!*				IF ALLTRIM(_X_UMMAGA) == "NR"
*!*					AQM_GIACEN = M.ORD_NUMBOB
*!*				ENDIF
*!*			ENDIF

*!*			AQM_NOTE   = M.ORD_NOTEBO					&& SERGIO 2015/07/21 : DA ORA IN MOVIMAGA E' POSSIBILE DIGITARE NOTE/COMMENTI

*!*			
*!*			AQM_QTAKG   = M.ORD_QTAKG					&& QUANTITA' DA CARICARE IN KG
*!*			AQM_QTAMQ   = M.ORD_QTAMQ					&& QUANTITA' DA CARICARE IN METRI QUADRI
*!*			AQM_QTAML   = M.ORD_QTAML					&& QUANTITA' DA CARICARE IN METRI LINEARI
*!*			AQM_QTAMC   = M.ORD_QTAMC   

*!*			AQM_PRZCON  = M.ORD_PRZNET					&& PREZZO DI ACQUISTO										*CARICO*
*!*			AQM_FILA_N  = M.ORD_FILA_N					&& MAGAZZINO A LOCAZIONI : FILA
*!*			AQM_PIAN_N  = M.ORD_PIAN_N					&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_N  = M.ORD_UBIC_N					&& MAGAZZINO A LOCAZIONI : UBICAZIONE
*!*			AQM_FILA_X  = M.ORD_FILA_X					&& MAGAZZINO A LOCAZIONI : FILA	
*!*			AQM_PIAN_X  = M.ORD_PIAN_X					&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_X  = M.ORD_UBIC_X					&& MAGAZZINO A LOCAZIONI : UBICAZIONE

*!*			AQM_DADOVE  = "MENU_BFO000"					&& PROCEDURA DI PROVENIENZA
*!*			AQM_TOP 	= XXX_CAUS						&& CAUSALE DI CARICO/SCARICO
*!*			AQM_NUMDOC  = XXX_NUMORD					&& NUMERO DOCUMENTO
*!*			AQM_DTDOCU  = XXX_DATORD					&& DATA DOCUMENTO
*!*			AQM_DTREGI  = AQM_DATAGG					&& DATA REGISTRAZIONE
*!*			AQM_VALUTA  = XXX_VALUTA					&& VALUTA DI RIFERIMENTO
*!*			AQM_COORD   = M.ORD_COORD
*!*			AQM_CODPDV  = XXX_CODBUN					&& CODICE PUNTO DI VENDITA
*!*			AQM_UM      = M.ORD_UM						&& UNITA' DI MISURA

*!*			AQM_ALTEZZ = M.ORD_ALTEZZ					&& ALTEZZA PRODOTTO
*!*			AQM_LUNGHE = M.ORD_LUNGHE					&& LUNGHEZZA PRODOTTO
*!*			AQM_SPESSO = M.ORD_SPESSO					&& SPESSORE PRODOTTO
*!*			AQM_NRDBOB = 0								&& NUMERO BOBINA	
*!*			AQM_PREACQ = M.ORD_PREZZO					&& PREZZO DI ACQUISTO 										*CARICO*
*!*			AQM_PREVEN = 0								&& PREZZO DI VENDITA
*!*			AQM_SCONTO = M.ORD_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC1    = M.ORD_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC2    = M.ORD_SC2						&& 2° SCONTO DI VENDITA
*!*			AQM_SC3    = M.ORD_SC3						&& 3° SCONTO DI VENDITA
*!*			
*!*			AQM_IVAVEN = M.ORD_IVA						&& IVA
*!*			AQM_CODTAG = M.ORD_CODTAG					&& CODICE TAGLIA 
*!*			AQM_DESTAG = M.ORD_DESTAG					&& DESCRIZIONE TAGLIA
*!*			AQM_CODMAT = M.ORD_CODMAT					&& CODICE MATERIALE
*!*			AQM_DESMAT = M.ORD_DESMAT					&& DESCRIZIONE MATERIALE
*!*			AQM_CODCOL = M.ORD_CODCOL					&& CODICE COLORE
*!*			AQM_DESCOL = M.ORD_DESCOL					&& DESCRIZIONE COLORE		
*!*			AQM_SERIE  = M.ORD_SERIE					&& MAGAZZINO FISCALE : SERIE
*!*			AQM_AAPROD = M.ORD_AAPROD					&& MAGAZZINO FISCALE : ANNO DI PRODUZIONE
*!*			AQM_SERBOL = M.ORD_SERBOL					&& MAGAZZINO FISCALE : SERIE BOLLETTA
*!*			AQM_SERNUM = M.ORD_SERNUM					&& MAGAZZINO FISCALE : NUMERO DI SERIE
*!*			AQM_NUMEDA = M.ORD_NUMEDA					&& MAGAZZINO FISCALE : NUMERO DA
*!*			AQM_NUMEAL = M.ORD_NUMEAL					&& MAGAZZINO FISCALE : NUMERO A
*!*			AQM_CBFISC = M.ORD_CBFISC					&& MAGAZZINO FISCALE : CODICE A BARRE FISCALE
*!*			AQM_NOTVAR = M.ORD_NOTE						&& NOTE
*!*			AQM_NUMMOV = PUB_NUMCSI						&& CARICO SCARICO *?*
*!*			AQM_LEGSYS = M.ORD_SYSMAG					&& SYS DELLA RIGA DDT CHE PERMETTE DI AGGANCIARE LA RIGA ORDINE A FORNITORE ORIGINALE SULLA BFO MENTRE SEVE PER AGGANCIARE LA RIGA DELLA DDT AL MOVIMENTO SE TRATTO UNA DDT DA MENU_BOL000

*!*			AQM_QUAPRO = M.ORD_QUAPRO					&& CODICE QUALITA' PRODOTTO
*!*			AQM_CLIINV = M.ORD_CLIENT					&& CODICE CLIENTE PER CUI E' STATO FATTO IL PRODOTTO E RILEVATO DALLE PROCEDURE INVENTARIALI

*!*			AQM_QUAPRO_MOV = M.ORD_QUAPRO				&& CODICE QUALITA' PRODOTTO PER U_MAG_MO
*!*			AQM_CLIINV_MOV = M.ORD_CLIENT				&& CODICE CLIENTE PER CUI E' STATO FATTO IL PRODOTTO E RILEVATO DALLE PROCEDURE INVENTARIALI PER U_MAG_MO

*!*			AQM_SERIAL = M.ORS_NLOTFO
*!*			
*!*			**=> ERASMO - INIZIO 07/11/2014
*!*			*** SE VALORIZZAZIONE PREZZO OBBLIGATORIA E PREZZO PASSATO = 0, VALORIZZO CON PREZZO DI COSTO STANDARD
*!*			IF PUB_FLGPCO AND AQM_PRZCON = 0
*!*				LOCAL _cNomeCurArticoli
*!*				_cNomeCurArticoli = "CUR_ARTICOLI" + SYS(2015)
*!*				x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
*!*				x_codi = "art_codpri = '" + ALLTRIM(AQM_ANAART) + "'"
*!*				x_cond = x_soci + " and " + x_codi
*!*				cSql = "select ART_PRZCOS,ART_PRZCO1 from u_art_pr where " + x_cond
*!*				IF !ExecCommand(cSql,_cNomeCurArticoli)
*!*				   RETURN .F.
*!*				ENDIF
*!*				SELECT &_cNomeCurArticoli
*!*				GO TOP
*!*				IF !EOF()
*!*					IF ART_PRZCOS > 0
*!*						AQM_PRZCON = ART_PRZCOS
*!*					ELSE
*!*						IF ART_PRZCO1 > 0
*!*							AQM_PRZCON = ART_PRZCO1
*!*						ENDIF			
*!*					ENDIF
*!*				ENDIF
*!*				USE
*!*				AQM_PREACQ = AQM_PRZCON
*!*			ENDIF
*!*			**=> ERASMO - FINE 07/11/2014
*!*			
*!*			AQM_DATORI = IIF(TYPE("PUB_DATORI") <> 'C', "", IIF(!EMPTY(PUB_DATORI), PUB_DATORI, ""))  && ERASMO - 16/02/2015
*!*			
*!*			AQM_FORNSUPP = IIF(TYPE("PUB_FORNSUPP") <> 'C', "", IIF(!EMPTY(PUB_FORNSUPP), PUB_FORNSUPP, ""))  && ERASMO - 22/07/2015
*!*			

*!*		CASE _dADOVE == "AQMLIB_GIACENZA_MAGAZZINO"		&& RIPRENDE I DATI DAL RECORD DELLA GIACENZA DI MAGAZZINO
*!*		
*!*			AQM_CODSOC = PUB_CODSOC
*!*			AQM_NUMIDE = M.MAG_NUMIDE
*!*			AQM_LEGAME = M.MAG_LEGAME					&& AGGANCIA U_MAG_GG
*!*			AQM_UNIQUE = M.MAG_UNIQUE					&& IDENTIFICA UNIVOCAMENTE LA RIGA DI GIACENZA

*!*			AQM_DATAGG = M.MAG_DATAGG					&& DATA 1° CARICO DELLA GIACENZA CHE STO MOVIMENTANDO
*!*			AQM_ORACAR = M.MAG_ORACAR					&& ORA 1° CARICO DELLA GIACENZA CHE STO MOVIMENTANDO
*!*			
*!*			AQM_DTDOCU = ""								&& DOV'E' LA DATA DOCUMENTO IN U_MAG_GG ???
*!*			AQM_NUMDOC = ""								&& DOV'E' IL NUMERO DOCUMENTO IN U_MAG_GG ???
*!*			AQM_CODART = M.MAG_CODART					&& CODICE ARTICOLO+NUMERO IDENTIFICATIVO DEL PRODOTTO PER IL MAGAZZINO	
*!*			AQM_ANAART = M.MAG_ANAART					&& CODICE ARTICOLO E BASTA DI ANAGRAFICA ARTICOLI
*!*			AQM_CODMAG = M.MAG_CODMAG					&& CODICE MAGAZZINO
*!*			AQM_UM     = ""								&& NON C'E' UNITA' DI MISURA IN U_MAG_GG - DEVE ESSERE CONSIDERATA U_ART_PR.ART_UMMAGA
*!*			AQM_CODFOR = M.MAG_FORNIT					&& CODICE FORNITORE PER CARICHI								*CARICO*
*!*			AQM_CODCLI = ""								&& CODICE CLIENTE PER SCARICHI
*!*			
*!*			AQM_GIACEN = M.MAG_GIACEN					&& QUANTITA' DA SCARICARE PER UNITA' DI MISURA DI MAGAZZINO MEMORIZZATA NELLA VARIABILE M.MAG_GIACEN
*!*			
*!*			AQM_QTAMQ = M.MAG_QTAMQ
*!*			AQM_QTAML = M.MAG_QTAML
*!*			AQM_QTAKG = M.MAG_QTAKG
*!*			
*!*			AQM_QTAMC = M.MAG_QTAMC   
*!*			
*!*			*** VALORIZZO LA QTA IN UM MAGAZZINO CON LA QTA IN GIACENZA
*!*			_X_UMMAGA = AQM_TROVA_UMMAGA(AQM_ANAART)
*!*			DO CASE
*!*				CASE ALLTRIM(_X_UMMAGA) == "KG"
*!*					AQM_QTAKG = AQM_GIACEN
*!*				CASE ALLTRIM(_X_UMMAGA) == "MQ"
*!*					AQM_QTAMQ = AQM_GIACEN
*!*				CASE ALLTRIM(_X_UMMAGA) == "ML"
*!*					AQM_QTAML = AQM_GIACEN
*!*				CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*					AQM_QTAMC = AQM_GIACEN
*!*			ENDCASE
*!*			
*!*			AQM_NUMORF = ""								&& NUMERO ORDINE A FORNITORE
*!*			AQM_DATORF = ""								&& DATA ORDINE A FORNITORE
*!*			
*!*			AQM_PRZCON = M.MAG_PRZCON					&& PREZZO DI ACQUISTO										*CARICO*
*!*			AQM_FILA_N = M.MAG_FILA_N					&& MAGAZZINO A LOCAZIONI : FILA
*!*			AQM_PIAN_N = M.MAG_PIAN_N					&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_N = M.MAG_UBIC_N					&& MAGAZZINO A LOCAZIONI : UBICAZIONE
*!*			AQM_FILA_X = M.MAG_FILA_X 					&& MAGAZZINO A LOCAZIONI : FILA	
*!*			AQM_PIAN_X = M.MAG_PIAN_X					&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_X = M.MAG_UBIC_X					&& MAGAZZINO A LOCAZIONI : UBICAZIONE
*!*			
*!*			AQM_DADOVE = "AQMLIB_GIACENZA_MAGAZZINO"	&& PROCEDURA DI PROVENIENZA
*!*			AQM_TOP    = ""								&& CAUSALE DI CARICO/SCARICO
*!*			AQM_DTREGI = ""								&& DATA REGISTRAZIONE
*!*			*AQM_VALUTA = ""								&& VALUTA DI RIFERIMENTO
*!*			**=> ERASMO - INIZIO 04/02/2015
*!*			*** DETERMINO LA VALUTA DAL PRIMO MOVIMENTO DI CARICO LEGATO A QUESTA GIACENZA
*!*			x_lega = "MOV_LEGAME = '" + M.MAG_LEGAME + "'"
*!*			x_segn = "MOV_SEGNO = '+'"
*!*			x_cond = x_lega + " and " + x_segn
*!*			cSql = "SELECT TOP 1 MOV_VALUTA FROM U_MAG_MO WHERE " + x_cond + " ORDER BY MOV_DTREGI, MOV_ORAMOV"
*!*			IF !ExecCommand(Csql,"TMP_MAG_MO")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT TMP_MAG_MO
*!*			IF !EOF()
*!*				AQM_VALUTA = MOV_VALUTA
*!*			ENDIF
*!*			**=> ERASMO - FINE 04/02/2015
*!*			IF EMPTY(AQM_VALUTA)
*!*				AQM_VALUTA = PUB_VALRIF
*!*			ENDIF
*!*			AQM_COORD  = ""
*!*			AQM_CODPDV = M.MAG_CODPDV					&& CODICE PUNTO DI VENDITA
*!*			AQM_UM     = ""								&& UNITA' DI MISURA
*!*			AQM_NRLINT = M.MAG_NRLINT					&& NUMERO LOTTO INTERNO
*!*			
*!*			AQM_ALTEZZ = M.MAG_ALTEZZ					&& ALTEZZA PRODOTTO
*!*			AQM_LUNGHE = M.MAG_LUNGHE					&& LUNGHEZZA PRODOTTO
*!*			AQM_SPESSO = M.MAG_SPESSO					&& SPESSORE PRODOTTO
*!*			
*!*	*!*			X_TIPO = CERCATIPO(AQM_ANAART)
*!*	*!*			IF X_TIPO = '1'  && BOBINE
*!*	*!*				IF AQM_QTAMQ <= 0
*!*	*!*					AQM_QTAMQ = TROVA_MQ_DA_AL(AQM_ALTEZZ,AQM_LUNGHE,1)
*!*	*!*				ENDIF
*!*	*!*				IF AQM_QTAML <= 0
*!*	*!*					AQM_QTAML = TROVA_ML_DA_LU(AQM_LUNGHE,1)
*!*	*!*				ENDIF
*!*	*!*				IF AQM_QTAKG <= 0
*!*	*!*					AQM_QTAKG = TROVA_KG_DA_MQ(AQM_ANAART,AQM_SPESSO,AQM_QTAMQ,1)
*!*	*!*				ENDIF
*!*	*!*			ENDIF
*!*			
*!*			AQM_NRDBOB = M.MAG_NRDBOB					&& NUMERO BOBINA
*!*			AQM_PREACQ = M.MAG_PRZCON					&& PREZZO DI ACQUISTO 										*CARICO*
*!*			AQM_PREVEN = 0								&& PREZZO DI VENDITA
*!*			AQM_SCONTO = M.MAG_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC1    = M.MAG_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC2    = M.MAG_SC2						&& 2° SCONTO DI VENDITA
*!*			AQM_SC3    = M.MAG_SC3						&& 3° SCONTO DI VENDITA
*!*			AQM_SC4    = M.MAG_SC4						&& 4° SCONTO DI VENDITA
*!*			AQM_SC5    = M.MAG_SC5						&& 5° SCONTO DI VENDITA
*!*			
*!*			AQM_IVAVEN = ""								&& IVA
*!*			AQM_CODTAG = ""								&& CODICE TAGLIA 
*!*			AQM_DESTAG = ""								&& DESCRIZIONE TAGLIA
*!*			AQM_CODMAT = M.MAG_CODMAT					&& CODICE MATERIALE
*!*			AQM_DESMAT = M.MAG_DESMAT					&& DESCRIZIONE MATERIALE
*!*			AQM_CODCOL = M.MAG_CODCOL					&& CODICE COLORE
*!*			AQM_DESCOL = M.MAG_DESCOL					&& DESCRIZIONE COLORE		
*!*			AQM_SERIE  = M.MAG_SERIE					&& MAGAZZINO FISCALE : SERIE
*!*			AQM_AAPROD = M.MAG_AAPROD					&& MAGAZZINO FISCALE : ANNO DI PRODUZIONE
*!*			AQM_SERBOL = M.MAG_SERBOL					&& MAGAZZINO FISCALE : SERIE BOLLETTA
*!*			AQM_SERNUM = M.MAG_SERNUM					&& MAGAZZINO FISCALE : NUMERO DI SERIE
*!*			AQM_NUMEDA = M.MAG_NUMEDA					&& MAGAZZINO FISCALE : NUMERO DA
*!*			AQM_NUMEAL = M.MAG_NUMEAL					&& MAGAZZINO FISCALE : NUMERO A
*!*			AQM_CBFISC = M.MAG_CBFISC					&& MAGAZZINO FISCALE : CODICE A BARRE FISCALE
*!*			AQM_NOTVAR = ""								&& NOTE
*!*			AQM_NUMMOV = ""								&& CARICO SCARICO *?*
*!*			
*!*			*AQM_LEGSYS = SYS(2015)						&& BISOGNA ASSEGNARGLI UN NUOVO LEGSYS PERCHE' SI TRATTA DI UN MOVIMENTO CHE PRESCINDE DAI DOCUMENTI, 
*!*			AQM_LEGSYS = M.MAG_LEGSYS					&& OPPURE TENIAMO IL LEGSYS DELLA GIACENZA ORIGINALE (PUO' SERVIRE IN CASO DI AGGIORNAMENTO PREZZI DA MENU_BFO000) ???

*!*			AQM_CDAFOR = M.MAG_CDAFOR
*!*			AQM_OINFOR = M.MAG_OINFOR
*!*			AQM_PINFOR = M.MAG_PINFOR
*!*			AQM_DTPFOR = M.MAG_DTPFOR
*!*			AQM_TRAFOR = M.MAG_TRAFOR
*!*			AQM_NBAFOR = M.MAG_NBAFOR
*!*			AQM_BDAFOR = M.MAG_BDAFOR
*!*			AQM_BALFOR = M.MAG_BALFOR
*!*			AQM_PNKFOR = M.MAG_PNKFOR
*!*			
*!*			AQM_SERIAL = M.MAG_SERIAL  
*!*			
*!*			AQM_DATORI = IIF(TYPE("PUB_DATORI") <> 'C', "", IIF(!EMPTY(PUB_DATORI), PUB_DATORI, ""))  && ERASMO - 16/02/2015
*!*			
*!*			AQM_FORNSUPP = M.MAG_FORNSUPP  && ERASMO - 22/07/2015
*!*			

*!*		CASE _dADOVE == "AQMLIB_DISTINTA_BASE"

*!*			AQM_DTDOCU = _XDB_DATA
*!*			AQM_NUMDOC = _XDB_NUMDOC
*!*			AQM_CODCLI = _XDB_CODCLI
*!*			AQM_TOP    = _XDB_TOP
*!*			AQM_DTREGI = _XDB_DTREGI
*!*			AQM_VALUTA = ""
*!*			AQM_COORD  = ""

*!*			
*!*			
*!*		
*!*			AQM_CODSOC = PUB_CODSOC
*!*	*SER??
*!*	*!*			AQM_NUMIDE = M.MAG_NUMIDE
*!*	*!*			AQM_LEGAME = M.MAG_LEGAME					&& AGGANCIA U_MAG_GG
*!*			AQM_UNIQUE = SYS(2015)						&& IDENTIFICA UNIVOCAMENTE LA RIGA DI GIACENZA
*!*	*SER??

*!*			AQM_DATAGG = _XDB_DATA						&& DATA 1° CARICO DELLA GIACENZA CHE STO MOVIMENTANDO
*!*			AQM_ORACAR = TIME()							&& ORA 1° CARICO DELLA GIACENZA CHE STO MOVIMENTANDO
*!*			
*!*			AQM_DTDOCU = _XDB_DATA						&& DOV'E' LA DATA DOCUMENTO IN U_MAG_GG ???
*!*			AQM_NUMDOC = _XDB_NUMDOC					&& DOV'E' IL NUMERO DOCUMENTO IN U_MAG_GG ???
*!*			AQM_CODART = M.WCOD  						&& CODICE ARTICOLO+NUMERO IDENTIFICATIVO DEL PRODOTTO PER IL MAGAZZINO	
*!*			AQM_ANAART = M.WCOD  						&& CODICE ARTICOLO E BASTA DI ANAGRAFICA ARTICOLI
*!*			AQM_CODMAG = M.WMAGA						&& CODICE MAGAZZINO
*!*			AQM_UM     = ""								&& NON C'E' UNITA' DI MISURA IN U_MAG_GG - DEVE ESSERE CONSIDERATA U_ART_PR.ART_UMMAGA
*!*			AQM_CODFOR = _XDB_CODFOR					&& CODICE FORNITORE PER CARICHI DEL PRODOTTO FINITO
*!*			AQM_CODCLI = _XDB_CODCLI					&& CODICE CLIENTE PER SCARICHI
*!*			
*!*			AQM_GIACEN = QT_QT							&& QUANTITA' DA SCARICARE PER UNITA' DI MISURA DI MAGAZZINO MEMORIZZATA NELLA VARIABILE M.MAG_GIACEN
*!*			
*!*			*** VALORIZZO LE QTA NELLE VARIE UNITA' DI MISURA
*!*			_X_UMMAGA = AQM_TROVA_UMMAGA(AQM_ANAART)
*!*			DO CASE
*!*				CASE ALLTRIM(_X_UMMAGA) == "KG"
*!*					AQM_QTAKG = AQM_GIACEN
*!*				CASE ALLTRIM(_X_UMMAGA) == "MQ"
*!*					AQM_QTAMQ = AQM_GIACEN
*!*				CASE ALLTRIM(_X_UMMAGA) == "ML"
*!*					AQM_QTAML = AQM_GIACEN
*!*				CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*					AQM_QTAMC = AQM_GIACEN
*!*			ENDCASE
*!*			
*!*			AQM_NUMORF = ""								&& NUMERO ORDINE A FORNITORE
*!*			AQM_DATORF = ""								&& DATA ORDINE A FORNITORE
*!*			
*!*			AQM_PRZCON = M.WCOS							&& PREZZO DI ACQUISTO										
*!*			AQM_FILA_N = 0								&& MAGAZZINO A LOCAZIONI : FILA
*!*			AQM_PIAN_N = 0								&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_N = 0								&& MAGAZZINO A LOCAZIONI : UBICAZIONE
*!*			AQM_FILA_X = "" 							&& MAGAZZINO A LOCAZIONI : FILA	
*!*			AQM_PIAN_X = ""								&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_X = ""								&& MAGAZZINO A LOCAZIONI : UBICAZIONE
*!*			
*!*			AQM_DADOVE = "AQMLIB_DISTINTA_BASE"			&& PROCEDURA DI PROVENIENZA
*!*			AQM_DTREGI = ""								&& DATA REGISTRAZIONE
*!*			AQM_VALUTA = ""								&& VALUTA DI RIFERIMENTO
*!*			IF EMPTY(AQM_VALUTA)
*!*				AQM_VALUTA = PUB_VALRIF
*!*			ENDIF
*!*			AQM_COORD  = ""
*!*			AQM_CODPDV = ""								&& CODICE PUNTO DI VENDITA
*!*			AQM_UM     = ""								&& UNITA' DI MISURA


*!*			AQM_NRLINT  = 0								&& NUMERO LOTTO INTERNO 
*!*	*SER??		
*!*	*!*			AQM_ALTEZZ = M.MAG_ALTEZZ					&& ALTEZZA PRODOTTO
*!*	*!*			AQM_LUNGHE = M.MAG_LUNGHE					&& LUNGHEZZA PRODOTTO
*!*	*!*			AQM_SPESSO = M.MAG_SPESSO					&& SPESSORE PRODOTTO
*!*	*SER??	
*!*			
*!*			X_TIPO = CERCATIPO(AQM_ANAART)
*!*			IF X_TIPO = '1'  && BOBINE
*!*				IF AQM_QTAMQ <= 0
*!*					AQM_QTAMQ = TROVA_MQ_DA_AL(AQM_ALTEZZ,AQM_LUNGHE,1)
*!*				ENDIF
*!*				IF AQM_QTAML <= 0
*!*					AQM_QTAML = TROVA_ML_DA_LU(AQM_LUNGHE,1)
*!*				ENDIF
*!*				IF AQM_QTAKG <= 0
*!*					AQM_QTAKG = TROVA_KG_DA_MQ(AQM_ANAART,AQM_SPESSO,AQM_QTAMQ,1)
*!*				ENDIF
*!*			ENDIF
*!*			
*!*			AQM_NRDBOB = 0								&& NUMERO BOBINA
*!*			AQM_PREACQ = AQM_PRZCON						&& PREZZO DI ACQUISTO 										
*!*			AQM_PREVEN = 0								&& PREZZO DI VENDITA
*!*			AQM_SCONTO = 0								&& SCONTO DI VENDITA
*!*			AQM_SC1    = 0								&& SCONTO DI VENDITA
*!*			AQM_SC2    = 0								&& 2° SCONTO DI VENDITA
*!*			AQM_SC3    = 0								&& 3° SCONTO DI VENDITA

*!*		
*!*			AQM_IVAVEN = ""								&& IVA
*!*			AQM_CODTAG = ""								&& CODICE TAGLIA 
*!*			AQM_DESTAG = ""								&& DESCRIZIONE TAGLIA
*!*			AQM_CODCOL = ""								&& CODICE COLORE
*!*			AQM_DESCOL = ""								&& DESCRIZIONE COLORE		




*!*			AQM_NOTVAR = ""								&& NOTE
*!*			AQM_NUMMOV = ""								&& CARICO SCARICO *?*
*!*			
*!*			AQM_LEGSYS = SYS(2015)						&& BISOGNA ASSEGNARGLI UN NUOVO LEGSYS PERCHE' SI TRATTA DI UN MOVIMENTO CHE PRESCINDE DAI DOCUMENTI, 
*!*	*!*		AQM_LEGSYS = M.MAG_LEGSYS					&& OPPURE TENIAMO IL LEGSYS DELLA GIACENZA ORIGINALE (PUO' SERVIRE IN CASO DI AGGIORNAMENTO PREZZI DA MENU_BFO000) ???



*!*	*!*			AQM_SERIE  = M.MAG_SERIE					&& MAGAZZINO FISCALE : SERIE
*!*	*!*			AQM_AAPROD = M.MAG_AAPROD					&& MAGAZZINO FISCALE : ANNO DI PRODUZIONE
*!*	*!*			AQM_SERBOL = M.MAG_SERBOL					&& MAGAZZINO FISCALE : SERIE BOLLETTA
*!*	*!*			AQM_SERNUM = M.MAG_SERNUM					&& MAGAZZINO FISCALE : NUMERO DI SERIE
*!*	*!*			AQM_NUMEDA = M.MAG_NUMEDA					&& MAGAZZINO FISCALE : NUMERO DA
*!*	*!*			AQM_NUMEAL = M.MAG_NUMEAL					&& MAGAZZINO FISCALE : NUMERO A
*!*	*!*			AQM_CBFISC = M.MAG_CBFISC					&& MAGAZZINO FISCALE : CODICE A BARRE FISCALE
*!*	*!*			AQM_CDAFOR = M.MAG_CDAFOR
*!*	*!*			AQM_OINFOR = M.MAG_OINFOR
*!*	*!*			AQM_PINFOR = M.MAG_PINFOR
*!*	*!*			AQM_DTPFOR = M.MAG_DTPFOR
*!*	*!*			AQM_TRAFOR = M.MAG_TRAFOR
*!*	*!*			AQM_NBAFOR = M.MAG_NBAFOR
*!*	*!*			AQM_BDAFOR = M.MAG_BDAFOR
*!*	*!*			AQM_BALFOR = M.MAG_BALFOR
*!*	*!*			AQM_PNKFOR = M.MAG_PNKFOR
*!*			


*!*		CASE _dADOVE == "MENU_BCL000"					&& SCARICO PER CONTO LAVORO
*!*		
*!*			AQM_CODSOC	= PUB_CODSOC
*!*			AQM_DATAGG  = ""							&& SOLO PER CARICO DI MAGAZZINO								*CARICO*
*!*			AQM_ORACAR	= ""
*!*			AQM_CODART  = M.ORD_CODART
*!*			AQM_ANAART  = M.ORD_CODART
*!*			AQM_CODMAG  = M.ORD_MAGA
*!*			AQM_CODFOR  = ""							&& CODICE FORNITORE PER CARICHI								*CARICO*
*!*			AQM_CODCLI  = M.ORD_CODCLI					&& CODICE CLIENTE PER SCARICHI
*!*			*AQM_GIACEN  = M.ORD_QTAORD					&& QUANTITA' DA SCARICARE PER UNITA' DI MISURA
*!*			
*!*			*** VALORIZZO LA QTA DA SCARICARE IN BASE ALLA UNITA' DI MISURA DI MAGAZZINO (NON NECESSARIAMENTE QUELLA DI VENDITA)
*!*			_X_UMMAGA = AQM_TROVA_UMMAGA(AQM_ANAART)
*!*			IF ALLTRIM(M.ORD_UM) == ALLTRIM(_X_UMMAGA)
*!*				AQM_GIACEN = M.ORD_QTAORD
*!*			ELSE
*!*				DO CASE
*!*					CASE ALLTRIM(_X_UMMAGA) == "KG"
*!*						AQM_GIACEN = M.ORD_QTAKG
*!*						
*!*					CASE ALLTRIM(_X_UMMAGA) == "MQ"
*!*						AQM_GIACEN = M.ORD_QTAMQ
*!*											
*!*					CASE ALLTRIM(_X_UMMAGA) == "ML"
*!*						AQM_GIACEN = M.ORD_QTAML
*!*						
*!*					CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*						AQM_GIACEN = M.ORD_QTAMC
*!*									
*!*					OTHERWISE
*!*						AQM_GIACEN = M.ORD_QTAORD
*!*						
*!*				ENDCASE
*!*			ENDIF
*!*			
*!*			AQM_QTAKG   = M.ORD_QTAKG					&& QUANTITA' DA SCARICARE IN KG
*!*			AQM_QTAMQ   = M.ORD_QTAMQ					&& QUANTITA' DA SCARICARE IN METRI QUADRI
*!*			AQM_QTAML   = M.ORD_QTAML					&& QUANTITA' DA SCARICARE IN METRI LINEARI
*!*			AQM_QTAMC   = M.ORD_QTAMC   

*!*			AQM_PRZCON  = 0								&& PREZZO DI ACQUISTO										*CARICO*
*!*			AQM_FILA_N  = 0								&& MAGAZZINO A LOCAZIONI : FILA
*!*			AQM_PIAN_N  = 0								&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_N  = 0								&& MAGAZZINO A LOCAZIONI : UBICAZIONE
*!*			AQM_FILA_X  = "" 							&& MAGAZZINO A LOCAZIONI : FILA	
*!*			AQM_PIAN_X  = ""							&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_X  = ""							&& MAGAZZINO A LOCAZIONI : UBICAZIONE


*!*			AQM_DADOVE  = "MENU_BCL000"					&& PROCEDURA DI PROVENIENZA
*!*			AQM_TOP 	= M.ORD_CAUS					&& CAUSALE DI CARICO/SCARICO
*!*			AQM_NUMDOC  = M.ORD_NUMORD					&& NUMERO DOCUMENTO
*!*			AQM_DTDOCU  = M.ORD_DATORD					&& DATA DOCUMENTO
*!*			AQM_DTREGI  = RIBALTA2(DTOC(DATE()))		&& DATA REGISTRAZIONE
*!*			AQM_VALUTA  = M.ORD_VALUTA					&& VALUTA DI RIFERIMENTO
*!*			IF EMPTY(AQM_VALUTA)
*!*				AQM_VALUTA = PUB_VALRIF
*!*			ENDIF
*!*			AQM_COORD   = M.ORD_COORD
*!*			AQM_CODPDV  = M.ORD_CODBUN					&& CODICE PUNTO DI VENDITA
*!*			AQM_UM      = M.ORD_UM						&& UNITA' DI MISURA
*!*			AQM_NRLINT  = 0								&& NUMERO LOTTO INTERNO *?*

*!*			AQM_ALTEZZ = M.ORD_ALTEZZ					&& ALTEZZA PRODOTTO
*!*			AQM_LUNGHE = M.ORD_LUNGHE					&& LUNGHEZZA PRODOTTO
*!*			AQM_SPESSO = M.ORD_SPESSO					&& SPESSORE PRODOTTO
*!*			*AQM_NRDBOB = M.ORD_NUMBOB					&& NUMERO BOBINE	
*!*			AQM_NRDBOB = 0								&& NUMERO BOBINA SCARICATA
*!*			AQM_PREACQ = 0								&& PREZZO DI ACQUISTO 										*CARICO*
*!*			AQM_PREVEN = M.ORD_PRZNET					&& PREZZO DI VENDITA
*!*			AQM_SCONTO = M.ORD_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC1    = M.ORD_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC2    = M.ORD_SC2						&& 2° SCONTO DI VENDITA
*!*			AQM_SC3    = M.ORD_SC3						&& 3° SCONTO DI VENDITA
*!*			AQM_SC4    = M.ORD_SC4						&& 4° SCONTO DI VENDITA
*!*			AQM_SC5    = M.ORD_SC5						&& 5° SCONTO DI VENDITA
*!*			AQM_IVAVEN = M.ORD_IVA						&& IVA
*!*			AQM_CODTAG = M.ORD_CODTAG					&& CODICE TAGLIA 
*!*			AQM_DESTAG = M.ORD_DESTAG					&& DESCRIZIONE TAGLIA
*!*			AQM_CODMAT = M.ORD_CODMAT					&& CODICE MATERIALE
*!*			AQM_DESMAT = M.ORD_DESMAT					&& DESCRIZIONE MATERIALE
*!*			AQM_CODCOL = M.ORD_CODCOL					&& CODICE COLORE
*!*			AQM_DESCOL = M.ORD_DESCOL					&& DESCRIZIONE COLORE		
*!*			AQM_SERIE  = M.ORD_SERIE					&& MAGAZZINO FISCALE : SERIE
*!*			AQM_AAPROD = M.ORD_ANNOPR					&& MAGAZZINO FISCALE : ANNO DI PRODUZIONE
*!*			AQM_SERBOL = M.ORD_SERBOL					&& MAGAZZINO FISCALE : SERIE BOLLETTA
*!*			AQM_SERNUM = M.ORD_SERNUM					&& MAGAZZINO FISCALE : NUMERO DI SERIE
*!*			AQM_NUMEDA = M.ORD_NUMEDA					&& MAGAZZINO FISCALE : NUMERO DA
*!*			AQM_NUMEAL = M.ORD_NUMEAL					&& MAGAZZINO FISCALE : NUMERO A
*!*			AQM_CBFISC = M.ORD_CBFISC					&& MAGAZZINO FISCALE : CODICE A BARRE FISCALE
*!*			AQM_NOTVAR = M.ORD_NOTE						&& NOTE
*!*			AQM_NUMMOV = PUB_NUMCSI						&& CARICO SCARICO *?*
*!*			AQM_LEGSYS = M.ORD_SYSMAG					&& SYS DELLA RIGA DDT CHE PERMETTE DI AGGANCIARE LA RIGA ORDINE A FORNITORE ORIGINALE SULLA BFO MENTRE SEVE PER AGGANCIARE LA RIGA DELLA DDT AL MOVIMENTO SE TRATTO UNA DDT DA MENU_BOL000


*!*		CASE _dADOVE == "MENU_BOLRESFOR"					&& SCARICO PER RESO A FORNITORE
*!*		
*!*			AQM_CODSOC	= PUB_CODSOC
*!*			AQM_DATAGG  = ""							&& SOLO PER CARICO DI MAGAZZINO								*CARICO*
*!*			AQM_ORACAR	= ""
*!*			AQM_CODART  = M.ORD_CODART
*!*			AQM_ANAART  = M.ORD_CODART
*!*			AQM_CODMAG  = M.ORD_MAGA
*!*			AQM_CODFOR  = M.ORD_CODCLI
*!*			AQM_CODCLI  = ""
*!*			*AQM_GIACEN  = M.ORD_QTAORD					&& QUANTITA' DA SCARICARE PER UNITA' DI MISURA
*!*			
*!*			*** VALORIZZO LA QTA DA SCARICARE IN BASE ALLA UNITA' DI MISURA DI MAGAZZINO (NON NECESSARIAMENTE QUELLA DI VENDITA)
*!*			_X_UMMAGA = AQM_TROVA_UMMAGA(AQM_ANAART)
*!*			IF ALLTRIM(M.ORD_UM) == ALLTRIM(_X_UMMAGA)
*!*				AQM_GIACEN = M.ORD_QTAORD
*!*			ELSE
*!*				DO CASE
*!*					CASE ALLTRIM(_X_UMMAGA) == "KG"
*!*						AQM_GIACEN = M.ORD_QTAKG
*!*						
*!*					CASE ALLTRIM(_X_UMMAGA) == "MQ"
*!*						AQM_GIACEN = M.ORD_QTAMQ
*!*											
*!*					CASE ALLTRIM(_X_UMMAGA) == "ML"
*!*						AQM_GIACEN = M.ORD_QTAML
*!*						
*!*					CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*						AQM_GIACEN = M.ORD_QTAMC
*!*										
*!*					OTHERWISE
*!*						AQM_GIACEN = M.ORD_QTAORD
*!*						
*!*				ENDCASE
*!*			ENDIF
*!*			
*!*			AQM_QTAKG   = M.ORD_QTAKG					&& QUANTITA' DA SCARICARE IN KG
*!*			AQM_QTAMQ   = M.ORD_QTAMQ					&& QUANTITA' DA SCARICARE IN METRI QUADRI
*!*			AQM_QTAML   = M.ORD_QTAML					&& QUANTITA' DA SCARICARE IN METRI LINEARI
*!*			AQM_QTAMC   = M.ORD_QTAMC   

*!*			AQM_PRZCON  = M.ORD_PREZZO					&& PREZZO DI ACQUISTO										*CARICO*
*!*			AQM_FILA_N  = 0								&& MAGAZZINO A LOCAZIONI : FILA
*!*			AQM_PIAN_N  = 0								&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_N  = 0								&& MAGAZZINO A LOCAZIONI : UBICAZIONE
*!*			AQM_FILA_X  = "" 							&& MAGAZZINO A LOCAZIONI : FILA	
*!*			AQM_PIAN_X  = ""							&& MAGAZZINO A LOCAZIONI : PIANO
*!*			AQM_UBIC_X  = ""							&& MAGAZZINO A LOCAZIONI : UBICAZIONE


*!*			AQM_DADOVE  = "MENU_BOLRESFOR"				&& PROCEDURA DI PROVENIENZA
*!*			AQM_TOP 	= M.ORD_CAUS					&& CAUSALE DI CARICO/SCARICO
*!*			AQM_NUMDOC  = M.ORD_NUMORD					&& NUMERO DOCUMENTO
*!*			AQM_DTDOCU  = M.ORD_DATORD					&& DATA DOCUMENTO
*!*			AQM_DTREGI  = RIBALTA2(DTOC(DATE()))		&& DATA REGISTRAZIONE
*!*			AQM_VALUTA  = M.ORD_VALUTA					&& VALUTA DI RIFERIMENTO
*!*			IF EMPTY(AQM_VALUTA)
*!*				AQM_VALUTA = PUB_VALRIF
*!*			ENDIF
*!*			AQM_COORD   = M.ORD_COORD
*!*			AQM_CODPDV  = M.ORD_CODBUN					&& CODICE PUNTO DI VENDITA
*!*			AQM_UM      = M.ORD_UM						&& UNITA' DI MISURA
*!*			AQM_NRLINT  = 0								&& NUMERO LOTTO INTERNO *?*

*!*			AQM_ALTEZZ = M.ORD_ALTEZZ					&& ALTEZZA PRODOTTO
*!*			AQM_LUNGHE = M.ORD_LUNGHE					&& LUNGHEZZA PRODOTTO
*!*			AQM_SPESSO = M.ORD_SPESSO					&& SPESSORE PRODOTTO
*!*			*AQM_NRDBOB = M.ORD_NUMBOB					&& NUMERO BOBINE	
*!*			AQM_NRDBOB = 0								&& NUMERO BOBINA SCARICATA
*!*			AQM_PREACQ = 0								&& PREZZO DI ACQUISTO 										*CARICO*
*!*			AQM_PREVEN = M.ORD_PRZNET					&& PREZZO DI VENDITA
*!*			AQM_SCONTO = M.ORD_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC1    = M.ORD_SC1						&& SCONTO DI VENDITA
*!*			AQM_SC2    = M.ORD_SC2						&& 2° SCONTO DI VENDITA
*!*			AQM_SC3    = M.ORD_SC3						&& 3° SCONTO DI VENDITA
*!*			AQM_SC4    = M.ORD_SC4						&& 4° SCONTO DI VENDITA
*!*			AQM_SC5    = M.ORD_SC5						&& 5° SCONTO DI VENDITA
*!*			AQM_IVAVEN = M.ORD_IVA						&& IVA
*!*			AQM_CODTAG = M.ORD_CODTAG					&& CODICE TAGLIA 
*!*			AQM_DESTAG = M.ORD_DESTAG					&& DESCRIZIONE TAGLIA
*!*			AQM_CODMAT = M.ORD_CODMAT					&& CODICE MATERIALE
*!*			AQM_DESMAT = M.ORD_DESMAT					&& DESCRIZIONE MATERIALE
*!*			AQM_CODCOL = M.ORD_CODCOL					&& CODICE COLORE
*!*			AQM_DESCOL = M.ORD_DESCOL					&& DESCRIZIONE COLORE		
*!*			AQM_SERIE  = M.ORD_SERIE					&& MAGAZZINO FISCALE : SERIE
*!*			AQM_AAPROD = M.ORD_ANNOPR					&& MAGAZZINO FISCALE : ANNO DI PRODUZIONE
*!*			AQM_SERBOL = M.ORD_SERBOL					&& MAGAZZINO FISCALE : SERIE BOLLETTA
*!*			AQM_SERNUM = M.ORD_SERNUM					&& MAGAZZINO FISCALE : NUMERO DI SERIE
*!*			AQM_NUMEDA = M.ORD_NUMEDA					&& MAGAZZINO FISCALE : NUMERO DA
*!*			AQM_NUMEAL = M.ORD_NUMEAL					&& MAGAZZINO FISCALE : NUMERO A
*!*			AQM_CBFISC = M.ORD_CBFISC					&& MAGAZZINO FISCALE : CODICE A BARRE FISCALE
*!*			AQM_NOTVAR = M.ORD_NOTE						&& NOTE
*!*			AQM_NUMMOV = PUB_NUMCSI						&& CARICO SCARICO *?*
*!*			AQM_LEGSYS = M.ORD_SYSMAG					&& SYS DELLA RIGA DDT CHE PERMETTE DI AGGANCIARE LA RIGA DELLA DDT AL MOVIMENTO
*!*			

*!*	ENDCASE

*!*	SELECT(_OLD_SELECT)

*!*	RETURN(.T.)


*!*	*************************
*!*	FUNCTION AQM_TROVA_UMMAGA
*!*	*************************

*!*	LPARAMETERS _par_anaart

*!*	LOCAL _AQM_SS
*!*	_AQM_SS=SELECT()

*!*	_RIT = ""
*!*	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
*!*	x_codi = "art_codpri = '" + ALLTRIM(_par_anaart) + "'"
*!*	x_cond = x_soci + " and " + x_codi
*!*	Csql   = "select art_ummaga,art_unimis from u_art_pr where " + x_cond
*!*	IF !ExecCommand(cSql,"cur_articoli")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT cur_articoli
*!*	GO TOP
*!*	IF EOF()
*!*		_RIT = ""
*!*	ELSE
*!*		_RIT = ART_UMMAGA
*!*		IF EMPTY(_RIT)
*!*			_RIT = ART_UNIMIS
*!*		ENDIF
*!*	ENDIF

*!*	SELECT(_AQM_SS)

*!*	RETURN _RIT



*!*	******************************
*!*	FUNCTION AQM_SCARICA_MAGAZZINO
*!*	******************************
*!*	LPARAMETERS _par_scarica_impegnato
*!*	IF PCOUNT() = 0
*!*		_par_scarica_impegnato = .F.
*!*	ENDIF

*!*	LOCAL _AQM_SEL
*!*	_AQM_SEL=SELECT()

*!*	_OK_SCARICA_MAGAZZINO = .F.

*!*	AQM_NUMMOV_LOCALE = AQM_RILEVA_NUMERO_INTERNO()

*!*	_x_soci = "mag_codsoc = '" + AQM_CODSOC + "'"
*!*	_x_unqe = "mag_unique = '" + ALLTRIM(AQM_UNIQUE) + "'"
*!*	_x_cond = _x_soci + " and " + _x_unqe
*!*	Csql    = "select * from u_mag_gg where " + _x_cond
*!*	IF !ExecCommand(cSql,"LOCAL_U_MAG_GG")
*!*	   return(.f.)
*!*	ENDIF

*!*	SELECT LOCAL_U_MAG_GG
*!*	GO TOP       
*!*	IF !EOF()
*!*		
*!*		_giac_disp = MAG_GIACEN
*!*		
*!*		=AQM_GESTIONE_VARIABILI_ORIGINALI_LOCALI()
*!*		
*!*		LOCAL_AQM_GIACEN = AQM_GIACEN
*!*		
*!*		IF _giac_disp >= LOCAL_AQM_GIACEN
*!*			
*!*			LOCAL_DATAOGGI   = RIBALTA2(DTOC(DATE()))

*!*			*** ACCESSI ANAGRAFICI
*!*			=ACCESSO_PARAMETRO_TOP()
*!*			=ACCESSO_ANAGRAFICA_FORNITORE()
*!*			=ACCESSO_ANAGRAFICA_CLIENTE()
*!*			=ACCESSO_ANAGRAFICA_ARTICOLI(AQM_ANAART)
*!*			
*!*			*_Y_SCAR = AQM_SCARICA_GIACENZA()  && SCARICA LA GIACENZA DA U_MAG_GG
*!*			_Y_SCAR = AQM_SCARICA_GIACENZA(_par_scarica_impegnato)
*!*			IF _Y_SCAR
*!*				_OK_SCARICA_MAGAZZINO = .T.
*!*			ENDIF
*!*			
*!*		ELSE

*!*			MESSAGEBOX("Giacenza non disponibile",16,"Attenzione")
*!*		
*!*		ENDIF

*!*	ELSE				
*!*		
*!*		MESSAGEBOX("Giacenza non disponibile",16,"Attenzione")

*!*	ENDIF

*!*	SELECT(_AQM_SEL)

*!*	RETURN _OK_SCARICA_MAGAZZINO



*!*	************************************************
*!*	FUNCTION AQM_GESTIONE_VARIABILI_ORIGINALI_LOCALI
*!*	************************************************

*!*	RELEASE ORIGINALE_AQM_DESART			&& DESCRIZIONE ANAGRAFICA ARTICOLI

*!*	RELEASE ORD_SYSMAG_RIGENERATO 
*!*	RELEASE LOCAL_LEGAME
*!*	RELEASE LOCAL_QTA_QTAORD 
*!*	RELEASE LOCAL_QTA_QTAMQ  
*!*	RELEASE LOCAL_QTA_QTAKG  
*!*	RELEASE LOCAL_QTA_QTAML  


*!*	RELEASE LOCAL_MOVIMENTO
*!*	RELEASE LOCAL_AQM_IMPEGNI
*!*	RELEASE LOCAL_AQM_GIACEN
*!*	RELEASE LOCAL_AQM_QTAKG 
*!*	RELEASE LOCAL_AQM_QTAMQ 
*!*	RELEASE LOCAL_AQM_QTAML  
*!*	RELEASE LOCAL_AQM_QTAMC   
*!*	RELEASE LOCAL_DATAOGGI   


*!*	RELEASE LOCAL_NAT    
*!*	RELEASE LOCAL_LIB    
*!*	RELEASE LOCAL_TMOV   
*!*	RELEASE LOCAL_NAT1   
*!*	RELEASE LOCAL_LIB1   
*!*	RELEASE LOCAL_TMOV1  
*!*	RELEASE LOCAL_TOPCAR 



*!*	PUBLIC LOCAL_LEGAME 

*!*	PUBLIC LOCAL_QTA_QTAORD 
*!*	PUBLIC LOCAL_QTA_QTAMQ  
*!*	PUBLIC LOCAL_QTA_QTAKG  
*!*	PUBLIC LOCAL_QTA_QTAML  

*!*	PUBLIC LOCAL_MOVIMENTO
*!*	PUBLIC LOCAL_AQM_IMPEGNI
*!*	PUBLIC LOCAL_AQM_GIACEN 
*!*	PUBLIC LOCAL_AQM_QTAKG  
*!*	PUBLIC LOCAL_AQM_QTAMQ  
*!*	PUBLIC LOCAL_AQM_QTAML  
*!*	PUBLIC LOCAL_AQM_QTAMC   
*!*	PUBLIC LOCAL_DATAOGGI   

*!*	PUBLIC LOCAL_NAT    
*!*	PUBLIC LOCAL_LIB    
*!*	PUBLIC LOCAL_TMOV  
*!*	PUBLIC LOCAL_NAT1   
*!*	PUBLIC LOCAL_LIB1  
*!*	PUBLIC LOCAL_TMOV1  
*!*	PUBLIC LOCAL_TOPCAR 


*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREACQ	&& PREZZO DI COSTO ORIGINALE DA ANAGRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREVEN	&& PREZZO DI RICAVO ORIGINALE DA ANAGRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNIMIS    && UNITA' DI MISURA DI ACQUISTO DA ANAFRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNMAGA    && UNITA' DI MISURA DI VENDITA DA ANAFRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_COORD     && COORDINATE DI MAGAZZINO DA ANAGRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_TIPART    && TIPO DI PRODOTTO DA ANAGRAFICA ARTICOLI


*!*	RELEASE ORIGINALE_AQM_GIACEN 						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	RELEASE ORIGINALE_AQM_QTAKG  						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	RELEASE ORIGINALE_AQM_QTAMQ  						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	RELEASE ORIGINALE_AQM_QTAML  						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	RELEASE ORIGINALE_AQM_QTAMC   
*!*	RELEASE ORIGINALE_AQM_PREACQ  						&& PREZZO    DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	RELEASE ORIGINALE_AQM_SC1      						&& SCONTO-1  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 					
*!*	RELEASE ORIGINALE_AQM_SC2      						&& SCONTO-2  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	RELEASE ORIGINALE_AQM_SC3     						&& SCONTO-3  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	RELEASE ORIGINALE_AQM_SC4      						&& SCONTO-4  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	RELEASE ORIGINALE_AQM_SC5      						&& SCONTO-5  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 

*!*	RELEASE ORIGINALE_AQM_CODFOR   						&& CODICE FORNITORE                    DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	RELEASE ORIGINALE_AQM_DESFOR    					&& RAGIONE SOCIALE FORNITORE           DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	RELEASE ORIGINALE_AQM_NUMIDE    					&& NUMERO IDENTIFICATIVO ORIGINALE     DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	RELEASE ORIGINALE_AQM_LEGAME    					&& SYS DI LEGAME CHE LEGA U_MAG_GG E LE SEGUENZE DEI MOVIMENTI LEGATE A U_MAG_MO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO


*!*	PUBLIC ORIGINALE_AQM_DESART							&& DESCRIZIONE ANAGRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREACQ	    && PREZZO DI COSTO ORIGINALE DA ANAGRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREVEN	    && PREZZO DI RICAVO ORIGINALE DA ANAGRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNIMIS     && UNITA' DI MISURA DI ACQUISTO DA ANAFRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNMAGA     && UNITA' DI MISURA DI VENDITA DA ANAFRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_COORD      && COORDINATE DI MAGAZZINO DA ANAGRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_TIPART     && TIPO DI PRODOTTO DA ANAGRAFICA ARTICOLI

*!*	PUBLIC ORIGINALE_AQM_GIACEN 						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	PUBLIC ORIGINALE_AQM_QTAKG  						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	PUBLIC ORIGINALE_AQM_QTAMQ  						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	PUBLIC ORIGINALE_AQM_QTAML  						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	PUBLIC ORIGINALE_AQM_QTAMC   
*!*	PUBLIC ORIGINALE_AQM_PREACQ  						&& PREZZO    DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	PUBLIC ORIGINALE_AQM_SC1      						&& SCONTO-1  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 					
*!*	PUBLIC ORIGINALE_AQM_SC2      						&& SCONTO-2  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	PUBLIC ORIGINALE_AQM_SC3     						&& SCONTO-3  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	PUBLIC ORIGINALE_AQM_SC4      						&& SCONTO-4  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	PUBLIC ORIGINALE_AQM_SC5      						&& SCONTO-5  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 

*!*	PUBLIC ORIGINALE_AQM_CODFOR   						&& CODICE FORNITORE                    DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	PUBLIC ORIGINALE_AQM_DESFOR    						&& RAGIONE SOCIALE FORNITORE           DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	PUBLIC ORIGINALE_AQM_NUMIDE    						&& NUMERO IDENTIFICATIVO ORIGINALE     DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	PUBLIC ORIGINALE_AQM_LEGAME    						&& SYS DI LEGAME CHE LEGA U_MAG_GG E LE SEGUENZE DEI MOVIMENTI LEGATE A U_MAG_MO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO



*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREACQ    && PREZZO DI COSTO ORIGINALE DA ANAGRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREVEN    && PREZZO DI RICAVO ORIGINALE DA ANAGRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNIMIS    && UNITA' DI MISURA DI ACQUISTO DA ANAFRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNMAGA    && UNITA' DI MISURA DI VENDITA DA ANAFRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_COORD     && COORDINATE DI MAGAZZINO DA ANAGRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_TIPART    && TIPO DI PRODOTTO DA ANAGRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODMAT    && CODICE MATERIALE 
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESMAT 	&& DESCRIZIONE MATERIALE

*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODFOR    && CODICE PRIMO FORNITORE DA ANAGRAFICA ARTICOLI
*!*	RELEASE ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESFOR 	&& DESCRIZIONE PRIMO FORNITORE DA ANAGRAFICA ARTICOLI

*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREACQ     && PREZZO DI COSTO ORIGINALE DA ANAGRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREVEN     && PREZZO DI RICAVO ORIGINALE DA ANAGRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNIMIS     && UNITA' DI MISURA DI ACQUISTO DA ANAFRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNMAGA     && UNITA' DI MISURA DI VENDITA DA ANAFRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_COORD      && COORDINATE DI MAGAZZINO DA ANAGRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_TIPART     && TIPO DI PRODOTTO DA ANAGRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODMAT     && CODICE MATERIALE 
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESMAT 	&& DESCRIZIONE MATERIALE

*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODFOR    && CODICE PRIMO FORNITORE DA ANAGRAFICA ARTICOLI
*!*	PUBLIC ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESFOR 	&& DESCRIZIONE PRIMO FORNITORE DA ANAGRAFICA ARTICOLI

*!*	PUBLIC ORD_SYSMAG_RIGENERATO 

*!*	ORIGINALE_AQM_DESART					 = ""		&& DESCRIZIONE ANAGRAFICA ARTICOLI
*!*	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREACQ = 0	    && PREZZO DI COSTO ORIGINALE DA ANAGRAFICA ARTICOLI
*!*	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREVEN = 0	    && PREZZO DI RICAVO ORIGINALE DA ANAGRAFICA ARTICOLI
*!*	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNIMIS = 0        && UNITA' DI MISURA DI ACQUISTO DA ANAFRAFICA ARTICOLI
*!*	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNMAGA = 0        && UNITA' DI MISURA DI VENDITA DA ANAFRAFICA ARTICOLI
*!*	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_COORD  = ''       && COORDINATE DI MAGAZZINO DA ANAGRAFICA ARTICOLI
*!*	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_TIPART = ''       && TIPO DI PRODOTTO DA ANAGRAFICA ARTICOLI
*!*	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODMAT = ''		&& CODICE MATERIALE 
*!*	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESMAT = ''		&& DESCRIZIONE MATERIALE

*!*	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODFOR = ""		&& CODICE PRIMO FORNITORE DA ANAGRAFICA ARTICOLI
*!*	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESFOR = ""		&& DESCRIZIONE PRIMO FORNITORE DA ANAGRAFICA ARTICOLI



*!*	ORIGINALE_AQM_GIACEN = 0						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	ORIGINALE_AQM_QTAKG  = 0						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	ORIGINALE_AQM_QTAMQ  = 0						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	ORIGINALE_AQM_QTAML  = 0						&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	ORIGINALE_AQM_QTAMC  = 0   
*!*	ORIGINALE_AQM_PREACQ = 0 						&& PREZZO    DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	ORIGINALE_AQM_SC1    = 0   						&& SCONTO-1  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 					
*!*	ORIGINALE_AQM_SC2    = 0   						&& SCONTO-2  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	ORIGINALE_AQM_SC3    = 0   						&& SCONTO-3  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	ORIGINALE_AQM_SC4    = 0   						&& SCONTO-4  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	ORIGINALE_AQM_SC5    = 0   						&& SCONTO-5  DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 

*!*	ORIGINALE_AQM_CODFOR = ''   					&& CODICE FORNITORE                    DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	ORIGINALE_AQM_DESFOR = ''   					&& RAGIONE SOCIALE FORNITORE           DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	ORIGINALE_AQM_NUMIDE = ''   					&& NUMERO IDENTIFICATIVO ORIGINALE     DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	ORIGINALE_AQM_LEGAME = ''   					&& SYS DI LEGAME CHE LEGA U_MAG_GG E LE SEGUENZE DEI MOVIMENTI LEGATE A U_MAG_MO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO


*!*	LOCAL_MOVIMENTO   = "NON-CREA-MOVIMENTO"
*!*	LOCAL_AQM_IMPEGNI = ""
*!*	LOCAL_AQM_GIACEN = 0
*!*	LOCAL_AQM_QTAKG  = 0
*!*	LOCAL_AQM_QTAMQ  = 0
*!*	LOCAL_AQM_QTAML  = 0
*!*	LOCAL_AQM_QTAMC  = 0   
*!*	LOCAL_DATAOGGI   = ''

*!*	LOCAL_NAT    = ""
*!*	LOCAL_LIB    = ""
*!*	LOCAL_TMOV   = ""
*!*	LOCAL_NAT1   = ""
*!*	LOCAL_LIB1   = ""
*!*	LOCAL_TMOV1  = ""
*!*	LOCAL_TOPCAR = ""


*!*	*!*	LOCAL_QTA_QTAORD = 0
*!*	*!*	LOCAL_QTA_QTAMQ  = 0 
*!*	*!*	LOCAL_QTA_QTAKG  = 0 
*!*	*!*	LOCAL_QTA_QTAML  = 0 

*!*	LOCAL_LEGAME = ""
*!*	ORD_SYSMAG_RIGENERATO = ""


*!*	RETURN(.T.)


*!*	******************************
*!*	FUNCTION ACCESSO_PARAMETRO_TOP
*!*	******************************


*!*	LOCAL_NAT    = ""
*!*	LOCAL_LIB    = ""
*!*	LOCAL_TMOV   = ""
*!*	LOCAL_NAT1   = ""
*!*	LOCAL_LIB1   = ""
*!*	LOCAL_TMOV1  = ""
*!*	LOCAL_TOPCAR = ""

*!*	LOCAL_CSC = ""   

*!*	v_seek   = 'TOP'+AQM_TOP
*!*	v_chiave = "codice"
*!*	IF seek_std('para',v_seek,v_chiave,'LOCAL_PARA')
*!*	   	SELECT LOCAL_PARA
*!*	   	LOCAL_NAT    = SUBSTR(LIBERA,1,1)   && (NATURA C=CARICO - S=SCARICO - D=DARE - A=AVERE)
*!*	   	LOCAL_LIB    = SUBSTR(LIBERA,12,1)  && (C=CLIENTE - F=FORNITORE - +/-=COMP.D.B. - A=ALTRO)
*!*	   	LOCAL_TMOV   = SUBSTR(LIBERA,33,2)				
*!*	   	LOCAL_CSC    = SUBSTR(LIBERA,25,1)   

*!*		** SERGIO 19/11/2021 INIZIO 
*!*	   	*LOCAL_TOPCAR = SUBSTR(LIBERA,35,3)  && CAUSALE CONTRARIA A QUELLA DIGITATA
*!*		LOCAL_TOPCAR = CERCA_CAUSALI_TOP(AQM_TOP,'CONCAU')	&& CAUSALE CONTRARIA A QUELLA DIGITATA
*!*		** SERGIO 19/11/2021 FINE  
*!*	   
*!*	ELSE
*!*	   RETURN(.t.)
*!*	ENDIF

*!*	AQM_TIPMOV = LOCAL_TMOV

*!*	IF  LOCAL_NAT = 'C' .OR.  LOCAL_NAT = 'S'
*!*	ELSE
*!*	   RETURN(.t.)
*!*	ENDIF


*!*	IF LOCAL_NAT = 'C'									
*!*	   AQM_SEGNO   = "+"							
*!*	ELSE
*!*	   AQM_SEGNO   = "-"								
*!*	ENDIF												

*!*	IF EMPTY(ALLTRIM(LOCAL_TOPCAR))
*!*	   IF AQM_SEGNO   = '+'
*!*	      LOCAL_TOPCAR = '200'
*!*	   ELSE
*!*	      LOCAL_TOPCAR = '100'
*!*	   ENDIF
*!*	ENDIF   


*!*	RETURN(.T.)


*!*	*************************************
*!*	FUNCTION ACCESSO_ANAGRAFICA_FORNITORE
*!*	*************************************

*!*	AQM_DESFOR = ""
*!*	IF !EMPTY(AQM_CODFOR) 
*!*		x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
*!*		x_codi = "for_codcli = '" + ALLTRIM(AQM_CODFOR) + "'"
*!*		x_cond = x_soci + " and " + x_codi
*!*		Csql   = "select FOR_CODCLI,FOR_RAGSOC from u_for_an where " + x_cond
*!*		IF !ExecCommand(cSql,"u_for_an")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT u_for_an
*!*		GO TOP
*!*		IF !EOF()
*!*		   AQM_DESFOR = for_ragsoc
*!*		ELSE 
*!*		   AQM_DESFOR = ""
*!*		ENDIF
*!*	ENDIF 


*!*	RETURN(.T.)


*!*	***********************************
*!*	FUNCTION ACCESSO_ANAGRAFICA_CLIENTE
*!*	***********************************

*!*	AQM_DESCLI = ""
*!*	IF !EMPTY(AQM_CODCLI) 
*!*		x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
*!*		x_codi = "cli_codcli = '" + ALLTRIM(AQM_CODCLI) + "'"
*!*		x_cond = x_soci + " and " + x_codi
*!*		Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
*!*		IF !ExecCommand(cSql,"u_cli_an")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT u_cli_an
*!*		GO TOP
*!*		IF !EOF()
*!*		   AQM_DESCLI = cli_ragsoc
*!*		ELSE 
*!*		   AQM_DESCLI = ""
*!*		ENDIF
*!*	ENDIF 



*!*	RETURN(.T.)


*!*	************************************
*!*	FUNCTION ACCESSO_ANAGRAFICA_ARTICOLI
*!*	************************************

*!*	LPARAMETERS _par_anaart

*!*	x_soci = "art_codsoc = '" + PUB_CODSOC + "'"
*!*	x_codi = "art_codpri = '" + ALLTRIM(_par_anaart) + "'"
*!*	x_cond = x_soci + " and " + x_codi
*!*	Csql   = "select * from u_art_pr where " + x_cond + " order by art_codsoc,art_codpri"
*!*	IF !ExecCommand(Csql,"u_art_pr")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT U_ART_PR
*!*	GO TOP
*!*	IF EOF()
*!*	   	AQM_DESART = ""
*!*	   	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREACQ = 0 
*!*	   	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREVEN = 0
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNIMIS = ''
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNMAGA = ''  
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_COORD  = ''
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_TIPART = ''
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODMAT = ''
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESMAT = ''	
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODIMB = ''
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESIMB = ''

*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODFOR = ""
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESFOR = ""
*!*	ELSE 

*!*	   	AQM_DESART = ART_DESCR
*!*	   	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREACQ = ART_PRZCOS 
*!*	   	ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREVEN = ART_PRZVEN
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNIMIS = ART_UNIMIS
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNMAGA = ART_UMMAGA 
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_COORD  = ART_COORD 
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_TIPART = ART_TIPART
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODMAT = ART_CODMAT
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESMAT = ART_DESMAT
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODIMB = ART_CODIMB
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESIMB = ART_DESIMB
*!*		
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODFOR = ART_CODF1
*!*		ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESFOR = ""
*!*	ENDIF

*!*	IF !EMPTY(ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODFOR) 
*!*		x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
*!*		x_codi = "for_codcli = '" + ALLTRIM(ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODFOR) + "'"
*!*		x_cond = x_soci + " and " + x_codi
*!*		Csql   = "select FOR_CODCLI,FOR_RAGSOC from u_for_an where " + x_cond
*!*		IF !ExecCommand(cSql,"CX_for_an")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT CX_for_an
*!*		GO TOP
*!*		IF !EOF()
*!*		   ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESFOR = for_ragsoc
*!*		ELSE 
*!*		   ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESFOR = ""
*!*		ENDIF
*!*	ENDIF 

*!*	RETURN(.T.)



*!*	*****************************
*!*	FUNCTION AQM_SCARICA_GIACENZA
*!*	*****************************

*!*	LPARAMETERS _par_scarica_impegnato,_par_docmod

*!*	IF PCOUNT() = 0
*!*		_par_scarica_impegnato = .F.
*!*	ENDIF

*!*	IF PCOUNT() >= 2
*!*	ELSE
*!*		_par_docmod = .F.
*!*	ENDIF

*!*	_OK_SCARICA_GIACENZA = .F.

*!*	SELECT LOCAL_U_MAG_GG
*!*	GO TOP  

*!*	DO WHILE .NOT. EOF()

*!*	    SELECT LOCAL_U_MAG_GG
*!*	    ___ID_UNIQUE  = ID_UNIQUE 
*!*	    
*!*	    IF LOCAL_AQM_GIACEN > 0						&& luppa sino a che non ha TOLTO TUTTA LA QTA MOVIMENTATA di record di u_mag_gg
*!*	    ELSE 
*!*	      EXIT
*!*	    ENDIF    
*!*	    
*!*	    
*!*		_e_cond = "id_unique = '" + ___ID_UNIQUE + "'"	
*!*		Csql    = "select * from u_mag_gg where " + _e_cond + " order by mag_codart"
*!*		IF !ExecRW(Csql,"u_mag_gg","R")
*!*			   return(.f.)
*!*		ENDIF
*!*			
*!*	    SELECT U_MAG_GG
*!*	    IF !EOF()
*!*	    	*MESSAGEBOX("STO PER AGGIORNARE U_MAG_GG")
*!*	    	*SET STEP ON
*!*	    	SELECT U_MAG_GG
*!*	    	
*!*	     	*___DISPONIBILE 	= MAG_GIACEN - MAG_QTAIMP
*!*	 		IF _par_scarica_impegnato
*!*				___DISPONIBILE 	= MAG_GIACEN
*!*			ELSE
*!*				___DISPONIBILE 	= MAG_GIACEN - MAG_QTAIMP
*!*			ENDIF
*!*	         
*!*			*AQM_QTAKG  = MAG_QTAKG
*!*			*AQM_QTAMQ  = MAG_QTAMQ
*!*			*AQM_QTAML  = MAG_QTAML
*!*			*AQM_NRDBOB = MAG_NRDBOB
*!*			
*!*			AQM_CDAFOR = MAG_CDAFOR
*!*			AQM_OINFOR = MAG_OINFOR
*!*			AQM_PINFOR = MAG_PINFOR
*!*			AQM_DTPFOR = MAG_DTPFOR
*!*			AQM_TRAFOR = MAG_TRAFOR
*!*			AQM_NBAFOR = MAG_NBAFOR
*!*			AQM_BDAFOR = MAG_BDAFOR
*!*			AQM_BALFOR = MAG_BALFOR
*!*			AQM_PNKFOR = MAG_PNKFOR
*!*	    
*!*		    *IF ___DISPONIBILE => LOCAL_AQM_GIACEN 
*!*		    *IF ___DISPONIBILE > LOCAL_AQM_GIACEN 
*!*		    IF ___DISPONIBILE >= LOCAL_AQM_GIACEN  
*!*		      
*!*		      SELECT U_MAG_GG
*!*		      REPLACE MAG_GIACEN WITH MAG_GIACEN - LOCAL_AQM_GIACEN 
*!*		      
*!*	 
*!*		      IF _par_scarica_impegnato
*!*		      	SELECT U_MAG_GG
*!*		      	REPLACE MAG_QTAIMP WITH MAG_QTAIMP - LOCAL_AQM_GIACEN 
*!*		      	IF MAG_QTAIMP < 0
*!*		      		SELECT U_MAG_GG
*!*		      		REPLACE MAG_QTAIMP WITH 0
*!*		      	ENDIF
*!*		      ENDIF
*!*	 

*!*		      *REPLACE MAG_QTAKG  WITH MAG_QTAKG  - LOCAL_AQM_QTAKG
*!*		      *REPLACE MAG_QTAMQ  WITH MAG_QTAMQ  - LOCAL_AQM_QTAMQ
*!*		      *REPLACE MAG_QTAML  WITH MAG_QTAML  - LOCAL_AQM_QTAML
*!*		      
*!*				*** RESETTO E VALORIZZO LE QTA NELLE VARIE UNITA' DI MISURA SULLA RIGA DI GIACENZA
*!*				SELECT U_MAG_GG
*!*				REPLACE MAG_QTAMQ WITH 0
*!*				REPLACE MAG_QTAML WITH 0
*!*				REPLACE MAG_QTAKG WITH 0
*!*				REPLACE MAG_QTAMC WITH 0   
*!*				
*!*				_X_UMMAGA = AQM_TROVA_UMMAGA(AQM_ANAART)
*!*				DO CASE
*!*					CASE ALLTRIM(_X_UMMAGA) == "KG"
*!*						SELECT U_MAG_GG
*!*						REPLACE MAG_QTAKG WITH MAG_GIACEN
*!*					CASE ALLTRIM(_X_UMMAGA) == "MQ"
*!*						SELECT U_MAG_GG
*!*						REPLACE MAG_QTAMQ WITH MAG_GIACEN
*!*					CASE ALLTRIM(_X_UMMAGA) == "ML"
*!*						SELECT U_MAG_GG
*!*						REPLACE MAG_QTAML WITH MAG_GIACEN
*!*					CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*						SELECT U_MAG_GG
*!*						REPLACE MAG_QTAMC WITH MAG_GIACEN
*!*					
*!*				ENDCASE
*!*				
*!*				X_TIPO = CERCATIPO(MAG_ANAART)
*!*				IF X_TIPO = '1'  && BOBINE
*!*					SELECT U_MAG_GG
*!*					REPLACE MAG_LUNGHE WITH AQM_LUNGHE   
*!*					
*!*					IF MAG_QTAMQ <= 0
*!*						SELECT U_MAG_GG
*!*						REPLACE MAG_QTAMQ WITH TROVA_MQ_DA_AL(MAG_ALTEZZ,MAG_LUNGHE,1)
*!*					ENDIF
*!*					IF MAG_QTAML <= 0
*!*						SELECT U_MAG_GG
*!*						REPLACE MAG_QTAML WITH TROVA_ML_DA_LU(MAG_LUNGHE,1)
*!*					ENDIF
*!*					IF MAG_QTAKG <= 0
*!*						SELECT U_MAG_GG
*!*						REPLACE MAG_QTAKG WITH TROVA_KG_DA_MQ(MAG_ANAART,MAG_SPESSO,MAG_QTAMQ,1)
*!*					ENDIF
*!*				ENDIF
*!*				
*!*				IF X_TIPO = '3'  && MANICOTTI
*!*					IF ALLTRIM(_X_UMMAGA) == "NR"
*!*						SELECT U_MAG_GG
*!*						REPLACE MAG_QTAML WITH MAG_GIACEN * MAG_ALTEZZ / 1000
*!*					ENDIF
*!*				ENDIF
*!*				
*!*				IF X_TIPO = '6'  && PANNELLI TRUCIOLARI
*!*					X_QTANR = 0
*!*					DO CASE
*!*						CASE ALLTRIM(_X_UMMAGA) == "MQ"
*!*							SELECT U_MAG_GG
*!*							X_QTANR = TROVA_NR_DA_MQ_LEGNO(MAG_ALTEZZ,MAG_LUNGHE,MAG_GIACEN)
*!*						CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*							SELECT U_MAG_GG
*!*							X_QTANR = TROVA_NR_DA_MC_LEGNO(MAG_ALTEZZ,MAG_LUNGHE,MAG_GIACEN,MAG_SPESSO)
*!*					ENDCASE
*!*					SELECT U_MAG_GG
*!*					REPLACE MAG_QTAMQ WITH TROVA_MQ_DA_AL_LEGNO(MAG_ALTEZZ,MAG_LUNGHE,X_QTANR)
*!*					REPLACE MAG_QTAML WITH TROVA_ML_DA_LU(MAG_LUNGHE,X_QTANR)
*!*					REPLACE MAG_QTAKG WITH 0
*!*					REPLACE MAG_QTAMC WITH TROVA_MC_DA_AL_LEGNO(MAG_ALTEZZ,MAG_LUNGHE,X_QTANR,MAG_SPESSO) 
*!*				ENDIF
*!*				
*!*				IF X_TIPO = '8'  && CARTE IMPREGNATE
*!*					IF ALLTRIM(_X_UMMAGA) == "NR"
*!*						SELECT U_MAG_GG
*!*						REPLACE MAG_QTAMQ WITH TROVA_MQ_DA_AL(MAG_ALTEZZ,MAG_LUNGHE,MAG_GIACEN)
*!*					ENDIF
*!*				ENDIF
*!*				
*!*				IF X_TIPO = '9'  && DADI PRESSATI
*!*					X_QTANR = 0
*!*					DO CASE
*!*						CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*							SELECT U_MAG_GG
*!*							X_QTANR = TROVA_NR_DA_MC_LEGNO(MAG_ALTEZZ,MAG_LUNGHE,MAG_GIACEN,MAG_SPESSO)
*!*					ENDCASE
*!*					SELECT U_MAG_GG
*!*					REPLACE MAG_QTAMQ WITH 0
*!*					REPLACE MAG_QTAML WITH 0
*!*					REPLACE MAG_QTAKG WITH 0
*!*					REPLACE MAG_QTAMC WITH TROVA_MC_DA_AL_LEGNO(MAG_ALTEZZ,MAG_LUNGHE,X_QTANR,MAG_SPESSO,6) 
*!*				ENDIF
*!*				
*!*				*** SE LA GIACENZA RIMANENTE NON E' SIGNIFICATIVA (SOLO PER ALCUNE TIPOLOGIE DI PRODOTTO) ALLORA LA AZZERO
*!*				_nLimiteGiacenzaSignific = 0
*!*				IF X_TIPO = '1' OR X_TIPO = '6'
*!*					*_nLimiteGiacenzaSignific = 0.009
*!*					_nLimiteGiacenzaSignific = 0.09  && AUMENTATA TOLLERANZA PER GIACENZA SUFFICIENTE
*!*				ENDIF
*!*				IF X_TIPO = '9'
*!*					_nLimiteGiacenzaSignific = 0.0009
*!*				ENDIF
*!*				IF _nLimiteGiacenzaSignific > 0
*!*					SELECT U_MAG_GG
*!*					IF MAG_GIACEN > _nLimiteGiacenzaSignific
*!*					ELSE
*!*						SELECT U_MAG_GG
*!*						REPLACE MAG_GIACEN WITH 0
*!*						REPLACE MAG_QTAIMP WITH 0
*!*						REPLACE MAG_QTAMQ WITH 0
*!*						REPLACE MAG_QTAML WITH 0
*!*						REPLACE MAG_QTAKG WITH 0
*!*						REPLACE MAG_QTAMC WITH 0
*!*					ENDIF
*!*				ENDIF
*!*				
*!*		      *!*	_________________________________________________________________________________________________SALVATAGGIO VARIABILI ORIGINALI AL MOMENTO DEL CARICO 
*!*		      
*!*	    
*!*		      ORIGINALE_AQM_GIACEN   = LOCAL_AQM_GIACEN 
*!*		      ORIGINALE_AQM_QTAKG    = LOCAL_AQM_QTAKG  
*!*		      ORIGINALE_AQM_QTAMQ    = LOCAL_AQM_QTAMQ
*!*		      ORIGINALE_AQM_QTAML    = LOCAL_AQM_QTAML 
*!*		      ORIGINALE_AQM_QTAMC    = LOCAL_AQM_QTAMC   
*!*					
*!*		      *!*	_________________________________________________________________________________________________SALVATAGGIO VARIABILI ORIGINALI AL MOMENTO DEL CARICO 
*!*		      
*!*		      LOCAL_AQM_GIACEN = 0
*!*			  LOCAL_AQM_QTAKG  = 0
*!*			  LOCAL_AQM_QTAMQ  = 0
*!*			  LOCAL_AQM_QTAML  = 0
*!*			  LOCAL_AQM_QTAMC  = 0   
*!*			  
*!*		    ELSE
*!*			  
*!*		      *!*	_________________________________________________________________________________________________SALVATAGGIO VARIABILI ORIGINALI AL MOMENTO DEL CARICO 
*!*		      SELECT U_MAG_GG
*!*		      ORIGINALE_AQM_GIACEN   = MAG_GIACEN
*!*		      ORIGINALE_AQM_QTAKG    = MAG_QTAKG
*!*		      ORIGINALE_AQM_QTAMQ    = MAG_QTAMQ
*!*		      ORIGINALE_AQM_QTAML    = MAG_QTAML
*!*		      ORIGINALE_AQM_QTAMC    = MAG_QTAMC   
*!*		      *!*	_________________________________________________________________________________________________SALVATAGGIO VARIABILI ORIGINALI AL MOMENTO DEL CARICO 
*!*			  
*!*		      *LOCAL_AQM_GIACEN = LOCAL_AQM_GIACEN - MAG_GIACEN
*!*		      SELECT U_MAG_GG
*!*		      LOCAL_AQM_GIACEN = LOCAL_AQM_GIACEN - ___DISPONIBILE 
*!*			  LOCAL_AQM_QTAKG  = LOCAL_AQM_QTAKG  - MAG_QTAKG
*!*			  LOCAL_AQM_QTAMQ  = LOCAL_AQM_QTAMQ  - MAG_QTAMQ
*!*			  LOCAL_AQM_QTAML  = LOCAL_AQM_QTAML  - MAG_QTAML
*!*			  LOCAL_AQM_QTAMC  = LOCAL_AQM_QTAMC  - MAG_QTAMC   
*!*			  
*!*			  SELECT U_MAG_GG
*!*		      REPLACE MAG_GIACEN WITH 0
*!*		      REPLACE MAG_QTAIMP WITH 0   
*!*		      REPLACE MAG_QTAKG  WITH 0
*!*		      REPLACE MAG_QTAMQ  WITH 0
*!*		      REPLACE MAG_QTAML  WITH 0
*!*		      REPLACE MAG_QTAMC  WITH 0   
*!*		    ENDIF


*!*			*!*	____________________________________________________________________________________________________LEGGE IL NUMERO ORDINE A FORNITORE SE ESISTE 

*!*	        *=AQM_CARICA_NUMERO_ORDINE_FORNITORE(MAG_CODMAG,MAG_LEGSYS)

*!*	        SELECT U_MAG_GG

*!*			*!*	___________________________________________________________________________________________________SALVATAGGIO VARIABILI ORIGINALI AL MOMENTO DEL CARICO 

*!*		    ORIGINALE_AQM_PREACQ = MAG_PRZCON	&& PREZZO                              DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 					
*!*		    ORIGINALE_AQM_SC1    = MAG_SC1   	&& SCONTO-1                            DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 					
*!*		    ORIGINALE_AQM_SC2    = MAG_SC2   	&& SCONTO-2                            DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*		    ORIGINALE_AQM_SC3    = MAG_SC3   	&& SCONTO-3                            DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*		    ORIGINALE_AQM_SC4    = MAG_SC4   	&& SCONTO-4                            DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*		    ORIGINALE_AQM_SC5    = MAG_SC5   	&& SCONTO-5                            DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	        ORIGINALE_AQM_CODFOR = MAG_FORNIT   && CODICE FORNITORE                    DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*			ORIGINALE_AQM_DESFOR = MAG_DESFOR   && RAGIONE SOCIALE FORNITORE           DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO
*!*		    ORIGINALE_AQM_NUMIDE = MAG_NUMIDE   && NUMERO IDENTIFICATIVO ORIGINALE     DI ACQUISTO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO 
*!*	        ORIGINALE_AQM_LEGAME = MAG_LEGAME   && SYS DI LEGAME CHE LEGA U_MAG_GG E LE SEQUENZE DEI MOVIMENTI LEGATE A U_MAG_MO ORIGINALE DEL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	 
*!*			*!*	_________________________________________________________________________________________________SALVATAGGIO VARIABILI ORIGINALI AL MOMENTO DEL CARICO 



*!*		    *** VISTO CHE STO SCARICANDO, NON C'E' MOTIVO DI INSERIRE LE LOCAZIONI
*!*	*!*		    REPLACE MAG_FILA_X WITH aqm_fila_x 
*!*	*!*		    REPLACE MAG_PIAN_X WITH aqm_pian_x 
*!*	*!*		    REPLACE MAG_UBIC_X WITH aqm_ubic_x 
*!*	*!*		    REPLACE MAG_FILA_N WITH aqm_fila_n
*!*	*!*		    REPLACE MAG_PIAN_N WITH aqm_pian_n 
*!*	*!*		    REPLACE MAG_UBIC_N WITH aqm_ubic_n 

*!*			SELECT U_MAG_GG
*!*			IF MAG_GIACEN > 0									&& NON SONO GESTITE GIACENZE NEGATIVE
*!*			ELSE
*!*			   SELECT U_MAG_GG
*!*			   REPLACE MAG_GIACEN WITH 0
*!*			   REPLACE MAG_QTAMQ  WITH 0
*!*			   REPLACE MAG_QTAKG  WITH 0
*!*			   REPLACE MAG_QTAML  WITH 0
*!*			   REPLACE MAG_QTAMC  WITH 0   
*!*			   REPLACE MAG_QTAIMP WITH 0
*!*			   REPLACE MAG_GKGIMP WITH 0
*!*			   REPLACE MAG_GMLIMP WITH 0
*!*			ENDIF
*!*			
*!*			**=> ERASMO - INIZIO 21/02/2014
*!*			*** MOLTI DEI DATI DA SCRIVERE SUL MOVIMENTO DA CREARE DEVONO PROVENIRE 
*!*			*** DALLA GIACENZA CHE STO SCARICANDO, QUINDI REINIZIALIZZO ALCUNE VARIABILI
*!*			*** PRIMA CHE TALE RIGA DI GIACENZA POSSA ESSERE EVENTUALMENTE ELIMINATA (SE A ZERO)
*!*			SELECT U_MAG_GG
*!*			AQM_DATAGG = MAG_DATAGG
*!*			AQM_CODART = MAG_CODART
*!*			AQM_CODMAG = MAG_CODMAG
*!*			AQM_FILA_N = MAG_FILA_N
*!*			AQM_PIAN_N = MAG_PIAN_N
*!*			AQM_UBIC_N = MAG_UBIC_N
*!*			AQM_FILA_X = MAG_FILA_X
*!*			AQM_PIAN_X = MAG_PIAN_X
*!*			AQM_UBIC_X = MAG_UBIC_X
*!*			AQM_NRLINT = MAG_NRLINT
*!*			AQM_ALTEZZ = MAG_ALTEZZ
*!*			AQM_LUNGHE = MAG_LUNGHE
*!*			AQM_SPESSO = MAG_SPESSO
*!*			AQM_PREACQ = MAG_PRZCON
*!*			AQM_AAPROD = MAG_AAPROD
*!*			AQM_SERBOL = MAG_SERBOL
*!*			AQM_SERNUM = MAG_SERNUM
*!*			AQM_NUMEDA = MAG_NUMEDA
*!*			AQM_NUMEAL = MAG_NUMEAL
*!*			AQM_CBFISC = MAG_CBFISC
*!*			AQM_ORACAR = MAG_ORACAR
*!*	        
*!*			AQM_UNIQUE = MAG_UNIQUE
*!*			
*!*			AQM_SERIAL = MAG_SERIAL
*!*			**=> ERASMO - FINE 21/02/2014
*!*			
*!*			**=> ERASMO - INIZIO 17/02/2016
*!*			*** DETERMINO LA VALUTA DAL PRIMO MOVIMENTO DI CARICO LEGATO A QUESTA GIACENZA
*!*			SELECT U_MAG_GG
*!*			x_lega = "MOV_LEGAME = '" + MAG_LEGAME + "'"
*!*			x_segn = "MOV_SEGNO = '+'"
*!*			x_cond = x_lega + " and " + x_segn
*!*			cSql = "SELECT TOP 1 MOV_VALUTA FROM U_MAG_MO WHERE " + x_cond + " ORDER BY MOV_DTREGI, MOV_ORAMOV"
*!*			IF !ExecCommand(Csql,"TMP_MAG_MO")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT TMP_MAG_MO
*!*			IF !EOF()
*!*				AQM_VALUTA = MOV_VALUTA
*!*			ENDIF
*!*			SELECT U_MAG_GG
*!*			**=> ERASMO - FINE 17/02/2016
*!*			
*!*			IF EMPTY(ALLTRIM(PUB_MAGNO0))
*!*			ELSE
*!*			   SELECT U_MAG_GG
*!*			   IF MAG_GIACEN = 0								&& CANCELLA IL RECORD SU U_MAG_GG SE E' = 0 ED E' PREVISTO NEI PARAMETRI AZIENDALI 
*!*			      IF ALLTRIM(MAG_CODMAG) $ PUB_MAGNO0
*!*			      ELSE
*!*			         DELETE
*!*			      ENDIF
*!*			   ENDIF
*!*			ENDIF
*!*		
*!*			

*!*	*!*			*** MOLTI DEI DATI DA SCRIVERE SUL MOVIMENTO DA CREARE DEVONO PROVENIRE 
*!*	*!*			*** DALLA GIACENZA CHE STO SCARICANDO, QUINDI REINIZIALIZZO ALCUNE VARIABILI
*!*	*!*			AQM_DATAGG = MAG_DATAGG
*!*	*!*			AQM_CODART = MAG_CODART
*!*	*!*			AQM_CODMAG = MAG_CODMAG
*!*	*!*			AQM_FILA_N = MAG_FILA_N
*!*	*!*			AQM_PIAN_N = MAG_PIAN_N
*!*	*!*			AQM_UBIC_N = MAG_UBIC_N
*!*	*!*			AQM_FILA_X = MAG_FILA_X
*!*	*!*			AQM_PIAN_X = MAG_PIAN_X
*!*	*!*			AQM_UBIC_X = MAG_UBIC_X
*!*	*!*			AQM_NRLINT = MAG_NRLINT
*!*	*!*			AQM_ALTEZZ = MAG_ALTEZZ
*!*	*!*			AQM_LUNGHE = MAG_LUNGHE
*!*	*!*			AQM_SPESSO = MAG_SPESSO
*!*	*!*			AQM_PREACQ = MAG_PRZCON
*!*	*!*			AQM_AAPROD = MAG_AAPROD
*!*	*!*			AQM_SERBOL = MAG_SERBOL
*!*	*!*			AQM_SERNUM = MAG_SERNUM
*!*	*!*			AQM_NUMEDA = MAG_NUMEDA
*!*	*!*			AQM_NUMEAL = MAG_NUMEAL
*!*	*!*			AQM_CBFISC = MAG_CBFISC
*!*	*!*			AQM_ORACAR = MAG_ORACAR
*!*	*!*	        
*!*	*!*			AQM_UNIQUE = MAG_UNIQUE   
*!*			
*!*			

*!*	        *!*	____________________________________________________________________________________________________________________ AGGIORNA U_MAG_GG
*!*			IF !ExecRW(cSql,"U_MAG_GG","W")						 
*!*			   return(.f.)
*!*			ENDIF

*!*	        *!*	____________________________________________________________________________________________________________________ AGGIORNA U_MAG_MO
*!*			LOCAL_MOVIMENTO = "CREA-MOVIMENTO"
*!*			*=AQM_CREA_U_MAG_MO(LOCAL_MOVIMENTO)
*!*			=AQM_CREA_U_MAG_MO(LOCAL_MOVIMENTO,_par_docmod)  

*!*		ENDIF    
*!*	   

*!*		SELECT LOCAL_U_MAG_GG
*!*		SKIP +1

*!*	ENDDO WHILE .NOT. EOF()


*!*	*** AGGIORNAMENTO LOGICA DI FUNZIONAMENTO SCARICO GIACENZA: SE PUB_CTRGIA = .T. NON POSSO MAI SCARICARE PIU' DELLA GIACENZA DISPONIBILE; 
*!*	*** SE LOCAL_AQM_GIACEN > 0, SIGNIFICA CHE QUALCOSA NON HA FUNZIONATO NEL CONTROLLO PREVENTIVO DI DISPONIBILITà DI GIACENZA, 
*!*	*** QUINDI NON DEVO RESTITUIRE L'OK NEL CASO IN CUI NON SONO RIUSCITO A SCARICA TUTTA LA GIACENZA PASSATA ALLA FUNZIONE

*!*	*IF  LOCAL_AQM_GIACEN > 0
*!*	_lAncoraDaScaricare = .F.
*!*	*IF CERCATIPO(AQM_ANAART) == '6'
*!*	*	IF LOCAL_AQM_GIACEN > 0.009
*!*	*		_lAncoraDaScaricare = .T.
*!*	*	ENDIF

*!*	J_TIPO = CERCATIPO(AQM_ANAART)
*!*	_nLimiteGiacenzaSignific = 0
*!*	IF J_TIPO = '1' OR J_TIPO = '6'
*!*		*_nLimiteGiacenzaSignific = 0.009
*!*		_nLimiteGiacenzaSignific = 0.09  && AUMENTATA TOLLERANZA PER GIACENZA SUFFICIENTE
*!*	ENDIF
*!*	IF J_TIPO = '9'
*!*		_nLimiteGiacenzaSignific = 0.0009
*!*	ENDIF
*!*	IF _nLimiteGiacenzaSignific > 0
*!*		IF LOCAL_AQM_GIACEN > _nLimiteGiacenzaSignific
*!*			_lAncoraDaScaricare = .T.
*!*		ENDIF
*!*	ELSE
*!*		IF LOCAL_AQM_GIACEN > 0
*!*			_lAncoraDaScaricare = .T.
*!*		ENDIF
*!*	ENDIF

*!*	*!*	IF _lAncoraDaScaricare

*!*	*!*	    IF PUB_GIANEG 	&& ELABORA ANCHE LE GIACENZE NEGATIVE  
*!*	*!*	    
*!*	*!*	        AQM_GIACEN = LOCAL_AQM_GIACEN 
*!*	*!*	         
*!*	*!*			DO AQM_SCARICA_MAGAZZINO_GIACENZE_NEGATIVE
*!*	*!*	    	_OK_SCARICA_GIACENZA  = .T.
*!*	*!*	    	_YES_SCAR = .T.
*!*	*!*			_OK_SCARICA_MAGAZZINO = .T.

*!*	*!*	   
*!*	*!*	       ELSE

*!*	*!*			IF PUB_CTRGIA
*!*	*!*				_OK_SCARICA_GIACENZA = .F.
*!*	*!*			ELSE
*!*	*!*				DO AQM_SCARICA_MAGAZZINO_SOLO_MOVIMENTI
*!*	*!*				_OK_SCARICA_GIACENZA = .T.
*!*	*!*			ENDIF

*!*	*!*		ENDIF
*!*	*!*		
*!*	*!*	*!*		VERIFICA SE DOPO AVER SCARICATO TUTTA LA GIACENZA DISPONIBILE HO ANCORA DEL RESIDUO NON ASSOCIATO A NESSUNA GIACENZA , 
*!*	*!*	*!*		IN QUESTO CASO CREO IL MOVIMENTO RELATIVO ALL'ULTIMA QUANTITA' DA SCARICARE

*!*	*!*	*!* 	ORIGINALE_AQM_GIACEN = LOCAL_AQM_GIACEN									&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	*!*	*!*		ORIGINALE_AQM_QTAKG  = LOCAL_AQM_QTAKG									&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	*!*	*!*		ORIGINALE_AQM_QTAMQ  = LOCAL_AQM_QTAMQ									&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO
*!*	*!*	*!*		ORIGINALE_AQM_QTAML  = LOCAL_AQM_QTAML									&& GIACENZA  ORIGINALE SCARICATA DAL MOVIMENTO DI CARICO PIU' VECCHIO

*!*	*!*	*!*		*LOCAL_MOVIMENTO = "CREA-MOVIMENTO"
*!*	*!*	*!*		*=AQM_CREA_U_MAG_MO(LOCAL_MOVIMENTO)
*!*	*!*	*!*		
*!*	*!*	*!*		*** RIPULISCO VARIABILI DI GIACENZA PERCHE' NON HO NESSUNA GIACENZA DI RIFERIMENTO DA CUI SCARICARE
*!*	*!*	*!*		AQM_DATAGG = ""
*!*	*!*	*!*		*!*		AQM_CODART = ""					&& SI PERO' STO GESTENDO UN RESIDUO DI ARTICOLO CHE STO SCARICANDO DALLA DDT
*!*	*!*	*!*		*!*		AQM_CODMAG = MAG_CODMAG
*!*	*!*	*!*		AQM_FILA_N = 0
*!*	*!*	*!*		AQM_PIAN_N = 0
*!*	*!*	*!*		AQM_UBIC_N = 0
*!*	*!*	*!*		AQM_FILA_X = ""
*!*	*!*	*!*		AQM_PIAN_X = ""
*!*	*!*	*!*		AQM_UBIC_X = ""
*!*	*!*	*!*		AQM_NRLINT = 0
*!*	*!*	*!*		AQM_ALTEZZ = 0
*!*	*!*	*!*		AQM_LUNGHE = 0
*!*	*!*	*!*		AQM_SPESSO = 0
*!*	*!*	*!*		*AQM_PREACQ = MAG_PRZCON
*!*	*!*	*!*		AQM_AAPROD = 0
*!*	*!*	*!*		AQM_SERBOL = ""
*!*	*!*	*!*		AQM_SERNUM = ""
*!*	*!*	*!*		AQM_NUMEDA = 0
*!*	*!*	*!*		AQM_NUMEAL = 0
*!*	*!*	*!*		AQM_CBFISC = ""
*!*	*!*	*!*		_OLD_TOP = AQM_TOP
*!*	*!*	*!*		*** CREO UN MOVIMENTO IN + FITTIZIO
*!*	*!*	*!*		AQM_SEGNO = "+"
*!*	*!*	*!*		AQM_TOP = PUB_MPIU
*!*	*!*	*!*		LOCAL_MOVIMENTO = "CREA-MOVIMENTO"
*!*	*!*	*!*		=AQM_CREA_U_MAG_MO(LOCAL_MOVIMENTO)
*!*	*!*	*!*		*** CREO IL MOVIMENTO DI SCARICO EFFETTIVO
*!*	*!*	*!*		AQM_SEGNO = "-"
*!*	*!*	*!*		AQM_TOP = _OLD_TOP
*!*	*!*	*!*		LOCAL_MOVIMENTO = "CREA-MOVIMENTO"
*!*	*!*	*!*		=AQM_CREA_U_MAG_MO(LOCAL_MOVIMENTO)
*!*	*!*	ELSE

*!*	*!*		_OK_SCARICA_GIACENZA = .T.
*!*	*!*		
*!*	*!*	ENDIF

*!*	_OK_SCARICA_GIACENZA = .T.

*!*	RETURN _OK_SCARICA_GIACENZA


*!*	*********************************
*!*	FUNCTION AQM_CREA_U_MAG_MO
*!*	*********************************
*!*	PARAMETERS _cREAMOVIMENTO,lDOCMOD
*!*	 
*!*	IF ALLTRIM(_cREAMOVIMENTO) <> "CREA-MOVIMENTO"
*!*		RETURN(.T.)	
*!*	ENDIF

*!*	IF PCOUNT() <=1
*!*		lDOCMOD = .F.
*!*	ENDIF


*!*	LOCAL _AQM_SXSX
*!*	_AQM_SXSX=SELECT()

*!*	*** NON C'E' MOTIVO DI CREARE UN NUOVO NUMERO DI LOTTO INTERNO NEL MOVIMENTO: 
*!*	*** QUESTO DEVE PERVENIRE DALLA GIACENZA CHE STO SCARICANDO/CARICANDO
*!*	*!*	=AQM_NUMERO_LOTTO_INTERNO(AQM_ANAART)										&& GESTIONE DEL NUMERO LOTTO INTERNO

*!*	Csql = "select * from u_mag_mo where 1=0"
*!*	IF !ExecRW(Csql,"U_MAG_MO","R")
*!*	 	return(.f.)
*!*	ENDIF
*!*	   		
*!*	   		
*!*	SELECT U_MAG_MO
*!*	APPEND BLANK

*!*	REPLACE MOV_CODSOC WITH PUB_CODSOC
*!*	REPLACE MOV_CODMAG WITH AQM_CODMAG  
*!*	REPLACE MOV_CODART WITH AQM_CODART  
*!*	REPLACE MOV_TOP    WITH AQM_TOP 
*!*	REPLACE MOV_SEGNO  WITH AQM_SEGNO

*!*	REPLACE MOV_NOTE  WITH AQM_NOTE && 2015/07/21 SERGIO : SU MOVIMAGA POSSO DIGITARE DEI COMMENTI


*!*	IF EMPTY(MOV_SEGNO)
*!*		REPLACE MOV_SEGNO WITH '+'
*!*		REPLACE MOV_NOTE WITH "FORZATO MOV_SEGNO + IN AQMLIB.PRG/AQM_CREA_U_MAG_MO"
*!*	ENDIF
*!*	REPLACE MOV_NUMDOC WITH AQM_NUMDOC 

*!*	IF EMPTY(ALLTRIM(AQM_DTREGI)) .OR. AQM_DTREGI = '  /  /    ' .OR. AQM_DTREGI = '    /  /  ' 
*!*		REPLACE MOV_DTREGI WITH LOCAL_DATAOGGI 
*!*	ELSE
*!*		REPLACE MOV_DTREGI WITH AQM_DTREGI 
*!*	ENDIF
*!*	IF SUBSTR(MOV_DTREGI,3,1) = '/'
*!*		REPLACE MOV_DTREGI WITH RIBALTA2(MOV_DTREGI)
*!*	ENDIF

*!*	IF EMPTY(MOV_DTREGI)
*!*		REPLACE MOV_DTREGI WITH RIBALTA2(DTOC(DATE()))
*!*	ENDIF

*!*	IF EMPTY(ALLTRIM(AQM_DTDOCU)) .OR. AQM_DTDOCU = '  /  /    ' .OR. AQM_DTDOCU = '    /  /  ' 
*!*	    *REPLACE MOV_DTDOCU WITH LOCAL_DATAOGGI  && SE NON E' DEFINITA UNA DATA DOCUMENTO NON E' NECESSARIO INSERIRLA
*!*	ELSE
*!*		REPLACE MOV_DTDOCU WITH AQM_DTDOCU
*!*	ENDIF
*!*	IF SUBSTR(MOV_DTDOCU,3,1) = '/'
*!*		REPLACE MOV_DTDOCU WITH RIBALTA2(MOV_DTDOCU)
*!*	ENDIF

*!*	REPLACE MOV_CODFOR WITH AQM_CODFOR
*!*	REPLACE MOV_FORNIT WITH AQM_CODFOR
*!*	IF EMPTY(AQM_CODFOR)
*!*		REPLACE MOV_CODFOR WITH	ORIGINALE_AQM_CODFOR
*!*		REPLACE MOV_FORNIT WITH ORIGINALE_AQM_CODFOR			
*!*	ENDIF
*!*	REPLACE MOV_DESFOR WITH AQM_DESFOR
*!*	IF EMPTY(AQM_DESFOR)
*!*		REPLACE MOV_DESFOR WITH ORIGINALE_AQM_DESFOR 
*!*	ENDIF

*!*	REPLACE MOV_CODCLI WITH AQM_CODCLI
*!*	REPLACE MOV_DESCLI WITH AQM_DESCLI
*!*	REPLACE MOV_RAGSOC WITH AQM_DESCLI

*!*	REPLACE MOV_QTAMOV WITH ORIGINALE_AQM_GIACEN  

*!*	REPLACE MOV_ANAART WITH AQM_ANAART
*!*	REPLACE MOV_SPESSO WITH AQM_SPESSO 
*!*	REPLACE MOV_ALTEZZ WITH AQM_ALTEZZ
*!*	REPLACE MOV_LUNGHE WITH AQM_LUNGHE
*!*	*REPLACE MOV_NRLINT WITH VAL(AQM_NRLINT)
*!*	REPLACE MOV_NRLINT WITH AQM_NRLINT  
*!*	REPLACE MOV_NRDBOB WITH AQM_NRDBOB

*!*	*** CODICE RIATTIVATO
*!*	REPLACE MOV_QTAMQ  WITH ORIGINALE_AQM_QTAMQ
*!*	REPLACE MOV_QTAKG  WITH ORIGINALE_AQM_QTAKG
*!*	REPLACE MOV_QTAML  WITH ORIGINALE_AQM_QTAML

*!*	_X_UMMAGA = AQM_TROVA_UMMAGA(MOV_ANAART)
*!*	DO CASE
*!*		CASE ALLTRIM(_X_UMMAGA) == "KG"
*!*			REPLACE MOV_QTAKG WITH MOV_QTAMOV
*!*		CASE ALLTRIM(_X_UMMAGA) == "MQ"
*!*			REPLACE MOV_QTAMQ WITH MOV_QTAMOV
*!*			REPLACE MOV_QTANR  WITH TROVA_NR_DA_MQ_LEGNO(MOV_ALTEZZ,MOV_LUNGHE,MOV_QTAMOV)
*!*		CASE ALLTRIM(_X_UMMAGA) == "ML"
*!*			REPLACE MOV_QTAML WITH MOV_QTAMOV
*!*		CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*			REPLACE MOV_QTAMC WITH MOV_QTAMOV
*!*			REPLACE MOV_QTANR  WITH TROVA_NR_DA_MC_LEGNO(MOV_ALTEZZ,MOV_LUNGHE,MOV_QTAMOV,MOV_SPESSO)
*!*		CASE ALLTRIM(_X_UMMAGA) == "NR" 				
*!*			REPLACE MOV_QTANR  WITH AQM_QTANR  			
*!*		CASE ALLTRIM(_X_UMMAGA) == "N." 				
*!*			REPLACE MOV_QTANR  WITH AQM_QTANR  			
*!*		CASE ALLTRIM(_X_UMMAGA) == "N" 					
*!*			REPLACE MOV_QTANR  WITH AQM_QTANR  			
*!*	ENDCASE



*!*	X_TIPO = CERCATIPO(MOV_ANAART)
*!*	IF X_TIPO = '1'  && BOBINE
*!*		IF MOV_QTAMQ <= 0
*!*			REPLACE MOV_QTAMQ WITH TROVA_MQ_DA_AL(MOV_ALTEZZ,MOV_LUNGHE,1)
*!*		ENDIF
*!*		IF MOV_QTAML <= 0
*!*			REPLACE MOV_QTAML WITH TROVA_ML_DA_LU(MOV_LUNGHE,1)
*!*		ENDIF
*!*		IF MOV_QTAKG <= 0
*!*			REPLACE MOV_QTAKG WITH TROVA_KG_DA_MQ(MOV_ANAART,MOV_SPESSO,MOV_QTAMQ,1)
*!*		ENDIF
*!*	ENDIF

*!*	IF X_TIPO = '3'  && MANICOTTI
*!*		IF ALLTRIM(_X_UMMAGA) == "NR"
*!*			REPLACE MOV_QTAML WITH MOV_QTAMOV * MOV_ALTEZZ / 1000
*!*		ENDIF
*!*	ENDIF

*!*	IF X_TIPO = '6'  && PANNELLI TRUCIOLARI
*!*		X_QTANR = 0
*!*		DO CASE
*!*			CASE ALLTRIM(_X_UMMAGA) == "MQ"
*!*				X_QTANR = TROVA_NR_DA_MQ_LEGNO(MOV_ALTEZZ,MOV_LUNGHE,MOV_QTAMOV)
*!*			CASE ALLTRIM(_X_UMMAGA) == "MC"
*!*				X_QTANR = TROVA_NR_DA_MC_LEGNO(MOV_ALTEZZ,MOV_LUNGHE,MOV_QTAMOV,MOV_SPESSO)
*!*		ENDCASE
*!*		REPLACE MOV_QTAMQ WITH TROVA_MQ_DA_AL_LEGNO(MOV_ALTEZZ,MOV_LUNGHE,X_QTANR)
*!*		REPLACE MOV_QTAML WITH TROVA_ML_DA_LU(MOV_LUNGHE,X_QTANR)
*!*		REPLACE MOV_QTAKG WITH 0
*!*		REPLACE MOV_QTAMC WITH TROVA_MC_DA_AL_LEGNO(MOV_ALTEZZ,MOV_LUNGHE,X_QTANR,MOV_SPESSO) 
*!*	ENDIF

*!*	IF X_TIPO = '8'  && CARTE IMPREGNATE
*!*		IF ALLTRIM(_X_UMMAGA) == "NR"
*!*			REPLACE MOV_QTAMQ WITH TROVA_MQ_DA_AL(MOV_ALTEZZ,MOV_LUNGHE,MOV_QTAMOV)
*!*		ENDIF
*!*	ENDIF


*!*	REPLACE MOV_SCONTO WITH ORIGINALE_AQM_SC1
*!*	IF MOV_SCONTO = 0
*!*		REPLACE MOV_SCONTO WITH AQM_SC1
*!*	ENDIF

*!*	REPLACE MOV_SC1CAM WITH ORIGINALE_AQM_SC1
*!*	IF MOV_SC1CAM = 0
*!*		REPLACE MOV_SC1CAM WITH AQM_SC1
*!*	ENDIF
*!*	REPLACE MOV_SC2CAM WITH ORIGINALE_AQM_SC2
*!*	IF MOV_SC2CAM = 0
*!*		REPLACE MOV_SC2CAM WITH AQM_SC2
*!*	ENDIF
*!*	REPLACE MOV_SC3CAM WITH ORIGINALE_AQM_SC3
*!*	IF MOV_SC3CAM = 0
*!*		REPLACE MOV_SC3CAM WITH AQM_SC3
*!*	ENDIF
*!*	REPLACE MOV_SC4CAM WITH ORIGINALE_AQM_SC4
*!*	REPLACE MOV_SC5CAM WITH ORIGINALE_AQM_SC5




*!*	REPLACE MOV_PREACQ WITH ORIGINALE_AQM_PREACQ 							&& PREZZO DI COSTO DAL RECORD ORIGINALE DI CARICO MAGAZZINO
*!*	IF MOV_PREACQ = 0
*!*		REPLACE MOV_PREACQ WITH AQM_PREACQ									&& PREZZO DI COSTO PASSATO DAL SINGOLO PROGRAMMA APPLICATIVO
*!*	ENDIF 
*!*	IF MOV_PREACQ = 0
*!*		REPLACE MOV_PREACQ WITH ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREACQ	&& PREZZO DI COSTO DA ANAGRAFICA ARTICOLI
*!*	ENDIF 
*!*	REPLACE MOV_PREVEN WITH AQM_PREVEN 										&& PREZZO DI VENDITA PASSATO DAL SINGOLO PROGRAMMA APPLICATIVO
*!*	IF MOV_PREVEN = 0
*!*		REPLACE MOV_PREVEN WITH ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_PREVEN 	&& PREZZO DI VENDITA DA ANAGRAFICA ARTICOLI
*!*	ENDIF


*!*	REPLACE MOV_IVAVEN WITH AQM_IVAVEN 

*!*	REPLACE MOV_VALVEN WITH ROUND((MOV_QTAMOV * MOV_PREVEN),2)
*!*	REPLACE MOV_VALACQ WITH ROUND((MOV_QTAMOV * MOV_PREACQ),2)

*!*	REPLACE MOV_PRSPOT WITH AQM_PRSPOT 										&& SERGIO 2014/09/27 NON GESTISCE IL PREZZO NEI DATI DI ULTIMO CARICO DELL'ANAGRAFICA ARTICOLI NEL CASO DI ACQUISTO SPOT

*!*	REPLACE MOV_UM     WITH AQM_UM  
*!*	IF EMPTY(MOV_UM)
*!*		REPLACE MOV_UM     WITH ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_UNIMIS
*!*	ENDIF
*!*	   
*!*	REPLACE MOV_COORD  WITH AQM_COORD
*!*	IF EMPTY(MOV_COORD)
*!*		REPLACE MOV_COORD  WITH ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_COORD 
*!*	ENDIF 
*!*	  
*!*	IF EMPTY(AQM_VALUTA)
*!*		REPLACE MOV_VALUTA WITH PUB_VALRIF
*!*	ELSE
*!*		REPLACE MOV_VALUTA WITH AQM_VALUTA
*!*	ENDIF

*!*	REPLACE MOV_SERIE  WITH AQM_SERIE
*!*	REPLACE MOV_AAPROD WITH AQM_AAPROD
*!*	REPLACE MOV_DESART WITH AQM_DESART 

*!*	REPLACE MOV_CODTAG WITH AQM_CODTAG
*!*	REPLACE MOV_DESTAG WITH AQM_DESTAG
*!*	REPLACE MOV_CODCOL WITH AQM_CODCOL
*!*	REPLACE MOV_DESCOL WITH AQM_DESCOL
*!*	REPLACE MOV_CODPDV WITH AQM_CODPDV		
*!*	*REPLACE MOV_ORAMOV WITH TIME()
*!*	IF !EMPTY(AQM_ORAMOV)
*!*		REPLACE MOV_ORAMOV WITH AQM_ORAMOV
*!*	ELSE
*!*		REPLACE MOV_ORAMOV WITH TIME()
*!*	ENDIF
*!*	REPLACE MOV_TIPMOV WITH AQM_TIPMOV 	


*!*	REPLACE MOV_LEGSYS WITH AQM_LEGSYS									&& GESTITO NEL PROGRAMMA APPLICATIVO CHIAMANTE						
*!*	REPLACE MOV_LEGAME WITH ORIGINALE_AQM_LEGAME						&& ORIGINALE DA MOVIMENTO DI CARICO
*!*	REPLACE MOV_NUMIDE WITH ORIGINALE_AQM_NUMIDE 						&& ORIGINALE DA MOVIMENTO DI CARICO
*!*	REPLACE MOV_UNIQUE WITH SYS(2015)									&& SYS UNIVOCO

*!*	REPLACE MOV_DATORI WITH AQM_DATORI  && ERASMO - 16/02/2015 - DATA ORIGINALE DI CARICO

*!*	REPLACE MOV_FORNSUPP WITH AQM_FORNSUPP  && ERASMO - 22/07/2015 - COD. FORNITORE SUPPORTO FILM SPALMATO

*!*	REPLACE MOV_NUMORF WITH AQM_NUMORF
*!*	REPLACE MOV_DATORF WITH AQM_DATORF
*!*	*REPLACE MOV_DATSCA WITH LOCAL_DATAOGGI
*!*	REPLACE MOV_DATSCA WITH AQM_DATAGG  && DATA 1° CARICO DELLA GIACENZA CHE STO MOVIMENTANDO

*!*	REPLACE MOV_ANNO   WITH SUBSTR(MOV_DTDOCU,1,4)
*!*	REPLACE MOV_CODOPE WITH PUB_CODOPE
*!*	REPLACE MOV_NOMOPE WITH PUB_NOMOPE


*!*	REPLACE MOV_CODMAT WITH ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_CODMAT
*!*	REPLACE MOV_DESMAT WITH ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_DESMAT

*!*	REPLACE MOV_NBAFOR WITH AQM_NBAFOR
*!*	REPLACE MOV_BDAFOR WITH AQM_BDAFOR
*!*	REPLACE MOV_BALFOR WITH AQM_BALFOR

*!*	REPLACE MOV_TIPART WITH ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_TIPART
*!*	REPLACE MOV_SERBOL WITH AQM_SERBOL
*!*	REPLACE MOV_SERNUM WITH AQM_SERNUM
*!*	REPLACE MOV_NUMEDA WITH AQM_NUMEDA
*!*	REPLACE MOV_NUMEAL WITH AQM_NUMEAL
*!*	REPLACE MOV_CBFISC WITH AQM_CBFISC
*!*	REPLACE MOV_FILA_X WITH AQM_FILA_X
*!*	REPLACE MOV_PIAN_X WITH AQM_PIAN_X
*!*	REPLACE MOV_UBIC_X WITH AQM_UBIC_X
*!*	REPLACE MOV_FILA_N WITH AQM_FILA_N
*!*	REPLACE MOV_PIAN_N WITH AQM_PIAN_N
*!*	REPLACE MOV_UBIC_N WITH AQM_UBIC_N
*!*	REPLACE MOV_NOTVAR WITH AQM_NOTVAR
*!*	REPLACE MOV_NUMMOV WITH AQM_NUMMOV_LOCALE

*!*	REPLACE MOV_CDAFOR WITH AQM_CDAFOR
*!*	REPLACE MOV_OINFOR WITH AQM_OINFOR
*!*	REPLACE MOV_PINFOR WITH AQM_PINFOR
*!*	=CAMBIADT(AQM_DTPFOR,"MOV_DTPFOR")
*!*	REPLACE MOV_TRAFOR WITH AQM_TRAFOR
*!*	REPLACE MOV_NBAFOR WITH AQM_NBAFOR
*!*	REPLACE MOV_BDAFOR WITH AQM_BDAFOR
*!*	REPLACE MOV_BALFOR WITH AQM_BALFOR
*!*	REPLACE MOV_PNKFOR WITH AQM_PNKFOR

*!*	REPLACE MOV_DOCMOD WITH lDOCMOD

*!*	REPLACE MOV_MAGUNQ WITH AQM_UNIQUE

*!*	REPLACE MOV_QUAPRO WITH AQM_QUAPRO_MOV 				 
*!*	REPLACE MOV_CLIENT WITH AQM_CLIINV_MOV 				&& PRODUZIONE PER CLIENTE RILEVATA DA INVENTARIO

*!*	IF TYPE("PUB_NOTEMOV") == 'C' OR TYPE("PUB_NOTEMOV") == 'M'
*!*		REPLACE MOV_NOTE WITH PUB_NOTEMOV
*!*	ENDIF

*!*	REPLACE MOV_SERIAL WITH AQM_SERIAL

*!*	REPLACE MOV_VIA WITH AQM_VIA    && ERASMO - 25/02/2016
*!*	REPLACE MOV_PORT WITH AQM_PORT  && ERASMO - 25/02/2016


*!*	*** MEMORIZZO I DATI RELATIVI ALL'ULTIMA MOVIMENTAZIONE DI QUESTO ARTICOLO
*!*	LOCAL _locANAART,_locNUMDOC,_locDTDOCU,_locQTAMOV,_locPREACQ,_locVALUTA,_locLEGAME,_locPRSPOT
*!*	_locANAART = MOV_ANAART
*!*	_locNUMDOC = MOV_NUMDOC
*!*	_locDTDOCU = MOV_DTDOCU
*!*	_locQTAMOV = MOV_QTAMOV
*!*	_locPREACQ = MOV_PREACQ
*!*	_locVALUTA = MOV_VALUTA
*!*	_locLEGAME = MOV_LEGAME  && ERASMO - 19/09/2014
*!*	_locPRSPOT = MOV_PRSPOT  && ERASMO - 29/09/2014
*!*	IF !ExecRW(Csql,"U_MAG_MO","W")
*!*	   return(.f.)
*!*	ENDIF

*!*	*!*	**=> ERASMO - INIZIO 29/09/2014
*!*	*!*	*** SOSTITUZIONE AGGIORNAMENTO DATI ULTIMO CARICO CON ROUTINE GENERALIZZATA
*!*	*!*	*** AGGIORNO I DATI ULTIMO CARICO SOLO SE NON SI TRATTA DI UN ACQUISTO SPOT
*!*	*!*	*IF !_locPRSPOT
*!*	*!*	IF !_locPRSPOT AND ALLTRIM(_locNUMDOC) <> "Gn"  && ERASMO - 26/01/2015 - SOLO IN CASO NON SI TRATTI DI UN MOVIMENTO AUTOMATICO DI CARICO GIACENZA NEGATIVA
*!*	*!*		*DO AQM_DATI_ULTIMA_MOVIMENTAZIONE_ARTICOLO WITH AQM_SEGNO,_locANAART,.T.,_locDTDOCU,_locNUMDOC,_locQTAMOV,_locPREACQ,_locVALUTA,_locLEGAME
*!*	*!*		**=> ERASMO - INIZIO 22/02/2016
*!*	*!*		*** SE LE DI.BA. SONO VALORIZZATE RIPRENDENDO I COSTI RISPETTO AL PREZZO DI ULTIMO CARICO IN ANAGR. ARTICOLI (SCHEDA MOVIMENTAZIONI), ALLORA CONSIDERO I SOLI MOVIMENTI DI CARICO DA BOLLA FORNITORE
*!*	*!*		*** OPPURE QUELLI DI CARICO DA PRODUZIONE
*!*	*!*		IF AQM_SEGNO = '+' AND PUB_OPZDBCOST = 2
*!*	*!*			*IF AQM_TOP = PUB_BFO
*!*	*!*			IF AQM_TOP = PUB_BFO OR AQM_TOP = PUB_CAPAGL OR AQM_TOP = PUB_CAUCAL OR AQM_TOP = PUB_CACARI OR AQM_TOP = PUB_CACATA OR AQM_TOP = PUB_CACART OR AQM_TOP = PUB_CASCLE OR AQM_TOP = PUB_CAPRNO OR ;
*!*	*!*				AQM_TOP = PUB_CAPPDMVERS OR AQM_TOP = PUB_CAPPDMSPED OR AQM_TOP = PUB_CAPPMIVERS  && ERASMO - 10/03/2016
*!*	*!*				DO AQM_DATI_ULTIMA_MOVIMENTAZIONE_ARTICOLO WITH AQM_SEGNO,_locANAART,.T.,_locDTDOCU,_locNUMDOC,_locQTAMOV,_locPREACQ,_locVALUTA,_locLEGAME
*!*	*!*			ENDIF
*!*	*!*		ELSE
*!*	*!*			DO AQM_DATI_ULTIMA_MOVIMENTAZIONE_ARTICOLO WITH AQM_SEGNO,_locANAART,.T.,_locDTDOCU,_locNUMDOC,_locQTAMOV,_locPREACQ,_locVALUTA,_locLEGAME
*!*	*!*		ENDIF
*!*	*!*		**=> ERASMO - FINE 22/02/2016
*!*	*!*	ENDIF
*!*	*!*	**=> ERASMO - FINE 29/09/2014

*!*	SELECT(_AQM_SXSX)


*!*	RETURN(.T.)


*!*	************************************************************************************************************************
*!*	PROCEDURE AQM_DATI_ULTIMA_MOVIMENTAZIONE_ARTICOLO
*!*	************************************************************************************************************************
*!*	LPARAMETERS _par_segno,_par_anaart,_par_aggiorna,_par_dtdocu,_par_numdoc,_par_qtamov,_par_preacq,_par_valuta,_par_legame 

*!*	IF PCOUNT() >= 1
*!*	ELSE
*!*		_par_segno = ""
*!*	ENDIF

*!*	IF PCOUNT() >= 2
*!*	ELSE
*!*		_par_anaart = ""
*!*	ENDIF

*!*	IF PCOUNT() >= 3
*!*	ELSE
*!*		_par_aggiorna = .F.
*!*	ENDIF

*!*	IF PCOUNT() >= 4
*!*	ELSE
*!*		_par_dtdocu = ""
*!*	ENDIF

*!*	IF PCOUNT() >= 5
*!*	ELSE
*!*		_par_numdoc = ""
*!*	ENDIF

*!*	IF PCOUNT() >= 6
*!*	ELSE
*!*		_par_qtamov = 0
*!*	ENDIF

*!*	IF PCOUNT() >= 7
*!*	ELSE
*!*		_par_preacq = 0
*!*	ENDIF

*!*	IF PCOUNT() >= 8
*!*	ELSE
*!*		_par_valuta = ""
*!*	ENDIF

*!*	IF PCOUNT() >= 9
*!*	ELSE
*!*		_par_legame = ""
*!*	ENDIF

*!*	*** MEMORIZZO I DATI RELATIVI ALL'ULTIMA MOVIMENTAZIONE DI QUESTO ARTICOLO IN VARIABILI LOCALI
*!*	LOCAL _locANAART,_locNUMDOC,_locDTDOCU,_locQTAMOV,_locPREACQ,_locLEGAME
*!*	_locANAART = _par_anaart
*!*	_locNUMDOC = _par_numdoc 
*!*	_locDTDOCU = _par_dtdocu 
*!*	_locQTAMOV = _par_qtamov 
*!*	_locPREACQ = _par_preacq 
*!*	_locVALUTA = _par_valuta 
*!*	_locLEGAME = _par_legame

*!*	*** VALORIZZO VARIABILI PUBBLICHE PER UTILIZZARLE COME VARIABILI DI RITORNO ALLA ROUTINE CHIAMANTE
*!*	RELEASE PUB_ULNCAR,PUB_ULDCAR,PUB_ULQCAR,PUB_ULPCAR,PUB_ULNSCA,PUB_ULDSCA,PUB_ULQSCA,PUB_ULPSCA
*!*	PUBLIC PUB_ULNCAR,PUB_ULDCAR,PUB_ULQCAR,PUB_ULPCAR,PUB_ULNSCA,PUB_ULDSCA,PUB_ULQSCA,PUB_ULPSCA
*!*	PUB_ULNCAR = _locNUMDOC
*!*	PUB_ULDCAR = _locDTDOCU
*!*	PUB_ULQCAR = _locQTAMOV
*!*	PUB_ULPCAR = _locPREACQ
*!*	PUB_ULNSCA = _locNUMDOC
*!*	PUB_ULDSCA = _locDTDOCU
*!*	PUB_ULQSCA = _locQTAMOV
*!*	PUB_ULPSCA = _locPREACQ

*!*	IF EMPTY(_locANAART)
*!*		RETURN
*!*	ENDIF

*!*	LOCAL _ACT_SELECT
*!*	_ACT_SELECT = SELECT()

*!*	*** SE I DATI RELATIVI ALL'ULTIMA MOVIMENTAZIONE DI QUESTO ARTICOLO SONO VUOTI O NON
*!*	*** VENGONO PASSATI PROCEDO ALLA RICERCA DI QUESTI DATI SUI MOVIMENTI DI MAGAZZINO
*!*	IF EMPTY(_locANAART) OR EMPTY(_locNUMDOC) OR EMPTY(_locDTDOCU) OR EMPTY(_locQTAMOV) OR EMPTY(_locPREACQ) OR EMPTY(_locVALUTA) OR EMPTY(_locLEGAME)
*!*		x_arti = "MOV_ANAART = '" + _locANAART + "'"
*!*		x_segn = "MOV_SEGNO = '" + _par_segno + "'"
*!*		x_data = IIF(EMPTY(_locDTDOCU),"1=1","MOV_DTREGI <= '" + _locDTDOCU + "'")
*!*		x_spot = "MOV_PRSPOT = 0"  && ERASMO - 29/09/2014
*!*		x_gine = "MOV_NUMDOC <> 'Gn'"  && ERASMO - 26/01/2015 - ESCLUDE MOVIMENTI AUTOMATICI DI CARICO GIACENZE NEGATIVE
*!*		x_mpiu = "MOV_TOP <> '" + PUB_MPIU + "'"  && ERASMO - 21/09/2015 - ESCLUDE MOVIMENTI AUTOMATICI DI RICARICO PER MODIFICA/ANNULLO RIGA BOLLA
*!*		x_cond = x_arti + " and " + x_segn + " and " + x_data + " and " + x_spot + " and " + x_gine + " and " + x_mpiu 
*!*		**=> ERASMO - INIZIO 22/02/2016
*!*		*** SE LE DI.BA. SONO VALORIZZATE RIPRENDENDO I COSTI RISPETTO AL PREZZO DI ULTIMO CARICO IN ANAGR. ARTICOLI (SCHEDA MOVIMENTAZIONI), ALLORA CONSIDERO I SOLI MOVIMENTI DI CARICO DA BOLLA FORNITORE
*!*		*** OPPURE QUELLI DI CARICO DA PRODUZIONE
*!*		IF _par_segno = '+' AND PUB_OPZDBCOST = 2
*!*			*x_topc = "MOV_TOP = '" + PUB_BFO + "'"
*!*			x_topc = "MOV_TOP IN ('" + PUB_BFO + "','" + PUB_CAPAGL + "','" + PUB_CAUCAL + "','" + PUB_CACARI + "','" + PUB_CACATA + "','" + PUB_CACART + "','" + PUB_CASCLE + "','" + PUB_CAPRNO + "','" + ;
*!*				PUB_CAPPDMVERS + "','" + PUB_CAPPDMSPED + "','" + PUB_CAPPMIVERS + "')"  && ERASMO - 10/03/2016
*!*			x_cond = x_cond + " and " + x_topc 
*!*		ENDIF
*!*		**=> ERASMO - FINE 22/02/2016
*!*		cSql = "SELECT TOP 1 MOV_ANAART, MOV_NUMDOC, MOV_DTDOCU, MOV_QTAMOV, MOV_PREACQ, MOV_VALUTA, MOV_LEGAME FROM U_MAG_MO WHERE " + x_cond + " ORDER BY MOV_DTREGI DESC, MOV_ORAMOV DESC"
*!*		IF !ExecCommand(Csql,"TMP_MAG_MO")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT TMP_MAG_MO
*!*		IF !EOF()
*!*			_locNUMDOC = MOV_NUMDOC 
*!*			_locDTDOCU = MOV_DTDOCU 
*!*			_locQTAMOV = MOV_QTAMOV 
*!*			_locPREACQ = MOV_PREACQ 
*!*			_locVALUTA = MOV_VALUTA 
*!*			_locLEGAME = MOV_LEGAME
*!*		ELSE
*!*			SELECT(_ACT_SELECT)
*!*			RETURN
*!*		ENDIF
*!*	ENDIF

*!*	*!*	*** SE MOVIMENTO DI SCARICO, CERCO LA VALUTA EFFETTIVA DAL MOVIMENTO DI ACQUISTO LEGATO
*!*	*!*	IF _par_segno = '-' AND !EMPTY(_locLEGAME)
*!*	*!*		x_lega = "MOV_LEGAME = '" + _locLEGAME + "'"
*!*	*!*		x_segn = "MOV_SEGNO = '+'"
*!*	*!*		x_cond = x_lega + " and " + x_segn
*!*	*!*		cSql = "SELECT TOP 1 MOV_VALUTA FROM U_MAG_MO WHERE " + x_cond + " ORDER BY MOV_DTREGI, MOV_ORAMOV"
*!*	*!*		IF !ExecCommand(Csql,"TMP_MAG_MO")
*!*	*!*		   return(.f.)
*!*	*!*		ENDIF
*!*	*!*		SELECT TMP_MAG_MO
*!*	*!*		IF !EOF()
*!*	*!*			_locVALUTA = MOV_VALUTA
*!*	*!*		ENDIF
*!*	*!*	ENDIF

*!*	**=> ERASMO - INIZIO 21/09/2015
*!*	*** CERCO SEMPRE LA VALUTA EFFETTIVA DAL MOVIMENTO DI ACQUISTO LEGATO
*!*	IF !EMPTY(_locLEGAME)
*!*		x_lega = "MOV_LEGAME = '" + _locLEGAME + "'"
*!*		x_segn = "MOV_SEGNO = '+'"
*!*		x_mpiu = "MOV_TOP <> '" + PUB_MPIU + "'"  && ESCLUDE MOVIMENTI AUTOMATICI DI RICARICO PER MODIFICA/ANNULLO RIGA BOLLA
*!*		x_cond = x_lega + " and " + x_segn + " and " + x_mpiu 
*!*		cSql = "SELECT TOP 1 MOV_VALUTA FROM U_MAG_MO WHERE " + x_cond + " ORDER BY MOV_DTREGI, MOV_ORAMOV"
*!*		IF !ExecCommand(Csql,"TMP_MAG_MO")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT TMP_MAG_MO
*!*		IF !EOF()
*!*			_locVALUTA = MOV_VALUTA
*!*		ENDIF
*!*	ENDIF
*!*	**=> ERASMO - FINE 21/09/2015

*!*	*** CONVERSIONE DEL PREZZO DI ACQUISTO NELL'ULTIMO CAMBIO DISPONIBILE ALLA DATA DOCUMENTO DEL MOVIMENTO
*!*	IF ALLTRIM(_locVALUTA) <> ALLTRIM(PUB_VALRIF)
*!*		__PREZZO_VALRIF = 0
*!*		x_cval = "VVA_CODVAL = '" + _locVALUTA + "'"
*!*		x_data = "VVA_DATA <= '" + _locDTDOCU + "'"
*!*		x_cond = x_cval + " and " + x_data
*!*		cSql = "SELECT TOP 1 * FROM U_VVA_CH WHERE " + x_cond + " ORDER BY VVA_DATA DESC"
*!*		IF !ExecCommand(Csql,"CURS_VVA_CH")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT CURS_VVA_CH
*!*		IF !EOF()
*!*			__CAMBIO_RECENTE = VVA_CHANGE
*!*			__PREZZO_VALRIF = CAMBIO(_locVALUTA,_locPREACQ,__CAMBIO_RECENTE,"",.F.,6)
*!*		ENDIF
*!*		_locPREACQ = __PREZZO_VALRIF
*!*	ENDIF

*!*	PUB_ULNCAR = _locNUMDOC
*!*	PUB_ULDCAR = _locDTDOCU
*!*	PUB_ULQCAR = _locQTAMOV
*!*	PUB_ULPCAR = _locPREACQ
*!*	PUB_ULNSCA = _locNUMDOC
*!*	PUB_ULDSCA = _locDTDOCU
*!*	PUB_ULQSCA = _locQTAMOV
*!*	PUB_ULPSCA = _locPREACQ

*!*	*** AGGIORNAMENTO SCHEDA "MOVIMENTAZIONI" DELL'ANAGRAFICA ARTICOLI
*!*	IF _par_aggiorna
*!*		cSql = ""
*!*		IF _par_segno = '+'
*!*			x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
*!*			x_codi = "ART_CODPRI = '" + _locANAART + "'"
*!*			x_cond = x_soci + " and " + x_codi 
*!*			cSql = "SELECT * FROM U_ART_PR WHERE " + x_cond
*!*			IF !ExecRW(Csql,"U_ART_PR","R")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT U_ART_PR
*!*			GO TOP
*!*			IF !EOF()
*!*				REPLACE ART_ULNCAR WITH _locNUMDOC
*!*				REPLACE ART_ULDCAR WITH _locDTDOCU
*!*				REPLACE ART_ULQCAR WITH _locQTAMOV
*!*				REPLACE ART_ULPCAR WITH _locPREACQ
*!*			ENDIF
*!*			IF !ExecRW(Csql,"U_ART_PR","W")
*!*			   return(.f.)
*!*			ENDIF
*!*		ENDIF
*!*					
*!*		IF _par_segno = '-'
*!*			x_soci = "ART_CODSOC = '" + PUB_CODSOC + "'"
*!*			x_codi = "ART_CODPRI = '" + _locANAART + "'"
*!*			x_cond = x_soci + " and " + x_codi 
*!*			cSql = "SELECT * FROM U_ART_PR WHERE " + x_cond
*!*			IF !ExecRW(Csql,"U_ART_PR","R")
*!*			   return(.f.)
*!*			ENDIF
*!*			SELECT U_ART_PR
*!*			GO TOP
*!*			IF !EOF()
*!*				REPLACE ART_ULNSCA WITH _locNUMDOC
*!*				REPLACE ART_ULDSCA WITH _locDTDOCU
*!*				REPLACE ART_ULQSCA WITH _locQTAMOV
*!*				REPLACE ART_ULPSCA WITH _locPREACQ
*!*			ENDIF
*!*			IF !ExecRW(Csql,"U_ART_PR","W")
*!*			   return(.f.)
*!*			ENDIF
*!*		ENDIF
*!*	ENDIF

*!*	SELECT(_ACT_SELECT)

*!*	ENDPROC


*!*	********************************
*!*	FUNCTION CAMBIO
*!*	********************************

*!*	* -->> MODIFICA 21/03/2001
*!*	* -----------------------------------------
*!*	* -->> aggiunto il parametro opzionale _CONTO_CONTABILE
*!*	* -->> che e'la chiave di lettura della tabella CONTI(indice CONTO)
*!*	* -->> chiave composta da SOCIETA'+ANNO+CONTO
*!*	* -->> quando e' valorizzato il nuovo parametro controllo se il conto
*!*	* -->> e' un conto IVA e in questo caso aggiungo 0.49 se lire o 0.0000 se euro
*!*	* -->> per poter arrotondare alla lira/centesimo superiore.

*!*	* -->> MODIFICA 03/11/2012 - FABIANO
*!*	* -->>     SE LA VALUTA DI RIFERIMENTO PUB_VALRIF ='EUR' E LA VALUTA DEL CAMBIO _COD_VAL='EUR'
*!*	* -->>     ALLORA NON SERVE ACCEDERE A CONTI PER STABILIRE SE SI TRATTA DI UN CONTO IVA
*!*	* -->>     PERCHE' COMUNQUE AGGIUNGEREI  _IVA_EURO  = 0 ALL'IMPORTO CALCOLATO
*!*	* -----------------------------------------

*!*	PARA _COD_VAL,_IMP_DOC,_CAM_DOC,_CONTO_CONTABILE,_FL_INVAL,_DECIMALS  

*!*	_W_PR=PARAMETER()

*!*	IF _W_PR < 3
*!*	   WAIT WINDOW "Routine cambio mancano i parametri"
*!*	   RETURN(0)
*!*	ENDIF

*!*	IF _W_PR = 3
*!*	   _CONTO_CONTABILE=""
*!*	   _FL_INVAL       = .F.  && STAMPA IN ITL/LIT
*!*	ENDIF

*!*	IF _W_PR = 4
*!*	   _FL_INVAL       = .F.  && STAMPA IN ITL/LIT
*!*	ENDIF


*!*	*** IMPOSTO DA PARAMETRO IL NUMERO DI DECIMALI PER L'ARROTONDAMENTO CON CUI VOGLIO IL 
*!*	*** CALCOLO DEL CAMBIO PER ESEMPIO NEL CALCOLO DEL BILANCIO PRETENDO UNA PRECISIONE DI 3 DECIMALI
*!*	IF _W_PR < 6
*!*		_DECIMALS = 2
*!*	ENDIF


*!*	* -->> se richiedo la stampa in valuta non eseguo la routine cambio
*!*	* ------------------------------------------------------------------
*!*	IF _FL_INVAL     && STAMPA IN VALUTA USCITA FORZATA
*!*	   RETURN(_IMP_DOC)
*!*	ENDIF

*!*	_IVA_LIRE=0
*!*	_IVA_EURO=0


*!*	*** SE LA VALUTA DI RIFERIMENTO PUB_VALRIF ='EUR' E LA VALUTA DEL CAMBIO _COD_VAL='EUR'
*!*	*** ALLORA NON SERVE ACCEDERE A CONTI PER STABILIRE SE SI TRATTA DI UN CONTO IVA
*!*	*** PERCHE' COMUNQUE AGGIUNGEREI  _IVA_EURO  = 0 ALL'IMPORTO CALCOLATO
*!*	***
*!*	IF PUB_VALRIF ='EUR' AND _COD_VAL ='EUR'
*!*	ELSE
*!*		IF !EMPTY(_CONTO_CONTABILE)
*!*		   _SELE_PARA=SELECT()
*!*		   _LENG  = LEN(ALLTRIM(_CONTO_CONTABILE)) - 6
*!*		   x_soci = "con_soc = '" + SUBSTR(_CONTO_CONTABILE,1,2) + "'"
*!*		   x_anno = "con_anno = '" + SUBSTR(_CONTO_CONTABILE,3,4) + "'"
*!*		   x_cont = "con_conto = '" + SUBSTR(_CONTO_CONTABILE,7,_LENG) + "'"
*!*		   x_cond = x_soci + " and " + x_anno + " and " + x_cont
*!*		   Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
*!*		   IF !ExecCommand(cSql,"cur_conti")
*!*		      return(.f.)
*!*		   ENDIF
*!*		   SELECT cur_conti
*!*		   GO TOP
*!*		   IF EOF()
*!*		   ELSE
*!*		      IF CON_TIPOCO = "I"    && CONTO IVA
*!*		         _IVA_LIRE  = .49
*!*		         _IVA_EURO  = .0000
*!*		      ENDIF
*!*		   ENDIF        
*!*		   SELECT(_SELE_PARA)
*!*		ENDIF
*!*	ENDIF

*!*	_CALCOLO=_IMP_DOC*_CAM_DOC

*!*	IF _COD_VAL $ "ITL.LIT" AND PUB_VALRIF $ "ITL.LIT"
*!*	   RETURN(ROUND(_CALCOLO+_IVA_LIRE,0))
*!*	ELSE
*!*	   IF PUB_VALRIF $ "ITL.LIT"
*!*	      RETURN(ROUND(_CALCOLO+_IVA_LIRE,0))
*!*	   ELSE
*!*	      *RETURN(ROUND(_CALCOLO+_IVA_EURO,2))
*!*	      RETURN(ROUND(_CALCOLO+_IVA_EURO,_DECIMALS))  
*!*	   ENDIF
*!*	ENDIF


*!*	*********************
*!*	FUNCTION AQM_CREA
*!*	*********************

*!*	SELECT U_MAG_GG

*!*	APPEND BLANK


*!*	REPLACE MAG_GIANEG WITH AQM_GIANEG   
*!*	 	
*!*	REPLACE MAG_CODSOC WITH PUB_CODSOC
*!*	*REPLACE MAG_DATAGG WITH RIBALTA2(AQM_DATAGG)
*!*	REPLACE MAG_DATAGG WITH AQM_DATAGG  && LA VARIABILE AQM_DATAGG E' GIA' NEL FORMATO 'AAAA/MM/GG'
*!*	REPLACE MAG_ORACAR WITH AQM_ORACAR	&& ORA 1° CARICO DELLA GIACENZA CHE STO CREANDO
*!*	REPLACE MAG_ANAART WITH AQM_ANAART  && MANCAVA IL CODICE ARTICOLO ANAGRAFICO
*!*	REPLACE MAG_CODART WITH AQM_CODART 
*!*	REPLACE MAG_DESART WITH AQM_DESART
*!*	REPLACE MAG_CODMAG WITH AQM_CODMAG
*!*	REPLACE MAG_CODPDV WITH AQM_CODPDV 
*!*	REPLACE MAG_FORNIT WITH AQM_CODFOR
*!*	REPLACE MAG_DESFOR WITH AQM_DESFOR 

*!*	REPLACE MAG_GIACEN WITH AQM_GIACEN

*!*	REPLACE MAG_SPESSO WITH AQM_SPESSO
*!*	REPLACE MAG_ALTEZZ WITH AQM_ALTEZZ
*!*	REPLACE MAG_LUNGHE WITH AQM_LUNGHE

*!*	*_XX_QTAMQ = TROVA_MQ_DA_AL(MAG_ALTEZZ,MAG_LUNGHE,1)
*!*	*REPLACE MAG_QTAMQ WITH _XX_QTAMQ 
*!*	*_XX_QTAML = TROVA_ML_DA_LU(MAG_LUNGHE,1)
*!*	*REPLACE MAG_QTAML WITH _XX_QTAML
*!*	*_XX_QTAKG = TROVA_KG_DA_MQ(MAG_ANAART,MAG_SPESSO,MAG_QTAMQ,1)
*!*	*REPLACE MAG_QTAKG WITH _XX_QTAKG

*!*	REPLACE MAG_QTAKG  WITH AQM_QTAKG	
*!*	REPLACE MAG_QTAMQ  WITH AQM_QTAMQ	
*!*	REPLACE MAG_QTAML  WITH AQM_QTAML
*!*	REPLACE MAG_QTAMC  WITH AQM_QTAMC   
*!*	REPLACE MAG_QTANR  WITH AQM_QTANR  


*!*	REPLACE MAG_QTAIMP WITH AQM_QTAIMP	 
*!*	REPLACE MAG_GMLIMP WITH AQM_GMLIMP 	
*!*	REPLACE MAG_GKGIMP WITH AQM_GKGIMP 	



*!*	REPLACE MAG_PRZCON WITH AQM_PRZCON
*!*	REPLACE MAG_LEGSYS WITH AQM_LEGSYS
*!*	REPLACE MAG_LEGAME WITH AQM_LEGAME
*!*	REPLACE MAG_PRZUFF WITH AQM_PRZCON
*!*	REPLACE MAG_NUMIDE WITH AQM_NUMIDE	
*!*	REPLACE MAG_SC1    WITH AQM_SC1
*!*	REPLACE MAG_SC2    WITH AQM_SC2
*!*	REPLACE MAG_SC3    WITH AQM_SC3
*!*	REPLACE MAG_UNIQUE WITH AQM_UNIQUE  && ?????
*!*	REPLACE MAG_ANNO   WITH PUB_ANNO


*!*	REPLACE MAG_CODMAT WITH AQM_CODMAT
*!*	REPLACE MAG_DESMAT WITH AQM_DESMAT
*!*	REPLACE MAG_CODCOL WITH AQM_CODCOL
*!*	REPLACE MAG_DESCOL WITH AQM_DESCOL
*!*	REPLACE MAG_TIPART WITH ORIGINALE_ANAGRAFICA_ARTICOLI_AQM_TIPART
*!*	*REPLACE MAG_NRLINT WITH VAL(AQM_NRLINT)
*!*	REPLACE MAG_NRLINT WITH AQM_NRLINT  
*!*	REPLACE MAG_NRDBOB WITH AQM_NRDBOB



*!*	*!*		REPLACE MAG_NUMORD WITH AQM_NUMORD
*!*	*!*		REPLACE MAG_DATORD WITH AQM_DATORD
*!*	*!*		REPLACE MAG_SYSORD WITH AQM_SYSORD

*!*	REPLACE MAG_AAPROD WITH AQM_AAPROD  
*!*	REPLACE MAG_SERBOL WITH AQM_SERBOL 
*!*	REPLACE MAG_SERNUM WITH AQM_SERNUM 
*!*	REPLACE MAG_NUMEDA WITH AQM_NUMEDA 
*!*	REPLACE MAG_NUMEAL WITH AQM_NUMEAL 
*!*	REPLACE MAG_CBFISC WITH AQM_CBFISC 

*!*	*REPLACE MAG_QTACON WITH AQM_GIACEN  && ????
*!*	REPLACE MAG_SERIE  WITH AQM_SERIE
*!*	REPLACE MAG_FILA_X WITH AQM_FILA_X
*!*	REPLACE MAG_PIAN_X WITH AQM_PIAN_X
*!*	REPLACE MAG_UBIC_X WITH AQM_UBIC_X
*!*	REPLACE MAG_FILA_N WITH AQM_FILA_N
*!*	REPLACE MAG_PIAN_N WITH AQM_PIAN_N
*!*	REPLACE MAG_UBIC_N WITH AQM_UBIC_N

*!*	REPLACE MAG_CDAFOR WITH AQM_CDAFOR
*!*	REPLACE MAG_OINFOR WITH AQM_OINFOR
*!*	REPLACE MAG_PINFOR WITH AQM_PINFOR
*!*	=CAMBIADT(AQM_DTPFOR,"MAG_DTPFOR")
*!*	REPLACE MAG_TRAFOR WITH AQM_TRAFOR
*!*	REPLACE MAG_NBAFOR WITH AQM_NBAFOR
*!*	REPLACE MAG_BDAFOR WITH AQM_BDAFOR
*!*	REPLACE MAG_BALFOR WITH AQM_BALFOR
*!*	REPLACE MAG_PNKFOR WITH AQM_PNKFOR

*!*	REPLACE MAG_QUAPRO WITH AQM_QUAPRO 				 
*!*	REPLACE MAG_CLIENT WITH AQM_CLIINV 				&& PRODUZIONE PER CLIENTE RILEVATA DA INVENTARIO

*!*	REPLACE MAG_SERIAL WITH AQM_SERIAL   

*!*	REPLACE MAG_FORNSUPP WITH AQM_FORNSUPP  && ERASMO - 22/07/2015 - COD. FORNITORE SUPPORTO FILM SPALMATO


*!*	RETURN(.T.)



*!*	***********************************************************************
*!*	* Funzione - TRC     Data: 18.03.97   Autore: Project S.r.L.
*!*	***********************************************************************
*!*	*
*!*	*  AGGIUNGE ZERI INIZIALI AD UN NUMERO IN FORMATO CARATTERE
*!*	*  PARAMETRI DA PASSARE
*!*	*  _LUN  = LUNGEZZA DEL CAMPO
*!*	*  _COD = VARIABILE CONTENENTE VALORE
*!*	*
*!*	*  sintassi:
*!*	*  V_COD=TRC(10,V_COD)
*!*	**************************
*!*	FUNCTION TRC
*!*	**************************
*!*	PARA _LUN,_COD

*!*	_COD=ALLTRIM(_COD)
*!*	IF LEN(_COD) > _LUN
*!*	 RETURN(_COD)
*!*	ENDIF

*!*	_LUN1=_LUN - LEN(_COD)
*!*	_OUT=REPLICATE('0',_LUN1)+_COD

*!*	RETURN(_OUT)


*!*	*********************************
*!*	FUNCTION AQM_NUMERO_LOTTO_INTERNO
*!*	*********************************
*!*	PARAMETERS _cART

*!*	LOCAL _AQM_SLOTTS
*!*	_AQM_SLOTTS=SELECT()

*!*	*=> - FNU = FILM NUDO  (M.P.)
*!*	*=> - ADE = ADESIVI    (M.P.)
*!*	*=> - COL = COLLA      (S.L.)
*!*	*=> - SPA = BOBINA SPALMATA 
*!*	*=> - RIB = BOBINA RIBOBINATA
*!*	*=> - IMB = BOBINA RIBOBINATA BUONA SOLO PER L'IMBALLO
*!*	*=> - TAG = BOBINA TAGLIATA

*!*	V_TIPO = '0'
*!*	V_DESCR_PARAMETRO = "GENERICO"  
*!*	IF PUB_TIPOBOB = 'FNU'
*!*	   V_TIPO = '1'
*!*	   V_DESCR_PARAMETRO = "BOBINE"  
*!*	ENDIF
*!*	IF PUB_TIPOBOB = 'ADE'
*!*	   V_TIPO = '2'
*!*	   V_DESCR_PARAMETRO = "ADESIVO"  
*!*	ENDIF
*!*	IF PUB_TIPOBOB = 'COL'
*!*	   V_TIPO = '3'
*!*	   V_DESCR_PARAMETRO = "COLLA"  
*!*	ENDIF
*!*	IF PUB_TIPOBOB = 'SPA'
*!*	   V_TIPO = '4'
*!*	   V_DESCR_PARAMETRO = "BOBINE"  
*!*	ENDIF
*!*	IF PUB_TIPOBOB = 'RIB' .OR. PUB_TIPOBOB = 'IMB'
*!*	   V_TIPO = '5'
*!*	   V_DESCR_PARAMETRO = "BOBINE"  
*!*	ENDIF
*!*	IF PUB_TIPOBOB = 'TAG'
*!*	   V_TIPO = '6'
*!*	   V_DESCR_PARAMETRO = "BOBINE"  
*!*	ENDIF
*!*	IF PUB_TIPOBOB = 'DAD'
*!*	   V_TIPO = '7'
*!*	   V_DESCR_PARAMETRO = "DADI PRESSATI"  
*!*	ENDIF

*!*	_LOOP = .T.
*!*	DO WHILE _LOOP

*!*		v_seek   = 'NUMBOB'+V_TIPO
*!*		v_chiave = "codice"
*!*		cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
*!*		IF !ExecRW(cSql,"PARA","R")
*!*		   return(.f.)
*!*		ENDIF

*!*		SELECT PARA
*!*		IF RECCOUNT() <> 0
*!*		ELSE
*!*		   APPEND BLANK
*!*		   REPLACE CODICE WITH 'NUMBOB' + V_TIPO
*!*		   *REPLACE DESCRI WITH 'PROGRESSIVO NUMERO LOTTO INTERNO PER BOBINE ' + PUB_TIPOBOB
*!*		   REPLACE DESCRI WITH "PROGRESSIVO NUMERO LOTTO INTERNO PER " + V_DESCR_PARAMETRO + " " + PUB_TIPOBOB
*!*		   REPLACE LIBERA WITH '0000000'
*!*		ENDIF

*!*		V2 = VAL(SUBSTR(LIBERA,1,7)) + 1
*!*		REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
*!*		V_CNRLINT = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
*!*		IF !ExecRW(cSql,"PARA","W")
*!*		   return(.f.)
*!*		ENDIF

*!*		V_CNRLINT = TRC(6,ALLTRIM(V_CNRLINT))
*!*		LOTTO_INTERNO = V_TIPO + SUBSTR(PUB_ANNO,4,1) + V_CNRLINT

*!*		V_CDARTI = ALLTRIM(_cART)
*!*		IF LEN(V_CDARTI) > 7
*!*		   CODICE_ARTICOLO_CON_LOTTO_INTERNO = SUBSTR(V_CDARTI,1,7) + '.' + LOTTO_INTERNO
*!*		ELSE
*!*		   CODICE_ARTICOLO_CON_LOTTO_INTERNO = V_CDARTI + '.' + LOTTO_INTERNO
*!*		ENDIF

*!*		CODICE_ARTICOLO_CON_LOTTO_INTERNO = STRTRAN(CODICE_ARTICOLO_CON_LOTTO_INTERNO,"_","-")  &&PATCH PER PROBLEMA LETTORE BARCODE SU CARATTERE UNDERSCORE


*!*		*** VERIFICO EFFETTIVA INESISTENZA GIACENZE CON STESSO NUMERO DI LOTTO INTERNO E/O CODICE ARTICOLO INTERNO
*!*		_x_soci = "mag_codsoc = '" + PUB_CODSOC + "'"
*!*		_x_data = "mag_datagg <> ''"
*!*		_x_codi = "mag_codart = '" + ALLTRIM(CODICE_ARTICOLO_CON_LOTTO_INTERNO) + "'"
*!*		_x_nrlt = "mag_nrlint = " + LOTTO_INTERNO
*!*		_x_cond = _x_soci + " and " + _x_data + " and (" + _x_codi + " or " + _x_nrlt + ")"
*!*		Csql    = "select * from u_mag_gg where " + _x_cond
*!*		IF !ExecCommand(cSql,"VRFY_MAG_GG")
*!*		   return(.f.)
*!*		ENDIF
*!*		SELECT VRFY_MAG_GG
*!*		GO TOP
*!*		IF EOF()
*!*			_LOOP = .F.
*!*			AQM_CODINT = CODICE_ARTICOLO_CON_LOTTO_INTERNO 
*!*			AQM_NRLINT = VAL(LOTTO_INTERNO)
*!*			AQM_CODART = AQM_CODINT
*!*		ENDIF
*!*		
*!*	ENDDO

*!*	SELECT(_AQM_SLOTTS)
*!*	 
*!*	RETURN(.T.)


*!*	************************
*!*	FUNCTION CAMBIADT
*!*	************************
*!*	PARA _DATA,_NOMEDT

*!*	IF _DATA = '  /  /    ' .OR. _DATA = SPACE(10) .OR. ;
*!*	   _DATA = '    /  /  ' .OR. EMPTY(_DATA)
*!*	   REPLACE &_NOMEDT WITH SPACE(10)
*!*	ELSE
*!*	   IF SUBSTR(_DATA,3,1) = '/'
*!*	      REPLACE &_NOMEDT WITH RIBALTA2(_DATA)
*!*	   ELSE
*!*	      REPLACE &_NOMEDT WITH _DATA
*!*	   ENDIF
*!*	ENDIF

*!*	RETURN(.T.)


*!*	****************************************
*!*	FUNCTION AQM_RILEVA_GIACENZE_DISPONIBILI
*!*	****************************************

*!*	LPARAMETERS _par_codsoc,_par_anaart,_par_codmag,_par_prenot,_par_codint,_par_altezz,_par_lunghe,_par_fila_x,_par_pian_x,_par_ubic_x,_par_umrit,_par_escl_mag_scarto,_par_cond_aggiuntiva

*!*	IF PCOUNT() >= 11
*!*		_par_umrit = ALLTRIM(_par_umrit)
*!*	ELSE
*!*		_par_umrit = ""
*!*	ENDIF

*!*	IF PCOUNT() >= 12
*!*	ELSE
*!*		_par_escl_mag_scarto = .T.
*!*	ENDIF

*!*	IF PCOUNT() >= 13
*!*	ELSE
*!*		_par_cond_aggiuntiva = ""
*!*	ENDIF


*!*	LOCAL _AQM_SS
*!*	_AQM_SS=SELECT()

*!*	LOCAL _RIT
*!*	_RIT = 0

*!*	_x_soci = "mag_codsoc = '" + _par_codsoc + "'"
*!*	_x_data = "mag_datagg <> ''"
*!*	*_x_codi = "mag_anaart = '" + ALLTRIM(_par_anaart) + "'"
*!*	_x_codi = IIF(EMPTY(_par_anaart),"1=1","mag_anaart = '" + ALLTRIM(_par_anaart) + "'")
*!*	*** FILTRO SU MAGAZZINI MULTIPLI
*!*	IF !EMPTY(_par_codmag)
*!*		IF "'" $ _par_codmag
*!*			_x_maga = "mag_codmag IN (" + ALLTRIM(_par_codmag) + ")"
*!*		ELSE
*!*			_x_maga = "mag_codmag = '" + ALLTRIM(_par_codmag) + "'"
*!*		ENDIF
*!*	ELSE
*!*		_x_maga = "1=1"
*!*	ENDIF
*!*	_x_pren = IIF(_par_prenot = .F.,"1=1","mag_prenot = 0")
*!*	_x_disp = "(mag_giacen - mag_qtaimp) > 0"
*!*	_x_cint = IIF(EMPTY(_par_codint),"1=1","mag_codart = '" + ALLTRIM(_par_codint) + "'")
*!*	_x_alte = IIF(_par_altezz <= 0,"1=1","mag_altezz = " + ALLTRIM(STR(_par_altezz,7,0)))
*!*	_x_lung = IIF(_par_lunghe <= 0,"1=1","mag_lunghe = " + ALLTRIM(STR(_par_lunghe,8,0)))
*!*	_x_fila = IIF(EMPTY(_par_fila_x),"1=1","mag_fila_x = '" + ALLTRIM(_par_fila_x) + "'")
*!*	_x_pian = IIF(EMPTY(_par_pian_x),"1=1","mag_pian_x = '" + ALLTRIM(_par_pian_x) + "'")
*!*	_x_ubic = IIF(EMPTY(_par_ubic_x),"1=1","mag_ubic_x = '" + ALLTRIM(_par_ubic_x) + "'")
*!*	_x_scrt = IIF(!_par_escl_mag_scarto,"1=1","mag_codmag not in ('" + ALLTRIM(PUB_SPASCA) + "','" + ALLTRIM(PUB_SCAPPT) + "')")   
*!*	_x_cond = _x_soci + " and " + _x_data + " and " + _x_codi + " and " + _x_maga + " and " + _x_pren + " and " + _x_disp + " and " + ;
*!*	          _x_cint + " and " + _x_alte + " and " + _x_lung + " and " + _x_fila + " and " + _x_pian + " and " + _x_ubic + " and " + _x_scrt 
*!*	*_x_cond = STRTRAN(_x_cond," and 1=1","")
*!*	**=> ERASMO - INIZIO 22/09/2014
*!*	IF !EMPTY(_par_cond_aggiuntiva)
*!*		_x_cond = _x_cond + " and " + ALLTRIM(_par_cond_aggiuntiva)
*!*	ENDIF
*!*	**=> ERASMO - FINE 22/09/2014
*!*	Csql = "select u_mag_gg.*, u_art_pr.art_ummaga as mag_ummaga from u_mag_gg left outer join u_art_pr on art_codpri = mag_anaart where " + _x_cond + ;
*!*		" order by mag_datagg,mag_oracar,mag_codart"

*!*	IF !ExecCommand(cSql,"LOCAL_U_MAG_GG")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT LOCAL_U_MAG_GG
*!*	GO TOP
*!*	IF EOF()
*!*	*!*		** SCARICA LA GIACENZA A LIVELLO DI ARTICOLO
*!*	*!*		_x_cond = _x_soci + " and " + _x_data + " and " + _x_codi + " and " + _x_pren + " and " + _x_disp + " and " + ;
*!*	*!*		          _x_cint + " and " + _x_alte + " and " + _x_lung + " and " + _x_scrt 
*!*	*!*		_x_cond = STRTRAN(_x_cond," and 1=1","")
*!*	*!*		Csql    = "select * from u_mag_gg where " + _x_cond + " order by mag_datagg,mag_oracar,mag_codart"
*!*	*!*		IF !ExecCommand(cSql,"LOCAL_U_MAG_GG")
*!*	*!*		   return(.f.)
*!*	*!*		ENDIF
*!*		*** BLOCCO ASTERISCATO PERCHE' NON PIU' NECESSARIO,
*!*		*** CREATO ORIGINARIAMENTE PER XILOPAN CAUSA GESTIONE SUPERFICIALE DEI MAGAZZINI DI CARICO
*!*	ENDIF
*!*	SELECT LOCAL_U_MAG_GG
*!*	GO TOP
*!*	SCAN
*!*		*_RIT = _RIT + (MAG_GIACEN - MAG_QTAIMP)

*!*		IF EMPTY(_par_umrit)
*!*			_RIT = _RIT + (MAG_GIACEN - MAG_QTAIMP)
*!*		ELSE
*!*			_cNomeCampoQtaUm = "MAG_QTA" + _par_umrit
*!*			_cTipoArticolo = CERCATIPO(MAG_ANAART)
*!*			DO CASE
*!*				CASE _cTipoArticolo = '6' AND _par_umrit = "NR"
*!*					__n_MAG_QTANR = 0
*!*					DO CASE
*!*						CASE ALLTRIM(MAG_UMMAGA) == "MQ"
*!*							__n_MAG_QTANR = TROVA_NR_DA_MQ_LEGNO(MAG_ALTEZZ,MAG_LUNGHE,MAG_GIACEN)
*!*						CASE ALLTRIM(MAG_UMMAGA) == "MC"
*!*							__n_MAG_QTANR = TROVA_NR_DA_MC_LEGNO(MAG_ALTEZZ,MAG_LUNGHE,MAG_GIACEN,MAG_SPESSO)
*!*					ENDCASE
*!*					_RIT = _RIT + __n_MAG_QTANR
*!*				

*!*				CASE _cTipoArticolo = '9' AND _par_umrit = "NR"
*!*					__n_MAG_QTANR = 0
*!*					DO CASE
*!*						CASE ALLTRIM(MAG_UMMAGA) == "MQ"
*!*							__n_MAG_QTANR = TROVA_NR_DA_MQ_LEGNO(MAG_ALTEZZ,MAG_LUNGHE,MAG_GIACEN)
*!*						CASE ALLTRIM(MAG_UMMAGA) == "MC"
*!*							__n_MAG_QTANR = TROVA_NR_DA_MC_LEGNO(MAG_ALTEZZ,MAG_LUNGHE,MAG_GIACEN,MAG_SPESSO)
*!*					ENDCASE
*!*					_RIT = _RIT + __n_MAG_QTANR
*!*				
*!*				OTHERWISE
*!*					_RIT = _RIT + &_cNomeCampoQtaUm
*!*			ENDCASE
*!*		ENDIF
*!*	ENDSCAN

*!*	SELECT(_AQM_SS)

*!*	RETURN _RIT


*!*	*********************************
*!*	FUNCTION AQM_RILEVA_QTA_IMPEGNATA
*!*	*********************************

*!*	LPARAMETERS _par_codsoc,_par_anaart,_par_codmag,_par_prenot,_par_codint,_par_altezz,_par_lunghe,_par_fila_x,_par_pian_x,_par_ubic_x

*!*	LOCAL _AQM_SS
*!*	_AQM_SS=SELECT()

*!*	_RIT = 0

*!*	_x_soci = "mag_codsoc = '" + _par_codsoc + "'"
*!*	_x_data = "mag_datagg <> ''"
*!*	_x_codi = "mag_anaart = '" + ALLTRIM(_par_anaart) + "'"
*!*	*_x_maga = "mag_codmag = '" + ALLTRIM(_par_codmag) + "'"
*!*	**=> ERASMO - INIZIO 12/09/2014
*!*	*** FILTRO SU MAGAZZINI MULTIPLI
*!*	IF !EMPTY(_par_codmag)
*!*		IF "'" $ _par_codmag
*!*			_x_maga = "mag_codmag IN (" + ALLTRIM(_par_codmag) + ")"
*!*		ELSE
*!*			_x_maga = "mag_codmag = '" + ALLTRIM(_par_codmag) + "'"
*!*		ENDIF
*!*	ELSE
*!*		_x_maga = "1=1"
*!*	ENDIF
*!*	**=> ERASMO - FINE 12/09/2014
*!*	_x_pren = IIF(_par_prenot = .F.,"1=1","mag_prenot = 0")
*!*	_x_disp = "mag_giacen > 0"
*!*	_x_cint = IIF(EMPTY(_par_codint),"1=1","mag_codart = '" + ALLTRIM(_par_codint) + "'")
*!*	_x_alte = IIF(_par_altezz <= 0,"1=1","mag_altezz = " + ALLTRIM(STR(_par_altezz,7,0)))
*!*	_x_lung = IIF(_par_lunghe <= 0,"1=1","mag_lunghe = " + ALLTRIM(STR(_par_lunghe,8,0)))
*!*	_x_fila = IIF(EMPTY(_par_fila_x),"1=1","mag_fila_x = '" + ALLTRIM(_par_fila_x) + "'")
*!*	_x_pian = IIF(EMPTY(_par_pian_x),"1=1","mag_pian_x = '" + ALLTRIM(_par_pian_x) + "'")
*!*	_x_ubic = IIF(EMPTY(_par_ubic_x),"1=1","mag_ubic_x = '" + ALLTRIM(_par_ubic_x) + "'")
*!*	_x_cond = _x_soci + " and " + _x_data + " and " + _x_codi + " and " + _x_maga + " and " + _x_pren + " and " + _x_disp + " and " + ;
*!*	          _x_cint + " and " + _x_alte + " and " + _x_lung + " and " + _x_fila + " and " + _x_pian + " and " + _x_ubic
*!*	_x_cond = STRTRAN(_x_cond," and 1=1","")
*!*	Csql    = "select * from u_mag_gg where " + _x_cond + " order by mag_datagg,mag_oracar,mag_codart"
*!*	IF !ExecCommand(cSql,"LOCAL_U_MAG_GG")
*!*	   return(.f.)
*!*	ENDIF
*!*	SELECT LOCAL_U_MAG_GG
*!*	GO TOP
*!*	SCAN
*!*		_RIT = _RIT + MAG_QTAIMP
*!*	ENDSCAN

*!*	SELECT(_AQM_SS)

*!*	RETURN _RIT


***************************************************************************************
PROCEDURE VERIFICA_ESPOSIZIONE_CLIENTE
***************************************************************************************
PARAMETERS _par_codcli,_par_datrif

IF PCOUNT() >= 1
ELSE
	RETURN .F.
ENDIF

IF PCOUNT() >= 2
ELSE
	_par_datrif = DTOC(DATE())
ENDIF

***************************************************************************************
*** DETERMINAZIONE DELLA COPERTURA CLIENTE
***************************************************************************************

RELEASE V_SALDOCLI,V_RESORDI,V_DDTNOFAT,V_FATNOCOGE,V_FIDOCLIENTE,V_ESPOSIZIONE,V_CLASSEFIDO,V_PARTITEAPERTE,V_FIDOCLIENTEA,V_MESS_ESPOSIZIONE
PUBLIC  V_SALDOCLI,V_RESORDI,V_DDTNOFAT,V_FATNOCOGE,V_FIDOCLIENTE,V_ESPOSIZIONE,V_CLASSEFIDO,V_PARTITEAPERTE,V_FIDOCLIENTEA,V_MESS_ESPOSIZIONE
V_SALDOCLI      = 0
V_RESORDI       = 0
V_DDTNOFAT      = 0
V_FATNOCOGE     = 0
V_FIDOCLIENTE   = 0
V_FIDOCLIENTEA  = 0 
V_ESPOSIZIONE   = 0
V_CLASSEFIDO    = SPACE(01)
V_PARTITEAPERTE = 0
V_MESS_ESPOSIZIONE = ""

x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + ALLTRIM(_par_codcli) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"cur_cliente")
   return(.f.)
ENDIF
SELECT cur_cliente
GO TOP
IF EOF()
ELSE
   V_ER = SOTTOGEN(CLI_NAZION)
   IF !V_ER
  	  PREFIX= PUB_CC
   ENDIF 
   SELECT cur_cliente
   V_FIDOCLIENTE = CLI_IMPFID
   V_CLASSEFIDO  = CLI_CLFIDO
   V_FIDOCLIENTEA = CLI_IMPFI2
   V_CLASSEFIDOA  = CLI_CLFID2
ENDIF

V_SALDOCLI = VERIFICA_SCOPERTO_CLIENTE(_par_codcli,_par_datrif)

*** Rilevamento del saldo dell' ordinato in essere
**==> Acquisizione del codice iva dal cliente
_ESENZI=.F.
x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + _par_codcli + "'"
x_cond = x_soci + " and " + x_codi
cSql = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"CUR_CLIENTE")
   RETURN .F.
ENDIF
SELECT CUR_CLIENTE
GO TOP
IF EOF()
   _ALRID = CERCA_IVA_DEFAULT("","CODICE",RIBALTA2(_par_datrif))
ELSE
   _ALRID = CLI_ALRID
   IF !EMPTY(CLI_ALRID)
      _ESENZI = .T.			&& CLIENTE IN ESENZIONE
   ELSE
      _ALRID = CERCA_IVA_DEFAULT("","CODICE",RIBALTA2(_par_datrif))
   ENDIF
ENDIF

**==> Calcolo delle spese bolli e di trasporto
V_SPESE = 0

IF PUB_OPZRSK = 2  && RISCHIO 2 (CONSIDERA ANCHE IL VALORE DEGLI ORDINI IN ESSERE)
	**==> Acquisizione dei saldi ordini
	x_clie = "ors_codcli = '" + ALLTRIM(_par_codcli) + "'"
	x_clse = "ord_chiuso = 0"
	x_cond = x_clie + " and " + x_clse
	cSql   = "select * from u_ord_dd where " + x_cond + " order by ORS_NUMORD,ord_codart"
	IF !ExecCommand(cSql,"CUR_RESORDINI")
	   RETURN .F.
	ENDIF
	SELECT CUR_RESORDINI
	GO TOP

	DO WHILE .T.

	   IF EOF()
	      EXIT
	   ENDIF

	   IF ALLTRIM(ORD_DESART) = "*** COMMENTO ***"   
	      SKIP +1
	      LOOP
	   ENDIF   

	   IF (ORD_NUMBOB - ORD_NUMBOE) < 1
	      SKIP +1
	      LOOP
	   ENDIF   
	   
	      
	   V_QTAORD = ORD_QTAORD - ORD_QTAEV

	   IF V_QTAORD > 0
	   ELSE
	      SKIP +1
	      LOOP
	   ENDIF

	   M.T_IMPONIB = 0
	   M.T_IMPOSTA = 0
	   M.T_VALORE  = 0
	   MATPUBX     = 0
	   M.T_OMAGGIO = 0
	   M.I_OMAGGIO = 0

	   IVA1   = SPACE(3)
	   IMPO1  = 0
	   IMPOS1 = 0

	   V_VALORE = ROUND((ORD_PRZNET*V_QTAORD),2)

	   COD_IVA = ORD_IVA
	   IMPONIB = V_VALORE
	   DES_ART = SUBSTR(ORD_DESART,1,16)

	   IF ORD_PUBBLI = "S"
	      MATPUBX = MATPUBX + V_VALORE
	   ENDIF

	   v_seek	= 'IVA'+COD_IVA
	   v_chiave = "codice"
	   IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
	      SELECT CUR_PARA
	      ALIQ = SUBSTR(LIBERA,1,3)
	      NUM_ALIQ = VAL(ALIQ)
	   ELSE
	      NUM_ALIQ = 0
	   ENDIF

	   SELECT CUR_RESORDINI

	   IMPOSTA = (IMPONIB * NUM_ALIQ) / 100

	   IF ORD_PUBBLI = "O"			&& MATERIALEIN OMAGGIO CON IVA A CARICO AZIENDA
	      IMPOS1     = 0
	   ELSE
	      IVA1   = COD_IVA
	      IMPO1  = IMPONIB
	      IMPOS1 = IMPOSTA
	      PUB_ALIQ = CERCA_IVA_DEFAULT("","ALIQUOTA",RIBALTA2(ORS_DATORD))
	      IF !_ESENZI      					&& SOLO SE NON IN ESENZIONE
	         V_IMPSP = V_SPESE * (PUB_ALIQ/100)
	      ELSE
	         V_IMPSP = 0		 				&& ESENTE
	      ENDIF
	      * -->> INSERISCO L'IVA DELLE SPESE(20%) SULLE IVE AL 20
	      FOR HF=1 TO 1
	        _IMPO ="IMPO"+ALLTRIM(STR(HF))
	        _IMPOS="IMPOS"+ALLTRIM(STR(HF))
	        IF ROUND((&_IMPOS/&_IMPO)*100,0)=PUB_ALIQ
	           &_IMPOS=&_IMPOS+V_IMPSP
	           EXIT
	        ENDIF
	      NEXT
	      IMPOS1	   = ROUND((IMPOS1+.0000),2)
	   ENDIF
	   
	   M.T_IMPONIB = IMPO1
	   M.T_IMPOSTA = IMPOS1
	   M.T_IMPONIB = M.T_IMPONIB + V_SPESE
	   M.T_VALORE  = M.T_IMPONIB + M.T_IMPOSTA - MATPUBX
	   
	   SELECT CUR_RESORDINI
	   *VALORE_RESIDUO = ORD_VALORE * ((ORD_QTAORD-ORD_QTAEV)/ORD_QTAORD)
	   VALORE_RESIDUO = M.T_VALORE * ((ORD_QTAORD-ORD_QTAEV)/ORD_QTAORD)  && ERASMO - 05/03/2013
	   
	   ***V_RESORDI = V_RESORDI + M.T_VALORE
	   V_RESORDI = V_RESORDI + VALORE_RESIDUO

	   SKIP +1

	ENDDO   
ENDIF

*=> Rilevamento delle bolle emesse ma non ancora fatturate
**==> Acquisizione delle bolle emesse ma non ancora fatturate
x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_salc = "ord_flbol <> 'S'"
x_clie = "ord_codcli = '" + ALLTRIM(_par_codcli) + "'"
x_data = "ord_datord = ord_datord"
x_cond = x_soci + " and " + x_salc + " and " + x_clie + " and " + x_data
cSql   = "select * from u_bol_tt where " + x_cond + " order by taggancio,ord_datord"
IF !ExecCommand(cSql,"CUR_DDTNOFAT")
   RETURN .F.
ENDIF
SELECT CUR_DDTNOFAT
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   
   IF ORD_CAUS = PUB_BOLLA
   ELSE 
      SKIP +1
      LOOP
   ENDIF

   V_DDTNOFAT = V_DDTNOFAT + ORD_VALORE
   
   SELECT CUR_DDTNOFAT
   SKIP +1
ENDDO   


*=> Rilevamento delle fatture emesse ma non passate in Co.Ge.
**==> Acquisizione delle fatture emesse ma non passate in contabilità generale
x_soci = "ord_codsoc = '" + PUB_CODSOC + "'"
x_salc = "ord_cge = 0"
x_clie = "ord_codcli = '" + ALLTRIM(_par_codcli) + "'"
x_cond = x_soci + " and " + x_salc + " and " + x_clie
cSql   = "select * from u_fat_tt where " + x_cond + " order by taggancio,ord_datord"
IF !ExecCommand(cSql,"CUR_FATNOCOGE")
   RETURN .F.
ENDIF
SELECT CUR_FATNOCOGE
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF

   IF ORD_CAUS = PUB_FATTU 
   ELSE 
      SKIP +1
      LOOP
   ENDIF
   
   V_FATNOCOGE = V_FATNOCOGE + ORD_VALORE

   SELECT CUR_FATNOCOGE
   SKIP +1
ENDDO   

V_ESPOSIZIONE = V_SALDOCLI + V_FATNOCOGE + V_DDTNOFAT + V_RESORDI

V_NOTACONF = "Valore partite aperte e RI.BA. non consolidate = " + ALLTRIM(STR(V_SALDOCLI,18,2)) + CHR(13) + ;
             "Valore fatture non ancora in co.ge. = " + ALLTRIM(STR(V_FATNOCOGE,18,2)) + CHR(13) + ;
             "Valore bolle non ancora fatturate   = " + ALLTRIM(STR(V_DDTNOFAT,18,2)) + CHR(13) + ;
             "Valore residuo ancora in ordine     = " + ALLTRIM(STR(V_RESORDI,18,2)) + CHR(13) + ;
             "===============================================" + CHR(13) + CHR(13) + ;
             "Valore esposizione del cliente      = " + ALLTRIM(STR(V_ESPOSIZIONE,18,2)) + CHR(13) + ;
             "Limite fido concesso al cliente     = " + ALLTRIM(STR(V_FIDOCLIENTE,18,2))+ CHR(13) + ;
             "Limite fido aggiuntivo concesso al cliente     = " + ALLTRIM(STR(V_FIDOCLIENTEA,18,2))

IF V_FIDOCLIENTE+V_FIDOCLIENTEA=0
ELSE
	IF V_ESPOSIZIONE > (V_FIDOCLIENTE+V_FIDOCLIENTEA)
	   V_MESS_ESPOSIZIONE="E S P O S I Z I O N E   S U P E R I O R E   A L   F I D O"
	ELSE
	   V_MESS_ESPOSIZIONE="E S P O S I Z I O N E   I N F E R I O R E   A L   F I D O"
	ENDIF
ENDIF

V_NOTACONF = V_NOTACONF + CHR(13) + CHR(13) +V_MESS_ESPOSIZIONE

ENDPROC


**************************
FUNCTION CERCA_IVA_DEFAULT
**************************
**********************************************************************************************************************************
*** PASSANDO IL NOME TABELLA OPPURE LA DATA DI RIFERIMENTO RITORNA IL CODICE IVA DI DEFAULT OPPURE L'ALIQUOTA
**********************************************************************************************************************************
*** ESEMPI:
***   PUB_IVADEF = CERCA_IVA_DEFAULT("CU_FAT_DD","CODICE")
**********************************************************************************************************************************
***   PUB_ALIQ = CERCA_IVA_DEFAULT("CU_FAT_DD","ALIQUOTA")
**********************************************************************************************************************************
***   PUB_IVADEF = CERCA_IVA_DEFAULT("","CODICE",M.ORD_DATORD)
**********************************************************************************************************************************
PARAMETERS _par_tabella,_par_ritorno,_par_datarif

IF PCOUNT() >= 2
ELSE
	MESSAGEBOX("Parametri per Function 'CERCA_IVA_DEFAULT' insufficienti",16,"Attenzione")
	RETURN ""
ENDIF

IF TYPE("_par_tabella") == 'C'
ELSE
	MESSAGEBOX("Parametri per Function 'CERCA_IVA_DEFAULT' non validi o insufficienti",16,"Attenzione")
	RETURN ""
ENDIF

IF TYPE("_par_ritorno") == 'C'
ELSE
	MESSAGEBOX("Parametri per Function 'CERCA_IVA_DEFAULT' non validi o insufficienti",16,"Attenzione")
	RETURN ""
ENDIF
IF _par_ritorno == 'CODICE' .OR. _par_ritorno == 'ALIQUOTA'
ELSE
	MESSAGEBOX("Parametri per Function 'CERCA_IVA_DEFAULT' non validi o insufficienti",16,"Attenzione")
	RETURN ""
ENDIF

IF PCOUNT() >= 3
ELSE
	_par_datarif = ""
ENDIF

IF EMPTY(_par_tabella)
	IF EMPTY(_par_datarif)
		MESSAGEBOX("Parametri per Function 'CERCA_IVA_DEFAULT' non validi o insufficienti",16,"Attenzione")
		RETURN ""
	ENDIF	
ENDIF

_RIT = ""
_data = ""

SWS=SELECT()


IF EMPTY(_par_datarif)
	SELECT &_par_tabella
	GO TOP

	DO CASE
		*CASE 'U_BOL_DD' $ UPPER(ALLTRIM(_par_tabella))
		CASE 'U_BOL_DD' $ UPPER(ALLTRIM(_par_tabella)) OR 'U_BCL_DD' $ UPPER(ALLTRIM(_par_tabella))  && ERASMO - 09/11/2011
			IF TYPE("M.ORD_INTRAS") == 'C'
				_data = M.ORD_INTRAS
			ENDIF
			IF EMPTY(_data)
				IF TYPE("M.ORD_DATORD") == 'C'
					_data = M.ORD_DATORD
				ELSE
					_data = ORS_DATORD
				ENDIF
			ENDIF
			
		OTHERWISE
			IF TYPE("M.ORD_DATORD") == 'C'
				_data = M.ORD_DATORD
			ELSE
				_data = ORS_DATORD
			ENDIF
	ENDCASE
ELSE
	_data = _par_datarif
ENDIF

IF EMPTY(_data)
	_data = RIBALTA2(DTOC(DATE()))
ENDIF

IF SUBSTR(_data,3,1) == '/'
	_data = RIBALTA2(_data)
ENDIF

_CODIVA = ""
x_dtda = "DATADA <= '" + _data + "'"
x_dtal = "DATAAL >= '" + _data + "'"
x_cond = x_dtda + " and " + x_dtal 
Csql = "select * from ivadefault where " + x_cond
IF !ExecCommand(Csql,"cx_ivadefault")
   return(.f.)
ENDIF
SELECT cx_ivadefault
GO TOP
IF EOF()
	_CODIVA = ALLTRIM(PUB_IVA)
ELSE
	_CODIVA = ALLTRIM(CODIVA)
ENDIF

IF _par_ritorno == 'CODICE'
	_RIT = _CODIVA
ELSE
	PERC_ALIQ = 0
	IF !ExecCommand("select * from para where codice = 'IVA" + ALLTRIM(_CODIVA) + "'","cx_para")
	   return
	ENDIF
	SELECT cx_para
	IF reccount() <> 0
	   cALIQ = SUBSTR(LIBERA,1,3)
	   PERC_ALIQ = VAL(cALIQ)
	ENDIF
	RELEASE _RIT
	_RIT = PERC_ALIQ
ENDIF

SELECT(SWS)

RETURN _RIT

ENDFUNC


***************************************************************************************
FUNCTION VERIFICA_SCOPERTO_CLIENTE
***************************************************************************************
PARAMETERS _P_CONTO,_P_DATA_RIFERIMENTO

LOCAL _CURRENT_SELECT,_SCOPERTO_RIBA,_NDARE,_NAVERE,_CF,;
		_DATADAL,_DATAAL,_PARTITA,_NUMREGI,_CURSORE, _DTSCADE,_DTASCAD,_SOLOSALDO,;
		_ORDINE,_OPENCLOSE,_SOLO_RIBA_ 

_CURRENT_SELECT= SELECT()

=DEF_VIP000()						&& DEFINISCE I CURSORE PER LA GESTIONE DEI PARTITARI/CLIENTI/FORNITORI

V_ER = SOTTOGEN("ITA")
IF V_ER
	RETURN .F.
ENDIF 
&& IN PUB_FF C'E' IL MASTRO DEI CONTI FORNITORI
&& IN PUB_CC C'E' IL MASTRO DEI CONTI CLIENTI

IF EMPTY(_P_CONTO)
	_P_CONTO		= "TUTTI"			  	&& CODICE DEL CLIENTE/FORNITORE
ELSE
	IF SUBSTR(ALLTRIM(_P_CONTO),1,LEN(PUB_CC))!=PUB_CC
		_P_CONTO = PUB_CC+ALLTRIM(_P_CONTO)
	ENDIF
ENDIF

*** PARTITE APERTE + SCOPERTO RIBA
_DATADAL	= "01/01/1990"			&& PERIODO DI ESTRAZIONE DELLE PARTITE DAL
_DATAAL		= _P_DATA_RIFERIMENTO	&& PERIODO DI ESTRAZIONE DELLE PARTITE AL
_PARTITA	= 0				 		&& NUMERO DI PARTITA , SE INDICATA ESTRAE SOLO LA PARTITA DEL CLIENTE O DEL FORNITORE ALRIMENTI TUTTE
_NUMREGI	= ""			 		&& NUMERO DI REGISTRAZIONE ,SE INDICATA ESTRAE SOLO LA PARTITA DEL CLIENTE O DEL FORNITORE ALRIMENTI TUTTE
_CURSORE    = "SCADE"		 		&& NOME DEL CURSORE DI RITORNO CONTENENTE LE PARITE
_DTSCADE	= _P_DATA_RIFERIMENTO   && RITORNA TUTTE LE PARTITE SCADUTE SINO ALLA DATA COMPRESA
_DTASCAD	= ""	          		&& RITORNA TUTTE LE PARTITE CHE SCADRANNO DALA DATA INDICATA , ALTRIMENTI TUTTE
_SOLOSALDO	= "SCADENZE" 			&& RITORNA SOLO IL SALDO DELLA PARTITA , ALTRIMENTI TUTTE
_ORDINE		= 8 				 	&& ORDINE DI ANNO / NUMERO PARTITA / DATA DI SCADENZA
_OPENCLOSE	= 2						&& 2 : RITORNA SOLO I MOVIMENTI DI DETTAGLIO DELLE PARTITE ANCORA APERTE
_SOLO_RIBA_ = 2						&& 2 : TUTTE LE SCADENZE NON-RIBA + LE SCADENZE RIBA NON CONSOLIDATE

=CERCA_PARTITE("C","PART_CLI",_P_CONTO,_DATADAL,_DATAAL,_PARTITA,_NUMREGI,_CURSORE,_DTSCADE,_DTASCAD,_SOLOSALDO,_ORDINE,_OPENCLOSE,_SOLO_RIBA_)  

SELECT SCADE
SUM NDARE TO _NDARE
SUM NAVERE TO _NAVERE 

_SCOPERTO=_NDARE-_NAVERE

SELECT(_CURRENT_SELECT)

RETURN _SCOPERTO
* FINE PROCEDURE VERIFICA_SCOPERTO_CLIENTE
***************************************************************************************


****************************************
FUNCTION DEF_VIP000
****************************************
** DEFINISCE IL CURSORE PER LA GESTIONE DEI PAGAMENTI

IF USED("cur_fornitori")
	SELECT cur_fornitori 
	USE	
ENDIF

CREATE CURSOR cur_fornitori ;
	(DESCOSATRATTA C(10), DESGRADOIMPORTANZA C(10), DESFORMAPAGAMENTO C(10), DESTIPOCONTRATTO C(10), DESACQ  C(10), DESFOR C(45), CODFOR C(10), NAZION C(03))

INDEX ON DESCOSATRATTA 				TAG DESCOS
INDEX ON DESGRADOIMPORTANZA		 	TAG DESGRA
INDEX ON DESFORMAPAGAMENTO		 	TAG DESFOR
INDEX ON DESTIPOCONTRATTO		 	TAG DESTIP
INDEX ON DESACQ					 	TAG DESACQ
INDEX ON DESFOR					 	TAG DESFOR
SET ORDER TO DESCOS

IF USED("CUR_PIANOP")
	SELECT CUR_PIANOP 
	USE	
ENDIF

CREATE CURSOR CUR_PIANOP ;
	(RAGSOC C(30),CONTABILITA_PREVISIONALE C(1),NPART N(10,0), DTREG C(10), NREG C(08), TIPODOC C(10), NUMDOC C(20), DTDOC C(10), DTSCAD C(10), CPA C(10), ;
	 VALUTA C(3), DARE C(15),AVEREX C(15), NUMPRO C(4), DESMOV C(50),DESMOV1 C(50),NPARTO N(10,0), CAMBIO N(15,10), ;
	 IMPVAL N(11,4),NDARE N(17,3),NAVERE N(17,3),NSALDO N(17,3),INDICE C(30),NFAT C(08),V_SALDO C(15), ;
	 ANNOK C(04), NPROGK N(5,0), CODFOR C(10), dtscade d(8),   ;
	 COSATRATTA C(5),GRADOIMPORTANZA C(5),FORMAPAGAMENTO C(5),TIPOCONTRATTO C(5),CODACQ C(3),PRIPAGA C(4),TIPOPA C(10), BLOCCO L, STORIA M)

INDEX ON VAL(INDICE) 			TAG DTREG 
INDEX ON RIBALTA2(DTDOC)+NUMDOC TAG DOCUM
SET ORDER TO DTREG

IF USED("CUR_CONGELATO")
	SELECT CUR_CONGELATO
	USE	
ENDIF

CREATE CURSOR CUR_CONGELATO ;
	(RAGSOC C(30),CONTABILITA_PREVISIONALE C(1),NPART N(10,0), DTREG C(10), NREG C(08), TIPODOC C(10), NUMDOC C(20), DTDOC C(10), DTSCAD C(10), CPA C(10), ;
	 VALUTA C(3), DARE C(15),AVEREX C(15), NUMPRO C(4), DESMOV C(50),DESMOV1 C(50),NPARTO N(10,0), CAMBIO N(15,10), ;
	 IMPVAL N(11,4),NDARE N(17,3),NAVERE N(17,3),NSALDO N(17,3),INDICE C(30),NFAT C(08),V_SALDO C(15), ;
	 ANNOK C(04), NPROGK N(5,0), CODFOR C(10), dtscade d(8),INDIRI C(40),LOCALI C(40),DTUSOL C(4),NUMSOL N(3,0),GGESPOS N(14,0), CORPO Memo,   ;
	 COSATRATTA C(5),GRADOIMPORTANZA C(5),FORMAPAGAMENTO C(5),TIPOCONTRATTO C(5),CODACQ C(3),PRIPAGA C(4),TIPOPA C(10), BLOCCO L, STORIA M)

INDEX ON VAL(INDICE) 			TAG DTREG 
INDEX ON RIBALTA2(DTDOC)+NUMDOC TAG DOCUM
SET ORDER TO DTREG

IF USED("SALDI_APERTI_CHIUSI")
	SELECT SALDI_APERTI_CHIUSI
	USE	
ENDIF

*** FABIANO 05/05/2014 - AGGIUNTO PARTITA_CON_PREVISIONALI C(1)
*** FABIANO 08/05/2014 - AGGIUNTO PARTITA_CON_EFFETTI C(1), FLAG_EFFETTO C(1)
CREATE CURSOR SALDI_APERTI_CHIUSI ;
	(RAGSOC C(30),CONTABILITA_PREVISIONALE C(1),NPART N(10,0), DTREG C(10), NREG C(08), TIPODOC C(10), NUMDOC C(20), DTDOC C(10), DTSCAD C(10), CPA C(10),MOVNUMPRO C(13), ;
	 VALUTA C(3), DARE C(15),AVEREX C(15), NUMPRO C(4), DESMOV C(50),DESMOV1 C(50),NPARTO N(10,0), CAMBIO N(15,10), ;
	 IMPVAL N(11,4),NDARE N(17,3),NAVERE N(17,3),NSALDO N(17,3),INDICE C(30),NFAT C(08),V_SALDO C(15), ;
	 ANNOK C(04), NPROGK N(5,0), CODFOR C(10), dtscade d(8),INDIRI C(40),LOCALI C(40),DTUSOL C(4),NUMSOL N(3,0),GGESPOS N(14,0), CORPO Memo,   ;
	 COSATRATTA C(5),GRADOIMPORTANZA C(5),FORMAPAGAMENTO C(5),TIPOCONTRATTO C(5),CODACQ C(3),PRIPAGA C(4),TIPOOPE C(10),FLAG_NATURA C(1),FLAG_RIBA C(1),DTPOSTRIBA C(10), SELEZIONE C(3),TIPOPA C(10), BLOCCO L, STORIA M,;
	 FLAG_CONVERTITA L, COD_CONTO C(13) ,PARTITA_CON_PREVISIONALI C(1), PARTITA_CON_EFFETTI C(1), FLAG_EFFETTO C(1))  

INDEX ON ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0)) TAG NUMPART 
INDEX ON ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))+DTSCAD TAG DTREG 
INDEX ON RIBALTA2(DTDOC)+NUMDOC TAG DOCUM
SET ORDER TO DTREG

IF USED("SCADE")
	SELECT SCADE
	USE	
ENDIF

*** FABIANO 05/05/2014 - AGGIUNTO PARTITA_CON_PREVISIONALI C(1)
*** FABIANO 08/05/2014 - AGGIUNTO PARTITA_CON_EFFETTI C(1), FLAG_EFFETTO C(1)
CREATE CURSOR SCADE ;
	(RAGSOC C(30),CONTABILITA_PREVISIONALE C(1),NPART N(10,0), DTREG C(10), NREG C(08), TIPODOC C(10), NUMDOC C(20), DTDOC C(10), DTSCAD C(10), CPA C(10),MOVNUMPRO C(13), ;
	 VALUTA C(3), DARE C(15),AVEREX C(15), NUMPRO C(4), DESMOV C(50),DESMOV1 C(50),NPARTO N(10,0), CAMBIO N(15,10), ;
	 IMPVAL N(11,4),NDARE N(17,3),NAVERE N(17,3),NSALDO N(17,3),INDICE C(30),NFAT C(08),V_SALDO C(15), ;
	 ANNOK C(04), NPROGK N(5,0), CODFOR C(10), dtscade d(8),INDIRI C(40),LOCALI C(40),DTUSOL C(4),NUMSOL N(3,0),GGESPOS N(14,0), CORPO Memo, ;
	 COSATRATTA C(5),GRADOIMPORTANZA C(5),FORMAPAGAMENTO C(5),TIPOCONTRATTO C(5),CODACQ C(3),PRIPAGA C(4), BANCAFOR C(5), ANOMAX C(3),SYS_PARTI C(10) , KEY_UNIQUE C(36),;
	 TIPOOPE C(10),FLAG_NATURA C(1),FLAG_RIBA C(1),FLAG_RIBA_TOP C(1), FLAG_NOTAC_TOP C(1), FLAG_TRATTA_TOP C(1), DTPOSTRIBA C(10), SELEZIONE C(3),TIPOPA C(10), BLOCCO L, STORIA M, SHOW_PART L, COD_CONTO C(13), ;
	 PARTITA_APERTA L, INSOLUTO_NON_PAGATO L, BANCASOL C(5), DESBANCASOL C(20), IBANSOL Memo, CODAGE C(3), DESAGE C(50), CODTIPOPA C(10), DESTIPOPA C(50) ,PARTITA_CON_PREVISIONALI C(1),;
	 PARTITA_CON_EFFETTI C(1), FLAG_EFFETTO C(1))
	

INDEX ON ALLTRIM(BANCASOL) + ALLTRIM(CODFOR) + RIBALTA2(DTSCAD) 	 	TAG BANCA_SC    	
INDEX ON ALLTRIM(CODFOR) + RIBALTA2(DTSCAD) 	 						TAG SCADENZA
INDEX ON VAL(INDICE) 													TAG DTREG 
INDEX ON RIBALTA2(DTDOC)+NUMDOC 										TAG DOCUM
SET ORDER TO DTREG


SELECT SCADE
ZAP
INDEX ON ALLTRIM(CODFOR) + RIBALTA2(DTSCAD) 	 TAG SCADENZA
INDEX ON VAL(INDICE) TAG DTREG && DESCENDING
INDEX ON RIBALTA2(DTDOC)+NUMDOC TAG DOCUM
SET ORDER TO DTREG

**..

IF USED("CSALDI_PARTITE")
	SELECT CSALDI_PARTITE 
	USE	
ENDIF

*** FABIANO 05/05/2014 - AGGIUNTO PARTITA_CON_PREVISIONALI C(1)
*** FABIANO 08/05/2014 - AGGIUNTO PARTITA_CON_EFFETTI C(1), FLAG_EFFETTO C(1)
*** ERASMO 10/09/2015 - ALLARGATO CAMPO NUMEROFATT DA C(6) A C(20)
CREATE CURSOR CSALDI_PARTITE (			;
	 SELEZIONE			C(3),			;
	 LEGA_SPLIT			C(120),			;
	 ID_PARTITA  		C(120),         ;
	 tipologia			C(20),			;
	 ragsoc 			C(100),          ;
	 contabilit 		C(1),  	      	;
	 npart 				N(10,0),  	    ;
	 dtscad 			C(10),			;
	 nsaldo 			N(17,3),		;
	 ndare 				N(17,3),		;
	 navere 			N(17,3),		;
	 codfor 			C(13),			;
	 dtscade 			D(8),			;
	 tipopagam 			C(10),			;
	 cosatratta 		C(5),			;
	 gradoimpor 		C(5),			;
	 formapagam 		C(5),			;
	 tipocontra 		C(5),			;
	 codacq 			C(3),			;
	 pripaga 			C(4),			;
	 c1sepago 			L,				;
	 c1sesposto 		L	,			;
	 c1quantpag 		N(17,3),		;
	 c1quandpag 		C(10),			;
	 c1pripag 			C(4),			;
	 c1achescad 		C(10),			;
	 c1motivo	 		C(50),			;
	 c1nomope	 		C(20),			;
	 c2sepago 			L 	,			;
	 c2sesposto 		L  ,			;
	 c2quantpag 		N(17,3),		;
	 c2quandpag 		C(10),			;
	 c2pripag 			C(4),			;
	 c2achescad 		C(10),			;
	 c2motivo	 		C(50),			;
	 c2nomope	 		C(20),			;
	 c3sepago 			L 	,			;
	 c3sesposto 		L 	 ,			;
	 c3quantpag 		N(17,3),		;
	 c3quandpag 		C(10),			;
	 c3pripag 			C(4),			;
	 c3achescad 		C(10),			;
	 c3motivo	 		C(50),			;
	 c3nomope	 		C(20),			;
	 c4sepago 			L 	,			;
	 c4sesposto 		L 	 ,			;
	 c4quantpag 		N(17,3),		;
	 c4quandpag 		C(10),			;
	 c4pripag 			C(4),			;
	 c4achescad 		C(10),			;
	 c4motivo	 		C(50),			;
	 c4nomope	 		C(20),			;
	 c5sepago 			L 		,		;
	 c5sesposto 		L 	 		,	;
	 c5quantpag 		N(17,3)	,		;
	 c5quandpag 		C(10)		,	;
	 c5pripag 			C(4)		,	;
	 c5achescad 		C(10)		,	;
	 c5motivo	 		C(50),			;
	 c5nomope	 		C(20),			;
	 banca 				C(13),			;
	 contocorr 			C(20),			;
	 contocont 			C(13),			;
	 quantavalu 		N(17,3), 		;
	 quandovalu 		C(10),;
	 ANOMALIA			C(3),;
	 ABI				C(5),;
	 CAB				C(5),;
	 CC					C(12),;
	 NUMEROFATT			C(20),;
	 NAZIONE			C(3),;
	 FLG_PAGATO			L,;
	 PARZIALE			N(17,3),;
	 TAGGANCIO			C(32),;
	 DES_ANOMAL			C(100),;
	 FLG_CBI			L,;
	 BON_RIC			C(10),;
	 CPA				C(10),;
	 TIPOOPE C(10),FLAG_NATURA C(1),FLAG_RIBA C(1), DTPOSTRIBA C(10),TIPOPA C(10), BLOCCO L, STORIA M,;
	 PARTITA_CON_PREVISIONALI C(1),PARTITA_CON_EFFETTI C(1), FLAG_EFFETTO C(1))	 




RETURN(.T.)


***********************************************************************
* Funzione - SOTTOGEN     Data: 31.03.98   Autore: Carlo by Project
***********************************************************************
*  RITORNA IN PUB_CC E PUB_FF IL SOTTOCONTO CLIENTI E FORNITORI
*  V_ER =.T. SE NON TROVO NESSUN SOTTOCONTO, ALTRIMENTI V_ER=.F.
*
*  PUB_STATO_CEE = .T.			SE SI TRATTA DI UN PAESE CEE
*  PUB_STATO_EXTRA_CEE = .T.	SE SI TRATTA DI UN PAESE EXTRA CEE
*
*  ACCEDE AL PARAMETRO STA+CODICE NAZIONE
*	SE NON ESISTE : TRATTA IL PARAMETRO GEN+PUB_CODSOC
*
*  sintassi:
*  V_ER=SOTTOGEN(V_CODNAZ)
**************************
FUNCTION SOTTOGEN
**************************
PARA _CNAZ

PUB_ER				= .F.
PUB_CC				= ''
PUB_FF				= ''
PUB_STATO_CEE 		= .F.			
PUB_STATO_EXTRA_CEE = .F.	

_SAVESEL = SELECT()

_CNAZ = ALLTRIM(SUBSTR(_CNAZ,1,3))


* == >>> ACCESSO AL PARAMETRO GENERALE
TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GEN'+?pub_codsoc
ENDTEXT
IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF
SELECT PARA
IF reccount() > 0
   ** SERGIO 18/12/2021 INIZIO
   IF PUB_CONTOSIMILCEE 
	   PUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_GRUPPOCF))
	   PUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_GRUPPOCF))
   ELSE
	   PUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_SOTTOG-1))
	   PUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_SOTTOG-1))
   ENDIF
   ** SERGIO 18/12/2021 FINE   
ELSE
   =MESSAGEBOX("Parametro << GEN01 >> non trovato",16,"*** ATTENZIONE ***")
   SELECT(_SAVESEL)
   PUB_ER=.T.
   RETURN(PUB_ER)
ENDIF


* == >>> ACCESSO AL PARAMETRO NAZIONE

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'STA'+?_cnaz
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() = 0
    PUB_ER=.F.
    SELECT(_SAVESEL)
    RETURN(PUB_ER)
ENDIF

* == >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONE ITALIA

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENIT'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() > 0
    IF _CNAZ $ NOTE
      
	   ** SERGIO 18/12/2021 INIZIO
	   IF PUB_CONTOSIMILCEE 
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_GRUPPOCF))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_GRUPPOCF))
	   ELSE
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,pub_sottog-1))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,pub_sottog-1))
	   ENDIF
	   ** SERGIO 18/12/2021 FINE       
      
      
      IF EMPTY(XUB_CC).OR.EMPTY(XUB_FF)
	    =MESSAGEBOX("Mancano valori nel parametro << GENIT >>",16,"*** ATTENZIONE ***")
        PUB_ER=.T.
        SELECT(_SAVESEL)
        RETURN(PUB_ER)
      ELSE
      
        PUB_CC=XUB_CC
        PUB_FF=XUB_FF
        PUB_ER=.F.

        SELECT(_SAVESEL)
        RETURN(PUB_ER)
      ENDIF
    ELSE
      PUB_ER=.T.
    ENDIF
ENDIF

* == >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONI CEE

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENCE'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() > 0
   IF _CNAZ $ NOTE
	   ** SERGIO 18/12/2021 INIZIO
	   IF PUB_CONTOSIMILCEE 
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_GRUPPOCF))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_GRUPPOCF))
	   ELSE
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,pub_sottog-1))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,pub_sottog-1))
	   ENDIF
	   ** SERGIO 18/12/2021 FINE      
      
      IF EMPTY(XUB_CC).OR.EMPTY(XUB_FF)
	    =MESSAGEBOX("Mancano valori nel parametro << GENCE >>",16,"*** ATTENZIONE ***")
        PUB_ER=.T.
        RETURN(PUB_ER)
      ELSE

        PUB_CC			= XUB_CC
        PUB_FF			= XUB_FF
        PUB_STATO_CEE 	= .T.
        PUB_ER			= .F.
        
        SELECT(_SAVESEL)
        RETURN(PUB_ER)
      ENDIF
    ELSE
      PUB_ER=.T.
    ENDIF
ENDIF



* === >>> ACCESSO AL PARAMETRO GENERALE PER NAZIONI EXTRA CEE

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GENEX'
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

SELECT PARA
IF reccount() > 0
   IF _CNAZ $ NOTE
	   ** SERGIO 18/12/2021 INIZIO
	   IF PUB_CONTOSIMILCEE 
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,PUB_GRUPPOCF))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,PUB_GRUPPOCF))
	   ELSE
	      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,pub_sottog-1))
	      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,pub_sottog-1))
	   ENDIF
	   ** SERGIO 18/12/2021 FINE      

      IF EMPTY(XUB_CC).OR.EMPTY(XUB_FF)
	    =MESSAGEBOX("Mancano valori nel parametro << GENEX >>",16,"*** ATTENZIONE ***")
        PUB_ER=.T.
        RETURN(PUB_ER)
      ELSE
      
        PUB_CC				= XUB_CC
        PUB_FF				= XUB_FF
		PUB_STATO_EXTRA_CEE = .T.	
        PUB_ER				= .F.

        SELECT(_SAVESEL)
        RETURN(PUB_ER)
      ENDIF
    ELSE
      PUB_ER=.T.
    ENDIF
ENDIF


IF PUB_ER=.T.
    *=MESSAGEBOX("PARAMETRO 'GEN' NON TROVATO",16,"ATTENZIONE")
    *RETURN(PUB_ER)
ENDIF

**=> ERASMO - INIZIO 31/01/2014
SELECT(_SAVESEL)

ENDFUNC
**=> ERASMO - FINE 31/01/2014


****************************************
FUNCTION DEF_EURO
****************************************
** DEFINISCE IL CURSORE PER LA GESTIONE DELLE PARTITE CLIENTI / FORNITORI


CREATE CURSOR PART_EUR ;
		(CONTO C(13),NPART N(10,0),INDICE C(200), NUMPRO C(13),NREG C(08),DTREG C(10), TIPODOC C(10), NUMDOC C(10), CONTABILITA_PREVISIONALE C(1),;
		DTDOC C(10), DTSCAD C(10),VALUTA C(3),CAMBIO N(15,10),D_ITL N(20,3),A_ITL N(20,3),T_ITL N(20,3),D_EUR N(20,3), ;
		A_EUR N(20,3),T_EUR N(20,3),T_DIF N(20,3), CODAGE C(03), DESAGE C(40), CODNAZ C(03), DESNAZ C(40), RAGSOC C(40), NPROT C(10), TDOC C(10), ANOMAX C(3), T_NOPART L)
		INDEX ON ALLTRIM(CONTO) + STR(NPART,10,0)  				TAG PART_EUR
		INDEX ON ALLTRIM(RAGSOC) + STR(NPART,10,0)  			TAG PART_SOC
		INDEX ON ALLTRIM(CONTO) + DTSCAD  						TAG PART_DTS
		INDEX ON ALLTRIM(CONTO) + STR(NPART,10,0) + DTSCAD  	TAG PART_ESC


RETURN(.T.)


***********************************************************************
* Funzione - TRASGG     Data: 12.03.97   Autore: Project S.r.L.
***********************************************************************
*
*  Consente di convertire una data in giorni
*  parametri da passare:
*  "AMG"  se la data è in formato AAAA/MM/GG
*  "GMA"  se la data è in formato GG/MM/AAAA
*  _DATA1  variavile contenente la data
*
*  sintassi:
*  TRASGG("AMG",_DATA1)
**************************
FUNCTION TRASGG
**************************
PARAMETER _TIPO,_DATA1
_GIORNI=0
*!*	IF _TIPO="AMG"
*!*	  IF SUBSTR(_DATA1,3,1)="/"
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,2)) * 360)
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,4,2)) * 30)
*!*	    IF VAL(SUBSTR(_DATA1,7,2)) > 30
*!*	      _GIORNI=_GIORNI+30
*!*	    ELSE
*!*	      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,7,2)))
*!*	    ENDIF
*!*	  ELSE
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,4)) * 360)
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,6,2)) * 30)
*!*	    IF VAL(SUBSTR(_DATA1,9,2)) > 30
*!*	      _GIORNI=_GIORNI+30
*!*	    ELSE
*!*	      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,9,2)))
*!*	    ENDIF
*!*	  ENDIF
*!*	ELSE
*!*	  IF SUBSTR(_DATA1,7,3)=" "
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,7,2)) * 360)
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,4,2)) * 30)
*!*	    IF VAL(SUBSTR(_DATA1,1,2)) > 30
*!*	      _GIORNI=_GIORNI+30
*!*	    ELSE
*!*	      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,2)))
*!*	    ENDIF
*!*	  ELSE
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,7,4)) * 360)
*!*	    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,4,2)) * 30)
*!*	    IF VAL(SUBSTR(_DATA1,1,2)) > 30
*!*	      _GIORNI=_GIORNI+30
*!*	    ELSE
*!*	      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,2)))
*!*	    ENDIF
*!*	  ENDIF
*!*	ENDIF

IF _TIPO="AMG"
  IF SUBSTR(_DATA1,3,1)="/"
    _GIORNI=CTOD(_DATA1)-CTOD("01/01/1900")
  ELSE
    _GIORNI=CTOD(RIBALTA2(_DATA1))-CTOD("01/01/1900")
  ENDIF
ELSE
  IF SUBSTR(_DATA1,5,1)="/"
  	_GIORNI=CTOD(RIBALTA2(_DATA1))-CTOD("01/01/1900")
  ELSE
  	_GIORNI=CTOD(_DATA1)-CTOD("01/01/1900")
  ENDIF
ENDIF


RETURN(_GIORNI)


***************************************************************************
FUNCTION LABEL_NR_PEZZI_PRODOTTO_FINITO
***************************************************************************
** RESTITUISCE LA DESCRIZIONE DA FAR COMPARIRE NELLE ETICHETTE CHE INDICANO 
** IL NUMERO PEZZI DEL PRODOTTO FINITO IN BASE AL TIPO DI PRODUZIONE ATTIVA
***************************************************************************

LPARAMETERS _par_tipo

IF PCOUNT() = 0
	_par_tipo = "ESTESA"
ENDIF

_RIT = ""

IF _par_tipo = "ESTESA"
	DO CASE
		CASE PUB_PRDFILM
			_RIT = "rotoli"
		CASE PUB_PRGPLET
			_RIT = "pannelli"
		CASE PUB_PRDFPR
			_RIT = "bobine"
	 	OTHERWISE
	 		_RIT = "pezzi" 
	ENDCASE
ENDIF

IF _par_tipo = "RIDOTTA"
	DO CASE
		CASE PUB_PRDFILM
			_RIT = "rot."
		CASE PUB_PRGPLET
			_RIT = "pezzi"
		CASE PUB_PRDFPR
			_RIT = "bob."
	 	OTHERWISE
	 		_RIT = "pz." 
	ENDCASE
ENDIF

RETURN _RIT
