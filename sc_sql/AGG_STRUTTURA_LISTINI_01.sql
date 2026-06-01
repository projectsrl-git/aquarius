
ALTER TABLE [dbo].[STRUTTURA_LISTINI] ADD 
	COL_DESEST varchar(03) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[STRUTTURA_LISTINI] WITH NOCHECK ADD
	CONSTRAINT [DF_STRUTTURA_LISTINI_COL_DESEST] DEFAULT ('') FOR [COL_DESEST]
go

UPDATE STRUTTURA_LISTINI SET COL_DESEST = ''