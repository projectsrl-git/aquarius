if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RisUCost]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[RisUCost]
GO

CREATE TABLE [dbo].[RisUCost] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[DAGGANCIO] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[ID_COSTO] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[D_Inizio_C] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[D_Fine_C] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[COSTO_ORD] [numeric](17, 2) NULL ,
	[COSTO_STR] [numeric](17, 2) NULL ,
	[COSTO_REP] [numeric](17, 2) NULL ,
	[COSTO_FES] [numeric](17, 2) NULL ,
	[COSTO_NOT] [numeric](17, 2) NULL ,
	[ORDINE] [numeric](3, 0) NULL ,
	[B_INCORSO] [varchar] (1) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RisUCost] WITH NOCHECK ADD 
	CONSTRAINT [PK_RisUCost] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RisUCost] WITH NOCHECK ADD 
	CONSTRAINT [DF_RisUCost_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_RisUCost_DAGGANCIO] DEFAULT ('') FOR [DAGGANCIO],
	CONSTRAINT [DF_RisUCost_ID_COSTO] DEFAULT ('') FOR [ID_COSTO],
	CONSTRAINT [DF_RisUCost_D_Inizio_C] DEFAULT ('') FOR [D_Inizio_C],
	CONSTRAINT [DF_RisUCost_D_Fine_C] DEFAULT ('') FOR [D_Fine_C],
	CONSTRAINT [DF_RisUCost_COSTO_ORD] DEFAULT (0) FOR [COSTO_ORD],
	CONSTRAINT [DF_RisUCost_COSTO_STR] DEFAULT (0) FOR [COSTO_STR],
	CONSTRAINT [DF_RisUCost_COSTO_REP] DEFAULT (0) FOR [COSTO_REP],
	CONSTRAINT [DF_RisUCost_COSTO_FES] DEFAULT (0) FOR [COSTO_FES],
	CONSTRAINT [DF_RisUCost_COSTO_NOT] DEFAULT (0) FOR [COSTO_NOT],
	CONSTRAINT [DF_RisUCost_ORDINE] DEFAULT (0) FOR [ORDINE],
	CONSTRAINT [DF_RISUCOST_B_INCORSO] DEFAULT ('') FOR [B_INCORSO]
GO

