/* 
****************************************************************************************************************
AGGIUNTA CAMPO "SF_PREORDINE__C_ID" IN TESTATA ORDINE PER LEGAME CON SALESFORCE
****************************************************************************************************************
*/

ALTER TABLE [dbo].[U_ORD_T2] ADD
	SF_PREORDINE__C_ID varchar(18) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_T2_SF_PREORDINE__C_ID] DEFAULT ('')
go
