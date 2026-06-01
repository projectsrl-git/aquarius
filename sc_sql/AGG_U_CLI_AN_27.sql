
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CLI_AN] ADD 
	CLI_LEGALE  [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_LEGALE] DEFAULT (0) FOR [CLI_LEGALE]
go

UPDATE U_CLI_AN SET CLI_LEGALE = 0

