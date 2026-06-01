
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[USER_MENU]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[USER_MENU]
GO

CREATE TABLE [dbo].[USER_MENU] (
	[ID_UNIQUE]  uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[CODOPE] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT (''),
	[MENU] [varchar] (50) COLLATE Latin1_General_CI_AS NULL DEFAULT (''),
	[LABEL] [varchar] (50) COLLATE Latin1_General_CI_AS NULL DEFAULT (''),
	[CMDBCKCOL] [numeric] (10,0) NOT NULL DEFAULT (0),
	[HIDDEN] [BIT] NOT NULL DEFAULT (0),
	[CMDLEFT] [numeric] (10,0) NOT NULL DEFAULT (0),
	[CMDTOP] [numeric] (10,0) NOT NULL DEFAULT (0)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[USER_MENU] WITH NOCHECK ADD 
	CONSTRAINT [PK_USER_MENU] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

