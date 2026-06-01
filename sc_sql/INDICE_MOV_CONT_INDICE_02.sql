/*
Dettagli indice mancanti in SQLQuery1.sql - CARDIO-SQL2016.Cardioline (sviluppo (77))
Query Processor stima che l'implementazione del seguente indice potrebbe migliorare il costo della query di 93.885%.
*/

CREATE NONCLUSTERED INDEX [INDICE_02]
ON [dbo].[MOV_CONT] ([MOV_ANNO])
INCLUDE ([MOV_DTREG],[MOV_CONTO],[MOV_TMOV],[MOV_IMP],[MOV_CAMBIO],[MOV_CCO])
GO

