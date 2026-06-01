
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[FATTURABILE_MDB] ADD 
	 MDB_SYSRIGA varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[FATTURABILE_MDB] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_MDB_MDB_SYSRIGA] DEFAULT ('') FOR [MDB_SYSRIGA]
go

UPDATE FATTURABILE_MDB SET MDB_SYSRIGA = ''

