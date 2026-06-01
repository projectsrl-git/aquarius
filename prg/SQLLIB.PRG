


*********************************************************************************************
*
* -->> Libreria con le funzioni per l'utilizzo di un database sql / oracle
*
*********************************************************************************************
*
* -->> Creata il 26/09/2002 da Project s.r.l.
*
*********************************************************************************************
*
* -->> Modificata il ........ da ..... by Project s.r.l. (tipo di modifica)
*
*********************************************************************************************



*********************************************************************************************
FUNCTION SetHomeDB
*********************************************************************************************

IF !SwicthDBConnection(PUB_NOMEDB)
	RETURN (.f.)
ENDIF 

RETURN .t.
*********************************************************************************************

*********************************************************************************************
FUNCTION SwicthDB
*********************************************************************************************
PARAMETERS numeroDbAlternativo

PRIVATE v_nomedb

v_nomedb=""

IF PCOUNT()=0
	v_nomedb=PUB_NOMEDB_ALT1
ELSE
	DO CASE 
		CASE numeroDbAlternativo =1
			v_nomedb=PUB_NOMEDB_ALT1

		CASE numeroDbAlternativo =2
			v_nomedb=PUB_NOMEDB_ALT2
		
		CASE numeroDbAlternativo =3
			v_nomedb=PUB_NOMEDB_ALT3

		OTHERWISE 
			=MESSAGEBOX("Num.database alternativo non previsto",48,"*** ATTENZIONE ***")
			return(.f.)
			
	ENDCASE 
		
ENDIF 

IF !SwicthDBConnection(v_nomedb)
	RETURN (.f.)
ENDIF 

RETURN .t.
*********************************************************************************************


*********************************************************************************************
FUNCTION SwicthDBConnection
*********************************************************************************************
PARAMETERS V_NOMEDB

*!*	IF !FILE("STRINGSQL.DBF")
*!*	  	=MESSAGEBOX("Errore connessione SQL",16,"*** ATTENZIONE ***")
*!*		RETURN(.f.)
*!*	ELSE
*!*	  SELECT ALLTRIM(STRINGA) AS cString FROM STRINGSQL WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED() INTO CURSOR _TMP
*!*	  IF _TALLY = 0
*!*			=MESSAGEBOX("Errore connessione SQL",16,"*** ATTENZIONE ***")
*!*			RETURN(.f.)
*!*	  ELSE
*!*			SELECT _TMP
*!*			
*!*			V_PREFIX=SUBSTR(cString,1,AT("DATABASE=",cString)-1)
*!*			V_SUFFIX=SUBSTR(cString,AT("DATABASE=",cString))
*!*			V_SUFFIX=SUBSTR(V_SUFFIX,AT(";",V_SUFFIX))
*!*			
*!*			
*!*			cString=ALLTRIM(V_PREFIX+"DATABASE="+V_NOMEDB+V_SUFFIX)
*!*			
*!*			UPDATE STRINGSQL SET STRINGA=cString WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED()
*!*			SQLDISCONNECT(pub_sqlhd)
*!*			pub_sqlhd =0
*!*	  ENDIF
*!*	ENDIF

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
		
		*IF "DRIVER=" $ V_NOMEDB .AND. "SERVER=" $ V_NOMEDB .AND. "UID=" $ V_NOMEDB .AND. "PWD=" $ V_NOMEDB .AND. ;
		*   "APP=" $ V_NOMEDB .AND. "WSID=" $ V_NOMEDB .AND. "DATABASE=" $ V_NOMEDB
		
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
   *pub_sqlhd = SQLSTRINGCONNECT("DRIVER=SQL Server")
   **=> ERASMO - INIZIO 09/09/2009
   cString = ""
   DO InitializeStringsqlFromDbsocieta WITH "cString"
   pub_sqlhd = SQLSTRINGCONNECT(cString)
   **=> ERASMO - FINE 09/09/2009
  
   cString = SQLGETPROP(pub_sqlhd, 'CONNECTSTRING')
   CREATE TABLE STRINGSQL(ID_DATA C(10),CONNDEF C(1),DE_NAME C(100),ID_WRK C(100),STRINGA C(200))
   INSERT INTO STRINGSQL (ID_DATA,CONNDEF,DE_NAME,ID_WRK,STRINGA) VALUES ('SQL','S','User system',SYS(0),cString)
   
   SELECT ALLTRIM(STRINGA) AS cString FROM STRINGSQL WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED() INTO CURSOR _TMP  && ERASMO - 09/09/2009
ELSE
   SELECT ALLTRIM(STRINGA) AS cString FROM STRINGSQL WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED() INTO CURSOR _TMP
   IF _TALLY = 0
      *pub_sqlhd = SQLSTRINGCONNECT("DRIVER=SQL Server")
      **=> ERASMO - INIZIO 09/09/2009
      cString = ""
      DO InitializeStringsqlFromDbsocieta WITH "cString"
      pub_sqlhd = SQLSTRINGCONNECT(cString)
      **=> ERASMO - FINE 09/09/2009
         
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
* Eof FUNCTION ExecConnect
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

*!*	PARAMETERS _stringsql,_nomesql

**=> ERASMO - INIZIO 21/12/2012
PARAMETERS _stringsql,_nomesql,_canstop,_NomeVarStopped

IF PCOUNT() >= 3
ELSE
	_canstop = .F.
ENDIF
**=> ERASMO - FINE 21/12/2012

**=> ERASMO - INIZIO 25/03/2015
IF PCOUNT() >= 4
ELSE
	_NomeVarStopped = ""
ENDIF
**=> ERASMO - FINE 25/03/2015

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

*!*	_RT=SQLEXEC(pub_sqlhd, _stringsql, _nomesql)
*!*	IF _RT < 0
*!*		=MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
*!*	*	SQLDISCONNECT(pub_sqlhd)
*!*	*	pub_sqlhd=0
*!*		RETURN(.f.)
*!*	ENDIF

