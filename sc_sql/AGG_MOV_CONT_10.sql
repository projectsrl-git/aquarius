/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[MOV_CONT] ADD 
	 MOV_INTRA_ok_ko BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CONT_MOV_INTRA_ok_ko] DEFAULT (0) FOR [MOV_INTRA_ok_ko]
go

UPDATE MOV_CONT SET MOV_INTRA_ok_ko = 0
