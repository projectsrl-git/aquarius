/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AVA_SM] ADD 
        ADE_GIAIMP [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AVA_SM] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AVA_SM_ADE_GIAIMP] DEFAULT (0) FOR [ADE_GIAIMP]

go

UPDATE U_AVA_SM SET ADE_GIAIMP = 0
