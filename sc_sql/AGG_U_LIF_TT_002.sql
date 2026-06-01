
/* 
**************************************************************
INSERIMENTO CAMPO "QUANTITA' MINIMA" IN LISTINO FORNITORE
**************************************************************
*/
ALTER TABLE [dbo].[U_LIF_TT] ADD 
	 LIS_QTA numeric(17,4) NOT NULL CONSTRAINT [DF_U_LIF_TT_LIS_QTA] DEFAULT (0)
go

