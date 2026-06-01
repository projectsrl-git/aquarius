/* 
********************************************
INSERIMENTO CAMPO MAG_DTACOL (DATA SCADENZA)
********************************************
*/    

ALTER TABLE [dbo].[U_MAG_GG] ADD 
	MAG_DTACOL varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_MAG_GG_MAG_DTACOL] DEFAULT ('')
go
