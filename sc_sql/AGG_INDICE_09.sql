
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[INDICE] ADD 
		 MOV_IVAOMA [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_IVAOMA] DEFAULT (0) FOR [MOV_IVAOMA]
go

UPDATE INDICE SET MOV_IVAOMA = 0
