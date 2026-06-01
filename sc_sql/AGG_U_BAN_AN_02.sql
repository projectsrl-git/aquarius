/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BAN_AN] ADD 
	 	 BAN_PRESE varchar(01) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BAN_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BAN_AN_BAN_PRESE] DEFAULT (' ') FOR [BAN_PRESE]
go

UPDATE U_BAN_AN SET BAN_PRESE 	= SPACE(01)
