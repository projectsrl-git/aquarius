
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_AN] ADD 
	 AZI_TIPCAS varchar(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_AN_AZI_TIPCAS] DEFAULT ('') FOR [AZI_TIPCAS]
go
