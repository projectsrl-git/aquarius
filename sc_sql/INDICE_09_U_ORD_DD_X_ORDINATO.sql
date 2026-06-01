/*
Missing Index Details from VISTA_ORDINATO.sql - DELLVS15.Cardioline (sviluppo (52))
The Query Processor estimates that implementing the following index could improve the query cost by 63.2221%.
*/

CREATE NONCLUSTERED INDEX [INDICE_09]
ON [dbo].[U_ORD_DD] ([ORD_QTAORD])
INCLUDE ([DAGGANCIO],[ORD_CODART],[ORD_DESART],[ORD_QTAEV],[ORD_PREZZO],[ORD_PRZNET],[ORD_DATCON],[ORD_PUBBLI],[ORD_CCODET])
GO
