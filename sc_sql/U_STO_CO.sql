if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_sto_co]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_sto_co]
GO
 
CREATE TABLE [dbo].[u_sto_co] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[STO_ANNO] [varchar] (04) COLLATE Latin1_General_CI_AS NULL ,
	[STO_MESE] [varchar] (02) COLLATE Latin1_General_CI_AS NULL ,
	[STO_QTAITA] [numeric] (17,2) NULL ,
	[STO_VALITA] [numeric] (17,2) NULL ,
	[STO_QTAEXP] [numeric] (17,2) NULL ,
	[STO_VALEXP] [numeric] (17,2) NULL ,
	[STO_POLIEC] [bit] NULL ,
	[STO_ELABDA] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[STO_ELABAL] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[STO_DATSTO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[STO_ORASTO] [varchar] (08) COLLATE Latin1_General_CI_AS NULL ,
	[STO_CODOPE] [varchar] (03) COLLATE Latin1_General_CI_AS NULL ,
	[STO_DESOPE] [varchar] (50) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[u_sto_co] WITH NOCHECK ADD 
	CONSTRAINT [PK_u_sto_co] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[u_sto_co] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_sto_co_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_sto_co_STO_ANNO] DEFAULT ('') FOR [STO_ANNO],
	CONSTRAINT [DF_u_sto_co_STO_MESE] DEFAULT ('') FOR [STO_MESE],
	CONSTRAINT [DF_u_sto_co_STO_QTAITA] DEFAULT (0) FOR [STO_QTAITA],
	CONSTRAINT [DF_u_sto_co_STO_VALITA] DEFAULT (0) FOR [STO_VALITA],
	CONSTRAINT [DF_u_sto_co_STO_QTAEXP] DEFAULT (0) FOR [STO_QTAEXP],
	CONSTRAINT [DF_u_sto_co_STO_VALEXP] DEFAULT (0) FOR [STO_VALEXP],
	CONSTRAINT [DF_u_sto_co_STO_POLIEC] DEFAULT (0) FOR [STO_POLIEC],
	CONSTRAINT [DF_u_sto_co_STO_ELABDA] DEFAULT ('') FOR [STO_ELABDA],
	CONSTRAINT [DF_u_sto_co_STO_ELABAL] DEFAULT ('') FOR [STO_ELABAL],
	CONSTRAINT [DF_u_sto_co_STO_DATSTO] DEFAULT ('') FOR [STO_DATSTO],
	CONSTRAINT [DF_u_sto_co_STO_ORASTO] DEFAULT ('') FOR [STO_ORASTO],
	CONSTRAINT [DF_u_sto_co_STO_CODOPE] DEFAULT ('') FOR [STO_CODOPE],
	CONSTRAINT [DF_u_sto_co_STO_DESOPE] DEFAULT ('') FOR [STO_DESOPE]
GO

