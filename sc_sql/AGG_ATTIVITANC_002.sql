
ALTER TABLE [dbo].[ATTIVITANC] ADD 
	DATA_ATT varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[ATTIVITANC] WITH NOCHECK ADD
	CONSTRAINT [DF_ATTIVITANC_DATA_ATT] DEFAULT ('') FOR [DATA_ATT]
go

UPDATE ATTIVITANC SET DATA_ATT = ''