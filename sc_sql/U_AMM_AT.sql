if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_amm_at]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_amm_at]
GO
 
CREATE TABLE [dbo].[u_amm_at] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[AMM_CODCES] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_DESCRI] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_CODCAT] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_TIPCAT] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_FLGUSO] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_PERSPE] [numeric] (6,2) NULL ,
	[AMM_FLGNEW] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_DATUTI] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_QTEAMM] [numeric] (5,0) NULL ,
	[AMM_PERBAS] [numeric] (6,2) NULL ,
	[AMM_PERANT] [numeric] (6,2) NULL ,
	[AMM_PERACC] [numeric] (6,2) NULL ,
	[AMM_MATRIC] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_NOTE] [text] COLLATE Latin1_General_CI_AS NULL ,
	[AMM_CONFON] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_CONCES] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_VALSTO] [numeric] (13,2) NULL ,
	[AMM_VALRES] [numeric] (13,2) NULL ,
	[AMM_TIPCES] [numeric] (1,0) NULL ,
	[AMM_DATCES] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_VALCES] [numeric] (13,2) NULL ,
	[AMM_PLUMIN] [numeric] (13,2) NULL
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[u_amm_at] WITH NOCHECK ADD 
	CONSTRAINT [PK_u_amm_at] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[u_amm_at] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_amm_at_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_amm_at_AMM_CODCES] DEFAULT ('') FOR [AMM_CODCES],
	CONSTRAINT [DF_u_amm_at_AMM_DESCRI] DEFAULT ('') FOR [AMM_DESCRI],
	CONSTRAINT [DF_u_amm_at_AMM_CODCAT] DEFAULT ('') FOR [AMM_CODCAT],
	CONSTRAINT [DF_u_amm_at_AMM_TIPCAT] DEFAULT ('') FOR [AMM_TIPCAT],
	CONSTRAINT [DF_u_amm_at_AMM_FLGUSO] DEFAULT ('') FOR [AMM_FLGUSO],
	CONSTRAINT [DF_u_amm_at_AMM_PERSPE] DEFAULT (0) FOR [AMM_PERSPE],
	CONSTRAINT [DF_u_amm_at_AMM_FLGNEW] DEFAULT ('') FOR [AMM_FLGNEW],
	CONSTRAINT [DF_u_amm_at_AMM_DATUTI] DEFAULT ('') FOR [AMM_DATUTI],
	CONSTRAINT [DF_u_amm_at_AMM_QTEAMM] DEFAULT (0) FOR [AMM_QTEAMM],
	CONSTRAINT [DF_u_amm_at_AMM_PERBAS] DEFAULT (0) FOR [AMM_PERBAS],
	CONSTRAINT [DF_u_amm_at_AMM_PERANT] DEFAULT (0) FOR [AMM_PERANT],
	CONSTRAINT [DF_u_amm_at_AMM_PERACC] DEFAULT (0) FOR [AMM_PERACC],
	CONSTRAINT [DF_u_amm_at_AMM_MATRIC] DEFAULT ('') FOR [AMM_MATRIC],
	CONSTRAINT [DF_u_amm_at_AMM_NOTE] DEFAULT ('') FOR [AMM_NOTE],
	CONSTRAINT [DF_u_amm_at_AMM_CONFON] DEFAULT ('') FOR [AMM_CONFON],
	CONSTRAINT [DF_u_amm_at_AMM_CONCES] DEFAULT ('') FOR [AMM_CONCES],
	CONSTRAINT [DF_u_amm_at_AMM_VALSTO] DEFAULT (0) FOR [AMM_VALSTO],
	CONSTRAINT [DF_u_amm_at_AMM_VALRES] DEFAULT (0) FOR [AMM_VALRES],
	CONSTRAINT [DF_u_amm_at_AMM_TIPCES] DEFAULT (0) FOR [AMM_TIPCES],
	CONSTRAINT [DF_u_amm_at_AMM_DATCES] DEFAULT ('') FOR [AMM_DATCES],
	CONSTRAINT [DF_u_amm_at_AMM_VALCES] DEFAULT (0) FOR [AMM_VALCES],
	CONSTRAINT [DF_u_amm_at_AMM_PLUMIN] DEFAULT (0) FOR [AMM_PLUMIN]
GO

