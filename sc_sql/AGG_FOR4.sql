
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_FOR_AN] ADD 
	 FOR_GGFORN [numeric](4, 0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_AN_FOR_GGFORN] DEFAULT (0) FOR [FOR_GGFORN]
go

UPDATE U_FOR_AN SET FOR_GGFORN = 0

