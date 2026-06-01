/*    
***********************************************************************
INSERIMENTO CAMPO "CLIENTE FACTOR" IN ANAGRAFICA CLIENTI
***********************************************************************
*/

ALTER TABLE [dbo].[U_ANA_CL] ADD 
	CLI_FACTOR BIT NOT NULL CONSTRAINT [DF_U_ANA_CL_CLI_FACTOR] DEFAULT (0)
go
