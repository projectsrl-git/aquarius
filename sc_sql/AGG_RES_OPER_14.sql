/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
	OK_LAB_PROCEDURE BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_OK_LAB_PROCEDURE] DEFAULT (0) FOR [OK_LAB_PROCEDURE]
go

UPDATE RES_OPER SET OK_LAB_PROCEDURE	= 0
