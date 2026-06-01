if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_vva_ch]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_vva_ch]
GO
 
CREATE TABLE [dbo].[u_vva_ch] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[VVA_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[VVA_CODVAL] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[VVA_NOMVAL] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[VVA_DATA] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[VVA_CHANGE] [numeric] (15,10) NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[u_vva_ch] WITH NOCHECK ADD 
	CONSTRAINT [PK_u_vva_ch] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[u_vva_ch] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_vva_ch_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_vva_ch_VVA_CODSOC] DEFAULT ('') FOR [VVA_CODSOC],
	CONSTRAINT [DF_u_vva_ch_VVA_CODVAL] DEFAULT ('') FOR [VVA_CODVAL],
	CONSTRAINT [DF_u_vva_ch_VVA_NOMVAL] DEFAULT ('') FOR [VVA_NOMVAL],
	CONSTRAINT [DF_u_vva_ch_VVA_DATA] DEFAULT ('') FOR [VVA_DATA],
	CONSTRAINT [DF_u_vva_ch_VVA_CHANGE] DEFAULT (0) FOR [VVA_CHANGE]
GO

