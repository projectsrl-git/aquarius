/* 
**************************************************************
COME ALLARGARE UN CAMPO ESISTENTE
**************************************************************
*/
ALTER TABLE [dbo].[U_OFF_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_ORD_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_BOL_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_SPE_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go
ALTER TABLE [dbo].[U_ORF_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAT_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_FAP_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_PRB_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_BFO_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_RIA_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_RAA_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[U_PCK_TT] ALTER COLUMN
	 	 ORD_BANCA varchar(10) COLLATE Latin1_General_CI_AS NULL
go