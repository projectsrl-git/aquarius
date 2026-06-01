/*
Missing Index Details from SQLQuery1.sql - SRV-CARDIOLINE.Cardioline (sviluppo (86))
The Query Processor estimates that implementing the following index could improve the query cost by 63.205%.
*/

CREATE NONCLUSTERED INDEX [INDICE_07]
ON [dbo].[U_FAT_DD] ([ORS_NUMDDT],[ORS_DATDDT],[ORD_DESART])
INCLUDE ([ORS_NUMORD],[ORS_DATORD])
GO

