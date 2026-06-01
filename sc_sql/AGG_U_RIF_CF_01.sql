
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_RIF_CF] ADD 
	 RIF_CODFUN varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_RIF_CF] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_RIF_CF_RIF_CODFUN] DEFAULT ('') FOR [RIF_CODFUN]
go

UPDATE U_RIF_CF SET RIF_CODFUN = ''

