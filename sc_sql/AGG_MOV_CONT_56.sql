/* 
************************************************************************
AGGIUNTA CAMPO PER ESCLUSIONE MOVIMENTO CONTABILE DA DICHIARAZIONE INTRA
************************************************************************
*/
ALTER TABLE [dbo].[MOV_CONT] ADD
	MOV_INTRA_DELETED BIT NOT NULL CONSTRAINT [DF_MOV_CONT_MOV_INTRA_DELETED] DEFAULT (0)
go
