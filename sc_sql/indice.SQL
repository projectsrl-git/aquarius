if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[indice]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[indice]
GO
 
CREATE TABLE [dbo].[indice] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[MOV_SOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_ANNO] [varchar] (4) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_DTDOC] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_NDOC] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_DTREG] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_NREGIS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_CONTO] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_TOP] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_TMOV] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_IMP] [numeric] (17,3) NULL ,
	[MOV_NPROT] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_MODPAG] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_IVA] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_IMPOST] [numeric] (17,3) NULL ,
	[MOV_IMPORT] [numeric] (17,3) NULL ,
	[MOV_NUMPRO] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_FLG] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_DESMOV] [varchar] (45) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_DESMO1] [varchar] (45) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_SALDO] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_NPART] [numeric] (10,0) NULL ,
	[MOV_PROGPA] [numeric] (5,0) NULL ,
	[MOV_FATRI] [bit] NULL ,
	[MOV_NOTE] [text] COLLATE Latin1_General_CI_AS NULL ,
	[MOV_CODNOT] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_CAMBIO] [numeric] (15,10) NULL ,
	[MOV_IMPVAL] [numeric] (11,4) NULL ,
	[MOV_VALUTA] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_DTVAL] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_SYS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[SELEZIONE] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_PESO] [numeric] (10,2) NULL ,
	[MOV_TISPE] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_PORTO] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_CLDOG] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[MOV_BANCA] [varchar] (5) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[indice] WITH NOCHECK ADD 
	CONSTRAINT [PK_indice] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[indice] WITH NOCHECK ADD 
	CONSTRAINT [DF_indice_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_indice_MOV_SOC] DEFAULT ('') FOR [MOV_SOC],
	CONSTRAINT [DF_indice_MOV_ANNO] DEFAULT ('') FOR [MOV_ANNO],
	CONSTRAINT [DF_indice_MOV_DTDOC] DEFAULT ('') FOR [MOV_DTDOC],
	CONSTRAINT [DF_indice_MOV_NDOC] DEFAULT ('') FOR [MOV_NDOC],
	CONSTRAINT [DF_indice_MOV_DTREG] DEFAULT ('') FOR [MOV_DTREG],
	CONSTRAINT [DF_indice_MOV_NREGIS] DEFAULT ('') FOR [MOV_NREGIS],
	CONSTRAINT [DF_indice_MOV_CONTO] DEFAULT ('') FOR [MOV_CONTO],
	CONSTRAINT [DF_indice_MOV_TOP] DEFAULT ('') FOR [MOV_TOP],
	CONSTRAINT [DF_indice_MOV_TMOV] DEFAULT ('') FOR [MOV_TMOV],
	CONSTRAINT [DF_indice_MOV_IMP] DEFAULT (0) FOR [MOV_IMP],
	CONSTRAINT [DF_indice_MOV_NPROT] DEFAULT ('') FOR [MOV_NPROT],
	CONSTRAINT [DF_indice_MOV_MODPAG] DEFAULT ('') FOR [MOV_MODPAG],
	CONSTRAINT [DF_indice_MOV_IVA] DEFAULT ('') FOR [MOV_IVA],
	CONSTRAINT [DF_indice_MOV_IMPOST] DEFAULT (0) FOR [MOV_IMPOST],
	CONSTRAINT [DF_indice_MOV_IMPORT] DEFAULT (0) FOR [MOV_IMPORT],
	CONSTRAINT [DF_indice_MOV_NUMPRO] DEFAULT ('') FOR [MOV_NUMPRO],
	CONSTRAINT [DF_indice_MOV_FLG] DEFAULT ('') FOR [MOV_FLG],
	CONSTRAINT [DF_indice_MOV_DESMOV] DEFAULT ('') FOR [MOV_DESMOV],
	CONSTRAINT [DF_indice_MOV_DESMO1] DEFAULT ('') FOR [MOV_DESMO1],
	CONSTRAINT [DF_indice_MOV_SALDO] DEFAULT ('') FOR [MOV_SALDO],
	CONSTRAINT [DF_indice_MOV_NPART] DEFAULT (0) FOR [MOV_NPART],
	CONSTRAINT [DF_indice_MOV_PROGPA] DEFAULT (0) FOR [MOV_PROGPA],
	CONSTRAINT [DF_indice_MOV_FATRI] DEFAULT (0) FOR [MOV_FATRI],
	CONSTRAINT [DF_indice_MOV_NOTE] DEFAULT ('') FOR [MOV_NOTE],
	CONSTRAINT [DF_indice_MOV_CODNOT] DEFAULT ('') FOR [MOV_CODNOT],
	CONSTRAINT [DF_indice_MOV_CAMBIO] DEFAULT (0) FOR [MOV_CAMBIO],
	CONSTRAINT [DF_indice_MOV_IMPVAL] DEFAULT (0) FOR [MOV_IMPVAL],
	CONSTRAINT [DF_indice_MOV_VALUTA] DEFAULT ('') FOR [MOV_VALUTA],
	CONSTRAINT [DF_indice_MOV_DTVAL] DEFAULT ('') FOR [MOV_DTVAL],
	CONSTRAINT [DF_indice_MOV_SYS] DEFAULT ('') FOR [MOV_SYS],
	CONSTRAINT [DF_indice_SELEZIONE] DEFAULT ('') FOR [SELEZIONE],
	CONSTRAINT [DF_indice_MOV_PESO] DEFAULT (0) FOR [MOV_PESO],
	CONSTRAINT [DF_indice_MOV_TISPE] DEFAULT ('') FOR [MOV_TISPE],
	CONSTRAINT [DF_indice_MOV_PORTO] DEFAULT ('') FOR [MOV_PORTO],
	CONSTRAINT [DF_indice_MOV_CLDOG] DEFAULT ('') FOR [MOV_CLDOG],
	CONSTRAINT [DF_indice_MOV_BANCA] DEFAULT ('') FOR [MOV_BANCA]
GO

