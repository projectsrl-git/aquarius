
/* 
**************************************************************
ELIMINAZIONE CAMPI SE ESISTENTI DA UNA TABELLA
**************************************************************
*/


if Exists(select * from syscolumns where Name = N'TOTALE' and ID = Object_ID(N'TIMESHT'))
BEGIN
	ALTER TABLE [dbo].[TIMESHT] DROP CONSTRAINT [DF_TIMESHT_TOTALE]
	ALTER TABLE [dbo].[TIMESHT] DROP COLUMN TOTALE
END

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[TIMESHT] ADD 
	TOTALE numeric(10,2) NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[TIMESHT] WITH NOCHECK ADD 
	CONSTRAINT [DF_TIMESHT_TOTALE] DEFAULT (0) FOR [TOTALE]
go

UPDATE TIMESHT SET TOTALE   = 0
