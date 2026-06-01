/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_AD] ADD 
	AMD_MOVSEQ NUMERIC (15,0)  NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_AD] WITH NOCHECK ADD
	CONSTRAINT [DF_U_AMM_AD_AMD_MOVSEQ] DEFAULT (0) FOR [AMD_MOVSEQ]
go

UPDATE U_AMM_AD SET AMD_MOVSEQ = 0