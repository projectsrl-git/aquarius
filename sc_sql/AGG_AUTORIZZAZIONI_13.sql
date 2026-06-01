/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[AUTORIZZAZIONI] ADD 
	AUT_TIPOLOGIA TEXT COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_AUTORIZZAZIONI_AUT_TIPOLOGIA] DEFAULT ('')
go
