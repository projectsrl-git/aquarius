/*    
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_INCASS varchar(13) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_INCASS] DEFAULT ('') FOR [CLI_INCASS]
go

UPDATE U_CLI_AN SET CLI_INCASS = ''

