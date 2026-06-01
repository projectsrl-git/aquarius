if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CONTRST_DD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CONTRST_DD]
GO
 
CREATE TABLE [dbo].[CONTRST_DD] (
	id_unique uniqueidentifier ROWGUIDCOL NOT NULL ,
	DAGGANCIO varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	IDATTIVITA varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	Sequen numeric(10,0) NULL ,
	DataInizio varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	DataFine varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	CodAttiv varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	DesAttiv varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	ValCosto numeric(17,2) NULL ,
	ValRicavo numeric(17,2) NULL ,
	ValUtile numeric(17,2) NULL ,
	Annotazioni text NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[CONTRST_DD] WITH NOCHECK ADD 
	CONSTRAINT [PK_CONTRST_DD] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CONTRST_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_CONTRST_DD_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_CONTRST_DD_DAGGANCIO] DEFAULT ('') FOR [DAGGANCIO],
	CONSTRAINT [DF_CONTRST_DD_IDATTIVITA] DEFAULT ('') FOR [IDATTIVITA],
	CONSTRAINT [DF_CONTRST_DD_Sequen] DEFAULT (0) FOR [Sequen],
	CONSTRAINT [DF_CONTRST_DD_DataInizio] DEFAULT ('') FOR [DataInizio],
	CONSTRAINT [DF_CONTRST_DD_DataFine] DEFAULT ('') FOR [DataFine],
	CONSTRAINT [DF_CONTRST_DD_CodAttiv] DEFAULT ('') FOR [CodAttiv],
	CONSTRAINT [DF_CONTRST_DD_DesAttiv] DEFAULT ('') FOR [DesAttiv],
	CONSTRAINT [DF_CONTRST_DD_ValCosto] DEFAULT (0) FOR [ValCosto],
	CONSTRAINT [DF_CONTRST_DD_ValRicavo] DEFAULT (0) FOR [ValRicavo],
	CONSTRAINT [DF_CONTRST_DD_ValUtile] DEFAULT (0) FOR [ValUtile],
	CONSTRAINT [DF_CONTRST_DD_Annotazioni] DEFAULT ('') FOR [Annotazioni]
GO

