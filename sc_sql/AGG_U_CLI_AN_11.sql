/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CLI_AN] ADD 
		 CLI_PERCON1 numeric (10,3) NULL,
		 CLI_PERCON2 numeric (10,3) NULL,
		 CLI_PERCON3 numeric (10,3) NULL,
		 CLI_PERCON4 numeric (10,3) NULL,
		 CLI_PERCON5 numeric (10,3) NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PCK_DD_CLI_PERCON1] DEFAULT ('0')    FOR [CLI_PERCON1],
	CONSTRAINT [DF_U_PCK_DD_CLI_PERCON2] DEFAULT ('0')    FOR [CLI_PERCON2],
	CONSTRAINT [DF_U_PCK_DD_CLI_PERCON3] DEFAULT ('0')    FOR [CLI_PERCON3],
	CONSTRAINT [DF_U_PCK_DD_CLI_PERCON4] DEFAULT ('0')    FOR [CLI_PERCON4],
	CONSTRAINT [DF_U_PCK_DD_CLI_PERCON5] DEFAULT ('0')    FOR [CLI_PERCON5]
go

UPDATE U_CLI_AN SET CLI_PERCON1 	= 0
UPDATE U_CLI_AN SET CLI_PERCON2 	= 0
UPDATE U_CLI_AN SET CLI_PERCON3 	= 0
UPDATE U_CLI_AN SET CLI_PERCON4 	= 0
UPDATE U_CLI_AN SET CLI_PERCON5 	= 0
