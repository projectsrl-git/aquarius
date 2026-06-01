/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/  
ALTER TABLE [dbo].[UTENTI] ADD 
	[RAGIONE] 	[varchar] (200)  COLLATE Latin1_General_CI_AS NULL 		,
	[TELEFONO] 	[varchar] (20)  COLLATE Latin1_General_CI_AS NULL, 		
	[FAX] 	[varchar] (20)  COLLATE Latin1_General_CI_AS NULL 		
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[UTENTI] WITH NOCHECK ADD 
	CONSTRAINT [DF_UTENTI_RAGIONE] DEFAULT ('') FOR [RAGIONE],
	CONSTRAINT [DF_UTENTI_TELEFONO] DEFAULT ('') FOR [TELEFONO],
	CONSTRAINT [DF_UTENTI_FAX] DEFAULT ('') FOR [FAX]
go

update UTENTI set RAGIONE = ''
update UTENTI set TELEFONO = ''
update UTENTI set FAX = ''