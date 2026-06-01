if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[DETTORA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[DETTORA]
GO
 
CREATE TABLE [dbo].[DETTORA] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDDettOra varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	IDTipoOra varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	Nome varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	UtenteIns varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataIns varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	UtenteMod varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataMod varchar(10) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[DETTORA] WITH NOCHECK ADD 
	CONSTRAINT [PK_DETTORA] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[DETTORA] WITH NOCHECK ADD 
	CONSTRAINT [DF_DETTORA_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_DETTORA_IDDettOra] DEFAULT ('') FOR [IDDettOra],
	CONSTRAINT [DF_DETTORA_IDTipoOra] DEFAULT ('') FOR [IDTipoOra],
	CONSTRAINT [DF_DETTORA_Nome] DEFAULT ('') FOR [Nome],
	CONSTRAINT [DF_DETTORA_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_DETTORA_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_DETTORA_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_DETTORA_D_DataMod] DEFAULT ('') FOR [D_DataMod]
GO

