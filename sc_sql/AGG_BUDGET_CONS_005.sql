/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_CONS] ADD 
	GFOGLIOPRES BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[BUDGET_CONS] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_CONS_GFOGLIOPRES] DEFAULT (0) FOR [GFOGLIOPRES]
go

UPDATE BUDGET_CONS SET GFOGLIOPRES = 0



