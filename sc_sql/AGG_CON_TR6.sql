
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_TR] ADD 
	 CON_PRBTRA [numeric](18, 0) NULL,
	 CON_PRBRIC [numeric](18, 0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_TR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_TR_CON_PRBTRA] DEFAULT (0) FOR [CON_PRBTRA],
	CONSTRAINT [DF_U_CON_TR_CON_PRBRIC] DEFAULT (0) FOR [CON_PRBRIC]
go
