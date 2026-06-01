/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_AD] ADD 
	AMD_ANNO VARCHAR(04) COLLATE Latin1_General_CI_AS NULL,
	AMD_DTREG VARCHAR(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_AD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_AD_AMD_ANNO] DEFAULT ('') FOR [AMD_ANNO],
	CONSTRAINT [DF_U_AMM_AD_AMD_DTREG] DEFAULT (0) FOR [AMD_DTREG]
go

UPDATE U_AMM_AD SET AMD_ANNO  = ''
UPDATE U_AMM_AD SET AMD_DTREG = ''

