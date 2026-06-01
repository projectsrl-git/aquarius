
ALTER TABLE [dbo].[U_LOC_GE] ADD 
	LOC_H numeric(6,0) NULL,
	LOC_L numeric(6,0) NULL,
	LOC_P numeric(6,0) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_LOC_GE] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LOC_GE_LOC_H] DEFAULT (0) FOR [LOC_H],
	CONSTRAINT [DF_U_LOC_GE_LOC_L] DEFAULT (0) FOR [LOC_L],
	CONSTRAINT [DF_U_LOC_GE_LOC_P] DEFAULT (0) FOR [LOC_P]
go

UPDATE U_LOC_GE SET LOC_H = 0
UPDATE U_LOC_GE SET LOC_L = 0
UPDATE U_LOC_GE SET LOC_P = 0
