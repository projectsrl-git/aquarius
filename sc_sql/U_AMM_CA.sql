if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_amm_ca]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_amm_ca]
GO
 
CREATE TABLE [dbo].[u_amm_ca] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[AMM_CODAMM] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_DESCR1] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_DESCR2] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_DESCR3] [varchar] (50) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_PERAMM] [numeric] (6,2) NULL ,
	[AMM_CONTAB] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[AMM_CONPAR] [varchar] (13) COLLATE Latin1_General_CI_AS NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[u_amm_ca] WITH NOCHECK ADD 
	CONSTRAINT [PK_u_amm_ca] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[u_amm_ca] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_amm_ca_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_amm_ca_AMM_CODAMM] DEFAULT ('') FOR [AMM_CODAMM],
	CONSTRAINT [DF_u_amm_ca_AMM_DESCR1] DEFAULT ('') FOR [AMM_DESCR1],
	CONSTRAINT [DF_u_amm_ca_AMM_DESCR2] DEFAULT ('') FOR [AMM_DESCR2],
	CONSTRAINT [DF_u_amm_ca_AMM_DESCR3] DEFAULT ('') FOR [AMM_DESCR3],
	CONSTRAINT [DF_u_amm_ca_AMM_PERAMM] DEFAULT (0) FOR [AMM_PERAMM],
	CONSTRAINT [DF_u_amm_ca_AMM_CONTAB] DEFAULT ('') FOR [AMM_CONTAB],
	CONSTRAINT [DF_u_amm_ca_AMM_CONPAR] DEFAULT ('') FOR [AMM_CONPAR]
GO

