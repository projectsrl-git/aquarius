/* 
***************************************************
AGGIUNTA CAMPO "SCONTO CASSA" IN ANAGRAFICA CLIENTI
***************************************************
*/

ALTER TABLE [dbo].[U_ANA_CL] ADD 
	CLI_SCASSA NUMERIC(5,2) NOT NULL CONSTRAINT [DF_U_AZI_PB_AZI_CLI_SCASSA] DEFAULT (0)
go
