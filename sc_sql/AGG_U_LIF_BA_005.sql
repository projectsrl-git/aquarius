
ALTER TABLE [dbo].[U_LIF_BA] ADD 
	LIS_CODCLI varchar(10) COLLATE Latin1_General_CI_AS NULL,
	LIS_RAGSOC varchar(80) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LIF_BA] WITH NOCHECK ADD
	CONSTRAINT [DF_U_LIF_BA_LIS_CODCLI] DEFAULT ('') FOR [LIS_CODCLI],
	CONSTRAINT [DF_U_LIF_BA_LIS_RAGSOC] DEFAULT ('') FOR [LIS_RAGSOC]
go

UPDATE U_LIF_BA SET LIS_CODCLI = ''
UPDATE U_LIF_BA SET LIS_RAGSOC = ''