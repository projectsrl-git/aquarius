
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_GPE_AN] ADD 
	 GPE_CONTO varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_GPE_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_GPE_AN_GPE_CONTO] DEFAULT ('') FOR [GPE_CONTO]
go

UPDATE U_GPE_AN SET GPE_CONTO = SPACE(0)