/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
        AZI_BENDUR [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_BENDUR] DEFAULT (0) FOR [AZI_BENDUR]

go

UPDATE U_AZI_PA SET AZI_BENDUR = 0
