/*
Missing Index Details from SQLQuery3.sql - IMPRESIND.Impresind (sviluppo (62))
The Query Processor estimates that implementing the following index could improve the query cost by 46.9886%.
*/

GO
CREATE NONCLUSTERED INDEX [INDICE_01]
ON [dbo].[MOV_CONT] ([MOV_ANNO],[MOV_TOP])
INCLUDE ([MOV_DTREG],[MOV_CONTO],[MOV_TMOV],[MOV_IMP],[MOV_CAMBIO],[MOV_CONTABILITA_PREVISIONALE])
GO
