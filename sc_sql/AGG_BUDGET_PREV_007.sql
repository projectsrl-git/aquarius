/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_PREV] ADD 
	FLG_TIMESHT BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[BUDGET_PREV] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_PREV_FLG_TIMESHT] DEFAULT (0) FOR [FLG_TIMESHT]
go

UPDATE BUDGET_PREV SET FLG_TIMESHT = 0



