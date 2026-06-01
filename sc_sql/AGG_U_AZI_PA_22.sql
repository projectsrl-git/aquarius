/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_AZI_PA] ADD 
	 	 AZI_LOGBOL bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_LOGBOL] DEFAULT (0) FOR [AZI_LOGBOL]
go



UPDATE U_AZI_PA SET AZI_LOGBOL = 0