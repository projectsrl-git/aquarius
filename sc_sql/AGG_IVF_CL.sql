/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_IVF_CL] ADD 
	[IVF_NUMNEW] numeric(10) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_IVF_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_IVF_CL_IVF_NUMNEW] DEFAULT (0) FOR [IVF_NUMNEW]
go

UPDATE U_IVF_CL SET IVF_NUMNEW = 0



