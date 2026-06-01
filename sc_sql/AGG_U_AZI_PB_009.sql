/*
*/

ALTER TABLE [dbo].[U_AZI_PB] ADD 
	 AZI_PLAFACQ  bit NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PB] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AZI_PB_AZI_PLAFACQ ] DEFAULT (0) FOR [AZI_PLAFACQ ]
go


UPDATE U_AZI_PB SET AZI_PLAFACQ  = 0