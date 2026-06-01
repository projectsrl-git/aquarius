/* 
*****************************************************************************************************************************
INSERIMENTO NUOVI CAMPI PER PROGRAMMA DI PRODUZIONE:
	- PRODUZIONE.LIVELLO: Livello, per gestire il livello gerarchico del componente)
	- PRODUZIONE.DIS_QTAT: Coefficiente di impiego totale del componente
	- PRODUZIONE.GRUART: Tipo articolo ('G' se gruppo (CON FIGLI), 'A' se articolo di acquisto / materia prima (SENZA FIGLI))
	- PRODUZIONE.MPARENT: Main Parent (chiave del padre principale ovvero il prodotto finito)
*****************************************************************************************************************************
*/

ALTER TABLE [dbo].[PRODUZIONE] ADD 
	[LIVELLO] [numeric] (10,0) NULL,
	[DIS_QTAT] [numeric] (17,4) NULL,
	[GRUART] [varchar] (1) COLLATE Latin1_General_CI_AS NULL,
	[MPARENT] [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
	[GERARCHIA] [varchar] (254) COLLATE Latin1_General_CI_AS NULL,
	[GERARC_KEY] [varchar] (254) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[PRODUZIONE] WITH NOCHECK ADD 
	CONSTRAINT [DF_PRODUZIONE_LIVELLO] DEFAULT (0) FOR [LIVELLO],
	CONSTRAINT [DF_PRODUZIONE_DIS_QTAT] DEFAULT (0) FOR [DIS_QTAT],
	CONSTRAINT [DF_PRODUZIONE_GRUART] DEFAULT ('') FOR [GRUART],
	CONSTRAINT [DF_PRODUZIONE_MPARENT] DEFAULT ('') FOR [MPARENT],
	CONSTRAINT [DF_PRODUZIONE_GERARCHIA] DEFAULT ('') FOR [GERARCHIA],
	CONSTRAINT [DF_PRODUZIONE_GERARC_KEY] DEFAULT ('') FOR [GERARC_KEY]
go


-- AGGIORNAMENTO CAMPI SU PROGRAMMI ESISTENTI
UPDATE PRODUZIONE SET LIVELLO = 0
UPDATE PRODUZIONE SET DIS_QTAT = 0
UPDATE PRODUZIONE SET GRUART = 0
UPDATE PRODUZIONE SET MPARENT = 0
UPDATE PRODUZIONE SET GERARCHIA = 0
UPDATE PRODUZIONE SET GERARC_KEY = 0
