/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_AN
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_AN] ADD 
	 MAG_FILA_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_PIAN_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_UBIC_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_FILA_N [numeric](5) NULL,
	 MAG_PIAN_N [numeric](5) NULL,
	 MAG_UBIC_N [numeric](5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_AN_MAG_FILA_X] DEFAULT ('') FOR [MAG_FILA_X],
	CONSTRAINT [DF_U_MAG_AN_MAG_PIAN_X] DEFAULT ('') FOR [MAG_PIAN_X],
	CONSTRAINT [DF_U_MAG_AN_MAG_UBIC_X] DEFAULT ('') FOR [MAG_UBIC_X],
	CONSTRAINT [DF_U_MAG_AN_MAG_FILA_N] DEFAULT (0) FOR [MAG_FILA_N],
	CONSTRAINT [DF_U_MAG_AN_MAG_PIAN_N] DEFAULT (0) FOR [MAG_PIAN_N],
	CONSTRAINT [DF_U_MAG_AN_MAG_UBIC_N] DEFAULT (0) FOR [MAG_UBIC_N]
go

UPDATE U_MAG_AN SET MAG_FILA_X = SPACE(05)
UPDATE U_MAG_AN SET MAG_PIAN_X = SPACE(05)
UPDATE U_MAG_AN SET MAG_UBIC_X = SPACE(05)
UPDATE U_MAG_AN SET MAG_FILA_N = 0
UPDATE U_MAG_AN SET MAG_PIAN_N = 0
UPDATE U_MAG_AN SET MAG_UBIC_N = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_GG
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_GG] ADD 
	 MAG_FILA_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_PIAN_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_UBIC_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_FILA_N [numeric](5) NULL,
	 MAG_PIAN_N [numeric](5) NULL,
	 MAG_UBIC_N [numeric](5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GG_MAG_FILA_X] DEFAULT ('') FOR [MAG_FILA_X],
	CONSTRAINT [DF_U_MAG_GG_MAG_PIAN_X] DEFAULT ('') FOR [MAG_PIAN_X],
	CONSTRAINT [DF_U_MAG_GG_MAG_UBIC_X] DEFAULT ('') FOR [MAG_UBIC_X],
	CONSTRAINT [DF_U_MAG_GG_MAG_FILA_N] DEFAULT (0) FOR [MAG_FILA_N],
	CONSTRAINT [DF_U_MAG_GG_MAG_PIAN_N] DEFAULT (0) FOR [MAG_PIAN_N],
	CONSTRAINT [DF_U_MAG_GG_MAG_UBIC_N] DEFAULT (0) FOR [MAG_UBIC_N]
go

UPDATE U_MAG_GG SET MAG_FILA_X = SPACE(05)
UPDATE U_MAG_GG SET MAG_PIAN_X = SPACE(05)
UPDATE U_MAG_GG SET MAG_UBIC_X = SPACE(05)
UPDATE U_MAG_GG SET MAG_FILA_N = 0
UPDATE U_MAG_GG SET MAG_PIAN_N = 0
UPDATE U_MAG_GG SET MAG_UBIC_N = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_GS
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_GS] ADD 
	 MAG_FILA_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_PIAN_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_UBIC_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_FILA_N [numeric](5) NULL,
	 MAG_PIAN_N [numeric](5) NULL,
	 MAG_UBIC_N [numeric](5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_GS] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_GS_MAG_FILA_X] DEFAULT ('') FOR [MAG_FILA_X],
	CONSTRAINT [DF_U_MAG_GS_MAG_PIAN_X] DEFAULT ('') FOR [MAG_PIAN_X],
	CONSTRAINT [DF_U_MAG_GS_MAG_UBIC_X] DEFAULT ('') FOR [MAG_UBIC_X],
	CONSTRAINT [DF_U_MAG_GS_MAG_FILA_N] DEFAULT (0) FOR [MAG_FILA_N],
	CONSTRAINT [DF_U_MAG_GS_MAG_PIAN_N] DEFAULT (0) FOR [MAG_PIAN_N],
	CONSTRAINT [DF_U_MAG_GS_MAG_UBIC_N] DEFAULT (0) FOR [MAG_UBIC_N]
