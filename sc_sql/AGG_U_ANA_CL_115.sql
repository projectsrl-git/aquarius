/* 
**********************************************************************************************
AGGIUNTA CAMPO "EC_CUSTOMER_ID" IN ANAGRAFICA CLIENTI: ID CLIENTE CORRISPONDENTE SU E-COMMERCE
**********************************************************************************************
*/

ALTER TABLE [dbo].[U_ANA_CL] ADD 
	CLI_RACLI varchar(05) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ANA_CL_CLI_RACLI] DEFAULT ('')
go
