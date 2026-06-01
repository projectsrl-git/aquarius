/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FIN_DD] ADD 
	 	 FIN_STATUS  varchar(20) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FIN_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FIN_DD_FIN_STATUS] DEFAULT ('   ') FOR [FIN_STATUS]
go

UPDATE U_FIN_DD SET FIN_STATUS 	= SPACE(20)
