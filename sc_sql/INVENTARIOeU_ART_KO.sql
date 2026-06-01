if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_art_ko]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_art_ko]
GO

CREATE TABLE [dbo].[u_art_ko] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[ART_BARCOD] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[ART_CODPRI] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[ART_DESCR] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[ART_MAGA] [varchar] (6) COLLATE Latin1_General_CI_AS NULL ,
	[ART_QTAINV] [numeric](10, 2) NULL
) ON [PRIMARY] 
GO


ALTER TABLE [dbo].[u_art_ko] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_art_ko_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_art_ko_ART_BARCOD] DEFAULT ('') FOR [ART_BARCOD],
	CONSTRAINT [DF_u_art_ko_ART_CODPRI] DEFAULT ('') FOR [ART_CODPRI],
	CONSTRAINT [DF_u_art_ko_ART_DESCR] DEFAULT ('') FOR [ART_DESCR],
	CONSTRAINT [DF_u_art_ko_ART_MAGA] DEFAULT ('') FOR [ART_MAGA],
	CONSTRAINT [DF_u_art_ko_ART_QTAINV] DEFAULT ('') FOR [ART_QTAINV],	
	CONSTRAINT [PK_u_art_ko] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO




if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[inventario]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[inventario]
GO

CREATE TABLE [dbo].[inventario] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[ART_BARCOD] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[ART_CODPRI] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[ART_DESCR] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[ART_MAGA] [varchar] (6) COLLATE Latin1_General_CI_AS NULL ,
	[ART_QTAINV] [numeric](10, 2) NULL
) ON [PRIMARY] 
GO


ALTER TABLE [dbo].[inventario] WITH NOCHECK ADD 
	CONSTRAINT [DF_inventario_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_inventario_ART_BARCOD] DEFAULT ('') FOR [ART_BARCOD],
	CONSTRAINT [DF_inventario_ART_CODPRI] DEFAULT ('') FOR [ART_CODPRI],
	CONSTRAINT [DF_inventario_ART_DESCR] DEFAULT ('') FOR [ART_DESCR],
	CONSTRAINT [DF_inventario_ART_MAGA] DEFAULT ('') FOR [ART_MAGA],
	CONSTRAINT [DF_inventario_ART_QTAINV] DEFAULT ('') FOR [ART_QTAINV],	
	CONSTRAINT [PK_inventario] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO