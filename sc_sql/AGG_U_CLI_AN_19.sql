/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_NOTSPA text COLLATE Latin1_General_CI_AS NULL,
	 CLI_NOTTAG text COLLATE Latin1_General_CI_AS NULL,
	 CLI_NOTSPE text COLLATE Latin1_General_CI_AS NULL	
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_NOTSPA] DEFAULT ('') FOR [CLI_NOTSPA],
	CONSTRAINT [DF_U_CLI_AN_CLI_NOTTAG] DEFAULT ('') FOR [CLI_NOTTAG],
	CONSTRAINT [DF_U_CLI_AN_CLI_NOTSPE] DEFAULT ('') FOR [CLI_NOTSPE]
go

UPDATE U_CLI_AN SET CLI_NOTSPA = ''
UPDATE U_CLI_AN SET CLI_NOTTAG = ''
UPDATE U_CLI_AN SET CLI_NOTSPE = ''


