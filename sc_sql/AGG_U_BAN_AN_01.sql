/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BAN_AN] ADD 
	 	 BAN_CONRIC varchar(10) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BAN_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BAN_AN_BAN_CONRIC] DEFAULT ('    ') FOR [BAN_CONRIC]
go

UPDATE U_BAN_AN SET BAN_CONRIC 	= SPACE(10)
