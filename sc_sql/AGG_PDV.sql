
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_AN] ADD 
	 PDV_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_AN_PDV_PROVIN] DEFAULT ('') FOR [PDV_PROVIN]
go
