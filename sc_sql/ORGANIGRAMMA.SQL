if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ORGANIGRAMMA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[ORGANIGRAMMA]
GO
 
CREATE TABLE [dbo].[ORGANIGRAMMA] (
	[id_unique] uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[RUOLO] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[RUOLO_SUP] [varchar] (20) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ORGANIGRAMMA] WITH NOCHECK ADD 
	CONSTRAINT [PK_ORGANIGRAMMA] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ORGANIGRAMMA] WITH NOCHECK ADD 
	CONSTRAINT [DF_ORGANIGRAMMA_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_ORGANIGRAMMA_RUOLO] DEFAULT ('') FOR [RUOLO],
	CONSTRAINT [DF_ORGANIGRAMMA_RUOLO_SUP] DEFAULT ('') FOR [RUOLO_SUP]
GO

