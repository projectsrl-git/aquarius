/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	[azi_ecoris] [bit] NULl
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_ecoris] DEFAULT (0) FOR [azi_ecoris]
	
go

UPDATE U_AZI_PA SET azi_ecoris  = 0
