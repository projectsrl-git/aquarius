
*!*	##############################################################################################################
  
					**********************************************************************************************
					***         PROJECT SRL - LIBRERIA COMUNE DI TUTTE LE LIBRERIE PER                         ***
					***                       LA GESTIONE DI AQ_ADMIN                                          ***
					***                                                                                        ***
					**********************************************************************************************

*!*	##############################################################################################################
  




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

PARAMETERS _stringsql,_nomesql,_canstop,_NomeVarStopped

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


***************************************************************************
* Funzione - CERCAMENUUTENTE   Data: 17.09.2004   Autore: Project - Cougar
***************************************************************************
*
*  Cerca nella stringa estratta da UTENTI nella tabella TBL_MENU 
*  se è presente l'utente corrente.
*  
*  Sintassi: CERCAMENUUTENTE( campoUtenti, utenteCorrente )
*  Parametro: Carattere, Carattere
*  Ritorna:   Boolean
*
*  Se trova l'utente la funzione restituisce .T.
*  Se non la trova restituisce .F.
*
*  (LOGICO No?, ndr)
*
*  Esempio:
*  SELECT TBL_MENU
*  XXX = CERCAMENUUTENTE( UTENTI, PUB_CODOPE )
*
***************************************************************************
FUNCTION CERCAMENUUTENTE
***************************************************************************
PARAMETERS campoUtenti, utenteCorrente

myFlag = .F.
inFlag = .F.
myCont = 0

DO WHILE !inFlag
	XXX = STR_EXTRACT( campoUtenti, ".", 3 + myCont )
	IF XXX = utenteCorrente
		myFlag = .T.
		inFlag = .T.
	ELSE
		IF XXX = ""
			inFlag = .T.
		ELSE
			myCont = myCont + 1
		ENDIF
	ENDIF
ENDDO

RETURN myFlag


****************************************
FUNCTION UNDEF_VIP000
****************************************
** DEFINISCE IL CURSORE PER LA GESTIONE DEI PAGAMENTI

IF USED("cur_fornitori")
	SELECT cur_fornitori 
	USE	
ENDIF

IF USED("CUR_PIANOP")
	SELECT CUR_PIANOP 
	USE	
ENDIF

IF USED("CUR_CONGELATO")
	SELECT CUR_CONGELATO
	USE	
ENDIF

IF USED("SALDI_APERTI_CHIUSI")
	SELECT SALDI_APERTI_CHIUSI
	USE	
ENDIF

IF USED("SCADE")
	SELECT SCADE
	USE	
ENDIF

IF USED("CSALDI_PARTITE")
	SELECT CSALDI_PARTITE 
	USE	
ENDIF


****************************************


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
	(RAGSOC C(30),CONTABILITA_PREVISIONALE C(1),NPART N(10,0), DTREG C(10), NREG C(08), TIPODOC C(10), NUMDOC C(7), DTDOC C(10), DTSCAD C(10), CPA C(03), ;
	 VALUTA C(3), DARE C(15),AVEREX C(15), NUMPRO C(4), DESMOV C(50),DESMOV1 C(50),NPARTO N(10,0), CAMBIO N(15,10), ;
	 IMPVAL N(11,4),NDARE N(17,3),NAVERE N(17,3),NSALDO N(17,3),INDICE C(30),NFAT C(08),V_SALDO C(15), ;
	 ANNOK C(04), NPROGK N(5,0), CODFOR C(10), dtscade d(8),   ;
	 COSATRATTA C(5),GRADOIMPORTANZA C(5),FORMAPAGAMENTO C(5),TIPOCONTRATTO C(5),CODACQ C(3),PRIPAGA C(4),TIPOPA C(3), BLOCCO L, STORIA M)

INDEX ON VAL(INDICE) 			TAG DTREG 
INDEX ON RIBALTA2(DTDOC)+NUMDOC TAG DOCUM
SET ORDER TO DTREG

IF USED("CUR_CONGELATO")
	SELECT CUR_CONGELATO
	USE	
ENDIF

CREATE CURSOR CUR_CONGELATO ;
	(RAGSOC C(30),CONTABILITA_PREVISIONALE C(1),NPART N(10,0), DTREG C(10), NREG C(08), TIPODOC C(10), NUMDOC C(7), DTDOC C(10), DTSCAD C(10), CPA C(03), ;
	 VALUTA C(3), DARE C(15),AVEREX C(15), NUMPRO C(4), DESMOV C(50),DESMOV1 C(50),NPARTO N(10,0), CAMBIO N(15,10), ;
	 IMPVAL N(11,4),NDARE N(17,3),NAVERE N(17,3),NSALDO N(17,3),INDICE C(30),NFAT C(08),V_SALDO C(15), ;
	 ANNOK C(04), NPROGK N(5,0), CODFOR C(10), dtscade d(8),INDIRI C(40),LOCALI C(40),DTUSOL C(4),NUMSOL N(3,0),GGESPOS N(14,0), CORPO Memo,   ;
	 COSATRATTA C(5),GRADOIMPORTANZA C(5),FORMAPAGAMENTO C(5),TIPOCONTRATTO C(5),CODACQ C(3),PRIPAGA C(4),TIPOPA C(3), BLOCCO L, STORIA M)

INDEX ON VAL(INDICE) 			TAG DTREG 
INDEX ON RIBALTA2(DTDOC)+NUMDOC TAG DOCUM
SET ORDER TO DTREG

IF USED("SALDI_APERTI_CHIUSI")
	SELECT SALDI_APERTI_CHIUSI
	USE	
ENDIF

*** FABIANO 17/03/2012 - FLAG_CONVERTITA 
*** FABIANO 20/05/2012 - AGGIUNTO COD_CONTO C(13)
CREATE CURSOR SALDI_APERTI_CHIUSI ;
	(RAGSOC C(30),CONTABILITA_PREVISIONALE C(1),NPART N(10,0), DTREG C(10), NREG C(08), TIPODOC C(10), NUMDOC C(7), DTDOC C(10), DTSCAD C(10), CPA C(03),MOVNUMPRO C(13), ;
	 VALUTA C(3), DARE C(15),AVEREX C(15), NUMPRO C(4), DESMOV C(50),DESMOV1 C(50),NPARTO N(10,0), CAMBIO N(15,10), ;
	 IMPVAL N(11,4),NDARE N(17,3),NAVERE N(17,3),NSALDO N(17,3),INDICE C(30),NFAT C(08),V_SALDO C(15), ;
	 ANNOK C(04), NPROGK N(5,0), CODFOR C(10), dtscade d(8),INDIRI C(40),LOCALI C(40),DTUSOL C(4),NUMSOL N(3,0),GGESPOS N(14,0), CORPO Memo,   ;
	 COSATRATTA C(5),GRADOIMPORTANZA C(5),FORMAPAGAMENTO C(5),TIPOCONTRATTO C(5),CODACQ C(3),PRIPAGA C(4),TIPOOPE C(3),FLAG_NATURA C(1),FLAG_RIBA C(1),DTPOSTRIBA C(10), SELEZIONE C(3),TIPOPA C(3), BLOCCO L, STORIA M,;
	 FLAG_CONVERTITA L, COD_CONTO C(13))  

INDEX ON ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0)) TAG NUMPART 
INDEX ON ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))+DTSCAD TAG DTREG 
INDEX ON RIBALTA2(DTDOC)+NUMDOC TAG DOCUM
SET ORDER TO DTREG

IF USED("SCADE")
	SELECT SCADE
	USE	
ENDIF

*** FABIANO 05/05/2013 - AGGUNTO AGENTE E TIPO PARTITA
CREATE CURSOR SCADE ;
	(RAGSOC C(30),CONTABILITA_PREVISIONALE C(1),NPART N(10,0), DTREG C(10), NREG C(08), TIPODOC C(10), NUMDOC C(7), DTDOC C(10), DTSCAD C(10), CPA C(03),MOVNUMPRO C(13), ;
	 VALUTA C(3), DARE C(15),AVEREX C(15), NUMPRO C(4), DESMOV C(50),DESMOV1 C(50),NPARTO N(10,0), CAMBIO N(15,10), ;
	 IMPVAL N(11,4),NDARE N(17,3),NAVERE N(17,3),NSALDO N(17,3),INDICE C(30),NFAT C(08),V_SALDO C(15), ;
	 ANNOK C(04), NPROGK N(5,0), CODFOR C(10), dtscade d(8),INDIRI C(40),LOCALI C(40),DTUSOL C(4),NUMSOL N(3,0),GGESPOS N(14,0), CORPO Memo, ;
	 COSATRATTA C(5),GRADOIMPORTANZA C(5),FORMAPAGAMENTO C(5),TIPOCONTRATTO C(5),CODACQ C(3),PRIPAGA C(4), BANCAFOR C(5), ANOMAX C(3),SYS_PARTI C(10) , KEY_UNIQUE C(36),;
	 TIPOOPE C(3),FLAG_NATURA C(1),FLAG_RIBA C(1),FLAG_RIBA_TOP C(1), FLAG_NOTAC_TOP C(1), FLAG_TRATTA_TOP C(1), DTPOSTRIBA C(10), SELEZIONE C(3),TIPOPA C(3), BLOCCO L, STORIA M, SHOW_PART L, COD_CONTO C(13), ;
	 PARTITA_APERTA L, INSOLUTO_NON_PAGATO L, BANCASOL C(5), DESBANCASOL C(20), IBANSOL Memo, CODAGE C(3), DESAGE C(50), CODTIPOPA C(3), DESTIPOPA C(50) )
	

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
	 tipopagam 			C(3),			;
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
	 NUMEROFATT			C(6),;
	 NAZIONE			C(3),;
	 FLG_PAGATO			L,;
	 PARZIALE			N(17,3),;
	 TAGGANCIO			C(32),;
	 DES_ANOMAL			C(100),;
	 FLG_CBI			L,;
	 BON_RIC			C(3),;
	 CPA				C(3),;
	 TIPOOPE C(3),FLAG_NATURA C(1),FLAG_RIBA C(1), DTPOSTRIBA C(10),TIPOPA C(3), BLOCCO L, STORIA M)	 




RETURN(.T.)



************************
FUNCTION DATA_AAAAMMGG
************************
PARA _DATA

IF _DATA = '  /  /    ' .OR. _DATA = SPACE(10) .OR. ;
   _DATA = '    /  /  ' .OR. EMPTY(_DATA)
   RETURN SPACE(10)
ELSE
   IF SUBSTR(_DATA,3,1) = '/'
      RETURN  RIBALTA2(_DATA)
   ENDIF
   RETURN  _DATA
ENDIF


************************
FUNCTION DATA_GGMMAAAA
************************
PARA _DATA

IF _DATA = '  /  /    ' .OR. _DATA = SPACE(10) .OR. ;
   _DATA = '    /  /  ' .OR. EMPTY(_DATA)
   RETURN SPACE(10)
ELSE
   IF SUBSTR(_DATA,3,1) = '/'
	   RETURN  _DATA
   ENDIF
   RETURN  RIBALTA2(_DATA)
ENDIF



***********************************************************************
* Funzione - MODTBL     Data: 15.08.00   Autore: Project S.r.L.  NUOVA 
***********************************************************************
*
*  MODIFICA UNA TABELLA AGGIORNANDO / AGGIUNGENDO DEI CAMPI
*  CONTROLLA SE IL CAMPO:
*  		 ESISTE  	-  MODIFICA EVENTUALE LUNGHEZZA E TIPOLOGIA
*  		 NON ESISTE -  AGGIUNGE IL CAMPO
*
*  ******************************************************************************
*  PRIMA DI RICHIAMARE LA FUNZIONE LA TABELLA DBF DEVE ESSERE APERTA IN EXCLUSIVA
*  ******************************************************************************
*
*  PARAMETRI DA PASSARE: ALIAS DELLA TABELLA
*                        NOME DEL CAMPO
*                        TIPOLOGIA E LUNGHEZZA CAMPO
*                        FLAG DI CANCELLAZIONE CAMPO (OPZIONALE)
*
*  Sintassi:
*  =MODTBL(ALIAS(SELECT()),"NOME_CAMPO","C(10)",.F.,.T.)
*
**************************
FUNCTION MODTBL
**************************
PARA _TBL,_CAMPO,_TIPO,_DROP,_CURS

IF PARAMETER() < 4
  _DROP=.F.
ENDIF

IF EMPTY(_CURS)
	_CURS=.F.
ENDIF

_TBL   = UPPER(_TBL)
_CAMPO = UPPER(_CAMPO)
_TIPO  = UPPER(_TIPO)

ESISTE=.F.
IF _CURS
	Select &_TBL
	_TotFields=afields(_NameFields)
	for _x=1 to _TotFields
	   IF ALLTRIM(_NameFields[_x,1]) == ALLTRIM(_CAMPO)
	     ESISTE=.T.
		 _NameFields[_x,2]=SUBSTR(_TIPO,1,1)
 		 _DIMENSIONE=STRTRAN(STR_EXTRACT(_TIPO,"(",2),")","")
		 _NameFields[_x,3]=INT(VAL(STR_EXTRACT(_DIMENSIONE,",",1)))
		 _NameFields[_x,4]=INT(VAL(STR_EXTRACT(_DIMENSIONE,",",2)))
	     EXIT
	   ENDIF
	next
	IF !ESISTE
		_Nfields=_TotFields+1
		*DIMENSION _NameFields[_Nfields,16]
		_nArrayColumns = ALEN(_NameFields,2)			&& ERASMO - 29/09/2009 - CORREZIONE PER ANOMALIA IN VFP9
		DIMENSION _NameFields[_Nfields,_nArrayColumns]	&& ERASMO - 29/09/2009 - CORREZIONE PER ANOMALIA IN VFP9
		_NameFields[_Nfields,1]=_CAMPO
		_NameFields[_Nfields,2]=SUBSTR(_TIPO,1,1)
		_DIMENSIONE=STRTRAN(STR_EXTRACT(_TIPO,"(",2),")","")
		_NameFields[_Nfields,3]=INT(VAL(STR_EXTRACT(_DIMENSIONE,",",1)))
		_NameFields[_Nfields,4]=INT(VAL(STR_EXTRACT(_DIMENSIONE,",",2)))
		_NameFields[_Nfields,5]=.T.
		_NameFields[_Nfields,6]=.F.
		FOR JJ1=7 TO 16
			_NameFields[_Nfields,JJ1]=""
		NEXT
	ENDIF
	CREATE CURSOR &_TBL FROM ARRAY _NameFields
	RETURN(.T.)
ENDIF


ESISTE=.F.
* -->> RICERCO NELLA TABELLA SE IL CAMPO GIA' ESISTE
Select &_TBL
_TotFields=afields(_NameFields)
for _x=1 to _TotFields
   IF ALLTRIM(_NameFields[_x,1]) == ALLTRIM(_CAMPO)
     ESISTE=.T.
     EXIT
   ENDIF
next

* -->> CANCELLAZIONE DI UN CAMPO DALLA TABELLA
* ----------------------------------------------
IF _DROP
  ALTER TABLE &_TBL DROP COLUMN &_CAMPO
  RETURN(.T.)
ENDIF


* -->> AGGIUNTA / VARIAZIONE DI UN CAMPO NELLA TABELLA
* ----------------------------------------------
IF ESISTE
  ALTER TABLE &_TBL ALTER COLUMN &_CAMPO  &_TIPO    && MODIFICA
ELSE
  ALTER TABLE &_TBL ADD   COLUMN &_CAMPO  &_TIPO    && AGGIUNTA
ENDIF

RETURN(.T.)



*************************************************************************
* Funzione - VERTBL     Data: 01.03.01   Autore: Project
*************************************************************************
*
*  CONTROLLA SE IL CAMPO ESISTE
*
*  PARAMETRI DA PASSARE: ALIAS DELLA TABELLA
*                        NOME DEL CAMPO
*
*  Sintassi:
*  =MODTBL(ALIAS(SELECT()),"NOME_CAMPO")
*
**************************
FUNCTION VERTBL
**************************
PARA _TBL,_CAMPO

_TBL   = UPPER(_TBL)
_CAMPO = UPPER(_CAMPO)

ESISTE=.F.
* -->> RICERCO NELLA TABELLA SE IL CAMPO GIA' ESISTE
Select &_TBL
_TotFields=afields(_NameFields)
for _x=1 to _TotFields
   IF ALLTRIM(_NameFields[_x,1]) == ALLTRIM(_CAMPO)
     ESISTE=.T.
     EXIT
   ENDIF
next

RETURN(ESISTE)



***********************************************************************
* Funzione - SOTTOGEN     Data: 31.03.98   Autore: Carlo by Project
***********************************************************************
*  RITORNA IN PUB_CC E PUB_FF IL SOTTOCONTO CLIENTI E FORNITORI
*  V_ER =.T. SE NON TROVO NESSUN SOTTOCONTO, ALTRIMENTI V_ER=.F.
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

PUB_ER=.F.
PUB_CC=''
PUB_FF=''

_SAVESEL = SELECT()

_CNAZ = ALLTRIM(SUBSTR(_CNAZ,1,3))

TEXT TO cSql NOSHOW
	SELECT *
	FROM para
	where codice = 'GEN'+?pub_codsoc
ENDTEXT

IF !ExecCommand(cSql,"para")
  return(.f.)
ENDIF

* == >>> ACCESSO AL PARAMETRO GENERALE
SELECT PARA
IF reccount() > 0
   PUB_CC=ALLTRIM(SUBSTR(LIBERA,1,pub_sottog-1))
   PUB_FF=ALLTRIM(SUBSTR(LIBERA,18,pub_sottog-1))
ELSE
   =MESSAGEBOX("Parametro << GEN01 >> non trovato",16,"*** ATTENZIONE ***")
   SELECT(_SAVESEL)
   PUB_ER=.T.
   RETURN(PUB_ER)
ENDIF

* WAIT WINDOWS "GENERALE"+ PUB_CC + "<<<" + PUB_FF + "<<<"

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
      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,pub_sottog-1))
      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,pub_sottog-1))
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

* WAIT WINDOWS "GENERALE ITALIA "+ PUB_CC + "<<<" + PUB_FF + "<<<"

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
      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,pub_sottog-1))
      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,pub_sottog-1))
      IF EMPTY(XUB_CC).OR.EMPTY(XUB_FF)
	    =MESSAGEBOX("Mancano valori nel parametro << GENCE >>",16,"*** ATTENZIONE ***")
        PUB_ER=.T.
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

* WAIT WINDOWS "GENERALE CEE "+ PUB_CC + "<<<" + PUB_FF + "<<<"

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
      XUB_CC=ALLTRIM(SUBSTR(LIBERA,1,pub_sottog-1))
      XUB_FF=ALLTRIM(SUBSTR(LIBERA,18,pub_sottog-1))
      IF EMPTY(XUB_CC).OR.EMPTY(XUB_FF)
	    =MESSAGEBOX("Mancano valori nel parametro << GENEX >>",16,"*** ATTENZIONE ***")
        PUB_ER=.T.
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

* WAIT WINDOWS "GENERALE EXTRA CEE "+ PUB_CC + "<<<" + PUB_FF + "<<<"


IF PUB_ER=.T.
    *=MESSAGEBOX("PARAMETRO 'GEN' NON TROVATO",16,"ATTENZIONE")
    *RETURN(PUB_ER)
ENDIF


*********************************************************************************************
* SEEK_STD()	funzione per la gestione di tutte le tabella
*********************************************************************************************
* La funzione restituisce TRUE se trova, FALSE se non trova dati nella tabella
* selezionata con una certa chiave, inoltre restituisce il cursore con il/i record
* che hanno soffisfatto il filtro
*
* Descrizione dei parametri:
* 		_nometabella	= è il nome della tabella su cui effettuare la ricerca
*		_chiavericerca	= è la chiave completa di ricerca (pub_codsoc+v_codcli)
*		_campinchiave	= è l'elenco dei campi che formano la chiave (cli_codsoc+cli_codcli)
*					   
* Esempio:
*		seek_std('u_cli_an','pub_codsoc+v_codcli','cli_codsoc+cli_codcli','CUR_U_CLI_AN)
*********************************************************************************************
FUNCTION seek_std
PARAMETERS _nometabella,_chiavericerca,_campinchiave,_nomecursore
IF PARAMETERS() < 2
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return(.f.)
ENDIF 

IF EMPTY(_nomecursore)
   _cursore_ricerca="pj_cur_"+_nometabella
ELSE
   _cursore_ricerca=_nomecursore
ENDIF

_pjlib_sele=SELECT()

_pj_seek = "select * from "+_nometabella+" where "+_campinchiave+" = '"+_chiavericerca+"'"

IF !ExecCommand(_pj_seek,_cursore_ricerca)
   return(.f.)
ENDIF
	
SELECT &_cursore_ricerca
IF reccount() = 0
   _ret_valore=.f.
ELSE
   _ret_valore=.t.
ENDIF 
	
SELECT(_pjlib_sele)

return(_ret_valore)



*****************************************************************************************
*	 						 CREA I SALDI PARTITE CLENTI/FORNITORI           		    * 
*****************************************************************************************			
* FUNZIONE GENERALIZZATA PER ESTRARRE / AGGIORNARE I SALDI DAI PARTITARI 
*
* LA FUNZIONE DI ESTRAZIONE RIPORTA UN CURSORE CON I DATI DELLO SCADUTO A SCADERE 
*
* PARAMETRI DELLA FUNZIONE 
* _cf = C : CLIENTI
*       F : FORNITORI
*
* _codcli = codice del cliente o del fornitore
*
* _npart  = numero partita cliente fornitore
*
* _dtscad = data di scadenza della singola riga della partita 
*
* _estrai = A 		: ESTRAE SENZA AGGIORNARE SOLO SALDO PARTITE APERTE
*           C 		: ESTRAE SENZA AGGIORNARE SOLO SALDO PARTITE CHIUSE
*           T 		: ESTRAE SENZA AGGIORNARE TUTTI I SALDI DELLE PARTITE SIA APERTE CHE CHIUSE
*			
*
*			=========
*           CREA                  : AGGIORNA I SALDI SUI PARTITARI
*           ANNU                  : ANNULLA TUTTI I SALDI DELLA PARTITA 			      
* 			ANNUA                 : ANNULLA I SALDI ANCORA APERTI DELLA PARTITA
*			ANNUC                 : ANNULLA I SALDI CHIUSI DELLA PARTITA
*           ANNULLASALDICLIENTE   : ANNULLA TUTTI I SALDI DEL CLIENTE
*           ANNULLASALDIFORNITORE : ANNULLA TUTTI I SALDI DEL FORNITORE
*			CREACF                : AGGIORNA I SALDI SUI PARTITARI A LIVELLO DI CLIENTE / FORNITORE
*
*
*
* _dettagli_partite : SI  : ESTRAE DOPO AVER CREATO IL CURSORE CUR_SALDI_CLI/CUR_SALDI_FOR LE PARTITE INDICATE DAL FLAG 
*							DI ESTRAZIONE A LIVELLO DI SALDO = .T.	(SOLO NELLE FUNZIONI DI ESTRAZIONE)
*
* _estrai_tutto     : se = "ESTRAILEPARTITEDELCLIENTE-FORNITORE" , elabora tutte le partite del SINGOLO cliente/fornitore
*  				    : se = "ESTRAITUTTELEPARTITE" , elabora tutte le partite dei clienti/fornitori
*  				    : se = "ESTRAITUTTELEPARTITE-SENZAANOMALIE" , elabora tutte le partite di tutti i clienti/fornitori senza anomalie
*  				    : se = "ESTRAITUTTELEPARTITE-SENZAANOMALIE-DEL-CLI-FOR" , elabora tutte le partite del cliente/fornitore indicato senza anomalie
*  				    : se = "ESTRAITUTTELEPARTITE-CONANOMALIE" , elabora tutte le partite di tutti i clienti/fornitori con anomalie
*  				    : se = "ESTRAITUTTELEPARTITE-CONANOMALIE-DEL-CLI-FOR" , elabora tutte le partite del cliente/fornitore indicato con anomalie
*
*                   ########   _estrai = CREA   ################
*                   : se = "ESTRAITUTTELEPARTITEFORNITORE" ricrea i saldi del fornitore specifico impostato DOPO AVERLI CANCELLATI 
*
*
* FABIANO 18/06/2004 : riportati come parametri alcuni parametri della Function CERCA_PARTIRE per poter raffinare l'estrazione
* ==========================
*
* _data_dal			: periodo di estrazione delle partite dal
* _data_al			: periodo di estrazione delle partite al
* _data_scaduto		: ritorna tutte le partite scadute sino alla data compresa
* _data_a_scadere   : ritorna tutte le partite che scadranno dala data indicata 
*
*
*  ULTERIORI FUNZIONALITA' COMBINATE
*  =================================
*
*    SE _estrai = CREA e  _codcli = "TUTTO" e _npart = "TUTTO >>>>>>>> vengono RICREATI TUTTI I SALDI CLIENTI/FORNITORI
*    SE _estrai = ANNU e  _codcli = "TUTTO" e _npart = "TUTTO >>>>>>>> vengono CANCELLATI tutti i saldi clienti/fornitori
*
*
* >>>>>>>>> CURSORI RESTITUITI : 
*								CSALDI_PARTITE 	contiene i saldi clienti / fornitori
*								PARTITECF		contiene il dettaglio delle partite aperte (CLI/FOR) desiderate



FUNCTION CREA_SALDI_CF
PARA 	_cf,;
		_codcli,;
		_npart,;
		_dtscad,;
		_estrai,;
		_dettagli_partite,;
		_estrai_tutto,;
		_data_dal,;
		_data_al,;
		_data_scaduto,;
		_data_a_scadere,;
		_P_FLAG_SCADENZA_DAL_AL

LOCAL 	VTIPO     ,;
		VARCHIVIO ,;
		VCONTO    ,;
		VDTDAL	  ,;
		VDTAL	  ,;
		VPARTITA  ,;
		VNUMREGI  ,;
		VCURSORE  ,;
		VDTSCADE  ,;
		VDTASCAD  ,;
		VSOLOSALDO,;
		VORDINE	  ,;
		VOPENCLOSE,;
		_numero_parametri,;
		_FLAG_SCADENZA_DAL_AL
				

_numero_parametri = PARAMETERS()

SET EXACT ON
_FLAG_SCADENZA_DAL_AL=.F.


DO CASE 
	CASE _numero_parametri < 6
		_dettagli_partite = "NO"
		_estrai_tutto 	= ""
		_data_dal		= "01/01/1990"
		_data_al 		= "31/12/2999"
		_data_scaduto	= ""
		_data_a_scadere	= ""

	CASE _numero_parametri < 7
		_estrai_tutto 	= ""
		_data_dal		= "01/01/1990"
		_data_al 		= "31/12/2999"
		_data_scaduto	= ""
		_data_a_scadere	= ""

	CASE _numero_parametri < 8
		_data_dal		= "01/01/1990"
		_data_al 		= "31/12/2999"
		_data_scaduto	= ""
		_data_a_scadere	= ""

	CASE _numero_parametri < 9
		_data_al 		= "31/12/2999"
		_data_scaduto	= ""
		_data_a_scadere	= ""

	CASE _numero_parametri < 10
		_data_scaduto	= ""
		_data_a_scadere	= ""

	CASE _numero_parametri < 11
		_data_a_scadere	= ""

	CASE _numero_parametri = 12
		_FLAG_SCADENZA_DAL_AL=_P_FLAG_SCADENZA_DAL_AL

		
ENDCASE


AABBSXS  = SELECT()
_zero    = 0

		
DO CASE


		CASE _CF  == "C"         && GESTIONE PARTITE CLIENTI


				IF _dettagli_partite == "SI"
				
						SELECT CUR_SALDI_CLI
						GO TOP
						DO WHILE .NOT.EOF()

							SCATTER MEMVAR MEMO
							IF M.PAR_ESTRAIPARTITA 

							*!*	*!*	SOLO UNA PARITA MIRATA DEL DEL FORNITORE RICHIAMANDOLA PER NUMERO DI PARTITA
								VTIPO    	= "C"			 		&& C= CLIENTE F= FORNITORE	
								VARCHIVIO	= "PART_CLI"	 		&& PART_CLI = PARTITARIO CLIENTI , PART_FOR = PARTITARIO FORNITORI
								VCONTO   	= M.PAR_CODCLI		 	&& CODICE DEL CLIENTE
								VDTDAL		= _data_dal		  	    && PERIODO DI ESTRAZIONE DELLE PARTITE DAL
								VDTAL		= _data_al 				&& PERIODO DI ESTRAZIONE DELLE PARTITE AL
								VPARTITA 	= M.PAR_NPART	 		&& NUMERO DI PARTITA , SE INDICATA ESTRAE SOLO LA PARTITA DEL CLIENTE O DEL FORNITORE ALRIMENTI TUTTE
								VNUMREGI 	= ""			 		&& NUMERO DI REGISTRAZIONE ,SE INDICATA ESTRAE SOLO LA PARTITA DEL CLIENTE O DEL FORNITORE ALRIMENTI TUTTE
								VCURSORE 	= "SCADE"		 		&& NOME DEL CURSORE DI RITORNO CONTENENTE LE PARITE
								VDTSCADE 	= _data_scaduto	   		&& RITORNA TUTTE LE PARTITE SCADUTE SINO ALLA DATA COMPRESA
								VDTASCAD 	= _data_a_scadere  		&& RITORNA TUTTE LE PARTITE CHE SCADRANNO DALA DATA INDICATA , ALTRIMENTI TUTTE
								VSOLOSALDO	= ""			 		&& RITORNA SOLO IL SALDO DELLA PARTITA , ALTRIMENTI TUTTE
								VORDINE		= 3				 		&& IN ORDINE DI NUMERO PARTITA
								VOPENCLOSE	= 2				 		&& SOLO PARTITE APERTE 

								=CERCA_PARTITE(VTIPO,VARCHIVIO,VCONTO,VDTDAL,VDTAL,VPARTITA,VNUMREGI,VCURSORE,VDTSCADE,VDTASCAD,VSOLOSALDO,VORDINE,VOPENCLOSE)  

							    SELECT SCADE
							    GO TOP
							    SCAN 
								  SCATTER MEMVAR MEMO
								  INSERT INTO PARTITECF FROM MEMVAR
							    ENDSCAN

							ENDIF M.PAR_ESTRAIPARTITA 

							SELECT CUR_SALDI_CLI
							SKIP + 1

						ENDDO
				
				
				
						SELECT(AABBSXS)
						RETURN
				
				ENDIF



				DO CASE 

				
						CASE _estrai== "A"			&& SOLO SALDI PARTITE APERTE

								*!*	

									__condi__="PAR_NPART = ?_NPART AND PAR_CODCLI = ?_CODCLI AND PAR_FATT <> 0"  && PARTITA

									IF _estrai_tutto  = "ESTRAILEPARTITEDELCLIENTE-FORNITORE" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT <> 0"	 && TUTTE LE PARTITE DEL CLIENTE	
									ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-SENZAANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT <> 0 AND PAR_ANOMAX = '   '"	 && TUTTE LE PARTITE DEL CLIENTE SENZA ANOMALIE	
									ENDIF

									IF _estrai_tutto = "ESTRAITUTTELEPARTITE" 
										__condi__="PAR_FATT <> 0"							 && TUTTE LE PARTITE DI TUTTI I CLIENTI
					 				ENDIF

									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-SENZAANOMALIE" 
										__condi__="PAR_FATT <> 0 AND PAR_ANOMAX = '   '"	 
					 				ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-CONANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT <> 0 AND PAR_ANOMAX <> '   '"	 && TUTTE LE PARTITE DEL CLIENTE SENZA ANOMALIE	
									ENDIF


									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-CONANOMALIE" 
										__condi__="PAR_FATT <> 0 AND PAR_ANOMAX <> '   '"	 
					 				ENDIF


								*!*	CREA IL CURSORE FOX CONENENTE ULTERIORI CAMPI
									__c1__="par_ragsoc AS ragsoc,par_npart AS npart,par_dtscad AS dtscad,par_fatt AS nsaldo,par_codcli AS codfor"
									__c2__=",par_codacq AS tipopagam,par_cosatratta AS cosatratta,par_gradoimportanza AS gradoimpor,par_formapagamento AS formapagam,par_tipocontratto AS tipocontra,par_codacq AS codacq,par_pripaga AS pripaga"
									__c3__=",par_estrai AS c1sepago,par_estrai AS c1sesposto,par_fatta AS c1quantpag,par_datac AS c1quandpag,par_prty AS c1pripag,par_datac AS c1achescad"
									__c4__=",par_estrai AS c2sepago,par_estrai AS c2sesposto,par_fatta AS c2quantpag,par_datac AS c2quandpag,par_prty AS c2pripag,par_datac AS c2achescad"
									__c5__=",par_estrai AS c3sepago,par_estrai AS c3sesposto,par_fatta AS c3quantpag,par_datac AS c3quandpag,par_prty AS c3pripag,par_datac AS c3achescad"
									__c6__=",par_estrai AS c4sepago,par_estrai AS c4sesposto,par_fatta AS c4quantpag,par_datac AS c4quandpag,par_prty AS c4pripag,par_datac AS c4achescad"
									__c7__=",par_estrai AS c5sepago,par_estrai AS c5sesposto,par_fatta AS c5quantpag,par_datac AS c5quandpag,par_prty AS c5pripag,par_datac AS c5achescad"
									__c8__=",par_datac AS banca,par_contoc AS contocont,par_fatta AS quantavalu,par_datac AS quandovalu,par_anomax AS ANOMALIA"

									__campi__ = __c1__+__c2__+__c3__+__c4__+__c5__+__c6__+__c7__+__c8__


									cSql="SELECT "+__campi__+" FROM SALDI_CLI WHERE " + __condi__ +" order by PAR_CODCLI"
									
									IF !ExecCommand(cSql,"cur_saldi_cli")
									   return(.f.)
									ENDIF


							    	SELECT cur_saldi_cli
								    GO TOP
								    SCAN 
									  SCATTER MEMVAR MEMO
									  INSERT INTO CSALDI_PARTITE FROM MEMVAR
								    ENDSCAN

								
									SELECT(AABBSXS)
									RETURN




						CASE _estrai == "C"			&& SOLO SALDI PARTITE CHIUSE

								*!*	
					
									__condi__="PAR_NPART = ?_NPART AND PAR_CODCLI = ?_CODCLI AND PAR_FATT = 0"  && PARTITA

									IF _estrai_tutto  = "ESTRAILEPARTITEDELCLIENTE-FORNITORE" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT = 0"	 && TUTTE LE PARTITE DEL CLIENTE	
									ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-SENZAANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT = 0 AND PAR_ANOMAX = '   '"	 && TUTTE LE PARTITE DEL CLIENTE SENZA ANOMALIE	
									ENDIF
									
									IF _estrai_tutto = "ESTRAITUTTELEPARTITE" 
										__condi__="PAR_FATT = 0"							 && TUTTE LE PARTITE DI TUTTI I CLIENTI	
					 				ENDIF

									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-SENZAANOMALIE" 
										__condi__="PAR_FATT = 0 AND PAR_ANOMAX = '   '"	 && TUTTE LE PARTITE DI TUTTI I CLIENTI
					 				ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-CONANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT = 0 AND PAR_ANOMAX <> '   '"	 && TUTTE LE PARTITE DEL CLIENTE SENZA ANOMALIE	
									ENDIF

									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-CONANOMALIE" 
										__condi__="PAR_FATT = 0 AND PAR_ANOMAX <> '   '"	 
					 				ENDIF



								*!*	CREA IL CURSORE FOX CONENENTE ULTERIORI CAMPI
									__c1__="par_ragsoc AS ragsoc,par_npart AS npart,par_dtscad AS dtscad,par_fatt AS nsaldo,par_codcli AS codfor"
									__c2__=",par_codacq AS tipopagam,par_cosatratta AS cosatratta,par_gradoimportanza AS gradoimpor,par_formapagamento AS formapagam,par_tipocontratto AS tipocontra,par_codacq AS codacq,par_pripaga AS pripaga"
									__c3__=",par_estrai AS c1sepago,par_estrai AS c1sesposto,par_fatta AS c1quantpag,par_datac AS c1quandpag,par_prty AS c1pripag,par_datac AS c1achescad"
									__c4__=",par_estrai AS c2sepago,par_estrai AS c2sesposto,par_fatta AS c2quantpag,par_datac AS c2quandpag,par_prty AS c2pripag,par_datac AS c2achescad"
									__c5__=",par_estrai AS c3sepago,par_estrai AS c3sesposto,par_fatta AS c3quantpag,par_datac AS c3quandpag,par_prty AS c3pripag,par_datac AS c3achescad"
									__c6__=",par_estrai AS c4sepago,par_estrai AS c4sesposto,par_fatta AS c4quantpag,par_datac AS c4quandpag,par_prty AS c4pripag,par_datac AS c4achescad"
									__c7__=",par_estrai AS c5sepago,par_estrai AS c5sesposto,par_fatta AS c5quantpag,par_datac AS c5quandpag,par_prty AS c5pripag,par_datac AS c5achescad"
									__c8__=",par_datac AS banca,par_contoc AS contocont,par_fatta AS quantavalu,par_datac AS quandovalu,par_anomax AS ANOMALIA"

									__campi__ = __c1__+__c2__+__c3__+__c4__+__c5__+__c6__+__c7__+__c8__


									cSql="SELECT "+__campi__+" FROM SALDI_CLI WHERE " + __condi__ +" order by PAR_CODCLI"
									
									IF !ExecCommand(cSql,"cur_saldi_cli")
									   return(.f.)
									ENDIF


							    	SELECT cur_saldi_cli
								    GO TOP
								    SCAN 
									  SCATTER MEMVAR MEMO
									  INSERT INTO CSALDI_PARTITE FROM MEMVAR
								    ENDSCAN

							
									SELECT(AABBSXS)
									RETURN

						
						CASE _estrai == "T"			&& TUTTI I SALDI SIA DELLE PARTITE APERTE CHE CHIUSE

								*!*	
									__condi__="PAR_NPART = ?_NPART AND PAR_CODCLI = ?_CODCLI"  && PARTITA

									IF _estrai_tutto  = "ESTRAILEPARTITEDELCLIENTE-FORNITORE" 
										__condi__="PAR_CODCLI = ?_CODCLI"	 && TUTTE LE PARTITE DEL CLIENTE	
									ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-SENZAANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_ANOMAX = '   '"	 
									ENDIF
									
									IF _estrai_tutto = "ESTRAITUTTELEPARTITE" 
										__condi__="1=1"							 && TUTTE LE PARTITE DI TUTTI I CLIENTI	
					 				ENDIF

									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-SENZAANOMALIE" 
										__condi__="PAR_ANOMAX = '   '"	 && TUTTE LE PARTITE DI TUTTI I CLIENTI
					 				ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-CONANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_ANOMAX <> '   '"	 && TUTTE LE PARTITE DEL CLIENTE SENZA ANOMALIE	
									ENDIF


									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-CONANOMALIE" 
										__condi__="PAR_ANOMAX <> '   '"	 
					 				ENDIF

								*!*	CREA IL CURSORE FOX CONENENTE ULTERIORI CAMPI
									__c1__="par_ragsoc AS ragsoc,par_npart AS npart,par_dtscad AS dtscad,par_fatt AS nsaldo,par_codcli AS codfor"
									__c2__=",par_codacq AS tipopagam,par_cosatratta AS cosatratta,par_gradoimportanza AS gradoimpor,par_formapagamento AS formapagam,par_tipocontratto AS tipocontra,par_codacq AS codacq,par_pripaga AS pripaga"
									__c3__=",par_estrai AS c1sepago,par_estrai AS c1sesposto,par_fatta AS c1quantpag,par_datac AS c1quandpag,par_prty AS c1pripag,par_datac AS c1achescad"
									__c4__=",par_estrai AS c2sepago,par_estrai AS c2sesposto,par_fatta AS c2quantpag,par_datac AS c2quandpag,par_prty AS c2pripag,par_datac AS c2achescad"
									__c5__=",par_estrai AS c3sepago,par_estrai AS c3sesposto,par_fatta AS c3quantpag,par_datac AS c3quandpag,par_prty AS c3pripag,par_datac AS c3achescad"
									__c6__=",par_estrai AS c4sepago,par_estrai AS c4sesposto,par_fatta AS c4quantpag,par_datac AS c4quandpag,par_prty AS c4pripag,par_datac AS c4achescad"
									__c7__=",par_estrai AS c5sepago,par_estrai AS c5sesposto,par_fatta AS c5quantpag,par_datac AS c5quandpag,par_prty AS c5pripag,par_datac AS c5achescad"
									__c8__=",par_datac AS banca,par_contoc AS contocont,par_fatta AS quantavalu,par_datac AS quandovalu,par_anomax AS ANOMALIA"

									__campi__ = __c1__+__c2__+__c3__+__c4__+__c5__+__c6__+__c7__+__c8__


									cSql="SELECT "+__campi__+" FROM SALDI_CLI WHERE " + __condi__ +" order by PAR_CODCLI"
									
									IF !ExecCommand(cSql,"cur_saldi_cli")
									   return(.f.)
									ENDIF


							    	SELECT cur_saldi_cli
								    GO TOP
								    SCAN 
									  SCATTER MEMVAR MEMO
									  INSERT INTO CSALDI_PARTITE FROM MEMVAR
								    ENDSCAN

								
									SELECT(AABBSXS)
									RETURN

	
				
				ENDCASE 



			*!*	CREA IL PRIMO CURSORE PER I SALDI DARE

				__campi__="par_ragsoc,par_codcli,par_npart,par_dtscad,par_anomax"
				__somma__=", SUM(par_fatt) AS par_fattd,SUM(par_fatta) as par_fatta"
				IF _estrai_tutto = "ESTRAITUTTELEPARTITE" 
					__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'D'"  && TUTTE LE PARTITE
				ELSE
					__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'D' AND PAR_NPART = ?_NPART AND PAR_CODCLI = ?_CODCLI"  && PARTITA
				ENDIF

				IF _estrai == "CREACF"
					__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'D' AND PAR_CODCLI = ?_CODCLI"  && PARTITA CLIENTE
				ENDIF
				
				cSql="SELECT "+__campi__+__somma__+" FROM PART_CLI WHERE " + __condi__ +  ;
				    					                          " group by "+__campi__+" order by PAR_CODCLI"
				IF !ExecCommand(cSql,"cur_dare")
				   return(.f.)
				ENDIF

			*!*	CREA IL SECONDO CURSORE PER I SALDI AVERE
				__campi__="par_ragsoc,par_codcli,par_npart,par_dtscad,par_anomax"
				__somma__=", SUM(par_fattd) AS par_fattd, SUM(par_fatt) AS par_fatta"

				IF _estrai_tutto = "ESTRAITUTTELEPARTITE" 
					__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'A'"  && TUTTE LE PARTITE
				ELSE
					__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'A' AND PAR_NPART = ?_NPART AND PAR_CODCLI = ?_CODCLI"
				ENDIF


				IF _estrai == "CREACF"
					__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'A' AND PAR_CODCLI = ?_CODCLI" && PARTITA CLIENTE
				ENDIF


				cSql="SELECT "+__campi__+__somma__+" FROM PART_CLI WHERE " + __condi__ +  ;
				    					                          " group by "+__campi__+" order by PAR_CODCLI"
				IF !ExecCommand(cSql,"cur_avere")
				   return(.f.)
				ENDIF

			*!*	CREA IL TERZO CURSORE PER FONDERE I SALDI DARE CON I SALDI AVERE
				SELECT * FROM cur_dare UNION SELECT * FROM cur_avere INTO CURSOR cur_da 


			*!*	CREA IL QUARTO CURSORE FOX PER CALCOLARE IL RECORD DI SALDO
				__campi__="par_ragsoc,par_codcli,par_npart,par_dtscad,par_anomax"
				__somma__=",SUM(par_fattd-par_fatta) AS par_fatt"
				__condi__="1=1"
				cSql="SELECT "+__campi__+__somma__+" FROM CUR_DA WHERE " + __condi__ +  ;
				    					                          " group by "+__campi__+" INTO CURSOR cu_saldi_cli"
				&CSQL
				        
				
				DO CASE 
				
						CASE _estrai == "CREACF"		&& AGGIORNA I SALDI 



								*!*	CANCELLA I SALDI ESISTENTI
							        CSQL="DELETE FROM SALDI_CLI WHERE PAR_CODCLI = ?_codcli"

							        IF !ExecCommand(CSQL,"")
							           RETURN (.f.)
							        ENDIF 


								*!*	CREA IL QUINTO CURSORE CONTENENTE IL RECORD DI SALDO DELLE PARTITE SIA APERTE CHE CHIUSE									
									SELECT '    ' AS id_unique,* FROM cu_saldi_cli INTO CURSOR CUR_SALDI_CLI


								    IF !ExecRW('','saldi_cli','I','','CUR_SALDI_CLI')
								      return(.f.)
								    ENDIF



				
						CASE _estrai == "CREA"		&& AGGIORNA I SALDI 



								*!*	CANCELLA I SALDI ESISTENTI
									IF _estrai_tutto = "ESTRAITUTTELEPARTITE" 
								        CSQL="DELETE FROM SALDI_CLI"
									ELSE
								        CSQL="DELETE FROM SALDI_CLI WHERE PAR_npart = ?_npart AND PAR_CODCLI = ?_codcli"
									ENDIF

							        IF !ExecCommand(CSQL,"")
							           RETURN (.f.)
							        ENDIF 


								*!*	CREA IL QUINTO CURSORE CONTENENTE IL RECORD DI SALDO DELLE PARTITE SIA APERTE CHE CHIUSE									
									SELECT '    ' AS id_unique,* FROM cu_saldi_cli INTO CURSOR CUR_SALDI_CLI


								    IF !ExecRW('','saldi_cli','I','','CUR_SALDI_CLI')
								      return(.f.)
								    ENDIF



						CASE _estrai == "ANNU"		&& ANNULLA TUTTI I SALDI DELLA PARTITA 


								*!*	CANCELLA I SALDI ESISTENTI DELLA PARTITA

									IF _estrai_tutto = "ESTRAITUTTELEPARTITE" 
								        CSQL="DELETE FROM SALDI_CLI"
								        IF !ExecCommand(CSQL,"")
								           RETURN (.f.)
								        ENDIF 
									ELSE
								        CSQL="DELETE FROM SALDI_CLI WHERE PAR_npart = ?_npart AND PAR_CODCLI = ?_codcli"
								        IF !ExecCommand(CSQL,"")
								           RETURN (.f.)
								        ENDIF 
									ENDIF

						CASE _estrai == "ANNUA"		&& ANNULLA TUTTI I SALDI APERTI DELLA PARTITA 


								*!*	CANCELLA I SALDI APERTI ESISTENTI DELLA PARTITA
							        CSQL="DELETE FROM SALDI_CLI WHERE PAR_npart = ?_npart AND PAR_CODCLI = ?_codcli AND PAR_FATT <> ?_zero"
							        IF !ExecCommand(CSQL,"")
							           RETURN (.f.)
							        ENDIF 


						CASE _estrai == "ANNUC"		&& ANNULLA TUTTI I SALDI CHIUSI DELLA PARTITA 

								*!*	CANCELLA I SALDI CHIUSI ESISTENTI DELLA PARTITA
							        CSQL="DELETE FROM SALDI_CLI WHERE PAR_npart = ?_npart AND PAR_CODCLI = ?_codcli AND PAR_FATT = ?_zero"
							        IF !ExecCommand(CSQL,"")
							           RETURN (.f.)
							        ENDIF 

						CASE _estrai == "ANNULLASALDICLIENTE"		&& ANNULLA TUTTI I SALDI DEL CLIENTE 

							        CSQL="DELETE FROM SALDI_FOR WHERE PAR_CODCLI = ?_codcli "
							        IF !ExecCommand(CSQL,"")
							           RETURN (.f.)
							        ENDIF 



																	
						ENDCASE
				



		CASE _CF  = "F"			&& GESTIONE PARTITE FORNITORI

				IF _dettagli_partite == "SI"
				
				
				
						SELECT CUR_SALDI_FOR
						GO TOP
						DO WHILE .NOT.EOF()

							SCATTER MEMVAR MEMO
							IF M.PAR_ESTRAIPARTITA 

							*!*	*!*	SOLO UNA PARITA MIRATA DEL DEL FORNITORE RICHIAMANDOLA PER NUMERO DI PARTITA
								VTIPO    	= "F"			 		&& C= CLIENTE F= FORNITORE	
								VARCHIVIO	= "PART_FOR"	 		&& PART_CLI = PARTITARIO CLIENTI , PART_FOR = PARTITARIO FORNITORI
								VCONTO   	= M.PAR_CODCLI		 	&& CODICE DEL CLIENTE
								VDTDAL		= _data_dal				&& PERIODO DI ESTRAZIONE DELLE PARTITE DAL
								VDTAL		= _data_al 				&& PERIODO DI ESTRAZIONE DELLE PARTITE AL
								VPARTITA 	= M.PAR_NPART	 		&& NUMERO DI PARTITA , SE INDICATA ESTRAE SOLO LA PARTITA DEL CLIENTE O DEL FORNITORE ALRIMENTI TUTTE
								VNUMREGI 	= ""			 		&& NUMERO DI REGISTRAZIONE ,SE INDICATA ESTRAE SOLO LA PARTITA DEL CLIENTE O DEL FORNITORE ALRIMENTI TUTTE
								VCURSORE 	= "SCADE"		 		&& NOME DEL CURSORE DI RITORNO CONTENENTE LE PARITE
								VDTSCADE 	= _data_scaduto	   		&& RITORNA TUTTE LE PARTITE SCADUTE SINO ALLA DATA COMPRESA
								VDTASCAD 	= _data_a_scadere  		&& RITORNA TUTTE LE PARTITE CHE SCADRANNO DALA DATA INDICATA , ALTRIMENTI TUTTE
								VSOLOSALDO	= ""			 		&& RITORNA SOLO IL SALDO DELLA PARTITA , ALTRIMENTI TUTTE
								VORDINE		= 3				 		&& IN ORDINE DI NUMERO PARTITA
								VOPENCLOSE	= 2				 		&& SOLO PARTITE APERTE 

								=CERCA_PARTITE(VTIPO,VARCHIVIO,VCONTO,VDTDAL,VDTAL,VPARTITA,VNUMREGI,VCURSORE,VDTSCADE,VDTASCAD,VSOLOSALDO,VORDINE,VOPENCLOSE)  

							    SELECT SCADE
							    GO TOP
							    SCAN 
								  SCATTER MEMVAR MEMO
								  INSERT INTO PARTITECF FROM MEMVAR
							    ENDSCAN

							ENDIF M.PAR_ESTRAIPARTITA 

							SELECT CUR_SALDI_FOR
							SKIP + 1

						ENDDO
				
				
				
						SELECT(AABBSXS)
						RETURN
				
				ENDIF



				DO CASE 
						
				
						CASE _estrai == "A"			&& SOLO SALDI PARTITE APERTE

								*!*	
									__condi__="PAR_NPART = ?_NPART AND PAR_CODCLI = ?_CODCLI AND PAR_FATT <> 0"  && PARTITA

									IF _estrai_tutto  = "ESTRAILEPARTITEDELCLIENTE-FORNITORE" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT <> 0"	 && TUTTE LE PARTITE DEL FORNITORE	
									ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-SENZAANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT <> 0 AND PAR_ANOMAX = '   '"	 && TUTTE LE PARTITE DEL FORNITORE SENZA ANOMALIE	
									ENDIF
									
									IF _estrai_tutto = "ESTRAITUTTELEPARTITE" 
										__condi__="PAR_FATT <> 0"							 && TUTTE LE PARTITE DI TUTTI I FORNITORE	
					 				ENDIF

									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-SENZAANOMALIE" 
										__condi__="PAR_FATT <> 0 AND PAR_ANOMAX = '   '"	 && TUTTE LE PARTITE DI TUTTI I CLIENTI
					 				ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-CONANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT <> 0 AND PAR_ANOMAX <> '   '"	 && TUTTE LE PARTITE DEL CLIENTE SENZA ANOMALIE	
									ENDIF


									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-CONANOMALIE" 
										__condi__="PAR_FATT <> 0 AND PAR_ANOMAX <> '   '"	 
					 				ENDIF



					 				* condizione sulla data di scadenza della partita
					 				_condizione_scadenza=""
		
					 									 				
					 				IF !_FLAG_SCADENZA_DAL_AL
						 				IF !EMPTY(_data_scaduto) AND RIBALTA2(_data_scaduto)<=RIBALTA2(DTOC(DATE())) AND !(RIBALTA2(_data_a_scadere)>RIBALTA2(DTOC(DATE())))
						 				  	_condizione_scadenza=_condizione_scadenza+" AND PAR_DTSCAD BETWEEN '"+RIBALTA2(_data_scaduto)+"' AND '"+RIBALTA2(DTOC(DATE()))+"' "
						 				ENDIF
						 				    
						 				IF !EMPTY(_data_a_scadere) AND RIBALTA2(_data_a_scadere)>RIBALTA2(DTOC(DATE()))
						 					_condizione_scadenza=_condizione_scadenza+" AND PAR_DTSCAD BETWEEN '"+RIBALTA2(DTOC(DATE()))+"' AND '"+RIBALTA2(_data_a_scadere)+"' "
						 				ENDIF
									ELSE
						 					_condizione_scadenza=" AND PAR_DTSCAD BETWEEN '"+RIBALTA2(_data_scaduto)+"' AND '"+RIBALTA2(_data_a_scadere)+"' "
						 				
						 			ENDIF
          
								*!*	CREA IL CURSORE FOX CONENENTE ULTERIORI CAMPI
									__c1__="par_ragsoc AS ragsoc,par_npart AS npart,par_dtscad AS dtscad,par_fatt AS nsaldo,par_codcli AS codfor"
									__c2__=",par_codacq AS tipopagam,par_cosatratta AS cosatratta,par_gradoimportanza AS gradoimpor,par_formapagamento AS formapagam,par_tipocontratto AS tipocontra,par_codacq AS codacq,par_pripaga AS pripaga"
									__c3__=",par_estrai AS c1sepago,par_estrai AS c1sesposto,par_fatta AS c1quantpag,par_datac AS c1quandpag,par_prty AS c1pripag,par_datac AS c1achescad"
									__c4__=",par_estrai AS c2sepago,par_estrai AS c2sesposto,par_fatta AS c2quantpag,par_datac AS c2quandpag,par_prty AS c2pripag,par_datac AS c2achescad"
									__c5__=",par_estrai AS c3sepago,par_estrai AS c3sesposto,par_fatta AS c3quantpag,par_datac AS c3quandpag,par_prty AS c3pripag,par_datac AS c3achescad"
									__c6__=",par_estrai AS c4sepago,par_estrai AS c4sesposto,par_fatta AS c4quantpag,par_datac AS c4quandpag,par_prty AS c4pripag,par_datac AS c4achescad"
									__c7__=",par_estrai AS c5sepago,par_estrai AS c5sesposto,par_fatta AS c5quantpag,par_datac AS c5quandpag,par_prty AS c5pripag,par_datac AS c5achescad"
									*__c8__=",par_datac AS banca,par_contoc AS contocont,par_fatta AS quantavalu,par_datac AS quandovalu,par_anomax AS ANOMALIA"
									*** FABIANO 19/11/2005 INIZIO
									__c8__=",PAR_BANCA AS banca,par_contoc AS contocont,par_fatta AS quantavalu,par_datac AS quandovalu,par_anomax AS ANOMALIA, ID_UNIQUE AS ID_PARTITA"
									*** FABIANO 19/11/2005 FINE

									__campi__ = __c1__+__c2__+__c3__+__c4__+__c5__+__c6__+__c7__+__c8__


									cSql="SELECT "+__campi__+" FROM SALDI_FOR WHERE " + __condi__ +_condizione_scadenza+" order by PAR_CODCLI"
									
									IF !ExecCommand(cSql,"cur_saldi_for")
									   return(.f.)
									ENDIF


							    	SELECT cur_saldi_for
								    GO TOP
								    SCAN 
									  SCATTER MEMVAR MEMO
									  INSERT INTO CSALDI_PARTITE FROM MEMVAR
								    ENDSCAN

								
									SELECT(AABBSXS)
									RETURN


						CASE _estrai == "C"			&& SOLO SALDI PARTITE CHIUSE

								*!*	
									__condi__="PAR_NPART = ?_NPART AND PAR_CODCLI = ?_CODCLI AND PAR_FATT = 0"  && PARTITA

									IF _estrai_tutto  = "ESTRAILEPARTITEDELCLIENTE-FORNITORE" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT = 0"	 && TUTTE LE PARTITE DEL FORNITORE	
									ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-SENZAANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT = 0 AND PAR_ANOMAX = '   '"	 && TUTTE LE PARTITE DEL FORNITORE SENZA ANOMALIE	
									ENDIF
									
									IF _estrai_tutto = "ESTRAITUTTELEPARTITE" 
										__condi__="PAR_FATT = 0"							 && TUTTE LE PARTITE DI TUTTI I FORNITORE	
					 				ENDIF

									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-SENZAANOMALIE" 
										__condi__="PAR_FATT = 0 AND PAR_ANOMAX = '   '"	 && TUTTE LE PARTITE DI TUTTI I CLIENTI
					 				ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-CONANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_FATT = 0 AND PAR_ANOMAX <> '   '"	 && TUTTE LE PARTITE DEL CLIENTE SENZA ANOMALIE	
									ENDIF


									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-CONANOMALIE" 
										__condi__="PAR_FATT = 0 AND PAR_ANOMAX <> '   '"	 
					 				ENDIF



								*!*	CREA IL CURSORE FOX CONENENTE ULTERIORI CAMPI
									__c1__="par_ragsoc AS ragsoc,par_npart AS npart,par_dtscad AS dtscad,par_fatt AS nsaldo,par_codcli AS codfor"
									__c2__=",par_codacq AS tipopagam,par_cosatratta AS cosatratta,par_gradoimportanza AS gradoimpor,par_formapagamento AS formapagam,par_tipocontratto AS tipocontra,par_codacq AS codacq,par_pripaga AS pripaga"
									__c3__=",par_estrai AS c1sepago,par_estrai AS c1sesposto,par_fatta AS c1quantpag,par_datac AS c1quandpag,par_prty AS c1pripag,par_datac AS c1achescad"
									__c4__=",par_estrai AS c2sepago,par_estrai AS c2sesposto,par_fatta AS c2quantpag,par_datac AS c2quandpag,par_prty AS c2pripag,par_datac AS c2achescad"
									__c5__=",par_estrai AS c3sepago,par_estrai AS c3sesposto,par_fatta AS c3quantpag,par_datac AS c3quandpag,par_prty AS c3pripag,par_datac AS c3achescad"
									__c6__=",par_estrai AS c4sepago,par_estrai AS c4sesposto,par_fatta AS c4quantpag,par_datac AS c4quandpag,par_prty AS c4pripag,par_datac AS c4achescad"
									__c7__=",par_estrai AS c5sepago,par_estrai AS c5sesposto,par_fatta AS c5quantpag,par_datac AS c5quandpag,par_prty AS c5pripag,par_datac AS c5achescad"
									__c8__=",par_datac AS banca,par_contoc AS contocont,par_fatta AS quantavalu,par_datac AS quandovalu,par_anomax AS ANOMALIA"

									__campi__ = __c1__+__c2__+__c3__+__c4__+__c5__+__c6__+__c7__+__c8__


									cSql="SELECT "+__campi__+" FROM SALDI_FOR WHERE " + __condi__ +" order by PAR_CODCLI"
									
									IF !ExecCommand(cSql,"cur_saldi_for")
									   return(.f.)
									ENDIF


							    	SELECT cur_saldi_for
								    GO TOP
								    SCAN 
									  SCATTER MEMVAR MEMO
									  INSERT INTO CSALDI_PARTITE FROM MEMVAR
								    ENDSCAN

								
									SELECT(AABBSXS)
									RETURN

						
						CASE _estrai == "T"			&& TUTTI I SALDI SIA DELLE PARTITE APERTE CHE CHIUSE

								*!*	
									__condi__="PAR_NPART = ?_NPART AND PAR_CODCLI = ?_CODCLI"  && PARTITA

									IF _estrai_tutto  = "ESTRAILEPARTITEDELCLIENTE-FORNITORE" 
										__condi__="PAR_CODCLI = ?_CODCLI"	 && TUTTE LE PARTITE DEL FORNITORE	
									ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-SENZAANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_ANOMAX = '   '"	 && TUTTE LE PARTITE DEL FORNITORE SENZA ANOMALIE	
									ENDIF
									
									IF _estrai_tutto = "ESTRAITUTTELEPARTITE" 
										__condi__="1=1"							 && TUTTE LE PARTITE DI TUTTI I FORNITORE	
					 				ENDIF

									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-SENZAANOMALIE" 
										__condi__="PAR_ANOMAX = '   '"	 && TUTTE LE PARTITE DI TUTTI I CLIENTI
					 				ENDIF

									IF _estrai_tutto  = "ESTRAITUTTELEPARTITE-CONANOMALIE-DEL-CLI-FOR" 
										__condi__="PAR_CODCLI = ?_CODCLI AND PAR_ANOMAX <> '   '"	 && TUTTE LE PARTITE DEL CLIENTE SENZA ANOMALIE	
									ENDIF


									IF _estrai_tutto = "ESTRAITUTTELEPARTITE-CONANOMALIE" 
										__condi__="PAR_ANOMAX <> '   '"	 
					 				ENDIF


								*!*	CREA IL CURSORE FOX CONENENTE ULTERIORI CAMPI
									__c1__="par_ragsoc AS ragsoc,par_npart AS npart,par_dtscad AS dtscad,par_fatt AS nsaldo,par_codcli AS codfor"
									__c2__=",par_codacq AS tipopagam,par_cosatratta AS cosatratta,par_gradoimportanza AS gradoimpor,par_formapagamento AS formapagam,par_tipocontratto AS tipocontra,par_codacq AS codacq,par_pripaga AS pripaga"
									__c3__=",par_estrai AS c1sepago,par_estrai AS c1sesposto,par_fatta AS c1quantpag,par_datac AS c1quandpag,par_prty AS c1pripag,par_datac AS c1achescad"
									__c4__=",par_estrai AS c2sepago,par_estrai AS c2sesposto,par_fatta AS c2quantpag,par_datac AS c2quandpag,par_prty AS c2pripag,par_datac AS c2achescad"
									__c5__=",par_estrai AS c3sepago,par_estrai AS c3sesposto,par_fatta AS c3quantpag,par_datac AS c3quandpag,par_prty AS c3pripag,par_datac AS c3achescad"
									__c6__=",par_estrai AS c4sepago,par_estrai AS c4sesposto,par_fatta AS c4quantpag,par_datac AS c4quandpag,par_prty AS c4pripag,par_datac AS c4achescad"
									__c7__=",par_estrai AS c5sepago,par_estrai AS c5sesposto,par_fatta AS c5quantpag,par_datac AS c5quandpag,par_prty AS c5pripag,par_datac AS c5achescad"
									__c8__=",par_datac AS banca,par_contoc AS contocont,par_fatta AS quantavalu,par_datac AS quandovalu,par_anomax AS ANOMALIA"

									__campi__ = __c1__+__c2__+__c3__+__c4__+__c5__+__c6__+__c7__+__c8__


									cSql="SELECT "+__campi__+" FROM SALDI_FOR WHERE " + __condi__ +" order by PAR_CODCLI"
									
									IF !ExecCommand(cSql,"cur_saldi_for")
									   return(.f.)
									ENDIF


							    	SELECT cur_saldi_for
								    GO TOP
								    SCAN 
									  SCATTER MEMVAR MEMO
									  INSERT INTO CSALDI_PARTITE FROM MEMVAR
								    ENDSCAN

								
									SELECT(AABBSXS)
									RETURN

	
				ENDCASE 

				


			*!*	XFABX CREA IL PRIMO CURSORE PER I SALDI DARE

*!*					__campi__="par_ragsoc,par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad,par_anomax"
				__campi__="par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad,par_banca"
				__somma__=", SUM(par_fatt) AS par_fattd,SUM(par_fatta) as par_fatta"

				DO CASE
					CASE _estrai_tutto = "ESTRAITUTTELEPARTITE" 
						__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'D'"  && TUTTE LE PARTITE
						
					CASE _estrai_tutto = "ESTRAITUTTELEPARTITEFORNITORE" 
						__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'D' AND PAR_CODCLI = ?_CODCLI"  && TUTTE LE PARTITE DEL SINGOLO FORNITORE 

					OTHERWISE
						__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'D' AND PAR_NPART = ?_NPART AND PAR_CODCLI = ?_CODCLI"  && PARTITA
				ENDCASE


				IF _estrai == "CREACF"
					__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'D' AND PAR_CODCLI = ?_CODCLI"  && PARTITA FORNITORE
				ENDIF
	
				
				cSql="SELECT "+__campi__+__somma__+" FROM PART_FOR WHERE " + __condi__ +  ;
				    					                          " group by "+__campi__+" order by PAR_CODCLI"
                				    					                          
				    					                          
				IF !ExecCommand(cSql,"cur_dare")
				   return(.f.)
				ENDIF

			*!*	CREA IL SECONDO CURSORE PER I SALDI AVERE
*!*					__campi__="par_ragsoc,par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad,par_anomax"
				__campi__="par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad,par_banca"
				__somma__=", SUM(par_fattd) AS par_fattd, SUM(par_fatt) AS par_fatta"

				
				DO CASE
					CASE _estrai_tutto = "ESTRAITUTTELEPARTITE" 
						__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'A'"  && TUTTE LE PARTITE
						
					CASE _estrai_tutto = "ESTRAITUTTELEPARTITEFORNITORE"   && TUTTE LE PARTITE DEL SINGOLO FORNITORE 
						__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'A' AND PAR_CODCLI = ?_CODCLI"
						
					OTHERWISE
						__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'A' AND PAR_NPART = ?_NPART AND PAR_CODCLI = ?_CODCLI"  && PARTITA
				ENDCASE
				
				
				IF _estrai == "CREACF"
					__condi__="PAR_NPROG > 100 AND PAR_TMOV = 'A'  AND PAR_CODCLI = ?_CODCLI"  && PARTITA FORNITORE
				ENDIF
			
				
				cSql="SELECT "+__campi__+__somma__+" FROM PART_FOR WHERE " + __condi__ +  ;
				    					                          " group by "+__campi__+" order by PAR_CODCLI"
				IF !ExecCommand(cSql,"cur_avere")
				   return(.f.)
				ENDIF


			*!*	CREA IL TERZO CURSORE PER FONDERE I SALDI DARE CON I SALDI AVERE
				SELECT * FROM cur_dare UNION SELECT * FROM cur_avere INTO CURSOR cur_da 


			*!*	CREA IL QUARTO CURSORE FOX PER CALCOLARE IL RECORD DI SALDO
*!*					__campi__="par_ragsoc,par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad,par_anomax"
				__campi__="par_cosatratta,par_gradoimportanza,par_formapagamento,par_tipocontratto,par_codacq,par_pripaga,par_codcli,par_npart,par_dtscad,par_banca"
				__somma__=",SUM(par_fattd-par_fatta) AS par_fatt"
				__condi__="1=1"

				cSql="SELECT "+__campi__+__somma__+" FROM CUR_DA WHERE " + __condi__ +  ;
				    					                          " group by "+__campi__+" INTO CURSOR cu_saldi_for"
				&CSQL

				
				DO CASE 

						CASE _estrai == "CREACF"		&& AGGIORNA I SALDI 


								*!*	CANCELLA I SALDI ESISTENTI DEL FORNITORE
							        CSQL="DELETE FROM SALDI_FOR WHERE PAR_CODCLI = ?_codcli"

							        IF !ExecCommand(CSQL,"")
							           RETURN (.f.)
							        ENDIF 


								*!*	CREA IL QUINTO CURSORE CONTENENTE IL RECORD DI SALDO DELLE PARTITE SIA APERTE CHE CHIUSE									
									*SELECT '    ' AS id_unique,* FROM cu_saldi_for INTO CURSOR CUR_SALDI_FOR

									=RIPORTA_CAMPI_ANAGRAFICA_FORNITORE("cu_saldi_for")
								    
								    IF !ExecRW('','saldi_for','I','','CUR_SALDI_FOR')
								      return(.f.)
								    ENDIF
								    
									_FLAG_DI_VERIFICA_INSERIMENTO_PARTITARIO_FORNITORE = .T.




						CASE _estrai == "CREA"		&& AGGIORNA I SALDI 


								*!*	CANCELLA I SALDI ESISTENTI
									DO CASE 
										CASE _estrai_tutto = "ESTRAITUTTELEPARTITE" 
											CSQL="DELETE FROM SALDI_FOR"  && TUTTE LE PARTITE
											
										CASE _estrai_tutto = "ESTRAITUTTELEPARTITEFORNITORE"   && TUTTE LE PARTITE DEL SINGOLO FORNITORE 
											CSQL="DELETE FROM SALDI_FOR WHERE PAR_CODCLI = ?_codcli"
											
										OTHERWISE
								        	CSQL="DELETE FROM SALDI_FOR WHERE PAR_npart = ?_npart AND PAR_CODCLI = ?_codcli"
								        	
									ENDCASE 

							        IF !ExecCommand(CSQL,"")
							           RETURN (.f.)
							        ENDIF 

								*!*	CREA IL QUINTO CURSORE CONTENENTE IL RECORD DI SALDO DELLE PARTITE SIA APERTE CHE CHIUSE									

									*SELECT '    ' AS id_unique,* FROM cu_saldi_for INTO CURSOR CUR_SALDI_FOR

                                    =RIPORTA_CAMPI_ANAGRAFICA_FORNITORE("cu_saldi_for")
                                    
								    IF !ExecRW('','saldi_for','I','','CUR_SALDI_FOR')
								      return(.f.)
								    ENDIF
								    
									_FLAG_DI_VERIFICA_INSERIMENTO_PARTITARIO_FORNITORE = .T.

						CASE _estrai == "ANNU"		&& ANNULLA TUTTI I SALDI DELLA PARTITA 


								*!*	CANCELLA I SALDI ESISTENTI DELLA PARTITA
									IF _estrai_tutto = "ESTRAITUTTELEPARTITE" 
								        CSQL="DELETE FROM SALDI_FOR"
								        IF !ExecCommand(CSQL,"")
								           RETURN (.f.)
								        ENDIF 
									ELSE
								        CSQL="DELETE FROM SALDI_FOR WHERE PAR_npart = ?_npart AND PAR_CODCLI = ?_codcli"
								        IF !ExecCommand(CSQL,"")
								           RETURN (.f.)
								        ENDIF 
									ENDIF

						CASE _estrai == "ANNUA"		&& ANNULLA TUTTI I SALDI APERTI DELLA PARTITA 


								*!*	CANCELLA I SALDI APERTI ESISTENTI DELLA PARTITA
							        CSQL="DELETE FROM SALDI_FOR WHERE PAR_npart = ?_npart AND PAR_CODCLI = ?_codcli AND PAR_FATT <> ?_zero"
							        IF !ExecCommand(CSQL,"")
							           RETURN (.f.)
							        ENDIF 


						CASE _estrai == "ANNUC"		&& ANNULLA TUTTI I SALDI CHIUSI DELLA PARTITA 

								*!*	CANCELLA I SALDI CHIUSI ESISTENTI DELLA PARTITA
							        CSQL="DELETE FROM SALDI_FOR WHERE PAR_npart = ?_npart AND PAR_CODCLI = ?_codcli AND PAR_FATT = ?_zero"
							        IF !ExecCommand(CSQL,"")
							           RETURN (.f.)
							        ENDIF 

						CASE _estrai == "ANNULLASALDIFORNITORE"		&& ANNULLA TUTTI I SALDI DEL FORNITORE 

							        CSQL="DELETE FROM SALDI_FOR WHERE PAR_CODCLI = ?_codcli "
							        IF !ExecCommand(CSQL,"")
							           RETURN (.f.)
							        ENDIF 




																	
						ENDCASE
				
				
				



ENDCASE

SELECT(AABBSXS)
RETURN




*!*	*****************************************************************************************
*!*	*	 XFAX					 RIPORTA CAMPI ANAGRAFICA FORNITORE SUI SALDI      		    * 
*!*	*****************************************************************************************			
*
FUNCTION RIPORTA_CAMPI_ANAGRAFICA_FORNITORE
PARA 	__CURSORE_DA_ELABORARE

AABBSXSKK  = SELECT()


CREATE CURSOR CUR_SALDI_FOR (;
	 ID_UNIQUE              C(200), ;    
	 PAR_RAGSOC 			C(40),  ;
	 PAR_NPART 				N(10,0),; 
	 PAR_DTSCAD 			C(10),	;       
	 PAR_CODCLI 			C(13),	;       
	 PAR_CODACQ 			C(3),	;        
	 PAR_COSATRATTA 		C(5),	;     
	 PAR_GRADOIMPORTANZA	C(5),	;  
	 PAR_FORMAPAGAMENTO		C(5),	;  
	 PAR_TIPOCONTRATTO		C(5),	;   
	 PAR_PRIPAGA 			C(4),	;       
	 PAR_FATT				N(20,3),; 
	 PAR_FATTD				N(20,3),; 
	 PAR_FATTA				N(20,3),; 
	 PAR_BANCA 				C(10))	   



SELECT &__CURSORE_DA_ELABORARE
GO TOP

DO WHILE .NOT. EOF()

    SELECT &__CURSORE_DA_ELABORARE
	SCATTER MEMVAR 

    ___CODCLI = PAR_CODCLI
    
    x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
    x_codi = "for_codcli = '" + ALLTRIM(SUBSTR(___CODCLI,PUB_SOTTOG,PUB_CONTO)) + "'"
    x_cond = x_soci + " and " + x_codi
    Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
    IF !ExecCommand(cSql,"u_for_an")
      return(.f.)
    ENDIF

	SELECT CUR_SALDI_FOR
	APPEND BLANK
	GATHER MEMVAR
	
    REPLACE PAR_RAGSOC WITH U_FOR_AN.FOR_RAGSOC  

    SELECT &__CURSORE_DA_ELABORARE
  
	
	SKIP +1
	
	
ENDDO WHILE .NOT. EOF()


SELECT &__CURSORE_DA_ELABORARE
GO TOP

SELECT(AABBSXSKK)
RETURN





*!*	***********************************************************************************
FUNCTION CERCA_PARTITE
*!*	***********************************************************************************
*!*	**
*!*	** CREA IL CURSORE SCADE CONTENETE LE PARTITE DEI CLIENTI O DEI FORNITORI
*!*	**
*!*	** ESTRARE LE PARTITE DEI CLIENTI O DEI FORNITORI SEGUENDO LE SEGUENTI REGOLE :
*!*	**
*!*	** PARAMETRI DA GESTIRE :
*!*	**
*!*	**     _CF  		=  C  SE CLIENTE , F SE FORNITORE
*!*	**     _ARCH_IN		=  PART_CLI SE PARTITARIO CLIENTI , PART_FOR SE PARTITARIO FORNITORI
*!*	**     _CONTO		=  CODICE DEL CONTO CLIENTE / FORNITORE (COMPRENSIVO DEL SOTTOGRUPPO)
*!*	**      			=  SE IL CAMPO CONTIENE IL VALORE "TUTTI" ESTRAE TUTTE LE PARTITE APERTE DI TUTTI I FORNITORI ALLA SCADENZA
*!*	**     _DATADAL		=  PERIODO DI AESTRAZIONE DELE PARTITE DAL
*!*	**     _DATAAL		=  PERIODO DI AESTRAZIONE DELE PARTITE AL
*!*	**     _PARTITA		=  NUMERO DELLA PARTITA DA RICERCARE , SE NON INDICATA ESTRAE TUTTO
*!*	**     _NUMREGI		=  NUMERO DI REGISTRAZIONE CONTABILE DA RICERCARE , SE NON INDICATA ESTRAE TUTTO
*!*	**     _CURSORE     =  NOME DEL CURSORE DI LAVORO (SCADE)	
*!*	**     _DTSCADE		=  SE INDICATA ESTRAE TUTTE LE PARTITE SCADUTE ALLA DATA
*!*	**     _DTASCAD		=  SE INDICATA ESTRAE TUTTE LE PARTITE CHE SCADRANNO ALLA DATA
*!*	**     _SOLOSALDO	=  SI: SE INDICATO ESTRAE IL SOLO RECORD DI SALDO DELLA PARTITA DEL CLIENTE O FORNITORE
*!*	**     				=  SCADENZE: MOSTRA LE SCADENZE DELLE PARTITE
*!*	**     				=  SOLO_SCADENZE_NEL_PERIODO: MOSTRA SOLO LE SCADENZE DEL PERIODO _DATDAL-_DATAAL
*!*	**
*!*	**     _ORDINE		=  1 : RITORNA SCADE CODIFICANDO LA CHIAVE (CAMPO : INDICE) IN ORDINE DI DATA DI REGISTRAZIONE
*!*	**      			=  2 : RITORNA SCADE CODIFICANDO LA CHIAVE (CAMPO : INDICE) IN ORDINE DI NUMERO PARTITA / DATA DI SCADENZA
*!*	**      			=  3 : RITORNA SCADE CODIFICANDO LA CHIAVE (CAMPO : INDICE) IN ORDINE DI NUMERO PARTITA 
*!*	**      			=  4 : RITORNA SCADE CODIFICANDO LA CHIAVE (CAMPO : INDICE) IN ORDINE DI ANNO / NUMERO DI REGISTRAZIONE
*!*	**      			=  5 : RITORNA SCADE CODIFICANDO LA CHIAVE (CAMPO : INDICE) IN ORDINE DI DATA DI SCADENZA
*!*	**      			=  6 : RITORNA SCADE CODIFICANDO LA CHIAVE (CAMPO : INDICE) IN ORDINE DI CLIENTE-FORNITORE  
*!*	**      			=  7 : RITORNA SCADE CODIFICANDO LA CHIAVE (CAMPO : INDICE) IN ORDINE DI CLIENTE-FORNITORE / NUMERO PARTITA / DATA DI SCADENZA
*!*	**      			=  8 : RITORNA SCADE CODIFICANDO LA CHIAVE (CAMPO : INDICE) IN ORDINE DI ANNO / NUMERO PARTITA / DATA DI SCADENZA
*!*	**
*!*	**     _OPENCLOSE	=  1 : RITORNA TUTTE LE PARTITE SIA APERTE CHE CHIUSE
*!*	**      			=  2 : RITORNA SOLO I MOVIMENTI DI DETTAGLIO DELLE PARTITE ANCORA APERTE
*!*	**      			=  3 : RITORNA SOLO I MOVIMENTI DI DETTAGLIO DELLE PARTITE CHIUSE CON IL SALDO = 0
*!*	**
*!*	**	   _SOLO_RIBA_  =  0 : NESSUNA CONSIDERAZIONE SULLE RIBA
*!*	**	   			    =  1 : SOLO RIBA SCADENTI
*!*	**		            =  2 : TUTTE LE SCADENZE NON-RIBA + LE SCADENZE RIBA NON CONSOLIDATE
*!*	**		
*!*	**		
*!*	**
*!*	**	   _XTIPOPA_    =  .T. : ELABORA SOLO LE PARTITE RICLASSIFICATE
*!*	**		
*!*	**		
*!*	**		
*!*	** _RISPOSTA        =  .T. SE ALMENO UNA PARTITA E' STATA TROVATA
*!*	**
*!*	**
*!*	** CURSORE DI SUPPORTO DA USARE E DI RITORNO:
*!*	**
*!*	**		SCADE  		=  DA CREARE LA PRIMA VOLTA ; CONTIENE LE PARTITE CLIENTI O FORNITORI
*!*	**						

*** TEST CONTABILITA' PREVISIONALE - FABIANO 16/10/2012: AGGIUNTO PARAMETRO _X_INCLUDE_CONTABILITA_PREVISIONALE  
PARA _CF,_ARCH_IN,_CONTO,_DATADAL,_DATAAL,_PARTITA,_NUMREGI,_CURSORE,_DTSCADE,_DTASCAD,_SOLOSALDO,_ORDINE,_OPENCLOSE,_SOLO_RIBA_,_ELA_AGEN_,_XPARTITA,_XTIPOPA_,_X_INCLUDE_CONTABILITA_PREVISIONALE 


AABBSXS  = SELECT()

*!*	** DEFINIZIONE VARIABILI

IF PCOUNT()<14
	_SOLO_RIBA_= 0
	_XPARTITA  = 0
	_ACCESSO_PER_NUMERO_PARTITA = .F.
	_XTIPOPA_  = .F.
	*** TEST CONTABILITA' PREVISIONALE - FABIANO 16/10/2012
	_X_INCLUDE_CONTABILITA_PREVISIONALE =.F.
ENDIF

IF PCOUNT()<15
	IF _SOLO_RIBA_<>2
		_SOLO_RIBA_= 0
	ENDIF
	_ELA_AGEN_ = ""
	_XPARTITA  = 0
	_ACCESSO_PER_NUMERO_PARTITA = .F.
	_XTIPOPA_  = .F.
	*** TEST CONTABILITA' PREVISIONALE - FABIANO 16/10/2012
	_X_INCLUDE_CONTABILITA_PREVISIONALE =.F.
ENDIF

IF PCOUNT()<16
	IF _SOLO_RIBA_<>2
		_SOLO_RIBA_= 0
	ENDIF
	_ELA_AGEN_ = ""
	_XPARTITA  = 0
	_ACCESSO_PER_NUMERO_PARTITA = .F.
	_XTIPOPA_  = .F.
	*** TEST CONTABILITA' PREVISIONALE - FABIANO 16/10/2012
	_X_INCLUDE_CONTABILITA_PREVISIONALE =.F.
ENDIF

IF PCOUNT()<17
	IF _SOLO_RIBA_<>2
		_SOLO_RIBA_= 0
	ENDIF
	_ELA_AGEN_ = ""
	_XPARTITA  = 0
	_ACCESSO_PER_NUMERO_PARTITA = .F.
	_XTIPOPA_  = .F.
	*** TEST CONTABILITA' PREVISIONALE - FABIANO 16/10/2012
	_X_INCLUDE_CONTABILITA_PREVISIONALE =.F.	
ENDIF




IF PCOUNT()=>16
	IF _XPARTITA > 0
		_ACCESSO_PER_NUMERO_PARTITA = .T.
	ELSE
		_ACCESSO_PER_NUMERO_PARTITA = .F.
	ENDIF 
ENDIF



*** TEST CONTABILITA' PREVISIONALE - FABIANO 16/10/2012 - VALORIZZA CONDIZIONE  X_CONTABILITA_PREVISIONALE
X_CONTABILITA_PREVISIONALE=" AND PAR_CONTABILITA_PREVISIONALE<>'P' "
IF PCOUNT()=>18
	IF _X_INCLUDE_CONTABILITA_PREVISIONALE 
		X_CONTABILITA_PREVISIONALE= ""
	ENDIF 
ENDIF



*** GESTIONE SALDI SCADENZE - FABIANO 21/07/2011
*** CREO UN CURSOR SALDI_SCADENZE PER RACCOGLIERE LE SCADENZE
*** IL CURSOR HA LA STESSA STRUTTURA DI SALDI_APERTI_CHIUSI
***
*** GESTIONE SALDI SCADENZE - FABIANO 18/03/2012
*** PER I CLIENTI: SOLO SALDO="SOLO_SCADENZE_NEL_PERIODO"
***                MOSTRA SOLO LE SCADENZE NEL PERIODO _DATADAL - _DATAAL
IF _SOLOSALDO="SCADENZE" OR _SOLOSALDO="SOLO_SCADENZE_NEL_PERIODO"
	AFIELDS( _ARRAY_SALDI_APERTI_CHIUSI ,"SALDI_APERTI_CHIUSI" )		
	CREATE CURSOR SALDI_SCADENZE FROM ARRAY _ARRAY_SALDI_APERTI_CHIUSI  
	SELECT SALDI_SCADENZE 												
	INDEX ON ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))+DTSCAD TAG DTSCAD && INDICE PER CODICE CLI/FOR + NR.PARTITA + DATA SCADENZA 
	SET ORDER TO DTSCAD													
ENDIF


M.DDARE    = 0
M.AAVERE   = 0
XTCSALDO   = 0
TDARE      = 0
TAVERE     = 0
TSALDO     = 0
SALDO_PREC = 0
_RISPOSTA  = .T.

*!*	** DEFINIZIONE CURSORI
=DEF_EURO()		&& DEFINISCE IL CURSORE PER LA GESTIONE DEI PARTITARI

*!*	** ACCESSO AI PARTITARI CLIENTI / FORNITORI
x_data = ""
x_agen = ""
x_npart = ""
x_codi = ""
x_nreg = ""
	
DO CASE

   CASE ALLTRIM(_CONTO) = "TUTTI" 					&& PARTITE DI TUTTI I FORNITORI SCADUTE ALLA DATA DI SCADENZA INDICATA
   
		_CONTO = ""
		_DTPARTI = "01/01/1990"
		x_dt1  = RIBALTA2(_DTPARTI) 
		x_dt2  = RIBALTA2(_DTSCADE) 
		x_data = "AND par_dtscad between '" + x_dt1 + "' and '" + x_dt2 + "'"

  
   CASE ALLTRIM(_CONTO) = "AGENTE" 					&& PARTITE DI TUTTI I FORNITORI SCADUTE ALLA DATA DI SCADENZA INDICATA
   
 		_CONTO = ""
		_DTPARTI = "01/01/1990"
		x_dt1  = RIBALTA2(_DTPARTI) 
		x_dt2  = RIBALTA2(_DTSCADE) 
		x_data = "AND par_dtscad between '" + x_dt1 + "' and '" + x_dt2 + "'"
		x_agen = IIF(EMPTY(_ELA_AGEN_),"","AND CLIENTI.cli_age = '"+ALLTRIM(_ELA_AGEN_)+"'")
		   
   CASE _PARTITA <> 0 					&& SOLO UNA PARITA MIRATA
   
		
*!*			_DTPARTI = "01/01/1990"
*!*			x_dt1  = RIBALTA2(_DTPARTI) 
*!*			x_dt2  = RIBALTA2(_DTSCADE) 
*!*			x_data = "AND par_dtscad between '" + x_dt1 + "' and '" + x_dt2 + "'" 
		
		x_codi = "AND par_codcli = '" + ALLTRIM(_CONTO) + "'"
		IF _ACCESSO_PER_NUMERO_PARTITA
			x_npart= " AND par_npart = " + ALLTRIM(STR(_PARTITA,10,0))
		ELSE
			x_npart= ''
		ENDIF  	
	

   CASE !EMPTY(_NUMREGI) 					&& SOLO UNA PARTITA MIRATA ED IDENTIFICATA PER NUMERO DI REGISTRAZIONE 

		x_codi = "AND par_codcli = '" + ALLTRIM(_CONTO) + "'"
		x_dt1  = RIBALTA2(_DATADAL) 
		x_dt2  = RIBALTA2(_DATAAL) 
		x_data = "AND par_dtreg between '" + x_dt1 + "' and '" + x_dt2 + "'"
		x_nreg = "AND par_nreg =  " + ALLTRIM(_NUMREGI)  

   CASE !EMPTY(_DTSCADE) 					&& PARTITE SCADUTE ALLA DATA DI SCADENZA INDICATA
      ********************************************************************************************************************
      *** SIMONE - 27/03/2009 - AGGIUNTO IN ORDER BY IL CAMPO PAR_NPART PER PROBLEMA RILEVATO SULLO STORICO CONTABILE, 
      **                        QUANDO VIENE MESSA LA SPUNTA "CHIUSURA PARTITE IN AUTOMATICO"
      ***                       LA PRIMA VOLTA DA' UNA CIFRA DI SALDO, CHE è DIVERSA DALLA SECONDA VOLTA
      ********************************************************************************************************************

		x_codi = "AND par_codcli = '" + ALLTRIM(_CONTO) + "'"
		_DTPARTI = "01/01/1990"
		x_dt1  = RIBALTA2(_DTPARTI) 
		x_dt2  = RIBALTA2(_DTSCADE) 
		x_data = "AND par_dtscad between '" + x_dt1 + "' and '" + x_dt2 + "'"
 
   CASE !EMPTY(_DTASCAD) 					&& PARTITE CHE ANDRANNO A SCADERE IN BASE ALLA DATA DI SCADENZA INDICATA 
   
		x_codi = "AND par_codcli = '" + ALLTRIM(_CONTO) + "'"
		_DTARRIVO = "31/12/2990"
		x_dt1  = RIBALTA2(_DTASCAD) 
		x_dt2  = RIBALTA2(_DTARRIVO) 
		x_data = "AND par_dtscad between '" + x_dt1 + "' and '" + x_dt2 + "'"

   OTHERWISE

		x_codi = "AND par_codcli = '" + ALLTRIM(_CONTO) + "'"
		x_dt1  = RIBALTA2(_DATADAL) 
		x_dt2  = RIBALTA2(_DATAAL) 
		x_data = "AND par_dtreg between '" + x_dt1 + "' and '" + x_dt2 + "'"


ENDCASE

IF _SOLOSALDO="SCADENZE" OR _SOLOSALDO="SOLO_SCADENZE_NEL_PERIODO"
		_DTINIZIO = "01/01/1990"
		_DTARRIVO = "31/12/2999"
		x_dt1  = RIBALTA2(_DTINIZIO) 
		x_dt2  = RIBALTA2(_DTARRIVO) 
		x_data = "AND par_dtscad between '" + x_dt1 + "' and '" + x_dt2 + "'"
		x_data = ""
		
		X_DATA = X_DATA + "AND PAR_DTREG <='" + RIBALTA2(_DATAAL) + "'"
ENDIF



WAIT WINDOW "ATTENDERE PREGO... estrazione partitario in corso" NOWAIT

cSql=""     
cNomeCursorSql="CURS_PART"
SOTTOGEN("ITA")
_START_COD_CLI=LEN(PUB_CC)+1
_START_COD_FOR=LEN(PUB_FF)+1
	
IF _CF  = "C"        && VERIFICA SE CLIENTE

	*** TEST CONTABILITA' PREVISIONALE - FABIANO 16/10/2012 - AGGIUNTA CONDIZIONE  <<X_CONTABILITA_PREVISIONALE>>
	*** FABIANO 05/05/2015 - AGGIUNTA TIPOLOGIA PARTITA 
	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
   		SELECT 	COALESCE(CL.CLI_RAGSOC,PA.PAR_RAGSOC) AS CLI_RAGSOC,
   				COALESCE(CL.CLI_CAP,'') AS CLI_CAP,
   				COALESCE(CL.CLI_INDIR,'') AS CLI_INDIR,
   				COALESCE(CL.CLI_LOCALI,'') AS CLI_LOCALI,
   				COALESCE(CL.CLI_AGE,'') AS CLI_AGE,
   				COALESCE(CL.CLI_AGE,'') AS AGENTE,
   				COALESCE(AGE.DESCRI,'') AS DESCRI_AGENTE,
				PA.PAR_TIPFAT  AS TIPOOPE ,
				COALESCE(SUBSTRING(PARTOP.LIBERA,2,1),'')  AS FLAG_NATURA ,
				COALESCE(SUBSTRING(PARTOP.LIBERA,10,1),'')  AS FLAG_RIBA_TOP ,
				COALESCE(SUBSTRING(PARTOP.LIBERA,11,1),'')  AS FLAG_NOTAC_TOP ,
				COALESCE(SUBSTRING(PARTOP.LIBERA,56,1),'')  AS FLAG_TRATTA_TOP ,
				COALESCE(SUBSTRING(PAR.LIBERA,10,1),'')  AS FLAG_RIBA,
				COALESCE(TPA.DESCRI,'')  AS DESCRI_TIPOPA,
   				PA.* 
   		FROM PART_CLI AS PA 
   		LEFT OUTER JOIN U_CLI_AN AS CL 	
   		ON SUBSTRING(PA.PAR_CODCLI,<<_START_COD_CLI>>,LEN(PA.PAR_CODCLI))=CL.CLI_CODCLI 
   		LEFT OUTER JOIN PARA AS PAR
   		ON PAR.CODICE='CPA'+PA.PAR_CODPAG 
   		LEFT OUTER JOIN PARA AS PARTOP
   		ON PARTOP.CODICE='TOP'+PA.PAR_TIPFAT  
		LEFT OUTER JOIN PARA AS TPA
		ON TPA.CODICE='TPA'+PA.PAR_TIPOPA 
		LEFT OUTER JOIN PARA AS AGE
		ON AGE.CODICE='AGE'+COALESCE(CL.CLI_AGE,'') 
   		WHERE PAR_CODSOC = '<<PUB_CODSOC>>'
	        AND PAR_NPROG <> 100 <<x_data>> <<x_codi>> <<x_agen>> <<x_npart>> <<x_nreg>>  <<X_CONTABILITA_PREVISIONALE>>
        ORDER BY PAR_CODSOC,PAR_CODCLI,PAR_NPART

	ENDTEXT					&& FINE SCRITTURA QUERY
ELSE

	*** TEST CONTABILITA' PREVISIONALE - FABIANO 16/10/2012 - AGGIUNTA CONDIZIONE  <<X_CONTABILITA_PREVISIONALE>>
	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
   		SELECT 	COALESCE(FO.FOR_RAGSOC,'PA.PAR_RAGSOC') AS FOR_RAGSOC,
   				COALESCE(FO.FOR_CAP,'') AS FOR_CAP,
   				COALESCE(FO.FOR_INDIR,'') AS FOR_INDIR,
   				COALESCE(FO.FOR_LOCALI,'') AS FOR_LOCALI,
   				COALESCE(FO.FOR_BAE,'') AS FOR_BAE,
				PA.PAR_TIPFAT  AS TIPOOPE ,
				COALESCE(SUBSTRING(PARTOP.LIBERA,2,1),'')  AS FLAG_NATURA ,
				COALESCE(SUBSTRING(PARTOP.LIBERA,10,1),'')  AS FLAG_RIBA_TOP ,
				COALESCE(SUBSTRING(PARTOP.LIBERA,11,1),'')  AS FLAG_NOTAC_TOP ,
				COALESCE(SUBSTRING(PARTOP.LIBERA,56,1),'')  AS FLAG_TRATTA_TOP ,
				COALESCE(SUBSTRING(PAR.LIBERA,10,1),'')  AS FLAG_RIBA,
				COALESCE(TPA.DESCRI,'')  AS DESCRI_TIPOPA,
   				PA.*
   		FROM PART_FOR AS PA 
   		LEFT OUTER JOIN U_FOR_AN AS FO	
   		ON SUBSTRING(PA.PAR_CODCLI,<<_START_COD_FOR>>,LEN(PA.PAR_CODCLI))=FO.FOR_CODCLI 
   		LEFT OUTER JOIN PARA AS PAR
   		ON PAR.CODICE='CPA'+PA.PAR_CODPAG 
   		LEFT OUTER JOIN PARA AS PARTOP
   		ON PARTOP.CODICE='TOP'+PA.PAR_TIPFAT  
		LEFT OUTER JOIN PARA AS TPA
		ON TPA.CODICE='TPA'+PA.PAR_TIPOPA 
   		WHERE PAR_CODSOC = '<<PUB_CODSOC>>' 
	        AND PAR_NPROG <> 100 <<x_data>> <<x_codi>> <<x_agen>> <<x_npart>> <<x_nreg>>  <<X_CONTABILITA_PREVISIONALE>>
        ORDER BY PAR_CODSOC,PAR_CODCLI,PAR_NPART 

	ENDTEXT					&& FINE SCRITTURA QUERY

ENDIF



IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF

SELECT CURS_PART
GO TOP




WAIT WINDOW "ATTENDERE PREGO... verifica partite estratte" NOWAIT



DO WHILE !EOF()

	   
   SELECT CURS_PART
   M.DTREG       = RIBALTA2(PAR_DTREG)
   M.NREG        = PAR_NREG
   M.NFAT        = PAR_NUMFAT

*!*	IF PAR_NPART = 120615
*!*		SET STEP ON 
*!*	ENDIF

*!*	   IF PAR_NOPART = .T.		&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*		  SELECT CURS_PART		&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*		  SKIP +1				&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*		  LOOP					&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*	   ENDIF					&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	

   DO CASE

	  CASE _ORDINE      = 1    && TUTTE IN ORDINE DI DATA REGISTRAZIONE
 		   M.INDICE      = STRTRAN(PAR_DTREG,"/","")

 	  CASE _ORDINE      = 2    && TUTTE IN ORDINE DI NUMERO PARTITA / SCADENZA
		   M.INDICE      = ALLTRIM(STR(PAR_NPART,10,0))+STRTRAN(PAR_DTSCAD,"/","")+PAR_NUMFAT

	  CASE _ORDINE      = 3    && TUTTE IN ORDINE DI NUMERO PARTITA	
  		   M.INDICE      = ALLTRIM(STR(PAR_NPART,10,0))+ALLTRIM(STR(PAR_NPROG,10,0))
           
	  CASE _ORDINE      = 4    && TUTTE IN ORDINE DI ANNO / NUMERO REGISTRAZIONE
  		   M.INDICE      = PAR_ANNO + ALLTRIM(PAR_NREG)

	  CASE _ORDINE      = 5    && TUTTE IN ORDINE DI DATA SCADENZA
		   M.INDICE      = STRTRAN(PAR_DTSCAD,"/","")

	  CASE _ORDINE      = 6    && TUTTE IN ORDINE DI FORNITORE 
		   M.INDICE      = ALLTRIM(PAR_CODCLI)
		   
	  CASE _ORDINE      = 7    && TUTTE IN ORDINE DI FORNITORE / NUMERO PARTITA / SCADENZA  
		   M.INDICE      = ALLTRIM(PAR_CODCLI)+ALLTRIM(STR(PAR_NPART,10,0))+STRTRAN(PAR_DTSCAD,"/","")
		   
	  CASE _ORDINE      = 8    && TUTTE IN ORDINE DI ANNO / NUMERO PARTITA / SCADENZA  
		   M.INDICE      = PAR_ANNO +ALLTRIM(STR(PAR_NPART,10,0))+STRTRAN(PAR_DTSCAD,"/","")
     
   ENDCASE

   M.SELEZIONE                  = ""
   M.DESMOV      				= PAR_DESMOV
   M.DESMOV1     				= PAR_DESMO1
   M.CAMBIO      				= PAR_CAMBIO
   M.IMPVAL      				= PAR_IMPVAL
   M.VALUTA      				= PAR_VALUTA
   M.NPART       				= PAR_NPART
   M.NPARTO      				= PAR_NPARTO
   M.CPA         				= PAR_CODPAG
   M.ANNOK       				= PAR_ANNO
   M.NPROGK     				= PAR_NPROG
   M.CONTABILITA_PREVISIONALE 	= PAR_CONTABILITA_PREVISIONALE
   M.CODFOR 					= SUBSTR(PAR_CODCLI,PUB_SOTTOG,PUB_CONTO)
   M.COD_CONTO					= PAR_CODCLI
   M.cosatratta 				= PAR_cosatratta
   M.gradoimportanza			= PAR_gradoimportanza
   M.formapagamento				= PAR_formapagamento
   M.tipocontratto				= PAR_tipocontratto		
   M.codacq						= PAR_codacq
   M.pripaga					= PAR_pripaga
   M.indiri						= ""
   M.locali						= ""
   M.SYS_PARTI					= SYS_PARTI
   M.BANCAFOR                   = PAR_BANCA
   M.ANOMAX						= PAR_ANOMAX
   M.ID_UNIQUE					= ID_UNIQUE  		 	&& SIMONE - 27/03/2009     

   M.FLAG_RIBA   				= FLAG_RIBA  			&& FABIANO 30/12/2011 - VALE 'X' SE LE CONDIZIONI DI PAGAMENTO SONO RIBA
   M.FLAG_RIBA_TOP 				= FLAG_RIBA_TOP			&& FABIANO 06/03/2012 - VALE 'S' SE IL TOP E' DI TIPO RIBA
   M.FLAG_NOTAC_TOP 			= FLAG_NOTAC_TOP 		&& FABIANO 26/04/2012 - VALE 'S' SE IL TOP E' DI TIPO NOTA CREDITO
   M.FLAG_TRATTA_TOP 			= FLAG_TRATTA_TOP 		&& FABIANO 04/05/2012 - VALE 'S' SE IL TOP E' DI TIPO TRATTA
   M.FLAG_NATURA   				= FLAG_NATURA       	&& FABIANO 30/12/2011 - VALE 'S' SE TOP FATTURE CLI/FOR
   M.TIPOOPE   				    = TIPOOPE   			&& FABIANO 30/12/2011 - TOP DELLA SCADENZA
   M.TIPOPA  				    = PAR_TIPOPA 			&& FABIANO 08/01/2012 - PROCEDURA RECUPERO CREDITI
   M.BLOCCO                     = PAR_BLOCCO            && FABIANO 08/01/2012 - PAGAMENTO BLOCCATO
   M.STORIA                     = PAR_STORIA            && FABIANO 08/01/2012 - IDENTIFICA LA SITUAZIONE DELLA PARTITA   
   M.MOVNUMPRO                  = PAR_NUMPRO			&& SERGIO  22/04/2012 - IDENTIFICA IL LEGAME ALLA PRIMA NOTA

   M.CODTIPOPA 					= PAR_TIPOPA            && FABIANO 05/05/2013 - TIPO PARTITA 
   M.DESTIPOPA 					= DESCRI_TIPOPA			&& FABIANO 05/05/2013 - DESCRIZIONE TIPO PARTITA 
   
   M.RAGSOC = ""
   M.indiri = ""
   M.locali = ""
   _X_AGE_  = ""
   
   IF _CF  = "C"        && VERIFICA SE CLIENTE
		M.RAGSOC    = CLI_RAGSOC
		M.indiri	= CLI_CAP + " - " + ALLTRIM(CLI_INDIR)
		M.locali	= ALLTRIM(CLI_LOCALI)
		_X_AGE_     = CLI_AGE		  
      
		M.CODAGE	= AGENTE				&& FABIANO 05/05/2013 - CODICE AGENTE 
		M.DESAGE 	= DESCRI_AGENTE         && FABIANO 05/05/2013 - DESCRIZIONE AGENTE
   ELSE	   
       	M.RAGSOC    = FOR_RAGSOC
	   	M.indiri	= FOR_CAP + " - " + ALLTRIM(FOR_INDIR)
	   	M.locali	= ALLTRIM(FOR_LOCALI)
       	IF EMPTY(M.BANCAFOR)
			M.BANCAFOR = FOR_BAE
		ENDIF
		
		M.CODAGE	= ""				&& FABIANO 05/05/2013 - CODICE AGENTE 
		M.DESAGE 	= ""         		&& FABIANO 05/05/2013 - DESCRIZIONE AGENTE		
   ENDIF
   
   
   SELECT CURS_PART
   
   IF EMPTY(M.DTREG)
      M.DTREG = REPLICATE(" " ,10)
   ENDIF

   IF _CF  = "C"					&& CLIENTI
      M.NUMPRO      = PAR_NPROT
      M.NUMDOC      = PAR_NPROT
   ELSE								&& FORNITORI
      M.NUMPRO      = SPACE(06)
      M.NUMDOC      = PAR_NUMFAT
   ENDIF

   SP  = LEN(ALLTRIM(M.NUMDOC))
   _SP = (7 - SP)
   M.NUMDOC = REPLICATE(" " ,_SP)+ ALLTRIM(M.NUMDOC)

   M.DTDOC       = RIBALTA2(PAR_DTFAT)
   IF EMPTY(M.DTDOC)
      M.DTDOC = REPLICATE(" " ,10)
   ENDIF
       
   IF PAR_NPROG <> 100
      PR   = PAR_NPROG-100
      WTF  = PAR_TIPFAT
      DAT  = RIBALTA2(PAR_DATPAG)
      DA   = 0     && IMPORTO TRANCHE DARE
      TA   = 0      
      AV   = 0     && IMPORTO TRANCHE AVERE
      NAT   =  PAR_TMOV    && PRENDE LA NATURA DEL MOVIMENTO DAL DATABASE 
	  SELECT CURS_PART
      DDOC   = RIBALTA2(PAR_DTFAT)
      
      IF _CF  = "C"     				   && CLIENTE  : FATT = DARE
         IF NAT = "D"
            DA   = PAR_FATT
            DS   = RIBALTA2(PAR_DTSCAD)
         ELSE
            AV   = PAR_FATT
		    DS   = RIBALTA2(PAR_DTSCAD)
         ENDIF
      ELSE
         IF NAT = "A"				       && FORNITORE : FATT= AVERE   
            AV   = PAR_FATT
            DS   = RIBALTA2(PAR_DTSCAD)
         ELSE
            DA   = PAR_FATT
		    DS   = RIBALTA2(PAR_DTSCAD)
         ENDIF
      ENDIF
      
      IF M.VALUTA = PUB_VALRIF
         X_VAL_D = DA
         X_VAL_A = AV
      ELSE
          IF PUB_VALRIF = 'EUR'		
            X_VAL_D = TEURO(M.VALUTA,DA,DDOC)    
            X_VAL_A = TEURO(M.VALUTA,AV,DDOC)    
         ELSE										
            X_VAL_D = TLIRE(M.VALUTA,DA,DDOC)    	
            X_VAL_A = TLIRE(M.VALUTA,AV,DDOC)    	
         ENDIF										
      ENDIF

      M.DDARE  = M.DDARE + X_VAL_D
      M.AAVERE = M.AAVERE + X_VAL_A 

      TDARE   = TDARE + X_VAL_D
      TAVERE  = TAVERE + X_VAL_A
      
      **** FABIANO 30/12/2011
      **** SE STO CONSIDERANDO LE RIBA EFFETIVAMENTE INCASSATE ----------------------------- CASO DI RIBA EFFETTIVAMENTE INCASSATE
      **** CONTROLLO LE DATE DI SCADENZA POSTICIPATE
      **** SE LA SCADENZA POSTICIPATA NON RIENTRA NELL'INTEVALLO
      **** NON AGGIUNGO QUESTA RIGA IN CURSORE SCADE
      **** 
 *FAB?????     
      
      M.DTPOSTRIBA=""
	  IF _SOLO_RIBA_  = 2
		
			*** FABIANO 30/12/2011
			*** SE E' UNA RIBA CONTROLLO LA SCADENZA POSTICIPATA
			***IF M.FLAG_RIBA ='X' AND M.FLAG_NATURA<>'S' 
			IF M.FLAG_RIBA ='X' 
		    	
		      	*** CONTROLLO DATA SCADENZA DS - GG/MM/AAAAA
		    	M.DTPOSTRIBA  = DTOC(CTOD(DS)+PUB_GGRIBA)
		    ELSE
		    	M.DTPOSTRIBA  = DS
				
			ENDIF
			
	  ENDIF
      
      SELECT SCADE
    
      APPEND BLANK
      GATHER MEMVAR
      REPLACE SELEZIONE                 WITH M.SELEZIONE
      REPLACE DTREG   					WITH M.DTREG 
      REPLACE NREG    					WITH M.NREG
      REPLACE INDICE  					WITH M.INDICE 
      REPLACE NUMDOC  					WITH M.NUMDOC  
      REPLACE NUMPRO  					WITH M.NUMPRO
      REPLACE DTDOC   					WITH M.DTDOC
      REPLACE DESMOV  					WITH M.DESMOV
      REPLACE DESMOV1 					WITH M.DESMOV1
      REPLACE CAMBIO  					WITH M.CAMBIO
      REPLACE IMPVAL  					WITH M.IMPVAL
      REPLACE VALUTA  					WITH M.VALUTA
      REPLACE CODFOR  					WITH M.CODFOR
      REPLACE RAGSOC  					WITH M.RAGSOC
	  REPLACE cosatratta 				WITH M.cosatratta
      REPLACE gradoimportanza			WITH M.gradoimportanza
      REPLACE formapagamento			WITH M.formapagamento
      REPLACE tipocontratto				WITH M.tipocontratto		
      REPLACE codacq					WITH M.codacq
      REPLACE pripaga					WITH M.pripaga
      REPLACE indiri 				  	WITH M.indiri
	  REPLACE locali					WITH M.locali
	  REPLACE SYS_PARTI					WITH M.SYS_PARTI
	  REPLACE BANCAFOR                  WITH M.BANCAFOR          
	  REPLACE anomax	                WITH m.anomax    
	  REPLACE KEY_UNIQUE 				WITH M.ID_UNIQUE		 && SIMONE - 27/03/2009
	  REPLACE FLAG_RIBA					WITH M.FLAG_RIBA
	  REPLACE DTPOSTRIBA                WITH M.DTPOSTRIBA
	  REPLACE FLAG_NATURA               WITH M.FLAG_NATURA
	  REPLACE TIPOOPE                   WITH M.TIPOOPE  
	  REPLACE TIPOPA                    WITH M.TIPOPA            && FABIANO 08/01/2012 - PROCEDURA RECUPERO CREDITI
	  REPLACE BLOCCO                    WITH M.BLOCCO            && FABIANO 08/01/2012 - PAGAMENTO BLOCCATO
	  REPLACE STORIA                    WITH M.STORIA            && FABIANO 08/01/2012 - IDENTIFICA LA SITUAZIONE DELLA PARTITA 
      REPLACE MOVNUMPRO 				WITH M.MOVNUMPRO 		 && SERGIO  22/04/2012 - LEGAME ALLA REGISTRAZIONE DI PRIMA NOTA
  
      IF EMPTY(DS)
         REPLACE DTSCAD WITH REPLICATE(" " ,10)
      ELSE
         REPLACE DTSCAD WITH DS
         REPLACE DTSCADE WITH CTOD(DS)
      ENDIF
      

      N_SALDO 	 = DA - AV
      SALDO_PREC = SALDO_PREC + N_SALDO
      N_SALDO 	 = SALDO_PREC
    
      _SA = 15 - LEN(ALLTRIM(STR(N_SALDO,15,3)))
    
      REPLACE V_SALDO WITH REPLICATE(" " ,_SA) + ALLTRIM(STR(N_SALDO,15,3))
      REPLACE NSALDO  WITH NSALDO
         
      _WT = 3 - LEN(ALLTRIM(WTF))
      REPLACE TIPODOC WITH REPLICATE(" " ,_WT) + ALLTRIM(WTF)
      
      IF DA = 0
         REPLACE DARE  WITH REPLICATE(" " ,11)
         REPLACE NDARE WITH 0
      ELSE  
         _DA = 15 - LEN(ALLTRIM(STR(DA,15,3)))
         REPLACE DARE  WITH REPLICATE(" " ,_DA) + ALLTRIM(STR(DA,15,3))
         REPLACE NDARE WITH DA
      ENDIF   
    
      IF AV = 0
         REPLACE AVEREX WITH REPLICATE(" " ,15)
         REPLACE NAVERE WITH 0
      ELSE  
         _AV = 15 - LEN(ALLTRIM(STR(AV,15,3)))
         REPLACE AVEREX WITH REPLICATE(" " ,_AV) + ALLTRIM(STR(AV,15,3))
         REPLACE NAVERE WITH AV
      ENDIF   

   ENDIF


	*!*	** CREA I SALDI PARTITA
	IF _OPENCLOSE = 1 OR _OPENCLOSE = 2 OR _OPENCLOSE = 3

		SELECT SCADE
		SCATTER MEMVAR MEMO
		 
		_SEEK = ALLTRIM(M.CODFOR)+ALLTRIM(STR(M.NPART,10,0)) 	&& SERGIO  25/7/06
		SELECT SALDI_APERTI_CHIUSI								&& SERGIO  25/7/06
		SET ORDER TO NUMPART 									&& SERGIO  25/7/06
    	 
		SEEK _SEEK
		IF FOUND()
			REPLACE NDARE    WITH NDARE + M.NDARE					&& SOMMO TUTTI I DARE
			REPLACE NAVERE   WITH NAVERE + M.NAVERE					&& SOMMO TUTTI GLI AVERE
			REPLACE NSALDO   WITH NDARE - NAVERE					&& CALCOLO IL SALDO
			REPLACE DARE     WITH STR(NDARE,15,3)
			REPLACE AVEREX   WITH STR(NAVERE,15,3)
		ELSE
			APPEND BLANK
			GATHER MEMVAR MEMO
			REPLACE DTSCAD 	WITH RIBALTA2(M.DTSCAD)
			REPLACE DTSCADE WITH CTOD(M.DTSCAD)
			REPLACE DARE  	WITH STR(NDARE,15,3)
			REPLACE AVEREX 	WITH STR(NAVERE,15,3)
			REPLACE NSALDO 	WITH M.NDARE - M.NAVERE
			REPLACE NDARE   WITH M.NDARE
			REPLACE NAVERE  WITH M.NAVERE
		ENDIF
		
		*!*	** CREA I SALDI SCADENZA && FABIANO 20/07/2011
		IF _SOLOSALDO="SCADENZE" OR _SOLOSALDO="SOLO_SCADENZE_NEL_PERIODO"
		
			SELECT SCADE
			SCATTER MEMVAR MEMO
			
			*_SEEK = ALLTRIM(M.CODFOR)+ALLTRIM(STR(M.NPART,10,0))+RIBALTA2(M.DTSCAD)
			_SEEK = ALLTRIM(M.CODFOR)+ALLTRIM(STR(M.NPART,10,0))+M.DTSCAD  && ERASMO - 16/11/2011
			SELECT SALDI_SCADENZE
			SET ORDER TO DTSCAD  
			
			SEEK _SEEK
			IF FOUND()
				REPLACE NDARE    WITH NDARE + M.NDARE					&& SOMMO TUTTI I DARE
				REPLACE NAVERE   WITH NAVERE + M.NAVERE					&& SOMMO TUTTI GLI AVERE
				REPLACE NSALDO   WITH NDARE - NAVERE					&& CALCOLO IL SALDO
				REPLACE DARE     WITH STR(NDARE,15,3)
				REPLACE AVEREX   WITH STR(NAVERE,15,3)
			   	__GGOGGI = TRASGG("GMA",DTOC(DATE()))
			   	__GGIERI = TRASGG("GMA",M.DTSCAD)
			   	__GGSCAD = __GGOGGI - __GGIERI   	
			    REPLACE GGESPOS WITH __GGSCAD 
			ELSE
				APPEND BLANK
				GATHER MEMVAR MEMO
				*REPLACE DTSCAD 	WITH RIBALTA2(M.DTSCAD)
				REPLACE DTSCAD 	WITH M.DTSCAD  && ERASMO - 16/11/2011
				REPLACE DTSCADE WITH CTOD(M.DTSCAD)
				REPLACE DARE  	WITH STR(NDARE,15,3)
				REPLACE AVEREX 	WITH STR(NAVERE,15,3)
				REPLACE NSALDO 	WITH M.NDARE - M.NAVERE
				REPLACE NDARE   WITH M.NDARE
				REPLACE NAVERE  WITH M.NAVERE
			   	__GGOGGI = TRASGG("GMA",DTOC(DATE()))
			   	__GGIERI = TRASGG("GMA",M.DTSCAD)
			   	__GGSCAD = __GGOGGI - __GGIERI   	
			    REPLACE GGESPOS WITH __GGSCAD 
			ENDIF
			
		ENDIF

	ENDIF
	
	SELECT CURS_PART
	SKIP +1

ENDDO



*!*	IF PAR_NPART = 120615
*!*		SET STEP ON 
*!*	ENDIF



*** FABIANO 31/01/2011
*** SE STO GESTENDO LE RIBA NON CONSOLODITE
*** FACCIO UNA GESTIONE IN UNA ROUTINE SEPARATA 
*** E POI ESCO DAL PROGRAMMA
IF _SOLO_RIBA_  =2 AND (_SOLOSALDO = "SCADENZE" OR _SOLOSALDO="SOLO_SCADENZE_NEL_PERIODO")  AND _OPENCLOSE = 2

	DO CREA_CURSORI_DI_VERIFICA_PER_ELABORAZIONE_SCADENZIARIO_CLIENTI WITH _DATAAL

	DO CERCA_SALDI_SCADENZE_CONVERTITE
	
	**************************************************************
	DO CERCA_PARTITE_GESTIONE_RISCHIO_RIBA WITH _XTIPOPA_,_DATAAL
	**************************************************************
	
	DO AGGIUNGI_SU_SCADE_SALDI_SCADENZE_CONVERTITE
	
	IF _SOLOSALDO="SOLO_SCADENZE_NEL_PERIODO"
		DO MOSTRA_SOLO_SCADENZE_NEL_PERIODO WITH _DATADAL,_DATAAL
	ENDIF	
	
	WAIT WINDOW "ATTENDERE PREGO... elaborazione scadenziario terminata correttamente" NOWAIT
	
	SELECT(AABBSXS)
	RETURN(.T.)

ENDIF 
**** FINE GESTIONE RIBA NON CONSOLIDATE


*** FABIANO 31/01/2011
**** SE NON MI INTERESSA FARE RAGIONAMENTI SULLE RIBA NON CONSOLIDATE
**** PROSEGUO NORMALMENTE NEL PROGAMMA


*** CANCELLA LE PARTITE CHIUSE
WAIT WINDOW "ATTENDERE PREGO... verifica partite chiuse" NOWAIT

IF _OPENCLOSE = 2  AND _SOLOSALDO <> "SI" AND _SOLOSALDO <> "SCADENZE" AND _SOLOSALDO<>"SOLO_SCADENZE_NEL_PERIODO"

	SELECT SCADE 
	GO TOP

	DO WHILE .NOT. EOF()
	
	     SCATTER MEMVAR MEMO
	     
		 IF _SOLO_RIBA_ = 1		&& SE SI DESIDERANO LE RIBA : NON VIENE VERIFICATO IL SALDO

		     __NORIBA  = " "
		     XX_SEEK = "CPA"+ALLTRIM(M.CPA)
		     IF SEEK_STD('PARA',XX_SEEK,'CODICE','__CPA_PARA')
		       SELECT __CPA_PARA
			   __NORIBA = SUBSTR(LIBERA,10,1)
			 ENDIF

	         _SEEK = ALLTRIM(M.CODFOR)+ALLTRIM(STR(M.NPART,10,0))   && SERGIO 25/7/06
			 SELECT SALDI_APERTI_CHIUSI								&& SERGIO 25/7/06
	    	 SET ORDER TO NUMPART 									&& SERGIO 25/7/06
	    	 		 
	         SEEK _SEEK
	         IF FOUND()
				 IF NSALDO = 0			
					IF __NORIBA <> "X" 	&& CANCELLA IL RECORD SOLO SE NO RIBA 
						SELECT SCADE
						DELETE 
				 	ENDIF
				 ENDIF
	         ENDIF


		ELSE

	         _SEEK = ALLTRIM(M.CODFOR)+ALLTRIM(STR(M.NPART,10,0))   && SERGIO 25/7/06
			 SELECT SALDI_APERTI_CHIUSI								&& SERGIO 25/7/06
	    	 SET ORDER TO NUMPART 									&& SERGIO 25/7/06
	    	 		 
	         SEEK _SEEK
	         IF FOUND()
				 IF NSALDO = 0			&& CANCELLA IL RECORD 
					SELECT SCADE
					DELETE 
				 ENDIF
 	         ENDIF
		
		ENDIF
		
	  
	  SELECT SCADE
	  SKIP +1
	ENDDO
	
ENDIF

*** CANCELLA LE PARTITE APERTE 
*** L'UTENTE VUOLE SOLO LE PARTITE CHIUSE
***
IF _OPENCLOSE = 3 AND _SOLOSALDO <> "SI" AND _SOLOSALDO <> "SCADENZE" AND _SOLOSALDO<>"SOLO_SCADENZE_NEL_PERIODO"

	WAIT WINDOW "ATTENDERE PREGO... verifica partite aperte" NOWAIT

	SELECT SCADE 
	GO TOP
	DO WHILE !EOF()
	
	    _SEEK = ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))    && SERGIO 25/7/06
		SELECT SALDI_APERTI_CHIUSI							&& SERGIO 25/7/06
		SET ORDER TO NUMPART 								&& SERGIO 25/7/06
		 
        SEEK _SEEK
		IF !FOUND()
			SELECT SCADE
			SKIP +1
		ENDIF
         
		IF NSALDO <>  0			&& CANCELLA IL RECORD 
			SELECT SCADE
			DELETE 
		ENDIF
		
		SELECT SCADE
		SKIP +1
  
	ENDDO
	
ENDIF
 
*** RITORNA SOLO I SALDI
***


IF _SOLOSALDO = "SI" OR _SOLOSALDO = "SCADENZE" OR _SOLOSALDO="SOLO_SCADENZE_NEL_PERIODO"

	CGE_TOTALE_DARE_  = 0
	CGE_TOTALE_AVERE_ = 0
	CGE_TOTALE_SALDO_ = 0


    SELECT SCADE				&& CANCELLA SCADE PER RIPORTARE SOLO IL SALDO DELLE PARTITE APERTE
    ZAP

	IF _SOLOSALDO = "SI" 
		SELECT SALDI_APERTI_CHIUSI 
		DO CASE
			CASE  _OPENCLOSE = 2
				&& RITORNA SOLO I SALDI DELLE PARTITE APERTE 
				DELETE FROM SALDI_APERTI_CHIUSI WHERE NSALDO = 0 
			CASE  _OPENCLOSE = 3
				&& RITORNA SOLO I SALDI DELLE PARTITE CHIUSE  
				DELETE FROM SALDI_APERTI_CHIUSI WHERE NSALDO <> 0 
		ENDCASE 
	ELSE
		SELECT SALDI_SCADENZE 
		DO CASE
			CASE  _OPENCLOSE = 2
				&& RITORNA SOLO I SALDI DELLE PARTITE APERTE 
				*!*	DELETE FROM SALDI_SCADENZE WHERE NPART IN (SELECT NPART  FROM SALDI_APERTI_CHIUSI WHERE NSALDO = 0 )
				DELETE FROM SALDI_SCADENZE WHERE ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0)) IN (SELECT ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))  FROM SALDI_APERTI_CHIUSI WHERE NSALDO = 0 )
				DELETE FROM SALDI_SCADENZE WHERE NSALDO = 0 	
				*** DO DELETE_SALDI_ZERO
			CASE  _OPENCLOSE = 3
				&& RITORNA SOLO I SALDI DELLE PARTITE CHIUSE  
				*!*	DELETE FROM SALDI_SCADENZE WHERE NPART IN (SELECT NPART  FROM SALDI_APERTI_CHIUSI WHERE NSALDO <> 0 )
				DELETE FROM SALDI_SCADENZE WHERE ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0)) IN (SELECT ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))  FROM SALDI_APERTI_CHIUSI WHERE NSALDO <> 0 )				
				DELETE FROM SALDI_SCADENZE WHERE NSALDO <> 0 
		ENDCASE 
	ENDIF

			
	GO TOP
	
	DO WHILE !EOF()
	
		IF DELETED()
			SKIP
			LOOP
		ENDIF

		SCATTER MEMVAR MEMO
		
		SELECT SCADE
		APPEND BLANK
		GATHER MEMVAR MEMO
		
		IF NSALDO = 0 			
			REPLACE DARE 	WITH SPACE(15)
			REPLACE AVEREX 	WITH SPACE(15)
		ENDIF

	    CGE_TOTALE_DARE_  = CGE_TOTALE_DARE_  + NDARE
		CGE_TOTALE_AVERE_ = CGE_TOTALE_AVERE_ + NAVERE
		CGE_TOTALE_SALDO_ = CGE_TOTALE_DARE_  - CGE_TOTALE_AVERE_ 

		  
		IF _SOLOSALDO = "SI" 
			SELECT SALDI_APERTI_CHIUSI 
		ELSE
			SELECT SALDI_SCADENZE 
		ENDIF				
		SKIP +1

	ENDDO

ENDIF
      
   
IF _SOLOSALDO = "SCADENZE"  OR _SOLOSALDO="SOLO_SCADENZE_NEL_PERIODO"
	SELECT SCADE
	GO TOP
	DO WHILE !EOF()

		*** SE SCADENZA NON RICHIESTA DA INTERVALLO CANCELLA IL RECORD
		
		IF _CF='F'
			_DATAAL='31/12/2999'
		ENDIF
		
			
		IF RIBALTA2(DTSCAD)<RIBALTA2(_DATADAL) OR RIBALTA2(DTSCAD)>RIBALTA2(_DATAAL)	
			DELETE
		ENDIF	
		
		SELECT SCADE
		SKIP +1
	ENDDO
ENDIF


SELECT SCADE
GO TOP
IF EOF()
	_RISPOSTA = .F.
ELSE
	_RISPOSTA = .T.
ENDIF 




SELECT(AABBSXS)
RETURN(.T.)


***************************************************************************************
PROCEDURE CREA_CURSORI_DI_VERIFICA_PER_ELABORAZIONE_SCADENZIARIO_CLIENTI 
***************************************************************************************
* FABIANO 18/03/2011
***************************************************************************************

PARAMETERS _DATAAL

********** CURSORE SCADENZE CON RELATIVI SALDI
WAIT WINDOW "ATTENDERE PREGO... analizza saldi scadenze" NOWAIT
SELECT CODFOR,NPART,DTSCAD,SUM(SALDO) AS SALDO ;
 FROM ;
(SELECT CODFOR,;
	NPART,;
	DTSCAD,;
	(NDARE - NAVERE) AS SALDO ;
FROM SCADE ) AS SC1 ;
GROUP BY CODFOR,NPART,DTSCAD ;
INTO CURSOR SCADENZE_APERTE_CHIUSE 

SELECT SCADENZE_APERTE_CHIUSE 
INDEX ON RIBALTA2(DTSCAD)+ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))	TAG  SCADENZA
SET ORDER TO SCADENZA
GO TOP

********** CURSORE SCADENZE CON RIBA
WAIT WINDOW "ATTENDERE PREGO... analizza scadenze con riba" NOWAIT
SELECT CODFOR,NPART,DTSCAD,TIPODOC ;
FROM SCADE ;
WHERE FLAG_RIBA_TOP ='S' ;
GROUP BY CODFOR,NPART,DTSCAD,TIPODOC ;
INTO CURSOR SCADENZE_CON_RIBA

SELECT SCADENZE_CON_RIBA
INDEX ON RIBALTA2(DTSCAD)+ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))	TAG  SCADENZA
SET ORDER TO SCADENZA
GO TOP

********** CURSORE SCADENZE CON BONIFICO
WAIT WINDOW "ATTENDERE PREGO... analizza scadenze con bonifici" NOWAIT
SELECT CODFOR,NPART,DTSCAD,TIPODOC ;
FROM SCADE ;
WHERE FLAG_RIBA_TOP ='N' AND FLAG_NATURA='P' AND FLAG_TRATTA_TOP<>'S';
GROUP BY CODFOR,NPART,DTSCAD,TIPODOC ;
INTO CURSOR SCADENZE_CON_BONIFICO

SELECT SCADENZE_CON_BONIFICO
INDEX ON RIBALTA2(DTSCAD)+ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))	TAG  SCADENZA
SET ORDER TO SCADENZA
GO TOP

********** CURSORE SCADENZE CON INSOLUTO
WAIT WINDOW "ATTENDERE PREGO... analizza scadenze con insoluti" NOWAIT
SELECT CODFOR,NPART,DTSCAD,TIPODOC ;
FROM SCADE ;
WHERE FLAG_NATURA='I' ;
GROUP BY CODFOR,NPART,DTSCAD,TIPODOC ;
INTO CURSOR SCADENZE_CON_INSOLUTO

SELECT SCADENZE_CON_INSOLUTO
INDEX ON RIBALTA2(DTSCAD)+ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))	TAG  SCADENZA
SET ORDER TO SCADENZA
GO TOP

********** CURSORE SCADENZE CON FATTURE
WAIT WINDOW "ATTENDERE PREGO... analizza scadenze con fatture" NOWAIT
SELECT CODFOR,NPART,DTSCAD,TIPODOC ;
FROM SCADE ;
WHERE FLAG_NATURA='S' ;
GROUP BY CODFOR,NPART,DTSCAD,TIPODOC ;
INTO CURSOR SCADENZE_CON_FATTURE

SELECT SCADENZE_CON_FATTURE
INDEX ON RIBALTA2(DTSCAD)+ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))	TAG  SCADENZA
SET ORDER TO SCADENZA
GO TOP


********** CURSORE PARTITE CON SCADENZE FUTURE
WAIT WINDOW "ATTENDERE PREGO... analizza partite con scadenze successive al "+_DATAAL NOWAIT
SELECT CODFOR,NPART ;
FROM SCADE ;
WHERE RIBALTA2(DTPOSTRIBA)>RIBALTA2(_DATAAL) ;
GROUP BY CODFOR,NPART ;
INTO CURSOR PARTITE_CON_SCADENZE_FUTURE

SELECT PARTITE_CON_SCADENZE_FUTURE
INDEX ON ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))	TAG  PARTITA
SET ORDER TO PARTITA
GO TOP

********** CURSORE SCADENZE CON TRATTE
WAIT WINDOW "ATTENDERE PREGO... analizza scadenze con TRATTE/CAMBIALI" NOWAIT
SELECT CODFOR,NPART,DTSCAD,TIPODOC ;
FROM SCADE ;
WHERE FLAG_TRATTA_TOP ='S' ;
GROUP BY CODFOR,NPART,DTSCAD,TIPODOC ;
INTO CURSOR SCADENZE_CON_TRATTE

SELECT SCADENZE_CON_TRATTE
INDEX ON RIBALTA2(DTSCAD)+ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))	TAG  SCADENZA
SET ORDER TO SCADENZA
GO TOP


RETURN
***************************************************************************************

***************************************************************************************
PROCEDURE CERCA_PARTITE_GESTIONE_RISCHIO_RIBA
***************************************************************************************
* FABIANO 31/12/2011
* UNLTIMA MODIFICA - 18/03/2011
***************************************************************************************
PARAMETERS _XTIPOPA___,_DATAAL

IF PCOUNT() < 1
	_XTIPOPA___ = .F.
ENDIF

LOCAL _CURRENT_SELECT
_CURRENT_SELECT= SELECT()


WAIT WINDOW "ATTENDERE PREGO... elaborazione scadenziario clienti" NOWAIT


SELECT SCADE
GO TOP



DO WHILE !EOF()

*!*			IF NPART = 120915
*!*				SET STEP ON 
*!*			ENDIF

	SELECT SCADE
	REPLACE NSALDO WITH  NDARE - NAVERE

    IF _XTIPOPA___
		IF EMPTY(ALLTRIM(TIPOPA))					&& SE PER TPOLOGIA DI PARTITE SCARTA LE PARTITE CORRETTE NON RICLASSIFICATE
			SELECT SCADE   
			SKIP
			LOOP
		ENDIF
    ENDIF 
    

	*** VERIFICO SE E' UNA SCADENZA CONVERTITA
	SELECT SCADE 
	
	_SEEK = ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))+DTSCAD 
	SELECT SALDI_SCADENZE
	SET ORDER TO DTSCAD  

	SEEK _SEEK	
	IF FOUND()
		IF FLAG_CONVERTITA 	&& SE E' UNA SCADENZA CONVERTITA LA SALTO
			SELECT SCADE
			SKIP
			LOOP
		ENDIF
	ENDIF
	
	SELECT SCADE 
	
    _SEEK_PARTITA = ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))
	SELECT SALDI_APERTI_CHIUSI						
	SET ORDER TO NUMPART 							
	
    SEEK _SEEK_PARTITA 
	IF !FOUND()
		*** QUESTO NON DEVE MAI SUCCEDERE PERCHE' SALDI_APERTI_CHIUSI SICURAMENTE CONTERRA' LA MIA PARTITA
		SELECT SCADE
		SKIP +1	
		LOOP
	ENDIF
     
    ************ QUI CONTROLLO SE LA PARTITA E' APERTA O CHIUSA ********
	SELECT SALDI_APERTI_CHIUSI
	
	*** SE LA PARTITA E' CHIUSA E NON HA SCADENZE NEL FUTURO
	IF NSALDO =  0			
		SELECT SCADE
		
		_SEEK_PARTITA = ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))
		SELECT PARTITE_CON_SCADENZE_FUTURE
		SEEK _SEEK_PARTITA 
		IF !FOUND()
			SELECT SCADE
			REPLACE SELEZIONE WITH ""
			SKIP +1	
			LOOP
		ENDIF
		
	ENDIF
		
	*** SE LA PARTITA E' CHIUSA E HO DELLE SCADENZE APERTE
	*** E' IL CASO DELLE "VECCHIE" FATTURE  PROVENIENTI DA ALTRI SISTEMI
	IF NSALDO =  0			
		SELECT SCADE
		
		___SALVA_POS=RECNO()
		
		_CODFOR = CODFOR
		_NPART  = NPART
		_HO_SCADENZE_APERTE=.F.
		SELECT * FROM SCADENZE_APERTE_CHIUSE WHERE ALLTRIM(CODFOR)=ALLTRIM(_CODFOR) AND NPART = _NPART  INTO CURSOR _SOLO_QUESTA_PART
		SELECT _SOLO_QUESTA_PART
		GO TOP
		DO WHILE !EOF()
		
			IF SALDO<>0
				_HO_SCADENZE_APERTE=.T.
				EXIT
			ENDIF
			
			SKIP
		ENDDO

		IF _HO_SCADENZE_APERTE && VECCHIE FATTURE XILO
		
			SELECT SCADE
			IF FLAG_NATURA='S'   && E' TOP FATTURA
			
				REPLACE SELEZIONE   	WITH "" 
				REPLACE FLAG_RIBA_TOP 	WITH ""	
				SKIP +1	
				LOOP

			ENDIF	
			
			SELECT SCADE
			IF FLAG_RIBA_TOP="S"
				IF RIBALTA2(DTPOSTRIBA)>RIBALTA2(_DATAAL)
					IF NDARE - NAVERE < 0										&& NON FA NULLA SU TUTTI I MOVIMENTI IN DARE
						**** TRASFORMO LE RIBA IN FATTURA
						
						REPLACE DESMOV		WITH "Fattura"
						REPLACE TIPODOC     WITH PUB_FATTU
						REPLACE TIPOOPE     WITH PUB_FATTU
						REPLACE NDARE  		WITH NAVERE
						REPLACE NAVERE 		WITH 0
						REPLACE NSALDO    	WITH NDARE
			            REPLACE DARE   		WITH STR(NDARE,15,3)
			            REPLACE AVEREX      WITH ""
			            REPLACE V_SALDO		WITH STR(NDARE,15,3)
						REPLACE SELEZIONE   	WITH "SI" 
						REPLACE FLAG_RIBA_TOP 	WITH "S"
						
						SKIP +1	
						LOOP						
						
		            ENDIF
		        ELSE
					REPLACE SELEZIONE  WITH "" 
					SKIP +1	
					LOOP						
	            ENDIF
			ENDIF				
			
		ENDIF
		
		
	ENDIF


	SELECT SCADE
    _SEEK = RIBALTA2(DTSCAD)+ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))
    
    SELECT SCADENZE_APERTE_CHIUSE 
    SET ORDER TO SCADENZA
	SEEK _SEEK
	
	IF !FOUND()
		*** NON PUO' SUCCEDERE
		SELECT SCADE
		REPLACE SELEZIONE WITH ""
		SKIP +1	
		LOOP
	ENDIF
	
	SELECT SCADENZE_APERTE_CHIUSE
	*** CASO 1) LA SCADENZA E' APERTA: PRENDO TUTTE LE RIGHE, 
	IF SALDO > 0	&& SARANNO POI I PROGRAMMI CHE USANO SCADE A FARE I RAGGRUPPAMENTI
					&& E QUINDI A MOSTRARE I SALDI
		
		SELECT SCADE
		REPLACE SELEZIONE WITH "SI"
		
		SELECT SCADENZE_CON_INSOLUTO
	    SET ORDER TO SCADENZA
		SEEK _SEEK
		IF FOUND()	&& HO UN INSOLUTO IN QUESTA DATA
		
			&& CONTROLLO SE C'E' UN BONIFICO A CHIUDERE IN PARTE L'INSOLUTO
			SELECT SCADENZE_CON_BONIFICO
		    SET ORDER TO SCADENZA
			SEEK _SEEK
			
			IF FOUND()							&& SE CI SONO BONIFICI NON METTO NESSUN FLAG SUL REPORT
				SELECT SCADE
				REPLACE FLAG_NATURA   WITH ""			
				REPLACE FLAG_RIBA_TOP WITH ""	
			ELSE								&& SE NON CI SONO BONIFICI METTO LA "I" DI INSOLUTO
				SELECT SCADE
				REPLACE FLAG_NATURA   WITH "I"		
				REPLACE FLAG_RIBA_TOP WITH ""	
				REPLACE INSOLUTO_NON_PAGATO WITH .T.
			ENDIF		
		ENDIF
		
		SELECT SCADE
		SKIP +1	
		LOOP
	ENDIF


	SELECT SCADENZE_APERTE_CHIUSE

    *** LA SCADENZA E' APERTA CON SALDO <0 ED E' UNA NOTA DI CREDITO
	IF SALDO < 0	&& SARANNO POI I PROGRAMMI CHE USANO SCADE A FARE I RAGGRUPPAMENTI
					&& E QUINDI A MOSTRARE I SALDI
					
		SELECT SCADE
					
*!*			IF 	FLAG_NATURA   = 'S' AND FLAG_RIBA_TOP <> "S" && FATTURA/ NOTA DI ACCREDITO	
			REPLACE SELEZIONE WITH "SI"
			SELECT SCADE
			SKIP +1	
			LOOP
*!*			ENDIF
	
	
	
	ENDIF
    

			
	*** LA SCADENZA E' CHIUSA 
	
	*** CASO 2) LA SCADENZA E' CHIUSA CON UN BONIFICO
	***         NON FACCIO VEDERE NULLA: TUTTO INCASSATO
	SELECT SCADENZE_CON_BONIFICO
    SET ORDER TO SCADENZA
	SEEK _SEEK
		
	IF FOUND() && CHIUSA CON UN BONIFICO
		SELECT SCADE
		REPLACE SELEZIONE WITH ""
		SKIP +1	
		LOOP
	ENDIF

	*** CASO 3) CHIUSA CON RIBA (O RIEMISSIONE RIBA)
	SELECT SCADENZE_CON_RIBA
    SET ORDER TO SCADENZA
	SEEK _SEEK
	
	IF FOUND()		&& SE LA TROVO VUOL DIRE CHE QUELLA SCADENZA HA UN TOP RIBA
		
		*** MOSTRO LA FATTURA SE LA RICEVUTA BANCARIA NON ANCORA CONSOLIDATA 
		SELECT SCADE
		
		IF FLAG_RIBA='X' AND FLAG_NATURA='S'   && E' CPA RIBA E TOP FATTURA
		
			IF RIBALTA2(DTPOSTRIBA)>RIBALTA2(_DATAAL)	
			
				REPLACE SELEZIONE   	WITH "SI" 
				REPLACE FLAG_RIBA_TOP 	WITH "S"		&& E' UNA FATTURA CONTRO RICEVUTA BANCARIA 
														&& VALORIZZO FLAG_RIBA_TOP ="S" PERCHE' SUL REPORT VOGLIO FARE COMPARIRE 
														&& QUESTA RIGA COME RI.BA.
				SELECT SCADE 
				
				SKIP +1	
				LOOP

			ENDIF					
			
		ENDIF
		
		
		*** MOSTRO LA NOTA DI CREDITO SE LA RICEVUTA BANCARIA NON ANCORA CONSOLIDATA 
		SELECT SCADE
		
		
		****** FABIANO 26/04/2012 - NOTA DI CREDITO A COMPENSAZIONE DI UNA FATTURA CONTRO RICEVUTA BANCARIA
		****** FABIANO 26/04/2012 - NOTA DI CREDITO A COMPENSAZIONE DI UNA FATTURA CONTRO RICEVUTA BANCARIA
		****** FABIANO 26/04/2012 - NOTA DI CREDITO A COMPENSAZIONE DI UNA FATTURA CONTRO RICEVUTA BANCARIA
		****** FABIANO 26/04/2012 - NOTA DI CREDITO A COMPENSAZIONE DI UNA FATTURA CONTRO RICEVUTA BANCARIA
		IF FLAG_NOTAC_TOP='S' 						&& E' UN TOP NOTA DI CREDITO
		
	      	*** RICALCOLO LA SCADENZA POSTICIPATA
	      	*** SE LE CONDIZIONI DI PAGAMENTO NON SONO RIBA
	      	IF FLAG_RIBA="X"
	      		_DTPOSTRIBA_RICALCOLATA  = DTPOSTRIBA
	      	ELSE
	    		_DTPOSTRIBA_RICALCOLATA  = DTOC(CTOD(DTSCAD)+PUB_GGRIBA)
	    	ENDIF	

			IF RIBALTA2(_DTPOSTRIBA_RICALCOLATA  )>RIBALTA2(_DATAAL)	
		
				REPLACE SELEZIONE   	WITH "SI" 
				REPLACE FLAG_RIBA_TOP 	WITH "S"		&& E' UNA NOTA DI CREDITO CHE COMPENSA UNA FATTURA CONTRO RICEVUTA BANCARIA 
														&& VALORIZZO FLAG_RIBA_TOP ="S" PERCHE' SUL REPORT VOGLIO FARE COMPARIRE 
														&& QUESTA RIGA COME RI.BA.
				SELECT SCADE 
				
				SKIP +1	
				LOOP

			ENDIF					
			
		ENDIF
		
		
	ENDIF
	

	*** CASO 4) CHIUSA CON RIBA (O RIEMISSIONE RIBA) MA NON C'E' FATTURA
	***         LA PARTITA E' APERTA CON UN INSOLUTO
	***
	SELECT SCADENZE_CON_RIBA
    SET ORDER TO SCADENZA
	SEEK _SEEK
	
	IF FOUND()		&& SE LA TROVO VUOL DIRE CHE QUELLA SCADENZA HA UN TOP RIBA
		
		*** MOSTRO LA FATTURA SE LA RICEVUTA BANCARIA NON ANCORA CONSOLIDATA 
		SELECT SCADENZE_CON_FATTURE
		SET ORDER TO SCADENZA
		SEEK _SEEK

		IF !FOUND()
		
			SELECT SCADE
			IF FLAG_NATURA='I'   && E' L'INSOLUTO DA RIAPRIRE
			
			
		      	*** RICALCOLO LA SCADENZA POSTICIPATA
		      	*** SE LE CONDIZIONI DI PAGAMENTO NON SONO RIBA
		      	IF FLAG_RIBA="X"
		      		_DTPOSTRIBA_RICALCOLATA  = DTPOSTRIBA
		      	ELSE
		    		_DTPOSTRIBA_RICALCOLATA  = DTOC(CTOD(DTSCAD)+PUB_GGRIBA)
		    	ENDIF	
			
				IF RIBALTA2(_DTPOSTRIBA_RICALCOLATA)>RIBALTA2(_DATAAL)				

					REPLACE SELEZIONE   	WITH "SI" 
					REPLACE FLAG_RIBA_TOP 	WITH ""	
					REPLACE INSOLUTO_NON_PAGATO WITH .T.
					
					SKIP +1	
					LOOP

				ENDIF					
				
			ENDIF
			
		ENDIF
		
	ENDIF

	*********************************************** GESTIONE TRATTE ************************************
	*********************************************** GESTIONE TRATTE ************************************
	*********************************************** GESTIONE TRATTE ************************************
	*********************************************** GESTIONE TRATTE ************************************
	*********************************************** GESTIONE TRATTE ************************************
	*********************************************** GESTIONE TRATTE ************************************
	*********************************************** GESTIONE TRATTE ************************************
	*********************************************** GESTIONE TRATTE ************************************
	*********************************************** GESTIONE TRATTE ************************************
	*********************************************** GESTIONE TRATTE ************************************
	*********************************************** GESTIONE TRATTE ************************************
	*** CASO 5) CHIUSA CON TRATTA
	SELECT SCADENZE_CON_TRATTE
    SET ORDER TO SCADENZA
	SEEK _SEEK
	
	IF FOUND()		&& SE LA TROVO VUOL DIRE CHE QUELLA SCADENZA HA UN TOP TRATTA
		
		*** MOSTRO LA FATTURA SE LA RICEVUTA BANCARIA NON ANCORA CONSOLIDATA 
		SELECT SCADE
		
		IF FLAG_TRATTA_TOP='S'   && E' TOP TRATTA
		
			***IF RIBALTA2(DTPOSTRIBA)>RIBALTA2(_DATAAL)	
			IF RIBALTA2(DTSCAD)>RIBALTA2(_DATAAL)	
			
				SELECT SCADE 
				REPLACE SELEZIONE   	WITH "SI" 
				REPLACE DESMOV	 	    WITH "TRATTA/CAMBIALE"
				**** CAMBIO SEGNO ALLA TRATTA SE NEGATIVO
				IF NDARE - NAVERE < 0										&& NON FA NULLA SU TUTTI I MOVIMENTI IN DARE
					
					REPLACE NDARE  		WITH NAVERE
					REPLACE NAVERE 		WITH 0
					REPLACE NSALDO    	WITH NDARE
		            REPLACE DARE   		WITH STR(NDARE,15,3)
		            REPLACE AVEREX      WITH ""
		            REPLACE V_SALDO		WITH STR(NDARE,15,3)
					REPLACE SELEZIONE   	WITH "SI" 
	            ENDIF

				SKIP +1	
				LOOP

			ENDIF					
			
		ENDIF
		
		
		
		*** MOSTRO LA NOTA DI CREDITO SE LA TRATTA NON E' ANCORA CONSOLIDATA 
		SELECT SCADE 
		
		****** FABIANO 03/05/2012 - NOTA DI CREDITO A COMPENSAZIONE DI UNA FATTURA PAGATA CON TRATTA/CAMBIALE
		IF FLAG_NOTAC_TOP='S' 						&& E' UN TOP NOTA DI CREDITO
		
    		****_DTPOSTRIBA_RICALCOLATA  = DTOC(CTOD(DTSCAD)+PUB_GGRIBA)

			***IF RIBALTA2(_DTPOSTRIBA_RICALCOLATA  )>RIBALTA2(_DATAAL)	
			IF RIBALTA2(DTSCAD)>RIBALTA2(_DATAAL)	
		
				REPLACE SELEZIONE   	WITH "SI" 
				**** CAMBIO SEGNO ALLA NOTA DI CREDITO
				IF NDARE - NAVERE < 0										&& NON FA NULLA SU TUTTI I MOVIMENTI IN DARE
					
					REPLACE NDARE  		WITH NAVERE
					REPLACE NAVERE 		WITH 0
					REPLACE NSALDO    	WITH NDARE
		            REPLACE DARE   		WITH STR(NDARE,15,3)
		            REPLACE AVEREX      WITH ""
		            REPLACE V_SALDO		WITH STR(NDARE,15,3)
					REPLACE SELEZIONE   	WITH "SI" 
					REPLACE FLAG_NATURA WITH 'T'  							&& SERVE PER FAR COMPARIRE 'T' SUGLI SCADENZIARI
	            ENDIF
				SELECT SCADE 
				
				SKIP +1	
				LOOP

			ENDIF					
			
		ENDIF		
		
	ENDIF
	


	SELECT SCADE
	SKIP +1
ENDDO



*** CANCELLO TUTTI I RECORD NON SELEZIONATI
SELECT SCADE
DELETE FOR EMPTY(SELEZIONE)

REPLACE FLAG_NATURA  WITH "T" FOR FLAG_TRATTA_TOP='S'	&& SERVE PER FAR COMPARIRE 'T' SUGLI SCADENZIARI


SELECT SCADE
GO TOP
IF EOF()
	_RISPOSTA = .F.
ELSE
	_RISPOSTA = .T.
ENDIF 

SELECT(_CURRENT_SELECT)
RETURN
* FINE PROCEDURE CERCA_PARTITE_GESTIONE_RISCHIO_RIBA
***************************************************************************************


***************************************************************************************
PROCEDURE CERCA_SALDI_SCADENZE_CONVERTITE
***************************************************************************************
* FABIANO 17/03/2012
***************************************************************************************

_DATA_LIMITE_ARCHIVI_CONVERTITI="31/12/2011"
 
WAIT WINDOW "ATTENDERE PREGO... elaborazione partite aperte scadute precedenti al "+_DATA_LIMITE_ARCHIVI_CONVERTITI NOWAIT

SELECT SALDI_SCADENZE
SET ORDER TO DTSCAD 
GO TOP

DO WHILE !EOF()

	*** CONTROLLO SE LA PARTITA E' CHIUSA
    _SEEK_PARTITA = ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))
	SELECT SALDI_APERTI_CHIUSI						
	SET ORDER TO NUMPART 							
	
    SEEK _SEEK_PARTITA 
	IF !FOUND()
		*** QUESTO NON DEVE MAI SUCCEDERE PERCHE' SALDI_APERTI_CHIUSI SICURAMENTE CONTERRA' LA MIA PARTITA
		SELECT SCADE
		SKIP +1	
		LOOP
	ENDIF
     
    ************ QUI CONTROLLO SE LA PARTITA E' APERTA O CHIUSA ********
	SELECT SALDI_APERTI_CHIUSI
	*** SE LA PARTITA E' CHIUSA NON FACCIO NULLA
	IF NSALDO =  0			
		SELECT SALDI_SCADENZE
		SKIP
		LOOP
	ENDIF
	
	SELECT SALDI_SCADENZE
	
	*** SE ARRIVO QUI LA SPARTITA E' APERTA

	*** CONROLLO SEL HA SCADENZE NEL FUTURO
	_SEEK_PARTITA = ALLTRIM(CODFOR)+ALLTRIM(STR(NPART,10,0))
	SELECT PARTITE_CON_SCADENZE_FUTURE
	SEEK _SEEK_PARTITA 
	*** SE HA SCADENZE NEL FUTURO NON FACCIO NULLA
	IF FOUND()
		SELECT SALDI_SCADENZE
		SKIP
		LOOP
	ENDIF

	SELECT SALDI_SCADENZE

	*** SE ARRIVO QUI LA PARTITA E' APERTA E NON HA SCADENZE NEL FUTURO
	
	IF RIBALTA2(DTSCAD)<= RIBALTA2(_DATA_LIMITE_ARCHIVI_CONVERTITI)
		*** MODIFICO IL COMMENTO CON "*** SALDO SCADENZA ***"
		*** VALORIZZO FLAG_CONVERTITA 
		REPLACE FLAG_CONVERTITA WITH .T.
		REPLACE DESMOV WITH "*** SALDO SCADENZA ***"
		
	ENDIF

	SELECT SALDI_SCADENZE
	SKIP

ENDDO


RETURN
***************************************************************************************


***************************************************************************************
PROCEDURE AGGIUNGI_SU_SCADE_SALDI_SCADENZE_CONVERTITE
***************************************************************************************
* FABIANO 17/03/2012
***************************************************************************************
SELECT SALDI_SCADENZE

WAIT WINDOW "ATTENDERE PREGO... riprende saldi parite aperte scadute" NOWAIT

GO TOP
DO WHILE !EOF()

	IF !FLAG_CONVERTITA 
		SKIP
		LOOP
	ENDIF
	
	SCATTER MEMVAR MEMO
	SELECT SCADE
	APPEND BLANK
	GATHER MEMVAR MEMO
	
	_SALDO= M.NDARE  - M.NAVERE 
	

	IF _SALDO >0
		REPLACE NDARE  		WITH _SALDO
		REPLACE NAVERE 		WITH 0
        REPLACE DARE   		WITH STR(_SALDO,15,3)
        REPLACE AVEREX      WITH ""
	ELSE
		REPLACE NDARE  		WITH 0
		REPLACE NAVERE 		WITH ABS(_SALDO)
        REPLACE DARE   		WITH ""
        REPLACE AVEREX      WITH STR( ABS(_SALDO),15,3)
	ENDIF		
		
	REPLACE	FLAG_NATURA WITH ""
	REPLACE	FLAG_RIBA 	WITH ""
	REPLACE TIPOPA      WITH ""
	****REPLACE	TIPOOPE 	WITH ???????????
	
	SELECT SALDI_SCADENZE
	SKIP
	LOOP
ENDDO


RETURN


***************************************************************************************
PROCEDURE MOSTRA_SOLO_SCADENZE_NEL_PERIODO
***************************************************************************************
* FABIANO 18/03/2012 
***************************************************************************************

PARAMETERS _DATADAL,_DATAAL

WAIT WINDOW "Elimina scadenze fuori dal periodo richiesto..." NOWAIT 
SELECT SCADE
GO TOP
DELETE FOR RIBALTA2(DTSCAD)<RIBALTA2(_DATADAL) OR RIBALTA2(DTSCAD)>RIBALTA2(_DATAAL)
GO TOP		


RETURN
***************************************************************************************



****************************************
FUNCTION DEF_EURO
****************************************
** DEFINISCE IL CURSORE PER LA GESTIONE DELLE PARTITE CLIENTI / FORNITORI


CREATE CURSOR PART_EUR ;
		(CONTO C(13),NPART N(10,0),INDICE C(200), NUMPRO C(13),NREG C(08),DTREG C(10), TIPODOC C(10), NUMDOC C(7), CONTABILITA_PREVISIONALE C(1),;
		DTDOC C(10), DTSCAD C(10),VALUTA C(3),CAMBIO N(15,10),D_ITL N(20,3),A_ITL N(20,3),T_ITL N(20,3),D_EUR N(20,3), ;
		A_EUR N(20,3),T_EUR N(20,3),T_DIF N(20,3), CODAGE C(03), DESAGE C(40), CODNAZ C(03), DESNAZ C(40), RAGSOC C(40), NPROT C(10), TDOC C(3), ANOMAX C(3), T_NOPART L)
		INDEX ON ALLTRIM(CONTO) + STR(NPART,10,0)  				TAG PART_EUR
		INDEX ON ALLTRIM(RAGSOC) + STR(NPART,10,0)  			TAG PART_SOC
		INDEX ON ALLTRIM(CONTO) + DTSCAD  						TAG PART_DTS
		INDEX ON ALLTRIM(CONTO) + STR(NPART,10,0) + DTSCAD  	TAG PART_ESC


RETURN(.T.)


***************************************
FUNCTION TEURO           		 && CONVERTE IN EURO IL VALORE SU BASE VALUTA ORIGINALE
***************************************

PARA _VALUTA,_EURO,_DATA

IF _VALUTA = "EUR"
   RETURN(_EURO)
ENDIF

SXXS=STR(SELECT())

x_soci = "vva_codsoc = '" + PUB_CODSOC + "'"
x_data = "vva_data = '" + ALLTRIM(_data) + "'"
x_valu = "vva_codval = '" + ALLTRIM(_valuta) + "'"
x_cond = x_soci + " and " + x_data + " and " + x_valu
cSql="SELECT * FROM u_vva_ch WHERE " + x_cond + " order by vva_codsoc,vva_data,vva_codval"
IF !ExecCommand(cSql,"cu_vva_ch")
   return
ENDIF
SELECT cu_vva_ch
IF reccount() <> 0
   PUB_CAMBIO = VVA_CHANGE
ELSE
   PUB_CAMBIO = 1
   IF _VALUTA = "ITL" .OR. _VALUTA = "LIT"
   ELSE
      PUB_CAMBIO = 1
   ENDIF
ENDIF

IF PUB_CAMBIO = 0
   PUB_CAMBIO = 1
ENDIF

* IN PUB_CAMBIO ABBIAMO IL CAMBIO RELATIVO AD AVERE UNA LIRA
* PUB_CAMBIO E' DEDOTTO DA U_VVA_CH

IF PUB_VALRIF = "EUR"
   IF _VALUTA = "EUR"
	  _EURO = ROUND((_EURO * PUB_CAMBIO) ,2)
   ELSE
	  _EURO = ROUND((_EURO * PUB_CAMBIO) ,2)
   ENDIF
ELSE
   _EURO = ROUND((_EURO * PUB_CAMBIO) / 1936.27,2)
ENDIF

SELECT &SXXS

RETURN(_EURO)


***************************************
FUNCTION TEUROP           		 && CONVERTE IN EURO IL VALORE SU BASE VALUTA ORIGINALE
***************************************

PARA _VALUTA,_EURO,_DATA

IF _VALUTA = "EUR"
   RETURN(_EURO)
ENDIF

SXXS=STR(SELECT())

*!*	x_soci = "vva_codsoc = '" + _V_CODMAG + "'"
x_soci = "vva_codsoc = '" + PUB_CODSOC + "'"
x_data = "vva_data = '" + ALLTRIM(_data) + "'"
x_valu = "vva_codval = '" + ALLTRIM(_valuta) + "'"
x_cond = x_soci + " and " + x_data + " and " + x_valu
cSql="SELECT * FROM u_vva_ch WHERE " + x_cond + " order by vva_codsoc,vva_data,vva_codval"
IF !ExecCommand(cSql,"cu_vva_ch")
   return
ENDIF
SELECT cu_vva_ch
IF reccount() <> 0
   PUB_CAMBIO = VVA_CHANGE
ELSE
   PUB_CAMBIO = 1
   IF _VALUTA = "ITL" .OR. _VALUTA = "LIT"
   ELSE
      PUB_CAMBIO = 1
   ENDIF
ENDIF

IF PUB_CAMBIO = 0
   PUB_CAMBIO = 1
ENDIF

* IN PUB_CAMBIO ABBIAMO IL CAMBIO RELATIVO AD AVERE UNA LIRA
* PUB_CAMBIO E' DEDOTTO DA U_VVA_CH

IF PUB_VALRIF = "EUR"
   IF _VALUTA = "EUR"
	  _EURO = ROUND((_EURO * PUB_CAMBIO) ,2)
   ELSE
  	  _EURO = ROUND((_EURO * PUB_CAMBIO) / 1936.27,2)  && EFFETTUA LA TRIANGOLAZIONE SU BASE COEFF 0,000516.... SE ITL
   ENDIF
ELSE
   _EURO = ROUND((_EURO * PUB_CAMBIO) / 1936.27,2)
ENDIF

SELECT &SXXS

RETURN(_EURO)


***************************************
FUNCTION TLIRE           		 && CONVERTE IN LIRE IL VALORE SU BASE VALUTA ORIGINALE
***************************************

PARA _VALUTA,_LIRE,_DATA

SYYS=STR(SELECT())

IF _VALUTA = 'ITL' .OR. _VALUTA = 'LIT'
   SELECT &SYYS
   RETURN(_LIRE)
ENDIF

IF _VALUTA = 'EUR'
   SELECT &SYYS
   _LIRE = ROUND((_LIRE * 1936.27),0)
   RETURN(_LIRE)
ENDIF


          
*!*	x_soci = "vva_codsoc = '" + _V_CODMAG + "'"
x_soci = "vva_codsoc = '" + PUB_CODSOC + "'"
x_data = "vva_data = '" + ALLTRIM(_data) + "'"
x_valu = "vva_codval = '" + ALLTRIM(_valuta) + "'"
x_cond = x_soci + " and " + x_data + " and " + x_valu
cSql="SELECT * FROM u_vva_ch WHERE " + x_cond + " order by vva_codsoc,vva_data,vva_codval"
IF !ExecCommand(cSql,"cu_vva_ch")
   return
ENDIF
SELECT cu_vva_ch
IF reccount() <> 0
   PUB_CAMBIO = VVA_CHANGE
ELSE
   PUB_CAMBIO = 1
ENDIF

IF PUB_CAMBIO = 0
   PUB_CAMBIO = 1
ENDIF

* IN PUB_CAMBIO ABBIAMO IL CAMBIO RELATIVO AD AVERE UNA LIRA
* PUB_CAMBIO E' DEDOTTO DA U_VVA_CH

IF PUB_VALRIF = "EUR"
   _LIRE = ROUND(((_LIRE * PUB_CAMBIO) * 1936.27),0)
ELSE
   _LIRE = ROUND((_LIRE * PUB_CAMBIO),0)
ENDIF

SELECT &SYYS

RETURN(_LIRE)



*******************************************************
 PROCEDURE MAX_EURO
*******************************************************

PARA VAL_MAX,_VALUTA
OK_DIGIT = .T.

IF _VALUTA <> "EUR"
	RETURN(OK_DIGIT)
ENDIF

SS=STR(SELECT())

IF !ExecCommand("select * from para where codice = 'TEUEUR'","para")
   return
ENDIF
SELECT PARA
IF reccount() <> 0
   IF VAL_MAX > VAL(LIBERA)
	  RIT = MESSAGEBOX("Importo EURO digitato superiore"+"all'importo massimo gestiti",62,"CONFERMA")
	  OK_DIGIT = .F.
   ENDIF
ENDIF

SELECT &SS

RETURN(OK_DIGIT)

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
IF _TIPO="AMG"
  IF SUBSTR(_DATA1,3,1)="/"
    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,2)) * 360)
    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,4,2)) * 30)
    IF VAL(SUBSTR(_DATA1,7,2)) > 30
      _GIORNI=_GIORNI+30
    ELSE
      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,7,2)))
    ENDIF
  ELSE
    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,4)) * 360)
    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,6,2)) * 30)
    IF VAL(SUBSTR(_DATA1,9,2)) > 30
      _GIORNI=_GIORNI+30
    ELSE
      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,9,2)))
    ENDIF
  ENDIF
ELSE
  IF SUBSTR(_DATA1,7,3)=" "
    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,7,2)) * 360)
    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,4,2)) * 30)
    IF VAL(SUBSTR(_DATA1,1,2)) > 30
      _GIORNI=_GIORNI+30
    ELSE
      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,2)))
    ENDIF
  ELSE
    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,7,4)) * 360)
    _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,4,2)) * 30)
    IF VAL(SUBSTR(_DATA1,1,2)) > 30
      _GIORNI=_GIORNI+30
    ELSE
      _GIORNI=_GIORNI+(VAL(SUBSTR(_DATA1,1,2)))
    ENDIF
  ENDIF
ENDIF
RETURN(_GIORNI)



**********************************************************************
* Funzione - VALID_DATA   Data: 27.08.94   Autore: Project
**********************************************************************
* Questa funzione permette di verificare l'esattezza di una data in
* formato stringa. Accetta un solo parametro di tipo carattere lungo
* 8, nel formato GG.MM.AA ritorna un valore logico .T. se data Ok .F.
* se data non corretta.
**********************************************************************
FUNCTION VALID_DATA
*******************
PARAMETERS X_DATA
RETURN(CTOD(X_DATA)!= {  /  /  })


**********************************************************************
* Funzione - OK_DATA   Data: 14.04.96   Autore: Project S.r.L.
**********************************************************************
*
* TRASFORMA DATA FORMATO GG.MM.AA IN FORMATO GG.MM.AAAA
* SE LA DATA E' ERRATA RITORNA AUTOMATICAMENTE LA DATA DI SISTEMA
*
* SINTASSI: DATA=OK_DATA(DATA)
* DATA= VARIABILE DA PASSARE CONTENENTE LA DATA DA CONTROLLARE
*
**********************************************************************
FUNCTION OK_DATA
*******************
PARA XDATA

FLAG_DATA = .T.
XGG       = VAL(SUBSTR(XDATA,1,2))
XMM       = VAL(SUBSTR(XDATA,4,2))
XAA1      = VAL(SUBSTR(XDATA,7,2))
XAA2      = VAL(SUBSTR(XDATA,9,2))
_LENAA    = LEN(ALLTRIM(SUBSTR(XDATA,7,4)))

IF _LENAA <> 4
   IF XAA2=0
	  IF XAA1 > 80
	     XAA2=XAA1
         XAA1=19
	  ELSE
         XAA2=XAA1
	     XAA1=20
      ENDIF
   ENDIF
ENDIF 

BIS=((XAA2/4)=INT(XAA2/4))

IF XGG= 0  .OR. XMM = 0 .OR. XMM > 12
   FLAG_DATA = .F.
ENDIF

DO CASE
   CASE XMM = 2 .AND. BIS
        IF XGG > 29
           FLAG_DATA = .F.
        ENDIF
   CASE XMM = 2
        IF XGG > 28
           FLAG_DATA = .F.
        ENDIF
   CASE XMM = 11 .OR. XMM = 4 .OR. XMM = 6 .OR. XMM = 9
        IF XGG > 30
           FLAG_DATA = .F.
        ENDIF
   CASE XMM = 1 .OR. XMM = 3 .OR. XMM = 5 .OR. XMM = 7 .OR. XMM = 8 .OR. XMM = 10 .OR. XMM = 12
        IF XGG > 31
           FLAG_DATA = .F.
        ENDIF
ENDCASE

IF !FLAG_DATA
   XDATA = DTOC(DATE())
   XGG   = VAL(SUBSTR(XDATA,1,2))
   XMM   = VAL(SUBSTR(XDATA,4,2))
   XAA1  = VAL(SUBSTR(XDATA,7,2))
   XAA2  = VAL(SUBSTR(XDATA,9,2))
   IF XAA2=0
      IF XAA1 > 80
         XAA2=XAA1
         XAA1=19
      ELSE
         XAA2=XAA1
         XAA1=20
      ENDIF
   ENDIF
ENDIF

XSEPA = SUBSTR(XDATA,3,1)
XGG   = STRTRAN(STR(XGG,2)," ","0")
XMM   = STRTRAN(STR(XMM,2)," ","0")
XAA1  = STRTRAN(STR(XAA1,2)," ","0")
XAA2  = STRTRAN(STR(XAA2,2)," ","0")

RETURN(XGG+XSEPA+XMM+XSEPA+XAA1+XAA2)


*!*	***********************************************************************************
FUNCTION AQUAREP
*!*	***********************************************************************************
*!*	**
*!*	** MEGA FUNZIONE DI AGGIORNAMENTO SISTEMA CONTABILE
*!*	**
*!*	** PARAMETRI DA GESTIRE :
*!*	**
*!*	**					_NPARF   :   SE = CARICA  , CARICA IL NUMERO DI PARTITA ALTRIMENTI CONSIDERA CGE_NPARF
*!*	**					_NUMPRO  :   SE = CARICA  , CARICA IL NUMERO INTERNO DI PRIMA NOTA ALTRIMENTI CONSIDERA CGE_NUMPRO
*!*	**					_INDICE  :   SE = CARICA  , CREA IL RECORD INDICE ALTRIMENTI DA PER SCONTATO CHE SIA STATO CREATO IN PRECEDENZA
*!*	**
*!*	**

PARAMETERS _TIPO,_NPARF,_NUMPRO,_INDICE,_NREG,_NDOC



AABBSXS  = SELECT()

*!* ___________________________PRELIEVO DEI NUMERI INTERNI DA PARAMETRI

   VER_CONTO 	= " "					
   FATTURA 		= " "		
   =AQUAREP_TOP(CGE_TOPX)			&& RICERCA TUTTE LE VARIABILI USATE PER GLI AGGIORNAMENTI LEGATE AL TOP	
 
   IF _NUMPRO = "CARICA" 
	   PN_C    = " "	
	   DO REG_NUMRPN              	&& PRELEVA E AGGIORNA PARAMETRI NUM.REGISTRAZIONE INTERNO DI PRIMA NOTA
	   CGE_PN_C   = PN_C
	   CGE_NUMPRO = PN_C 
   ELSE	
	   CGE_PN_C   = CGE_NUMPRO
	   CGE_NUMPRO = CGE_NUMPRO
   ENDIF	

   NPROT  		=  " "	
   DO REG_NUMPRO              		&& PRELEVA E AGGIORNA PARAMETRO NUM.PROTOCOLLO FORNITORE
   CGE_NPROT  	=  NPROT


   IF _TIPO = "FOR"
	   IF _NPARF = "CARICA"
		    DO REG_NUMPRC           	&& AGGIORNA PARAMETRO NUM.PARTITA FORNITORE
		   	CGE_NPARF  = PUB_NPARF
	   ELSE
		   	CGE_NPARF  = CGE_NPARF
	   ENDIF	
   ELSE
	   IF _NPARF = "CARICA"
		    DO AQUAREP_NPART           	&& AGGIORNA PARAMETRO NUM.PARTITA CLIENTE
		   	CGE_NPARF  = PUB_NPARF
	   ELSE
		   	CGE_NPARF  = CGE_NPARF
	   ENDIF	
   ENDIF


   IF _NREG = "CARICA"
	     DO AQUAREP_NUMREG           	&& AGGIORNA PARAMETRO NUM.PARTITA FORNITORE
   ENDIF	

   IF _NDOC	= "CARICANREG"				&& FORZA IL NUMERO DI REGISTRAZIONE
		CGE_NDOC = CGE_NREG
   ENDIF	

      
*!* ___________________________AGGIORNAMENTO ARCHIVI CENTRALI 

   =AQUAREP_AGGDBA()              	&& AGGIORNA CONTI/MOV_CONT/PATITARI




SELECT(AABBSXS)
RETURN

**********************************************************************************************************
*										AGGIORNAMENTO SISTEMA CONTABILE								 	 *
**********************************************************************************************************
FUNCTION DEF_AQUAREP
*!*	** definizione variabili pubbliche per aggiornare il sistema contabile


RELEASE     CGE_AGGANCIAPARTITARI           && FLAG PER L'AGGANCIO AUTOMATICO DEI PARTITARI DA IMPOSTARE SEMPRE CON " "
RELEASE	   	CGE_DATES    					&& FLAG GESTITO DALLA TESORERIA IMPOSTATO FISSO CON IL VALORE DI "DA-TES"
RELEASE	   	CGE_OKTES    					&& FLAG GESTITO DALLA TESORERIA IMPOSTATO CON IL VALORE DI "OK-TES" DOPO LA CERTIFICAZIONE DELLA REGISTRAZIONE

RELEASE	   	CGE_CON    						&& CONTO CONTABILE
RELEASE	   	CGE_COMM   						&& PRIMA DESCRIZIONE 
RELEASE	   	CGE_COM1   						&& SECONDA DESCRIZIONE
RELEASE	   	CGE_DA     						&& IMPORTO DARE
RELEASE	   	CGE_AV     						&& IMPORTO AVERE
RELEASE	   	CGE_IV     						&& CODICE IVA
RELEASE	   	CGE_IMP    						&& IMPOSTA
RELEASE	   	CGE_DESCO  						&& DESCRIZIONE CONTO 
RELEASE	   	CGE_CECOS  						&& CODICE CENTRO DI COSTO
RELEASE	   	CGE_WCCAGE 						&& SALVA CODICE AGENTE PER FATTURE CLIENTI SU MOV_CEE
RELEASE	   	CGE_KABBUO 						&& SALVA EVENTUALE ABBUONO CLIENTI/FORNITORI
RELEASE	   	CGE_XNOTE  						&& NOTA/COMMENTI
RELEASE	   	CGE_XCCLI  						&& MASTRO CLIENTE
RELEASE	   	CGE_XCFOR  						&& MASTRO FORNITORE
RELEASE		CGE_TOPX						&& TIPO OPERAZIONE
RELEASE		CGE_TOTDOCU						&& TOTALE DEL DOCUMETO 						(CGE_DA+CGE_AV)
RELEASE		CGE_DATAREG						&& DATA DI REGISTRAZIONE 					(GG/MM/AAAA)
RELEASE		CGE_NREG						&& NUMERO DI REGISTRAZIONE 					(CHR(6))
RELEASE		CGE_DATADOC						&& DATA DOCUMENTO 							(GG/MM/AAAA)
RELEASE		CGE_NDOC						&& NUMERO DOCUMENTO							(CHR(6))
RELEASE		CGE_NPROT						&& NUMERO DI PROTOCOLLO FORNITORI			(CHR(6))
RELEASE		CGE_PN_C						&& NUMERO INTERNO DI PRIMA NOTA				(CHR(10))
RELEASE		CGE_FR							&& FATTURE FORNITORI PERVENUTE IN RITARDO	(LOGICAL)
RELEASE		CGE_PESO						&& PESO PER GESTIONE ACQUISTI INTRASTAT		(NUMERIC (10,2))
RELEASE		CGE_NPARF						&& NUMERO PARTITA CLIENTE/FORNITORE			(NUMERIC (17,6))
RELEASE		CGE_TISPE						&& TIPO SPEDIZIONE ACQUISTI INTRASTAT		(CHR(3))
RELEASE		CGE_PORTO						&& PORTO ACQUISTI INTRASTAT					(CHR(3))
RELEASE		CGE_CLDOG						&& CLASSE DOGANALE ACQUISTI INTRASTAT		(CHR(16))
RELEASE		CGE_BANCA						&& CODICE BANCA								(CHR(5))
RELEASE		CGE_DATSCAD						&& DATA SCADENZA 							(GG/MM/AAAA)		
RELEASE		CGE_CPA							&& CONDIZIONI D PAGAMENTO					(CHR(3))
RELEASE	    CGE_BOLLATOIVA  				&& STAMPA BOLLATO IVA FATTURE DIFFERITA  	(CHR(1))
RELEASE		CGE_COSATRATTA 					&& COSA TRATTA IL FORNITORE					(CHR(5))
RELEASE		CGE_GRADOIMPORTANZA 			&& GRADO IMPORTANZA DEL FORNITORE			(CHR(5))	
RELEASE		CGE_FORMAPAGAMENTO 				&& FORMA PAGAMENTO DEL FORNITORE			(CHR(5))	
RELEASE		CGE_TIPOCONTRATTO 				&& FLUSSO FINANZIARIO						(CHR(5))	
RELEASE		CGE_CODACQ						&& TIPO CONTRATTO(CONTO ASS, DEP.,ESTIMAT.  (CHR(3))	
RELEASE		CGE_PRIPAGA						&& PRIORITA' DEL PAGAMENTO FORNITORE		(CHR(4))	
RELEASE		CGE_CONTABILITA_PREVISIONALE	&& CONTABILITA PREVISIONALE / EFFETTIVA		(CHR(1))	
RELEASE		CGE_XCAMBIO						&& CAMBIO									(NUMERIC (15,10))
RELEASE		CGE_VALUTA						&& CODICE VALUTA							(CHR(3))
RELEASE		CGE_XDATAVAL					&& DATA VALUTA								(GG/MM/AAAA)		
RELEASE		CGE_TMOV						&& TIPO MOVIMENTO (D=DARE;A=AVERE)			(CHR(1))		
RELEASE		CGE_XANOMAX						&& CODICE ANOMALIA PER CONTESTAZIONE DOC.	(CHR(3))		
RELEASE		CGE_CECO						&& CODICE CENTRO DI COSTO					(CHR(13))		
RELEASE     CGE_SEQUEN						&& NUMERO SEQUENZA RIGA MOV_CONT			(NUMERIC (15,0))
RELEASE     CGE_NUMPRO						&& SALVATAGGIO NUMERO INTERNO DI PRIMA NOTA	(CHR(10))

RELEASE     CGE_MPUBBLI						&& SALVATAGGIO NUMERO INTERNO DI PRIMA NOTA	(NUMERIC (14,3))

*** Fabiano 10/04/2005
RELEASE     CGE_DTPAG						&& DATA PAGAMENTO

PUBLIC      CGE_AGGANCIAPARTITARI           && FLAG PER L'AGGANCIO AUTOMATICO DEI PARTITARI DA IMPOSTARE SEMPRE CON " "
PUBLIC	   	CGE_DATES    					&& FLAG GESTITO DALLA TESORERIA IMPOSTATO FISSO CON IL VALORE DI "DA-TES"
PUBLIC	   	CGE_OKTES    					&& FLAG GESTITO DALLA TESORERIA IMPOSTATO CON IL VALORE DI "OK-TES" DOPO LA CERTIFICAZIONE DELLA REGISTRAZIONE

PUBLIC	   	CGE_CON    						&& CONTO CONTABILE
PUBLIC	   	CGE_COMM   						&& PRIMA DESCRIZIONE 
PUBLIC	   	CGE_COM1   						&& SECONDA DESCRIZIONE
PUBLIC	   	CGE_DA     						&& IMPORTO DARE
PUBLIC	   	CGE_AV     						&& IMPORTO AVERE
PUBLIC	   	CGE_IV     						&& CODICE IVA
PUBLIC	   	CGE_IMP    						&& IMPOSTA
PUBLIC	   	CGE_DESCO  						&& DESCRIZIONE CONTO 
PUBLIC	   	CGE_CECOS  						&& CODICE CENTRO DI COSTO
PUBLIC	   	CGE_WCCAGE 						&& SALVA CODICE AGENTE PER FATTURE CLIENTI SU MOV_CEE
PUBLIC	   	CGE_KABBUO 						&& SALVA EVENTUALE ABBUONO CLIENTI/FORNITORI
PUBLIC	   	CGE_XNOTE  						&& NOTA/COMMENTI
PUBLIC	   	CGE_XCCLI  						&& MASTRO CLIENTE
PUBLIC	   	CGE_XCFOR  						&& MASTRO FORNITORE
PUBLIC		CGE_TOPX						&& TIPO OPERAZIONE
PUBLIC		CGE_TOTDOCU						&& TOTALE DEL DOCUMETO 						(CGE_DA+CGE_AV)
PUBLIC		CGE_DATAREG						&& DATA DI REGISTRAZIONE 					(GG/MM/AAAA)
PUBLIC		CGE_NREG						&& NUMERO DI REGISTRAZIONE 					(CHR(6))
PUBLIC		CGE_DATADOC						&& DATA DOCUMENTO 							(GG/MM/AAAA)
PUBLIC		CGE_NDOC						&& NUMERO DOCUMENTO							(CHR(6))
PUBLIC		CGE_NPROT						&& NUMERO DI PROTOCOLLO FORNITORI			(CHR(6))
PUBLIC		CGE_PN_C						&& NUMERO INTERNO DI PRIMA NOTA				(CHR(10))
PUBLIC		CGE_FR							&& FATTURE FORNITORI PERVENUTE IN RITARDO	(LOGICAL)
PUBLIC		CGE_PESO						&& PESO PER GESTIONE ACQUISTI INTRASTAT		(NUMERIC (10,2))
PUBLIC		CGE_NPARF						&& NUMERO PARTITA CLIENTE/FORNITORE			(NUMERIC (17,6))
PUBLIC		CGE_TISPE						&& TIPO SPEDIZIONE ACQUISTI INTRASTAT		(CHR(3))
PUBLIC		CGE_PORTO						&& PORTO ACQUISTI INTRASTAT					(CHR(3))
PUBLIC		CGE_CLDOG						&& CLASSE DOGANALE ACQUISTI INTRASTAT		(CHR(16))
PUBLIC		CGE_BANCA						&& CODICE BANCA								(CHR(5))
PUBLIC		CGE_DATSCAD						&& DATA SCADENZA 							(GG/MM/AAAA)		
PUBLIC		CGE_CPA							&& CONDIZIONI D PAGAMENTO					(CHR(3))
PUBLIC	    CGE_BOLLATOIVA  				&& STAMPA BOLLATO IVA FATTURE DIFFERITA  	(CHR(1))
PUBLIC		CGE_COSATRATTA 					&& COSA TRATTA IL FORNITORE					(CHR(5))
PUBLIC		CGE_GRADOIMPORTANZA 			&& GRADO IMPORTANZA DEL FORNITORE			(CHR(5))	
PUBLIC		CGE_FORMAPAGAMENTO 				&& FORMA PAGAMENTO DEL FORNITORE			(CHR(5))	
PUBLIC		CGE_TIPOCONTRATTO 				&& FLUSSO FINANZIARIO						(CHR(5))	
PUBLIC		CGE_CODACQ						&& TIPO CONTRATTO(CONTO ASS, DEP.,ESTIMAT.  (CHR(3))	
PUBLIC		CGE_PRIPAGA						&& PRIORITA' DEL PAGAMENTO FORNITORE		(CHR(4))	
PUBLIC		CGE_CONTABILITA_PREVISIONALE	&& CONTABILITA PREVISIONALE / EFFETTIVA		(CHR(1))	
PUBLIC		CGE_XCAMBIO						&& CAMBIO									(NUMERIC (15,10))
PUBLIC		CGE_VALUTA						&& CODICE VALUTA							(CHR(3))
PUBLIC		CGE_XDATAVAL					&& DATA VALUTA								(GG/MM/AAAA)		
PUBLIC		CGE_TMOV						&& TIPO MOVIMENTO (D=DARE;A=AVERE)			(CHR(1))		
PUBLIC		CGE_XANOMAX						&& CODICE ANOMALIA PER CONTESTAZIONE DOC.	(CHR(3))		
PUBLIC		CGE_CECO						&& CODICE CENTRO DI COSTO					(CHR(13))		
PUBLIC      CGE_SEQUEN						&& NUMERO SEQUENZA RIGA MOV_CONT			(NUMERIC (15,0))
PUBLIC      CGE_NUMPRO						&& SALVATAGGIO NUMERO INTERNO DI PRIMA NOTA	(CHR(10))

PUBLIC      CGE_MPUBBLI						&& SALVATAGGIO NUMERO INTERNO DI PRIMA NOTA	(NUMERIC (14,3))

*** Fabiano 10/04/2005
PUBLIC      CGE_DTPAG						&& DATA PAGAMENTO

CGE_AGGANCIAPARTITARI           = " "
CGE_DATES    					= ""
CGE_OKTES    					= SPACE(06)

CGE_CON    						= SPACE(13)	&& CONTO CONTABILE							(CHR(13))
CGE_COMM   						= SPACE(30)	&& PRIMA DESCRIZIONE 						(CHR(30))
CGE_COM1   						= SPACE(30)	&& SECONDA DESCRIZIONE						(CHR(30))
CGE_DA     						= 0			&& IMPORTO DARE								(NUMERICO 17,3)
CGE_AV     						= 0			&& IMPORTO AVERE							(NUMERICO 17,3)
CGE_IV     						= SPACE(3)	&& CODICE IVA								(CHR(3))
CGE_IMP    						= 0			&& IMPOSTA									(NUMERICO 17,3)
CGE_DESCO  						= SPACE(30)	&& DESCRIZIONE CONTO 						(CHR(30))
CGE_CECOS  						= SPACE(13)	&& CODICE CENTRO DI COSTO					(CHR(13))
CGE_WCCAGE 						= SPACE(3)	&& CODICE AGENTE FATTURE CLI.MOV_CEE		(CHR(3))
CGE_KABBUO 						= 0			&& SALVA ABBUONO CLIENTI/FORNITORI			(NUMERICO 17,3)
CGE_XNOTE  						= SPACE(30)	&& NOTA/COMMENTI							(CHR(30))	
CGE_XCCLI  						= SPACE(4)	&& MASTRO CLIENTE							(CHR(4))
CGE_XCFOR  						= SPACE(4)	&& MASTRO FORNITORE							(CHR(4))
CGE_TOPX						= SPACE(3)	&& TIPO OPERAZIONE							(CHR(3))
CGE_TOTDOCU						= 0			&& TOTALE DEL DOCUMETO 						(CGE_DA+CGE_AV)
CGE_DATAREG						= SPACE(10)	&& DATA DI REGISTRAZIONE 					(GG/MM/AAAA)
CGE_NREG						= SPACE(6)	&& NUMERO DI REGISTRAZIONE 					(CHR(6))
CGE_DATADOC						= SPACE(10)	&& DATA DOCUMENTO 							(GG/MM/AAAA)
CGE_NDOC						= SPACE(6)	&& NUMERO DOCUMENTO							(CHR(6))
CGE_NPROT						= SPACE(6)	&& NUMERO DI PROTOCOLLO FORNITORI			(CHR(6))
CGE_PN_C						= SPACE(10)	&& NUMERO INTERNO DI PRIMA NOTA				(CHR(10))
CGE_FR							= .F.		&& FATTURE FORNITORI PERVENUTE IN RITARDO	(LOGICAL)
CGE_PESO						= 0			&& PESO PER GESTIONE ACQUISTI INTRASTAT		(NUMERIC (10,2))
CGE_NPARF						= 0			&& NUMERO PARTITA CLIENTE/FORNITORE			(NUMERIC (17,6))
CGE_TISPE						= SPACE(3)	&& TIPO SPEDIZIONE ACQUISTI INTRASTAT		(CHR(3))
CGE_PORTO						= SPACE(3)	&& PORTO ACQUISTI INTRASTAT					(CHR(3))
CGE_CLDOG						= SPACE(16)	&& CLASSE DOGANALE ACQUISTI INTRASTAT		(CHR(16))
CGE_BANCA						= SPACE(5)	&& CODICE BANCA								(CHR(5))
CGE_DATSCAD						= SPACE(10)	&& DATA SCADENZA 							(GG/MM/AAAA)		
CGE_CPA							= SPACE(3)	&& CONDIZIONI D PAGAMENTO					(CHR(3))
CGE_BOLLATOIVA  				= SPACE(1)	&& STAMPA BOLLATO IVA FATTURE DIFFERITA  	(CHR(1))
CGE_COSATRATTA 					= SPACE(5)	&& COSA TRATTA IL FORNITORE					(CHR(5))
CGE_GRADOIMPORTANZA 			= SPACE(5)	&& GRADO IMPORTANZA DEL FORNITORE			(CHR(5))	
CGE_FORMAPAGAMENTO 				= SPACE(5)	&& FORMA PAGAMENTO DEL FORNITORE			(CHR(5))	
CGE_TIPOCONTRATTO 				= SPACE(5)	&& FLUSSO FINANZIARIO						(CHR(5))	
CGE_CODACQ						= SPACE(3)	&& TIPO CONTRATTO(CONTO ASS, DEP.,ESTIMAT.  (CHR(3))	
CGE_PRIPAGA						= SPACE(4)	&& PRIORITA' DEL PAGAMENTO FORNITORE		(CHR(4))	
CGE_CONTABILITA_PREVISIONALE	= SPACE(1)	&& CONTABILITA PREVISIONALE / EFFETTIVA		(CHR(1))	
CGE_XCAMBIO						= 0 		&& CAMBIO									(NUMERIC (15,10))
CGE_VALUTA						= SPACE(3)	&& CODICE VALUTA							(CHR(3))
CGE_XDATAVAL					= SPACE(10)	&& DATA VALUTA								(GG/MM/AAAA)		
CGE_TMOV						= SPACE(1) 	&& TIPO MOVIMENTO (D=DARE;A=AVERE)			(CHR(1))		
CGE_XANOMAX						= SPACE(3)	&& CODICE ANOMALIA PER CONTESTAZIONE DOC.	(CHR(3))		
CGE_CECO						= SPACE(13)	&& CODICE CENTRO DI COSTO					(CHR(13))		
CGE_SEQUEN						= 0 		&& NUMERO SEQUENZA RIGA MOV_CONT			(NUMERIC (15,0))
CGE_NUMPRO						= SPACE(10) && SALVATAGGIO NUMERO INTERNO DI PRIMA NOTA	(CHR(10))
CGE_MPUBBLI						= 0			&& SALVATAGGIO NUMERO INTERNO DI PRIMA NOTA	(NUMERIC (14,3))

*** Fabiano 10/04/2005
CGE_DTPAG						= space(10) && DATA PAGAMENTO

			

RETURN
        
*************************************************************************
*   				CREA PARTITARI E SALDI PARTITE CLIENTI     			*
*************************************************************************
FUNCTION AQUAREP_PARCLI



x_soci = "CLI_codsoc = '" + PUB_CODSOC + "'"
x_codi = "CLI_codcli = '" + SUBSTR(CGE_CON,PUB_SOTTOG,PUB_CONTO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_CLI_an where " + x_cond + " order by CLI_codsoc,CLI_codcli"
IF !ExecCommand(cSql,"cur_clienti")
   return(.f.)
ENDIF

RELEASE V_DESCRIC
PUBLIC V_DESCRIC


SELECT cur_clienti
GO TOP
IF EOF()
   V_DESCRIC = SPACE(15)
   V_TELEFO  = SPACE(15)
   V_PARIVA  = SPACE(11)
   V_CONPAG  = PUB_CPA 
ELSE
   V_DESCRIC = CLI_RAGSOC
   V_TELEFO  = CLI_TELEFO
   V_PARIVA  = CLI_PARIVA
   V_CONPAG  = CLI_CONPAG
ENDIF

IF !ExecCommand("select * from PART_CLI where 0=1","cur_partcli")
   return(.f.)
ENDIF


SELECT CUR_partcli
APPEND BLANK
REC_PART=RECNO()


REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
REPLACE PAR_TIPODO  WITH "FAT"

IF FATTURA='P'
   REPLACE PAR_TIPODO  WITH "PAG"
ENDIF

IF FATTURA='I'
   REPLACE PAR_TIPODO  WITH "INS"
ENDIF

IF FATTURA='N'
   REPLACE PAR_TIPODO  WITH "NCR"
ENDIF


REPLACE PAR_CODCLI  WITH CGE_CON
REPLACE PAR_RAGSOC  WITH V_DESCRIC
REPLACE PAR_DTREG   WITH RIBALTA2(CGE_DATAREG)
REPLACE PAR_DTFAT   WITH RIBALTA2(CGE_DATADOC)
REPLACE PAR_TIPFAT  WITH CGE_TOPX
REPLACE PAR_TOTIM   WITH (CGE_TOTDOCU-CGE_IMP+CGE_KABBUO)        && SOMMA EVENTUALE ABBUONO
REPLACE PAR_TIMPOS  WITH CGE_IMP
REPLACE PAR_FATT    WITH CGE_TOTDOCU+CGE_KABBUO                                    && SOMMA EVENTUALE ABBUONO
REPLACE PAR_NUMFAT  WITH CGE_NDOC

* --------  Gestione contabilità previsionale -------- *
 IF ALLTRIM(PUB_TIPOGE) = "PREVISIONALE"
   REPLACE PAR_CONTABILITA_PREVISIONALE    WITH "P"
 ELSE
   REPLACE PAR_CONTABILITA_PREVISIONALE    WITH " "
 ENDIF
* --------  Gestione contabilità previsionale -------- *

      * --------  Blocca / sblocca registrazione previsionale -------- *
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIEFFETTIVA"
	      REPLACE PAR_CONTABILITA_PREVISIONALE    WITH " "
	  ENDIF
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIPREVISIONALE"
	      REPLACE PAR_CONTABILITA_PREVISIONALE    WITH "P"
	  ENDIF
      * --------  Blocca / sblocca registrazione previsionale -------- *

* --------  Classifica la partita -------- *
*!*	REPLACE PAR_COSATRATTA 		WITH CGE_COSATRATTA
*!*	REPLACE PAR_GRADOIMPORTANZA WITH CGE_GRADOIMPORTANZA
*!*	REPLACE PAR_FORMAPAGAMENTO 	WITH CGE_FORMAPAGAMENTO
*!*	REPLACE PAR_TIPOCONTRATTO 	WITH CGE_TIPOCONTRATTO
*!*	REPLACE PAR_CODACQ			WITH CGE_CODACQ
*!*	REPLACE PAR_PRIPAGA			WITH CGE_PRIPAGA
* --------  Classifica la partita -------- *

* ---------  Controllo ddt/fatture -------- *
REPLACE PAR_ANOMAX			WITH CGE_XANOMAX
* ---------  Controllo ddt/fatture -------- *


* ------- MAX Nuovi Campi Per Euro ------- *
REPLACE PAR_CAMBIO WITH CGE_XCAMBIO
REPLACE PAR_VALUTA WITH CGE_XVALUTA
*REPLACE PAR_DTVAL  WITH CGE_XDATAVAL
=CAMBIADT(CGE_XDATAVAL,"PAR_DTVAL")

* ------- MAX Nuovi Campi Per Euro ------- *
REPLACE PAR_BANCA   WITH CGE_BANCA
IF EMPTY(TOP_COL)
   REPLACE PAR_NPROG   WITH 100
ELSE
   REPLACE PAR_NPROG   WITH 900
ENDIF
IF PAR_TIPODO <> "FAT"  && GESTIONE INSERIMENTO DA PRIMA NOTA
   REPLACE PAR_NPROG   WITH 900
ENDIF
IF __CONTO ='I'   && APERTURA DI BILANCIO PER CLIENTI 
   REPLACE PAR_TIPODO  WITH "PAG"
   REPLACE PAR_NPROG   WITH 900
ENDIF 


REPLACE PAR_NPART   WITH CGE_NPARF       && CONSIDERA COME NUMERO DI PARTITA ETERNO
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(CGE_NREG)
REPLACE PAR_NUMPRO  WITH ALLTRIM(CGE_PN_C)
REPLACE PAR_CIVA1   WITH CGE_IV
REPLACE PAR_IMPO1   WITH (CGE_TOTDOCU-CGE_IMP+CGE_KABBUO)
REPLACE PAR_IMPOS1  WITH CGE_IMP
REPLACE PAR_TOT1    WITH CGE_TOTDOCU+CGE_KABBUO
REPLACE PAR_TOTIM   WITH (CGE_TOTDOCU-CGE_IMP+CGE_KABBUO)
REPLACE PAR_TIMPOS  WITH CGE_IMP
REPLACE PAR_FATT    WITH CGE_TOTDOCU+CGE_KABBUO
REPLACE PAR_DESMOV  WITH CGE_COMM
REPLACE PAR_DESMO1  WITH CGE_COM1


IF CGE_DA<>0
   REPLACE PAR_TMOV WITH "D"
ENDIF
IF CGE_AV<>0
   REPLACE PAR_TMOV WITH "A"
ENDIF

IF FATTURA='P' .OR.  FATTURA='I' .OR. CGE_AGGANCIAPARTITARI = 'S'           && GESTISCO UNA SECONDA REPLACE A QUESTO PUNTO
   REPLACE PAR_TOTIM   WITH CGE_DA+CGE_AV+KABBUO                            && SOMMA EVENTUALE ABBUONO
   REPLACE PAR_TIMPOS  WITH 0
   REPLACE PAR_FATT    WITH CGE_DA+CGE_AV+KABBUO                            && SOMMA EVENTUALE ABBUONO
   REPLACE PAR_IMPO1   WITH 0
   REPLACE PAR_IMPOS1  WITH 0
   REPLACE PAR_TOT1    WITH 0
   REPLACE PAR_NPROG   WITH 900
ENDIF

DATA_SCAD=SPACE(10)
=AQUAREP_SCADC()      && GESTIONE SCADENZIARIO clienti SOLO SE FATTURE / EFFETTI


SELECT CUR_partcli
GO TOP

XYZ_CONTO   = PAR_CODCLI	 && CODICE DEL cliente
XYZ_PARTITA = PAR_NPART	 	 && PARTITA cliente

IF !EMPTY(CGE_DATASCAD)
	REPLACE PAR_DTSCAD  		 WITH RIBALTA2(CGE_DATASCAD)
ELSE
	REPLACE PAR_DTSCAD  		 WITH RIBALTA2(DATA_SCAD)
ENDIF


*** Fabiano 14/04/2005 - GESTIONE PAR_DATPAG
IF EMPTY(CGE_DTPAG)
	*REPLACE PAR_DATPAG WITH RIBALTA2(PAR_DTSCAD) 
    =CAMBIADT(PAR_DATPAG,"PAR_DATPAG")
ELSE
	*REPLACE PAR_DATPAG WITH RIBALTA2(CGE_DTPAG)
    =CAMBIADT(CGE_DTPAG,"PAR_DATPAG")
ENDIF



IF !ExecRW('','PART_CLI','I','','CUR_partcli')
   return(.f.)
ENDIF


*!*	2008-05-30 SERGIO/SIMONE - NO SALDI
*!*	=CREA_SALDI_CF("C",XYZ_CONTO,XYZ_PARTITA,"XXXXXXXXXX","CREA")


RETURN

*************************************************************************
*    GESTIONE SCADENZIARIO FORNITORI                                    *
*************************************************************************
PROCEDURE AQUAREP_SCADF


IF FATTURA = 'S' .OR. FATTURA = 'A'    && ESEGUE SOLO SE SI TRATTA DI FATTURA
ELSE
   RETURN
ENDIF

HH=SELECT()
x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_codi = "for_codcli = '" + SUBSTR(CGE_CON,PUB_SOTTOG,PUB_CONTO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"cur_fornitore")
   return(.f.)
ENDIF

SELECT cur_fornitore
GO TOP

IF EOF()
   V_CONPAG  = PUB_CPA   && FORZATURA CPA CONTANTI
ELSE
   V_CONPAG  = FOR_CONPAG                                                         && DA ANAGRAFICA FORNITORI
ENDIF


DATA_SCAD   = SPACE(10)
PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
VET_DAL[1]= "0000"      
VET_DAL[2]= "0000"
VET_AL[1] = "0000"
VET_AL[2] = "0000" 
VET_DAY[1]= "0000" 
VET_DAY[2]= "0000"
___FLAG_POSALL = .F.	&& 2010-08-04 sergio posticipi per tutto l'anno
___CLIENTE     = ""		&& 2010-08-04 sergio posticipi per tutto l'anno


RELEASE __T_IMPON,__T_IMPOS   
PUBLIC  __T_IMPON,__T_IMPOS   
__T_IMPON	= CGE_DA+CGE_AV+CGE_KABBUO

IF FATTURA = 'S'								&& SOLO SE SI TRATTA DI FATTURA SCORPORA L'IVA NEL CASO DI INSOLUTO/EFFETTO O ALTRO NO						
	__T_IMPOS   = CGE_IMP 						&& SOLO SE SI TRATTA DI FATTURA SCORPORA L'IVA NEL CASO DI INSOLUTO/EFFETTO O ALTRO NO
ELSE
	__T_IMPOS   = 0
ENDIF 


V_TUTTO=TRANCHE("PARA",V_CONPAG,RIBALTA2(CGE_DATADOC),(CGE_DA+CGE_AV+CGE_KABBUO),VET_DAL,VET_AL,VET_DAY,CGE_VALUTA,___FLAG_POSALL,___CLIENTE,__T_IMPON,__T_IMPOS)    && 2010-08-04 sergio posticipi per tutto l'anno


=AQUAREP_PERIODI()    && CREA I PERIODI DI SCADENZA


RETURN



*************************
PROCEDURE AQUAREP_PERIODI
*************************

SELECT CU_TRANK
GO TOP
DO WHILE .NOT. EOF()


    DATA_SCAD = TK_DSCAD
	IMP_TRANK = TK_IMP_SCAD 
	
	=AQUAREP_CREA_PERI()
	
	SELECT CU_TRANK
	SKIP +1

ENDDO



RETURN

***************************
PROCEDURE AQUAREP_CREA_PERI
***************************


** ===>>> CREA I PERIODI DI SCADENZA
IF CLI_FOR='C'
   SELECT CUR_PARTCLI
ELSE
   SELECT CUR_PARTFOR
ENDIF

APPEND BLANK
REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO

REPLACE PAR_TIPODO  WITH "FAT"
IF FATTURA = "A"
	REPLACE PAR_TIPODO  WITH "PAG"
ENDIF

REPLACE PAR_CODCLI  WITH CGE_CON
REPLACE PAR_RAGSOC  WITH V_DESCRIC
REPLACE PAR_DTREG   WITH RIBALTA2(CGE_DATAREG)
REPLACE PAR_DTFAT   WITH RIBALTA2(CGE_DATADOC)
REPLACE PAR_TIPFAT  WITH CGE_TOPX
REPLACE PAR_TOTIM   WITH 0
REPLACE PAR_TIMPOS  WITH 0
REPLACE PAR_FATT    WITH IMP_TRANK
REPLACE PAR_DESMOV  WITH CGE_COMM
REPLACE PAR_DESMO1  WITH CGE_COM1


* --------  Gestione contabilità previsionale -------- *
  IF ALLTRIM(PUB_TIPOGE) = "PREVISIONALE"
      REPLACE PAR_CONTABILITA_PREVISIONALE    WITH "P"
  ELSE
      REPLACE PAR_CONTABILITA_PREVISIONALE    WITH " "
  ENDIF
* --------  Gestione contabilità previsionale -------- *

* --------  Blocca / sblocca registrazione previsionale -------- *
IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIEFFETTIVA"
    REPLACE PAR_CONTABILITA_PREVISIONALE    WITH " "
ENDIF
IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIPREVISIONALE"
    REPLACE PAR_CONTABILITA_PREVISIONALE    WITH "P"
ENDIF
* --------  Blocca / sblocca registrazione previsionale -------- *


* --------  Classifica la partita -------- *
IF CLI_FOR='F'
	REPLACE PAR_COSATRATTA 		WITH CGE_COSATRATTA
	REPLACE PAR_GRADOIMPORTANZA WITH CGE_GRADOIMPORTANZA
	REPLACE PAR_FORMAPAGAMENTO 	WITH CGE_FORMAPAGAMENTO
	REPLACE PAR_TIPOCONTRATTO 	WITH CGE_TIPOCONTRATTO
	REPLACE PAR_CODACQ			WITH CGE_CODACQ
	REPLACE PAR_PRIPAGA			WITH CGE_PRIPAGA
ENDIF
* --------  Classifica la partita -------- *


* ---------  Controllo ddt/fatture -------- *
REPLACE PAR_ANOMAX			WITH CGE_XANOMAX
* ---------  Controllo ddt/fatture -------- *


* ------- MAX Nuovi Campi Per Euro ------- *
REPLACE PAR_CAMBIO WITH CGE_XCAMBIO
REPLACE PAR_VALUTA WITH CGE_XVALUTA
*REPLACE PAR_DTVAL  WITH CGE_XDATAVAL
=CAMBIADT(CGE_XDATAVAL,"PAR_DTVAL")

* ------- MAX Nuovi Campi Per Euro ------- *
REPLACE PAR_BANCA   WITH CGE_BANCA
IF CGE_DA<>0
   REPLACE PAR_TMOV WITH "D"
ENDIF
IF CGE_AV<>0
   REPLACE PAR_TMOV WITH "A"
ENDIF
REPLACE PAR_NUMFAT  WITH CGE_NDOC
XPRG = CONTA_TRA * 100
REPLACE PAR_NPROG   WITH XPRG + 100

REPLACE PAR_NPART   WITH CGE_NPARF


IF CLI_FOR='C'
*!*	   REPLACE PAR_NPART   WITH VAL(CGE_NDOC)
   REPLACE PAR_NPROT   WITH ALLTRIM(CGE_NDOC)     &&& ALLTRIM(CGE_NPROT)
ENDIF

REPLACE PAR_DTSCAD  WITH RIBALTA2(DATA_SCAD)
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(CGE_NREG)
REPLACE PAR_NUMPRO  WITH ALLTRIM(CGE_PN_C)
IF CLI_FOR='F'
   REPLACE PAR_FATRI   WITH CGE_FR        && FATTURE FORNITORI IN RITARDO
ENDIF

REPLACE PAR_CIVA1   WITH CGE_IV
REPLACE PAR_IMPO1   WITH (CGE_TOTDOCU-CGE_IMP+CGE_KABBUO)
REPLACE PAR_IMPOS1  WITH CGE_IMP
REPLACE PAR_TOT1    WITH CGE_TOTDOCU+CGE_KABBUO



RETURN

****************************************
FUNCTION EUR_PART
****************************************
**
** DETERMINA SE LA PARTITA DEL CLIENTE/FORNITORE E' PAREGGIATA O NO
**
** ESTRAE I MOVIMENTI DI OGNI SINGOLA PARTITA CLIENTE O FORNITORE IN BASE AL NUMERO DI PARTITA
**
** RESTITUISCE .T. NEL CASO IN CUI LA PARTITA E' CHIUSA , .F. NEL CASO LA PARTITA SIA ANCORA APERTA
**
** PARAMETRI DA GESTIRE :
**
**     _CF  		=  C  SE CLIENTE , F SE FORNITORE
**     _ARCH_IN		=  PART_CLI SE PARTITARIO CLIENTI , PART_FOR SE PARTITARIO FORNITORI
**     _CONTO		=  CODICE DEL CONTO CLIENTE / FORNITORE (COMPRENSIVO DEL SOTTOGRUPPO)
**     _PARTITA		=  NUMERO DELLA PARTITA DA RICERCARE
**     _CURSORE     =  NOME DEL CURSORE DI LAVORO	
**     _RAGGR		=  DA IMPOSTARE SEMPRE CON .T. RAGGRUPPA TUTTI I MOVIMENTI NEL_CURSORE OTTENENDO IL SALDO DELLA PARTITA
**	   _DIFFAR		*  CREA RECORD CON TOP AR$ PER DIFFERENZA DI ARROTONDAMENTO IN VALUTA EURO
**	   _RAGSC		*  S= CREA PART_EUR PER CONTO,PARTITA,DATA SCADENZA  (FUNZIONE NON ANCORA ATTIVA IN QUANTO DEDOTTA DALLA NUOVA GESTIONE SCAD_CLI/SCAD_FOR)
**
**
** CURSORE DI SUPPORTO DA USARE :
**
**		PART_EUR	=  DA CREARE LA PRIMA VOLTA ; CONTIENE IL RECORD DI SALDO DELLA PARTITA
**					=  E' USATO DA :
**							
**						EUR_PART PER VERIFICARE ULTERIORMENTE IL SALDO DELLA PARTITA
**							SENZA RIPETERE TUTTO IL PROCESSO DI CALCOLO
**
**					=  QUESTO CURSORE VIENE DEFINITO IN DEF_EURO()	
**
**
** FABIANO 21/03/2006 - NASCONDERE FATTURE LEGATE A EFFETTI PASSIVI CON VALORIZZAZIONE
** DI UNNUOVO FLAG _NASCONDE_FATTURE_LEGATE_A_EFFETTI_PASSIVI = "S"
**						
**
**					= se attivo il flag Pub_flag_escludi_movimenti_partitari
**					  la procedura non considera i movimeti al di fuori dell'intervallo digitato	
**
** SERGIO 20/11/2011 - ESCLUDE O MENO LE PARTITE DICHIARATE DUBBIE DAL RECUPERO CREDITI (PAR_NOPART=.T.)
**
**
**
**************************************************************************************

PARA _CF,_ARCH_IN,_CONTO,_PARTITA,_CURSORE,_RAGGR,_DIFFAR,_RAGSC,_NASCONDE_FATTURE_LEGATE_A_EFFETTI_PASSIVI


_N_PAR  = PARAMETERS()											&& PARTE NUOVA
IF _N_PAR   = 7													&& PARTE NUOVA
   _RAGSC = " "													&& PARTE NUOVA
   _NASCONDE_FATTURE_LEGATE_A_EFFETTI_PASSIVI ="" 				&& FABIANO 21/03/2006 - NASCONDERE FATTURE LEGATE A EFFETTI PASSIVI
ENDIF															&& PARTE NUOVA	

IF _N_PAR   = 8	                                  				&& FABIANO 21/03/2006 - NASCONDERE FATTURE LEGATE A EFFETTI PASSIVI      
   _NASCONDE_FATTURE_LEGATE_A_EFFETTI_PASSIVI ="" 				&& FABIANO 21/03/2006 - NASCONDERE FATTURE LEGATE A EFFETTI PASSIVI
ENDIF							                                && FABIANO 21/03/2006 - NASCONDERE FATTURE LEGATE A EFFETTI PASSIVI


*!*	CONSIDERA SEMPRE LA GESTIONE DELLE PARTITE DUBBIE A PRESCINDERE DAL RICHIAMO
*!*	_ESCLUDE_PARTITE_DUBBIE = .T.								&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	   
_ESCLUDE_PARTITE_DUBBIE = .F.									&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	   
*!*	CONSIDERA SEMPRE LA GESTIONE DELLE PARTITE DUBBIE A PRESCINDERE DAL RICHIAMO

** DEFINIZIONE VARIABILI

AABBSS    = SELECT()
II        = TAG()
_QUIQUI   = RECNO()
_TD_ITL   = 0
_TD_EUR   = 0
_TA_ITL   = 0
_TA_EUR   = 0
_NMOVD    = 0
_NMOVA    = 0
_PARCLO   = .F.   && PARTITA APERTA

RELEASE FLAG_PARTITA_DUBBIA 									&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE
PUBLIC FLAG_PARTITA_DUBBIA 										&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE
FLAG_PARTITA_DUBBIA = .F.										&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE


CREATE CURSOR &_CURSORE ;
	(INDICE C(13),  NUMPRO C(13),  _XNREG C(08),  DTREG C(10),   TIPODOC C(10), NUMDOC C(7),     ;
	 NPROT C(10),   TDOC C(3),     DTDOC C(10),   DTSCAD C(10),  VALUTA C(3),   CAMBIO N(15,10), ;
	 D_ITL N(17,3), A_ITL N(17,3), T_ITL N(17,3), D_EUR N(17,3), A_EUR N(17,3), T_EUR N(17,3), T_NOPART L,   ;
	 T_DIF N(17,3), ANOMAX C(3))

CSQL = "select * from " + _ARCH_IN + " where 0=1"
IF !ExecCommand(CSQL,_ARCH_IN)
  return(.f.)
ENDIF
SELECT &_ARCH_IN
AA = AFIELDS(PARTXXX)
CREATE CURSOR _EURPART FROM ARRAY PARTXXX



* PRIMA VERIFICA INCROCIATA PER SAPERE SE LA PARTITA E' SALDATA

SELECT PART_EUR
SET ORDER TO PART_EUR
SEEK ALLTRIM(_CONTO) + STR(_PARTITA,10,0)

IF _RAGSC = "S"    	&& CREA PART_EUR PER PARTITA , DATA DI SCADENZA
ELSE

	IF FOUND()			&& PARTITA GIA' TRATTATA DA EUR_PART : NON PROSEGUO CON IL RIFACIMENTO DEI CALCOLI

*!*		   IF _ESCLUDE_PARTITE_DUBBIE 	&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE
*!*		       IF T_NOPART = .T.		&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*				  _PARCLO=.T.			&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*				  RETURN(_PARCLO)		&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*			   ENDIF					&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*	       ENDIF						&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE
       
	   IF T_EUR = 0
		  IF T_DIF = 0
		     _PARCLO=.T.
			 RETURN(_PARCLO)	
		  ELSE
			 _PARCLO=.F.
			 RETURN(_PARCLO)
		  ENDIF	
	   ELSE
	      _PARCLO=.F.
		  RETURN(_PARCLO)
	   ENDIF
	ENDIF

ENDIF

*** PREPARA LE CONDIZIONI DI RICERCA DELLA PARTITA NELLA TABELLA
*** PART_CLI OPPURE PART_FOR
***
x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
x_clie = "par_codcli = '" + ALLTRIM(_CONTO) + "'"
x_npar = "par_npart = " + ALLTRIM(STR(_PARTITA,10,0))

*** FABIANO 11/06/2006 - NASCONDERE FATTURE LEGATE A EFFETTI PASSIVI
*** SE HO IMPOSTATO _NASCONDE_FATTURE_LEGATE_A_EFFETTI_PASSIVI="S"
*** ALLORA NON VOGLIO FAR VEDERE LE PARTITE LEGATE AD EFFETTI PASSIVI 
***

IF ALLTRIM(_ARCH_IN)="PART_FOR" AND _NASCONDE_FATTURE_LEGATE_A_EFFETTI_PASSIVI="S"

   *** CONTROLLO SE LA PARTITA E' ASSOCIATA AD EFFETTI PASSIVI
   *** OSSIA TRA TUTTE LE RIGHE RIFERITE ALLA PARTITA PRESENTI SUL PARTITARIO
   *** NE ESISTE ALMENO UNA ASSOCIATA AD EFFETTI PASSIVI
   *** IN TAL CASO NON MOSTRA QUESTA PARTITA 

   cSql="SELECT * FROM " + _ARCH_IN + " WHERE " + x_soci + " and " + x_clie + " and " + x_npar +;
   	  " AND PAR_NUMPRO IN (SELECT ASS_NUMPRO FROM U_ASS_DD WHERE ASS_NUMPRO=PAR_NUMPRO)"
   
	IF !ExecCommand(cSql,"_TEST_EFF")
	   return(.f.)
	ENDIF

	*** C'E' ALMENO UNA RIGA DI PARTITARIO ASSOCIATA A EFFETTO PASSIVO
	*** ALLORA QUESTA PARTITA NON E' DA FAR VEDERE 
	*** PERCHE' HO SCELTO _NASCONDE_FATTURE_LEGATE_A_EFFETTI_PASSIVI="S"
	***
	SELECT _TEST_EFF
	IF RECCOUNT()>0
		_PARCLO   = .T.
		RETURN _PARCLO  
	ENDIF

ENDIF	

*** FABIANO 11/06/2006 - NASCONDERE FATTURE LEGATE A EFFETTI PASSIVI

** CREA CURSORE CON TUTTI I MOVIMENTI DELLA PARTITA **********************


IF Pub_flag_escludi_movimenti_partitari
       
	____x_data = "par_dtreg between '" + Pub_data_dal+ "' and '" + Pub_data_al+ "'"
	
	cSql="SELECT * FROM " + _ARCH_IN + " WHERE " + x_soci + " and " + x_clie + " and " + x_npar + " and " + ____x_data + ;
	                                   " order by par_codsoc,par_codcli,par_npart"

ELSE
	
	cSql="SELECT * FROM " + _ARCH_IN + " WHERE " + x_soci + " and " + x_clie + " and " + x_npar + ;
	                                   " order by par_codsoc,par_codcli,par_npart"
ENDIF




IF !ExecCommand(cSql,_ARCH_IN)
   return(.f.)
ENDIF

SELECT &_ARCH_IN
GO TOP
DO WHILE .NOT.EOF()
	SCATTER MEMVAR MEMO
	SELECT _EURPART
	APPEND BLANK
	GATHER MEMVAR MEMO	
	SELECT &_ARCH_IN
	SKIP +1
ENDDO

* VERIFICO SE LA PARTITA E' STATA CHIUSA CON MOVIMENTO AUTOMATICO
* DI ARROTONDAMENTO  AR$

SELECT *;
  FROM _EURPART;
  WHERE "AR$" $ PAR_TIPFAT INTO CURSOR _TMP
SELECT _TMP
IF RECCOUNT()<>0
   _PARCLO=.T.
   RETURN(_PARCLO)
ENDIF



SELECT _EURPART

GO TOP

DO WHILE .NOT.EOF()

   DO CASE
 	  CASE _CF = "C"		&& FILTRO CLIENTE
	       IF PAR_TIPODO = 'FAT' .AND. PAR_NPROG = 100
		      SKIP + 1
		      LOOP
		   ENDIF
		   IF PAR_TIPODO = 'INC' .AND. PAR_NPROG = 100
		      SKIP + 1
		      LOOP
		   ENDIF
	  CASE _CF = "F"		&& FILTRO FORNITORE
		   IF PAR_TIPODO = 'FAT' .AND. PAR_NPROG = 100
		      SKIP + 1
		      LOOP
		   ENDIF
   ENDCASE

   SCATTER MEMVAR MEMO
   
*!*	IF PAR_NPART = 52271
*!*		SET STEP ON 
*!*	ENDIF

   M.DTREG       = RIBALTA2(PAR_DTREG)
   M._XNREG      = PAR_NREG
   M.INDICE      = ALLTRIM(PAR_NUMFAT)
   M.DESMOV      = PAR_DESMOV
   M.DESMOV1     = PAR_DESMO1
   M.CAMBIO      = PAR_CAMBIO
   M.VALUTA      = PAR_VALUTA
   M.DTSCAD      = PAR_DTSCAD
   M.TDOC        = PAR_TIPFAT
   M.T_NOPART    = PAR_NOPART  				&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE

   DO CASE
 	  CASE _CF = "C"		&& FILTRO CLIENTE
           M.NPROT       = PAR_NPROT
 	  CASE _CF = "F"		&& FILTRO FORNITORE
 	       M.NPROT       = PAR_NUMFAT
   ENDCASE

   WTF = PAR_TIPFAT
   _WT = 3 - LEN(ALLTRIM(WTF))

   IF EMPTY(M.DTREG)
      M.DTREG = REPLICATE(" " ,10)
   ENDIF

   M.NUMDOC = PAR_NUMFAT
   M.NUMPRO = PAR_NUMPRO
   SP       = LEN(ALLTRIM(M.NUMDOC))
   _SP      = (7 - SP)
   M.NUMDOC = REPLICATE(" " ,_SP)+ ALLTRIM(M.NUMDOC)
   M.DTDOC  = RIBALTA2(PAR_DTFAT)
   IF EMPTY(M.DTDOC)
      M.DTDOC = REPLICATE(" " ,10)
   ENDIF
   WTF      = PAR_TIPFAT
   DAT      = RIBALTA2(PAR_DATPAG)
   NAT      = PAR_TMOV    && PRENDE LA NATURA DEL MOVIMENTO DAL DATABASE
   DA       = 0
   AV       = 0
   IF NAT   = "D"
      DA    = PAR_FATT
      DS    = RIBALTA2(PAR_DTSCAD)
   ELSE
      AV    = PAR_FATT
      DS    = RIBALTA2(PAR_DATPAG)
   ENDIF

   SELECT &_CURSORE
   APPEND BLANK
   REPLACE DTREG    WITH M.DTREG
   REPLACE _XNREG   WITH M._XNREG
   REPLACE INDICE   WITH M.INDICE
   REPLACE NUMDOC   WITH M.NUMDOC
   REPLACE NUMPRO   WITH M.NUMPRO
   REPLACE DTDOC    WITH M.DTDOC
   REPLACE DTSCAD   WITH M.DTSCAD
   REPLACE CAMBIO   WITH M.CAMBIO
   REPLACE VALUTA   WITH M.VALUTA
   REPLACE TIPODOC  WITH REPLICATE(" " ,_WT) + ALLTRIM(WTF)
   REPLACE NPROT    WITH M.NPROT
   REPLACE TDOC     WITH M.TDOC
   REPLACE T_NOPART WITH M.T_NOPART    	&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE
   FLAG_PARTITA_DUBBIA = M.T_NOPART    	&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE

   IF M.PAR_TMOV = "D"
      _NMOVD = _NMOVD +1
      IF M.PAR_TIPFAT <> "AR$"
 	     REPLACE D_ITL WITH TLIRE(M.PAR_VALUTA,M.PAR_FATT,RIBALTA2(M.PAR_DTFAT))
	  ENDIF
 	  REPLACE D_EUR WITH TEURO(M.PAR_VALUTA,M.PAR_FATT,RIBALTA2(M.PAR_DTFAT))
	  _TD_ITL   = _TD_ITL   + D_ITL
	  _TD_EUR   = _TD_EUR   + D_EUR
   ENDIF

   IF PAR_TMOV = "A"
      _NMOVA = _NMOVA +1
      IF M.PAR_TIPFAT <> "AR$"
         REPLACE A_ITL WITH TLIRE(PAR_VALUTA,PAR_FATT,RIBALTA2(PAR_DTFAT))
	  ENDIF
	  REPLACE A_EUR WITH TEURO(PAR_VALUTA,PAR_FATT,RIBALTA2(PAR_DTFAT))
	  _TA_ITL   = _TA_ITL   + A_ITL
	  _TA_EUR   = _TA_EUR   + A_EUR
   ENDIF

   SELECT _EURPART
   SKIP +1

ENDDO

SELECT &_CURSORE
GO TOP

* CREA IL CURSORE CON IL SOLO SALDO ITL/EUR
IF _RAGGR
   SELECT &_CURSORE
   SCATTER MEMVAR MEMO
   CREATE CURSOR &_CURSORE ;
	 	  (INDICE C(13),  NUMPRO C(13),    _XNREG C(08),  DTREG C(10),   TIPODOC C(10), ;
	 	   NUMDOC C(7),   NPROT C(10),     TDOC C(3),     DTDOC C(10),   DTSCAD C(10),  ;
	 	   VALUTA C(3),   CAMBIO N(15,10), D_ITL N(17,3), A_ITL N(17,3), T_ITL N(17,3), ;
	 	   D_EUR N(17,3), A_EUR N(17,3),   T_EUR N(17,3), T_DIF N(17,3), T_NOPART L)
	APPEND BLANK
	GATHER MEMVAR MEMO
    REPLACE T_ITL   WITH  _TD_ITL - _TA_ITL
    REPLACE T_EUR   WITH  _TD_EUR - _TA_EUR
    REPLACE D_ITL   WITH  0
    REPLACE A_ITL   WITH  0
    REPLACE D_EUR   WITH  0
    REPLACE A_EUR   WITH  0
    IF T_EUR <> 0
	    REPLACE T_DIF   WITH  (TEURO("ITL",T_ITL,RIBALTA2(M.PAR_DTFAT)) - T_EUR)  && VERIFICA SE ESISTE DIFFERENZA DI ARROTONDAMENTO TRA IL TOTALE LIRE ED IL TOTALE EURO CALCOLATI
	ELSE
	    REPLACE T_DIF   WITH  0
	ENDIF

*!*	    2005-09-10
*!*	    SERGIO : IN UN CASO SPECIFICO IL CALCOLO IN EURO E' PERFETTO MENTRE IL CALCOLO IN LIRE RIPORTA UNA DIFFERENZA DI UNA
*!*	    LIRA E PER QUESTO A QUESTO DA OGGI IN POI CESSA LA GESTIONE DEL CONTROLLO INCROCIATO SULLA QUADRATURA DELLA PARTITA
*!*	    IN LIRE 
*!*	    
*!*	    IF T_ITL <> 0
*!*		    REPLACE T_DIF   WITH  (TLIRE("ITL",T_EUR,RIBALTA2(M.PAR_DTFAT)) - T_ITL)  && VERIFICA SE ESISTE DIFFERENZA DI ARROTONDAMENTO TRA IL TOTALE LIRE ED IL TOTALE EURO CALCOLATI
*!*		ELSE
*!*		    REPLACE T_DIF   WITH  0
*!*		ENDIF
*!*	    

	SCATTER MEMVAR MEMO	
	* CREA IL RECORD DI PER VERIFICA SE LA PARTITA E' GIA' STATA PAREGGIATA
	SELECT PART_EUR
	APPEND BLANK
	GATHER MEMVAR MEMO
	REPLACE CONTO  WITH  _CONTO
	REPLACE NPART  WITH  _PARTITA
ENDIF


* && SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE VERIFICA SE LA PARTITA E' CLASSIFICATA DUBBIA DAL RECUPERO CREDITI

*!*	IF _ESCLUDE_PARTITE_DUBBIE 			&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE
*!*	   IF FLAG_PARTITA_DUBBIA = .T.		&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*		  _PARCLO=.T.					&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*		  RETURN(_PARCLO)				&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*	   ENDIF							&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE	
*!*	ENDIF								&& SERGIO  20/11/2011 - GESTIONE PARTITE DUBBIE



* VERIFICA SE ESISTONO SIA MOVIMENTI DARE CHE AVERE (IN QUESTO CASO LA PARTITA E' SICURAMENTE APERTA)

_PARCLO = .F.           
IF _NMOVD = 0 .OR. _NMOVA = 0
   _PARCLO = .F.         && PARTITA APERTA
   RETURN(_PARCLO)
ENDIF

* VERIFICO SE LA PARTITA E' PAREGGIATA DOPO I CALCOLI E PRIMA DELLA EVENTUALE CREAZIONE DEL RECORD DI ARROTONDAMENTO

SELECT &_CURSORE		&& CARICA M.T_DIF
SCATTER MEMVAR MEMO
IF M.T_EUR = 0
   _PARCLO = .T.        && PARTITA CHIUSA
   RETURN(_PARCLO)
ENDIF

* CREA IL RECORD CON IL VALORE DI DIFFERENZA ARROTONDAMENTO IN EURO PER
IF _DIFFAR
   * -->> SE LA DIFFERENZA E' IN EURO
   * ----------------------------------------
   IF M.T_EUR <> 0
  	  SELECT &_CURSORE		&& CARICA M.T_DIF
	  SCATTER MEMVAR MEMO
      * CREA IL RECORD DI ARROTONDAMENTO EURO SOLAMENTE SE SONO NELLE CONDIZIONI DI CHIUSURA DELLA PARTITA
	  IF !BETW(ABS(T_EUR),-0.02,0.02)
	     _PARCLO = .F.     && PARTITA APERTA
         RETURN(_PARCLO)
      ENDIF
  	  IF M.T_DIF <> 0   .AND. BETW(ABS(M.T_DIF),-0.02,0.02)
	     SELECT _EURPART			&& CARICA LE VARIABILI DALLA FATTURA
		 GO TOP
		 SCATTER MEMVAR MEMO
		 SELECT &_ARCH_IN
		 APPEND BLANK
		 GATHER MEMVAR MEMO
 	     REPLACE PAR_TIPODO  WITH "PAG"
	     REPLACE PAR_NPROG   WITH 990
	     DO CASE
		    CASE _CF = "C"		&& FILTRO CLIENTE
			     REPLACE PAR_TIPFAT  WITH "AR$"
			     REPLACE PAR_TMOV    WITH IIF(M.T_DIF < 0,"A","D")
			CASE _CF = "F"		&& FILTRO FORNITORE
			     REPLACE PAR_TIPFAT  WITH "AR$"
			     REPLACE PAR_TMOV    WITH IIF(M.T_DIF < 0,"A","D")
	     ENDCASE
 	     REPLACE PAR_TOTIM   WITH ABS(M.T_DIF)
	     REPLACE PAR_TIMPOS  WITH 0
	     REPLACE PAR_FATT    WITH ABS(M.T_DIF)
	     REPLACE PAR_CIVA1   WITH "NO"
	     REPLACE PAR_IMPO1   WITH 0
	     REPLACE PAR_IMPOS1  WITH 0
	     REPLACE PAR_TOT1    WITH 0
 	     REPLACE PAR_CIVA2   WITH "NO"
	     REPLACE PAR_IMPO2   WITH 0
	     REPLACE PAR_IMPOS2  WITH 0
	     REPLACE PAR_TOT2    WITH 0
 	     REPLACE PAR_CIVA3   WITH "NO"
	     REPLACE PAR_IMPO3   WITH 0
	     REPLACE PAR_IMPOS3  WITH 0
	     REPLACE PAR_TOT3    WITH 0
	     REPLACE PAR_CIVA4   WITH "NO"
	     REPLACE PAR_IMPO4   WITH 0
	     REPLACE PAR_IMPOS4  WITH 0
	     REPLACE PAR_TOT4    WITH 0
	     REPLACE PAR_CIVA5   WITH "NO"
	     REPLACE PAR_IMPO5   WITH 0
	     REPLACE PAR_IMPOS5  WITH 0
	     REPLACE PAR_TOT5    WITH 0
	     REPLACE PAR_VALUTA  WITH "EUR"
	     REPLACE PAR_IMPVAL  WITH 0
  	     _PARCLO = .T.     && PARTITA CHIUSA
	  ENDIF
   ENDIF
   * -->> SE LA DIFFERENZA E' IN LIRE
   * ----------------------------------------
   IF M.T_ITL <> 0
 	  SELECT &_CURSORE		&& CARICA M.T_DIF
	  SCATTER MEMVAR MEMO
      * CREA IL RECORD DI ARROTONDAMENTO EURO SOLAMENTE SE SONO NELLE CONDIZIONI DI CHIUSURA DELLA PARTITA
	  IF !BETW(ABS(T_ITL),-10,10)
	     _PARCLO = .F.     && PARTITA APERTA
         RETURN(_PARCLO)
      ENDIF
	  IF M.T_DIF <> 0   .AND. BETW(ABS(M.T_DIF),-10,10)
	     SELECT _EURPART			&& CARICA LE VARIABILI DALLA FATTURA
		 GO TOP
		 SCATTER MEMVAR MEMO
		 CSQL = "select * from " + &_ARCH_IN + " where 0=1"
         IF !ExecCommand(CSQL,"part_cli_for")
            return(.f.)
         ENDIF
         SELECT PART_CLI_FOR
		 APPEND BLANK
		 GATHER MEMVAR MEMO
 	     REPLACE PAR_TIPODO  WITH "PAG"
	     REPLACE PAR_NPROG   WITH 990
	     DO CASE
		    CASE _CF = "C"		&& FILTRO CLIENTE
			     REPLACE PAR_TIPFAT  WITH "AR$"
			     REPLACE PAR_TMOV    WITH IIF(M.T_DIF < 0,"A","D")
			CASE _CF = "F"		&& FILTRO FORNITORE
			     REPLACE PAR_TIPFAT  WITH "AR$"
			     REPLACE PAR_TMOV    WITH IIF(M.T_DIF < 0,"A","D")
		 ENDCASE
 	     REPLACE PAR_TOTIM   WITH ABS(M.T_DIF)
	     REPLACE PAR_TIMPOS  WITH 0
	     REPLACE PAR_FATT    WITH ABS(M.T_DIF)
	     REPLACE PAR_CIVA1   WITH "NO"
	     REPLACE PAR_IMPO1   WITH 0
	     REPLACE PAR_IMPOS1  WITH 0
	     REPLACE PAR_TOT1    WITH 0
	     REPLACE PAR_CIVA2   WITH "NO"
	     REPLACE PAR_IMPO2   WITH 0
	     REPLACE PAR_IMPOS2  WITH 0
	     REPLACE PAR_TOT2    WITH 0
	     REPLACE PAR_CIVA3   WITH "NO"
	     REPLACE PAR_IMPO3   WITH 0
	     REPLACE PAR_IMPOS3  WITH 0
	     REPLACE PAR_TOT3    WITH 0
	     REPLACE PAR_CIVA4   WITH "NO"
	     REPLACE PAR_IMPO4   WITH 0
	     REPLACE PAR_IMPOS4  WITH 0
	     REPLACE PAR_TOT4    WITH 0
 	     REPLACE PAR_CIVA5   WITH "NO"
	     REPLACE PAR_IMPO5   WITH 0
	     REPLACE PAR_IMPOS5  WITH 0
	     REPLACE PAR_TOT5    WITH 0
	     REPLACE PAR_VALUTA  WITH "ITL"
	     REPLACE PAR_IMPVAL  WITH 0
         IF !ExecRW('',_ARCH_IN,'I','','PART_CLI_FOR')
            return(.f.)
         ENDIF
	     _PARCLO = .T.     && PARTITA CHIUSA
	ENDIF
  ENDIF
ENDIF

SELECT &_CURSORE

SELECT(AABBSS)
RETURN(_PARCLO)

*************************************************************************
*      ANNULLO PARTITARIO CLIENTI / FORNITORI                           *
*************************************************************************
PROCEDURE REG_ANCLFO


IF COMPENSAZIONE_CLIENTE_FORNITORE 			&& GESTIONE COMPENSAZIONE CLIENTI / FORNITORI
   DO REG_ANCLFO_COMPENSAZIONI
   RETURN
ENDIF


* << ACCESSO PRIMA PARTITARIO CLIENTI,SE NON ESISTE ACCEDO AL PART.FORNITORI

CREATE CURSOR REC_CANCE (REC_NUMPRO C(10))
INDEX ON REC_NUMPRO TAG I_RECANCE ADDITIVE

XXX_TIPODO = SPACE(03)
NUM_TROVATO=.F.

PUB_NPART_GIA_ASSEGNATO_A_FATTURA = 0

IF !ExecCommand("select * from part_cli where 0=1","part_cli")
  return(.f.)
ENDIF
SELECT PART_CLI
AA = AFIELDS(PARTXXX)
CREATE CURSOR _SALPART FROM ARRAY PARTXXX		&& CREA UN CURSORE DINAMICO PER IL SALVATAGGIO PARTITA

x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
x_anno = "par_anno = '" + PUB_ANNO + "'"
x_npro = "par_numpro = '" + ALLTRIM(PUB_REGIN) + "'"
cSql="SELECT * FROM PART_CLI WHERE " + x_soci + " and " + x_anno + " and " + x_npro + ;
                                   " order by par_codsoc,par_anno,par_numpro"
IF !ExecCommand(cSql,"cur_partcli")
   return(.f.)
ENDIF

SELECT CUR_PARTCLI
GO TOP

IF EOF()

   IF !ExecCommand("select * from part_for where 0=1","part_for")
      return(.f.)
   ENDIF

   SELECT PART_FOR
   AA = AFIELDS(PARTXXX)
   CREATE CURSOR _SALPART FROM ARRAY PARTXXX		&& CREA UN CURSORE DINAMICO PER IL SALVATAGGIO PARTITA
   x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
   x_anno = "par_anno = '" + PUB_ANNO + "'"
   x_npro = "par_numpro = '" + ALLTRIM(PUB_REGIN) + "'"
   cSql="SELECT * FROM PART_FOR WHERE " + x_soci + " and " + x_anno + " and " + x_npro + ;
                                      " order by par_codsoc,par_anno,par_numpro"
   IF !ExecCommand(cSql,"cur_partfor")
      return(.f.)
   ENDIF

   SELECT CUR_PARTFOR
   GO TOP
   IF EOF()
   ELSE
      NUM_TROVATO=.T.
      PUB_PCLFO  ="FOR"
      PUB_NPART  = PAR_NPART
      PUB_CODCLI = PAR_CODCLI
      PUB_NPART_GIA_ASSEGNATO_A_FATTURA = PAR_NPART      && NUMERO DI PARTITA ORIGINALE GIA' ASSEGNATA ALLA FATTURA  SE SI TRATTA DI EFFETTI
   ENDIF
ELSE
   NUM_TROVATO=.T.
   PUB_PCLFO  ="CLI"
   PUB_NPART  = PAR_NPART
   PUB_CODCLI = PAR_CODCLI
ENDIF


IF NUM_TROVATO

	   DO WHILE (PAR_NUMPRO=PUB_REGIN) .AND. (!EOF())

	      IF DELETED()
	         SKIP +1
	         LOOP
	      ENDIF

	      IF ALLTRIM(PAR_NUMPRO) <> ALLTRIM(PUB_REGIN)
	         EXIT
	      ENDIF

	      IF PAR_TIPFAT = "AR$"
	         SKIP +1
		     LOOP
		  ENDIF  

	      * SALVATAGGIO DEL TIPO DOCUMENTO IN QUANTO SE VARIO IL DOCUMENTO
	      * E IL DOCUMENTO E' UN PAGAMENTO OR UN INSOLUTO OR UNA NOTA CREDITO
	      * DEVO GESTIRE DURANTE L'AGGIORNAMENTO DEI PARTITARI UN SOLO RECORD
	      * CON PAG/INS/NCR CON LO STESSO NUMERO DI RIGA
	      XXX_TIPODO 	= PAR_TIPODO     && IDENTIFICA PAG/NCR/INS/FAT
	      XXX_NPROG  	= PAR_NPROG      && NUMERO PROGRESSIVO INTERNO
	      XXX_DATPAG 	= PAR_DATPAG     && DATA PAGAMENTO ORIGINALE
	      XXX_NREG   	= PAR_NREG       && NUMERO DI REGISTRAZIONE ORIGINALE
		  XXX_NPART_ 	= PAR_NPART		 && NUMERO DI PARTITA
		  XXX_CODCLI_ 	= PAR_CODCLI	 && CODICE CLIENTE/FORNITORE
	      SCATTER MEMVAR MEMO	
	      XSS=STR(SELECT())

		  SELECT  _SALPART 			  && EFFETTUA IL SALVATAGGIO DELLA PARTITA PRIMA DELLA CANCELLAZIONE 	
	      APPEND BLANK
		  GATHER MEMVAR MEMO

	      SELECT REC_CANCE
	      SET ORDER TO I_RECANCE
	      SEEK M.PAR_NUMPRO
	      IF FOUND()
	      ELSE
	         APPEND BLANK
	         REPLACE REC_NUMPRO WITH M.PAR_NUMPRO
	      ENDIF
		
		  SELECT &XSS
	      DELETE

	      SKIP +1

	   ENDDO



	   **XXSERXX*************************** PEZZO REVISIONATO 11/11/2002 : SERGIO ********************************** INIZIO

	   IF PUB_PCLFO  ="CLI"
	      SELECT REC_CANCE
	      SET ORDER TO I_RECANCE
	      GO TOP
	      DO WHILE .T.
	         IF EOF()
	            EXIT
	         ENDIF
	         M.REC_NUMPRO = REC_NUMPRO
	         CSQL="DELETE FROM PART_CLI WHERE PAR_NUMPRO = ?M.REC_NUMPRO"
	         IF !ExecCommand(CSQL,"")
	            RETURN (.f.)
	         ENDIF 
	         SELECT REC_CANCE
	         SKIP +1
	      ENDDO
	   ENDIF    

	   IF PUB_PCLFO  ="FOR"

	      ** ACCEDE ALLA PARTITA IN BASE A >>>> PUB_NPART <<<<< E SOSTITUISCE 
	      ** PAR_NPART CON IL NUMERO DI PARTITA ORIGINALE PRESO DA INDICE 
	      ** SULLA BASE DI MOV_NUMPRO PRELEVANDO MOV_NPART
		
		  IF PUB_ANNPN=.T.
			  DO RIPORTA_VECCHIO_NUMERO_PARTITA 	WITH PUB_NPART   && CAMBIA IL NUMERO DI PARTITA DEL PAGAMENTO ORIGINALE
		  ENDIF

	      
	      SELECT REC_CANCE
	      SET ORDER TO I_RECANCE
	      GO TOP
	      DO WHILE .T.
	         IF EOF()
	            EXIT
	         ENDIF
	         M.REC_NUMPRO = REC_NUMPRO
	         CSQL="DELETE FROM PART_FOR WHERE PAR_NUMPRO = ?M.REC_NUMPRO"
	         IF !ExecCommand(CSQL,"")
	            RETURN (.f.)
	         ENDIF 
	         SELECT REC_CANCE
	         SKIP +1
	      ENDDO

	      
	   ENDIF    


*!*	2008-05-30 SERGIO/SIMONE - NO SALDI
*!*		   IF PUB_ANNPN			&& NEL CASO DI SOLO ANNULLO DELLA PRIMA NOTA ANNULLA I SALDI DEI PARTITARI
*!*			   IF PUB_PCLFO  ="CLI"
*!*					=CREA_SALDI_CF("C",XXX_CODCLI_,XXX_NPART_,"XXXXXXXXXX","CREA")
*!*		   	   ENDIF	
*!*			   IF PUB_PCLFO  ="FOR"
*!*					=CREA_SALDI_CF("F",XXX_CODCLI_,XXX_NPART_,"XXXXXXXXXX","CREA")
*!*		   	   ENDIF	
*!*		   ENDIF


	   SELECT _SALPART
	   GO TOP



ENDIF

RETURN


*************************************************************************
*      ANNULLO PARTITARIO CLIENTI / FORNITORI PER COMPENSAZIONI         *
*************************************************************************
PROCEDURE REG_ANCLFO_COMPENSAZIONI



* << ACCESSO PRIMA PARTITARIO CLIENTI E POI AL PARTITARIO FORNITORI

CREATE CURSOR REC_CANCE (REC_NUMPRO C(10))
INDEX ON REC_NUMPRO TAG I_RECANCE ADDITIVE

XXX_TIPODO = SPACE(03)
NUM_TROVATO=.F.

PUB_NPART_GIA_ASSEGNATO_A_FATTURA = 0

IF !ExecCommand("select * from part_cli where 0=1","part_cli")
  return(.f.)
ENDIF
SELECT PART_CLI
AA = AFIELDS(PARTXXX)
CREATE CURSOR _SALPART FROM ARRAY PARTXXX		&& CREA UN CURSORE DINAMICO PER IL SALVATAGGIO PARTITA


*!*	LEGGE IL PARTITARIO CLIENTI

x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
x_anno = "par_anno = '" + PUB_ANNO + "'"
x_npro = "par_numpro = '" + ALLTRIM(PUB_REGIN) + "'"
cSql="SELECT * FROM PART_CLI WHERE " + x_soci + " and " + x_anno + " and " + x_npro + ;
                                   " order by par_codsoc,par_anno,par_numpro"
IF !ExecCommand(cSql,"cur_partcli")
   return(.f.)
ENDIF

SELECT CUR_PARTCLI
GO TOP
IF EOF()
    
    NUM_TROVATO			 	= .F.

ELSE
	NUM_TROVATO			 	= .T.
	PUB_PCLFO  				= "CLI"
	PUB_NPART  				= PAR_NPART
	PUB_CODCLI 				= PAR_CODCLI
ENDIF


IF NUM_TROVATO

	   DO WHILE (PAR_NUMPRO=PUB_REGIN) .AND. (!EOF())

	      IF DELETED()
	         SKIP +1
	         LOOP
	      ENDIF

	      IF ALLTRIM(PAR_NUMPRO) <> ALLTRIM(PUB_REGIN)
	         EXIT
	      ENDIF

	      IF PAR_TIPFAT = "AR$"
	         SKIP +1
		     LOOP
		  ENDIF  

	      * SALVATAGGIO DEL TIPO DOCUMENTO IN QUANTO SE VARIO IL DOCUMENTO
	      * E IL DOCUMENTO E' UN PAGAMENTO OR UN INSOLUTO OR UNA NOTA CREDITO
	      * DEVO GESTIRE DURANTE L'AGGIORNAMENTO DEI PARTITARI UN SOLO RECORD
	      * CON PAG/INS/NCR CON LO STESSO NUMERO DI RIGA
	      XXX_TIPODO 	= PAR_TIPODO     && IDENTIFICA PAG/NCR/INS/FAT
	      XXX_NPROG  	= PAR_NPROG      && NUMERO PROGRESSIVO INTERNO
	      XXX_DATPAG 	= PAR_DATPAG     && DATA PAGAMENTO ORIGINALE
	      XXX_NREG   	= PAR_NREG       && NUMERO DI REGISTRAZIONE ORIGINALE
		  XXX_NPART_ 	= PAR_NPART		 && NUMERO DI PARTITA
		  XXX_CODCLI_ 	= PAR_CODCLI	 && CODICE CLIENTE/FORNITORE
	      SCATTER MEMVAR MEMO	
	      XSS=STR(SELECT())

		  SELECT  _SALPART 			  && EFFETTUA IL SALVATAGGIO DELLA PARTITA PRIMA DELLA CANCELLAZIONE 	
	      APPEND BLANK
		  GATHER MEMVAR MEMO

	      SELECT REC_CANCE
	      SET ORDER TO I_RECANCE
	      SEEK M.PAR_NUMPRO
	      IF FOUND()
	      ELSE
	         APPEND BLANK
	         REPLACE REC_NUMPRO WITH M.PAR_NUMPRO
	      ENDIF
		
		  SELECT &XSS
	      DELETE

	      SKIP +1

	   ENDDO



	   **XXSERXX*************************** PEZZO REVISIONATO 11/11/2002 : SERGIO ********************************** INIZIO

	   IF PUB_PCLFO  ="CLI"
	      SELECT REC_CANCE
	      SET ORDER TO I_RECANCE
	      GO TOP
	      DO WHILE .T.
	         IF EOF()
	            EXIT
	         ENDIF
	         M.REC_NUMPRO = REC_NUMPRO
	         CSQL="DELETE FROM PART_CLI WHERE PAR_NUMPRO = ?M.REC_NUMPRO"
	         IF !ExecCommand(CSQL,"")
	            RETURN (.f.)
	         ENDIF 
	         SELECT REC_CANCE
	         SKIP +1
	      ENDDO
	   ENDIF    

*!*	2008-05-30 SERGIO/SIMONE - NO SALDI
*!*		   IF PUB_ANNPN			&& NEL CASO DI SOLO ANNULLO DELLA PRIMA NOTA ANNULLA I SALDI DEI PARTITARI
*!*			   IF PUB_PCLFO  ="CLI"
*!*					=CREA_SALDI_CF("C",XXX_CODCLI_,"000000","XXXXXXXXXX","CREACF")   && RICREA SALDI SU TUTTO IL CLIENTE
*!*		   	   ENDIF	
*!*		   ENDIF


	   SELECT _SALPART
	   GO TOP



ENDIF


*!*	RESET CURSORI ___________________________________________________________________

CREATE CURSOR REC_CANCE (REC_NUMPRO C(10))
INDEX ON REC_NUMPRO TAG I_RECANCE ADDITIVE

IF !ExecCommand("select * from part_cli where 0=1","part_cli")
  return(.f.)
ENDIF
SELECT PART_CLI
AA = AFIELDS(PARTXXX)
CREATE CURSOR _SALPART FROM ARRAY PARTXXX		&& CREA UN CURSORE DINAMICO PER IL SALVATAGGIO PARTITA



*!*	LEGGE IL PARTITARIO FORNITORI

   IF !ExecCommand("select * from part_for where 0=1","part_for")
      return(.f.)
   ENDIF

   SELECT PART_FOR
   AA = AFIELDS(PARTXXX)
   CREATE CURSOR _SALPART FROM ARRAY PARTXXX		&& CREA UN CURSORE DINAMICO PER IL SALVATAGGIO PARTITA
   x_soci = "par_codsoc = '" + PUB_CODSOC + "'"
   x_anno = "par_anno = '" + PUB_ANNO + "'"
   x_npro = "par_numpro = '" + ALLTRIM(PUB_REGIN) + "'"
   cSql="SELECT * FROM PART_FOR WHERE " + x_soci + " and " + x_anno + " and " + x_npro + ;
                                      " order by par_codsoc,par_anno,par_numpro"
   IF !ExecCommand(cSql,"cur_partfor")
      return(.f.)
   ENDIF

   SELECT CUR_PARTFOR
   GO TOP
   IF EOF()
   
      NUM_TROVATO			 	= .F.

   ELSE
      NUM_TROVATO				= .T.
      PUB_PCLFO  				= "FOR"
      PUB_NPART  				= PAR_NPART
      PUB_CODCLI 				= PAR_CODCLI
      PUB_NPART_GIA_ASSEGNATO_A_FATTURA = PAR_NPART      && NUMERO DI PARTITA ORIGINALE GIA' ASSEGNATA ALLA FATTURA  SE SI TRATTA DI EFFETTI
   ENDIF


   IF NUM_TROVATO

	   DO WHILE (PAR_NUMPRO=PUB_REGIN) .AND. (!EOF())

	      IF DELETED()
	         SKIP +1
	         LOOP
	      ENDIF

	      IF ALLTRIM(PAR_NUMPRO) <> ALLTRIM(PUB_REGIN)
	         EXIT
	      ENDIF

	      IF PAR_TIPFAT = "AR$"
	         SKIP +1
		     LOOP
		  ENDIF  

	      * SALVATAGGIO DEL TIPO DOCUMENTO IN QUANTO SE VARIO IL DOCUMENTO
	      * E IL DOCUMENTO E' UN PAGAMENTO OR UN INSOLUTO OR UNA NOTA CREDITO
	      * DEVO GESTIRE DURANTE L'AGGIORNAMENTO DEI PARTITARI UN SOLO RECORD
	      * CON PAG/INS/NCR CON LO STESSO NUMERO DI RIGA
	      XXX_TIPODO 	= PAR_TIPODO     && IDENTIFICA PAG/NCR/INS/FAT
	      XXX_NPROG  	= PAR_NPROG      && NUMERO PROGRESSIVO INTERNO
	      XXX_DATPAG 	= PAR_DATPAG     && DATA PAGAMENTO ORIGINALE
	      XXX_NREG   	= PAR_NREG       && NUMERO DI REGISTRAZIONE ORIGINALE
		  XXX_NPART_ 	= PAR_NPART		 && NUMERO DI PARTITA
		  XXX_CODCLI_ 	= PAR_CODCLI	 && CODICE CLIENTE/FORNITORE
	      SCATTER MEMVAR MEMO	
	      XSS=STR(SELECT())

		  SELECT  _SALPART 			  && EFFETTUA IL SALVATAGGIO DELLA PARTITA PRIMA DELLA CANCELLAZIONE 	
	      APPEND BLANK
		  GATHER MEMVAR MEMO

	      SELECT REC_CANCE
	      SET ORDER TO I_RECANCE
	      SEEK M.PAR_NUMPRO
	      IF FOUND()
	      ELSE
	         APPEND BLANK
	         REPLACE REC_NUMPRO WITH M.PAR_NUMPRO
	      ENDIF
		
		  SELECT &XSS
	      DELETE

	      SKIP +1

	   ENDDO



	   **XXSERXX*************************** PEZZO REVISIONATO 11/11/2002 : SERGIO ********************************** INIZIO

	   IF PUB_PCLFO  ="FOR"

	      ** ACCEDE ALLA PARTITA IN BASE A >>>> PUB_NPART <<<<< E SOSTITUISCE 
	      ** PAR_NPART CON IL NUMERO DI PARTITA ORIGINALE PRESO DA INDICE 
	      ** SULLA BASE DI MOV_NUMPRO PRELEVANDO MOV_NPART
		
		  IF PUB_ANNPN=.T.
			  DO RIPORTA_VECCHIO_NUMERO_PARTITA 	WITH PUB_NPART   && CAMBIA IL NUMERO DI PARTITA DEL PAGAMENTO ORIGINALE
		  ENDIF

	      
	      SELECT REC_CANCE
	      SET ORDER TO I_RECANCE
	      GO TOP
	      DO WHILE .T.
	         IF EOF()
	            EXIT
	         ENDIF
	         M.REC_NUMPRO = REC_NUMPRO
	         CSQL="DELETE FROM PART_FOR WHERE PAR_NUMPRO = ?M.REC_NUMPRO"
	         IF !ExecCommand(CSQL,"")
	            RETURN (.f.)
	         ENDIF 
	         SELECT REC_CANCE
	         SKIP +1
	      ENDDO

	      
	   ENDIF    

*!*	2008-05-30 SERGIO/SIMONE - NO SALDI
*!*		   IF PUB_ANNPN			&& NEL CASO DI SOLO ANNULLO DELLA PRIMA NOTA ANNULLA I SALDI DEI PARTITARI
*!*			   IF PUB_PCLFO  ="FOR"
*!*					=CREA_SALDI_CF("F",XXX_CODCLI_,"000000","XXXXXXXXXX","CREACF")    && RICREA SALDI SU TUTTO IL FORNITORE
*!*		   	   ENDIF	
*!*		   ENDIF


	   SELECT _SALPART
	   GO TOP



   ENDIF




RETURN


***********************************************
* AGG. NUMERO DI PARTITA CLIENTE 		      *
***********************************************
PROCEDURE REG_NUMPAC
***********************************************


IF PUB_VARPN			&& SOLO SE STO REGISTRANDO UN PAGAMENTO ANTICIPATO FORNITORE : CANT = "F"
	RETURN
ENDIF


v_seek	  = 'NUMPRC'+PUB_CODSOC
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
   V_LIB1		= 1
   CS_LIB1      = STR(V_LIB1)
   PUB_NPARF    = VAL(CS_LIB1)
   APPEND BLANK
   REPLACE CODICE WITH 'NUMPRC'+PUB_CODSOC
   REPLACE DESCRI WITH "N.PARTITA CLIENTE/FORNITORE"
   REPLACE LIBERA WITH ALLTRIM(CS_LIB1)
ELSE
   C_LIB1	= SUBSTR(LIBERA,1,10)
   V_LIB1 	= VAL(C_LIB1)
   V_LIB1 	= V_LIB1+1
   CS_LIB1   = STR(V_LIB1)
   PUB_NPARF = VAL(CS_LIB1)
   REPLACE LIBERA  WITH ALLTRIM(CS_LIB1)
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN

***********************************************
* AGG. NUMERO DI PARTITA FORNITORE 		      *
***********************************************
PROCEDURE REG_NUMPRF
***********************************************


IF PUB_VARPN			&& SOLO SE STO REGISTRANDO UN PAGAMENTO ANTICIPATO FORNITORE : CANT = "F"
	RETURN
ENDIF

v_seek	  = 'NUMPRC'+PUB_CODSOC
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
   V_LIB1		= 1
   CS_LIB1      = STR(V_LIB1)
   PUB_NPARF    = VAL(CS_LIB1)
   APPEND BLANK
   REPLACE CODICE WITH 'NUMPRC'+PUB_CODSOC
   REPLACE DESCRI WITH "N.PARTITA FORNITORE"
   REPLACE LIBERA WITH ALLTRIM(CS_LIB1)
ELSE
   C_LIB1	= SUBSTR(LIBERA,1,10)
   V_LIB1 	= VAL(C_LIB1)
   V_LIB1 	= V_LIB1+1
   CS_LIB1   = STR(V_LIB1)
   PUB_NPARF = VAL(CS_LIB1)
   REPLACE LIBERA  WITH ALLTRIM(CS_LIB1)
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN



**SERGIO INIZIO 07/08/2004
*********************************************************************************************
* SEEK_PARA()	funzione per la gestione della tabella PARA
*********************************************************************************************
* La funzione restituisce dalla tabella PARA, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_para
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore,_FASCIACOMPETENZA
IF PARAMETERS() < 5
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF PARAMETERS() <= 6
	_FASCIACOMPETENZA = "ALL"
ENDIF

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_para"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_tiporec+_chiave+"'"
_seek1= "'"+_tiporec+ALLTRIM(_chiave)+"%'"

IF _FASCIACOMPETENZA = 'ALL'
ELSE
   _seek = _SEEK + " AND SUBSTRING(LIBERA,42,1) = '" + ALLTRIM(_FASCIACOMPETENZA) + "'"
   _seek1 = _SEEK1 + " AND SUBSTRING(LIBERA,42,1) = '" + ALLTRIM(_FASCIACOMPETENZA) + "'"
ENDIF   

cSql 	= "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4 FROM para where codice = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4 FROM para where codice like "+_seek1+" order by "+_ordinamento

IF !ExecCommand(Csql_1,"xxx_para")
   return(.f.)
ENDIF
SELECT XXX_PARA
GO TOP


IF EOF()
   _seek1 = "codice like '" + _tiporec + "%'"
   _seek2 = "descri like '" + ALLTRIM(_chiave) + "%'"
   IF _FASCIACOMPETENZA = 'ALL'
      _seek4 = _seek1 + " and " + _seek2
   ELSE
      _seek3 = "SUBSTRING(LIBERA,42,1) = '" + ALLTRIM(_FASCIACOMPETENZA) + "'"
     _seek4 = _seek1 + " and " + _seek2 + " and " + _seek3
   ENDIF   
   cSql_1 = "SELECT SUBSTRING(CODICE,"+_lunghezza+") AS CODICE, DESCRI, LIBERA, CONIVA, CONTO1, CONTO2, CONTO3, CONTO4 FROM para where " + _seek4 + " order by "+_ordinamento
ENDIF

PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione;Libera"
PUB_VISTA  = "CODICE;DESCRI;LIBERA"
PUB_RIT    = _ritorno

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\elenco_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri ecash"
ELSE
   DO Form FORM\elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco parametri"
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)
**SERGIO FINE 07/08/2004






************************************************************************
FUNCTION GET_DES
************************************************************************
* RESTITUISCE LA DESCRIZIONE DEL PARAMERTO (PRESENTE IN PARA.DBF)
* IMPOSTATO IN INGRESSO
*
* SINTASSI:
*
* DESCRIZIONE=GET_DES("TOP","VEN")
*
* ? DESCRIZIONE ----->  CONTIENE "FATTURA DI VENDITA"
*
* FABIANO... 12/10/1999
************************************************************************
PARAMETERS _GD_TIPO,_GD_CODICE

_GD_SEL=SELECT()

_GD_DESCRI=""

IF EMPTY(_GD_TIPO)
  WAIT WINDOW "!!! ATTENZIONE !!! FUNZIONE - GET_DES"+CHR(13)+"DESCRIZIONE NON VALORIZZATA: MANCA IL TIPO DI PARAMETRO"
  SELECT(_GD_SEL)
  RETURN(_GD_DESCRI)
ENDIF

IF EMPTY(_GD_CODICE)
  SELECT(_GD_SEL)
  RETURN(_GD_DESCRI)
ENDIF

IF !ExecCommand("select * from para where codice = ?_GD_TIPO+?_GD_CODICE","para")
   return
ENDIF
SELECT PARA
IF reccount() = 0
  _GD_DESCRI="Parametro inesistente"
ELSE
  _GD_DESCRI=ALLTRIM(DESCRI)
ENDIF

SELECT(_GD_SEL)

RETURN(_GD_DESCRI)

***********************************************************************
* Procedura - PLAYWAV    Data: 10.12.95   Autore: Project
***********************************************************************
* Suona un file in formato .Wav
* ATTENZIONE! : L'utilizzo di questa procedura modifica l'impostazione
* di SET BEL TO è quindi necessario reimpostarne il valore dopo l'esecuzione.
* Tale limitazione è dovuta all'impossibilità di FoxPro di ritornare
* l'impostazione corrente di SET BEL TO !!!
***********************************************************************
PROCEDURE PLAYWAV
*****************

PARA _NOMEFILE

*!*	SET BELL TO (_NOMEFILE), 0
*!*	?? CHR(7)

**=> ERASMO - INIZIO 26/10/2009
*** FUNZIONE ALTERNATIVA PER EVITARE IL PROBLEMA DELLA 
*** VISUALIZZAZIONE ANOMALA IMMAGINI NEI COMMANDBUTTON
IF FILE(_NOMEFILE)
   #DEFINE SND_SYNC 0
   #DEFINE SND_ASYNC 1
   #DEFINE SND_NODEFAULT 2
   #DEFINE SND_MEMORY 4
   #DEFINE SND_LOOP 8
   #DEFINE SND_NOSTOP 16
   DECLARE INTEGER sndPlaySound IN winmm STRING lpszSound, INTEGER fuSound
   = sndPlaySound(_NOMEFILE,SND_ASYNC + SND_NODEFAULT)
ENDIF
**=> ERASMO - FINE 26/10/2009

RETURN

*******************************************************************************
FUNCTION CHECKNUM
*******************************************************************************
* Sintassi:  CHECKNUM(<valore>,<cifre totali campo>,<cifre decimali campo>)
* 
* Ritorna:   boolean (.T./.F.)
* 
* Controlla che il numero <valore> sia contenuto 
* nella dimensione massima accettata da un campo in
* tabella caratterizzato dalla dimensione 
* Numeric (<cifre totali campo>,<cifre decimali campo>)
*
* - Ritorna .T. se il numero e' contenibile in tabella in quel campo
* - Ritorna .F. se il numero e' piu' grande del range corrispondente alla
*     dimensione impostata
*
* Esempio:
*
* IF !CHECKNUM(M.ORD_VALORE,17,3)
*    RETURN(.F.)
* ENDIF
*
*******************************************************************************
PARAMETERS 	_P_VALORE_DA_CONTROLLARE,;
			_P_CIFRE_TOTALI_CAMPO,;
			_P_CIFRE_DECIMALI_CAMPO

LOCAL _VALORE_DA_CONTROLLARE,;
	  _CIFRE_TOTALI_CAMPO,;
	  _CIFRE_DECIMALI_CAMPO,;
	  _CIFRA_SALVAGENTE			&& CONTROLLA IL NUMERO MASSIMO DI CIFRE
	  
IF PCOUNT() <3
	WAIT WINDOW "FUNCTION CHECKNUM: INSERIRE OBBLIGATORIAMENTE TUTTI I PARAMETRI"
	RETURN(.F.)
ENDIF

_VALORE_DA_CONTROLLARE=ABS(_P_VALORE_DA_CONTROLLARE)
_CIFRE_TOTALI_CAMPO	  =_P_CIFRE_TOTALI_CAMPO
_CIFRE_DECIMALI_CAMPO =_P_CIFRE_DECIMALI_CAMPO

IF _CIFRE_DECIMALI_CAMPO =0
  _CIFRA_SALVAGENTE	  =1
ELSE
  _CIFRA_SALVAGENTE	  =2
ENDIF

IF ABS(_VALORE_DA_CONTROLLARE)>VAL(REPLICATE('9',_CIFRE_TOTALI_CAMPO-_CIFRE_DECIMALI_CAMPO-_CIFRA_SALVAGENTE))
	MESSAGEBOX("Valore "+ALLTRIM(STR(_VALORE_DA_CONTROLLARE))+" troppo elevato."+CHR(13)+;
				"Verificare quantita' ed importi",48,"Attenzione!")
	RETURN(.F.)

ELSE
	RETURN(.T.)
ENDIF

* FINE FUNCTION CHECKNUM
******************************

******************************
FUNCTION _LISTFO
******************************
PARA _CODCLI,_CODART,_DATLIS,_ALLIST

IF SUBSTR(_DATLIS,3,1) = '/'
   _DATLIS = RIBALTA2(_DATLIS)
ENDIF
IF SUBSTR(_ALLIST,3,1) = '/'
   _ALLIST = RIBALTA2(_ALLIST)
ENDIF



**1)--ACCESSO AL LISTINO DI BASE PER TUTTI I FORNITORI
SS=STR(SELECT())
OK_ESISTE = .F.

_CODCLI__ = ''		&& TUTTI I FORNITORI

x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_clie = "lis_codcli = '" + ALLTRIM(_CODCLI__) + "'"
x_arti = "lis_codart = '" + ALLTRIM(_codart) + "'"
x_cond = x_soci + " and " + x_clie + " and " + x_arti
Csql   = "select * from u_lif_tt where " + x_cond + " order by lis_codsoc,lis_codcli,lis_codart"
IF !ExecCommand(cSql,"u_lif_tt")
   return(.f.)
ENDIF
SELECT U_LIF_TT
GO TOP


DO WHILE .T.

   IF EOF()
      EXIT
   ENDIF
   
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF


   IF _DATLIS >= LIS_DATLIS .AND. _DATLIS <= LIS_ALLIST
   ELSE
      SKIP +1
      LOOP
   ENDIF
   
   

   OK_ESISTE = .T.
   PUB_PREZZO = LIS_PREZZO
   PUB_SC1    = LIS_SC1
   PUB_SC2    = LIS_SC2
   PUB_SC3    = LIS_SC3

   EXIT

ENDDO



**2)--ACCESSO AL LISTINO DEL FORNITORE PERSONALIZZATO
SS=STR(SELECT())


x_soci = "lis_codsoc = '" + PUB_CODSOC + "'"
x_clie = "lis_codcli = '" + ALLTRIM(_codcli) + "'"
x_arti = "lis_codart = '" + ALLTRIM(_codart) + "'"
x_cond = x_soci + " and " + x_clie + " and " + x_arti
Csql   = "select * from u_lif_tt where " + x_cond + " order by lis_codsoc,lis_codcli,lis_codart"
IF !ExecCommand(cSql,"u_lif_tt")
   return(.f.)
ENDIF
SELECT U_LIF_TT
GO TOP
IF !EOF()

	OK_ESISTE = .F.

	DO WHILE .T.

	   IF EOF()
	      EXIT
	   ENDIF
	   
	   IF DELETED()
	      SKIP +1
	      LOOP
	   ENDIF


	   IF _DATLIS >= LIS_DATLIS .AND. _DATLIS <= LIS_ALLIST
	   ELSE
	      SKIP +1
	      LOOP
	   ENDIF
	   
	   
	 
	   OK_ESISTE = .T.
	   PUB_PREZZO = LIS_PREZZO
	   PUB_SC1    = LIS_SC1
	   PUB_SC2    = LIS_SC2
	   PUB_SC3    = LIS_SC3

	   EXIT

	ENDDO
ENDIF

SELECT &SS
RETURN(OK_ESISTE)



*!*	***********************************************************************************
FUNCTION AQUAREP_TOP
*!*	***********************************************************************************
*!*	**
*!*	** RICERCA LE VARIABILI LEGATE AL TIPO OPERAZIONE
*!*	**
*!*	**
PARAMETERS _TOP


RELEASE SWWS
PUBLIC  SWWS
SWWS=SELECT()

_TOP = seek_para('TOP',ALLTRIM(_TOP),'CODICE','CODICE',"4,3")
DES   = ""
IF EMPTY(_TOP)
   =MESSAGEB("Codice Top obbligatorio",64,"*** ATTENZIONE ***")
   **THISFORM.REFRESH
   SELECT(SWWS)
   RETURN 
ENDIF

SELECT _pj_para
_TOP      			= UPPER(_TOP)
**CGE_TOPX  		= _TOP
CONIVAX   			= CONIVA  
TCOD01    			= CONTO1
TCOD02    			= CONTO2
TCOD03    			= CONTO3
TCOD04   			= CONTO4
DES       			= DESCRI     
TP        			= SUBSTR(LIBERA,1,1)
FATTURA   			= SUBSTR(LIBERA,2,1)
VER_CONTO 			= SUBSTR(LIBERA,12,1)
NATURA    			= TP
NO_AUT	  			= SUBSTR(LIBERA,16,1)
PR_NO	  			= SUBSTR(LIBERA,17,1)
PR_SI	  			= SUBSTR(LIBERA,18,1)
PR_TOP	  			= SUBSTR(LIBERA,19,1)
PR_ANA	  			= SUBSTR(LIBERA,20,1)
PR_LIS    			= SUBSTR(LIBERA,21,1)
PR_LAN    			= SUBSTR(LIBERA,22,1)
__CEE     			= SUBSTR(LIBERA,23,1)
IL_CCO    			= SUBSTR(LIBERA,31,1)
IN_CCO    			= SUBSTR(LIBERA,32,1)
TPROC     			= SUBSTR(LIBERA,38,3)
AGGANCIAPARTITARI 	= SUBSTR(LIBERA,44,1)

PR_ANA1   = .F.
PR_TOP1   = .F.


SELECT(SWWS)

RETURN



*************************************************************************
*   AGGIORNAMENTO DEI D.BASE CONTI/MOV_CONT/PART_CLI/PART_FOR           *
*************************************************************************
FUNCTION AQUAREP_AGGDBA

SET EXACT ON

   XDESF   = ""

   v_seek   = 'TOP'+CGE_TOPX
   v_chiave = "codice"
   IF seek_std('PARA',v_seek,v_chiave,'CUR_PARA')
      SELECT CUR_PARA
      TI_TOP  =SUBSTR(LIBERA,2,1)
	  __CONTO =SUBSTR(LIBERA,12,1)
      IL_CCO  =SUBSTR(LIBERA,31,1)
      IN_CCO  =SUBSTR(LIBERA,32,1)
   ELSE
      TI_TOP  =SPACE(1)
	  __CONTO =SPACE(1)
      IL_CCO  =SPACE(1)
      IN_CCO  =SPACE(1)
   ENDIF

   IF TI_TOP = "S" .OR. TI_TOP = "C" && SOLO SE FATTURA/CORRISPETTIVI GESTISCE IVA
   ELSE
      IV  = 'NO'
   ENDIF


   	CGE_TOTDOCU=CGE_DA+CGE_AV

    IF ALLTRIM(_INDICE) = "CARICA"
	   	=AQUAREP_INDICE()              	&& CREA INDICE
	ENDIF
	
	=AQUAREP_CERCA_CLI_FOR()			&& CERCA I DATI DEL CLIENTE/FORNITORE
   	=AQUAREP_MOV_CONT()              	&& CREA MOV_CONT
   	=AQUAREP_CONTI()  	            	&& OGGI CONTI

    IF TI_TOP = "S" .OR. TI_TOP = "C"   && SOLO SE FATTURA/CORRISPETTIVI GESTISCE IVA
      =AQUAREP_AGGIVA()                 && AGGIORNAMENTO CONTI IVA AUTOMATICI
    ENDIF


    =AQUAREP_PARTIT()      				&& CREA I PARTITARI ED I SALDI PARTITE


*!*	    IF IL_CCO = 'S' .OR. IN_CCO = 'S'
*!*	       DO REG_CCOSTI   && AGGIORNAMENTO CENTRI DI COSTO ILLIMITATI  (MINERVA)
*!*	    ELSE
*!*	       DO REG_CCOSTO   && AGGIORNAMENTO CENTRI DI COSTO (MAX 10)
*!*	    ENDIF





RETURN

*************************************************************************
*                    			CREA INDICE     					    *
*************************************************************************
FUNCTION AQUAREP_INDICE



      IF !ExecCommand("select * from indice where 0=1","cur_indice")
         return(.f.)
      ENDIF

      SELECT CUR_INDICE
      APPEND BLANK

      REPLACE MOV_SOC    			WITH PUB_CODSOC
      REPLACE MOV_ANNO   			WITH PUB_ANNO
      REPLACE MOV_DTREG  			WITH RIBALTA2(CGE_DATAREG)
      REPLACE MOV_NREGIS 			WITH ALLTRIM(CGE_NREG)
      REPLACE MOV_DTDOC  			WITH RIBALTA2(CGE_DATADOC)
      REPLACE MOV_NDOC   			WITH CGE_NDOC
      REPLACE MOV_TOP    			WITH CGE_TOPX
      REPLACE MOV_NPROT  			WITH ALLTRIM(CGE_NPROT)
      REPLACE MOV_CONTO  			WITH CGE_CON
      REPLACE MOV_IVA    			WITH CGE_IV
      REPLACE MOV_IMPOST 			WITH CGE_IMP
      REPLACE MOV_DESMOV 			WITH CGE_COMM
      REPLACE MOV_DESMO1 			WITH CGE_COM1
      REPLACE MOV_NUMPRO 			WITH ALLTRIM(CGE_PN_C)
      REPLACE MOV_IMP    			WITH CGE_TOTDOCU
      REPLACE MOV_NOTE   			WITH CGE_XNOTE
      REPLACE MOV_FATRI  			WITH CGE_FR        && FATTURE FORNITORI IN RITARDO
      REPLACE MOV_PESO      		WITH CGE_PESO
      REPLACE MOV_NPART     		WITH CGE_NPARF
      REPLACE MOV_TISPE  			WITH CGE_TISPE
      REPLACE MOV_PORTO  			WITH CGE_PORTO
      REPLACE MOV_CLDOG  			WITH CGE_CLDOG
      REPLACE MOV_BANCA  			WITH CGE_BANCA
      REPLACE MOV_DATSCAD   		WITH RIBALTA2(CGE_DATASCAD)
      REPLACE MOV_MODPAG    		WITH CGE_CPA
      REPLACE MOV_BOLLATOIVA    	WITH CGE_BOLLATOIVA

	  REPLACE MOV_COSATRATTA 		WITH CGE_COSATRATTA
	  REPLACE MOV_GRADOIMPORTANZA 	WITH CGE_GRADOIMPORTANZA
	  REPLACE MOV_FORMAPAGAMENTO 	WITH CGE_FORMAPAGAMENTO
	  REPLACE MOV_TIPOCONTRATTO 	WITH CGE_TIPOCONTRATTO
	  REPLACE MOV_CODACQ			WITH CGE_CODACQ
	  REPLACE MOV_PRIPAGA			WITH CGE_PRIPAGA

		
      * --------  Gestione contabilità previsionale -------- *
	  IF ALLTRIM(PUB_TIPOGE) = "PREVISIONALE"
	      REPLACE MOV_CONTABILITA_PREVISIONALE    WITH "P"
      ELSE
	      REPLACE MOV_CONTABILITA_PREVISIONALE    WITH " "
	  ENDIF
      * --------  Gestione contabilità previsionale -------- *

      * --------  Blocca / sblocca registrazione previsionale -------- *
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIEFFETTIVA"
	      REPLACE MOV_CONTABILITA_PREVISIONALE    WITH " "
	  ENDIF
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIPREVISIONALE"
	      REPLACE MOV_CONTABILITA_PREVISIONALE    WITH "P"
	  ENDIF
      * --------  Blocca / sblocca registrazione previsionale -------- *


      * ------- MAX Nuovi Campi Per Euro ------- *
      REPLACE MOV_CAMBIO WITH CGE_XCAMBIO
      REPLACE MOV_VALUTA WITH CGE_XVALUTA
      REPLACE MOV_DTVAL  WITH RIBALTA2(CGE_XDATAVAL)
      * ------- MAX Nuovi Campi Per Euro ------- *
      IF CGE_DA <> 0
         REPLACE MOV_TMOV   WITH "D"
      ELSE
         REPLACE MOV_TMOV   WITH "A"
      ENDIF
      REPLACE MOV_ANOMAX WITH CGE_XANOMAX
      REPLACE MOV_CODCCO WITH CGE_CECO


	  IF CGE_DATES  = "DA-TES"						&& REGISTRAZIONE CREATA DALLA TESORERIA
	      REPLACE MOV_DATES WITH CGE_DATES
	  ELSE
	      REPLACE MOV_DATES WITH SPACE(06)	         
      ENDIF
      
 
     
      IF !ExecRW('','indice','I','','CUR_INDICE')
         return(.f.)
      ENDIF



RETURN


*************************************************************************
*                  	CERCA DATI CLIENTE/FORNITORE     					*
*************************************************************************
FUNCTION AQUAREP_CERCA_CLI_FOR


   IF VER_CONTO = "F"
      x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "for_codcli = '" + SUBSTR(CGE_CON,PUB_SOTTOG,PUB_CONTO) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
      IF !ExecCommand(cSql,"cur_fornitore")
         return(.f.)
      ENDIF
      SELECT cur_fornitore
      GO TOP
      IF EOF()
      ELSE
         XDESF=ALLTRIM(FOR_RAGSOC)
      ENDIF
   ENDIF

   IF VER_CONTO = "C"
      x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
      x_codi = "cli_codcli = '" + SUBSTR(CGE_CON,PUB_SOTTOG,PUB_CONTO) + "'"
      x_cond = x_soci + " and " + x_codi
      Csql   = "select * from u_cli_an where " + x_cond + " order by cli_codsoc,cli_codcli"
      IF !ExecCommand(cSql,"cur_cliente")
         return(.f.)
      ENDIF
      SELECT cur_cliente
      GO TOP
      IF EOF()
      ELSE
         XDESF=ALLTRIM(CLI_RAGSOC)
      ENDIF
   ENDIF



RETURN



*************************************************************************
*                    			CREA MOV_CONT     					    *
*************************************************************************
FUNCTION AQUAREP_MOV_CONT


   X_CONTOP = SPACE(13)

   IF !ExecCommand("select * from mov_cont where 0=1","cur_movcont")
      return(.f.)
   ENDIF

   SELECT CUR_MOVCONT
   APPEND BLANK

   REPLACE MOV_SEQUEN 								WITH CGE_SEQUEN
   REPLACE MOV_SOC    								WITH PUB_CODSOC
   REPLACE MOV_ANNO   								WITH PUB_ANNO
   REPLACE MOV_DTREG  								WITH RIBALTA2(CGE_DATAREG)
   REPLACE MOV_NREGIS 								WITH ALLTRIM(CGE_NREG)
   REPLACE MOV_DTDOC  								WITH RIBALTA2(CGE_DATADOC)
   REPLACE MOV_ANNODO 								WITH SUBSTR(MOV_DTDOC,1,4)   
   REPLACE MOV_NDOC   								WITH CGE_NDOC
   REPLACE MOV_TOP    								WITH CGE_TOPX
   REPLACE MOV_NPROT  								WITH ALLTRIM(CGE_NPROT)
   REPLACE MOV_CONTO  								WITH CGE_CON
   REPLACE MOV_IVA    								WITH CGE_IV
   REPLACE MOV_IMPOST 								WITH CGE_IMP
   IF EMPTY(CGE_COMM)
      REPLACE MOV_DESMOV 							WITH XDESF
   ELSE
      REPLACE MOV_DESMOV 							WITH CGE_COMM
   ENDIF
   REPLACE MOV_DESMO1 								WITH CGE_COM1
   REPLACE MOV_NUMPRO 								WITH ALLTRIM(CGE_PN_C)
   REPLACE MOV_IMP    								WITH (CGE_DA+CGE_AV)
   REPLACE MOV_NOTE   								WITH CGE_XNOTE
   REPLACE MOV_CCLI   								WITH CGE_XCCLI
   REPLACE MOV_CFOR   								WITH CGE_XCFOR
   REPLACE MOV_CCO    								WITH CGE_CECOS
   REPLACE MOV_CEE    								WITH CGE_WCCAGE
   X_CONTOP = ALLTRIM(STR(RECNO()))               	&& GESTIONE PER AGGANCIO CENTRI DI COSTO IN VARIAZIONE
   REPLACE MOV_CONTOP 								WITH X_CONTOP
   **REPLACE MOV_IMPORT 							WITH M.SOLOIVA   		&& GESTIONE REGISTRAZIONI CONTABILI DI SOLO IVA
   REPLACE MOV_FATRI  								WITH CGE_FR       			&& FATTURE FORNITORI IN RITARDO
   REPLACE MOV_PESO     							WITH CGE_PESO
   REPLACE MOV_NPART    							WITH CGE_NPARF
   REPLACE MOV_TISPE  								WITH CGE_TISPE
   REPLACE MOV_PORTO  								WITH CGE_PORTO
   REPLACE MOV_CLDOG  								WITH CGE_CLDOG
   REPLACE MOV_BANCA  								WITH CGE_BANCA
   REPLACE MOV_DATSCAD  							WITH RIBALTA2(CGE_DATASCAD)
   REPLACE MOV_MODPAG   							WITH CGE_CPA
   REPLACE MOV_BOLLATOIVA    						WITH CGE_BOLLATOIVA   

*!*	      REPLACE MOV_EXTRA_NUMDOC WITH M.EXTRA_NUMDOC
*!*	      REPLACE MOV_EXTRA_DATDOC WITH M.EXTRA_DATDOC
*!*	      REPLACE MOV_EXTRA_IMPDOC WITH M.EXTRA_IMPDOC
*!*	      REPLACE MOV_EXTRA_SYSDOC WITH M.EXTRA_SYSDOC


   REPLACE MOV_COSATRATTA 							WITH CGE_COSATRATTA
   REPLACE MOV_GRADOIMPORTANZA 						WITH CGE_GRADOIMPORTANZA
   REPLACE MOV_FORMAPAGAMENTO 						WITH CGE_FORMAPAGAMENTO
   REPLACE MOV_TIPOCONTRATTO 						WITH CGE_TIPOCONTRATTO
   REPLACE MOV_CODACQ								WITH CGE_CODACQ
   REPLACE MOV_PRIPAGA								WITH CGE_PRIPAGA

   REPLACE MOV_PUBBLI								WITH CGE_MPUBBLI
   
      * --------  Gestione contabilità previsionale -------- *
	  IF ALLTRIM(PUB_TIPOGE) = "PREVISIONALE"
	      REPLACE MOV_CONTABILITA_PREVISIONALE    	WITH "P"
      ELSE
	      REPLACE MOV_CONTABILITA_PREVISIONALE    	WITH " "
	  ENDIF
      * --------  Gestione contabilità previsionale -------- *

      * --------  Blocca / sblocca registrazione previsionale -------- *
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIEFFETTIVA"
	      REPLACE MOV_CONTABILITA_PREVISIONALE    	WITH " "
	  ENDIF
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIPREVISIONALE"
	      REPLACE MOV_CONTABILITA_PREVISIONALE    	WITH "P"
	  ENDIF
      * --------  Blocca / sblocca registrazione previsionale -------- *

   
   * ------- MAX Nuovi Campi Per Euro ------- *
   **REPLACE MOV_DTVAL  	WITH CGE_XDATAVAL
   =CAMBIADT(CGE_XDATAVAL,"MOV_DTVAL")
   REPLACE MOV_VALUTA 	WITH CGE_XVALUTA
   REPLACE MOV_CAMBIO 	WITH CGE_XCAMBIO
   * ------- MAX Nuovi Campi Per Euro ------- *
   IF CGE_DA <> 0
      REPLACE MOV_TMOV  WITH "D"
   ELSE
      REPLACE MOV_TMOV   WITH "A"
   ENDIF

   *** Fabiano 10/04/2005 - gestione data valuta
   **REPLACE MOV_DTPAG    WITH RIBALTA2(CGE_DTPAG)
   =CAMBIADT(CGE_DTPAG,"MOV_DTPAG")

   
   IF !ExecRW('','mov_cont','I','','CUR_MOVCONT')
      return(.f.)
   ENDIF


RETURN




*************************************************************************
*                    		AGGIORNA CONTI	     					    *
*************************************************************************
FUNCTION AQUAREP_CONTI



   x_soci = "con_soc = '" + PUB_CODSOC + "'"
   x_anno = "con_anno = '" + PUB_ANNO + "'"
   x_annp = "con_anno = '" + PUB_ANNOP + "'"
   x_cont = "con_conto = '" + ALLTRIM(CGE_CON) + "'"
   x_cond = x_soci + " and " + x_anno + " and " + x_cont
   x_conp = x_soci + " and " + x_annp + " and " + x_cont

   IF CGE_TOPX = "CHI"
      Csql  = "select * from conti where " + x_conp + " order by con_soc,con_anno,con_conto"
   ELSE
      Csql  = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
   ENDIF

   IF !ExecRW(cSql,"CONTI","R")
      return(.f.)
   ENDIF
   SELECT CONTI

   IF RECCOUNT() = 0
      PUB_ERRORE=MESSAGEBOX('Conto inesistente'+CHR(13)+"durante l'aggiornamento",64,'*** ATTENZIONE ***')
      RETURN
   ELSE
 
          
			  IF ALLTRIM(PUB_TIPOGE) = "PREVISIONALE"

				      P_IMPA= PRE_IMP_A
				      P_IMPD= PRE_IMP_D
				      IF CGE_TOPX = "CHI"
				         MESE    = "12"
				      ELSE
				         MESE    = SUBSTR(CGE_DATAREG,4,2)
				      ENDIF
				      VAR     = "PRE_AV"+MESE
				      VAR2    = "PRE_DA"+MESE
				      CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
					  * CHI_EUR_ITL
					  IF CGE_TOPX = "CHI"
					     REPLACE   PRE_IMP_D   WITH P_IMPD+CAMBIO(PUB_VALPRE,CGE_DA,PUB_CAMPRE)
				         REPLACE   PRE_IMP_A   WITH P_IMPA+CAMBIO(PUB_VALPRE,CGE_AV,PUB_CAMPRE)
				         REPLACE   &VAR2       WITH CAMBIO(PUB_VALPRE,CGE_DA,PUB_CAMPRE)+&VAR2
				    	 REPLACE   &VAR        WITH CAMBIO(PUB_VALPRE,CGE_AV,PUB_CAMPRE)+&VAR
					  ELSE	
					     REPLACE   PRE_IMP_D   WITH P_IMPD+CAMBIO(CGE_XVALUTA,CGE_DA,CGE_XCAMBIO)
				         REPLACE   PRE_IMP_A   WITH P_IMPA+CAMBIO(CGE_XVALUTA,CGE_AV,CGE_XCAMBIO)
				         REPLACE   &VAR2       WITH CAMBIO(CGE_XVALUTA,CGE_DA,CGE_XCAMBIO)+&VAR2
				    	 REPLACE   &VAR        WITH CAMBIO(CGE_XVALUTA,CGE_AV,CGE_XCAMBIO)+&VAR
					  ENDIF

			  ELSE	

				      P_IMPA= CON_IMP_A
				      P_IMPD= CON_IMP_D
				      IF CGE_TOPX = "CHI"
				         MESE    = "12"
				      ELSE
				         MESE    = SUBSTR(CGE_DATAREG,4,2)
				      ENDIF
				      VAR     = "CON_AV"+MESE
				      VAR2    = "CON_DA"+MESE
				      CLI_FOR = SUBSTR(CON_TIPOCO,1,1)
					  * CHI_EUR_ITL
					  IF CGE_TOPX = "CHI"
					     REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(PUB_VALPRE,CGE_DA,PUB_CAMPRE)
				         REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(PUB_VALPRE,CGE_AV,PUB_CAMPRE)
				         REPLACE   &VAR2       WITH CAMBIO(PUB_VALPRE,CGE_DA,PUB_CAMPRE)+&VAR2
				    	 REPLACE   &VAR        WITH CAMBIO(PUB_VALPRE,CGE_AV,PUB_CAMPRE)+&VAR
					  ELSE	
					     REPLACE   CON_IMP_D   WITH P_IMPD+CAMBIO(CGE_XVALUTA,CGE_DA,CGE_XCAMBIO)
				         REPLACE   CON_IMP_A   WITH P_IMPA+CAMBIO(CGE_XVALUTA,CGE_AV,CGE_XCAMBIO)
				         REPLACE   &VAR2       WITH CAMBIO(CGE_XVALUTA,CGE_DA,CGE_XCAMBIO)+&VAR2
				    	 REPLACE   &VAR        WITH CAMBIO(CGE_XVALUTA,CGE_AV,CGE_XCAMBIO)+&VAR
					  ENDIF

			  ENDIF


   ENDIF

   IF !ExecRW(cSql,"CONTI","W")
      return(.f.)
   ENDIF



RETURN


*************************************************************************
*   AGGIORNAMENTO DEI D.BASECONTI/MOV_CONT A FRONTE DI IVA              *
*************************************************************************
FUNCTION AQUAREP_AGGIVA

* AGGIORNA IL CONTO IVA SE ESISTE IVA
*  - ACCEDO AL PARAMETRO IVA PER PRELEVARE IL CONTO IVA
*  - CREO MOV_CONT CON IL CONTO TROVATO SU TAB_LIBERA
*  - AGGIORNO IL D.B. CONTI CON IL CONTO TROVATO

IF CGE_IV  = 'NO'  && NON GESTISCE IVA
   RETURN
ENDIF


v_seek   = 'IVA'+ALLTRIM(CGE_IV)
v_chiave = "codice"

IF seek_std('PARA',v_seek,v_chiave,'CUR_PARA')
   
   SELECT CUR_PARA
   IF VER_CONTO = "C"
      CONTO_IVA=SUBSTR(LIBERA,5,13)                && CONTO IVA CLIENTI
   ELSE
      IF VER_CONTO = "F"
         CONTO_IVA=SUBSTR(LIBERA,20,20)            && CONTO IVA FORNITORI
      ELSE
         WAIT WINDOW "TOP ne cliente ne fornitore"
         CONTO_IVA=SUBSTR(LIBERA,5,13)             && CONTO IVA CLIENTI
      ENDIF
   ENDIF


   IF !ExecCommand("select * from mov_cont where 0=1","cur_movcont")
      return(.f.)
   ENDIF
   
   
   SELECT CUR_MOVCONT
   APPEND  BLANK
   
   CGE_SEQUEN = CGE_SEQUEN + 10
   REPLACE MOV_SEQUEN 								WITH CGE_SEQUEN
   REPLACE MOV_SOC    								WITH PUB_CODSOC
   REPLACE MOV_ANNO   								WITH PUB_ANNO
   REPLACE MOV_DTREG  								WITH RIBALTA2(CGE_DATAREG)
   REPLACE MOV_NREGIS 								WITH ALLTRIM(CGE_NREG)
   REPLACE MOV_DTDOC  								WITH RIBALTA2(CGE_DATADOC)
   REPLACE MOV_ANNODO 								WITH SUBSTR(MOV_DTDOC,1,4)   &&  23/04/2003
   REPLACE MOV_NDOC   								WITH CGE_NDOC
   REPLACE MOV_TOP    								WITH CGE_TOPX
   REPLACE MOV_NPROT  								WITH ALLTRIM(CGE_NPROT)
   REPLACE MOV_CONTO  								WITH ALLTRIM(CONTO_IVA)
   REPLACE MOV_IVA    								WITH CGE_IV
   REPLACE MOV_IMPOST 								WITH 0
   IF !EMPTY(XDESF)
      REPLACE MOV_DESMOV 							WITH XDESF
   ELSE
      REPLACE MOV_DESMOV 							WITH CGE_COMM
   ENDIF
   REPLACE MOV_NPART  								WITH CGE_NPARF
   REPLACE MOV_DESMO1	 							WITH CGE_COM1
   REPLACE MOV_NUMPRO 								WITH ALLTRIM(CGE_PN_C)
   REPLACE MOV_IMP    								WITH CGE_IMP
   REPLACE MOV_FATRI  								WITH CGE_FR        && FATTURE FORNITORI IN RITARDO
   REPLACE MOV_BOLLATOIVA    						WITH CGE_BOLLATOIVA

*!*	      REPLACE MOV_EXTRA_NUMDOC WITH M.EXTRA_NUMDOC
*!*	      REPLACE MOV_EXTRA_DATDOC WITH M.EXTRA_DATDOC
*!*	      REPLACE MOV_EXTRA_IMPDOC WITH M.EXTRA_IMPDOC
*!*	      REPLACE MOV_EXTRA_SYSDOC WITH M.EXTRA_SYSDOC


   REPLACE MOV_COSATRATTA 							WITH CGE_COSATRATTA
   REPLACE MOV_GRADOIMPORTANZA 						WITH CGE_GRADOIMPORTANZA
   REPLACE MOV_FORMAPAGAMENTO 						WITH CGE_FORMAPAGAMENTO
   REPLACE MOV_TIPOCONTRATTO 						WITH CGE_TIPOCONTRATTO
   REPLACE MOV_CODACQ								WITH CGE_CODACQ
   REPLACE MOV_PRIPAGA								WITH CGE_PRIPAGA

   REPLACE MOV_PUBBLI								WITH CGE_MPUBBLI

   REPLACE MOV_BANCA  								WITH CGE_BANCA
   REPLACE MOV_DATSCAD  							WITH RIBALTA2(CGE_DATASCAD)
   REPLACE MOV_MODPAG   							WITH CGE_CPA


      * --------  Gestione contabilità previsionale -------- *
	  IF ALLTRIM(PUB_TIPOGE) = "PREVISIONALE"
	      REPLACE MOV_CONTABILITA_PREVISIONALE    	WITH "P"
      ELSE
	      REPLACE MOV_CONTABILITA_PREVISIONALE    	WITH " "
	  ENDIF
      * --------  Gestione contabilità previsionale -------- *

      * --------  Blocca / sblocca registrazione previsionale -------- *
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIEFFETTIVA"
	      REPLACE MOV_CONTABILITA_PREVISIONALE    	WITH " "
	  ENDIF
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIPREVISIONALE"
	      REPLACE MOV_CONTABILITA_PREVISIONALE    	WITH "P"
	  ENDIF
      * --------  Blocca / sblocca registrazione previsionale -------- *


   * ------- MAX Nuovi Campi Per Euro ------- *
   REPLACE MOV_DTVAL  WITH RIBALTA2(CGE_XDATAVAL)
   REPLACE MOV_CAMBIO WITH CGE_XCAMBIO
   REPLACE MOV_VALUTA WITH CGE_XVALUTA
   * ------- MAX Nuovi Campi Per Euro ------- *
   IF CGE_DA <> 0
      REPLACE MOV_TMOV   WITH "D"
   ELSE
      REPLACE MOV_TMOV   WITH "A"
   ENDIF

   IF !ExecRW('','mov_cont','I','','CUR_MOVCONT')
      return(.f.)
   ENDIF

ELSE
   PUB_ERRORE=MESSAGEBOX('Errore nella ricerca'+CHR(13)+'del conto IVA',64,'*** ATTENZIONE ***')
   RETURN
ENDIF

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_cont = "con_conto = '" + ALLTRIM(CONTO_IVA) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
IF !ExecRW(cSql,"CONTI","R")
   return(.f.)
ENDIF

SELECT CONTI
IF RECCOUNT() = 0
   PUB_ERRORE=MESSAGEBOX('Conto IVA inesistente'+CHR(13)+'in parametro IVA',64,'*** ATTENZIONE ***')
ELSE

   IF CGE_TOPX = "CHI"
      MESE    = "12"
   ELSE
      MESE    = SUBSTR(CGE_DATAREG,4,2)
   ENDIF

   VAR     = "CON_AV"+MESE
   VAR2    = "CON_DA"+MESE
   
   IF CGE_DA <> 0
      REPLACE CON_IMP_D   WITH CON_IMP_D+CAMBIO(CGE_XVALUTA,CGE_IMP,CGE_XCAMBIO)
      REPLACE &VAR2       WITH CAMBIO(CGE_XVALUTA,CGE_IMP,CGE_XCAMBIO)+&VAR2       && VAR2 = DARE
   ELSE
      REPLACE CON_IMP_A   WITH CON_IMP_A+CAMBIO(CGE_XVALUTA,CGE_IMP,CGE_XCAMBIO)
      REPLACE &VAR        WITH &VAR+CAMBIO(CGE_XVALUTA,CGE_IMP,CGE_XCAMBIO)        && VAR = AVERE
   ENDIF
ENDIF
IF !ExecRW(cSql,"CONTI","W")
   return(.f.)
ENDIF

RETURN


*************************************************************************
*   					CREA PARTITARI E SALDI PARTITE             		*
*************************************************************************
FUNCTION AQUAREP_PARTIT

x_soci = "con_soc = '" + PUB_CODSOC + "'"
x_anno = "con_anno = '" + PUB_ANNO + "'"
x_annp = "con_anno = '" + PUB_ANNOP + "'"
x_cont = "con_conto = '" + ALLTRIM(CGE_CON) + "'"
x_cond = x_soci + " and " + x_anno + " and " + x_cont
x_conp = x_soci + " and " + x_annp + " and " + x_cont
IF M.TOP = "CHI"
   Csql   = "select * from conti where " + x_conp + " order by con_soc,con_anno,con_conto"
ELSE
   Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
ENDIF
IF !ExecCommand(cSql,"cur_conti")
   return(.f.)
ENDIF
SELECT cur_conti
GO TOP
IF EOF()
   PUB_ERRORE=MESSAGEBOX('Conto inesistente durante'+CHR(13)+"l'aggiornamento partitario",64,'*** ATTENZIONE ***')
   RETURN
ENDIF
CLI_FOR = SUBSTR(CON_TIPOCO,1,1)


IF CLI_FOR='C'
   =AQUAREP_PARCLI()         && AGGIORNA PARTITARIO CLIENTI
ENDIF

IF CLI_FOR='F'
   =AQUAREP_PARFOR()         && AGGIORNA PARTITARIO FORNITORI
ENDIF

RETURN



*************************************************************************
*   			CREA PARTITARI E SALDI PARTITE FORNITORI           		*
*************************************************************************
FUNCTION AQUAREP_PARFOR



x_soci = "for_codsoc = '" + PUB_CODSOC + "'"
x_codi = "for_codcli = '" + SUBSTR(CGE_CON,PUB_SOTTOG,PUB_CONTO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from u_for_an where " + x_cond + " order by for_codsoc,for_codcli"
IF !ExecCommand(cSql,"cur_fornitori")
   return(.f.)
ENDIF

RELEASE V_DESCRIC
PUBLIC V_DESCRIC


SELECT cur_fornitori
GO TOP
IF EOF()
   V_DESCRIC = SPACE(15)
   V_TELEFO  = SPACE(15)
   V_PARIVA  = SPACE(11)
   V_CONPAG  = PUB_CPA 
ELSE
   V_DESCRIC = FOR_RAGSOC
   V_TELEFO  = FOR_TELEFO
   V_PARIVA  = FOR_PARIVA
   V_CONPAG  = FOR_CONPAG
ENDIF

IF !ExecCommand("select * from part_for where 0=1","cur_partfor")
   return(.f.)
ENDIF


SELECT CUR_PARTFOR
APPEND BLANK
REC_PART=RECNO()


REPLACE PAR_CODSOC  WITH PUB_CODSOC
REPLACE PAR_ANNO    WITH PUB_ANNO
REPLACE PAR_TIPODO  WITH "FAT"

IF FATTURA='P'
   REPLACE PAR_TIPODO  WITH "PAG"
ENDIF

IF FATTURA='I'
   REPLACE PAR_TIPODO  WITH "INS"
ENDIF

IF FATTURA='N'
   REPLACE PAR_TIPODO  WITH "NCR"
ENDIF

											
IF FATTURA='A'
   REPLACE PAR_TIPODO  			WITH "PAG"
   REPLACE PAR_NPARTO           WITH CGE_NPARF  && CONSIDERA COME NUMERO DI PARTITA ETERNO
ENDIF

REPLACE PAR_CODCLI  WITH CGE_CON
REPLACE PAR_RAGSOC  WITH V_DESCRIC
REPLACE PAR_DTREG   WITH RIBALTA2(CGE_DATAREG)
REPLACE PAR_DTFAT   WITH RIBALTA2(CGE_DATADOC)
REPLACE PAR_TIPFAT  WITH CGE_TOPX
REPLACE PAR_TOTIM   WITH (CGE_TOTDOCU-CGE_IMP+CGE_KABBUO)        && SOMMA EVENTUALE ABBUONO
REPLACE PAR_TIMPOS  WITH CGE_IMP
REPLACE PAR_FATT    WITH CGE_TOTDOCU+CGE_KABBUO                                    && SOMMA EVENTUALE ABBUONO
REPLACE PAR_NUMFAT  WITH CGE_NDOC

* --------  Gestione contabilità previsionale -------- *
 IF ALLTRIM(PUB_TIPOGE) = "PREVISIONALE"
   REPLACE PAR_CONTABILITA_PREVISIONALE    WITH "P"
 ELSE
   REPLACE PAR_CONTABILITA_PREVISIONALE    WITH " "
 ENDIF
* --------  Gestione contabilità previsionale -------- *

      * --------  Blocca / sblocca registrazione previsionale -------- *
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIEFFETTIVA"
	      REPLACE PAR_CONTABILITA_PREVISIONALE    WITH " "
	  ENDIF
	  IF PUB_BLOCCA_SBLOCCA_PREVISIONALE="SIPREVISIONALE"
	      REPLACE PAR_CONTABILITA_PREVISIONALE    WITH "P"
	  ENDIF
      * --------  Blocca / sblocca registrazione previsionale -------- *

* --------  Classifica la partita -------- *
REPLACE PAR_COSATRATTA 		WITH CGE_COSATRATTA
REPLACE PAR_GRADOIMPORTANZA WITH CGE_GRADOIMPORTANZA
REPLACE PAR_FORMAPAGAMENTO 	WITH CGE_FORMAPAGAMENTO
REPLACE PAR_TIPOCONTRATTO 	WITH CGE_TIPOCONTRATTO
REPLACE PAR_CODACQ			WITH CGE_CODACQ
REPLACE PAR_PRIPAGA			WITH CGE_PRIPAGA
* --------  Classifica la partita -------- *

* ---------  Controllo ddt/fatture -------- *
REPLACE PAR_ANOMAX			WITH CGE_XANOMAX    
* ---------  Controllo ddt/fatture -------- *


* ------- MAX Nuovi Campi Per Euro ------- *
REPLACE PAR_CAMBIO WITH CGE_XCAMBIO
REPLACE PAR_VALUTA WITH CGE_XVALUTA
*REPLACE PAR_DTVAL  WITH CGE_XDATAVAL
=CAMBIADT(CGE_XDATAVAL,"PAR_DTVAL")


* ------- MAX Nuovi Campi Per Euro ------- *
REPLACE PAR_BANCA   WITH CGE_BANCA
IF EMPTY(TOP_COL)
   REPLACE PAR_NPROG   WITH 100
ELSE
   REPLACE PAR_NPROG   WITH 900
ENDIF
IF PAR_TIPODO <> "FAT"  && GESTIONE INSERIMENTO DA PRIMA NOTA
   REPLACE PAR_NPROG   WITH 900
ENDIF
IF __CONTO ='I'   && APERTURA DI BILANCIO PER CLIENTI FORNITORI
   REPLACE PAR_TIPODO  WITH "PAG"
   REPLACE PAR_NPROG   WITH 900
ENDIF 


REPLACE PAR_NPART   WITH CGE_NPARF       && CONSIDERA COME NUMERO DI PARTITA ETERNO
REPLACE PAR_CODPAG  WITH V_CONPAG
REPLACE PAR_TEL     WITH V_TELEFO
REPLACE PAR_IVA     WITH V_PARIVA
REPLACE PAR_NREG    WITH ALLTRIM(CGE_NREG)
REPLACE PAR_NUMPRO  WITH ALLTRIM(CGE_PN_C)
REPLACE PAR_CIVA1   WITH CGE_IV
REPLACE PAR_IMPO1   WITH (CGE_TOTDOCU-CGE_IMP+CGE_KABBUO)
REPLACE PAR_IMPOS1  WITH CGE_IMP
REPLACE PAR_TOT1    WITH CGE_TOTDOCU+CGE_KABBUO
REPLACE PAR_TOTIM   WITH (CGE_TOTDOCU-CGE_IMP+CGE_KABBUO)
REPLACE PAR_TIMPOS  WITH CGE_IMP
REPLACE PAR_FATT    WITH CGE_TOTDOCU+CGE_KABBUO
REPLACE PAR_DESMOV  WITH CGE_COMM
REPLACE PAR_DESMO1  WITH CGE_COM1
REPLACE PAR_FATRI   WITH CGE_FR        && FATTURE FORNITORI IN RITARDO


IF CGE_DA<>0
   REPLACE PAR_TMOV WITH "D"
ENDIF
IF CGE_AV<>0
   REPLACE PAR_TMOV WITH "A"
ENDIF

IF FATTURA='P' .OR.  FATTURA='I'  .OR. CGE_AGGANCIAPARTITARI = 'S'          && GESTISCO UNA SECONDA REPLACE A QUESTO PUNTO
   REPLACE PAR_TOTIM   WITH CGE_DA+CGE_AV+KABBUO                            && SOMMA EVENTUALE ABBUONO
   REPLACE PAR_TIMPOS  WITH 0
   REPLACE PAR_FATT    WITH CGE_DA+CGE_AV+KABBUO                            && SOMMA EVENTUALE ABBUONO
   REPLACE PAR_IMPO1   WITH 0
   REPLACE PAR_IMPOS1  WITH 0
   REPLACE PAR_TOT1    WITH 0
   REPLACE PAR_NPROG   WITH 900
ENDIF

DATA_SCAD=SPACE(10)
=AQUAREP_SCADF()      && GESTIONE SCADENZIARIO FORNITORI SOLO SE FATTURE / EFFETTI


SELECT CUR_PARTFOR
GO TOP

XYZ_CONTO   = PAR_CODCLI	 && CODICE DEL FORNITORE
XYZ_PARTITA = PAR_NPART	 	 && PARTITA FORNITORE

IF !EMPTY(CGE_DATASCAD)
	REPLACE PAR_DTSCAD  		 WITH RIBALTA2(CGE_DATASCAD)
ELSE
	REPLACE PAR_DTSCAD  		 WITH RIBALTA2(DATA_SCAD)
ENDIF


*** Fabiano 14/04/2005 - GESTIONE PAR_DATPAG
IF EMPTY(CGE_DTPAG)
	*REPLACE PAR_DATPAG WITH RIBALTA2(PAR_DTSCAD) 
    =CAMBIADT(PAR_DATPAG,"PAR_DATPAG")
ELSE
	*REPLACE PAR_DATPAG WITH RIBALTA2(CGE_DTPAG)
    =CAMBIADT(CGE_DTPAG,"PAR_DATPAG")
ENDIF



IF !ExecRW('','part_for','I','','CUR_PARTFOR')
   return(.f.)
ENDIF


*!*	2008-05-30 SERGIO/SIMONE - NO SALDI
*!*	=CREA_SALDI_CF("F",XYZ_CONTO,XYZ_PARTITA,"XXXXXXXXXX","CREA")


RETURN

*************************************************************************
*   PRELEVA NUMERO PARTITA DEL CLIENTE                                  *
*************************************************************************
FUNCTION AQUAREP_NPART


   SAVE_NPART=SELECT()
   RELEASE _NUMPARK 
   PUBLIC  _NUMPARK 
   _NUMPARK = SPACE(06)
   v_seek	 = 'NUMPRC'+PUB_CODSOC
   v_chiave  = "codice"
   cSql      = "select * from para where " + v_chiave + " = '" + v_seek + "'"
   IF !ExecRW(cSql,"PARA","R")
      return(.f.)
   ENDIF
   SELECT PARA
   IF RECCOUNT() = 0
	  _NUMPARK = "    "
   ELSE
      V2=VAL(SUBSTR(LIBERA,1,7)) + 1
      REPLACE LIBERA WITH SUBSTR(STR(V2,7,0),1,7)
      _NUMPARK  = ALLTRIM(SUBSTR(STR(V2,7,0),1,7))
   ENDIF
   IF !ExecRW(cSql,"PARA","W")
      return(.f.)
   ENDIF
   SELECT(SAVE_NPART)

   PUB_NPARF  =VAL(_NUMPARK)

RETURN


*************************************************************************
*   PRELEVA NUMERO PARTITA DEL CLIENTE                                  *
*************************************************************************
FUNCTION AQUAREP_NUMREG

v_seek	  = 'NUMREG'+PUB_ANNO+PUB_CODSOC
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
   T_NUM     = 1
   TC_NUM    = STR(T_NUM)
   APPEND BLANK
   REPLACE CODICE WITH 'NUMREG'+PUB_ANNO+PUB_CODSOC
   REPLACE DESCRI WITH "N.REGISTRAZIONE UTENTE"
   REPLACE LIBERA WITH ALLTRIM(TC_NUM)
   CGE_NREG      = TC_NUM
ELSE
   C_NUM  = SUBSTR(LIBERA,1,10)
   V_NUM  = VAL(C_NUM)
   T_NUM  = V_NUM+1
   TC_NUM = STR(T_NUM)
   REPLACE LIBERA WITH ALLTRIM(TC_NUM)
   CGE_NREG      = TC_NUM
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN


***********************************************
* AGG. NUMERO DI REGISTRAZIONE  INTERNO DI PN *
***********************************************
PROCEDURE REG_NUMRPN

v_seek	  = 'NUMREGPN'+PUB_CODSOC
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
   APPEND BLANK
   PN        = 1
   PN_C      = sys(2015)    &&   STR(PN)
   NUMEROINT = PN_C
   REPLACE CODICE WITH 'NUMREGPN'+PUB_CODSOC
   REPLACE DESCRI WITH "N.REG.INTERNO PN"
   REPLACE LIBERA WITH ALLTRIM(PN_C)
ELSE
   PN        = VAL(SUBSTR(LIBERA,1,10))
   PN        = PN + 1
   PN_C      = STR(PN)
   NUMEROINT = PN_C
   PN_C      = SYS(2015)
   NUMEROINT = PN_C
ENDIF

PUB_NUOVO_NUMPRO_ASSEGNATO = PN_C

IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN


***********************************************
* AGG. NUMERO DI PROTOCOLLO FORNITORE         *
***********************************************
PROCEDURE REG_NUMPRO
***********************************************

IF VER_CONTO <> "F"		&& SOLO FORNITORI
   RETURN
ENDIF

IF FATTURA <> "S"		&& NON GESTISCE TOP DIVERSI DA FATTURA
   RETURN
ENDIF

V_TIPREG = ""

IF !ExecCommand("select * from u_azi_pa","cu_azi_pa")
   return(.f.)
ENDIF
SELECT CU_AZI_PA
GO TOP
IF EOF()
ELSE
   IF AZI_NRSEBF				&& gestione della numerazione separata protocollo fornitori
      v_seek	= 'TOP'+ALLTRIM(M.TOP) 
      v_chiave = "codice"
      IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
         SELECT CUR_PARA
         CEE   = SUBSTR(LIBERA,23,1)
      ELSE
         CEE    = SPACE(1)
      ENDIF
      
      IF CEE = "E"
         v_tipreg = '2'         && registro bollati fornitori abituali cee
      ELSE
         v_tipreg = '1'         && registro bollati fornitori nazionali
      ENDIF
   
*!*	      IF PUB_CESCOM				&& REGISTRO IVA CESSIONI COMPENSATIVE ATTIVATO !!!!
*!*		      IF CEE = "R"
*!*		         v_tipreg = '4'     && REGISTRO IVA CESSIONI COMPENSATIVE
*!*			  ENDIF
*!*	      ENDIF


   ENDIF
   
   *** SIMONE 07/03/2011 - INIZIO
   SELECT CU_AZI_PA
   IF AZI_NRSENO				&& gestione della numerazione separata protocollo PER NOTE OCCASIONALI
      v_seek	= 'TOP'+ALLTRIM(M.TOP)
      v_chiave = "codice"
      IF seek_std('para',v_seek,v_chiave,'CUR_PARA')
         SELECT CUR_PARA
         NOC   = SUBSTR(LIBERA,23,1)
      ELSE
         NOC   = SPACE(1)
      ENDIF
      IF NOC = "N"
         v_tipreg = '3'         && registro bollati fornitori NOTE OCCASIONALI
      ENDIF
   ENDIF
   *** SIMONE 07/03/2011 - FINE
   
ENDIF

v_chiave  = "codice"
v_seek    = 'NUMPRO'+PUB_ANNO+PUB_CODSOC+ALLTRIM(V_TIPREG)
cSql      = "select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
   SAVE_NP    = NPROT
   V_LIB      = 1
   CS_LIB     = STR(V_LIB)
   NPROT      = CS_LIB
   X_NPROT    = NPROT
   APPEND BLANK
   REPLACE CODICE WITH V_SEEK
   IF EMPTY(ALLTRIM(V_TIPREG))
      REPLACE DESCRI WITH "N.PROTOCOLLO FORNITORE UNICO"
   ELSE
      IF V_TIPREG = '1'
         REPLACE DESCRI WITH "N.PROTOCOLLO FORNITORE NAZIONALE"
      ENDIF
      IF V_TIPREG = '2'
         REPLACE DESCRI WITH "N.PROTOCOLLO FORNITORE ABITUALE CEE"
      ENDIF
      *** SIMONE 07/03/2011 - INIZIO
      IF V_TIPREG = '3'
         REPLACE DESCRI WITH "N.PROTOCOLLO FORNITORE NOTE OCCASIONALI"
      ENDIF
      *** SIMONE 07/03/2011 - INIZIO
*!*	      IF V_TIPREG = '4'
*!*	         REPLACE DESCRI WITH "N.REGISTRO IVA CESSIONI COMPENSATIVE"
*!*	      ENDIF
   ENDIF
   REPLACE LIBERA WITH ALLTRIM(CS_LIB)
ELSE
   C_LIB   = SUBSTR(LIBERA,1,10)
   V_LIB   = VAL(C_LIB)
   V_LIB   = V_LIB+1
   CS_LIB  = STR(V_LIB)
   SAVE_NP = NPROT
   NPROT   = CS_LIB
   X_NPROT = NPROT
   REPLACE LIBERA  WITH ALLTRIM(CS_LIB)
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN


***********************************************
* AGG. NUMERO DI PARTITA FORNITORE 		      *
***********************************************
PROCEDURE REG_NUMPRC
***********************************************


IF VER_CONTO <> "F"		&& SOLO FORNITORI
   RETURN
ENDIF

IF FATTURA = "S" .OR. FATTURA = "A"		&& FATTURE E DOCUMENTI EXTRA CONTABILI COME EFFETTI
ELSE
   RETURN
ENDIF

v_seek	  = 'NUMPRC'+PUB_CODSOC
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
   V_LIB1		= 1
   CS_LIB1      = STR(V_LIB1)
   PUB_NPARF    = VAL(CS_LIB1)
   APPEND BLANK
   REPLACE CODICE WITH 'NUMPRC'+PUB_CODSOC
   REPLACE DESCRI WITH "N.PARTITA FORNITORE"
   REPLACE LIBERA WITH ALLTRIM(CS_LIB1)
ELSE
   C_LIB1	= SUBSTR(LIBERA,1,10)
   V_LIB1 	= VAL(C_LIB1)
   V_LIB1 	= V_LIB1+1
   CS_LIB1   = STR(V_LIB1)
   PUB_NPARF = VAL(CS_LIB1)
   REPLACE LIBERA  WITH ALLTRIM(CS_LIB1)
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN

***********************************************
* AGG. NUMERO DI PARTITA FORNITORE 		      *
***********************************************
PROCEDURE REG_NUMPRF
***********************************************


IF PUB_VARPN			&& SOLO SE STO REGISTRANDO UN PAGAMENTO ANTICIPATO FORNITORE : CANT = "F"
	RETURN
ENDIF

v_seek	  = 'NUMPRC'+PUB_CODSOC
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecRW(cSql,"PARA","R")
   return(.f.)
ENDIF
SELECT PARA
IF RECCOUNT() = 0
   V_LIB1		= 1
   CS_LIB1      = STR(V_LIB1)
   PUB_NPARF    = VAL(CS_LIB1)
   APPEND BLANK
   REPLACE CODICE WITH 'NUMPRC'+PUB_CODSOC
   REPLACE DESCRI WITH "N.PARTITA FORNITORE"
   REPLACE LIBERA WITH ALLTRIM(CS_LIB1)
ELSE
   C_LIB1	= SUBSTR(LIBERA,1,10)
   V_LIB1 	= VAL(C_LIB1)
   V_LIB1 	= V_LIB1+1
   CS_LIB1   = STR(V_LIB1)
   PUB_NPARF = VAL(CS_LIB1)
   REPLACE LIBERA  WITH ALLTRIM(CS_LIB1)
ENDIF
IF !ExecRW(cSql,"PARA","W")
   return(.f.)
ENDIF

RETURN



************************
FUNCTION CAMBIADT
************************
PARA _DATA,_NOMEDT

IF _DATA = '  /  /    ' .OR. _DATA = SPACE(10) .OR. ;
   _DATA = '    /  /  ' .OR. EMPTY(_DATA)
   REPLACE &_NOMEDT WITH SPACE(10)
ELSE
   IF SUBSTR(_DATA,3,1) = '/'
      REPLACE &_NOMEDT WITH RIBALTA2(_DATA)
   ELSE
      REPLACE &_NOMEDT WITH _DATA
   ENDIF
ENDIF

RETURN(.T.)



*************************************************************************
*    RIPORTA IL VECCHIO NUMERO DI PARTITA SU ANNULLO REGISTRAZIONE      *
*************************************************************************
* E' IL CASO DI UN ANNULLO DI PRIMA NOTA A FRONTE DI UNA FATTURA CHE
* AGGANCIA UN PAGAMENTO INSERITO PRIMA DELLA FATTURA
*
* ACCEDE ALLA PARTITA IN BASE A >>>> PUB_NPART <<<<< E SOSTITUISCE 
* PAR_NPART CON IL NUMERO DI PARTITA ORIGINALE PRESO DA INDICE 
* SULLA BASE DI MOV_NUMPRO PRELEVANDO MOV_NPART
*

 
PROCEDURE RIPORTA_VECCHIO_NUMERO_PARTITA
PARAMETERS __NPART__

    OK_AGGIORNA_PARTITA = .F.
    AXABBSS    = SELECT()

    ** LEGGE LA PARTITA DAL PARTITARIO FORNITORI PRIMA DELLA CANCELLAZIONE
    x_x_part  = ALLTRIM(STR(__NPART__))
    x_soci    = "par_codsoc = '" + PUB_CODSOC + "'"
    x_anno    = "par_anno = '" + PUB_ANNO + "'"
    x_npro    = "par_npart = '" + x_x_part + "'"
    
    cSql="SELECT * FROM PART_FOR WHERE " + x_soci + " and " + x_anno + " and " + x_npro + ;
                                      " order by par_codsoc,par_anno,par_numpro"

	IF !ExecRW(cSql,"part_for","R")
	   RETURN .F.
	ENDIF
	

	SELECT part_for
	GO TOP
	
	DO WHILE .NOT. EOF()
	
		IF PAR_NPARTO <> 0
			replace par_npart WITH PAR_NPARTO 					&& ATTRIBUISCE IL NUMERO DELLA PARTITA DELLA FATTURA DEL FORNITORE
            OK_AGGIORNA_PARTITA = .T.  
		ENDIF	
		
		SELECT part_for
		SKIP +1

	ENDDO

    IF OK_AGGIORNA_PARTITA 
		SELECT part_for
		GO TOP

		IF !ExecRW('','part_for','W','','part_for')
		   return(.f.)
		ENDIF
	ENDIF

SELECT(AXABBSS)

RETURN



*!*	****************************************************************************
*!*	 Funzione - TRANCHE
*!*	****************************************************************************
*!*	 Sintassi : Variabile =  TRANCHE(Select,ConPag,DtFatt,Vimptot [,Vet_Dal,Vet_Al,Vet_Day])
*!*	 Select   : e' la select di PARA
*!*	 ConPag   : e' il codice della condizione di pagamento 'CPA' in U_SIC_PA
*!*	 DtFatt   : e' la data della fattura nel formato AAAA.MM.GG
*!*	 Vimptot  : e' l'importo totale della fattura
*!*
*!*	 I parametri Vet_Dal,Vet_Al,Vet_Day sono opzionali e servono per il calcolo dei posticipi
*!*	 Vet_Dal  : e' il vettore contenente la data (gg.mm) di partenza del posticipo
*!*	 Vet_Al   : e' il vettore contenente la data (gg.mm) di termine del posticipo
*!*	 Vet_Day  : e' il vettore contenente la data (gg.mm) di posticipo
*!*
*!*	 ATTENZIONE : la funzione e' legata alla funzione GIRA
*!*
*!*	 LA FUNZIONE RITORNA 	:
*!*							:
*!*							: 
*!*	 NUOVA GESTIONE 		:
*!*	 ============== 		:
*!*	 			CU_TRANK 	: un cursore contenente data scadenza+importo+gestione scadenza (RB=RICEVUTA BANCARIA NO=NON GESTISCE LA TRANCHE NELLA PROCEDURA DELLE RIBA (OTTIENE SEMPRE LA VARIABILE V_TUTTO PER LA VECCHIA GESTIONE)
*!*	 		  				:                                                                                                                       =============================================================
*!*	 						:
*!*	 VECCHIA GESTIONE 		:
*!*	 ================		:
*!*							:
*!*	 			V_TUTTO  	: una stringa contenente l'importo delle tranche e di seguito tutte le date di scadenza delle stesse.
*!*	 		  				: l'importo e le date sono separati da uno spazio
*!*	 			COMPENSO 	: la funzione setta una variabile publica COMPENSO che vale la differenza del totale
*!*	 		  				: documento - la somma delle tranche
*!*	 
*!*	 
*!*	 
*!*	 ATTENZIONE !!! : e' necessario il SET della data nel formato tedesco
*!*	 SET DATE GERMAN


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
 
 

RELEASE V_SCAFISS,V_SOLOIMPIVA,V_PERIMPO,V_SCAFISS_1RATA,V_TIPI_TRANCHE       
PUBLIC V_SCAFISS,V_SOLOIMPIVA,V_PERIMPO,V_SCAFISS_1RATA,V_TIPI_TRANCHE       
V_SCAFISS 	 		= 0    	&& sono i giorni fissi da sommare alla data di scadenza
V_SCAFISS_1RATA 	= 0		&& sono i giorni fissi da sommare solo alla data di scadenza della prima rata
V_SOLOIMPIVA    	= ""	&& scorpora il valore dell'IVA dall'imponibile e lo attribuisce alla prima scadenza della fattura
V_PERIMPO    		= 0		&& calcola i xxx % dell'imponibile e lo somma alla prima scadenza della fattura , il resto viene suddiviso alle restanti scadenze in parti uguali
V_RIBA       		= ""   	&& serve per verificare se ribba o meno
V_TIPI_TRANCHE      = ""    && contiene il tipo di tranche per ogni scadenza



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

   
	ENDIF

   V_CPAG 			= ALLTRIM(DESCRI)
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
     
     
     IF _FLAG_POSALL 						&& 2010-08-03 - SERGIO GESTIONE POSTICIPI FISSI PREVITI PER TUTTI I MESI DELL'ANNO A LIVELLO DI CLIENTE
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
   
   IF _FLAG_POSALL 												&& 2010-08-03 - SERGIO GESTIONE POSTICIPI FISSI PREVISTI PER TUTTI I MESI DELL'ANNO A LIVELLO DI CLIENTE
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


CONTA_TRA = 0
** RICERCA IMPORTO TRANCHE
IS=0
IS2=0						&& INDICE CHE DETERMINA LA PARTENZA/FINE DELLA DATA SCADENZA
_XPAROLA = ''
=CERCA_PAROLA(_STRINGA) 	&& ORA IS PARTE DAL PRIMO CARATTERE DELLA PRIMA DATA SCADENZA


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


**************************************************************************************************
FUNCTION SCADENZAFISSA_SOLO_PER_LA_PRIMA_RATA_DI_SCADENZA		&& FORZA LA DATA DI SCADENZA FISSA 
**************************************************************************************************
PARA _TRANCHE_


V_TUTTO = _TRANCHE_

LEN_V_TUTTO = LEN(ALLTRIM(_TRANCHE_))

CONTA_TRA = 0
** RICERCA IMPORTO TRANCHE
IS=0						&& INDICE CHE DETERMINA LA PARTENZA/FINE DELLA DATA SCADENZA
_XPAROLA = ''
=CERCA_PAROLA(_TRANCHE_) 


** MODIFICA DATA SCADENZA

_GGGGFISSI        = STR(V_SCAFISS_1RATA,2,0)   
DATA_SCAD_OLD     = SUBSTR(V_TUTTO,IS+1,10)
DATA_SCAD_RIC     = CTOD(DATA_SCAD_OLD)+VAL(_GGGGFISSI) 
DATA_SCAD_NEW     = DTOC(DATA_SCAD_RIC)

_TRANCHE_ = STRTRAN(_TRANCHE_,DATA_SCAD_OLD,ALLTRIM(DATA_SCAD_NEW))


RETURN(_TRANCHE_)



**************************************************************************
FUNCTION SCADENZAFISSA		&& FORZA LA DATA DI SCADENZA FISSA 
**************************************************************************
PARA _TRANCHE_



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

   _GGGGFISSI        = STR(V_SCAFISS,2,0)   
   DATA_SCAD_OLD     = SUBSTR(V_TUTTO,IS+1,10)
   DATA_SCAD_RIC     = CTOD(DATA_SCAD_OLD)+VAL(_GGGGFISSI) 
   DATA_SCAD_NEW     = DTOC(DATA_SCAD_RIC)

   _TRANCHE_ = STRTRAN(_TRANCHE_,DATA_SCAD_OLD,ALLTRIM(DATA_SCAD_NEW))


   ** RICERCA DATA SCADENZA SUCCESSIVA

   XPAROLA = ''
   DO PAROLA


ENDDO


RETURN(_TRANCHE_)


*************************************************************************
*    GESTIONE SCADENZIARIO CLIENTI	                                    *
*************************************************************************
FUNCTION AQUAREP_SCADC


IF FATTURA = 'S' .OR. FATTURA = 'A'    && ESEGUE SOLO SE SI TRATTA DI FATTURA
ELSE
   RETURN
ENDIF

HH=SELECT()
x_soci = "cli_codsoc = '" + PUB_CODSOC + "'"
x_codi = "cli_codcli = '" + SUBSTR(CGE_CON,PUB_SOTTOG,PUB_CONTO) + "'"
x_cond = x_soci + " and " + x_codi
Csql   = "select * from U_CLI_AN where " + x_cond + " order by cli_codsoc,cli_codcli"
IF !ExecCommand(cSql,"cur_cliente")
   return(.f.)
ENDIF

SELECT cur_cliente
GO TOP

IF EOF()
   V_CONPAG  = PUB_CPA   && FORZATURA CPA CONTANTI
ELSE
   V_CONPAG  = cli_CONPAG                                                         && DA ANAGRAFICA clienti
ENDIF


DATA_SCAD=SPACE(10)
PUBLIC VET_DAL[2],VET_AL[2],VET_DAY[2]
VET_DAL[1]= "0000"
VET_DAL[2]= "0000"
VET_AL[1] = "0000"
VET_AL[2] = "0000"
VET_DAY[1]= "0000"
VET_DAY[2]= "0000"

V_TUTTO=TRANCHE("PARA",V_CONPAG,RIBALTA2(CGE_DATADOC),(CGE_DA+CGE_AV+CGE_KABBUO))

=AQUAREP_PERIODI()    && CREA I PERIODI DI SCADENZA


RETURN


********************************
FUNCTION CAMBIO
********************************

* -->> MODIFICA 21/03/2001
* -----------------------------------------
* -->> aggiunto il parametro opzionale _CONTO_CONTABILE
* -->> che e'la chiave di lettura della tabella CONTI(indice CONTO)
* -->> chiave composta da SOCIETA'+ANNO+CONTO
* -->> quando e' valorizzato il nuovo parametro controllo se il conto
* -->> e' un conto IVA e in questo caso aggiungo 0.49 se lire o 0.0000 se euro
* -->> per poter arrotondare alla lira/centesimo superiore.

* -->> MODIFICA 03/11/2012 - FABIANO
* -->>     SE LA VALUTA DI RIFERIMENTO PUB_VALRIF ='EUR' E LA VALUTA DEL CAMBIO _COD_VAL='EUR'
* -->>     ALLORA NON SERVE ACCEDERE A CONTI PER STABILIRE SE SI TRATTA DI UN CONTO IVA
* -->>     PERCHE' COMUNQUE AGGIUNGEREI  _IVA_EURO  = 0 ALL'IMPORTO CALCOLATO
* -----------------------------------------

*PARA _COD_VAL,_IMP_DOC,_CAM_DOC,_CONTO_CONTABILE,_FL_INVAL
PARA _COD_VAL,_IMP_DOC,_CAM_DOC,_CONTO_CONTABILE,_FL_INVAL,_DECIMALS  && ERASMO - 20/05/2011

_W_PR=PARAMETER()

IF _W_PR < 3
   WAIT WINDOW "Routine cambio mancano i parametri"
   RETURN(0)
ENDIF

IF _W_PR = 3
   _CONTO_CONTABILE=""
   _FL_INVAL       = .F.  && STAMPA IN ITL/LIT
ENDIF

IF _W_PR = 4
   _FL_INVAL       = .F.  && STAMPA IN ITL/LIT
ENDIF

**=> ERASMO - INIZIO 20/05/2011
*** IMPOSTO DA PARAMETRO IL NUMERO DI DECIMALI PER L'ARROTONDAMENTO CON CUI VOGLIO IL 
*** CALCOLO DEL CAMBIO PER ESEMPIO NEL CALCOLO DEL BILANCIO PRETENDO UNA PRECISIONE DI 3 DECIMALI
IF _W_PR < 6
	_DECIMALS = 2
ENDIF
**=> ERASMO - FINE 20/05/2011

* -->> se richiedo la stampa in valuta non eseguo la routine cambio
* ------------------------------------------------------------------
IF _FL_INVAL     && STAMPA IN VALUTA USCITA FORZATA
   RETURN(_IMP_DOC)
ENDIF

_IVA_LIRE=0
_IVA_EURO=0

*** FABIANO 02/11/2012 - OTTIMIZZAZIONE ROUTINE CAMBIO
***
*** SE LA VALUTA DI RIFERIMENTO PUB_VALRIF ='EUR' E LA VALUTA DEL CAMBIO _COD_VAL='EUR'
*** ALLORA NON SERVE ACCEDERE A CONTI PER STABILIRE SE SI TRATTA DI UN CONTO IVA
*** PERCHE' COMUNQUE AGGIUNGEREI  _IVA_EURO  = 0 ALL'IMPORTO CALCOLATO
***
IF PUB_VALRIF ='EUR' AND _COD_VAL ='EUR'
ELSE
	IF !EMPTY(_CONTO_CONTABILE)
	   _SELE_PARA=SELECT()
	   _LENG  = LEN(ALLTRIM(_CONTO_CONTABILE)) - 6
	   x_soci = "con_soc = '" + SUBSTR(_CONTO_CONTABILE,1,2) + "'"
	   x_anno = "con_anno = '" + SUBSTR(_CONTO_CONTABILE,3,4) + "'"
	   x_cont = "con_conto = '" + SUBSTR(_CONTO_CONTABILE,7,_LENG) + "'"
	   x_cond = x_soci + " and " + x_anno + " and " + x_cont
	   Csql   = "select * from conti where " + x_cond + " order by con_soc,con_anno,con_conto"
	   IF !ExecCommand(cSql,"cur_conti")
	      return(.f.)
	   ENDIF
	   SELECT cur_conti
	   GO TOP
	   IF EOF()
	   ELSE
	      IF CON_TIPOCO = "I"    && CONTO IVA
	         _IVA_LIRE  = .49
	         _IVA_EURO  = .0000
	      ENDIF
	   ENDIF        
	   SELECT(_SELE_PARA)
	ENDIF
ENDIF

_CALCOLO=_IMP_DOC*_CAM_DOC

IF _COD_VAL $ "ITL.LIT" AND PUB_VALRIF $ "ITL.LIT"
   RETURN(ROUND(_CALCOLO+_IVA_LIRE,0))
ELSE
   IF PUB_VALRIF $ "ITL.LIT"
      RETURN(ROUND(_CALCOLO+_IVA_LIRE,0))
   ELSE
      *RETURN(ROUND(_CALCOLO+_IVA_EURO,2))
      RETURN(ROUND(_CALCOLO+_IVA_EURO,_DECIMALS))  && ERASMO - 20/05/2011
   ENDIF
ENDIF




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


******************************
FUNCTION GIRA
******************************
PARAMETERS CHI
_APPO=SUBSTR(CHI,3,2)+SUBSTR(CHI,1,2)
RETURN(_APPO)

********************
FUNCTION CERCAREPO      && RICERCA IL REPORT DI STAMPA PERSONALIZZATO
********************
* -->> SINTASSI: AA=CERCAREPO(_COMPA,_PROC,_REPO)
* -->> DOVE    :  _COMPA = CODICE DELLA COMPAGNIA SE ESISTONO REPORT DIVERSI
* -->>                     A SECONDA DELLE COMPAGNIE. PER UN REPORT UNICO PER
* -->>                     TUTTE LE COMPAGNIE DEVE ESSERE << XXX >>.
* -->>            _PROC  = NOME DELLA PROCEDURA IN CUI E' RICHIAMATO E CON CUI
* -->>                     VIENE IDENTIFICATO IN PJTIPREP.DBF.
* -->>            _REPO  = NOME DEL REPORT STANDARD USATO DAL SISTEMA.

PARA _COMPA,_PROC,_REPO

* -->> RICERCO SE ESISTONO REPORT DI STAMPA PERSONALIZZATI
* -->> RICHIESTI DAI VARI CLIENTI
IF PARAMETER() < 3
  _NOMEREP="NNN"
ELSE
  _NOMEREP="REPORT\"+_REPO
ENDIF
**** DO DAV

_SAVE_SEL=STR(SELECT())
SET EXACT ON

x_comp = "compa = '" + ALLTRIM(_COMPA) + "'"
x_nome = "nomeproc = '" + ALLTRIM(_PROC) + "'"
x_cond = x_comp + " and " + x_nome   
cSql = "select * from pjtiprep where " + x_cond + " order by compa,nomeproc"

*** TEXT TO cSql NOSHOW
***	   SELECT *
***	   FROM pjtiprep
***	   where compa+nomeproc = ?_COMPA+?_PROC
*** ENDTEXT

IF !ExecCommand(cSql,"pjtiprep")
   return("NNN")
ENDIF

SELECT pjtiprep
IF reccount() > 0
   _NOMEREP="REPORT\"+NOMEREP
ELSE
   x_nome = "nomeproc = '" + ALLTRIM(_PROC) + "'"
   x_cond = x_nome   
   cSql = "select * from pjtiprep where " + x_cond + " order by nomeproc"
   *** TEXT TO cSql NOSHOW
   ***	  SELECT *
   ***	  FROM pjtiprep
   ***	  where nomeproc = ?_PROC
   *** ENDTEXT
   IF !ExecCommand(cSql,"pjtiprep")
	  return("NNN")
   ENDIF
   SELECT pjtiprep
   IF reccount() > 0
 	  _NOMEREP="REPORT\"+NOMEREP
   ENDIF
ENDIF

SET EXACT OFF

IF !FILE(_NOMEREP)
   =MESSAGEB("Manca il report: "+ALLTRIM(_NOMEREP),16,"*** ATTENZIONE ***")
   SELECT &_SAVE_SEL
   RETURN("NNN")
ENDIF

SELECT &_SAVE_SEL
RETURN(_NOMEREP)


************************************************************************
PROCEDURE REPORT_TO_XLS								 && ERASMO - 08/2010
************************************************************************
*
* Questa procedura permette la creazione di un file excel in base al
* cursore e al file di report passato nei parametri, riportando i soli
* campi contenuti nel report di stampa
*
*
* Sintassi:
* 
* DO REPORT_TO_XLS WITH <cursore o tabella>,<nome_report>
*
* <cursore o tabella>           : 	é la tabella/cursore che si vuole 
*									rappresentare nel file excel
* <nome_report>                 : 	è il file di report sul quale deve 
*									basarsi la visualizzazione o meno 
*									dei campi in tabella
*
************************************************************************
                                                                                
PARAMETER _NOME_CURSORE,_NOME_FILE_REPORT

IF PARAMETERS() < 2
	RETURN .F.
ENDIF

_OLD_SELECT = SELECT()

_NOME_COMPLETO_REPORT = "REPORT\" + _NOME_FILE_REPORT
IF FILE(_NOME_COMPLETO_REPORT)
ELSE
	SELECT(_OLD_SELECT)
	RETURN .F.
ENDIF

IF !USED(_NOME_COMPLETO_REPORT)
   USE &_NOME_COMPLETO_REPORT ALIAS MY_FRX_CURSOR IN 0 AGAIN
ENDIF

_HEADER_BAND_INITIAL_POSITION = 0
_GENERIC_BAND_HEIGHT = 2083.333  && ALTEZZA STANDARD DELLA PRIMA BANDA
_DETAIL_BAND_FINAL_POSITION = 0

SELECT MY_FRX_CURSOR
SET FILTER TO
SET ORDER TO
GO TOP

*** ALTEZZA HEADER BAND
LOCATE FOR Objtype = 9 AND Objcode = 1
IF !EOF()
	_HEADER_BAND_INITIAL_POSITION = Height
ENDIF
GO TOP

*** ALTEZZE DA SOMMARE DELLE BANDE DI RAGGRUPPAMENTO
SCAN
	IF Objtype = 9 AND Objcode = 3
		_GENERIC_BAND_HEIGHT = _GENERIC_BAND_HEIGHT + Height + 2083.333
	ENDIF
ENDSCAN
GO TOP

*** ALTEZZA DETAIL BAND
LOCATE FOR Objtype = 9 AND Objcode = 4
IF !EOF()
	_DETAIL_BAND_FINAL_POSITION = Height + _GENERIC_BAND_HEIGHT + _HEADER_BAND_INITIAL_POSITION
ENDIF
GO TOP

IF _HEADER_BAND_INITIAL_POSITION = 0 .OR. _DETAIL_BAND_FINAL_POSITION = 0 .OR. (_DETAIL_BAND_FINAL_POSITION < _HEADER_BAND_INITIAL_POSITION)
	SELECT MY_FRX_CURSOR
	USE
	SELECT(_OLD_SELECT)
	RETURN .F.
ENDIF

CREATE CURSOR ELENCO_CAMPI (NOME_CAMPO C(254), EXPR_CAMPO C(254), VPOS N(20,3), HPOS N(20,3))
INDEX ON STR(HPOS,20,3)+STR(VPOS,20,3) TAG I_POSIZ
CREATE CURSOR ELENCO_TITOLI (EXPR_CAMPO C(254), VPOS N(20,3), HPOS N(20,3))
INDEX ON STR(VPOS,20,3)+STR(HPOS,20,3) TAG I_POSIZ

SELECT MY_FRX_CURSOR
GO TOP
SCAN
	
	*** SOLO LE CASELLE DI TESTO
	IF Objtype = 8 .AND. Objcode = 0
	ELSE
		LOOP
	ENDIF
	
	*** SOLO QUELLE CONTENUTE NELLA DETAIL BAND
	IF VPos > _HEADER_BAND_INITIAL_POSITION .AND. VPos <= _DETAIL_BAND_FINAL_POSITION 
	ELSE
		LOOP
	ENDIF
	_FIELD_NAME = UPPER(ALLTRIM(Expr))
	_VPOSIZ = Vpos
	_HPOSIZ = Hpos
	
	*** VERIFICO CHE IL CAMPO SIA CONTENUTO ALL'INTERNO DEL CURSORE CHE POPOLA IL REPORT
	_OK_FIELD = .F.
	nFieldNumber = 1
	_STRING = ""
	SELECT &_NOME_CURSORE
	GO TOP
	DO WHILE .T.
		_STRING = UPPER(ALLTRIM(FIELDS(nFieldNumber,_NOME_CURSORE)))
		IF EMPTY(_STRING)
			EXIT
		ENDIF
		IF _STRING $ _FIELD_NAME
			_OK_FIELD = .T.
			EXIT
		ENDIF
		nFieldNumber = nFieldNumber + 1
	ENDDO
	IF _OK_FIELD
		SELECT ELENCO_CAMPI 
		APPEND BLANK
		REPLACE NOME_CAMPO WITH _STRING
		REPLACE EXPR_CAMPO WITH _FIELD_NAME
		REPLACE VPOS WITH _VPOSIZ 
		REPLACE HPOS WITH _HPOSIZ 
	ENDIF
	
ENDSCAN

*** DETERMINO EVENTUALI TITOLI PRESENTI NEL PAGE HEADER
SELECT MY_FRX_CURSOR
GO TOP
SCAN
	
	*** SOLO LE LABEL E LE CASELLE DI TESTO
	IF (Objtype = 5 .OR. Objtype = 8).AND. Objcode = 0
	ELSE
		LOOP
	ENDIF
	
	*** SOLO QUELLE CONTENUTE NELLA HEADER BAND
	IF VPos <= _HEADER_BAND_INITIAL_POSITION 
	ELSE
		LOOP
	ENDIF
	_FIELD_EXPR = UPPER(ALLTRIM(Expr))
	
	IF "GETTESTO" $ _FIELD_EXPR
		LOOP
	ENDIF
	
	_VPOSIZ = Vpos
	_HPOSIZ = Hpos
	
	SELECT ELENCO_TITOLI 
	APPEND BLANK
	REPLACE EXPR_CAMPO WITH _FIELD_EXPR 
	REPLACE VPOS WITH _VPOSIZ 
	REPLACE HPOS WITH _HPOSIZ 
	
ENDSCAN

SELECT ELENCO_TITOLI 
SET ORDER TO I_POSIZ
GO TOP
*_EXPR_TITOLO1 = EXPR_CAMPO
**=> ERASMO - INIZIO 18/06/2012
*** SE _EXPR_TITOLO1  CONTIENE UN RITORNO A CAPO IL COMANDO &_EXPR_TITOLO1 DA' ERRORE, QUINDI ELIMINO EVENTUALI CHR(13) PRESENTI NELLA STRINGA
_EXPR_TITOLO1 = ALLTRIM(EXPR_CAMPO)
_EXPR_TITOLO1 = STRTRAN(_EXPR_TITOLO1,CHR(13),'')
**=> ERASMO - FINE 18/06/2012
SELECT &_NOME_CURSORE
GO TOP
_TITOLO1 = &_EXPR_TITOLO1
_TITOLO1 = STRTRAN(_TITOLO1,CHR(13),CHR(10))
_TITOLO1 = STRTRAN(_TITOLO1,CHR(10)+CHR(10),CHR(10))

SELECT MY_FRX_CURSOR
USE

_STRINGA_CAMPI = ""
SELECT ELENCO_CAMPI 
SET ORDER TO I_POSIZ
GO TOP
IF EOF()
	USE
	RETURN .F.
ENDIF
SCAN
	IF EMPTY(ALLTRIM(_STRINGA_CAMPI))
		_STRINGA_CAMPI = _STRINGA_CAMPI + ALLTRIM(EXPR_CAMPO) + " AS " + ALLTRIM(NOME_CAMPO)
	ELSE
		_STRINGA_CAMPI = _STRINGA_CAMPI + ", " + ALLTRIM(EXPR_CAMPO) + " AS " + ALLTRIM(NOME_CAMPO)
	ENDIF
ENDSCAN
USE

_STRINGA_SELECT = "SELECT " + _STRINGA_CAMPI + " FROM " + _NOME_CURSORE + " INTO CURSOR CURSORE_XLS"
&_STRINGA_SELECT
DO ESTRXLS WITH "CURSORE_XLS",_TITOLO1

SELECT(_OLD_SELECT)

RETURN


***********************************************************************
PROCEDURE RES_OPER_CONF
***********************************************************************
REPLACE OPE_CODSOC WITH M.OPE_CODSOC 
REPLACE OPE_CODICE WITH M.OPE_CODICE 
REPLACE OPE_DESCRI WITH M.OPE_DESCRI 
REPLACE OPE_BLKPRZ WITH M.OPE_BLKPRZ 
REPLACE OPE_NOVPRZ WITH M.OPE_NOVPRZ 

RETURN


*********************************************************************************************

FUNCTION seek_res_oper1
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PARAMETERS() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_res_oper"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT * FROM res_oper where societa+codice = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM res_oper where societa+codice like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "codice;descri"
PUB_RIT    = _ritorno

DO Form elenco WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco operatori"


STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)

************************************************************************
PROCEDURE ESTRXLS
************************************************************************
*
* Tale procedura permette la creazione di un file excel in base al cursore passato nei parametri.
*
* Sintassi:
* 
* DO ESTRXLS WITH <cursore o tabella>,<titolo1>,<titolo2>,<titolo3>,<subtotale>,<def_decimali>
*
* <cursore o tabella>           : é il nome della tabella/cursore che si vuole rappresentare nel file excel [stringa]
* <titolo1>                     : primo titolo da visualizzare nel file excel [stringa]
* <titolo2>                     : secondo titolo da visualizzare nel file excel [stringa]
* <titolo3>                     : terzo titolo da visualizzare nel file excel [stringa]
* <subtotale>                   : subtotale di tutti i valori numerici alla fine del file excel [booleano .t./.f.]
* <def_decimali>                : esiste un cursore dal nome 'CUR_ESTRXLS_DEF_DECIMALS' dal quale dedurre i decimali da riportare per i campi numerici [booleano .t./.f.]
*
********************************************************************************************************************
                                                                                
PARAMETER _NOMECUR,_TITOLO1,_TITOLO2,_TITOLO3,_SUBTOTALS,_DEFDECIMALS

**=> ERASMO - INIZIO 10/08/2010
IF PARAMETERS() = 0
   MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
   RETURN .F.
ENDIF

IF PARAMETERS() < 2
   _TITOLO1 = ""
ENDIF
IF PARAMETERS() < 3
   _TITOLO2 = ""
ENDIF
IF PARAMETERS() < 4
   _TITOLO3 = ""
ENDIF
**=> ERASMO - FINE 10/08/2010

**=> ERASMO - INIZIO 09/01/2012
*** PARAMETRO PER LA SCRITTURA DEI TOTALI GENERALI A FINE TABELLA, CON DEFAULT A TRUE
IF PARAMETERS() < 5
   _SUBTOTALS = .T.
ENDIF
**=> ERASMO - FINE 09/01/2012

**=> ERASMO - INIZIO 28/03/2012
*** PARAMETRO PER LA SEGNALAZIONE CHE NEL CURSORE DAL NOME 'CUR_ESTRXLS_DEF_DECIMALS' SONO DEFINITI I DECIMALI DA RIPORTARE PER I CAMPI NUMERICI, CON DEFAULT A FALSE
IF PARAMETERS() < 6
   _DEFDECIMALS = .F.
ENDIF
**=> ERASMO - FINE 28/03/2012

SELECT &_NOMECUR
GO TOP
IF RECCOUNT() > 65530
   MESSAGEBOX("Generazione file excel: numero di righe eccessivo",16,"Attenzione")
   RETURN .F.
ENDIF

WAIT WINDOWS "Creazione foglio excel in corso..." nowait

local oExcel
objExcel = CreateObject([Excel.Application])
objExcel.Visible = .f.
objExcel.Workbooks.Add()
xlLandscape = 2

WITH objExcel 
*!*	   .Workbooks.Open(ALLTRIM(_X_FILENAME),0,0)
*!*	   .Visible = .f.
   .Range("A1:IV65536").Select
   *.Selection.Font.Size = 8  && ERASMO - 05/01/2012 - SETTAGGIO ASTERISCATO A CAUSA DELLO SPAZIO ECCESSIVO OCCUPATO (INTESO COME PESANTEZZA DEL FILE IN MEGABYTE)
*!*	   .Range("A1:IV1").Select
*!*	   .Selection.Font.Size = 10
*!*	   .Selection.Font.Bold = .t.
*!*	   .Columns().EntireColumn.AutoFit
*!*	   .Rows("1:1").EntireRow.Select
*!*	   .Selection.Insert
*!*	   .Selection.Insert
*!*	   .Selection.Insert
   .Range("A1").Select
*!*	   .ActiveSheet.Pictures.Insert(sys(5)+sys(2003)+"\report\logo_report.jpg").Select && carica il logo azienda
*!*	   .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a False"
*!*	   .Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
*!*	   .Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
   
   IF FILE(PUB_LOGO1)
      _FULL_PATH = SYS(5) + SYS(2003) + "\" + ALLTRIM(PUB_LOGO1)
      .ActiveSheet.Pictures.Insert(_FULL_PATH).Select && carica il logo principale dell'azienda
      .Selection.ShapeRange.LockAspectRatio = -1 && imposta il "mantieni proporzioni a True"
      *.Selection.ShapeRange.Height = 65.25*0.6 && regola l'altezza del logo azienda
      *.Selection.ShapeRange.Width = 159.75*0.6 && regola la larghezza del logo azienda 
      *.Selection.ShapeRange.Height = 31.5 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Height = 50 && regola l'altezza del logo azienda
      .Selection.ShapeRange.Top = 0  && allinea l'immagine in alto - ERASMO 16/06/2009    
      .Selection.ShapeRange.Left = 0  && allinea l'immagine a sinistra - ERASMO 16/06/2009
   ENDIF

*!*	   .ActiveWorkbook.Save
*!*	   .ActiveWorkbook.Close
ENDWITH

nFieldNumber = 1
_STRING      = ""
_NUMEROCAMPI = 0
DO WHILE .T.
   _STRING = FIELDS(nFieldNumber,_NOMECUR)
   IF EMPTY(ALLTRIM(_STRING))
      EXIT
   ENDIF
   _NUMEROCAMPI = _NUMEROCAMPI + 1
   nFieldNumber = nFieldNumber + 1
ENDDO

*MESSAGEBOX("Il cursore contiene " + ALLTRIM(STR(_NUMEROCAMPI)) + " campi",64,"Informazione")
_RIGA_INIZIALE = 6

FOR I = 1 TO _NUMEROCAMPI
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Value = FIELD(I,_NOMECUR) && NOME CAMPO
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Bold = .T.
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).Font.Size = 10
   objExcel.ActiveSheet.Cells(_RIGA_INIZIALE,I).HorizontalAlignment = 3  
ENDFOR

_Range = n2c(1) + ALLTRIM(STR(_RIGA_INIZIALE,10,0)) + ":" + n2c(_NUMEROCAMPI) + ALLTRIM(STR(_RIGA_INIZIALE,10,0))
objExcel.ActiveSheet.Range(_Range).Select

xlEdgeTop    = 8
xlEdgeBottom = 9
xlContinuous = 1
xlThin       = 2
xlAutomatic  = -4105
xlSolid      = 1
WITH objExcel.Selection.Borders(xlEdgeBottom)
   .LineStyle = xlContinuous
   .Weight = xlThin
   .ColorIndex = xlAutomatic
ENDWITH
WITH objExcel.Selection.Borders(xlEdgeTop)
   .LineStyle = xlContinuous
   .Weight = xlThin
   .ColorIndex = xlAutomatic
ENDWITH
WITH objExcel.Selection.Interior
   .ColorIndex = 37
   .Pattern = xlSolid
ENDWITH

objExcel.ActiveSheet.Columns().EntireColumn.AutoFit

*!*	objExcel.ActiveSheet.Cells(2,2).Value = _TITOLO1
*!*	objExcel.ActiveSheet.Cells(2,2).Font.Bold = .T.
*!*	objExcel.ActiveSheet.Cells(2,2).Font.Size = 11
*!*	objExcel.ActiveSheet.Cells(2,2).HorizontalAlignment = 1

*!*	objExcel.ActiveSheet.Cells(3,2).Value = _TITOLO2
*!*	objExcel.ActiveSheet.Cells(3,2).Font.Bold = .T.
*!*	objExcel.ActiveSheet.Cells(3,2).Font.Size = 11
*!*	objExcel.ActiveSheet.Cells(3,2).HorizontalAlignment = 1

*!*	objExcel.ActiveSheet.Cells(4,2).Value = _TITOLO3
*!*	objExcel.ActiveSheet.Cells(4,2).Font.Bold = .T.
*!*	objExcel.ActiveSheet.Cells(4,2).Font.Size = 11
*!*	objExcel.ActiveSheet.Cells(4,2).HorizontalAlignment = 1

*!*	**=> ERASMO - INIZIO 10/08/2010
*!*	WITH objExcel
*!*		.ActiveSheet.Cells(2,5).Value = _TITOLO1
*!*		.ActiveSheet.Cells(2,5).Font.Bold = .T.
*!*		.ActiveSheet.Cells(2,5).Font.Size = 11
*!*		.ActiveSheet.Cells(2,5).HorizontalAlignment = 1

*!*		.ActiveSheet.Cells(3,5).Value = _TITOLO2
*!*		.ActiveSheet.Cells(3,5).Font.Bold = .T.
*!*		.ActiveSheet.Cells(3,5).Font.Size = 11
*!*		.ActiveSheet.Cells(3,5).HorizontalAlignment = 1

*!*		.ActiveSheet.Cells(4,5).Value = _TITOLO3
*!*		.ActiveSheet.Cells(4,5).Font.Bold = .T.
*!*		.ActiveSheet.Cells(4,5).Font.Size = 11
*!*		.ActiveSheet.Cells(4,5).HorizontalAlignment = 1
*!*	ENDWITH
*!*	**=> ERASMO - FINE 10/08/2010

** LUCA
*objExcel.ActiveSheet.Rows(2).RowHeight = 50

_nRIGA = _RIGA_INIZIALE + 1
SELECT &_NOMECUR
GO TOP
DO WHILE .T.
   IF EOF()
      EXIT
   ENDIF
   IF DELETED()
      SKIP +1
      LOOP
   ENDIF
   
   WAIT WINDOWS "Creazione foglio excel in corso... - riga " + ALLTRIM(STR(RECNO())) + " di " + ALLTRIM(STR(RECCOUNT())) NOWAIT
   
   FOR I = 1 TO _NUMEROCAMPI
      _NOMECAMPO = ALLTRIM(FIELD(I,_NOMECUR))
      _VALORE = &_NOMECAMPO
      _Range  = n2c(I) + ALLTRIM(STR(_nRIGA,10,0)) && + ":" + n2c(I) + ALLTRIM(STR(_nRIGA,10,0))
      IF TYPE(_NOMECAMPO) = "N"
         objExcel.ActiveSheet.Range(_Range).Select
         objExcel.Selection.NumberFormat = "#,##0.00"
         *IF AT('METRIQUADRI',ALLTRIM(_TITOLO2)) <> 0
         IF 'METRIQUADRI' $ ALLTRIM(_TITOLO2) OR 'METRICUBI' $ ALLTRIM(_TITOLO2)  && ERASMO - 17/01/2012
            A=0
			NFORMAT = ''
         	FOR A=1 TO PUB_DECQTA STEP 1
         		NFORMAT = NFORMAT + '0'
         	ENDFOR
         	NFORMAT = '#,##0.' + NFORMAT
         	objExcel.Selection.NumberFormat = NFORMAT
         ENDIF
         IF AT('Unità',ALLTRIM(_TITOLO2)) <> 0
            A=0
			NFORMAT = ''
         	FOR A=1 TO PUB_DECQTA STEP 1
         		NFORMAT = NFORMAT + '0'
         	ENDFOR
         	NFORMAT = '#,##0.' + NFORMAT
         	objExcel.Selection.NumberFormat = NFORMAT
         ENDIF
         IF AT('Unità',ALLTRIM(_TITOLO3)) <> 0
            A=0
			NFORMAT = ''
         	FOR A=1 TO PUB_DECQTA STEP 1
         		NFORMAT = NFORMAT + '0'
         	ENDFOR
         	NFORMAT = '#,##0.' + NFORMAT
         	objExcel.Selection.NumberFormat = NFORMAT
         ENDIF
         IF AT('Valuta',ALLTRIM(_TITOLO2)) <> 0
            A=0
			NFORMAT = ''
         	FOR A=1 TO PUB_DECVAL STEP 1
         		NFORMAT = NFORMAT + '0'
         	ENDFOR
         	NFORMAT = '#,##0.' + NFORMAT
         	objExcel.Selection.NumberFormat = NFORMAT
         ENDIF
         IF AT('Valuta',ALLTRIM(_TITOLO3)) <> 0
            A=0
			NFORMAT = ''
         	FOR A=1 TO PUB_DECVAL STEP 1
         		NFORMAT = NFORMAT + '0'
         	ENDFOR
         	NFORMAT = '#,##0.' + NFORMAT
         	objExcel.Selection.NumberFormat = NFORMAT
         ENDIF
         
         **=> ERASMO - INIZIO 28/03/2012
         IF _DEFDECIMALS AND USED("CUR_ESTRXLS_DEF_DECIMALS")
            SELECT CUR_ESTRXLS_DEF_DECIMALS
            SET ORDER TO I_FLDNAME
            GO TOP
            _SEEK = ALLTRIM(_NOMECAMPO)
            SEEK _SEEK
            IF FOUND()
               _nDecimals = NDECIMALS
               IF _nDecimals > 0
                  A=0
      			  NFORMAT = ''
               	  FOR A=1 TO _nDecimals STEP 1
               		 NFORMAT = NFORMAT + '0'
               	  ENDFOR
               	  NFORMAT = '#,##0.' + NFORMAT
               	  objExcel.Selection.NumberFormat = NFORMAT
               ELSE
                  objExcel.Selection.NumberFormat = "#,##0"
               ENDIF
            ENDIF
            SELECT &_NOMECUR
         ENDIF
         **=> ERASMO - FINE 28/03/2012         
      ELSE
         objExcel.ActiveSheet.Range(_Range).Select
         objExcel.Selection.NumberFormat = "@"
      ENDIF
      objExcel.ActiveSheet.Cells(_nRIGA,I).Value = _VALORE

   ENDFOR
   
   _nRIGA = _nRIGA + 1

   SELECT &_NOMECUR
   SKIP +1
ENDDO

*!*	**LUCA
*!*	objExcel.ActiveSheet.Cells(_nRIGA+1,2).Value = "TOTALI"
*!*	objExcel.ActiveSheet.Cells(_nRIGA+1,2).Font.Bold = .T.
*!*	objExcel.ActiveSheet.Cells(_nRIGA+1,2).Font.Size = 11
*!*	objExcel.ActiveSheet.Cells(_nRIGA+1,2).HorizontalAlignment = 1

*!*	*** TOTALI
*!*	_T_RIGA  = _nRIGA + 1
*!*	_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1
*!*	WITH objExcel 
*!*	   
*!*	   _RANGE  = "E" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	    _RANGE  = "F" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "G" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "H" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "I" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "J" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	         
*!*	   _RANGE  = "K" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	      
*!*	   _RANGE  = "L" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "M" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "N" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "O" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "P" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	   _RANGE  = "Q" + ALLTRIM(STR(_T_RIGA,10,0))
*!*	   .Range(_RANGE).Select
*!*	   .Selection.NumberFormat = "#,##0.00"
*!*	   .ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
*!*	   .Selection.Font.Bold = .t.
*!*	   
*!*	ENDWITH

**=> ERASMO - INIZIO 10/08/2010
*** TOTALI DINAMICI SU TUTTI I CAMPI NUMERICI
IF _SUBTOTALS  && ERASMO - 09/01/2012
	_T_RIGA  = _nRIGA + 1
	_RIF_SUM = _nRIGA - _RIGA_INIZIALE + 1
	FOR I = 1 TO FCOUNT(_NOMECUR)
		_NOMECAMPO = FIELD(I,_NOMECUR)
		IF TYPE(_NOMECAMPO) = "N"
			WITH objExcel 
				_Range  = n2c(I) + ALLTRIM(STR(_T_RIGA,10,0))
				.Range(_RANGE).Select
				.Selection.NumberFormat = "#,##0.00"
				.ActiveCell.FormulaR1C1 = "=SUM(R[-"+ALLTRIM(STR(_RIF_SUM,10,0))+"]C:R[-2]C)"
				.Selection.Font.Bold = .t.
				_COLUMN = n2c(I) + ":" + n2c(I)
				.Columns(_COLUMN).EntireColumn.AutoFit
			ENDWITH
		ENDIF
	ENDFOR
ENDIF  && ERASMO - 09/01/2012
**=> ERASMO - FINE 10/08/2010

**=> ERASMO - INIZIO 17/01/2011
*** AGGIUNGO I TITOLI ALLA FINE DELLA SCRITTURA DEI DETTAGLI PER NON INFLUIRE SULL'AUTOFIT DELLE COLONNE
WITH objExcel
	.ActiveSheet.Cells(2,5).Value = _TITOLO1
	.ActiveSheet.Cells(2,5).Font.Bold = .T.
	.ActiveSheet.Cells(2,5).Font.Size = 11
	.ActiveSheet.Cells(2,5).HorizontalAlignment = 1

	.ActiveSheet.Cells(3,5).Value = _TITOLO2
	.ActiveSheet.Cells(3,5).Font.Bold = .T.
	.ActiveSheet.Cells(3,5).Font.Size = 11
	.ActiveSheet.Cells(3,5).HorizontalAlignment = 1

	.ActiveSheet.Cells(4,5).Value = _TITOLO3
	.ActiveSheet.Cells(4,5).Font.Bold = .T.
	.ActiveSheet.Cells(4,5).Font.Size = 11
	.ActiveSheet.Cells(4,5).HorizontalAlignment = 1
ENDWITH
**=> ERASMO - FINE 17/01/2011

objExcel.Range("A1").Select
   
objExcel.Visible = .t.

**=> ERASMO - INIZIO 28/03/2012
IF USED("CUR_ESTRXLS_DEF_DECIMALS")
	SELECT CUR_ESTRXLS_DEF_DECIMALS
	USE
ENDIF
**=> ERASMO - FINE 28/03/2012   




***************************
* Function N2C
***************************
FUNCTION N2C
LPARAMETERS	nNumero
			
LOCAL cLettera

IF nNumero<=26
	cLettera=CHR(nNumero+64)
ELSE
	*cLettera=CHR(INT(nNumero/26)+64)+chr((nNumero-INT(nNumero/26)*26)+64)	
	
	**=> ERASMO INIZIO - 06/10/2008 - MODIFICA FATTA TRAMITE SEGNALAZIONE LUCA
	if mod (nNumero,26)<>0
		cLettera=CHR(INT(nNumero/26)+64)+chr((nNumero-INT(nNumero/26)*26)+64)
	else		
	** i multipli di 26 sono un caso particolare che causa il salto della cella xZ es: AZ => B@
	** la formula viene forzata per sistemare il problema
		cLettera=CHR(INT(nNumero/26)+63)+chr(90)	
	ENDIF
	**=> ERASMO FINE - 06/10/2008
	
ENDIF

RETURN cLettera
ENDFUNC



****************************
PROCEDURE Tokenizer
*****************************
LPARAMETERS pStringa,pProprieta

LOCAL 	_valore,;
		_posizione,;
		_stringa,;
		_posizioneFinale

_valore=""
_stringa=pStringa
_posizione=AT(pProprieta+":",_stringa)
_posizioneFinale=0

IF _posizione>0
	_stringa=SUBSTR(_stringa,_posizione+LEN(pProprieta+":"))
	_posizioneFinale=AT(";",_stringa)-1
	_valore=ALLTRIM(SUBSTR(_stringa,1,_posizioneFinale))
ENDIF


RETURN _valore
ENDPROC 



*****************************
PROCEDURE Colore
*****************************
LPARAMETERS pColore

LOCAL nValoreColore

nValoreColore=0

DO CASE
	CASE pColore="BIANCO"  	
		nValoreColore=RGB(255, 255, 255)	
	CASE pColore="NERO"  
		nValoreColore=RGB(0, 0, 0	     )
	CASE pColore="GRIGIO_CHIARO" 
		nValoreColore=RGB(192, 192, 192)
	CASE pColore="GRIGIO"  
		nValoreColore=RGB(128, 128, 128)
	CASE pColore="ROSSO"  
		nValoreColore=RGB(255, 0, 0	 )
	CASE pColore="BORDEAUX"  
		nValoreColore=RGB(128, 0, 0	 )
	CASE pColore="GIALLO"  
		nValoreColore=RGB(255, 255, 0	 )
	CASE pColore="GIALLO_CHIARO"  
		nValoreColore=RGB(255, 255, 128	 )
	CASE pColore="VERDE_OLIVA"  
		nValoreColore=RGB(128, 128, 0	 )
	CASE pColore="VERDE_LIMONE"  
		nValoreColore=RGB(0, 255, 0	 )
	CASE pColore="VERDE"  
		nValoreColore=RGB(0, 128, 0	 )
	CASE pColore="AZZURRO"  
		nValoreColore=RGB(0, 255, 255	 )
	CASE pColore="VERDE_ACQUA"  
		nValoreColore=RGB(0, 128, 128	 )
	CASE pColore="BLU"  
		nValoreColore=RGB(0, 0, 255	 )
	CASE pColore="BLU_SCURO"  
		nValoreColore=RGB(0, 0, 128	 )
	CASE pColore="FUCSIA"  
		nValoreColore=RGB(255, 0 ,255	 )
	CASE pColore="VIOLA"  
		nValoreColore=RGB(128, 0, 128	 )
	CASE pColore="PUFFO"  
		nValoreColore=RGB(128,128,255	 )
	CASE pColore="CELESTE"  
		nValoreColore=RGB(106,181,255)
ENDCASE
RETURN nValoreColore

ENDPROC

**********************************************************
* Classe CasellaDiTesto
**********************************************************
DEFINE CLASS CasellaDiTesto AS TestoPerGriglia
  		  
    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click

	
		WITH this
			.Parent.Parent.DefaultClick()
			IF !.alreadyClick
				.Parent.Parent.VerificaSelezioneMultipla()
* 				.BackColor=RGB(255,0,0)
* 				.ForeColor=RGB(255,255,255)
*				.FontBold=.T.
				.alreadyClick=.T.
				.clickTime=SECONDS()
			ELSE
				.alreadyClick=.F.
				IF (SECONDS()-.clickTime)*100<40
					IF .Parent.Parent.StatoSelezioneMultipla>0
						MESSAGEBOX("Prima di effettuare un'operazione di pagamento o trasferimento disattivare la selezione multipla",48,"Attenzione!")
					ELSE
						.DblClick()	
					ENDIF	
				ELSE
					.Parent.Parent.VerificaSelezioneMultipla()
				ENDIF
			ENDIF
		ENDWITH
	ENDPROC
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
		WITH this
		
* 			SELECT (.Parent.Parent.RecordSource)		
* 			.Parent.Parent.TAG=ALLTRIM(STR(RECNO()))
		
			* seleziona tutte le caselle selezionate con un colore diverso
			* e....
			* seleziona la casella corrente con un colore diverso
			* anche se non ho selezionato nulla questa la devo selezionare comunque
*!*				IF .Parent.Parent.AbilitaSelezione
*!*					REPLACE SELEZIONE WITH .Parent.Parent.SimboloSelezione
*!*					.Parent.Parent.SetAll("DynamicBackColor","IIF(!EMPTY(SELEZIONE) OR RECNO()=VAL(THIS.TAG), COLORE('ROSSO'),COLORE('GRIGIO_CHIARO'))", "Column")
*!*					.Parent.Parent.SetAll("DynamicForeColor","IIF(!EMPTY(SELEZIONE) OR RECNO()=VAL(THIS.TAG), COLORE('GIALLO'),COLORE('GRIGIO'))", "Column")
*!*					.Parent.Parent.SetAll("DynamicFontBold","IIF(!EMPTY(SELEZIONE) OR RECNO()=VAL(THIS.TAG),.T.,.F.)","Column") 
*!*				ELSE			
*!*		 			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()=VAL(THIS.TAG), COLORE('ROSSO'),COLORE('GRIGIO_CHIARO'))", "Column")
*!*		 			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()=VAL(THIS.TAG), COLORE('GIALLO'),COLORE('GRIGIO'))", "Column")
*!*		 			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()=VAL(THIS.TAG),.T.,.F.)","Column") 
*!*				ENDIF			
			
			.Parent.Parent.StatoTransazioneCelle
			.Parent.Parent.Refresh()
		ENDWITH
	ENDPROC
	*- FINE Metodo: DblClick
    ***************************
	

ENDDEFINE
*- FINE CLASSE CasellaDiTesto
**********************************************************


**********************************************************
* Classe TestoPerGriglia
**********************************************************
DEFINE CLASS TestoPerGriglia AS TextBox
	alreadyClick=.F.
	clickTime=0
	
	*****************************
	* Metodo PROCEDURE Init
	*****************************
	PROCEDURE Init
		
		WITH this
			.height=20
			.FontName=this.Parent.Parent.FontName
			.FontSize=this.Parent.Parent.FontSize
			.FontBold=this.Parent.Parent.FontBold
			.SpecialEffect=1
			.BorderStyle=0 && 0-none 1-fixed single
			.BackColor=RGB(255,255,255)
			.ForeColor=RGB(0,0,0)
			.SelectedBackColor=RGB(255,0,0)
			.SelectedForeColor=RGB(255,255,255)
			.DisabledBackColor=RGB(255,0,0)
			.DisabledForeColor=RGB(255,255,255)
		ENDWITH	

	ENDPROC
	*- FINE Metodo: Init
    ***************************

    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
		THIS.Parent.Parent.DefaultClick()
		THIS.Parent.Parent.VerificaSelezioneMultipla()
		THIS.FontBold=.T.
		
		IF this.Parent.Parent.Name="GrigliaPagati"
			this.Parent.Parent.Parent.Seleziona_Movimenti()
		ENDIF
				
	ENDPROC
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick

	ENDPROC
	*- FINE Metodo: DblClick
    ***************************

ENDDEFINE
*- FINE CLASSE TestoPerGriglia
**********************************************************


**********************************************************
* Classe TestoStandard
**********************************************************
DEFINE CLASS TestoStandard AS TestoPerGriglia
	
	alreadyClick=.F.
	clickTime=0

	*****************************
	* Metodo PROCEDURE Init
	*****************************
	PROCEDURE Init
		
		WITH this
			.height=20
			.FontName=this.Parent.Parent.FontName
			.FontSize=this.Parent.Parent.FontSize
			.FontBold=this.Parent.Parent.FontBold
			.SpecialEffect=1
			.BorderStyle=0 && 0-none 1-fixed single
			.BackColor=RGB(255,255,255)
			.ForeColor=RGB(0,0,0)
			.SelectedBackColor=RGB(255,0,0)
			.SelectedForeColor=RGB(255,255,255)
			.DisabledBackColor=RGB(255,0,0)
			.DisabledForeColor=RGB(255,255,255)
		ENDWITH	
		
	RETURN
	*- FINE Metodo: Init
    ***************************	
		  		  
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
		WITH this
			_ALIAS=.Parent.Parent.RecordSourceAlias
			SELECT &_ALIAS
			_RECNO=ALLTRIM(STR(RECNO()))
			* seleziona la casella corrente con un colore diverso
			.Parent.Parent.SetAll("DynamicBackColor","IIF(RECNO()="+_RECNO+",COLORE('ROSSO'),COLORE('BIANCO'))", "Column")
			.Parent.Parent.SetAll("DynamicForeColor","IIF(RECNO()="+_RECNO+",COLORE('GIALLO'),COLORE('NERO'))", "Column")
			.Parent.Parent.SetAll("DynamicFontBold","IIF(RECNO()="+_RECNO+",.T.,.F.)","Column") 
			
			.Parent.Parent.Refresh()
		ENDWITH
	RETURN
	*- FINE Metodo: Click
    ***************************
		
	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DblClick
	
	RETURN
	*- FINE Metodo: DblClick
    ***************************
    
ENDDEFINE
*- FINE CLASSE TestoStandard
**********************************************************


**********************************************************
* Classe CheckBoxPerGriglia
**********************************************************
DEFINE CLASS CheckBoxPerGriglia AS CheckBox
	
    WIDTH = 18
    AUTOSIZE = .T.
    CAPTION = ""
    NAME = "CheckBoxPerGriglia"

	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click

		SELECT (this.Parent.Parent.RECORDSOURCE)
		IF RECCOUNT()=0
			RETURN
		ENDIF
	
		IF !THIS.Parent.Parent.VerificaSelezioneMultipla()
			SELECT (THIS.Parent.Parent.RecordSource) 
			IF EMPTY(SELEZIONE)
				REPLACE SELEZIONE WITH THIS.Parent.Parent.SimboloSelezione
			ELSE
				REPLACE SELEZIONE WITH SPACE(0)
			ENDIF
		ENDIF

		IF this.Parent.Parent.Name="GrigliaPagati"
			this.Parent.Parent.Parent.Seleziona_Movimenti()
		ENDIF
		
		THIS.Parent.Parent.Refresh()
	ENDPROC
	*- FINE Metodo: Click
    ***************************

ENDDEFINE
*- FINE CLASSE CheckBoxPerGriglia
**********************************************************

**********************************************************
* Classe Intestazione
**********************************************************
DEFINE CLASS Intestazione AS HEADER
	AlreadyOrdered=.F.
	OrderAscending=.F.
    
	***************************
	* Metodo 
	* Procedure Click
	***************************
	PROCEDURE Click
		LOCAL 	_ALIAS,;
				_ORDER,;
				_TAG_NAME
				
* 	    IF !_PUB_ABILITA_ORDINAMENTO_CAMPI
* 			RETURN
* 	    ENDIF
    
        WITH THIS
        	 
			_ALIAS=.PARENT.PARENT.RECORDSOURCE
			_ORDER=.PARENT.CONTROLSOURCE

			IF _ORDER='SELEZIONE'
				RETURN
			ENDIF
			
			_FLAG_SUBSTR = .F.
			LOCAL _I
			SELECT &_ALIAS
			AFIELDS(A_STRUTTURA_CAMPI)
			FOR _I = 1 TO ALEN(A_STRUTTURA_CAMPI,1)
				IF _ORDER = A_STRUTTURA_CAMPI(_I,1)
					IF (A_STRUTTURA_CAMPI(_I,2) = 'C' OR A_STRUTTURA_CAMPI(_I,2) = 'M') AND A_STRUTTURA_CAMPI(_I,3) > 100
						_FLAG_SUBSTR = .T.
						EXIT
					ENDIF
				ENDIF
			NEXT
			RELEASE A_STRUTTURA_CAMPI

			
			SELECT &_ALIAS
			IF .AlreadyOrdered
				DELETE TAG _TMPINDEX
			ENDIF
			
			IF !_FLAG_SUBSTR
				IF .OrderAscending
					INDEX ON &_ORDER TAG _TMPINDEX DESC
					.OrderAscending=.F.
				ELSE
					INDEX ON &_ORDER TAG _TMPINDEX 
					.OrderAscending=.T.
				ENDIF
			ELSE
				IF .OrderAscending
					INDEX ON SUBSTR(&_ORDER,1,100) TAG _TMPINDEX DESC
					.OrderAscending=.F.
				ELSE
					INDEX ON SUBSTR(&_ORDER,1,100) TAG _TMPINDEX 
					.OrderAscending=.T.
				ENDIF
			ENDIF
			
			SET ORDER TO _TMPINDEX
			.AlreadyOrdered=.T.
			.PARENT.PARENT.REFRESH()
		ENDWITH
	ENDPROC
    *- FINE Metodo: Click
    ***************************	

	***************************
	* Metodo 
	* Procedure DblClick
	***************************
	PROCEDURE DBLCLICK
        WITH THIS
            LOCAL lnOldArea, lcType, lcSource, llForceScan, lnFSize, lnHeaderSize, lnRecNo, llChanged, llAllowScan
            LOCAL lcFontName, lnFontSize, cFontStyle, lcFontName2, lnFontSize2, cFontStyle2, loControl, lcNullDisplay
            m.llChanged = .F.
            IF !EMPTY(.PARENT.CONTROLSOURCE)
                m.lnOldArea = SELECT(0)
                SELECT (.PARENT.PARENT.RECORDSOURCE)
                m.lcSource = .PARENT.CONTROLSOURCE
                m.lcType = TYPE(m.lcSource)
                IF ! (m.lcType $ 'GOPUS')
                    m.llForceScan = m.lcType == 'M'
                    IF !m.llForceScan
                        IF '.' $ m.lcSource AND ;
                                USED(LEFT(m.lcSource,AT('.',m.lcSource)-1))
                            m.lnFSize = FSIZE(SUBSTR(m.lcSource,AT('.',m.lcSource)+1),LEFT(m.lcSource,AT('.',m.lcSource)-1))
                            m.llForceScan = (m.lnFSize=0 OR m.lnFSize > 10) OR m.lcType$"YNIBF" && fields longer than 30 require scanning too, currency/integer/numeric field require scan anyway because a wide range
                        ELSE
                            m.llForceScan = .T.
                        ENDIF
                    ENDIF
                    WITH .PARENT
                        m.lcFontName = .FONTNAME
                        m.lnFontSize = .FONTSIZE
                        m.lcFontStyle = IIF(.FONTBOLD,"B","") + ;
                            IIF(.FONTITALIC,"I","") + ;
                            IIF(.FONTSTRIKETHRU,"-","") + ;
                            IIF(.FONTUNDERLINE,"U","")
                        m.lcNullDisplay = SET("NULLDISPLAY")
                        IF !EMPTY(.CURRENTCONTROL)
                            m.loControl = EVAL('.' + .CURRENTCONTROL)
                            IF TYPE("m.loControl.FontName")=="C"
                                m.lcFontName2 = m.loControl.FONTNAME
                                m.lnFontSize2 = m.loControl.FONTSIZE
                                m.lcFontStyle2 = IIF(m.loControl.FONTBOLD,"B","") + ;
                                    IIF(.FONTITALIC,"I","") + ;
                                    IIF(.FONTSTRIKETHRU,"-","") + ;
                                    IIF(.FONTUNDERLINE,"U","")
                                IF TXTWIDTH(REPLICATE("O",20), m.lcFontName, m.lnFontSize, m.lcFontStyle) < ;
                                        TXTWIDTH(REPLICATE("O",20), m.lcFontName2, m.lnFontSize2, m.lcFontStyle2)
                                    m.lcFontName = m.lcFontName2
                                    m.lnFontSize = m.lnFontSize2
                                    m.lcFontStyle = m.lcFontStyle2
                                    IF TYPE("m.loControl.NullDisplay") == "C"
                                        m.lcNullDisplay = IIF(EMPTY(m.loControl.NULLDISPLAY),SET("NULLDISPLAY"),m.loControl.NULLDISPLAY)
                                    ENDIF
                                ENDIF
                            ENDIF
                        ENDIF
                    ENDWITH
                    IF m.llForceScan
                        m.llAllowScan = .T.
                        IF INLIST(CURSORGETPROP('buffering'),2,3)
                            m.lcFldState = GETFLDSTATE(-1)
                            m.llAllowScan = !('2' $ m.lcFldState OR '3' $ m.lcFldState OR '4' $ m.lcFldState)
                        ENDIF
                        IF m.llAllowScan
                            m.lnHeaderSize = 0
                            m.lnRecNo = IIF(EOF(),0,RECNO())
                            IF !BOF()
                                SKIP -20
                            ENDIF
                            SCAN NEXT 40
                                IF .PARENT.INPUTMASK = ""
                                    m.lnHeaderSize = MAX(m.lnHeaderSize, ;
                                        CEILING((TXTWIDTH(NVL(ALLTRIM(TRANSFORM(EVAL(m.lcSource))),m.lcNullDisplay), ;
                                        m.lcFontName, m.lnFontSize, m.lcFontStyle)+1) * ;
                                        FONTMETRIC(6, m.lcFontName, m.lnFontSize, m.lcFontStyle)))
                                ELSE
                                    m.lnHeaderSize = MAX(m.lnHeaderSize, ;
                                        CEILING((TXTWIDTH(NVL(ALLTRIM(TRANSFORM(EVAL(m.lcSource),.PARENT.INPUTMASK)),m.lcNullDisplay), ;
                                        m.lcFontName, m.lnFontSize, m.lcFontStyle)+1) * ;
                                        FONTMETRIC(6, m.lcFontName, m.lnFontSize, m.lcFontStyle)))
                                ENDIF
                            ENDSCAN
                            IF m.lnRecNo=0
                                GO BOTTOM
                                IF !EOF()
                                    SKIP
                                ENDIF
                            ELSE
                                GO (m.lnRecNo)
                            ENDIF
                            m.llChanged = .T.
                        ENDIF
                    ELSE
                        DO CASE
                        CASE m.lcType = "D"
                            m.lnFSize = 10
                        CASE m.lcType = "T"
                            m.lnFSize = 20
                        ENDCASE
                        m.lnHeaderSize = TXTWIDTH(REPLICATE("0",m.lnFSize+1),m.lcFontName, m.lnFontSize, m.lcFontStyle) * ;
                            FONTMETRIC(6, m.lcFontName, m.lnFontSize, m.lcFontStyle)
                        m.llChanged = .T.
                    ENDIF
                    IF m.llChanged
                        m.lnHeaderSize = MAX(m.lnHeaderSize, ;
                            CEILING(TXTWIDTH(.CAPTION,.FONTNAME,.FONTSIZE,IIF(.FONTBOLD,"B","") + ;
                            IIF(.FONTITALIC,"I","") + ;
                            IIF(.FONTSTRIKETHRU,"-","") + ;
                            IIF(.FONTUNDERLINE,"U","")) * ;
                            FONTMETRIC(6, .FONTNAME,.FONTSIZE,IIF(.FONTBOLD,"B","") + ;
                            IIF(.FONTITALIC,"I","") + ;
                            IIF(.FONTSTRIKETHRU,"-","") + ;
                            IIF(.FONTUNDERLINE,"U","")) )+4)

                        .PARENT.WIDTH = MAX(m.lnHeaderSize,10)
                    ENDIF
                ENDIF
                SELECT (m.lnOldArea)
            ENDIF
            IF NOT m.llChanged
                .PARENT.WIDTH = MAX(.DefaultWidth,10)
            ELSE
                IF NOT(OBJTOCLIENT(THIS,3) = .PARENT.WIDTH) AND .PARENT.COLUMNORDER <> .PARENT.PARENT.LEFTCOLUMN
                    .PARENT.SETFOCUS
                ENDIF
                IF NOT(OBJTOCLIENT(THIS,3) = .PARENT.WIDTH) AND .PARENT.COLUMNORDER <> .PARENT.PARENT.LEFTCOLUMN
                    .PARENT.PARENT.DOSCROLL(5)
                ENDIF
            ENDIF
        ENDWITH
    ENDPROC
    *- FINE Metodo: DblClick
    ***************************
    
ENDDEFINE
*- FINE CLASSE Intestazione
**********************************************************



******************************************
PROCEDURE REPLACE_INTO_CURSOR
******************************************
LPARAMETERS _NOMECUR

IF PARAMETERS() < 1
   RETURN .F.
ENDIF

IF EMPTY(ALLTRIM(_NOMECUR))
   RETURN .F.
ENDIF

IF ' ' $ _NOMECUR
   RETURN .F.
ENDIF

SWS=SELECT()

SELECT &_NOMECUR
AFIELDS(_A_CURSORE)

FOR I = 1 TO ALEN(_A_CURSORE,1)
	_NOMECAMPO = ALLTRIM(_A_CURSORE[I,1])
	IF UPPER(_NOMECAMPO) == "ID_UNIQUE"
		LOOP
	ENDIF
	_NOMECAMPO_MEMVAR = "M." + _NOMECAMPO
	IF TYPE("_NOMECAMPO_MEMVAR") == "C"
	ELSE
		LOOP
	ENDIF
	REPLACE &_NOMECAMPO WITH &_NOMECAMPO_MEMVAR 
ENDFOR

SELECT(SWS)

RETURN

*****************************************************************************
PROCEDURE menurice
*****************************************************************************
PRIVATE _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric

_p_click 	= "ricerche\menurice"																			
_p_alias	= "cu_tbl_menu"																					
_p_campi	= "menu;label;comando"					
_p_testa	= "Nome menu;Voce menu;Comando"					
_p_tiporic	= "Nome menu,1,Nella voce menu,2,Nel comando,3"
_p_nomeric	= "Ricerca menu principali"																	

DO FORM form\ricerca WITH _p_click,_p_alias,_p_campi,_p_testa,_p_tiporic,_p_nomeric linked

RETURN


***********************************************************************  
* Procedura - predisponi_tbl_menu     Data: 16/01/2008   Autore: Project
***********************************************************************
*
*  PERMETTE LA PREDISPOSIZIONE DELLA TABELLA DBF TBL_MENU
*  PER VARIE OPZIONI PRIMA DEL CARICAMENTO DELLE VOCI DI MENU
*
***********************************************************************
PROCEDURE predisponi_tbl_menu
***********************************************************************
_RISP = MESSAGEBOX("Ignorare il caricamento delle abilitazioni utente?" + CHR(13) + CHR(13) + ;
                   "Rispondendo 'SI' verranno mantenute le varie" + CHR(13) + ;
                   "abilitazioni alle voci di menu per gli utenti già presenti sul sistema." + CHR(13) + CHR(13) + ;
                   "Rispondendo 'NO' verranno caricate anche le varie" + CHR(13) + ;
                   "abilitazioni alle voci di menu per gli utenti.",36,"Attenzione")
IF _RISP = 6
ELSE
   RETURN
ENDIF

IF FILE("TBL_MENU.DBF")
ELSE
   MESSAGEBOX("File TBL_MENU.DBF non trovato",16,"Attenzione")
   RETURN
ENDIF

cSql = "select * from TBL_MENU order by menu,ordine"
IF !ExecCommand(cSql,"CU_OLD_MENU")
  return(.f.)
ENDIF
SELECT CU_OLD_MENU
INDEX ON ALLTRIM(MENU) + ALLTRIM(LABEL) TAG I_INDEX

cSql = "select * from TBL_MENU where 1=0"
IF !ExecCommand(cSql,"CU_MENU_STA")
  return(.f.)
ENDIF
SELECT CU_MENU_STA
INDEX ON ALLTRIM(MENU) + ALLTRIM(STR(ORDINE,2,0)) TAG I_INDEX

* -->> Apro tabella FOX cambiando l'alias
* --------------------------------------------
USE TBL_MENU ALIAS CX_TBL_MENU IN 0 AGAIN

SELECT CX_TBL_MENU
GO TOP
SCAN
   _XX_MENU   = MENU
   _XX_LABEL  = LABEL
   _YY_UTENTI = ""
   SELECT CU_OLD_MENU
   SET ORDER TO I_INDEX
   GO TOP
   _SEEK = ALLTRIM(_XX_MENU) + ALLTRIM(_XX_LABEL)
   SEEK _SEEK
   IF FOUND()
      _YY_UTENTI = UTENTI
   ELSE
      _YY_UTENTI = "..SER."  && ERASMO - 22/01/2008
      SELECT CX_TBL_MENU
      SCATTER MEMVAR MEMO
      SELECT CU_MENU_STA
      APPEND BLANK
      REPLACE MENU WITH M.MENU
      REPLACE LABEL WITH M.LABEL
      REPLACE COMANDO WITH M.COMANDO
   ENDIF
   SELECT CX_TBL_MENU
   REPLACE UTENTI WITH _YY_UTENTI 
ENDSCAN

SELECT CU_MENU_STA
SET ORDER TO I_INDEX
GO TOP
IF EOF()
ELSE
   _RISP = MESSAGEBOX("Rilevate nuove voci di menu senza abilitazioni utente." + CHR(13) + CHR(13) + ;
                      "Stampa una lista per abilitare manualmente le nuove voci di menu?",36,"Attenzione")
   IF _RISP = 6
      V_REPORT = "menu_no_users.FRX"
      DO PRG\MENUSTA WITH "CU_MENU_STA",.T.,.T.,"XXX","&V_REPORT","&V_REPORT"
   ENDIF
ENDIF

SELECT CX_TBL_MENU
USE

RETURN


**************************************************************************************
* Procedura - Open_with_default_windows_program		Data: 18/09/2008   Autore: Project
**************************************************************************************
*
*  Consente di aprire ogni tipo di file conosciuto dal sistema in windows 
*  tramite il programma predefinito
*
**************************************************************************************
PROCEDURE Open_with_default_windows_program
**************************************************************************************
PARAMETER _full_path

IF PARAMETERS() = 0
   RETURN .F.
ENDIF

lcFile = _full_path
IF FILE(lcFile)
ELSE
   MESSAGEBOX("Nome file o percorso non corretto",16,"Attenzione")
   RETURN .F.
ENDIF

IF EMPTY(lcFile)
   MESSAGEBOX("Parametro Nome file vuoto",16,"Attenzione")
   RETURN .F.
ENDIF

DECLARE INTEGER ShellExecute IN shell32.dll ; 
  INTEGER hndWin, ; 
  STRING cAction, ; 
  STRING cFileName, ; 
  STRING cParams, ;  
  STRING cDir, ; 
  INTEGER nShowWin

cAction = "open" 
WAIT WINDOWS "Apertura in corso..." nowait
TRY
	ShellExecute(0,cAction,lcFile,0,0,1)
CATCH
	WAIT WINDOWS "Apertura impossibile" nowait
ENDTRY


RETURN




***********************************************************
* SOSTITUISCE UN APICE (ACCENTO) CON UNA LETTERA ACCENTATA ED
* UN APICE (APOSTROFO) CON UN ACCENTO
***********************************************************
PROCEDURE APITOSPA
***********************************************************

PARA _STRINGA

RELEASE XXX_STRINGA,XXX_LUNG,XXX_NUOVA
PUBLIC  XXX_STRINGA,XXX_LUNG,XXX_NUOVA

XXX_STRINGA = _STRINGA
XXX_LUNG    = LEN(XXX_STRINGA)
XXX_NUOVA   = ""

RELEASE __I
LOCAL __I

FOR __I=1 TO XXX_LUNG
   
   IF SUBSTR(XXX_STRINGA,__I,1) = "'"
      X_ACCENTO = .F.
      IF SUBSTR(XXX_STRINGA,__I-1,1) = "A" .OR. SUBSTR(XXX_STRINGA,__I-1,1) = "a"
         XXX_LETTERA = 'à'
         X_ACCENTO   = .T.
      ENDIF
      IF SUBSTR(XXX_STRINGA,__I-1,1) = "E" .OR. SUBSTR(XXX_STRINGA,__I-1,1) = "e"
         XXX_LETTERA = 'è'
         X_ACCENTO   = .T.
      ENDIF
      IF SUBSTR(XXX_STRINGA,__I-1,1) = "I" .OR. SUBSTR(XXX_STRINGA,__I-1,1) = "i"
         XXX_LETTERA = 'ì'
         X_ACCENTO   = .T.
      ENDIF
      IF SUBSTR(XXX_STRINGA,__I-1,1) = "O" .OR. SUBSTR(XXX_STRINGA,__I-1,1) = "o"
         XXX_LETTERA = 'ò'
         X_ACCENTO   = .T.
      ENDIF
      IF SUBSTR(XXX_STRINGA,__I-1,1) = "U" .OR. SUBSTR(XXX_STRINGA,__I-1,1) = "u"
         XXX_LETTERA = 'ù'
         X_ACCENTO   = .T.
      ENDIF
      IF X_ACCENTO
         XXX_LETTERA = UPPER(XXX_LETTERA)
         XXX_LEN     = LEN(XXX_NUOVA) - 1
         XXX_NUOVA   = SUBSTR(XXX_NUOVA,1,XXX_LEN) + XXX_LETTERA
      ELSE
         *XXX_NUOVA = XXX_NUOVA + "''"
         **=> ERASMO - INIZIO 18/04/2008
         XXX_NUOVA = XXX_NUOVA + "`"
         **=> ERASMO - FINE 18/04/2008
      ENDIF
   ELSE
      XXX_NUOVA = XXX_NUOVA + SUBSTR(XXX_STRINGA,__I,1)
   ENDIF
      
ENDFOR

RETURN XXX_NUOVA


***************************************************************************
* Funzione - pj_inputbox                 Data: 15/05/2009   Autore: Project
***************************************************************************
*
*  Consente di digitare un valore testuale similmente alla funzione Fox INPUTBOX()
*  
*  Es.:
*
*  _NEW_EMAIL = PJ_INPUTBOX("Digitare il valore:","Titolo","testo di default")
*
*
*  La funzione restituisce la stringa inserita
*
***********************************************************************
FUNCTION pj_inputbox
***********************************************************************

PARAMETERS _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE

IF PARAMETERS() < 1 .OR. TYPE("_CINPUTPROMPT") <> 'C'
   _CINPUTPROMPT = "Digitare il valore"
ENDIF

IF PARAMETERS() < 2 .OR. TYPE("_CDIALOGCAPTION") <> 'C'
   _CDIALOGCAPTION = "Aquarius"
ENDIF

IF PARAMETERS() < 3 .OR. TYPE("_CDEFAULTVALUE") <> 'C'
   _CDEFAULTVALUE = ""
ELSE
   _CDEFAULTVALUE = RTRIM(_CDEFAULTVALUE)
ENDIF

_CRETURN = _CDEFAULTVALUE 

DO FORM FORM\PJ_INPUTBOX WITH _CINPUTPROMPT,_CDIALOGCAPTION,_CDEFAULTVALUE 

RETURN(_CRETURN)



*********************************************************************************
* Funzione - SetResolutionBackground Data: 01/09/2010   Autore: Project
*********************************************************************************
*
* Consente di settare lo sfondo della finestra principale di Aquarius nella
* risoluzione ideale previa esistenza del file con nome precisamente identificato
*
*********************************************************************************
FUNCTION SetResolutionBackground
*********************************************************************************

PARAMETERS _defa_filename

IF PARAMETERS() < 1
	RETURN ""
ENDIF

_defa_filename = ALLTRIM(_defa_filename)
_defa_fileext = ALLTRIM(SUBSTR(_defa_filename,RAT('.',_defa_filename,1)))  && ERASMO - 19/10/2012
_x_resolution = ALLTRIM(STR(SYSMETRIC(1))) + 'X' + ALLTRIM(STR(SYSMETRIC(2)))
*_radice_nomefile = SUBSTR(_defa_filename,1,LEN(_defa_filename)-4)
_radice_nomefile = STRTRAN(_defa_filename,_defa_fileext,"")  && ERASMO - 19/10/2012
*_x_nomefile = _radice_nomefile + '_' + _x_resolution + ".JPG"
_x_nomefile = _radice_nomefile + '_' + _x_resolution + _defa_fileext  && ERASMO - 19/10/2012

*!*	IF FILE(_x_nomefile)
*!*		_SCREEN.Picture = _x_nomefile
*!*	ENDIF

RETURN _x_nomefile  && ERASMO - 19/10/2012

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

************************************************************************
PROCEDURE X_AZI_AN
***********************************************************************
REPLACE AZI_CODSOC WITH M.AZI_CODSOC
REPLACE AZI_CODCLI WITH M.AZI_CODCLI
REPLACE AZI_RAGSOC WITH M.AZI_RAGSOC
REPLACE AZI_INDIRI WITH M.AZI_INDIRI
REPLACE AZI_LOCALI WITH M.AZI_LOCALI
REPLACE AZI_CAP    WITH M.AZI_CAP
REPLACE AZI_TELEFO WITH M.AZI_TELEFO
REPLACE AZI_FAX    WITH M.AZI_FAX
REPLACE AZI_PIVA   WITH M.AZI_PIVA
REPLACE AZI_IVACEE WITH M.AZI_IVACEE
REPLACE AZI_CODFIS WITH M.AZI_CODFIS
REPLACE AZI_CONDCO WITH M.AZI_CONDCO
REPLACE AZI_MODTRA WITH M.AZI_MODTRA
REPLACE AZI_PAEORI WITH M.AZI_PAEORI
REPLACE AZI_IVACLI WITH M.AZI_IVACLI
REPLACE AZI_FABBR  WITH M.AZI_FABBR
REPLACE AZI_LIBERA WITH M.AZI_LIBERA
REPLACE AZI_PAGCLI WITH M.AZI_PAGCLI
REPLACE AZI_PROTCL WITH M.AZI_PROTCL
REPLACE AZI_ESECLI WITH M.AZI_ESECLI
REPLACE AZI_IVAFOR WITH M.AZI_IVAFOR
REPLACE AZI_PAGFOR WITH M.AZI_PAGFOR
REPLACE AZI_PROTFO WITH M.AZI_PROTFO
REPLACE AZI_ESEFOR WITH M.AZI_ESEFOR
REPLACE AZI_CORRIS WITH M.AZI_CORRIS
REPLACE AZI_PAGCOR WITH M.AZI_PAGCOR
REPLACE AZI_ESECOR WITH M.AZI_ESECOR
REPLACE AZI_LIBGIO WITH M.AZI_LIBGIO
REPLACE AZI_PAGLIB WITH M.AZI_PAGLIB
REPLACE AZI_ESELIB WITH M.AZI_ESELIB
REPLACE AZI_NUMRE  WITH M.AZI_NUMRE
REPLACE AZI_NFAGE  WITH M.AZI_NFAGE
REPLACE AZI_PROTCO WITH M.AZI_PROTCO
REPLACE AZI_NATURA WITH M.AZI_NATURA
REPLACE AZI_VAL01  WITH M.AZI_VAL01
REPLACE AZI_VAL02  WITH M.AZI_VAL02
REPLACE AZI_VAL03  WITH M.AZI_VAL03
REPLACE AZI_VAL04  WITH M.AZI_VAL04
REPLACE AZI_VAL05  WITH M.AZI_VAL05
REPLACE AZI_VAL06  WITH M.AZI_VAL06
REPLACE AZI_VAL07  WITH M.AZI_VAL07
REPLACE AZI_VAL08  WITH M.AZI_VAL08
REPLACE AZI_VAL09  WITH M.AZI_VAL09
REPLACE AZI_VAL10  WITH M.AZI_VAL10
REPLACE AZI_VAL11  WITH M.AZI_VAL11
REPLACE AZI_VAL12  WITH M.AZI_VAL12
REPLACE AZI_VAL13  WITH M.AZI_VAL13
REPLACE AZI_VAL14  WITH M.AZI_VAL14
REPLACE AZI_VAL15  WITH M.AZI_VAL15
REPLACE AZI_VAL16  WITH M.AZI_VAL16
REPLACE AZI_VAL17  WITH M.AZI_VAL17
REPLACE AZI_VAL18  WITH M.AZI_VAL18
REPLACE AZI_VAL19  WITH M.AZI_VAL19
REPLACE AZI_VAL20  WITH M.AZI_VAL20
REPLACE AZI_BOLLA  WITH M.AZI_BOLLA
REPLACE AZI_FAPRO  WITH M.AZI_FAPRO
REPLACE AZI_ORDIN  WITH M.AZI_ORDIN
REPLACE AZI_FATTU  WITH M.AZI_FATTU
REPLACE AZI_EFFE   WITH M.AZI_EFFE
REPLACE AZI_ORFO   WITH M.AZI_ORFO
REPLACE AZI_OFFE   WITH M.AZI_OFFE
REPLACE AZI_COMM   WITH M.AZI_COMM
REPLACE AZI_CTLO   WITH M.AZI_CTLO
REPLACE AZI_SAU    WITH M.AZI_SAU
REPLACE AZI_CODM   WITH M.AZI_CODM
REPLACE AZI_TLIN   WITH M.AZI_TLIN
REPLACE AZI_INTOFF WITH M.AZI_INTOFF
REPLACE AZI_PIEOFF WITH M.AZI_PIEOFF
REPLACE AZI_INTORD WITH M.AZI_INTORD
REPLACE AZI_PIEORD WITH M.AZI_PIEORD
REPLACE AZI_INTORF WITH M.AZI_INTORF
REPLACE AZI_PIEORF WITH M.AZI_PIEORF
REPLACE AZI_INTBOL WITH M.AZI_INTBOL
REPLACE AZI_PIEBOL WITH M.AZI_PIEBOL
REPLACE AZI_INTFAP WITH M.AZI_INTFAP
REPLACE AZI_PIEFAP WITH M.AZI_PIEFAP
REPLACE AZI_INTFAT WITH M.AZI_INTFAT
REPLACE AZI_PIEFAT WITH M.AZI_PIEFAT
REPLACE AZI_ARTPUB WITH M.AZI_ARTPUB
REPLACE AZI_INTRA1 WITH M.AZI_INTRA1
REPLACE AZI_INTRA2 WITH M.AZI_INTRA2
REPLACE AZI_REGIMP WITH M.AZI_REGIMP
REPLACE AZI_NUMISC WITH M.AZI_NUMISC
REPLACE AZI_CSIVER WITH M.AZI_CSIVER
REPLACE AZI_REA    WITH M.AZI_REA
REPLACE AZI_REANUM WITH M.AZI_REANUM
REPLACE AZI_NOSC   WITH M.AZI_NOSC
REPLACE AZI_SKART  WITH M.AZI_SKART
REPLACE AZI_RISOLU WITH M.AZI_RISOLU
REPLACE AZI_IVA    WITH M.AZI_IVA
REPLACE AZI_UM     WITH M.AZI_UM
REPLACE AZI_VERYD  WITH M.AZI_VERYD
REPLACE AZI_SPINC  WITH M.AZI_SPINC
REPLACE AZI_SCAFA  WITH M.AZI_SCAFA
REPLACE AZI_CFDEF  WITH M.AZI_CFDEF
REPLACE AZI_NBOIE  WITH M.AZI_NBOIE
REPLACE AZI_NFANC  WITH M.AZI_NFANC
REPLACE AZI_LIS01  WITH M.AZI_LIS01
REPLACE AZI_LIS02  WITH M.AZI_LIS02
REPLACE AZI_LIS03  WITH M.AZI_LIS03
REPLACE AZI_LIS04  WITH M.AZI_LIS04
REPLACE AZI_LIS05  WITH M.AZI_LIS05
REPLACE AZI_LIS06  WITH M.AZI_LIS06
REPLACE AZI_LIS07  WITH M.AZI_LIS07
REPLACE AZI_LIS08  WITH M.AZI_LIS08
REPLACE AZI_LIS09  WITH M.AZI_LIS09
REPLACE AZI_LIS0A  WITH M.AZI_LIS0A
REPLACE AZI_LINEA  WITH M.AZI_LINEA
REPLACE AZI_CPA    WITH M.AZI_CPA
REPLACE AZI_AGE    WITH M.AZI_AGE
REPLACE AZI_VALU   WITH M.AZI_VALU
REPLACE AZI_NAZI   WITH M.AZI_NAZI
REPLACE AZI_NCR    WITH M.AZI_NCR
REPLACE AZI_STFAD  WITH M.AZI_STFAD
REPLACE AZI_FAMTU  WITH M.AZI_FAMTU
REPLACE AZI_CARFA  WITH M.AZI_CARFA
REPLACE AZI_ESIVA  WITH M.AZI_ESIVA
REPLACE AZI_TFPER  WITH M.AZI_TFPER
REPLACE AZI_NORD   WITH M.AZI_NORD
REPLACE AZI_TFTOP  WITH M.AZI_TFTOP
REPLACE AZI_COMCEE WITH M.AZI_COMCEE
REPLACE AZI_PROTCE WITH M.AZI_PROTCE
REPLACE AZI_PREZZI WITH M.AZI_PREZZI
REPLACE AZI_IMPEGN WITH M.AZI_IMPEGN
REPLACE AZI_NBOBA  WITH M.AZI_NBOBA
REPLACE AZI_CTRGIA WITH M.AZI_CTRGIA
REPLACE AZI_CTRORF WITH M.AZI_CTRORF
REPLACE AZI_CADEF  WITH M.AZI_CADEF
REPLACE AZI_WEBRCF WITH M.AZI_WEBRCF
REPLACE AZI_WEBRCD WITH M.AZI_WEBRCD
REPLACE AZI_WEBTRF WITH M.AZI_WEBTRF
REPLACE AZI_WEBTRD WITH M.AZI_WEBTRD
REPLACE AZI_STFAT  WITH M.AZI_STFAT
REPLACE AZI_STFAP  WITH M.AZI_STFAP
REPLACE AZI_FATTR  WITH M.AZI_FATTR
REPLACE AZI_MLPLTU WITH M.AZI_MLPLTU
REPLACE AZI_MLPLDT WITH M.AZI_MLPLDT
REPLACE AZI_MLEBDT WITH M.AZI_MLEBDT
REPLACE AZI_CLIDIR WITH M.AZI_CLIDIR
REPLACE AZI_CAUDIR WITH M.AZI_CAUDIR
REPLACE AZI_RATES1 WITH M.AZI_RATES1
REPLACE AZI_RATES2 WITH M.AZI_RATES2
REPLACE AZI_RADET1 WITH M.AZI_RADET1
REPLACE AZI_RADET2 WITH M.AZI_RADET2
REPLACE AZI_RADET3 WITH M.AZI_RADET3
REPLACE AZI_RADET4 WITH M.AZI_RADET4
REPLACE AZI_RADET5 WITH M.AZI_RADET5
REPLACE AZZ_RATES1 WITH M.AZZ_RATES1
REPLACE AZZ_RATES2 WITH M.AZZ_RATES2
REPLACE AZZ_RADET1 WITH M.AZZ_RADET1
REPLACE AZZ_RADET2 WITH M.AZZ_RADET2
REPLACE AZZ_RADET3 WITH M.AZZ_RADET3
REPLACE AZZ_RADET4 WITH M.AZZ_RADET4
REPLACE AZZ_RADET5 WITH M.AZZ_RADET5
REPLACE AZZ_REGIMP WITH M.AZZ_REGIMP
REPLACE AZZ_NUMISC WITH M.AZZ_NUMISC
REPLACE AZZ_CSIVER WITH M.AZZ_CSIVER
REPLACE AZZ_REA    WITH M.AZZ_REA
REPLACE AZZ_REANUM WITH M.AZZ_REANUM
REPLACE AZI_NOSOL  WITH M.AZI_NOSOL
REPLACE AZI_AACDAL WITH M.AZI_AACDAL
REPLACE AZI_AACAL  WITH M.AZI_AACAL
REPLACE AZI_QTAORF WITH M.AZI_QTAORF
REPLACE AZI_MAGLOG WITH M.AZI_MAGLOG
REPLACE AZI_PROGAA WITH M.AZI_PROGAA
REPLACE AZI_NOSPOO WITH M.AZI_NOSPOO
REPLACE AZI_PROVVI WITH M.AZI_PROVVI
REPLACE AZI_SC1    WITH M.AZI_SC1
REPLACE AZI_SC2    WITH M.AZI_SC2
REPLACE AZI_SC3    WITH M.AZI_SC3
REPLACE AZI_CERTIF WITH M.AZI_CERTIF
REPLACE AZI_FORMAR WITH M.AZI_FORMAR
REPLACE AZI_MESERR WITH M.AZI_MESERR
REPLACE AZI_PAGANT WITH M.AZI_PAGANT
REPLACE AZI_CAUANT WITH M.AZI_CAUANT
REPLACE AZI_CAUAVA WITH M.AZI_CAUAVA
REPLACE AZI_CAUSAL WITH M.AZI_CAUSAL
REPLACE AZI_COMSEM WITH M.AZI_COMSEM
REPLACE AZI_CPAINC WITH M.AZI_CPAINC
REPLACE AZI_ARTINC WITH M.AZI_ARTINC
REPLACE AZI_CAUCFO WITH M.AZI_CAUCFO
REPLACE AZI_CAUCSP WITH M.AZI_CAUCSP
REPLACE AZI_CAUSSP WITH M.AZI_CAUSSP
REPLACE AZI_CAUSFA WITH M.AZI_CAUSFA
REPLACE AZI_CAULES WITH M.AZI_CAULES
REPLACE AZI_OREGIO WITH M.AZI_OREGIO
REPLACE AZI_CAUCMA WITH M.AZI_CAUCMA
REPLACE AZI_BFO    WITH M.AZI_BFO
REPLACE AZI_BOLFOR WITH M.AZI_BOLFOR
REPLACE AZI_CTRLBF WITH M.AZI_CTRLBF
REPLACE AZI_CODBUN WITH M.AZI_CODBUN
REPLACE AZI_CTRTAG WITH M.AZI_CTRTAG
REPLACE AZI_CTRCOL WITH M.AZI_CTRCOL
REPLACE AZI_CATACO WITH M.AZI_CATACO
REPLACE AZI_MLDOCA WITH M.AZI_MLDOCA
REPLACE AZI_ARTRES WITH M.AZI_ARTRES
REPLACE AZI_CAURIF WITH M.AZI_CAURIF
REPLACE AZI_CAUREC WITH M.AZI_CAUREC
REPLACE AZI_CAUCAS WITH M.AZI_CAUCAS
REPLACE AZI_CODCAS WITH M.AZI_CODCAS
REPLACE AZI_MASTRO WITH M.AZI_MASTRO
REPLACE AZI_SOTTOG WITH M.AZI_SOTTOG
REPLACE AZI_VISRIC WITH M.AZI_VISRIC
REPLACE AZI_DDTRIC WITH M.AZI_DDTRIC
REPLACE AZI_CAUREF WITH M.AZI_CAUREF
REPLACE AZI_GESEDI WITH M.AZI_GESEDI
REPLACE AZI_CONTO  WITH M.AZI_CONTO
REPLACE AZI_CAUPDV WITH M.AZI_CAUPDV
REPLACE AZI_NUMLOT WITH M.AZI_NUMLOT
REPLACE AZI_EAISBN WITH M.AZI_EAISBN
REPLACE AZI_TIPCAS WITH M.AZI_TIPCAS
REPLACE AZI_FTPROT WITH M.AZI_FTPROT
REPLACE AZI_VISRID WITH M.AZI_VISRID
REPLACE AZI_ARTABB WITH M.AZI_ARTABB
REPLACE AZI_FTPRIC WITH M.AZI_FTPRIC
REPLACE AZI_CAUTRA WITH M.AZI_CAUTRA
REPLACE AZI_GIAADF WITH M.AZI_GIAADF
REPLACE AZI_FORPRE WITH M.AZI_FORPRE
REPLACE AZI_RESCLI WITH M.AZI_RESCLI
REPLACE AZI_TIPCON WITH M.AZI_TIPCON
REPLACE AZI_PRZBAS WITH M.AZI_PRZBAS
REPLACE AZI_DATOLD WITH M.AZI_DATOLD
REPLACE AZI_CAMCOS WITH M.AZI_CAMCOS
REPLACE AZI_MULTIANNO WITH M.AZI_MULTIA
REPLACE azi_nfatdifferita WITH m.azi_nfatdi
REPLACE AZI_CAUSOS WITH M.AZI_CAUSOS
REPLACE AZI_RICONF WITH M.AZI_RICONF
REPLACE AZI_DECQTA WITH M.AZI_DECQTA
REPLACE AZI_DECPRZ WITH M.AZI_DECPRZ
REPLACE AZI_DECVAL WITH M.AZI_DECVAL
REPLACE AZI_COSATRATTA			WITH M.AZI_COSATR
REPLACE AZI_GRADOIMPORTANZA		WITH M.AZI_GRADOI
REPLACE AZI_FORMAPAGAMENTO		WITH M.AZI_FORMAP
REPLACE AZI_TIPOCONTRATTO		WITH M.AZI_TIPOCO
REPLACE AZI_CONAQUISTO			WITH M.AZI_CONAQU

REPLACE AZI_CARORF WITH M.AZI_CARORF
REPLACE AZI_CQUMPC WITH M.AZI_CQUMPC
REPLACE AZI_CQUMPN WITH M.AZI_CQUMPN
REPLACE AZI_SPAPRO WITH M.AZI_SPAPRO
REPLACE AZI_SPAMPR WITH M.AZI_SPAMPR
REPLACE AZI_SPACQS WITH M.AZI_SPACQS
REPLACE AZI_CQUSLC WITH M.AZI_CQUSLC
REPLACE AZI_CQUSLN WITH M.AZI_CQUSLN
REPLACE AZI_RIBPRO WITH M.AZI_RIBPRO
REPLACE AZI_RIBSLR WITH M.AZI_RIBSLR
REPLACE AZI_RIBSLO WITH M.AZI_RIBSLO
REPLACE AZI_TAGPRO WITH M.AZI_TAGPRO
REPLACE AZI_TAGSLR WITH M.AZI_TAGSLR
REPLACE AZI_TAGPFO WITH M.AZI_TAGPFO
REPLACE AZI_ALTLUN WITH M.AZI_ALTLUN

RETURN

************************************************************************
PROCEDURE X_FOR_AN
***********************************************************************
REPLACE FOR_CODSOC WITH M.FOR_CODSOC
REPLACE FOR_CODCLI WITH M.FOR_CODCLI
REPLACE FOR_CLICEE WITH M.FOR_CLICEE
REPLACE FOR_PARIVA WITH M.FOR_PARIVA
REPLACE FOR_IVACEE WITH M.FOR_IVACEE
REPLACE FOR_CODFIS WITH M.FOR_CODFIS
REPLACE FOR_RAGSOC WITH M.FOR_RAGSOC
REPLACE FOR_PF     WITH M.FOR_PF
REPLACE FOR_RAGDUE WITH M.FOR_RAGDUE
REPLACE FOR_INDIR  WITH M.FOR_INDIR
REPLACE FOR_CAP    WITH M.FOR_CAP
REPLACE FOR_LOCALI WITH M.FOR_LOCALI
REPLACE FOR_NAZION WITH M.FOR_NAZION
REPLACE FOR_VALUTA WITH M.FOR_VALUTA
REPLACE FOR_ZONA   WITH M.FOR_ZONA
REPLACE FOR_TELEFO WITH M.FOR_TELEFO
REPLACE FOR_FAX    WITH M.FOR_FAX
REPLACE FOR_TELEX  WITH M.FOR_TELEX
REPLACE FOR_CONPAG WITH M.FOR_CONPAG
REPLACE FOR_BAE    WITH M.FOR_BAE
REPLACE FOR_BPF    WITH M.FOR_BPF
REPLACE FOR_INDEFF WITH M.FOR_INDEFF
REPLACE FOR_CODIVA WITH M.FOR_CODIVA
REPLACE FOR_NOTE   WITH M.FOR_NOTE
REPLACE FOR_CONTO1 WITH M.FOR_CONTO1
REPLACE FOR_CONTO2 WITH M.FOR_CONTO2
REPLACE FOR_CONTO3 WITH M.FOR_CONTO3
REPLACE FOR_CONTO4 WITH M.FOR_CONTO4
REPLACE FOR_CONTO5 WITH M.FOR_CONTO5
REPLACE SELEZIONE  WITH M.SELEZIONE
REPLACE FOR_RICERC WITH M.FOR_RICERC
REPLACE FOR_ABICAB WITH M.FOR_ABICAB
REPLACE FOR_NUMCOC WITH M.FOR_NUMCOC
REPLACE FOR_CODRAC WITH M.FOR_CODRAC
REPLACE FOR_RIFERI WITH M.FOR_RIFERI
REPLACE FOR_CIRPEF WITH M.FOR_CIRPEF
REPLACE FOR_PERCCO WITH M.FOR_PERCCO
REPLACE FOR_PERCPR WITH M.FOR_PERCPR
REPLACE FOR_TETMAX WITH M.FOR_TETMAX
REPLACE FOR_PERCPA WITH M.FOR_PERCPA
REPLACE FOR_EMAIL  WITH M.FOR_EMAIL
REPLACE FOR_LUNASC WITH M.FOR_LUNASC
=CAMBIADT(M.FOR_DTNASC,"FOR_DTNASC")
REPLACE FOR_CONTRO WITH M.FOR_CONTRO
REPLACE FOR_PROVIN WITH M.FOR_PROVIN
REPLACE FOR_TRASME WITH M.FOR_TRASME
=CAMBIADT(M.FOR_DATINS,"FOR_DATINS")
=CAMBIADT(M.FOR_DATNEW,"FOR_DATNEW")
REPLACE FOR_CODCON WITH M.FOR_CODCON
REPLACE FOR_FLGTRA WITH M.FOR_FLGTRA
REPLACE FOR_GGFORN WITH M.FOR_GGFORN
REPLACE FOR_CODCHE WITH M.FOR_CODCHE
REPLACE FOR_CODCIN WITH M.FOR_CODCIN
REPLACE FOR_CODABI WITH M.FOR_CODABI
REPLACE FOR_CODCAB WITH M.FOR_CODCAB
REPLACE FOR_CDIBAN WITH M.FOR_CDIBAN
REPLACE FOR_CODACQ WITH M.FOR_CODACQ
REPLACE FOR_DESACQ WITH M.FOR_DESACQ
REPLACE FOR_COSATRATTA			WITH M.FOR_COSATR
REPLACE FOR_GRADOIMPORTANZA		WITH M.FOR_GRADOI
REPLACE FOR_FORMAPAGAMENTO		WITH M.FOR_FORMAP
REPLACE FOR_TIPOCONTRATTO		WITH M.FOR_TIPOCO
REPLACE FOR_PRIPAGA				WITH M.FOR_PRIPAG

RETURN



************************************************************************
PROCEDURE U_AZI_PA
***********************************************************************
REPLACE AZI_CODSOC  WITH PUB_CODSOC
REPLACE AZI_VMAGAZ  WITH M.AZI_VMAGAZ
REPLACE AZI_VARTIC  WITH M.AZI_VARTIC
REPLACE AZI_VMAGPE  WITH M.AZI_VMAGPE
REPLACE AZI_VMAGAR  WITH M.AZI_VMAGAR
REPLACE AZI_VMARPE  WITH M.AZI_VMARPE
REPLACE AZI_VFOMAR  WITH M.AZI_VFOMAR
REPLACE AZI_VFOMAP  WITH M.AZI_VFOMAP
REPLACE AZI_VFORNI  WITH M.AZI_VFORNI
REPLACE AZI_VMAGTC  WITH M.AZI_VMAGTC
REPLACE AZI_VMATCH  WITH M.AZI_VMATCH 
REPLACE AZI_VAMFTC  WITH M.AZI_VAMFTC 
REPLACE AZI_POLIEC  WITH M.AZI_POLIEC 
REPLACE AZI_CDAIMB  WITH M.AZI_CDAIMB 
REPLACE AZI_FISCALE WITH M.AZI_FISCALE
REPLACE AZI_DATSYS  WITH M.AZI_DATSYS 
REPLACE AZI_NOTCEE  WITH M.AZI_NOTCEE  
REPLACE AZI_TOPINV  WITH M.AZI_TOPINV  
REPLACE AZI_IVANAG  WITH M.AZI_IVANAG
REPLACE AZI_FATRC   WITH M.AZI_FATRC
REPLACE AZI_NOTRC   WITH M.AZI_NOTRC
REPLACE AZI_PRGPRD  WITH M.AZI_PRGPRD
REPLACE AZI_SISCUR  WITH M.AZI_SISCUR
REPLACE AZI_CODREC  WITH M.AZI_CODREC
REPLACE AZI_LIS11   WITH M.AZI_LIS11
REPLACE AZI_STIPE   WITH M.AZI_STIPE
REPLACE AZI_INCCLI  WITH M.AZI_INCCLI
REPLACE AZI_EFFPAS  WITH M.AZI_EFFPAS
REPLACE AZI_EFFATT  WITH M.AZI_EFFATT
REPLACE AZI_CONTR   WITH M.AZI_CONTR
REPLACE AZI_LEASIN  WITH M.AZI_LEASIN
REPLACE AZI_FINAN   WITH M.AZI_FINAN
REPLACE AZI_COMCLI  WITH M.AZI_COMCLI
REPLACE AZI_COMFOR  WITH M.AZI_COMFOR
REPLACE AZI_DARE    WITH M.AZI_DARE
REPLACE AZI_AVERE   WITH M.AZI_AVERE
REPLACE AZI_MOVLOG  WITH M.AZI_MOVLOG
REPLACE AZI_ANTRIB	WITH M.AZI_ANTRIB
REPLACE AZI_USATES 	WITH M.AZI_USATES    
REPLACE AZI_NRSEBF  WITH M.AZI_NRSEBF	
REPLACE AZI_PROTFA  WITH M.AZI_PROTFA   
REPLACE AZI_AGGPRO  WITH M.AZI_AGGPRO   
REPLACE AZI_PROTCI  WITH M.AZI_PROTCI     
REPLACE AZI_NRSEBC  WITH M.AZI_NRSEBC	
REPLACE AZI_RRIFOR	WITH M.AZI_RRIFOR
REPLACE AZI_CCOSTD  WITH M.AZI_CCOSTD	
REPLACE AZI_CCOACLI WITH M.AZI_CCOACLI	
REPLACE AZI_CCOAART WITH M.AZI_CCOAART 	
REPLACE AZI_CCOPDC  WITH M.AZI_CCOPDC  	
REPLACE AZI_CCOCLI  WITH M.AZI_CCOCLI 
REPLACE AZI_CCOFOR  WITH M.AZI_CCOFOR	
REPLACE AZI_MAGNO0  WITH M.AZI_MAGNO0	
REPLACE AZI_TOPCAM  WITH M.AZI_TOPCAM	
REPLACE AZI_BENDUR  WITH M.AZI_BENDUR	&& PROJECT 04/08/2006
REPLACE AZI_FATRIA  WITH M.AZI_FATRIA	&& SERGIO 01/04/2007
REPLACE AZI_NUCOCG  WITH M.AZI_NUCOCG	&& SERGIO 01/04/2007
REPLACE AZI_NUCOAQ  WITH M.AZI_NUCOAQ	&& SERGIO 01/04/2007
REPLACE AZI_NUCOAS  WITH M.AZI_NUCOAS	&& SERGIO 01/04/2007
REPLACE AZI_NUCOOK  WITH M.AZI_NUCOOK	&& SERGIO 01/04/2007
REPLACE AZI_CLIRIC  WITH M.AZI_CLIRIC   && ERASMO 13/04/2007
REPLACE AZI_CARFOR  WITH M.AZI_CARFOR   && sergio 15/04/2007
REPLACE AZI_SDBSIG  WITH M.AZI_SDBSIG   && SERGIO 01/07/2007
REPLACE AZI_SDBNOG  WITH M.AZI_SDBNOG   && SERGIO 01/07/2007
REPLACE AZI_CDBSIG  WITH M.AZI_CDBSIG   && SERGIO 01/07/2007
REPLACE AZI_CDBNOG  WITH M.AZI_CDBNOG   && SERGIO 01/07/2007
REPLACE AZI_IDSOCI  WITH M.AZI_IDSOCI	&& SERGIO 14/10/2007
REPLACE AZI_CEEUNO  WITH M.AZI_CEEUNO	&& SERGIO 14/01/2008
REPLACE AZI_PRENOT  WITH M.AZI_PRENOT	&& ERASMO 12/05/2008
REPLACE AZI_ORDINT  WITH M.AZI_ORDINT 	&& FABIANO 02/06/2008
REPLACE AZI_FABBIS  WITH M.AZI_FABBIS 	&& FABIANO 02/06/2008
REPLACE AZI_PRSSTD  WITH M.AZI_PRSSTD	&& SERGIO 02/08/2008
REPLACE AZI_PRDFILM WITH M.AZI_PRDFILM	&& SERGIO 02/08/2008
REPLACE AZI_PRMMOL  WITH M.AZI_PRMMOL	&& SERGIO 02/08/2008
REPLACE AZI_PRTTES  WITH M.AZI_PRTTES	&& SERGIO 02/08/2008
REPLACE AZI_ECORIS  WITH M.AZI_ECORIS	&& SERGIO 19/08/2008
REPLACE AZI_SPASCA  WITH M.AZI_SPASCA	&& SIMONE 25/02/2009
REPLACE AZI_LOGBOL	WITH M.AZI_LOGBOL	&& ERASMO - 02/11/2009
REPLACE AZI_TAGAGE	WITH M.AZI_TAGAGE	&& ERASMO - 06/11/2010
REPLACE AZI_CAUMOV	WITH M.AZI_CAUMOV	&& ERASMO - 17/09/2010
REPLACE AZI_PRSSTD  WITH M.AZI_PRSSTD	&& SERGIO 02/08/2008
REPLACE AZI_DESKTOP WITH M.AZI_DESKTOP  && SERGIO 26/08/2010	
REPLACE AZI_PASS  	WITH M.AZI_PASS  	&& SERGIO 26/08/2010
REPLACE AZI_PASS_SW	WITH M.AZI_PASS_SW	&& SERGIO 26/08/2010
REPLACE AZI_SCRIT_B	WITH M.AZI_SCRIT_B	&& SERGIO 26/08/2010
REPLACE AZI_SCRIT_N	WITH M.AZI_SCRIT_N	&& SERGIO 26/08/2010
REPLACE AZI_SCRIT_R	WITH M.AZI_SCRIT_R	&& SERGIO 26/08/2010
REPLACE AZI_AQUAR   WITH M.AZI_AQUAR   	&& SERGIO 26/08/2010
REPLACE AZI_PASS_B  WITH M.AZI_PASS_B  	&& SERGIO 26/08/2010
REPLACE AZI_PASS_N  WITH M.AZI_PASS_N 	&& SERGIO 26/08/2010
REPLACE AZI_PASS_R  WITH M.AZI_PASS_R 	&& SERGIO 26/08/2010
REPLACE AZI_SUBMEN  WITH M.AZI_SUBMEN 	&& SERGIO 26/08/2010
REPLACE AZI_SCRIT   WITH M.AZI_SCRIT 	&& SERGIO 26/08/2010
REPLACE AZI_COMPON  WITH M.AZI_COMPON  	&& SIMONE 17/11/2010
REPLACE AZI_PRORATA WITH M.AZI_PRORATA  && SERGIO 25/11/2010
REPLACE AZI_GGDTSP  WITH M.AZI_GGDTSP   && ERASMO 13/12/2010
REPLACE AZI_CGMAGA  WITH M.AZI_CGMAGA	&& ERASMO 28/12/2010
REPLACE AZI_VERSRA  WITH M.AZI_VERSRA	&& SERGIO 13/01/2011
REPLACE AZI_NOQUAD  WITH M.AZI_NOQUAD   && SERGIO 01/02/2011
REPLACE AZI_FATSTU	WITH M.AZI_FATSTU	&& ERASMO - 03/02/2011
REPLACE AZI_NRSENO	WITH M.AZI_NRSENO	&& SIMONE - 07/03/2011
REPLACE AZI_PROTNO	WITH M.AZI_PROTNO	&& SIMONE - 07/03/2011
REPLACE AZI_TRANCH  WITH M.AZI_TRANCH	&& SIMONE - 25/03/2011
REPLACE AZI_INSBFO	WITH M.AZI_INSBFO   && ERASMO - 27/04/2011   
REPLACE AZI_MPIU    WITH M.AZI_MPIU		&& SERGIO - 05/05/2011
REPLACE AZI_MMEN    WITH M.AZI_MMEN 	&& SERGIO - 05/05/2011
REPLACE AZI_ZTLSHW	WITH M.AZI_ZTLSHW   && ERASMO - 18/05/2011
REPLACE AZI_BFP		WITH M.AZI_BFP 		&& ERASMO - 02/09/2011
REPLACE AZI_MAXRDA	WITH M.AZI_MAXRDA 	&& ERASMO - 02/09/2011
REPLACE AZI_MACINA	WITH M.AZI_MACINA 	&& ERASMO - 02/09/2011
REPLACE AZI_PRESSA	WITH M.AZI_PRESSA 	&& ERASMO - 02/09/2011 
REPLACE AZI_TAGLIO	WITH M.AZI_TAGLIO 	&& ERASMO - 02/09/2011 
REPLACE AZI_LEVIGA	WITH M.AZI_LEVIGA 	&& ERASMO - 02/09/2011 
REPLACE AZI_LEVIGA1	WITH M.AZI_LEVIGA1 	&& ERASMO - 28/01/2013
REPLACE AZI_LEVIGA2	WITH M.AZI_LEVIGA2 	&& ERASMO - 28/01/2013
REPLACE AZI_LEVIGA3	WITH M.AZI_LEVIGA3 	&& ERASMO - 28/01/2013 
REPLACE AZI_NOBILI	WITH M.AZI_NOBILI 	&& ERASMO - 02/09/2011 
REPLACE AZI_PROFIN	WITH M.AZI_PROFIN 	&& ERASMO - 02/09/2011 
REPLACE AZI_TFATT	WITH M.AZI_TFATT	&& SERGIO - 25/09/2011 
REPLACE AZI_PRGPLET WITH M.AZI_PRGPLET 	&& SERGIO - 16/10/2011
REPLACE AZI_CBI		WITH M.AZI_CBI 		&& FABIANO - 27/11/2011
REPLACE AZI_ARRNID	WITH M.AZI_ARRNID	&& ERASMO - 29/11/2011
REPLACE AZI_LIS12   WITH M.AZI_LIS12    && SERGIO - 09/12/2011 
REPLACE AZI_LIS13   WITH M.AZI_LIS13    && SERGIO - 09/12/2011 
REPLACE AZI_LIS14   WITH M.AZI_LIS14    && SERGIO - 09/12/2011 
REPLACE AZI_TOPPNC  WITH M.AZI_TOPPNC   && FABIANO - 21/12/2011 
REPLACE AZI_TOPTRI  WITH M.AZI_TOPTRI   && FABIANO - 21/12/2011 
REPLACE AZI_GGRIBA  WITH M.AZI_GGRIBA   && FABIANO - 30/12/2011 
REPLACE AZI_YESLOGBOL	WITH M.AZI_YESLOGBOL	&& ERASMO - 19/01/2012
REPLACE AZI_DOGCOM		WITH M.AZI_DOGCOM		&& ERASMO - 19/01/2012
REPLACE AZI_NOPOSTI		WITH M.AZI_NOPOSTI		&& SERGIO - 18/02/2012
REPLACE AZI_TRATTA		WITH M.AZI_TRATTA		&& FABIANO - 22/03/2012
REPLACE AZI_NBOREF   	WITH M.AZI_NBOREF    	&& SERGIO - 03/06/2012 
REPLACE AZI_LIFSCO   	WITH M.AZI_LIFSCO   	&& SERGIO - 09/07/2012 
REPLACE AZI_CAUVBA  	WITH M.AZI_CAUVBA   	&& SERGIO - 13/07/2012 
REPLACE AZI_CLIMAG		WITH M.AZI_CLIMAG		&& SERGIO - 15/07/2012 
REPLACE AZI_SCAPPT		WITH M.AZI_SCAPPT		&& SERGIO - 18/08/2012 
REPLACE AZI_CAIPPT		WITH M.AZI_CAIPPT		&& SERGIO - 20/08/2012 
REPLACE AZI_GIANEG		WITH M.AZI_GIANEG		&& SERGIO - 05/09/2012 
REPLACE AZI_CAUGNE		WITH M.AZI_CAUGNE		&& SERGIO - 16/09/2012 
REPLACE AZI_CAPAGL		WITH M.AZI_CAPAGL		&& SERGIO - 16/09/2012 
REPLACE AZI_CAUSMP 		WITH M.AZI_CAUSMP		&& SERGIO - 16/09/2012 
REPLACE AZI_CAURIM 		WITH M.AZI_CAURIM 		&& SERGIO - 16/09/2012
REPLACE AZI_CAUSPR 		WITH M.AZI_CAUSPR 		&& SERGIO - 16/09/2012
REPLACE AZI_ARTSPR 		WITH M.AZI_ARTSPR 		&& SERGIO - 16/09/2012
REPLACE AZI_CAUCAL 		WITH M.AZI_CAUCAL 		&& SERGIO - 16/09/2012
REPLACE AZI_CAUSCL 		WITH M.AZI_CAUSCL 		&& SERGIO - 16/09/2012
REPLACE AZI_CACARI 		WITH M.AZI_CACARI 		&& SERGIO - 16/09/2012
REPLACE AZI_CASCRI 		WITH M.AZI_CASCRI 		&& SERGIO - 16/09/2012
REPLACE AZI_CACATA 		WITH M.AZI_CACATA 		&& SERGIO - 16/09/2012
REPLACE AZI_CASCTA 		WITH M.AZI_CASCTA 		&& SERGIO - 16/09/2012
REPLACE AZI_CACART 		WITH M.AZI_CACART 		&& SERGIO - 16/09/2012
REPLACE AZI_CASCRT 		WITH M.AZI_CASCRT 		&& SERGIO - 16/09/2012
REPLACE AZI_CASCLE 		WITH M.AZI_CASCLE 		&& SERGIO - 16/09/2012
REPLACE AZI_ARTSLE 		WITH M.AZI_ARTSLE 		&& SERGIO - 16/09/2012
REPLACE AZI_CAPRNO 		WITH M.AZI_CAPRNO 		&& SERGIO - 16/09/2012
REPLACE AZI_SCPRNO 		WITH M.AZI_SCPRNO 		&& SERGIO - 16/09/2012
REPLACE AZI_CASCNO 		WITH M.AZI_CASCNO 		&& SERGIO - 16/09/2012
REPLACE AZI_ARTSNO 		WITH M.AZI_ARTSNO 		&& SERGIO - 16/09/2012
REPLACE AZI_LCKPRE 		WITH M.AZI_LCKPRE  		&& ERASMO - 26/09/2012
REPLACE AZI_LCKLEV 		WITH M.AZI_LCKLEV  		&& ERASMO - 26/09/2012
REPLACE AZI_LCKNOB 		WITH M.AZI_LCKNOB  		&& ERASMO - 26/09/2012
REPLACE AZI_GGCONS 		WITH M.AZI_GGCONS  		&& ERASMO - 10/10/2012
REPLACE AZI_FLGPCO 		WITH M.AZI_FLGPCO  		&& ERASMO - 25/10/2012
REPLACE AZI_NODBPN  	WITH M.AZI_NODBPN  		&& ERASMO - 06/11/2012
REPLACE AZI_CDAPRD     	WITH M.AZI_CDAPRD		&& ERASMO - 13/12/2012
REPLACE AZI_MSGORDNODB 	WITH M.AZI_MSGORDNODB	&& ERASMO - 13/12/2012
REPLACE AZI_LCKORDNODB 	WITH M.AZI_LCKORDNODB	&& ERASMO - 13/12/2012
REPLACE AZI_IVAXCA 		WITH M.AZI_IVAXCA		&& SERGIO - 03/01/2013
REPLACE AZI_SAUFOR 		WITH M.AZI_SAUFOR  		&& ERASMO - 29/01/2013
REPLACE AZI_PRZDIB 		WITH M.AZI_PRZDIB  		&& SERGIO - 30/01/2013
REPLACE AZI_LOGSQL 		WITH M.AZI_LOGSQL  		&& ERASMO - 12/02/2013
REPLACE AZI_CESCOM		WITH M.AZI_CESCOM		&& SERGIO - 22/02/2013
REPLACE AZI_DOGBOL 		WITH M.AZI_DOGBOL  		&& ERASMO - 25/02/2013
REPLACE AZI_DOGART 		WITH M.AZI_DOGART  		&& ERASMO - 25/02/2013
REPLACE AZI_OPZRSK		WITH M.AZI_OPZRSK		&& ERASMO - 07/03/2013
REPLACE AZI_PKRSTA		WITH M.AZI_PKRSTA		&& ERASMO - 07/03/2013
REPLACE AZI_BOLIVA1		WITH M.AZI_BOLIVA1		&& SERGIO - 08/03/2013
REPLACE AZI_DDTQTADOPPIE 	WITH M.AZI_DDTQTADOPPIE && FABIANO - 09/03/2013
REPLACE AZI_PKREML			WITH M.AZI_PKREML		&& ERASMO - 14/03/2013
REPLACE AZI_NOSALDI			WITH M.AZI_NOSALDI		&& SERGIO - 20/03/2013
REPLACE AZI_PKAUPE			WITH M.AZI_PKAUPE		&& ERASMO - 22/03/2013
REPLACE AZI_DDTLCK			WITH M.AZI_DDTLCK		&& ERASMO - 22/03/2013
REPLACE AZI_PKNCAU			WITH M.AZI_PKNCAU		&& ERASMO - 25/03/2013

REPLACE AZI_FATIDR			WITH M.AZI_FATIDR		&& SERGIO - 06/04/2013
REPLACE AZI_PERIDR			WITH M.AZI_PERIDR		&& SERGIO - 06/04/2013

REPLACE AZI_PGGCLS			WITH M.AZI_PGGCLS		&& ERASMO - 14/05/2013


RETURN


************************************************************************
PROCEDURE U_AZI_AN
***********************************************************************
REPLACE AZI_CODSOC WITH M.AZI_CODSOC
REPLACE AZI_CODCLI WITH M.AZI_CODCLI
REPLACE AZI_RAGSOC WITH M.AZI_RAGSOC
REPLACE AZI_INDIRI WITH M.AZI_INDIRI
REPLACE AZI_LOCALI WITH M.AZI_LOCALI
REPLACE AZI_CAP    WITH M.AZI_CAP
REPLACE AZI_TELEFO WITH M.AZI_TELEFO
REPLACE AZI_FAX    WITH M.AZI_FAX
REPLACE AZI_PIVA   WITH M.AZI_PIVA
REPLACE AZI_IVACEE WITH M.AZI_IVACEE
REPLACE AZI_CODFIS WITH M.AZI_CODFIS
REPLACE AZI_CONDCO WITH M.AZI_CONDCO
REPLACE AZI_MODTRA WITH M.AZI_MODTRA
REPLACE AZI_PAEORI WITH M.AZI_PAEORI
REPLACE AZI_IVACLI WITH M.AZI_IVACLI
REPLACE AZI_FABBR  WITH M.AZI_FABBR
REPLACE AZI_LIBERA WITH M.AZI_LIBERA
REPLACE AZI_PAGCLI WITH M.AZI_PAGCLI
REPLACE AZI_PROTCL WITH M.AZI_PROTCL
REPLACE AZI_ESECLI WITH M.AZI_ESECLI
REPLACE AZI_IVAFOR WITH M.AZI_IVAFOR
REPLACE AZI_PAGFOR WITH M.AZI_PAGFOR
REPLACE AZI_PROTFO WITH M.AZI_PROTFO
REPLACE AZI_ESEFOR WITH M.AZI_ESEFOR
REPLACE AZI_CORRIS WITH M.AZI_CORRIS
REPLACE AZI_PAGCOR WITH M.AZI_PAGCOR
REPLACE AZI_ESECOR WITH M.AZI_ESECOR
REPLACE AZI_LIBGIO WITH M.AZI_LIBGIO
REPLACE AZI_PAGLIB WITH M.AZI_PAGLIB
REPLACE AZI_ESELIB WITH M.AZI_ESELIB
REPLACE AZI_NUMRE  WITH M.AZI_NUMRE
REPLACE AZI_NFAGE  WITH M.AZI_NFAGE
REPLACE AZI_PROTCO WITH M.AZI_PROTCO
REPLACE AZI_NATURA WITH M.AZI_NATURA
REPLACE AZI_VAL01  WITH M.AZI_VAL01
REPLACE AZI_VAL02  WITH M.AZI_VAL02
REPLACE AZI_VAL03  WITH M.AZI_VAL03
REPLACE AZI_VAL04  WITH M.AZI_VAL04
REPLACE AZI_VAL05  WITH M.AZI_VAL05
REPLACE AZI_VAL06  WITH M.AZI_VAL06
REPLACE AZI_VAL07  WITH M.AZI_VAL07
REPLACE AZI_VAL08  WITH M.AZI_VAL08
REPLACE AZI_VAL09  WITH M.AZI_VAL09
REPLACE AZI_VAL10  WITH M.AZI_VAL10
REPLACE AZI_VAL11  WITH M.AZI_VAL11
REPLACE AZI_VAL12  WITH M.AZI_VAL12
REPLACE AZI_VAL13  WITH M.AZI_VAL13
REPLACE AZI_VAL14  WITH M.AZI_VAL14
REPLACE AZI_VAL15  WITH M.AZI_VAL15
REPLACE AZI_VAL16  WITH M.AZI_VAL16
REPLACE AZI_VAL17  WITH M.AZI_VAL17
*!*	REPLACE AZI_VAL18  WITH M.AZI_VAL18		&& asteriscate provvisoriamente in quanto U_AZI_AN è arrivato al limte del numero di colonne previste
*!*	REPLACE AZI_VAL19  WITH M.AZI_VAL19
*!*	REPLACE AZI_VAL20  WITH M.AZI_VAL20
REPLACE AZI_BOLLA  WITH M.AZI_BOLLA
REPLACE AZI_FAPRO  WITH M.AZI_FAPRO
REPLACE AZI_ORDIN  WITH M.AZI_ORDIN
REPLACE AZI_FATTU  WITH M.AZI_FATTU
REPLACE AZI_EFFE   WITH M.AZI_EFFE
REPLACE AZI_ORFO   WITH M.AZI_ORFO
REPLACE AZI_OFFE   WITH M.AZI_OFFE
REPLACE AZI_COMM   WITH M.AZI_COMM
REPLACE AZI_CTLO   WITH M.AZI_CTLO
REPLACE AZI_SAU    WITH M.AZI_SAU
REPLACE AZI_CODM   WITH M.AZI_CODM
REPLACE AZI_TLIN   WITH M.AZI_TLIN
REPLACE AZI_INTOFF WITH M.AZI_INTOFF
REPLACE AZI_PIEOFF WITH M.AZI_PIEOFF
REPLACE AZI_INTORD WITH M.AZI_INTORD
REPLACE AZI_PIEORD WITH M.AZI_PIEORD
REPLACE AZI_INTORF WITH M.AZI_INTORF
REPLACE AZI_PIEORF WITH M.AZI_PIEORF
REPLACE AZI_INTBOL WITH M.AZI_INTBOL
REPLACE AZI_PIEBOL WITH M.AZI_PIEBOL
REPLACE AZI_INTFAP WITH M.AZI_INTFAP
REPLACE AZI_PIEFAP WITH M.AZI_PIEFAP
REPLACE AZI_INTFAT WITH M.AZI_INTFAT
REPLACE AZI_PIEFAT WITH M.AZI_PIEFAT
REPLACE AZI_ARTPUB WITH M.AZI_ARTPUB
REPLACE AZI_INTRA1 WITH M.AZI_INTRA1
REPLACE AZI_INTRA2 WITH M.AZI_INTRA2
REPLACE AZI_REGIMP WITH M.AZI_REGIMP
REPLACE AZI_NUMISC WITH M.AZI_NUMISC
REPLACE AZI_CSIVER WITH M.AZI_CSIVER
REPLACE AZI_REA    WITH M.AZI_REA
REPLACE AZI_REANUM WITH M.AZI_REANUM
REPLACE AZI_NOSC   WITH M.AZI_NOSC
REPLACE AZI_SKART  WITH M.AZI_SKART
REPLACE AZI_RISOLU WITH M.AZI_RISOLU
REPLACE AZI_IVA    WITH M.AZI_IVA
REPLACE AZI_UM     WITH M.AZI_UM
REPLACE AZI_VERYD  WITH M.AZI_VERYD
REPLACE AZI_SPINC  WITH M.AZI_SPINC
REPLACE AZI_SCAFA  WITH M.AZI_SCAFA
REPLACE AZI_CFDEF  WITH M.AZI_CFDEF
REPLACE AZI_NBOIE  WITH M.AZI_NBOIE
REPLACE AZI_NFANC  WITH M.AZI_NFANC
REPLACE AZI_LIS01  WITH M.AZI_LIS01
REPLACE AZI_LIS02  WITH M.AZI_LIS02
REPLACE AZI_LIS03  WITH M.AZI_LIS03
REPLACE AZI_LIS04  WITH M.AZI_LIS04
REPLACE AZI_LIS05  WITH M.AZI_LIS05
REPLACE AZI_LIS06  WITH M.AZI_LIS06
REPLACE AZI_LIS07  WITH M.AZI_LIS07
REPLACE AZI_LIS08  WITH M.AZI_LIS08
REPLACE AZI_LIS09  WITH M.AZI_LIS09
REPLACE AZI_LIS10  WITH M.AZI_LIS10
REPLACE AZI_LIS0A  WITH M.AZI_LIS0A
REPLACE AZI_LINEA  WITH M.AZI_LINEA
REPLACE AZI_CPA    WITH M.AZI_CPA
REPLACE AZI_AGE    WITH M.AZI_AGE
REPLACE AZI_VALU   WITH M.AZI_VALU
REPLACE AZI_NAZI   WITH M.AZI_NAZI
REPLACE AZI_NCR    WITH M.AZI_NCR
REPLACE AZI_STFAD  WITH M.AZI_STFAD
REPLACE AZI_FAMTU  WITH M.AZI_FAMTU
REPLACE AZI_CARFA  WITH M.AZI_CARFA
REPLACE AZI_ESIVA  WITH M.AZI_ESIVA
REPLACE AZI_TFPER  WITH M.AZI_TFPER
REPLACE AZI_NORD   WITH M.AZI_NORD
REPLACE AZI_TFTOP  WITH M.AZI_TFTOP
REPLACE AZI_COMCEE WITH M.AZI_COMCEE
REPLACE AZI_PROTCE WITH M.AZI_PROTCE
REPLACE AZI_PREZZI WITH M.AZI_PREZZI
REPLACE AZI_IMPEGN WITH M.AZI_IMPEGN
REPLACE AZI_NBOBA  WITH M.AZI_NBOBA
REPLACE AZI_CTRGIA WITH M.AZI_CTRGIA
REPLACE AZI_CTRORF WITH M.AZI_CTRORF
REPLACE AZI_CADEF  WITH M.AZI_CADEF
REPLACE AZI_WEBRCF WITH M.AZI_WEBRCF
REPLACE AZI_WEBRCD WITH M.AZI_WEBRCD
REPLACE AZI_WEBTRF WITH M.AZI_WEBTRF
REPLACE AZI_WEBTRD WITH M.AZI_WEBTRD
REPLACE AZI_STFAT  WITH M.AZI_STFAT
REPLACE AZI_STFAP  WITH M.AZI_STFAP
REPLACE AZI_FATTR  WITH M.AZI_FATTR
REPLACE AZI_MLPLTU WITH M.AZI_MLPLTU
REPLACE AZI_MLPLDT WITH M.AZI_MLPLDT
REPLACE AZI_MLEBDT WITH M.AZI_MLEBDT
REPLACE AZI_CLIDIR WITH M.AZI_CLIDIR
REPLACE AZI_CAUDIR WITH M.AZI_CAUDIR
REPLACE AZI_RATES1 WITH M.AZI_RATES1
REPLACE AZI_RATES2 WITH M.AZI_RATES2
REPLACE AZI_RADET1 WITH M.AZI_RADET1
REPLACE AZI_RADET2 WITH M.AZI_RADET2
REPLACE AZI_RADET3 WITH M.AZI_RADET3
REPLACE AZI_RADET4 WITH M.AZI_RADET4
REPLACE AZI_RADET5 WITH M.AZI_RADET5
REPLACE AZZ_RATES1 WITH M.AZZ_RATES1
REPLACE AZZ_RATES2 WITH M.AZZ_RATES2
REPLACE AZZ_RADET1 WITH M.AZZ_RADET1
REPLACE AZZ_RADET2 WITH M.AZZ_RADET2
REPLACE AZZ_RADET3 WITH M.AZZ_RADET3
REPLACE AZZ_RADET4 WITH M.AZZ_RADET4
REPLACE AZZ_RADET5 WITH M.AZZ_RADET5
REPLACE AZZ_REGIMP WITH M.AZZ_REGIMP
REPLACE AZZ_NUMISC WITH M.AZZ_NUMISC
REPLACE AZZ_CSIVER WITH M.AZZ_CSIVER
REPLACE AZZ_REA    WITH M.AZZ_REA
REPLACE AZZ_REANUM WITH M.AZZ_REANUM
REPLACE AZI_NOSOL  WITH M.AZI_NOSOL
REPLACE AZI_AACDAL WITH M.AZI_AACDAL
REPLACE AZI_AACAL  WITH M.AZI_AACAL
REPLACE AZI_QTAORF WITH M.AZI_QTAORF
REPLACE AZI_MAGLOG WITH M.AZI_MAGLOG
REPLACE AZI_PROGAA WITH M.AZI_PROGAA
REPLACE AZI_NOSPOO WITH M.AZI_NOSPOO
REPLACE AZI_PROVVI WITH M.AZI_PROVVI
REPLACE AZI_SC1    WITH M.AZI_SC1
REPLACE AZI_SC2    WITH M.AZI_SC2
REPLACE AZI_SC3    WITH M.AZI_SC3
REPLACE AZI_CERTIF WITH M.AZI_CERTIF
REPLACE AZI_FORMAR WITH M.AZI_FORMAR
REPLACE AZI_MESERR WITH M.AZI_MESERR
REPLACE AZI_PAGANT WITH M.AZI_PAGANT
REPLACE AZI_CAUANT WITH M.AZI_CAUANT
REPLACE AZI_CAUAVA WITH M.AZI_CAUAVA
REPLACE AZI_CAUSAL WITH M.AZI_CAUSAL
REPLACE AZI_COMSEM WITH M.AZI_COMSEM
REPLACE AZI_CPAINC WITH M.AZI_CPAINC
REPLACE AZI_ARTINC WITH M.AZI_ARTINC
REPLACE AZI_CAUCFO WITH M.AZI_CAUCFO
REPLACE AZI_CAUCSP WITH M.AZI_CAUCSP
REPLACE AZI_CAUSSP WITH M.AZI_CAUSSP
REPLACE AZI_CAUSFA WITH M.AZI_CAUSFA
REPLACE AZI_CAULES WITH M.AZI_CAULES
REPLACE AZI_OREGIO WITH M.AZI_OREGIO
REPLACE AZI_CAUCMA WITH M.AZI_CAUCMA
REPLACE AZI_BFO    WITH M.AZI_BFO
REPLACE AZI_BOLFOR WITH M.AZI_BOLFOR
REPLACE AZI_CTRLBF WITH M.AZI_CTRLBF
REPLACE AZI_CODBUN WITH M.AZI_CODBUN
REPLACE AZI_CTRTAG WITH M.AZI_CTRTAG
REPLACE AZI_CTRCOL WITH M.AZI_CTRCOL
REPLACE AZI_CATACO WITH M.AZI_CATACO
REPLACE AZI_MLDOCA WITH M.AZI_MLDOCA
REPLACE AZI_ARTRES WITH M.AZI_ARTRES
REPLACE AZI_CAURIF WITH M.AZI_CAURIF
REPLACE AZI_CAUREC WITH M.AZI_CAUREC
REPLACE AZI_CAUCAS WITH M.AZI_CAUCAS
REPLACE AZI_CODCAS WITH M.AZI_CODCAS
REPLACE AZI_MASTRO WITH M.AZI_MASTRO
REPLACE AZI_SOTTOG WITH M.AZI_SOTTOG
REPLACE AZI_VISRIC WITH M.AZI_VISRIC
REPLACE AZI_DDTRIC WITH M.AZI_DDTRIC
REPLACE AZI_CAUREF WITH M.AZI_CAUREF
REPLACE AZI_GESEDI WITH M.AZI_GESEDI
REPLACE AZI_CONTO  WITH M.AZI_CONTO
REPLACE AZI_CAUPDV WITH M.AZI_CAUPDV
REPLACE AZI_NUMLOT WITH M.AZI_NUMLOT
REPLACE AZI_EAISBN WITH M.AZI_EAISBN
REPLACE AZI_TIPCAS WITH M.AZI_TIPCAS
REPLACE AZI_FTPROT WITH M.AZI_FTPROT
REPLACE AZI_VISRID WITH M.AZI_VISRID
REPLACE AZI_ARTABB WITH M.AZI_ARTABB
REPLACE AZI_FTPRIC WITH M.AZI_FTPRIC
REPLACE AZI_CAUTRA WITH M.AZI_CAUTRA
REPLACE AZI_GIAADF WITH M.AZI_GIAADF
REPLACE AZI_FORPRE WITH M.AZI_FORPRE
REPLACE AZI_RESCLI WITH M.AZI_RESCLI
REPLACE AZI_TIPCON WITH M.AZI_TIPCON
REPLACE AZI_PRZBAS WITH M.AZI_PRZBAS
REPLACE AZI_DATOLD WITH M.AZI_DATOLD
REPLACE AZI_CAMCOS WITH M.AZI_CAMCOS
REPLACE AZI_MULTIANNO WITH M.AZI_MULTIANNO
REPLACE azi_nfatdifferita WITH m.azi_nfatdifferita
REPLACE AZI_CAUSOS WITH M.AZI_CAUSOS
REPLACE AZI_RICONF WITH M.AZI_RICONF
REPLACE AZI_DECQTA WITH M.AZI_DECQTA
REPLACE AZI_DECPRZ WITH M.AZI_DECPRZ
REPLACE AZI_DECVAL WITH M.AZI_DECVAL
REPLACE AZI_COSATRATTA			WITH M.AZI_COSATRATTA
REPLACE AZI_GRADOIMPORTANZA		WITH M.AZI_GRADOIMPORTANZA
REPLACE AZI_FORMAPAGAMENTO		WITH M.AZI_FORMAPAGAMENTO
REPLACE AZI_TIPOCONTRATTO		WITH M.AZI_TIPOCONTRATTO
REPLACE AZI_CONAQUISTO			WITH M.AZI_CONAQUISTO

REPLACE AZI_CARORF WITH M.AZI_CARORF
REPLACE AZI_CQUMPC WITH M.AZI_CQUMPC
REPLACE AZI_CQUMPN WITH M.AZI_CQUMPN
REPLACE AZI_SPAPRO WITH M.AZI_SPAPRO
REPLACE AZI_SPAMPR WITH M.AZI_SPAMPR
REPLACE AZI_SPACQS WITH M.AZI_SPACQS
REPLACE AZI_CQUSLC WITH M.AZI_CQUSLC
REPLACE AZI_CQUSLN WITH M.AZI_CQUSLN
REPLACE AZI_RIBPRO WITH M.AZI_RIBPRO
REPLACE AZI_RIBSLR WITH M.AZI_RIBSLR
REPLACE AZI_RIBSLO WITH M.AZI_RIBSLO
REPLACE AZI_TAGPRO WITH M.AZI_TAGPRO
REPLACE AZI_TAGSLR WITH M.AZI_TAGSLR
REPLACE AZI_TAGPFO WITH M.AZI_TAGPFO
REPLACE AZI_ALTLUN WITH M.AZI_ALTLUN
REPLACE AZI_PRIPAGA WITH M.AZI_PRIPAGA
REPLACE AZI_PAGAFOR WITH M.AZI_PAGAFOR
REPLACE AZI_TRF     WITH M.AZI_TRF
REPLACE AZI_PAGANCR WITH M.AZI_PAGANCR
REPLACE AZI_TRAIVA  WITH M.AZI_TRAIVA


RETURN



***************************************************************************
FUNCTION DEFPUB
***************************************************************************
* CREA VARIABILI PUBBLICHE DA UN DBF
* PASSARE LA SELECT IN CUI E' APERTO IL DBF

PARA _SELECT

Select(_SELECT)
_TotFields=afields(_NameFields)
for _x=1 to _TotFields
   _temp="M."+_NameFields[_x,1]
   release &_temp
   public &_temp
next


***************************************************************************
FUNCTION RELPUB
***************************************************************************
* RILASCIA VARIABILI PUBBLICHE CREATE DA UN DBF
* PASSARE LA SELECT IN CUI E' APERTO IL DBF

PARA _SELECT

Select(_SELECT)
_TotFields=afields(_NameFields)
for _x=1 to _TotFields
   _temp="M."+_NameFields[_x,1]
   release &_temp
next


***********************************************************************
* Funzione - TRC     Data: 18.03.97   Autore: Project S.r.L.
***********************************************************************
*
*  AGGIUNGE ZERI INIZIALI AD UN NUMERO IN FORMATO CARATTERE
*  PARAMETRI DA PASSARE
*  _LUN  = LUNGEZZA DEL CAMPO
*  _COD = VARIABILE CONTENENTE VALORE
*
*  sintassi:
*  V_COD=TRC(10,V_COD)
**************************
FUNCTION TRC
**************************
PARA _LUN,_COD

_COD=ALLTRIM(_COD)
IF LEN(_COD) > _LUN
 RETURN(_COD)
ENDIF

_LUN1=_LUN - LEN(_COD)
_OUT=REPLICATE('0',_LUN1)+_COD

RETURN(_OUT)

*********************************************************************************************
* SEEK_U_CLI_AN()	funzione per la gestione della tabella U_CLI_AN
*********************************************************************************************
* La funzione restituisce dalla tabella U_CLI_AN, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_cli_an
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PARAMETERS() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_cli_an"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

*!*	_seek = "'"+_chiave+"'"
*!*	_seek1= "'"+_chiave+"%'"
**=> ERASMO - INIZIO 29/12/2010
_seek = "'"+_chiave+"'" + " and CLI_OBSOL <> 'S'"
_seek1= "'"+_chiave+"%'" + " and CLI_OBSOL <> 'S'"
**=> ERASMO - FINE 29/12/2010
cSql 	= "SELECT * FROM u_cli_an where cli_codsoc+cli_codcli = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM u_cli_an where cli_codsoc+cli_ragsoc like "+_seek1+" or cli_codsoc+cli_pariva like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Ragione sociale;Parita IVA"
PUB_VISTA  = "cli_codcli;cli_ragsoc;cli_pariva"
PUB_RIT    = _ritorno
___dimensioni= "120;510;120"

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\ELENCO_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco clienti ecash"
ELSE
   DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco clienti",___dimensioni
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)


*********************************************************************************************
* SEEK_u_for_an()	funzione per la gestione della tabella u_for_an
*********************************************************************************************
* La funzione restituisce dalla tabella u_for_an, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_for_an
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PARAMETERS() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_for_an"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

*!*	_seek = "'"+_chiave+"'"
*!*	_seek1= "'"+_chiave+"%'"
**=> ERASMO - INIZIO 29/12/2010
_seek = "'"+_chiave+"'" + " and FOR_OBSOL <> 'S'"
_seek1= "'"+_chiave+"%'" + " and FOR_OBSOL <> 'S'"
**=> ERASMO - FINE 29/12/2010
cSql 	= "SELECT * FROM u_for_an where for_codsoc+for_codcli = "+_seek+" order by "+_ordinamento 
*!*	cSql_1 	= "SELECT * FROM u_for_an where for_codsoc+for_ragsoc like "+_seek1+" order by "+_ordinamento	&& sergio 2012/07/17
cSql_1 	= "SELECT * FROM u_for_an where for_codsoc+for_ragsoc like "+_seek1+" or for_codsoc+for_pariva like "+_seek1+" order by "+_ordinamento	
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Ragione sociale;Parita IVA"
PUB_VISTA  = "for_codcli;for_ragsoc;for_pariva"
___dimensioni= "120;510;120"

PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco fornitori",___dimensioni

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)

*********************************************************************************************
* SEEK_u_art_pr()	funzione per la gestione della tabella u_art_pr
*********************************************************************************************
* La funzione restituisce dalla tabella u_art_pr, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_art_pr
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PARAMETERS() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_art_pr"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   IF LEN(ALLTRIM(_chiave)) > 2
   ELSE
      cSql="SELECT * FROM U_ART_PR WHERE 1=0"
      IF !ExecCommand(cSql,_nomecursore)
         return(.f.)
      ENDIF
      V_TESTO = "Bisogna digitare almeno 3 caratteri per iniziare la ricerca"
      V_FORM  = "DO FORM FORM\MESSAGE_ECASH WITH '" + V_TESTO + "'"
      &V_FORM
      SELECT(_pjlib_sele)
      _ret_valore=""
      return(_ret_valore)
   ENDIF
ELSE
   IF LEN(ALLTRIM(_chiave)) > 0
   ELSE
      cSql="SELECT * FROM U_ART_PR WHERE 1=0"
      IF !ExecCommand(cSql,_nomecursore)
         return(.f.)
      ENDIF
      PUB_ERRORE=MESSAGEBOX('Bisogna digitare almeno 1 carattere per iniziare la ricerca',64,'*** ATTENZIONE ***')
      SELECT(_pjlib_sele)
      _ret_valore=""
      return(_ret_valore)
   ENDIF
ENDIF

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
**=> ERASMO - INIZIO 29/12/2010
_seek = "'"+_chiave+"'" + " and ART_OBSOL <> 'S'"
_seek1= "'"+_chiave+"%'" + " and ART_OBSOL <> 'S'"
**=> ERASMO - FINE 29/12/2010

* -->> query per procedura elenco standard (form elenco)
* ----------------------------------------------------------------
cSql 	= "SELECT top 50 * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT top 50 * FROM u_art_pr where art_codsoc = " + pub_codsoc + " and " +_ordinamento+" like "+_seek1+" order by "+_ordinamento
	

* -->> query per procedura elenco con paginazione (form elenco_pg)
* ----------------------------------------------------------------------

* -->> parametri per prima query
* ----------------------------------
j_ii_tabella_10 = "u_art_pr"
j_ii_cond_10	= "art_codsoc = '" + pub_codsoc + "'"
j_ii_cond_11	= " and " +_ordinamento+" = "+_seek
j_ii_cond_12	= " and 1=1"
j_ii_cond_13	= " and 1=1"
j_ii_ordine_10	= _ordinamento

* -->> parametri per seconda query
* ----------------------------------
j_ii_tabella_20	= "u_art_pr"
j_ii_cond_20	= "art_codsoc = '" + pub_codsoc + "'"
j_ii_cond_21	= " and " +_ordinamento+" like "+_seek1
j_ii_cond_22	= " and 1=1"
j_ii_cond_23	= " and 1=1"
j_ii_ordine_20	= _ordinamento


cSql_pg 	= j_ii_tabella_10+":"+j_ii_cond_10+":"+j_ii_cond_11+":"+j_ii_cond_12+":"+j_ii_cond_13+":"+j_ii_ordine_10
cSql_1_pg 	= j_ii_tabella_20+":"+j_ii_cond_20+":"+j_ii_cond_21+":"+j_ii_cond_22+":"+j_ii_cond_23+":"+j_ii_ordine_20


PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1

* -->> nuova variabile con le query x elenco con paginazione
* -----------------------------------------------------------------
PUB_SEEK_PG= cSql_pg+";"+cSql_1_pg
* -----------------------------------------------------------------

PUB_TESTA  = "Codice;Descrizione"
PUB_VISTA  = "art_codpri;art_descr"
PUB_RIT    = _ritorno

IF SUBSTR(_nomecursore,1,5) = 'ECASH'
   DO Form FORM\ELENCO_ecash WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli ecash"
ELSE
*   DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco articoli"
   DO Form FORM\ELENCO_PG WITH pub_select,pub_seek_pg,pub_testa,pub_vista,pub_rit,"Elenco articoli"
ENDIF

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)

*********************************************************************************************
* SEEK_u_pdv_an()	funzione per la gestione della tabella u_pdv_an
*********************************************************************************************
* La funzione restituisce dalla tabella u_pdv_an, il parametro che corrisponde ai criteri 
* presenti nei parametri passati. Se non trova ricorrenze corrette, apre la funestra delle
* scelte e restituisce il parametro selezionato.
*
* La funzione, richiede che vengano passati 5 parametri tutti obbligatori.
* Nel caso alcuni parametri non vengano utilizzati, vanno passati a BLANK ("").
*
* Descrizione dei parametri:
* 		_tiporec	= è il tipo di parametro da ricercare (TOP,CPA,ecc.)
*		_chiave		= è il valore ricercato (prima chiave)
* 		_ritorno	= è il campo da cui la funzione deve ritornare il valore
* 		_ordinamento= è l'ordine in cui vedo i dati nella finestra delle scelte
*		_lunghezza	= è la posizione del valore ricercato all'interno del campo codice
*					  (se codice=TOP555 e cerco 555, _lunghezza sarà 4,3 ovvero dalla
*					   posizione 4 per 3 caratteri).
*					   
*********************************************************************************************
FUNCTION seek_u_pdv_an
PARAMETERS _tiporec,_chiave,_ritorno,_ordinamento,_lunghezza,_nomecursore
IF PARAMETERS() < 6
   =MESSAGEBOX("Parametri insufficienti per la funzione richiamata",16,"*** ATTENZIONE ***")
   return("")
ENDIF 

IF EMPTY(_lunghezza)
   _lunghezza="1"
ENDIF

IF EMPTY(_nomecursore)
   _nomecursore="_pj_u_pdv_an"
ENDIF

_ret_valore=""

_pjlib_sele=SELECT()

_seek = "'"+_chiave+"'"
_seek1= "'"+_chiave+"%'"
cSql 	= "SELECT * FROM u_pdv_an where "+_ordinamento+" = "+_seek+" order by "+_ordinamento 
cSql_1 	= "SELECT * FROM u_pdv_an where "+_ordinamento+" like "+_seek1+" order by "+_ordinamento
	
PUB_SELECT = _nomecursore
PUB_SEEK   = cSql+";"+cSql_1
PUB_TESTA  = "Codice;Descrizione centro di costo"
PUB_VISTA  = "pdv_codice;pdv_descri"
PUB_RIT    = _ritorno

DO Form FORM\ELENCO WITH pub_select,pub_seek,pub_testa,pub_vista,pub_rit,"Elenco buisness unit"

STORE PUB_RIT TO _ret_valore

SELECT(_pjlib_sele)

return(_ret_valore)

**=> ERASMO - INIZIO 04/09/2013
**********************************************************
PROCEDURE MESSAGGIO_STILE_WIN8
**********************************************************
*** MOSTRA UN MESSAGGIO DI AVVISO A TUTTO SCHERMO CON SFONDO SEMITRASPARENTE, CON STILE SIMILE A QUELLO DI WINDOWS 8
*** 
*** PARAMETRI:
*** 	- _MESSAGGIO 	= Stringa di testo per il messaggio statico da visualizzare
*** 	- [_BACKCOLOR] 	= Stringa (facoltativa) contenente il colore di sfondo preferito del messaggio (default "0,0,160")
*** 	- [_TIMEOUT] 	= Numero di secondi dopo il quale viene chiuso automaticamente il messaggio
*** 	- [_DYNAMICMSG] = Stringa di testo contenente una espressione dinamica, come ad esempio un countdown
*** 
*** ESEMPIO 1 (messaggio semlice):
***		_cMsg = "ATTENZIONE" + CHR(13) + CHR(13) + "Operazione non consentita" + CHR(13) + "Fare click su OK per continuare"
*** 	DO MESSAGGIO_STILE_WIN8 WITH _cMsg
***
*** ESEMPIO 2 (messaggio dinamico a chiusura automatica):
*** 	PUB_BLOCCA_AQUARIUS_TIMEOUT = 10
*** 	_cDynMsg = '"ATTENZIONE" + CHR(13) + CHR(13) + "Il sistema si chiuderà automaticamente per assistenza tecnica" + CHR(13) + ' + ;
*** 		'"Ultimare le attività e uscire entro " + ALLTRIM(STR(ROUND(_NTimeOut - _NDeltaTime,0))) + " secondi"'
*** 	DO MESSAGGIO_STILE_WIN8 WITH "","255,0,0",PUB_BLOCCA_AQUARIUS_TIMEOUT,_cDynMsg
**********************************************************
LPARAMETERS _MESSAGGIO,_BACKCOLOR,_TIMEOUT,_DYNAMICMSG

IF PCOUNT() >= 1
ELSE
	_MESSAGGIO = ""
ENDIF
IF PCOUNT() >= 2
ELSE
	_BACKCOLOR = "0,0,160"
ENDIF
IF PCOUNT() >= 3
ELSE
	_TIMEOUT = 0
ENDIF
IF PCOUNT() >= 4
ELSE
	_DYNAMICMSG = ""
ENDIF

IF EMPTY(_BACKCOLOR)
	_BACKCOLOR = "0,0,160"
ENDIF

omessaggio_bckgrnd = CREATEOBJECT("messaggio_bckgrnd",_MESSAGGIO,_BACKCOLOR,_TIMEOUT,_DYNAMICMSG)
omessaggio_bckgrnd.SHOW

ENDPROC

*** DEFINIZIONE CLASSE PER FORM MESSAGGIO_BCKGRND
DEFINE CLASS messaggio_bckgrnd AS form

	BorderStyle = 0
	Height = 600
	Width = 800
	Desktop = .T.
	ShowWindow = 0
	DoCreate = .T.
	OLEDragMode = 0
	OLEDropMode = 0
	ShowTips = .T.
	AutoCenter = .F.
	Picture = "..\"
	Caption = ""
	MaxButton = .F.
	MinButton = .T.
	MousePointer = 0
	Visible = .F.
	Icon = "..\"
	TitleBar = 0
	WindowType = 1
	AlwaysOnTop = .F.
	AlwaysOnBottom = .F.
	BackColor = RGB(192,192,192)
	Themes = .F.
	Name = "MESSAGGIO_BCKGRND"


	PROCEDURE Destroy

		CLEAR DLLS _Sol_SetWindowLong
		CLEAR DLLS _Sol_SetLayeredWindowAttributes
		
	ENDPROC


	PROCEDURE Init

		PARAMETERS _MESSAGGIO,_BACKCOLOR,_TIMEOUT,_DYNAMICMSG

		RELEASE _PAR_MESSAGGIO,_PAR_BACKCOLOR,_PAR_TIMEOUT,_PAR_DYNAMICMSG
		PUBLIC _PAR_MESSAGGIO,_PAR_BACKCOLOR,_PAR_TIMEOUT,_PAR_DYNAMICMSG
		_PAR_MESSAGGIO = _MESSAGGIO
		_PAR_BACKCOLOR = _BACKCOLOR
		_PAR_TIMEOUT = _TIMEOUT
		_PAR_DYNAMICMSG = _DYNAMICMSG

		THISFORM.Width = SYSMETRIC(1)
		THISFORM.Height = SYSMETRIC(2)

		*** IMPOSTAZIONE TRASPARENZA FORM (solo form con proprietà Desktop = .T.)
		#DEFINE BADOS_LOC	"This sample only runs on Windows 2000 or higher."
		IF VAL(OS(3))<5
			MESSAGEBOX(BADOS_LOC)
			RETURN .F.
		ENDIF
		DECLARE SetWindowLong In Win32Api AS _Sol_SetWindowLong Integer, Integer, Integer
		DECLARE SetLayeredWindowAttributes In Win32Api AS _Sol_SetLayeredWindowAttributes Integer, String, Integer, Integer
		_Sol_SetWindowLong(THISFORM.hWnd, -20, 0x00080000)
		_nTransparencyLevel = 160  && (accept values from 0 to 255)
		_Sol_SetLayeredWindowAttributes(THISFORM.hWnd, 0, _nTransparencyLevel, 2)

		THISFORM.AutoCenter = .T.
		THISFORM.Visible = .T.
		
	ENDPROC


	PROCEDURE Activate
	
		omessaggio_scritta = CREATEOBJECT("messaggio_scritta",_PAR_MESSAGGIO,_PAR_BACKCOLOR,_PAR_TIMEOUT,_PAR_DYNAMICMSG)
		omessaggio_scritta.SHOW

		RELEASE THISFORM
		
	ENDPROC

ENDDEFINE

*** DEFINIZIONE CLASSE PER FORM MESSAGGIO_SCRITTA
DEFINE CLASS messaggio_scritta AS form

	BorderStyle = 0
	Height = 300
	Width = 800
	Desktop = .T.
	ShowWindow = 0
	DoCreate = .T.
	OLEDragMode = 0
	OLEDropMode = 0
	ShowTips = .T.
	AutoCenter = .F.
	Picture = "..\"
	Caption = ""
	MaxButton = .F.
	MinButton = .T.
	MousePointer = 0
	Visible = .F.
	Icon = "..\"
	TitleBar = 0
	WindowType = 1
	AlwaysOnTop = .F.
	AlwaysOnBottom = .F.
	BackColor = RGB(0,0,160)
	Themes = .F.
	Name = "messaggio_scritta"


	ADD OBJECT edtmessaggio AS editbox WITH ;
		FontSize = 18, ;
		Alignment = 0, ;
		BackStyle = 0, ;
		BorderStyle = 0, ;
		ScrollBars = 0, ;
		Enabled = .F., ;
		DisabledForeColor = RGB(255,255,255), ;
		Caption = "edtmessaggio", ;
		Value = "edtmessaggio", ;
		Height = 282, ;
		Left = 25, ;
		Top = 9, ;
		Width = 750, ;
		Name = "edtmessaggio"


	ADD OBJECT timer1 AS timer WITH ;
		Top = 253, ;
		Left = 8, ;
		Height = 24, ;
		Width = 25, ;
		Name = "Timer1"
		
		
	ADD OBJECT container1 AS container WITH ;
		Top = 240, ;
		Left = 637, ;
		Height = 40, ;
		Width = 145, ;
		BackStyle = 0, ;
		BorderWidth = 0, ;
		TabIndex = 107, ;
		Name = "Container1", ;
		Visible = .T.


	PROCEDURE Init

		PARAMETERS _par_cMessaggio,_par_cBackColor,_par_nTimeout,_par_cDynamicMsg
		
		THISFORM.Width = SYSMETRIC(1)
		THISFORM.edtmessaggio.Value = ALLTRIM(_par_cMessaggio)
		THISFORM.edtmessaggio.Left = (THISFORM.Width - THISFORM.edtmessaggio.Width) / 2
		
		_CMD = "THISFORM.BackColor = RGB(" + _par_cBackColor + ")"
		&_CMD
		
		*** AGGIUNGO AL CONTAINER LA SHAPE1 (OPACO) CHE FA DA SFONDO
		THISFORM.container1.ADDOBJECT("shape1","shape")
		THISFORM.container1.shape1.Top = 0
		THISFORM.container1.shape1.Left = 0
		THISFORM.container1.shape1.Height = 40
		THISFORM.container1.shape1.Width = 145
		THISFORM.container1.shape1.BackStyle = 1
		THISFORM.container1.shape1.BackColor = RGB(128,0,255)
		THISFORM.container1.shape1.BorderStyle = 0
		THISFORM.container1.shape1.Name = "Shape1"
		THISFORM.container1.shape1.Visible = .T.
		
		*** AGGIUNGO AL CONTAINER LA LABEL1
		THISFORM.container1.ADDOBJECT("label1","label")
		THISFORM.container1.label1.AutoSize = .F.
		THISFORM.container1.label1.FontBold = .F.
		THISFORM.container1.label1.FontSize = 12
		THISFORM.container1.label1.Alignment = 2
		THISFORM.container1.label1.BackStyle = 0
		THISFORM.container1.label1.Caption = "OK"
		THISFORM.container1.label1.Height = 21
		THISFORM.container1.label1.Left = 0
		THISFORM.container1.label1.Top = 10
		THISFORM.container1.label1.Width = 145
		THISFORM.container1.label1.ForeColor = RGB(255,255,255)
		THISFORM.container1.label1.Name = "Label1"
		THISFORM.container1.label1.Visible = .T.
		
		*** AGGIUNGO AL CONTAINER LA SHAPE2 (TRASPARENTE) CHE ESEGUE GLI EFFETTI GRAFICI DEL BORDO CHE SI ILLUMINA AL PASSAGGIO DEL MOUSE, ED ESEGUE IL CLICK
		THISFORM.container1.ADDOBJECT("shape2","shpMsgWin8Style")
		THISFORM.container1.shape2.Top = 0
		THISFORM.container1.shape2.Left = 0
		THISFORM.container1.shape2.Height = 40
		THISFORM.container1.shape2.Width = 145
		THISFORM.container1.shape2.BackStyle = 0
		THISFORM.container1.shape2.BorderStyle = 1
		THISFORM.container1.shape2.BorderWidth = 1
		THISFORM.container1.shape2.MousePointer = 15
		THISFORM.container1.shape2.BorderColor = RGB(255,255,255)
		THISFORM.container1.shape2.Name = "Shape2"
		THISFORM.container1.shape2.Visible = .T.
		
		THISFORM.container1.Left = THISFORM.edtmessaggio.Left + THISFORM.edtmessaggio.Width + 12
		THISFORM.container1.Top = THISFORM.edtmessaggio.Top + THISFORM.edtmessaggio.Height - THISFORM.container1.Height
		
		RELEASE _NTimeOut,_CDynamicMsg,_NTimeIni
		PUBLIC _NTimeOut,_CDynamicMsg,_NTimeIni
		_NTimeOut = _par_nTimeout
		_CDynamicMsg = _par_cDynamicMsg 
		_NTimeIni = 0

		IF _NTimeOut > 0
			_NTimeIni = SECONDS()
			THISFORM.Timer1.Interval = 1000
		ELSE
			THISFORM.Timer1.Interval = 0
		ENDIF

		THISFORM.Timer1.Timer

		_nome_file_audio = sys(5) + sys(2003) + "\wav\error.wav"
		DO PLAYWAV WITH _nome_file_audio

		WAIT CLEAR

		THISFORM.AutoCenter = .T.
		THISFORM.Visible = .T.
		
	ENDPROC
		
	
	PROCEDURE timer1.Timer

		IF EMPTY(_CDynamicMsg)
			RETURN
		ENDIF

		_NDeltaTime = SECONDS() - _NTimeIni

		IF _NDeltaTime >= (_NTimeOut + 1)
			THISFORM.container1.shape2.click
		ENDIF

		IF _NTimeOut - _NDeltaTime > 0
		ELSE
			_NDeltaTime = _NTimeOut
		ENDIF

		THISFORM.edtmessaggio.Value = &_CDynamicMsg
		THISFORM.edtmessaggio.Refresh
		
	ENDPROC

ENDDEFINE

*** DEFINIZIONE CLASSE PER SHAPE (CHE FA DA PULSANTE OK NEL CONTAINER1)
DEFINE CLASS shpMsgWin8Style AS Shape
	
	PROCEDURE MouseLeave
	
		LPARAMETERS nButton, nShift, nXCoord, nYCoord

		*this.BorderStyle = 0
		THISFORM.container1.shape2.BorderWidth = 1
		
		THIS.Parent.label1.FontBold = .F.
		
		*THIS.Parent.label1.FORECOLOR = RGB(0,0,160)
				
	ENDPROC


	PROCEDURE MouseEnter
	
		LPARAMETERS nButton, nShift, nXCoord, nYCoord

		*this.BorderStyle = 1
		THISFORM.container1.shape2.BorderWidth = 2
		
		THIS.Parent.label1.FontBold = .T.
		
		*THIS.Parent.label1.ForeColor = RGB(255,0,0)
		
	ENDPROC


	PROCEDURE Click
	
		RELEASE THISFORM
		
	ENDPROC

ENDDEFINE
**=> ERASMO - FINE 04/09/2013

*********************************************************
PROCEDURE CONTATORE
*********************************************************

PARAMETERS _TESTO,_NUMERO,_PASSO,_POS_Y,_POS_X,_NOME_WIN

_NUM_PARA=PARAMETERS()

DO CASE
   CASE _NUM_PARA=1
        =MSGBOX("Manca in parametro","ERRORE IN CONTATORE",31)
   CASE _NUM_PARA=2
        _PASSO=1
        _POS_X=10
        _POS_Y=5
        _NOME_WIN="DISPLAY"
   CASE _NUM_PARA=3
        _POS_X=10
        _POS_Y=5
        _NOME_WIN="DISPLAY"
   CASE _NUM_PARA=5
        _NOME_WIN="DISPLAY"
ENDCASE

IF _PASSO=0 .AND. WEXIST(_NOME_WIN)
   RELEASE WINDOW &_NOME_WIN
   RETURN
ENDIF

IF _NUMERO/_PASSO!=INT(_NUMERO/_PASSO)
   RETURN
ENDIF

IF NOT WEXIST(_NOME_WIN) ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".PJX" ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".SCX" ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".MNX" ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".PRG" ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".FRX" ;
	OR UPPER(WTITLE(_NOME_WIN)) == _NOME_WIN+".QPR"
	DEFINE WINDOW &_NOME_WIN ;
		AT _POS_Y,_POS_X ;
		SIZE 4.769,22.800 ;
		FONT "MS Sans Serif", 8 ;
		NOFLOAT ;
		NOCLOSE ;
		NOMINIMIZE ;
		PANEL ;
		COLOR RGB(,,,192,192,192)

   ACTIVATE WINDOW &_NOME_WIN

   @ 0.462,1.200 SAY "conta_BN.bmp" BITMAP ;
	SIZE 2.462,20.400 ;
	STYLE "T"
   @ 3.308,1.800 SAY _TESTO ;
	SIZE 1.000,19.400 ;
	FONT "MS Sans Serif", 8

ENDIF

SS_NUMERO=STR(_NUMERO,6,0)

ACTIVATE WINDOW &_NOME_WIN

@ 0.923,3.000 SAY "n_"+ALLTRIM(SUBSTR(SS_NUMERO,1,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"
@ 0.923,5.800 SAY "N_"+ALLTRIM(SUBSTR(SS_NUMERO,2,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"
@ 0.923,8.600 SAY "N_"+ALLTRIM(SUBSTR(SS_NUMERO,3,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"
@ 0.923,11.400 SAY "N_"+ALLTRIM(SUBSTR(SS_NUMERO,4,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"
@ 0.923,14.200 SAY "N_"+ALLTRIM(SUBSTR(SS_NUMERO,5,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"
@ 0.923,17.000 SAY "N_"+ALLTRIM(SUBSTR(SS_NUMERO,6,1))+".bmp" BITMAP ;
	SIZE 1.462,2.800 ;
	STYLE "T"

RETURN

**************************************************************************
* Funzione - MSGBOX     Data: 28.10.94    Autore: PROJECT S.R.L.
**************************************************************************
FUNCTION MSGBOX
***************
PARAMETERS _STRG,_TITOLO,_TIPO
=messagebox(_STRG,16,_TITOLO)
RETURN(1)




***********************************************************************
PROCEDURE U_AZI_PB
***********************************************************************

REPLACE AZI_NOSKPROD 		WITH M.AZI_NOSKPROD 	&& SERGIO - 18/01/2014
REPLACE AZI_NOCONTI 		WITH M.AZI_NOCONTI 		&& SERGIO - 18/01/2014
REPLACE AZI_NOCAMPICLI 		WITH M.AZI_NOCAMPICLI 	&& SERGIO - 18/01/2014



RETURN

************************
FUNCTION SUBDIR_FILE_PDF
************************
PARAMETERS _par_tipdoc

IF PCOUNT() = 0
	RETURN ""
ENDIF

_SAVE_SELECT=SELECT()

_cRIT = ""

*** CERCO L'EVENTUALE SOTTODIRECTORY CONFIGURATA NELL'APPOSITO PARAMETRO PER QUEL DETERMINATO TIPO DOCUMENTO
v_seek	  = 'FSD' + ALLTRIM(_par_tipdoc)
v_chiave  = "codice"
cSql="select * from para where " + v_chiave + " = '" + v_seek + "'"
IF !ExecCommand(cSql,"PARA")
   return(.f.)
ENDIF
SELECT PARA
IF !EOF()
	IF !EMPTY(LIBERA)
		_cRIT = ALLTRIM(LIBERA)
	ENDIF
ENDIF

SELECT(_SAVE_SELECT)

RETURN _cRIT


**********************
FUNCTION CREA_FILE_PDF
**********************
PARAMETERS _pdf_select,_pdf_report,_pdf_descrizione,_pdf_sotto_directory

IF PCOUNT()=4
	_pdf_sotto_directory____= ALLTRIM(_pdf_sotto_directory)
ELSE 
	_pdf_sotto_directory____= ""
ENDIF

S3S=STR(SELECT())

*!*	PRELEVA LA DIRECTORY OVE MEMORIZZARE I FILE PDF

RELEASE _DIRECTORY_PDF 
PUBLIC _DIRECTORY_PDF 

_KEY_PARA = "FSDEMAIL"
IF !EXECCOMMAND("SELECT * FROM PARA WHERE CODICE='"+_KEY_PARA+"'  ORDER BY CODICE ","CURS_PARA")
   RETURN .F.
ENDIF
IF !EOF()
	SELECT CURS_PARA
	GO TOP
	_DIRECTORY_PDF = ALLTRIM(LIBERA)
ELSE
	_DIRECTORY_PDF  = ""	
ENDIF

IF EMPTY(ALLTRIM(_DIRECTORY_PDF))
	PUB_ERRORE=MESSAGEBOX('percorso in parametro FSD mancante'+CHR(13)+'creare il parametro con chiave EMAIL',64,'*** ATTENZIONE ***')
	RETURN .F.
ENDIF

* -->> creo directory se non esiste
* -------------------------------------
IF DIRECTORY(_DIRECTORY_PDF)
ELSE
	*** SE ESISTE IL VOLUME/UNITA' DI RETE ALLORA CREO LA DIRECTORY
	IF !DIRECTORY(JUSTDRIVE(_DIRECTORY_PDF))
		MESSAGEBOX("Volume o unità di rete '" + JUSTDRIVE(_DIRECTORY_PDF) + "' inesistenti" + CHR(13) + CHR(13) + ;
			"Non sarà possibile creare correttamente i files PDF",48,"Attenzione")
		RETURN .F.
	ELSE
		_COMMAND = "MKDIR &_V_DIRECTORY_FILE_PDF"
		&_COMMAND
	ENDIF
ENDIF

IF  !empty(_pdf_sotto_directory____)
	_DIRECTORY_PDF = _DIRECTORY_PDF+"\"+_pdf_sotto_directory____
	IF DIRECTORY(_DIRECTORY_PDF)
	ELSE
	   *MKDIR &_DIRECTORY_PDF 
		_COMMAND = "MKDIR &_DIRECTORY_PDF"
		&_COMMAND
	ENDIF
ENDIF

IF EMPTY(ALLTRIM(_pdf_descrizione))
	PUB_ERRORE=MESSAGEBOX('MANCA IL NOME DEL FILE PDF'+CHR(13)+'DA CREARE',64,'*** ATTENZIONE ***')
	_pdf_descrizione = "DOCXXX"
ENDIF


*!*	CREA IL FILE PDF

WAIT WINDOWS "Creazione file PDF in corso attendere prego ......" NOWAIT

SET PROCEDURE TO ApiLib additive
DO declare_fun && procedura di ApiLib
_pub_dir_=sys(5)+sys(2003)
set defa to &_pub_dir_	
ActiveConfig  	 = "0"
***tnFileType   	 = "8"
tnFileType   	 = "9"
txtTabella   	 = ALLTRIM(_PDF_SELECT)
txtReportPath	 = sys(5)+sys(2003)+"\"+ALLTRIM(_PDF_REPORT)
txtExportPath	 = _DIRECTORY_PDF+"\"+ALLTRIM(_pdf_descrizione)+".pdf" 
exeAutomatic 	 = 1
txtEmailOutput   = ""
txtOggettoOutput = ""
_SAVE_PUB_NOLOGO = PUB_NOLOGO
PUB_NOLOGO		 = .F.
do PRG\creapdf1 with ActiveConfig,tnFileType,txtTabella,txtReportPath,txtExportPath,exeAutomatic,txtEmailOutput,txtOggettoOutput
PUB_NOLOGO       = _SAVE_PUB_NOLOGO 
SET DEFA TO &PUB_DIR

*!*	**=> ERASMO - INIZIO 14/08/2008
*!*	RELEASE FILE_PDF_APPENA_GENERATO
*!*	PUBLIC FILE_PDF_APPENA_GENERATO
*!*	FILE_PDF_APPENA_GENERATO = txtExportPath
*!*	**=> ERASMO - FINE 14/08/2008

FILE_PDF_APPENA_GENERATO = IIF(EMPTY(FILE_PDF_APPENA_GENERATO),txtExportPath,FILE_PDF_APPENA_GENERATO + " ; " + txtExportPath)  && ERASMO - 06/06/2011

SELECT &S3S

RETURN

************************************************************************
FUNCTION GET_GRIDCONF
************************************************************************
LPARAMETERS _par_objectref,_par_chiave_opzionale

IF PCOUNT() < 1
	MESSAGEBOX("Parametri insufficienti",16,"Attenzione")
	RETURN .F.
ENDIF

**=> ERASMO - INIZIO 24/04/2014
IF PCOUNT() >= 2
ELSE
	_par_chiave_opzionale = ""
ENDIF
**=> ERASMO - FINE 24/04/2014

IF TYPE("_par_objectref") == "O" AND !ISNULL(_par_objectref)
ELSE
	MESSAGEBOX("Nessun oggetto di riferimento alla griglia",16,"Attenzione")
	RETURN .F.
ENDIF

_O_ObjectRef = _par_objectref
IF _O_ObjectRef.baseclass = "Grid"
ELSE
	MESSAGEBOX("L'oggetto chiamante non è una griglia",16,"Attenzione")
	RETURN .F.
ENDIF

*** PRELEVO LE INFORMAZIONI SUL PROGRAMMA CHIAMAMNTE
ASTACKINFO(ArrayStackInfo)
_nStackLevels = ALEN(ArrayStackInfo, 1)
_nCallingLevel = _nStackLevels - 1
_cCallingProgramFileName = UPPER(ALLTRIM(ArrayStackInfo(_nCallingLevel,2)))
_C_SrcFileName = ALLTRIM(STRTRAN(UPPER(ALLTRIM(_cCallingProgramFileName)),UPPER(SYS(5)+SYS(2003)),""))

*** PRELEVO LE INFORMAZIONI SUL NOME COMPLETO DELLA GRIGLIA
_C_GridName = ALLTRIM(_O_ObjectRef.Name)
cParent = "_O_ObjectRef"
DO WHILE .T.
	cParent = cParent + ".Parent"
	IF TYPE(cParent) == "O" AND !ISNULL(&cParent)
		cParentName = cParent + ".Name"
		_C_GridName = ALLTRIM(&cParentName) + "." + _C_GridName
	ELSE
		EXIT
	ENDIF
ENDDO
_C_GridName = ALLTRIM(UPPER(_C_GridName))

IF USED("CX_IDGRIDCONF")
	SELECT CX_IDGRIDCONF
	USE
ENDIF
IF USED("CX_GRIDCONF")
	SELECT CX_GRIDCONF
	USE
ENDIF
x_fnam = "SRCFILENAME = '" + _C_SrcFileName + "'"
x_gnam = "GRIDNAME = '" + _C_GridName + "'"
x_keyo = "KEYOPZ = '" + _par_chiave_opzionale + "'"  && ERASMO - 24/04/2014
x_user = "UTENTI LIKE '%" + PUB_CODOPE + "%'"
*x_cond = x_fnam + " and " + x_gnam + " and " + x_user 
x_cond = x_fnam + " and " + x_gnam + " and " + x_keyo + " and " + x_user  && ERASMO - 24/04/2014
cSql = "SELECT IDGRIDCONF FROM GRIDCONF WHERE " + x_cond + " GROUP BY IDGRIDCONF"
IF !ExecCommand(cSql,"CX_IDGRIDCONF")
	return(.f.)
ENDIF
SELECT CX_IDGRIDCONF
GO TOP
IF EOF()
	x_fnam = "SRCFILENAME = '" + _C_SrcFileName + "'"
	x_gnam = "GRIDNAME = '" + _C_GridName + "'"
	x_keyo = "KEYOPZ = '" + _par_chiave_opzionale + "'"  && ERASMO - 24/04/2014
	x_user = "SUBSTRING(UTENTI,1,10) = ''"
	*x_cond = x_fnam + " and " + x_gnam + " and " + x_user 
	x_cond = x_fnam + " and " + x_gnam + " and " + x_keyo + " and " + x_user  && ERASMO - 24/04/2014
	cSql = "SELECT IDGRIDCONF FROM GRIDCONF WHERE " + x_cond + " GROUP BY IDGRIDCONF"
	IF !ExecCommand(cSql,"CX_IDGRIDCONF")
		return(.f.)
	ENDIF
	SELECT CX_IDGRIDCONF
	GO TOP
	IF EOF()
		RETURN .F.
	ENDIF
ENDIF

SELECT CX_IDGRIDCONF
GO TOP
_IDGRIDCONF = IDGRIDCONF
x_idgc = "IDGRIDCONF = '" + _IDGRIDCONF + "'"
x_cond = x_idgc
cSql = "SELECT * FROM GRIDCONF WHERE " + x_cond
IF !ExecCommand(cSql,"CX_GRIDCONF")
	return(.f.)
ENDIF
SELECT CX_GRIDCONF
GO TOP
IF EOF()
	RETURN .F.
ENDIF
SCAN
	_cObject = "_O_ObjectRef." + ALLTRIM(COLUMNNAME)
	IF TYPE(_cObject) == "O" AND !ISNULL(&_cObject)
		_cColumnBaseClass = _cObject + ".BaseClass = 'Column'"
		IF &_cColumnBaseClass
			_cColumnOrder = _cObject + ".ColumnOrder = " + ALLTRIM(STR(ORDINAMENTO))
			_cVisible = _cObject + ".Visible = " + IIF(VISIBILE,".T.",".F.")
			_cWidth = _cObject + ".Width = " + ALLTRIM(STR(LARGHEZZA))
			&_cColumnOrder
			&_cVisible
			&_cWidth
		ENDIF
	ENDIF
	
	_cObject = "_O_ObjectRef." + ALLTRIM(COLUMNNAME) + "." + ALLTRIM(HEADERNAME)
	IF TYPE(_cObject) == "O" AND !ISNULL(&_cObject)
		_cHeaderBaseClass = _cObject + ".BaseClass = 'Header'"
		IF &_cHeaderBaseClass 
			_cCaption = _cObject + ".Caption = '" + ALLTRIM(INTESTAZIONE) + "'"
			&_cCaption
		ENDIF
	ENDIF	
ENDSCAN

RETURN .T.

************************************************
PROCEDURE VEDO_SINGOLO_UTENTE
************************************************
LPARAMETERS  _P_USERID

LOCAL _USERID

_USERID=""
IF PCOUNT()>0
	_USERID=_P_USERID
ENDIF

DO VEDO_UTENTI WITH _USERID
SELECT CVEDO_UTENTI
DELETE FOR USERID!=_P_USERID



************************************************
PROCEDURE VEDO_UTENTI
************************************************
LPARAMETERS  _USERID

IF PCOUNT()<1
	RETURN
ENDIF

LOCAL cSql,cNomeCursorSql,_CANCELLARE,_RUOLO_SUP,_FLAG_RUOLO_IN_ORGANIGRAMMA,_SONO_ROOT

_SONO_ROOT=.F.
_FLAG_RUOLO_IN_ORGANIGRAMMA=.F.

*** VERIFICO ESISTENZA UTENTE
cSql=""     
cNomeCursorSql="_TEMP"

TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
	SELECT * FROM RES_OPER WHERE CODICE ='<<_USERID>>'
ENDTEXT					&& FINE SCRITTURA QUERY

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF	

SELECT _TEMP
IF RECCOUNT()=0
	=MESSAGEBOX("L'utente "+_USERID+" non esiste.",48,"Attenzione")
	*** SE L'UTENTE NON ESISTE NON POSSO VEDERE NESSUN ALTRO UTENTE DI NESSUN RUOLO
	*** PERO' DEVO COMUNQUE RESTITUIRE UN CURSOR CVEDO_UTENTI
	*** PER CONSENTIRE AI PROGRAMMI CHE RICHIAMANO QUESTA PROCEDURA
	*** DI NON ANDARE IN ERRORE
ELSE

	*** 2) VERIFICO SE L'UTENTE E' ASSEGNATO AD UN RUOLO
	cSql=""     
	cNomeCursorSql="CMIEI_RUOLI"

	TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
		SELECT 
			UXR.RUOLO,
			ORG.RUOLO_SUP
		FROM UTENTIXRUOLI AS UXR
		LEFT OUTER JOIN ORGANIGRAMMA AS ORG 
		ON UXR.RUOLO=ORG.RUOLO 
		WHERE UXR.USERID='<<_USERID>>'
	ENDTEXT					&& FINE SCRITTURA QUERY

	IF !ExecPreparedCommand(cSql,cNomeCursorSql)
		return(.F.)
	ENDIF	

	SELECT CMIEI_RUOLI
	INDEX ON RUOLO TAG RUOLO
	
	IF RECCOUNT()=0
		=MESSAGEBOX("L'utente "+_USERID+" non è assegnato ad un ruolo.",48,"Attenzione")
		*** SE L'UTENTE NON E' ASSEGNATO A NESSUN RUOLO, NON POSSO VEDERE NESSUN ALTRO UTENTE DI NESSUN RUOLO
		*** PERO' DEVO COMUNQUE RESTITUIRE UN CURSOR CVEDO_UTENTI
		*** PER CONSENTIRE AI PROGRAMMI CHE RICHIAMANO QUESTA PROCEDURA
		*** DI NON ANDARE IN ERRORE
	ELSE
	
		_FLAG_RUOLO_IN_ORGANIGRAMMA=.F.
		_SONO_ROOT=.F.
		
		SELECT CMIEI_RUOLI
		GO TOP
		DO WHILE !EOF()
			
			IF ISNULL(RUOLO_SUP)
				SKIP
				LOOP
			ENDIF	
			
			_FLAG_RUOLO_IN_ORGANIGRAMMA=.T.
			
			*** SE IL CAMPO RUOLO_SUP E' VUOTO E NON NULL
			*** ALLORA UNO DEI MIEI RUOLI E' RADICE DELL'ALBERO
			*** E POSSO VEDERE TUTTI GLI ALTRI NODI
			IF EMPTY(RUOLO_SUP)
				_SONO_ROOT=.F.
			ENDIF	
			
			SKIP
			
		ENDDO
		
	ENDIF
	
	
ENDIF

*** COSTRUISCO L'INTERO ORGANIGRAMMA
cSql=""     
cNomeCursorSql="CVEDO_UTENTI"

TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
	SELECT 
		OPE.CODICE AS USERID,
		OPE.DESCRI AS NOME_UTENTE,
		COALESCE(ORG.RUOLO,'') AS RUOLO,
		COALESCE(RUO.DESCRI,'') AS DESCR_RUOLO,
		COALESCE(ORG.RUOLO_SUP,'') AS RUOLO_SUP,
		COALESCE(RUOSUP.DESCRI,'') AS DESCR_RUOLO_SUP,
		AUT.VEDE_TUTTI AS VEDE_TUTTI,
		AUT.INSERIMENTO AS INSERIMENTO,
		AUT.MODIFICA AS MODIFICA,
		AUT.ANNULLO AS ANNULLO,
		AUT.STAMPA AS STAMPA,
		AUT.AUT_LIVELLO1 AS AUT_LIVELLO1,
		AUT.AUT_LIVELLO2 AS AUT_LIVELLO2,
		AUT.AUT_LIVELLO3 AS AUT_LIVELLO3,
		AUT.AUT_LIVELLO4 AS AUT_LIVELLO4,
		AUT.AUT_LIVELLO5 AS AUT_LIVELLO5,
		AUT.MOSTRA_PREZZI AS MOSTRA_PREZZI,
		AUT.MOSTRA_FORNITORI AS MOSTRA_FORNITORI,
		AUT.TES_CLIENTI AS TES_CLIENTI,
		AUT.TES_FORNITORI AS TES_FORNITORI,
		AUT.TES_RIBA AS TES_RIBA,    
		AUT.TES_F24 AS TES_F24,    
		AUT.TES_CBI AS TES_CBI,    
		AUT.TES_STIPENDI AS TES_STIPENDI,
		AUT.NR_PRPROD      AS NR_PRPROD,
		AUT.ST_DAPROD      AS ST_DAPROD,
		AUT.ST_INPROD      AS ST_INPROD,
		AUT.ST_PRODOTTO    AS ST_PRODOTTO,
		AUT.ST_PROD_SOSPESA AS ST_PROD_SOSPESA,
		AUT.ST_RESET       AS ST_RESET,
		AUT.ST_MULTI       AS ST_MULTI,
		AUT.NR_PZ_PRODOTTI AS NR_PZ_PRODOTTI,
		AUT.NR_PZ_DAPROD   AS NR_PZ_DAPROD,
		AUT.DOC_SELEZIONA AS DOC_SELEZIONA,
		AUT.DOC_STAMPA    AS DOC_STAMPA,
		AUT.DOC_PDF       AS DOC_PDF,
		AUT.DOC_MAIL      AS DOC_MAIL,
		AUT.ANACLI_VIS AS ANACLI_VIS,
		AUT.ANACLI_INS AS ANACLI_INS,
		AUT.ANACLI_MOD AS ANACLI_MOD,
		AUT.ANACLI_ANN AS ANACLI_ANN,
		AUT.ANAFOR_VIS AS ANAFOR_VIS,
		AUT.ANAFOR_INS AS ANAFOR_INS,
		AUT.ANAFOR_MOD AS ANAFOR_MOD,
		AUT.ANAFOR_ANN AS ANAFOR_ANN,
		AUT.DOC_TIPIDOC AS DOC_TIPIDOC,
		AUT.DOC_DEFADOC AS DOC_DEFADOC,
		AUT.ANAART_VIS AS ANAART_VIS,
		AUT.ANAART_INS AS ANAART_INS,
		AUT.ANAART_MOD AS ANAART_MOD,
		AUT.ANAART_ANN AS ANAART_ANN
	FROM RES_OPER AS OPE
	LEFT OUTER JOIN UTENTIXRUOLI AS UXR
	ON UXR.USERID=OPE.CODICE AND OPE.SOCIETA='<<PUB_CODSOC>>'
	LEFT OUTER JOIN  ORGANIGRAMMA AS ORG
	ON ORG.RUOLO = UXR.RUOLO
	LEFT OUTER JOIN PARA AS RUO
	ON RUO.CODICE='RUO'+ORG.RUOLO
	LEFT OUTER JOIN PARA AS RUOSUP
	ON RUOSUP.CODICE='RUO'+ORG.RUOLO_SUP
	LEFT OUTER JOIN AUTORIZZAZIONI AS AUT
	ON UXR.USERID=AUT.USERID AND UXR.RUOLO=AUT.RUOLO
ENDTEXT					&& FINE SCRITTURA QUERY

IF !ExecPreparedCommand(cSql,cNomeCursorSql)
	return(.F.)
ENDIF	



SELECT CVEDO_UTENTI
INDEX ON USERID TAG USERID

SELECT CVEDO_UTENTI
IF RECCOUNT()=0
	RETURN
ENDIF


*** SE NON HO NESSUN RUOLO ALLORA NON POSSO VEDERE NESSUNO
SELECT CMIEI_RUOLI
IF RECCOUNT()=0
	SELECT CVEDO_UTENTI
	DELETE ALL
	RETURN
ENDIF

*** SE IL MIO RUOLO NON E' IN ORGANIGRAMMA ALLORA NON POSSO VEDERE NESSUNO
IF !_FLAG_RUOLO_IN_ORGANIGRAMMA
	=MESSAGEBOX("I ruoli assegati all'utente "+_USERID+" non sono collocati nell'organigramma.",48,"Attenzione")
	*** PERO' DEVO COMUNQUE RESTITUIRE UN CURSOR CVEDO_UTENTI
	*** PER CONSENTIRE AI PROGRAMMI CHE RICHIAMANO QUESTA PROCEDURA
	*** DI NON ANDARE IN ERRORE
	SELECT CVEDO_UTENTI
	DELETE ALL
	RETURN
ENDIF

*** SE UNO DEI MIEI RUOLI E' RADICE DELL'ALBERO
*** E POSSO VEDERE TUTTI GLI ALTRI NODI
*** NON CANCELLO NESSUNO
IF _SONO_ROOT
	SELECT CVEDO_UTENTI
	RETURN
ENDIF

*** ANALIZZO L'ORGANIGRAMMA E CANCELLO TUTTI I NODI CHE NON POSSO VEDERE
SELECT CVEDO_UTENTI
GO TOP
DO WHILE !EOF()

	IF DELETED()
		SELECT CVEDO_UTENTI
		SKIP
		LOOP
	ENDIF
	
	_V_RUOLO=ALLTRIM(RUOLO)
	_V_RUOLO_SUP=ALLTRIM(RUOLO_SUP)
	
	_QUESTO_LO_VEDO=.F.
	SELECT CMIEI_RUOLI	
	GO TOP 
	DO WHILE !EOF()
		*IF ALLTRIM(RUOLO)=_V_RUOLO
		IF ALLTRIM(RUOLO)==_V_RUOLO  && ERASMO - 02/09/2011
			_QUESTO_LO_VEDO=.T.
		ENDIF 
		
		*IF ALLTRIM(RUOLO)=_V_RUOLO_SUP
		IF ALLTRIM(RUOLO)==_V_RUOLO_SUP  && ERASMO - 02/09/2011
			_QUESTO_LO_VEDO=.T.
		ENDIF 				
		SKIP
	ENDDO
	
	IF _QUESTO_LO_VEDO
		SELECT CVEDO_UTENTI
		SKIP
		LOOP
	ENDIF	
	
	
	_CANCELLARE=.T.
	
	*** CONTROLLO SE IL RUOLO E' SOTTO AL MIO RUOLO
	*** SE NON E' SOTTO DI ME LO DEVO CANCELLARE PERCHE' NON POSSO VEDERLO
	DO WHILE .T.
	
		*IF _V_RUOLO_SUP=""
		IF EMPTY(_V_RUOLO_SUP)  && ERASMO - 02/09/2011
			EXIT
		ENDIF
		
		cSql=""     
		cNomeCursorSql="CRICORSIVO"

		TEXT TO cSql NOSHOW  	&& INIZIO SCRITTURA QUERY
			SELECT * FROM ORGANIGRAMMA WHERE RUOLO ='<<_V_RUOLO_SUP>>'
		ENDTEXT					&& FINE SCRITTURA QUERY

		IF !ExecPreparedCommand(cSql,cNomeCursorSql)
			return(.F.)
		ENDIF	
		
		SELECT CRICORSIVO
		IF RECCOUNT()=0
			EXIT
		ENDIF
		
		_CRICORSIVO_RUOLO_SUP=ALLTRIM(RUOLO_SUP)
		
		*** SE IL SUPERIORE SONO IO: POSSO VEDERLO
		_IL_SUPERIORE_SONO_IO=.F.
		SELECT CMIEI_RUOLI	
		GO TOP 
		DO WHILE !EOF()
			*IF _CRICORSIVO_RUOLO_SUP=RUOLO
			IF ALLTRIM(_CRICORSIVO_RUOLO_SUP)==ALLTRIM(RUOLO)  && ERASMO - 02/09/2011
				_IL_SUPERIORE_SONO_IO=.T.
				EXIT
			ENDIF
			SKIP
		ENDDO		
		IF _IL_SUPERIORE_SONO_IO
			_CANCELLARE=.F.
			EXIT
		ENDIF
		
		
		SELECT CRICORSIVO
		_V_RUOLO_SUP=RUOLO_SUP
	
	ENDDO
	
	IF !_CANCELLARE
		SELECT CVEDO_UTENTI
		SKIP
		LOOP
	ENDIF

	SELECT CVEDO_UTENTI
	DELETE
	SKIP
ENDDO

SELECT CVEDO_UTENTI
GO TOP 
DO WHILE !EOF()

	IF DELETED()
		SKIP
		LOOP
	ENDIF 
	
	LOCAL _VEDE_TUTTI,_INSERIMENTO,_MODIFICA,_ANNULLO,_STAMPA,_AUT_LIVELLO1,_AUT_LIVELLO2,_AUT_LIVELLO3,_AUT_LIVELLO4,_AUT_LIVELLO5,_MOSTRA_PREZZI,_MOSTRA_FORNITORI,_TES_CLIENTI,_TES_FORNITORI,_TES_STIPENDI,_TES_RIBA,_TES_F24,_TES_CBI,_NR_PRPROD,_ST_DAPROD,_ST_INPROD,_ST_PRODOTTO,_ST_PROD_SOSPESA,_ST_RESET,_ST_MULTI,_NR_PZ_PRODOTTI,_NR_PZ_DAPROD,_DOC_SELEZIONA,_DOC_STAMPA,_DOC_PDF,_DOC_MAIL
	
	_VEDE_TUTTI       =.F.
	_INSERIMENTO      =.F.
	_MODIFICA         =.F.
	_ANNULLO          =.F.
	_STAMPA           =.F.
	_AUT_LIVELLO1     =.F.
	_AUT_LIVELLO2     =.F.
	_AUT_LIVELLO3     =.F.
	_AUT_LIVELLO4     =.F.
	_AUT_LIVELLO5     =.F.
	_MOSTRA_PREZZI    =.F.
	_MOSTRA_FORNITORI =.F.
	_TES_CLIENTI      =.F.
	_TES_FORNITORI    =.F.
	_TES_STIPENDI     =.F.
	_TES_RIBA         =.F.
	_TES_F24          =.F.
	_TES_CBI          =.F.
	_NR_PRPROD	      =.F.
	_ST_DAPROD	      =.F.
	_ST_INPROD	      =.F.
	_ST_PRODOTTO	  =.F.
	_ST_PROD_SOSPESA  =.F.
	_ST_RESET         =.F.
	_ST_MULTI	      =.F.
	_NR_PZ_PRODOTTI	  =.F.
	_NR_PZ_DAPROD	  =.F.	
	_DOC_SELEZIONA	  =.T.
	_DOC_STAMPA       =.T.
	_DOC_PDF          =.T.
	_DOC_MAIL         =.T.	

	_USERID= ALLTRIM(USERID)
	_RUOLO = ALLTRIM(RUOLO)

	cSql = "SELECT * FROM AUTORIZZAZIONI WHERE USERID='"+_USERID+"' AND RUOLO='"+_RUOLO+"'"
	IF !ExecCommand(cSql,"AUTORIZZAZIONI")
	  RETURN(.F.)
	ENDIF
		
	SELECT AUTORIZZAZIONI
	IF RECCOUNT()>0

		_VEDE_TUTTI       = VEDE_TUTTI      
		_INSERIMENTO      = INSERIMENTO     
		_MODIFICA         = MODIFICA        
		_ANNULLO          = ANNULLO         
		_STAMPA           = STAMPA          
		_AUT_LIVELLO1     = AUT_LIVELLO1    
		_AUT_LIVELLO2     = AUT_LIVELLO2    
		_AUT_LIVELLO3     = AUT_LIVELLO3    
		_AUT_LIVELLO4     = AUT_LIVELLO4    
		_AUT_LIVELLO5     = AUT_LIVELLO5    
		_MOSTRA_PREZZI    = MOSTRA_PREZZI   
		_MOSTRA_FORNITORI = MOSTRA_FORNITORI
		_TES_CLIENTI	  = TES_CLIENTI	
		_TES_FORNITORI    = TES_FORNITORI    	
		_TES_STIPENDI     = TES_STIPENDI     	
		_TES_RIBA         = TES_RIBA         	
		_TES_F24          = TES_F24          	
		_TES_CBI          = TES_CBI       
		_NR_PRPROD		  = NR_PRPROD
		_ST_DAPROD		  = ST_DAPROD
		_ST_INPROD		  = ST_INPROD
		_ST_PRODOTTO	  = ST_PRODOTTO
		_ST_PROD_SOSPESA  = ST_PROD_SOSPESA
		_ST_RESET         = ST_RESET
		_ST_MULTI	      = ST_MULTI
		_NR_PZ_PRODOTTI	  = NR_PZ_PRODOTTI
		_NR_PZ_DAPROD	  = NR_PZ_DAPROD   
		_DOC_SELEZIONA    = DOC_SELEZIONA
		_DOC_STAMPA       = DOC_STAMPA   
		_DOC_PDF          = DOC_PDF      
		_DOC_MAIL         = DOC_MAIL     		  		   	

	ELSE

		cSql = "SELECT * FROM AUTORIZZAZIONI WHERE RUOLO='"+_RUOLO+"'"
		IF !ExecCommand(cSql,"CAUT_RUOLO")
		  RETURN(.F.)
		ENDIF
		
		SELECT CAUT_RUOLO
		IF RECCOUNT()>0
			_VEDE_TUTTI       = VEDE_TUTTI      
			_INSERIMENTO      = INSERIMENTO     
			_MODIFICA         = MODIFICA        
			_ANNULLO          = ANNULLO         
			_STAMPA           = STAMPA          
			_AUT_LIVELLO1     = AUT_LIVELLO1    
			_AUT_LIVELLO2     = AUT_LIVELLO2    
			_AUT_LIVELLO3     = AUT_LIVELLO3    
			_AUT_LIVELLO4     = AUT_LIVELLO4    
			_AUT_LIVELLO5     = AUT_LIVELLO5    
			_MOSTRA_PREZZI    = MOSTRA_PREZZI   
			_MOSTRA_FORNITORI = MOSTRA_FORNITORI
			_TES_CLIENTI	  = TES_CLIENTI	
			_TES_FORNITORI    = TES_FORNITORI    	
			_TES_STIPENDI     = TES_STIPENDI     	
			_TES_RIBA         = TES_RIBA         	
			_TES_F24          = TES_F24          	
			_TES_CBI          = TES_CBI     
			_NR_PRPROD		  = NR_PRPROD
			_ST_DAPROD		  = ST_DAPROD
			_ST_INPROD		  = ST_INPROD
			_ST_PRODOTTO	  = ST_PRODOTTO
			_ST_PROD_SOSPESA  = ST_PROD_SOSPESA
			_ST_RESET         = ST_RESET
			_ST_MULTI	      = ST_MULTI
			_NR_PZ_PRODOTTI	  = NR_PZ_PRODOTTI
			_NR_PZ_DAPROD	  = NR_PZ_DAPROD     			     	
			_DOC_SELEZIONA    = DOC_SELEZIONA
			_DOC_STAMPA       = DOC_STAMPA   
			_DOC_PDF          = DOC_PDF      
			_DOC_MAIL         = DOC_MAIL     
		ENDIF
		
	ENDIF
	
	SELECT CVEDO_UTENTI
	REPLACE VEDE_TUTTI       WITH IIF(ISNULL(_VEDE_TUTTI)       ,.F.,_VEDE_TUTTI)
	REPLACE INSERIMENTO      WITH IIF(ISNULL(_INSERIMENTO)	    ,.F.,_INSERIMENTO)
	REPLACE MODIFICA         WITH IIF(ISNULL(_MODIFICA)         ,.F.,_MODIFICA)
	REPLACE ANNULLO          WITH IIF(ISNULL(_ANNULLO)          ,.F.,_ANNULLO)
	REPLACE STAMPA           WITH IIF(ISNULL(_STAMPA)           ,.F.,_STAMPA)
	REPLACE AUT_LIVELLO1     WITH IIF(ISNULL(_AUT_LIVELLO1)     ,.F.,_AUT_LIVELLO1)
	REPLACE AUT_LIVELLO2     WITH IIF(ISNULL(_AUT_LIVELLO2)     ,.F.,_AUT_LIVELLO2)
	REPLACE AUT_LIVELLO3     WITH IIF(ISNULL(_AUT_LIVELLO3)     ,.F.,_AUT_LIVELLO3)
	REPLACE AUT_LIVELLO4     WITH IIF(ISNULL(_AUT_LIVELLO4)     ,.F.,_AUT_LIVELLO4)
	REPLACE AUT_LIVELLO5     WITH IIF(ISNULL(_AUT_LIVELLO5)     ,.F.,_AUT_LIVELLO5)
	REPLACE MOSTRA_PREZZI    WITH IIF(ISNULL(_MOSTRA_PREZZI)    ,.F.,_MOSTRA_PREZZI)
	REPLACE MOSTRA_FORNITORI WITH IIF(ISNULL(_MOSTRA_FORNITORI) ,.F.,_MOSTRA_FORNITORI)
	REPLACE TES_CLIENTI      WITH IIF(ISNULL(_TES_CLIENTI)      ,.F.,_TES_CLIENTI)
	REPLACE TES_FORNITORI    WITH IIF(ISNULL(_TES_FORNITORI)    ,.F.,_TES_FORNITORI)
	REPLACE TES_STIPENDI     WITH IIF(ISNULL(_TES_STIPENDI)     ,.F.,_TES_STIPENDI)
	REPLACE TES_RIBA         WITH IIF(ISNULL(_TES_RIBA)         ,.F.,_TES_RIBA)
	REPLACE TES_F24          WITH IIF(ISNULL(_TES_F24)          ,.F.,_TES_F24)
	REPLACE TES_CBI          WITH IIF(ISNULL(_TES_CBI)          ,.F.,_TES_CBI)
	REPLACE NR_PRPROD        WITH IIF(ISNULL(_NR_PRPROD     ),.F.,_NR_PRPROD     )
	REPLACE ST_DAPROD        WITH IIF(ISNULL(_ST_DAPROD     ),.F.,_ST_DAPROD     )
	REPLACE ST_INPROD        WITH IIF(ISNULL(_ST_INPROD     ),.F.,_ST_INPROD     )
	REPLACE ST_PRODOTTO      WITH IIF(ISNULL(_ST_PRODOTTO   ),.F.,_ST_PRODOTTO   )
	REPLACE ST_PROD_SOSPESA  WITH IIF(ISNULL(_ST_PROD_SOSPESA   ),.F.,_ST_PROD_SOSPESA)
	REPLACE ST_RESET         WITH IIF(ISNULL(_ST_RESET   ),.F.,_ST_RESET)
	REPLACE ST_MULTI         WITH IIF(ISNULL(_ST_MULTI      ),.F.,_ST_MULTI      )
	REPLACE NR_PZ_PRODOTTI   WITH IIF(ISNULL(_NR_PZ_PRODOTTI),.F.,_NR_PZ_PRODOTTI)
	REPLACE NR_PZ_DAPROD     WITH IIF(ISNULL(_NR_PZ_DAPROD  ),.F.,_NR_PZ_DAPROD  )	
	REPLACE DOC_SELEZIONA WITH IIF(ISNULL(_DOC_SELEZIONA ),.T.,_DOC_SELEZIONA  )
	REPLACE DOC_STAMPA    WITH IIF(ISNULL(_DOC_STAMPA    ),.T.,_DOC_STAMPA     )
	REPLACE DOC_PDF       WITH IIF(ISNULL(_DOC_PDF       ),.T.,_DOC_PDF        )
	REPLACE DOC_MAIL      WITH IIF(ISNULL(_DOC_MAIL      ),.T.,_DOC_MAIL       )	
	
	SKIP
	LOOP 
ENDDO

***** FABIANO 29/08/2011 - FINE
SELECT CVEDO_UTENTI
GO TOP 


ENDPROC



