/* 
********************************************
INSERIMENTO CAMPO DTASCA (DATA SCADENZA)
********************************************
*/    

ALTER TABLE [dbo].[U_BFO_SN] ADD 
	DTASCA varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_BFO_SN_DTASCA] DEFAULT ('')
go
