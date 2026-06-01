/*
Missing Index Details from SQLQuery1.sql - SRV-CARDIOLINE.Cardioline_test (sviluppo (79))
The Query Processor estimates that implementing the following index could improve the query cost by 62.273%.
*/

CREATE NONCLUSTERED INDEX [INDICE_09]
ON [dbo].[U_FAT_DD] ([ORD_CODART])
INCLUDE ([DAGGANCIO],[ORD_DESART],[ORD_QTAORD],[ORD_PREZZO],[ORD_PRZNET],[ORD_DATCON],[ORD_PUBBLI],[ORD_SEQUEN],[ord_ccodet])
GO

