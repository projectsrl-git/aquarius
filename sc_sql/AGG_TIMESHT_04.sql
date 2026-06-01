
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[TIMESHT] ADD 
	 FLAGRIMBSPE varchar(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[TIMESHT] WITH NOCHECK ADD 
	CONSTRAINT [DF_TIMESHT_FLAGRIMBSPE] DEFAULT ('') FOR [FLAGRIMBSPE]
go

UPDATE TIMESHT SET FLAGRIMBSPE = '0'

