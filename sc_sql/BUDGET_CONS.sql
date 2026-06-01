if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[BUDGET_CONS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[BUDGET_CONS]
GO
 
CREATE TABLE [dbo].[BUDGET_CONS] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDCommessa_dc varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCommessaD varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	CodAttivita varchar(03) COLLATE Latin1_General_CI_AS NULL ,
	DesAttivita varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	TipoSogg varchar(01) COLLATE Latin1_General_CI_AS NULL ,
	DsTipSog varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	CodSogg varchar(20) COLLATE Latin1_General_CI_AS NULL ,
	DesSogg varchar(100) COLLATE Latin1_General_CI_AS NULL ,
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
	Annotazioni text COLLATE Latin1_General_CI_AS NULL ,
	FlgFatturab bit NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[BUDGET_CONS] WITH NOCHECK ADD 
	CONSTRAINT [PK_BUDGET_CONS] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[BUDGET_CONS] WITH NOCHECK ADD 
	CONSTRAINT [DF_BUDGET_CONS_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_BUDGET_CONS_IDCommessa_dc] DEFAULT ('') FOR [IDCommessa_dc],
	CONSTRAINT [DF_BUDGET_CONS_IDCommessaD] DEFAULT ('') FOR [IDCommessaD],
	CONSTRAINT [DF_BUDGET_CONS_CodAttivita] DEFAULT ('') FOR [CodAttivita],
	CONSTRAINT [DF_BUDGET_CONS_DesAttivita] DEFAULT ('') FOR [DesAttivita],
	CONSTRAINT [DF_BUDGET_CONS_TipoSogg] DEFAULT ('') FOR [TipoSogg],
	CONSTRAINT [DF_BUDGET_CONS_DsTipSog] DEFAULT ('') FOR [DsTipSog],
	CONSTRAINT [DF_BUDGET_CONS_CodSogg] DEFAULT ('') FOR [CodSogg],
	CONSTRAINT [DF_BUDGET_CONS_DesSogg] DEFAULT ('') FOR [DesSogg],
	CONSTRAINT [DF_BUDGET_CONS_Anno] DEFAULT ('') FOR [Anno],
	CONSTRAINT [DF_BUDGET_CONS_Mese] DEFAULT ('') FOR [Mese],
	CONSTRAINT [DF_BUDGET_CONS_AAAAMM] DEFAULT ('') FOR [AAAAMM],
	CONSTRAINT [DF_BUDGET_CONS_QtaGG] DEFAULT (0) FOR [QtaGG],
	CONSTRAINT [DF_BUDGET_CONS_OreGG] DEFAULT (0) FOR [OreGG],
	CONSTRAINT [DF_BUDGET_CONS_UMcosto] DEFAULT ('') FOR [UMcosto],
	CONSTRAINT [DF_BUDGET_CONS_UMricavo] DEFAULT ('') FOR [UMricavo],
	CONSTRAINT [DF_BUDGET_CONS_Costo] DEFAULT (0) FOR [Costo],
	CONSTRAINT [DF_BUDGET_CONS_Ricavo] DEFAULT (0) FOR [Ricavo],
	CONSTRAINT [DF_BUDGET_CONS_ValCosto] DEFAULT (0) FOR [ValCosto],
	CONSTRAINT [DF_BUDGET_CONS_ValRicavo] DEFAULT (0) FOR [ValRicavo],
	CONSTRAINT [DF_BUDGET_CONS_ValUtile] DEFAULT (0) FOR [ValUtile],
	CONSTRAINT [DF_BUDGET_CONS_IDTipoOra_c] DEFAULT ('') FOR [IDTipoOra_c],
	CONSTRAINT [DF_BUDGET_CONS_TipoOra_c] DEFAULT ('') FOR [TipoOra_c],
	CONSTRAINT [DF_BUDGET_CONS_IDDettOra_c] DEFAULT ('') FOR [IDDettOra_c],
	CONSTRAINT [DF_BUDGET_CONS_DettOra_c] DEFAULT ('') FOR [DettOra_c],
	CONSTRAINT [DF_BUDGET_CONS_IDTipoOra_r] DEFAULT ('') FOR [IDTipoOra_r],
	CONSTRAINT [DF_BUDGET_CONS_TipoOra_r] DEFAULT ('') FOR [TipoOra_r],
	CONSTRAINT [DF_BUDGET_CONS_IDDettOra_r] DEFAULT ('') FOR [IDDettOra_r],
	CONSTRAINT [DF_BUDGET_CONS_DettOra_r] DEFAULT ('') FOR [DettOra_r],
	CONSTRAINT [DF_BUDGET_CONS_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_BUDGET_CONS_FlgFatturab] DEFAULT (0) FOR [FlgFatturab]
GO

