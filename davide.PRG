SET MULTILOCKS ON
IF !FILE("STRINGSQL.DBF")
  HD      = SQLSTRINGCONNECT("DRIVER=SQL Server")
  cString = SQLGETPROP(HD, 'CONNECTSTRING')
  CREATE TABLE STRINGSQL(ID_DATA C(10),STRINGA C(200))
  INSERT INTO STRINGSQL (ID_DATA,STRINGA) VALUES ('SQL',cString)
ELSE
  SELECT ALLTRIM(STRINGA) AS cString FROM STRINGSQL WHERE 'SQL' $ ID_DATA INTO CURSOR _TMP
  HD      = SQLSTRINGCONNECT(_TMP.cString)
ENDIF



******************************************************
* -->> PROVA FATTA UTILIZZANDO ESEMPIO (2 TABELLA)
******************************************************
* Seleziono dati da CLIENTE e BANCA dove l'Id_Banca = 4
TEXT TO cSql NOSHOW
	SELECT 
	C.Id_CLIENTE,
	C.Nome,
	C.ID_BANCA AS CLI_BANCA,
	B.Id_Banca,
	B.Nome AS Banca_Nome
	FROM CLIENTE C
	LEFT OUTER JOIN BANCA B ON C.Id_Banca = B.Id_Banca
	WHERE B.id_Banca = 4
	AND C.ID_CLIENTE > 5500
ENDTEXT


SQLEXEC(HD, cSql, "CLIENTE_BANCA")

BROWSE


CURSORSETPROP("Buffering" , 5,"CLIENTE_BANCA")

