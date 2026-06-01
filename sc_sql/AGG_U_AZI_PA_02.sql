/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 AZI_AQUAR [bit] NULL,
	 AZI_PASS_B [bit] NULL,
	 AZI_PASS_N [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_AQUAR] DEFAULT (0) FOR [AZI_AQUAR],
	CONSTRAINT [DF_U_AZI_PA_AZI_PASS_B] DEFAULT (0) FOR [AZI_PASS_B],
	CONSTRAINT [DF_U_AZI_PA_AZI_PASS_N] DEFAULT (0) FOR [AZI_PASS_N]
go



UPDATE U_AZI_PA SET AZI_AQUAR = 0
UPDATE U_AZI_PA SET AZI_PASS_B = 0
UPDATE U_AZI_PA SET AZI_PASS_N = 0