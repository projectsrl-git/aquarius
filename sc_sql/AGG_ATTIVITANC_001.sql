
ALTER TABLE [dbo].[ATTIVITANC] ADD 
	COD_OPE varchar(80) COLLATE Latin1_General_CI_AS NULL,
	DES_OPE varchar(100) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[ATTIVITANC] WITH NOCHECK ADD
	CONSTRAINT [DF_ATTIVITANC_COD_OPE] DEFAULT ('') FOR [COD_OPE],
	CONSTRAINT [DF_ATTIVITANC_DES_OPE] DEFAULT ('') FOR [DES_OPE]
go

UPDATE ATTIVITANC SET COD_OPE = ''
UPDATE ATTIVITANC SET DES_OPE = ''