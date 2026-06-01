if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COMMESSA_DC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[COMMESSA_DC]
GO
 
CREATE TABLE [dbo].[COMMESSA_DC] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDCOMMESSA_DC varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCommessaD varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	CodAttivita varchar(03) COLLATE Latin1_General_CI_AS NULL ,
	DesAttivita varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	TipoSogg varchar(01) COLLATE Latin1_General_CI_AS NULL ,
	DsTipSog varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	CodSogg varchar(20) COLLATE Latin1_General_CI_AS NULL ,
	DesSogg varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	DatIni varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	DatFin varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	GGprev numeric(10,0) NULL ,
	ValCosto numeric(17,2) NULL ,
	ValRicavo numeric(17,2) NULL ,
	ValUtile numeric(17,2) NULL ,
	Note text COLLATE Latin1_General_CI_AS NULL ,
	B_chiuso bit NULL,
	Sequen numeric(10,0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[COMMESSA_DC] WITH NOCHECK ADD 
	CONSTRAINT [PK_COMMESSA_DC] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[COMMESSA_DC] WITH NOCHECK ADD 
	CONSTRAINT [DF_COMMESSA_DC_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_COMMESSA_DC_IDCOMMESSA_DC] DEFAULT ('') FOR [IDCOMMESSA_DC],
	CONSTRAINT [DF_COMMESSA_DC_IDCommessaD] DEFAULT ('') FOR [IDCommessaD],
	CONSTRAINT [DF_COMMESSA_DC_CodAttivita] DEFAULT ('') FOR [CodAttivita],
	CONSTRAINT [DF_COMMESSA_DC_DesAttivita] DEFAULT ('') FOR [DesAttivita],
	CONSTRAINT [DF_COMMESSA_DC_TipoSogg] DEFAULT ('') FOR [TipoSogg],
	CONSTRAINT [DF_COMMESSA_DC_DsTipSog] DEFAULT ('') FOR [DsTipSog],
	CONSTRAINT [DF_COMMESSA_DC_CodSogg] DEFAULT ('') FOR [CodSogg],
	CONSTRAINT [DF_COMMESSA_DC_DesSogg] DEFAULT ('') FOR [DesSogg],
	CONSTRAINT [DF_COMMESSA_DC_DatIni] DEFAULT ('') FOR [DatIni],
	CONSTRAINT [DF_COMMESSA_DC_DatFin] DEFAULT ('') FOR [DatFin],
	CONSTRAINT [DF_COMMESSA_DC_GGprev] DEFAULT (0) FOR [GGprev],
	CONSTRAINT [DF_COMMESSA_DC_ValCosto] DEFAULT (0) FOR [ValCosto],
	CONSTRAINT [DF_COMMESSA_DC_ValRicavo] DEFAULT (0) FOR [ValRicavo],
	CONSTRAINT [DF_COMMESSA_DC_ValUtile] DEFAULT (0) FOR [ValUtile],
	CONSTRAINT [DF_COMMESSA_DC_Note] DEFAULT ('') FOR [Note],
	CONSTRAINT [DF_COMMESSA_DC_B_chiuso] DEFAULT (0) FOR [B_chiuso],
	CONSTRAINT [DF_COMMESSA_DC_Sequen] DEFAULT (0) FOR [Sequen]
GO

