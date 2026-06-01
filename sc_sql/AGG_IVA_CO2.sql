
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_IVA_CL] ADD 
	 IVA_BOLLATOIVA varchar(1) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_IVA_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_IVA_CL_IVA_BOLLATOIVA] DEFAULT ('') FOR [IVA_BOLLATOIVA]
go


UPDATE U_IVA_CL SET IVA_BOLLATOIVA = ' '