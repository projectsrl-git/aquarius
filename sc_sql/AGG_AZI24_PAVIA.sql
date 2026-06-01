/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_AZI_AN] ADD 
	 AZI_LIS10 [bit] NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_AN_AZI_LIS10] DEFAULT (0) FOR [AZI_LIS10]
go

UPDATE U_AZI_AN SET AZI_LIS10= 0