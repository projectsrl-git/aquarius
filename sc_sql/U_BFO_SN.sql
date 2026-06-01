if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_BFO_SN]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_BFO_SN]
GO
 
CREATE TABLE [dbo].[U_BFO_SN] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[DAGGANCIO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CODSYS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[SERIAL] [varchar] (20) COLLATE Latin1_General_CI_AS NULL ,
	[QUANTI] [numeric] (12,2) NULL
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_BFO_SN] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_BFO_SN] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_BFO_SN] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_BFO_SN_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_BFO_SN_DAGGANCIO] DEFAULT ('') FOR [DAGGANCIO],
	CONSTRAINT [DF_U_BFO_SN_CODSYS] DEFAULT ('') FOR [CODSYS],
	CONSTRAINT [DF_U_BFO_SN_CODART] DEFAULT ('') FOR [CODART],
	CONSTRAINT [DF_U_BFO_SN_SERIAL] DEFAULT ('') FOR [SERIAL],
	CONSTRAINT [DF_U_BFO_SN_QUANTI] DEFAULT (0) FOR [QUANTI]
GO

