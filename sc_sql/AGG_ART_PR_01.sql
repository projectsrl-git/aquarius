/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_ART_PR] ADD 
	ART_PEDLAR NUMERIC(7,2) NULL,
	ART_PEDLUN NUMERIC(7,2) NULL,
	ART_PEDALT NUMERIC(7,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_PEDLAR] DEFAULT (0) FOR [ART_PEDLAR],	
	CONSTRAINT [DF_U_ART_PR_ART_PEDLUN] DEFAULT (0) FOR [ART_PEDLUN],	
	CONSTRAINT [DF_U_ART_PR_ART_PEDALT] DEFAULT (0) FOR [ART_PEDALT]	

go

UPDATE U_ART_PR SET ART_PEDLAR = 0
UPDATE U_ART_PR SET ART_PEDLUN = 0
UPDATE U_ART_PR SET ART_PEDALT = 0
