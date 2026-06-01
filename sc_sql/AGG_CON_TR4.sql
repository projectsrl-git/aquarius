
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_TR] ADD 
	 CON_DDTTRA [numeric](18, 0) NULL,
	 CON_DDTRIC [numeric](18, 0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_TR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_TR_CON_DDTTRA] DEFAULT (0) FOR [CON_DDTTRA],
	CONSTRAINT [DF_U_CON_TR_CON_DDTRIC] DEFAULT (0) FOR [CON_DDTRIC]
go
