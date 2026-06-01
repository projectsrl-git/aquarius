
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_CA] ADD 
	 CAS_FORNIT varchar(10) COLLATE Latin1_General_CI_AS NULL,
	 CAS_RAGFOR varchar(50) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_CA_CAS_FORNIT] DEFAULT ('') FOR [CAS_FORNIT],
	CONSTRAINT [DF_U_PDV_CA_CAS_RAGFOR] DEFAULT ('') FOR [CAS_RAGFOR]
go
