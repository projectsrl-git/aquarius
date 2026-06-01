/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_CONS] ADD 
	NOTIMESHT BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[BUDGET_CONS] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_CONS_NOTIMESHT] DEFAULT (0) FOR [NOTIMESHT]
go

UPDATE BUDGET_CONS SET NOTIMESHT = 0



