if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CATEGORIE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CATEGORIE]
GO
 
CREATE TABLE [dbo].[CATEGORIE] (
	[id_unique] uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CATEGORIA] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[CATEGORIA_SUP] [varchar] (20) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CATEGORIE] WITH NOCHECK ADD 
	CONSTRAINT [PK_CATEGORIE] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CATEGORIE] WITH NOCHECK ADD 
	CONSTRAINT [DF_CATEGORIE_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_CATEGORIE_CATEGORIA] DEFAULT ('') FOR [CATEGORIA],
	CONSTRAINT [DF_CATEGORIE_CATEGORIA_SUP] DEFAULT ('') FOR [CATEGORIA_SUP]
GO

