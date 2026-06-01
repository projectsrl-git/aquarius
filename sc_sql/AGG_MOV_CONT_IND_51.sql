
ALTER TABLE [dbo].[MOV_CONT] ADD 
  MOV_CODCES varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CONT_MOV_CODCES] DEFAULT ('') FOR [MOV_CODCES]
go

UPDATE MOV_CONT SET MOV_CODCES = ''


ALTER TABLE [dbo].[INDICE] ADD 
  MOV_CODCES varchar(16) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_CODCES] DEFAULT ('') FOR [MOV_CODCES]
go

UPDATE INDICE SET MOV_CODCES = ''

