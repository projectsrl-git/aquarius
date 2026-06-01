
/* 
********************************************************************
INSERIMENTO NUOVO CAMPO FLAG DI CHIUSURA PROGRAMMA DI PRODUZIONE
********************************************************************
*/
ALTER TABLE [dbo].[PRODUZIONE] ADD 
	[FLGCLOSED] BIT NULL
go

ALTER TABLE [dbo].[PRODUZIONE] WITH NOCHECK ADD 
	CONSTRAINT [DF_PRODUZIONE_FLGCLOSED] DEFAULT (0) FOR [FLGCLOSED]
go

UPDATE PRODUZIONE SET FLGCLOSED = 0