**=> ERASMO - INIZIO 21/12/2012
IF _canstop
		
*!*		**=> ERASMO - INIZIO 03/03/2014
*!*		IF TYPE("_SCREEN.AqVerificaAlert1") == 'O'
*!*			_OLD_AqVerificaAlert_Interval = _SCREEN.AqVerificaAlert1.Interval
*!*			_SCREEN.AqVerificaAlert1.Interval = 0
*!*		ENDIF
*!*		**=> ERASMO - FINE 03/03/2014
	
	PUB_ABILITA_AqVerificaAlert = .F.  && ERASMO - 12/03/2015
	
	LOCAL _OLD_AsynchronousMode		&& ERASMO - 12/03/2015
	_OLD_AsynchronousMode = .F.		&& ERASMO - 12/03/2015
	_OLD_AsynchronousMode = SQLGETPROP(pub_sqlhd, 'Asynchronous')
	SQLSETPROP(pub_sqlhd, 'Asynchronous', .T.)   && To stop SQLEXEC( )
	
	_RT = 0
	
	*_STOPPED = .F.
	*DO FORM FORM\SQLEXECUTION_CANSTOP
	**=> ERASMO - INIZIO 25/03/2015
	DO FORM FORM\SQLEXECUTION_CANSTOP WITH .F.,_NomeVarStopped
	**=> ERASMO - FINE 25/03/2015
	
	SQLSETPROP(pub_sqlhd, 'Asynchronous', _OLD_AsynchronousMode)
	
*!*		**=> ERASMO - INIZIO 03/03/2014
*!*		IF TYPE("_SCREEN.AqVerificaAlert1") == 'O'
*!*			_SCREEN.AqVerificaAlert1.Interval = _OLD_AqVerificaAlert_Interval
*!*		ENDIF
*!*		**=> ERASMO - FINE 03/03/2014

	PUB_ABILITA_AqVerificaAlert = .T.  && ERASMO - 12/03/2015
	
	IF _RT < 0
		MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
		RETURN(.f.)
	ENDIF
	
ELSE
	
	**=> ERASMO - INIZIO 29/04/2016
	IF TYPE("_OK_BlackBoxExecCommand") = 'L' AND _OK_BlackBoxExecCommand = .F.
	ELSE
		IF SUBSTR(_stringsql,1,6) = "DELETE" OR SUBSTR(_stringsql,1,6) = "UPDATE"
			_nomecur_BEFORE_BlackBoxExecCommand = BlackBoxExecCommand("BEFORE",_stringsql,_nomesql,"")
		ENDIF
	ENDIF
	**=> ERASMO - FINE 29/04/2016
	
*!*		**=> ERASMO - INIZIO 19/09/2017
*!*		*** IMPOSTA LA SESSIONE DI ACCESSO A SQL IN MODO DA RICONOSCERE DURANTE LA SUCCESSIVA "TABLEUPDATE" 
*!*		*** I CAMPI DI TIPO VARCHAR, EVITANDO IL PROBLEMA DEGLI SPAZI DI RIEMPIMENTO A DESTRA
*!*		CURSORSETPROP("MapVarchar", .T., 0)
*!*		**=> ERASMO - FINE 19/09/2017
		
	_RT=SQLEXEC(pub_sqlhd, _stringsql, _nomesql)
	IF _RT < 0
		=MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
	*	SQLDISCONNECT(pub_sqlhd)
	*	pub_sqlhd=0
		RETURN(.f.)
	ENDIF
	
	**=> ERASMO - INIZIO 29/04/2016
	IF TYPE("_OK_BlackBoxExecCommand") = 'L' AND _OK_BlackBoxExecCommand = .F.
	ELSE
		IF SUBSTR(_stringsql,1,6) = "DELETE" OR SUBSTR(_stringsql,1,6) = "UPDATE"
			IF TYPE("_nomecur_BEFORE_BlackBoxExecCommand") = 'C' AND !EMPTY(_nomecur_BEFORE_BlackBoxExecCommand)
				=BlackBoxExecCommand("AFTER",_stringsql,_nomesql,_nomecur_BEFORE_BlackBoxExecCommand)
			ENDIF
		ENDIF
	ENDIF
	**=> ERASMO - FINE 29/04/2016

ENDIF
**=> ERASMO - FINE 21/12/2012

**=> ERASMO - INIZIO 12/02/2013
IF TYPE("PUB_LOGSQL") == 'L' AND PUB_LOGSQL AND _nomesql <> 'LOGSQL'
	_nLogSqlSecondsFin = SECONDS()
	_nLogSqlDeltaSeconds = _nLogSqlSecondsFin - _nLogSqlSecondsIni
	*IF _nLogSqlDeltaSeconds >= 1  &&SERGIO/ERASMO ??????????????????
	*IF _nLogSqlDeltaSeconds >= 0.2
	IF _nLogSqlDeltaSeconds >= PUB_NSECMIN_LOGSQL  && ERASMO - 10/03/2023
		ASTACKINFO(ArrayStackInfo)
		_nStackLevels = ALEN(ArrayStackInfo, 1)
		_nCallingLevel = _nStackLevels - 1
		DO WriteLogSql WITH ALLTRIM(_stringsql)
	ENDIF
