/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_PREV] ADD 
	 ORD_EPEC varchar(200) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[BUDGET_PREV] WITH NOCHECK ADD 

	CONSTRAINT [DF_BUDGET_PREV_ORD_EPEC] DEFAULT ('') FOR [ORD_EPEC]

go

UPDATE BUDGET_PREV SET ORD_EPEC = ''
