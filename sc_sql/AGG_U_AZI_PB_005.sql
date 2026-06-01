/*
*/

ALTER TABLE [dbo].[U_AZI_PB] ADD 
	 AZI_NOCAMPIORD bit NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_NOCAMPIORD] DEFAULT (0) FOR [AZI_NOCAMPIORD]
go


UPDATE U_AZI_PB SET AZI_NOCAMPIORD = 0