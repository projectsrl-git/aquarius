/*
Missing Index Details from SQLQuery2.sql - CARDIO-SQL2016.Cardioline (sviluppo (56))
The Query Processor estimates that implementing the following index could improve the query cost by 16.9633%.
*/

CREATE NONCLUSTERED INDEX [INDICE_03]
ON [dbo].[U_VVA_CH] ([VVA_CODVAL],[VVA_DATA])
INCLUDE ([VVA_CHANGE])
GO

