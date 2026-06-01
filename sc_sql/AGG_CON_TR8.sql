
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_TR] ADD 
	 CON_MOCTRA [numeric](18, 0) NULL,
	 CON_MOCRIC [numeric](18, 0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_TR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_TR_CON_MOCTRA] DEFAULT (0) FOR [CON_MOCTRA],
	CONSTRAINT [DF_U_CON_TR_CON_MOCRIC] DEFAULT (0) FOR [CON_MOCRIC]
go

UPDATE U_CON_TR SET CON_MOCTRA = 0
UPDATE U_CON_TR SET CON_MOCRIC = 0
