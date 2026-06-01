if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COMMESSA_DC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[COMMESSA_DC]
GO

CREATE TABLE [COMMESSA_DC] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_COMMESSA_DC_id_unique] DEFAULT (newid()),
	[IDCOMMESSA_DC] [varchar] (32) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_IDCOMMESSA_DC] DEFAULT (''),
	[IDCommessaD] [varchar] (32) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_IDCommessaD] DEFAULT (''),
	[CodAttivita] [varchar] (3) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_CodAttivita] DEFAULT (''),
	[DesAttivita] [varchar] (254) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_DesAttivita] DEFAULT (''),
	[TipoSogg] [varchar] (1) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_TipoSogg] DEFAULT (''),
	[DsTipSog] [varchar] (100) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_DsTipSog] DEFAULT (''),
	[CodSogg] [varchar] (20) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_CodSogg] DEFAULT (''),
	[DesSogg] [varchar] (100) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_DesSogg] DEFAULT (''),
	[DatIni] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_DatIni] DEFAULT (''),
	[DatFin] [varchar] (10) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_DatFin] DEFAULT (''),
	[GGprev] [numeric](10, 0) NULL CONSTRAINT [DF_COMMESSA_DC_GGprev] DEFAULT (0),
	[ValCosto] [numeric](17, 2) NULL CONSTRAINT [DF_COMMESSA_DC_ValCosto] DEFAULT (0),
	[ValRicavo] [numeric](17, 2) NULL CONSTRAINT [DF_COMMESSA_DC_ValRicavo] DEFAULT (0),
	[ValUtile] [numeric](17, 2) NULL CONSTRAINT [DF_COMMESSA_DC_ValUtile] DEFAULT (0),
	[Note] [text] COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_Note] DEFAULT (''),
	[B_chiuso] [bit] NULL CONSTRAINT [DF_COMMESSA_DC_B_chiuso] DEFAULT (0),
	[Sequen] [numeric](10, 0) NULL CONSTRAINT [DF_COMMESSA_DC_Sequen] DEFAULT (0),
	[CODFIGPROF] [varchar] (3) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_CODFIGPROF] DEFAULT (''),
	[DESFIGPROF] [varchar] (100) COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_COMMESSA_DC_DESFIGPROF] DEFAULT (''),
	[CODUTENTE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[DESUTENTE] [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[COMUNE] [varchar] (100) COLLATE Latin1_General_CI_AS NULL ,
	[PROVINCIA] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	CONSTRAINT [PK_COMMESSA_DC] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO


