
ALTER TABLE [dbo].[STRUTTURA_LISTINI] ADD 
	LIS_DTVALI varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[STRUTTURA_LISTINI] WITH NOCHECK ADD
	CONSTRAINT [DF_STRUTTURA_LISTINI_LIS_DTVALI] DEFAULT ('') FOR [LIS_DTVALI]
go

UPDATE STRUTTURA_LISTINI SET LIS_DTVALI = ''