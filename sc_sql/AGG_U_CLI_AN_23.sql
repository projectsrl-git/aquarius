
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CLI_AN] ADD 
	CLI_MAILTO text COLLATE Latin1_General_CI_AS NULL,
	CLI_MAILCC text COLLATE Latin1_General_CI_AS NULL,
	CLI_MAILCN text COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_MAILTO] DEFAULT ('') FOR [CLI_MAILTO],
	CONSTRAINT [DF_U_CLI_AN_CLI_MAILCC] DEFAULT ('') FOR [CLI_MAILCC],
	CONSTRAINT [DF_U_CLI_AN_CLI_MAILCN] DEFAULT ('') FOR [CLI_MAILCN]
go

UPDATE U_CLI_AN SET CLI_MAILTO = ''
UPDATE U_CLI_AN SET CLI_MAILCC = ''
UPDATE U_CLI_AN SET CLI_MAILCN = ''

