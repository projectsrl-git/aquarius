
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	[AZI_PRGPRD] [bit] NULL,
	[AZI_SISCUR] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_PRGPRD] DEFAULT (0) FOR [AZI_PRGPRD],
	CONSTRAINT [DF_U_AZI_PA_AZI_SISCUR] DEFAULT (0) FOR [AZI_SISCUR]
go

UPDATE U_AZI_PA SET AZI_PRGPRD = 0
UPDATE U_AZI_PA SET AZI_SISCUR = 1
