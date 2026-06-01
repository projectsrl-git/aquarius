/* 
***************************************************************************************************
INSERIMENTO CAMPI PER GESTIONE SCONTI ACQUISTO VENDITE AL BANCO
***************************************************************************************************
*/    

ALTER TABLE [dbo].[STRUTTURA_LISTINI] ADD 
	LIS_SC1 NUMERIC(7,2) NOT NULL CONSTRAINT [DF_STRUTTURA_LISTINI_LIS_SC1] DEFAULT (0),
	LIS_SC2 NUMERIC(7,2) NOT NULL CONSTRAINT [DF_STRUTTURA_LISTINI_LIS_SC2] DEFAULT (0),
	LIS_SC3 NUMERIC(7,2) NOT NULL CONSTRAINT [DF_STRUTTURA_LISTINI_LIS_SC3] DEFAULT (0)
go

