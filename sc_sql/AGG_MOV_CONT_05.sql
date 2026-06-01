
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[MOV_CONT] ADD 
	 	 MOV_NOIVA varchar(1) COLLATE Latin1_General_CI_AS NULL
 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CONT_MOV_NOIVA] DEFAULT (' ') FOR [MOV_NOIVA]
go

UPDATE MOV_CONT SET MOV_NOIVA = ' '
