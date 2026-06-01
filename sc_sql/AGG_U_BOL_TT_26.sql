/* 
*****************************************************************************
INSERIMENTO CAMPO "Costo aziendale trasporto" in testata DDT
*****************************************************************************
*/
ALTER TABLE [dbo].[U_BOL_TT] ADD 
	 ORD_CSTTRA numeric (16,3) NOT NULL DEFAULT (0)
go
