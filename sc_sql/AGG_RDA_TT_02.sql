/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RDA_TT] ADD 
	NON_COMPLETA bit NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[RDA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_RDA_TT_NON_COMPLETA] DEFAULT (0) FOR [NON_COMPLETA]
go

UPDATE RDA_TT SET NON_COMPLETA = 0

