
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[NOTE_COM] ADD 
	[NOC_TOTMQ] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[NOTE_COM] WITH NOCHECK ADD 
	CONSTRAINT [DF_NOTE_COM_NOC_TOTMQ] DEFAULT (0) FOR [NOC_TOTMQ]
go

UPDATE NOTE_COM SET NOC_TOTMQ = 0
