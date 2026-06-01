/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[LOG_USER] ADD 
	[HTTP_PARAMS]		[varchar] (255) COLLATE Latin1_General_CI_AS  NULL
	
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[LOG_USER] WITH NOCHECK ADD 
	CONSTRAINT [DF_LOG_USER_HTTP_PARAMS] DEFAULT ('') FOR [HTTP_PARAMS]

go

update LOG_USER set HTTP_PARAMS = ''