ENDIF
**=> ERASMO - FINE 12/02/2013

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
		LOCAL a1,a2,a3,a4,a5,a6,a7  && ERASMO - 30/04/2014
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
		
		*DO BlackBox WITH "",_nomesql,"EXECRW_W",_nomesql  && ERASMO - 17/04/2013
		DO BlackBox WITH _stringsql,_nomesql,"EXECRW_W",_nomesql  && ERASMO - 29/04/2016
		
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
			*IF _nLogSqlDeltaSeconds >= 1  &&SERGIO/ERASMO ??????????????????
			*IF _nLogSqlDeltaSeconds >= 0.2
			IF _nLogSqlDeltaSeconds >= PUB_NSECMIN_LOGSQL  && ERASMO - 10/03/2023
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
		
		*DO BlackBox WITH "",_nomesql,"EXECRW_I",_nomecur  && ERASMO - 17/04/2013
		DO BlackBox WITH _stringsql,_nomesql,"EXECRW_I",_nomecur  && ERASMO - 29/04/2016
		_OK_BlackBoxExecCommand = .F.  && ERASMO - 29/04/2016
		
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



*********************************************************************************************
FUNCTION ExecPreparedCommand
*********************************************************************************************
*PARAMETERS _stringsql,_nomesql
**=> ERASMO - INIZIO 20/01/2015
PARAMETERS _stringsql,_nomesql,_canstop,_NomeVarStopped

IF PCOUNT() >= 3
ELSE
	_canstop = .F.
ENDIF
**=> ERASMO - FINE 20/01/2015

**=> ERASMO - INIZIO 25/03/2015
IF PCOUNT() >= 4
ELSE
	_NomeVarStopped = ""
ENDIF
**=> ERASMO - FINE 25/03/2015

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

*!*	= SQLPREPARE(pub_sqlhd, _stringsql,_nomesql)
*!*	_RT=SQLEXEC(pub_sqlhd)
*!*	IF _RT < 0
*!*		=MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
*!*	*	SQLDISCONNECT(pub_sqlhd)
*!*	*	pub_sqlhd=0
*!*		RETURN(.f.)
*!*	ENDIF

**=> ERASMO - INIZIO 20/01/2015
IF _canstop
	
*!*		IF TYPE("_SCREEN.AqVerificaAlert1") == 'O'
*!*			_OLD_AqVerificaAlert_Interval = _SCREEN.AqVerificaAlert1.Interval
*!*			_SCREEN.AqVerificaAlert1.Interval = 0
*!*		ENDIF
	
	PUB_ABILITA_AqVerificaAlert = .F.  && ERASMO - 12/03/2015
	
	LOCAL _OLD_AsynchronousMode		&& ERASMO - 12/03/2015
	_OLD_AsynchronousMode = .F.		&& ERASMO - 12/03/2015
	_OLD_AsynchronousMode = SQLGETPROP(pub_sqlhd, 'Asynchronous')
	SQLSETPROP(pub_sqlhd, 'Asynchronous', .T.)   && To stop SQLEXEC( )
	
	_RT = 0
	
	*_STOPPED = .F.
	*DO FORM FORM\SQLEXECUTION_CANSTOP WITH .T.
	**=> ERASMO - INIZIO 25/03/2015
	DO FORM FORM\SQLEXECUTION_CANSTOP WITH .T.,_NomeVarStopped
	**=> ERASMO - FINE 25/03/2015
	
	SQLSETPROP(pub_sqlhd, 'Asynchronous', _OLD_AsynchronousMode)
	
*!*		IF TYPE("_SCREEN.AqVerificaAlert1") == 'O'
*!*			_SCREEN.AqVerificaAlert1.Interval = _OLD_AqVerificaAlert_Interval
*!*		ENDIF

	PUB_ABILITA_AqVerificaAlert = .T.  && ERASMO - 12/03/2015
	
	IF _RT < 0
		MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
		RETURN(.f.)
	ENDIF
	
ELSE

	= SQLPREPARE(pub_sqlhd, _stringsql,_nomesql)
	*_RT=SQLEXEC(pub_sqlhd)
	_RT=SQLEXEC(pub_sqlhd, _stringsql,_nomesql)
	IF _RT < 0
		=MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
	*	SQLDISCONNECT(pub_sqlhd)
	*	pub_sqlhd=0
		RETURN(.f.)
	ENDIF

ENDIF
**=> ERASMO - FINE 20/01/2015

**=> ERASMO - INIZIO 12/02/2013
IF TYPE("PUB_LOGSQL") == 'L' AND PUB_LOGSQL AND _nomesql <> 'LOGSQL'
	_nLogSqlSecondsFin = SECONDS()
	_nLogSqlDeltaSeconds = _nLogSqlSecondsFin - _nLogSqlSecondsIni
	*IF _nLogSqlDeltaSeconds >= 1  &&SERGIO/ERASMO ??????????????????
	*IF _nLogSqlDeltaSeconds >= 0.2
	IF _nLogSqlDeltaSeconds >= PUB_NSECMIN_LOGSQL  && ERASMO - 10/03/2023
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
FUNCTION ExecQueryFile
*********************************************************************************************
PARAMETERS _sqlQueryFile,_nomesql

LOCAL 	gnFileHandle,;
		nSize,;
		_stringsql

IF pub_sqlhd < 1
	IF !ExecConnect()
	  return(.f.)
	ENDIF 
ENDIF

_stringsql=""

IF FILE(_sqlQueryFile) && Esiste il file? 

	gnFileHandle = FOPEN(_sqlQueryFile)
	* Seek to end of file to determine the number of bytes in the file
	nSize =  FSEEK(gnFileHandle, 0, 2)     && Move pointer to EOF
	IF nSize <= 0
		* If the file is empty, display an error message
		MESSAGEBOX("Il file "+ALLTRIM(_sqlQueryFile)+" e' vuoto o non valido.",48,"Attenzione!")
		RETURN(.f.)
	ELSE
		* If file is not empty, the program stores its contents
		* in memory, then displays the text on the main Visual FoxPro window
		= FSEEK(gnFileHandle, 0, 0)      && Move pointer to BOF
		_stringsql= FREAD(gnFileHandle, nSize)
	ENDIF
	= FCLOSE(gnFileHandle)         && Close the file
