if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_lis_al]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_lis_al]
GO
 
CREATE TABLE [dbo].[u_lis_al] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[LIS_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_CODCLI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_RAGSOC] [varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_DESART] [varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_DATLIS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_ALLIST] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_CLIART] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_ARTGRU] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_DEARCL] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_PREZZO] [numeric] (19,6) NULL ,
	[LIS_DEARC1] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_TRASME] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_SCONTO] [numeric] (18,3) NULL ,
	[LIS_DTCONT] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_KILIMP] [numeric] (8,0) NULL ,
	[LIS_PROVVI] [numeric] (10,3) NULL ,
	[LIS_SC1] [numeric] (7,2) NULL ,
	[LIS_SC2] [numeric] (7,2) NULL ,
	[LIS_SC3] [numeric] (7,2) NULL ,
	[SELEZIONE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_CODVAL] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_PUBBLI] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[LIS_FLGTRA] [bit] NULL ,
	[LIS_PRZSCO] [numeric] (19,6) NULL ,
	[LIS_QTA] [numeric] (12,2) NULL ,
	[LIS_ALTEDA] [numeric] (6,0) NULL ,
	[LIS_ALTEAL] [numeric] (6,0) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[u_lis_al] WITH NOCHECK ADD 
	CONSTRAINT [PK_u_lis_al] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[u_lis_al] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_lis_al_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_lis_al_LIS_CODSOC] DEFAULT ('') FOR [LIS_CODSOC],
	CONSTRAINT [DF_u_lis_al_LIS_CODCLI] DEFAULT ('') FOR [LIS_CODCLI],
	CONSTRAINT [DF_u_lis_al_LIS_RAGSOC] DEFAULT ('') FOR [LIS_RAGSOC],
	CONSTRAINT [DF_u_lis_al_LIS_CODART] DEFAULT ('') FOR [LIS_CODART],
	CONSTRAINT [DF_u_lis_al_LIS_DESART] DEFAULT ('') FOR [LIS_DESART],
	CONSTRAINT [DF_u_lis_al_LIS_DATLIS] DEFAULT ('') FOR [LIS_DATLIS],
	CONSTRAINT [DF_u_lis_al_LIS_ALLIST] DEFAULT ('') FOR [LIS_ALLIST],
	CONSTRAINT [DF_u_lis_al_LIS_CLIART] DEFAULT ('') FOR [LIS_CLIART],
	CONSTRAINT [DF_u_lis_al_LIS_ARTGRU] DEFAULT ('') FOR [LIS_ARTGRU],
	CONSTRAINT [DF_u_lis_al_LIS_DEARCL] DEFAULT ('') FOR [LIS_DEARCL],
	CONSTRAINT [DF_u_lis_al_LIS_PREZZO] DEFAULT (0) FOR [LIS_PREZZO],
	CONSTRAINT [DF_u_lis_al_LIS_DEARC1] DEFAULT ('') FOR [LIS_DEARC1],
	CONSTRAINT [DF_u_lis_al_LIS_TRASME] DEFAULT ('') FOR [LIS_TRASME],
	CONSTRAINT [DF_u_lis_al_LIS_SCONTO] DEFAULT (0) FOR [LIS_SCONTO],
	CONSTRAINT [DF_u_lis_al_LIS_DTCONT] DEFAULT ('') FOR [LIS_DTCONT],
	CONSTRAINT [DF_u_lis_al_LIS_KILIMP] DEFAULT (0) FOR [LIS_KILIMP],
	CONSTRAINT [DF_u_lis_al_LIS_PROVVI] DEFAULT (0) FOR [LIS_PROVVI],
	CONSTRAINT [DF_u_lis_al_LIS_SC1] DEFAULT (0) FOR [LIS_SC1],
	CONSTRAINT [DF_u_lis_al_LIS_SC2] DEFAULT (0) FOR [LIS_SC2],
	CONSTRAINT [DF_u_lis_al_LIS_SC3] DEFAULT (0) FOR [LIS_SC3],
	CONSTRAINT [DF_u_lis_al_SELEZIONE] DEFAULT ('') FOR [SELEZIONE],
	CONSTRAINT [DF_u_lis_al_LIS_CODVAL] DEFAULT ('') FOR [LIS_CODVAL],
	CONSTRAINT [DF_u_lis_al_LIS_PUBBLI] DEFAULT ('') FOR [LIS_PUBBLI],
	CONSTRAINT [DF_u_lis_al_LIS_FLGTRA] DEFAULT (0) FOR [LIS_FLGTRA],
	CONSTRAINT [DF_u_lis_al_LIS_PRZSCO] DEFAULT (0) FOR [LIS_PRZSCO],
	CONSTRAINT [DF_u_lis_al_LIS_QTA] DEFAULT (0) FOR [LIS_QTA],
	CONSTRAINT [DF_u_lis_al_LIS_ALTEDA] DEFAULT (0) FOR [LIS_ALTEDA],
	CONSTRAINT [DF_u_lis_al_LIS_ALTEAL] DEFAULT (0) FOR [LIS_ALTEAL]
GO

