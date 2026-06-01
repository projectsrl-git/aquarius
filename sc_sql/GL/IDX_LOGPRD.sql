/*
Missing Index Details from SQLQuery3.sql - DELLVS15.Cardioline (sviluppo (53))
The Query Processor estimates that implementing the following index could improve the query cost by 48.7748%.
*/

IF  EXISTS (SELECT * FROM sys.indexes WHERE object_id = OBJECT_ID(N'[dbo].[PRODUZIONE]') AND name = N'IDX_LOGPRD')
	DROP INDEX [IDX_LOGPRD] ON [dbo].[PRODUZIONE] WITH ( ONLINE = OFF )
GO

CREATE NONCLUSTERED INDEX [IDX_LOGPRD]
ON [dbo].[PRODUZIONE] ([IDPRG],[PARENT],[FLGCLOSED])
INCLUDE ([NUMPRG],[DATPRG])
GO
