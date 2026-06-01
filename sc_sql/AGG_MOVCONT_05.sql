/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[MOV_CONT] ADD 
	 	 MOV_BOLLATOIVA varchar(1) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CONT_MOV_BOLLATOIVA] DEFAULT ('0') FOR [MOV_BOLLATOIVA]
go

UPDATE MOV_CONT SET MOV_BOLLATOIVA = ' '