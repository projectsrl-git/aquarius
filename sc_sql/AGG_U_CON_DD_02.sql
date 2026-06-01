/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CON_DD] ADD 
	 	 CON_STATUS  varchar(20) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CON_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_DD_CON_STATUS] DEFAULT ('   ') FOR [CON_STATUS]
go

UPDATE U_CON_DD SET CON_STATUS 	= SPACE(20)
