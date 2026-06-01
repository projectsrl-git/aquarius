
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PARA] ADD 
	 CHIUFISCAL BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_CHIUFISCAL] DEFAULT (0) FOR [CHIUFISCAL]
go


UPDATE PARA SET CHIUFISCAL = 0

