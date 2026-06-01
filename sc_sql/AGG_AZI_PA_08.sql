/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 AZI_VERSRA varchar(3) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_VERSRA] DEFAULT ('') FOR [AZI_VERSRA]
go