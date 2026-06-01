
ALTER TABLE [dbo].[U_GPP_MO] ADD 
  GPP_SYSPAG varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_GPP_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_GPP_MO_GPP_SYSPAG] DEFAULT ('') FOR [GPP_SYSPAG]
go

UPDATE U_GPP_MO SET GPP_SYSPAG = ''

