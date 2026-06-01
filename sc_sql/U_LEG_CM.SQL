if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_LEG_CM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_LEG_CM]
GO
 
CREATE TABLE [dbo].[U_LEG_CM] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[LEG_CODCES] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[LEG_ANNO] [varchar] (4) COLLATE Latin1_General_CI_AS NULL ,
	[LEG_NREGIS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[LEG_NUMPRO] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[LEG_CONTO] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[LEG_FLGLEG] [bit] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_LEG_CM] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_LEG_CM] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_LEG_CM] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_LEG_CM_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_LEG_CM_LEG_CODCES] DEFAULT ('') FOR [LEG_CODCES],
	CONSTRAINT [DF_U_LEG_CM_LEG_ANNO] DEFAULT ('') FOR [LEG_ANNO],
	CONSTRAINT [DF_U_LEG_CM_LEG_NREGIS] DEFAULT ('') FOR [LEG_NREGIS],
	CONSTRAINT [DF_U_LEG_CM_LEG_NUMPRO] DEFAULT ('') FOR [LEG_NUMPRO],
	CONSTRAINT [DF_U_LEG_CM_LEG_CONTO] DEFAULT ('') FOR [LEG_CONTO],
	CONSTRAINT [DF_U_LEG_CM_LEG_FLGLEG] DEFAULT (0) FOR [LEG_FLGLEG]
GO