ELSE 	
	 MESSAGEBOX("Il file "+ALLTRIM(_sqlQueryFile)+" non esiste.",48,"Attenzione!")
	 RETURN(.f.)
ENDIF

_stringsql = STRTRAN(_stringsql,CHR(10)+'GO',"")  && ERASMO - 03/01/2012

= SQLPREPARE(pub_sqlhd, _stringsql,_nomesql)
_RT=SQLEXEC(pub_sqlhd)
IF _RT < 0
	=MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
*	SQLDISCONNECT(pub_sqlhd)
*	pub_sqlhd=0
	RETURN(.f.)
ENDIF 
RETURN(.t.)

*********************************************************************************************
* Eof FUNCTION ExecQueryFile
*********************************************************************************************


*********************************************************************************************
* Begin PROCEDURE InitializeStringsql
*********************************************************************************************
PROCEDURE InitializeStringsqlFromDbsocieta
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
         _RISP = MESSAGEBOX("File DBSOCIETA.DBF vuoto" + CHR(13) + CHR(13) + "Aprire l'utilità di configurazione del DBSOCIETA?",64+4,"Attenzione")
         IF _RISP = 6
            IF USED("DBSOCIETA")
               SELECT DBSOCIETA
               USE
            ENDIF
            DO CONFIGURA_DBSOCIETA
            LOOP
         ELSE
            MESSAGEBOX("File DBSOCIETA.DBF vuoto per lo startup di Aquarius su questa postazione",16,"*** ATTENZIONE ***")
            QUIT
         ENDIF
      ELSE
      	SELECT TOP 1 * FROM DBSOCIETA ORDER BY CODICE INTO CURSOR TMPDBSOC
       	SELECT TMPDBSOC
       	GO TOP
       	&_cString_name = ALLTRIM(NOMEDB)
       	USE
       	EXIT
       ENDIF
   ELSE
      _RISP = MESSAGEBOX("File DBSOCIETA.DBF inesistente" + CHR(13) + CHR(13) + "Aprire l'utilità di configurazione del DBSOCIETA?",64+4,"Attenzione")
      IF _RISP = 6
         IF USED("DBSOCIETA")
            SELECT DBSOCIETA
            USE
         ENDIF
         DO CONFIGURA_DBSOCIETA
         LOOP
      ELSE
         MESSAGEBOX("File DBSOCIETA.DBF inesistente per lo startup di Aquarius su questa postazione",16,"*** ATTENZIONE ***")
         QUIT
      ENDIF
   ENDIF
ENDDO
   
RETURN
*********************************************************************************************
* End PROCEDURE InitializeStringsql
*********************************************************************************************

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

*!*	iiSql=""     
*!*	iiNomeCursorSql="LOGSQL"
*!*	TEXT TO iiSql NOSHOW
*!*		INSERT INTO LOGSQL (
*!*			CODOPE,
*!*			NOMOPE,
*!*			WORKSTAT,
*!*			CSQL,
*!*			MainTableNames,
*!*			WhereCondFields,
*!*			CallStackLevel,
*!*			CurrentProgramFilename,
*!*			ModuleOrObjectName,
*!*			ModuleOrObjectSourceFilename,
*!*			LineNumberObjectSourceFile,
*!*			SourceLineContents,
*!*			Time)
*!*		VALUES (
*!*			'<<_LOGSQL_CODOPE>>',
*!*			'<<_LOGSQL_NOMOPE>>',
*!*			'<<_LOGSQL_WORKSTAT>>',
*!*			'<<STRTRAN(_LOGSQL_CSQL,"'","''")>>',
*!*			'<<_LOGSQL_MainTableNames>>',		
*!*			'<<STRTRAN(_LOGSQL_WhereCondFields,"'","''")>>',
*!*			<<_LOGSQL_CallStackLevel>>,
*!*			'<<_LOGSQL_CurrentProgramFilename>>',
*!*			'<<_LOGSQL_ModuleOrObjectName>>',
*!*			'<<_LOGSQL_ModuleOrObjectSourceFilename>>',
*!*			<<_LOGSQL_LineNumberObjectSourceFile>>,
*!*			'<<STRTRAN(_LOGSQL_SourceLineContents,"'","''")>>',
*!*			<<STRTRAN(STR(_LOGSQL_TIME,20,3),",",".")>>)
*!*	ENDTEXT

**=> ERASMO - INIZIO 06/03/2018
*** TRONCAMENTO VARIABILI TROPPO LUNGHE PER LA TABELLA LOGSQL
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
		'<<SUBSTR(_LOGSQL_CODOPE,1,20)>>',
		'<<SUBSTR(_LOGSQL_NOMOPE,1,25)>>',
		'<<SUBSTR(_LOGSQL_WORKSTAT,1,100)>>',
		'<<STRTRAN(_LOGSQL_CSQL,"'","''")>>',
		'<<SUBSTR(_LOGSQL_MainTableNames,1,254)>>',		
		'<<SUBSTR(STRTRAN(_LOGSQL_WhereCondFields,"'","''"),1,254)>>',
		<<_LOGSQL_CallStackLevel>>,
		'<<SUBSTR(_LOGSQL_CurrentProgramFilename,1,254)>>',
		'<<SUBSTR(_LOGSQL_ModuleOrObjectName,1,254)>>',
		'<<SUBSTR(_LOGSQL_ModuleOrObjectSourceFilename,1,254)>>',
		<<_LOGSQL_LineNumberObjectSourceFile>>,
		'<<SUBSTR(STRTRAN(_LOGSQL_SourceLineContents,"'","''"),1,254)>>',
		<<STRTRAN(STR(_LOGSQL_TIME,20,3),",",".")>>)
ENDTEXT
**=> ERASMO - FINE 06/03/2018

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
PARAMETERS _par_SqlClause, _par_SqlString, _par_NomeVarStringaRit

