/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RDA_DD] ADD 
	A_CESPITE bit NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[RDA_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_RDA_DD_A_CESPITE] DEFAULT (0) FOR [A_CESPITE]
go

UPDATE RDA_DD SET A_CESPITE = 0

