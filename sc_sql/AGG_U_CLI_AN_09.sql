/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_CDMAGD varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 CLI_DSMAGD varchar(30) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_CDMAGD] DEFAULT ('') FOR [CLI_CDMAGD],
	CONSTRAINT [DF_U_CLI_AN_CLI_DSMAGD] DEFAULT ('') FOR [CLI_DSMAGD]
go

UPDATE U_CLI_AN SET CLI_CDMAGD = SPACE(06)
UPDATE U_CLI_AN SET CLI_DSMAGD = SPACE(30)
