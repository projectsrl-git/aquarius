
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_IVA_TS] ADD 
 	 ITO_PA varchar(01) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_IVA_TS] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_IVA_TS_ITO_PA]  DEFAULT ('   ') FOR [ITO_PA]
go

UPDATE U_IVA_TS SET ITO_PA 	= ''

