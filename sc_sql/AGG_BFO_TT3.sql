
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BFO_TT] ADD 
	 ORD_TIPO numeric(1,0) NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BFO_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_TT_ORD_TIPO] DEFAULT ('0') FOR [ORD_TIPO]
go
