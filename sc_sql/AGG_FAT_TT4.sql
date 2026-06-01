
ALTER TABLE [dbo].[U_FAT_TT] ADD 
	 ORD_FLGABB [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_FLGABB] DEFAULT (0) FOR [ORD_FLGABB]
go
UPDATE U_FAT_TT SET ORD_FLGABB = 0

