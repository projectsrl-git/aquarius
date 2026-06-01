/* 
**************************************************************
INTRASTAT: Codice del paese di origine della merce
**************************************************************
*/    

ALTER TABLE [dbo].[MOV_CONT] ADD 
	MOV_STATO_INTRA_ORIG varchar(2) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_MOV_STATO_INTRA_ORIG] DEFAULT ('')
go

UPDATE MOV_CONT SET MOV_STATO_INTRA_ORIG = MOV_STATO_INTRA_PROV