go

UPDATE U_MAG_GS SET MAG_FILA_X = SPACE(05)
UPDATE U_MAG_GS SET MAG_PIAN_X = SPACE(05)
UPDATE U_MAG_GS SET MAG_UBIC_X = SPACE(05)
UPDATE U_MAG_GS SET MAG_FILA_N = 0
UPDATE U_MAG_GS SET MAG_PIAN_N = 0
UPDATE U_MAG_GS SET MAG_UBIC_N = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_DA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_DA] ADD 
	 MAG_FILA_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_PIAN_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_UBIC_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_FILA_N [numeric](5) NULL,
	 MAG_PIAN_N [numeric](5) NULL,
	 MAG_UBIC_N [numeric](5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_DA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_DA_MAG_FILA_X] DEFAULT ('') FOR [MAG_FILA_X],
	CONSTRAINT [DF_U_MAG_DA_MAG_PIAN_X] DEFAULT ('') FOR [MAG_PIAN_X],
	CONSTRAINT [DF_U_MAG_DA_MAG_UBIC_X] DEFAULT ('') FOR [MAG_UBIC_X],
	CONSTRAINT [DF_U_MAG_DA_MAG_FILA_N] DEFAULT (0) FOR [MAG_FILA_N],
	CONSTRAINT [DF_U_MAG_DA_MAG_PIAN_N] DEFAULT (0) FOR [MAG_PIAN_N],
	CONSTRAINT [DF_U_MAG_DA_MAG_UBIC_N] DEFAULT (0) FOR [MAG_UBIC_N]
go

UPDATE U_MAG_DA SET MAG_FILA_X = SPACE(05)
UPDATE U_MAG_DA SET MAG_PIAN_X = SPACE(05)
UPDATE U_MAG_DA SET MAG_UBIC_X = SPACE(05)
UPDATE U_MAG_DA SET MAG_FILA_N = 0
UPDATE U_MAG_DA SET MAG_PIAN_N = 0
UPDATE U_MAG_DA SET MAG_UBIC_N = 0

/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_SA
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_SA] ADD 
	 MAG_FILA_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_PIAN_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_UBIC_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_FILA_N [numeric](5) NULL,
	 MAG_PIAN_N [numeric](5) NULL,
	 MAG_UBIC_N [numeric](5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_SA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_SA_MAG_FILA_X] DEFAULT ('') FOR [MAG_FILA_X],
	CONSTRAINT [DF_U_MAG_SA_MAG_PIAN_X] DEFAULT ('') FOR [MAG_PIAN_X],
	CONSTRAINT [DF_U_MAG_SA_MAG_UBIC_X] DEFAULT ('') FOR [MAG_UBIC_X],
	CONSTRAINT [DF_U_MAG_SA_MAG_FILA_N] DEFAULT (0) FOR [MAG_FILA_N],
	CONSTRAINT [DF_U_MAG_SA_MAG_PIAN_N] DEFAULT (0) FOR [MAG_PIAN_N],
	CONSTRAINT [DF_U_MAG_SA_MAG_UBIC_N] DEFAULT (0) FOR [MAG_UBIC_N]
go

UPDATE U_MAG_SA SET MAG_FILA_X = SPACE(05)
UPDATE U_MAG_SA SET MAG_PIAN_X = SPACE(05)
UPDATE U_MAG_SA SET MAG_UBIC_X = SPACE(05)
UPDATE U_MAG_SA SET MAG_FILA_N = 0
UPDATE U_MAG_SA SET MAG_PIAN_N = 0
UPDATE U_MAG_SA SET MAG_UBIC_N = 0

