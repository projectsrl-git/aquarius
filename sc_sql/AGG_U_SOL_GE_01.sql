
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_SOL_GE] ADD 
	SOL_EMAIL text COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_SOL_GE] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_SOL_GE_SOL_EMAIL] DEFAULT ('') FOR [SOL_EMAIL]
go

UPDATE U_SOL_GE SET SOL_EMAIL= ''

