
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_FOR_PR] ADD 
	 FPR_NUMUCA varchar(6) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FOR_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FOR_PR_FPR_NUMUCA] DEFAULT ('') FOR [FPR_NUMUCA]
go
