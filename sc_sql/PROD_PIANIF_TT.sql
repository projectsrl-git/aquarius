
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROD_PIANIF]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PROD_PIANIF]
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROD_PIANIF_TT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PROD_PIANIF_TT]
GO


CREATE TABLE [dbo].[PROD_PIANIF_TT] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[IDPIANIF] varchar (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[NUMERO] varchar (6) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DATA] varchar (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DESCRI] varchar (200) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[NOTE] text COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[OPZPERIOD] numeric(1,0) NOT NULL DEFAULT 0,
	[NPERIODS] numeric(2,0) NOT NULL DEFAULT 0,
	[PERDA] varchar (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[PERAL] varchar (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DTULTMOD] varchar (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[MAGAZDISP] text COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[OPZDOC] bit NOT NULL DEFAULT 0,
	[DSRCDA] varchar (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DSRCAL] varchar (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[OPZTIPDOC] numeric(1,0) NOT NULL DEFAULT 0,
	[OPZDATORD] numeric(1,0) NOT NULL DEFAULT 0,
	[OPZTIPORD] numeric(1,0) NOT NULL DEFAULT 0,
	[OPZSCM] bit NOT NULL DEFAULT 0,
	[OPZOCR] bit NOT NULL DEFAULT 0,
	[OPZPRG] bit NOT NULL DEFAULT 0,
	[IMPORTXLS] bit NOT NULL DEFAULT 0,
	[FILEXLS] varchar (254) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DPRGDA] varchar (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DPRGAL] varchar (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CURRENTPIANIF] bit NOT NULL DEFAULT 0,
	[FLGCONF] bit NOT NULL DEFAULT 0
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PROD_PIANIF_TT] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROD_PIANIF_TT] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
