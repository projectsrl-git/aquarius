/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_APPPRO varchar(06) COLLATE Latin1_General_CI_AS NULL,
	 CLI_GGEVAS numeric (3,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_APPPRO] DEFAULT ('') FOR [CLI_APPPRO],
	CONSTRAINT [DF_U_CLI_AN_CLI_GGEVAS] DEFAULT ('0') FOR [CLI_GGEVAS]
go

UPDATE U_CLI_AN SET CLI_APPPRO = ''
UPDATE U_CLI_AN SET CLI_GGEVAS = 0

