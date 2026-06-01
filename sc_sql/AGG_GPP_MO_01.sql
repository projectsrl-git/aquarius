/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_GPP_MO] ADD 
	SELEZIONE VARCHAR(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_GPP_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_GPP_MO_SELEZIONE] DEFAULT ('') FOR [SELEZIONE]
go

UPDATE U_GPP_MO SET SELEZIONE = SPACE(10)
