if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[CLIENTIC]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[CLIENTIC]
GO
 
CREATE TABLE [dbo].[CLIENTIC] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDCommessaC varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	CodCli varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	RagSoc varchar(80) COLLATE Latin1_General_CI_AS NULL ,
	Indiri varchar(80) COLLATE Latin1_General_CI_AS NULL ,
	Locali varchar(80) COLLATE Latin1_General_CI_AS NULL ,
	Cap varchar(05) COLLATE Latin1_General_CI_AS NULL ,
	Provin varchar(02) COLLATE Latin1_General_CI_AS NULL ,
	IDPartecip varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	Sequen numeric(10,0) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[CLIENTIC] WITH NOCHECK ADD 
	CONSTRAINT [PK_CLIENTIC] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[CLIENTIC] WITH NOCHECK ADD 
	CONSTRAINT [DF_CLIENTIC_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_CLIENTIC_IDCommessaC] DEFAULT ('') FOR [IDCommessaC],
	CONSTRAINT [DF_CLIENTIC_CodCli] DEFAULT ('') FOR [CodCli],
	CONSTRAINT [DF_CLIENTIC_RagSoc] DEFAULT ('') FOR [RagSoc],
	CONSTRAINT [DF_CLIENTIC_Indiri] DEFAULT ('') FOR [Indiri],
	CONSTRAINT [DF_CLIENTIC_Locali] DEFAULT ('') FOR [Locali],
	CONSTRAINT [DF_CLIENTIC_Cap] DEFAULT ('') FOR [Cap],
	CONSTRAINT [DF_CLIENTIC_Provin] DEFAULT ('') FOR [Provin],
	CONSTRAINT [DF_CLIENTIC_IDPartecip] DEFAULT ('') FOR [IDPartecip],
	CONSTRAINT [DF_CLIENTIC_Sequen] DEFAULT (0) FOR [Sequen]
GO

