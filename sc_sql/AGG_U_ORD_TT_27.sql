
ALTER TABLE [dbo].[U_ORD_TT] ADD 
	 ORD_PESNET numeric (8,0)
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ORD_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_TT_ORD_PESNET] DEFAULT (0) FOR [ORD_PESNET]
go

UPDATE U_ORD_TT SET ORD_PESNET = 0

