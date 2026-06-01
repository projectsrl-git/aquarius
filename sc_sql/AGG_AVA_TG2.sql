
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AVA_TG] ADD 
	 AVA_PRGBOB numeric(10) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AVA_TG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AVA_TG_AVA_PRGBOB] DEFAULT (0) FOR [AVA_PRGBOB]
go

UPDATE U_AVA_TG SET AVA_PRGBOB = 0

	