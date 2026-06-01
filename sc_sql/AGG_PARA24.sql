/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PARA] ADD 
	[NOHELP] [bit]  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_NOHELP ] DEFAULT (0) FOR [NOHELP ]
go


-- SE IVA SPLIT PAYMENT IMPOSTA 'S'
UPDATE PARA SET NOHELP = 0
