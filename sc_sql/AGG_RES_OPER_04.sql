/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RES_OPER] ADD 
        NO_COSTI [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RES_OPER] WITH NOCHECK ADD 
	CONSTRAINT [DF_RES_OPER_NO_COSTI] DEFAULT (0) FOR [NO_COSTI]

go

UPDATE RES_OPER SET NO_COSTI = 0

