/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_PREV] ADD 
	VALNETGG numeric(17,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[BUDGET_PREV] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_PREV_VALNETGG] DEFAULT (0) FOR [VALNETGG]
go

UPDATE BUDGET_PREV SET VALNETGG = 0



