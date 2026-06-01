
ALTER TABLE [dbo].[MOV_CONT] ADD 
  MOV_SYSPAG varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[MOV_CONT] WITH NOCHECK ADD 
	CONSTRAINT [DF_MOV_CONT_MOV_SYSPAG] DEFAULT ('') FOR [MOV_SYSPAG]
go

UPDATE MOV_CONT SET MOV_SYSPAG = ''

