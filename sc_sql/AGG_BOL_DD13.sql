
ALTER TABLE [dbo].[U_BOL_DD] ADD 
	 ORD_FLGPKL [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_ORD_FLGPKL] DEFAULT (0) FOR [ORD_FLGPKL]
go
UPDATE U_BOL_DD SET ORD_FLGPKL = 0

