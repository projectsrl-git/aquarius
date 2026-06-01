
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[FATTURABILE_MDB] ADD 
	MDB_GIACP1 numeric(19,4) NOT NULL CONSTRAINT [DF_FATTURABILE_MDB_MDB_GIACP1] DEFAULT (0),
	MDB_GIACP2 numeric(19,4) NOT NULL CONSTRAINT [DF_FATTURABILE_MDB_MDB_GIACP2] DEFAULT (0),
	MDB_VALORR numeric(19,4) NOT NULL CONSTRAINT [DF_FATTURABILE_MDB_MDB_VALORR] DEFAULT (0)
go
