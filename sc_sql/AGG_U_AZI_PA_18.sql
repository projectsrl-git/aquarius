/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 	 AZI_ORDINT varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_ORDINT] DEFAULT ('') FOR [AZI_ORDINT]
go



UPDATE U_AZI_PA SET AZI_ORDINT 	= ''



ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 	 AZI_FABBIS varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_FABBIS] DEFAULT ('') FOR [AZI_FABBIS]
go



UPDATE U_AZI_PA SET AZI_FABBIS 	= ''
