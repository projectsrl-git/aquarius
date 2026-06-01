/* 
***********************************************************
AGGIUNTA CAMPI PER GESTIONE APPROVAZIONE ORDINE DI ACQUISTO
***********************************************************
*/

ALTER TABLE [dbo].[U_ORF_TT] ADD 
	ORD_FLGAPP bit NOT NULL CONSTRAINT [DF_U_ORF_TT_ORD_FLGAPP] DEFAULT (0),
	ORD_DATIAPP varchar(254) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORF_TT_ORD_DATIAPP] DEFAULT ('')
go
