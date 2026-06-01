
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_GG] ADD 
	 MAG_NUMIDE varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 MAG_CODBUN varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MAG_ANNO varchar(04) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_NUMIDE] DEFAULT ('') FOR [MAG_NUMIDE],
	CONSTRAINT [DF_U_MAG_GG_MAG_CODBUN] DEFAULT ('') FOR [MAG_CODBUN],
	CONSTRAINT [DF_U_MAG_GG_MAG_ANNO] DEFAULT ('') FOR [MAG_ANNO]
go

UPDATE U_MAG_GG SET MAG_NUMIDE = SPACE(06)
UPDATE U_MAG_GG SET MAG_CODBUN = SPACE(10)
UPDATE U_MAG_GG SET MAG_ANNO = SPACE(04)
