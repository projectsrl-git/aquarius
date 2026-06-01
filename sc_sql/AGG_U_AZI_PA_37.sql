/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AZI_PA] ADD 
 	 AZI_ZTLSHW BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_AZI_PA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PA_AZI_ZTLSHW]  DEFAULT (1) FOR [AZI_ZTLSHW]
go

UPDATE U_AZI_PA SET AZI_ZTLSHW = 1
