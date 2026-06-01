if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CONTRST_DL]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CONTRST_DL]
GO
 
CREATE TABLE [dbo].[CONTRST_DL] (
	id_unique uniqueidentifier ROWGUIDCOL NOT NULL ,
	DAGGANCIO varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	IDATTIVITA varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	IDDETTAGLI varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	AAAAMM varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	TIPO_ELAB varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	QtaCosto numeric(17,2) NULL ,
	UMCosto varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	PrzCosto numeric(17,6) NULL ,
	Costo numeric(17,2) NULL ,
	QtaRicavo numeric(17,2) NULL ,
	QtaRicavo2 numeric(17,2) NULL ,
	UMRicavo varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	PrzRicavo numeric(17,6) NULL ,
	Ricavo numeric(17,2) NULL ,
	Utile numeric(17,2) NULL ,
	Annotazioni text NULL ,
	Tipo_fatt varchar(1) COLLATE Latin1_General_CI_AS NULL ,
	FlgFatturab bit NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CONTRST_DL] WITH NOCHECK ADD 
	CONSTRAINT [PK_CONTRST_DL] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CONTRST_DL] WITH NOCHECK ADD 
	CONSTRAINT [DF_CONTRST_DL_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_CONTRST_DL_DAGGANCIO] DEFAULT ('') FOR [DAGGANCIO],
	CONSTRAINT [DF_CONTRST_DL_IDATTIVITA] DEFAULT ('') FOR [IDATTIVITA],
	CONSTRAINT [DF_CONTRST_DL_IDDETTAGLI] DEFAULT ('') FOR [IDDETTAGLI],
	CONSTRAINT [DF_CONTRST_DL_AAAAMM] DEFAULT ('') FOR [AAAAMM],
	CONSTRAINT [DF_CONTRST_DL_TIPO_ELAB] DEFAULT ('') FOR [TIPO_ELAB],
	CONSTRAINT [DF_CONTRST_DL_QtaCosto] DEFAULT (0) FOR [QtaCosto],
	CONSTRAINT [DF_CONTRST_DL_UMCosto] DEFAULT ('') FOR [UMCosto],
	CONSTRAINT [DF_CONTRST_DL_PrzCosto] DEFAULT (0) FOR [PrzCosto],
	CONSTRAINT [DF_CONTRST_DL_Costo] DEFAULT (0) FOR [Costo],
	CONSTRAINT [DF_CONTRST_DL_QtaRicavo] DEFAULT (0) FOR [QtaRicavo],
	CONSTRAINT [DF_CONTRST_DL_QtaRicavo2] DEFAULT (0) FOR [QtaRicavo2],
	CONSTRAINT [DF_CONTRST_DL_UMRicavo] DEFAULT ('') FOR [UMRicavo],
	CONSTRAINT [DF_CONTRST_DL_PrzRicavo] DEFAULT (0) FOR [PrzRicavo],
	CONSTRAINT [DF_CONTRST_DL_Ricavo] DEFAULT (0) FOR [Ricavo],
	CONSTRAINT [DF_CONTRST_DL_Utile] DEFAULT (0) FOR [Utile],
	CONSTRAINT [DF_CONTRST_DL_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_CONTRST_DL_Tipo_fatt] DEFAULT ('') FOR [Tipo_fatt],
	CONSTRAINT [DF_CONTRST_DL_FlgFatturab] DEFAULT ('') FOR [FlgFatturab]
GO

