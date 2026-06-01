
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_CMP_CL] ADD 
	CMP_NUMCMP varchar(06) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_CMP_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CMP_CL_CMP_NUMCMP] DEFAULT ('') FOR [CMP_NUMCMP]
go

UPDATE U_CMP_CL SET CMP_NUMCMP = SPACE(06)
