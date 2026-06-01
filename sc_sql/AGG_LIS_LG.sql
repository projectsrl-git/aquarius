/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_LIS_LG] ADD 
	 LIS_FLGTRA [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LIS_LG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LIS_LG_LIS_FLGTRA] DEFAULT (0) FOR [LIS_FLGTRA]
go

UPDATE U_LIS_LG SET LIS_FLGTRA = 1

