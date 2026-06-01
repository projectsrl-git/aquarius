if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_ORD_DG]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_ORD_DG]
GO
 
CREATE TABLE [dbo].[U_ORD_DG] (
	[id_unique]  uniqueidentifier ROWGUIDCOL  NOT NULL ,
	[DAGGANCIO] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CODSYS] [varchar] (10) COLLATE Latin1_General_CI_AS NULL ,
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NULL ,
	[SERIAL] [varchar] (20) COLLATE Latin1_General_CI_AS NULL 
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_ORD_DG] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_ORD_DG] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO

ALTER TABLE [dbo].[U_ORD_DG] WITH NOCHECK ADD 
	CONSTRAINT [DF_U_ORD_DG_id_unique] DEFAULT (newid()) FOR [id_unique],
	CONSTRAINT [DF_U_ORD_DG_DAGGANCIO] DEFAULT ('') FOR [DAGGANCIO],
	CONSTRAINT [DF_U_ORD_DG_CODSYS] DEFAULT ('') FOR [CODSYS],
	CONSTRAINT [DF_U_ORD_DG_CODART] DEFAULT ('') FOR [CODART],
	CONSTRAINT [DF_U_ORD_DG_SERIAL] DEFAULT ('') FOR [SERIAL]
GO

