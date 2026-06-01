/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/

ALTER TABLE [dbo].[U_ALT_DA] ADD 
	 ALT_TIPART varchar(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ALT_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ALT_DA_ALT_TIPART] DEFAULT ('') FOR [ALT_TIPART]
go

UPDATE U_ALT_DA SET ALT_TIPART = ' '

