
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_TR] ADD 
	 CON_RICTRA [numeric](18, 0) NULL,
	 CON_RICRIC [numeric](18, 0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_TR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_TR_CON_RICTRA] DEFAULT (0) FOR [CON_RICTRA],
	CONSTRAINT [DF_U_CON_TR_CON_RICRIC] DEFAULT (0) FOR [CON_RICRIC]
go
