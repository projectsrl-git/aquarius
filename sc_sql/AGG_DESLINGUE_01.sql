/* 
**************************************************************
INSERIMENTO CAMPO NOTE IN TABELLA DESCRIZIONI IN LINGUA
**************************************************************
*/
ALTER TABLE [dbo].[DESLINGUE] ADD 
		NOTE text COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_DESLINGUE_NOTE] DEFAULT ('')
go
