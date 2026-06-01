
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_TR] ADD 
	 CON_RESTRA [numeric](18, 0) NULL,
	 CON_RESRIC [numeric](18, 0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_TR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_TR_CON_RESTRA] DEFAULT (0) FOR [CON_RESTRA],
	CONSTRAINT [DF_U_CON_TR_CON_RESRIC] DEFAULT (0) FOR [CON_RESRIC]
go
