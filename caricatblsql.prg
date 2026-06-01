
CLOSE DATA ALL

SET EXCLUSIVE OFF

SET PROCEDURE TO prg\winlib additive

USE TABELLEFOX IN 0 AGAIN

SCAN
	_TABELLA_FOX=ALLTRIM(PATH)+ALLTRIM(TABELLA)
	
    IF FILE(_TABELLA_FOX)
    	DO carica_sql WITH _TABELLA_FOX
	ENDIF
	 
	SELECT TABELLEFOX
ENDSCAN


=MESSAGEBOX("Caricamento tabelle AQUARIUS SQL  terminato",64,"*** INFORMAZIONE ***")

return


************************************************************************************
PROCEDURE carica_sql
************************************************************************************
PARAMETERS _tblfox

************************************************************************************
* -->> definizione delle variabili
************************************************************************************

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


* -->> Apro tabella FOX cambiando l'alias
* --------------------------------------------
USE &_tblfox ALIAS &_nomecur IN 0 AGAIN
SELECT &_nomecur
IF RECCOUNT() = 0
	USE IN &_nomecur
	SQLDISCONNECT(HD)
	RETURN 
ENDIF 


* -->> Creo cursore STP dalla select su SQL
* -->> vuoto
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
GO TOP 
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
	SCATTER MEMVAR memo
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
	WAIT WINDOW "Record inseriti in "+_nomesql+":"+STR(RECNO()) nowait
endscan

USE IN &_nomesql

SQLDISCONNECT(HD)


RETURN









