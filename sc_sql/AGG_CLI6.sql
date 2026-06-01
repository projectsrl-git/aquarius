
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

-- INSERISCO IL CAMPO CLI_VALIMP
ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_VALIMP numeric(17,3) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_VALIMP] DEFAULT ('0') FOR [CLI_VALIMP]
go
-- INSERISCO IL CAMPO CLI_NUMINSOL PER DETERMINARE IL NUMERO DEGLI INSOLUTI
ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_NUMINSOL varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_NUMINSOL] DEFAULT ('') FOR [CLI_NUMINSOL]
go
-- INSERISCO IL CAMPO CLI_LINGUA 
ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_LINGUA varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_LINGUA] DEFAULT ('') FOR [CLI_LINGUA]
go
-- INSERISCO IL CAMPO CLI_SOTZONA CHE DETERMINA LA SOTTOZONA DI APPARTENENZA DEL CLIENTE

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_SOTZONA varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_SOTZONA] DEFAULT ('') FOR [CLI_SOTZONA]
go
-- INSERISCO IL CAMPO CLI_ABI2 CHE DETERMINA L'ABI DELLA SECONDA BANCA DI APPOGGIO

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_ABI2 varchar(4) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_ABI2] DEFAULT ('') FOR [CLI_ABI2]
go
-- INSERISCO IL CAMPO CLI_CAB2 CHE DETERMINA IL CAB DELLA SECONDA BANCA DI APPOGGIO

ALTER TABLE [dbo].[U_CLI_AN] ADD 
	 CLI_CAB2 varchar(5) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[U_CLI_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CLI_AN_CLI_CAB2] DEFAULT ('') FOR [CLI_CAB2]
go