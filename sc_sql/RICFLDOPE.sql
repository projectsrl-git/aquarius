if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RICFLDOPE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[RICFLDOPE]
GO

CREATE TABLE [dbo].[RICFLDOPE] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL ,
	[CODRIC] [varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[NOMERIC] [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[CODOPE] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[DEFAFLD] [numeric] (3,0) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RICFLDOPE] WITH NOCHECK ADD 
	CONSTRAINT [PK_RICFLDOPE] PRIMARY KEY CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RICFLDOPE] WITH NOCHECK ADD 
	CONSTRAINT [DF_RICFLDOPE_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_RICFLDOPE_CODRIC] DEFAULT ('') FOR [CODRIC],
	CONSTRAINT [DF_RICFLDOPE_NOMERIC] DEFAULT ('') FOR [NOMERIC],
	CONSTRAINT [DF_RICFLDOPE_CODOPE] DEFAULT ('') FOR [CODOPE],
	CONSTRAINT [DF_RICFLDOPE_DEFAFLD] DEFAULT (0) FOR [DEFAFLD]
GO
