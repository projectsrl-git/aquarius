if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PIANIFIC_COMM]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[PIANIFIC_COMM]
GO
 
CREATE TABLE [dbo].[PIANIFIC_COMM] (
	id_unique  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	IDCommessaD varchar(32) COLLATE Latin1_General_CI_AS NULL ,
	CodAttivita varchar(03) COLLATE Latin1_General_CI_AS NULL ,
	DesAttivita varchar(254) COLLATE Latin1_General_CI_AS NULL ,
	UlterDesAtt text COLLATE Latin1_General_CI_AS NULL ,
	RisImpe text COLLATE Latin1_General_CI_AS NULL ,
	DatIni_P varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	DatFin_P varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	GGtot_P numeric(17,2) NULL ,
	DatIni_C varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	DatFin_C varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	GGtot_C numeric(17,2) NULL ,
	Delta numeric(17,2) NULL ,
	Esito varchar(01) COLLATE Latin1_General_CI_AS NULL ,
	DataEsito varchar(10) COLLATE Latin1_General_CI_AS NULL ,
	Note text COLLATE Latin1_General_CI_AS NULL ,
	Sequen numeric(10,0) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[PIANIFIC_COMM] WITH NOCHECK ADD 
	CONSTRAINT [PK_PIANIFIC_COMM] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PIANIFIC_COMM] WITH NOCHECK ADD 
	CONSTRAINT [DF_PIANIFIC_COMM_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_PIANIFIC_COMM_IDCommessaD] DEFAULT ('') FOR [IDCommessaD],
	CONSTRAINT [DF_PIANIFIC_COMM_CodAttivita] DEFAULT ('') FOR [CodAttivita],
	CONSTRAINT [DF_PIANIFIC_COMM_DesAttivita] DEFAULT ('') FOR [DesAttivita],
	CONSTRAINT [DF_PIANIFIC_COMM_UlterDesAtt] DEFAULT ('') FOR [UlterDesAtt],
	CONSTRAINT [DF_PIANIFIC_COMM_RisImpe] DEFAULT ('') FOR [RisImpe],
	CONSTRAINT [DF_PIANIFIC_COMM_DatIni_P] DEFAULT ('') FOR [DatIni_P],
	CONSTRAINT [DF_PIANIFIC_COMM_DatFin_P] DEFAULT ('') FOR [DatFin_P],
	CONSTRAINT [DF_PIANIFIC_COMM_GGtot_P] DEFAULT (0) FOR [GGtot_P],
	CONSTRAINT [DF_PIANIFIC_COMM_DatIni_C] DEFAULT ('') FOR [DatIni_C],
	CONSTRAINT [DF_PIANIFIC_COMM_DatFin_C] DEFAULT ('') FOR [DatFin_C],
	CONSTRAINT [DF_PIANIFIC_COMM_GGtot_C] DEFAULT (0) FOR [GGtot_C],
	CONSTRAINT [DF_PIANIFIC_COMM_Delta] DEFAULT (0) FOR [Delta],
	CONSTRAINT [DF_PIANIFIC_COMM_Esito] DEFAULT (0) FOR [Esito],
	CONSTRAINT [DF_PIANIFIC_COMM_DataEsito] DEFAULT ('') FOR [DataEsito],
	CONSTRAINT [DF_PIANIFIC_COMM_Note] DEFAULT ('') FOR [Note],
	CONSTRAINT [DF_PIANIFIC_COMM_Sequen] DEFAULT (0) FOR [Sequen]
GO

