
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_PER_AN] ADD 
	 PER_TIPPER varchar(1) COLLATE Latin1_General_CI_AS NULL

go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PER_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PER_AN_PER_TIPPER] DEFAULT ('') FOR [PER_TIPPER]
go