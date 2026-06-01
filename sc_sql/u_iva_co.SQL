if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[u_iva_co]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
drop table [dbo].[u_iva_co]
GO
 
CREATE TABLE [dbo].[u_iva_co] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[COR_CODSOC] [varchar] (2) COLLATE Latin1_General_CI_AS NULL ,
	[COR_CODPDV] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[COR_ANNO] [varchar] (4) COLLATE Latin1_General_CI_AS NULL ,
	[COR_DATA] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[COR_TOTALE] [numeric] (15,2) NULL ,
	[COR_CDIVA1] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[COR_PEIVA1] [numeric] (2,0) NULL ,
	[COR_VAIVA] [numeric] (15,2) NULL ,
	[COR_CDIVA2] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[COR_PEIVA2] [numeric] (2,0) NULL ,
	[COR_VAIVA2] [numeric] (15,2) NULL ,
	[COR_CDIVA3] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[COR_PEIVA3] [numeric] (2,0) NULL ,
	[COR_VAIVA3] [numeric] (15,2) NULL ,
	[COR_CDIVA4] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[COR_PEIVA4] [numeric] (2,0) NULL ,
	[COR_VAIVA4] [numeric] (15,2) NULL ,
	[COR_CDIVA5] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[COR_PEIVA5] [numeric] (2,0) NULL ,
	[COR_VAIVA5] [numeric] (15,2) NULL ,
	[COR_CDIVAN] [varchar] (3) COLLATE Latin1_General_CI_AS NULL ,
	[COR_DEIVAN] [varchar] (30) COLLATE Latin1_General_CI_AS NULL ,
	[COR_VAIVAN] [numeric] (15,2) NULL ,
	[COR_FATNDA] [varchar] (6) COLLATE Latin1_General_CI_AS NULL ,
	[COR_FATNAL] [varchar] (6) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[u_iva_co] WITH NOCHECK ADD 
	CONSTRAINT [PK_u_iva_co] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[u_iva_co] WITH NOCHECK ADD 
	CONSTRAINT [DF_u_iva_co_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_u_iva_co_COR_CODSOC] DEFAULT ('') FOR [COR_CODSOC],
	CONSTRAINT [DF_u_iva_co_COR_CODPDV] DEFAULT ('') FOR [COR_CODPDV],
	CONSTRAINT [DF_u_iva_co_COR_ANNO] DEFAULT ('') FOR [COR_ANNO],
	CONSTRAINT [DF_u_iva_co_COR_DATA] DEFAULT ('') FOR [COR_DATA],
	CONSTRAINT [DF_u_iva_co_COR_TOTALE] DEFAULT (0) FOR [COR_TOTALE],
	CONSTRAINT [DF_u_iva_co_COR_CDIVA1] DEFAULT ('') FOR [COR_CDIVA1],
	CONSTRAINT [DF_u_iva_co_COR_PEIVA1] DEFAULT (0) FOR [COR_PEIVA1],
	CONSTRAINT [DF_u_iva_co_COR_VAIVA] DEFAULT (0) FOR [COR_VAIVA],
	CONSTRAINT [DF_u_iva_co_COR_CDIVA2] DEFAULT ('') FOR [COR_CDIVA2],
	CONSTRAINT [DF_u_iva_co_COR_PEIVA2] DEFAULT (0) FOR [COR_PEIVA2],
	CONSTRAINT [DF_u_iva_co_COR_VAIVA2] DEFAULT (0) FOR [COR_VAIVA2],
	CONSTRAINT [DF_u_iva_co_COR_CDIVA3] DEFAULT ('') FOR [COR_CDIVA3],
	CONSTRAINT [DF_u_iva_co_COR_PEIVA3] DEFAULT (0) FOR [COR_PEIVA3],
	CONSTRAINT [DF_u_iva_co_COR_VAIVA3] DEFAULT (0) FOR [COR_VAIVA3],
	CONSTRAINT [DF_u_iva_co_COR_CDIVA4] DEFAULT ('') FOR [COR_CDIVA4],
	CONSTRAINT [DF_u_iva_co_COR_PEIVA4] DEFAULT (0) FOR [COR_PEIVA4],
	CONSTRAINT [DF_u_iva_co_COR_VAIVA4] DEFAULT (0) FOR [COR_VAIVA4],
	CONSTRAINT [DF_u_iva_co_COR_CDIVA5] DEFAULT ('') FOR [COR_CDIVA5],
	CONSTRAINT [DF_u_iva_co_COR_PEIVA5] DEFAULT (0) FOR [COR_PEIVA5],
	CONSTRAINT [DF_u_iva_co_COR_VAIVA5] DEFAULT (0) FOR [COR_VAIVA5],
	CONSTRAINT [DF_u_iva_co_COR_CDIVAN] DEFAULT ('') FOR [COR_CDIVAN],
	CONSTRAINT [DF_u_iva_co_COR_DEIVAN] DEFAULT ('') FOR [COR_DEIVAN],
	CONSTRAINT [DF_u_iva_co_COR_VAIVAN] DEFAULT (0) FOR [COR_VAIVAN],
	CONSTRAINT [DF_u_iva_co_COR_FATNDA] DEFAULT ('') FOR [COR_FATNDA],
	CONSTRAINT [DF_u_iva_co_COR_FATNAL] DEFAULT ('') FOR [COR_FATNAL]
GO

