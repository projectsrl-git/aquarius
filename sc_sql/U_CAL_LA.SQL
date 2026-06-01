if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_CAL_LA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[U_CAL_LA]
GO
 
CREATE TABLE [dbo].[U_CAL_LA] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CAL_ANNO] [numeric] (4,0) NULL ,
	[CAL_DATA] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CAL_DATAMG] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CAL_SETT] [varchar] (7) COLLATE Latin1_General_CI_AS NULL ,
	[CAL_GIOR] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CAL_LAVO] [bit] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_CAL_LA] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_CAL_LA] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_CAL_LA] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_CAL_LA_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_CAL_LA_CAL_ANNO] DEFAULT (0) FOR [CAL_ANNO],
	CONSTRAINT [DF_U_CAL_LA_CAL_DATA] DEFAULT ('') FOR [CAL_DATA],
	CONSTRAINT [DF_U_CAL_LA_CAL_DATAMG] DEFAULT ('') FOR [CAL_DATAMG],
	CONSTRAINT [DF_U_CAL_LA_CAL_SETT] DEFAULT ('') FOR [CAL_SETT],
	CONSTRAINT [DF_U_CAL_LA_CAL_GIOR] DEFAULT ('') FOR [CAL_GIOR],
	CONSTRAINT [DF_U_CAL_LA_CAL_LAVO] DEFAULT (0) FOR [CAL_LAVO]
GO

