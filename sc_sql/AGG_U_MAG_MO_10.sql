/* 
**********************************************************************
INSERIMENTO CAMPI PER GESTIONE FATTURE IN PROGETTO AQ_SUWAMA
**********************************************************************
*/    

ALTER TABLE [dbo].[U_MAG_MO] ADD 
	MOV_VIA varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_MAG_MO_MOV_VIA] DEFAULT (''),
	MOV_PORT varchar(50) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_MAG_MO_MOV_PORT] DEFAULT ('')
go
