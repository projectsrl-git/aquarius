if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TRATTCOM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[TRATTCOM]
GO

CREATE TABLE [dbo].[TRATTCOM] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[TAGGANCIO] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[Codice] [varchar] (25) COLLATE Latin1_General_CI_AS NULL ,
	[IDTrattCPre] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDCentrCom] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDAreaMerc] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDClassTC] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDRisUResp] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDRisUAutor] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDAnaAzi] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[Stato] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[Titolo] [varchar] (255) COLLATE Latin1_General_CI_AS NULL ,
	[D_Apertura] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[Annotazioni] [text] COLLATE Latin1_General_CI_AS NULL ,
	[Ricalter] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[D_Chiusura] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[Esito] [text] COLLATE Latin1_General_CI_AS NULL ,
	[MotivazEsit] [text] COLLATE Latin1_General_CI_AS NULL ,
	[NoteChiusur] [text] COLLATE Latin1_General_CI_AS NULL ,
	[UtenteIns] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[D_DataIns] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[UtenteMod] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[D_DataMod] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[FLAG_CF] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[OREGG] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[UMCOSTO] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[UMRICAVO] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[VALCOSTO] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[VALRICAVO] [varchar] (1) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[TRATTCOM] WITH NOCHECK ADD 
	CONSTRAINT [PK_TRATTCOM] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TRATTCOM] WITH NOCHECK ADD 
	CONSTRAINT [DF_TRATTCOM_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_TRATTCOM_TAGGANCIO] DEFAULT ('') FOR [TAGGANCIO],
	CONSTRAINT [DF_TRATTCOM_Codice] DEFAULT ('') FOR [Codice],
	CONSTRAINT [DF_TRATTCOM_IDTrattCPre] DEFAULT ('') FOR [IDTrattCPre],
	CONSTRAINT [DF_TRATTCOM_IDCentrCom] DEFAULT ('') FOR [IDCentrCom],
	CONSTRAINT [DF_TRATTCOM_IDAreaMerc] DEFAULT ('') FOR [IDAreaMerc],
	CONSTRAINT [DF_TRATTCOM_IDClassTC] DEFAULT ('') FOR [IDClassTC],
	CONSTRAINT [DF_TRATTCOM_IDRisUResp] DEFAULT ('') FOR [IDRisUResp],
	CONSTRAINT [DF_TRATTCOM_IDRisUAutor] DEFAULT ('') FOR [IDRisUAutor],
	CONSTRAINT [DF_TRATTCOM_IDAnaAzi] DEFAULT ('') FOR [IDAnaAzi],
	CONSTRAINT [DF_TRATTCOM_Stato] DEFAULT ('') FOR [Stato],
	CONSTRAINT [DF_TRATTCOM_Titolo] DEFAULT ('') FOR [Titolo],
	CONSTRAINT [DF_TRATTCOM_D_Apertura] DEFAULT ('') FOR [D_Apertura],
	CONSTRAINT [DF_TRATTCOM_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_TRATTCOM_Ricalter] DEFAULT ('') FOR [Ricalter],
	CONSTRAINT [DF_TRATTCOM_D_Chiusura] DEFAULT ('') FOR [D_Chiusura],
	CONSTRAINT [DF_TRATTCOM_Esito] DEFAULT ('') FOR [Esito],
	CONSTRAINT [DF_TRATTCOM_MotivazEsit] DEFAULT ('') FOR [MotivazEsit],
	CONSTRAINT [DF_TRATTCOM_NoteChiusur] DEFAULT ('') FOR [NoteChiusur],
	CONSTRAINT [DF_TRATTCOM_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_TRATTCOM_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_TRATTCOM_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_TRATTCOM_D_DataMod] DEFAULT ('') FOR [D_DataMod],
	CONSTRAINT [DF_TRATTCOM_FLAG_CF] DEFAULT ('') FOR [FLAG_CF],
	CONSTRAINT [DF_TRATTCOM_OREGG] DEFAULT ('') FOR [OREGG],
	CONSTRAINT [DF_TRATTCOM_UMCOSTO] DEFAULT ('') FOR [UMCOSTO],
	CONSTRAINT [DF_TRATTCOM_UMRICAVO] DEFAULT ('') FOR [UMRICAVO],
	CONSTRAINT [DF_TRATTCOM_VALCOSTO] DEFAULT ('') FOR [VALCOSTO],
	CONSTRAINT [DF_TRATTCOM_VALRICAVO] DEFAULT ('') FOR [VALRICAVO]
GO

