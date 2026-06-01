/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_RIC_DD] ADD 
	 	 RIC_BAPRES varchar(5) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_RIC_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_RIC_DD_RIC_BAPRES] DEFAULT  ('') FOR [RIC_BAPRES]

go

UPDATE U_RIC_DD SET RIC_BAPRES		= ''
