/* 
********************************************
INSERIMENTO CAMPO MOV_DTSCAD (DATA SCADENZA)
********************************************
*/    

ALTER TABLE [dbo].[U_MAG_MO] ADD 
	MOV_DTSCAD varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_MOV_GG_MOV_DTSCAD] DEFAULT ('')
go
