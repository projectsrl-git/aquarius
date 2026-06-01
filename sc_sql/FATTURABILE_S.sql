if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FATTURABILE_S]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[FATTURABILE_S]
GO
 
CREATE TABLE [dbo].[FATTURABILE_S] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDFatturabile varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCommessaC varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	Codice varchar(25) COLLATE Latin1_General_CI_AS NULL ,
	CodCli varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	RagSoc varchar(80) COLLATE Latin1_General_CI_AS NULL ,
	Indiri varchar(80) COLLATE Latin1_General_CI_AS NULL ,
	Locali varchar(80) COLLATE Latin1_General_CI_AS NULL ,
	Cap varchar(05) COLLATE Latin1_General_CI_AS NULL ,
	Provin varchar(02) COLLATE Latin1_General_CI_AS NULL ,
	IDPartecip varchar(32) COLLATE Latin1_General_CI_AS NULL ,

	IDCommessa_DC varchar(32) COLLATE Latin1_General_CI_AS NULL ,
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
	Note text COLLATE Latin1_General_CI_AS NULL ,
	B_chiuso bit NULL,

	Anno varchar(04) COLLATE Latin1_General_CI_AS NULL ,
	Mese varchar(02) COLLATE Latin1_General_CI_AS NULL ,
	AAAAMM varchar(07) COLLATE Latin1_General_CI_AS NULL ,
	QtaGG numeric(17,2) NULL ,
	OreGG numeric(10,2) NULL ,
	UMcosto varchar(02) COLLATE Latin1_General_CI_AS NULL ,
	UMricavo varchar(02) COLLATE Latin1_General_CI_AS NULL ,
	Costo numeric(17,6) NULL ,
	Ricavo numeric(17,6) NULL ,
	ValCosto numeric(17,2) NULL ,
	ValRicavo numeric(17,2) NULL ,
	ValUtile numeric(17,2) NULL ,
	IDTipoOra_c varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	TipoOra_c varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	IDDettOra_c varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	DettOra_c varchar(245) COLLATE Latin1_General_CI_AS NULL ,
	IDTipoOra_r varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	TipoOra_r varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	IDDettOra_r varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	DettOra_r varchar(245) COLLATE Latin1_General_CI_AS NULL ,
	Annotazioni text COLLATE Latin1_General_CI_AS NULL,
	TotOre numeric(17,2) NULL ,
	TotCosto numeric(17,2) NULL ,
	TotRicavo numeric(17,2) NULL ,
	TotUtile numeric(17,2) NULL ,
	FlgFatturato bit NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[FATTURABILE_S] WITH NOCHECK ADD 
	CONSTRAINT [PK_FATTURABILE_S] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FATTURABILE_S] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_S_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_FATTURABILE_S_IDFatturabile] DEFAULT ('') FOR [IDFatturabile],
	CONSTRAINT [DF_FATTURABILE_S_IDCommessaC] DEFAULT ('') FOR [IDCommessaC],
	CONSTRAINT [DF_FATTURABILE_S_Codice] DEFAULT ('') FOR [Codice],
	CONSTRAINT [DF_FATTURABILE_S_CodCli] DEFAULT ('') FOR [CodCli],
	CONSTRAINT [DF_FATTURABILE_S_RagSoc] DEFAULT ('') FOR [RagSoc],
	CONSTRAINT [DF_FATTURABILE_S_Indiri] DEFAULT ('') FOR [Indiri],
	CONSTRAINT [DF_FATTURABILE_S_Locali] DEFAULT ('') FOR [Locali],
	CONSTRAINT [DF_FATTURABILE_S_Cap] DEFAULT ('') FOR [Cap],
	CONSTRAINT [DF_FATTURABILE_S_Provin] DEFAULT ('') FOR [Provin],
	CONSTRAINT [DF_FATTURABILE_S_IDPartecip] DEFAULT ('') FOR [IDPartecip],

	CONSTRAINT [DF_FATTURABILE_S_IDCommessa_DC] DEFAULT ('') FOR [IDCommessa_DC],
	CONSTRAINT [DF_FATTURABILE_S_IDCommessaD] DEFAULT ('') FOR [IDCommessaD],
	CONSTRAINT [DF_FATTURABILE_S_CodAttivita] DEFAULT ('') FOR [CodAttivita],
	CONSTRAINT [DF_FATTURABILE_S_DesAttivita] DEFAULT ('') FOR [DesAttivita],
	CONSTRAINT [DF_FATTURABILE_S_TipoSogg] DEFAULT ('') FOR [TipoSogg],
	CONSTRAINT [DF_FATTURABILE_S_DsTipSog] DEFAULT ('') FOR [DsTipSog],
	CONSTRAINT [DF_FATTURABILE_S_CodSogg] DEFAULT ('') FOR [CodSogg],
	CONSTRAINT [DF_FATTURABILE_S_DesSogg] DEFAULT ('') FOR [DesSogg],
	CONSTRAINT [DF_FATTURABILE_S_DatIni] DEFAULT ('') FOR [DatIni],
	CONSTRAINT [DF_FATTURABILE_S_DatFin] DEFAULT ('') FOR [DatFin],
	CONSTRAINT [DF_FATTURABILE_S_GGprev] DEFAULT (0) FOR [GGprev],
	CONSTRAINT [DF_FATTURABILE_S_Note] DEFAULT ('') FOR [Note],
	CONSTRAINT [DF_FATTURABILE_S_B_chiuso] DEFAULT (0) FOR [B_chiuso],

	CONSTRAINT [DF_FATTURABILE_S_Anno] DEFAULT ('') FOR [Anno],
	CONSTRAINT [DF_FATTURABILE_S_Mese] DEFAULT ('') FOR [Mese],
	CONSTRAINT [DF_FATTURABILE_S_AAAAMM] DEFAULT ('') FOR [AAAAMM],
	CONSTRAINT [DF_FATTURABILE_S_QtaGG] DEFAULT (0) FOR [QtaGG],
	CONSTRAINT [DF_FATTURABILE_S_OreGG] DEFAULT (0) FOR [OreGG],
	CONSTRAINT [DF_FATTURABILE_S_UMcosto] DEFAULT ('') FOR [UMcosto],
	CONSTRAINT [DF_FATTURABILE_S_UMricavo] DEFAULT ('') FOR [UMricavo],
	CONSTRAINT [DF_FATTURABILE_S_Costo] DEFAULT (0) FOR [Costo],
	CONSTRAINT [DF_FATTURABILE_S_Ricavo] DEFAULT (0) FOR [Ricavo],
	CONSTRAINT [DF_FATTURABILE_S_ValCosto] DEFAULT (0) FOR [ValCosto],
	CONSTRAINT [DF_FATTURABILE_S_ValRicavo] DEFAULT (0) FOR [ValRicavo],
	CONSTRAINT [DF_FATTURABILE_S_ValUtile] DEFAULT (0) FOR [ValUtile],
	CONSTRAINT [DF_FATTURABILE_S_IDTipoOra_c] DEFAULT ('') FOR [IDTipoOra_c],
	CONSTRAINT [DF_FATTURABILE_S_TipoOra_c] DEFAULT ('') FOR [TipoOra_c],
	CONSTRAINT [DF_FATTURABILE_S_IDDettOra_c] DEFAULT ('') FOR [IDDettOra_c],
	CONSTRAINT [DF_FATTURABILE_S_DettOra_c] DEFAULT ('') FOR [DettOra_c],
	CONSTRAINT [DF_FATTURABILE_S_IDTipoOra_r] DEFAULT ('') FOR [IDTipoOra_r],
	CONSTRAINT [DF_FATTURABILE_S_TipoOra_r] DEFAULT ('') FOR [TipoOra_r],
	CONSTRAINT [DF_FATTURABILE_S_IDDettOra_r] DEFAULT ('') FOR [IDDettOra_r],
	CONSTRAINT [DF_FATTURABILE_S_DettOra_r] DEFAULT ('') FOR [DettOra_r],
	CONSTRAINT [DF_FATTURABILE_S_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_FATTURABILE_S_TotOre] DEFAULT (0) FOR [TotOre],
	CONSTRAINT [DF_FATTURABILE_S_TotCosto] DEFAULT (0) FOR [TotCosto],
	CONSTRAINT [DF_FATTURABILE_S_TotRicavo] DEFAULT (0) FOR [TotRicavo],
	CONSTRAINT [DF_FATTURABILE_S_TotUtile] DEFAULT (0) FOR [TotUtile],
	CONSTRAINT [DF_FATTURABILE_S_FlgFatturato] DEFAULT (0) FOR [FlgFatturato]
GO

