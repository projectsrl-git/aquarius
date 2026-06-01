/*
Missing Index Details from SQLQuery1.sql - ELSYST.AQ_ELSYST (sviluppo (56))
The Query Processor estimates that implementing the following index could improve the query cost by 41.9726%.
*/

CREATE NONCLUSTERED INDEX [IDX_PRODUZIONE_02]
ON [dbo].[PRODUZIONE] ([COMP],[FASELA],[DIS_FITTIZ],[LIVELLO])

GO

