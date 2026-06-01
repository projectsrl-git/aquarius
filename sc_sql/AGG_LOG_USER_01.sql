
/* 
***********************************************************************************************
INSERIMENTO CAMPO "SPID" IN LOG UTENTE AQUARIUS PER GESTIONE UTENTE COLLEGATO IN AQ_ADMIN
***********************************************************************************************
*/
ALTER TABLE [dbo].[LOG_USER] ADD 
	 [SPID] [varchar] (10) COLLATE Latin1_General_CI_AS NULL
go

-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[LOG_USER] WITH NOCHECK ADD 
	CONSTRAINT [DF_LOG_USER_SPID] DEFAULT ('') FOR [SPID]
go

UPDATE LOG_USER SET SPID = ''
GO


/* 
**************************************************************
ALLARGAMENTO CAMPO ESISTENTE
**************************************************************
*/
ALTER TABLE [dbo].[LOG_USER] ALTER COLUMN
	 OPERAZIONE varchar(200) COLLATE Latin1_General_CI_AS NULL
go
