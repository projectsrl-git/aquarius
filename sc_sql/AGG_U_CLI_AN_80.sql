/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_TXTORD text COLLATE Latin1_General_CI_AS NULL,	
	 CLI_TXTBOL text COLLATE Latin1_General_CI_AS NULL,	
	 CLI_TXTFAT text COLLATE Latin1_General_CI_AS NULL,	
	 CLI_TXTFAP text COLLATE Latin1_General_CI_AS NULL	

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_TXTORD] DEFAULT ('') FOR [CLI_TXTORD],
	CONSTRAINT [DF_U_CLI_AN_CLI_TXTBOL] DEFAULT ('') FOR [CLI_TXTBOL],
	CONSTRAINT [DF_U_CLI_AN_CLI_TXTFAT] DEFAULT ('') FOR [CLI_TXTFAT],
	CONSTRAINT [DF_U_CLI_AN_CLI_TXTFAP] DEFAULT ('') FOR [CLI_TXTFAP]
go

UPDATE U_CLI_AN SET CLI_TXTORD = ''
UPDATE U_CLI_AN SET CLI_TXTBOL = ''
UPDATE U_CLI_AN SET CLI_TXTFAT = ''
UPDATE U_CLI_AN SET CLI_TXTFAP = ''

