/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CBI_LOG] ADD 
	CBI_NUMDIS varchar(6) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[CBI_LOG] WITH NOCHECK ADD 
        CONSTRAINT [DF_CBI_LOG_CBI_NUMDIS] DEFAULT ('')    FOR [CBI_NUMDIS] 
go

UPDATE CBI_LOG SET CBI_NUMDIS 	= '' 
