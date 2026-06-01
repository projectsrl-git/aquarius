/* 
********************************************************************
INSERIMENTO NUOVO CAMPO PER CARICHI DA PROGRAMMI DI PRODUZIONE:
	- Serial Number (assegnato al momento del prelievo)
********************************************************************
*/
ALTER TABLE [dbo].[PROD_CARICHI] ADD 
	[SERIAL] [varchar] (10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[PROD_CARICHI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_CARICHI_SERIAL] DEFAULT ('') FOR [SERIAL]
go

UPDATE PROD_CARICHI SET SERIAL = ''
