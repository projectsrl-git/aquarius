if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TIMESHT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TIMESHT]
GO
 
CREATE TABLE [dbo].[TIMESHT] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDTimeSht varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDRisUmana varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCommessa varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCompXCom varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTipoOra varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDDettOra varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	Data varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	Minuti numeric(10,0) NULL ,
	Ore numeric(10,0) NULL ,
	Anno varchar(04) COLLATE Latin1_General_CI_AS NULL ,
	Mese varchar(02) COLLATE Latin1_General_CI_AS NULL ,
	Codris varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	Desris varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	TipoOra varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	DettOra varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	Commessa varchar(25) COLLATE Latin1_General_CI_AS NULL ,
	CompComm varchar(02) COLLATE Latin1_General_CI_AS NULL ,
	DsCompComm varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	B_Bloccato bit NULL ,
	Annotazioni text COLLATE Latin1_General_CI_AS NULL ,
	UtenteIns varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataIns varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	UtenteMod varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataMod varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	FlgFatt bit NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TIMESHT] WITH NOCHECK ADD 
	CONSTRAINT [PK_TIMESHT] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TIMESHT] WITH NOCHECK ADD 
	CONSTRAINT [DF_TIMESHT_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_TIMESHT_IDTimeSht] DEFAULT ('') FOR [IDTimeSht],
	CONSTRAINT [DF_TIMESHT_IDRisUmana] DEFAULT ('') FOR [IDRisUmana],
	CONSTRAINT [DF_TIMESHT_IDCommessa] DEFAULT ('') FOR [IDCommessa],
	CONSTRAINT [DF_TIMESHT_IDCompXCom] DEFAULT ('') FOR [IDCompXCom],
	CONSTRAINT [DF_TIMESHT_IDTipoOra] DEFAULT ('') FOR [IDTipoOra],
	CONSTRAINT [DF_TIMESHT_IDDettOra] DEFAULT ('') FOR [IDDettOra],
	CONSTRAINT [DF_TIMESHT_Data] DEFAULT ('') FOR [Data],
	CONSTRAINT [DF_TIMESHT_Minuti] DEFAULT (0) FOR [Minuti],
	CONSTRAINT [DF_TIMESHT_Ore] DEFAULT (0) FOR [Ore],
	CONSTRAINT [DF_TIMESHT_Anno] DEFAULT ('') FOR [Anno],
	CONSTRAINT [DF_TIMESHT_Mese] DEFAULT ('') FOR [Mese],
	CONSTRAINT [DF_TIMESHT_Codris] DEFAULT ('') FOR [Codris],
	CONSTRAINT [DF_TIMESHT_Desris] DEFAULT ('') FOR [Desris],
	CONSTRAINT [DF_TIMESHT_TipoOra] DEFAULT ('') FOR [TipoOra],
	CONSTRAINT [DF_TIMESHT_DettOra] DEFAULT ('') FOR [DettOra],
	CONSTRAINT [DF_TIMESHT_Commessa] DEFAULT ('') FOR [Commessa],
	CONSTRAINT [DF_TIMESHT_CompComm] DEFAULT ('') FOR [CompComm],
	CONSTRAINT [DF_TIMESHT_DsCompComm] DEFAULT ('') FOR [DsCompComm],
	CONSTRAINT [DF_TIMESHT_B_Bloccato] DEFAULT (0) FOR [B_Bloccato],
	CONSTRAINT [DF_TIMESHT_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_TIMESHT_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_TIMESHT_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_TIMESHT_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_TIMESHT_D_DataMod] DEFAULT ('') FOR [D_DataMod],
	CONSTRAINT [DF_TIMESHT_FlgFatt] DEFAULT (0) FOR [FlgFatt]
GO

