
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_INV_MA] ADD 
	 INV_MODIFI [bit] NULL,
	 INV_INSERI [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_INV_MA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_INV_MA_INV_MODIFI] DEFAULT (0) FOR [INV_MODIFI],
	CONSTRAINT [DF_U_INV_MA_INV_INSERI] DEFAULT (0) FOR [INV_INSERI]
go

UPDATE U_INV_MA SET INV_MODIFI = 0
UPDATE U_INV_MA SET INV_INSERI = 0
