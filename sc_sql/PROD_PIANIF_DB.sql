
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROD_PIANIF_DB]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PROD_PIANIF_DB]
GO
 
CREATE TABLE [dbo].[PROD_PIANIF_DB] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[IDPIANIF] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[TIPO] [varchar] (1) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[LIVELLO] numeric(3,0) NOT NULL DEFAULT 0,
	[CODGRU] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODSUP] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DESSUP] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DESART] [varchar] (200) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[UMMAGA] [varchar] (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[FASELA] [varchar] (3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[QTA] numeric(19,4) NOT NULL DEFAULT 0,
	[QTAT] numeric(19,4) NOT NULL DEFAULT 0,
	[SECIMP] numeric(12,0) NOT NULL DEFAULT 0,
	[LEADTMAX] numeric(4,0) NOT NULL DEFAULT 0,
	[LEADTMAXT] numeric(4,0) NOT NULL DEFAULT 0,
	[FITTIZ] bit NOT NULL DEFAULT 0,
	[G_FITTIZ] bit NOT NULL DEFAULT 0
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PROD_PIANIF_DB] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROD_PIANIF_DB] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

