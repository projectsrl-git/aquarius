if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[IstrForm]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[IstrForm]
GO

CREATE TABLE [dbo].[IstrForm] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[DAGGANCIO] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[ID_ISTRUZIONE] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDLivIstrN] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[IDLivIstrI] [varchar] (32) COLLATE Latin1_General_CI_AS NULL ,
	[D_Inizio_ISTR] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[D_Fine_ISTR] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[Durata] [varchar] (150) COLLATE Latin1_General_CI_AS NULL ,
	[IstitEnteFo] [text] COLLATE Latin1_General_CI_AS NULL ,
	[MatAbilProf] [text] COLLATE Latin1_General_CI_AS NULL ,
	[Qualifica] [varchar] (150) COLLATE Latin1_General_CI_AS NULL ,
	[TemCompProf] [text] COLLATE Latin1_General_CI_AS NULL ,
	[AttestatiFP] [text] COLLATE Latin1_General_CI_AS NULL ,
	[Certificaz] [text] COLLATE Latin1_General_CI_AS NULL ,
	[ORDINE] [numeric](3, 0) NULL ,
	[DIVIDENDO] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[DIVISORE] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[FLAG_PRIMARIO] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[TESI] [varchar] (200) COLLATE Latin1_General_CI_AS NULL ,
	[DESCTESI] [text] COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[IstrForm] WITH NOCHECK ADD 
	CONSTRAINT [PK_IstrForm] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	) WITH  FILLFACTOR = 90  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[IstrForm] WITH NOCHECK ADD 
	CONSTRAINT [DF_IstrForm_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_IstrForm_DAGGANCIO] DEFAULT ('') FOR [DAGGANCIO],
	CONSTRAINT [DF_IstrForm_ID_ISTRUZIONE] DEFAULT ('') FOR [ID_ISTRUZIONE],
	CONSTRAINT [DF_IstrForm_IDLivIstrN] DEFAULT ('') FOR [IDLivIstrN],
	CONSTRAINT [DF_IstrForm_IDLivIstrI] DEFAULT ('') FOR [IDLivIstrI],
	CONSTRAINT [DF_IstrForm_D_Inizio_ISTR] DEFAULT ('') FOR [D_Inizio_ISTR],
	CONSTRAINT [DF_IstrForm_D_Fine_ISTR] DEFAULT ('') FOR [D_Fine_ISTR],
	CONSTRAINT [DF_IstrForm_Durata] DEFAULT ('') FOR [Durata],
	CONSTRAINT [DF_IstrForm_IstitEnteFo] DEFAULT ('') FOR [IstitEnteFo],
	CONSTRAINT [DF_IstrForm_MatAbilProf] DEFAULT ('') FOR [MatAbilProf],
	CONSTRAINT [DF_IstrForm_Qualifica] DEFAULT ('') FOR [Qualifica],
	CONSTRAINT [DF_IstrForm_TemCompProf] DEFAULT ('') FOR [TemCompProf],
	CONSTRAINT [DF_IstrForm_AttestatiFP] DEFAULT ('') FOR [AttestatiFP],
	CONSTRAINT [DF_IstrForm_Certificaz] DEFAULT ('') FOR [Certificaz],
	CONSTRAINT [DF_IstrForm_ORDINE] DEFAULT (0) FOR [ORDINE],
	CONSTRAINT [DF_ISTRFORM_DIVIDENDO] DEFAULT ('') FOR [DIVIDENDO],
	CONSTRAINT [DF_ISTRFORM_DIVISORE] DEFAULT ('') FOR [DIVISORE],
	CONSTRAINT [DF_ISTRFORM_FLAG_PRIMARIO] DEFAULT ('') FOR [FLAG_PRIMARIO],
	CONSTRAINT [DF_ISTRFORM_TESI] DEFAULT ('') FOR [TESI],
	CONSTRAINT [DF_ISTRFORM_DESCTESI] DEFAULT ('') FOR [DESCTESI]
GO

