
ALTER TABLE [dbo].[INDICE] ADD 
  MOV_SYSDOC varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_SYSDOC] DEFAULT ('') FOR [MOV_SYSDOC]
go

UPDATE INDICE SET MOV_SYSDOC = ''

