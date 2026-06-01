/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/  

ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 FOR_CCOST1 varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 FOR_CCOST2 varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 FOR_CCOST3 varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 FOR_CCOST4 varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 FOR_CCOST5 varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_CCOST1] DEFAULT ('') FOR [FOR_CCOST1],
	CONSTRAINT [DF_U_FOR_AN_FOR_CCOST2] DEFAULT ('') FOR [FOR_CCOST2],
	CONSTRAINT [DF_U_FOR_AN_FOR_CCOST3] DEFAULT ('') FOR [FOR_CCOST3],
	CONSTRAINT [DF_U_FOR_AN_FOR_CCOST4] DEFAULT ('') FOR [FOR_CCOST4],
	CONSTRAINT [DF_U_FOR_AN_FOR_CCOST5] DEFAULT ('') FOR [FOR_CCOST5]

go

UPDATE U_FOR_AN SET FOR_CCOST1 = ''
UPDATE U_FOR_AN SET FOR_CCOST2 = ''
UPDATE U_FOR_AN SET FOR_CCOST3 = ''
UPDATE U_FOR_AN SET FOR_CCOST4 = ''
UPDATE U_FOR_AN SET FOR_CCOST5 = ''

