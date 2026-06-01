/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CONTI] ADD 
	CON_CODAMM varchar(10) COLLATE Latin1_General_CI_AS NULL,
	CON_CODCES varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[CONTI] WITH NOCHECK ADD 
	CONSTRAINT [DF_CONTI_CON_CODAMM] DEFAULT ('') FOR [CON_CODAMM],
	CONSTRAINT [DF_CONTI_CON_CODCES] DEFAULT ('') FOR [CON_CODCES]
go

UPDATE CONTI SET CON_CODAMM = ''
UPDATE CONTI SET CON_CODCES = ''

