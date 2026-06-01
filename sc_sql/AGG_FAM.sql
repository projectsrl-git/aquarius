
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FAM_DD] ADD 
	 ORD_SEQUEN numeric(5,0) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAM_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAM_DD_ORD_SEQUEN] DEFAULT ('0') FOR [ORD_SEQUEN]
go
