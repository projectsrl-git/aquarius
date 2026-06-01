

ALTER TABLE [dbo].[U_BOL_DD] ADD 
	 ORD_NRERES numeric(10) NULL,
	 ORD_QTERES numeric(10,2) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_ORD_NRERES] DEFAULT (0) FOR [ORD_NRERES],
	CONSTRAINT [DF_U_BOL_DD_ORD_QTERES] DEFAULT (0) FOR [ORD_QTERES]
go

UPDATE U_BOL_DD SET ORD_NRERES = 0
UPDATE U_BOL_DD SET ORD_QTERES = 0

