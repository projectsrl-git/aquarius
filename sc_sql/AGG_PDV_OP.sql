
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_OP] ADD 
	 CAS_CODPDV varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_OP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_OP_CAS_CODPDV] DEFAULT ('') FOR [CAS_CODPDV]
go
