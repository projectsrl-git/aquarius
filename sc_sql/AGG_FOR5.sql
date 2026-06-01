
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 FOR_CODCHE varchar(01) COLLATE Latin1_General_CI_AS NULL,
	 FOR_CODCIN varchar(02) COLLATE Latin1_General_CI_AS NULL,
	 FOR_CODABI varchar(05) COLLATE Latin1_General_CI_AS NULL,
	 FOR_CODCAB varchar(05) COLLATE Latin1_General_CI_AS NULL,
	 FOR_CDIBAN varchar(27) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_CODCHE] DEFAULT ('') FOR [FOR_CODCHE],
	CONSTRAINT [DF_U_FOR_AN_FOR_CODCIN] DEFAULT ('') FOR [FOR_CODCIN],
	CONSTRAINT [DF_U_FOR_AN_FOR_CODABI] DEFAULT ('') FOR [FOR_CODABI],
	CONSTRAINT [DF_U_FOR_AN_FOR_CODCAB] DEFAULT ('') FOR [FOR_CODCAB],
	CONSTRAINT [DF_U_FOR_AN_FOR_CDIBAN] DEFAULT ('') FOR [FOR_CDIBAN]
go

UPDATE U_FOR_AN SET FOR_CODCHE = SPACE(01)
UPDATE U_FOR_AN SET FOR_CODCIN = SPACE(02)
UPDATE U_FOR_AN SET FOR_CODABI = SPACE(05)
UPDATE U_FOR_AN SET FOR_CODCAB = SPACE(05)
UPDATE U_FOR_AN SET FOR_CDIBAN = SPACE(27)
