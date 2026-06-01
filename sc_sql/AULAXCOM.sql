if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AULAXCOM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[AULAXCOM]
GO
 
CREATE TABLE [dbo].[AULAXCOM] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDCompXCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	Aula varchar(15) COLLATE Latin1_General_CI_AS NULL ,
	Nome varchar(100) COLLATE Latin1_General_CI_AS NULL ,
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

ALTER TABLE [dbo].[AULAXCOM] WITH NOCHECK ADD 
	CONSTRAINT [PK_AULAXCOM] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[AULAXCOM] WITH NOCHECK ADD 
	CONSTRAINT [DF_AULAXCOM_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_AULAXCOM_IDCompXCom] DEFAULT ('') FOR [IDCompXCom],
	CONSTRAINT [DF_AULAXCOM_Aula] DEFAULT ('') FOR [Aula],
	CONSTRAINT [DF_AULAXCOM_Nome] DEFAULT ('') FOR [Nome],
	CONSTRAINT [DF_AULAXCOM_D_InizioSch] DEFAULT ('') FOR [D_InizioSch],
	CONSTRAINT [DF_AULAXCOM_D_FineSch] DEFAULT ('') FOR [D_FineSch],
	CONSTRAINT [DF_AULAXCOM_D_InizioEff] DEFAULT ('') FOR [D_InizioEff],
	CONSTRAINT [DF_AULAXCOM_D_FineEff] DEFAULT ('') FOR [D_FineEff],
	CONSTRAINT [DF_AULAXCOM_CostoGUMed] DEFAULT (0) FOR [CostoGUMed],
	CONSTRAINT [DF_AULAXCOM_RicavoGUMed] DEFAULT (0) FOR [RicavoGUMed],
	CONSTRAINT [DF_AULAXCOM_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_AULAXCOM_B_chiuso] DEFAULT (0) FOR [B_chiuso],
	CONSTRAINT [DF_AULAXCOM_Sequen] DEFAULT (0) FOR [Sequen]
GO

