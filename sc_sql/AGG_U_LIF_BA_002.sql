
ALTER TABLE [dbo].[U_LIF_BA] ADD 
	LIS_SCOMAGG varchar(10) COLLATE Latin1_General_CI_AS NULL,
	LIS_DESSCM varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LIF_BA] WITH NOCHECK ADD
	CONSTRAINT [DF_U_LIF_BA_LIS_SCOMAGG] DEFAULT ('') FOR [LIS_SCOMAGG],
	CONSTRAINT [DF_U_LIF_BA_LIS_DESSCM] DEFAULT ('') FOR [LIS_DESSCM]
go

UPDATE U_LIF_BA SET LIS_SCOMAGG = ''
UPDATE U_LIF_BA SET LIS_DESSCM = ''