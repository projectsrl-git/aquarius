
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_NUMIDE varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 MOV_CODBUN varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_ANNO varchar(04) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_NUMIDE] DEFAULT ('') FOR [MOV_NUMIDE],
	CONSTRAINT [DF_U_MAG_MO_MOV_CODBUN] DEFAULT ('') FOR [MOV_CODBUN],
	CONSTRAINT [DF_U_MAG_MO_MOV_ANNO] DEFAULT ('') FOR [MOV_ANNO]
go

UPDATE U_MAG_MO SET MOV_NUMIDE = SPACE(06)
UPDATE U_MAG_MO SET MOV_CODBUN = SPACE(10)
UPDATE U_MAG_MO SET MOV_ANNO = SPACE(04)
