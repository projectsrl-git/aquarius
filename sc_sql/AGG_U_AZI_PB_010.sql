/*
*/

ALTER TABLE [dbo].[U_AZI_PB] ADD 
	 AZI_TIMEEV [numeric] (4) NULL 

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_TIMEEV ] DEFAULT (0) FOR [AZI_TIMEEV ]
go


UPDATE U_AZI_PB SET AZI_TIMEEV  = 0

