/* 
****************************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER PRELIEVO E VERSAMENTO PROGRAMMA DI PRODUZIONE:
	- PROD_CARICHI.QTAPREL: Quantità PRELEVATA (necessaria per capire quanto è stato già prelevato e quanto c'è ancora da prelevare)
****************************************************************************************************************************************
*/

ALTER TABLE [dbo].[PROD_CARICHI] ADD 
	[QTAPREL] [numeric] (17,4) NULL
go

ALTER TABLE [dbo].[PROD_CARICHI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_CARICHI_QTAPREL] DEFAULT (0) FOR [QTAPREL]
go


UPDATE PROD_CARICHI SET QTAPREL = 0
