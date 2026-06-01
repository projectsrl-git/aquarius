if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_amm_ad]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_amm_ad]
GO
 
CREATE TABLE [dbo].[u_amm_ad] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[AMD_CODCES] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[AMD_TIPDOC] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[AMD_NUMDOC] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[AMD_DATDOC] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[AMD_VALORE] [numeric] (13,2) NULL ,
	[AMD_SEQUEN] [numeric] (5,0) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[u_amm_ad] WITH NOCHECK ADD 
	CONSTRAINT [PK_u_amm_ad] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[u_amm_ad] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_amm_ad_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_amm_ad_AMD_CODCES] DEFAULT ('') FOR [AMD_CODCES],
	CONSTRAINT [DF_u_amm_ad_AMD_TIPDOC] DEFAULT ('') FOR [AMD_TIPDOC],
	CONSTRAINT [DF_u_amm_ad_AMD_NUMDOC] DEFAULT ('') FOR [AMD_NUMDOC],
	CONSTRAINT [DF_u_amm_ad_AMD_DATDOC] DEFAULT ('') FOR [AMD_DATDOC],
	CONSTRAINT [DF_u_amm_ad_AMD_VALORE] DEFAULT (0) FOR [AMD_VALORE],
	CONSTRAINT [DF_u_amm_ad_AMD_SEQUEN] DEFAULT (0) FOR [AMD_SEQUEN]
GO
