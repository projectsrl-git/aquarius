/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 AZI_DESKTOP varchar(200) COLLATE Latin1_General_CI_AS NULL,
 	 AZI_PASS varchar(200) COLLATE Latin1_General_CI_AS NULL,
 	 AZI_PASS_SW varchar(200) COLLATE Latin1_General_CI_AS NULL,
	 AZI_SCRIT_B [bit] NULL,
	 AZI_SCRIT_N [bit] NULL,
	 AZI_SCRIT_R [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_DESKTOP]  DEFAULT ('') FOR [AZI_DESKTOP],
	CONSTRAINT [DF_U_AZI_PA_AZI_PASS]  DEFAULT ('') FOR [AZI_PASS],
	CONSTRAINT [DF_U_AZI_PA_AZI_PASS_SW]  DEFAULT ('') FOR [AZI_PASS_SW],
	CONSTRAINT [DF_U_AZI_PA_AZI_SCRIT_B] DEFAULT (0) FOR [AZI_SCRIT_B],
	CONSTRAINT [DF_U_AZI_PA_AZI_SCRIT_N] DEFAULT (0) FOR [AZI_SCRIT_N],
	CONSTRAINT [DF_U_AZI_PA_AZI_SCRIT_R] DEFAULT (0) FOR [AZI_SCRIT_R]
go



UPDATE U_AZI_PA SET AZI_DESKTOP = ''
UPDATE U_AZI_PA SET AZI_PASS = ''
UPDATE U_AZI_PA SET AZI_PASS_SW = ''
UPDATE U_AZI_PA SET AZI_SCRIT_B = 0
UPDATE U_AZI_PA SET AZI_SCRIT_N = 0
UPDATE U_AZI_PA SET AZI_SCRIT_R = 0