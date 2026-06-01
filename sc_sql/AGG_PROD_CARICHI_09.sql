/* 
************************************************************************************************************************************************
INSERIMENTO NUOVI CAMPI PER GESTIONE BANCALI IN CARICHI DI PRODUZIONE:
	- PROD_CARICHI.LUNPCK: Lunghezza imballo
	- PROD_CARICHI.AGGDDT: Aggancio DDT generata
************************************************************************************************************************************************
*/

ALTER TABLE [dbo].[PROD_CARICHI] ADD 
	LUNPCK numeric (10,0) NULL,
	AGGDDT varchar (10) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[PROD_CARICHI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_CARICHI_LUNPCK] DEFAULT (0) FOR [LUNPCK],
	CONSTRAINT [DF_PROD_CARICHI_AGGDDT] DEFAULT ('') FOR [AGGDDT]
go

UPDATE PROD_CARICHI SET LUNPCK = 0
UPDATE PROD_CARICHI SET AGGDDT = ''

