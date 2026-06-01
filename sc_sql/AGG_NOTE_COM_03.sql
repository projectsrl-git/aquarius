
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[NOTE_COM] ADD 
	[NOT_CONVERT] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[NOTE_COM] WITH NOCHECK ADD 
	CONSTRAINT [DF_NOTE_COM_NOT_CONVERT] DEFAULT (0) FOR [NOT_CONVERT]
go

UPDATE NOTE_COM SET NOT_CONVERT = 0
