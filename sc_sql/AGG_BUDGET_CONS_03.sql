/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_CONS] ADD 
	 ORD_EPEC varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[BUDGET_CONS] WITH NOCHECK ADD 

	CONSTRAINT [DF_BUDGET_CONS_ORD_EPEC] DEFAULT ('') FOR [ORD_EPEC]

go

UPDATE BUDGET_CONS SET ORD_EPEC = ''
