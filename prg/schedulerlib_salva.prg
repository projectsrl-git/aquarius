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

IF !EXECCOMMAND("SELECT * FROM SCHEDULER","TMP_SCHEDULER")
	RETURN .F.
ENDIF

*** TRA TUTTI GLI OGGETTI DEL CONTENITORE _SCREEN VERIFICO SE ESISTONO DEI TIMER CHE IN REALTA' NON ESISTONO PIU' SULLA TABELLA SCHEDULER
*** IN QUANTO L'UTENTE NEL FRATTEMPO POTREBBE AVERLI ELIMINATI: IN TAL CASO LI RIMUOVO
LOCAL _i
IF _SCREEN.ControlCount > 0
	FOR _i = 1 TO _SCREEN.ControlCount
		IF _SCREEN.Controls(_i).BaseClass = "Timer"
			_nomeTimer = _SCREEN.Controls(_i).Name
			IF UPPER(ALLTRIM(_nomeTimer)) == UPPER("AqSchedulerTimerMasterM")
				LOOP
			ENDIF
			IF USED("XX_TMP_SCHEDULER")
				SELECT XX_TMP_SCHEDULER
				USE
			ENDIF
			SELECT "Timer" + ALLTRIM(ID_FUNZIONE) AS NOME_TIMER FROM TMP_SCHEDULER WHERE "Timer" + ALLTRIM(ID_FUNZIONE) == _nomeTimer INTO CURSOR XX_TMP_SCHEDULER
			SELECT XX_TMP_SCHEDULER
			GO TOP
			IF EOF()
				_SCREEN.RemoveObject(_nomeTimer)
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
_NOME_CURSORE = "TMP_FUNZIONE" + SYS(2015)

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

IF RIBALTA2(DTOC(DATE())) >= PERIDAL AND RIBALTA2(DTOC(DATE())) <= PERIAL
ELSE
	USE
	RETURN
ENDIF

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

FOR _ii = 1 TO 4
	_cNomeCampo = _W_XX_GIORNO_SETT + "_TIME" + ALLTRIM(STR(_ii))
	IF EMPTY(&_cNomeCampo) OR &_cNomeCampo = "  :  :  "
	ELSE
		IF ALLTRIM(&_cNomeCampo) == ALLTRIM(_W_XX_TIME)
		
			*** FAI QUELLO CHE VUOI!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			SELECT &_NOME_CURSORE
			GO TOP
			DO ELABORA_PROGRAMMA_SCHEDULATO WITH ALLTRIM(PROGRAMMA),GO_EMAIL,ID_FUNZIONE
			
		ENDIF
	ENDIF
NEXT

SELECT &_NOME_CURSORE
USE

ENDPROC



*!*	################################################################################################################################################################
*******************************************************************************************************************
* DEFINIZIONE CLASSE PER TIMER DI CONTROLLO FLAG DI BLOCCO PER CHIUSURA AUTOMATICA AQUARIUS DA QUALSIASI POSTAZIONE



DEFINE CLASS AqScheduler_01_Timer AS Timer
	
	PROCEDURE Timer
	
		DO VERIFICA_DATA_ORA_01 WITH .T.  && VERIFICO SE DEVO ESEGUIRE UN PROGRAMMA ALLA DETERMINATA DATA ORA
		
		THIS.Interval = 0 && TIMER SPENTO
		
	ENDPROC
	
ENDDEFINE


********************************
PROCEDURE VERIFICA_DATA_ORA_01
********************************
LPARAMETERS _par_waitmsg

IF PCOUNT() > 0
ELSE
	_par_waitmsg = .T.
ENDIF

_ACT_SEL = SELECT()

*WAIT CLEAR
*WAIT WINDOWS "STO VERIFICANDO CHE BELLO !!!!" + "  Time  " + TIME() AT 10,50 NOWAIT
*!*	_runcommand = "run /n C:\AQUARIUS\AQ_exec_01.BAT"	
*!*	&_runcommand


*##########################################
*_X_FILENAME = PUTFILE("Nome file", SYS(5) + SYS(2003) + "\SC_SQL\POPOLA_TABPROP.sql", "sql")

LOCAL _X_FILENAME,V_FILE,_STRINGA

_X_FILENAME = "C:\TEST_TIMER\FILE_TIMER_01.TXT"

IF FILE(_X_FILENAME)
	_cEraseExistingFile = "ERASE '" + _X_FILENAME + "'"
	&_cEraseExistingFile
ENDIF
V_FILE = FCREATE(_X_FILENAME)

*!*	LOCAL _I
*!*	_STRINGA = ""
*!*	FOR _I = 1 TO 1000000
*!*		_STRINGA = _STRINGA + CHR(13) + CHR(10) + "TIMER 01 GENERATO ALLE ORE: " + TIME()
*!*	NEXT
_STRINGA = "TIMER 01 GENERATO ALLE ORE: " + TIME()

FPUTS(V_FILE,_STRINGA)
=FCLOSE(V_FILE)
*##########################################


*!*	_act_seconds1 = SECONDS()

*!*	*!*	DO WHILE .T.
*!*	*!*		_act_seconds2 = SECONDS()
*!*	*!*		IF _act_seconds2 - _act_seconds1 > 10		&& ATTENDE PRIMA DI TERMINARE 10 SECONDI IN PIU'
*!*	*!*			EXIT
*!*	*!*		ENDIF
*!*	*!*	ENDDO


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

PARAMETERS _stringsql,_nomesql

IF pub_sqlhd < 1
	IF !ExecConnect()
	  return(.f.)
	ENDIF 
ENDIF

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

LOCAL _valore

_valore=""

IF FILE(_configfile)	  && Esiste il file? 

	gnConfigFile = FOPEN(_configfile)	  	&& Se esiste, lo apre in lettura
	IF gnConfigFile >= 0  					&& Verifica errore in apertura del file
											&& Se non viene trovato alcun errore legge file
		do while !feof(gnConfigFile)
			riga=FGETS(gnConfigFile)
			
			if at('=',riga)>0
				chiave=upper(substr(riga,1,at("=",riga)-1))
				valore=allt(substr(riga,at("=",riga)+1))

				if	chiave=_proprieta
					_valore=valore
				endif
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
