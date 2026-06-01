/*
Missing Index Details from SQLQuery2.sql - CARDIO-SQL2016.Cardioline (sviluppo (56))
The Query Processor estimates that implementing the following index could improve the query cost by 63.7205%.
*/

CREATE NONCLUSTERED INDEX [INDICE_01]
ON [dbo].[U_ART_AN] ([ART_CODPRI])
INCLUDE ([ART_CODGMI])
GO

