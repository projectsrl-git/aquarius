/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_LEA_DD] ADD 
	 	 LEA_STATUS  varchar(20) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LEA_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LEA_DD_LEA_STATUS] DEFAULT ('   ') FOR [LEA_STATUS]
go

UPDATE U_LEA_DD SET LEA_STATUS 	= SPACE(20)
