/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CNT_TT] ADD 
	CNT_TRASME bit NULL,
	CNT_DTTRAS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	CNT_ORTRAS varchar(8) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CNT_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CNT_TT_CNT_TRASME] DEFAULT (0) FOR [CNT_TRASME],
	CONSTRAINT [DF_U_CNT_TT_CNT_DTTRAS] DEFAULT ('') FOR [CNT_DTTRAS],
	CONSTRAINT [DF_U_CNT_TT_CNT_ORTRAS] DEFAULT ('') FOR [CNT_ORTRAS]
go

UPDATE U_CNT_TT SET CNT_TRASME = 0
UPDATE U_CNT_TT SET CNT_DTTRAS = ''
UPDATE U_CNT_TT SET CNT_ORTRAS = ''

