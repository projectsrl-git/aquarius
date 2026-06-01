
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[FATTURABILE_MDB] ADD 
	MDB_GIACTT numeric(19,4) NOT NULL CONSTRAINT [DF_FATTURABILE_MDB_MDB_GIACTT] DEFAULT (0),
	MDB_NRBOES numeric(4,0) NOT NULL CONSTRAINT [DF_FATTURABILE_MDB_MDB_NRBOES] DEFAULT (0)
go
