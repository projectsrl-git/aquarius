
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_IVA_CO] ADD 
	 COR_NUMSCO [numeric](10) NULL ,
	 COR_NETIVA [numeric](15, 2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_IVA_CO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_IVA_CO_COR_NUMSCO] DEFAULT (0) FOR [COR_NUMSCO],
	CONSTRAINT [DF_U_IVA_CO_COR_NETIVA] DEFAULT (0) FOR [COR_NETIVA]
go
