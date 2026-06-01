/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[MOV_CONT] ADD 
	 	 MOV_UNITA_SUPPL_INTRA numeric (10,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
    CONSTRAINT [DF_MOV_CONT_MOV_UNITA_SUPPL_INTRA] DEFAULT ('0')   FOR [MOV_UNITA_SUPPL_INTRA]
go

UPDATE MOV_CONT SET MOV_UNITA_SUPPL_INTRA 	= 0

