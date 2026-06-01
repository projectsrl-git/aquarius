if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_TOP_MO]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_TOP_MO]
GO
 
CREATE TABLE [dbo].[U_TOP_MO] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[TOP_MAGSCA] [varchar] (6) COLLATE Latin1_General_CI_AS NULL ,
	[TOP_MAGCAR] [varchar] (6) COLLATE Latin1_General_CI_AS NULL ,
	[TOP_CAUSCA] [varchar] (4) COLLATE Latin1_General_CI_AS NULL ,
	[TOP_CAUCAR] [varchar] (4) COLLATE Latin1_General_CI_AS NULL ,
	[TOP_ATTIVO] [bit] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_TOP_MO] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_TOP_MO] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_TOP_MO] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_TOP_MO_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_TOP_MO_TOP_MAGSCA] DEFAULT ('') FOR [TOP_MAGSCA],
	CONSTRAINT [DF_U_TOP_MO_TOP_MAGCAR] DEFAULT ('') FOR [TOP_MAGCAR],
	CONSTRAINT [DF_U_TOP_MO_TOP_CAUSCA] DEFAULT ('') FOR [TOP_CAUSCA],
	CONSTRAINT [DF_U_TOP_MO_TOP_CAUCAR] DEFAULT ('') FOR [TOP_CAUCAR],
	CONSTRAINT [DF_U_TOP_MO_TOP_ATTIVO] DEFAULT (0) FOR [TOP_ATTIVO]
GO

