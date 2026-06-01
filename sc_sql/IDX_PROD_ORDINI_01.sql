/*
Missing Index Details from SQLQuery7.sql - srv-l3a.l3a_test (sviluppo (70))
The Query Processor estimates that implementing the following index could improve the query cost by 44.0791%.
*/

CREATE NONCLUSTERED INDEX [IDX_PROD_ORDINI_01]
ON [dbo].[PROD_ORDINI] ([CODSYS],[IDPRG])
INCLUDE ([NUMORD],[DATORD],[CODCLI],[RAGSOC])
GO

