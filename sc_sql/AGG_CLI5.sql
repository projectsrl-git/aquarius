
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_CODCHE varchar(01) COLLATE Latin1_General_CI_AS NULL,
	 CLI_CODCIN varchar(02) COLLATE Latin1_General_CI_AS NULL,
	 CLI_CODABI varchar(05) COLLATE Latin1_General_CI_AS NULL,
	 CLI_CODCAB varchar(05) COLLATE Latin1_General_CI_AS NULL,
	 CLI_CDIBAN varchar(27) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_CODCHE] DEFAULT ('') FOR [CLI_CODCHE],
	CONSTRAINT [DF_U_CLI_AN_CLI_CODCIN] DEFAULT ('') FOR [CLI_CODCIN],
	CONSTRAINT [DF_U_CLI_AN_CLI_CODABI] DEFAULT ('') FOR [CLI_CODABI],
	CONSTRAINT [DF_U_CLI_AN_CLI_CODCAB] DEFAULT ('') FOR [CLI_CODCAB],
	CONSTRAINT [DF_U_CLI_AN_CLI_CDIBAN] DEFAULT ('') FOR [CLI_CDIBAN]
go

UPDATE U_CLI_AN SET CLI_CODCHE = SPACE(01)
UPDATE U_CLI_AN SET CLI_CODCIN = SPACE(02)
UPDATE U_CLI_AN SET CLI_CODABI = SPACE(05)
UPDATE U_CLI_AN SET CLI_CODCAB = SPACE(05)
UPDATE U_CLI_AN SET CLI_CDIBAN = SPACE(27)
