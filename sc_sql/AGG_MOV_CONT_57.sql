/* 
************************************************************************
AGGIUNTA CAMPO PER ESCLUSIONE MOVIMENTO CONTABILE DA DICHIARAZIONE INTRA
************************************************************************
*/
ALTER TABLE [dbo].[MOV_CONT] ADD
	MOV_ANT_CAMB_SEGNO BIT NOT NULL CONSTRAINT [DF_MOV_CONT_MOV_ANT_CAMB_SEGNO] DEFAULT (0)
go
