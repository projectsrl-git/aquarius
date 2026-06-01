/* 
*************************************************************************************************************************
AGGIUNTA CAMPO "CLI_IDNSO" IN ANAGRAFICA CLIENTI: ENDPOINT CLIENTE LEGAME FATTURA ELETTRONICA CON NODO SMISTAMENTO ORDINI
*************************************************************************************************************************
*/

ALTER TABLE [dbo].[U_ANA_CL] ADD 
	CLI_IDNSO varchar(6) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ANA_CL_CLI_IDNSO] DEFAULT ('')
go
