/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_CONS] ADD 
	 ORD_SYSFAT varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[BUDGET_CONS] WITH NOCHECK ADD 

	CONSTRAINT [DF_BUDGET_CONS_ORD_SYSFAT] DEFAULT ('') FOR [ORD_SYSFAT]

go

UPDATE BUDGET_CONS SET ORD_SYSFAT = ''
