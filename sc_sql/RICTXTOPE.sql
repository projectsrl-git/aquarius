if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RICTXTOPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[RICTXTOPE]
GO

CREATE TABLE [dbo].[RICTXTOPE] (
	[id_unique] uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[CODRIC] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_RICTXTOPE_CODRIC] DEFAULT (''),
	[NOMERIC] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_RICTXTOPE_NOMERIC] DEFAULT (''),
	[CODOPE] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_RICTXTOPE_CODOPE] DEFAULT (''),
	[PREVTXT] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_RICTXTOPE_PREVTXT] DEFAULT (''),
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RICTXTOPE] WITH NOCHECK ADD 
	CONSTRAINT [PK_RICTXTOPE] PRIMARY KEY CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
