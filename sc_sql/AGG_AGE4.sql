
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AGE_AN] ADD 
	[AGE_NOTRASP] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AGE_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AGE_AN_AGE_NOTRASP] DEFAULT (0) FOR [AGE_NOTRASP]
go

UPDATE U_AGE_AN SET AGE_NOTRASP = 0
