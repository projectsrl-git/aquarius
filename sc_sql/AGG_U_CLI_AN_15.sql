/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_LISCLI varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 CLI_PRIVAC varchar(01) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_LISCLI] DEFAULT ('') FOR [CLI_LISCLI],
	CONSTRAINT [DF_U_CLI_AN_CLI_PRIVAC] DEFAULT ('') FOR [CLI_PRIVAC]
go

UPDATE U_CLI_AN SET CLI_LISCLI = ''

UPDATE U_CLI_AN SET CLI_PRIVAC = ''