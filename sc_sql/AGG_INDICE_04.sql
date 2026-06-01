
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[INDICE] ADD 
	 	 MOV_BOLLATOIVA varchar(1) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_BOLLATOIVA] DEFAULT ('0') FOR [MOV_BOLLATOIVA]
go

UPDATE INDICE SET MOV_BOLLATOIVA = '          '