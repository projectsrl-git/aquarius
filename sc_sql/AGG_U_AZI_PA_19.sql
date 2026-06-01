/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	[azi_prsstd] [bit] NULL,
	[azi_prdfilm] [bit] NULL,
	[azi_prmmol] [bit] NULL,
	[azi_prttes] [bit] NULl
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_azi_prsstd] DEFAULT (0) FOR [azi_prsstd],
	CONSTRAINT [DF_U_AZI_PA_azi_prdfilm] DEFAULT (0) FOR [azi_prdfilm],
	CONSTRAINT [DF_U_AZI_PA_azi_prmmol] DEFAULT (0) FOR [azi_prmmol],
	CONSTRAINT [DF_U_AZI_PA_azi_prttes] DEFAULT (0) FOR [azi_prttes]
	
go

UPDATE U_AZI_PA SET azi_prsstd  = 0
UPDATE U_AZI_PA SET azi_prdfilm  = 0
UPDATE U_AZI_PA SET azi_prmmol  = 0
UPDATE U_AZI_PA SET azi_prttes  = 0