IF PCOUNT() > 1
ELSE
	_par_SqlString = _LOGSQL_CSQL
ENDIF

**=> ERASMO - INIZIO 29/04/2016
IF PCOUNT() >= 3
ELSE
	_par_NomeVarStringaRit = "_LOGSQL_MainTableNames"
ENDIF
**=> ERASMO - FINE 29/04/2016

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
	&_par_NomeVarStringaRit = &_par_NomeVarStringaRit + IIF(EMPTY(&_par_NomeVarStringaRit),""," ; ") + _cTableName
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

**=> ERASMO - INIZIO 25/03/2019
*** ESCLUDO DALL'ELABORAZIONE BLACKBOX TUTTI GLI EVENTUALI FORM CHIAMANTI APPOSITAMENTE IMPOSTATI COME DA ESCLUDERE NELLO SPECIFICO PARAMETRO DI SISTEMA
_BlackBox_CallingFormFileName = ""
ASTACKINFO(AStackInfoBlackBox)
_nStackLevels = ALEN(AStackInfoBlackBox, 1)
FOR _nLevel = (_nStackLevels - 1) TO 1 STEP -1
	_CurrentProgramFilename = ALLTRIM(AStackInfoBlackBox(_nLevel,2))
	IF FILE(_CurrentProgramFilename) AND UPPER(JUSTEXT(_CurrentProgramFilename)) == "SCT"
		_BlackBox_CallingFormFileName = _CurrentProgramFilename
		EXIT
	ENDIF
NEXT

IF !EMPTY(PUB_ESCLFORMBLBX) AND !EMPTY(_BlackBox_CallingFormFileName) AND UPPER(JUSTSTEM(JUSTFNAME(_BlackBox_CallingFormFileName))) $ UPPER(PUB_ESCLFORMBLBX)
	SELECT(_Before_BlackBox_ALIAS)
	RETURN .F.
ENDIF
**=> ERASMO - FINE 25/03/2019

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
*_BlackBox_CallingFormFileName = ""
_BlackBox_Note = _par_note
_BlackBox_CSQL = ALLTRIM(_par_stringsql)

*!*	ASTACKINFO(AStackInfoBlackBox)
*!*	_nStackLevels = ALEN(AStackInfoBlackBox, 1)
*!*	FOR _nLevel = (_nStackLevels - 1) TO 1 STEP -1
*!*		_CurrentProgramFilename = ALLTRIM(AStackInfoBlackBox(_nLevel,2))
*!*		IF FILE(_CurrentProgramFilename) AND UPPER(JUSTEXT(_CurrentProgramFilename)) == "SCT"
*!*			_BlackBox_CallingFormFileName = _CurrentProgramFilename
*!*			EXIT
*!*		ENDIF
*!*	NEXT

*_BlackBox_PrevFieldsValues = ""
*_BlackBox_FieldsValues = ""

IF USED("TEMP_ELENCO_X_BlackBox")
	SELECT TEMP_ELENCO_X_BlackBox
	USE
ENDIF

**=> ERASMO - INIZIO 29/04/2016
LOCAL _set_deleted_status
_set_deleted_status = SET("DELETED")
SET DELETED OFF  && DEVO CONSIDERARE ANCHE LE RIGHE CONTRASSEGNATE COME ELIMINATE PER POTERLE TRACCIARE SULLA BLACKBOX
**=> ERASMO - FINE 29/04/2016

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

	_BlackBox_PrevFieldsValues = ""  && ERASMO - 29/04/2016
	_BlackBox_FieldsValues = ""  && ERASMO - 29/04/2016
	
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
		SET DELETED &_set_deleted_status  && ERASMO - 29/04/2016
		RETURN .F.
	ENDIF
	
	IF USED("Prev_BlackBox")
		SELECT Prev_BlackBox
		USE
	ENDIF
	ssSql=""
	ssNomeCursorSql="Prev_BlackBox"
	TEXT TO ssSql NOSHOW
		SELECT * FROM <<_BlackBox_MainTableName>> WHERE <<_BlackBox_WhereCondKey>>
	ENDTEXT
	IF !ExecPreparedCommand(ssSql,ssNomeCursorSql)
		SET DELETED &_set_deleted_status  && ERASMO - 29/04/2016
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
		*IF TYPE(_cNOME_CAMPO) <> "U"
		*	_uVALORE_CAMPO = &_cNOME_CAMPO
		*	_BlackBox_FieldsValues = _BlackBox_FieldsValues + ;
		*		IIF(!EMPTY(_cDESC_CAMPO),_cDESC_CAMPO + SPACE(1),"") + ;
		*		"[" + _cNOME_CAMPO + "]: " + ;
		*		RTRIM(TRANSFORM(_uVALORE_CAMPO))			
		*ENDIF
		**=> ERASMO - INIZIO 29/04/2016
		*** TRACCIO IL VALORE ATTUALE SOLO SE LA RIGA NON E' STATA CONTRASSEGNATA COME "DELETED"
		IF TYPE(_cNOME_CAMPO) <> "U"
			_uVALORE_CAMPO = &_cNOME_CAMPO
			IF DELETED()
				_uVALORE_CAMPO = "DELETED"
			ENDIF
			_BlackBox_FieldsValues = _BlackBox_FieldsValues + ;
				IIF(!EMPTY(_cDESC_CAMPO),_cDESC_CAMPO + SPACE(1),"") + ;
				"[" + _cNOME_CAMPO + "]: " + ;
				RTRIM(TRANSFORM(_uVALORE_CAMPO))			
		ENDIF
		**=> ERASMO - FINE 29/04/2016	
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
		SET DELETED &_set_deleted_status  && ERASMO - 29/04/2016
		return(.F.)
	ENDIF
	
	*_BlackBox_FieldsValues = ""
	
	SELECT &_par_nomecur
	SKIP +1
