/* 
****************************************************************************************************************
AGGIUNTA CAMPO "ORD_IDSDI" PER FATTURAZIONE ELETTRONICA
****************************************************************************************************************
*/

ALTER TABLE [dbo].[U_ORD_T2] ADD 
	ORD_IDSDI varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_T2_ORD_IDSDI] DEFAULT ('')
go
