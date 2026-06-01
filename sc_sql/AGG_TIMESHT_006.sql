/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[TIMESHT] ADD 
	SPESEGGUNI numeric(17,6) NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[TIMESHT] WITH NOCHECK ADD 
	CONSTRAINT [DF_TIMESHT_SPESEGGUNI] DEFAULT (0) FOR [SPESEGGUNI]
go

UPDATE TIMESHT SET SPESEGGUNI = SPESEGG

