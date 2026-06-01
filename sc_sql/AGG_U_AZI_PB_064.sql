

ALTER TABLE [dbo].[U_AZI_PB] ADD 
	AZI_PRIMAN varchar(20) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AZI_PB] WITH NOCHECK ADD
	CONSTRAINT [DF_U_AZI_PB_AZI_PRIMAN] DEFAULT ('') FOR [AZI_PRIMAN]
go

UPDATE U_AZI_PB SET AZI_PRIMAN = ''