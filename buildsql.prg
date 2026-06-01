
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
