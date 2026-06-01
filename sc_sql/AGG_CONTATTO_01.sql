
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CONTATTO] ADD 
	 FLAG varchar(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[CONTATTO] WITH NOCHECK ADD 
	CONSTRAINT [DF_CONTATTO_FLAG] DEFAULT ('') FOR [FLAG]
go

UPDATE CONTATTO SET FLAG = ''

