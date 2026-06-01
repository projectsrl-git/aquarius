
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_SINT_DD] ADD 
	NOTE TEXT COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[BUDGET_SINT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_SINT_DD_NOTE] DEFAULT ('') FOR [NOTE]
go

UPDATE BUDGET_SINT_DD SET NOTE=''
