  
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BAN_AN] ADD 
	 SELEZIONE varchar(10) COLLATE Latin1_General_CI_AS NULL
	 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BAN_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BAN_AN_SELEZIONE] DEFAULT ('') FOR [SELEZIONE]
	go

UPDATE U_BAN_AN SET SELEZIONE=''