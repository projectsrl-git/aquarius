if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_art_ko]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_art_ko]
GO


CREATE TABLE [u_art_ko] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_u_art_ko_id_unique] DEFAULT (newid()),
	[ART_BARCOD] [varchar] (20) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_u_art_ko_ART_BARCOD] DEFAULT (''),
	[ART_CODPRI] [varchar] (16) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_u_art_ko_ART_CODPRI] DEFAULT (''),
	[ART_DESCR] [varchar] (40) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_u_art_ko_ART_DESCR] DEFAULT (''),
	[ART_MAGA] [varchar] (6) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_u_art_ko_ART_MAGA] DEFAULT (''),
	[ART_QTAINV] [numeric](10, 2) NULL CONSTRAINT [DF_u_art_ko_ART_QTAINV] DEFAULT (0),
	[ART_DATA] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_u_art_ko_ART_DATA] DEFAULT (''),
	[ART_ORA] [varchar] (8) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_u_art_ko_ART_ORA] DEFAULT (''),
	[ART_ANAG] [bit] NULL CONSTRAINT [DF_u_art_ko_ART_ANAG] DEFAULT (0),
	[ART_MAGAZ] [bit] NULL CONSTRAINT [DF_u_art_ko_ART_MAGAZ] DEFAULT (0),
	[ART_CONSOL] [bit] NULL CONSTRAINT [DF_u_art_ko_ART_CONSOL] DEFAULT (0),
	[art_dtcari] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_u_art_ko_art_dtcari] DEFAULT (''),
	[ART_ORACAR] [varchar] (8) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_u_art_ko_ART_ORACAR] DEFAULT (''),
	CONSTRAINT [PK_u_art_ko] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
) ON [PRIMARY]
GO


