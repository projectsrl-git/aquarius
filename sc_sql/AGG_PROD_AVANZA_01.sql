
/* 
************************************************************************************************************
INSERIMENTO NUOVO CAMPO NUMERO PRESSATE EFFETTIVO (NRPRESS2) - VENGONO PRODOTTI 6 MEGA PANNELLI PER PRESSATA
************************************************************************************************************
*/
ALTER TABLE [dbo].[PROD_AVANZA] ADD 
	[NRPRESS2] [numeric] (12,0) NULL
go

ALTER TABLE [dbo].[PROD_AVANZA] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_AVANZA_NRPRESS2] DEFAULT (0) FOR [NRPRESS2]
go

UPDATE PROD_AVANZA SET NRPRESS2 = CEILING(NRPRESS / 6)

