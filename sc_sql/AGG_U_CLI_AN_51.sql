/*    
***********************************************************************
INSERIMENTO CAMPO RAGIONE SOCIALE RIDOTTA IN TABELLA ANAGRAFICA CLIENTI
***********************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_HOMPAG varchar(50) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_HOMPAG] DEFAULT ('') FOR [CLI_HOMPAG]
go

UPDATE U_CLI_AN SET CLI_HOMPAG = ''
