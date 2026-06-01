
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[INDICE] ADD 
	 	 MOV_DATSCAD varchar(10) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_CONT] DEFAULT ('0') FOR [MOV_DATSCAD]
go

UPDATE INDICE SET MOV_DATSCAD = '          '