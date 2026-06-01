/* 
**********************************************************************************************
AGGIUNTA CAMPO "EC_CUSTOMER_ID" IN ANAGRAFICA CLIENTI: ID CLIENTE CORRISPONDENTE SU E-COMMERCE
**********************************************************************************************
*/

ALTER TABLE [dbo].[U_ANA_CL] ADD 
	EC_CUSTOMER_ID int NOT NULL CONSTRAINT [DF_U_ANA_CL_EC_CUSTOMER_ID] DEFAULT (0),
	EC_CUSTOMER_UPDATED_AT varchar(20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ANA_CL_EC_CUSTOMER_UPDATED_AT] DEFAULT ('')
go
