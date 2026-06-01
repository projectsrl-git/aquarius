/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_AD] ADD 
	AMD_CONTO varchar(13) COLLATE Latin1_General_CI_AS NULL,
	AMD_TOP varchar(03) COLLATE Latin1_General_CI_AS NULL,
	AMD_DESTOP varchar(50) COLLATE Latin1_General_CI_AS NULL,
	AMD_NREGIS varchar(10) COLLATE Latin1_General_CI_AS NULL,
	AMD_NPART NUMERIC (10,0)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_AD] WITH NOCHECK ADD
	CONSTRAINT [DF_U_AMM_AD_AMD_CONTO] DEFAULT ('') FOR [AMD_CONTO],
	CONSTRAINT [DF_U_AMM_AD_AMD_TOP] DEFAULT ('') FOR [AMD_TOP],
	CONSTRAINT [DF_U_AMM_AD_AMD_DESTOP] DEFAULT ('') FOR [AMD_DESTOP],
	CONSTRAINT [DF_U_AMM_AD_AMD_NREGIS] DEFAULT ('') FOR [AMD_NREGIS],
	CONSTRAINT [DF_U_AMM_AD_AMD_NPART] DEFAULT (0) FOR [AMD_NPART]
go

UPDATE U_AMM_AD SET AMD_CONTO = ''
UPDATE U_AMM_AD SET AMD_TOP = ''
UPDATE U_AMM_AD SET AMD_DESTOP = ''
UPDATE U_AMM_AD SET AMD_NREGIS = ''
UPDATE U_AMM_AD SET AMD_NPART = 0