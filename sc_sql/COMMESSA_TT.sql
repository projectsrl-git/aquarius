if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[COMMESSA_TT]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[COMMESSA_TT]
GO
 
CREATE TABLE [dbo].[COMMESSA_TT] (
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
	B_Saldata bit NULL ,
	FlgCons bit NULL ,
	CodArt_R varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	CodArt_A varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	CodArt_P varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	CodArt_S varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	CodArt_X varchar(16) COLLATE Latin1_General_CI_AS NULL ,
	FlgRegola1 bit NULL ,
	FlgRegola2 bit NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[COMMESSA_TT] WITH NOCHECK ADD 
	CONSTRAINT [PK_COMMESSA_TT] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[COMMESSA_TT] WITH NOCHECK ADD 
	CONSTRAINT [DF_COMMESSA_TT_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_COMMESSA_TT_IDCommessa] DEFAULT ('') FOR [IDCommessa],
	CONSTRAINT [DF_COMMESSA_TT_TrattCom] DEFAULT ('') FOR [TrattCom],
	CONSTRAINT [DF_COMMESSA_TT_D_TrattCom] DEFAULT ('') FOR [D_TrattCom],
	CONSTRAINT [DF_COMMESSA_TT_RisUResp] DEFAULT ('') FOR [RisUResp],
	CONSTRAINT [DF_COMMESSA_TT_CentrComP] DEFAULT ('') FOR [CentrComP],
	CONSTRAINT [DF_COMMESSA_TT_CentrCom] DEFAULT ('') FOR [CentrCom],
	CONSTRAINT [DF_COMMESSA_TT_AreaMerc] DEFAULT ('') FOR [AreaMerc],
	CONSTRAINT [DF_COMMESSA_TT_ClassTC] DEFAULT ('') FOR [ClassTC],
	CONSTRAINT [DF_COMMESSA_TT_B_Interna] DEFAULT (0) FOR [B_Interna],
	CONSTRAINT [DF_COMMESSA_TT_B_ClienteSn] DEFAULT (0) FOR [B_ClienteSn],
	CONSTRAINT [DF_COMMESSA_TT_Codice] DEFAULT ('') FOR [Codice],
	CONSTRAINT [DF_COMMESSA_TT_D_Data] DEFAULT ('') FOR [D_Data],
	CONSTRAINT [DF_COMMESSA_TT_D_Inizio] DEFAULT ('') FOR [D_Inizio],
	CONSTRAINT [DF_COMMESSA_TT_D_Fine] DEFAULT ('') FOR [D_Fine],
	CONSTRAINT [DF_COMMESSA_TT_Titolo] DEFAULT ('') FOR [Titolo],
	CONSTRAINT [DF_COMMESSA_TT_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_COMMESSA_TT_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_COMMESSA_TT_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_COMMESSA_TT_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_COMMESSA_TT_D_DataMod] DEFAULT ('') FOR [D_DataMod],
	CONSTRAINT [DF_COMMESSA_TT_B_Chiusa] DEFAULT (0) FOR [B_Chiusa],
	CONSTRAINT [DF_COMMESSA_TT_B_Saldata] DEFAULT (0) FOR [B_Saldata],
	CONSTRAINT [DF_COMMESSA_TT_FlgCons] DEFAULT (0) FOR [FlgCons],
	CONSTRAINT [DF_COMMESSA_TT_CodArt_R] DEFAULT ('') FOR [CodArt_R],
	CONSTRAINT [DF_COMMESSA_TT_CodArt_A] DEFAULT ('') FOR [CodArt_A],
	CONSTRAINT [DF_COMMESSA_TT_CodArt_P] DEFAULT ('') FOR [CodArt_P],
	CONSTRAINT [DF_COMMESSA_TT_CodArt_S] DEFAULT ('') FOR [CodArt_S],
	CONSTRAINT [DF_COMMESSA_TT_CodArt_X] DEFAULT ('') FOR [CodArt_X],
	CONSTRAINT [DF_COMMESSA_TT_FlgRegola1] DEFAULT (0) FOR [FlgRegola1],
	CONSTRAINT [DF_COMMESSA_TT_FlgRegola2] DEFAULT (0) FOR [FlgRegola2]
GO

