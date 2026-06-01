if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[su_prv_an]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[su_prv_an]
GO

CREATE TABLE [dbo].[su_prv_an] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[PRV_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_ANNO] [varchar] (4) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_CODCLI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_RAGSOC] [varchar] (35) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_DATFAT] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_NUMFAT] [varchar] (6) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_TIPODO] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_IMPONI] [numeric](15, 3) NULL ,
	[PRV_PERPRO] [numeric](7, 2) NULL ,
	[PRV_TOTPRO] [numeric](14, 3) NULL ,
	[PRV_CODAGE] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_DESAGE] [varchar] (35) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_RECNO] [numeric](12, 0) NULL ,
	[PRV_VALUTA] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_CAMBIO] [numeric](19, 10) NULL ,
	[PRV_NPART] [numeric](12, 0) NULL ,
	[PRV_TIPFAT] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_TMOV] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_CODPAG] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_DESPAG] [varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_DTSCAD] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_LIQUID] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_ANOMAX] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_DTLIQU] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_STORIC] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_MESE] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_NONMAT] [numeric](19, 3) NULL ,
	[PRV_MATURA] [numeric](19, 3) NULL ,
	[PRV_TOTLIQ] [numeric](19, 3) NULL ,
	[PRV_PNONMA] [numeric](19, 3) NULL ,
	[PRV_PMATUR] [numeric](19, 3) NULL ,
	[PRV_PTOTLI] [numeric](19, 3) NULL ,
	[PRV_NONMOD] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[PRV_DISLIQ] [numeric](12, 0) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[su_prv_an] WITH NOCHECK ADD 
	CONSTRAINT [PK_su_prv_an] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[su_prv_an] WITH NOCHECK ADD 
	CONSTRAINT [DF_su_prv_an_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_su_prv_an_PRV_CODSOC] DEFAULT ('') FOR [PRV_CODSOC],
	CONSTRAINT [DF_su_prv_an_PRV_ANNO] DEFAULT ('') FOR [PRV_ANNO],
	CONSTRAINT [DF_su_prv_an_PRV_CODCLI] DEFAULT ('') FOR [PRV_CODCLI],
	CONSTRAINT [DF_su_prv_an_PRV_RAGSOC] DEFAULT ('') FOR [PRV_RAGSOC],
	CONSTRAINT [DF_su_prv_an_PRV_DATFAT] DEFAULT ('') FOR [PRV_DATFAT],
	CONSTRAINT [DF_su_prv_an_PRV_NUMFAT] DEFAULT ('') FOR [PRV_NUMFAT],
	CONSTRAINT [DF_su_prv_an_PRV_TIPODO] DEFAULT ('') FOR [PRV_TIPODO],
	CONSTRAINT [DF_su_prv_an_PRV_IMPONI] DEFAULT (0) FOR [PRV_IMPONI],
	CONSTRAINT [DF_su_prv_an_PRV_PERPRO] DEFAULT (0) FOR [PRV_PERPRO],
	CONSTRAINT [DF_su_prv_an_PRV_TOTPRO] DEFAULT (0) FOR [PRV_TOTPRO],
	CONSTRAINT [DF_su_prv_an_PRV_CODAGE] DEFAULT ('') FOR [PRV_CODAGE],
	CONSTRAINT [DF_su_prv_an_PRV_DESAGE] DEFAULT ('') FOR [PRV_DESAGE],
	CONSTRAINT [DF_su_prv_an_PRV_RECNO] DEFAULT (0) FOR [PRV_RECNO],
	CONSTRAINT [DF_su_prv_an_PRV_VALUTA] DEFAULT ('') FOR [PRV_VALUTA],
	CONSTRAINT [DF_su_prv_an_PRV_CAMBIO] DEFAULT (0) FOR [PRV_CAMBIO],
	CONSTRAINT [DF_su_prv_an_PRV_NPART] DEFAULT (0) FOR [PRV_NPART],
	CONSTRAINT [DF_su_prv_an_PRV_TIPFAT] DEFAULT ('') FOR [PRV_TIPFAT],
	CONSTRAINT [DF_su_prv_an_PRV_TMOV] DEFAULT ('') FOR [PRV_TMOV],
	CONSTRAINT [DF_su_prv_an_PRV_CODPAG] DEFAULT ('') FOR [PRV_CODPAG],
	CONSTRAINT [DF_su_prv_an_PRV_DESPAG] DEFAULT ('') FOR [PRV_DESPAG],
	CONSTRAINT [DF_su_prv_an_PRV_DTSCAD] DEFAULT ('') FOR [PRV_DTSCAD],
	CONSTRAINT [DF_su_prv_an_PRV_LIQUID] DEFAULT ('') FOR [PRV_LIQUID],
	CONSTRAINT [DF_su_prv_an_PRV_ANOMAX] DEFAULT ('') FOR [PRV_ANOMAX],
	CONSTRAINT [DF_su_prv_an_PRV_DTLIQU] DEFAULT ('') FOR [PRV_DTLIQU],
	CONSTRAINT [DF_su_prv_an_PRV_STORIC] DEFAULT ('') FOR [PRV_STORIC],
	CONSTRAINT [DF_su_prv_an_PRV_MESE] DEFAULT ('') FOR [PRV_MESE],
	CONSTRAINT [DF_su_prv_an_PRV_NONMAT] DEFAULT (0) FOR [PRV_NONMAT],
	CONSTRAINT [DF_su_prv_an_PRV_MATURA] DEFAULT (0) FOR [PRV_MATURA],
	CONSTRAINT [DF_su_prv_an_PRV_TOTLIQ] DEFAULT (0) FOR [PRV_TOTLIQ],
	CONSTRAINT [DF_su_prv_an_PRV_PNONMA] DEFAULT (0) FOR [PRV_PNONMA],
	CONSTRAINT [DF_su_prv_an_PRV_PMATUR] DEFAULT (0) FOR [PRV_PMATUR],
	CONSTRAINT [DF_su_prv_an_PRV_PTOTLI] DEFAULT (0) FOR [PRV_PTOTLI],
	CONSTRAINT [DF_su_prv_an_PRV_NONMOD] DEFAULT ('') FOR [PRV_NONMOD],
	CONSTRAINT [DF_su_prv_an_PRV_DISLIQ] DEFAULT (0) FOR [PRV_DISLIQ]
GO
