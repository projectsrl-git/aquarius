
/* 
*************************************************************************
INSERIMENTO CAMPO QTANRC (Numero dadi per pallet) IN TABELLA PACKING LIST
*************************************************************************
*/
ALTER TABLE [dbo].[PROD_PACKING] ADD 
	QTANRC NUMERIC (17,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PROD_PACKING] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_PACKING_QTANRC] DEFAULT (0) FOR [QTANRC]
go

UPDATE PROD_PACKING SET QTANRC = 0
