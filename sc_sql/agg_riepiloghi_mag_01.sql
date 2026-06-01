
/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_RI] ADD 
	 MAG_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL,
	[MAG_FLGTRA] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_RI] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_RI_MAG_UNIQUE] DEFAULT ('') FOR [MAG_UNIQUE],
	CONSTRAINT [DF_U_MAG_RI_MAG_FLGTRA] DEFAULT (0) FOR [MAG_FLGTRA]
go

UPDATE U_MAG_RI SET MAG_FLGTRA = 0
UPDATE U_MAG_RI SET MAG_UNIQUE = '   '

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_AR] ADD 
	 MAG_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL,
	[MAG_FLGTRA] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_AR] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_AR_MAG_UNIQUE] DEFAULT ('') FOR [MAG_UNIQUE],
	CONSTRAINT [DF_U_MAG_AR_MAG_FLGTRA] DEFAULT (0) FOR [MAG_FLGTRA]
go

UPDATE U_MAG_AR SET MAG_FLGTRA = 0
UPDATE U_MAG_AR SET MAG_UNIQUE = '   '

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MA] ADD 
	 MAG_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL,
	[MAG_FLGTRA] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MA_MAG_UNIQUE] DEFAULT ('') FOR [MAG_UNIQUE],
	CONSTRAINT [DF_U_MAG_MA_MAG_FLGTRA] DEFAULT (0) FOR [MAG_FLGTRA]
go

UPDATE U_MAG_MA SET MAG_FLGTRA = 0
UPDATE U_MAG_MA SET MAG_UNIQUE = '   '

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MF] ADD 
	 MAG_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL,
	[MAG_FLGTRA] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MF] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MF_MAG_UNIQUE] DEFAULT ('') FOR [MAG_UNIQUE],
	CONSTRAINT [DF_U_MAG_MF_MAG_FLGTRA] DEFAULT (0) FOR [MAG_FLGTRA]
go

UPDATE U_MAG_MF SET MAG_FLGTRA = 0
UPDATE U_MAG_MF SET MAG_UNIQUE = '   '

/* 
**************************************************************
COME INSERIRE UN NUOVO CAMPO IN UNA TABELLA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_FO] ADD 
	 MAG_UNIQUE varchar(10) COLLATE Latin1_General_CI_AS NULL,
	[MAG_FLGTRA] [bit] NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_FO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_FO_MAG_UNIQUE] DEFAULT ('') FOR [MAG_UNIQUE],
	CONSTRAINT [DF_U_MAG_FO_MAG_FLGTRA] DEFAULT (0) FOR [MAG_FLGTRA]
go

UPDATE U_MAG_FO SET MAG_FLGTRA = 0
UPDATE U_MAG_FO SET MAG_UNIQUE = '   '