/*
The Query Processor estimates that implementing the following index could improve the query cost by 25.3532%.
Nuovo indice per gestione garanzie
*/

CREATE NONCLUSTERED INDEX [INDICE_03]
ON [dbo].[U_BOL_DD] ([ORD_DESART],[ORD_DES2])
INCLUDE ([ORD_CODART],[ORS_NUMORD],[ORS_DATORD])
GO

