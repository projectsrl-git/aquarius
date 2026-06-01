if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_SCO_MI]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_SCO_MI]
GO
 
CREATE TABLE [dbo].[U_SCO_MI] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[SCO_CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[SCO_ALTEZZ] [numeric] (5,0) NULL ,
	[SCO_LUNGHE] [numeric] (15,0) NULL ,
	[SCO_NUMBOB] [numeric] (6,0) NULL ,
	[SCO_SCORMI] [numeric] (18,2) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_SCO_MI] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_SCO_MI] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_SCO_MI] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_SCO_MI_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_SCO_MI_SCO_CODART] DEFAULT ('') FOR [SCO_CODART],
	CONSTRAINT [DF_U_SCO_MI_SCO_ALTEZZ] DEFAULT (0) FOR [SCO_ALTEZZ],
	CONSTRAINT [DF_U_SCO_MI_SCO_LUNGHE] DEFAULT (0) FOR [SCO_LUNGHE],
	CONSTRAINT [DF_U_SCO_MI_SCO_NUMBOB] DEFAULT (0) FOR [SCO_NUMBOB],
	CONSTRAINT [DF_U_SCO_MI_SCO_SCORMI] DEFAULT (0) FOR [SCO_SCORMI]
GO

