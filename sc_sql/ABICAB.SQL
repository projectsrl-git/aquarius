if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[ABICAB]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[ABICAB]
GO
 
CREATE TABLE [dbo].[ABICAB] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CODICE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[DESCRIZION] [varchar] (120) COLLATE Latin1_General_CI_AS NULL ,
	[INDIRIZZO] [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[LOCALITA] [varchar] (33) COLLATE Latin1_General_CI_AS NULL ,
	[CAP] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[PROV] [varchar] (2) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[ABICAB] WITH NOCHECK ADD 
	CONSTRAINT [PK_ABICAB] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[ABICAB] WITH NOCHECK ADD 
	CONSTRAINT [DF_ABICAB_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_ABICAB_CODICE] DEFAULT ('') FOR [CODICE],
	CONSTRAINT [DF_ABICAB_DESCRIZION] DEFAULT ('') FOR [DESCRIZION],
	CONSTRAINT [DF_ABICAB_INDIRIZZO] DEFAULT ('') FOR [INDIRIZZO],
	CONSTRAINT [DF_ABICAB_LOCALITA] DEFAULT ('') FOR [LOCALITA],
	CONSTRAINT [DF_ABICAB_CAP] DEFAULT ('') FOR [CAP],
	CONSTRAINT [DF_ABICAB_PROV] DEFAULT ('') FOR [PROV]
GO

