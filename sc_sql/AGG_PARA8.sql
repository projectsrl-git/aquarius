
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[PARA] ADD 
	 PERIMPO	[numeric] (6,2) NULL 
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PARA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PARA_PERIMPO]	DEFAULT (0)  FOR [PERIMPO]
go

UPDATE PARA SET PERIMPO = 0