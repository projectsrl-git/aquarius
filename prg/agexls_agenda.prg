CLOSE DATABASES all
_tblfox = 'U_AGN_AN'

* -->> nomi cursori, tabelle sql, tabelle fox
* --------------------------------------------
_nomecur="C"+JUSTSTEM(_tblfox)
_nomesql=JUSTSTEM(_tblfox)
_nomefox=JUSTSTEM(_tblfox)


* -->> Stringhe sql, fox da eseguire
* --------------------------------------------
_stringsql="SELECT * FROM " + _nomesql + " WHERE 1=0"



* -->> Connessione a Sql server
* -->> se non è presente nel dbf di configurazione,
* -->> lo  richiedo al driver e lo inserisco
* -->> nel dbf di configurazione
* --------------------------------------------
SET MULTILOCKS ON
IF !FILE("STRINGSQL.DBF")
  hd = SQLSTRINGCONNECT("DRIVER=SQL Server")
  cString = SQLGETPROP(hd, 'CONNECTSTRING')
  CREATE TABLE STRINGSQL(ID_DATA C(10),ID_WRK C(100),STRINGA C(200))
  INSERT INTO STRINGSQL (ID_DATA,ID_WRK,STRINGA) VALUES ('SQL',SYS(0),cString)
ELSE
  SELECT ALLTRIM(STRINGA) AS cString FROM STRINGSQL WHERE 'SQL' $ ID_DATA AND SYS(0) $ ID_WRK  AND conndef='S' AND !DELETED() INTO CURSOR _TMP
  IF _TALLY = 0
		  hd = SQLSTRINGCONNECT("DRIVER=SQL Server")
		  cString = SQLGETPROP(hd, 'CONNECTSTRING')
		  INSERT INTO STRINGSQL (ID_DATA,ID_WRK,STRINGA) VALUES ('SQL',SYS(0),cString)
  ELSE
	  hd = SQLSTRINGCONNECT(_TMP.cString)
      IF hd < 0
      	=MESSAGEBOX("Errore connessione SQL",16,"*** ATTENZIONE ***")
		RETURN(.f.)
	  endif
  ENDIF
ENDIF


SELECT 0
* -->> Apro tabella FOX cambiando l'alias
* --------------------------------------------
CREATE CURSOR &_nomecur ( C0 C(10), C1 C(5), C2 C(30), c3 C(50), c4 c(80), c5 c(30) , c6 c(50) ,  c7 c(30),c8 c(30) , c9 c(30),c10 c(30),c11 c(30), c12 c(55), c13 c(50),c14 c(50),c15 c(30))
APPEND FROM GETFILE('xls') XLS
* -->> Creo cursore STP dalla select su SQL
* -->> vuoto
*AGN_TIPOL =C2 AGn_societ=c3 AGN_NOME= LEFT(C4,40) AGN_COGNOME= RIGHT(C4,40)
*AGN_TELEF=C5 AGN_TELEF2=C6 AGN_TELEF3 =C7 AGN_FAX1=C8 AGN_FAX2=C9
*AGN_CELL=C10 AGN_CELLAZ =C11 AGN_INDIR= C12  AGN_EMAIL= C13 AGN_note=C14 AGN_SITO= C15
* --------------------------------------------
_rt=SQLEXEC(HD, _stringsql, _nomesql)
IF _rt < 0
	=MESSAGEBOX("Errore nella creazione del cursore STP",16,"*** ATTENZIONE ***")
	SQLDISCONNECT(HD)
	RETURN 
ENDIF 

* -->> Preparo l'elenco dei nome campi da
* -->> aggiornare e l'abbinamento tra campo
* -->> tabella SQL e cursore STP
* --------------------------------------------

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


SELECT &_nomecur
SET FILTER TO !EMPTY(c4+C5)
GO TOP 
skip
SCAN
	* -->> Setto le proprietà del cursore STP
	* --------------------------------------------
	CURSORSETPROP("Buffering" , 5,_nomesql)
	CURSORSETPROP("UpdateNameList" , UpdateNameList,_nomesql)
	CURSORSETPROP("UpdatableFieldList", UpdatableFieldList, _nomesql)
	CURSORSETPROP("KeyFieldList" , "ID_unique", _nomesql)
	CURSORSETPROP("Tables" , _nomesql, _nomesql)
	CURSORSETPROP("WhereType" , 1, _nomesql)
	CURSORSETPROP("SendUpdates" , .T., _nomesql)


	* -->> Eseguo procedura che lavora sul cursore
	* -->> STP (inserisce, cancella ,modifica, ecc)
	* --------------------------------------------
	*SCATTER MEMVAR memo
	m.AGN_CODSOC = '01' 
	
	m.AGN_UTENTE = ALLTRIM(c1)
	M.AGN_utente ='SER'
	M.AGN_TIPOL =ALLTRIM(C2) 
	M.AGn_societ=ALLTRIM(c3) 
	M.AGN_COGNOME= ALLTRIM(LEFT(C4,40)) 
	M.AGN_NOME= ALLTRIM(RIGHT(C4,40))
	M.AGN_TELEF=ALLTRIM(C5)
	M.AGN_TELEF2=ALLTRIM(C6) 
	M.AGN_TELEF3 =ALLTRIM(C7) 
	M.AGN_FAX1=ALLTRIM(C8) 
	M.AGN_FAX2=ALLTRIM(C9)
	M.AGN_CELL=ALLTRIM(C10) 
	M.AGN_CELLAZ =ALLTRIM(C11) 
	M.AGN_INDIR= ALLTRIM(C12) 
	M.AGN_EMAIL= ALLTRIM(C13) 
	M.AGN_note=ALLTRIM(C14) 
	M.AGN_SITO=ALLTRIM( C15)
	INSERT INTO &_nomesql FROM memvar

	IF !TABLEUPDATE(2, .T., _nomesql)
		MESSAGEBOX(MESSAGE())
		TABLEREVERT(.T.,_nomesql)
		SQLDISCONNECT(HD)
 		RETURN 
	ENDIF

	* -->> Creo cursore STP dalla select su SQL
	* -->> vuoto
	* --------------------------------------------
	SQLEXEC(HD, _stringsql, _nomesql)

	SELECT &_nomecur
	WAIT WINDOW "Record inseriti:"+STR(RECNO()) nowait
endscan


* -->> Chiedo se si vuole visualizzare
* -->> la tabella  SQL
* --------------------------------------------
IF MESSAGEBOX("Desideri visualizzare la tabella SQL ?",292,"*** DOMANDA ***") = 6
  _rt=SQLEXEC(HD, "SELECT * FROM "+_nomesql, _nomesql)
  IF _rt < 0
	=MESSAGEBOX("Errore durante l'istruzione Select",16,"*** ATTENZIONE ***")
	SQLDISCONNECT(HD)
	RETURN 
  ENDIF 

  BROWSE
ENDIF


USE IN &_nomesql

SQLDISCONNECT(HD)


RETURN






