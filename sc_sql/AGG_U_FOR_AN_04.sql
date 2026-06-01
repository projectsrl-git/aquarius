/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 	 FOR_BDAL varchar(04) COLLATE Latin1_General_CI_AS NULL,
	 	 FOR_BAL varchar(04) COLLATE Latin1_General_CI_AS NULL,
	 	 FOR_GG1 varchar(04) COLLATE Latin1_General_CI_AS NULL,
	 	 FOR_B2DAL varchar(04) COLLATE Latin1_General_CI_AS NULL,
	 	 FOR_B2AL varchar(04) COLLATE Latin1_General_CI_AS NULL,
	 	 FOR_GG2 varchar(04) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_BDAL] DEFAULT ('    ') FOR [FOR_BDAL],
	CONSTRAINT [DF_U_FOR_AN_FOR_BAL] DEFAULT ('    ') FOR [FOR_BAL],
	CONSTRAINT [DF_U_FOR_AN_FOR_GG1] DEFAULT ('    ') FOR [FOR_GG1],
	CONSTRAINT [DF_U_FOR_AN_FOR_B2DAL] DEFAULT ('    ') FOR [FOR_B2DAL],
	CONSTRAINT [DF_U_FOR_AN_FOR_B2AL] DEFAULT ('    ') FOR [FOR_B2AL],
	CONSTRAINT [DF_U_FOR_AN_FOR_GG2] DEFAULT ('    ') FOR [FOR_GG2]
go

UPDATE U_FOR_AN SET FOR_BDAL 	= '0108'
UPDATE U_FOR_AN SET FOR_BAL 	= '3108'
UPDATE U_FOR_AN SET FOR_GG1 	= '1009'
UPDATE U_FOR_AN SET FOR_B2DAL 	= '2012'
UPDATE U_FOR_AN SET FOR_B2AL 	= '3112'
UPDATE U_FOR_AN SET FOR_GG2 	= '1001'
