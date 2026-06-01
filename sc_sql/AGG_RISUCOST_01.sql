/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RISUCOST] ADD 
	HRTOGG [numeric] (2,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[RISUCOST] WITH NOCHECK ADD 
	CONSTRAINT [DF_RISUCOST_HRTOGG] DEFAULT (0) FOR [HRTOGG]
go


UPDATE RISUCOST SET HRTOGG = (SELECT COALESCE((select CAST(LIBERA AS NUMERIC) AS PAR_HRTOGG from para where codice = 'H/G01'),8) AS DEF_HRTOGG)
