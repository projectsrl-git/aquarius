
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_SLF_CQ] ADD 
	 SLF_FILNUD [text] COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_SLF_CQ] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_SLF_CQ_SLF_FILNUD] DEFAULT ('') FOR [SLF_FILNUD]
go

UPDATE U_SLF_CQ SET SLF_FILNUD = SPACE(01)