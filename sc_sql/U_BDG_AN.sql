if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_BDG_AN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_BDG_AN]
GO

CREATE TABLE [dbo].[U_BDG_AN] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[BDG_ANNO] [varchar] (4) COLLATE Latin1_General_CI_AS NULL ,
	[BDG_CODCLI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[BDG_RAGSOC] [varchar] (80) COLLATE Latin1_General_CI_AS NULL ,
	[BDG_CODNAZ] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[BDG_DESNAZ] [varchar] (80) COLLATE Latin1_General_CI_AS NULL ,
	[BDG_UM] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[BDG_TIPART] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[BDG_QTATOT] [numeric](17, 2) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_BDG_AN] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_BDG_AN] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_BDG_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BDG_AN_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_BDG_AN_BDG_ANNO] DEFAULT ('') FOR [BDG_ANNO],
	CONSTRAINT [DF_U_BDG_AN_BDG_CODCLI] DEFAULT ('') FOR [BDG_CODCLI],
	CONSTRAINT [DF_U_BDG_AN_BDG_RAGSOC] DEFAULT ('') FOR [BDG_RAGSOC],
	CONSTRAINT [DF_U_BDG_AN_BDG_CODNAZ] DEFAULT ('') FOR [BDG_CODNAZ],
	CONSTRAINT [DF_U_BDG_AN_BDG_DESNAZ] DEFAULT ('') FOR [BDG_DESNAZ],
	CONSTRAINT [DF_U_BDG_AN_BDG_UM] DEFAULT ('') FOR [BDG_UM],
	CONSTRAINT [DF_U_BDG_AN_BDG_TIPART] DEFAULT ('') FOR [BDG_TIPART],
	CONSTRAINT [DF_U_BDG_AN_BDG_QTATOT] DEFAULT (0) FOR [BDG_QTATOT]
GO

