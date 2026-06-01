if exists (select * from dbo.sysobjects where id = object_id(N'[dbo].[U_ART_GA]') and OBJECTPROPERTY(id, N'IsUserTable') = 1)
	drop table [dbo].[U_ART_GA]
GO

CREATE TABLE [dbo].[U_ART_GA] (
	[id_unique]  uniqueidentifier ROWGUIDCOL NOT NULL CONSTRAINT [DF_U_ART_GA_id_unique] DEFAULT (newid()),
	[CODART] [varchar] (16) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ART_GA_CODART] DEFAULT (''),
	[NMESI] [numeric] (2,0) NOT NULL CONSTRAINT [DF_U_ART_GA_NMESI] DEFAULT (0),
	[DTVAL] [varchar] (10) COLLATE Latin1_General_CI_AS NOT NULL CONSTRAINT [DF_U_ART_GA_DTVAL] DEFAULT (''),
	[NOTE] [text] COLLATE Latin1_General_CI_AS NULL CONSTRAINT [DF_U_ART_GA_NOTE] DEFAULT ('')
) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

ALTER TABLE [dbo].[U_ART_GA] WITH NOCHECK ADD 
	CONSTRAINT [PK_U_ART_GA] PRIMARY KEY CLUSTERED 
	(
		[id_unique]
	)  ON [PRIMARY] 
GO
