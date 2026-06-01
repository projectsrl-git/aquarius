/*
The Query Processor estimates that implementing the following index could improve the query cost by 25.3532%.
Nuovo indice per gestione schede sicurezza
*/

CREATE NONCLUSTERED INDEX [INDICE_01]
ON [dbo].[SCHEDE_SDS] ([SDS_CODICE],[SDS_VERSION])
GO