CURSORSETPROP("UpdateNameList" , "ID_CLIENTE CLIENTE.ID_CLIENTE,;
								  NOME CLIENTE.NOME,;
								  CLI_BANCA CLIENTE.ID_BANCA,;
								  ID_BANCA BANCA.ID_BANCA,;
								  BANCA_NOME BANCA.NOME","CLIENTE_BANCA")

* In UPDATABLEFIELDLIST Indico a VFP che il campo BANCA_NOME è un campo
* che esiste solo nel cursore locale, e che deve essere comunque aggiornabile, 
* ciò è possibile grazie all'associazione fatta nella property UPDATENAMELIST
* (vedi parte sottolineata) dove si indica il corrispondente nome remoto

CURSORSETPROP("UpdatableFieldList" , "ID_CLIENTE, ID_BANCA, NOME, BANCA_NOME, CLI_BANCA","CLIENTE_BANCA")


CURSORSETPROP("KeyFieldList" , "ID_BANCA, ID_CLIENTE", "CLIENTE_BANCA")

CURSORSETPROP("Tables" , "CLIENTE, BANCA", "CLIENTE_BANCA")
CURSORSETPROP("WhereType" , 1, "CLIENTE_BANCA")
CURSORSETPROP("SendUpdates" , .T., "CLIENTE_BANCA")

FOR h=6000 TO 6100
	WAIT WINDOW "Record inseriti"+STR(h) nowait
	_codcli=h
	_descli="Cliente con codice: "+PADL(ALLTRIM(STR(h)),9,'0')
	INSERT INTO CLIENTE_BANCA (ID_CLIENTE,NOME,CLI_BANCA,ID_BANCA,BANCA_NOME) VALUES (_CODCLI,_DESCLI,6,6,'BANCA NUMERO 6') 
NEXT

FOR h=7000 TO 7100
	WAIT WINDOW "Record inseriti"+STR(h) nowait
	_codcli=h
	_descli="Cliente con codice: "+PADL(ALLTRIM(STR(h)),9,'0')
	INSERT INTO CLIENTE_BANCA (ID_CLIENTE,NOME,CLI_BANCA,ID_BANCA,BANCA_NOME) VALUES (_CODCLI,_DESCLI,7,7,'BANCA NUMERO 7') 
NEXT




IF !TABLEUPDATE(2, .T., 'CLIENTE_BANCA')
  MESSAGEBOX(MESSAGE())
  TABLEREVERT(.T.,'CLIENTE_BANCA')
ELSE
  SQLEXEC(HD, "SELECT * FROM CLIENTE", "CLIENTE")
  BROWSE
ENDIF

USE IN CLIENTE_BANCA
SQLDISCONNECT(HD)






RETURN




******************************************************
* -->> PROVA FATTA UTILIZZANDO ESEMPIO (1 TABELLA)
******************************************************
* Seleziono tutti i clienti il cui nome inizia per ....
SQLEXEC(HD, "SELECT * FROM CLIENTE WHERE ID_CLIENTE=1717", "CLIENTE")
BROWSE

* Impongo il Buffer a 5 per il cursore CLIENTE
CURSORSETPROP("Buffering" , 5,"CLIENTE")

CURSORSETPROP("UpdateNameList" , " ID_CLIENTE CLIENTE.ID_CLIENTE, NOME CLIENTE.NOME, ID_BANCA CLIENTE.ID_BANCA","CLIENTE")
CURSORSETPROP("UpdatableFieldList", "ID_CLIENTE, NOME, ID_BANCA", "CLIENTE")
CURSORSETPROP("KeyFieldList" , "ID_CLIENTE", "CLIENTE")
CURSORSETPROP("Tables" , "CLIENTE", "CLIENTE")
CURSORSETPROP("WhereType" , 1, "CLIENTE")
CURSORSETPROP("SendUpdates" , .T., "CLIENTE")

UPDATE CLIENTE SET NOME=STRTRAN(NOME,"Mario","FILIPPO")


IF !TABLEUPDATE(2, .T., 'CLIENTE')
  MESSAGEBOX(MESSAGE())
  TABLEREVERT(.T.,'CLIENTE')
ELSE
  SQLEXEC(HD, "SELECT * FROM CLIENTE", "CLIENTE")
  BROWSE
ENDIF

USE IN CLIENTE
SQLDISCONNECT(HD)






RETURN


***********************************
* -->> PROVA FATTA DA DAVIDE 
***********************************
SET DELETED ON
SET MULTILOCKS ON

*SET STEP ON 
*HD = SQLSTRINGCONNECT("DRIVER=SQL Server")

=SQLEXEC(HD,"SELECT * FROM U_CLI_AN WHERE CLI_CODCLI >= '000000001' AND CLI_CODCLI <= '000000100'","CU_CLIENTI")
SELECT CU_CLIENTI
INDEX ON CLI_CODSOC+CLI_CODCLI TAG U_CLI_AN CANDIDATE

*SET STEP ON 
=CURSORSETPROP("Buffering" , 5,"CU_CLIENTI")
=CURSORSETPROP("Tables" , "U_CLI_AN","CU_CLIENTI")
=CURSORSETPROP("UpdateNameList" , "cli_codsoc CU_CLIENTI.cli_codsoc,;
								  cli_codcli CU_CLIENTI.cli_codcli,;
								  cli_flag CU_CLIENTI.cli_flag,;
								  cli_data CU_CLIENTI.cli_data,;
								  cli_prezzo CU_CLIENTI.cli_prezzo,;
								  cli_valore CU_CLIENTI.","CU_CLIENTI")
								  
=CURSORSETPROP("UpdatableFieldList", "cli_codsoc,cli_codcli,cli_flag,cli_data,cli_prezzo,cli_valore", "CU_CLIENTI")
=CURSORSETPROP("KeyFieldList" , "cli_codsoc", "CU_CLIENTI")
=CURSORSETPROP("WhereType" , 1, "CU_CLIENTI")
=CURSORSETPROP("SendUpdates" , .T., "CU_CLIENTI")


DELETE FROM CU_CLIENTI WHERE BETWEEN(cli_codcli,"000000001","000000005")


IF !TABLEUPDATE(2, .T., 'CU_CLIENTI')
   =MESSAGEBOX(MESSAGE())
ENDIF


**=SQLEXEC(HD,"SELECT * FROM U_CLI_AN","CU_CLIENTI")
**BROWSE
**HD = SQLdisCONNECT(hd)
CLOSE DATABASES ALL
