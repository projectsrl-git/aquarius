
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_DD] ADD 
	 ORS_NUMIDE varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 ORS_CODBUN varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 ORS_ANNO varchar(04) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_DD_ORS_NUMIDE] DEFAULT ('') FOR [ORS_NUMIDE],
	CONSTRAINT [DF_U_BFO_DD_ORS_CODBUN] DEFAULT ('') FOR [ORS_CODBUN],
	CONSTRAINT [DF_U_BFO_DD_ORS_ANNO] DEFAULT ('') FOR [ORS_ANNO]
go

UPDATE U_BFO_DD SET ORS_NUMIDE = SPACE(06)
UPDATE U_BFO_DD SET ORS_CODBUN = SPACE(10)
UPDATE U_BFO_DD SET ORS_ANNO = SPACE(04)
