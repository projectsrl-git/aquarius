
ALTER TABLE [dbo].[U_ART_AN] ADD 
	ART_MAGCLES varchar(6) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ART_AN] WITH NOCHECK ADD
	CONSTRAINT [DF_U_ART_AN_ART_MAGCLES] DEFAULT ('') FOR [ART_MAGCLES]
go


UPDATE U_ART_AN SET ART_MAGCLES = ''