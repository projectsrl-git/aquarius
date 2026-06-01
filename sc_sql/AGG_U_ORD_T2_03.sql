/* 
****************************************************************************************************************
AGGIUNTA CAMPO "SF_ORDINE_DI_VENDITA__C_ID" E "SF_LASTMODIFIEDDATE" IN TESTATE FATTURA PER LEGAME CON SALESFORCE
****************************************************************************************************************
*/

ALTER TABLE [dbo].[U_ORD_T2] ADD 
	SF_ORDINE_DI_VENDITA__C_ID varchar(18) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_T2_SF_ORDINE_DI_VENDITA__C_ID] DEFAULT (''),
	SF_LASTMODIFIEDDATE varchar(28) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_T2_SF_LASTMODIFIEDDATE] DEFAULT ('')
go
