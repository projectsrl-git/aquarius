

ALTER TABLE [dbo].[U_BOL_DD] ADD 
	 RES_CODINT varchar(16) COLLATE Latin1_General_CI_AS NULL,
	 RES_NUMLOT numeric(08) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_BOL_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BOL_DD_RES_CODINT] DEFAULT ('') FOR [RES_CODINT],
	CONSTRAINT [DF_U_BOL_DD_RES_NUMLOT] DEFAULT (0) FOR [RES_NUMLOT]
go

UPDATE U_BOL_DD SET RES_CODINT = SPACE(16)
UPDATE U_BOL_DD SET RES_NUMLOT = 0

