
/* 
**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_ART_PR
**************************************************************
*/

ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
	 [ART_QTACON] numeric (13,3) NULL
go
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
 	 [ART_TOTSCA] numeric (13,3) NULL
go
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
 	 [ART_TOTCAR] numeric (13,3) NULL
go
ALTER TABLE [dbo].[U_ART_PR] ALTER COLUMN
 	 [ART_QTASPE] numeric (13,3) NULL
go

**************************************************************
MODIFICA AI CAMPI DELLE TABELLA U_FAT_DD
**************************************************************
*/

ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAORD numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAEV  numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTADEV numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAOLD numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAFAT numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTCONF numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTXCON numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAKG  numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAMQ  numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAML  numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAKG1 numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAMQ1 numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAML1 numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAKGI numeric(13,3) NULL
GO
ALTER TABLE [dbo].[U_FAT_DD] ALTER COLUMN
	 ORD_QTAKGE numeric(13,3) NULL
GO