ENDDO

SET DELETED &_set_deleted_status  && ERASMO - 29/04/2016

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



**=> ERASMO - INIZIO 29/04/2016
*********************************************************************************************
* Begin PROCEDURE BlackBoxExecCommand
*********************************************************************************************
PROCEDURE BlackBoxExecCommand
*********************************************************************************************
PARAMETERS _par_before_after,_par_stringsql,_par_nomesql,_par_nomecur_before

*=BlackBoxExecCommand("BEFORE",_stringsql,_nomesql)
*=BlackBoxExecCommand("AFTER",_stringsql,_nomesql,_nomecur_BEFORE_BlackBoxExecCommand)

IF PCOUNT() >= 3
ELSE
	RETURN ""
ENDIF

_par_stringsql = UPPER(ALLTRIM(_par_stringsql))  && ERASMO - 14/03/2019

IF PCOUNT() >= 4
ELSE
	_par_nomecur_before = ""
ENDIF

_Before_BlackBoxExecCommand_ALIAS = SELECT()

IF EMPTY(_par_stringsql) OR EMPTY(_par_nomesql)
	SELECT(_Before_BlackBoxExecCommand_ALIAS)
	RETURN ""
ENDIF

**=> ERASMO - INIZIO 25/03/2019
*** ESCLUDO DALL'ELABORAZIONE BLACKBOX TUTTI GLI EVENTUALI FORM CHIAMANTI APPOSITAMENTE IMPOSTATI COME DA ESCLUDERE NELLO SPECIFICO PARAMETRO DI SISTEMA
_BlackBoxExecCommand_CallingFormFileName = ""
ASTACKINFO(AStackInfoBlackBoxExecCommand)
_nStackLevels = ALEN(AStackInfoBlackBoxExecCommand, 1)
FOR _nLevel = (_nStackLevels - 1) TO 1 STEP -1
	_CurrentProgramFilename = ALLTRIM(AStackInfoBlackBoxExecCommand(_nLevel,2))
	IF FILE(_CurrentProgramFilename) AND UPPER(JUSTEXT(_CurrentProgramFilename)) == "SCT"
		_BlackBoxExecCommand_CallingFormFileName = _CurrentProgramFilename
		EXIT
	ENDIF
NEXT

IF !EMPTY(PUB_ESCLFORMBLBX) AND !EMPTY(_BlackBoxExecCommand_CallingFormFileName) AND UPPER(JUSTSTEM(JUSTFNAME(_BlackBoxExecCommand_CallingFormFileName))) $ UPPER(PUB_ESCLFORMBLBX)
	SELECT(_Before_BlackBoxExecCommand_ALIAS)
	RETURN ""
ENDIF
**=> ERASMO - FINE 25/03/2019

*** SE NON ANCORA CREATO, CREO IL CURSORE PUBBLICO PER LA VERIFICA DELLE TABELLE DI CUI CREARE IL LOG
IF !USED("PUB_ELENCO_X_BlackBox")
	DO Crea_PUB_ELENCO_X_BLACKBOX
ENDIF

*** DETERMINO IL NOME DELLA TABELLA SQL
_BlackBoxExecCommand_MainTableName = ""
DO FindLeftDelimitedTableName WITH "DELETE FROM ", _par_stringsql, "_BlackBoxExecCommand_MainTableName"
IF EMPTY(_BlackBoxExecCommand_MainTableName) OR ';' $ _BlackBoxExecCommand_MainTableName
	DO FindLeftDelimitedTableName WITH "DELETE ", _par_stringsql, "_BlackBoxExecCommand_MainTableName"
	IF EMPTY(_BlackBoxExecCommand_MainTableName) OR ';' $ _BlackBoxExecCommand_MainTableName
		DO FindLeftDelimitedTableName WITH "UPDATE ", _par_stringsql, "_BlackBoxExecCommand_MainTableName"
		IF EMPTY(_BlackBoxExecCommand_MainTableName) OR ';' $ _BlackBoxExecCommand_MainTableName
			_BlackBoxExecCommand_MainTableName = ""
			SELECT(_Before_BlackBoxExecCommand_ALIAS)
			RETURN ""
		ENDIF
	ENDIF
ENDIF

*** VERIFICO SE DEVO CREARE IL LOG PER LA TABELLA IN LINEA
SELECT PUB_ELENCO_X_BlackBox
SET ORDER TO I_TABNAME
GO TOP
SEEK UPPER(ALLTRIM(_BlackBoxExecCommand_MainTableName))
IF !FOUND()
	SELECT(_Before_BlackBoxExecCommand_ALIAS)
	RETURN ""
ENDIF

IF _par_before_after = "BEFORE"

	*** CREAZIONE CURSORE CONTENENTE I RECORD DELLA TABELLA NELLO STATO APPENA PRECEDENTE L'ESECUZIONE DELL' ExecCommand
	LOCAL iiSql,iiNomeCursorSql  && ERASMO - 14/03/2019
	iiSql="SELECT * FROM " + _BlackBoxExecCommand_MainTableName + " " + ALLTRIM(SUBSTR(_par_stringsql,AT("WHERE",_par_stringsql,1)))
	iiNomeCursorSql="nomecur_before" + SYS(2015)
	IF !ExecPreparedCommand(iiSql,iiNomeCursorSql)
		SET DELETED &_set_deleted_status
		RETURN ""
	ENDIF
	SELECT &iiNomeCursorSql
	GO TOP
	IF !EOF()
		SELECT(_Before_BlackBoxExecCommand_ALIAS)
		RETURN iiNomeCursorSql
	ELSE
		SELECT(_Before_BlackBoxExecCommand_ALIAS)
		RETURN ""
	ENDIF
	
ENDIF

