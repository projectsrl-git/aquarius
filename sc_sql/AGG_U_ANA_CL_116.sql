/* 
**********************************************************************************************
AGGIUNTA CAMPO "CLI_RACLI4" IN ANAGRAFICA CLIENTI: RITENUTA 4% SU IMPONIBILE
**********************************************************************************************
*/

ALTER TABLE [dbo].[U_ANA_CL] ADD 
	CLI_RACLI4 varchar(05) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ANA_CL_CLI_RACLI4] DEFAULT ('')
go


ALTER TABLE [dbo].[U_ANA_CL] ADD 
	CLI_RA4  NUMERIC(10,2) NOT NULL CONSTRAINT [DF_U_ANA_CL_CLI_RA4] DEFAULT (0)
go
