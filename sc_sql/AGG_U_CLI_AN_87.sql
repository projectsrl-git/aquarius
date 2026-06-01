/*    
**************************************************************************************************
INSERIMENTO CAMPO 'Nome report personalizzato in etichette nobilita' IN TABELLA ANAGRAFICA CLIENTI
**************************************************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_ETINOB varchar(30) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_ETINOB] DEFAULT ('') FOR [CLI_ETINOB]
go

UPDATE U_CLI_AN SET CLI_ETINOB = ''
