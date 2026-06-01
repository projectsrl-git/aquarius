/*
*** Variabile per il flag "Disattivato (non selezionabile in help di ricerca)" delle tabelle parametriche
*/

ALTER TABLE [dbo].[PARA] ADD 
	DISATTIVO bit NOT NULL DEFAULT (0)
go
