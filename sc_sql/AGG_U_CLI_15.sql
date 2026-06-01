/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 	 cli_bae varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_CLI_AN] ALTER COLUMN
	 	 cli_baefor varchar(10) COLLATE Latin1_General_CI_AS NULL
go
