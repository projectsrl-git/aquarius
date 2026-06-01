/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_Pa] ADD 
	AZI_MAGNO0 TEXT COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_MAGNO0] DEFAULT ('') FOR [AZI_MAGNO0]

go

UPDATE U_AZI_PA SET AZI_MAGNO0 = ''
