/* 
**********************************************************************
INSERIMENTO CAMPI PER GESTIONE FATTURE IN PROGETTO AQ_SUWAMA
**********************************************************************
*/    

ALTER TABLE [dbo].[U_MAG_MO] ADD 
	MOV_INVCLSD BIT NOT NULL CONSTRAINT [DF_U_MAG_MO_MOV_INVCLSD] DEFAULT (0),
	MOV_CHNGUSD NUMERIC(15,10) NOT NULL CONSTRAINT [DF_U_MAG_MO_MOV_CHNGUSD] DEFAULT (0)
go
