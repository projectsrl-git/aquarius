
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[CBI_LOG] ADD 
	TIPO_FILE varchar(50) COLLATE Latin1_General_CI_AS NULL 
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)

ALTER TABLE [dbo].[CBI_LOG] WITH NOCHECK ADD 
        CONSTRAINT [DF_CBI_LOG_TIPO_FILE] DEFAULT ('0')    FOR [TIPO_FILE] 
go

UPDATE CBI_LOG SET TIPO_FILE 	= '' 
