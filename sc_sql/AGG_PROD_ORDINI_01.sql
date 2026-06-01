
/* 
************************************************************************************
INSERIMENTO CAMPO QTANRC (Numero dadi per pallet) IN TABELLA ORDINI IN PRODUZIONE
************************************************************************************
*/
ALTER TABLE [dbo].[PROD_ORDINI] ADD 
	 QTANRC NUMERIC (13,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PROD_ORDINI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_ORDINI_QTANRC] DEFAULT (0) FOR [QTANRC]
go

UPDATE PROD_ORDINI SET QTANRC = 0
