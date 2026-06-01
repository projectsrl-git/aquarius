/* 
*******************************************************************************************************************
AGGIUNTA CAMPO "ORD_NOTET" IN TESTATE FATTURA PER DESCRIZIONE FATTURA CON TESTO LUNGO (ACQUISIZIONE FATTURE DA GIL)
*******************************************************************************************************************
*/

ALTER TABLE [dbo].[U_FAT_TT] ADD 
	ORD_NOTET text COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_FAT_TT_ORD_NOTET] DEFAULT ('')
go
