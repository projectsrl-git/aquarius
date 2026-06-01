/* 
*****************************************************************************
INSERIMENTO CAMPO "Nr. Pallets" in testata DDT
*****************************************************************************
*/
ALTER TABLE [dbo].[U_BOL_TT] ADD 
	 ORD_PEDANE numeric (8,0)
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_TT_ORD_PEDANE] DEFAULT (0) FOR [ORD_PEDANE]
go

UPDATE U_BOL_TT SET ORD_PEDANE = 0

