if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CBIEP70]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[CBIEP70]
GO
 
CREATE TABLE [dbo].[CBIEP70] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[IDSUPPORTO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[TIPORECORD] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[NUMPROFLUS] [varchar] (7) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CBIEP70] WITH NOCHECK ADD 
	CONSTRAINT [PK_CBIEP70] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CBIEP70] WITH NOCHECK ADD 
	CONSTRAINT [DF_CBIEP70_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_CBIEP70_IDSUPPORTO] DEFAULT ('') FOR [IDSUPPORTO],
	CONSTRAINT [DF_CBIEP70_TIPORECORD] DEFAULT ('') FOR [TIPORECORD],
	CONSTRAINT [DF_CBIEP70_NUMPROFLUS] DEFAULT ('') FOR [NUMPROFLUS]
GO

