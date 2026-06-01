/* 
*****************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER COSTO PRODOTTO DA DISTINTA BASE:
	- PROD_AVANZA.DIT_COSTO: Prezzo di costo unitario
*****************************************************************************************************************************
*/

ALTER TABLE [dbo].[PROD_AVANZA] ADD 
	[DIT_COSTO] [numeric] (19,6) NULL
go

ALTER TABLE [dbo].[PROD_AVANZA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_AVANZA_DIT_COSTO] DEFAULT (0) FOR [DIT_COSTO]
go


-- AGGIORNAMENTO CAMPI SU PROGRAMMI ESISTENTI
UPDATE PROD_AVANZA SET DIT_COSTO = 0
