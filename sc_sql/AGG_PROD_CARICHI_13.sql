/* 
*****************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER PROGRAMMA DI PRODUZIONE:
	- PROD_CARICHI.TSAGG: Timestamp per DeadLock (blocco avanzamenti in caso di modifica produzione (Massera))
*****************************************************************************************************************************
*/

ALTER TABLE [dbo].[PROD_CARICHI] ADD 
	[TSAGG] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('')
go
