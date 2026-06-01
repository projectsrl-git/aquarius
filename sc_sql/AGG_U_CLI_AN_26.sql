/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_CLFID2 varchar(1) COLLATE Latin1_General_CI_AS NULL,
	 CLI_IMPFI2 numeric(15,3) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_CLFID2] DEFAULT ('') FOR [CLI_CLFID2],
	CONSTRAINT [DF_U_CLI_AN_CLI_IMPFI2] DEFAULT (0) FOR [CLI_IMPFI2]
go

UPDATE U_CLI_AN SET CLI_CLFID2 = ''
UPDATE U_CLI_AN SET CLI_IMPFI2 = 0

