
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 FOR_TRASME varchar(2) COLLATE Latin1_General_CI_AS NULL,
	 FOR_DATINS varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_TRASME] DEFAULT ('') FOR [FOR_TRASME],
	CONSTRAINT [DF_U_FOR_AN_FOR_DATINS] DEFAULT ('') FOR [FOR_DATINS]
go
