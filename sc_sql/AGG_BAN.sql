
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BAN_AN] ADD 
	 BAN_PROVIN varchar(2) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BAN_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BAN_AN_BAN_PROVIN] DEFAULT ('') FOR [BAN_PROVIN]
go
