
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRO_MY] ADD 
	 MIC_LMAXFO [numeric](6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRO_MY] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRO_MY_MIC_LMAXFO] DEFAULT (0) FOR [MIC_LMAXFO]
go

UPDATE U_PRO_MY SET MIC_LMAXFO = 5000