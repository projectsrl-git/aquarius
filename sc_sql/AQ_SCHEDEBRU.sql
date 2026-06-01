

/****** Object:  Table [dbo].[AQ_SCHEDEBRU]   ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[AQ_SCHEDEBRU]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[AQ_SCHEDEBRU]
GO  


CREATE TABLE [dbo].[AQ_SCHEDEBRU](
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL CONSTRAINT [DF_AQ_SCHEDEBRU_id_unique] DEFAULT (newid()),
	[ID_PMKEY]        [varchar](10) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_ID_PMKEY] DEFAULT (''),            
	[CCODSCHE]        [varchar](20) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_CCODSCHE] DEFAULT (''),
	[ID_RIGO]         [varchar](5) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_ID_RIGO] DEFAULT (''), 
	[ID_BRU]          [varchar](5) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_ID_BRU] DEFAULT (''), 
	[CDITTABRU]       [varchar](50) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_CDITTABRU] DEFAULT (''), 
	[CCODCLI]         [varchar](10) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_CCODCLI] DEFAULT (''), 
	[CMODBRU]         [varchar](25) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_CMODBRU] DEFAULT (''), 
	[CMATBRU]         [varchar](40) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_CMATBRU] DEFAULT (''),
	[COD_PRODUT]      [varchar](40) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_COD_PRODUT] DEFAULT (''), 
	[CUGELLO]         [varchar](12) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_CUGELLO] DEFAULT (''), 
	[CCALCAL]         [Numeric](10) NULL, 
	[CNOTE1]          [varchar](50) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_CNOTE1] DEFAULT (''),
	[CNOTE2]          [varchar](50) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_CNOTE2] DEFAULT (''),
	[CNOTE3]          [varchar](50) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_CNOTE3] DEFAULT (''),
	[TIPO_BRU]        [varchar](3) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_TIPO_BRU] DEFAULT (''),
	[POT_MIN]         [Numeric](9,2) NULL, 
	[POT_MAX]         [Numeric](9,2) NULL, 
	[EMULSIONE]       [bit] NULL,
	[PROGRESSIVO]     [bit] NULL,
	[DT_INSTALL]      [varchar](10) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_DT_INSTALL] DEFAULT (''), 
	[CFLAGGARZ]       [bit] NULL,
	[CDAINGARNZ]      [varchar](10) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_CDAINGARNZ] DEFAULT (''), 
	[CDAFIGARNZ]      [varchar](10) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_CDAFIGARNZ] DEFAULT (''), 
	[DT_DISMESS]      [varchar](10) NULL CONSTRAINT [DF_AQ_SCHEDEBRU_DT_DISMESS] DEFAULT (''), 
	[DISMESSA]        [bit] NULL,
	[POT_MIN_MC]      [Numeric](9,2) NULL,
	[POT_MAX_MC]      [Numeric](9,2) NULL,
	[POT_REAL_MC]     [Numeric](9,2) NULL,
	[POT_REAL_KG]     [Numeric](9,2) NULL,
	[UGELLO_1]        [Numeric](9,2) NULL,
	[UGELLO_2]        [Numeric](9,2) NULL,
	[PRESS_POMP]      [Numeric](9,2) NULL,
	[CONSU_GAS]       [Numeric](9,2) NULL,
	[POT_MIN_KW]      [Numeric](9,2) NULL,
	[POT_MAX_KW]      [Numeric](9,2) NULL,
	[POT_REAL_KW]     [Numeric](9,2) NULL,
	[POT_MIN_GASS_KW] [Numeric](9,2) NULL,
	[POT_MAX_GASS_KW] [Numeric](9,2) NULL,
	[POT_REAL_GASS_KW] [Numeric](9,2) NULL,
	[ANNOCOSTRU]       [Numeric](4) NULL, 
	[A_NORMA]          [bit] NULL
) 

ALTER TABLE [dbo].[AQ_SCHEDEBRU] WITH NOCHECK ADD 
	CONSTRAINT [PK_AQ_SCHEDEBRU] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO


