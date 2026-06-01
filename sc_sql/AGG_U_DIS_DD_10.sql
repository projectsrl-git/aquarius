/* 
*******************************************************************************************************
INSERIMENTO NUOVO CAMPO IN TABELLA DETTAGLI DI.BA. PER MEMORIZZARE LA CORRISPONDENZA CON IL 
CORRISPETTIVO RECORD  NELL'OGGETTO PRODOTTO_DOTAZIONE__C DI SALESFORCE
*******************************************************************************************************
*/
ALTER TABLE [dbo].[U_DIS_DD] ADD 
	SF_PRODOTTO_DOTAZIONE__C_ID varchar(18) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_DIS_DD_SF_PRODOTTO_DOTAZIONE__C_ID] DEFAULT ('')
go
