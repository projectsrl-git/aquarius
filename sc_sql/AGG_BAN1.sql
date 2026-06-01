
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BAN_AN] ADD 
	 BAN_TRASME varchar(2) COLLATE Latin1_General_CI_AS NULL,
	 BAN_DATINS varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BAN_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BAN_AN_BAN_TRASME] DEFAULT ('') FOR [BAN_TRASME],
	CONSTRAINT [DF_U_BAN_AN_BAN_DATINS] DEFAULT ('') FOR [BAN_DATINS]
go
