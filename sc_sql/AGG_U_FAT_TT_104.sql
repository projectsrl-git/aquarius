/* 
**************************************************************************************************************
AGGIUNTA CAMPO "SF_FATTURA_TESTATA__C_ID" E "SF_LASTMODIFIEDDATE" IN TESTATE FATTURA PER LEGAME CON SALESFORCE
**************************************************************************************************************
*/

ALTER TABLE [dbo].[U_FAT_TT] ADD 
	SF_FATTURA_TESTATA__C_ID varchar(18) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_FAT_TT_SF_FATTURA_TESTATA__C_ID] DEFAULT (''),
	SF_LASTMODIFIEDDATE varchar(28) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_FAT_TT_SF_LASTMODIFIEDDATE] DEFAULT ('')
go
