
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_AN] ADD 
	[AZI_FORPRE] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_AN_AZI_FORPRE] DEFAULT (0) FOR [AZI_FORPRE]
go
UPDATE U_AZI_AN SET AZI_FORPRE = 1