/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_SS
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_SS] ADD 
	 MAG_FILA_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_PIAN_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_UBIC_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_FILA_N [numeric](5) NULL,
	 MAG_PIAN_N [numeric](5) NULL,
	 MAG_UBIC_N [numeric](5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_SS] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_SS_MAG_FILA_X] DEFAULT ('') FOR [MAG_FILA_X],
	CONSTRAINT [DF_U_MAG_SS_MAG_PIAN_X] DEFAULT ('') FOR [MAG_PIAN_X],
	CONSTRAINT [DF_U_MAG_SS_MAG_UBIC_X] DEFAULT ('') FOR [MAG_UBIC_X],
	CONSTRAINT [DF_U_MAG_SS_MAG_FILA_N] DEFAULT (0) FOR [MAG_FILA_N],
	CONSTRAINT [DF_U_MAG_SS_MAG_PIAN_N] DEFAULT (0) FOR [MAG_PIAN_N],
	CONSTRAINT [DF_U_MAG_SS_MAG_UBIC_N] DEFAULT (0) FOR [MAG_UBIC_N]
go

UPDATE U_MAG_SS SET MAG_FILA_X = SPACE(05)
UPDATE U_MAG_SS SET MAG_PIAN_X = SPACE(05)
UPDATE U_MAG_SS SET MAG_UBIC_X = SPACE(05)
UPDATE U_MAG_SS SET MAG_FILA_N = 0
UPDATE U_MAG_SS SET MAG_PIAN_N = 0
UPDATE U_MAG_SS SET MAG_UBIC_N = 0

/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_MO
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MO] ADD 
	 MOV_FILA_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MOV_PIAN_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MOV_UBIC_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MOV_FILA_N [numeric](5) NULL,
	 MOV_PIAN_N [numeric](5) NULL,
	 MOV_UBIC_N [numeric](5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MO_MOV_FILA_X] DEFAULT ('') FOR [MOV_FILA_X],
	CONSTRAINT [DF_U_MAG_MO_MOV_PIAN_X] DEFAULT ('') FOR [MOV_PIAN_X],
	CONSTRAINT [DF_U_MAG_MO_MOV_UBIC_X] DEFAULT ('') FOR [MOV_UBIC_X],
	CONSTRAINT [DF_U_MAG_MO_MOV_FILA_N] DEFAULT (0) FOR [MOV_FILA_N],
	CONSTRAINT [DF_U_MAG_MO_MOV_PIAN_N] DEFAULT (0) FOR [MOV_PIAN_N],
	CONSTRAINT [DF_U_MAG_MO_MOV_UBIC_N] DEFAULT (0) FOR [MOV_UBIC_N]
go

UPDATE U_MAG_MO SET MOV_FILA_X = SPACE(05)
UPDATE U_MAG_MO SET MOV_PIAN_X = SPACE(05)
UPDATE U_MAG_MO SET MOV_UBIC_X = SPACE(05)
UPDATE U_MAG_MO SET MOV_FILA_N = 0
UPDATE U_MAG_MO SET MOV_PIAN_N = 0
UPDATE U_MAG_MO SET MOV_UBIC_N = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_MAG_MS
**************************************************************
*/
ALTER TABLE [dbo].[U_MAG_MS] ADD 
	 MOV_FILA_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MOV_PIAN_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MOV_UBIC_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MOV_FILA_N [numeric](5) NULL,
	 MOV_PIAN_N [numeric](5) NULL,
	 MOV_UBIC_N [numeric](5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_MAG_MS] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_MAG_MS_MOV_FILA_X] DEFAULT ('') FOR [MOV_FILA_X],
	CONSTRAINT [DF_U_MAG_MS_MOV_PIAN_X] DEFAULT ('') FOR [MOV_PIAN_X],
	CONSTRAINT [DF_U_MAG_MS_MOV_UBIC_X] DEFAULT ('') FOR [MOV_UBIC_X],
	CONSTRAINT [DF_U_MAG_MS_MOV_FILA_N] DEFAULT (0) FOR [MOV_FILA_N],
	CONSTRAINT [DF_U_MAG_MS_MOV_PIAN_N] DEFAULT (0) FOR [MOV_PIAN_N],
	CONSTRAINT [DF_U_MAG_MS_MOV_UBIC_N] DEFAULT (0) FOR [MOV_UBIC_N]
