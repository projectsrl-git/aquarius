
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_SINT_DD] ADD 
	 FLG_TIMESHT [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[BUDGET_SINT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_SINT_DD_FLG_TIMESHT] DEFAULT (0) FOR [FLG_TIMESHT]
go

UPDATE BUDGET_SINT_DD SET FLG_TIMESHT = 0

