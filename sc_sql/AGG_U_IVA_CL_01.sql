
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_IVA_CL] ADD 
 	 iva_top varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_IVA_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_IVA_CL_iva_top]  DEFAULT ('   ') FOR [iva_top]
go

UPDATE U_IVA_CL SET iva_top 	= '  '

