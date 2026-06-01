if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_lot_ri]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_lot_ri]
GO
 
CREATE TABLE [dbo].[u_lot_ri] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[LOT_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[LOT_NLOINI] [numeric] (10,0) NULL ,
	[LOT_DATOPE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[LOT_ORAOPE] [varchar] (8) COLLATE Latin1_General_CI_AS NULL ,
	[LOT_MAGSCA] [varchar] (6) COLLATE Latin1_General_CI_AS NULL ,
	[LOT_MAGCAR] [varchar] (6) COLLATE Latin1_General_CI_AS NULL ,
	[LOT_CODCAU] [varchar] (4) COLLATE Latin1_General_CI_AS NULL ,
	[LOT_NLOFIN] [numeric] (10,0) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[u_lot_ri] WITH NOCHECK ADD 
	CONSTRAINT [PK_u_lot_ri] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[u_lot_ri] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_lot_ri_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_lot_ri_LOT_CODSOC] DEFAULT ('') FOR [LOT_CODSOC],
	CONSTRAINT [DF_u_lot_ri_LOT_NLOINI] DEFAULT (0) FOR [LOT_NLOINI],
	CONSTRAINT [DF_u_lot_ri_LOT_DATOPE] DEFAULT ('') FOR [LOT_DATOPE],
	CONSTRAINT [DF_u_lot_ri_LOT_ORAOPE] DEFAULT ('') FOR [LOT_ORAOPE],
	CONSTRAINT [DF_u_lot_ri_LOT_MAGSCA] DEFAULT ('') FOR [LOT_MAGSCA],
	CONSTRAINT [DF_u_lot_ri_LOT_MAGCAR] DEFAULT ('') FOR [LOT_MAGCAR],
	CONSTRAINT [DF_u_lot_ri_LOT_CODCAU] DEFAULT ('') FOR [LOT_CODCAU],
	CONSTRAINT [DF_u_lot_ri_LOT_NLOFIN] DEFAULT (0) FOR [LOT_NLOFIN]
GO

