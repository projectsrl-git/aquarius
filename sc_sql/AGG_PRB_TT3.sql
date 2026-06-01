
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PRB_TT] ADD 
	 ORD_CONSED [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PRB_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PRB_TT_ORD_CONSED] DEFAULT (0) FOR [ORD_CONSED]
go
