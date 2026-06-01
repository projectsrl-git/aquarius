/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_PREV] ADD 
	GFOGLIOPRES BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[BUDGET_PREV] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_PREV_GFOGLIOPRES] DEFAULT (0) FOR [GFOGLIOPRES]
go

UPDATE BUDGET_PREV SET GFOGLIOPRES = 0