IF _par_before_after = "AFTER"
	IF EMPTY(_par_nomecur_before)
		SELECT(_Before_BlackBoxExecCommand_ALIAS)
		RETURN ""
	ENDIF
	IF !USED(_par_nomecur_before)
		SELECT(_Before_BlackBoxExecCommand_ALIAS)
		RETURN ""
	ENDIF
ELSE
	SELECT(_Before_BlackBoxExecCommand_ALIAS)
	RETURN ""
ENDIF

_BlackBoxExecCommand_CODOPE = IIF(TYPE("PUB_CODOPE")=='C',ALLTRIM(PUB_CODOPE),"")
_BlackBoxExecCommand_NOMOPE = IIF(TYPE("PUB_NOMOPE")=='C',ALLTRIM(PUB_NOMOPE),"")
_BlackBoxExecCommand_WORKSTAT = SYS(0)
_BlackBoxExecCommand_EXECTYPE = "EXECCOMMAND"
*!*	_BlackBoxExecCommand_CallingFormFileName = ""
_BlackBoxExecCommand_Note = ""
_BlackBoxExecCommand_CSQL = ALLTRIM(_par_stringsql)

*!*	ASTACKINFO(AStackInfoBlackBoxExecCommand)
*!*	_nStackLevels = ALEN(AStackInfoBlackBoxExecCommand, 1)
*!*	FOR _nLevel = (_nStackLevels - 1) TO 1 STEP -1
*!*		_CurrentProgramFilename = ALLTRIM(AStackInfoBlackBoxExecCommand(_nLevel,2))
*!*		IF FILE(_CurrentProgramFilename) AND UPPER(JUSTEXT(_CurrentProgramFilename)) == "SCT"
*!*			_BlackBoxExecCommand_CallingFormFileName = _CurrentProgramFilename
*!*			EXIT
*!*		ENDIF
*!*	NEXT

IF USED("TEMP_ELENCO_X_BlackBoxExecCommand")
	SELECT TEMP_ELENCO_X_BlackBoxExecCommand
	USE
ENDIF

LOCAL _set_deleted_status
_set_deleted_status = SET("DELETED")
SET DELETED OFF

SELECT &_par_nomecur_before
GO TOP

SELECT * FROM PUB_ELENCO_X_BlackBox ;
WHERE UPPER(ALLTRIM(NOME_TAB)) == UPPER(ALLTRIM(_BlackBoxExecCommand_MainTableName)) ;
ORDER BY SEQUEN ;
INTO CURSOR TEMP_ELENCO_X_BlackBoxExecCommand

SELECT TEMP_ELENCO_X_BlackBoxExecCommand
GO TOP
_BlackBoxExecCommand_MainTableDescr = ALLTRIM(DESC_TAB)

