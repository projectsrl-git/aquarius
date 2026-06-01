/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[BUDGET_CONS] ADD 
	CODAG2 varchar(03) COLLATE Latin1_General_CI_AS NULL,
	DESAG2 varchar(100) COLLATE Latin1_General_CI_AS NULL,
	CODAG3 varchar(03) COLLATE Latin1_General_CI_AS NULL,
	DESAG3 varchar(100) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[BUDGET_CONS] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_CONS_CODAG2] DEFAULT ('') FOR [CODAG2],
	CONSTRAINT [DF_BUDGET_CONS_DESAG2] DEFAULT ('') FOR [DESAG2],
	CONSTRAINT [DF_BUDGET_CONS_CODAG3] DEFAULT ('') FOR [CODAG3],
	CONSTRAINT [DF_BUDGET_CONS_DESAG3] DEFAULT ('') FOR [DESAG3]
go

UPDATE BUDGET_CONS SET CODAG2 = ''
UPDATE BUDGET_CONS SET DESAG2 = ''
UPDATE BUDGET_CONS SET CODAG3 = ''
UPDATE BUDGET_CONS SET DESAG3 = ''



