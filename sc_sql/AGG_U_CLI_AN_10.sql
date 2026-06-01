/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_CCOST1 varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 CLI_CCOST2 varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 CLI_CCOST3 varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 CLI_CCOST4 varchar(13) COLLATE Latin1_General_CI_AS NULL,
	 CLI_CCOST5 varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_CCOST1] DEFAULT ('') FOR [CLI_CCOST1],
	CONSTRAINT [DF_U_CLI_AN_CLI_CCOST2] DEFAULT ('') FOR [CLI_CCOST2],
	CONSTRAINT [DF_U_CLI_AN_CLI_CCOST3] DEFAULT ('') FOR [CLI_CCOST3],
	CONSTRAINT [DF_U_CLI_AN_CLI_CCOST4] DEFAULT ('') FOR [CLI_CCOST4],
	CONSTRAINT [DF_U_CLI_AN_CLI_CCOST5] DEFAULT ('') FOR [CLI_CCOST5]

go

UPDATE U_CLI_AN SET CLI_CCOST1 = ''
UPDATE U_CLI_AN SET CLI_CCOST2 = ''
UPDATE U_CLI_AN SET CLI_CCOST3 = ''
UPDATE U_CLI_AN SET CLI_CCOST4 = ''
UPDATE U_CLI_AN SET CLI_CCOST5 = ''

