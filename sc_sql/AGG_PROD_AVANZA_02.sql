
/* 
********************************************************************
INSERIMENTO NUOVO CAMPO NOTE IN SEQUENZE PROGRAMMA DI PRODUZIONE
********************************************************************
*/
ALTER TABLE [dbo].[PROD_AVANZA] ADD 
	[SEQ_NOTE] text NULL
go

ALTER TABLE [dbo].[PROD_AVANZA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_AVANZA_SEQ_NOTE] DEFAULT ('') FOR [SEQ_NOTE]
go

UPDATE PROD_AVANZA SET SEQ_NOTE = ''
