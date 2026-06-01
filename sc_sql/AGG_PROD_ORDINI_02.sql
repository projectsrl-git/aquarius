
/* 
***************************************************************************************************************************
INSERIMENTO CAMPO FLGOKPROD PER ABILITARE L'ACQUISIZIONE DEI BARCODE PER LOGPRD TAGLIO (GL) IN TABELLA ORDINI IN PRODUZIONE
***************************************************************************************************************************
*/
ALTER TABLE [dbo].[PROD_ORDINI] ADD 
	 FLGOKPROD BIT NOT NULL CONSTRAINT [DF_PROD_ORDINI_FLGOKPROD] DEFAULT (0)
go
