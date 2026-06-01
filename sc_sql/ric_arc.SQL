if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ric_arc]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ric_arc]
GO
 
CREATE TABLE [dbo].[ric_arc] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[SIRIC] [bit] NULL ,
	[PATH] [varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[SOCIETA] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[MANUT] [bit] NULL ,
	[ABIL] [text] COLLATE Latin1_General_CI_AS NULL ,
	[VENDUTO] [varchar] (50) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[ric_arc] WITH NOCHECK ADD 
	CONSTRAINT [PK_ric_arc] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ric_arc] WITH NOCHECK ADD 
	CONSTRAINT [DF_ric_arc_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_ric_arc_SIRIC] DEFAULT (0) FOR [SIRIC],
	CONSTRAINT [DF_ric_arc_PATH] DEFAULT ('') FOR [PATH],
	CONSTRAINT [DF_ric_arc_SOCIETA] DEFAULT ('') FOR [SOCIETA],
	CONSTRAINT [DF_ric_arc_MANUT] DEFAULT (0) FOR [MANUT],
	CONSTRAINT [DF_ric_arc_ABIL] DEFAULT ('') FOR [ABIL],
	CONSTRAINT [DF_ric_arc_VENDUTO] DEFAULT ('') FOR [VENDUTO]
GO

