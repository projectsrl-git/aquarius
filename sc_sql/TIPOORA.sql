if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[TIPOORA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[TIPOORA]
GO
 
CREATE TABLE [dbo].[TIPOORA] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDTipoOra varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	Nome varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	UtenteIns varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataIns varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	UtenteMod varchar(50) COLLATE Latin1_General_CI_AS NULL ,
	D_DataMod varchar(10) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[TIPOORA] WITH NOCHECK ADD 
	CONSTRAINT [PK_TIPOORA] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[TIPOORA] WITH NOCHECK ADD 
	CONSTRAINT [DF_TIPOORA_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_TIPOORA_IDTipoOra] DEFAULT ('') FOR [IDTipoOra],
	CONSTRAINT [DF_TIPOORA_Nome] DEFAULT ('') FOR [Nome],
	CONSTRAINT [DF_TIPOORA_UtenteIns] DEFAULT ('') FOR [UtenteIns],
	CONSTRAINT [DF_TIPOORA_D_DataIns] DEFAULT ('') FOR [D_DataIns],
	CONSTRAINT [DF_TIPOORA_UtenteMod] DEFAULT ('') FOR [UtenteMod],
	CONSTRAINT [DF_TIPOORA_D_DataMod] DEFAULT ('') FOR [D_DataMod]
GO

