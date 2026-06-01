
/* 
*************************************************************************
INSERIMENTO CAMPO ORD_VETXTR (Vettore occasionale) IN TABELLA TESTATA DDT
*************************************************************************
*/
ALTER TABLE [dbo].[U_BOL_TT] ADD 
	 ORD_VETXTR text NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_TT_ORD_VETXTR] DEFAULT ('') FOR [ORD_VETXTR]
go

UPDATE U_BOL_TT SET ORD_VETXTR = ''
