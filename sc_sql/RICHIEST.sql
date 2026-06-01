if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[Richiest]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[Richiest]
GO

CREATE TABLE [dbo].[Richiest] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[TAGGANCIO] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[Codice] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[IDRisUmaRIR] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[IDAnaAziRic] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[AnaAziRic] [varchar] (80) COLLATE Latin1_General_CI_AS NULL ,
	[CFAnaAziRic] [char] (1) COLLATE Latin1_General_CI_AS NULL ,
	[IDRiferim] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[IDAnaAziRefI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[AnaAziRefI] [varchar] (80) COLLATE Latin1_General_CI_AS NULL ,
	[CFAnaAziRefI] [char] (1) COLLATE Latin1_General_CI_AS NULL ,
	[IDRiferRefI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[IDAnaAzCliF] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[AnaAzCliF] [varchar] (80) COLLATE Latin1_General_CI_AS NULL ,
	[CFAnaAzCliF] [char] (1) COLLATE Latin1_General_CI_AS NULL ,
	[IDStatoRic] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[D_DataRich] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[D_Scadenza] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[SedeLavor] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[Descrizione] [text] COLLATE Latin1_General_CI_AS NULL ,
	[Nrisorse] [numeric](3, 0) NULL ,
	[Ricalter] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[UtenteIns] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[D_DataIns] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[UtenteMod] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[D_DataMod] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[FLAG_TIPO] [varchar] (1) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[Richiest] WITH NOCHECK ADD 
	CONSTRAINT [PK_Richiest] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[Richiest] WITH NOCHECK ADD 
	CONSTRAINT [DF_Richiest_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_Richiest_TAGGANCIO] DEFAULT ('') FOR [TAGGANCIO],
	CONSTRAINT [DF_Richiest_Codice] DEFAULT ('') FOR [Codice],
	CONSTRAINT [DF_Richiest_IDRisUmaRIR] DEFAULT ('') FOR [IDRisUmaRIR],
	CONSTRAINT [DF_Richiest_IDAnaAziRic] DEFAULT ('') FOR [IDAnaAziRic],
	CONSTRAINT [DF_Richiest_AnaAziRic] DEFAULT ('') FOR [AnaAziRic],
	CONSTRAINT [DF_Richiest_CFAnaAziRic] DEFAULT ('') FOR [CFAnaAziRic],
	CONSTRAINT [DF_Richiest_IDRiferim] DEFAULT ('') FOR [IDRiferim],
	CONSTRAINT [DF_Richiest_IDAnaAziRefI] DEFAULT ('') FOR [IDAnaAziRefI],
	CONSTRAINT [DF_Richiest_AnaAziRefI] DEFAULT ('') FOR [AnaAziRefI],
	CONSTRAINT [DF_Richiest_CFAnaAziRefI] DEFAULT ('') FOR [CFAnaAziRefI],
	CONSTRAINT [DF_Richiest_IDRiferRefI] DEFAULT ('') FOR [IDRiferRefI],
	CONSTRAINT [DF_Richiest_IDAnaAzCliF] DEFAULT ('') FOR [IDAnaAzCliF],
	CONSTRAINT [DF_Richiest_AnaAzCliF] DEFAULT ('') FOR [AnaAzCliF],
	CONSTRAINT [DF_Richiest_CFAnaAzCliF] DEFAULT ('') FOR [CFAnaAzCliF],
	CONSTRAINT [DF_Richiest_IDStatoRic] DEFAULT ('') FOR [IDStatoRic],
	CONSTRAINT [DF_Richiest_D_DataRich] DEFAULT ('') FOR [D_DataRich],
	CONSTRAINT [DF_Richiest_D_Scadenza] DEFAULT ('') FOR [D_Scadenza],
	CONSTRAINT [DF_Richiest_SedeLavor] DEFAULT ('') FOR [SedeLavor],
	CONSTRAINT [DF_Richiest_Descrizione] DEFAULT ('') FOR [Descrizione],
	CONSTRAINT [DF_Richiest_Nrisorse] DEFAULT (0) FOR [Nrisorse],
	CONSTRAINT [DF_Richiest_Ricalter] DEFAULT ('') FOR [Ricalter],
	CONSTRAINT [DF_Richiest_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_Richiest_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_Richiest_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_Richiest_D_DataMod] DEFAULT ('') FOR [D_DataMod],
	CONSTRAINT [DF_RICHIEST_FLAG_TIPO] DEFAULT ('') FOR [FLAG_TIPO]
GO

