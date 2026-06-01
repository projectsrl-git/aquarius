

CLOSE DATA ALL

SET PROCEDURE TO prg\winlib additive


* -->> preparo il nome del file script per creare la tabella
* -->> nel database AQUARIUS di sql 2000 server
* -->> Esempio: c:\aquarius\sc_sql\u_cli_an.sql
* --------------------------------------------------------------------
_FILE='SC_SQL\Aquarius.SQL'

* -->> Cancello eventuale vecchio file
* --------------------------------------------------------------------
ERASE &_FILE


* -->> Creo file con funzione a basso livello aprendo un canale di
* -->> comunicazione (HH)
* --------------------------------------------------------------------
HH=FCREATE(_FILE)

USE TABELLEFOX IN 0 AGAIN

SCAN
	IF "FOXUSER.DBF" $ UPPER(tabella)
	  LOOP
	ENDIF 
	
	_TABELLA_FOX=ALLTRIM(PATH)+ALLTRIM(TABELLA)
	
	DO CREA_SCRIPT_SQL WITH _TABELLA_FOX
	
	_temp=" "
	=FPUTS(HH,_TEMP)
	=FPUTS(HH,_TEMP)
	=FPUTS(HH,_TEMP)
	=FPUTS(HH,_TEMP)
	=FPUTS(HH,_TEMP)
	
	SELECT TABELLEFOX
ENDSCAN

* -->> Chiusura canale comunicazione e file .sql
* --------------------------------------------------------------------
=FCLOSE(HH)

=MESSAGEBOX("Script sql per le tabelle AQUARIUS  terminato",64,"*** INFORMAZIONE ***")







**************************************************************************************************************
PROCEDURE CREA_SCRIPT_SQL
**************************************************************************************************************
PARAMETERS _tabellafox


* -->> Controllo esistenza tabella Fox
* --------------------------------------------------------------------
IF !FILE(_tabellafox+IIF(".DBF" $ UPPER(_tabellafox),"",".dbf"))
	=MESSAGEBOX("La tabella " + _tabellafox + " non esiste",16,"*** INFORMAZIONE ***")
	RETURN 
ENDIF 


**********************************************************************
* -->> Inizio scrittura file .SQL
**********************************************************************

* -->> Se esiste la tabella su SQL la cancello (DROP TABLE)
* --------------------------------------------------------------------
_temp="if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[" + JUSTSTEM(_tabellafox) + "]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)"
=FPUTS(HH,_TEMP)
_temp="drop table [dbo].[" + JUSTSTEM(_tabellafox) + "]"
=FPUTS(HH,_TEMP)
_temp="GO"
=FPUTS(HH,_TEMP)
_temp=" "
=FPUTS(HH,_TEMP)

* -->> Creo la tabella (CREATE TABLE) inserendo come primo campo
* -->> il campo ID_UNIQUE campo univoco gestito in automatico da SQL
* --------------------------------------------------------------------
_temp="CREATE TABLE [dbo].[" + JUSTSTEM(_tabellafox) + "] ("
=FPUTS(HH,_TEMP)
_temp="	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,"
=FPUTS(HH,_TEMP)


* -->> Inserisco i campi della tabella di FOX
* --------------------------------------------------------------------
_campo_memo=.f.

_tabella=JUSTSTEM(_tabellafox)

USE &_tabellafox IN 0 AGAIN

SELECT &_tabella

_TotFields=afields(_NameFields)

for _x=1 to _TotFields
	DO case

		* -->> Se campo carattere
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="C"
			_temp="	[" + _NameFields[_x,1] + "] [varchar] (" + ALLTRIM(STR(_NameFields[_x,3])) + ") COLLATE Latin1_General_CI_AS NULL " + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Se campo numerico
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="N"
			_temp="	[" + _NameFields[_x,1] + "] [numeric] (" + ALLTRIM(STR(_NameFields[_x,3])) + "," + ALLTRIM(STR(_NameFields[_x,4])) + ") NULL " + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Se campo logico
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="L"
			_temp="	[" + _NameFields[_x,1] + "] [bit] NULL " + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Se campo memo
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="M"
			_campo_memo=.t.
			_temp="	[" + _NameFields[_x,1] + "] [text] COLLATE Latin1_General_CI_AS NULL " + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Se campo Data
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="D"
			_temp="	[" + _NameFields[_x,1] + "] [datetime] NULL " + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Se campo DataTime
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="T"
			_temp="	[" + _NameFields[_x,1] + "] [datetime] NULL " + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Tipo campo non gestito (ESCO DALLA PROCEDURA)
		* --------------------------------------------------------------------
		OTHERWISE
			=MESSAGEBOX("Codice campo non gestito <<" + _NameFields[_x,2] + ">> nella tabella <<"+_tabella+">>",16,"*** ATTENZIONE ERRORE ***")
			=FCLOSE(HH)
			return
	endcase
next

* -->> Chiudo creazione tabella
* --------------------------------------------------------------------
IF _campo_memo
	_temp=") ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]"
ELSE
	_temp=") ON [PRIMARY]"
