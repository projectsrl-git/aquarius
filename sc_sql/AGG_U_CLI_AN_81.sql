
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CLI_AN] ADD 
	[CLI_PESOORD] [bit] NULL,
	[CLI_PESOBOL] [bit] NULL,
	[CLI_PESOFAT] [bit] NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_PESOORD] DEFAULT (0) FOR [CLI_PESOORD],
	CONSTRAINT [DF_U_CLI_AN_CLI_PESOBOL] DEFAULT (0) FOR [CLI_PESOBOL],
	CONSTRAINT [DF_U_CLI_AN_CLI_PESOFAT] DEFAULT (0) FOR [CLI_PESOFAT]
go

UPDATE U_CLI_AN SET CLI_PESOORD = 0
UPDATE U_CLI_AN SET CLI_PESOBOL = 0
UPDATE U_CLI_AN SET CLI_PESOFAT = 0