if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FLOW_STEPS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[FLOW_STEPS]
GO
 
CREATE TABLE [dbo].[FLOW_STEPS] (
	[id_unique]          uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[ID_PROCEDURA]       [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
	[ID_BLOCCO]          [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
	[ID_STEP]            [varchar] (20) COLLATE Latin1_General_CI_AS NULL,
	[USERID]             [varchar] (30) COLLATE Latin1_General_CI_AS NULL,
	[FLG_ESEGUITO]       [BIT] NULL,
	[DATA_INIZIO]        [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
	[ORA_INIZIO]         [varchar] (8) COLLATE Latin1_General_CI_AS NULL,
	[DATA_FINE]          [varchar] (10) COLLATE Latin1_General_CI_AS NULL,
	[ORA_FINE]           [varchar] (8) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[FLOW_STEPS] WITH NOCHECK ADD 
	CONSTRAINT [PK_FLOW_STEPS]  PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FLOW_STEPS] WITH NOCHECK ADD 
	CONSTRAINT [DF_FLOW_STEPS_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_FLOW_STEPS_ID_PROCEDURA]  DEFAULT ('') FOR [ID_PROCEDURA],
	CONSTRAINT [DF_FLOW_STEPS_ID_BLOCCO]  DEFAULT ('') FOR [ID_BLOCCO],
	CONSTRAINT [DF_FLOW_STEPS_USERID] DEFAULT ('') FOR [USERID], 
	CONSTRAINT [DF_FLOW_FLG_ESEGUITO] DEFAULT (0) FOR [FLG_ESEGUITO], 
	CONSTRAINT [DF_FLOW_STEPS_DATA_INIZIO]  DEFAULT ('') FOR [DATA_INIZIO], 
	CONSTRAINT [DF_FLOW_STEPS_ORA_INIZIO]  DEFAULT ('') FOR [ORA_INIZIO],    
	CONSTRAINT [DF_FLOW_STEPS_DATA_FINE]  DEFAULT ('') FOR [DATA_FINE],
	CONSTRAINT [DF_FLOW_STEPS_ORA_FINE]  DEFAULT ('') FOR [ORA_FINE]
GO                               



