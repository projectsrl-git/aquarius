/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CLIENTIC] ADD 
	 ClienteXFat BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[CLIENTIC] WITH NOCHECK ADD 
	CONSTRAINT [DF_CLIENTIC_ClienteXFat] DEFAULT (1) FOR [ClienteXFat]
go


UPDATE CLIENTIC SET ClienteXFat = 1