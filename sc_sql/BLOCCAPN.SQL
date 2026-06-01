if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BLOCCAPN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[BLOCCAPN]
GO
 
CREATE TABLE [dbo].[BLOCCAPN] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[BPN_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[BPN_DATADAL] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[BPN_DATAAL] [varchar] (10) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[BLOCCAPN] WITH NOCHECK ADD 
	CONSTRAINT [PK_BLOCCAPN] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BLOCCAPN] WITH NOCHECK ADD 
	CONSTRAINT [DF_BLOCCAPN_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_BLOCCAPN_BPN_CODSOC] DEFAULT ('') FOR [BPN_CODSOC],
	CONSTRAINT [DF_BLOCCAPN_BPN_DATADAL] DEFAULT ('') FOR [BPN_DATADAL],
	CONSTRAINT [DF_BLOCCAPN_BPN_DATAAL] DEFAULT ('') FOR [BPN_DATAAL]
GO

