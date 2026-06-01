
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[NOTE_COM] ADD [nos_ordmag] [bit] not NULL CONSTRAINT [DF_NOTE_COM_nos_ordmag] DEFAULT (0)
