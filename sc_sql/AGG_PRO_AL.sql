/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRO_AL] ADD 
	ALT_PROGRE NUMERIC (3,0)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRO_AL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRO_AL_ALT_PROGRE] DEFAULT (0) FOR [ALT_PROGRE]
go

UPDATE U_PRO_AL SET ALT_PROGRE = 0
