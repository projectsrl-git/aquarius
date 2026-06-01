if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COMMESSA_DP]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[COMMESSA_DP]
GO
 
CREATE TABLE [dbo].[COMMESSA_DP] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDCommessa_DP varchar(32) COLLATE Latin1_General_CI_AS NULL ,
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

ALTER TABLE [dbo].[COMMESSA_DP] WITH NOCHECK ADD 
	CONSTRAINT [PK_COMMESSA_DP] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[COMMESSA_DP] WITH NOCHECK ADD 
	CONSTRAINT [DF_COMMESSA_DP_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_COMMESSA_DP_IDCommessa_DP] DEFAULT ('') FOR [IDCommessa_DP],
	CONSTRAINT [DF_COMMESSA_DP_IDCommessaD] DEFAULT ('') FOR [IDCommessaD],
	CONSTRAINT [DF_COMMESSA_DP_CodAttivita] DEFAULT ('') FOR [CodAttivita],
	CONSTRAINT [DF_COMMESSA_DP_DesAttivita] DEFAULT ('') FOR [DesAttivita],
	CONSTRAINT [DF_COMMESSA_DP_TipoSogg] DEFAULT ('') FOR [TipoSogg],
	CONSTRAINT [DF_COMMESSA_DP_DsTipSog] DEFAULT ('') FOR [DsTipSog],
	CONSTRAINT [DF_COMMESSA_DP_CodSogg] DEFAULT ('') FOR [CodSogg],
	CONSTRAINT [DF_COMMESSA_DP_DesSogg] DEFAULT ('') FOR [DesSogg],
	CONSTRAINT [DF_COMMESSA_DP_DatIni] DEFAULT ('') FOR [DatIni],
	CONSTRAINT [DF_COMMESSA_DP_DatFin] DEFAULT ('') FOR [DatFin],
	CONSTRAINT [DF_COMMESSA_DP_GGprev] DEFAULT (0) FOR [GGprev],
	CONSTRAINT [DF_COMMESSA_DP_ValCosto] DEFAULT (0) FOR [ValCosto],
	CONSTRAINT [DF_COMMESSA_DP_ValRicavo] DEFAULT (0) FOR [ValRicavo],
	CONSTRAINT [DF_COMMESSA_DP_ValUtile] DEFAULT (0) FOR [ValUtile],
	CONSTRAINT [DF_COMMESSA_DP_Note] DEFAULT ('') FOR [Note],
	CONSTRAINT [DF_COMMESSA_DP_B_chiuso] DEFAULT (0) FOR [B_chiuso],
	CONSTRAINT [DF_COMMESSA_DP_Sequen] DEFAULT (0) FOR [Sequen]
GO