ENDIF
=FPUTS(HH,_TEMP)
_temp="GO"
=FPUTS(HH,_TEMP)
_temp=""
=FPUTS(HH,_TEMP)


* -->> Creo chiave primaria su campo ID_UNIQUE
* --------------------------------------------------------------------
_temp="ALTER TABLE [dbo].[" + JUSTSTEM(_tabellafox) + "] WITH NOCHECK ADD "
=FPUTS(HH,_TEMP)
_temp="	CONSTRAINT [PK_" + JUSTSTEM(_tabellafox) + "] PRIMARY KEY  CLUSTERED "
=FPUTS(HH,_TEMP)
_temp="	("
=FPUTS(HH,_TEMP)
_temp="		[id_unique]"
=FPUTS(HH,_TEMP)
_temp="	)  ON [PRIMARY] "
=FPUTS(HH,_TEMP)
_temp="GO"
=FPUTS(HH,_TEMP)
_temp=""
=FPUTS(HH,_TEMP)


* -->> Aggiungo al campo chiave primaria ID_UNIQUE la gestione di 
* -->> codice univoco (funzione SQL NEWID())
* -->> Valorizzo blank di default i campi memo e carattere e zero
* -->> i campi numerici e logici.
* --------------------------------------------------------------------
_temp="ALTER TABLE [dbo].[" + JUSTSTEM(_tabellafox) + "] WITH NOCHECK ADD "
=FPUTS(HH,_TEMP)
_temp="	CONSTRAINT [DF_" + JUSTSTEM(_tabellafox) + "_id_unique] DEFAULT (newid()) FOR [id_unique]" + IIF(_x=_TotFields,"",",")
=FPUTS(HH,_TEMP)

for _x=1 to _TotFields
	DO case

		* -->> Se campo carattere
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="C"
			_temp="	CONSTRAINT [DF_" + JUSTSTEM(_tabellafox) + "_" + _NameFields[_x,1] + "] DEFAULT ('') FOR [" + _NameFields[_x,1] + "]" + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Se campo numerico
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="N"
			_temp="	CONSTRAINT [DF_" + JUSTSTEM(_tabellafox) + "_" + _NameFields[_x,1] + "] DEFAULT (0) FOR [" + _NameFields[_x,1] + "]" + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Se campo logico
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="L"
			_temp="	CONSTRAINT [DF_" + JUSTSTEM(_tabellafox) + "_" + _NameFields[_x,1] + "] DEFAULT (0) FOR [" + _NameFields[_x,1] + "]" + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Se campo memo
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="M"
			_temp="	CONSTRAINT [DF_" + JUSTSTEM(_tabellafox) + "_" + _NameFields[_x,1] + "] DEFAULT ('') FOR [" + _NameFields[_x,1] + "]" + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Se campo data
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="D"
			_temp="	CONSTRAINT [DF_" + JUSTSTEM(_tabellafox) + "_" + _NameFields[_x,1] + "] DEFAULT ('') FOR [" + _NameFields[_x,1] + "]" + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Se campo datatime
		* --------------------------------------------------------------------
		CASE _NameFields[_x,2]="T"
			_temp="	CONSTRAINT [DF_" + JUSTSTEM(_tabellafox) + "_" + _NameFields[_x,1] + "] DEFAULT ('') FOR [" + _NameFields[_x,1] + "]" + IIF(_x=_TotFields,"",",")
			=FPUTS(HH,_TEMP)

		* -->> Tipo campo non gestito (ESCO DALLA PROCEDURA)
		* --------------------------------------------------------------------
		OTHERWISE
			=MESSAGEBOX("Codice campo non gestito <<" + _NameFields[_x,2] + ">>",16,"*** ATTENZIONE ERRORE ***")
			=FCLOSE(HH)
			return
	endcase
next

_temp="GO"
=FPUTS(HH,_TEMP)
_temp=""
=FPUTS(HH,_TEMP)



************************************************************************************
* -->> esempio di come creare gli indici
************************************************************************************

*!*	* -->> Gestione indici univoci
*!*	* -->> (Controlla e blocca l'iserimento di chiavi doppie
*!*	* --------------------------------------------------------------------
*!*	_temp=" CREATE  UNIQUE  INDEX [nome_indice] ON [dbo].[" + JUSTSTEM(_tabellafox) + "]([campo1], [campo2]) ON [PRIMARY]"
*!*	=FPUTS(HH,_TEMP)
*!*	_temp="GO"
*!*	=FPUTS(HH,_TEMP)
*!*	_temp=""
*!*	=FPUTS(HH,_TEMP)


*!*	* -->> Gestione indici normali
*!*	* --------------------------------------------------------------------
*!*	_temp=" CREATE  INDEX [nome_indice] ON [dbo].[" + JUSTSTEM(_tabellafox) + "]([campo1],[campo2]) ON [PRIMARY]"
*!*	=FPUTS(HH,_TEMP)
*!*	_temp="GO"
*!*	=FPUTS(HH,_TEMP)
*!*	_temp=""
*!*	=FPUTS(HH,_TEMP)


return