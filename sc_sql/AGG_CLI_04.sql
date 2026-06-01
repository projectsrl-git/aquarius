/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CLI_AN] ADD 
	CLI_OBSOL VARCHAR(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_OBSOL] DEFAULT ('') FOR [CLI_OBSOL]
go

UPDATE U_CLI_AN SET CLI_OBSOL = ''

