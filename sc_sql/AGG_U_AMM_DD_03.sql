/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_DD] ADD 
 	 ord_syssim varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_DD_ord_syssim]  DEFAULT ('   ') FOR [ord_syssim]
go

UPDATE U_AMM_DD SET ord_syssim 	= '  '
