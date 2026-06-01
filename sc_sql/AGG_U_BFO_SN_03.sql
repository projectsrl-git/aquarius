/* 
*****************************************************
INSERIMENTO CAMPO PROGRE (PROGRESSIVO DI INSERIMENTO)
*****************************************************
*/    

ALTER TABLE [dbo].[U_BFO_SN] ADD 
	PROGRE NUMERIC(10,0) NOT NULL CONSTRAINT [DF_U_BFO_SN_PROGRE] DEFAULT (0)
go
