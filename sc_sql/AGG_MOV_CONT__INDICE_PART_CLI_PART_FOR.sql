
ALTER TABLE [dbo].[MOV_CONT] ADD 
  MOV_STATO_CEE varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CONT_MOV_STATO_CEE] DEFAULT ('') FOR [MOV_STATO_CEE]
go

UPDATE MOV_CONT SET MOV_STATO_CEE = ''


ALTER TABLE [dbo].[INDICE] ADD 
  MOV_STATO_CEE varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_STATO_CEE] DEFAULT ('') FOR [MOV_STATO_CEE]
go

UPDATE INDICE SET MOV_STATO_CEE = ''



ALTER TABLE [dbo].[PART_CLI] ADD 
  PAR_STATO_CEE varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_CLI] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_CLI_PAR_STATO_CEE] DEFAULT ('') FOR [PAR_STATO_CEE]
go

UPDATE PART_CLI SET PAR_STATO_CEE = ''



ALTER TABLE [dbo].[PART_FOR] ADD 
  PAR_STATO_CEE varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[PART_FOR] WITH NOCHECK ADD 
	CONSTRAINT [DF_PART_FOR_PAR_STATO_CEE] DEFAULT ('') FOR [PAR_STATO_CEE]
go

UPDATE PART_FOR SET PAR_STATO_CEE = ''
