
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[EVENTI] ADD 
	 ORDINE numeric(3,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[EVENTI] WITH NOCHECK ADD 
	CONSTRAINT [DF_EVENTI_ORDINE] DEFAULT (0) FOR [ORDINE]
go

UPDATE EVENTI SET ORDINE = 0