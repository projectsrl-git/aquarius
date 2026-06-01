
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_TR] ADD 
	 CON_MEGTRA [numeric](18, 0) NULL,
	 CON_MEGRIC [numeric](18, 0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_TR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_TR_CON_MEGTRA] DEFAULT (0) FOR [CON_MEGTRA],
	CONSTRAINT [DF_U_CON_TR_CON_MEGRIC] DEFAULT (0) FOR [CON_MEGRIC]
go
