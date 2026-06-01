if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FLOW_LINEE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FLOW_LINEE]
GO
 
CREATE TABLE [dbo].[FLOW_LINEE] (
	[id_unique]          uniqueidentifier ROWGUIDCOL  NOT NULL ,
    [ID_PROCEDURA]       [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
	[NOME]       [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
	[TIPO]       [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
	[TOPPOS]     [numeric] (5) NULL,
	[LEFTPOS]    [numeric] (5) NULL,
	[HEIGHT]     [numeric] (5) NULL,
	[WIDTH]      [numeric] (5) NULL,
	[SLANT]      [varchar] (1) COLLATE Latin1_General_CI_AS NULL,
	[BLOCCODA]   [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
	[BLOCCOA]    [varchar] (20) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FLOW_LINEE] WITH NOCHECK ADD 
	CONSTRAINT [PK_FLOW_LINEE] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FLOW_LINEE] WITH NOCHECK ADD 
	CONSTRAINT [DF_FLOW_LINEE_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_FLOW_LINEE_ID_PROCEDURA]  DEFAULT ('') FOR [ID_PROCEDURA],
	CONSTRAINT [DF_FLOW_LINEE_NOME]  DEFAULT ('') FOR [NOME],
	CONSTRAINT [DF_FLOW_LINEE_TIPO] DEFAULT ('') FOR [TIPO], 
	CONSTRAINT [DF_FLOW_LINEE_TOPPOS]  DEFAULT (0) FOR [TOPPOS], 
	CONSTRAINT [DF_FLOW_LINEE_LEFTPOS] DEFAULT (0) FOR [LEFTPOS], 
	CONSTRAINT [DF_FLOW_LINEE_HEIGHT] DEFAULT (0) FOR [HEIGHT], 
	CONSTRAINT [DF_FLOW_LINEE_WIDTH] DEFAULT (0) FOR [WIDTH], 
	CONSTRAINT [DF_FLOW_LINEE_SLANT]  DEFAULT ('') FOR [SLANT],    
	CONSTRAINT [DF_FLOW_LINEE_BLOCCODA]  DEFAULT ('') FOR [BLOCCODA],
	CONSTRAINT [DF_FLOW_LINEE_BLOCCOA]  DEFAULT ('') FOR [BLOCCOA]
GO                               

