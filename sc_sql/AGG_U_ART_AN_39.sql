/* 
********************************************************************************************************
AGGIUNTA CAMPO "SF_PRODUCT2_ID" E "SF_LASTMODIFIEDDATE" IN ANAGRAFICA ARTICOLI PER LEGAME CON SALESFORCE
********************************************************************************************************
*/

ALTER TABLE [dbo].[U_ART_AN] ADD 
	SF_PRODUCT2_ID varchar(18) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ART_AN_SF_PRODUCT2_ID] DEFAULT (''),
	SF_LASTMODIFIEDDATE varchar(28) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ART_AN_SF_LASTMODIFIEDDATE] DEFAULT ('')
go
