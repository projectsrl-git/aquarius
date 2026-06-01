
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[NOTE_COM] ADD 
	[nos_ordinif] [bit] NULL,
	[noa_ordinif] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[NOTE_COM] WITH NOCHECK ADD 
	CONSTRAINT [DF_NOTE_COM_nos_ordinif] DEFAULT (0) FOR [nos_ordinif],
	CONSTRAINT [DF_NOTE_COM_noa_ordinif] DEFAULT (0) FOR [noa_ordinif]
go

UPDATE NOTE_COM SET nos_ordinif = 0
UPDATE NOTE_COM SET noa_ordinif = 0