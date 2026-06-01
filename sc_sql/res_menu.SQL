if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[res_menu]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[res_menu]
GO
 
CREATE TABLE [dbo].[res_menu] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[RES_DESCRI] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[RES_VAR] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[RES_USER] [text] COLLATE Latin1_General_CI_AS NULL ,
	[RES_PROG] [numeric] (5,0) NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[res_menu] WITH NOCHECK ADD 
	CONSTRAINT [PK_res_menu] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[res_menu] WITH NOCHECK ADD 
	CONSTRAINT [DF_res_menu_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_res_menu_RES_DESCRI] DEFAULT ('') FOR [RES_DESCRI],
	CONSTRAINT [DF_res_menu_RES_VAR] DEFAULT ('') FOR [RES_VAR],
	CONSTRAINT [DF_res_menu_RES_USER] DEFAULT ('') FOR [RES_USER],
	CONSTRAINT [DF_res_menu_RES_PROG] DEFAULT (0) FOR [RES_PROG]
GO

