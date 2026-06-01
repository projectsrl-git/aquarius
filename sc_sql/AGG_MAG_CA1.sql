
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_CA] ADD 
	 MOV_NUMIDE varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 MOV_CODBUN varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 MOV_ANNO varchar(04) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_CA_MOV_NUMIDE] DEFAULT ('') FOR [MOV_NUMIDE],
	CONSTRAINT [DF_U_MAG_CA_MOV_CODBUN] DEFAULT ('') FOR [MOV_CODBUN],
	CONSTRAINT [DF_U_MAG_CA_MOV_ANNO] DEFAULT ('') FOR [MOV_ANNO]
go

UPDATE U_MAG_CA SET MOV_NUMIDE = SPACE(06)
UPDATE U_MAG_CA SET MOV_CODBUN = SPACE(10)
UPDATE U_MAG_CA SET MOV_ANNO = SPACE(04)
