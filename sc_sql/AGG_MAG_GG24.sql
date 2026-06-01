ALTER TABLE [dbo].[U_MAG_GG] ADD 
	 MAG_QTACON numeric(10,2) NULL,
	 MAG_SERIE varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_QTACON] DEFAULT (0) FOR [MAG_QTACON],
	CONSTRAINT [DF_U_MAG_GG_MAG_SERIE] DEFAULT ('') FOR [MAG_SERIE]
go
UPDATE U_MAG_GG SET MAG_QTACON = 0
UPDATE U_MAG_GG SET MAG_SERIE = SPACE(03)



ALTER TABLE [dbo].[U_MAG_CP] ADD 
	 MAG_QTACON numeric(10,2) NULL,
	 MAG_SERIE varchar(3) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_CP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_CP_MAG_QTACON] DEFAULT (0) FOR [MAG_QTACON],
	CONSTRAINT [DF_U_MAG_CP_MAG_SERIE] DEFAULT ('') FOR [MAG_SERIE]
go
UPDATE U_MAG_CP SET MAG_QTACON = 0
UPDATE U_MAG_CP SET MAG_SERIE = SPACE(03)
