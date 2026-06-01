if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[inventario]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[inventario]
GO

CREATE TABLE [inventario] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_inventario_id_unique] DEFAULT (newid()),
	[ART_BARCOD] [varchar] (20) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_inventario_ART_BARCOD] DEFAULT (''),
	[ART_CODPRI] [varchar] (16) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_inventario_ART_CODPRI] DEFAULT (''),
	[ART_DESCR] [varchar] (40) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_inventario_ART_DESCR] DEFAULT (''),
	[ART_MAGA] [varchar] (6) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_inventario_ART_MAGA] DEFAULT (''),
	[ART_QTAINV] [numeric](10, 2) NULL CONSTRAINT [DF_inventario_ART_QTAINV] DEFAULT (0),
	[ART_DTCARI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_inventario_ART_DTCARI] DEFAULT (''),
	[ART_ORACAR] [varchar] (8) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_inventario_ART_ORACAR] DEFAULT (''),
	CONSTRAINT [PK_inventario] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO


