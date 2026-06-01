/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_AMM_AT] ADD 
	AMM_DATREG VARCHAR(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_AMM_AT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_AMM_AT_AMM_DATREG] DEFAULT ('') FOR [AMM_DATREG]

go

UPDATE U_AMM_AT SET AMM_DATREG = AMM_DATUTI

