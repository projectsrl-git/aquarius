/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[AUTORIZZAZIONI] ADD 
	VIS_CCOSTO TEXT COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[AUTORIZZAZIONI] WITH NOCHECK ADD 
	CONSTRAINT [DF_AUTORIZZAZIONI_VIS_CCOSTO] DEFAULT ('') FOR [VIS_CCOSTO]

go

UPDATE AUTORIZZAZIONI SET VIS_CCOSTO = ''
