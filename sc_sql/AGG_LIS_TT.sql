/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_LIS_TT] ADD 
	 LIS_FLGTRA [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LIS_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LIS_TT_LIS_FLGTRA] DEFAULT (0) FOR [LIS_FLGTRA]
go

UPDATE U_LIS_TT SET LIS_FLGTRA = 1

