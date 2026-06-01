/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[MAIL_ADDRESS] ADD 
	CONFERMA BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[MAIL_ADDRESS] WITH NOCHECK ADD 
	CONSTRAINT [DF_MAIL_ADDRESS_CONFERMA] DEFAULT 0 FOR [CONFERMA]
go

UPDATE MAIL_ADDRESS SET CONFERMA = 0
