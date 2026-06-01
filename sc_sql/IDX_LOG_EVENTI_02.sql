/*
Missing Index Details from SQLQuery2.sql - DELLVS15.Cardioline (sviluppo (56))
The Query Processor estimates that implementing the following index could improve the query cost by 90.3767%.
*/


CREATE NONCLUSTERED INDEX [IDX_LOG_EVENTI_02] ON [dbo].[LOG_EVENTI] 
	([STATO_EVENTO])
INCLUDE ([COD_USER],[RUOLO_DEST])
GO
