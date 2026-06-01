
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROD_PIANIF_SPALMA_LEGORD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PROD_PIANIF_SPALMA_LEGORD]
GO
 
CREATE TABLE [dbo].[PROD_PIANIF_SPALMA_LEGORD] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[IDPIANIF] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[AGGANC] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[NUMORD] [varchar] (6) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DATORD] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[ORDSYS] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODCLI] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[RAGSOC] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DESART] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[SPESSO] numeric(5,0) NOT NULL DEFAULT 0,
	[ALTEZZ] numeric(6,0) NOT NULL DEFAULT 0,
	[LUNGHE] numeric(7,0) NOT NULL DEFAULT 0,
	[NUMBOB] numeric(10,0) NOT NULL DEFAULT 0,
	[UM] varchar(3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[QTA] numeric(19,4) NOT NULL DEFAULT 0,
	[DATCON] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ''
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PROD_PIANIF_SPALMA_LEGORD] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROD_PIANIF_SPALMA_LEGORD] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
