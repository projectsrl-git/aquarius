/* 
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_UNIQUE] DEFAULT ('') FOR [MOV_UNIQUE]
go
UPDATE U_MAG_MO SET MOV_UNIQUE = SPACE(10)

/* 
*/
ALTER TABLE [dbo].[U_MAG_CA] ADD 
	 MOV_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_CA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_CA_MOV_UNIQUE] DEFAULT ('') FOR [MOV_UNIQUE]
go
UPDATE U_MAG_CA SET MOV_UNIQUE = SPACE(10)

/* 
*/
ALTER TABLE [dbo].[U_MAG_GG] ADD 
	 MAG_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_UNIQUE] DEFAULT ('') FOR [MAG_UNIQUE]
go
UPDATE U_MAG_GG SET MAG_UNIQUE = SPACE(10)

/* 
*/
ALTER TABLE [dbo].[U_MAG_DA] ADD 
	 MAG_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_DA_MAG_UNIQUE] DEFAULT ('') FOR [MAG_UNIQUE]
go
UPDATE U_MAG_DA SET MAG_UNIQUE = SPACE(10)

/* 
*/
ALTER TABLE [dbo].[U_MAG_AN] ADD 
	 MAG_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_AN_MAG_UNIQUE] DEFAULT ('') FOR [MAG_UNIQUE]
go
UPDATE U_MAG_AN SET MAG_UNIQUE = SPACE(10)

/* 
*/
ALTER TABLE [dbo].[U_MAG_PR] ADD 
	 MAG_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_PR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_PR_MAG_UNIQUE] DEFAULT ('') FOR [MAG_UNIQUE]
go
UPDATE U_MAG_PR SET MAG_UNIQUE = SPACE(10)

/* 
*/
ALTER TABLE [dbo].[U_ALT_DA] ADD 
	 ALT_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_ALT_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ALT_DA_ALT_UNIQUE] DEFAULT ('') FOR [ALT_UNIQUE]
go
UPDATE U_ALT_DA SET ALT_UNIQUE = SPACE(10)
