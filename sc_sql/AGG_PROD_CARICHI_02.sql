/* 
*****************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER PRELIEVO E VERSAMENTO PROGRAMMA DI PROD_CARICHI:
	- PROD_CARICHI.MAGIMP: Magazzini impegnati (quelli di destinazione del prelievo che verranno scaricati durante il versamento)
*****************************************************************************************************************************
*/

ALTER TABLE [dbo].[PROD_CARICHI] ADD 
	[MAGIMP] [varchar] (254) COLLATE Latin1_General_CI_AS NULL
go

ALTER TABLE [dbo].[PROD_CARICHI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PROD_CARICHI_MAGIMP] DEFAULT ('') FOR [MAGIMP]
go


UPDATE PROD_CARICHI SET MAGIMP = ''
