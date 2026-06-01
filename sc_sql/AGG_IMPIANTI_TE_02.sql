
/*  
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[IMPIANTI_TE] ADD 
	POT_NOM_GRUPPO NUMERIC(9,2) NOT NULL CONSTRAINT [DF_IMPIANTI_TE_POT_NOM_GRUPPO] DEFAULT (0)
GO

