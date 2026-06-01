if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COMMESSA_DP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[COMMESSA_DP]
GO

CREATE TABLE [COMMESSA_DP] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_COMMESSA_DP_id_unique] DEFAULT (newid()),
	[IDCommessa_DP] [varchar] (32) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_IDCommessa_DP] DEFAULT (''),
	[IDCommessaD] [varchar] (32) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_IDCommessaD] DEFAULT (''),
	[CodAttivita] [varchar] (3) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_CodAttivita] DEFAULT (''),
	[DesAttivita] [varchar] (254) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_DesAttivita] DEFAULT (''),
	[TipoSogg] [varchar] (1) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_TipoSogg] DEFAULT (''),
	[DsTipSog] [varchar] (100) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_DsTipSog] DEFAULT (''),
	[CodSogg] [varchar] (20) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_CodSogg] DEFAULT (''),
	[DesSogg] [varchar] (100) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_DesSogg] DEFAULT (''),
	[DatIni] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_DatIni] DEFAULT (''),
	[DatFin] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_DatFin] DEFAULT (''),
	[GGprev] [numeric](10, 0) NULL CONSTRAINT [DF_COMMESSA_DP_GGprev] DEFAULT (0),
	[ValCosto] [numeric](17, 2) NULL CONSTRAINT [DF_COMMESSA_DP_ValCosto] DEFAULT (0),
	[ValRicavo] [numeric](17, 2) NULL CONSTRAINT [DF_COMMESSA_DP_ValRicavo] DEFAULT (0),
	[ValUtile] [numeric](17, 2) NULL CONSTRAINT [DF_COMMESSA_DP_ValUtile] DEFAULT (0),
	[Note] [text] COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_Note] DEFAULT (''),
	[B_chiuso] [bit] NULL CONSTRAINT [DF_COMMESSA_DP_B_chiuso] DEFAULT (0),
	[Sequen] [numeric](10, 0) NULL CONSTRAINT [DF_COMMESSA_DP_Sequen] DEFAULT (0),
	[CODFIGPROF] [varchar] (3) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_CODFIGPROF] DEFAULT (''),
	[DESFIGPROF] [varchar] (100) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DP_DESFIGPROF] DEFAULT (''),
	[CODUTENTE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_CODUTENTE] DEFAULT (''),
	[DESUTENTE] [varchar] (100) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_DESUTENTE] DEFAULT (''),
	[COMUNE] [varchar] (100) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_COMUNE] DEFAULT (''),
	[PROVINCIA] [varchar] (2) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_PROVINCIA] DEFAULT (''),
	CONSTRAINT [PK_COMMESSA_DP] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


