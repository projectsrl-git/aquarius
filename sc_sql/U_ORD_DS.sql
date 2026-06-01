if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_ORD_DS]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_ORD_DS]
GO

CREATE TABLE [dbo].[U_ORD_DS] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_U_ORD_DS_id_unique] DEFAULT (newid()),
	[DAGGANCIO] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_DS_DAGGANCIO] DEFAULT (''),
	[CODSYS] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_DS_CODSYS] DEFAULT (''),
	[PADRE] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_DS_PADRE] DEFAULT (''),
	[COMP] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_DS_COMP] DEFAULT (''),
	[ARTSOS] [varchar] (30) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ORD_DS_ARTSOS] DEFAULT (''),
	[QTADIS] [numeric] (19,6) NOT NULL CONSTRAINT [DF_U_ORD_DS_QTADIS] DEFAULT (0)
) ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_ORD_DS] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_ORD_DS] PRIMARY KEY  CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
