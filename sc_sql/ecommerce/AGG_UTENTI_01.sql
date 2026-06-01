/*   
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[UTENTI] ADD 
	[TIPOLOGIA] 	[varchar] (1)  COLLATE Latin1_General_CI_AS NULL 		
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[UTENTI] WITH NOCHECK ADD 
	CONSTRAINT [DF_UTENTI_TIPOLOGIA] DEFAULT ('') FOR [TIPOLOGIA]
go

update UTENTI set TIPOLOGIA = ''
