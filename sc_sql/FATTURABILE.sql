if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[FATTURABILE]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[FATTURABILE]
GO
 
CREATE TABLE [dbo].[FATTURABILE] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDFatturabile varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDCommessa varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	TrattCom varchar(25) COLLATE Latin1_General_CI_AS NULL ,
	D_TrattCom varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	RisUResp varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	DsRisUResp varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	CentrComP varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	DsCentrComP varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	CentrCom varchar(5) COLLATE Latin1_General_CI_AS NULL ,
	DsCentrCom varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	AreaMerc varchar(3) COLLATE Latin1_General_CI_AS NULL ,
	DsAreaMerc varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	ClassTC varchar(2) COLLATE Latin1_General_CI_AS NULL ,
	DsClassTC varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	B_Interna numeric(1,0) NULL ,
	B_ClienteSn bit NULL ,
	Codice varchar(25) COLLATE Latin1_General_CI_AS NULL ,
	D_Data varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	D_Inizio varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	D_Fine varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	Titolo varchar(255) COLLATE Latin1_General_CI_AS NULL ,
	Annotazioni text COLLATE Latin1_General_CI_AS NULL ,
	B_Chiusa bit NULL ,
	B_Saldata bit NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[FATTURABILE] WITH NOCHECK ADD 
	CONSTRAINT [PK_FATTURABILE] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[FATTURABILE] WITH NOCHECK ADD 
	CONSTRAINT [DF_FATTURABILE_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_FATTURABILE_IDFatturabile] DEFAULT ('') FOR [IDFatturabile],
	CONSTRAINT [DF_FATTURABILE_IDCommessa] DEFAULT ('') FOR [IDCommessa],
	CONSTRAINT [DF_FATTURABILE_TrattCom] DEFAULT ('') FOR [TrattCom],
	CONSTRAINT [DF_FATTURABILE_D_TrattCom] DEFAULT ('') FOR [D_TrattCom],
	CONSTRAINT [DF_FATTURABILE_RisUResp] DEFAULT ('') FOR [RisUResp],
	CONSTRAINT [DF_FATTURABILE_DsRisUResp] DEFAULT ('') FOR [DsRisUResp],
	CONSTRAINT [DF_FATTURABILE_CentrComP] DEFAULT ('') FOR [CentrComP],
	CONSTRAINT [DF_FATTURABILE_DsCentrComP] DEFAULT ('') FOR [DsCentrComP],
	CONSTRAINT [DF_FATTURABILE_CentrCom] DEFAULT ('') FOR [CentrCom],
	CONSTRAINT [DF_FATTURABILE_DsCentrCom] DEFAULT ('') FOR [DsCentrCom],
	CONSTRAINT [DF_FATTURABILE_AreaMerc] DEFAULT ('') FOR [AreaMerc],
	CONSTRAINT [DF_FATTURABILE_DsAreaMerc] DEFAULT ('') FOR [DsAreaMerc],
	CONSTRAINT [DF_FATTURABILE_ClassTC] DEFAULT ('') FOR [ClassTC],
	CONSTRAINT [DF_FATTURABILE_DsClassTC] DEFAULT ('') FOR [DsClassTC],
	CONSTRAINT [DF_FATTURABILE_B_Interna] DEFAULT (0) FOR [B_Interna],
	CONSTRAINT [DF_FATTURABILE_B_ClienteSn] DEFAULT (0) FOR [B_ClienteSn],
	CONSTRAINT [DF_FATTURABILE_Codice] DEFAULT ('') FOR [Codice],
	CONSTRAINT [DF_FATTURABILE_D_Data] DEFAULT ('') FOR [D_Data],
	CONSTRAINT [DF_FATTURABILE_D_Inizio] DEFAULT ('') FOR [D_Inizio],
	CONSTRAINT [DF_FATTURABILE_D_Fine] DEFAULT ('') FOR [D_Fine],
	CONSTRAINT [DF_FATTURABILE_Titolo] DEFAULT ('') FOR [Titolo],
	CONSTRAINT [DF_FATTURABILE_Annotazioni] DEFAULT ('') FOR [Annotazioni],
	CONSTRAINT [DF_FATTURABILE_B_Chiusa] DEFAULT (0) FOR [B_Chiusa],
	CONSTRAINT [DF_FATTURABILE_B_Saldata] DEFAULT (0) FOR [B_Saldata]
GO

