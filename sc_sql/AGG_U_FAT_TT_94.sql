
ALTER TABLE [dbo].[U_FAT_TT] ADD 
	 ORD_PESNET numeric (8,0)
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAT_TT_ORD_PESNET] DEFAULT (0) FOR [ORD_PESNET]
go

UPDATE U_FAT_TT SET ORD_PESNET = 0

