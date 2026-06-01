/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_LIS_AL] ADD 
	LIS_LUNGDA NUMERIC (8,0)  NULL,
	LIS_LUNGAL NUMERIC (8,0)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LIS_AL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LIS_AL_LIS_LUNGDA] DEFAULT (0) FOR [LIS_LUNGDA],
	CONSTRAINT [DF_U_LIS_AL_LIS_LUNGAL] DEFAULT (0) FOR [LIS_LUNGAL]
go

UPDATE U_LIS_AL SET LIS_LUNGDA = 0
UPDATE U_LIS_AL SET LIS_LUNGAL = 0
