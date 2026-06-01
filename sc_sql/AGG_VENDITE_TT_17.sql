
/*  
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[VENDITE_TT] ADD 
	ORD_NOTE_INTERNE [text]  COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_VENDITE_TT_ORD_NOTE_INTERNE] DEFAULT ('')
GO

