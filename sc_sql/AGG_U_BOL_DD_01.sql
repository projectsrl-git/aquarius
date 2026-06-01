
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_BOL_DD] ADD 
	ORD_PROGRE 	varchar (10) 	COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_ORD_PROGRE] DEFAULT ('') FOR [ORD_PROGRE]
go

UPDATE U_BOL_DD SET ORD_PROGRE = ''


