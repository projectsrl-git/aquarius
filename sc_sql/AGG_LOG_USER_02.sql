
/* 
***********************************************************************************************
INSERIMENTO CAMPO "PID" IN LOG UTENTE AQUARIUS PER IDENTIFICARE L'ID DEL PROCESSO WINDOWS
***********************************************************************************************
*/
ALTER TABLE [dbo].[LOG_USER] ADD 
	 [PID] [numeric] (10,0) NOT NULL CONSTRAINT [DF_LOG_USER_PID] DEFAULT (0)
go
