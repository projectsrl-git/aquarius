ALTER TABLE [dbo].[U_MAG_GG] ADD 
	 MAG_NUMPED numeric(8) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_NUMPED] DEFAULT (0) FOR [MAG_NUMPED]
go

UPDATE U_MAG_GG SET MAG_NUMPED = 0


ALTER TABLE [dbo].[U_MAG_CP] ADD 
	 MAG_NUMPED numeric(8) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_CP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_CP_MAG_NUMPED] DEFAULT (0) FOR [MAG_NUMPED]
go

UPDATE U_MAG_CP SET MAG_NUMPED = 0

