/* 
************************************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER GESTIONE ARTICOLI GENERICI IN CARICHI DI PRODUZIONE MANUALE FILM PROTETTIVI (PROD_CARICHI.MAG_LEGMAG)
************************************************************************************************************************************************
*/

ALTER TABLE [dbo].[PROD_CARICHI] ADD 
	MAG_LEGMAG varchar (10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_PROD_CARICHI_MAG_LEGMAG] DEFAULT ('')
go
