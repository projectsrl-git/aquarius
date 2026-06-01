/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_SINT_DD] ADD 
	[ORETOT]        [numeric] (10,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[BUDGET_SINT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_SINT_DD_ORETOT] DEFAULT (0) FOR [ORETOT]
go
