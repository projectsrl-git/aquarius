if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_XLS_AN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_XLS_AN]
GO
 
CREATE TABLE [dbo].[U_XLS_AN] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[SOCIETA] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[CODICE] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[DESCRI] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[CONTO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[DESCCON] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[ORDINE] [numeric] (10,0) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_XLS_AN] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_XLS_AN] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_XLS_AN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_XLS_AN_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_XLS_AN_SOCIETA] DEFAULT ('') FOR [SOCIETA],
	CONSTRAINT [DF_U_XLS_AN_CODICE] DEFAULT ('') FOR [CODICE],
	CONSTRAINT [DF_U_XLS_AN_DESCRI] DEFAULT ('') FOR [DESCRI],
	CONSTRAINT [DF_U_XLS_AN_CONTO] DEFAULT ('') FOR [CONTO],
	CONSTRAINT [DF_U_XLS_AN_DESCCON] DEFAULT ('') FOR [DESCCON],
	CONSTRAINT [DF_U_XLS_AN_ORDINE] DEFAULT (0) FOR [ORDINE]
GO

