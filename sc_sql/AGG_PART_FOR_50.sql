
ALTER TABLE [dbo].[PART_FOR] ADD 
  SELEZIONE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_SELEZIONE] DEFAULT ('') FOR [SELEZIONE]
go

UPDATE PART_FOR SET SELEZIONE = ''

