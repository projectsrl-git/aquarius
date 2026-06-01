if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FLOW_MENU]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FLOW_MENU]
GO
 
CREATE TABLE [dbo].[FLOW_MENU] (
	[id_unique]   uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[ID_MENU]     [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
	[ID_OPZIONE]  [varchar] (3) COLLATE Latin1_General_CI_AS NULL,
	[DESCRIZIONE] [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
	[ICONA]       [varchar] (50) COLLATE Latin1_General_CI_AS NULL,
	[COMANDO]     [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[ID_PROCEDURA][varchar] (10) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FLOW_MENU] WITH NOCHECK ADD 
	CONSTRAINT [PK_FLOW_MENU] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FLOW_MENU] WITH NOCHECK ADD 
	CONSTRAINT [DF_FLOW_MENU_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_FLOW_MENU_ID_OPZIONE]  DEFAULT ('') FOR [ID_OPZIONE],
	CONSTRAINT [DF_FLOW_MENU_DESCRIZIONE]  DEFAULT ('') FOR [DESCRIZIONE], 
	CONSTRAINT [DF_FLOW_MENU_ICONA]  DEFAULT ('') FOR [ICONA], 
	CONSTRAINT [DF_FLOW_MENU_COMANDO]  DEFAULT ('') FOR [COMANDO],    
	CONSTRAINT [DF_FLOW_MENU_ID_MENU]  DEFAULT ('') FOR [ID_MENU]
GO                               