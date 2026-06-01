if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[PIANOP_DD]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[PIANOP_DD]
GO
 


CREATE TABLE [dbo].[PIANOP_DD] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[daggancio] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[cosatratta] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[gradoimpor] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[formapagam] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[tipocontra] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[codacq] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[pripaga] [varchar] (4) COLLATE Latin1_General_CI_AS NULL ,
	[codfor] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[ragsoc] [varchar] (40) COLLATE Latin1_General_CI_AS NULL ,
	[npart] [numeric] (16,0) NULL ,
	[dtscad] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[nsaldo] [numeric] (20,3) NULL ,
	[banca] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[abi] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[cab] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[cin] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[contocorr] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[contocont] [varchar] (13) COLLATE Latin1_General_CI_AS NULL ,
	[quantavalu] [numeric] (20,3) NULL ,
	[quandovalu] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[banca_part] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[abi_part] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[cab_part] [varchar] (5) COLLATE Latin1_General_CI_AS NULL ,
	[cin_part] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[contocorr_part] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[previs] [varchar] (1) COLLATE Latin1_General_CI_AS NULL ,
	[estrai] [bit] NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[PIANOP_DD] WITH NOCHECK ADD 
	CONSTRAINT [PK_PIANOP_DD] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[PIANOP_DD] WITH NOCHECK ADD 
	CONSTRAINT [DF_PIANOP_DD_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_PIANOP_DD_daggancio] DEFAULT ('') FOR [DAGGANCIO],
	CONSTRAINT [DF_PIANOP_DD_cosatratta] DEFAULT ('') FOR [cosatratta],
	CONSTRAINT [DF_PIANOP_DD_gradoimpor] DEFAULT ('') FOR [gradoimpor],
	CONSTRAINT [DF_PIANOP_DD_formapagam] DEFAULT ('') FOR [formapagam],
	CONSTRAINT [DF_PIANOP_DD_tipocontra] DEFAULT ('') FOR [tipocontra],
	CONSTRAINT [DF_PIANOP_DD_codacq] DEFAULT ('') FOR [codacq],
	CONSTRAINT [DF_PIANOP_DD_pripaga] DEFAULT ('') FOR [pripaga],
	CONSTRAINT [DF_PIANOP_DD_codfor] DEFAULT ('') FOR [codfor],
	CONSTRAINT [DF_PIANOP_DD_ragsoc] DEFAULT ('') FOR [ragsoc],
	CONSTRAINT [DF_PIANOP_DD_npart] DEFAULT (0) FOR [npart],
	CONSTRAINT [DF_PIANOP_DD_dtscad] DEFAULT ('') FOR [dtscad],
	CONSTRAINT [DF_PIANOP_DD_nsaldo] DEFAULT (0) FOR [nsaldo],
	CONSTRAINT [DF_PIANOP_DD_banca] DEFAULT ('') FOR [banca],
	CONSTRAINT [DF_PIANOP_DD_abi] DEFAULT ('') FOR [abi],
	CONSTRAINT [DF_PIANOP_DD_cab] DEFAULT ('') FOR [cab],
	CONSTRAINT [DF_PIANOP_DD_cin] DEFAULT ('') FOR [cin],
	CONSTRAINT [DF_PIANOP_DD_contocorr] DEFAULT ('') FOR [contocorr],
	CONSTRAINT [DF_PIANOP_DD_banca_part] DEFAULT ('') FOR [banca_part],
	CONSTRAINT [DF_PIANOP_DD_abi_part] DEFAULT ('') FOR [abi_part],
	CONSTRAINT [DF_PIANOP_DD_cab_part] DEFAULT ('') FOR [cab_part],
	CONSTRAINT [DF_PIANOP_DD_cin_part] DEFAULT ('') FOR [cin_part],
	CONSTRAINT [DF_PIANOP_DD_contocorr_part] DEFAULT ('') FOR [contocorr_part],
	CONSTRAINT [DF_PIANOP_DD_contocont] DEFAULT ('') FOR [contocont],
	CONSTRAINT [DF_PIANOP_DD_quantavalu] DEFAULT (0) FOR [quantavalu],
	CONSTRAINT [DF_PIANOP_DD_quandovalu] DEFAULT ('') FOR [quandovalu],
	CONSTRAINT [DF_PIANOP_DD_previs] DEFAULT ('') FOR [previs],
	CONSTRAINT [DF_PIANOP_DD_estrai] DEFAULT (0) FOR [estrai]
GO

