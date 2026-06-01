/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BOL_DD] ADD 
	ORD_PRZOLD NUMERIC(18,6) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_ORD_PRZOLD] DEFAULT (0) FOR [ORD_PRZOLD]	

go

UPDATE U_BOL_DD SET ORD_PRZOLD = 0