SELECT &_par_nomecur_before
DO WHILE !EOF()

	_BlackBoxExecCommand_PrevFieldsValues = ""
	_BlackBoxExecCommand_FieldsValues = ""

	*** CREAZIONE CONTENUTO DEL CAMPO MEMO PrevFieldsValues (SITUAZIONE PRECEDENTE)
	SELECT TEMP_ELENCO_X_BlackBoxExecCommand
	GO TOP
	SCAN
		IF EMPTY(_BlackBoxExecCommand_PrevFieldsValues)
		ELSE
			_BlackBoxExecCommand_PrevFieldsValues = _BlackBoxExecCommand_PrevFieldsValues + '|'
		ENDIF
		_cNOME_TAB = ALLTRIM(NOME_TAB)
		_cNOME_CAMPO = ALLTRIM(NOME_CAMPO)
		_cDESC_CAMPO = ALLTRIM(DESC_CAMPO)
		SELECT &_par_nomecur_before
		IF TYPE(_cNOME_CAMPO) <> "U"
			_uVALORE_CAMPO = &_cNOME_CAMPO
			_BlackBoxExecCommand_PrevFieldsValues = _BlackBoxExecCommand_PrevFieldsValues + ;
				IIF(!EMPTY(_cDESC_CAMPO),_cDESC_CAMPO + SPACE(1),"") + ;
				"[" + _cNOME_CAMPO + "]: " + ;
				RTRIM(TRANSFORM(_uVALORE_CAMPO))			
		ENDIF
	ENDSCAN
	
	
	*** ACCESSO ALLA TABELLA SQL PER LA CREAZIONE CONTENUTO DEL CAMPO MEMO FieldsValues (SITUAZIONE SUCCESSIVA)
	_BlackBoxExecCommand_WhereCondKey = ""
	SELECT TEMP_ELENCO_X_BlackBoxExecCommand
	GO TOP
	SCAN
		IF !FLG_CHIAVE
			LOOP
		ENDIF
		_cNOME_CAMPO = ALLTRIM(NOME_CAMPO)
		SELECT &_par_nomecur_before
		IF TYPE(_cNOME_CAMPO) <> "U"
			_uVALORE_CAMPO = &_cNOME_CAMPO
			IF EMPTY(TRANSFORM(_uVALORE_CAMPO))  && SE LA CHIAVE UNIVOCA CONFIGURATA, CONTENUTA NEL CURSORE PASSATO, NON E' SIGNIFICATIVA, ALLORA NON POSSO CONTINUARE
				_BlackBoxExecCommand_WhereCondKey = ""
				EXIT
			ENDIF
			_BlackBoxExecCommand_WhereCondKey = _BlackBoxExecCommand_WhereCondKey + IIF(!EMPTY(_BlackBoxExecCommand_WhereCondKey)," AND ","") + ALLTRIM(_cNOME_CAMPO) + " = '" + RTRIM(TRANSFORM(_uVALORE_CAMPO)) + "'"
		ENDIF		
	ENDSCAN
	IF EMPTY(_BlackBoxExecCommand_WhereCondKey)  && CHIAVE UNIVOCA NON CONFIGURATA CORRETTAMENTE
		SELECT(_Before_BlackBoxExecCommand_ALIAS)
		SET DELETED &_set_deleted_status
		RETURN ""
	ENDIF
	
	IF USED("Succ_BlackBoxExecCommand")
		SELECT Succ_BlackBoxExecCommand
		USE
	ENDIF
	ssSql=""
	ssNomeCursorSql="Succ_BlackBoxExecCommand"
	TEXT TO ssSql NOSHOW
		SELECT * FROM <<_BlackBoxExecCommand_MainTableName>> WHERE <<_BlackBoxExecCommand_WhereCondKey>>
	ENDTEXT
	IF !ExecPreparedCommand(ssSql,ssNomeCursorSql)
		SET DELETED &_set_deleted_status
		RETURN ""
	ENDIF
	SELECT Succ_BlackBoxExecCommand
	GO TOP
	IF EOF()  && STATO SUCCESSIVO RECORD NON TROVATO -> BISOGNA DI MEMORIZZARE NELLA RIGA DI LOG TUTTI I VALORI COME "DELETED"
		SELECT TEMP_ELENCO_X_BlackBoxExecCommand
		GO TOP
		SCAN
			IF EMPTY(_BlackBoxExecCommand_FieldsValues)
			ELSE
				_BlackBoxExecCommand_FieldsValues = _BlackBoxExecCommand_FieldsValues + '|'
			ENDIF
			_cNOME_TAB = ALLTRIM(NOME_TAB)
			_cNOME_CAMPO = ALLTRIM(NOME_CAMPO)
			_cDESC_CAMPO = ALLTRIM(DESC_CAMPO)
			SELECT &_par_nomecur_before
			*** TRACCIO IL VALORE ATTUALE LA RIGA COME "DELETED"
			IF TYPE(_cNOME_CAMPO) <> "U"
				_uVALORE_CAMPO = "DELETED"
				_BlackBoxExecCommand_FieldsValues = _BlackBoxExecCommand_FieldsValues + ;
					IIF(!EMPTY(_cDESC_CAMPO),_cDESC_CAMPO + SPACE(1),"") + ;
					"[" + _cNOME_CAMPO + "]: " + ;
					RTRIM(TRANSFORM(_uVALORE_CAMPO))			
			ENDIF
		ENDSCAN
	ELSE
		IF RECCOUNT() > 1  && TROVATE TROPPE RIGHE CORRISPONDENTI --> LA CHIAVE NON E' UNIVOCA O NON E' CONFIGURATA CORRETTAMENTE
			SELECT &_par_nomecur_before
			SKIP +1
			LOOP
		ENDIF
		
		*** CREAZIONE CONTENUTO DEL CAMPO MEMO FieldsValues (SITUAZIONE SUCCESSIVA)
		SELECT TEMP_ELENCO_X_BlackBoxExecCommand
		GO TOP
		SCAN
			IF EMPTY(_BlackBoxExecCommand_FieldsValues)
			ELSE
				_BlackBoxExecCommand_FieldsValues = _BlackBoxExecCommand_FieldsValues + '|'
			ENDIF
			_cNOME_TAB = ALLTRIM(NOME_TAB)
			_cNOME_CAMPO = ALLTRIM(NOME_CAMPO)
			_cDESC_CAMPO = ALLTRIM(DESC_CAMPO)
			SELECT Succ_BlackBoxExecCommand
			IF TYPE(_cNOME_CAMPO) <> "U"
				_uVALORE_CAMPO = &_cNOME_CAMPO
				_BlackBoxExecCommand_FieldsValues = _BlackBoxExecCommand_FieldsValues + ;
					IIF(!EMPTY(_cDESC_CAMPO),_cDESC_CAMPO + SPACE(1),"") + ;
					"[" + _cNOME_CAMPO + "]: " + ;
					RTRIM(TRANSFORM(_uVALORE_CAMPO))
			ENDIF
		ENDSCAN
		SELECT Succ_BlackBoxExecCommand
		USE
	ENDIF
	
	IF ALLTRIM(_BlackBoxExecCommand_PrevFieldsValues) == ALLTRIM(_BlackBoxExecCommand_FieldsValues)
		SELECT &_par_nomecur_before
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
			'<<_BlackBoxExecCommand_CODOPE>>',
			'<<_BlackBoxExecCommand_NOMOPE>>',
			'<<_BlackBoxExecCommand_WORKSTAT>>',
			'<<_BlackBoxExecCommand_EXECTYPE>>',
			'<<STRTRAN(_BlackBoxExecCommand_CSQL,"'","''")>>',
			'<<_BlackBoxExecCommand_CallingFormFileName>>',
			'<<_BlackBoxExecCommand_MainTableName>>',
			'<<STRTRAN(_BlackBoxExecCommand_MainTableDescr,"'","''")>>',
			'<<STRTRAN(_BlackBoxExecCommand_WhereCondKey,"'","''")>>',
			'<<STRTRAN(_BlackBoxExecCommand_PrevFieldsValues,"'","''")>>',
			'<<STRTRAN(_BlackBoxExecCommand_FieldsValues,"'","''")>>',
			'<<STRTRAN(_BlackBoxExecCommand_Note,"'","''")>>')
	ENDTEXT

	IF !ExecPreparedCommand(iiSql,iiNomeCursorSql)
		SET DELETED &_set_deleted_status
		return(.F.)
	ENDIF
	
	SELECT &_par_nomecur_before
	SKIP +1
ENDDO

SET DELETED &_set_deleted_status

SELECT TEMP_ELENCO_X_BlackBoxExecCommand
USE

SELECT(_Before_BlackBoxExecCommand_ALIAS)
   
RETURN _par_nomecur_before
*********************************************************************************************
* End PROCEDURE BlackBoxExecCommand
*********************************************************************************************
