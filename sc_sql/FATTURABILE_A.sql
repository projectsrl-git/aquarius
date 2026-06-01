if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FATTURABILE_A]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[FATTURABILE_A]
GO
 
CREATE TABLE [dbo].[FATTURABILE_A] (
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

ALTER TABLE [dbo].[FATTURABILE_A] WITH NOCHECK ADD 
	CONSTRAINT [PK_FATTURABILE_A] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FATTURABILE_A] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_A_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_FATTURABILE_A_IDFatturabile] DEFAULT ('') FOR [IDFatturabile],
	CONSTRAINT [DF_FATTURABILE_A_IDCommessaC] DEFAULT ('') FOR [IDCommessaC],
	CONSTRAINT [DF_FATTURABILE_A_Codice] DEFAULT ('') FOR [Codice],
	CONSTRAINT [DF_FATTURABILE_A_CodCli] DEFAULT ('') FOR [CodCli],
	CONSTRAINT [DF_FATTURABILE_A_RagSoc] DEFAULT ('') FOR [RagSoc],
	CONSTRAINT [DF_FATTURABILE_A_Indiri] DEFAULT ('') FOR [Indiri],
	CONSTRAINT [DF_FATTURABILE_A_Locali] DEFAULT ('') FOR [Locali],
	CONSTRAINT [DF_FATTURABILE_A_Cap] DEFAULT ('') FOR [Cap],
	CONSTRAINT [DF_FATTURABILE_A_Provin] DEFAULT ('') FOR [Provin],
	CONSTRAINT [DF_FATTURABILE_A_IDPartecip] DEFAULT ('') FOR [IDPartecip],

	CONSTRAINT [DF_FATTURABILE_A_IDCommessa_DC] DEFAULT ('') FOR [IDCommessa_DC],
	CONSTRAINT [DF_FATTURABILE_A_IDCommessaD] DEFAULT ('') FOR [IDCommessaD],
	CONSTRAINT [DF_FATTURABILE_A_CodAttivita] DEFAULT ('') FOR [CodAttivita],
	CONSTRAINT [DF_FATTURABILE_A_DesAttivita] DEFAULT ('') FOR [DesAttivita],
	CONSTRAINT [DF_FATTURABILE_A_TipoSogg] DEFAULT ('') FOR [TipoSogg],
	CONSTRAINT [DF_FATTURABILE_A_DsTipSog] DEFAULT ('') FOR [DsTipSog],
	CONSTRAINT [DF_FATTURABILE_A_CodSogg] DEFAULT ('') FOR [CodSogg],
	CONSTRAINT [DF_FATTURABILE_A_DesSogg] DEFAULT ('') FOR [DesSogg],
	CONSTRAINT [DF_FATTURABILE_A_DatIni] DEFAULT ('') FOR [DatIni],
	CONSTRAINT [DF_FATTURABILE_A_DatFin] DEFAULT ('') FOR [DatFin],
	CONSTRAINT [DF_FATTURABILE_A_GGprev] DEFAULT (0) FOR [GGprev],
	CONSTRAINT [DF_FATTURABILE_A_Note] DEFAULT ('') FOR [Note],
	CONSTRAINT [DF_FATTURABILE_A_B_chiuso] DEFAULT (0) FOR [B_chiuso],

	CONSTRAINT [DF_FATTURABILE_A_Anno] DEFAULT ('') FOR [Anno],
	CONSTRAINT [DF_FATTURABILE_A_Mese] DEFAULT ('') FOR [Mese],
	CONSTRAINT [DF_FATTURABILE_A_AAAAMM] DEFAULT ('') FOR [AAAAMM],
	CONSTRAINT [DF_FATTURABILE_A_QtaGG] DEFAULT (0) FOR [QtaGG],
	CONSTRAINT [DF_FATTURABILE_A_OreGG] DEFAULT (0) FOR [OreGG],
	CONSTRAINT [DF_FATTURABILE_A_UMcosto] DEFAULT ('') FOR [UMcosto],
	CONSTRAINT [DF_FATTURABILE_A_UMricavo] DEFAULT ('') FOR [UMricavo],
	CONSTRAINT [DF_FATTURABILE_A_Costo] DEFAULT (0) FOR [Costo],
	CONSTRAINT [DF_FATTURABILE_A_Ricavo] DEFAULT (0) FOR [Ricavo],
	CONSTRAINT [DF_FATTURABILE_A_ValCosto] DEFAULT (0) FOR [ValCosto],
	CONSTRAINT [DF_FATTURABILE_A_ValRicavo] DEFAULT (0) FOR [ValRicavo],
	CONSTRAINT [DF_FATTURABILE_A_ValUtile] DEFAULT (0) FOR [ValUtile],
	CONSTRAINT [DF_FATTURABILE_A_IDTipoOra_c] DEFAULT ('') FOR [IDTipoOra_c],
	CONSTRAINT [DF_FATTURABILE_A_TipoOra_c] DEFAULT ('') FOR [TipoOra_c],
	CONSTRAINT [DF_FATTURABILE_A_IDDettOra_c] DEFAULT ('') FOR [IDDettOra_c],
	CONSTRAINT [DF_FATTURABILE_A_DettOra_c] DEFAULT ('') FOR [DettOra_c],
	CONSTRAINT [DF_FATTURABILE_A_IDTipoOra_r] DEFAULT ('') FOR [IDTipoOra_r],
	CONSTRAINT [DF_FATTURABILE_A_TipoOra_r] DEFAULT ('') FOR [TipoOra_r],
	CONSTRAINT [DF_FATTURABILE_A_IDDettOra_r] DEFAULT ('') FOR [IDDettOra_r],
	CONSTRAINT [DF_FATTURABILE_A_DettOra_r] DEFAULT ('') FOR [DettOra_r],
	CONSTRAINT [DF_FATTURABILE_A_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_FATTURABILE_A_TotOre] DEFAULT (0) FOR [TotOre],
	CONSTRAINT [DF_FATTURABILE_A_TotCosto] DEFAULT (0) FOR [TotCosto],
	CONSTRAINT [DF_FATTURABILE_A_TotRicavo] DEFAULT (0) FOR [TotRicavo],
	CONSTRAINT [DF_FATTURABILE_A_TotUtile] DEFAULT (0) FOR [TotUtile],
	CONSTRAINT [DF_FATTURABILE_A_FlgFatturato] DEFAULT (0) FOR [FlgFatturato]
GO

