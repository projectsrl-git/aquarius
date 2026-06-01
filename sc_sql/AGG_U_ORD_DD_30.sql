
/* 
***************************************************************************************************************************
INSERIMENTO CAMPO FLGOKPROD PER ABILITARE L'ACQUISIZIONE DEI BARCODE PER LOGPRD TAGLIO (GL) IN TABELLA ORDINI IN PRODUZIONE
***************************************************************************************************************************
*/
ALTER TABLE [dbo].[U_ORD_DD] ADD 
	 FLGOKPROD BIT NOT NULL CONSTRAINT [DF_U_ORD_DD_FLGOKPROD] DEFAULT (0)
go

--UPDATE U_ORD_DD SET FLGOKPROD = 1 WHERE ORD_DESART <> '*** COMMENTO ***' AND ORD_CODART <> '' AND ORD_CODSYS IN (SELECT CODSYS FROM PROD_ORDINI WHERE FLGOKPROD = 1)