go

UPDATE U_MAG_MS SET MOV_FILA_X = SPACE(05)
UPDATE U_MAG_MS SET MOV_PIAN_X = SPACE(05)
UPDATE U_MAG_MS SET MOV_UBIC_X = SPACE(05)
UPDATE U_MAG_MS SET MOV_FILA_N = 0
UPDATE U_MAG_MS SET MOV_PIAN_N = 0
UPDATE U_MAG_MS SET MOV_UBIC_N = 0


/* 
**************************************************************
GESTIONE LOCAZIONE PER LA TABELLA  ==>  U_INV_MA
**************************************************************
*/
ALTER TABLE [dbo].[U_INV_MA] ADD 
	 MAG_FILA_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_PIAN_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_UBIC_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 MAG_FILA_N [numeric](5) NULL,
	 MAG_PIAN_N [numeric](5) NULL,
	 MAG_UBIC_N [numeric](5) NULL,
	 INV_FILA_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 INV_PIAN_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 INV_UBIC_X varchar(5) COLLATE Latin1_General_CI_AS NULL,
	 INV_FILA_N [numeric](5) NULL,
	 INV_PIAN_N [numeric](5) NULL,
	 INV_UBIC_N [numeric](5) NULL
go
-- forzature di default (vedi script standard per valorizzare campi diversi da varchar)
ALTER TABLE [dbo].[U_INV_MA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_INV_MA_MAG_FILA_X] DEFAULT ('') FOR [MAG_FILA_X],
	CONSTRAINT [DF_U_INV_MA_MAG_PIAN_X] DEFAULT ('') FOR [MAG_PIAN_X],
	CONSTRAINT [DF_U_INV_MA_MAG_UBIC_X] DEFAULT ('') FOR [MAG_UBIC_X],
	CONSTRAINT [DF_U_INV_MA_MAG_FILA_N] DEFAULT (0) FOR [MAG_FILA_N],
	CONSTRAINT [DF_U_INV_MA_MAG_PIAN_N] DEFAULT (0) FOR [MAG_PIAN_N],
	CONSTRAINT [DF_U_INV_MA_MAG_UBIC_N] DEFAULT (0) FOR [MAG_UBIC_N],
	CONSTRAINT [DF_U_INV_MA_INV_FILA_X] DEFAULT ('') FOR [INV_FILA_X],
	CONSTRAINT [DF_U_INV_MA_INV_PIAN_X] DEFAULT ('') FOR [INV_PIAN_X],
	CONSTRAINT [DF_U_INV_MA_INV_UBIC_X] DEFAULT ('') FOR [INV_UBIC_X],
	CONSTRAINT [DF_U_INV_MA_INV_FILA_N] DEFAULT (0) FOR [INV_FILA_N],
	CONSTRAINT [DF_U_INV_MA_INV_PIAN_N] DEFAULT (0) FOR [INV_PIAN_N],
	CONSTRAINT [DF_U_INV_MA_INV_UBIC_N] DEFAULT (0) FOR [INV_UBIC_N]
go

UPDATE U_INV_MA SET MAG_FILA_X = SPACE(05)
UPDATE U_INV_MA SET MAG_PIAN_X = SPACE(05)
UPDATE U_INV_MA SET MAG_UBIC_X = SPACE(05)
UPDATE U_INV_MA SET MAG_FILA_N = 0
UPDATE U_INV_MA SET MAG_PIAN_N = 0
UPDATE U_INV_MA SET MAG_UBIC_N = 0
UPDATE U_INV_MA SET INV_FILA_X = SPACE(05)
UPDATE U_INV_MA SET INV_PIAN_X = SPACE(05)
UPDATE U_INV_MA SET INV_UBIC_X = SPACE(05)
UPDATE U_INV_MA SET INV_FILA_N = 0
UPDATE U_INV_MA SET INV_PIAN_N = 0
UPDATE U_INV_MA SET INV_UBIC_N = 0
