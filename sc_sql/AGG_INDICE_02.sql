
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[INDICE] ADD 
	 MOV_NPARTO numeric(10,0) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_NPARTO] DEFAULT ('0') FOR [MOV_NPARTO]
go

UPDATE INDICE SET MOV_NPARTO = 0