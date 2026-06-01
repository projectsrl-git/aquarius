

ALTER TABLE [dbo].[U_FAP_DD] ADD 
	 ORS_SYSDDT varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_FAP_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_FAP_DD_ORS_SYSDDT] DEFAULT ('') FOR [ORS_SYSDDT]
go

UPDATE U_FAP_DD SET ORS_SYSDDT = SPACE(10)