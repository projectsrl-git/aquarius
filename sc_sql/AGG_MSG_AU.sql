
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MSG_AU] ADD 
	[MSG_FLGLET] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MSG_AU] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MSG_AU_MSG_FLGLET] DEFAULT (0) FOR [MSG_FLGLET]
go
