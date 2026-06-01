/*            
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_SINT_DD] ADD 
	[CodMansione]        [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
	[DesMansione]        [varchar] (80) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[BUDGET_SINT_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_SINT_DD_CodMansione] DEFAULT ('') FOR [CodMansione],
	CONSTRAINT [DF_BUDGET_SINT_DD_DesMansione] DEFAULT ('') FOR [DesMansione]
go
