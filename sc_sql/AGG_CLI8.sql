
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
-- INSERISCO IL CAMPO cli_scinco
ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 cli_scinco numeric(7,2) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_cli_scinco] DEFAULT ('0') FOR [cli_scinco]
go

UPDATE U_CLI_AN SET cli_scinco = 0
