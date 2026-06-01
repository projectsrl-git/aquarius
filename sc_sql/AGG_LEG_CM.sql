
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_LEG_CM] ADD 
	 LEG_SEQUEN [numeric](15,0) NULL
go


-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LEG_CM] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LEG_CM_LEG_SEQUEN] DEFAULT (0) FOR [LEG_SEQUEN]
go
