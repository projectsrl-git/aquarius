if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_cal_AS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_cal_AS]
GO
 
CREATE TABLE [dbo].[u_cal_AS] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[CAL_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[CAL_CODPDV] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CAL_DESPDV] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[CAL_ANNO] [numeric] (4,0) NULL ,
	[CAL_MESE] [numeric] (2,0) NULL ,
	[CAL_SETTIM] [numeric] (2,0) NULL ,
	[CAL_CODCOL] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CAL_DESCOL] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[CAL_DATA] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CAL_DESGG] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CAL_OPEN] [bit] NULL ,
	[CAL_INTER] [bit] NULL ,
	[CAL_CLOSE] [bit] NULL ,
	[CAL_FLGCON] [bit] NULL ,
	[CAL_FLGTRA] [bit] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[u_cal_AS] WITH NOCHECK ADD 
	CONSTRAINT [PK_u_cal_AS] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[u_cal_AS] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_cal_AS_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_cal_AS_CAL_CODSOC] DEFAULT ('') FOR [CAL_CODSOC],
	CONSTRAINT [DF_u_cal_AS_CAL_CODPDV] DEFAULT ('') FOR [CAL_CODPDV],
	CONSTRAINT [DF_u_cal_AS_CAL_DESPDV] DEFAULT ('') FOR [CAL_DESPDV],
	CONSTRAINT [DF_u_cal_AS_CAL_ANNO] DEFAULT (0) FOR [CAL_ANNO],
	CONSTRAINT [DF_u_cal_AS_CAL_MESE] DEFAULT (0) FOR [CAL_MESE],
	CONSTRAINT [DF_u_cal_AS_CAL_SETTIM] DEFAULT (0) FOR [CAL_SETTIM],
	CONSTRAINT [DF_u_cal_AS_CAL_CODCOL] DEFAULT ('') FOR [CAL_CODCOL],
	CONSTRAINT [DF_u_cal_AS_CAL_DESCOL] DEFAULT ('') FOR [CAL_DESCOL],
	CONSTRAINT [DF_u_cal_AS_CAL_DATA] DEFAULT ('') FOR [CAL_DATA],
	CONSTRAINT [DF_u_cal_AS_CAL_DESGG] DEFAULT ('') FOR [CAL_DESGG],
	CONSTRAINT [DF_u_cal_AS_CAL_OPEN] DEFAULT (0) FOR [CAL_OPEN],
	CONSTRAINT [DF_u_cal_AS_CAL_INTER] DEFAULT (0) FOR [CAL_INTER],
	CONSTRAINT [DF_u_cal_AS_CAL_CLOSE] DEFAULT (0) FOR [CAL_CLOSE],
	CONSTRAINT [DF_u_cal_AS_CAL_FLGCON] DEFAULT (0) FOR [CAL_FLGCON],
	CONSTRAINT [DF_u_cal_AS_CAL_FLGTRA] DEFAULT (0) FOR [CAL_FLGTRA]
GO

