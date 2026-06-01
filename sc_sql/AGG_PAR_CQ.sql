
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PAR_CQ] ADD 
	[PAR_ADDIDA] [numeric](3, 0) NULL ,   	
	[PAR_ADDIAL] [numeric](3, 0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PAR_CQ] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PAR_CQ_PAR_ADDIDA] DEFAULT (0) FOR [PAR_ADDIDA],
	CONSTRAINT [DF_U_PAR_CQ_PAR_ADDIAL] DEFAULT (0) FOR [PAR_ADDIAL]
go

UPDATE U_PAR_CQ SET PAR_ADDIDA = 0
UPDATE U_PAR_CQ SET PAR_ADDIAL = 0