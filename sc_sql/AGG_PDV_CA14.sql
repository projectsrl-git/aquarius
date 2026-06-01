
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_CA] ADD 
	[CAS_FLGSOF] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_CA_CAS_FLGSOF] DEFAULT (0) FOR [CAS_FLGSOF]
go

UPDATE U_PDV_CA SET CAS_FLGSOF = 0