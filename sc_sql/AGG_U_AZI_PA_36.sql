/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 AZI_MPIU varchar(003) COLLATE Latin1_General_CI_AS NULL,
 	 AZI_MMEN varchar(003) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_MPIU]  DEFAULT ('') FOR [AZI_MPIU],
	CONSTRAINT [DF_U_AZI_PA_AZI_MMEN]  DEFAULT ('') FOR [AZI_MMEN]
go



UPDATE U_AZI_PA SET AZI_MPIU = 'M++'
UPDATE U_AZI_PA SET AZI_MMEN = 'M--'
