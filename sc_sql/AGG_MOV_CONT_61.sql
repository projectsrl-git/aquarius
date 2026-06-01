/* 
**************************************************************
INTRASTAT: Codice del paese di origine della merce
**************************************************************
*/    

ALTER TABLE [dbo].[MOV_CONT] ADD 
	MOV_REGAUT varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_MOV_REGAUT] DEFAULT ('')
go


