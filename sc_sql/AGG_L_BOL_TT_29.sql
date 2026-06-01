/* 
**************************************************************************************************************
AGGIUNTA CAMPO "SF_DDT__C_ID" E "SF_LASTMODIFIEDDATE" IN TESTATE DDT PER LEGAME CON SALESFORCE
**************************************************************************************************************
*/

ALTER TABLE [dbo].[L_BOL_TT] ADD 
	SF_DDT__C_ID varchar(18) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_L_BOL_TT_SF_DDT__C_ID] DEFAULT (''),
	SF_LASTMODIFIEDDATE varchar(28) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_L_BOL_TT_SF_LASTMODIFIEDDATE] DEFAULT ('')
go
