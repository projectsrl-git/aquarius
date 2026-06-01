
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
-- INSERISCO IL CAMPO CLI_ENPACL
ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_ENPACL numeric(9,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_ENPACL] DEFAULT ('0') FOR [CLI_ENPACL]
go

UPDATE U_CLI_AN SET CLI_ENPACL = 0

