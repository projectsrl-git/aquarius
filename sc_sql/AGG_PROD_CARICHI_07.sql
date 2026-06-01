/* 
************************************************************************************************************************************************
INSERIMENTO NUOVI CAMPI PER PRELIEVO E VERSAMENTO PROGRAMMA DI PRODUZIONE:
	- PROD_CARICHI.QTAPREL_LORDA: Quantità PRELEVATA LORDA (necessaria per capire quanto è stato già prelevato e quanto c'è ancora da prelevare)
************************************************************************************************************************************************
*/

ALTER TABLE [dbo].[PROD_CARICHI] ADD 
	QTAPREL_LORDA numeric (17,4) NULL,
	NOTE TEXT COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[PROD_CARICHI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_CARICHI_QTAPREL_LORDA] DEFAULT (0) FOR [QTAPREL_LORDA],
	CONSTRAINT [DF_PROD_CARICHI_QTAPREL_NOTE] DEFAULT ('') FOR [NOTE]
go


--UPDATE PROD_CARICHI SET QTAPREL_LORDA = 0
UPDATE PROD_CARICHI SET NOTE = ''
