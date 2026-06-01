
ALTER TABLE [dbo].[U_LOC_GE] ADD 
	 LOC_FDESCR varchar(20) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LOC_GE] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LOC_GE_LOC_FDESCR] DEFAULT ('') FOR [LOC_FDESCR]
go

UPDATE U_LOC_GE SET LOC_FDESCR = ''

