
/*  
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[IMPIANTI_TE] ADD 
	ANNOCOSTRU_B NUMERIC(4,0) NOT NULL CONSTRAINT [DF_IMPIANTI_TE_ANNOCOSTRU_B] DEFAULT (0)
GO

