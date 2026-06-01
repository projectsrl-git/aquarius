
if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PROD_PIANIF_SPALMA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PROD_PIANIF_SPALMA]
GO
 
CREATE TABLE [dbo].[PROD_PIANIF_SPALMA] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL DEFAULT (newid()),
	[IDPIANIF] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[MESE] [varchar] (7) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DESART] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[SUPPORTO] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[ALTSUPP] numeric(6,0) NOT NULL DEFAULT 0,
	[LUNSUPP] numeric(7,0) NOT NULL DEFAULT 0,
	[NUMBOBSUPP] numeric(10,0) NOT NULL DEFAULT 0,
	[UM] varchar(3) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[QTASUPP] numeric(19,4) NOT NULL DEFAULT 0,
	[QTAORDINI] numeric(19,4) NOT NULL DEFAULT 0,
	[CODFOR] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DESFOR] [varchar] (100) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[SPESUPP] numeric(5,0) NOT NULL DEFAULT 0,
	[CILINDRO] numeric(5,0) NOT NULL DEFAULT 0,
	[TIPADE] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[QTATOTADE] numeric(19,4) NOT NULL DEFAULT 0,
	[UMIDI] numeric(5,0) NOT NULL DEFAULT 0,
	[NOTE_LAV] TEXT NOT NULL DEFAULT '',
	[INPROD] BIT NOT NULL DEFAULT 0,
	[COMPLETATO] BIT NOT NULL DEFAULT 0,
	[NASCOSTO] BIT NOT NULL DEFAULT 0,
	[CODOPE_REG] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[NOMOPE_REG] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DATA_REG] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[ORA_REG] [varchar] (8) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[CODOPE_MOD] [varchar] (20) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[NOMOPE_MOD] [varchar] (50) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[DATA_MOD] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT '',
	[ORA_MOD] [varchar] (8) COLLATE Latin1_General_CI_AS NOT NULL DEFAULT ''
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PROD_PIANIF_SPALMA] WITH NOCHECK ADD 
	CONSTRAINT [PK_PROD_PIANIF_SPALMA] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
