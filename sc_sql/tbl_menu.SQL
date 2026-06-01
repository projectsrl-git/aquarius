if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[tbl_menu]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[tbl_menu]
GO

CREATE TABLE [dbo].[tbl_menu] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[ordine] [numeric](18, 0) NOT NULL ,
	[menu] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL ,
	[label] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[comando] [varchar] (200) COLLATE Latin1_General_CI_AS NULL ,
	[descrizion] [text] COLLATE Latin1_General_CI_AS NULL ,
	[utenti] [text] COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[tbl_menu] WITH NOCHECK ADD 
	CONSTRAINT [PK_tbl_menu] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[tbl_menu] WITH NOCHECK ADD 
	CONSTRAINT [DF_tbl_menu_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_tbl_menu_ordine] DEFAULT (0) FOR [ordine],
	CONSTRAINT [DF_tbl_menu_menu] DEFAULT ('') FOR [menu],
	CONSTRAINT [DF_tbl_menu_label] DEFAULT ('') FOR [label],
	CONSTRAINT [DF_tbl_menu_comando] DEFAULT ('') FOR [comando],
	CONSTRAINT [DF_tbl_menu_descrizion] DEFAULT ('') FOR [descrizion],
	CONSTRAINT [DF_tbl_menu_utenti] DEFAULT ('') FOR [utenti],
	CONSTRAINT [IX_tbl_menu] UNIQUE  NONCLUSTERED 
	(
		[ordine],
		[menu]
	)  ON [PRIMARY] 
GO

