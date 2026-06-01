/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[AUTORIZZAZIONI] ADD 
	AUT_CCOSTO TEXT COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[AUTORIZZAZIONI] WITH NOCHECK ADD 
	CONSTRAINT [DF_AUTORIZZAZIONI_AUT_CCOSTO] DEFAULT ('') FOR [AUT_CCOSTO]

go

UPDATE AUTORIZZAZIONI SET AUT_CCOSTO = ''
