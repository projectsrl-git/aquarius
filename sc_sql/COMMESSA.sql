if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COMMESSA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[COMMESSA]
GO
 
CREATE TABLE [dbo].[COMMESSA] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDCommessa varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	TrattCom varchar(25) COLLATE Latin1_General_CI_AS NULL ,
	D_TrattCom varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	RisUResp varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	CentrComP varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	CentrCom varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	AreaMerc varchar(3) COLLATE Latin1_General_CI_AS NULL ,
	ClassTC varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	B_Interna numeric(1,0) NULL ,
	B_ClienteSn bit NULL ,
	Codice varchar(25) COLLATE Latin1_General_CI_AS NULL ,
	D_Data varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	D_Inizio varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	D_Fine varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	Titolo varchar(255) COLLATE Latin1_General_CI_AS NULL ,
	Annotazioni text COLLATE Latin1_General_CI_AS NULL ,
	UtenteIns varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataIns varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	UtenteMod varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataMod varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	B_Chiusa bit NULL ,
	B_Saldata bit NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[COMMESSA] WITH NOCHECK ADD 
	CONSTRAINT [PK_COMMESSA] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[COMMESSA] WITH NOCHECK ADD 
	CONSTRAINT [DF_COMMESSA_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_COMMESSA_IDCommessa] DEFAULT ('') FOR [IDCommessa],
	CONSTRAINT [DF_COMMESSA_TrattCom] DEFAULT ('') FOR [TrattCom],
	CONSTRAINT [DF_COMMESSA_D_TrattCom] DEFAULT ('') FOR [D_TrattCom],
	CONSTRAINT [DF_COMMESSA_RisUResp] DEFAULT ('') FOR [RisUResp],
	CONSTRAINT [DF_COMMESSA_CentrComP] DEFAULT ('') FOR [CentrComP],
	CONSTRAINT [DF_COMMESSA_CentrCom] DEFAULT ('') FOR [CentrCom],
	CONSTRAINT [DF_COMMESSA_AreaMerc] DEFAULT ('') FOR [AreaMerc],
	CONSTRAINT [DF_COMMESSA_ClassTC] DEFAULT ('') FOR [ClassTC],
	CONSTRAINT [DF_COMMESSA_B_Interna] DEFAULT (0) FOR [B_Interna],
	CONSTRAINT [DF_COMMESSA_B_ClienteSn] DEFAULT (0) FOR [B_ClienteSn],
	CONSTRAINT [DF_COMMESSA_Codice] DEFAULT ('') FOR [Codice],
	CONSTRAINT [DF_COMMESSA_D_Data] DEFAULT ('') FOR [D_Data],
	CONSTRAINT [DF_COMMESSA_D_Inizio] DEFAULT ('') FOR [D_Inizio],
	CONSTRAINT [DF_COMMESSA_D_Fine] DEFAULT ('') FOR [D_Fine],
	CONSTRAINT [DF_COMMESSA_Titolo] DEFAULT ('') FOR [Titolo],
	CONSTRAINT [DF_COMMESSA_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_COMMESSA_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_COMMESSA_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_COMMESSA_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_COMMESSA_D_DataMod] DEFAULT ('') FOR [D_DataMod],
	CONSTRAINT [DF_COMMESSA_B_Chiusa] DEFAULT (0) FOR [B_Chiusa],
	CONSTRAINT [DF_COMMESSA_B_Saldata] DEFAULT (0) FOR [B_Saldata]
GO

