if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_ART_SP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_ART_SP]
GO

CREATE TABLE [dbo].[U_ART_SP] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL ,
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[CODSPE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CDARFO] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[DESFOR] [varchar] (200) COLLATE Latin1_General_CI_AS NULL ,
	[NOTEFO] [text] COLLATE Latin1_General_CI_AS NULL ,
	[NOTESP] [text] COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_ART_SP] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_ART_SP] PRIMARY KEY CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_ART_SP] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ART_SP_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_ART_SP_CODART] DEFAULT ('') FOR [CODART],
	CONSTRAINT [DF_U_ART_SP_CODSPE] DEFAULT ('') FOR [CODSPE],
	CONSTRAINT [DF_U_ART_SP_CDARFO] DEFAULT ('') FOR [CDARFO],
	CONSTRAINT [DF_U_ART_SP_DESFOR] DEFAULT ('') FOR [DESFOR],
	CONSTRAINT [DF_U_ART_SP_NOTEFO] DEFAULT ('') FOR [NOTEFO],
	CONSTRAINT [DF_U_ART_SP_NOTESP] DEFAULT ('') FOR [NOTESP]
GO
