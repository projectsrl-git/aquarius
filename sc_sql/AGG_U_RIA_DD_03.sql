/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_RIA_DD] ADD 
		 ORD_CONTRIB numeric(17,3)  NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_RIA_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_RIA_DD_ORD_CONTRIB]  DEFAULT (0) FOR [ORD_CONTRIB]
go

UPDATE U_RIA_DD SET ORD_CONTRIB = 0
