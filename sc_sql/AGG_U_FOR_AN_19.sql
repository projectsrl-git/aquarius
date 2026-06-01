
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_AN] ADD 
	FOR_MAILTO text COLLATE Latin1_General_CI_AS NULL,
	FOR_MAILCC text COLLATE Latin1_General_CI_AS NULL,
	FOR_MAILCN text COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_MAILTO] DEFAULT ('') FOR [FOR_MAILTO],
	CONSTRAINT [DF_U_FOR_AN_FOR_MAILCC] DEFAULT ('') FOR [FOR_MAILCC],
	CONSTRAINT [DF_U_FOR_AN_FOR_MAILCN] DEFAULT ('') FOR [FOR_MAILCN]
go

UPDATE U_FOR_AN SET FOR_MAILTO = ''
UPDATE U_FOR_AN SET FOR_MAILCC = ''
UPDATE U_FOR_AN SET FOR_MAILCN = ''

