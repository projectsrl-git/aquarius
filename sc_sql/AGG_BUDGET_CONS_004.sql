/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_CONS] ADD 
	VALNETGG numeric(17,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[BUDGET_CONS] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_CONS_VALNETGG] DEFAULT (0) FOR [VALNETGG]
go

UPDATE BUDGET_CONS SET VALNETGG = 0



