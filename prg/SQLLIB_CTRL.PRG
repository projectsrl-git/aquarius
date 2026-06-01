


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
			*=MESSAGEBOX("Num.database alternativo non previsto",48,"*** ATTENZIONE ***")
			WAIT WINDOWS "Num.database alternativo non previsto" TIMEOUT 2
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
  	*=MESSAGEBOX("Errore connessione SQL",16,"*** ATTENZIONE ***")
  	WAIT WINDOWS "Errore connessione SQL" TIMEOUT 2
	RETURN(.f.)
ELSE
  SELECT ALLTRIM(STRINGA) AS cString FROM STRINGSQL WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED() INTO CURSOR _TMP
  IF _TALLY = 0
		*=MESSAGEBOX("Errore connessione SQL",16,"*** ATTENZIONE ***")
		WAIT WINDOWS "Errore connessione SQL" TIMEOUT 2
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
      	*=MESSAGEBOX("Errore connessione SQL",16,"*** ATTENZIONE ***")
      	WAIT WINDOWS "Errore connessione SQL" TIMEOUT 2
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
*********************************************************************************************

PARAMETERS _stringsql,_nomesql

IF pub_sqlhd < 1
	IF !ExecConnect()
	  return(.f.)
	ENDIF 
ENDIF

_RT=SQLEXEC(pub_sqlhd, _stringsql, _nomesql)
IF _RT < 0
	*=MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
	WAIT WINDOWS "Errore durante creazione del cursore STP ("+_nomesql+")" TIMEOUT 2
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
		IF !TABLEUPDATE(2, .T., _nomesql)
			*MESSAGEBOX(MESSAGE())
			WAIT WINDOWS MESSAGE() TIMEOUT 2
			TABLEREVERT(.T.,_nomesql)
			RETURN(.f.)
		ENDIF
		USE IN &_nomesql

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


= SQLPREPARE(pub_sqlhd, _stringsql,_nomesql)
_RT=SQLEXEC(pub_sqlhd)
IF _RT < 0
	*=MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
	WAIT WINDOWS "Errore durante creazione del cursore STP ("+_nomesql+")" TIMEOUT 2
*	SQLDISCONNECT(pub_sqlhd)
*	pub_sqlhd=0
	RETURN(.f.)
ENDIF 
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
		*MESSAGEBOX("Il file "+ALLTRIM(_sqlQueryFile)+" e' vuoto o non valido.",48,"Attenzione!")
		WAIT WINDOWS "Il file "+ALLTRIM(_sqlQueryFile)+" e' vuoto o non valido." TIMEOUT 2
		RETURN(.f.)
	ELSE
		* If file is not empty, the program stores its contents
		* in memory, then displays the text on the main Visual FoxPro window
		= FSEEK(gnFileHandle, 0, 0)      && Move pointer to BOF
		_stringsql= FREAD(gnFileHandle, nSize)
	ENDIF
	= FCLOSE(gnFileHandle)         && Close the file
ELSE 	
	 *MESSAGEBOX("Il file "+ALLTRIM(_sqlQueryFile)+" non esiste.",48,"Attenzione!")
	 WAIT WINDOWS "Il file "+ALLTRIM(_sqlQueryFile)+" non esiste." TIMEOUT 2
	 RETURN(.f.)
ENDIF

= SQLPREPARE(pub_sqlhd, _stringsql,_nomesql)
_RT=SQLEXEC(pub_sqlhd)
IF _RT < 0
	*=MESSAGEBOX("Errore durante creazione del cursore STP ("+_nomesql+")",16,"*** ATTENZIONE ***")
	WAIT WINDOWS "Errore durante creazione del cursore STP ("+_nomesql+")" TIMEOUT 2
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
         *_RISP = MESSAGEBOX("File DBSOCIETA.DBF vuoto" + CHR(13) + CHR(13) + "Aprire l'utilità di configurazione del DBSOCIETA?",64+4,"Attenzione")
         *IF _RISP = 6
         *   IF USED("DBSOCIETA")
         *      SELECT DBSOCIETA
         *      USE
         *   ENDIF
         *   DO CONFIGURA_DBSOCIETA
         *   LOOP
         *ELSE
         *   MESSAGEBOX("File DBSOCIETA.DBF vuoto per lo startup di Aquarius su questa postazione",16,"*** ATTENZIONE ***")
         *   QUIT
         *ENDIF
         WAIT WINDOWS "File DBSOCIETA.DBF vuoto per lo startup di Aquarius su questa postazione" TIMEOUT 2
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
      *_RISP = MESSAGEBOX("File DBSOCIETA.DBF inesistente" + CHR(13) + CHR(13) + "Aprire l'utilità di configurazione del DBSOCIETA?",64+4,"Attenzione")
      *IF _RISP = 6
      *   IF USED("DBSOCIETA")
      *      SELECT DBSOCIETA
      *      USE
      *   ENDIF
      *   DO CONFIGURA_DBSOCIETA
      *   LOOP
      *ELSE
      *   MESSAGEBOX("File DBSOCIETA.DBF inesistente per lo startup di Aquarius su questa postazione",16,"*** ATTENZIONE ***")
      *   QUIT
      *ENDIF
      WAIT WINDOWS "File DBSOCIETA.DBF inesistente per lo startup di Aquarius su questa postazione" TIMEOUT 2
      QUIT
   ENDIF
ENDDO
   
RETURN
*********************************************************************************************
* End PROCEDURE InitializeStringsql
*********************************************************************************************

