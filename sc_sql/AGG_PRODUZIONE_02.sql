
/* 
********************************************************************
INSERIMENTO NUOVO CAMPO NOTE PROGRAMMA DI PRODUZIONE
********************************************************************
*/
ALTER TABLE [dbo].[PRODUZIONE] ADD 
	[NOTE] text NULL
go

ALTER TABLE [dbo].[PRODUZIONE] WITH NOCHECK ADD 
	CONSTRAINT [DF_PRODUZIONE_NOTE] DEFAULT ('') FOR [NOTE]
go

UPDATE PRODUZIONE SET NOTE = ''
