/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
		[AZI_FISCALE] [bit] NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_FISCALE] DEFAULT (newid()) FOR [AZI_FISCALE]
go



UPDATE U_AZI_PA SET AZI_FISCALE = 1
