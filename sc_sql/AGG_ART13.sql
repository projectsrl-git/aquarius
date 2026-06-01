/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ART_PR] ADD 
	 ART_CODPOL varchar(02) COLLATE Latin1_General_CI_AS NULL,
	 ART_DESPOL varchar(30) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_PR_ART_CODPOL] DEFAULT ('') FOR [ART_CODPOL],
	CONSTRAINT [DF_U_ART_PR_ART_DESPOL] DEFAULT ('') FOR [ART_DESPOL]
go

UPDATE U_ART_PR SET ART_CODPOL = SPACE(02)
UPDATE U_ART_PR SET ART_DESPOL = SPACE(30)
