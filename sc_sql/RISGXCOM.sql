if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[RISGXCOM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[RISGXCOM]
GO
 
CREATE TABLE [dbo].[RISGXCOM] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDCompXCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	RisGener varchar(05) COLLATE Latin1_General_CI_AS NULL ,
	DsRisGener varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	B_Vendita bit NULL,
	B_Noleggio bit NULL,
	B_Licenza bit NULL,
	D_InizioSch varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	D_FineSch varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	D_InizioEff varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	D_FineEff varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	CostoGUMed numeric(17,6) NULL ,
	RicavoGUMed numeric(17,6) NULL ,
	Quantita numeric(17,6) NULL ,
	Annotazioni varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	B_chiuso bit NULL,
	Sequen numeric(10,0) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[RISGXCOM] WITH NOCHECK ADD 
	CONSTRAINT [PK_RISGXCOM] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[RISGXCOM] WITH NOCHECK ADD 
	CONSTRAINT [DF_RISGXCOM_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_RISGXCOM_IDCompXCom] DEFAULT ('') FOR [IDCompXCom],
	CONSTRAINT [DF_RISGXCOM_RisGener] DEFAULT ('') FOR [RisGener],
	CONSTRAINT [DF_RISGXCOM_DsRisGener] DEFAULT ('') FOR [DsRisGener],
	CONSTRAINT [DF_RISGXCOM_B_Vendita] DEFAULT (0) FOR [B_Vendita],
	CONSTRAINT [DF_RISGXCOM_B_Noleggio] DEFAULT (0) FOR [B_Noleggio],
	CONSTRAINT [DF_RISGXCOM_B_Licenza] DEFAULT (0) FOR [B_Licenza],
	CONSTRAINT [DF_RISGXCOM_D_InizioSch] DEFAULT ('') FOR [D_InizioSch],
	CONSTRAINT [DF_RISGXCOM_D_FineSch] DEFAULT ('') FOR [D_FineSch],
	CONSTRAINT [DF_RISGXCOM_D_InizioEff] DEFAULT ('') FOR [D_InizioEff],
	CONSTRAINT [DF_RISGXCOM_D_FineEff] DEFAULT ('') FOR [D_FineEff],
	CONSTRAINT [DF_RISGXCOM_CostoGUMed] DEFAULT (0) FOR [CostoGUMed],
	CONSTRAINT [DF_RISGXCOM_RicavoGUMed] DEFAULT (0) FOR [RicavoGUMed],
	CONSTRAINT [DF_RISGXCOM_Quantita] DEFAULT (0) FOR [Quantita],
	CONSTRAINT [DF_RISGXCOM_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_RISGXCOM_B_chiuso] DEFAULT (0) FOR [B_chiuso],
	CONSTRAINT [DF_RISGXCOM_Sequen] DEFAULT (0) FOR [Sequen]
GO

