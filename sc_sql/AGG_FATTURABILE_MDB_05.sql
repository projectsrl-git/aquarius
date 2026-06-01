
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[FATTURABILE_MDB] ADD 
	MDB_IMPRIRE numeric(17,2) NOT NULL CONSTRAINT [DF_FATTURABILE_MDB_MDB_IMPRIRE] DEFAULT (0)
go
