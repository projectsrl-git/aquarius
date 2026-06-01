if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_CON_PE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_CON_PE]
GO
 
CREATE TABLE [dbo].[U_CON_PE] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CON_CODICE] [varchar] (7) COLLATE Latin1_General_CI_AS NULL ,
	[CON_DESCRI] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[CON_SIGLA] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[CON_TIPCON] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[CON_DESCON] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[CON_PERCEN] [numeric] (6,2) NULL ,
	[CON_COMLOR] [numeric] (10,2) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_CON_PE] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_CON_PE] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_CON_PE] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CON_PE_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_CON_PE_CON_CODICE] DEFAULT ('') FOR [CON_CODICE],
	CONSTRAINT [DF_U_CON_PE_CON_DESCRI] DEFAULT ('') FOR [CON_DESCRI],
	CONSTRAINT [DF_U_CON_PE_CON_SIGLA] DEFAULT ('') FOR [CON_SIGLA],
	CONSTRAINT [DF_U_CON_PE_CON_TIPCON] DEFAULT ('') FOR [CON_TIPCON],
	CONSTRAINT [DF_U_CON_PE_CON_DESCON] DEFAULT ('') FOR [CON_DESCON],
	CONSTRAINT [DF_U_CON_PE_CON_PERCEN] DEFAULT (0) FOR [CON_PERCEN],
	CONSTRAINT [DF_U_CON_PE_CON_COMLOR] DEFAULT (0) FOR [CON_COMLOR]
GO

