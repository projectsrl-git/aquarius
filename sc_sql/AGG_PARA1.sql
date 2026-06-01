
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PARA] ADD 
	 PAR_TRASME varchar(2) COLLATE Latin1_General_CI_AS NULL,
	 PAR_DATINS varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_PAR_TRASME] DEFAULT ('') FOR [PAR_TRASME],
	CONSTRAINT [DF_PARA_PAR_DATINS] DEFAULT ('') FOR [PAR_DATINS]
go
