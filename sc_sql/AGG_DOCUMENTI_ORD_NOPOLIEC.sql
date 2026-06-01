/* 
************************************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER EVITARE GESTIONE POLIECO NEI DOCUMENTI CHE LO PREVEDONO (ORDINI / BOLLE / FATTURE)
************************************************************************************************************************************************
*/

ALTER TABLE [dbo].[U_ORD_TT] ADD 
	ORD_NOPOLIEC BIT NOT NULL CONSTRAINT [DF_U_ORD_TT_ORD_NOPOLIEC] DEFAULT (0)
go

ALTER TABLE [dbo].[U_BOL_TT] ADD 
	ORD_NOPOLIEC BIT NOT NULL CONSTRAINT [DF_U_BOL_TT_ORD_NOPOLIEC] DEFAULT (0)
go

ALTER TABLE [dbo].[L_BOL_TT] ADD 
	ORD_NOPOLIEC BIT NOT NULL CONSTRAINT [DF_L_BOL_TT_ORD_NOPOLIEC] DEFAULT (0)
go

ALTER TABLE [dbo].[U_FAT_TT] ADD 
	ORD_NOPOLIEC BIT NOT NULL CONSTRAINT [DF_U_FAT_TT_ORD_NOPOLIEC] DEFAULT (0)
go
