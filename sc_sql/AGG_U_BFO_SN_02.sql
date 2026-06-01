/* 
********************************************
INSERIMENTO CAMPO DTACOL (DATA COLLAUDO)
********************************************
*/    

ALTER TABLE [dbo].[U_BFO_SN] ADD 
	DTACOL varchar(10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_BFO_SN_DTACOL] DEFAULT ('')
go
