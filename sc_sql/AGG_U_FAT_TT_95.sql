/* 
*****************************************************************************
AGGIORNAMENTO DIMENSIONE CAMPO "Numero ordine cliente" in testata FATTURE
*****************************************************************************
*/

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN 
	 ORD_NUMORC varchar(20) COLLATE Latin1_General_CI_AS NULL
go
