if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RISUXCOM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[RISUXCOM]
GO
 
CREATE TABLE [dbo].[RISUXCOM] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDCompXCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	RisUmana varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	DsRisUmana varchar(150) COLLATE Latin1_General_CI_AS NULL ,
	FigProf varchar(03) COLLATE Latin1_General_CI_AS NULL ,
	DsFigProf varchar(100) COLLATE Latin1_General_CI_AS NULL ,
	AnaAzi varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	DsAnaAzi varchar(80) COLLATE Latin1_General_CI_AS NULL ,
	Comune varchar(40) COLLATE Latin1_General_CI_AS NULL ,
	Provin varchar(02) COLLATE Latin1_General_CI_AS NULL ,
	D_InizioSch varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	D_FineSch varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	D_InizioEff varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	D_FineEff varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	CostoGUMed numeric(17,6) NULL ,
	RicavoGUMed numeric(17,6) NULL ,
	Annotazioni varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	B_chiuso bit NULL,
	Sequen numeric(10,0) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RISUXCOM] WITH NOCHECK ADD 
	CONSTRAINT [PK_RISUXCOM] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RISUXCOM] WITH NOCHECK ADD 
	CONSTRAINT [DF_RISUXCOM_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_RISUXCOM_IDCompXCom] DEFAULT ('') FOR [IDCompXCom],
	CONSTRAINT [DF_RISUXCOM_RisUmana] DEFAULT ('') FOR [RisUmana],
	CONSTRAINT [DF_RISUXCOM_DsRisUmana] DEFAULT ('') FOR [DsRisUmana],
	CONSTRAINT [DF_RISUXCOM_FigProf] DEFAULT ('') FOR [FigProf],
	CONSTRAINT [DF_RISUXCOM_DsFigProf] DEFAULT ('') FOR [DsFigProf],
	CONSTRAINT [DF_RISUXCOM_AnaAzi] DEFAULT ('') FOR [AnaAzi],
	CONSTRAINT [DF_RISUXCOM_DsAnaAzi] DEFAULT ('') FOR [DsAnaAzi],
	CONSTRAINT [DF_RISUXCOM_Comune] DEFAULT ('') FOR [Comune],
	CONSTRAINT [DF_RISUXCOM_Provin] DEFAULT ('') FOR [Provin],
	CONSTRAINT [DF_RISUXCOM_D_InizioSch] DEFAULT ('') FOR [D_InizioSch],
	CONSTRAINT [DF_RISUXCOM_D_FineSch] DEFAULT ('') FOR [D_FineSch],
	CONSTRAINT [DF_RISUXCOM_D_InizioEff] DEFAULT ('') FOR [D_InizioEff],
	CONSTRAINT [DF_RISUXCOM_D_FineEff] DEFAULT ('') FOR [D_FineEff],
	CONSTRAINT [DF_RISUXCOM_CostoGUMed] DEFAULT (0) FOR [CostoGUMed],
	CONSTRAINT [DF_RISUXCOM_RicavoGUMed] DEFAULT (0) FOR [RicavoGUMed],
	CONSTRAINT [DF_RISUXCOM_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_RISUXCOM_B_chiuso] DEFAULT (0) FOR [B_chiuso],
	CONSTRAINT [DF_RISUXCOM_Sequen] DEFAULT (0) FOR [Sequen]
GO

