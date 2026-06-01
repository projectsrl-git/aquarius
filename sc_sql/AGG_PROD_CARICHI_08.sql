/* 
************************************************************************************************************************************************
INSERIMENTO NUOVI CAMPI PER GESTIONE BANCALI IN CARICHI DI PRODUZIONE:
	- PROD_CARICHI.CODIMB: Codice imballo
	- PROD_CARICHI.DESIMB: Descrizione imballo
	- PROD_CARICHI.NUMDDT: N° DDT creata
	- PROD_CARICHI.DATDDT: Data DDT creata
************************************************************************************************************************************************
*/

ALTER TABLE [dbo].[PROD_CARICHI] ADD 
	CODIMB varchar (3) COLLATE Latin1_General_CI_AS NULL,
	DESIMB varchar (50) COLLATE Latin1_General_CI_AS NULL,
	NUMDDT varchar (6) COLLATE Latin1_General_CI_AS NULL,
	DATDDT varchar (50) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[PROD_CARICHI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_CARICHI_CODIMB] DEFAULT ('') FOR [CODIMB],
	CONSTRAINT [DF_PROD_CARICHI_DESIMB] DEFAULT ('') FOR [DESIMB],
	CONSTRAINT [DF_PROD_CARICHI_NUMDDT] DEFAULT ('') FOR [NUMDDT],
	CONSTRAINT [DF_PROD_CARICHI_DATDDT] DEFAULT ('') FOR [DATDDT]
go

UPDATE PROD_CARICHI SET CODIMB = ''
UPDATE PROD_CARICHI SET DESIMB = ''
UPDATE PROD_CARICHI SET NUMDDT = ''
UPDATE PROD_CARICHI SET DATDDT = ''
