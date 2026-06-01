if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TURNI_DD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[TURNI_DD]
GO

CREATE TABLE [dbo].[TURNI_DD] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[PJ_TURNI] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[TUR_CODOPE] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[TUR_DESOPE] [varchar] (25) COLLATE Latin1_General_CI_AS NULL ,
	[TUR_TIPLAV] [varchar] (08) COLLATE Latin1_General_CI_AS NULL ,
	[TUR_DESLAV] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TURNI_DD] WITH NOCHECK ADD 
	CONSTRAINT [PK_TURNI_DD] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TURNI_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_TURNI_DD_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_TURNI_DD_PJ_TURNI] DEFAULT ('') FOR [PJ_TURNI],
	CONSTRAINT [DF_TURNI_DD_TUR_CODOPE] DEFAULT ('') FOR [TUR_CODOPE],
	CONSTRAINT [DF_TURNI_DD_TUR_DESOPE] DEFAULT ('') FOR [TUR_DESOPE],
	CONSTRAINT [DF_TURNI_DD_TUR_TIPLAV] DEFAULT ('') FOR [TUR_TIPLAV],
	CONSTRAINT [DF_TURNI_DD_TUR_DESLAV] DEFAULT ('') FOR [TUR_DESLAV]
GO

