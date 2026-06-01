
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[RISUMANA] ADD 
	 PASSWORD varchar(30) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[RISUMANA] WITH NOCHECK ADD 
	CONSTRAINT [DF_RISUMANA_PASSWORD] DEFAULT ('') FOR [PASSWORD]
go

UPDATE RISUMANA SET PASSWORD = ''

