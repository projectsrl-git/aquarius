
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AGE_AN] ADD 
	 AGE_TRASME varchar(2) COLLATE Latin1_General_CI_AS NULL,
	 AGE_DATINS varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AGE_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AGE_AN_AGE_TRASME] DEFAULT ('') FOR [AGE_TRASME],
	CONSTRAINT [DF_U_AGE_AN_AGE_DATINS] DEFAULT ('') FOR [AGE_DATINS]
go
