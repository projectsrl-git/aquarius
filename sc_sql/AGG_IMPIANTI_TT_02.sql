
/*  
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[IMPIANTI_TT] ADD 
	CNOTE_INTERNE [text]  COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_IMPIANTI_TT_CNOTE_INTERNE] DEFAULT ('')
GO

