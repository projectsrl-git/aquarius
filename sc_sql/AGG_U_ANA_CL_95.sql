/* 
***********************************************************
AGGIUNTA CAMPO "CLIENTE INADEMPIENTE" IN ANAGRAFICA CLIENTI
***********************************************************
*/

ALTER TABLE [dbo].[U_ANA_CL] ADD 
	CLI_INADEM BIT NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_CLI_INADEM] DEFAULT (0)
go
