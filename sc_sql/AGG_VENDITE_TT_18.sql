
/*  
**************************************************************
INSERIMENTO CAMPO ARROTONDAMENTO SUBTOTALE
**************************************************************
*/

ALTER TABLE [dbo].[VENDITE_TT] ADD 
	ORD_ARRSUB bit NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_ARRSUB] DEFAULT (0),
	ORD_IMPARR NUMERIC(17,2) NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_IMPARR] DEFAULT (0)
GO

