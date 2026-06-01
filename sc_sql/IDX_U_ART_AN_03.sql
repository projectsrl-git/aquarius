/*
Missing Index Details from SQLQuery2.sql - DELLVS15.Cardioline (sviluppo (58))
The Query Processor estimates that implementing the following index could improve the query cost by 17.932%.
*/

CREATE NONCLUSTERED INDEX [U_ART_AN_03]
ON [dbo].[U_ART_AN] ([ART_CODTSN])
INCLUDE ([ART_CODPRI])
GO

