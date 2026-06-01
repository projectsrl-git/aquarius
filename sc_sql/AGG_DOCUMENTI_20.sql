/* 
****************************************************************************************
ALLARGAMENTO A 50 CARATTERI CAMPO ORD_NUMTRX NEI DOCUMENTI
****************************************************************************************
*/

ALTER TABLE [dbo].[L_BOL_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[U_BCL_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[U_BFO_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[U_BOF_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[U_MRI_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[U_PCK_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[U_PRB_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[U_PRF_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[VENDITE_TT] ALTER COLUMN ORD_NUMTRX varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go