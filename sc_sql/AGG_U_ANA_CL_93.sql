
ALTER TABLE [dbo].[U_ANA_CL] ADD 
	CLI_NOCLDOG BIT NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ANA_CL] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ANA_CL_CLI_NOCLDOG] DEFAULT (0) FOR [CLI_NOCLDOG]
go

UPDATE U_ANA_CL SET CLI_NOCLDOG = 0

