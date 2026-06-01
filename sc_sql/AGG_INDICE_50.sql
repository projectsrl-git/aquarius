
ALTER TABLE [dbo].[INDICE] ADD 
  MOV_SYSPAG varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[INDICE] WITH NOCHECK ADD 
	CONSTRAINT [DF_INDICE_MOV_SYSPAG] DEFAULT ('') FOR [MOV_SYSPAG]
go

UPDATE INDICE SET MOV_SYSPAG = ''

