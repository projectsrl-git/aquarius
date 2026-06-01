/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_IVF_CL] ADD 
	[IVF_NUMORI] varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_IVF_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_IVF_CL_IVF_NUMORI] DEFAULT ('') FOR [IVF_NUMORI]
go

UPDATE U_IVF_CL SET IVF_NUMORI = ''




