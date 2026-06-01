
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PART_FOR] ADD 
	[PAR_BLOCCO] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_PAR_BLOCCO] DEFAULT (0) FOR [PAR_BLOCCO]
go

UPDATE PART_FOR SET PAR_BLOCCO = 0