/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_IVA_CL] ADD 
	[IVA_NUMNEW] numeric(10) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_IVA_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_IVA_CL_IVA_NUMNEW] DEFAULT (0) FOR [IVA_NUMNEW]
go

UPDATE U_IVA_CL SET IVA_NUMNEW = 0



