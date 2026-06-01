
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[LOG_EMAIL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[LOG_EMAIL]
GO
 
CREATE TABLE [dbo].[LOG_EMAIL] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[TIPDOC] [varchar] (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[NUMDOC] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DATDOC] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODCLI] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[RAGSOC] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[IND_MITTENTE] [TEXT] NOT NULL DEFAULT '',
	[IND_EMAIL] [TEXT] NOT NULL DEFAULT '',
	[IND_EMAILCC] [TEXT] NOT NULL DEFAULT '',
	[IND_EMAILCN] [TEXT] NOT NULL DEFAULT '',
	[OGGETTO] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[MESSAGGIO] [TEXT] NOT NULL DEFAULT '',
	[ALLEGATO] [varchar] (250) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[SENT] [BIT] NOT NULL DEFAULT 0,
	[DATLOG] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[ORALOG] [varchar] (8) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODOPE] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[NOMOPE] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ''
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[LOG_EMAIL] WITH NOCHECK ADD 
	CONSTRAINT [PK_LOG_EMAIL] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
