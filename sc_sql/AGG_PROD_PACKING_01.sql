
/* 
*************************************************************************
INSERIMENTO CAMPO NRPALLETS (Numero pallets) IN TABELLA PACKING LIST
*************************************************************************
*/
ALTER TABLE [dbo].[PROD_PACKING] ADD 
	 NRPALLETS NUMERIC (13,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PROD_PACKING] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_PACKING_NRPALLETS] DEFAULT (0) FOR [NRPALLETS]
go

UPDATE PROD_PACKING SET NRPALLETS = 0
