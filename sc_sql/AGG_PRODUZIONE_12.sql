/* 
*****************************************************************************************************************************
INSERIMENTO NUOVO CAMPO PER PROGRAMMA DI PRODUZIONE:
	- PRODUZIONE.TSAGG: Timestamp per DeadLock (blocco modifiche in caso di avanzamento produzione (Massera))
*****************************************************************************************************************************
*/

ALTER TABLE [dbo].[PRODUZIONE] ADD 
	[TSAGG] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ('')
go
