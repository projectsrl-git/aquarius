/* 
****************************************************************************************
ALLARGAMENTO A 50 CARATTERI CAMPI NOME REPORT IN TABELLA PER PERSONALIZZAZIONE DOCUMENTI
****************************************************************************************
*/


ALTER TABLE [dbo].[DOCUMENTI] ALTER COLUMN DOC_REPORT1 varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[DOCUMENTI] ALTER COLUMN DOC_REPORT2 varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[DOCUMENTI] ALTER COLUMN DOC_REPORT3 varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go

ALTER TABLE [dbo].[DOCUMENTI] ALTER COLUMN DOC_REPORT4 varchar(50) COLLATE Latin1_General_CI_AS NOT NULL
go