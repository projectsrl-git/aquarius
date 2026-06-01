/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_PDV_CA] ADD 
	 CAS_TOTALE [numeric](17, 2) NULL ,
	 CAS_RESTO [numeric](17, 2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_PDV_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_PDV_CA_CAS_TOTALE] DEFAULT (0) FOR [CAS_TOTALE],
	CONSTRAINT [DF_U_PDV_CA_CAS_RESTO] DEFAULT (0) FOR [CAS_RESTO]
go
